package getjump::Modules::Archive;

use strict;
use warnings;

use Archive::Extract;

use Data::Dumper;

use utf8;

our @VALID_TYPES = qw( application/x-zip );
our @VALID_EXTENSIONS = qw( zip tar tar.gz gz bz2 tar.gz2 lzma xz tar.xz txz );

sub get_text
{
	my($self, $path) = @_;
	my $ae = Archive::Extract->new( archive => $path );
	my $files = $ae->files;
	print $files;
}

sub get_valid_types
{
	return @VALID_TYPES;
}

sub get_valid_extensions
{
	return @VALID_EXTENSIONS;
}