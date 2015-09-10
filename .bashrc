# -*-sh-*-

################################################################################
# Bash Notes
#
# * You can't put whitespace either side of the = in an alias statement
#     alias foo="bar"     # ok
#     alias foo = "bar"   # not ok
# * export seems more forgiving though
#
################################################################################

thisfile='.bashrc'
wd=`pwd`
echo ">> $wd/$thisfile"


################################################################################
# PuTTY settings
#
# * Turn off the annoying bell under Terminal/Bell
# * Set the foreground and background colors for terminal text under
#   Window/Colours (yes, PuTTY was written by a Brit).
#     Default Background = R   0, G   0, B   0  (Black)
#     Default Foreground = R 187, G 187, B 187  (Grey/White)
# * Terminal/Keyboard
#     Home and End keys = Standard
#     Function keys and keypad = ESC[n~
# * Connection/SSH/X11
#     Check "Enable X11 forwarding"
#       - I think this is necessary if I want to run X apps back to the PC
#         from which I am running PuTTY.  I will need to have an X Server
#         (e.g. http://xfree86.cygwin.com/) installed.
#
################################################################################

################################################################################
# SSH notes
#
# If using PuTTY to connect to this host (via SSH) then configure things as
# specified above.  However, if using command line SSH to connect from another
# host (e.g. from Terminal on a Mac) then pass -X to ssh in order to enable X11
# forwarding on the connection.  For example:
#
# $ ssh -X <user>@<host>
#
# This will only work if X11 forwarding is enabled in /etc/ssh/sshd_config via
# this line ...
#
#   X11Forwarding yes
# 
################################################################################


#
# Detect OS
#
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  #echo "Platform == Linux"
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  #echo "Platform == Mac"
fi


################################################################################
# ls
#
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

#
# Other shortcuts
#
alias ll='ls -l'                   # Long List
alias lla='ls -al'                 # Long List (inc .* files)
alias ld='tree -d -L 1'            # List directories in the current directory
alias lda='tree -ad -L 1'          # Include .* directories
alias llt='ls -ltr'                # List files by modification time
alias lls='ls -lSr'                # List files by size
#
################################################################################


################################################################################
# FactSet stuff
#
if [[ -e /var/cfengine/classes/nextgen ]]
then
  echo "*** This is a Fonix box - Configuring accordingly ***"
  # Source standard stuff
  source /home/fonix/prd_progs/tools/engineering-login.sh
  source /home/dev/fonix/prd_progs/build/build_environment_setup.sh
  
  # Perforce config
  export P4USER=davies
  export P4PORT=scm.factset.com:1666
  export P4CONFIG=.p4rc
  export P4EDITOR="emacs -nw"

  alias tmux='~/bin/tmux'
  alias tree='~/bin/tree'
  
  # Aliases for the fcd and fdb prefixes for $ fdb|fcd <command> invocations
  alias fdb='source /home/fonix/prd_progs/fdb/fonix_utils_cover.sh fdb_utils_main'
  alias fcd='source /home/fonix/prd_progs/fdb/fonix_utils_cover.sh fcd_utils_main'
  
  # Usage:  rb <change_number>
  alias rb='perl /home/data/index/script/common/submit_review_board.pl'
  
  # Rakefds wrappers and shortcuts
  alias senv='source /home/user/davies/scripts/senv.sh'
  alias rkr='source /home/user/davies/scripts/rkr.sh'
  alias rkd='source /home/user/davies/scripts/rkd.sh'
  
  export DISABLE_FORMULA_LINUX_VERIFY=1

  export PATH="/home/user/davies/bin:$PATH"
  export LD_LIBRARY_PATH="/home/user/davies/local/lib:$LD_LIBRARY_PATH"
  export PATH="/home/fonix/prd_progs/bin:$PATH"
  
  export DISPLAY="daviespc.pc.factset.com:0"
fi
#
################################################################################


################################################################################
# Emacs
#
# I need to put this section AFTER loading FactSet shared stuff since I want to
# re-alias xemacs which the FactSet shared config aliases.
#
emacsbin=`which emacs`
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
#
################################################################################


################################################################################
# Misc
#

export TERM=xterm-256color

if [ -x /bin/less ]; then
  export PAGER=less
fi

#
# Prompt:  [<user>@<host> <dir>]$  with <dir> in green and <user>/<host> cyan
#
STARTCYAN='\e[0;36m'
STARTGREEN='\e[0;32m'
ENDCOLOR='\e[0m'
export PS1="[$STARTCYAN\u@\h$ENDCOLOR $STARTGREEN\w$ENDCOLOR]$"

# Prevent CTRL-s from messing up putty at the command line
# See: http://goo.gl/JEPbWh
stty -ixon

#
################################################################################


################################################################################
# Load additional (pottentially host specific) config from .profile.d/
#

if [ -d ~/.profile.d ]; then
  for f in ~/.profile.d/*; do source $f; done
fi

#
################################################################################


echo ""
echo "Welcome to `uname -s` `uname -r` on node `uname -n`"
echo ""
echo "<< $wd/$thisfile"
