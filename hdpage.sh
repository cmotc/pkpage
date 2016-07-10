#! /bin/sh
DOCTYPE_HEADER='<!DOCTYPE html>'
HTML='<html>'
if [ -z $TITLE ]; then
        TITLE='web page'
fi
if [ ! -z $LANG ]; then
        HTML="<html lang=$LANG>"
fi
HEADER="<head>\n
\t<meta charset=\"utf-8\">\n
\t<title>$TITLE</title>\n
\t<link rel=\"stylesheet\" href=\"style.css\">\n
\t<script src=\"script.js\"></script>\n
</head>\n
"
echo $DOCTYPE_HEADER
echo $HTML
echo $HEADER
