

package Gnome;

require Gtk;
require Gtk::Gdk::ImlibImage;
require Exporter;
require DynaLoader;
require AutoLoader;

use Carp;

$VERSION = '0.7005';

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
        
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

require Gnome::Types;

sub dl_load_flags {0x01}

bootstrap Gnome $VERSION;

sub getopt_options {
	my $dummy;
	return (
		Gtk->getopt_options,
		"disable-sound"	=> \$dummy,
		"enable-sound"	=> \$dummy,
		"espeaker=s"	=> \$dummy,
		"version"	=> \$dummy,
		"usage"	=> \$dummy,
		"help|?"	=> \$dummy,
		"sm-client-id=s"	=> \$dummy,
		"sm-config-prefix=s"	=> \$dummy,
		"sm-disable" => \$dummy,
		"disable-crash-dialog" => \$dummy,
		);
}

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
