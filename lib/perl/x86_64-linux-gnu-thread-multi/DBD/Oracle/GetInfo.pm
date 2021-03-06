package DBD::Oracle::GetInfo;

use strict;
use DBD::Oracle();

my $sql_driver = 'Oracle';
my $sql_ver_fmt = '%02d.%02d.%04d';   # ODBC version string: ##.##.#####

my $sql_driver_ver = sprintf $sql_ver_fmt, split (/\./, "$DBD::Oracle::VERSION.0.0.0.0.0.0");

sub sql_dbms_version {
    my $dbh = shift;
    local $^W; # for ora_server_version having too few parts
    return sprintf $sql_ver_fmt, @{DBD::Oracle::db::ora_server_version($dbh)};
}

my @Keywords = qw(
ACCESS
AUDIT
BFILE
BLOB
CLOB
CLUSTER
COMMENT
COMPRESS
EXCLUSIVE
FILE
IDENTIFIED
INCREMENT
INITIAL
LOCK
LONG
MAXEXTENTS
MINUS
MODE
MODIFY
NCLOB
NOAUDIT
NOCOMPRESS
NOWAIT
NUMBER
OFFLINE
ONLINE
PCTFREE
RAW
RENAME
RESOURCE
ROW
ROWID
ROWLABEL
ROWNUM
SHARE
START
SUCCESSFUL
SYNONYM
SYSDATE
TRIGGER
UID
VALIDATE
VARCHAR
);


sub sql_keywords {

    return join ',', @Keywords;

}



sub sql_data_source_name {
    my $dbh = shift;
    return "dbi:$sql_driver:" . $dbh->{Name};
}

sub sql_user_name {
    my $dbh = shift;
    # CURRENT_USER is a non-standard attribute, probably undef
    # Username is a standard DBI attribute
    return $dbh->{CURRENT_USER} || $dbh->{Username};
}


our %info = (
     20 => 'Y',                           # SQL_ACCESSIBLE_PROCEDURES
     19 => 'Y',                           # SQL_ACCESSIBLE_TABLES
      0 => 0,                             # SQL_ACTIVE_CONNECTIONS
    116 => 0,                             # SQL_ACTIVE_ENVIRONMENTS
      1 => 0,                             # SQL_ACTIVE_STATEMENTS
    169 => 64,                            # SQL_AGGREGATE_FUNCTIONS
    117 => 0,                             # SQL_ALTER_DOMAIN
     86 => 1029739,                       # SQL_ALTER_TABLE
  10021 => 2,                             # SQL_ASYNC_MODE
    120 => 0,                             # SQL_BATCH_ROW_COUNT
    121 => 0,                             # SQL_BATCH_SUPPORT
     82 => 88,                            # SQL_BOOKMARK_PERSISTENCE
    114 => 2,                             # SQL_CATALOG_LOCATION
  10003 => 'N',                           # SQL_CATALOG_NAME
     41 => '@',                           # SQL_CATALOG_NAME_SEPARATOR
     42 => 'Database Link',               # SQL_CATALOG_TERM
     92 => 3,                             # SQL_CATALOG_USAGE
  10004 => '',                            # SQL_COLLATING_SEQUENCE
  10004 => '',                            # SQL_COLLATION_SEQ
     87 => 'Y',                           # SQL_COLUMN_ALIAS
     22 => 1,                             # SQL_CONCAT_NULL_BEHAVIOR
     53 => 10518015,                      # SQL_CONVERT_BIGINT
     54 => 10775839,                      # SQL_CONVERT_BINARY
     55 => 10518015,                      # SQL_CONVERT_BIT
     56 => 15106047,                      # SQL_CONVERT_CHAR
     57 => 164097,                        # SQL_CONVERT_DATE
     58 => 10518015,                      # SQL_CONVERT_DECIMAL
     59 => 10514943,                      # SQL_CONVERT_DOUBLE
     60 => 10514943,                      # SQL_CONVERT_FLOAT
     48 => 1,                             # SQL_CONVERT_FUNCTIONS
    173 => 0,                             # SQL_CONVERT_GUID
     61 => 10518015,                      # SQL_CONVERT_INTEGER
    123 => 0,                             # SQL_CONVERT_INTERVAL_DAY_TIME
    124 => 0,                             # SQL_CONVERT_INTERVAL_YEAR_MONTH
     71 => 265216,                        # SQL_CONVERT_LONGVARBINARY
     62 => 14680833,                      # SQL_CONVERT_LONGVARCHAR
     63 => 10518015,                      # SQL_CONVERT_NUMERIC
     64 => 10514943,                      # SQL_CONVERT_REAL
     65 => 10518015,                      # SQL_CONVERT_SMALLINT
     66 => 0,                             # SQL_CONVERT_TIME
     67 => 10718465,                      # SQL_CONVERT_TIMESTAMP
     68 => 10518015,                      # SQL_CONVERT_TINYINT
     69 => 10775839,                      # SQL_CONVERT_VARBINARY
     70 => 15204351,                      # SQL_CONVERT_VARCHAR
    122 => 15106047,                      # SQL_CONVERT_WCHAR
    125 => 14680833,                      # SQL_CONVERT_WLONGVARCHAR
    126 => 15106047,                      # SQL_CONVERT_WVARCHAR
     74 => 2,                             # SQL_CORRELATION_NAME
    127 => 0,                             # SQL_CREATE_ASSERTION
    128 => 0,                             # SQL_CREATE_CHARACTER_SET
    129 => 0,                             # SQL_CREATE_COLLATION
    130 => 0,                             # SQL_CREATE_DOMAIN
    131 => 3,                             # SQL_CREATE_SCHEMA
    132 => 14305,                         # SQL_CREATE_TABLE
    133 => 0,                             # SQL_CREATE_TRANSLATION
    134 => 3,                             # SQL_CREATE_VIEW
     23 => 2,                             # SQL_CURSOR_COMMIT_BEHAVIOR
     24 => 2,                             # SQL_CURSOR_ROLLBACK_BEHAVIOR
  10001 => 1,                             # SQL_CURSOR_SENSITIVITY
     16 => 'DEVEL',                       # SQL_DATABASE_NAME
      2 => \&sql_data_source_name,        # SQL_DATA_SOURCE_NAME
     25 => 'N',                           # SQL_DATA_SOURCE_READ_ONLY
    119 => 0,                             # SQL_DATETIME_LITERALS
     17 => 'Oracle',                      # SQL_DBMS_NAME
     18 => \&sql_dbms_version,            # SQL_DBMS_VER
     18 => \&sql_dbms_version,            # SQL_DBMS_VERSION
    170 => 3,                             # SQL_DDL_INDEX
     26 => 8,                             # SQL_DEFAULT_TRANSACTION_ISOLATION
     26 => 8,                             # SQL_DEFAULT_TXN_ISOLATION
  10002 => 'Y',                           # SQL_DESCRIBE_PARAMETER
    171 => '03.52.0002.0002',             # SQL_DM_VER
      3 => 147209344,                     # SQL_DRIVER_HDBC
#   135 => undef,                         # SQL_DRIVER_HDESC
      4 => 147212776,                     # SQL_DRIVER_HENV
#    76 => undef,                         # SQL_DRIVER_HLIB
#     5 => undef,                         # SQL_DRIVER_HSTMT
      6 => $INC{'DBD/Oracle.pm'},         # SQL_DRIVER_NAME
     77 => '03.52',                       # SQL_DRIVER_ODBC_VER
      7 => $sql_driver_ver,               # SQL_DRIVER_VER
    136 => 0,                             # SQL_DROP_ASSERTION
    137 => 0,                             # SQL_DROP_CHARACTER_SET
    138 => 0,                             # SQL_DROP_COLLATION
    139 => 0,                             # SQL_DROP_DOMAIN
    140 => 0,                             # SQL_DROP_SCHEMA
    141 => 1,                             # SQL_DROP_TABLE
    142 => 0,                             # SQL_DROP_TRANSLATION
    143 => 1,                             # SQL_DROP_VIEW
    144 => 0,                             # SQL_DYNAMIC_CURSOR_ATTRIBUTES1
    145 => 0,                             # SQL_DYNAMIC_CURSOR_ATTRIBUTES2
     27 => 'Y',                           # SQL_EXPRESSIONS_IN_ORDERBY
      8 => 191,                           # SQL_FETCH_DIRECTION
     84 => 0,                             # SQL_FILE_USAGE
    146 => 57345,                         # SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES1
    147 => 2183,                          # SQL_FORWARD_ONLY_CURSOR_ATTRIBUTES2
     81 => 15,                            # SQL_GETDATA_EXTENSIONS
     88 => 2,                             # SQL_GROUP_BY
     28 => 1,                             # SQL_IDENTIFIER_CASE
     29 => '"',                           # SQL_IDENTIFIER_QUOTE_CHAR
    148 => 3,                             # SQL_INDEX_KEYWORDS
    149 => 65568,                         # SQL_INFO_SCHEMA_VIEWS
    172 => 7,                             # SQL_INSERT_STATEMENT
     73 => 'N',                           # SQL_INTEGRITY
    150 => 0,                             # SQL_KEYSET_CURSOR_ATTRIBUTES1
    151 => 0,                             # SQL_KEYSET_CURSOR_ATTRIBUTES2
     89 => \&sql_keywords,                # SQL_KEYWORDS
    113 => 'Y',                           # SQL_LIKE_ESCAPE_CLAUSE
     78 => 1,                             # SQL_LOCK_TYPES
     34 => 0,                             # SQL_MAXIMUM_CATALOG_NAME_LENGTH
     97 => 0,                             # SQL_MAXIMUM_COLUMNS_IN_GROUP_BY
     98 => 0,                             # SQL_MAXIMUM_COLUMNS_IN_INDEX
     99 => 0,                             # SQL_MAXIMUM_COLUMNS_IN_ORDER_BY
    100 => 1000,                          # SQL_MAXIMUM_COLUMNS_IN_SELECT
    101 => 1000,                          # SQL_MAXIMUM_COLUMNS_IN_TABLE
     30 => 30,                            # SQL_MAXIMUM_COLUMN_NAME_LENGTH
      1 => 0,                             # SQL_MAXIMUM_CONCURRENT_ACTIVITIES
     31 => 30,                            # SQL_MAXIMUM_CURSOR_NAME_LENGTH
      0 => 0,                             # SQL_MAXIMUM_DRIVER_CONNECTIONS
  10005 => 30,                            # SQL_MAXIMUM_IDENTIFIER_LENGTH
    102 => 0,                             # SQL_MAXIMUM_INDEX_SIZE
    104 => 0,                             # SQL_MAXIMUM_ROW_SIZE
     32 => 30,                            # SQL_MAXIMUM_SCHEMA_NAME_LENGTH
    105 => 0,                             # SQL_MAXIMUM_STATEMENT_LENGTH
# 20000 => undef,                         # SQL_MAXIMUM_STMT_OCTETS
# 20001 => undef,                         # SQL_MAXIMUM_STMT_OCTETS_DATA
# 20002 => undef,                         # SQL_MAXIMUM_STMT_OCTETS_SCHEMA
    106 => 0,                             # SQL_MAXIMUM_TABLES_IN_SELECT
     35 => 30,                            # SQL_MAXIMUM_TABLE_NAME_LENGTH
    107 => 30,                            # SQL_MAXIMUM_USER_NAME_LENGTH
  10022 => 0,                             # SQL_MAX_ASYNC_CONCURRENT_STATEMENTS
    112 => 0,                             # SQL_MAX_BINARY_LITERAL_LEN
     34 => 0,                             # SQL_MAX_CATALOG_NAME_LEN
    108 => 0,                             # SQL_MAX_CHAR_LITERAL_LEN
     97 => 0,                             # SQL_MAX_COLUMNS_IN_GROUP_BY
     98 => 0,                             # SQL_MAX_COLUMNS_IN_INDEX
     99 => 0,                             # SQL_MAX_COLUMNS_IN_ORDER_BY
    100 => 1000,                          # SQL_MAX_COLUMNS_IN_SELECT
    101 => 1000,                          # SQL_MAX_COLUMNS_IN_TABLE
     30 => 30,                            # SQL_MAX_COLUMN_NAME_LEN
      1 => 0,                             # SQL_MAX_CONCURRENT_ACTIVITIES
     31 => 30,                            # SQL_MAX_CURSOR_NAME_LEN
      0 => 0,                             # SQL_MAX_DRIVER_CONNECTIONS
  10005 => 30,                            # SQL_MAX_IDENTIFIER_LEN
    102 => 0,                             # SQL_MAX_INDEX_SIZE
     32 => 30,                            # SQL_MAX_OWNER_NAME_LEN
     33 => 92,                            # SQL_MAX_PROCEDURE_NAME_LEN
     34 => 0,                             # SQL_MAX_QUALIFIER_NAME_LEN
    104 => 0,                             # SQL_MAX_ROW_SIZE
    103 => 'N',                           # SQL_MAX_ROW_SIZE_INCLUDES_LONG
     32 => 30,                            # SQL_MAX_SCHEMA_NAME_LEN
    105 => 0,                             # SQL_MAX_STATEMENT_LEN
    106 => 0,                             # SQL_MAX_TABLES_IN_SELECT
     35 => 30,                            # SQL_MAX_TABLE_NAME_LEN
    107 => 30,                            # SQL_MAX_USER_NAME_LEN
     37 => 'Y',                           # SQL_MULTIPLE_ACTIVE_TXN
     36 => 'Y',                           # SQL_MULT_RESULT_SETS
    111 => 'N',                           # SQL_NEED_LONG_DATA_LEN
     75 => 1,                             # SQL_NON_NULLABLE_COLUMNS
     85 => 1,                             # SQL_NULL_COLLATION
     49 => 16646015,                      # SQL_NUMERIC_FUNCTIONS
      9 => 1,                             # SQL_ODBC_API_CONFORMANCE
    152 => 3,                             # SQL_ODBC_INTERFACE_CONFORMANCE
     12 => 0,                             # SQL_ODBC_SAG_CLI_CONFORMANCE
     15 => 1,                             # SQL_ODBC_SQL_CONFORMANCE
     73 => 'N',                           # SQL_ODBC_SQL_OPT_IEF
     10 => '03.52',                       # SQL_ODBC_VER
    115 => 127,                           # SQL_OJ_CAPABILITIES
     90 => 'N',                           # SQL_ORDER_BY_COLUMNS_IN_SELECT
     38 => 'Y',                           # SQL_OUTER_JOINS
    115 => 127,                           # SQL_OUTER_JOIN_CAPABILITIES
     39 => 'Owner',                       # SQL_OWNER_TERM
     91 => 31,                            # SQL_OWNER_USAGE
    153 => 2,                             # SQL_PARAM_ARRAY_ROW_COUNTS
    154 => 3,                             # SQL_PARAM_ARRAY_SELECTS
     80 => 7,                             # SQL_POSITIONED_STATEMENTS
     79 => 1,                             # SQL_POS_OPERATIONS
     21 => 'Y',                           # SQL_PROCEDURES
     40 => 'Procedure',                   # SQL_PROCEDURE_TERM
    114 => 2,                             # SQL_QUALIFIER_LOCATION
     41 => '@',                           # SQL_QUALIFIER_NAME_SEPARATOR
     42 => 'Database Link',               # SQL_QUALIFIER_TERM
     92 => 3,                             # SQL_QUALIFIER_USAGE
     93 => 3,                             # SQL_QUOTED_IDENTIFIER_CASE
     11 => 'Y',                           # SQL_ROW_UPDATES
     39 => 'Owner',                       # SQL_SCHEMA_TERM
     91 => 31,                            # SQL_SCHEMA_USAGE
     43 => 7,                             # SQL_SCROLL_CONCURRENCY
     44 => 19,                            # SQL_SCROLL_OPTIONS
     14 => '\\',                          # SQL_SEARCH_PATTERN_ESCAPE
     13 => sub {"$_[0]->{Name}"},         # SQL_SERVER_NAME
     94 => '$#',                          # SQL_SPECIAL_CHARACTERS
    155 => 0,                             # SQL_SQL92_DATETIME_FUNCTIONS
    156 => 0,                             # SQL_SQL92_FOREIGN_KEY_DELETE_RULE
    157 => 0,                             # SQL_SQL92_FOREIGN_KEY_UPDATE_RULE
    158 => 16,                            # SQL_SQL92_GRANT
    159 => 0,                             # SQL_SQL92_NUMERIC_VALUE_FUNCTIONS
    160 => 7687,                          # SQL_SQL92_PREDICATES
    161 => 0,                             # SQL_SQL92_RELATIONAL_JOIN_OPERATORS
    162 => 0,                             # SQL_SQL92_REVOKE
    163 => 0,                             # SQL_SQL92_ROW_VALUE_CONSTRUCTOR
    164 => 0,                             # SQL_SQL92_STRING_FUNCTIONS
    165 => 1,                             # SQL_SQL92_VALUE_EXPRESSIONS
    118 => 1,                             # SQL_SQL_CONFORMANCE
    166 => 3,                             # SQL_STANDARD_CLI_CONFORMANCE
    167 => 57935,                         # SQL_STATIC_CURSOR_ATTRIBUTES1
    168 => 4231,                          # SQL_STATIC_CURSOR_ATTRIBUTES2
     83 => 0,                             # SQL_STATIC_SENSITIVITY
     50 => 8355839,                       # SQL_STRING_FUNCTIONS
     95 => 31,                            # SQL_SUBQUERIES
     51 => 7,                             # SQL_SYSTEM_FUNCTIONS
     45 => 'Table',                       # SQL_TABLE_TERM
    109 => 0,                             # SQL_TIMEDATE_ADD_INTERVALS
    110 => 0,                             # SQL_TIMEDATE_DIFF_INTERVALS
     52 => 1023999,                       # SQL_TIMEDATE_FUNCTIONS
     46 => 3,                             # SQL_TRANSACTION_CAPABLE
     72 => 10,                            # SQL_TRANSACTION_ISOLATION_OPTION
     46 => 3,                             # SQL_TXN_CAPABLE
     72 => 10,                            # SQL_TXN_ISOLATION_OPTION
     96 => 3,                             # SQL_UNION
     96 => 3,                             # SQL_UNION_STATEMENT
     47 => \&sql_user_name,               # SQL_USER_NAME
  10000 => 1995,                          # SQL_XOPEN_CLI_YEAR
);

1;

__END__
