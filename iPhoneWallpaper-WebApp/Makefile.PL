#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'iPhoneWallpaper-WebApp';
all_from 'lib/iPhoneWallpaper/WebApp.pm';

requires 'Catalyst::Runtime' => '5.80011';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

requires 'File::Slurp';

install_script glob('script/*.pl');
auto_install;
WriteAll;
