#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use File::Basename;

my $directory = '.';
opendir(my $dir, $directory) or die "Cannot open directory: $!";
my @files = readdir($dir);
closedir($dir);

foreach my $file (@files) {
    # Skip '.' and '..' entries
    next if $file =~ /^\.\.?$/;

    my $new_file_name = $file;

    $new_file_name =~ s/\[.*?\]//g;
    $new_file_name =~ s/Second Edition/2E/g;
    $new_file_name =~ s/Second Ed/2E/g;
    $new_file_name =~ s/Joe Rogan Experience/JRE/g;
    $new_file_name =~ s/MMA Show //g;
    $new_file_name =~ s/ \./\./g;
    $new_file_name =~ s/  / /g;
    


    # Rename the file if the name has changed
    if ($new_file_name ne $file) {
        rename("$directory/$file", "$directory/$new_file_name")
            or warn "Could not rename $file to $new_file_name: $!";
    }
}
