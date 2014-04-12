package getjump::Date;

use strict;
use warnings;
use Carp;

use overload
	'""'     => \&string,
	'-'      => "subtract",
	'+'      => "add",
	'<=>'    => "compare",
	'cmp'    => "compare",
	fallback => 1;

our %DAYS_IN_MONTH = (
		1 => 31,
		2 => 28,
		3 => 31,
		4 => 30,
		5 => 31,
		6 => 30,
		7 => 31,
		8 => 31,
		9 => 30,
		10 => 31,
		11 => 30,
		12 => 31
	);

# self -> day, month, year

sub new
{
	my($class, @data) = @_;
	my $self = {};
	bless $self, $class;
	$self->_init(@data);
	$self->validate;
	return $self;
}

sub clone
{
	my($self) = @_;
	my $class = ref $self;
	my $new = $class->new;
	%$new = %$self;
	return $new;
}

sub validate
{
	my ($self) = @_;
	my $days = $DAYS_IN_MONTH{$self->{month}} or croak 'Month invalid';
	#1 <= $self->{month} && $self->{month} <= 12 or croak 'Month invalid';

	if ($self->{day} < 1 || $self->{day} > $DAYS_IN_MONTH{$self->{month}})
	{
		croak 'Days invalid';
	}
}

sub _init()
{
	my($self, @data) = @_;
	if(@data == 1)
	{
		# 19.03.2015
		my $string = shift @data;
		$string =~ /^(\d+).(\d+).(\d+)$/ or croak "Bad init string: $string";
		$self->set_date($1, $2, $3);
	} elsif(@data == 3)
	{
		# 19,3,2015
		$self->set_date(@data);
	} else {
		my ($S,$M,$H,$d,$m,$Y) = localtime(time());
		$m += 1;
		$Y += 1900;
		$self->set_date($d, $m, $Y);
	}

}

sub set_date
{
	my($self, $day, $month, $year) = @_;
	$self->{year} = int($year);
	$self->{month} = int($month);
	$self->{day} = int($day);
}

sub get_days_count
{
	my($self) = @_;
	$self->normalize;
	my $d = $self->{day};
	my $m = $self->{month};
	my $y = $self->{year};
	if($m < 3)
	{
		$y--;
		$m += 12;
	}
	return 365 * $y + $y / 4 - $y / 100 + $y / 400 + (153 * $m - 457) / 5 + $d - 306;
}

sub normalize
{
	my($self) = @_;
	my $flag = 1;
	while($flag)
	{
		my $c = int($self->{month}/12);
		my $m = $self->{month} % 12;
		if($self->{month} > 12)
		{
			$self->{year} += $c;
			$self->{month} = $m == 0 ? 1 : $m;
		}
		elsif($self->{month} < 1)
		{
			$self->{year} -= $c == 0 ? 1 : $c;
			$self->{month} = 12 - $m;
		}

		my $dm = $DAYS_IN_MONTH{$self->{month}};
		if($self->{month} == 2 && $self->is_leap_year)
		{
			$dm += 1;
		}

		if($self->{day} > $dm)
		{
			$self->{month}++;
			$self->{day} -= $dm;
			next;
		} elsif ($self->{day} < 1)
		{
			$self->{month}--;
			$self->{day} += $self->{month} - 1 < 0 ? 31 : $DAYS_IN_MONTH{$self->{month}};
			if($self->is_leap_year && $self->{month} == 2)
			{
				$self->{day}++;
			}
			next;
		}

		$flag = 0;
	}
}

sub is_leap_year
{
	my($self) = @_;
	return ($self->{year} % 4 == 0 && $self->{year} % 100 != 0) || ($self->{year} % 400 == 0);
}

sub delta_days
{
	my($self, $date) = @_;
	return $self->get_days_count - $date->get_days_count;
}

sub add
{
	my($self, $days) = @_;
	my $date = $self->clone;
	$date->{day} += $days;
	return $date;
}

sub subtract
{
	my($self, $days) = @_;
	my $date = $self->clone;
	$date->{day} -= $days;
	return $date;
}

sub string
{
	my($self) = @_;
	$self->normalize;
	return sprintf("%02d.%02d.%04d", $self->{day}, $self->{month}, $self->{year});
}

sub compare
{
	my($self, $date) = @_;
	return $self->get_days_count <=> $date->get_days_count;
}

1;

__END__