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

PKG_INFO=$(dpkg --info $PKG_FILE)

PKGFILEBIN=$(dpkg --info $PKG_FILE | grep 'Package:' | sed -e 's/^[ \t]*//')
HONE="============="
printf "%b\n" "\n<div id=\"header\">\n"
[ ! -z "$PKGFILEBIN" ] && printf "%b\n" "$PKGFILEBIN \n$HONE \n" | tee $PKG_FILE.md | markdown
PKGFILESRC=$(dpkg --info $PKG_FILE | grep 'Source:' | sed -e 's/^[ \t]*//')
HTWO="-------------"
[ ! -z "$PKGFILESRC" ] && printf "%b\n" "$PKGFILESRC \n$HTWO \n" | tee -a $PKG_FILE.md | markdown
printf "%b\n" "\n</div>\n"
printf "%b\n" "\n<div id=\"content\">\n"
PKGFILEVER=$(echo -n "###" && dpkg --info $PKG_FILE | grep 'Version:' | sed -e 's/^[ \t]*//')
PKGFILEMAN=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Maintainer:' | sed -e 's/^[ \t]*//' | tr -d "<>")
PKGFILESIZ=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Installed-Size:' | sed -e 's/^[ \t]*//')
PKGFILEDEP=$(dpkg --info $PKG_FILE | grep 'Depends:' | sed -e 's/^[ \t]*//' | sed -e 's/Depends:/###Depends:\n  */')
[ ! -z "$PKGFILEVER" ] && printf "%b\n" "$PKGFILEVER" | tee -a $PKG_FILE.md | markdown
[ ! -z "$PKGFILEMAN" ] && printf "%b\n" "$PKGFILEMAN" | tee -a $PKG_FILE.md | markdown
[ ! -z "$PKGFILESIZ" ] && printf "%b\n" "$PKGFILESIZ" | tee -a $PKG_FILE.md | markdown
[ ! -z "$PKGFILEDEP" ] && printf "%b\n" "$PKGFILEDEP" | tee -a $PKG_FILE.md | markdown
printf "%b\n" "\n</div>\n"
printf "%b\n" "\n<div id=\"sidebar\">\n"
PKGFILEREC=$(dpkg --info $PKG_FILE | grep 'Recommends:' | sed -e 's/^[ \t]*//' | sed -e 's/Recommends:/###Recommends:\n  */')
PKGFILEPRV=$(dpkg --info $PKG_FILE | grep 'Provides:' | sed -e 's/^[ \t]*//' | sed -e 's/Provides:/###Provides:\n  */')
PKGFILESEC=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Section:' | sed -e 's/^[ \t]*//')
PKGFILEPRI=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Priority:' | sed -e 's/^[ \t]*//')
DESCRIPTION_START=$(dpkg --info $PKG_FILE |  grep -n Description |  tr -d '[A-Za-z]' | tr -d '\-:. ' | cut -f1 -d"!" )
TOTAL_LINES=$(dpkg --info $PKG_FILE | nl | tail -1 |  tr -d '[A-Za-z]' | tr -d '\-:=. ' )
TOTAL_LINES=$(echo $TOTAL_LINES | cut -f1 -d" ")
TAIL_NUM=$(expr $TOTAL_LINES - $DESCRIPTION_START + 1)
PKGFILEDES=$(dpkg --info $PKG_FILE | tail -n $TAIL_NUM | sed -e 's/^[ \t]*//' | sed -e 's/Description:/###Description:\n/')
[ ! -z "$PKGFILEDES" ] && printf "%b\n" "$PKGFILEDES" | tee -a $PKG_FILE.md | markdown
PKG_URL=$(dpkg --info $PKG_FILE | grep 'Homepage:' | sed -e 's/Homepage:/ /' | sed -e 's/^[ \t]*//') #)
PKGFILEURL=$(dpkg --info $PKG_FILE | grep 'Homepage:' | sed -e 's/^[ \t]*//' | sed -e 's/Homepage:/Homepage:[/' | tr "\n" " " && echo "]($PKG_URL)")
[ ! -z "$PKGFILEURL" ] && printf "%b\n" "$PKGFILEURL" | tee -a $PKG_FILE.md | markdown
[ ! -z "$PKGFILEPRV" ] && printf "%b\n" "$PKGFILEPRV" | tee -a $PKG_FILE.md | markdown
[ ! -z "$PKGFILESEC" ] && printf "%b\n" "$PKGFILESEC" | tee -a $PKG_FILE.md | markdown
[ ! -z "$PKGFILEPRI" ] && printf "%b\n" "$PKGFILEPRI" | tee -a $PKG_FILE.md | markdown
printf "%b\n" "\n</div>\n"
