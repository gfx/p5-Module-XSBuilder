use strict;
use warnings;
use utf8;
use Test::More;

use File::Temp qw(tempdir);
use File::pushd;
use File::Spec;
use File::Copy::Recursive qw(rcopy);

use Config ();

my @dists = @ARGV;
if (! @dists) {
    @dists = glob('test-dist/*');
}

my %std_inc = map { $_ => 1 } @Config::Config{qw(
    sitelibexp sitearchexp
    privlibexp archlibexp
)};
my @non_std_inc = map { File::Spec->rel2abs($_) }
                 grep { not $std_inc{$_} } @INC;

my @perl_opts = map { "-I$_" } @non_std_inc;

sub cmd_perl {
    my(@args) = @_;

    system($^X, @perl_opts, @args);
}


foreach my $dist (@dists) {
    note "testing $dist";

    my $tempdir = tempdir(CLEANUP => 1, DIR => '.');

    rcopy($dist, "$tempdir/$dist");

    my $guard = pushd("$tempdir/$dist");

    is cmd_perl('Build.PL'),      0, 'perl Build.PL' or die;
    is cmd_perl('Build'),         0, './Build' or die;
    is cmd_perl('Build', 'test'), 0, './Build test' or die;
}
done_testing;

