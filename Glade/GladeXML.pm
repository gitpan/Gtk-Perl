

package Gtk::GladeXML;

require Gtk;
require Exporter;
require DynaLoader;
require AutoLoader;

use Carp;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
        
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

# Autoload methods go after __END__, and are processed by the autosplit program.

sub _connect_helper {
	my ($handler_name, $object, $signal_name, $signal_data, 
		$connect_object, $after, @handler) = @_;
	my ($func) = $after? "signal_connect_after" : "signal_connect";

	if ($connect_object) {
		warn "connect_object not supported for $handler_name\n";
	} else {
		no strict qw/refs/;
		$object->$func ($signal_name, @handler, $signal_data);
	}
}

sub _autoconnect_helper {
	my ($handler_name, $object, $signal_name, $signal_data, 
		$connect_object, $after, $package) = @_;
	my ($func) = $after? "signal_connect_after" : "signal_connect";
	my ($handler) = $handler_name;

	$handler = $package ."::". $handler_name if $package;

	if ($connect_object) {
		warn "connect_object not supported for $handler_name\n";
	} else {
		no strict qw/refs/;
		$object->$func ($signal_name, $handler, $signal_data);
	}
}

sub handler_connect {
	my ($self, $hname, @handler) = @_;

	$self->signal_connect_full($hname, \&_connect_helper, @handler);
}

sub signal_autoconnect_from_package {
	my ($self, $package) = @_;
	my ($handler);
	my ($chunk);
	($package, undef, undef) = caller() unless $package;
	$self->signal_autoconnect_full(\&_autoconnect_helper, @handler);
}

1;
__END__
