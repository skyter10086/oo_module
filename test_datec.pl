
use DateTime;
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
#conv_2_date('1982-10-01');

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
	{attribute =>'birth_date', field  =>  { name => 'birth' , type => 'Date', convert_to => sub { my $x = shift; my $res = $x->ymd;}, convert_from => \&str_2_date } },
	{attribute =>'phone', field  => {name => 'phone', type => 'VarChar', precision => '(25)'}},
	{attribute =>'orgnazition', field  => {name => 'org', type => 'VarChar', precision => '(60)', convert_to => sub {my $x = shift; return $x->code;} } },
	]
    	
	
}
