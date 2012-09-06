#!/bin/bash
################################################################################
# tmuxlogin - Open multiple tmux panes, each logged into a different server
#-------------------------------------------------------------------------------
# 20110302 dale bewley net
#
# Run this within your current tmux session to open a new window, or run it in
# the absence of a tmux session to create a new one. A new window will be
# created and split it into multiple panes. They are all synchronized by default
# and will each be ready to login to a different server.
#
# TODO:
#   o Option to ssh directly rather than just send keys.
#   o Option to do something other than login to a server. I guess that would
#     make 'tmuxlogin' a bad name.
#
# BUGS:
#   o Even if you give a new name, creating a new session does not work if you
#     are attached to any existing session. This is becuase the existance of
#     $TMUX is tested before the arguments are parsed.
#
#     This can be forced if $TMUX is temporarily unset long enough to run
#     new-session. However, it seems the orignial session is killed when the
#     2nd session is closed.
#
#   o Sometimes my main session has crashed when closing the tmuxlogin window.
#     It's happened on startup too.
#
################################################################################

# defaults
SESSION=$USER
SSH_USER=$USER
WINDOW="tmuxlogin"
TMUX=/usr/bin/tmux
# synchronize panes: 1=yes, 0=no
SYNC=1
SERVERS='localhost'

usage() {
    cat <<EOF >&2
$0 - Open multiple tmux panes, each logged into a different server.

Usage: $0 [-t tmux_session] [-w tmux_window] [-u ssh_user] [-v] <hosts ...>

Arguments:

 -h help
    This screen.

 -n no_synchronize
    Do not synchronize panes.

 -t tmux_session
    Name of existing tmux session to target, or new session.
    Default: "$SESSION"

 -u ssh_user
    User to ssh as.

 -v verbose
    Tell me something interesting.

 -w tmux_window
    Name of new tmux window to places panes in.
    Default: "$WINDOW"

EOF
}

debug() {
    echo "    Session: $SESSION"
    echo "     Window: $WINDOW"
    echo "Synchronize: $SYNC"
    echo "    Servers: $SERVERS"
    echo "   SSH User: $SSH_USER"
}

while getopts hvnt:u:w: opt
do
    case "$opt" in
      n)  SYNC="0";;
      t)  SESSION="$OPTARG";;
      u)  SSH_USER="$OPTARG";;
      v)  verbose=on;;
      w)  WINDOW="$OPTARG";;
      h) usage && exit 0;;
      \?) usage && exit 1;; # unknown flag
    esac
done

shift `expr $OPTIND - 1`
if [ -n "$*" ]; then
    SERVERS=$*
fi

open_windows() {
    # true if this is a brand new session
    new_session=$1

    echo "# $TMUX list-windows -t \"$SESSION\" | grep \"$WINDOW\""
    $TMUX list-windows -t "$SESSION" | grep "$WINDOW"
    if [ $? -eq 0 ]; then
        echo "Window '$SESSION:$WINDOW' already exists. Aborting."
    return
    fi

    # if this is a new session then there is no point in creating a new window
    if [ -n "$new_session" ]; then
        # this is a brand new session with only 1 window, so just rename it
        echo "# $TMUX rename-window  -t \"$SESSION:0\" \"$WINDOW\""
        $TMUX rename-window  -t "$SESSION:0" "$WINDOW"
    else
        # create new window in this pre-existing session
        echo "# $TMUX new-window -t "$SESSION" -a -n \"$WINDOW\""
        $TMUX new-window -t "$SESSION" -a -n "$WINDOW"
    fi

    # split window and echo servers to each pane
    # sending keys gives you a chance to decide when to type in password
    for server in $SERVERS; do
        echo "# $TMUX split-window -t \"$SESSION:$WINDOW\" -h"
        $TMUX split-window -t "$SESSION:$WINDOW" -h

        echo "# $TMUX send-keys -t \"$SESSION:$WINDOW\" \"ssh $SSH_USER@$server\""
        $TMUX send-keys -t "$SESSION:$WINDOW" "ssh $SSH_USER@$server"
    done

    # tile panes evenly
#    echo "# $TMUX select-layout -t \"$SESSION:$WINDOW\" tiled"
#    $TMUX select-layout -t "$SESSION:$WINDOW" tiled

    # synchronize input to all panes unless turned off
    if [ "$SYNC" -gt 0 ]; then
        echo "# $TMUX set-window-option -t "$SESSION:$WINDOW" synchronize-panes on"
        $TMUX set-window-option -t "$SESSION:$WINDOW" synchronize-panes on
    fi
}

if [ -n "$verbose" ]; then
    debug # show status
    sleep 1
fi

# does this session already exist?
$TMUX has-session -t "$SESSION"
if [ $? -ne 0 ]; then
    # session does not exist. create it.
    # this won't work if we are attached. even if the session name is different
    # the hack is to remove $TMUX temporarily
    echo "# $TMUX new-session -d -s \"$SESSION\""
    $TMUX new-session -d -s "$SESSION"
    split_only=1
fi

# time to open a window and chop it up
open_windows $split_only

# remove the original pane
echo "# $TMUX kill-pane -t \"$SESSION:$WINDOW.0\""
$TMUX kill-pane -t "$SESSION:$WINDOW.0"

# select the first pane
echo "# $TMUX select-pane -t \"$SESSION:$WINDOW.0\""
$TMUX select-pane -t "$SESSION:$WINDOW.0"

# split -h seems to stop at 5 unless layout is changed
echo "# $TMUX select-layout -t \"$SESSION:$WINDOW\" even-vertical"
$TMUX select-layout -t "$SESSION:$WINDOW" even-vertical

if [ -z "tmux" ]; then
    # now let's attach to the session if we aren't already attached
    # to some session
    $TMUX attach -t "$SESSION"
fi
