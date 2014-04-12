package getjump::Modules::Text;

use strict;
use warnings;

use Data::Dumper;

use utf8;

our @VALID_TYPES = qw( application/octet-stream text/plain );
our @VALID_EXTENSIONS = qw ( txt );

sub get_text
{
	my($self, $path) = @_;
	local $/;
	open my $in, '<', $path;

	my $buffer = <$in>;

	close $in;
	return $buffer;
}

sub get_valid_types
{
	return @VALID_TYPES;
}

sub get_valid_extensions
{
	return @VALID_EXTENSIONS;
}