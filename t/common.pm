package # Hide from PAUSE
    t::common;

use 5.006_000;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Exporter';
our @EXPORT_OK = qw(
    new_fh new_dir
);

use File::Spec ();
use File::Temp qw( tempfile tempdir );
use Fcntl qw( :flock );

my $parent = $ENV{WORK_DIR} || File::Spec->tmpdir || $ENV{TEMP};
print "\$parent=$parent\n";
my $dir = tempdir( CLEANUP => 1, DIR => $parent );
print "\$dir=$dir\n";
#my $dir = tempdir( DIR => '.' );

sub new_dir {
	tempdir( CLEANUP => 1, DIR => $dir )
}

sub new_fh {
    my ($fh, $filename) = tempfile( 'tmpXXXX', DIR => $dir, UNLINK => 1 );

    # This is because tempfile() returns a flock'ed $fh on MacOSX.
    flock $fh, LOCK_UN;

    return ($fh, $filename);
}

1;
__END__