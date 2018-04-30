package Person;

use lib './';
use utf8::all; 
use DateTime;
use Moose;
use Company;
use Data::Printer;

with 'DBish';

#my $People = {};

sub table {
    'Person';
}

sub primary {
    my $self = shift;
    return $self->sn ; # 返回值需要自己转换为字符串
}

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
	return DateTime->new($hr);

}

sub code2company {
	my $p =shift;
	return Company->GET($p);
}

sub map {
    # dropped：返回值是一个hash引用,格式为：属性名 => 选项哈希 
    # fix_0: 返回值改为一个Array引用,目的是为了按照指定顺序生成DB的schema
	# fix_1: 优化返回值结构，Array的每一个元素改为{attribute=>'',field=>''}格式，方便取值
    [
    {attribute => 'primary', field => { name => 'primary_key', type => 'VarChar', precision => '(25)' ,primary => 'PRIMARY KEY'} },
    {attribute =>'sn' , field => {name => 'sn', type => 'VarChar', precision => '(11)'} },
    {attribute =>'name', field  => {name => 'name', type => 'VarChar', precision => '(20)'} },
    {attribute =>'sex', field  => { name => 'sex', type => 'VarChar', precision => '(2)'} },
    {attribute =>'id', field  => { name => 'id', type => 'VarChar', precision => '(18)', convert_to => sub { my $a =shift;my $b=uc $a; } }},# convert 是一个把类的属性值转换为数据库字段可用的值的一个coderef
	{attribute =>'folk', field  => { name => 'folk', type => 'VarChar', precision => '(20)'} },
	{attribute =>'birth_date', field  =>  { name => 'birth' , type => 'Date', convert_to => sub { my $_ = shift; my $res = $_->ymd;}, convert_from => \&str_2_date } },
	{attribute =>'phone', field  => {name => 'phone', type => 'VarChar', precision => '(25)'}},
    {attribute =>'photo', field  => {name => 'photo', type => 'VarChar', precision => '(25)'}},
    {attribute =>'idcard_upside', field  => {name => 'upside', type => 'VarChar', precision => '(60)'}},
    {attribute =>'idcard_downside', field  => {name => 'downside', type => 'VarChar', precision => '(60)'}},
	{attribute =>'orgnization', field  => {name => 'org', type => 'VarChar', precision => '(20)', convert_to => sub {my $_ = shift; return $_->code;}, convert_from => \&code2company } },
	];
    	
	
}

has 'sn' => ( is => 'ro', isa => 'Str', required => 1); # primary-key 个人编号

has 'name' => ( is => 'rw', isa => 'Str', required => 1); # 姓名

has 'sex' => ( is => 'rw', isa => 'Str', required => 1); # 性别

has 'id' => ( is => 'rw', isa => 'Str', required => 1); # 身份证号码

has 'folk' => ( is => 'rw', isa => 'Str', required => 1); # 民族

has 'birth_date' => ( is => 'rw', isa => 'DateTime'); # 生日

has 'phone' => (is => 'rw', isa => 'Str'); # 联系电话

has 'photo' => (is=> 'rw', isa => 'Str'); # 个人照片

has 'idcard_upside' => (is=>'rw', isa=>'Str'); # 证件图片正面

has 'idcard_downside' => (is=>'rw', isa=>'Str'); # 证件图片背面

has 'orgnization' => ( is => 'rw', isa => 'Company'); # 单位

# 人员参保
sub insured {
  my ($self, $sitype, $p_salary) = @_; # 参保类型 个人基数

  ...

}

# 人员停保
sub uninsured {
  my ($self, $sitype ) = @_;
  ...
}


# 人员退休
sub retired {
  my ($self, $sitype) = @_;
  ...
}

# 人员解除合同
sub terminated {
  my ($self, $sitype) = @_;
  ...
}

# 人员死亡
sub died {
  my ($self, $sitype) = @_;
  ...
}

# 人员恢复参保
sub reinsured {
  my ($self, $sitype, $p_salary) = @_;
  ...
}

# 人员补征
sub pay_another {
  my ($self, $sitype, $p_salary, $duration) = @_;
  ...
}

# 人员保费调整
sub fix_pay {
 my ($self, $sitype, $p_money,$o_money,$remark) = @_;
 ...
}





=pod
before 'sn' => sub {
    my ($self, $param) = @_;
    say $param;
    #die " You have tried to break the unique rule!\n" if $People->{$param};
}
=cut

=pod
# class-method 获取所有人员 
sub Get_all {
    shift;
    return $People;
}
=cut
=pod
# meta-method 实例化后把当前实例加入类变量数组：$People中
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
=pod
# object-method 参数-人员编号 返回此编号对应的人员对象
sub get {
    my ($self, $person_sn) = @_;
    die "You should input the sn of person!\n" unless $person_sn;
    return $People->{$person_sn};
}
=cut
no Moose;

1;
