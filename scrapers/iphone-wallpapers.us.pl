#!/usr/bin/perl
use lib './lib';
use Finder;

my $id = int shift;
$id = 1 if $id == 0;
my $url = sprintf 'http://iphone-wallpapers.us/wallpaper?id=%d', $id;

my $finder = Finder->new();
$finder->print( $url );
