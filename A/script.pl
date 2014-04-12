open(my $in, "<", "text.in");
open(my $out, ">", "text.out");
 
$lim = <$in>;
$str = <$in>;
 
@words = split /\s+/, $str;
 
$newString = "";
$currentLength = 0;
$newLine = 0;
 
foreach $word(@words)
{
    $wordLength = length($word);
    if($currentLength + $wordLength > $lim)
    {
		(substr $newString, -1, 1) = "";
        $currentLength = 0;
        $newString .= "\n";
		$newLine = 1;
    }
     
    $currentLength += $wordLength + 1;
    $newString .= $word;
    $newString .= " " if \$word != \$words[-1];
	$newLine = 0 if $newLine;
}
 
print $out $newString;