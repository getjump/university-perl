use Test::Harness;

runtests(map "$_.t", qw(01-constructors 02-date_comparision 03-date_binary_operations 04-date_deltas 05-validation));

'haha return 1 they said';