
add_defs "pkg.defs";
add_typemap "pkg.typemap";

add_headers "<gtktty/gtktty.h>";

# we need to know what libraries are used by the
# gtktty lib we are going to link to....
$libs =~ s/-l/-lgtktty -l/; # hack hack

add_boot "Gtk::VtEmu";
