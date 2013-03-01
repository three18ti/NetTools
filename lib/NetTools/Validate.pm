package NetTools::Validate;
use Moose::Role;
use List::MoreUtils qw(all);

# Accept only ASCII inputs for regexes.  Use /u to override.
use re '/aa';

has regexes => (
    is      => 'ro',
    isa     => 'HashRef[ArrayRef]',
    lazy    => 1,
    builder => '_build_regexes',
);

sub _build_regexes {
    my ($self) = @_;
    return {
        domain => [
            qr{
                \A
                [a-z0-9-]+(\.[a-z0-9-]+)+
                \Z
            },
        ],
    }
}



sub is_valid {
    my ($self, $field, $value) = @_;

    die 'Invalid field ' . $field
        if !exists $self->regexes->{$field};

    # Get the regexes for the field.
    my @regexes = @{ $self->regexes->{$field} };

    # The value matches all the regexes
    my $is_valid = all { $value =~ m{$_}xms } @regexes;

    return $is_valid;
}
1;

