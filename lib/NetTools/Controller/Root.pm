package NetTools::Controller::Root;
use Moose;
use namespace::autoclean;

use Net::DNS;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

NetTools::Controller::Root - Root Controller for NetTools

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my %params;

    $c->stash (template => 'index.tt', );
}

sub dns_lookup : Chained PathPart('dns_lookup') {
    my ($self, $c) = @_;
    my $domain = $c->request->param( 'domain' );

    unless ($domain) {
        return $c->stash( 
            template => 'index.tt', 
            error_msg => 'Please enter a valid domain'
        );
    }

    my $res = Net::DNS::Resolver->new;
    my $answer = $res->search($domain);
    my $rr = $answer->pop('answer');
    my $ip = $rr->address;

    $c->stash( template=> 'lookup.tt', answer => $rr );
   
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

jon,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
