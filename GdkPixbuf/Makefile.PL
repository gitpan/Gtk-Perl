use ExtUtils::MakeMaker;
use File::Basename;
use blib '..';
use Gtk::Install::Files;
use Cwd;
require '../Depends.pm';
import ExtUtils::Depends;
require '../tools/gendefs.pl';

#eval {require '../build/IFiles.pm'};
#warn ("Using installed Gtk\n"), require Gtk::Install::Files if $@;

#$Gtk::Install::Files::CORE = cwd()."../build" unless $Gtk::Install::Files::CORE;

mkdir('build', 0777);

$pm = {};

$inc = `gdk-pixbuf-config --cflags`;
chomp($inc);
$libs = `gdk-pixbuf-config --libs`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap', cwd().'/build/GdkPixbufTypemap'];
@headers = ('"build/GdkPixbufTypes.h"');

ExtUtils::Depends::save_config('Gtk::Gdk::Pixbuf', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, "-I$Gtk::Install::Files::CORE");
push(@defines, '-Ibuild');

$pm->{'GdkPixbuf.pm'} = '$(INST_ARCHLIBDIR)/Pixbuf.pm';
#$pm->{'GdkImlibTypes.h'} = '$(INST_ARCHLIBDIR)/ImlibImage/Install/'.'GdkImlibTypes.h';

add_c('build/GdkPixbufDefs.c');
add_defs('pkg.defs');
add_raw_xs ('xs/GdkPixbuf.xs');
add_headers (qw( <gdk-pixbuf/gdk-pixbuf-loader.h> ));

@a = ( '-f', 'GdkPixbuf',
	'-p', 'Gtk=Gtk',
	'-p', 'GdkRgb=Gtk::Gdk::Rgb',
	'-p', 'Gdk=Gtk::Gdk',
	'-m', 'Gtk::Gdk::Pixbuf');

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

$depend = { 'build/GdkPixbufDefs.c' => 'build/GdkPixbufDefs.h build/PerlGdkPixbufInt.h' };

foreach (qw( build/GdkPixbufDefs.h build/PerlGdkPixbufInt.h)) {
        $pm->{$_} = '$(INST_ARCHLIBDIR)/'. basename($_);
}

write_ext();

@clean = qw(
	build/IFiles.pm build/perl-gdkpixbuf-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
gendefs::gen_doc('gdkpixbuf');
system("../tools/gendoc.pl", "-t", 'gdkpixbuf', keys %ExtUtils::Depends::xs);


WriteMakefile(
	'NAME'      => 'Gtk::Gdk::Pixbuf',
	'VERSION_FROM'	=> 'GdkPixbuf.pm',
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
