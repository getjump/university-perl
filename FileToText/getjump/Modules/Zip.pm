package getjump::Modules::Zip;

use strict;
use warnings;

use Data::Dumper;

use utf8;

use Archive::Zip;

our @VALID_TYPES = qw( application/zip );
our @VALID_EXTENSIONS = qw( zip );

sub get_text
{
	my($self, $path) = @_;
	my $zip = Archive::Zip->new();

	$zip->read($path);

	my @files = $zip->memberNames();
	
	return join("\n", @files);
}

sub get_valid_types
{
	return @VALID_TYPES;
}

sub get_valid_extensions
{
	return @VALID_EXTENSIONS;
}