use Modern::Perl;
use utf8::all;
use DateTime;
use lib "./";
use Person;
use Company;
use Data::Printer;
use SocialInsurance;


my $company_a = Company->new(
    'code' => 'A_08',
    'name' => '采油二厂',
);
$company_a->save;
my $person_a = Person->new(
    'sn' => '08103747567',
    'name' => 'DaiWang',
    'sex' => 'M',
    'id' => '411302198210103345',
    'folk' => '汉族',
    'birth_date' => DateTime->new(
                             year => 1982,
                             month => 10,
                             day => 1,),
    'phone' => '13583993102',
    'photo' => '/img/08103747567.jpg',
    'idcard_upside' => '/pic/411302198210103345_正.jpg',
    'idcard_downside' => '/pic/411302198210103345_背.jpg',
    'orgnization' => $company_a,
);
#$person_a->name('张耀扬');
$person_a->save;
my $person_b = Person->GET('08103747567');
print $person_b->orgnization->code,"\n";
$person_a->update({name=>'liu8xing'});
#$person_a->orgnazition($company_a);

=pod
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
=cut
#$person_a->prn_attr_types;

#$person_a->schema;

#ref \$person_a->_attr_names;

#$person_a->initial_table;
my $zg_tire = SocialInsurance->new('si_type'=>'sitype');
say $zg_tire->si_type;