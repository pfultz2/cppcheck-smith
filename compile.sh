#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

CSMITH_INCLUDE=$HOME/usr/include/csmith-2.3.0/

clang++-6.0 -std=c++14 -fsyntax-only -Wno-c++11-narrowing -Wno-unused-command-line-argument -isystem $CSMITH_INCLUDE $1
RES=$?
if [ $RES -ne "0" ]; then
    exit 0
fi

cppcheck --enable=all -I$CSMITH_INCLUDE $1
