package Genome::Annotation::SimpleReporter;

use strict;
use warnings;
use Genome;

class Genome::Annotation::SimpleReporter {
    is => 'Genome::Annotation::ReporterWithHeaderBase',
    has => [
    ],
};

sub name {
    return 'simple';
}

sub requires_interpreters {
    return qw(position single-vep);
}

sub headers {
    return qw/
        chromosome_name
        start
        stop
        reference
        variant
        transcript_name
        trv_type
        amino_acid_change
        default_gene_name
        ensembl_gene_id
    /;
}

1;
