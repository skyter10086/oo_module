use lib './';
use YearObject;

use Data::Printer;

my $year = YearObject->new(
    year_id => 2016,
    start_date => DateTime->new(year => 2016, month => 1, day => 1, time_zone => 'UTC'),
    end_date => DateTime->new(year => 2016, month => 7 ,day => 1, time_zone => 'UTC'),
);
p $year;

$year->start_date(DateTime->new(year => 2017, month => 1, day => 1, time_zone => 'UTC'));