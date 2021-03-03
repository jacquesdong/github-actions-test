#!/bin/sh

is_shell_source() {
    if [ -z "$__var_shell_source" ]; then
        case "${0##*/}" in
            sh|ash|dash|bash)
                __var_shell_source=0
                ;;
            *)
                __var_shell_source=1
                ;;
        esac
    fi
    return "$__var_shell_source"
}

if is_shell_source; then
    return
fi

set -e

is_command_exist() {
    command -v "$@" >/dev/null 2>&1
}

is_cmake_configured() {
    [ -f $BUILD/CMakeCache.txt ]
}

SOURCE="$(cd $(dirname "$0") && pwd)"
BUILD="$SOURCE/build"

print_help_usage() {
    cat >&2 << USAGE
Usage: $0 [-v] -S $SOURCE -B $BUILD
    -S SOURCE       source directory, default $SOURCE
    -B BUILD        build directory, default $BUILD
    -t TOOLCHAIN    toolchain file
    -v              verbose, show more messages
    -e              export compile commands

Example:
  mkdir build
  cd build

 Linux:
  cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

 Windows:
  cmake -G "Visual Studio 16 2019" -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

 macOS:
  cmake -G Xcode -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

USAGE
}

while getopts S:B:t:vexbh o; do
    case $o in
    S)  _flag_source="$OPTARG"
         ;;
    B)  _flag_build="$OPTARG"
         ;;
    t)  _flag_toolchain="$OPTARG"
        ;;

    v)  _flag_verbose=y
        ;;
    v)  _flag_export=y
        ;;
    b)  _flag_make=y
        ;;
    x)  set -x
        ;;
    h)  print_help_usage
        exit 0
        ;;
    \?) print_help_usage
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

if [ -n "$_flag_verbose" ]; then
    export VERBOSE=1
fi

if [ -n "$_flag_source" ]; then
    SOURCE="$_flag_source"

    if [ -z "$_flag_build" ]; then
        BUILD="$SOURCE/build"
    fi
fi

if [ -n "$_flag_build" ]; then
    BUILD="$_flag_build"
fi

mkdir -p "$BUILD"

if is_command_exist ninja; then
    ARGS="-G Ninja"
fi

if [ -n "$_flag_debug" ]; then
    ARGS="$ARGS -DCMAKE_BUILD_TYPE=Debug"
else
    ARGS="$ARGS -DCMAKE_BUILD_TYPE=RelWithDebInfo"
fi

if [ -n "$_flag_verbose" ]; then
    ARGS="$ARGS -DCMAKE_VERBOSE_MAKEFILE=ON"
fi

if [ -n "$_flag_export" ]; then
    ARGS="$ARGS -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
fi

if [ -n "$_flag_toolchain" ]; then
    ARGS="$ARGS -DCMAKE_TOOLCHAIN_FILE=$_flag_toolchain"
fi

cmake -S "$SOURCE" -B "$BUILD" $ARGS "$@"

if [ -n "$_flag_make" ]; then
    cmake --build "$BUILD"
fi
