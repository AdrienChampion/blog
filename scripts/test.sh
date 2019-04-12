#! /bin/bash

# This test script must run at the root of the repository.

timeout="2"
tests_path="src"

if [ "$1" = "--fix" ] ; then
    fix_errors="true"
else
    fix_errors="false"
fi

# Fixes an output file.
#
# Arguments
# - the path in which to run the command
# - the command (first line of the output file)
# - the actual output file
#
# The output file will be **overwritten**: its first line is going to be the command prefixed with
# "$ ", followed by the output of the command.
function fix_it {
    fix_path="$1"
    fix_command="$2"
    fix_target="$3"
    echo "\$ $fix_command" > $fix_target
    (cd "$fix_path" ; (eval "$fix_command" 2>&1)) >> $fix_target
}

# Asks the user on whether or not to fix an output file.
#
# Arguments
# - the path in which to run the command
# - the command (first line of the output file)
# - the actual output file
function ask_and_fix {
    ask_and_fix_path="$1"
    ask_and_fix_command="$2"
    ask_and_fix_target="$3"
    while true; do
        echo "  |"
        echo "  | Automatically fix output file \"$ask_and_fix_target\""
        echo "  | with the output of \"$ask_and_fix_command\""
        printf "  | ? y/N "

        read ask_and_fix_answer

        case "$ask_and_fix_answer" in
            y|yes|Y|Yes|YES)
                printf "  | fixing output file..."
                fix_it "$ask_and_fix_path" "$ask_and_fix_command" "$ask_and_fix_target"
                echo " done"
                break
            ;;
            ""|n|no|N|No|NO)
                echo "  | leaving output file as is"
                break
            ;;
            *)
                echo "  | no idea what \"$ask_and_fix_answer\" means"
                echo "  | try again..."
        esac
    done
}

echo "|===| Checking all output files"

for file in `find "$tests_path" -iname "*.output"` ; do
    echo "| $file"
    file_path=`echo "$file" | sed -e 's:\(.*\)/.*:\1:'`
    first_line=`head -n 1 "$file"`
    if [[ "$first_line" != \$* ]] ; then
        echo "|   file must start with a '\$ <command>' line"
        echo "|   found \"$first_line\""
        echo "|===|"
        exit 2
    fi
    command=`head -n 1 "$file" | sed -e "s:^\$ ::"`
    run_output=`(cd "$file_path" ; timeout $timeout sh -c "$command") 2>&1`
    diff <(tail -n +2 "$file") <(echo "$run_output") > /dev/null
    exit_code="$?"
    if [ "$exit_code" != "0" ] ; then
        echo "|   output of command \"$command\""
        echo "|   is different from \"$file\""
        echo "|=| diff:"
        IFS=$'\n'
        while read -r line ; do
            echo "  |     $line"
        done <<< "`diff <(tail -n +2 "$file") <(echo "$run_output")`"

        if [ "$fix_errors" = "true" ] ; then
            ask_and_fix "$file_path" "$command" "$file"
            echo "|=|"
        else
            echo "|=|"
            exit 2
        fi
    else
        echo "| - output confirmed"
    fi
done

echo "|===|"
