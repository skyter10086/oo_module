package YearObject;
use DateTime;
use Moose ;
use Moose::Util::TypeConstraints;
# 年份 - 是一个大于1990的正整数
subtype 'YearInt',
    as 'Int',
    where  {$_ >= 1990 };

# 比较两个DateTime大小，A在B之后就返回1,相等返回0，否则就是-1    
sub cmp_dt {
    my ($dt_1, $dt_2) = @_;
    if ($dt_1->year == $dt_2->year) {
        if ($dt_1->month == $dt_2->month) {
            if ($dt_1->day == $dt_2->day) {
                return 0;
            } elsif ($dt_1->day > $dt_2->day) {
                return 1;
            } else {
                return -1;
            }
        } elsif ($dt_1->month > $dt_2->month) {
            return 1;
        } else {
            return -1;
        }
    } elsif ($dt_1->year > $dt_2->year) {
        return 1;
    } else {
        return -1;
    }
}

# 年度 - 主键
has 'year_id' => (
    is => 'ro',
    isa => 'YearInt',
    default => sub {DateTime->now->year();},
    
);

# 起始日期
has 'start_date' => (
    is => 'rw',
    isa => 'DateTime',
    trigger => sub {
        my ($self, $start, $old_start) = @_;
        die "end_date should after start_date!" if (cmp_dt($self->end_date,$start)==0 || cmp_dt($self->end_date,$start)<0); 
    },
);

# 截止日期
has 'end_date' => (
    is => 'rw',
    isa => 'DateTime',
    trigger => sub {
        my ($self, $end, $old_end) = @_;
        die "end_date should after start_date!" if (cmp_dt($self->start_date,$end)==0 || cmp_dt($self->start_date,$end)>0); 
        },
);
no Moose::Util::TypeConstraints;
no Moose;
1;