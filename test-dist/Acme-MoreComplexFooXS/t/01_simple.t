use strict;
use Test::More;

use Acme::MoreComplexFooXS;

is(Acme::MoreComplexFooXS::hello(), 42);

done_testing;

