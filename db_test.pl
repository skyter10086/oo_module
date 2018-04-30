use strict;
use utf8::all;
use DateTime;
use DBI;

my $data_source = "dbi:SQLite:dbname=test.db";
my $username = '';
my $pwd = '';
my $options_hashref = {sqlite_unicode =>1, AutoCommit => 1, RaiseError => 1};

my $DBH = DBI->connect($data_source, $username, $pwd, $options_hashref) or die $DBI::errstr;


my filename = 'schema.sql';

