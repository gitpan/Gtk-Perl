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

$inc = `gnome-config --cflags gdk_pixbuf gnomeui`;
chomp($inc);
$libs = "-lgtkhtml ".`gnome-config --libs gdk_pixbuf gnomeui`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GtkHTMLTypemap'];
@headers = ('build/GtkHTMLDefs.h');

ExtUtils::Depends::save_config('Gtk::HTML', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, '-I../build', '-Ibuild', '-I.', '-I../Gtk');

$pm->{'GtkHTML.pm'} = '$(INST_ARCHLIBDIR)/HTML.pm';
$pm->{'build/GtkHTMLTypes.pm'} = '$(INST_ARCHLIBDIR)/HTML/Types.pm';

add_c ('build/GtkHTMLDefs.c');
add_defs ('pkg.defs');
add_headers (qw( <gtkhtml/gtkhtml.h> ));

add_raw_xs ('xs/GtkHTML.xs');
@a = (	'-f', 'GtkHTML', 
		'-p', 'Gtk=Gtk',
		'-p', 'GdkGL=Gtk::Gdk::GL',
		'-p', 'GdkRgb=Gtk::Gdk::Rgb',
		'-p', 'Gdk=Gtk::Gdk',
		'-p', 'Gnome=Gnome',
		'-p', 'Panel=Gnome::Panel',
		'-m', 'Gtk::HTML');

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

$depend = { 'build/GtkHTMLDefs.c' => 'build/GtkHTMLDefs.h build/PerlGtkHTMLInt.h' };

foreach (qw( build/GtkHTMLDefs.h build/PerlGtkHTMLInt.h)) {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/'. basename($_);
}

write_ext();

@clean = qw(
	build/IFiles.pm build/GtkHTMLDefs.c build/GtkHTMLDefs.h 
	build/GtkHTMLDefs.o build/GtkHTMLTypemap build/GtkHTMLTypes.pm 
	build/PerlGtkHTMLExt.c build/PerlGtkHTMLExt.h build/PerlGtkHTMLInt.h 
	build/boxed.xsh build/extension.xsh build/objects.xsh
	build/perl-gtkhtml-ds.pod  build/perl-gtkhtml-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('gtkhtml');
system("../tools/gendoc.pl", "-t", 'gtkhtml', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gtk::HTML',
	'VERSION_FROM'	=> 'GtkHTML.pm',
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
	#'LDFROM' => $ldfrom,
	'depend' => $depend,
);

sub MY::postamble {

'
Makefile: ' . join(' ',
	sort {$defs{$a} <=> $defs{$b}} keys %defs,
	<*/pkg*.pl>
	) . '

build/PerlGtkHTMLExt.h build/PerlGtkHTMLExt.c build/PerlGtkHTMLInt.h: build/GtkHTMLDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl GtkHTML </dev/null

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

	
