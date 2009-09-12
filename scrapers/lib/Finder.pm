package Finder;
use strict;

use Web::Scraper;
use URI;
local $|=1;

our $tags_exclude = { map { $_ => 1 } qw/
    iphone wallpaper by - 0 1 2 3 4 5 6 7 8 9
/};

sub new {
    my $class = shift;
    my %params = @_;
    my $self = bless { @_ }, $class;
    $self->{'container'} ||= 'body';
    $self->{'process'} ||= '';
    $self->{'tags_from'} ||= sub {()};

    eval sprintf q{
        $self->{'scraper'} = scraper {
            process "%s", "imgs[]" => scraper { 
                process 'img', 
                    src => '@src',
                    width => '@width', height => '@height', style => '@style',
                    title => '@title', alt => '@alt';
                %s
            };
        };
    }, $self->{'container'}, $self->{'process'};
    die "get scraper failed: $@\n" if $@;

    return $self;
}

sub print {
    my $self = shift;
    my $url = shift;
    return unless defined $url;
#    printf STDERR "url: $url\n";

    my $res = $self->{'scraper'}->scrape(URI->new($url));
    my $images = $res->{'imgs'};
#    print Dumper($images);use Data::Dumper;
    map {
        printf "%s  %s  %s\n", $_->{'src'}, join(',',@{$_->{'tags'}}), $url;
    } 
    map { $self->_append_tags($_); $_ } 
    grep { $self->_size_ok($_) } @$images;
}


sub _append_tags {
    my $self = shift;
    my $img = shift;

    my $tags_from = $self->{'tags_from'};
    my @tags_from = &$tags_from($img);

    my $tags;
    map { $tags->{$_}++ } grep { ! exists $tags_exclude->{$_} } 
    map { split(/\s+/, $_ ) } map { s/\W+$//; $_ } map { lc }
    ( @tags_from, map { $img->{$_} } qw/alt title tags/ );
    my @tags = keys %$tags;
    $img->{'tags'} = \@tags;
}

sub _size_ok {
    my $self = shift;
    my $img = shift;

    my ( $width, $height ) = map { int } ( $img->{'width'}, $img->{'height'} );
    if ( defined $img->{'style'} ){
        my ( $sw ) = ( $img->{'style'} =~ /\bwidth\b\s*:\s*\b(\d+)/i );
        my ( $sh ) = ( $img->{'style'} =~ /\bheight\b\s*:\s*\b(\d+)/i );
        $width = $sw if $width == 0;
        $height = $sh if $height == 0;
    }
    return ( $width == 320 and $height == 480 ) ? 1 : 0;
}

1;
