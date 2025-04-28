#!/usr/bin/perl

use strict;
use warnings;
use Selenium::Firefox;
use Firefox::Marionette;


my $password_file = "$ENV{HOME}/.ssh/mcoc_passwd";
open(my $pw, '<', $password_file) 
  or die "Could not open file '$password_file' $!";
my $password = <$pw>;
chomp $password;
close $pw;

system("/usr/local/bin/firefox --private-window \\
  https://store.playcontestofchampions.com/ \\
  >/dev/null 2>&1 &");

# Wait for Firefox to start
sleep 8;

system("xdotool mousemove 1704 136 click 1");
sleep 1;

system("xdotool mousemove 984 567 click 1");
sleep 7;

system("xdotool mousemove 934 593 click 1");
system("xdotool type 'dopaminerush\@icloud.com'");
system("xdotool mousemove 934 666 click 1");
system("xdotool type $password");
undef $password;
system("xdotool mousemove 934 776 click 1");
sleep 6;

system("xdotool key Ctrl+Shift+k");

my $command = 'document.querySelectorAll("span[data-testid=\'get-free\']").forEach(el => el.click());';
sleep 1;
foreach my $char (split //, $command) {
    system("xdotool type '$char'");
    system("sleep 0.03");
}
system("xdotool key Return");
sleep 3;
system("xdotool key Ctrl+q");
