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

$inc = `gnome-config --cflags gnomeui`;
chomp($inc);
$libs = `gnome-config --libs gtkxmhtml`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GtkXmHTMLTypemap'];
@headers = ('GXHTypes.h', 'build/GtkXmHTMLDefs.h');

ExtUtils::Depends::save_config('Gtk::XmHTML', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, '-I../build', '-Ibuild', '-I.', '-I../Gtk');

$pm->{'GtkXmHTML.pm'} = '$(INST_ARCHLIBDIR)/XmHTML.pm';
$pm->{'build/GtkXmHTMLTypes.pm'} = '$(INST_ARCHLIBDIR)/XmHTML/Types.pm';

add_c ('GXHTypes.c', 'build/GtkXmHTMLDefs.c');
add_defs ('pkg.defs');
add_headers (qw( <gtk-xmhtml/gtk-xmhtml.h> "GXHTypes.h"));

add_raw_xs ('xs/GtkXmHTML.xs');
@a = (	'-f', 'GtkXmHTML', 
		'-p', 'Gtk=Gtk',
		'-p', 'GdkGL=Gtk::Gdk::GL',
		'-p', 'GdkRgb=Gtk::Gdk::Rgb',
		'-p', 'Gdk=Gtk::Gdk',
		'-p', 'Gnome=Gnome',
		'-p', 'Panel=Gnome::Panel',
		'-m', 'Gtk::XmHTML');

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

$depend = { 'build/GtkXmHTMLDefs.c' => 'build/GtkXmHTMLDefs.h build/PerlGtkXmHTMLInt.h' };

foreach (qw(GXHTypes.h build/GtkXmHTMLDefs.h build/PerlGtkXmHTMLInt.h)) {
	$pm->{$_} = '$(INST_ARCHLIBDIR)/'. basename($_);
}

write_ext();

@clean = qw(
	build/IFiles.pm build/GtkXmHTMLDefs.c build/GtkXmHTMLDefs.h 
	build/GtkXmHTMLDefs.o build/GtkXmHTMLTypemap build/GtkXmHTMLTypes.pm 
	build/PerlGtkXmHTMLExt.c build/PerlGtkXmHTMLExt.h build/PerlGtkXmHTMLInt.h 
	build/boxed.xsh build/extension.xsh build/objects.xsh
	build/perl-gtkxmhtml-ds.pod  build/perl-gtkxmhtml-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('gtkxmhtml');
system("../tools/gendoc.pl", "-t", 'gtkxmhtml', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gtk::XmHTML',
	'VERSION_FROM'	=> 'GtkXmHTML.pm',
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

build/PerlGtkXmHTMLExt.h build/PerlGtkXmHTMLExt.c build/PerlGtkXmHTMLInt.h: build/GtkXmHTMLDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl GtkXmHTML </dev/null

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

	
