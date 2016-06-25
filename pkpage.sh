#!/bin/sh
while getopts ":f:" opt; do
  case $opt in
    a)
      echo "-f using file: $OPTARG"
      PKG_FILE=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
if [ ! -f PKG_FILE ]; then
    echo "Package file not found"
    exit 1
fi
PKG_INFO=$(dpkg --info PKG_FILE)