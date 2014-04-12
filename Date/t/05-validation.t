use strict;
use warnings;
use Test::More tests => 2;
use lib '..';
use getjump::Date;
use Data::Dumper;

BEGIN {
    $@ = '';
	eval { my $err = getjump::Date->new('19.00.2015') };
    ok($@ =~ qr/Month invalid/);
    $@ = '';
    eval { my $err = getjump::Date->new('00.03.2015') };
    ok($@ =~ qr/Days invalid/);
}