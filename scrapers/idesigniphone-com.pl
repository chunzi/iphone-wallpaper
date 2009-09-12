#!/usr/bin/perl
use lib './lib';
use Finder;

my $page = int shift;
$page = 1 if $page == 0;

my $finder = Finder->new(
    container => '.page',
    process => q{
        process 'a[rel="bookmark"]', bookmark => '@href';
    },
    tags_from => sub {
        my $img = shift;
        my ( $name ) = ( $img->{'bookmark'} =~ /\/([^\/]+)$/ );
        my @words = split(/-/, $name );
        return @words;
    }
);

for ( 1..427 ){
    my $url = sprintf 'http://idesigniphone.com/page/%d', $_;
    $finder->print( $url );
}
