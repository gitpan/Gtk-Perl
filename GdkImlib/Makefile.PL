use ExtUtils::MakeMaker;
use blib '..';
use Gtk::Install::Files;
use Cwd;
require '../Depends.pm';
import ExtUtils::Depends;

#eval {require '../build/IFiles.pm'};
#warn ("Using installed Gtk\n"), require Gtk::Install::Files if $@;

#$Gtk::Install::Files::CORE = cwd()."../build" unless $Gtk::Install::Files::CORE;

mkdir('build', 0777);

$pm = {};

$inc = `imlib-config --cflags-gdk`;
chomp($inc);
$libs = `imlib-config --libs-gdk`;
chomp($libs);

@typemaps = @Gtk::Install::Files::typemaps;
$typemaps = [cwd() . '/pkg.typemap'];
@headers = ('"GdkImlibTypes.h"');

ExtUtils::Depends::save_config('Gtk::Gdk::ImlibImage', 'build/IFiles.pm', $inc, $libs, 
	$typemaps, [keys %defs], [@defines], [@headers], $pm);

foreach (@typemaps) {
	print "Add typemap: $Gtk::Install::Files::CORE/$_\n";
	push(@$typemaps, cwd() .'/'.$Gtk::Install::Files::CORE . '/'. $_);
}

push(@defines, @Gtk::Install::Files::defines);
push(@defines, "-I$Gtk::Install::Files::CORE");
#push(@defines, '-I../build', '-I../Gtk');

$pm->{'GdkImlibImage.pm'} = '$(INST_ARCHLIBDIR)/ImlibImage.pm';
$pm->{'GdkImlibTypes.h'} = '$(INST_ARCHLIBDIR)/ImlibImage/Install/'.'GdkImlibTypes.h';

add_raw_xs ('xs/GdkImlib.xs');

($xfiles, $object, $ldfrom) = setup_xs();

@clean = qw(
	build/IFiles.pm build/perl-gdkimlib-ref.pod
);
push(@clean, @ExtUtils::Depends::clean);

# documentation
#gendefs::gen_doc('gdkimlib');
system("../tools/gendoc.pl", "-t", 'gdkimlib', keys %ExtUtils::Depends::xs);


WriteMakefile(
	'NAME'      => 'Gtk::Gdk::ImlibImage',
	'VERSION_FROM'	=> 'GdkImlibImage.pm',
	'PM' => $pm,
	'TYPEMAPS' => $typemaps,
	'XS' => $xfiles,
	'XSOPT' => '-noversioncheck',
	'DEFINE'    => join(' ',"-I.", @defines),
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	'INC' => $inc,
	'LIBS' => [$libs],
	'OBJECT' => $object,
	'clean' => {FILES => join(' ', @clean) },
);


sub MY::c_o {
	package MY; # so that "SUPER" works right
	my $inherited = shift->SUPER::c_o(@_);
	$inherited =~ s/CCCMD.*$/$&\n\t\@if test -f `basename \$*.o` -a "`basename \$*.o`" != "\$*.o"; then mv `basename \$*.o` \$*.o; fi/m;
    $inherited;
}
