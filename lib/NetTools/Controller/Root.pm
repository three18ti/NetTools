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

my @dns_types = qw( A MX NS SPF SRV TXT );

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my %params;

    $c->stash (template => 'index.tt', dns_types => \@dns_types,);
}

sub dns_search : Chained('/') PathPart('dns_search') {
    my ($self, $c) = @_;
    my $domain = $c->request->param('domain');
    my $search_type =$c->request->param('search_type');

    # set the form as the defualt template
    $c->stash( template => 'forms/dns_search.tt', dns_types => \@dns_types );

    # Set a nice instructional message
    return $c->stash( info_msg => 'Please enter a domain') unless $domain;

    my $res = Net::DNS::Resolver->new;
    my $query = $res->search($domain, $search_type)        
        || return $c->stash( error_msg => 'Please enter a valid domain', );
    
    my $rr = $query->pop('answer');

    my @columns = qw( address class type name );
    $c->stash( 
        template    => 'results/dns_search.tt', 
        columns     => \@columns,
        answer      => $rr 
    );
}

=head2 about

About page

=cut

sub about : Chained PathPart('about') {
    my ( $self, $c ) = @_;
    $c->stash( template => 'about.tt' );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->stash( template => '404.tt');
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
