#! /bin/bash

set -e

for file in `find . -iname "*.liq"` ; do
    target="$file.techel"
    echo "Compiling $file..."
    echo
    liquidity --no-simplify --no-peephole -o $target techel.liq ../contracts/* $file
    echo
    echo "Running test $target"
    techelson $target
done
