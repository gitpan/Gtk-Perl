package Gtk;

=pod

=head1 NAME

Gtk - Perl module for the Gimp Toolkit library

=head1 SYNOPSIS

	use Gtk '-init';
	my $window = new Gtk::Window;
	my $button = new Gtk::Button("Quit");
	$button->signal_connect("clicked", sub {Gtk->main_quit});
	$window->add($button);
	$window->show_all;
	Gtk->main;
	
=head1 DESCRIPTION

The Gtk module allows Perl access to the Gtk+ graphical user interface
library. You can find more information about Gtk+ on http://www.gtk.org.
The Perl binding tries to follow the C interface as much as possible,
providing at the same time a fully object oriented interface and
Perl-style calling conventions.

=head1 AUTHOR

Kenneth Albanowski, Paolo Molaro

=head1 SEE ALSO

perl(1)

=cut

require Exporter;
require DynaLoader;
require AutoLoader;

use Carp;

$VERSION = '0.7005';

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

sub import {
	my $self = shift;
	foreach (@_) {
		$self->init(),	next if /^-init$/;
	}
}

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    # NOTE: THIS AUTOLOAD FUNCTION IS FLAWED (but is the best we can do for now).
    # Avoid old-style ``&CONST'' usage. Either remove the ``&'' or add ``()''.
    if (@_ > 0) {
	$AutoLoader::AUTOLOAD = $AUTOLOAD;
	goto &AutoLoader::AUTOLOAD;
    }
    local($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    ($pack,$file,$line) = caller;
	    die "Your vendor has not defined Gtk macro $constname, used at $file line $line.
";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

# use RTLD_GLOBAL
sub dl_load_flags {0x01}

bootstrap Gtk;

# Preloaded methods go here.

@Gtk::Gdk::Bitmap::ISA = qw(Gtk::Gdk::Pixmap);
@Gtk::Gdk::Window::ISA = qw(Gtk::Gdk::Pixmap);

$Gtk::_init_package = "Gtk" if not defined $Gtk::_init_package;

package Gtk::_LazyLoader;

sub isa {
	my($object, $type) = @_;
	my($class);
	$class = ref($object) || $object;
	
	#return 1 if $class eq $type;

	foreach (@{$class . "::_ISA"}, @{$class . "::ISA"}) {
		return 1 if $_ eq $type or $_->isa($type);
	}

	return 0;
}
        
sub AUTOLOAD { 
	my($method,$object,$class);
	#print "AUTOLOAD = '$AUTOLOAD', ", join(',', map("'$_'", @_)),"\n";
	if ($AUTOLOAD =~ /^.*::/) {
		$method = $';
	}
	$object = shift @_;
	$class = ref($object) || $object;
	#print "1. Method=$method, object=$object, class=$class\n";

	if (not @{$class . "::_ISA"}) {
		my(@parents) = @{$class . "::ISA"};
		while (@parents) {
			$class = shift @parents;
			if (@{$class . "::_ISA"}) {
				last;
			}
			push @parents, @{$class . "::ISA"};
		}

	}

	@{$class . "::ISA"} = @{$class . "::_ISA"};
	@{$class . "::_ISA"} = ();
	#print "\@$class"."::ISA = (",join(',', @{$class . "::ISA"}),")\n";

	#print "2. Method=$method, object=$object, class=$class\n";
	&{$class . "::_bootstrap"}($class);
	$object->$method(@_);
}
  
package Gtk::Object;

use Carp;

sub AUTOLOAD {
    # This AUTOLOAD is used to automatically perform accessor/mutator functions
    # for Gtk object data members, in lieu of defined functions.
    
    my($result);
    my ($realname) = $AUTOLOAD;
    $realname =~ s/^.*:://;
    eval {
            my ($argn, $classn, $flags) = $_[0]->_get_arg_info($realname);
	    my $is_readable = $flags->{readable} || $flags->{readwrite};
	    my $is_writable = $flags->{writable} || $flags->{readwrite};
            #print STDERR "GOT ARG: $AUTOLOAD -> $argn ($classn) ", join(' ', keys %{$flags}), " - ",  join(' ', values %{$flags}),"\n";
   
	    if (@_ == 2 && $is_writable) {
	    	$_[0]->set($argn, $_[1]);
	    } elsif (@_ == 1 && $is_readable) {
	    	$result = $_[0]->get($argn);
	    } else {
	    	die;
	    }
	    
	    # Set up real method, to speed subsequent access
	    eval <<"EOT";
	    
	    sub ${classn}::$realname {
	    	if (\@_ == 2 && $is_writable) {
	    		\$_[0]->set('$argn', \$_[1]);
	    	} elsif (\@_ == 1 && $is_readable) {
	    		\$_[0]->get('$argn');
	    	} else {
	    		die "Usage: ${classn}::$realname (Object [, new_value])";
	    	}
	    }
EOT
	    
	};
	if ($@) {
		if (ref $_[0]) {
			$AUTOLOAD =~ s/^.*:://;
			croak "Can't locate object method \"$AUTOLOAD\" via package \"" . ref($_[0]) . "\"";
		} else {
			croak "Undefined subroutine \&$AUTOLOAD called";
		}
	}
	$result;
}

# Note: $handler and $slot_object are swapped!
sub signal_connect_object {
	my ($obj, $signal, $slot_object, $handler, @data) = @_;

	$obj->signal_connect($signal, sub {
		# throw away the object
		shift; 
		$slot_object->$handler(@_);
	}, @data);
}

sub signal_connect_object_after {
	my ($obj, $signal, $slot_object, $handler, @data) = @_;

	$obj->signal_connect_after($signal, sub {
		# throw away the object
		shift; 
		$slot_object->$handler(@_);
	}, @data);
}

package Gtk::Widget;

sub new {
	my ($class, @args) = @_;
	my ($obj) = Gtk::Object::new(@args);
	$class->add($obj) if ref($class);
	return $obj;
}

sub new_child {return new @_}

package Gtk::CTree;

sub insert_node_defaults {
	my ($ctree, %values) = @_;

	$values{spacing} = 5 unless defined $values{spacing};
	$values{is_leaf} = 1 unless defined $values{is_leaf};
	$values{expanded} = 0 unless defined $values{expanded};
	
	return $ctree->insert_node(@values{qw/parent sibling titles spacing pixmap_closed mask_closed pixmap_opened mask_opened is_leaf expanded/});
}

package Gtk;

require Gtk::Types;

sub getopt_options {
	my $dummy;
	return (
		"gdk-debug=s"	=> \$dummy,
		"gdk-no-debug=s"	=> \$dummy,
		"display=s"	=> \$dummy,
		"sync"	=> \$dummy,
		"no-xshm"	=> \$dummy,
		"name=s"	=> \$dummy,
		"class=s"	=> \$dummy,
		"gxid_host=s"	=> \$dummy,
		"gxid_port=s"	=> \$dummy,
		"xim-preedit=s"	=> \$dummy,
		"xim-status=s"	=> \$dummy,
		"gtk-debug=s"	=> \$dummy,
		"gtk-no-debug=s"	=> \$dummy,
		"g-fatal-warnings"	=> \$dummy,
		"gtk-module=s"	=> \$dummy,
	);
}

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
