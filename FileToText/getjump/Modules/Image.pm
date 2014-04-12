package getjump::Modules::Image;

use strict;
use warnings;

use Image::ExifTool qw(:Public);

use Data::Dumper;

use utf8;

our @VALID_TYPES = qw( image/jpeg image/png );
our @VALID_EXTENSIONS = qw( jpg jpeg png );

sub get_text
{
	my($self, $path) = @_;
	my $hash = ImageInfo($path);

	return join("\n", map { "$_ => $$hash{$_}" } keys $hash);
}

sub get_valid_types
{
	return @VALID_TYPES;
}

sub get_valid_extensions
{
	return @VALID_EXTENSIONS;
}