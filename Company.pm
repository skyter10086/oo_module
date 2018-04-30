package Company;

use lib "./";
#use Person;
use utf8::all;
use Moose;
use Data::Printer;

with 'DBish';

sub table {
    return 'Company';
}

sub primary {
    my $self = shift;
    return $self->code;
}

sub map {
	
        [
        {attribute => 'primary', field => {name => 'primary_key', type=>'VarChar',precision=>'(10)',primary => 'PRIMARY KEY'} },
        {attribute => 'code',field=>{name=>'code',type=>'VarChar',precision=>'(5)'} },
        {attribute => 'name',field=>{name=>'name',type=>'VarChar',precision=>'(60)'} }, 
        ]
    
}
=pod
sub BUILD {
    my $self = shift;
    $self->chk_table;
    my $pri = $self->primary;
    my $map = $self->map;
    my $fields_value = [] ;

    foreach my $item ( @{$self->map} ) {
        my $attr = $item->{attribute};
        if ($item->{field}->{convert_to}) {
            my $conv = $item->{field}->{convert_to};
            print $attr,"\n";
            my $attr_val = $self->$attr();
            print $attr_val,"\n";
            push @$fields_value, &$conv($attr_val);
        } else {
            push @$fields_value, $self->$attr()};
        }
        
    p $fields_value;

    $self->POST($pri, $fields_value);
    
    #$People->{$self->sn} = $self;
}
=cut

has 'code' => ( is => 'ro', isa => 'Str', required => 1); # 单位编码

has 'name' => ( is => 'rw', isa => 'Str', required => 1); # 单位名称

#has 'employees' => ( is => 'rw', lazy => 1, builder => sub { 1 }, init_arg => undef);
=pod
has 'employees' => (  # 员工 - hashref
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

# object-method 参数- 个人编号 把一个（对应个人编号的）人员对象加入当前单位
sub charge_person {
    my ($self, $person_sn) = @_;
    die "You do not provide the sn of hired person!!!\n" unless $person_sn;
    $self->employees->{$person_sn} = Person->get($person_sn) or die "You give a bad person sn!\n" ;
    Person->get($person_sn)->orgnazition($self) ;
}
=cut
no Moose;

1;
