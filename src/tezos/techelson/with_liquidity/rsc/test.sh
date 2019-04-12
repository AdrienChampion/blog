#! /bin/bash

set -e

test_file="$1"

this_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
techel_lib="$this_script_dir/tests/techel.liq"

# List of all the contracts.
contracts=""
for file in `find "$this_script_dir/contracts" -iname "*.liq"` ; do
    contracts="$contracts $file"
done

# File liquidity will compile to.
target="$test_file.techel"

echo "Compiling $test_file..."
echo
liquidity --no-annot --no-simplify --no-peephole $techel_lib $contracts -o $target $test_file
echo

# Running techelson on the target.
echo "Running test $target"
echo
techelson $target
