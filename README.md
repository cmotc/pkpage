# pkpage
Generates a Markdown-formatted description of a software package and a
corresponding html page. For use with my repo generator, apt-git so that it can
generate package description pages automatically and make the repositories
easier to browse. It's a very, very basic little script. I don't intend to
expand it or make it smarter, instead I'm going to use it by redirecting it's
output and processing that. It uses dpkg --info to read the contents of your
debian package, grep and sed, and doesn't need bash, so it should run fine on
any debian-based system.

## Usage
To use the program without installing it system-wide, just do

        ./pkpage.sh -f "deb-package.deb"

To install it system-wide into /usr/local/bin do

        ./install.sh install

This will install the script as pkpage, and a basic wrapper script for creating
html pages as pkpage-html. This will place it in your path, then you can run

        pkpage -f "deb-package.deb"

to generate markdown files, or

        pkpage-html -f "deb-package.deb"

to generate html files.

To remove it system-wide from /usr/local/bin do

        ./install.sh remove
