

package Gtk::GladeXML;

require Gtk;
require Exporter;
require DynaLoader;
require AutoLoader;

use Carp;
use strict;

$Gtk::GladeXML::VERSION = '0.7000';

@Gtk::GladeXML::ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@Gtk::GladeXML::EXPORT = qw(
        
);
# Other items we are prepared to export if requested
@Gtk::GladeXML::EXPORT_OK = qw(
);

bootstrap Gtk::GladeXML;

require Gtk::GladeXML::Types;

sub dl_load_flags {0x01}

# Autoload methods go after __END__, and are processed by the autosplit program.

sub _connect_helper {
	my ($handler_name, $object, $signal_name, $signal_data, 
		$connect_object, $after, $handler, @data) = @_;
	
	no strict qw/refs/;

	if ($connect_object) {
		my ($func) = $after? "signal_connect_object_after" : "signal_connect_object";
		$object->$func ($signal_name, $connect_object, $handler, @data, $signal_data);
	} else {
		my ($func) = $after? "signal_connect_after" : "signal_connect";
		$object->$func ($signal_name, $handler, $signal_data);
	}
}

sub _autoconnect_helper {
	my ($handler_name, $object, $signal_name, $signal_data, 
		$connect_object, $after, $package) = @_;
	my ($handler) = $handler_name;
	
	no strict qw/refs/;

	$handler = $package ."::". $handler_name if $package;

	if ($connect_object) {
		my ($func) = $after? "signal_connect_object_after" : "signal_connect_object";
		$object->$func ($signal_name, $connect_object, $handler, $signal_data);
	} else {
		my ($func) = $after? "signal_connect_after" : "signal_connect";
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
	$self->signal_autoconnect_full(\&_autoconnect_helper, $package);
}

1;
__END__
