#!/bin/bash

mkdir .tmp
cd .tmp
curl -L https://github.com/atcoder/ac-library/releases/download/v1.4/ac-library.zip > ac-library.zip
unzip ac-library.zip
mv atcoder ..
cd ..
rm -r .tmp
