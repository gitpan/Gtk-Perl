

package Gnome::Print;

require Gtk;
require Gtk::Gdk::ImlibImage;
require Gtk::Gdk::Pixbuf;
require Gnome;
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

require Gnome::Print::Types;

sub dl_load_flags {0x01}

bootstrap Gnome::Print $VERSION;

# Autoload methods go after __END__, and are processed by the autosplit program.

Gtk->mod_init_add('Gtk', sub {
	init Gtk::Gdk::Rgb;
});

Gtk->mod_init_add('Gnome', sub {
	init Gnome::Print;
});

1;
__END__
