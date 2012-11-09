#!/usr/bin/env genome-perl

use strict;
use warnings;

use above "Genome";
use File::Temp;
use Test::More tests => 13;
use Data::Dumper;

$ENV{UR_DBI_NO_COMMIT} = 1;
$ENV{UR_USE_DUMMY_AUTOGENERATED_IDS} = 1;

BEGIN {
    use_ok( 'Genome::Model::Tools::DetectVariants2::Filter::VarFilterIndel')
};

my $refbuild_id = 101947881;
my $test_data_directory = $ENV{GENOME_TEST_INPUTS} . "/Genome-Model-Tools-DetectVariants2-Filter-VarFilterIndel";

# Updated to .v2 for correcting an error with newlines
# v2: change FT description
my $expected_directory     = $test_data_directory . "/filter_result/v2";
my $detector_directory     = $test_data_directory . "/detector_result";
my $detector_vcf_directory = $test_data_directory . "/detector_vcf_result";
my $tumor_bam_file   = $test_data_directory. '/virtual_tumor_sorted.bam';
my $normal_bam_file  = $test_data_directory. '/virtual_normal_sorted.bam';

my $test_output_base = File::Temp::tempdir(
    'Genome-Model-Tools-DetectVariants2-Filter-VarFilterIndel-XXXXX', 
    DIR     => "$ENV{GENOME_TEST_TEMP}", 
    CLEANUP => 1,
);
my $test_output_dir = $test_output_base . '/filter';

my $vcf_version = Genome::Model::Tools::Vcf->get_vcf_version;

my @expected_output_files = qw( 
    indels.hq
    indels.hq.bed
    indels.hq.v1.bed
    indels.hq.v2.bed
    indels.lq
    indels.lq.bed
    indels.lq.v1.bed
    indels.lq.v2.bed 
);

my $detector_result = Genome::Model::Tools::DetectVariants2::Result->__define__(
    output_dir            => $detector_directory,
    detector_name         => 'Genome::Model::Tools::DetectVariants2::Samtools',
    detector_params       => 'something',  #does not matter
    detector_version      => 'r963',
    aligned_reads         => $tumor_bam_file,
    control_aligned_reads => $normal_bam_file,
    reference_build_id    => $refbuild_id,
);

my $detector_vcf_result = Genome::Model::Tools::DetectVariants2::Result::Vcf::Detector->__define__(
    input                => $detector_result,
    output_dir           => $detector_vcf_directory,
    aligned_reads_sample => "TEST",
    vcf_version          => $vcf_version,
);

$detector_result->add_user(user => $detector_vcf_result, label => 'uses');

my $var_filter_high_confidence = Genome::Model::Tools::DetectVariants2::Filter::VarFilterIndel->create(
    previous_result_id => $detector_result->id,
    output_directory   => $test_output_dir,
);

ok($var_filter_high_confidence, "created VarFilterIndel object");
ok($var_filter_high_confidence->execute(), "executed VarFilterIndel");

for my $output_file (@expected_output_files){
    my $expected_file = $expected_directory."/".$output_file;
    my $actual_file   = $test_output_dir."/".$output_file;
    my $diff_out      = Genome::Sys->diff_file_vs_file($expected_file, $actual_file);
    ok(!$diff_out, "$output_file output matched expected output") or diag("diff:\n". $diff_out);
}

ok(-s $test_output_dir."/indels.vcf.gz", "Found indels.vcf.gz"); 

my $expected_vcf = "$expected_directory/indels.vcf.gz";
my $output_vcf   = "$test_output_dir/indels.vcf.gz";
my $expected     = `zcat $expected_vcf | grep -v fileDate`;
my $output       = `zcat $output_vcf | grep -v fileDate`;
my $diff = Genome::Sys->diff_text_vs_text($output, $expected);
ok(!$diff, 'indels.vcf.gz output matched expected output')
    or diag("diff results:\n" . $diff);
done_testing();

