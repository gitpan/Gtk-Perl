
$Prefix = $ARGV[0];
$PREFIX = uc $Prefix;

@ARGV = (<$Prefix/*.h>, <*.h>);

$div1 = "";
$div2 = "";

$div3 = "";

while (<>) {

	next unless /Perl${Prefix}Declare(Func|Var)\s*\(\s*([^\)]+?)\s*,\s*([^,]+?)\s*\)/;
	
	my($kind, $type, $name, $rest) = ($1, $2, $3, $');
	next if /^\s*#/;
	
	#printf("$kind, $type, $name\n");
	
	if ($kind eq "Var") {
		$div1 .= "\t\tPerl${Prefix}ExtFixupName(_p_$name);\t\t\t\\\n";
		$div2 .= "#define $name (*(_p_$name))\n";
		$div4 .= "\tSet(\"_p_$name\", (int)&$name);\n";
	} else {
		$div1 .= "\t\tPerl${Prefix}ExtFixupName($name);\t\t\t\\\n";
		$div4 .= "\tSet(\"$name\", (int)&$name);\n";
	}
#	$div3 .= "extern $type $name $rest";
	
}

open (O, ">build/Perl${Prefix}Ext.h");

print O <<"EOT";

	/* Do not edit this file, it was generated by $0 */

#ifndef _PERL${PREFIX}_EXT_
#define _PERL${PREFIX}_EXT_
#define PERL${PREFIX}EXT

#ifdef GLOBAL_SYMBOLS
#include "Perl${Prefix}Int.h"
#else

#ifdef PERL${PREFIX}EXT_Define

#define Perl${Prefix}DeclareFunc(return, name) return (*name)
#define Perl${Prefix}DeclareVar(type, name) type * _p_ ## name

#else

#define Perl${Prefix}DeclareFunc(return, name) extern return (*name)
#define Perl${Prefix}DeclareVar(type, name) extern type * _p_ ## name

#endif

HV * Perl${Prefix}ExtFixupHash;

#define Perl${Prefix}ExtFixupName(name)						\\
	_lookup = hv_fetch(	Perl${Prefix}ExtFixupHash,			\\
				STRINGIFY(name),							\\
				strlen(STRINGIFY(name)), 0);				\\
	if (_lookup && SvOK(*_lookup) && SvIOK(*_lookup))		\\
		name = (void*)SvIV(*_lookup);

#define Perl${Prefix}ExtFixup()								\\
	{														\\
		SV ** _lookup;										\\
		if (!Perl${Prefix}ExtFixupHash) {					\\
			Perl${Prefix}ExtFixupHash = perl_get_hv("${Prefix}::_ExtFixup", TRUE);	\\
			/*												\\
			dSP ;											\\
			int count ;										\\
															\\
			ENTER ;											\\
			SAVETMPS;										\\
															\\
			PUSHMARK(sp) ;									\\
															\\
			count = perl_call_pv("${Prefix}::_ExtFixup", G_SCALAR);\\
															\\
			SPAGAIN ;										\\
															\\
			if (count != 1)									\\
				croak("Big trouble\n") ;					\\
															\\
			Perl${Prefix}ExtFixupHash = POPi ;				\\
															\\
			PUTBACK ;										\\
			FREETMPS ;										\\
			LEAVE ;											\\
			*/												\\
		}													\\
															\\
$div1	}

$div2

#endif /* !GLOBAL_SYMBOLS */

#endif /* _PERL${PREFIX}_EXT_ */

EOT


open(I, "<build/Perl${Prefix}Ext.c.in");
open(O, ">build/Perl${Prefix}Ext.c");

print O <<"EOT";

	/* Do not edit this file, it was generated by $0 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "Perl${Prefix}Int.h"

#include "${Prefix}Defs.h"

void Perl${Prefix}ExtSetupFixups(void)
{
	static int did_it = 0;
	SV * sv;
	HV * Perl${Prefix}ExtFixupHash;

	if (did_it)
		return;

	Perl${Prefix}ExtFixupHash = perl_get_hv("${Prefix}::_ExtFixup", TRUE);

#define Set(name, value) hv_store(Perl${Prefix}ExtFixupHash, name, strlen(name), newSViv(value), 0)

$div4
	
	did_it = 1;
}

EOT

open(O, ">build/Perl${Prefix}Int.h");

print O <<"EOT";

	/* Do not edit this file, it was generated by $0 */

#ifndef _PERL${PREFIX}_INT_
#define _PERL${PREFIX}_INT_
#define PERL${PREFIX}INT

#define Perl${Prefix}DeclareFunc(return, name) extern return name
#define Perl${Prefix}DeclareVar(type, name) extern type name

#define Perl${Prefix}ExtFixup()

#endif /* _PERL${PREFIX}_INT_ */

EOT
