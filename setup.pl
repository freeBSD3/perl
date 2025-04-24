#!/usr/bin/perl

use strict;
use warnings;



#################################################################
# Exit script if no internet connection

system("ping -c 1 8.8.8.8 > /dev/null 2>&1");

# Check the exit status of the ping command
if ($? != 0) {
    print "Offline: no internet connection\n";
    exit 1; # non-zero status to indicate failure
}

#################################################################


#################################################################
# Set the home dir to setup

my $parent_dir = '/home/jbm/tmp';
if (not -d $parent_dir)
{
  mkdir $parent_dir or die "Failed to create $parent_dir\n";  
}

#################################################################
# Make all the directories

my @dirs = (
  'books',
  'dotfiles',
  'Downloads',
  'Documents',
  'perl',
  'phone',
  'scripts',
  'Storage',
  'tablet',
  'writing',
);

foreach my $dir (@dirs)
{
  my $path = "$parent_dir/$dir";
  if (not -d $path)
  {
    mkdir $path or warn "Failed to create $path\n";
  }
}
#################################################################


#################################################################
# Install programs
# aperform other convenience or 
# security hardening edits while root

my @programs = (
  'conky',
  'curl',
  'doas',
  'exfat-utils',
  'fastfetch',
  'feh',
  'firefox-esr',
  'fluxbox',
  'fusefs-exfat',
  'htop',
  'GraphicsMagick',
  'ksh93',
  'libreoffice',
  'librewolf',
  'lolcat',
  'mupdf',
  'netpbm',
  'p5-Selenium-Remote-Driver',
  'qbittorrent',
  'scrot',
  'slock',
  'vlc',
  'wget',
  'wireguard-tools',
  'xdo',
  'xdotool',
  'xorg',
  'yt-dlp',
);

my $program_list = join ' ', @programs;
system("su -m <<EOF
pkg install -y $program_list
echo 'permit nopass jbm as root' > /usr/local/etc/doas.conf

sed -i '' 's/#*PermitRootLogin.*/PermitRootLogin no/' \\
  /etc/ssh/sshd_config

sed -i '' '/security.bsd.see_other_uids/s/#//' \\
  /etc/sysctl.conf

grep -q '^kern.randompid=1' /etc/sysctl.conf || \\
  echo 'kern.randompid=1' >> /etc/sysctl.conf
grep -q '^hald_enable="YES"' /etc/rc.conf || \\
  echo 'hald_enable="YES"' >> /etc/rc.conf
grep -q '^fusefs_enable="YES"' /etc/rc.conf || \\
  echo 'fusefs_enable="YES"' >> /etc/rc.conf
grep -q '^ntpd_enable="YES"' /etc/rc.conf || \\
  echo 'ntpd_enable="YES"' >> /etc/rc.conf

EOF");
#################################################################


#################################################################
# Populate .xinitrc

my $xinitrc;
if (not -f "$parent_dir/.xinitrc")
{
  open($xinitrc, '>', "$parent_dir/.xinitrc")
    or die "Could not open file: $!";
  print $xinitrc <<'EOF';
exec /usr/local/bin/startfluxbox 
EOF
  close($xinitrc);
  undef $xinitrc;
}

#################################################################


#################################################################
# Populate .vimrc

my $vimrc;
if (not -f "$parent_dir/.vimrc")
{
  open($vimrc, '>', "$parent_dir/.vimrc")
    or die "Could not open file: $!";
  print $vimrc <<'EOF';
set expandtab
set nocompatible
set number
set shiftwidth=2
set tabstop=2
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set nohlsearch
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
EOF
  close($vimrc);
  undef $vimrc;
}

#################################################################


#################################################################
# Populate .Xresources file for xterm

my $Xresources;
if (not -f "$parent_dir/.Xresources")
{
  open($Xresources, '>', "$parent_dir/.Xresources")
    or die "Could not open file: $!";

  print $Xresources <<'EOF';
! Use a nice truetype font and size by default... 
! *.font: xft.Hack:size=12
! xterm*faceName: Hack Bold
xterm*faceName: Hack
xterm*faceSize: 12

! xterm enabled to handle clipboard events
xterm*selectToClipboard: true

! Every shell is a login shell by default 
! (for inclusion of all necessary environment variables)
xterm*loginshell: true

! I like a LOT of scrollback...
xterm*savelines: 16384

! double-click to select whole URLs :D
xterm*charClass: 33:48,36-47:48,58-59:48,61:48,63-64:48,95:48,126:48

! DOS-box colours...
! Bright Green
xterm*foreground: rgb:00/ff/00

! Vibrant Orange
! xterm*foreground: rgb:ff/a5/00

! Black
xterm*background: rgb:00/00/00

xterm*color0: rgb:00/00/00
xterm*color1: rgb:a8/00/00
xterm*color2: rgb:00/a8/00
xterm*color3: rgb:a8/54/00
xterm*color4: rgb:00/00/a8
xterm*color5: rgb:a8/00/a8
xterm*color6: rgb:00/a8/a8
xterm*color7: rgb:a8/a8/a8
xterm*color8: rgb:54/54/54
xterm*color9: rgb:fc/54/54
xterm*color10: rgb:54/fc/54
xterm*color11: rgb:fc/fc/54
xterm*color12: rgb:54/54/fc
xterm*color13: rgb:fc/54/fc
xterm*color14: rgb:54/fc/fc
xterm*color15: rgb:fc/fc/fc

! right hand side scrollbar...
xterm*rightScrollBar: false 
xterm*ScrollBar: false

! stop output to terminal from jumping down 
! to bottom of scroll again
xterm*scrollTtyOutput: false
EOF
  close($Xresources);
  undef $Xresources;
}

#################################################################


#################################################################
# Populate .kshrc file

my $kshrc;
if (not -f "$parent_dir/.kshrc")
{
  open($kshrc, '>', "$parent_dir/.kshrc")
    or die "Could not open file: $!";

  print $kshrc <<'EOF';
# PS1=' ${PWD}  -->> '
PS1=' -->> '

# without this, arrow keys
# and tab completion were bugged
set -o emacs

alias krc='vim ~/.kshrc'
alias src='. ~/.kshrc'

alias ll='ls -l'
alias la='ls -a'
alias ldot='ls .*'

alias c=clear
alias cl=clear

alias install='yes | doas pkg install'
alias update='yes | doas pkg update'
alias search='pkg search'
alias vi=vim
alias dvim='doas vim'
alias reboot='doas reboot'
alias restart='doas reboot'
alias off='doas poweroff'
alias b='acpiconf -i 0 | grep Remain'
alias batt='acpiconf -i 0 | grep Remain'
alias ifc=ifconfig
alias ifup='doas ifconfig wlan0 up'
alias ifdown='doas ifconfig wlan0 down'

alias l='ls -cpv --color=auto'
alias ls='ls -cpv --color=auto'
alias sl='ls -cp --color=auto'
alias la='ls -acp --color=auto'

# alias install='yes | sudo dnf install'
# alias search='dnf search'

alias fast=fastfetch
alias ff='firefox >/dev/null 2>/dev/null &'
alias wiscan='ifconfig wlan0 scan'
alias tasks='vim ~/Documents/tasks.txt'
alias m=mplayer
alias menu='sudo vi /boot/grub/grub.cfg'
alias lo='libreoffice >/dev/null 2>/dev/null &'
alias poweroff='sudo poweroff'
alias mount='doas mount'
alias umount='doas umount'
alias du='du -hs'
alias py=python
alias ldev='ls /dev/ | grep da'
alias lynx='lynx -vikeys'
alias x0='xbacklight -dec 100'
alias phys='epdfview /home/jbm/classes/physics/physics*every*pdf*'
alias keys='vi /home/jbm/.fluxbox/keys'
alias df='df -h | grep home'
alias ping='ping -c 3 ddg.gg'
alias free='free -h'
alias lock=slock
alias mulcon='mullvad connect'
alias grep='grep -i'
alias path='echo -e ${PATH//:/"\n"} | lolcat'
alias areacode='cat ~/Documents/areacodes.txt | grep'
alias more=less
alias rmd='rm -r'
alias vlc='vlc --rate'
alias wthr='perl ~/scripts/wthr.pl'
alias newhop='perl ~/perl/relays.pl; sleep 5; ipaddr'

# :xdigit: for hexidecimal characters
alias macgrep="grep -Eo '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'"
alias ipgrep="grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'"

tidyperl()
{
  perltidy -gnu -i=2 $1
  mv $1.tdy $1
}

ipaddr()
{
  curl -s -o ipaddr -A "Windows NT" https://www.showmyip.com
  grep -E '>City|>Country|>Your IPv4|>Internet' ipaddr |\
  sed 's/<td>//g;s/<\/td>/ /g;s/<b>//g;s/<\/b>//g' |\
  lolcat -g 00FFFF:80FF00 -b
  # removes whitespace
  # sed 's/<td>//g;s/<\/td>/ /g;s/<b>//g;s/<\/b>//g' |\
  # sed 's/^[ \t]*//' | lolcat
  rm ipaddr
}

depsort()
{
	cat ~/Documents/to_install.txt | sort > ~/.dependency
	cat ~/.dependency > ~/Documents/to_install.txt
}

fynd()
{
  /usr/bin/find / -iname *$1* 2>/dev/null
}

wicon()
{
  doas ifconfig wlan0 ssid $1 up
  doas dhclient wlan0
}

docs()
{
	cd ~/Documents
}

scripts()
{
	cd ~/scripts
}

pics()
{
	cd ~/Pictures
}

stor()
{
	cd ~/Storage
}

downloads()
{
	cd ~/downloads
}

media()
{
        cd /media/
}

EOF
  close($kshrc);
  undef $kshrc;
}

#################################################################


#################################################################
# Append lines to fluxbox keys file 

my $keys_file = "$ENV{HOME}/.fluxbox/keys";
my @lines = (
    "Control Mod1 t :ExecCommand xterm -geometry 86x54+525+0",
    "Control Mod1 b :ExecCommand librewolf",
    "Control Mod1 d :ExecCommand dillo",
    "Control Mod1 l :ExecCommand libreoffice",
    "Control Mod1 f :Maximize"
);

if (-f $keys_file) {
    open my $read_fh, '<', $keys_file or die $!;
    my $content = do { join '', <$read_fh> };
    close $read_fh;

    for my $line (@lines) {
        unless ($content =~ /\Q$line\E\n/) {
            open my $append_fh, '>>', $keys_file or die $!;
            print $append_fh "$line\n";
            close $append_fh;
        }
    }
} else {
    open my $write_fh, '>', $keys_file or die $!;
    print $write_fh join("\n", @lines) . "\n";
    close $write_fh;
}

#################################################################
