package InsurantRecord;

use lib './';
use utf8::all;
use Moose;
use Moose::Util::TypeConstraints;
use Company;
use Term;
use SocialInsurance;

with 'DBish';

subtype 'CompanyType' => as 'Company';

coerce 'CompanyType' 
    => from 'Str',
        => via { Company::GET($_) };





sub table {
	...
}

sub primary {
	my $self = shift;
    my $pri = $self->sn.",".$self->issue->ymd.",".$self->sitype;
    return $pri;
}

sub map {
	...
}


sub _base_salary {
	my $self = shift;
	#use bignum;
	my $si_salary = SocialInsurance::new($self->sitype)->get_salary($self->issue->ymd);
	return $si_salary->top_salary if $self->salary > $si_salary->top_salary;
	return $si_salary->bottom_salary if $self->salary < $si_salary->bottom_salary;
	return $self->salary;
}


sub _person_rate {
	my $self = shift;
	my $si_ratio = SocialInsurance::new($self->sitype)->get_ratio($self->issue->ymd);
	return $si_ratio->person_rate;
}

sub _person_pay {
    my $self = shift;
    use bignum;
    my $pay = $self->base_salary * $self->person_rate;
    no bignum;
    $pay = sprintf "%.2f", $pay;
	$pay = $pay + 0;
	return $pay;
}

has 'sn' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has 'issue' => (
	is => 'ro',
	isa => 'Issue',
	required => 1,
	coerce => 1,
);

has 'sitype' => (
	is => 'ro',
	isa => 'SIType',
	required => 1,

);

has 'salary' => (
    is => 'rw',
    isa => 'Num',
    required => 1,

);

has 'base_salary' => (
	is => 'rw',
	builder => '_base_salary',
	lazy => 1,
	init_arg => undef,

);

has 'person_rate' => (
	is => 'rw',
	builder => '_person_rate',
	lazy => 1,
	init_arg => undef,

);

has 'person_pay' => (
	is => 'rw',
	builder => '_person_pay',
	lazy => 1,
	init_arg => undef,


);

has 'org' => (
	is => 'rw',
	isa => 'CompanyType',
	required => 1,
	coerce => 1,
);













no Moose;
1;