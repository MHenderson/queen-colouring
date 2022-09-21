#!/bin/bash

cd /opt
git clone https://github.com/docopt/docopts.git
cd docopts
./get_docopts.sh
cp docopts /usr/local/bin