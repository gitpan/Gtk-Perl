use ExtUtils::MakeMaker;
use File::Basename;
use blib '..';
use Gtk::Install::Files;
use Cwd;
require '../Depends.pm';
import ExtUtils::Depends;

require '../tools/gendefs.pl';

mkdir('build', 0777);

$pm = {};

$inc = `gtk-config --cflags`;
chomp($inc);
$libs = "-lgtkgl  -lMesaGL -lMesaGLU " . `gtk-config --libs`;
chomp($libs);
$nomesa = $libs;
$nomesa =~ s/Mesa//g;

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GtkGLAreaTypemap'];
@headers = ( 'build/GtkGLAreaDefs.h', 'build/PerlGtkGLAreaInt.h');

add_boot ('Gtk::Gdk::GL', 'Gtk::GLArea::Constants');

ExtUtils::Depends::save_config('Gtk::GLArea', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, '-I../build', '-Ibuild', '-I.', '-I../Gtk');

$pm->{'GtkGLArea.pm'} = '$(INST_ARCHLIBDIR)/GLArea.pm';
$pm->{'build/GtkGLAreaTypes.pm'} = '$(INST_ARCHLIBDIR)/GLArea/Types.pm';

add_c ( 'build/GtkGLAreaDefs.c');
add_defs ('pkg.defs');
add_headers (qw( <gtkgl/gtkglarea.h> ));

add_raw_xs ('xs/GtkGdkGL.xs', 'xs/Constants.xs');
@a = (	'-f', 'GtkGLArea', 
		'-p', 'Gtk=Gtk',
		'-p', 'GdkGL=Gtk::Gdk::GL',
		'-p', 'GdkRgb=Gtk::Gdk::Rgb',
		'-p', 'Gdk=Gtk::Gdk',
		'-p', 'Gnome=Gnome',
		'-p', 'Panel=Gnome::Panel',
		'-m', 'Gtk::GLArea');

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

$depend = { 'build/GtkGLAreaDefs.c' => 'build/GtkGLAreaDefs.h build/PerlGtkGLAreaInt.h' };

foreach (qw( build/GtkGLAreaDefs.h build/PerlGtkGLAreaInt.h)) {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/GLArea/Install/'. basename($_);
}
$pm->{ 'Constants.pm' }  = '$(INST_LIBDIR)/GLArea/Constants.pm';
$pm->{	'Glut.pm'} = '$(INST_LIBDIR)/GLArea/Glut.pm';

write_ext();

@clean = qw(
	build/IFiles.pm build/GtkGLAreaDefs.c build/GtkGLAreaDefs.h 
	build/GtkGLAreaDefs.o build/GtkGLAreaTypemap build/GtkGLAreaTypes.pm 
	build/PerlGtkGLAreaExt.c build/PerlGtkGLAreaExt.h build/PerlGtkGLAreaInt.h 
	build/boxed.xsh build/extension.xsh build/objects.xsh
	build/perl-gtkglarea-ds.pod  build/perl-gtkglarea-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('gtkglarea');
system("../tools/gendoc.pl", "-t", 'gtkglarea', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gtk::GLArea',
	'VERSION_FROM'	=> 'GtkGLArea.pm',
	'PM' => $pm,
	'TYPEMAPS' => $typemaps,
	'XS' => $xfiles,
	'XSOPT' => '-noversioncheck',
	'DEFINE'    => join(' ',@defines),
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	'INC' => $inc,
	'LIBS' => [$nomesa, $libs],
	'OBJECT' => $object,
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

build/PerlGtkGLAreaExt.h build/PerlGtkGLAreaExt.c build/PerlGtkGLAreaInt.h: build/GtkGLAreaDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl GtkGLArea </dev/null

gendoc:
	../tools/gendoc.pl -t gtkglarea $(XS_FILES)

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

	
