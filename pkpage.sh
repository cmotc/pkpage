#! /bin/sh

while getopts ":f:" opt; do
  case $opt in
    f)
      echo "-f using file: $OPTARG" > /dev/null
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
if [ ! -f $PKG_FILE ]; then
    echo "Package file not found" >&2
    exit 1
fi

echo $PKG_FILE >&2

PKG_INFO=$(dpkg --info $PKG_FILE)

dpkg --info $PKG_FILE | grep 'Package:' | sed -e 's/^[ \t]*//'
echo =================
dpkg --info $PKG_FILE | grep 'Source:' | sed -e 's/^[ \t]*//'
echo -----------------
echo -n "###" && dpkg --info $PKG_FILE | grep 'Version:' | sed -e 's/^[ \t]*//'
echo -n "####" && dpkg --info $PKG_FILE | grep 'Maintainer:' | sed -e 's/^[ \t]*//'
echo -n "####" && dpkg --info $PKG_FILE | grep 'Installed-Size:' | sed -e 's/^[ \t]*//'
dpkg --info $PKG_FILE | grep 'Depends:' | sed -e 's/^[ \t]*//' | sed -e 's/Depends:/###Depends:\n  */'
dpkg --info $PKG_FILE | grep 'Recommends:' | sed -e 's/^[ \t]*//' | sed -e 's/Recommends:/###Recommends:\n  */'
dpkg --info $PKG_FILE | grep 'Provides:' | sed -e 's/^[ \t]*//' | sed -e 's/Provides:/###Provides:\n  */'
echo -n "####" && dpkg --info $PKG_FILE | grep 'Section:' | sed -e 's/^[ \t]*//'
echo -n "####" && dpkg --info $PKG_FILE | grep 'Priority:' | sed -e 's/^[ \t]*//'
#echo$(
PKG_URL=$(dpkg --info $PKG_FILE | grep 'Homepage:' | sed -e 's/Homepage:/ /' | sed -e 's/^[ \t]*//') #)
dpkg --info $PKG_FILE | grep 'Homepage:' | sed -e 's/^[ \t]*//' | sed -e 's/Homepage:/Homepage:[/' | tr "\n" " " && echo "]($PKG_URL)"
echo -----------------
