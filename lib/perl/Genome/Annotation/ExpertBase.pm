package Genome::Annotation::ExpertBase;

use strict;
use warnings FATAL => 'all';
use Genome;
use Params::Validate qw(validate_pos validate :types);

class Genome::Annotation::ExpertBase {
    is => 'Genome::Annotation::ComponentBase',
    is_abstract => 1,
};

sub adaptor_class {
    my $self = shift;
    my $factory = Genome::Annotation::Factory->create();
    return $factory->get_class('adaptors', $self->name);
}

sub build_adaptor_operation {
    my $self = shift;
    return Genome::WorkflowBuilder::Command->create(
        name => 'Get inputs from build',
        command => $self->adaptor_class,
    );
}

sub connected_build_adaptor_operation {
    my ($self, $dag) = validate_pos(@_, 1, 1);

    my $build_adaptor_op = $self->build_adaptor_operation;
    $dag->add_operation($build_adaptor_op);
    $dag->connect_input(
        input_property => 'build_id',
        destination => $build_adaptor_op,
        destination_property => 'build_id',
    );
    $dag->connect_input(
        input_property => 'variant_type',
        destination => $build_adaptor_op,
        destination_property => 'variant_type',
    );
    return $build_adaptor_op;
}

sub dag {
    #   Must return a Genome::WorkflowBuilder::DAG
    # these usually just consist of a build_adaptor
    # followed by a single command, but could be
    # more complex.

    # DAG INPUTS:
    #   build_id
    #   input_result  (Genome::SoftwareResult that has a
    #                  'output_file_path' accessor that refers
    #                  to a .vcf or .vcf.gz file. or a 'get_vcf'
    #                  accessor which takes a 'variant_type'
    #                  argument to refer to a .vcf or .vcf.gz
    #                  file)
    # DAG OUTPUTS:
    #   software_result (Same requirements as <input_result>)
    die "Abstract";
}

sub _link {
    my $self = shift;
    my %p = validate(@_, {
        dag => {isa => 'Genome::WorkflowBuilder::DAG'},
        adaptor => {isa => 'Genome::WorkflowBuilder::Command'},
        previous => {type => OBJECT | UNDEF},
        target => {isa => 'Genome::WorkflowBuilder::Command'},
    });

    if (defined $p{previous}) {
        $p{dag}->create_link(
            source => $p{previous},
            source_property => 'output_result',
            destination => $p{target},
            destination_property => 'input_result',
        );
    }

    for my $name ($p{target}->command->input_names) {
        next if $name eq 'input_result';
        next unless $p{adaptor}->command->can($name);
        $p{dag}->create_link(
            source => $p{adaptor},
            source_property => $name,
            destination => $p{target},
            destination_property => $name,
        );
    }
}

1;