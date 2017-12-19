use Modern::Perl;
use utf8::all;
use DateTime;
use lib "./";
use Person;
use Company;
use Data::Printer;

my $person_a = Person->new(
    'sn' => '08103747567',
    'name' => 'DaiWang',
    'sex' => 'M',
    'id' => '411302198210103345',
    'folk' => '汉族',
    'birth_date' => DateTime->new(
                             year => 1982,
                             month => 10,
                             day => 10,),
    'phone' => '13583993102',
);
$person_a->name('张耀扬');
my $company_a = Company->new(
    'code' => 'A_23',
    'name' => '局机关',
);

$company_a->charge_person('08103747567');


say $company_a->name;
say $company_a->code;
p $company_a->employees;
say $company_a->employees->{'08103747567'}->orgnazition->{name};

my $person_b = Person->new(
    'sn' => '08103747567',
    'name' => 'DaiWang',
    'sex' => 'M',
    'id' => '411302198210103342',
    'folk' => '汉族',
    'birth_date' => DateTime->new(
                             year => 1983,
                             month => 10,
                             day => 10,),
    'phone' => '13583993101',
);

my $ps = Person::Get_all();
p $ps;
