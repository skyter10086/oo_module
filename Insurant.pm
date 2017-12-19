package Insurant;

use lib "./";
use Company;

use utf8::all;
use Moose;
use Moose::Util::TypeConstraints;

extends 'Person';

subtype 'InsuranceBase',
    as 'HashRef',
    where { $_->{'year'} && $_->{'base'} };

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


has 'orgnazition' => ( is => 'rw', isa => 'Company', required => 1, weak_ref => 1);

has 'insurance_bases' => ( is => 'rw', isa => 'ArrayRef[InsuranceBase]', default => sub{ [] } );

has 'insurance_types' => ( is => 'rw', isa => 'ArrayRef[InsuranceType]', defualt => sub{ {} } );

has 'figure' => (
    is => 'rw',
    isa => enum ( ['fulltime', 'non_fulltime' ] ),
);

no Moose::Util::TypeConstraints;

no Moose;

1;
