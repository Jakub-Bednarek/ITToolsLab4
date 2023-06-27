#! /bin/bash

set -o errexit -o pipefail

LONGOPTS=help,date,logs:
OPTIONS=hdl:

create_log_files() {
    if [ -z "$1" ] || [ $1 -le 0 ]; then
        echo "Invalid argument for --logs [-logs n_of_files]"
        return
    fi

    for (( i=1; i<=$1; i++))
    do
        echo "${i} $(date) skrypt.sh" > logs$i.txt
    done
}

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 1
fi

eval set -- "$PARSED"

while true
do
    case "$1" in
        -h|--help)
            echo "Syntax: skrypt.sh [--help|--date|--logs]"
            echo "Available options:"
            echo "  -h, --help                  Print helps"
            echo "  -d, --date                  Print current date"
            echo "  -l, --logs number_of_files  Create number_of_files log files with index, date and script use"
            shift
            ;;
        -d|--date)
            date
            shift
            ;;
        -l|--logs)
            create_log_files $2
            shift 2
            ;;
        --)
            shift
            break
            ;;
    esac
done