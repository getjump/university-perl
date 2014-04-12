package getjump::Modules::Latex;

use strict;
use warnings;

use Data::Dumper;

use utf8;

our @VALID_TYPES = qw( application/tex );
our @VALID_EXTENSIONS = qw ( tex out );

sub get_text
{
	my($self, $path) = @_;
	open my $in, '<', $path;

	my $inpreamble = 1;
	my @lines = ();

	my %keeparguments=("textit"=>1,
                        "underline"=>1,
                        "dfrac"=>1,
                        "bookmark"=>1                    
                        );

	my $buffer = '';

	while(<$in>)
      {
          # check that the document has begun
          if($_ =~ m/\\begin{document.*/)
          {
              $inpreamble=0;   
          }
          # ignore the preamble, and make string substitutions in 
          # the main document
         if(!$inpreamble) 
         {
             # remove \begin{<stuff>}[<optional arguments>]
             s/\\begin{.*?}(\[.*?\])?({.*?})?//g;
             # remove \end{<stuff>}
             s/\\end{.*?}//g;
             # remove \<commandname>{with argument}
             while ($_ =~ m/\\(.*?){.*?}/)
             {
                if($keeparguments{$1})
                {
                  s/\\.*?{(.*?)}/$1/;
                }
                else
                {
                  s/\\.*?{.*?}//;
                }
             }
             # print the current line (if we're not overwritting the current file)
             push(@lines, $_);
         }
     }

     $buffer = join('', @lines);

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