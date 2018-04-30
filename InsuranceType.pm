package InsuranceType;

use lib './';
use Moose;
use Moose::Util::TypeConstraints;
use utf8::all;

subtype 'InsurType',
    as enum([
    '职工基本养老保险',
    '灵活就业人员养老保险',
    '职工失业保险',
    '职工工伤保险',
    '职工工伤保险-B',
    '职工基本医疗保险',
    '城乡居民基本医疗保险',
    '职工补充医疗保险',
    '职工医疗大病救助',
    '城乡居民大病救助',
    '职工生育保险',    ]);

















no Moose;

1;
