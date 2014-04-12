use strict;
use warnings;
use Test::More tests => 5;
use lib '..';
use getjump::Date;
use Data::Dumper;

BEGIN {
	my($d1, $d2, $d3);
	$d1 = getjump::Date->new('19.03.2015');
    $d2 = getjump::Date->new('20.03.2015');
    $d3 = getjump::Date->new('21.03.2015');

    is($d2->delta_days($d1), 1);
    is($d3->delta_days($d2), 1);
    is($d3->delta_days($d1), 2);
    is($d1->delta_days($d3), -2);
    is($d1->delta_days($d2), -1);
}