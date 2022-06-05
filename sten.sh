#!/usr/bin/env bash

PROGRAM_NAME=sten
MSG_NO_TEMPLATE="info: No template provided, using C Template. "
MSG_NO_DIR="info: No directory provided, using current directory. "
MSG_NO_EMPTY_DIR="error: Please ensure the target directory exists and is empty. "
MSG_NO_XDG_CONFIG="info: \$XDG_DATA_HOME not set, using $HOME/.local/share. "
MSG_TEMPLATE_FOUND="info: Template found."


help_message() {
    printf "Usage:\n-t template name\n-d target directory\n-v verbose output\n"
}

VERBOSE=false

while [[ "$#" -gt 0 ]]; do 
    case "${1}" in
        -h|\?|--help) help_message; exit 0 ;;
        -v|--verbose) VERBOSE=true;;
        -d|--directory) TARGET_DIRECTORY="${2}"; shift ;;
        -t|--target) TARGET_LANGUAGE="${2}" ; shift ;;
        *) printf '%s\n' "unknown option, use -h / --help"; exit 1;;
    esac 
    shift
done


#if not set use defaults 
USERCONFIG=$HOME/.local/share
if [ -z "$XDG_DATA_HOME" ]; then
    if [ $VERBOSE = true ]; then
        echo "$MSG_NO_XDG_CONFIG"
    fi
else
    USERCONFIG=$XDG_DATA_HOME
fi


[ -z "$TARGET_LANGUAGE" ] && TARGET_LANGUAGE=c && 
    if [ $VERBOSE = true ]; then
        echo "$MSG_NO_TEMPLATE" 
    fi
[ -z "$TARGET_DIRECTORY" ] && TARGET_DIRECTORY=$(pwd) && 
    if [ $VERBOSE = true ]; then
        echo "$MSG_NO_DIR"
    fi


# check for templates, install if needed
if [ -d $USERCONFIG/$PROGRAM_NAME/$TARGET_LANGUAGE ]; then
    if [ $VERBOSE = true ]; then
        echo "$MSG_TEMPLATE_FOUND"
    fi
else 
    echo "Template $TARGET_LANGUAGE must be installed, installing to $USERCONFIG/$PROGRAM_NAME/$TARGET_LANGUAGE/"
    $(rm -rf $USERCONFIG/$PROGRAM_NAME)
    $(git clone https://github.com/chpf/sten $USERCONFIG/$PROGRAM_NAME)
    if [ -d $USERCONFIG/$PROGRAM_NAME/$TARGET_LANGUAGE ]; then
        if [ $VERBOSE = true ]; then
            echo "info: fetches new templates from git"
        fi
    else 
        echo "error: No template found"
        exit 1
    fi
fi

# directory must be empty
if [ -d $TARGET_DIRECTORY ]; then
    if [ "$(ls -A $TARGET_DIRECTORY )" ]; then
        echo "$MSG_NO_EMPTY_DIR"
        exit 1
    fi
fi

COPYPATH=$USERCONFIG/$PROGRAM_NAME/$TARGET_LANGUAGE/*

if [ $VERBOSE = true ]; then
    echo "Copy from: $COPYPATH"
    echo "to: $TARGET_DIRECTORY"
fi

cp -r $COPYPATH $TARGET_DIRECTORY

