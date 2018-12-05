#!/bin/bash

TMP_DIR=`mktemp -d`

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

COMPILE=$DIR/compile.sh

csmith \
    --no-checksum \
    --lang-cpp \
    --cpp11 \
    -o $TMP_DIR/test.cpp

$COMPILE $TMP_DIR/test.cpp |& tee $TMP_DIR/output
RES=$?
if [ $RES -ne "0" ]; then
    STAMP=`date "+%Y-%m-%dT%H_%M_%S"`
    mv $TMP_DIR/test.cpp "fail.cppcheck.$STAMP.cpp"
fi

grep -q "syntax error" $TMP_DIR/output
RES=$?
if [ $RES -eq "0" ]; then
    STAMP=`date "+%Y-%m-%dT%H_%M_%S"`
    mv $TMP_DIR/test.cpp "fail.cppcheck.$STAMP.cpp"
fi

rm -rf $TMP_DIR

exit $RES
