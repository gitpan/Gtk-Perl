
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

#undef DEBUG_TYPES

#ifdef GTK_HAVE_SIGNAL_INIT
#define GTK_HAVE_SIGNAL_EMITV
#endif

void destroy_handler(gpointer data);
void generic_handler(GtkObject * object, gpointer data, guint n_args, GtkArg * args);
void generic_handler_wo(GtkObject * object, gpointer data, guint n_args, GtkArg * args);

static void generic_perl_gtk_signal_marshaller(GtkObject * object, GtkSignalFunc func, gpointer func_data, GtkArg * args)
{
	croak("Unable to marshal C signals from Gtk class defined in Perl");
}

static void generic_perl_gtk_arg_get_func(GtkObject * object, GtkArg * arg, guint arg_id)
{
	SV * s = newSVGtkObjectRef(object, 0);
	int count;
	dSP;

	if (!s) {
		fprintf(stderr, "Object is not of registered type\n");
		return;
	}

	ENTER;
	SAVETMPS;
	
	PUSHMARK(sp);
	XPUSHs(sv_2mortal(s));
	XPUSHs(sv_2mortal(newSVpv(arg->name,0)));
	XPUSHs(sv_2mortal(newSViv(arg_id)));
	PUTBACK;
	count = perl_call_method("GTK_OBJECT_GET_ARG", G_SCALAR); 
	SPAGAIN;
	if (count != 1)
		croak("Big trouble\n");
	
	GtkSetArg(arg, POPs, s, object);
	
	PUTBACK;
	FREETMPS;
	LEAVE;
	
}

static void generic_perl_gtk_arg_set_func(GtkObject * object, GtkArg * arg, guint arg_id)
{
	SV * s = newSVGtkObjectRef(object, 0);
	dSP;

	if (!s) {
		fprintf(stderr, "Object is not of registered type\n");
		return;
	}

	PUSHMARK(sp);
	XPUSHs(sv_2mortal(s));
	XPUSHs(sv_2mortal(newSVpv(arg->name,0)));	
	XPUSHs(sv_2mortal(newSViv(arg_id)));
	XPUSHs(sv_2mortal(GtkGetArg(arg)));
	PUTBACK;
	perl_call_method("GTK_OBJECT_SET_ARG", G_DISCARD); 
	/* Errors are OK ! */
	
}

static void generic_perl_gtk_class_init(GtkObjectClass * klass)
{
	dSP;
	char * perlClass = ptname_for_gtnumber(klass->type);
	AV * signal_ids;
	SV * temp;
	int i;

	if (!perlClass) {
		fprintf(stderr, "Class is not registered\n");
		return;
	}

#ifdef DEBUG_TYPES	
	printf("Within generic class init\n");
#endif

#ifdef GTK_1_1
	klass->set_arg = (GtkArgGetFunc)generic_perl_gtk_arg_set_func;
	klass->get_arg = (GtkArgSetFunc)generic_perl_gtk_arg_get_func;
#endif


	PUSHMARK(sp);
	XPUSHs(sv_2mortal(newSVpv(perlClass, 0)));
	PUTBACK;
	perl_call_method("GTK_CLASS_INIT", G_DISCARD);

}

static void generic_perl_gtk_object_init(GtkObject * object, GtkObjectClass *klass)
{
	SV * s;
	dSP;
	char * func;
	CV *cv;

	s = newSVGtkObjectRef(object, ptname_for_gtnumber(klass->type));
	if (!s) {
		fprintf(stderr, "Object is not of registered type\n");
		return;
	}

	PUSHMARK(sp);
	/*XPUSHs(sv_2mortal(newSVpv(ptname_for_gtnumber(object->klass->type), 0)));*/
	XPUSHs(sv_2mortal(s));
	PUTBACK;
	func = g_strdup_printf("%s::GTK_OBJECT_INIT", ptname_for_gtnumber(object->klass->type));
	/*perl_call_method("GTK_OBJECT_INIT", G_DISCARD);*/
#ifdef DEBUG_TYPES	
	printf("Within generic object init (obj: %s, class: %s): %s\n", ptname_for_gtnumber(object->klass->type), ptname_for_gtnumber(klass->type), func);
#endif

	if ((cv=perl_get_cv(func, 0)))
		perl_call_sv((SV*)cv, G_DISCARD);
	g_free(func);	
}


void destroy_data(gpointer data)
{
	SvREFCNT_dec((SV*)data);
}


MODULE = Gtk::Object		PACKAGE = Gtk::Object		PREFIX = gtk_object_

#ifdef GTK_OBJECT

# FIXME: See if we need signal_connect_while_alive

int
signal_connect(object, event, handler, ...)
	Gtk::Object	object
	char *	event
	SV *	handler
	ALIAS:
		Gtk::Object::signal_connect = 0
		Gtk::Object::signal_connect_after = 1
	CODE:
	{
		AV * args;
		SV * arg;
		SV ** fixup;
		int i,j;
		int type;
		/*char num[20];
		void * fixupfunc = 0;*/
		args = newAV();
		
		type = gtk_signal_lookup(event, object->klass->type);
		
		if (!ix)
			i = gtk_signal_connect (GTK_OBJECT (object), event,
				NULL, (void*)args);
		else
			i = gtk_signal_connect_after (GTK_OBJECT (object), event,
				NULL, (void*)args);
		
				
		av_push(args, newRV_inc(SvRV(ST(0))));
		av_push(args, newSVsv(ST(1)));
		av_push(args, newSViv(type));
		
		PackCallbackST(args, 2);
		
		RETVAL = i;
	}
	OUTPUT:
	RETVAL

void
signal_disconnect(object, id)
	Gtk::Object	object
	int	id
	CODE:
	gtk_signal_disconnect(object, id);

void
signal_handlers_destroy(object)
	Gtk::Object	object
	CODE:
	gtk_signal_handlers_destroy(object);

char *
type_name(object)
	Gtk::Object	object
	CODE:
	RETVAL = gtk_type_name(GTK_OBJECT_TYPE(object));
	OUTPUT:
	RETVAL

SV *
get_user_data(object)
	Gtk::Object	object
	CODE:
	{
	    gpointer data = gtk_object_get_data(object, "_perl_user_data");
        RETVAL = newSVsv(data ? data : &PL_sv_undef);
	}
	OUTPUT:
	RETVAL

void
set_user_data(object, data)
	Gtk::Object	object
	SV *	data
	CODE:
	{
		if (!data || !SvOK(data))
			gtk_object_remove_data(object, "_perl_user_data");
		else
		    gtk_object_set_data_full(object, "_perl_user_data", newSVsv(data), destroy_data);
	}

Gtk::Object_Sink_Up
new_from_pointer(klass, pointer)
	SV *	klass
	unsigned long	pointer
	CODE:
	RETVAL = (GtkObject*)pointer;
	OUTPUT:
	RETVAL


unsigned long
_return_pointer(object)
	Gtk::Object	object
	CODE:
	RETVAL = (unsigned long)object;
	OUTPUT:
	RETVAL

void
DESTROY(object)
	SV *	object
	CODE:
	FreeHVObject((HV*)SvRV(ST(0)));

void
_get_arg_info(obj, name)
	Gtk::Object	obj
	SV * name
	PPCODE:
	{
		GtkArg argv;
		GtkType type;
		GtkArgInfo * arginfo = NULL;
		char* error;
		int klass = obj->klass->type;

		type = FindArgumentTypeWithObject(obj, name, &argv);
		error = gtk_object_arg_get_info(klass, argv.name, &arginfo);
		if (error) {
			g_warning("cannot get arg info: %s", error);
			g_free(error);
		} else {
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVpv(arginfo->full_name, 0)));
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVpv(ptname_for_gtnumber(arginfo->class_type), 0)));
			/* export more stuff here newSVGtkArgFlags() */
			EXTEND(sp, 1);
			PUSHs(sv_2mortal(newSVGtkArgFlags(arginfo->arg_flags)));
		}
	}

void
set(object, name, value, ...)
	Gtk::Object	object
	SV *	name
	SV *	value
	CODE:
	{
		GtkType t;
		GtkArg	argv[3];
		int p;
		int argc;
		
		for(p=1;p<items;) {
		
			if ((p+1)>=items)
				croak("too few arguments");
				
			FindArgumentTypeWithObject(object, ST(p), &argv[0]);

			value = ST(p+1);
		
			argc = 1;
			
			GtkSetArg(&argv[0], value, ST(0), object);

			gtk_object_setv(object, argc, argv);
			
			GtkFreeArg(&argv[0]);
			
			p += 1 + argc;
		}
	}


void
get(object, name, ...)
	Gtk::Object	object
	SV *	name
	PPCODE:
	{
		GtkType t;
		GtkArg	argv[3];
		int p;
		int argc;
		
		for(p=1;p<items;) {
		
			FindArgumentTypeWithObject(object, ST(p), &argv[0]);
		
			argc = 1;
			t=argv[0].type;
			
			gtk_object_getv(object, argc, argv);
			
			EXTEND(sp,1);
			PUSHs(sv_2mortal(GtkGetArg(&argv[0])));
			
			
			if (t == GTK_TYPE_STRING)
				g_free(GTK_VALUE_STRING(argv[0]));
			
			p++;
		}
	}

SV *
new(Class, ...)
	SV *	Class
	CODE:
	{
		GtkType t;
		GtkArg	argv[3];
		int p;
		int argc;
		char * perl_class;
		GtkObject *object;
		GtkType type;
		
		perl_class = SvPV(Class, PL_na);
		type = gtnumber_for_ptname(perl_class);
		if (!type) {
			if ( !(type = gtnumber_for_gtname(perl_class)) )
				croak("Invalid class name '%s'", perl_class);
			perl_class = ptname_for_gtnumber(type);
		}
	
		object = gtk_object_new(type, NULL);

		RETVAL = newSVGtkObjectRef(object, perl_class);
#ifdef DEBUG_TYPES
		printf("created SV %p for object %p from perltype %s (gtktype: %d -> %s)\n", RETVAL, object, SvPV(klass, PL_na), type, gtk_type_name(type));
#endif
		gtk_object_sink(object);
		
		for(p=1;p<items;) {
			char * argname;
		
			if ((p+1)>=items)
				croak("too few arguments");
			
			argname = SvPV(ST(p), PL_na);
			
			FindArgumentTypeWithObject(object, ST(p), &argv[0]);

			argc = 1;
			
			GtkSetArg(&argv[0], ST(p+1), RETVAL, object);

			gtk_object_setv(object, argc, argv);
			p += 1 + argc;
		}
	}
	OUTPUT:
	RETVAL

void
add_arg_type(Class, name, type, flags, num=1)
	SV *	Class
	SV *	name
	char *	type
	int     flags
	int	num
	CODE:
	{
		SV * name2 = name;
		int typeval;
		char * typename = gtk_type_name(gtnumber_for_ptname(SvPV(Class,PL_na)));
		if (strncmp(SvPV(name2,PL_na), typename, strlen(typename)) != 0) {
			/* Not prefixed with typename */
			name2 = sv_2mortal(newSVpv(typename, 0));
			sv_catpv(name2, "::");
			sv_catsv(name2, name);
		}
		typeval = gtnumber_for_ptname(type);
		if (!typeval)
			typeval = gtnumber_for_gtname(type);
		if (!typeval)
			typeval = gtk_type_from_name(type);
		if (!typeval) {
			char buf[130];
			sprintf(buf, "g%s", type);
			typeval = gtk_type_from_name(buf);
			if (!typeval) {
				strcpy(buf, "Gtk");
				buf[3] = toupper(type[0]);
				strcat(buf, type+1);
				typeval = gtk_type_from_name(buf);
			}
		}
		if (!typeval)
			croak("Unknown type %s", type);
		gtk_object_add_arg_type(strdup(SvPV(name2,PL_na)), typeval, flags, num);
	}

#ifndef GTK_HAVE_SIGNAL_EMITV

void
signal_emit(object, name)
	Gtk::Object	object
	SV *	name
	ALIAS:
		Gtk::Object::signal_emit = 0
		Gtk::Object::signal_emit_by_name = 1
	CODE:
	{
		gtk_signal_emit_by_name(object, SvPV(name,PL_na), NULL);
	}

#else

void
signal_emit(object, name, ...)
	Gtk::Object	object
	char *	name
	ALIAS:
		Gtk::Object::signal_emit = 0
		Gtk::Object::signal_emit_by_name = 1
	PPCODE:
	{
		GtkArg * args;
		guint sig = gtk_signal_lookup(name, object->klass->type);
		GtkSignalQuery * q;
		unsigned long retval;
		int params;
		int i,j;
		
		if (sig<1) {
			croak("Unknown signal %s in %s widget", name, gtk_type_name(object->klass->type));
		}
		
		q = gtk_signal_query(sig);
		
		if ((items-2) != q->nparams) {
			croak("Incorrect number of arguments for emission of signal %s in class %s, needed %d but got %d",
				name, gtk_type_name(object->klass->type), q->nparams, items-2);
		}
		
		params = q->nparams;
		
		args = calloc(params+1, sizeof(GtkArg));
		
		for(i=0,j=2;(i<params) && (j<items);i++,j++) {
			args[i].type = q->params[i];
			GtkSetArg(args+i, ST(j), 0, object);
		}
		args[params].type = q->return_val;
		GTK_VALUE_POINTER(args[params]) = &retval;
		
		g_free(q);
		
		gtk_signal_emitv(object, sig, args);
		
		EXTEND(sp,1);
		PUSHs(sv_2mortal(GtkGetRetArg(args + params)));
		
		free(args);
	}

int
signal_n_emissions(object, name)
	Gtk::Object object
	char *	name
	CODE:
	RETVAL = gtk_signal_n_emissions_by_name(object, name);
	OUTPUT:
	RETVAL

#endif

void
signal_emit_stop(object, name)
	Gtk::Object	object
	SV *	name
	ALIAS:
		Gtk::Object::signal_emit_stop = 0
		Gtk::Object::signal_emit_stop_by_name = 1
	CODE:
	{
		gtk_signal_emit_stop_by_name(object, SvPV(name,PL_na));
	}

void
signal_handler_block(object, handler_id)
		Gtk::Object     object
		unsigned int    handler_id
		CODE:
		{
				gtk_signal_handler_block(object, handler_id);
		}

void
signal_handler_unblock(object, handler_id)
		Gtk::Object     object
		unsigned int    handler_id
		CODE:
		{
				gtk_signal_handler_unblock(object, handler_id);
		}

unsigned int
signal_handler_pending(object, handler_id, may_be_blocked)
		Gtk::Object     object
		unsigned int    handler_id
		bool    may_be_blocked
		CODE:
		RETVAL= gtk_signal_handler_pending(object, handler_id, may_be_blocked);
		OUTPUT:
		RETVAL

#if GTK_HVER >= 0x010110

int
signal_handler_pending_by_id(object, handler_id, may_be_blocked)
		Gtk::Object     object
		unsigned int    handler_id
		bool    may_be_blocked
		CODE:
		RETVAL= gtk_signal_handler_pending_by_id(object, handler_id, may_be_blocked);
		OUTPUT:
		RETVAL

#endif

unsigned int
_object_type(object)
		SV *	object
		CODE:
		{
			GtkObject * o = SvGtkObjectRef(object, 0);
			int type;
			if (o)
				type = o->klass->type;
			else
				type = gtnumber_for_ptname(SvPV(object, PL_na));
			RETVAL=type;
		}
		OUTPUT:
		RETVAL

unsigned int
_object_size(object)
		SV *	object
		CODE:
		{
			GtkObject * o = SvGtkObjectRef(object, 0);
			int type;
			if (o)
				type = o->klass->type;
			else
				type = gtnumber_for_ptname(SvPV(object, PL_na));
			RETVAL = obj_size_for_gtname(gtk_type_name(type));
		}
		OUTPUT:
		RETVAL

unsigned int
_class_size(object)
		SV *	object
		CODE:
		{
			GtkObject * o = SvGtkObjectRef(object, 0);
			int type;
			if (o)
				type = o->klass->type;
			else
				type = gtnumber_for_ptname(SvPV(object, PL_na));
			RETVAL = class_size_for_gtname(gtk_type_name(type));
		}
		OUTPUT:
		RETVAL

int
register_subtype(parentClass, perlClass, ...)
	SV *	parentClass
	SV *	perlClass
	CODE:
	{
		dSP;
		int count;
		int signals;
		int parent_type;
		int i;
		long offset;
		GtkTypeInfo info;
		AV * signal_ids;
		SV * temp;
		SV * s;
		SV *	gtkName = 0;
		
		if (!gtkName) {
			int i;
			char *d, *s;
			gtkName = sv_2mortal(newSVsv(perlClass));
			d = s = SvPV(gtkName,PL_na);
			do {
				if (*s == ':')
					continue;
				*d++ = *s;
			} while(*s++);
		}
#ifdef DEBUG_TYPES	
		printf("GtkName = %s, PerlName = %s, ParentClass = %s\n", SvPV(gtkName, PL_na), SvPV(perlClass, PL_na), SvPV(parentClass, PL_na));
#endif
		
		info.type_name = SvPV(newSVsv(gtkName), PL_na); /* Yes, this leaks until interpreter cleanup */
		
		ENTER;
		SAVETMPS;
		
		PUSHMARK(sp);
		XPUSHs(sv_2mortal(newSVsv(parentClass)));
		PUTBACK;
		count = perl_call_method("_object_type", G_SCALAR);
		SPAGAIN;
		if (count != 1)
			croak("Big trouble\n");
		
		parent_type = POPi;
		
		PUTBACK;
		FREETMPS;
		LEAVE;

		
		ENTER;
		SAVETMPS;
		
		PUSHMARK(sp);
		XPUSHs(sv_2mortal(newSVsv(parentClass)));
		PUTBACK;
		count = perl_call_method("_object_size", G_SCALAR);
		SPAGAIN;
		if (count != 1)
			croak("Big trouble\n");
		
		info.object_size = POPi+sizeof(SV*);

		PUTBACK;
		FREETMPS;
		LEAVE;
		
		ENTER;
		SAVETMPS;
		
		PUSHMARK(sp);
		XPUSHs(sv_2mortal(newSVsv(parentClass)));
		PUTBACK;
		count = perl_call_method("_class_size", G_SCALAR);
		SPAGAIN;
		if (count != 1)
			croak("Big trouble\n");
		
		info.class_size = POPi;
		
		PUTBACK;
		FREETMPS;
		LEAVE;
#ifdef DEBUG_TYPES	
		printf("Parent_type = %d, object_size = %d, class_size = %d\n",
			parent_type, info.object_size, info.class_size);
#endif

		temp = newSVsv(perlClass);
		sv_catpv(temp, "::_signals");
		
		s = perl_get_sv(SvPV(temp, PL_na), TRUE);
		sv_setiv(s, signals);
		
		sv_setsv(temp, perlClass);
		sv_catpv(temp, "::_signal");
		
		s = perl_get_sv(SvPV(temp, PL_na), TRUE);
		sv_setiv(s, 0);

		sv_setsv(temp, perlClass);
		sv_catpv(temp, "::_signalbase");
		
		s = perl_get_sv(SvPV(temp, PL_na), TRUE);
		sv_setiv(s, info.class_size);

		sv_setsv(temp, perlClass);
		sv_catpv(temp, "::_signalids");

		signal_ids = perl_get_av(SvPV(temp, PL_na), TRUE);
		
		SvREFCNT_dec(temp);

		signals = (items - 1) / 2;

		offset = info.class_size;

		/*info.class_size += sizeof(GtkSignalFunc) * signals;*/
		
		info.class_init_func = (GtkClassInitFunc)generic_perl_gtk_class_init;
		info.object_init_func = (GtkObjectInitFunc)generic_perl_gtk_object_init;
#ifdef GTK_1_0
		info.arg_set_func = (GtkArgSetFunc)generic_perl_gtk_arg_set_func;
		info.arg_get_func = (GtkArgSetFunc)generic_perl_gtk_arg_get_func;
#else
		info.base_class_init_func = 0;
#endif

		RETVAL = gtk_type_unique(parent_type, &info);
#ifdef DEBUG_TYPES	
		printf("New type = %d\n", RETVAL);
#endif
		link_types(SvPV(gtkName, PL_na), SvPV(perlClass,PL_na), RETVAL, 0, info.object_size, info.class_size);

	}
	OUTPUT:
	RETVAL

void
add_signals (Class, ...)
	SV *	Class
	CODE:
	{
		GtkType klasstype;
		int i;
		gint sigs = (items-1)/2;
		guint * sig = malloc(sizeof(guint) * sigs);
	
		klasstype = gtnumber_for_ptname(SvPV(Class, PL_na));

		for (i=1;i<items-1;i+=2) {
			char * name = SvPV(ST(i), PL_na);
			AV * args = (AV*)SvRV(ST(i+1));
			GtkSignalRunType run_type = SvGtkSignalRunType(*av_fetch(args, 0, 0));
			int params = av_len(args);
			GtkType * types = (GtkType*)malloc(params * sizeof(GtkType));
			int j;
			
			for(j=1;j<=params;j++) {
				char * type = SvPV(*av_fetch(args, j, 0), PL_na);
				if (!(types[j-1] = gtk_type_from_name(type))) {
					croak("Unknown type %s", type);
				}
				
			}
#ifdef DEBUG_TYPES	
			printf("new signal '%s' has a return type of %s, and takes %d arguments\n",
				name, gtk_type_name(types[0]), params-1);
#endif
			
			j = gtk_signal_newv(name, run_type, klasstype, 0/*offset*/, generic_perl_gtk_signal_marshaller, types[0], params - 1, (params>1) ? types+1 : 0);
#ifdef DEBUG_TYPES	
			printf("signal '%s' => id = %d\n", name, j);
#endif
			sig[(i-1)/2] = j;
			
			/*av_push(signal_ids, newSViv(j));*/
			
			/*offset += sizeof(GtkSignalFunc);*/
		}
		gtk_object_class_add_signals(gtk_type_class(klasstype), sig, sigs);
		free(sig);
	}

void
destroy(object)
	Gtk::Object	object
	CODE:
	gtk_object_destroy(object);

void
gtk_object_ref(object)
	Gtk::Object	object

void
gtk_object_unref(object)
	Gtk::Object	object

bool
gtk_object_destroyed(object)
	Gtk::Object	object
	CODE:
	RETVAL = GTK_OBJECT_DESTROYED(object);
	OUTPUT:
	RETVAL

bool
gtk_object_floating(object)
	Gtk::Object	object
	CODE:
	RETVAL = GTK_OBJECT_FLOATING(object);
	OUTPUT:
	RETVAL

#ifdef GTK_OBJECT_CONNECTED

bool
gtk_object_connected(object)
	Gtk::Object	object
	CODE:
	RETVAL = GTK_OBJECT_CONNECTED(object);
	OUTPUT:
	RETVAL

#endif

#endif
