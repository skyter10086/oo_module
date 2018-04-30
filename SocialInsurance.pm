package SocialInsurance;

use lib "./";
use Moose;
use Moose::Util::TypeConstraints;
use utf8::all;
use IOC;
use SocialSalary;
use Ratio;

enum 'SIType' => $IOC::SITYPE;

sub _table {
	my $self = shift;
	return  $self->si_type ;
}


sub set_ratio {
    my ($self, $issue, $ratio) = @_;
    local $IOC::table = $self->_table;
    Ratio->chk_table;
    my $rr = Ratio->new(issue=>$issue,person_rate=>$ratio->{person},org_rate=>$ratio->{org}) || die "Initialize a new object of Ratio failed! ";
    $rr->save;
    
}

sub get_ratio {
    my ($self, $issue_key) = @_;
    local $IOC::table = $self->_table;
    Ratio->GET($issue_key) || die "Have not found item.";
}



sub get_salary {
	my ($self,$term_key) = @_;
	#print "term_key : ",$term_key,"\n";
	local $IOC::table = $self->_table;
	#print "IOC::table => ",$IOC::table,"\n";
	#SocialSalary->chk_table;
	SocialSalary->GET($term_key) || die "Have not found item.";
}

sub set_salary {
	my ($self, $term, $salary) = @_;
	#利用local产生临时变量在作用域内替换全局变量，但作用域外又恢复全局变量，来实现一个实例一个变量值
	local $IOC::table = $self->_table; 
	
	SocialSalary->chk_table;
	my $ss = SocialSalary->new(term=>$term,avg_salary=>$salary) || die "Initialize a new object of SocialSalary failed! ";
	$ss->save;
}

has 'si_type' => (
	is => 'ro',
	isa => 'SIType',
);
=pod
# Native delegation 原生委托
has 'salary' => (
	is => 'rw',
	traits => ['Hash'],
	isa => 'HashRef[SocialSalary]',
	default => sub { {} },
	handles => {
        'set_salary' => 'set',
        'get_salary' => 'get',
        'get_all_href' => 'elements',
        'count' => 'count',
        'clear' => 'clear',
        'is_empty' => 'is_empty',
    },
);
=cut



no Moose::Util::TypeConstraints;
no Moose;
1;
