package getjump::Modules::Tar;

use strict;
use warnings;

use Data::Dumper;

use utf8;

use Archive::Tar;

our @VALID_TYPES = qw( application/octet-stream );
our @VALID_EXTENSIONS = qw( tar );

sub get_text
{
	my($self, $path) = @_;
	my $tar = Archive::Tar->new();

	$tar->read($path);

	my @files = $tar->list_files();
	
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