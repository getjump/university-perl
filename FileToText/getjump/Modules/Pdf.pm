package getjump::Modules::Pdf;

use strict;
use warnings;

use Data::Dumper;

use utf8;

use CAM::PDF;
use CAM::PDF::PageText;

our @VALID_TYPES = qw( application/pdf );
our @VALID_EXTENSIONS = qw( pdf );

sub get_text
{
	my($self, $path) = @_;
	my $pdf = CAM::PDF->new($path);
	my $buffer = '';

	for my $page(1...$pdf->numPages())
	{
		$buffer .= $pdf->getPageText($page);
	}

	$buffer =~ s/[^\w\t\n ]//g;
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