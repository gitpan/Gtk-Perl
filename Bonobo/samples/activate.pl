#!/usr/bin/perl -w
# TITLE: Bonobo sample moniker activation
# REQUIRES: Gtk Gnome Bonobo
use Bonobo;
use Error qw(:try);

#@CORBA::Object_1_0::ISA = qw(CORBA::Object);

init Gnome $0, '0.1';
init Bonobo;

$moniker = shift || 'file:/etc/passwd';
$interface = shift || "IDL:Bonobo/Stream:1.0";
#Gtk->timeout_add(5000, sub {exit});

my $orb = CORBA::ORB_init ("orbit-local-orb");

try {
	$obj2 = $obj = Bonobo->get_object($moniker, $interface);
	die "Cannot activate $moniker\n" unless defined($obj);
	print "$obj\n";
	if ($obj->_is_a ('IDL:Bonobo/Stream:1.0')) {
		$info = $obj->getInfo(1|2|4); # content_type and size
		print "Content: $info->{content_type}\nSize: $info->{size}\n";
		$content = $obj->read(256);
		print "First 256 bytes of content:\n", $content, "\n";
	} elsif ($obj->_is_a('IDL:Bonobo/Control:1.0')) {
		$widget = new_control_from_objref Bonobo::Widget ($obj, undef);
		$win = new Gtk::Window;
		$win->signal_connect('destroy', sub {Gtk->exit(0)});
		$win->add($widget);
		$win->show_all;
		main Bonobo;
	}
} catch CORBA::Exception with {
	warn "Got an exception: $_[0]\n";
};


