#!/usr/bin/perl -w

use Data::Dumper;

my ($package, $prefix, $lastl) = (undef, undef);
my (%funcs, $tag);
my (%keywords, $mode, %current, %taboo);

@keywords{qw/ARG OUTPUT PROTO CONSTRUCTOR RETURNS DESC PARAMS SEEALSO EXAMPLE/} = ();
@taboo{qw/DESTROY constant/} = ();

%dataout = (
	'void'	=> undef,
	'char*'	=> "string",
	'gfloat'	=> "float",
	'gint'	=> 'integer',
	'int'	=> 'integer',
	'unsigned int'	=> 'integer',
	'unsigned long'	=> 'integer',
	'long'	=> 'integer',
	'bool'	=> 'boolean',
);

$tag = 'gtk';

if ($ARGV[0] eq '-t') {
	shift;
	$tag = shift || 'gtk';
}

foreach (@ARGV) {
	$lastl = $package = $prefix = $mode = undef;
	%current = ();
	open (F, $_) || die "Cannot open $_: $!";
	while (<F>) {
		next if !defined($_);
		chomp;
		if (/^\s*$/) {
			$current{'PACKAGE'} = $package unless $current{'PACKAGE'};
			if ($current{'PROTO'}) {
				# print STDERR "STORING: $current{'PROTO'} in $current{'PACKAGE'}\n";
				$funcs{$current{'PACKAGE'}}->{$current{'PROTO'}} = {%current};
			}
			%current = ();
			next;
		}
		if (/^\s*MODULE\s*=\s*(\S+)/) {
			$package = $1;
			$package = $1 if /PACKAGE\s*=\s*(\S+)/;
			$prefix = '';
			$prefix = $1 if /PREFIX\s*=\s*([_a-zA-Z][a-zA-Z0-9_]*)?\s*/;
			# print STDERR "PACKAGE = $package\nPREFIX = $prefix\n";
			next;
		}
		next unless $package;
		if (/^\s+#\s*(\w+):\s*(.*)/) {
			handle_keyword($1, $2) if exists $keywords{$1};
			next;
		}
		if (/^\s+#\s*(.+)/) {
			handle_keyword($mode, $1) if $mode;
			next;
		}
		if (/^([a-zA-Z_][a-zA-Z0-9_]*)\s*\((.*)\)\s*$/) {
			$_ = handle_proto($1, $2);
			redo;
		}
	} continue {
		$lastl = $_;
	}
	close(F);
}

my %funcdesc;

open(DOC, ">build/perl-$tag-ref.pod") || die "Cannot open doc: $!";
select DOC;
#print "\n=head1 NAME\n\nGtk/Perl Reference Manual\n\n";
foreach my $p (sort keys %funcs) {
	output_package($p);
	%funcdesc = %{$funcs{$p}};
	foreach (sort { $a cmp $b } keys %funcdesc) {
		output_func($p, $_);
		# print Dumper($funcdesc{$_});
	}
	#print "\n=back\n\n";
}
close(DOC);
exit(0);

sub handle_keyword {
	my ($k, $d) = @_;
	my $pack;
	
	# print STDERR "GOT KEYWORD: $k -> $d\n";
	$mode = $k;
	return unless $d;
	# ARG
	if ($k eq 'PROTO') {
		$current{'PACKAGE'} = $1 if $d =~ s/(.*)::(\w+)$/$2/;
		$current{$k} = $d;
	} elsif ($k eq 'ARG') {
		if ($d =~ /\s*([a-zA-Z_][a-zA-Z0-9_]*)\s+(.*?)\s+\(.*\)/) {
			my ($param, $type, $comment) = ($1, $2, $3);
			crunch_type($type);
			$current{'ARG'}->{$param} = [$type, $comment];
			# print STDERR "GOT ARG: $type, $param, $comment\n";
		} else {
			print STDERR "Wrong ARG construct: $d\n";
		}
	} else {
		$current{$k} .= "\n" if $current{$k};
		$current{$k} .= $d;
	}
}

sub handle_proto {
	my ($n, $args) = @_;
	my ($type, $param, $comment, $retval);
	
	$n =~ s/^$prefix// if $prefix;
	return if exists $taboo{$n};
	return unless $package;
	# print STDERR "PROTO = ${package}::$n\n";
	$current{'PROTO'} = $n unless exists $current{'PROTO'};
	$current{'OUTPUT'} = $lastl unless $current{'OUTPUT'};
	#return unless $args;
	$current{'PARAMS'} = $args unless exists $current{'PARAMS'};
	while(defined ($retval=<F>)) {
		last if $retval =~ /^\s*$/;
		last if $retval =~ /^\s*\w+:\s*$/;
		next unless $retval =~ /\s*(.*?)\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*$/;
		$comment = undef;
		$param = $2;
		$type = $1;
		crunch_type($type);
		$comment = 'may be undef' if $type =~ s/_OrNULL$//;
		$current{'ARG'}->{$param} = [$type, $comment] unless exists $current{'ARG'}->{$param};
	}
	return $retval;
}

sub crunch_type {
	$_[0] =~ s/\s+/ /o;
	$_[0] =~ s/\s+(?=\B)//g;
	$_[0] =~ s/(_Sink_Up|_Sink|_Up)$//o;
	$_[0] = $dataout{$_[0]} if exists $dataout{$_[0]};
}

sub my_compare {

	return $a cmp $b;
}

sub output_package {
	my ($p) = shift;
	my (@c);

	print "\n=head1 $p\n\n";
	# output description

	#print STDERR Dumper(\%funcdesc);
	# constructors
	foreach (keys %funcdesc) {
		push (@c, $_) if exists $funcs{$p}->{$_}->{'CONSTRUCTOR'};
	}
	print "B<Constructors:> ", join(', ', @c), "\n\n" if @c;

	#print "=over 4\n";
}

sub output_func {
	my ($p, $n) =@_ ;
	my ($data) = $funcs{$p}->{$n};
	my ($args) = $data->{'PARAMS'} || '';
	my ($out) = $data->{'OUTPUT'} || '';

	return unless $data;
	return unless keys %$data;

	crunch_type($out);

	print "\n=head2 \n$n ($args)\n\n";

	print "=over 4\n\n";
	foreach (split(', ', $args)) {
		next if /^Class/;
		next if /\.\.\./;
		s/\s*=.*$//;
		print "=item * ";
		print "B<$data->{'ARG'}->{$_}[0]> " if $data->{'ARG'}->{$_}[0];
		print "$_ ";
		print "($data->{'ARG'}->{$_}[1])" if $data->{'ARG'}->{$_}[1];
		print "\n\n";
	}
	print "=back\n\n";
	print "B<Return type:> $out\n\n" if $out;
	print "$data->{'DESC'}\n\n" if $data->{'DESC'};
	print "\nB<Returns:>\n", $data->{'RETURNS'}, "\n" if $data->{'RETURNS'};
	print "\nB<See also:>\n", $data->{'SEEALSO'}, "\n" if $data->{'SEEALSO'};
	# auto example?
	#print "EXAMPLE: $data->{'EXAMPLE'}\n" if $data->{'EXAMPLE'};
}
