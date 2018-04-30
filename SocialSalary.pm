package SocialSalary;

use lib './';
use Moose;
use Term;
use utf8::all;
use  IOC;

with 'DBish';

sub table {
	$IOC::table."_salary";
}

sub primary {
    my $self = shift;
    $self->term->term;
}

sub map {
	[
		{attribute => 'primary', field => {name => 'primary_key',type=>'VarChar',precision=>'(25)',primary=>'PRIMARY KEY'}},
		{attribute => 'term', field => {name => 'term',type => 'VarChar',precision => '(60)',convert_to => sub {my $p = shift;$p->to_str},convert_from => sub {my $p = shift; Term::to_obj($p);} }},
		{attribute => 'avg_salary', field => {name => 'avg_salary', type => 'Decimal',precision =>'(10,2)'}},
		{attribute => 'bottom_salary', field => {name => 'bottom_salary', type => 'Decimal',precision =>'(10,2)'}},
		{attribute => 'top_salary', field => {name => 'top_salary', type => 'Decimal',precision =>'(10,2)'}},

	];
}

sub _bottom {
	use bignum;
	my $self = shift;
	my $bottom = $self->avg_salary * 0.6;
	no bignum;
	$bottom = sprintf "%.2f", $bottom;
	$bottom = $bottom + 0;
	return $bottom;
}

sub _top {
	use bignum;
	my $self = shift;
	my $top = $self->avg_salary * 3.0;
	no bignum;
	$top = sprintf "%.2f", $top;
	$top = $top + 0;
	return $top;
}

has 'term' => (
	is => 'ro',
	isa => 'Term',
	required => 1,
);

has 'avg_salary' => (
	is => 'rw',
	isa => 'Num',
	required => 1,

);

has 'bottom_salary' => (
	is => 'rw',
	builder => '_bottom',
	init_arg => undef,
	lazy => 1,

);

has 'top_salary' => (
	is => 'rw',
	builder => '_top',
	init_arg => undef,
	lazy => 1,

);


no Moose;

1;
