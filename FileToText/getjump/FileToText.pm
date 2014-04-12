package getjump::FileToText;

use strict;
use warnings;

use Getopt::Long;

use Module::Pluggable search_path => ['getjump::Modules'], require => 1;

use Data::Dumper;

use Cwd;
use File::MMagic;

use Getopt::Long;

our $VERSION = '1.0';

our %MODULES_FILE_TYPES = ();
our %MODULES_FILE_EXTENSIONS = ();

our %CHECK_BY_TYPE = (
		'text/plain' => 1,
		'application/octet-stream' => 1,
		'application/x-zip' => 1
	);

our $VERBOSE = 0;

sub new
{
	my($class, @data) = @_;
	my $self = {};
	bless $self, $class;
	return $self;
}

# file2text fileName
sub bootstrap
{
	my $force = '';
	my $help = '';
	my $version = '';
	my $mime = '';
	my $types = '';
	my $mimetypes = '';
	my $rating = '';

	GetOptions(
		'force=s' => \$force, 
		'version' => \$version, 
		'help' => \$help, 
		'mime' => \$mime,
		'types' => \$types,
		'mimetypes' => \$mimetypes,
		'rating' => \$rating,
		'verbose' => \$VERBOSE
	);

	return print 9.99 if $rating;
	return version_message() if $version;
	return help_message() if ($help || $#ARGV < 0) && !$types && !$mimetypes;
	load_modules();
	return show_mimetypes() if $mimetypes;
	return show_types() if $types;
	process($force, $mime);
}

sub process
{
	my($force, $mime) = @_;
	my $filename = $ARGV[0];
	if($filename)
	{
		my $path = getcwd . '/' . $filename;
		my $mm = new File::MMagic;
		my $filetype = $mm->checktype_filename($path);
		print "Mime is $filetype\n" if $VERBOSE;

		return print $filetype if $mime;

		my $data;
		
		if($filetype && $MODULES_FILE_TYPES{$filetype})
		{
			my ($ext) = $path =~ /\.([^.]+)$/;
			# print $ext;
			# print Dumper(\%MODULES_FILE_EXTENSIONS);
			
			print "Should we check by type : " . ($CHECK_BY_TYPE{$filetype} ? "Yes" : "No") . "\n" if $VERBOSE;
			print "Is `$ext` handler defined : " . ($MODULES_FILE_EXTENSIONS{$ext} ? "Yes" : "No") . "\n" if $VERBOSE;

			if($CHECK_BY_TYPE{$filetype} && $MODULES_FILE_EXTENSIONS{$ext})
			{
				$data = $MODULES_FILE_EXTENSIONS{$ext}->get_text($path);
				print "Calling by extension : $ext\n" if $VERBOSE;
				print "Using $MODULES_FILE_EXTENSIONS{$ext}\n" if $VERBOSE;
			} elsif($force) {
				$force = 'getjump::Modules::' . $force;
				$data = $force->get_text($path);
			} else {
				$data = $MODULES_FILE_TYPES{$filetype}->get_text($path);
				print "Calling by mimetype $filetype\n" if $VERBOSE;
				print "Using $MODULES_FILE_TYPES{$filetype}\n" if $VERBOSE;
			}
		} else {
			die "Unsupported file type : $filetype";
		}

		return unless $data;

		utf8::decode($data);

		if($ARGV[1])
		{
			open(my $out, ">", $ARGV[1]);
			print $out $data;
		} else {
			print $data;
		}
	}
}

sub load_modules
{
	map
	{
		my $plugin = $_;
		map { $MODULES_FILE_TYPES{$_} = $plugin } $_->get_valid_types();
		map { $MODULES_FILE_EXTENSIONS{$_} = $plugin } $_->get_valid_extensions();
	} plugins();
}

sub help_message
{
	print 'Usage : file2text filename [?output]' . "\n" .
	"    --mime to return file mime type\n" .
	"    --force=#PACKAGE_NAME# to force use some package\n" .
	"    --help show this message\n" .
	"    --version show version\n" .
	"    --types return available file types\n".
	"    --mimetypes return available mime types\n".
	"    --rating return rating that should be grant for this work\n";
}

sub show_types {
	map { print $_ . "\n" } sort keys%MODULES_FILE_EXTENSIONS;
}

sub show_mimetypes {
	map { print $_ . "\n" } sort keys %MODULES_FILE_TYPES;
}

sub version_message
{
	print 'file2text version ' . $VERSION . "\n";
}

1;