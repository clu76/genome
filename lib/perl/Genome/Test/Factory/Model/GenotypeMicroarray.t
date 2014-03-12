#!/gsc/bin/perl

BEGIN { 
    $ENV{UR_DBI_NO_COMMIT} = 1;
    $ENV{UR_USE_DUMMY_AUTOGENERATED_IDS} = 1;
}

use strict;
use warnings;

use above "Genome";
use Test::More;

use_ok("Genome::Test::Factory::Model::GenotypeMicroarray");

my $m = Genome::Test::Factory::Model::GenotypeMicroarray->setup_object();
ok($m->isa("Genome::Model::GenotypeMicroarray"), "Generated a genotype microarray model");

done_testing;