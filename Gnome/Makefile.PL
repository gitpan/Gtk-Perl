use ExtUtils::MakeMaker;
use File::Basename;
use blib '..';
use blib '../GdkImlib';
use Gtk::Install::Files;
use Gtk::Gdk::ImlibImage::Install::Files;
use Cwd;
require '../Depends.pm';
import ExtUtils::Depends;

require '../tools/gendefs.pl';

mkdir('build', 0777);

$pm = {};

$inc = `gnome-config --cflags gnomeui zvt`;
chomp($inc);
$libs = `gnome-config --libs gnomeui zvt`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GnomeTypemap'];
@headers = qw("GnomeDefs.h");

$gnome_version = `gnome-config --version`;
if ( $gnome_version =~ /(\d+)\.(\d+)\.(\d+)/) {
	$gnome_major = $1;
	$gnome_minor = $2;
	$gnome_micro = $3;
} else {
	$gnome_major = $gnome_minor = $gnome_micro = 0;
}

$gnome_hverstr = sprintf("0x%02x%02x%02x", $gnome_major, $gnome_minor, $gnome_micro);
if ($gnome_major > 1 || ($gnome_major == 1 && $gnome_minor >= 1) || ($gnome_major == 1 && $gnome_micro >= 50)) {
	print "Using october gnome release\n";
	add_defs ('gnome-october.defs');
}

if (grep {/--with-panel/} @ARGV) {
	do 'pkg-panel.pl';
}
push @defines, "-DGNOME_HVER=$gnome_hverstr";
ExtUtils::Depends::save_config('Gnome', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}
foreach (@Gtk::Gdk::ImlibImage::Install::Files::typemaps) {
	print "Add typemap: $Gtk::Gdk::ImlibImage::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Gdk::ImlibImage::Install::Files::CORE . '/'. $_);
}
push(@defines, @Gtk::Install::Files::defines, @Gtk::Gdk::ImlibImage::Install::Files::defines);
#push(@defines, '-I../build', '-Ibuild', '-I.', '-I../Gtk');
push(@defines, "-I$Gtk::Gdk::ImlibImage::Install::Files::CORE");
push(@defines, '-Ibuild', '-I.', "-I$Gtk::Install::Files::CORE");

$pm->{'Gnome.pm'} = '$(INST_ARCHLIBDIR)/Gnome.pm';
$pm->{'build/GnomeTypes.pm'} = '$(INST_ARCHLIBDIR)/Gnome/Types.pm';

add_c ('build/GnomeDefs.c');
add_defs ('pkg.defs', 'pkg-zvt.defs');
add_headers (qw( <zvt/zvtterm.h> <libgnome/libgnome.h> <libgnomeui/libgnomeui.h> "GnomeTypes.h" ));

add_raw_xs ('xs/Gnome.xs', 'xs/GnomeDialogUtil.xs', 'xs/GnomeDNS.xs', 
	'xs/GnomeGeometry.xs', 'xs/GnomeICE.xs');

@a = (	'-f', 'Gnome', 
		'-p', 'Gtk=Gtk',
		'-p', 'GdkGL=Gtk::Gdk::GL',
		'-p', 'GdkRgb=Gtk::Gdk::Rgb',
		'-p', 'Gdk=Gtk::Gdk',
		'-p', 'Gnome=Gnome',
		'-p', 'Panel=Gnome::Panel',
		'-m', 'Gnome');

add_headers (@Gtk::Install::Files::headers);
add_headers (@Gtk::Gdk::ImlibImage::Install::Files::headers);
# FIXME: use defs and headers from ExtUtils::Depends....
%defs = %ExtUtils::Depends::defs;
%headers = %ExtUtils::Depends::headers;
foreach (sort {$defs{$a} <=> $defs{$b}} keys %defs) {
	push @a, '-d', $_;
}
foreach (sort {$headers{$a} <=> $headers{$b}} keys %headers) {
	push @a, '-i', $_;
}

add_raw_xs(gendefs::gendefs(@a));

($xfiles, $object, $ldfrom) = setup_xs();

$depend = { 'build/GnomeDefs.c' => 'build/GnomeDefs.h build/PerlGnomeInt.h' };

foreach (qw(build/GnomeDefs.h build/PerlGnomeInt.h)) {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/Gnome/Install/'. basename($_);
}

write_ext();

@clean = qw(
	build/IFiles.pm build/GnomeDefs.c build/GnomeDefs.h build/GnomeDefs.o 
	build/GnomeTypemap build/GnomeTypes.pm build/PerlGnomeExt.c 
	build/PerlGnomeExt.h build/PerlGnomeInt.h build/boxed.xsh 
	build/extension.xsh build/objects.xsh build/perl-gnome-ds.pod 
	build/perl-gnome-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('gnome');
system("../tools/gendoc.pl", "-t", 'gnome', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gnome',
	'VERSION_FROM'	=> 'Gnome.pm',
	'PM' => $pm,
	'TYPEMAPS' => $typemaps,
	'XS' => $xfiles,
	'XSOPT' => '-noversioncheck',
	'DEFINE'    => join(' ',@defines),
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	'INC' => $inc,
	'LIBS' => [$libs],
	'OBJECT' => $object,
	'clean' => {FILES => join(' ', @clean) },
	'OPTIMIZE' => '-O2 -g',
	#'LDFROM' => $ldfrom,
	'depend' => $depend,
);

sub MY::postamble {

'
Makefile: ' . join(' ',
	sort {$defs{$a} <=> $defs{$b}} keys %defs,
	<*/pkg*.pl>
	) . '

build/PerlGnomeExt.h build/PerlGnomeExt.c build/PerlGnomeInt.h: build/GnomeDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl Gnome </dev/null

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

	
