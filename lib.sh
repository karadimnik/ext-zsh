#!/usr/bin/env bash

function append_in_file() {
    local i=1
    local file=$1
    # IFS=' ' read -ra miniApps <<< "${@}"
    for arg; do
        if (("$i" == 1)); then
            i=$((i + 1))
            continue
        fi
        printf '\n%b' "$arg" >>"$file"
    done
}

# Control characters
CBRK=$'\x1b[0;01m' # Line break?
CNRM=$'\x1b[0;0m'  # Clear color
CUDL=$'\x1B[4m'    # Underline
CFSH=$'\x1B[5m'    # Flash
CRVS=$'\x1B[7m'    # Reverse video

# Normal color
CBLK=$'\x1B[0;30m'
CRED=$'\x1b[0;31m'
CGRN=$'\x1b[0;32m'
CYEL=$'\x1b[0;33m'
CBLU=$'\x1b[0;34m'
CMAG=$'\x1b[0;35m'
CCYN=$'\x1b[0;36m'
CWHT=$'\x1B[0;37m'

# Bright color
BBLK=$'\x1B[1;30m'
BRED=$'\x1b[1;31m'
BGRN=$'\x1b[1;32m'
BYEL=$'\x1b[1;33m'
BBLU=$'\x1b[1;34m'
BMAG=$'\x1b[1;35m'
BCYN=$'\x1b[1;36m'
BWHT=$'\x1B[1;37m'

# Background colors
BKBLK=$'\x1B[40m'
BKRED=$'\x1b[41m'
BKGRN=$'\x1b[42m'
BKYEL=$'\x1b[43m'
BKBLU=$'\x1b[44m'
BKMAG=$'\x1b[45m'
BKCYN=$'\x1b[46m'
BKWHT=$'\x1B[47m'
# "msg [OK]"
function pr_succ { # Reset color with \n
    if [ -f /.dockerenv ] || [ "$IS_DOCKER_IMAGE" == "TRUE" ]; then
        printf "%b\n" "${BBLU}[ ${BGRN}OK${BBLU} ]${CNRM} ${@}"
        # echo -n "${BBLU}[ ${BGRN}OK${BBLU} ]${CNRM} ${@}"
        # printf "%s" "${BBLU}[${BGRN}OK${BBLU}]"             # Pad with spaces
        # echo "${CNRM}"                                   # Reset color with \n
    else

        local TWIDTH=$(tput cols)                          # Get terminal width
        local SWIDTH="$@"                                  # Save string
        local WSPACE="$(expr ${TWIDTH} - ${#SWIDTH} + 21)" # Amount of whitespace
        echo -n {@}                                        # Print message
        printf "%${WSPACE}s" "${BBLU}[ ${BGRN}OK${BBLU} ]" # Pad with spaces
        echo "${CNRM}"                                     # Reset color with \n
    fi
}

# "msg [!!]"
function pr_fail {
    if [ -f /.dockerenv ] || [ "$IS_DOCKER_IMAGE" == "TRUE" ]; then
        printf "%b\n" "${BBLU}[ ${BRED}!!${BBLU} ]${CNRM} ${@}"
        # echo -n  "${BBLU}[ ${BRED}!!${BBLU} ]${CNRM}" ${@}
        # printf "%s" "${BBLU}[${BRED}!!${BBLU}]"             # Pad with spaces
        # echo "${CNRM}" # Reset color with \n
    else

        local TWIDTH=$(tput cols)                          # Get terminal width
        local SWIDTH="$@"                                  # Save string
        local WSPACE="$(expr ${TWIDTH} - ${#SWIDTH} + 21)" # Amount of whitespace
        echo -n ${@}                                       # Print message
        printf "%${WSPACE}s" "${BBLU}[ ${BRED}!!${BBLU} ]" # Pad with spaces
        echo "${CNRM}"                                     # Reset color with \n
    fi
}

# Warning msg in yellow
function pr_warn {
    echo -e "${BYEL}${@}${CNRM}"
}

# Information msg in blue
function pr_info {
    echo -e "${BBLU}${@}${CNRM}"
}

# Successful completion msg in green
function pr_done {
    echo -e "${BGRN}${@}${CNRM}"
}

# Error msg in red
function pr_err {
    echo -e "${BRED}${@}${CNRM}"
}

function log_result {
    # local i=1
    # local file=$1
    # # IFS=' ' read -ra miniApps <<< "${@}"
    # for arg; do
    #     if (("$i" == 1)); then
    #         i=$((i + 1))
    #         continue
    #     fi
    #     printf '\n%b' "$arg" >> "$file"
    # done

    if [ "$1" == 0 ]; then
        pr_succ "$3"
    else
        pr_fail "[ Failed ]" "$3"
        pr_fail "$2"
        exit 1
    fi
}
