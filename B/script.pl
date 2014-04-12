open(my $in, "<", "input.txt");
open(my $out, ">", "output.txt");
  
$ls = <$in>;
$pattern = <$in>;
$text = <$in>;
 
sub min ($$) { $_[$_[0] > $_[1]] }
 
(substr $pattern, -2, 2) = "";

if($pattern eq "*")
{
	print $out 1;
	exit;
}

$patternh = $pattern;

$patternh =~ s/[*]/.{1, 100}?/g;

my @matchesh = $text =~ /$patternh/g;

 
$count = 1000000000;

foreach $d(@matchesh)
{
	print $d . "\n";
    $count = min(length($d), $count);
}
 
if($count == 1000000000)
{
    print $out -1;
} else {
    print $out $count;
}