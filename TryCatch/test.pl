use getjump::TryCatch;
use getjump::Error;
use Data::Dumper;
use CustomException;

try
{
	getjump::Error->throw("test");
} catch CustomException with {
	
}