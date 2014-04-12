package getjump::Modules::Excel;

use strict;
use warnings;

use Data::Dumper;

use Win32::OLE;
use Win32::OLE::Enum;

our @VALID_TYPES = qw( application/doc application/docx );
our @VALID_EXTENSIONS = qw( xls xlsx );

sub max ($$) { $_[$_[0] < $_[1]] }

sub get_text
{
	my($self, $filename) = @_;
	my $excel = Win32::OLE->GetActiveObject('Excel.Application') ||
       Win32::OLE->new('Excel.Application');
	my $book = $excel->workbooks->open($filename);
	my $buffer;
	my @dat;
	my $maxSize = 0;
	my $rows = $excel->activesheet->usedrange->rows->count;
	my $cols = $excel->activesheet->usedrange->columns->count;
	for my $i(1..$rows)
	{
		for my $j(1..$cols)
		{
			$dat[$i-1][$j-1] = $excel->cells->{$i}->{$j}->text;
			$maxSize = max(length $dat[$i-1][$j-1], $maxSize);
		}
	}

	$maxSize++;

	my $spaces = '';

	for my $i(0..$rows-1)
	{
		for my $j(0..$cols-1)
		{
			$spaces = ' ' x ($maxSize-length($dat[$i][$j]));
			$buffer .= $spaces . $dat[$i][$j];
		}
		$buffer .= "\n";
	}

	$excel->quit();
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