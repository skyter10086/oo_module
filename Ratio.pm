package Ratio;

use lib './';
use Moose;
use Moose::Util::TypeConstraints;
use utf8::all;
use DateTime;
use IOC;
use Term;

with 'DBish';


sub str_2_date {
	
	my $p =shift;
	my @array = split(/-/,$p);
	my @a = map {$_+0} @array;
	#print @a;

	my $hr = {
		year => $a[0],
		month => $a[1],
		day => $a[2],
	};
	#print ref $a[1],"\n";
	return DateTime->new($hr) || die "DateTime create failed!";

}

sub primary {
    my $self = shift;
    $self->issue->ymd;
}

sub table {
    $IOC::table."_ratio";
}

sub map {
	[
		{attribute=>'primary',field=>{name=>'primary_key',type=>'VarChar',precision=>'(60)',primary=>'PRIMARY KEY',}},
		{attribute => 'issue', field => {name=>'issue',type=>'VarChar',precision=>'(20)',convert_to=>sub {my $p = shift;$p->ymd;},convert_from=>sub {my $p = shift;str_2_date($p);} }},
		{attribute=>'person_rate',field=>{name=>'person_rate',type=>'Decimal',precision=>'(5,4)',}},
		{attribute=>'org_rate',field=>{name=>'org_rate',type=>'Decimal',precision=>'(5,4)',}},
	
	
	];
    
}



has 'issue' => (
    is => 'ro',
    isa => 'Issue',
    required => 1,
    coerce => 1,
);

has 'person_rate' => (
    is => 'rw',
    isa => 'Num',
    required => 1,
);

has 'org_rate' => (
	is => 'rw',
	isa => 'Num',
	required => 1,
);


no Moose::Util::TypeConstraints;
no Moose;

1;



