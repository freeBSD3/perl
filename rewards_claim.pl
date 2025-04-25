#!/usr/bin/perl

use strict;
use warnings;


my $url = 'https://store.playcontestofchampions.com/';
my $cmd = "firefox -private-window $url >/dev/null 2>&1 &";

my $pw = do {
    open(my $pwf, '<', "$ENV{HOME}/.ssh/mcoc_passwd");
    local $/;
    <$pwf>;
};
chomp $pw;

# Check if a Firefox window already exists 
my $window_id;
$window_id = `xdotool search --name "Mozilla Firefox"`;
chomp $window_id;

if ($window_id) {
    # Firefox window exists, kill it
    system("xdo kill $window_id");
    sleep 1;  # Wait for the window to close
}

# Launch a new instance of Firefox
my $output = system($cmd);
sleep 5;

# Get the ID of the new Firefox window
$window_id = `xdotool search --name "Mozilla Firefox"`;
chomp $window_id;

# Move the Firefox window to Workspace 4
system("xdotool set_desktop_for_window $window_id 3");
system("xdotool set_desktop 3");
sleep 2;
system("xdotool mousemove 1703 136 click 1");
sleep 2;
system("xdotool mousemove 966 577 click 1");
sleep 5;
system("xdotool mousemove 936 594 click 1");
sleep 2;
system("xdotool type \"dopaminerush\@icloud.com\"");
system("xdotool mousemove 936 666 click 1");
system("xdotool type $pw");
system("xdotool mousemove 936 775 click 1");
sleep 5;
system("xdotool mousemove 200 512 click 1");
sleep 2;
system("xdotool key ctrl+shift+k");
sleep 2;
my $js_code = 'document.querySelector(\'[data-testid="free-button"]\').click()';
system("echo '$js_code' | xclip -selection clipboard");
system('xdotool', 'key', 'ctrl+v');
system('xdotool', 'key', 'Return');
