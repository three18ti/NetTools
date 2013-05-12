package NetTools::Controller::Root;
use Moose;
use namespace::autoclean;

with 'NetTools::Vars', 'NetTools::Validate';

use Net::DNS::Dig;
use Net::ParseWhois;

use Data::Dumper;

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

    $c->stash (template => 'index.tt', dns_types => $self->dns_types,);
}

sub dns_search : Chained PathPart('dns_search') {
    my ($self, $c) = @_;
    my $domain = $c->request->param('domain');
    my $search_type =$c->request->param('search_type');

    # set the form as the defualt template
    $c->stash( template => 'forms/dns_search.tt', dns_types => $self->dns_types );

    # Set a nice instructional message
    return $c->stash( info_msg => 'Please enter a domain') unless $domain;
    
#    return $c->stash( error_msg => 'Please enter a valid domain')
#        unless $self->is_valid( 'domain' => $domain );

    return $c->stash( error_msg => 'Please enter a valid search type' ) 
#        unless grep /^$search_type$/, @{$self->dns_types};
        unless grep $search_type eq $_, @{$self->dns_types};
    
    my $answer = Net::DNS::Dig->new()->for( $domain, $search_type )->sprintf;

    my @columns = qw( address class type name );
    $c->stash( 
        template    => 'results/dns_search.tt', 
        columns     => \@columns,
        answer      => $answer 
    );
}

sub domain_whois : Chained PathPart('domain_whois') {
    my ($self, $c) = @_;
    my $domain = $c->request->param('domain');

    $c->stash( template => 'forms/domain_whois.tt', );

    # Set a nice instructional message
    return $c->stash( info_msg => 'Please enter a domain', ) unless $domain;

    my $whois = Net::ParseWhois::Domain->new($domain);
    
    return $c->stash( error_msg => 'Could not connect to Whois Server' ) unless $whois->ok;

    $c->stash( template => 'results/domain_whois.tt', whois => $whois );
}



=head2 about

About page

=cut

sub about : Chained PathPart('about') {
    my ( $self, $c ) = @_;
    $c->stash( template => 'about.tt' );
}

=head2 contact

Contact Page

=cut

sub contact : Chained PathPart('contact') {
    my ( $self, $c ) = @_;
    $c->stash( template => 'contact.tt' );
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
