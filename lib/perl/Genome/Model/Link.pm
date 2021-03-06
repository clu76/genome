package Genome::Model::Link;
#:adukes related code in G:Model

use strict;
use warnings;

use Genome;
class Genome::Model::Link {
    table_name => 'model.model_link',
    type_name => 'genome model link',
    id_by => [
        from_model_id => { is => 'Text', len => 32 },
        to_model_id => { is => 'Text', len => 32 },
    ],
    has => [
        role => { is => 'Text', len => 56 },
        from_model => {
            is => 'Genome::Model',
            id_by => 'from_model_id',
            constraint_name => 'GML_FB_GM_FK',
        },
        to_model => {
            is => 'Genome::Model',
            id_by => 'to_model_id',
            constraint_name => 'GML_TB_GM_FK',
        },
    ],
    unique_constraints => [
        { properties => [qw/from_model_id to_model_id/], sql => 'GML_PK' },
    ],
    schema_name => 'GMSchema',
    data_source => 'Genome::DataSource::GMSchema',
};

1;
