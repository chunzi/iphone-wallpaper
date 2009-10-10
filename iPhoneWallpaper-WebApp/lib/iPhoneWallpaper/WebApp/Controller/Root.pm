package iPhoneWallpaper::WebApp::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';


sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

use File::Slurp;
my $path = iPhoneWallpaper::WebApp->path_to(',list');
my @photos = read_file( "$path" ); 
my @chosen = map { $photos[int rand($#photos)] } (1..7);
    $c->stash->{'photos'} = \@chosen;
    $c->stash->{'template'} = 'index.html';
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {}

=head1 NAME

iPhoneWallpaper::WebApp::Controller::Root - Root Controller for iPhoneWallpaper::WebApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=head2 end

Attempt to render a view, if needed.

=head1 AUTHOR

chunzi

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
