use strict;
use warnings;
use Test::More tests => 4;
use lib '..';
use getjump::Date;
use Data::Dumper;

BEGIN {
	my $d = getjump::Date->new;
	isa_ok($d, 'getjump::Date');
	ok($d->string =~ /\d{2}.\d{2}.\d{4}/, 'constructor based on current day');

	$d = getjump::Date->new(19, 3, 2015);
	is($d->string, '19.03.2015', 'constructor can take array (day, month, year)');

	$d = getjump::Date->new("20.03.2015");
	is($d->string, '20.03.2015', 'constructor can take string d.m.Y');
}