#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Copyright (C) 1997,1998, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */

#if !defined(PERLIO_IS_STDIO) && defined(HASATTRIBUTE)
# undef printf
#endif

#include <gtk/gtk.h>

#if !defined(PERLIO_IS_STDIO) && defined(HASATTRIBUTE)
# define printf PerlIO_stdoutf
#endif
   
#include "PerlGtkInt.h"
#include "GtkTypes.h"
#include "GdkTypes.h"
#include "MiscTypes.h"

#include "Derived.h"

#include "GtkDefs.h"

static HV * ObjectCache = 0;

/** If defined, engage heavy duty memory management, including garbage collection.
  */

#define TRY_MM
#if GTK_HVER >= 0x010200
#define USE_TYPE_QUERY
#endif
#undef DEBUG_TYPES

HV * gtname_by_ptname = 0;
HV * ptname_by_gtname = 0;
AV * ptname_by_gtnumber = 0;
HV * gtnumber_by_ptname = 0;
HV * gtinit_by_gtname = 0;
HV * gtosize_by_gtname = 0;
HV * gtcsize_by_gtname = 0;

void complete_types(int gtkTypeNumber, char * perlTypeName, SV * svPerlTypeName)
{
	dTHR;

	SV ** result;
	
	if (!perlTypeName)
		perlTypeName = SvPV(svPerlTypeName, PL_na);
	
	if (!svPerlTypeName) {
		char * gtkTypeName = gtk_type_name(gtkTypeNumber);
	
		result = hv_fetch(ptname_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
		
		if (!result || !SvOK(*result)) /* Weird */
			return; 
		
		svPerlTypeName = *result;
	}

	if (!ptname_by_gtnumber)
		ptname_by_gtnumber = newAV();
		
	av_store(ptname_by_gtnumber, GTK_TYPE_SEQNO(gtkTypeNumber), svPerlTypeName);

	if (!gtnumber_by_ptname)
		gtnumber_by_ptname = newHV();

	hv_store(gtnumber_by_ptname, perlTypeName, strlen(perlTypeName), newSViv(gtkTypeNumber), 0);

#ifdef DEBUG_TYPES
	printf("complete_types(%d, %s)\n", gtkTypeNumber, perlTypeName);
#endif

}

void link_types(char * gtkName, char * perlName, int gtkTypeNumber, gtkTypeInitFunc ifunc, int obj_size, int class_size)
{
	SV * perlnamesv = newSVpv(perlName, 0);
	SV * gtknamesv = newSVpv(gtkName, 0);
	
#ifdef DEBUG_TYPES
	printf("link_types(%s, %s, %d,)\n", gtkName, perlName, gtkTypeNumber);
#endif

	if (!gtname_by_ptname)
		gtname_by_ptname = newHV();
	hv_store(gtname_by_ptname, perlName, strlen(perlName), gtknamesv, 0);

	if (!ptname_by_gtname)
		ptname_by_gtname = newHV();
	hv_store(ptname_by_gtname, gtkName, strlen(gtkName), perlnamesv, 0);
	
	if (gtkTypeNumber) {
		complete_types(gtkTypeNumber, perlName, perlnamesv);
	}
	
	if (!gtinit_by_gtname)
		gtinit_by_gtname = newHV();
	hv_store(gtinit_by_gtname, gtkName, strlen(gtkName), newSViv((long)ifunc), 0);

#ifndef USE_TYPE_QUERY
	if (!gtosize_by_gtname)
		gtosize_by_gtname = newHV();
	hv_store(gtosize_by_gtname, gtkName, strlen(gtkName), newSViv(obj_size), 0);

	if (!gtcsize_by_gtname)
		gtcsize_by_gtname = newHV();
	hv_store(gtcsize_by_gtname, gtkName, strlen(gtkName), newSViv(class_size), 0);
#endif
}

int obj_size_for_gtname(char * gtkTypeName)
{
#ifndef USE_TYPE_QUERY
	SV ** result;

	if (!gtosize_by_gtname)
		result = 0;
	else
		result = hv_fetch(gtosize_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
	
	if (!result || !SvOK(*result))
		return 0;
	else
		return SvIV(*result);
#else
	GtkTypeQuery * q;
	GtkType type;
	gint size;
	
	if (!(type=gtk_type_from_name(gtkTypeName)))
			return 0;
	if (!(q = gtk_type_query(type)))
		return 0;
	size = q->object_size;
	g_free(q);
	return size;
#endif
}

int class_size_for_gtname(char * gtkTypeName)
{
#ifndef USE_TYPE_QUERY
	SV ** result;

	if (!gtcsize_by_gtname)
		result = 0;
	else
		result = hv_fetch(gtcsize_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
	
	if (!result || !SvOK(*result))
		return 0;
	else
		return SvIV(*result);
#else
	GtkTypeQuery * q;
	GtkType type;
	gint size;
	
	if (!(type=gtk_type_from_name(gtkTypeName)))
			return 0;
	if (!(q = gtk_type_query(type)))
		return 0;
	size = q->class_size;
	g_free(q);
	return size;
#endif
}

char * ptname_for_gtname(char * gtkTypeName)
{
	dTHR;

	char * perlTypeName = 0;
	SV ** result;

	if (!ptname_by_gtname)
		result = 0;
	else
		result = hv_fetch(ptname_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
	
	if (result && SvOK(*result))
		perlTypeName = SvPV(*result, PL_na);

#ifdef DEBUG_TYPES
	printf("ptname_for_gtname(%s) = %s\n", perlTypeName);
#endif

	return perlTypeName;
}

char * gtname_for_ptname(char * perlTypeName)
{
	dTHR;
	
	char * gtkTypeName = 0;
	SV ** result;

	if (!gtname_by_ptname)
		result = 0;
	else
		result = hv_fetch(gtname_by_ptname, perlTypeName, strlen(perlTypeName), 0);
	
	if (result && SvOK(*result))
		gtkTypeName = SvPV(*result, PL_na);

#ifdef DEBUG_TYPES
	printf("gtname_for_ptname(%s) = %s\n", gtkTypeName);
#endif
	
	return gtkTypeName;
}


char * ptname_for_gtnumber(int gtkTypeNumber)
{
	dTHR;

	SV ** result;
	char * perlTypeName;

#ifdef DEBUG_TYPES
	printf("ptname_for_gtnumber(%d) = ", gtkTypeNumber);
#endif

	if (!ptname_by_gtnumber)
		result = 0;
	else
		result = av_fetch(ptname_by_gtnumber, GTK_TYPE_SEQNO(gtkTypeNumber), 0);
		
	if (!result || !SvOK(*result)) {
		char * gtkTypeName;

		/* Type we haven't seen yet */
					
		if (!ptname_by_gtname) /* Weird */
			return 0;

		gtkTypeName = gtk_type_name(gtkTypeNumber);

		result = hv_fetch(ptname_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
		
		if (!result || !SvOK(*result)) /* Weird */
			return 0; 

		perlTypeName = SvPV(*result, PL_na);

		complete_types(gtkTypeNumber, 0, *result);
	
	} else
		perlTypeName = SvPV(*result, PL_na);
	
#ifdef DEBUG_TYPES
	printf("%s\n", perlTypeName);
#endif
	
	return perlTypeName;
}

int gtnumber_for_ptname(char * perlTypeName)
{
	dTHR;

	SV ** result;
	int gtkTypeNumber;

#ifdef DEBUG_TYPES
	printf("gtnumber_for_ptname(%s) =", perlTypeName);
#endif
	
	/*if (!ptname_by_gtnumber)*/
	if (!gtnumber_by_ptname)
		result = 0;
	else
		result = hv_fetch(gtnumber_by_ptname, perlTypeName, strlen(perlTypeName), 0);

	if (!result || !SvOK(*result)) {
		char * gtkTypeName;
		gtkTypeInitFunc tif;

		/* Type we haven't seen yet */
					
		if (!ptname_by_gtname || !gtinit_by_gtname) /* Weird */
			return 0;
		
		result = hv_fetch(gtname_by_ptname, perlTypeName, strlen(perlTypeName), 0);
		
		if (!result || !SvOK(*result)) /* Weird */
			return 0; 
		
		gtkTypeName = SvPV(*result, PL_na);
		
		result = hv_fetch(gtinit_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
		
		if (!result || !SvOK(*result)) /* Weird */
			return 0; 
		
		tif = (gtkTypeInitFunc)SvIV(*result);

		gtkTypeNumber = tif();

		complete_types(gtkTypeNumber, perlTypeName, 0);
		/* no more needed */
		hv_delete(gtinit_by_gtname, gtkTypeName, strlen(gtkTypeName), G_DISCARD);
	} else
		gtkTypeNumber = SvIV(*result);

#ifdef DEBUG_TYPES
	printf("%d\n", gtkTypeNumber);
#endif
	
	return gtkTypeNumber;
}

int gtnumber_for_gtname(char * gtkTypeName)
{
	SV ** result;
	int gtkTypeNumber;
	
#ifdef DEBUG_TYPES
	printf("gtnumber_for_gtname(%s) =", gtkTypeName);
#endif
	
	gtkTypeNumber = gtk_type_from_name(gtkTypeName);
	
	if (!gtkTypeNumber) {
		char * perlTypeName;
		gtkTypeInitFunc tif;

		/* Type we haven't seen yet */
		
		if (!gtinit_by_gtname)
			return 0;
					
		result = hv_fetch(gtinit_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
		
		if (!result || !SvOK(*result)) /* Weird */
			return 0; 
		
		tif = (gtkTypeInitFunc)SvIV(*result);

		gtkTypeNumber = tif();

		result = hv_fetch(ptname_by_gtname, gtkTypeName, strlen(gtkTypeName), 0);
		
		if (!result || !SvOK(*result)) /* Weird */
			return 0; 

		complete_types(gtkTypeNumber, 0, *result);

	} 

#ifdef DEBUG_TYPES
	printf("%d\n", gtkTypeNumber);
#endif

	return gtkTypeNumber;
}

void UnregisterGtkObject(SV * sv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();
	
	/*printf("Unregistering PO %x/%d from GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
	
	hv_delete(ObjectCache, buffer, strlen(buffer), G_DISCARD);
}

void RegisterGtkObject(SV * sv_object, GtkObject * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();
	
	/*printf("Registering PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/

	hv_store(ObjectCache, buffer, strlen(buffer), newRV((SV*)sv_object), 0);
}

SV * RetrieveGtkObject(GtkObject * gtk_object)
{
	char buffer[40];
	SV ** s;
	SV * sv_object;
	sprintf(buffer, "%lu", (unsigned long)gtk_object);

	if (!ObjectCache)
		ObjectCache = newHV();

	s = hv_fetch(ObjectCache, buffer, strlen(buffer), 0);
	
	if (s) {
		sv_object = (SV*)SvRV(*s);
		/*printf("Retrieving PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
		return sv_object;
	} else
		return 0;

}

/* Check a single PO to see whether it should be garbage collected */
int GCHVObject(HV * hv_object) {
	SV ** found;
	GtkObject * gtk_object;
	found = hv_fetch(hv_object, "_gtk", 4, 0);
	if (!found || !SvOK(*found))
		return 0;
	gtk_object = (GtkObject*)SvIV(*found);

	/*printf("Checking PO %x/%d vs GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
	if ((gtk_object->ref_count == 1) && (SvREFCNT(hv_object) == 1)) {
		/*printf("Derefing PO in GC\n");*/
		UnregisterGtkObject((SV*)hv_object, gtk_object);
		return 1;
	}
	return 0;

} 

/* Check all objects to see whether they should be collected */
int GCGtkObjects(void) {
  if (ObjectCache)
    {
      int count = 0;
      int dead = 0;
      HE *iter;
      /*printf("Starting GC\n");*/
      hv_iterinit (ObjectCache);
      while ((iter = hv_iternext (ObjectCache)))
        {
          SV * o = HeVAL(iter);
          HV * hv_object;
          SV ** found;
          GtkObject * gtk_object;
          
	if (!o || !SvOK(o) || !(hv_object=(HV*)SvRV(o)) || (SvTYPE(hv_object) != SVt_PVHV))
		continue;
	if (GCHVObject(hv_object))
		dead++;

          count++;
        }
            /*fprintf(stderr, "GC done, Count: %d; Dead %d\n", count, dead); */
	    return dead;
    }
    return 0;
}

int gc_during_idle = 0;

static void GCDuringIdle(void);

static int IdleGC(gpointer data) {
	HV * hv_object = data;
	
	/*printf("IdleGC PO %p\n", hv_object);*/
	
	if (data) {
	
		/* If we are GCing a specific object, stop all GC if we
		   can't clean it up, so we don't loop forever. */
		   
		if (GCHVObject(hv_object))
			gc_during_idle = gtk_idle_add(IdleGC, 0);
		else
			gc_during_idle = 0;
		return 0;
	}
	
	/* If we can free up some objects, this will return non-zero,
	   causing the idle function to be repeated. This will cause the GC
	   to be repeated until no more objects can be freed */
	   
	if (GCGtkObjects())
		return 1;

	gc_during_idle = 0;
	return 0;
}

static int TimeoutGC(gpointer data) {

	/* GC, and if we collected anything, loop during idle to unravel
	   everything */
	
	if (GCGtkObjects())
		GCDuringIdle();
	
	return 1;
}


static void GCDuringIdle(void) {
#ifdef TRY_MM
	if (!gc_during_idle)
		gc_during_idle = gtk_idle_add(IdleGC, 0);
#endif
}

static void GCAfterTimeout(void) {
	static int gc_after_timeout=0;
#ifdef TRY_MM
	if (!gc_after_timeout)
		gc_after_timeout = gtk_timeout_add(9237, TimeoutGC, 0);
#endif
}

static void DestroyGtkObject(GtkObject * gtk_object, gpointer data)
{
#ifdef TRY_MM
	HV * hv_object = (HV*)data;
	
	/*printf("DestroyGtkObject (1) called on PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/

	if (!SvREFCNT(hv_object)) {
		/* FIXME: */
		/*char *lab=NULL;
		gtk_label_get(GTK_LABEL(gtk_object), &lab);
		printf("tryed to destroy dead PO: %s %s\n", gtk_widget_get_name(gtk_object), lab);*/
		return;
	}
	GCHVObject(hv_object);
	
	GCDuringIdle();

	/*printf("DestroyGtkObject (2) called on PO %x/%d for GO %x/%d\n", hv_object, SvREFCNT(hv_object), gtk_object, gtk_object->ref_count);*/
#endif	
}

/* Called when a GTK object is being free'd. Free up its Perl object, if it
   hasn't been already. */

static void FreeGtkObject(gpointer data)
{
#ifdef TRY_MM
	HV * hv_object = (HV*)data;
	SV ** r;
	GCDuringIdle();
	/*printf("FreeGtkObject of (PO %p/%d) \n", hv_object, SvREFCNT(hv_object));*/
	if (!SvREFCNT(hv_object)) {
		/* FIXME: printf("tryed to destroy dead PO\n");*/
		return;
	}
	r = hv_fetch(hv_object, "_gtk", 4, 0);
	if (r && SvIV(*r)) {
		GtkObject * gtk_object = (GtkObject*)SvIV(*r);
		/*printf("GO %p/%d\n", gtk_object, gtk_object->ref_count);*/
		
		if (gtk_object_get_data(gtk_object,"_perl")) {
			/*printf("Unrefing PO %p/%d\n", hv_object, SvREFCNT(hv_object));*/
			gtk_object_remove_data(gtk_object, "_perl");
			UnregisterGtkObject((SV*)hv_object, gtk_object);
		} /*else
			printf("PO already unlinked\n");*/
		
	}/* else
		printf("No GO\n");*/
#endif
}

/* Called when a Perl object is being free'd. Free up its GTK object, if it
   hasn't been already. */

void FreeHVObject(HV * hv_object)
{
#ifdef TRY_MM
	SV ** r;
	r = hv_fetch(hv_object, "_gtk", 4, 0);
	GCDuringIdle();
	/*printf("FreeHVObject of PO %p/%d\n", hv_object, SvREFCNT(hv_object));*/
	if (r && SvIV(*r)) {
		GtkObject * gtk_object = (GtkObject*)SvIV(*r);
		hv_delete(hv_object, "_gtk", 4, G_DISCARD);
		
		if (gtk_object_get_data(gtk_object, "_perl")) {
			/*printf("Unrefing GO %p/%d\n", gtk_object, gtk_object->ref_count);*/
			gtk_object_unref(gtk_object);
			return;
		}
	}
	/*printf("Skipping FreeHVObject, as Gtk object is already free'd\n");*/
#endif
}


SV * newSVGtkObjectRef(GtkObject * object, char * classname)
{
	HV * previous;
	SV * result;
	if (!object)
		return newSVsv(&PL_sv_undef);
	previous = (HV*)RetrieveGtkObject(object);
	if (previous) {
		return newRV((SV*)previous);
#if 0
		result = newRV((SV*)previous);
		/* FIXME: check classname of previous */
		if (classname)
			sv_bless(result, gv_stashpv(classname, FALSE));
		/*printf("Returning previous PO %p, referencing GO %p\n", previous, object);*/
#endif
	} else {
		HV * h;
		SV * s;

		if (!classname) {
			classname = ptname_for_gtnumber(object->klass->type);
			if (!classname) {
				GtkType type = object->klass->type;
				
				/* OK, we weren't able to find a perl type to exactly the Gtk
				   object type. Maybe a parent of the Gtk type will work? */
				
				while (!classname && (type = gtk_type_parent(type)))
					classname = ptname_for_gtnumber(type);
				
				if (classname)
					warn("unable to directly represent GtkObject 0x%x of type %d (%s) as a "
					"Perl/Gtk type, using parent Gtk type %d (%s) instead",
					object, object->klass->type, gtk_type_name(object->klass->type),
					type, gtk_type_name(type));
			}
			if (!classname)
				croak("unable to convert GtkObject 0x%x of type %d (%s) into a Perl/Gtk type",
					object, object->klass->type, gtk_type_name(object->klass->type));
		} else {
			/* Ouch. This test is expensive but necessary to make sure that
			   a "fast" known-type import doesn't refer to an object type
			   that doesn't exist yet. */
			if (!gtnumber_for_ptname(classname)) 
				croak("unable to convert GtkObject 0x%x of type %d (%s) into a Perl/Gtk type",
					object, object->klass->type, gtk_type_name(object->klass->type));
		}

		h = newHV();
		s = newSViv((long)object);
		hv_store(h, "_gtk", 4, s, 0);
		result = newRV((SV*)h);
		RegisterGtkObject((SV*)h, object);
		gtk_object_ref(object);
		gtk_signal_connect(object, "destroy", (GtkSignalFunc)DestroyGtkObject, (gpointer)h);
		gtk_object_set_data_full(object, "_perl", h, FreeGtkObject);
		sv_bless(result, gv_stashpv(classname, FALSE));
		SvREFCNT_dec(h);
		GCAfterTimeout();
		/*printf("Creating new PO %p/%d referencing GO %p/%d\n", h, SvREFCNT(h), object, object->ref_count);*/
	}
	return result;
}

GtkObject * SvGtkObjectRef(SV * o, char * name)
{
	HV * q;
	SV ** r;
	if (!o || !SvROK(o) || !(q=(HV*)SvRV(o)) || (SvTYPE(q) != SVt_PVHV))
		return 0;
	if (name && !PerlGtk_sv_derived_from(o, name))
		croak("variable is not of type %s", name);
	r = hv_fetch(q, "_gtk", 4, 0);
	if (!r || !SvIV(*r))
		croak("variable is damaged %s", name);
	return (GtkObject*)SvIV(*r);
}

static void menu_callback (GtkWidget *widget, gpointer user_data)
{
	SV * handler = (SV*)user_data;
	int i;
	dSP;

	PUSHMARK(sp);
	
	if (SvRV(handler) && (SvTYPE(SvRV(handler)) == SVt_PVAV)) {
		AV * args = (AV*)SvRV(handler);
		handler = *av_fetch(args, 0, 0);
		for(i=1;i<=av_len(args);i++)
			XPUSHs(sv_2mortal(newSVsv(*av_fetch(args,i,0))));
	}

	XPUSHs(sv_2mortal(newSVGtkObjectRef(GTK_OBJECT(widget), 0)));
	PUTBACK;

	i = perl_call_sv(handler, G_DISCARD);
}

GtkMenuEntry * SvGtkMenuEntry(SV * data, GtkMenuEntry * e)
{
	dTHR;

	HV * h;
	SV ** s;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
	
	if (!e)
		e = alloc_temp(sizeof(GtkMenuEntry));

	h = (HV*)SvRV(data);
	
	if ((s=hv_fetch(h, "path", 4, 0)) && SvOK(*s))
		e->path = SvPV(*s,PL_na);
	else
		e->path = 0;
		/*croak("menu entry must contain path");*/
	if ((s=hv_fetch(h, "accelerator", 11, 0)) && SvOK(*s))
		e->accelerator = SvPV(*s, PL_na);
	else
		e->accelerator = 0;
		/*croak("menu entry must contain accelerator");*/
	if ((s=hv_fetch(h, "widget", 6, 0)) && SvOK(*s))
		e->widget =  (s && SvOK(*s)) ? GTK_WIDGET(SvGtkObjectRef(*s, "Gtk::Widget")) : NULL;
	else
		e->widget = 0;
		/*croak("menu entry must contain widget");*/
	if ((s=hv_fetch(h, "callback", 8, 0)) && SvOK(*s)) {
		e->callback = menu_callback;
		e->callback_data = newSVsv(*s);
	}
	else {
		e->callback = 0;
		e->callback_data = 0;
		/*croak("menu entry must contain callback");*/
	}

	return e;
}

SV * newSVGtkMenuEntry(GtkMenuEntry * e)
{
	dTHR;

	HV * h;
	SV * r;
	
	if (!e)
		return &PL_sv_undef;
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);
	
	hv_store(h, "path", 4, e->path ? newSVpv(e->path,0) : newSVsv(&PL_sv_undef), 0);
	hv_store(h, "accelerator", 11, e->accelerator ? newSVpv(e->accelerator,0) : newSVsv(&PL_sv_undef), 0);
	hv_store(h, "widget", 6, e->widget ? newSVGtkObjectRef(GTK_OBJECT(e->widget), 0) : newSVsv(&PL_sv_undef), 0);
	hv_store(h, "callback", 11, 
		((e->callback == menu_callback) && e->callback_data) ?
		newSVsv(e->callback_data) :
		newSVsv(&PL_sv_undef)
		, 0);
	
	return r;
}

SV * newSVGtkSelectionDataRef(GtkSelectionData * w) { return newSVMiscRef(w, "Gtk::SelectionData",0); }
GtkSelectionData * SvGtkSelectionDataRef(SV * data) { return SvMiscRef(data, "Gtk::SelectionData"); }

GtkType FindArgumentTypeWithObject(GtkObject * object, SV * name, GtkArg * result) {
	return FindArgumentTypeWithClass(object->klass, name, result);
}

GtkType FindArgumentTypeWithClass(GtkObjectClass * klass, SV * name, GtkArg * result) {
	dTHR;
	char * argname = SvPV(name, PL_na);
	GtkType t = GTK_TYPE_INVALID;

	/* Strip the ticklish dash:
	
	   -foo => foo
	 */
	if (argname[0] == '-')
		argname++;
	
	/* Convert Perl naming convention to Gtk:
	 
	   Gtk::... => Gtk...
	 */
	if (strncmp(argname, "Gtk::", 5) == 0) {
		SV * work = sv_2mortal(newSVpv("Gtk", 3)); 
		sv_catpv(work, argname+5);
		argname = SvPV(work, PL_na);
	}

	/* Fix something that's hard to deal with, otherwise:
	
	   signal::... => GtkObject::signal:... 
	 */
	if (strncmp(argname, "signal::", 8) ==0) {
		SV * work = sv_2mortal(newSVpv("GtkObject::", 11)); 
		sv_catpv(work, argname);
		argname = SvPV(work, PL_na);
	}

	/* If there isn't a class included, try the object class,
	   and then its parents, until a match is found:
	   
	   foo => GtkSomeType::foo 
	 */
#ifdef GTK_1_0
	if (!strchr(argname, ':') || ((t = gtk_object_get_arg_type(argname)) == GTK_TYPE_INVALID)) {
		SV * work = sv_2mortal(newSVsv(&PL_sv_undef)); 
		GtkType pt;
		/* Try appending the arg name to the class name */
		for(pt = klass->type;pt;pt = gtk_type_parent(pt)) {
			sv_setpv(work, gtk_type_name(pt));
			sv_catpv(work, "::");
			sv_catpv(work, argname);

			if ((t = gtk_object_get_arg_type(SvPV(work, PL_na))) != GTK_TYPE_INVALID) {
				argname = SvPV(work, PL_na);
				break;
			}
			/* And if that didn't work, try the parent class */
		}
	}
	
	if (t == GTK_TYPE_INVALID) {
		SV * work = sv_2mortal(newSVpv("GtkObject::signal::", 0));
		/* Last resort, try it as a signal name */
		sv_catpv(work, argname);
		argname = SvPV(work, PL_na);
		
		t = gtk_object_get_arg_type(argname); /* Useless, always succeeds */
	}
#else
        {       
                GtkArgInfo *info=NULL;
                char* error;
                error = gtk_object_arg_get_info(klass->type, argname, &info);
                if ( error ) {
                        SV * work = sv_2mortal(newSVpv("GtkObject::signal::", 0));
                        sv_catpv(work, argname);
                        argname = SvPV(work, PL_na);
                        g_free(gtk_object_arg_get_info(klass->type, argname, &info));

                }
                if ( info )
                        t = info->type;
                else {
                        g_warning("%s", error);
                        g_free(error);
                }
        }
#endif

	if (t == GTK_TYPE_SIGNAL) {
	
		/* Gtk will say anything is a signal, regardless of
		   whether it is or not. Actually look up the signal
		   to verify that it exists */
	
		int id;
		char * a = argname;
		if (strnEQ(a, "GtkObject::", 11))
			a += 11;
		if (strnEQ(a, "signal::", 8))
			a += 8;
		id = gtk_signal_lookup(a, klass ? klass->type : 0);
		if (!id)
			t = GTK_TYPE_INVALID;
	}

	if (t == GTK_TYPE_INVALID)
		croak("Unknown argument %s of %s", SvPV(name,PL_na), 0 ? "(none)" : gtk_type_name(klass->type));
	
	result->name = argname;
	result->type = t;
	
	return t;
}


struct PerlGtkTypeHelper * PerlGtkTypeHelpers = 0;

void AddTypeHelper(struct PerlGtkTypeHelper * n)
{
	struct PerlGtkTypeHelper * h = PerlGtkTypeHelpers;
	
	if (!n)
		return;

	n->next = 0;
	if (!h) {
		PerlGtkTypeHelpers = n;
		return;
	}
	
	while (h->next)
		h = h->next;

	h->next = n;
}

SV * GtkGetArg(GtkArg * a)
{
	SV * result = 0;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_CHAR:	result = newSViv(GTK_VALUE_CHAR(*a)); break;
		case GTK_TYPE_BOOL:	result = newSViv(GTK_VALUE_BOOL(*a)); break;
		case GTK_TYPE_INT:	result = newSViv(GTK_VALUE_INT(*a)); break;
		case GTK_TYPE_UINT:	result = newSViv(GTK_VALUE_UINT(*a)); break;
		case GTK_TYPE_LONG:	result = newSViv(GTK_VALUE_LONG(*a)); break;
		case GTK_TYPE_ULONG:	result = newSViv(GTK_VALUE_ULONG(*a)); break;
		case GTK_TYPE_FLOAT:	result = newSVnv(GTK_VALUE_FLOAT(*a)); break;	
		case GTK_TYPE_DOUBLE:	result = newSVnv(GTK_VALUE_DOUBLE(*a)); break;	
		case GTK_TYPE_STRING:	result = GTK_VALUE_STRING(*a) ? newSVpv(GTK_VALUE_STRING(*a),0) : newSVsv(&PL_sv_undef); break;
		case GTK_TYPE_OBJECT:	result = newSVGtkObjectRef(GTK_VALUE_OBJECT(*a), 0); break;
		case GTK_TYPE_SIGNAL:
		{
			AV * args = (AV*)GTK_VALUE_SIGNAL(*a).d;
			SV ** s;
			if ((GTK_VALUE_SIGNAL(*a).f != 0) ||
				(!args) ||
				(SvTYPE(args) != SVt_PVAV) ||
				(av_len(args) < 3) ||
				!(s = av_fetch(args, 2, 0))
				)
				croak("Unable to return a foreign signal type to Perl");

			result = newSVsv(*s);
			break;
		}
		case GTK_TYPE_ENUM:
			break;
		case GTK_TYPE_FLAGS:
			break;
		case GTK_TYPE_POINTER:
#if 0
			if (a->type == GTK_TYPE_POINTER_CHAR)
				result = newSViv(*GTK_RETLOC_CHAR(*a));
			else
			if (a->type == GTK_TYPE_POINTER_BOOL)
				result = newSViv(*GTK_RETLOC_BOOL(*a));
			else
			if (a->type == GTK_TYPE_POINTER_INT)
				result = newSViv(*GTK_RETLOC_INT(*a));
			else
			if (a->type == GTK_TYPE_POINTER_UINT)
				result = newSViv(*GTK_RETLOC_UINT(*a));
			else
			if (a->type == GTK_TYPE_POINTER_LONG)
				result = newSViv(*GTK_RETLOC_LONG(*a));
			else
			if (a->type == GTK_TYPE_POINTER_ULONG)
				result = newSViv(*GTK_RETLOC_ULONG(*a));
			else
			if (a->type == GTK_TYPE_POINTER_FLOAT)
				result = newSVnv(*GTK_RETLOC_FLOAT(*a));
			else
			if (a->type == GTK_TYPE_POINTER_DOUBLE)
				result = newSVnv(*GTK_RETLOC_DOUBLE(*a));
			else
			if (a->type == GTK_TYPE_POINTER_STRING)
				result = *GTK_RETLOC_STRING(*a) ? newSVpv(*GTK_RETLOC_STRING(*a), 0) : newSVsv(&PL_sv_undef);
			else
			if (a->type == GTK_TYPE_POINTER_OBJECT)
				result = newSVGtkObjectRef(*GTK_RETLOC_OBJECT(*a));
			else
#endif
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				result = newSVGdkEvent(GTK_VALUE_BOXED(*a));
			else if (a->type == GTK_TYPE_GDK_COLOR)
				result = newSVGdkColor(GTK_VALUE_BOXED(*a));
			else
				break;
	}
	
	if (result)
		return result;
	{
		struct PerlGtkTypeHelper * h = PerlGtkTypeHelpers;
		while (!result && h) {
			if (h->GtkGetArg_f && (result = h->GtkGetArg_f(a)))
				return result;
			h = h->next;
		}
	}
	
	/* this can go before the typehelpers once the silly gtk warning is removed */
	if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_ENUM)
		result = newSVDefEnumHash(a->type, GTK_VALUE_ENUM(*a));
	else if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_FLAGS)
		result = newSVDefFlagsHash(a->type, GTK_VALUE_FLAGS(*a));

	if (!result)
		croak("Cannot set argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));

	return result;
}

void GtkSetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object)
{
	dTHR;

	int result = 1;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_CHAR:		GTK_VALUE_CHAR(*a) = SvIV(v); break;
		case GTK_TYPE_BOOL:		GTK_VALUE_BOOL(*a) = SvIV(v); break;
		case GTK_TYPE_INT:		GTK_VALUE_INT(*a) = SvIV(v); break;
		case GTK_TYPE_UINT:		GTK_VALUE_UINT(*a) = SvIV(v); break;
		case GTK_TYPE_LONG:		GTK_VALUE_LONG(*a) = SvIV(v); break;
		case GTK_TYPE_ULONG:	GTK_VALUE_ULONG(*a) = SvIV(v); break;
		case GTK_TYPE_FLOAT:	GTK_VALUE_FLOAT(*a) = SvNV(v); break;	
		case GTK_TYPE_DOUBLE:	GTK_VALUE_DOUBLE(*a) = SvNV(v); break;	
		case GTK_TYPE_STRING:	GTK_VALUE_STRING(*a) = g_strdup(SvPV(v,PL_na)); break;
		case GTK_TYPE_OBJECT:	GTK_VALUE_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object"); break;
		case GTK_TYPE_SIGNAL:
		{
			AV * args;
			int i,j;
			int type;
			char * c = strchr(a->name, ':');
			c+=2;
			c = strchr(c, ':');
			c += 2;
			args = newAV();

			type = gtk_signal_lookup(c, Object->klass->type);

			av_push(args, newSVsv(Class));
			av_push(args, newSVpv(c, 0));
			av_push(args, newSViv(type));
			
			PackCallback(args, v);
			/*av_push(args, newSVsv(v));*/

			GTK_VALUE_SIGNAL(*a).f = 0;
			GTK_VALUE_SIGNAL(*a).d = args;
			break;
		}
		case GTK_TYPE_POINTER:
#if 0
			if (a->type == GTK_TYPE_POINTER_CHAR)
				*GTK_RETLOC_CHAR(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_BOOL)
				*GTK_RETLOC_BOOL(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_INT)
				*GTK_RETLOC_INT(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_UINT)
				*GTK_RETLOC_UINT(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_LONG)
				*GTK_RETLOC_LONG(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_ULONG)
				*GTK_RETLOC_ULONG(*a) = SvIV(v);
			else
			if (a->type == GTK_TYPE_POINTER_FLOAT)
				*GTK_RETLOC_FLOAT(*a) = SvNV(v);
			else
			if (a->type == GTK_TYPE_POINTER_DOUBLE)
				*GTK_RETLOC_DOUBLE(*a) = SvNV(v);
			else
			if (a->type == GTK_TYPE_POINTER_STRING)
				*GTK_RETLOC_STRING(*a) = SvPV(v, PL_na);
			else
			if (a->type == GTK_TYPE_POINTER_OBJECT)
				*GTK_RETLOC_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object");
			else
#endif
			result = 0;
			break;
		case GTK_TYPE_ENUM:
			result = 0;
			break;
		case GTK_TYPE_FLAGS:
			result = 0;
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				GTK_VALUE_BOXED(*a) = SvGdkEvent(v);
			else if (a->type == GTK_TYPE_GDK_COLOR)
				GTK_VALUE_BOXED(*a) = SvGdkColor(v);
			else
				result = 0;
			break;
		default:
			result = 0;
	}

	if (result)
		return;
	{
		struct PerlGtkTypeHelper * h = PerlGtkTypeHelpers;
		while (!result && h) {
			if (h->GtkSetArg_f && (result = h->GtkSetArg_f(a, v, Class, Object)))
				return;
			h = h->next;
		}
	}

	/* this can go before the typehelpers once the silly gtk warning is removed */
	if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_ENUM) {
		result = 1;
		GTK_VALUE_ENUM(*a) = SvDefEnumHash(a->type, v);
	} else if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_FLAGS) {
		result = 1;
		GTK_VALUE_FLAGS(*a) = SvDefFlagsHash(a->type, v);
	}

	if (!result)
		croak("Cannot set argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
}

void GtkSetRetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object)
{
	dTHR;

	int result = 1;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_CHAR:		*GTK_RETLOC_CHAR(*a) = SvIV(v); break;
		case GTK_TYPE_BOOL:		*GTK_RETLOC_BOOL(*a) = SvIV(v); break;
		case GTK_TYPE_INT:		*GTK_RETLOC_INT(*a) = SvIV(v); break;
		case GTK_TYPE_UINT:		*GTK_RETLOC_UINT(*a) = SvIV(v); break;
		case GTK_TYPE_LONG:		*GTK_RETLOC_LONG(*a) = SvIV(v); break;
		case GTK_TYPE_ULONG:	*GTK_RETLOC_ULONG(*a) = SvIV(v); break;
		case GTK_TYPE_FLOAT:	*GTK_RETLOC_FLOAT(*a) = SvNV(v); break;	
		case GTK_TYPE_DOUBLE:	*GTK_RETLOC_DOUBLE(*a) = SvNV(v); break;	
		case GTK_TYPE_STRING:	*GTK_RETLOC_STRING(*a) = SvPV(v,PL_na); break;
		case GTK_TYPE_OBJECT:	*GTK_RETLOC_OBJECT(*a) = SvGtkObjectRef(v, "Gtk::Object"); break;
		case GTK_TYPE_ENUM:
			result = 0;
			break;
		case GTK_TYPE_FLAGS:
			result = 0;
			break;
		case GTK_TYPE_POINTER:
			result = 0;
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				*GTK_RETLOC_BOXED(*a) = SvGdkEvent(v);
			else if (a->type == GTK_TYPE_GDK_COLOR)
				*GTK_RETLOC_BOXED(*a) = SvGdkColor(v);
			else
				result = 0;
			break;
		default:
			result = 0;
	}
	
	if (result)
		return;
	{
		struct PerlGtkTypeHelper * h = PerlGtkTypeHelpers;
		while (!result && h) {
			if (h->GtkSetRetArg_f && (result = h->GtkSetRetArg_f(a, v, Class, Object)))
				return;
			h = h->next;
		}
		
	}

	/* this can go before the typehelpers once the silly gtk warning is removed */
	if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_ENUM) {
		result = 1;
		*GTK_RETLOC_ENUM(*a) = SvDefEnumHash(a->type, v);
	} else if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_FLAGS) {
		result = 1;
		*GTK_RETLOC_FLAGS(*a) = SvDefFlagsHash(a->type, v);
	}

	if (!result)
		croak("Cannot set argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
}

SV * GtkGetRetArg(GtkArg * a)
{
	SV * result = 0;
	switch (GTK_FUNDAMENTAL_TYPE(a->type)) {
		case GTK_TYPE_NONE:		result = newSVsv(&PL_sv_undef); break;
		case GTK_TYPE_CHAR:		result = newSViv(*GTK_RETLOC_CHAR(*a)); break;
		case GTK_TYPE_BOOL:		result = newSViv(*GTK_RETLOC_BOOL(*a)); break;
		case GTK_TYPE_INT:		result = newSViv(*GTK_RETLOC_INT(*a)); break;
		case GTK_TYPE_UINT:		result = newSViv(*GTK_RETLOC_UINT(*a)); break;
		case GTK_TYPE_LONG:		result = newSViv(*GTK_RETLOC_LONG(*a)); break;
		case GTK_TYPE_ULONG:	result = newSViv(*GTK_RETLOC_ULONG(*a)); break;
		case GTK_TYPE_FLOAT:	result = newSVnv(*GTK_RETLOC_FLOAT(*a)); break;	
		case GTK_TYPE_DOUBLE:	result = newSVnv(*GTK_RETLOC_DOUBLE(*a)); break;	
		case GTK_TYPE_STRING:	result = newSVpv(*GTK_RETLOC_STRING(*a),0); break;
		case GTK_TYPE_OBJECT:	result = newSVGtkObjectRef(GTK_VALUE_OBJECT(*a), 0); break;
		case GTK_TYPE_ENUM:
			break;
		case GTK_TYPE_FLAGS:
			break;
		case GTK_TYPE_POINTER:
			break;
		case GTK_TYPE_BOXED:
			if (a->type == GTK_TYPE_GDK_EVENT)
				result = newSVGdkEvent(*GTK_RETLOC_BOXED(*a));
			else if (a->type == GTK_TYPE_GDK_COLOR)
				result = newSVGdkColor(*GTK_RETLOC_BOXED(*a));
			break;			
	}
	
	
	if (result)
		return result;
	{
		struct PerlGtkTypeHelper * h = PerlGtkTypeHelpers;
		while (!result && h) {
			if (h->GtkGetRetArg_f && (result = h->GtkGetRetArg_f(a)))
				return result;
			h = h->next;
		}
		
	}

	/* this can go before the typehelpers once the silly gtk warning is removed */
	if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_ENUM)
		result = newSVDefEnumHash(a->type, *GTK_RETLOC_ENUM(*a));
	else if (GTK_FUNDAMENTAL_TYPE(a->type) == GTK_TYPE_FLAGS)
		result = newSVDefFlagsHash(a->type, *GTK_RETLOC_FLAGS(*a));

	if (!result)
		croak("Cannot get return argument of type %s (fundamental type %s)", gtk_type_name(a->type), gtk_type_name(GTK_FUNDAMENTAL_TYPE(a->type)));
	
	return result;
}

void GtkFreeArg(GtkArg * a)
{
	int result = 0;
	
	struct PerlGtkTypeHelper * h = PerlGtkTypeHelpers;
	while (!result && h) {
		if (h->GtkFreeArg_f)
			result = h->GtkFreeArg_f(a);
		h = h->next;
	}
	
}

#if GTK_HVER > 0x010200

GdkGeometry* SvGdkGeometry (SV* data) {
	HV * h;
	SV **s;
	GdkGeometry *g;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV))
		return 0;
		
	h = (HV*)SvRV(data);

	g = alloc_temp(sizeof(GdkGeometry));
	memset(g, 0, sizeof(GdkGeometry));
	/* FIXME */

	if ((s=hv_fetch(h, "min_width", 9, 0)) && SvOK(*s)) {
		g->min_width = SvIV(*s);
	}
	if ((s=hv_fetch(h, "min_height", 10, 0)) && SvOK(*s)) {
		g->min_height = SvIV(*s);
	}
	if ((s=hv_fetch(h, "max_width", 9, 0)) && SvOK(*s)) {
		g->max_width = SvIV(*s);
	}
	if ((s=hv_fetch(h, "max_height", 10, 0)) && SvOK(*s)) {
		g->max_height = SvIV(*s);
	}
	if ((s=hv_fetch(h, "base_width", 10, 0)) && SvOK(*s)) {
		g->base_width = SvIV(*s);
	}
	if ((s=hv_fetch(h, "base_height", 11, 0)) && SvOK(*s)) {
		g->base_height = SvIV(*s);
	}
	if ((s=hv_fetch(h, "width_inc", 9, 0)) && SvOK(*s)) {
		g->width_inc = SvIV(*s);
	}
	if ((s=hv_fetch(h, "height_inc", 10, 0)) && SvOK(*s)) {
		g->height_inc = SvIV(*s);
	}
	if ((s=hv_fetch(h, "min_aspect", 10, 0)) && SvOK(*s)) {
		g->min_aspect = SvNV(*s);
	}
	if ((s=hv_fetch(h, "max_aspect", 10, 0)) && SvOK(*s)) {
		g->max_aspect = SvNV(*s);
	}
	return g;
}

GtkTargetEntry *
SvGtkTargetEntry(SV * data) {
	HV * h;
	AV * a;
	SV ** s;
	STRLEN len;
	GtkTargetEntry * e;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || 
			(SvTYPE(SvRV(data)) != SVt_PVHV && SvTYPE(SvRV(data)) != SVt_PVAV))
		return NULL;
	e = alloc_temp(sizeof(GtkTargetEntry));
	memset(e,0,sizeof(GtkTargetEntry));

	if (SvTYPE(SvRV(data)) == SVt_PVHV) {
		h = (HV*)SvRV(data);
		if ((s=hv_fetch(h, "target", 6, 0)) && SvOK(*s))
			e->target = SvPV(*s, len);
		if ((s=hv_fetch(h, "flags", 5, 0)) && SvOK(*s))
			e->flags = SvUV(*s);
		if ((s=hv_fetch(h, "info", 5, 0)) && SvOK(*s))
			e->info = SvUV(*s);
	} else {
		a = (AV*)SvRV(data);
		if ((s=av_fetch(a, 0, 0)) && SvOK(*s))
			e->target = SvPV(*s, len);
		if ((s=av_fetch(a, 1, 0)) && SvOK(*s))
			e->flags = SvUV(*s);
		if ((s=av_fetch(a, 2, 0)) && SvOK(*s))
			e->info = SvUV(*s);
	}
	return e;
}

SV*
newSVGtkTargetEntry (GtkTargetEntry* e) {
	dTHR;

	HV * h;
	SV * r;
	
	if (!e)
		return &PL_sv_undef;
		
	h = newHV();
	r = newRV((SV*)h);
	SvREFCNT_dec(h);
	
	hv_store(h, "target", 6, e->target ? newSVpv(e->target,0) : newSVsv(&PL_sv_undef), 0);
	hv_store(h, "flags", 5, newSViv(e->flags), 0);
	hv_store(h, "info", 5, newSViv(e->info), 0);
	
	return r;

}
#endif
