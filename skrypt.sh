#! /bin/bash

set -o errexit -o pipefail

LONGOPTS=help,date,init,logs:
OPTIONS=hdil:

create_log_files() {
    if [ $1 -le 0 ]
    then
        echo "Invalid value provided for --logs option, must be >= 1"
        return
    fi

    for (( i=1; i<=$1; i++))
    do
        if [ ! -d "./logs${i}" ]; then
            mkdir ./logs${i}
        fi
        echo "logs${i}.txt skrypt.sh $(date)" > logs${i}/logs$i.txt
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
        -i|--init)
            # Nie można zrobić git clone do tej samej ścieżki ponieważ znajdują się w niej już pliki dlatego nie używam dodatkowej "." po komendzie wskazującej na aktualną ścieżkę
            git clone git@github.com:Jakub-Bednarek/ITToolsLab4.git
            echo "PATH=$PATH:$(pwd)/skrypt.sh" >> ~/.bashrc
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