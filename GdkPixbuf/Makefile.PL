use ExtUtils::MakeMaker;
use blib '../Gtk';
use Cwd;
require '../Depends.pm';
require '../tools/gendefs.pl';

$gpb = new ExtUtils::Depends('Gtk::Gdk::Pixbuf', 'Gtk');

mkdir('build', 0777);

$gpb->set_inc (`gdk-pixbuf-config --cflags`);
$gpb->set_libs (`gdk-pixbuf-config --libs`);

$gpb->add_typemaps (cwd() . '/pkg.typemap', cwd().'/build/GdkPixbufTypemap');
$gpb->add_headers (qw( <gdk-pixbuf/gdk-pixbuf-loader.h> ));

$gpb->save_config( 'build/Files.pm');
$gpb->install( 'build/Files.pm');

$gpb->add_pm('GdkPixbuf.pm' => '$(INST_ARCHLIBDIR)/Pixbuf.pm');

$gpb->add_c('build/GdkPixbufDefs.c');
$gpb->add_defs('pkg.defs');
$gpb->add_xs ('xs/GdkPixbuf.xs');

@a = ( '-f', 'GdkPixbuf',
	'-p', 'Gtk=Gtk',
	'-p', 'GdkRgb=Gtk::Gdk::Rgb',
	'-p', 'Gdk=Gtk::Gdk',
	'-m', 'Gtk::Gdk::Pixbuf');

foreach ($gpb->get_defs) {
        push @a, '-d', $_;
}
foreach ($gpb->get_headers) {
        push @a, '-i', $_;
}

$gpb->add_xs(gendefs::gendefs(@a));

$depend = { 'build/GdkPixbufDefs.c' => 'build/GdkPixbufDefs.h build/PerlGdkPixbufInt.h' };

$gpb->install (qw( build/GdkPixbufDefs.h build/PerlGdkPixbufInt.h));
$gpb->write_ext("build/extension.xsh");

$gpb->add_clean ( map {"build/$_"} qw(
Files.pm	 GdkPixbufTypemap    PerlGdkPixbufInt.h  perl-gdkpixbuf-ds.pod
GdkPixbufDefs.c  GdkPixbufTypes.pm   boxed.xsh		 perl-gdkpixbuf-ref.xml
GdkPixbufDefs.h  PerlGdkPixbufExt.c  extension.xsh
GdkPixbufDefs.o  PerlGdkPixbufExt.h  objects.xsh
));

# documentation
gendefs::gen_doc('gdkpixbuf');
system("../tools/gendoc.pl", "-t", 'gdkpixbuf', keys %ExtUtils::Depends::xs);

WriteMakefile(
	'NAME'      => 'Gtk::Gdk::Pixbuf',
	'VERSION_FROM'	=> 'GdkPixbuf.pm',
	'XSOPT' => '-noversioncheck',
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	$gpb->get_makefile_vars,
);

sub MY::postamble {

'
Makefile: ' . join(' ',
        sort {$defs{$a} <=> $defs{$b}} keys %defs,
        <*/pkg*.pl>
        ) . '

build/PerlGdkPixbufExt.h build/PerlGdkPixbufExt.c build/PerlGdkPixbufInt.h: build/GdkPixbufDefs.h ../tools/genext.pl
	$(PERL) ../tools/genext.pl GdkPixbuf </dev/null

gendoc:
	../tools/gendoc.pl -t gdkpixbuf $(XS_FILES)

';

}

sub MY::c_o {
	package MY; # so that "SUPER" works right
	my $inherited = shift->SUPER::c_o(@_);
	$inherited =~ s/CCCMD.*$/$&\n\t\@if test -f `basename \$*.o` -a "`basename \$*.o`" != "\$*.o"; then mv `basename \$*.o` \$*.o; fi/m;
    $inherited;
}
