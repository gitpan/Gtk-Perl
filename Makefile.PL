use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use Cwd;
require 'Depends.pm';
#import ExtUtils::Depends;

#print "Configuring Perl/Gtk+... Note that additional packages can be added\n";
#print "by giving switches to Makefile.PL, including:\n\n";

foreach (<*/pkg*.pl>) {
	next unless m!(.*)/pkg(.*)\.pl!;
	my ($name) = lc $1.$2;
	next if $name eq "gtk";
	$package{$name} = $_;
}

foreach (sort keys %package) {
#	print "\t--with-$_\n";
}

#print "\nWe are going to guess some packages, if we guess wrong just use\n";
#print qq{the flags above but change "with" to "without".\n\n};

#print "Unfortunately, these packages aren't terribly smart, and you may need\n";
#print "to tweak the resultant Makefile or the */pkg*.pl files to properly\n";
#print "locate the files needed for a package.\n\n";

# Guess packages
print "You may also use '--lazy-load', which will reduce initial memory usage\n";
print "and loading time, at the cost of some internal glitches.\n\n";

%conf = (
	gdkimlib => "imlib-config",
	gnome => "gnome-config",
);

for(keys %conf) {
	my $v;
	if( ($v = qx($conf{$_} --version)) =~ /[0-9]/ ) {
		# no default submodule compilation
		#print "Guessing $_ - got version $v from $conf{$_}\n";
		#$defaultpack{$_} = 1;
	}
}

@defines = ();

# Starting with Perl 5.005 all embed variables got PL_ prefix
# so, to avoid errorswith sv_undef, we enable polluting name space..
if ($] > 5.004) {
	push @defines, "-DPERL_POLLUTE";
}

sub estr { # Take out blanks
	local $_ = $_[0];
	s/\s+/ /g;
	return $_;
}

# Search for a gnomeConf.sh file (waiting for gnome-config) ...
# One can also 'source' in the shell the proper gnomeConf.sh file
# before running perl Makefile.PL.
if(qx{gnome-config}) {
	print "gnome-config found\n";
	$gnome_version = qx{gnome-config --version};
	$gnome_version =~ s/\S+\s//;
	print "gnome version = $gnome_version\n";
	if($gnome_version =~ /0\.99/ || $gnome_version =~ /^1\./) {
		push @defines, "-DNEW_GNOME";
		print "new gnome found\n";
	}
	$ENV{GNOME_INCLUDEDIR}=estr(qx{gnome-config --cflags gnome});
	$ENV{GNOME_LIBDIR}=estr(qx{gnome-config --libdir});
	$ENV{GNOMEUI_LIBS}=estr(qx{gnome-config --libs gnomeui});
	$ENV{GTKXMHTML_LIBS}=estr(qx{gnome-config --libs gtkxmhtml});
} else {
	print "gnome-config not found!\n";
	print "If you did not enable any gnome options, ";
	print "you can ignore the above message\n";
}

$Lazy = grep($_ eq "--lazy-load", @ARGV);
@ARGV = grep($_ ne "--lazy-load", @ARGV);

$Directory = "";

if ($Lazy) {
	print "\n\nLazy loading enabled -- if anything breaks, please try disabling this.\n";
	push @defines, "-DLAZY_LOAD";
} elsif ($] < 5.004) {
	push @defines, "-DNEED_DERIVED";
}


$libs = `gtk-config --libs`;
$libs = "-L/usr/X11R6/lib -lgtk -lgdk -lglib -lX11 -lXext" if not defined $libs;

$inc = `gtk-config --cflags`;

$libs =~ s/\s+/ /g;
$inc =~ s/\s+/ /g;

$gtk_version = gtk_version();

if ($gtk_version =~ /^(\d+)\.(\d+)\.(\d+)/) {
	$gtk_major = $1;
	$gtk_minor = $2;
	$gtk_micro = $3;
	
	if ($gtk_major < 1 or ($gtk_major == 1 and $gtk_minor == 0 and $gtk_micro == 0)) {
		push @defines, "-DGTK_MAJOR_VERSION=$gtk_major",
						"-DGTK_MINOR_VERSION=$gtk_minor",
						"-DGTK_MICRO_VERSION=$gtk_micro";
	}
	
} else {
	$gtk_major = 0;
	$gtk_minor = 0;
	$gtk_micro = 0;
}

$gtk_hverstr = sprintf("0x%02x%02x%02x", $gtk_major, $gtk_minor, $gtk_micro);
$gtk_hver = hex($gtk_hverstr);

push @defines, "-DGTK_HVER=$gtk_hverstr";

if (not defined $gtk_version) {
	print "Unable to find  Gtk version...\n";
} else {
	print "Located Gtk version $gtk_version...\n";
}

mkdir("build", 0777);

$typemap = [cwd() . "/build/GtkTypemap"];
$object = 'build/GtkDefs.o build/PerlGtkExt.o';
$pm = {
	'build/GtkTypes.pm' => '$(INST_ARCHLIBDIR)/Gtk/Types.pm',
	'build/GtkKeysyms.pm' => '$(INST_ARCHLIBDIR)/Gtk/Keysyms.pm'
};

@clean = qw( build/perl-gtk-ref.pod build/perl-gtk-ds.pod
	build/GtkTypes.pm build/GtkKeysyms.pm build/GtkTypemap build/GtkDefs.c build/GtkDefs.h build/Objects.xpl build/boxed.xsh build/extension.xsh build/objects.xsh 
			build/PerlGtkExt.c build/PerlGtkExt.h build/PerlGtkInt.h build/IFiles.pm */*.o */*/*.o);

%xs = ();
%typemaps = ();
%defs = ();
%boot = ();


{
	local($Directory) = "Gtk/";
	do "Gtk/pkg.pl";
	$inc .= " -I./Gtk";
}

# build the keysyms mapping
{
	my ($incfile) = `gtk-config --prefix`;
	chomp($incfile);
	$incfile .= "/include/gdk/gdkkeysyms.h";

	open(OUT, '>build/GtkKeysyms.pm') || die "Cannot open build/GtkKeysyms.pm: $!";
	print OUT "# DO NOT EDIT!\n";
	print OUT "# This file was built by Gtk's Makefile.PL from $incfile.\n";
	print OUT "\npackage Gtk::Keysyms;\n\n";
	print OUT "%Gtk::Keysyms = (\n";
	if (open(IN, $incfile)) {
		while(<IN>) {
			print OUT "\t'$1'\t=>\t$2,\n" if /^\s*#\s*define\s+GDK_([a-zA-Z0-9_]+)\s+(\w+)$/;
		}
		close(IN);
	}
	print OUT ");\n\n1;\n";
	close(OUT);
}

sub include_package {
	my($p) = @_;
	if (exists $package{$p}) {
		local($Directory);
		my($f) = $package{$p};
		if ($f =~ m!^(.*/)!) {
			$Directory = $1;
			$inc .= " -I./$Directory";
		}
		print "Dir = $Directory\n";
		do $f;
	} else {
		die "Unknown package $p\n";
	}
}

foreach (@ARGV) {
	if (/^--with-/) {
		#include_package($');
		$defaultpack{$'} = 1;
	} elsif(/^--without-/) {
		print "Not including package $'\n";
		delete $defaultpack{$'};
	}
}

for(keys %defaultpack) {
	include_package($_);
}

$inc .= " -I./build";

require "tools/gendefs.pl";

print "Invoking gendefs.pl with [",join(", ",sort {$defs{$a} <=> $defs{$b}} keys %defs), "].\n";
print "Please wait, this may take a moment...\n";

add_headers ('<gtk/gtk.h>', '"GtkTypes.h"', '"GdkTypes.h"', '"MiscTypes.h"');

@a = (	'-f', 'Gtk', 
		'-p', 'Gtk=Gtk',
		'-p', 'GdkGL=Gtk::Gdk::GL',
		'-p', 'GdkRgb=Gtk::Gdk::Rgb',
		'-p', 'Gdk=Gtk::Gdk',
		'-p', 'Gnome=Gnome',
		'-p', 'Panel=Gnome::Panel',
		'-m', 'Gtk');
if ($Lazy) {
	push @a, "-L";
}
foreach (sort {$defs{$a} <=> $defs{$b}} keys %defs) {
	push @a, '-d', $_;
}
foreach (sort {$headers{$a} <=> $headers{$b}} keys %headers) {
	push @a, '-i', $_;
}

#system(@a);
#foreach (split(' ', (do 'Objects.xpl'))) {
#	add_xs($_);
#}

add_raw_xs(gendefs::gendefs(@a));

# documentation
gendefs::gen_doc();
system("./tools/gendoc.pl", keys %xs);

$xfiles = {};

foreach (sort {$xs{$a} <=> $xs{$b}} keys %xs) {
	my($xs) = $_;
	s/\.xs$/.c/;
	#s!^.*/!!;
	$xfiles->{$xs} = $_;

	s/\.c$/.o/;
	$object .= " $_";
	
}

foreach (sort {$c{$a} <=> $c{$b}} keys %c) {
	s/\.c$/.o/;
	$object .= " $_";
}

foreach (<*/.xs>, <*/xs/*.xs>) {
	if (not exists $xfiles->{$_}) {
		s/\.xs$/.c/;
		push @clean, $_;
	}
}

open (EXT, ">build/extension.xsh");
print EXT "\n\n# Do not edit this file, as it is automatically generated by Makefile.PL\n\n";
print EXT "BOOT:\n{\n";

foreach (sort {$boot{$a} <=> $boot{$b}} keys %boot) {
	my($b) = $_;
	$b =~ s/::/__/g;
	$b = "boot_$b";
	print EXT "extern void $b(CV *cv);\n";
}
foreach (sort {$boot{$a} <=> $boot{$b}} keys %boot) {
	my($b) = $_;
	$b =~ s/::/__/g;
	$b = "boot_$b";
	print EXT "callXS($b, cv, mark);\n";
}

print EXT "}\n";
close(EXT);

foreach (sort {$typemap{$a} <=> $typemap{$b}} keys %typemap) {
	push @$typemap, cwd() . "/" . $_;
}

use File::Basename;

foreach ( 'build/GtkDefs.h', 'build/PerlGtkExt.h', 'build/PerlGtkInt.h', 'Gtk/ppport.h', 'Gtk/GtkTypes.h', 'Gtk/GdkTypes.h', 'Gtk/MiscTypes.h', 'tools/gendefs.pl', 'tools/genext.pl', 'tools/gendoc.pl') {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/Gtk/Install/' . basename($_);
}

#$archinstall = join(' ', map( "Gtk/Install/$_", @archinstall));

#open(I, ">build/IFiles.pm");
#print I <<'EOT';
##!/usr/bin/perl
#
#package Gtk::Install::Files;
#
#@typemaps = qw(
#EOT
#
#foreach (@$typemap) {
#	my($b) = basename($_);
#	print I "	$b\n";
#	$pm->{$_} = '$(INST_ARCHLIBDIR)/Gtk/Install/' . $b;
#}
#
#print I <<'EOT';
#);
#
#@defs = qw(
#EOT
#
#foreach (sort {$defs{$a} <=> $defs{$b}} keys %defs) {
#	my($b) = basename($_);
#	print I "	$b\n";
#	#$pm->{$_} = '$(INST_ARCHLIBDIR)/Gtk/Install/' . $b;
#}
#
#print I <<'EOT';
#);
#
#@headers = qw(             
#EOT
#
#foreach (sort {$headers{$a} <=> $headers{$b}} keys %headers) {
#	print I "   $_\n";     
#}
#    
#print I <<'EOT';
#);                         
#    
#EOT
#    
#print I "\$libs = '$libs';\n";
#print I "\$inc = '$inc';\n";
#    
#print I <<'EOT';
#
#$CORE = undef;
#foreach (@INC) {
#	if ( -f $_ . "/Gtk/Install/gendefs.pl") {
#		$CORE = $_ . "/Gtk/Install/";
#		last;
#	}
#}
#
#1;
#
#EOT
#
#close(I);

#$pm->{"IFiles.pm"} = '$(INST_ARCHLIBDIR)/Gtk/Install/Files.pm';

$libs =~ s/(^|\s)-[rR]\S+//g;

@libs = split(/\s+/, $libs);
%seenlibs = ();
@revlibs=();
@lflags=();
foreach (@libs) {
	if (/^-l/) {
		unshift(@revlibs, $_);
	} else {
		unshift(@lflags, $_) unless $seenlibs{$_}++;
	}
}
#print "LIBS=@libs\n";
@libs=();
foreach (@revlibs) {
	unshift(@libs, $_) unless $seenlibs{$_}++;
}

#print "REVLIBS=@revlibs\n";
print "LIBS=@lflags @libs\n";
#exit 0;
$libs = "@lflags @libs";

@L = (LIBS => [$libs]);

if (defined $inc and $inc !~ /^\s*$/) {
	@I = (INC => $inc);
} else {
	@I = (); #e.g, INC => -I/usr/other/include
}

$depend = {'build/GtkDefs.c' => 'build/PerlGtkExt.h build/PerlGtkInt.h'};

ExtUtils::Depends::save_config('Gtk', 'build/IFiles.pm', $inc, $libs, $typemap, [keys %defs], [@defines], [keys %headers], $pm);

WriteMakefile(
	'DISTNAME' => 'Gtk-Perl',
    'NAME'	=> 'Gtk',
    'VERSION_FROM'	=> 'Gtk/Gtk.pm',
    'PM' => $pm,
    'TYPEMAPS' => $typemap,
    'XS' => $xfiles,
    'XSOPT' => '-noversioncheck',
    'DEFINE'	=> join(' ',@defines),
    'DIR'	=> '',
    'OBJECT' => $object,
	'XSPROTOARG' => '-noprototypes',
	'clean' => {FILES => join(' ', @clean) },
	'depend' => $depend,
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	@I,
	@L,
);

sub MY::postamble {

'
Makefile: ' . join(' ',
	sort {$defs{$a} <=> $defs{$b}} keys %defs,
	<*/pkg*.pl>
	) . '

build/PerlGtkExt.h build/PerlGtkExt.c build/PerlGtkInt.h: build/GtkDefs.h tools/genext.pl
	$(PERL) tools/genext.pl Gtk

';



}

sub MY::c_o {
	package MY; # so that "SUPER" works right
	my $inherited = shift->SUPER::c_o(@_);
	$inherited =~ s/CCCMD.*$/$&\n\t\@if test -f `basename \$*.o` -a "`basename \$*.o`" != "\$*.o"; then mv `basename \$*.o` \$*.o; fi/m;
    $inherited;
}

sub MY::const_config
{
	package MY;
	my $self = shift;
	my $flags = $self->{'CCCDLFLAGS'};
	$flags =~ s/(-[fK]?\s*)pic\b/${1}PIC/;
	$self->{'CCCDLFLAGS'} = $flags;
	return $self->SUPER::const_config;
}

sub gtk_version {
	my($result);

	$result = `gtk-config --version`;
	chomp $result;
	
	if (not defined $result) {

		unlink("gtkvertmp.out");

		open(T, ">gtkvertmp.c");
		print T <<'EOT';

#include <stdio.h>
#include <gtk/gtk.h>

int main(int argc, char *argv[])
{
	FILE * f = fopen("gtkvertmp.out", "w");
	fprintf(f,"%d.%d.%d\n", gtk_major_version, gtk_minor_version, gtk_micro_version);
	fclose(f);
	return 0;
}

EOT
		close(T);

		use Config;

		$c = "$Config{cc} $Config{ccflags} $inc gtkvertmp.c $Config{ldflags} $libs $Config{libs} -o gtkvertmp";
		system("$c && ./gtkvertmp");

		unlink("gtkvertmp.c");
		unlink("gtkvertmp.o");
		unlink("gtkvertmp");

		open(T, "<gtkvertmp.out");
		$result = <T>;
		chomp $result;
		close(T);

		unlink("gtkvertmp.out");
	}
	
	return $result;
}


$add = 0;
sub add_xs
{
	foreach (@_) { $xs{$Directory . "xs/" .$_} = $add++; }
}

sub add_raw_xs
{
	foreach (@_) { $xs{$_} = $add++; }
}

sub remove_xs
{
	foreach (@_) { delete $xs{$Directory . "xs/". $_}; }
}

sub add_pm
{
	my($k,$v);
	while (($k,$v) = splice(@_, 0, 2)) {
		$k = $Directory . $k;
		$pm->{$k} = $v;
	}
}

sub add_c
{
	foreach (@_) { $c{$Directory . $_} = $add++; }
}

sub remove_c
{
	foreach (@_) { delete $c{$Directory . $_}; }
}

sub add_typemap
{
	foreach (@_) { $typemap{$Directory . $_} = $add++; }
}

sub remove_typemap
{
	foreach (@_) { delete $typemap{$Directory . $_}; }
}

sub add_defs
{
	foreach (@_) { $defs{$Directory . $_} = $add++; }
}

sub remove_defs
{
	foreach (@_) { delete $defs{$Directory . $_}; }
}

sub add_headers
{
	foreach (@_) { $headers{$_} = $add++; }
}

sub remove_headers
{
	foreach (@_) { delete $headers{$_}; }
}

sub add_boot
{
	foreach (@_) { $boot{$_} = $add++; }
}

sub remove_boot
{
	foreach (@_) { delete $boot{$_}; }
}
