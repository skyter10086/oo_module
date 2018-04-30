use lib './';
use SocialSalary;



my $term = Term->new(
	term => 2015,
	begin => '2015-07-01',
	end => '2016-06-01' 
);

my $social_salary = SocialSalary->new(
	term => $term,
	avg_salary => 3507.23,
);

print "The bottom_salary is : ",$social_salary->bottom_salary() ,"\n";
print "The top_salary is : ",$social_salary->top_salary ," \n"; 