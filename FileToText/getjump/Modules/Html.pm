package getjump::Modules::Html;

use strict;
use warnings;

use Data::Dumper;

use HTML::HTML5::Parser;
use HTML::HTML5::ToText;

use utf8;

our @VALID_TYPES = qw( text/html );
our @VALID_EXTENSIONS = qw ( html );

sub get_text
{
	my($self, $path) = @_;
	my $dom = HTML::HTML5::Parser->parse_file($path);
 print HTML::HTML5::ToText
     ->with_traits(qw/ShowLinks ShowImages RenderTables/)
     ->new()
     ->process($dom);
}

sub get_valid_types
{
	return @VALID_TYPES;
}

sub get_valid_extensions
{
	return @VALID_EXTENSIONS;
}