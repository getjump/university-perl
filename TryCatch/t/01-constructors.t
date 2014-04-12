use strict;
use warnings;
use Test::More;
use lib '..';
use getjump::TryCatch;

subtest 'Try Catch Default' => sub {

	my $called;

	try
	{
		die "1";
	}
	catch
	{
		#print @_;
	}
	finally
	{

	}
}