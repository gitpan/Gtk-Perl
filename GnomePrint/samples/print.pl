#!/usr/bin/perl -w

#TITLE: Gnome Print sample
#REQUIRES: Gtk Gnome GnomePrint

use Gnome::Print;

init Gnome $0, '0.1';
Gtk::Widget->set_default_colormap(Gtk::Gdk::Rgb->get_cmap());
Gtk::Widget->set_default_visual(Gtk::Gdk::Rgb->get_visual());

$file = shift || "../../Gtk/samples/xpm/marble.xpm";
$pixbuf = Gtk::Gdk::Pixbuf->new_from_file($file);
@slanted = (0.9, 0.1, -0.8, 0.9, 0, 0);

$print_master = new Gnome::PrintMaster;
$context = $print_master->get_context;

$context->beginpage("Urka!");

# test gray and rgb images
$context->moveto(250, 200);
$width = 256;
$height = 60;
$image = pack("C*", 0..$width-1) x $height;
$context->grayimage($image, $width, $height);
$context->moveto(250, 300);
$context->rgbimage($image, $width, $height/3, $width);

$context->moveto(250, 350);
$context->pixbuf($pixbuf);

$context->moveto(100, 100);
$context->lineto(200, 200);
$context->stroke;
if (1) {
	$context->setfont(Gnome::Font->new_closest("Times", 'bold', 1, 20));
	$context->gsave();
	$context->moveto(150, 400);
	$context->concat(@slanted);
	$context->show("Slanted text, Times, bold 10");
	$context->grestore();
}
$context->moveto(250, 600);
foreach (map {$_*30} 0 .. 6) {
	$context->gsave();
	$context->concat(Gnome::Print->affine_rotate($_));
	$context->show("Un cjargnel no cjolares ...");
	$context->show("Un cjargnel \nno\n cjolares ...", {data=>0,handler=>sub {print "line: $_[1]\n";}}, 0, 'font-list', 'Times', 0, 'size', $_/10, 5, 'size', 10);
	$context->grestore();
}
$context->showpage;

$print_master->close;

$preview = new Gnome::PrintMasterPreview ($print_master, 'Gnome::Print from perl');
$preview->signal_connect('destroy', sub {Gtk->main_quit;});
$preview->show;

main Gtk;

