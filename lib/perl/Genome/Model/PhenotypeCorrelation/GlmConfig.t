#!/usr/bin/env perl

use File::Slurp qw/read_file/;
use File::Temp qw();
use Data::Dumper;
use Test::More;
use above 'Genome';

use strict;
use warnings;

BEGIN {
    $ENV{UR_DBI_NO_COMMIT} = 1;
    $ENV{UR_USE_DUMMY_AUTOGENERATED_IDS} = 1;
}

my $tmpdir = File::Temp->newdir();
my $output_file = "$tmpdir/glm-model.txt";

my $pkg = 'Genome::Model::PhenotypeCorrelation::GlmConfig';
use_ok($pkg);

my @lines;
my $pos = tell DATA;
while (my $line = <DATA>) {
    chomp $line;
    push(@lines, $line);
}
seek DATA, $pos, 0;
my $fh = *DATA;
my $obj = $pkg->from_filehandle($fh);
ok($obj, "Created GlmConfig object from filehandle");
my $obj_mem = $pkg->from_string_arrayref([@lines[1..$#lines]]);
ok($obj_mem, "Created GlmConfig object from arrayref");
is($obj->to_string, $obj_mem->to_string, "Loading from fh or array are equivalent");

my $expected_str = join("\n", @lines) . "\n";
$expected_str =~ s/ //g;
is($obj->to_string, $expected_str, "to_string ok");

my @expected_array = split("\n", $expected_str);
shift(@expected_array);

is_deeply($obj->to_arrayref, \@expected_array, "to_arrayref ok");

my $tmp_path = "$tmpdir/glm-model.txt";
$obj->to_file($tmp_path);
ok(-s $tmp_path, "to_file produces output");
my $contents = read_file($tmp_path);
is($contents, $expected_str, "output file contents ok");
my $obj_file = $pkg->from_file($tmp_path);
is($obj_file->to_string, $expected_str, "loading from file ok");


my @attributes = $obj->attributes;
is(scalar @attributes, 6, "Got all 6 attributes");
is(join(",", map {$_->{attr_name}} @attributes), "quant1,quant2,quant3,cat1,cat2,cat3", "Trait ordering ok");
my @cattributes = $obj->categorical_attributes;
my @qattributes = $obj->quantitative_attributes;
is(@cattributes, 3, "Got 3 categorical attributes");
is(@qattributes, 3, "Got 3 quantitative attributes");
is(join("", map {$_->{type}} @cattributes), "BBB", "Categorical attributes have correct type");
is(join("", map {$_->{type}} @qattributes), "QQQ", "Quantitative attributes have correct type");

my @result = $obj->attributes(qw/quant3 cat2/);
is(scalar(@result), 2, "Query by name");
is($result[0]->{attr_name}, "quant3", "Query by name");
is($result[1]->{attr_name}, "cat2", "Query by name");

is(join(",", @{$obj->attributes("quant1")->{covariates}}), "CV1,CV2,CV3", "quant1 covariates ok");
is(join(",", @{$obj->attributes("quant2")->{covariates}}), "CV4,CV5,CV6", "quant1 covariates ok");
is(scalar @{$obj->attributes("quant3")->{covariates}}, 0, "quant3 covariates ok");
is(join(",", @{$obj->attributes("cat1")->{covariates}}), "CV1,CV2,CV3", "cat1 covariates ok");
is(join(",", @{$obj->attributes("cat2")->{covariates}}), "CV4,CV5,CV6", "cat1 covariates ok");
is(scalar @{$obj->attributes("cat3")->{covariates}}, 0, "cat3 covariates ok");

done_testing();

__DATA__
analysis_type	clinical_data_trait_name	variant/gene_name	covariates	memo
Q	quant1	NA	CV1+CV2+CV3	
Q	quant2	NA	CV4+CV5+ CV6	
Q	quant3	NA	NA	
B	cat1	NA	CV1 +CV2+CV3	
B	cat2	NA	CV4 + CV5   + CV6	
B	cat3	NA	NA	
