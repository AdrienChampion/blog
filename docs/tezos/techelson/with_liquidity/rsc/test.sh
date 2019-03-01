#! /bin/bash

set -e

test_file="$1"

# List of all the contracts.
contracts=""
for file in `find contracts -iname "*.liq"` ; do
    contracts="$contracts $file"
done

# File liquidity will compile to.
target="$test_file.techel"

echo "Compiling $test_file..."
echo
liquidity --no-annot --no-simplify --no-peephole tests/techel.liq$contracts -o $target $test_file
echo

# Running techelson on the target.
echo "Running test $target"
echo
techelson $target
