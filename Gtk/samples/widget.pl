
use Gtk;

init Gtk;

#TITLE: Widget creation
#REQUIRES: Gtk Data::Dumper
 
package Foo;

use Data::Dumper;

@ISA = qw(Gtk::Button);

register_subtype Gtk::Button 'Foo', bloop => ['first', 'void'];

sub new {
	return Gtk::Object::new(@_);
}

sub GTK_OBJECT_INIT {
	print "init: ";
	print Dumper([@_]);
}

sub GTK_OBJECT_SET_ARG {
	print "set_arg: ";
	print Dumper([@_]);
}

sub GTK_OBJECT_GET_ARG {
	print "get_arg: ";
	print Dumper([@_]);
	return "$_[1]-result";
}

sub GTK_CLASS_INIT {
	my($self) = @_;
	print "class_init: ";
	print Dumper([@_]);

	add_arg_type $self "blorp", "GtkString", 3;
	add_arg_type $self "Foo::bletch", "gint", 3;

}

package main;

use Gtk;

$w = new Gtk::Window 'toplevel';

$b = new Foo Gtk::Button::label => "Foo button";

$b->{bibble} = 12;

#$b->signal_connect("clicked", sub { destroy $w });
$b->signal_connect("clicked", sub { $b->signal_emit("bloop")});

# Demonstration of emit
#use Data::Dumper;
#$b->signal_connect("install_accelerator", sub { 
#	print Dumper(\@_);
#	return 3;
#});
#$b->signal_connect("clicked", sub { print "ia: ",$b->signal_emit("install_accelerator", "signal", 64, 129),"\n";});

$b->signal_connect("bloop", sub {print "Bloop!\n"});

$b->set("Foo::blorp", 'fibble');
$b->set("Foo::bletch", 'fabble');
print "|",$b->get("Foo::blorp"),"|\n";

$w->add($b);

show $w;
show $b;

main Gtk;
