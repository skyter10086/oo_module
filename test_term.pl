use lib './';
use Term;

my $begin_date = {
	year => 2012,
	month => 2,
	day=> 1,
};
my $end_date = {
	year => 2013,
	month => 1,
	day => 1,
};
my $term = Term->new(
	term => '2012',
	begin => '2012-01-01',
	#end => '2012-05-01'
	#begin => DateTime->new($begin_date),
	end => DateTime->new($end_date),

);

print $term->term,"\n";

print "Not validated!\n" unless $term->is_valid;