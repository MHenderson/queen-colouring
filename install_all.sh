#!/bin/bash

cd /opt
mkdir color
cd color
wget --no-check-certificate http://www.cs.ualberta.ca/%7Ejoe/Coloring/Colorsrc/color.tar.gz
tar xzvf color.tar.gz
mkdir bin
make all

cd /opt
git clone https://github.com/docopt/docopts.git
cd docopts
./get_docopts.sh
cp docopts /usr/local/bin

apt-get install expect
cp -r /home/matthew/workspace/ccli /opt
