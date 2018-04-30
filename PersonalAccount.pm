package PersonalAccount;

use lib './';
use utf8::all;
use Moose;


sub primary {
  ...
}

sub table {
  ...
}

sub map {
  ...
}

has 'sn' => (
  is => 'ro',
  isa => 'Str',
  required => 1,


);

#has ''
no Moose;
1;
