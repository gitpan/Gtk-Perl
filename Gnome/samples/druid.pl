use Gtk;
use Gnome;

#TITLE: Druid example
#REQUIRES: Gtk Gnome

Gnome->init('druid');
init Gtk::Gdk::ImlibImage;

$logo = load_image Gtk::Gdk::ImlibImage ('../../Gtk/samples/xpm/3DRings.xpm');
#$logo2 = load_image Gtk::Gdk::ImlibImage ('../../Gtk/samples/xpm/Modeller.xpm');
$logo2 = load_image Gtk::Gdk::ImlibImage ('save.xpm');

my $win = new Gtk::Window("toplevel");
  $win->signal_connect( "destroy", \&Gtk::main_quit );
  $win->signal_connect( "delete_event", \&Gtk::false );
  my $vbox = new Gtk::VBox( 0, 2 );
  $win->add($vbox);
  $vbox->show;
  my $druid = new Gnome::Druid;
  $druid->signal_connect("cancel", sub {$win->hide;});
  $vbox->pack_start($druid,0,0,0);
  $druid_start = new Gnome::DruidPageStart();
  $druid_start->set_title("test");
  $druid_start->set_text("This is a test.");
  $druid_start->set_watermark($logo);
  $druid_start->show;
  $druid->append_page($druid_start);
  $druid_finish = new Gnome::DruidPageFinish();
  $druid_finish->set_title("Test Finished.");
  $druid_finish->set_text("This test is over.");
  $druid_finish->set_logo($logo2);
  $druid_finish->signal_connect("finish", sub {$win->hide;});
  $druid_finish->show;
  $druid->append_page($druid_finish);
  $druid->show;
  $win->show;

main Gtk;
