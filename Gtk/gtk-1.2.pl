# This configuration data is used for versions of Gtk from 1.2.x onward

add_xs "GtkAccelGroup.xs", "GtkProgressBar-1.1.xs", "GtkCList-1.2.xs";
add_boot "Gtk__AccelGroup", "Gtk::ProgressBar11", "Gtk::CList12";

add_defs "gtk-1.2.defs";
