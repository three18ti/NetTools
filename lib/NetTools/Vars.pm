package NetTools::Vars;
use Moose::Role;
use namespace::autoclean;


has 'dns_types' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [qw( A MX NS SPF SRV TXT)] },
);

#no Moose;
#__PACKAGE__->meta->make_immutable;
1;

