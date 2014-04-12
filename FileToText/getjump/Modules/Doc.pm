package getjump::Modules::Doc;

use strict;
use warnings;

use Data::Dumper;

use Win32::OLE;
use Win32::OLE::Enum;

our @VALID_TYPES = qw( application/doc application/docx application/rtf );
our @VALID_EXTENSIONS = qw( doc docx rtf );

sub get_text
{
	my($self, $filename) = @_;
	my $document = Win32::OLE->GetObject($filename);
	my $paragraphs = $document->Paragraphs();
	my $enumerate = new Win32::OLE::Enum($paragraphs);
	my $paragraph;
	my $buffer = '';
	while(defined($paragraph = $enumerate->Next()))
    {
    	my $text = $paragraph->{Range}->{Text};
    	$text =~ s/[\n\r]//g;
    	$text =~ s/\x0b/\n/g;
    	$buffer .= $text . "\n";
    }

    $document->close();

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