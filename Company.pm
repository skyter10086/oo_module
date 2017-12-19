package Company;

use lib "./";
use Person;
use utf8::all;
use Moose;


has 'code' => ( is => 'ro', isa => 'Str', required => 1);

has 'name' => ( is => 'rw', isa => 'Str', required => 1);

has 'employees' => ( 
    is => 'rw', 
    isa => 'HashRef[Person]', 
    default => sub { {} }, 
    handles => { 
        'get_employees' => 'get',
        'set_employees' => 'set',
        'del_employees' => 'delete',
        'has_no_employee' => 'is_empty',
    },

);

sub charge_person {
    my ($self, $person_sn) = @_;
    die "You do not provide the sn of hired person!!!\n" unless $person_sn;
    $self->employees->{$person_sn} = Person->get($person_sn) or die "You give a bad person sn!\n" ;
    Person->get($person_sn)->orgnazition($self) ;
}

no Moose;

1;
