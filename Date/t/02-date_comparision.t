use strict;
use warnings;
use Test::More tests => 8;
use lib '..';
use getjump::Date;
use Data::Dumper;

BEGIN {
	my($d1, $d2, $d3);
	$d1 = getjump::Date->new('19.03.2015');
    $d2 = getjump::Date->new('20.03.2015');
    $d3 = getjump::Date->new('21.03.2015');

    ok($d2 > $d1, 'Greater test');
    ok($d2 < $d3, 'Less test');
    ok($d2 == $d2, 'Equal test');
    ok($d1 != $d2, 'Not equal test');
    ok($d1 ne $d2, 'cmp: Not equal test');
    ok($d1 eq $d1, 'cmp: Equal test');
    ok($d1 lt $d2, 'cmp: Less test');
    ok($d2 gt $d1, 'cmp: Greater test');
}