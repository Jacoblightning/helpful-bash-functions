#!/usr/bin/env bash

# -----------------------------------------------------BEGIN HELPER FUNCTIONS (Do not call normally)--------------------------------------------------

_pid=0
_term=""


_shells=("bash" "fish" "zsh" "sh" "ash" "dash")

_in_shells () {
    if [[ " ${_shells[*]} " =~ [[:space:]]${1}[[:space:]] ]]; then
        return 0
    fi
    return 1
}

_up_pid () {
    npid=$(cat /proc/$(echo $$)/stat | cut -d \  -f 4)
    terminal=$(basename "/"$(ps -o cmd -f -p $npid | tail -1 | sed 's/ .*$//'))

    # "Recursivly" check the parent pid until we find one that's not bash
    while _in_shells "$terminal"; do
        npid=$(cat /proc/${npid}/stat | cut -d \  -f 4)
        terminal=$(basename "/"$(ps -o cmd -f -p $npid | tail -1 | sed 's/ .*$//'))
    done
    _pid="$npid"
    _term="$terminal"
    
    # Yes, I could use local vars but they were not working and I was too tired to debug it.
    unset npid
    unset terminal
}

# -----------------------------------------------------------END HELPER FUNCTIONS-------------------------------------------------------------------

# Find the pid of the terminal emulator
top_pid () {
    if [ "$_pid" -eq 0 ]; then
        _up_pid
    fi

    # >&2: see http://www.tldp.org/LDP/abs/html/io-redirection.html for explanation.
    >&2 echo "Emulator PID is: "
    echo "$_pid"
}

# Return 0 if in a tty. 1 otherwise (pty)
in_tty () {
    if [ -z "$_term" ]; then
        _up_pid
    fi

    if [ "$_term" = "-bash" ]; then
        # We are in a tty
        return 0
    else
        # We are in a pty
        return 1
    fi
}

# Get the name of the terminal emulator
emulator_name () {
    if in_tty; then
        echo "tty"
        return 0
    fi
    
    # The "in_tty" in the if statement above set the variable for us.
    echo "$_term"
    return 0
}
