#!/usr/bin/perl

#TITLE: Gnome Canvas
#REQUIRES: Gtk Gnome

$NAME = 'Calculator';

use Gnome;
init Gnome "calculator.pl";

my($window) = new Gtk::Widget "Gtk::Window",
	-type => -toplevel,
	-visible => 1,
	-signal::destroy => sub {exit}
	;

#Gtk::Gdk::Rgb->init();
#Gtk::Widget->push_visual(Gtk::Gdk::Rgb->get_visual ());
#Gtk::Widget->push_colormap (Gtk::Gdk::Rgb->get_cmap ());
#my($canvas) = Gnome::Canvas->new_aa() ;
my($canvas) = Gnome::Canvas->new() ;

#$canvas->set_scroll_region(0,0,300,300);
$window->add($canvas);
$canvas->show;

#$canvas->set_size(300,300);
# kill 19,$$;

$canvas->style->bg('normal', $canvas->style->white);

my $croot = $canvas->root;

my $cgroup = $croot->new($croot, "Gnome::CanvasGroup");
my $r = Gnome::CanvasItem->new($cgroup, "Gnome::CanvasRect",
	x1 => 0, x2 => 100, y1 => 0, y2 => 100,
	outline_color => "black",
	width_pixels => 2,
	);
my $rect = Gnome::CanvasItem->new($cgroup, "Gnome::CanvasRect",
	x1 => 5, x2 => 15, y1 => 5, y2 => 15,
	fill_color => "black",
	);
my $ell = $cgroup->new($cgroup, "Gnome::CanvasEllipse",
	x1 => 20, x2 => 40, y1 => 20, y2 => 40,
	fill_color => "red",
	outline_color => "blue",
	width_pixels => 3
	);

my ($cx, $cy);
my ($bp, $bpx, $bpy);
$cgroup->signal_connect("event", sub {
# 	print "EV: @_ \n(",(join "   ",%{$_[1]}),")\n";
	my($item, $event) = @_;
	if($event->{type} eq "button_press" and 
	   $event->{button} == 1) {
	   	$bp = 1; ($bpx, $bpy) = @{$event}{qw/x y/};
		print "PRESSED\n";
	} elsif($event->{type} eq "button_release" and 
	   $event->{button} == 1) {
	   	$bp = 0; 
		print "RELEASED\n";
	} elsif($event->{type} eq "motion_notify" and $bp) {
		my $dx = $event->{x} - $bpx;
		my $dy = $event->{y} - $bpy;
		print "CX &c: $cx $cy $dx $dy\n";
		#$cgroup->move($dx, $dy);
		 $cgroup->set(x => $cx += $dx,
	 		     y => $cy += $dy);
		$bpx += $dx;
		$bpy += $dy;
	}
	return 1;
});

# my $poly = $cgroup->new($cgroup, "Gnome::CanvasPolygon",
# 	points => [30,30, 40,30, 50,40, 30,60],
# 	fill_color => "pink",
# 	outline_color => "blue",
# 	width_pixels => 3
# 	);


my $cgroup2 = $croot->new($croot, "Gnome::CanvasGroup");
my $txt = $cgroup2->new($cgroup2, "Gnome::CanvasText",
	x => 50,
	y => 50,
	text => "A string\nToinen rivi",
);

my $line = $cgroup2->new($cgroup2,"Gnome::CanvasLine",
 	points => [10,10, 40,30, 50,40, 30,80, 80, 80],
	fill_color => green,
	width_pixels => 8,
	smooth => 1,
	spline_steps => 50
);


main Gtk;
