#!/usr/bin/env genome-perl

BEGIN { 
    $ENV{UR_DBI_NO_COMMIT} = 1;
    $ENV{UR_USE_DUMMY_AUTOGENERATED_IDS} = 1;
}

use strict;
use warnings;

use above "Genome";
use Test::More;
use Genome::Utility::Test qw(compare_ok);
use Genome::Test::Factory::Process;
use Sub::Install qw(reinstall_sub);

use Genome::VariantReporting::Framework::FileLookup;
reinstall_sub({
    into => 'Genome::VariantReporting::Framework::FileLookup',
    as => 'calculate_lookup',
    code => sub {
        return shift;
    }
});
use Genome::VariantReporting::Framework::Component::Report::MergedReport;
reinstall_sub({
    into => 'Genome::VariantReporting::Framework::Component::Report::MergedReport',
    as => 'report_path',
    code => sub {
        return "/bed/path";
    }
});

use Cwd qw(abs_path);
reinstall_sub({
    into => 'Cwd',
    as => 'abs_path',
    code => sub {
        return shift;
    }
});
my $pkg = 'Genome::VariantReporting::Command::Wrappers::CreateIgvSession';
use_ok($pkg);

my $data_dir = __FILE__.".d";
my $expected_output = File::Spec->join($data_dir, "expected.xml");

my $bams = {
    label1 => "/fake/path1",
    label2 => "/fake/path2",
};

my $_JSON_CODEC = new JSON->allow_nonref;

my $merged_report = Genome::VariantReporting::Framework::Component::Report::MergedReport->__define__(
);

my $process = Genome::Test::Factory::Process->setup_object();

my $cmd = $pkg->create(
    bam_hash_json => $_JSON_CODEC->canonical->encode($bams),
    genome_name => "TEST",
    reference_name => "GRCh37-lite-build37",
    merged_bed_reports => [$merged_report],
    process_id => $process->id,
    label => 'igv_session',
);

ok($cmd->execute, "Command executed ok");
isa_ok($cmd->output_result, "Genome::VariantReporting::Command::Wrappers::IgvSession");
compare_ok($expected_output, $cmd->output_result->output_file_path, "xml file is correct");

done_testing;

