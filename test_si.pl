use lib './';
use SocialInsurance;
#use SocialSalary;
use Data::Printer;
use utf8::all;

my $si_retire = SocialInsurance->new(si_type =>'职工基本养老保险');
=pod
$si_retire->set_salary('2012' => SocialSalary->new(
	term => Term->new({ 
		term => 2012, 
		begin => DateTime->new(
			year => 2012,
			month => 7,
			day => 1,
		),
		end => DateTime->new(
			year => 2013,
			month => 6,
			day => 1,
		),
	}),
	avg_salary => 3057.83,
));

#my %data = $si_retire->get_all_href;
#p %data;

#print "The term begin on ",$si_retire->salary->{'2012'}->term->begin->ymd;
=cut
$si_retire->set_salary(Term->new({ 
		term => 2012, 
		begin => DateTime->new(
			year => 2012,
			month => 7,
			day => 1,
		),
		end => DateTime->new(
			year => 2013,
			month => 6,
			day => 1,
		),
	}),3057.83);
$si_retire->set_ratio('2012-07-01', {person=>0.08,org=> 0.19});
$si_retire->get_ratio('2012-07-01');
	
	my $sa = $si_retire->get_salary('2012');
	print "avg_salary is ",$sa->avg_salary,"\n";
