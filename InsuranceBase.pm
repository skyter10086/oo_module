package InsuranceBase; # {缴费基数}

use lib './';
use utf8::all;

use YearObject;

use Moose;
use Moose::Util::TypeConstraints;


subtype 'PositiveNumber_Zero' ,
    as 'Num',
    where { $_ >= 0.0 };

# 年 - 类型是年对象
has 'year' => (
    is => 'ro',
    isa => 'YearObject',
    
    

);

# 缴费基数 - 大于或等于0的浮点数
has 'base' => (
    is => 'rw',
    isa => 'PositiveNumber_Zero',
    default => 0.00,
    
);


no Moose::Util::TypeConstraints;
no Moose;

1;
