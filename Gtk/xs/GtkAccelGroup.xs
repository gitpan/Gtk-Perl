
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"

MODULE = Gtk::AccelGroup	PACKAGE = Gtk::AccelGroup	PREFIX = gtk_accel_group_

Gtk::AccelGroup
gtk_accel_group_new(Class)
	SV	*Class
	CODE:
	RETVAL = gtk_accel_group_new();
	OUTPUT:
	RETVAL

Gtk::AccelGroup
gtk_accel_group_get_default(Class)
	SV	*Class
	CODE:
	RETVAL = gtk_accel_group_get_default();
	OUTPUT:
	RETVAL

bool
gtk_accel_group_activate(self, accel_key, accel_mods)
	Gtk::AccelGroup		self
	unsigned int		accel_key
	Gtk::Gdk::ModifierType	accel_mods

void
gtk_accel_group_attach(self, object)
	Gtk::AccelGroup	self
	Gtk::Object	object

void
gtk_accel_group_detach(self, object)
	Gtk::AccelGroup	self
	Gtk::Object	object

void
gtk_accel_group_lock(self)
	Gtk::AccelGroup	self

void
gtk_accel_group_unlock(self)
	Gtk::AccelGroup	self

#Gtk::AccelEntry
#gtk_accel_group_get_entry(self, accel_key, accel_mods)
#	Gtk::AccelGroup		self
#	unsigned int		accel_key
#	Gtk::Gdk::ModifierType	accel_mods

void
gtk_accel_group_lock_entry(self, accel_key, accel_mods)
	Gtk::AccelGroup		self
	unsigned int		accel_key
	Gtk::Gdk::ModifierType	accel_mods

void
gtk_accel_group_unlock_entry(self, accel_key, accel_mods)
	Gtk::AccelGroup		self
	unsigned int		accel_key
	Gtk::Gdk::ModifierType	accel_mods

void
gtk_accel_group_add(self, accel_key, accel_mods, accel_flags, object, accel_signal)
	Gtk::AccelGroup		self
	unsigned int		accel_key
	Gtk::Gdk::ModifierType	accel_mods
	Gtk::AccelFlags		accel_flags
	Gtk::Object		object
	char*			accel_signal

void
gtk_accel_group_remove(self, accel_key, accel_mods, object)
	Gtk::AccelGroup		self
	unsigned int		accel_key
	Gtk::Gdk::ModifierType	accel_mods
	Gtk::Object		object

MODULE = Gtk::AccelGroup	PACKAGE = Gtk::Accelerator	PREFIX = gtk_accelerator_

gboolean
gtk_accelerator_valid(Class, keyval, modifiers)
	SV		*Class
	guint	keyval
	Gtk::Gdk::ModifierType	modifiers
	CODE:
	RETVAL = gtk_accelerator_valid(keyval, modifiers);
	OUTPUT:
	RETVAL

void
gtk_accelerator_parse(Class, accelerator)
	SV	*Class
	char	*accelerator
	PPCODE:
	{
		unsigned int accel_key;
		GdkModifierType accel_mods;
		gtk_accelerator_parse(accelerator, &accel_key, &accel_mods);
		/* FIXME: GIMME */
		EXTEND(sp, 2);
		PUSHs(sv_2mortal(newSViv(accel_key)));
		PUSHs(sv_2mortal(newSVGdkModifierType(accel_mods)));
	}

char*
gtk_accelerator_name(Class, accel_key, accel_mods)
	SV*			Class
	unsigned int		accel_key
	Gtk::Gdk::ModifierType	accel_mods
	CODE:
	RETVAL = gtk_accelerator_name(accel_key, accel_mods);
	OUTPUT:
	RETVAL

void
gtk_accelerator_set_default_mod_mask(Class, default_mod_mask)
	SV *	Class
	Gtk::Gdk::ModifierType	default_mod_mask
	CODE:
	gtk_accelerator_set_default_mod_mask(default_mod_mask);

Gtk::Gdk::ModifierType
gtk_accelerator_get_default_mod_mask(Class)
	SV*	Class
	CODE:
	RETVAL = gtk_accelerator_get_default_mod_mask();
	OUTPUT:
	RETVAL


