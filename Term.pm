package Term;

use Moose;
use Moose::Util::TypeConstraints;
use utf8::all;
use DateTime;

subtype 'Issue'
	=> as 'DateTime'
	=> where { $_->day == 1 }
	=> message { "This date $_->ymd must be the first day of the month!"};


coerce 'Issue'
    => from 'Str'
    	=>via { 
    		my $p = shift;
    		#print "$p\n";
    		my @array = split(/-/,$p);
    		my @a = map {$_+0} @array;
    		my $hr = {
				year => $a[0],
				month => $a[1],
				day => $a[2],
			};
			return DateTime->new($hr);
    	};

subtype 'Year' 
	=> as 'Int'
	=> where {$_ > 1900 && $_ <= DateTime->now->year();}
	=> message { "This number ($_) is not vlaidated!" };

coerce 'Year'
    => from 'Str'
    	=> via {$_+0};


has 'term' => (
	is => 'ro',
	isa => 'Year',
	required => 1,
	coerce => 1,
);

has 'begin' => (
	is => 'rw',
	isa => 'Issue',
	required => 1,
	coerce => 1,
);

has 'end' => (
	is => 'rw',
	isa => 'Issue',
	required => 1,
	coerce => 1,
	);

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
	return DateTime->new($hr) || die "DateTime create failed!";

}

sub is_valid {
	my $self = shift;
	if (DateTime->compare_ignore_floating($self->begin,$self->end) == -1) {
		return 1;
	} else {
		return undef;
	}
}

sub to_str {
	my $self = shift;
	my $term = $self->term."";
	my $begin = $self->begin->ymd;
	my $end = $self->end->ymd;
	return "$term,$begin,$end" if $self->is_valid;
	return "Term is not validated";
}

sub to_obj {
	my $str = shift;
	my @arr = split(',',$str);

	my $term = $arr[0]+0;
	my $begin = str_2_date($arr[1]);
	my $end = str_2_date($arr[2]);
	my $term_obj = Term->new(term=>$term,begin=>$begin,end=>$end);

	return $term_obj if $term_obj->is_valid;
	return "Term is not validated";
}

no Moose::Util::TypeConstraints;
no Moose;
1;