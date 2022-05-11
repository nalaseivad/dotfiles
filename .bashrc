# -*-sh-*-

################################################################################
# Notes
#
# Bash
#
#  * You can't put whitespace either side of the = in an alias statement
#      alias foo="bar"     # ok
#      alias foo = "bar"   # not ok
#  * The same is true for export
#      export foo="bar"     # ok
#      export foo = "bar"   # not ok
#
#
# Types of shell and shell startup scripts
#
#   Interactive, non-interactive, login & non-login shells
#    * An interactive shell is one which runs with an associated terminal (and
#      keyboard) for user interaction (output can be written to the screen and
#      the user can enter input).
#    * A non-interactive shell is one where this is not the case, e.g. for an
#      automated process such as commands executed via SSH
#    * A login shell is one that is run as part of the login of a user to a
#      system.
#    * A non-login shell is any other shell run by the user after logging on
#      or one that is run by an automated process not coupled to a logged in
#      user.
#
#   Startup scripts
#     /etc/profile
#       Systemwide init file for login shells.
#     /etc/bashrc
#       Systemwide init file for interactive, non-login shells only.
#     ~/.bash_profile
#       Personal init file for login shells.  Run after /etc/profile.
#     ~/.bashrc
#       Personal init file for interactive, non-login shells only.  Run after
#       /etc/bashrc.
#
# I have seen things not work properly with SSH operations when there are echo
# commands in ~/.bashrc that write regardless of whether the shell is
# interactive or not.  Such lines should be guarded with checks for an
# interactive shell.
#
#
# PuTTY settings
#
#  * Turn off the annoying bell under Terminal/Bell
#  * Set the foreground and background colors for terminal text under
#    Window/Colours (yes, PuTTY was written by a Brit).
#      Default Background = R   0, G   0, B   0  (Black)
#      Default Foreground = R 187, G 187, B 187  (Grey/White)
#  * Terminal/Keyboard
#      Home and End keys = Standard
#      Function keys and keypad = ESC[n~
#  * Connection/SSH/X11
#      Check "Enable X11 forwarding"
#        - I think this is necessary if I want to run X apps back to the PC
#          from which I am running PuTTY.  I will need to have an X Server
#          (e.g. http://xfree86.cygwin.com/) installed.
#
#
# SSH notes
#
#  If using PuTTY to connect to this host (via SSH) then configure things as
#  specified above.  However, if using command line SSH to connect from another
#  host (e.g. from Terminal on a Mac) then pass -X to ssh in order to enable X11
#  forwarding on the connection.  For example:
#
#  $ ssh -X <user>@<host>
#
#  This will only work if X11 forwarding is enabled in /etc/ssh/sshd_config via
#  this line ...
#
#    X11Forwarding yes
#


################################################################################
# Functions

# Check whether we have a given program on the system
_have()
{
  command -v $1 &>/dev/null
}

# Check whether the current shell is interactive
_interactive()
{
  [[ $- == *i* ]]
}


################################################################################
# Open welcome message for interactive shells

thisfile='.bashrc'
wd=`pwd`

if _interactive ; then
  echo ">> $wd/$thisfile"
  echo "Welcome to `uname -s` `uname -r` on node `uname -n`"
fi


################################################################################
# Setup

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  #echo "Platform == Linux"
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  #echo "Platform == Mac"
fi

#
# Host specific setup.  Commands to set things up for a given host so that the
# rest of this script can run as is.  For example, on one Linux machine that I
# use it has emacs installed but with the executable emacs-23.1 as opposed to
# emacs.  This script assumes that I can call 'which emacs' in order to get the
# path to the binary so I need to first alias emacs to emacs-23.1 so that emacs
# will be known to the rest of the script.  This is a host-specific step and so
# I put it in .bashrc-host (on that one host only); I do NOT share .bashrc-host
# between Linux hosts.
#
if [ -f ~/.bashrc-host ]; then
  source ~/.bashrc-host
fi

################################################################################
# ls

detail='-pF'  # Add trailing characters to directory list items
              # / for directories, * for executables, @ for sym links, etc.
#
# Colors
#   On Linux ...
#     * Edit the .dircolors file to specify the color of each filetype
#     * To create the initial dircolors file if it doesn't exist yet run this
#       $ dircolors -p > .dircolors
#     * The eval linr below will set and export LS_COLORS in the environment
#     * Alias ls to use color as specified via $LS_COLORS
#   On Mac OSX ...
#     * Specify the colors via the LSCOLORS environment variable
#     * Alias ls to use color as specified via $LSCOLORS
#
if [[ $platform == 'linux' ]]; then
  eval "`dircolors -b ~/.dircolorsrc`"
  alias ls='ls --color=auto $detail'
elif [[ $platform == 'mac' ]]; then
  export LSCOLORS="gxbxhxDxfxhxhxhxhxcxcx"
  alias ls='ls -G $detail'
fi

# Other ls related shortcuts
alias ll='ls -l'                   # Long List
alias lla='ls -al'                 # Long List (inc .* files)
alias ll.='ls -ld .*'              # Long List of just .* files
alias ld='tree -d -L 1'            # List directories in the current directory
alias lda='tree -ad -L 1'          # Include .* directories
alias llt='ls -ltr'                # List files by modification time
alias lls='ls -lSr'                # List files by size

################################################################################
# Emacs
#
# I need to put this section AFTER loading FactSet shared stuff since I want to
# re-alias xemacs which the FactSet shared config aliases.  Also, the output of
# 'which' could be multi-line if we are resolving aliases so I want to just take
# the last line (the final resolved binary) and trim off any spaces.
#
if [[ $platform == 'mac' ]]; then
  emacsbin="/Applications/Emacs.app/Contents/MacOS/Emacs"
else
  emacsbin=`which emacs | tail -n 1 | sed "s/\s+//g"`
fi
#
# Running character mode Emacs with -rv sometimes works and sometimes does not.
# Assuming that I have set my default terminal foreground and background colors
# in PuTTY as above then Emacs should run with the same colors and achieve the
# effect of -rv anyway.
#
alias emacs="$emacsbin -nw"
#
# Running Emacs with X will not respect my terminal foreground/background colors
# and so I need to pass -rv on the command line in order to get reverse video.
# I should look in to whether I need this if I config my colors in my .emacs
# file though.  The 6x13 font works well most of the time.
#
alias xemacs="$emacsbin &"


################################################################################
# Misc

export TERM=xterm-256color

if [ -x /bin/less ]; then
  export PAGER=less
fi

#
# Shell Prompt
#
# I learnt that it's better to use tput than literal escape sequences for the
# non-printable characters for coloring, and also that you have to wrap those
# in \[ and \].
# https://askubuntu.com/questions/24358/how-do-i-get-long-command-lines-to-wrap-to-the-next-line

# Prompt:  [<user>@<host> <dir>]$  with <user>/<host> cyan and <dir> in green
cyan=$(tput setaf 6)
green=$(tput setaf 2)
reset=$(tput sgr0)
export PS1="[\[$cyan\]\u@\h\[$reset\] \[$green\]\w\[$reset\]]$"

# Prevent CTRL-s from messing up putty at the command line
# Only execute this for an interactive shell
# https://superuser.com/questions/124845/can-you-disable-the-ctrl-s-xoff-keystroke-in-putty/376881
[[ $- == *i* ]] && stty -ixon


################################################################################
# Load additional (potentially host specific) config from .profile.d/

if [ -d ~/.profile.d ]; then
  if [ -f ~/.profile.d/* ]; then
    for f in ~/.profile.d/*; do source $f; done
  fi
fi


################################################################################
# Close welcome message for interactive shells

if _interactive ; then
  echo "<< $wd/$thisfile"
fi


################################################################################
# Cleanup

# Remove previously defined functions
unset -f _have
unset -f _interactive
