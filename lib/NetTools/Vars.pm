package NetTools::Vars;
use Moose::Role;
use namespace::autoclean;


has 'dns_types' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [qw( A AAAA ANY CNAME MX NS PTR SOA SPF SRV TXT )] },
#    default => sub { [qw( A )] },
);


#no Moose;
#__PACKAGE__->meta->make_immutable;
1;

