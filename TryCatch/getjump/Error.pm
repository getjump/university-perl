package getjump::Error;

use strict;
use warnings;
use Data::Dumper;

require Carp;

use overload '""' => \&to_string, fallback => 0;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{message} = $params{message};
    $self->{file}    = $params{file};
    $self->{line}    = $params{line};

    return $self;
}

sub message { $_[0]->{message} }
sub line    { $_[0]->{line} }
sub file    { $_[0]->{file} }

sub throw {
    my $class = shift;
    my ($message) = @_;

    my (undef, $file, $line) = caller(0); # ??, file, line, method ...
    my $self = $class->new(message => $message, file => $file, line => $line);

    Carp::croak($self);
}

sub rethrow {
    my $self = shift;

    Carp::croak($self);
}

sub catch(&;@) {
    my $self = shift;
    my ($with, @tail) = @_;

    my $class = ref($self) ? ref($self) : $self;

    (getjump::Catch->new(handler => $with->handler, class => $class),
        @tail);
}

sub to_string {
    my $self = shift;

    my $message = $self->{message};
    $message =~ s{$}{ at $self->{file} line $self->{line}.}m;

    $message;
}

1;