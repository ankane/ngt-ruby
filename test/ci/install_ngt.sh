#!/usr/bin/env bash

set -e

CACHE_DIR=$HOME/ngt/$NGT_VERSION

if [ ! -d "$CACHE_DIR" ]; then
  wget https://github.com/yahoojapan/NGT/archive/v$NGT_VERSION.tar.gz
  tar xvfz v$NGT_VERSION.tar.gz
  mv NGT-$NGT_VERSION $CACHE_DIR

  cd $CACHE_DIR
  mkdir build
  cd build
  cmake ..
  make
else
  echo "NGT cached"
fi
