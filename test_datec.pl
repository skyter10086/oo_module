
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
    # dropped������ֵ��һ��hash����,��ʽΪ�������� => ѡ���ϣ 
    # fix_0: ����ֵ��Ϊһ��Array����,Ŀ����Ϊ�˰���ָ��˳������DB��schema
	# fix_1: �Ż�����ֵ�ṹ��Array��ÿһ��Ԫ�ظ�Ϊ{attribute=>'',field=>''}��ʽ������ȡֵ
    [
    {attribute => 'primary', field => { name => 'primary_key', type => 'VarChar', precision => '(25)' ,primary => 'PRIMARY KEY'} },
    {attribute =>'sn' , field => {name => 'sn', type => 'VarChar', precision => '(11)'} },
    {attribute =>'name', field  => {name => 'name', type => 'VarChar', precision => '(20)'} },
    {attribute =>'sex', field  => { name => 'sex', type => 'VarChar', precision => '(2)'} },
    {attribute =>'id', field  => { name => 'id', type => 'VarChar', precision => '(18)', convert_to => sub { my $a =shift;my $b=uc $a; } }},# convert ��һ�����������ֵת��Ϊ���ݿ��ֶο��õ�ֵ��һ��coderef
	{attribute =>'folk', field  => { name => 'folk', type => 'VarChar', precision => '(20)'} },
	{attribute =>'birth_date', field  =>  { name => 'birth' , type => 'Date', convert_to => sub { my $x = shift; my $res = $x->ymd;}, convert_from => \&str_2_date } },
	{attribute =>'phone', field  => {name => 'phone', type => 'VarChar', precision => '(25)'}},
	{attribute =>'orgnazition', field  => {name => 'org', type => 'VarChar', precision => '(60)', convert_to => sub {my $x = shift; return $x->code;} } },
	]
    	
	
}
