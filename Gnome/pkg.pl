
add_defs "pkg.defs";
add_typemap "pkg.typemap";

add_xs qw( Gnome.xs GnomeDialogUtil.xs GnomeDNS.xs GnomeGeometry.xs GnomeICE.xs);
# add_headers "<argp.h>", "<libgnome/libgnome.h>", "<libgnomeui/libgnomeui.h>", '"GnomeTypes.h"';
add_headers "<libgnome/libgnome.h>", "<libgnomeui/libgnomeui.h>", '"GnomeTypes.h"';
add_boot "Gnome", "Gnome::DialogUtil", "Gnome::DNS", "Gnome::Geometry", "Gnome::ICE";

add_pm 'Gnome.pm' => '$(INST_LIBDIR)/Gnome.pm';

# use gnomeConf.sh...
$inc = $ENV{GNOME_INCLUDEDIR} . " " . $inc;
$libs = "$libs -L$ENV{GNOME_LIBDIR} $ENV{GNOMEUI_LIBS}"; #hack hack

print "Got libs='$libs' (gn: $ENV{GNOMEUI_LIBS})\n";

