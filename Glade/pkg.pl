
print "Glade\n";

add_defs 'pkg.defs';
add_typemap 'pkg.typemap';

add_xs  'GladeXML.xs';
#add_boot 'Gtk::GladeXML';
add_pm 'GladeXML.pm' => '$(INST_LIBDIR)/Gtk/GladeXML.pm';

add_headers "<glade/glade.h>";

$libs .= " " . `libglade-config --libs`;
chomp($libs);
$inc .= " " . `libglade-config --cflags`;
chomp($inc);

