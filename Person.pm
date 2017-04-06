package Person;

use 5.24.1;
use Moose;
use Moose::Util::typeConstraints;
use DateTime;

has 'name' => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has 'sex' => (
  is => 'rw',
  isa => enum('SEX' ,[qw(male female)]),
  required => 1,
);

has 'id' => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has 'scbh' => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has 'aac001' => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has 'aab001' => (
  is => 'rw',
  isa => 'Str',
  required => 1,
);

has 'birth_date' => (
  is => 'rw',
  isa => 'DateTime',
  required => 1,
);

has 'work_date' => (
  is => 'rw',
  isa => 'Str',
);

has 'retire_date' => (
  is => 'rw',
  isa => 'Str',
);

has 'has_employed' => (
  is => 'rw',
  isa => 'Bool',
  required => 1,
);

has 'has_insured' => (
  is => 'rw',
  isa => 'Bool',
  required => 1,
);

has 'has_retired' => (
  is => 'rw',
  isa => 'Bool',
  required => 1,
);

has 'has_existed' => (
  is => 'rw',
  isa => 'Bool',
  required => 1,
);

has 'photo_file' => (
  is => 'rw',
  isa => 'Str',
);

has 'DoD' => (
  is => 'rw',
  isa => 'DateTime',
  );

has 'folk' => (
  is => 'rw',
  isa => 'FOLKS',
  required => 1,
  );

has 'region' => (
  is => 'rw',
  isa => 'REGIONS',
  );

has 'has_married' => (
  is => 'rw',
  isa => 'Bool',
  );

has 'phone' => (
  is => 'rw',
  isa => 'PHONE',
  );

has 'address' => (
 is => 'rw',
 isa => 'ADR',
 );

has 'zipcode' => (
  is => 'rw',
  isa => 'ZIP',
  );

has 'si_card' => (
  is => 'rw',
  is =>'Str',
  );

has 'dwbm' => (
  is => 'rw',
  isa => 'DWBM',
  );

no Moose;

__PACKAGE__->meta->make_immutable;

1;



