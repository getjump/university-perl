package getjump::TryCatch;

use strict;
use warnings;

use Carp;

use getjump::Error;
use getjump::With;
use getjump::Catch;
use getjump::Finally;

require Scalar::Util;

use Exporter 5.57 'import';
our @EXPORT = our @EXPORT_OK = qw(try catch finally with);

use Data::Dumper;

sub try(&;@) {
    my ($try, @handlers) = @_;

    my (@ret, $handled);

    eval { @ret = scalar $try->(); 1 } || do {
        my $e      = $@;
        my $orig_e = $e;

        if (!Scalar::Util::blessed($e)) {
            $orig_e =~ s{ at ([\S]+) line (\d+)\.\s*$}{}ms;
            $e = getjump::Error->new(
                message => $orig_e,
                file    => $1,
                line    => $2
            );
        }

        $handled = 0;
        print Dumper(\@handlers);

        for my $handler (@handlers) {
        	print Dumper(\$handler->class->());
        	#print Dumper(\@handlers);
            if ($handler) {
            	if($handler->isa('getjump::Catch'))
            	{
            		if ($e->isa($handler->class)) {# Hello, Isa
               		#if (ref($e) eq ($handler->class)) {
               			$handled = 1;
                    	$handler->handler->($e);
                	}
            	}
            }
        }

        Carp::croak($orig_e) unless $handled;
    };

    for my $handler (@handlers) {
    	if($handler && $handler->isa('getjump::Finally'))
      	{
	   		#print Dumper(\$handler->handler);
      		$handler->handler->();
        }
    }

    return $ret[0];
}

sub catch(&;@)
{
	my($class, $handler) = @_ == 2 ? ($_[0], $_[1]) : ('getjump::Error', $_[0]);
	getjump::Catch->new(handler => $handler, class => $class);
}

sub finally(&;@)
{
	my($handler) = @_;
	getjump::Finally->new(handler => $handler);
}

sub with(&;@) 
{
    my ($handler, $subhandler) = @_;

    (getjump::With->new(handler => $handler), $subhandler);
}

1;