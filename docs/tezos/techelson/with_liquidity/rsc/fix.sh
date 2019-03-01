#! /bin/bash

for file in `find output -type f -iname "*"` ; do
    echo "$file"
    tmp_file="$file.tmp"
    command=`head -n 1 "$file" | sed -e 's:^\$ ::'`
    echo "  $command"
    echo "\$ $command" > $tmp_file
    $command >> $tmp_file
    exit_code="$?"
    if [ "$exit_code" != "0" ] ; then
        echo "error on file $file ($exit_code)"
        echo "do you confirm?"
        read line
        if [ "$line" != "yes" ] ; then
            echo "cancelling"
            rm "$tmp_file"
            exit 2
        fi
    fi
    mv "$tmp_file" "$file"
done
