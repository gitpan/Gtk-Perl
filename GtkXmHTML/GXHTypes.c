
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"


	/* completely busted */
XmAnyCallbackStruct * SvGtkXmHTMLCallbackStruct(SV * data)
{
	return 0;
}

XmAnyCallbackStruct * SvSetXmAnyCallbackStruct(SV * data, XmAnyCallbackStruct * e)
{
	return 0;
}

SV * newSVXmAnyCallbackStruct(XmAnyCallbackStruct * e)
{
	HV * h;
	SV * r;
	int n;
	
	if (!e)
		return newSVsv(&PL_sv_undef);
 
        h = newHV();

	r = newRV((SV*)h);
	SvREFCNT_dec(h);

	sv_bless(r, gv_stashpv("Gtk::XmHTMLCallback", FALSE));
 	
	hv_store(h, "_ptr", 4, newSViv((int)e), 0);
	
	if (e->reason) {
	hv_store(h, "reason", 4, newSVXmHTMLCallbackReason(e->reason), 0);
	switch (e->reason) {
/*	case GDK_EXPOSE:
		hv_store(h, "area", 4, newSVGdkRectangle(&e->expose.area), 0);
		hv_store(h, "count", 5, newSViv(e->expose.count), 0);
		break;
	case GDK_MOTION_NOTIFY:
		hv_store(h, "is_hint", 7, newSViv(e->motion.is_hint), 0);
		hv_store(h, "x", 1, newSVnv(e->motion.x), 0);
		hv_store(h, "y", 1, newSVnv(e->motion.y), 0);
		hv_store(h, "pressure", 8, newSVnv(e->motion.pressure), 0);
		hv_store(h, "xtilt", 5, newSVnv(e->motion.xtilt), 0);
		hv_store(h, "ytilt", 5, newSVnv(e->motion.ytilt), 0);
		hv_store(h, "time", 4, newSViv(e->motion.time), 0);
		hv_store(h, "state", 5, newSViv(e->motion.state), 0);
		hv_store(h, "source", 6, newSVGdkInputSource(e->motion.source), 0);
		hv_store(h, "deviceid", 8, newSViv(e->motion.deviceid), 0);
		break;
	case GDK_BUTTON_PRESS:
	case GDK_2BUTTON_PRESS:
	case GDK_3BUTTON_PRESS:
	case GDK_BUTTON_RELEASE:
		hv_store(h, "x", 1, newSViv(e->button.x), 0);
		hv_store(h, "y", 1, newSViv(e->button.y), 0);
		hv_store(h, "time", 4, newSViv(e->button.time), 0);
		hv_store(h, "pressure", 8, newSVnv(e->motion.pressure), 0);
		hv_store(h, "xtilt", 5, newSVnv(e->motion.xtilt), 0);
		hv_store(h, "ytilt", 5, newSVnv(e->motion.ytilt), 0);
		hv_store(h, "state", 5, newSViv(e->button.state), 0);
		hv_store(h, "button", 6, newSViv(e->button.button), 0);
		hv_store(h, "source", 6, newSVGdkInputSource(e->motion.source), 0);
		hv_store(h, "deviceid", 8, newSViv(e->motion.deviceid), 0);
		break;
	case GDK_KEY_PRESS:
	case GDK_KEY_RELEASE:
		hv_store(h, "time", 4, newSViv(e->key.time), 0);
		hv_store(h, "state", 5, newSViv(e->key.state), 0);
		hv_store(h, "keyval", 6, newSViv(e->key.keyval), 0);
		break;
	case GDK_FOCUS_CHANGE:
		hv_store(h, "in", 2, newSViv(e->focus_change.in), 0);
		break;
	case GDK_ENTER_NOTIFY:
	case GDK_LEAVE_NOTIFY:
		hv_store(h, "window", 6, newSVGdkWindow(e->crossing.window), 0);
		hv_store(h, "subwindow", 9, newSVGdkWindow(e->crossing.subwindow), 0);
		hv_store(h, "detail", 6, newSVGdkNotifyType(e->crossing.detail), 0);
		break;
	case GDK_CONFIGURE:
		hv_store(h, "x", 1, newSViv(e->configure.x), 0);
		hv_store(h, "y", 1, newSViv(e->configure.y), 0);
		hv_store(h, "width", 5, newSViv(e->configure.width), 0);
		hv_store(h, "height", 6, newSViv(e->configure.height), 0);
		break;
	case GDK_PROPERTY_NOTIFY:
		hv_store(h, "time", 4, newSViv(e->property.time), 0);
		hv_store(h, "state", 5, newSViv(e->property.state), 0);
		hv_store(h, "atom", 4, newSVGdkAtom(e->property.atom), 0);
		break;
	case GDK_SELECTION_CLEAR:
	case GDK_SELECTION_REQUEST:
	case GDK_SELECTION_NOTIFY:
		hv_store(h, "requestor", 9, newSViv(e->selection.requestor), 0);
		hv_store(h, "time", 4, newSViv(e->selection.time), 0);
		hv_store(h, "selection", 9, newSVGdkAtom(e->selection.selection), 0);
		hv_store(h, "property", 8, newSVGdkAtom(e->selection.property), 0);
		break;
	case GDK_PROXIMITY_IN:
	case GDK_PROXIMITY_OUT:
		hv_store(h, "time", 4, newSViv(e->proximity.time), 0);
		hv_store(h, "source", 6, newSVGdkInputSource(e->motion.source), 0);
		hv_store(h, "deviceid", 8, newSViv(e->motion.deviceid), 0);
		break;
*/		
	}
	}
	
	return r;
}
