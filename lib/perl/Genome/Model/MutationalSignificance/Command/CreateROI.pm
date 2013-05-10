package Genome::Model::MutationalSignificance::Command::CreateROI;

use strict;
use warnings;

use Genome;

class Genome::Model::MutationalSignificance::Command::CreateROI {
    is => ['Command::V2'],
    has_input => [
        annotation_build => {
            is => 'Genome::Model::Build::ImportedAnnotation'
        },
        excluded_reference_sequence_patterns => {
            is => 'Text',
            is_many => 1,
            is_optional => 1,
            doc => "Exclude transcripts on these reference sequences",
        },
        included_feature_type_patterns => {
            is => 'Text',
            is_many => 1,
            is_optional => 1,
            doc => 'Include only entries that match one of these patterns',
        },
        condense_feature_name => {
            is => 'Boolean',
            doc => 'Use only gene name as feature name',
            default_value => 1,
        },
        flank_size => {
            is => 'Integer',
            doc => 'Add this number of base pairs on each side of the feature', #to do: check this
            default_value => 0,
        },
        extra_rois => {
            is => 'String',
            is_many => 1,
            is_optional => 1,
        },
    ],
    has_output => [
        roi_path => {
            is => 'String',
        },
    ],
};

sub execute {
    my $self = shift;

    my @params;

    if ($self->excluded_reference_sequence_patterns) {
        push @params, excluded_reference_sequence_patterns => [$self->excluded_reference_sequence_patterns];
    }
    if ($self->included_feature_type_patterns) {
        push @params, included_feature_type_patterns => [$self->included_feature_type_patterns];
    }
    if ($self->condense_feature_name) {
        push @params, condense_feature_name => $self->condense_feature_name;
    }
    if ($self->flank_size && $self->flank_size > 0) {
        push @params, flank_size => $self->flank_size;
    }
    push @params, include_flank => 1;
    push @params, one_based => 1;

    my $feature_list = $self->annotation_build->get_or_create_roi_bed(@params);

    unless ($feature_list) {
        $self->error_message('ROI file not available from annotation build '.$self->annotation_build->id);
        return;
    }

    $self->roi_path($feature_list->file_path);
    
    my $new_name = $feature_list->name;
    for my $extra_roi ($self->extra_rois) {
        $new_name .= "_$extra_roi";
    }

    my $new_feature_list = Genome::FeatureList->get(name => $new_name);

    unless ($new_feature_list) {
        my $tmp = Genome::Sys->create_temp_file_path;
        #my $db_version = "build37";
        #my $species_name = "human";
        #my $encode_version = "2013-04-19";
        #my $encode_db = Genome::Db->get(source_name => "encode", database_name => "$species_name/$db_version", external_version => $encode_version);
        #if ($encode_db) {
        #    my $encode_dir = $encode_db->data_directory;

        #my $cmd = "cat ".$feature_list->file_path." $encode_dir/Thurman2012.bed $encode_dir/Yip2012_translated.bed > $tmp";
        #`$cmd`;
        my $sorted_out = Genome::Sys->create_temp_file_path;
        my $rv = Genome::Model::Tools::Joinx::Sort->execute(
            input_files => [$tmp, $self->extra_rois],
            unique => 1,
            output_file => $sorted_out,
        );
        my $file_content_hash = Genome::Sys->md5sum($sorted_out);

        my $format = $feature_list->format;

        $new_feature_list = Genome::FeatureList->create(
            name => $new_name,
            format => $format,
            file_content_hash => $file_content_hash,
            subject => $feature_list->subject,
            reference => $feature_list->reference,
            file_path => $sorted_out,
            content_type => "roi",
            description => "Feature list with extra rois",
            source => "WUTGI",
        );
        #}
        #else {
        #    $new_feature_list = $feature_list;
        #}

        unless ($new_feature_list) {
            $self->error_message("Failed to create ROI file with extra ROIs");
            return;
        }
    }
    $self->roi_path($new_feature_list->file_path);
    $self->status_message('Using ROI file: '.$self->roi_path);
    return 1;
}

1;
