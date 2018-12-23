#!/usr/bin/env bash
set -euo pipefail

# usage ./pull_tools/run_tests.sh

./configure.sh -n
cd Src && make clean && make ser mode=warn && cd ../ && pwd
git clone --branch stable --single-branch --depth 1 https://github.com/testmolsim/molsim.git stable
cd stable && cp ../version.conf . && cp ../Src/make.* Src/ && cd Testin && make stable && cd ../../
cd Testin/ && ln -s ../stable/Testin/out_stable out_stable && cd ../
cd Testin && make diff && cd ../
cmp --silent pull_tools/diff_pull.txt Testin/diff.out
