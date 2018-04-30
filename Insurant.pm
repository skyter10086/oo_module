package Insurant; # class 参保人 

use lib "./";
use Company;
use Person;
use utf8::all;
use Moose;
#use Moose::Util::TypeConstraints;
#use InsuranceBase;

#extends 'Person';

=pod
subtype 'InsuranceBase',
    as 'HashRef',
    where { $_->{'year'} && $_->{'base'} };
=cut

# 险种类型
subtype 'InsuranceType',
    as enum([
    '养老保险-职工',
    '养老保险-协解',
    '失业保险',
    '工伤保险',
    '工伤保险-B',
    '职工基本医疗保险',
    '城乡居民基本医疗保险',
    '职工补充医疗保险',
    '职工大病救助',
    '城乡居民大病救助',
    '职工生育保险',    ]);
    
# 参数是$person_sn , 返回此sn对应的Person对象
sub is_person {
    my $person_sn = shift;
    Person->GET($person_sn) or die "You give a bad person num!\n";
}

# 同上 
has 'perosn' => (
    is => 'rw',
    builder => 'is_person',
);
# 缴费基数
has 'insurance_bases' => ( is => 'rw', isa => 'HashRef[InsuranceBase]', default => sub{ {} });
# 参保险种
has 'insurance_types' => ( is => 'rw', isa => 'ArrayRef[InsuranceType]', default => sub{ [] } );

# 身份
has 'figure' => ( 
    is => 'rw',
    isa => enum ( ['fulltime', 'non_fulltime','non_worker' ] ), # 全民职工，非全民职工，非职工
);

no Moose::Util::TypeConstraints;

no Moose;

1;