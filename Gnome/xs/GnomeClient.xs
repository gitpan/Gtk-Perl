
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "GtkDefs.h"
#include "GnomeDefs.h"


static void interaction_handler(GnomeClient * client, gint key, GnomeDialogType dialog_type, gpointer data)
{
	AV * args = (AV*)data;
    SV * handler = *av_fetch(args, 0, 0);
    int i;
    dSP;

    PUSHMARK(sp);
    for (i=1;i<=av_len(args);i++)
            XPUSHs(sv_2mortal(newSVsv(*av_fetch(args, i, 0))));

    XPUSHs(sv_2mortal(newSViv(key)));
    XPUSHs(sv_2mortal(newSVGnomeDialogType(dialog_type)));
    PUTBACK;

    perl_call_sv(handler, G_DISCARD);

}

MODULE = Gnome::Client		PACKAGE = Gnome::Client		PREFIX = gnome_client_

#ifdef GNOME_CLIENT

Gnome::Client_Sink
master(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_CLIENT(gnome_master_client());
	OUTPUT:
	RETVAL

Gnome::Client_Sink
cloned(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_CLIENT(gnome_cloned_client());
	OUTPUT:
	RETVAL

Gnome::Client_Sink
new(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_CLIENT(gnome_client_new());
	OUTPUT:
	RETVAL

Gnome::Client_Sink
new_without_connection(Class)
	SV *	Class
	CODE:
	RETVAL = GNOME_CLIENT(gnome_client_new_without_connection());
	OUTPUT:
	RETVAL

void
gnome_client_connect(client)
	Gnome::Client	client

void
gnome_client_disconnect(client)
	Gnome::Client	client

void
gnome_client_set_id(client, client_id)
	Gnome::Client	client
	char *	client_id

char *
gnome_client_get_id(client)
	Gnome::Client	client

char *
gnome_client_get_previous_id(client)
	Gnome::Client	client

char *
gnome_client_get_config_prefix(client)
	Gnome::Client	client

char *
gnome_client_get_global_config_prefix(client)
	Gnome::Client	client

void
gnome_client_set_clone_command(client, ...)
	Gnome::Client	client
	CODE:
	{
		char ** a = (char**)malloc(sizeof(char*) + items);
		int i;
		for(i=1;i<items;i++)
			a[i-1] = SvPV(ST(i), PL_na);
		a[i-1] = 0;
		gnome_client_set_clone_command(client, items-1, a);
		free(a);
	}

void
gnome_client_set_current_directory(client, dir)
	Gnome::Client	client
	char *	dir

void
gnome_client_set_discard_command(client, ...)
	Gnome::Client	client
	CODE:
	{
		char ** a = (char**)malloc(sizeof(char*) + items);
		int i;
		for(i=1;i<items;i++)
			a[i-1] = SvPV(ST(i), PL_na);
		a[i-1] = 0;
		gnome_client_set_discard_command(client, items-1, a);
		free(a);
	}

#ifdef NEW_GNOME

void
gnome_client_set_environment(client, name, value)
	Gnome::Client client
	char *name
	char *value

#else

void
gnome_client_set_environment(client, ...)
	Gnome::Client	client
	CODE:
	{
		char ** a = (char**)malloc(sizeof(char*) + items);
		int i;
		for(i=1;i<items;i++)
			a[i-1] = SvPV(ST(i), PL_na);
		a[i-1] = 0;
		gnome_client_set_environment(client, items-1, a);
		free(a);
	}

#endif

void
gnome_client_set_process_id(client, pid)
	Gnome::Client	client
	int	pid

void
gnome_client_set_program(client, program)
	Gnome::Client	client
	char *	program


void
gnome_client_set_restart_command(client, ...)
	Gnome::Client	client
	CODE:
	{
		char ** a = (char**)malloc(sizeof(char*) + items);
		int i;
		for(i=1;i<items;i++)
			a[i-1] = SvPV(ST(i), PL_na);
		a[i-1] = 0;
		gnome_client_set_restart_command(client, items-1, a);
		free(a);
	}

void
gnome_client_set_resign_command(client, ...)
	Gnome::Client	client
	CODE:
	{
		char ** a = (char**)malloc(sizeof(char*) + items);
		int i;
		for(i=1;i<items;i++)
			a[i-1] = SvPV(ST(i), PL_na);
		a[i-1] = 0;
		gnome_client_set_resign_command(client, items-1, a);
		free(a);
	}

void
gnome_client_set_restart_style(client, style)
	Gnome::Client	client
	Gnome::RestartStyle	style

void
gnome_client_set_shutdown_command(client, ...)
	Gnome::Client	client
	CODE:
	{
		char ** a = (char**)malloc(sizeof(char*) + items);
		int i;
		for(i=1;i<items;i++)
			a[i-1] = SvPV(ST(i), PL_na);
		a[i-1] = 0;
		gnome_client_set_shutdown_command(client, items-1, a);
		free(a);
	}

void
gnome_client_set_user_id(client, id)
	Gnome::Client	client
	char *	id

void
gnome_client_request_phase_2(client)
	Gnome::Client	client

void
gnome_client_request_interaction(client, dialog, handler, ...)
	Gnome::Client	client
	Gnome::DialogType	dialog
	SV *	handler
	CODE:
	{
		AV * args = newAV();
		PackCallbackST(args, 2);
		gnome_client_request_interaction(client, dialog, interaction_handler, (gpointer)args);
	}

void
interaction_key_return(Class, key, cancel_shutdown)
	SV *	Class
	int	key
	int	cancel_shutdown
	CODE:
	gnome_interaction_key_return(key, cancel_shutdown);

void
gnome_client_request_save(client, save_style, shutdown, interact_style, fast, global)
	Gnome::Client	client
	Gnome::SaveStyle	save_style
	bool	shutdown
	Gnome::InteractStyle	interact_style
	bool	fast
	bool	global


#endif

