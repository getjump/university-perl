open(my $in, "<", "input.txt");
open(my $out, ">", "output.txt");
 
$first = <$in>;
$second = <$in>;

(substr $first, -2, 2) = "";

print $first . "\n";
print $second;

$root = 0;

