package IOC;

use strict;
use utf8::all;
use DateTime;
use DBI;

my $data_source = "dbi:SQLite:dbname=test.db";
my $username = '';
my $pwd = '';
my $options_hashref = {sqlite_unicode =>1, AutoCommit => 1, RaiseError => 1};

our $DBH = DBI->connect($data_source, $username, $pwd, $options_hashref) or die $DBI::errstr;
our $SITYPE = [
	'sitype',
	'职工基本养老保险',
	'灵活就业人员养老保险',
	'职工失业保险',
	'职工工伤保险',
	'职工工伤保险-B',
	'职工企业年金',
	'职工医疗大病救助',
	'职工基本医疗保险',
	'职工补充医疗保险',
	'职工生育保险',
	'城乡居民基本医疗保险',
	'城乡居民大病救助',
];

our $table = 'tab';

1;