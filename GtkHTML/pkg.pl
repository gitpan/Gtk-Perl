
print "Gtk::HTML...\n";

add_pm 'GtkHTML.pm' => '$(INST_LIBDIR)/Gtk/HTML.pm';

add_defs 'pkg.defs';
add_typemap 'pkg.typemap';

add_headers (qw( <gtkhtml/gtkhtml.h> ));

$gtkhtmllibs = "-lgtkhtml " . `gtk-config --libs`;

$libs = "$libs $gtkhtmllibs"; 
# we need to know what libraries are used by the
# gtkxmhtml lib we are going to link to....
#
# This is a SERIOUSLY hackish way to do this.  I don't like working
# through the ENVIRONMENT variables anymore.  I think I'm going to
# go and convert all of these things. shortly...
#$libs =~ s/-l/$ENV{GTKXMHTML_LIBS} -l/; # hack hack
