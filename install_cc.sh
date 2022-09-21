#!/bin/bash

cd /opt
mkdir color
cd color
wget --no-check-certificate http://www.cs.ualberta.ca/%7Ejoe/Coloring/Colorsrc/color.tar.gz
tar xzvf color.tar.gz
mkdir bin
make all
