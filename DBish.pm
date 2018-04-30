package DBish;

use Template;
use Moose::Role;
use Modern::Perl;
use Data::Printer;
use IOC;
#use utf8::all;

requires 'primary', 'map','table';

=pod
has 'schema' => (
	is => 'ro',
	#isa => 'Str',
	lazy => 1,
	builder => '_schema',
	init_arg => undef,
);

sub _attr_names {
	my $self = shift;
	my $meta = $self->meta;
	my $attr_names = [];
	for my $attr ( $meta->get_all_attributes) {
	    push @$attr_names, $attr->name;
	}
	return sort @$attr_names;
}

sub prn_attr_types {
	my $self = shift;
	my $meta = $self->meta;
	for my $attr ( $meta->get_all_attributes ) {
	    my $attr_name = $attr->name;
		my $attr_type = $attr->type_constraint->name;
	    say "$attr_name  =>  $attr_type ";	
	
	}
}
=cut
# 有了reset这个方法，在update之前就会更新$self,就不会出现sn改变
# 但primary_key不变的错误，因为sn是primarykey 并且只读，所以一旦要update(sn=>?)
# 首先就会被Moose的constraint拦截报错，后面的代码不会运行。
sub reset {
	my ($self,$hr) = @_;
	while (my ($attr_key, $attr_val) = each %$hr) {
		$self->$attr_key($attr_val);
	}
	return $self; 
}

# 对象方法--update，给一个hashref，来更新当前对象的一系列属性，并更新到数据库中
sub update {
	my ($self,$hashref) = @_;
	$self = $self->reset($hashref);
	my $pri = $self->primary;
	$self->chk_table;
	if ($self->GET($pri)) {
		
		$self->PUT($pri,$hashref);
	} else {
		$self->save;
		$self->PUT($pri,$hashref);
	}
	print "now you have update a object to DB.\n";
	return 1;
}
sub save {
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

    $self->POST($pri, $fields_value) ;
        

}

sub _schema {
	my $self = shift;
	my $tab =  $self->table;
	my $tt_text = 'schema.tt2';
	# my $field = { name => 'name', type => 'VarChar', precision => '20'};
	my $fields = [];
	foreach my $item ( @{$self->map} ) {
		#while ( my ($attr_name, $field_hash) = each %{$item} ){
			push @$fields , $item->{field};	
		#}
		#say "now putting a field to fields array.";  
	}
	my $vars = {
		table => $tab,
		fields => $fields,
		primary => { constraint => 'PRIMARY KEY', param => '(primary_key)'},
	};
	#say $vars->{fields}->[0]->{name};
	#p $vars->{fields};
	my $tt = Template->new;
	my $out = '';
	
	#$tt->process($tt_text, $vars, 'schema.sql') || die $tt->error(), "\n";
	$tt->process($tt_text, $vars, \$out) || die $tt->error(), "\n";
	#print "$out \n";
	#return $out if $out;
	return $out;
}

sub initial_table {
	my $class = shift;
	say $class;
	my $schema = $class->_schema ;
	#say $Schema;
	my $dbh = $IOC::DBH || die "Your db connection is wrong!";
	
	#if ($SCHEMA && $dbh) {
		my $sth = $dbh->do($schema) ;
		say "The table has been initialed! ";
		#return 1;
	
	#} else {
	#	say "The schema or DBH has some problem, check it out! ";
	#	return ;
	#}
}

sub Table_existed {
	my $class = shift;
	my $dbh = $IOC::DBH;
	my $table = $class->table;
    #say $table;
	my @table_names = $dbh->tables('','main',$table,"TABLE") || return undef;
	#say $table_names[0];
	if ( grep { qr/."$table"/  } @table_names) {
		return 1;
	} else {
		return undef;
	}
}

sub chk_table {
	my $self = shift;
	if ($self->Table_existed) {
    say "Table no need to initial." ;
} else {
    say "You need to  call 'initial_table' method!";
    
    $self->initial_table;
}
}

sub GET {
	# $primary
	my $class = shift;
	my $primary = shift or die "You should input a primary ! ";
	#my $filter = shift or die "You should input a text of filter ! ";
	my $dbh = $IOC::DBH;
	my $table = $class->table;
	my $sql_get = "SELECT * FROM [% table %] WHERE primary_key = ?";
	# my $attrs = [];
	# my $fields = [];
	
	my $vars = {table => $table };
	my $tt = Template->new;
	my $sql_statement = '';
	$tt->process(\$sql_get,$vars,\$sql_statement);
	my $hash_ref = $dbh->selectrow_hashref($sql_statement,undef,$primary) || return;#die $DBI::errstr;
	# delete $hash_ref->{'primary_key'}
	my $args_hashref = {};
	foreach my $item ( @{$class->map} ) {
		next if ($item->{attribute} eq 'primary');
		#push @$attrs, $item->{attribute};
		#push @$fields, $item->{name};
		if ($item->{field}->{convert_from}){
			my $conv_from = $item->{field}->{convert_from};
			my $res = &$conv_from($hash_ref->{$item->{field}->{name}});
			$args_hashref->{$item->{attribute}} = $res;
		} else {
		$args_hashref->{$item->{attribute}} = $hash_ref->{$item->{field}->{name}};
	}
	}
	return $class->new($args_hashref);

}


sub array_to_string {
	my $array = shift;
	my $str = join(',', @$array);
	
}


sub POST {
	# $primary, all_attributes_values
	
	my ($class, $pri, $fields_vals) = @_; # []
	if ($class->GET($pri)){
        print "Object is existed!\n";
        return;
   }
	print "class: $class\n";
	print "pri: $pri\n";
	p $fields_vals;
	my $count = @$fields_vals;
	print "$count\n";
	my @vals = ();
	for ($a=0;$a<$count;$a = $a + 1){
		push @vals, "?";
	}
	my $vals_str = join ",",@vals;
	print "vals_str: $vals_str\n";
	my $sql_post = "INSERT INTO [% table %] VALUES ([% values %])";
	my $vars = {table => $class->table, values => $vals_str};
	p $vars;
	my $tt = Template->new;
	my $sql = '';
	$tt->process(\$sql_post,$vars,\$sql);
	print "sql: $sql\n";
	my $dbh = $IOC::DBH;
	my $sth = $dbh->prepare($sql);
	my $rv = $sth->execute(@$fields_vals);
	print "you have $rv records affected.\n";
	return 1;
}

sub PUT {
	# $primary, \%fields_values
	my ($class, $pri, $fields_href) = @_;
	unless ($class->GET($pri)) {
		# body...
		print "No record could be updated!\n";
        return;
	}
	my @pairs = ();
	my @vals = ();
	while (my ($k, $v) = each %$fields_href) {
		push @pairs, "$k=?";
		push @vals, $v;
	}
	my $pair = join(',', @pairs);
	my $vars = {table => $class->table, pair => $pair};
	my $sql_put = "UPDATE [% table %] SET [% pair %] WHERE primary_key = ?";
	my $tt = Template->new;
	my $sql = '';
	$tt->process(\$sql_put,$vars,\$sql);
	my $dbh = $IOC::DBH;
	my $sth = $dbh->prepare($sql);
	my $rv = $sth->execute(@vals,$pri);
	print "You have $rv record(s) updated.\n";
	return 1;
}

sub DEL {
	# $primary
	my ($class,$pri) =  @_;
		unless ($class->GET($pri)) {
		# body...
		print "No record could be deleted!\n";
        return;
	}
	my $vars = {table=>$class->table,primary=>$pri};
	my $sql_del = "DELETE FROM [% table %] WHERE primary_key=?";
	my $tt = Template->new;
	my $sql = '';
	$tt->process(\$sql_del,$vars,\$sql);
	my $dbh = $IOC::DBH;
	my $sth = $dbh->prepare($sql);
	my $rv = $sth->execute($pri);
	print "You have $rv record(s) deleted.\n";
	return 1;
}



no Moose::Role;
1;
