

package Bonobo;

require Gtk;
require Gtk::Gdk::ImlibImage;
require Gnome;
require Exporter;
require DynaLoader;
require AutoLoader;
use CORBA::ORBit 
	vnamespace => 1,
	defines => "-D__ORBIT_IDL__ -D__BONOBO_COMPILATION",
	idl_path => "/usr/share/idl:/usr/local/share/idl:/opt/idl", 
	idl => ['Bonobo.idl'];

use Carp;

$VERSION = '0.7006';

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
        
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

require Bonobo::Types;

sub dl_load_flags {0x01}

bootstrap Bonobo $VERSION;

# Autoload methods go after __END__, and are processed by the autosplit program.

sub getopt_options {
	my $dummy;
	return (
		"oaf-od-ior=s"	=> \$dummy,
		"oaf-ior-fd=i"	=> \$dummy,
		"oaf-activate-iid=s"	=> \$dummy,
		"oaf-private"	=> \$dummy,
		);
}
1;
__END__
