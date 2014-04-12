use strict;
use warnings;
use Test::More tests => 4;
use lib '..';
use getjump::Date;
use Data::Dumper;

BEGIN {
	my($d1, $d2, $d3);
	$d1 = getjump::Date->new('19.03.2015');

	ok(($d1+1)->string eq '20.03.2015', 'Add test');
	ok(($d1-1)->string eq '18.03.2015', 'Subtract test');

	ok(($d1+1000)->string eq '13.12.2017', 'Complex add test');
	ok(($d1-1000)->string eq '22.06.2012', 'Complex subtract test');
}