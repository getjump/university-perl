package getjump::Catch;

use strict;
use warnings;

use Data::Dumper;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    #print Dumper(\%params);

    $self->{handler} = $params{handler};
    $self->{class}   = $params{class};

    Carp::croak('class is required') unless $self->{class};

    return $self;
}

sub handler { $_[0]->{handler} }
sub class   { $_[0]->{class} }

1;