use ExtUtils::MakeMaker;
use File::Basename;
use blib '..';
use Gtk::Install::Files;
use Cwd;
require '../Depends.pm';
import ExtUtils::Depends;

require '../tools/gendefs.pl';

mkdir('build', 0777);

if (defined(`libglade-config --libs gnome`)) {
	$gnome = 'gnome';
} else {
	$gnome = '';
}

$pm = {};

$inc = `libglade-config --cflags $gnome`;
chomp($inc);
$libs = `libglade-config --libs $gnome`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GtkGladeXMLTypemap'];
@headers = ('build/GtkGladeXMLDefs.h');

ExtUtils::Depends::save_config('Gtk::GladeXML', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, '-I../build', '-Ibuild', '-I.', '-I../Gtk');

$pm->{'GladeXML.pm'} = '$(INST_ARCHLIBDIR)/GladeXML.pm';
$pm->{'build/GtkGladeXMLTypes.pm'} = '$(INST_ARCHLIBDIR)/GladeXML/Types.pm';

add_c ('build/GtkGladeXMLDefs.c');
add_defs ('pkg.defs');
add_headers (qw( <glade/glade.h> ));

add_raw_xs ('xs/GladeXML.xs');
@a = (	'-f', 'GtkGladeXML', 
		'-p', 'Gtk=Gtk',
		'-p', 'GdkGL=Gtk::Gdk::GL',
		'-p', 'GdkRgb=Gtk::Gdk::Rgb',
		'-p', 'Gdk=Gtk::Gdk',
		'-p', 'Gnome=Gnome',
		'-p', 'Panel=Gnome::Panel',
		'-m', 'Gtk::GladeXML');

add_headers (keys %Gtk::Install::files::headers);
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

$depend = { 'build/GtkGladeXMLDefs.c' => 'build/GtkGladeXMLDefs.h build/PerlGtkGladeXMLInt.h' };

foreach (qw(build/GtkGladeXMLDefs.h build/PerlGtkGladeXMLInt.h)) {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/GladeXML/Install/'. basename($_);
}

write_ext();

push(@defines, '-DGNOME_HVER=defined') if $gnome;

@clean = qw(
	build/IFiles.pm build/GtkGladeXMLDefs.c build/GtkGladeXMLDefs.h 
	build/GtkGladeXMLDefs.o build/GtkGladeXMLTypemap build/GtkGladeXMLTypes.pm 
	build/PerlGtkGladeXMLExt.c build/PerlGtkGladeXMLExt.h 
	build/PerlGtkGladeXMLInt.h build/perl-glade-ds.pod build/perl-glade-ref.pod
	build/boxed.xsh build/extension.xsh build/objects.xsh
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('glade');
system("../tools/gendoc.pl", "-t", 'glade', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gtk::GladeXML',
	'VERSION_FROM'	=> 'GladeXML.pm',
	'PM' => $pm,
	'TYPEMAPS' => $typemaps,
	'XS' => $xfiles,
	'XSOPT' => '-noversioncheck',
	'DEFINE'    => join(' ',@defines),
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	'INC' => $inc,
	'LIBS' => [$libs],
	'OBJECT' => $object,
	'OPTIMIZE' => '-O2 -g',
	'clean' => {FILES => join(' ', @clean) },
	#'LDFROM' => $ldfrom,
	'depend' => $depend,
);

sub MY::postamble {

'
Makefile: ' . join(' ',
	sort {$defs{$a} <=> $defs{$b}} keys %defs,
	<*/pkg*.pl>
	) . '

build/PerlGtkGladeXMLExt.h build/PerlGtkGladeXMLExt.c build/PerlGtkGladeXMLInt.h: build/GtkGladeXMLDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl GtkGladeXML </dev/null

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

	
