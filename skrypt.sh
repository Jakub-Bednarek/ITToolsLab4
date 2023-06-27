#! /bin/bash

set -o errexit -o pipefail

LONGOPTS=help,date,init,logs:,error:
OPTIONS=hdil:e:
DEFAULT_NUMBER_OF_ERROR_FILES=100

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

create_error_files() {
    if [ $1 -le 0 ]
    then
        echo "Invalid value provided for --error option, must be >= 1"
        return
    fi

    for (( i=1; i<=$1; i++ ))
    do
        if [ ! -d "./error${i}" ]; then
            mkdir ./error${i}
        fi
        echo "error${i}.txt skrypt.sh $(date)" > error${i}/error$i.txt
    done
}

# Nie mogłem znaleźć czy mechanizm 'enhanced getopt' wspiera domyślne wartości dla flag, dlatego parsuje wszystkie argumenty, w przypadku znalezienie flagi -e|-error sprawdzam czy wartość została podana
# Jeśli nie ma podanej żadnej wartości to dorzucam domyślne 100 i podmieniam argumenty skryptu na poprawione tak aby getopt mógł je poprawnie zparsować
number_regex='^[0-9]+$'
corrected_arguments_array=()
for (( i=1; i<=$#; i++ ))
do
    corrected_arguments_array+=(${!i})
    if [ ${!i} == "-e" ] || [ ${!i} == "--error" ]
    then
        next_argument=$((i + 1))
        if [[ ${!next_argument} =~ $number_regex ]]
        then
            corrected_arguments_array+=(${!next_argument})
        else
            corrected_arguments_array+=($DEFAULT_NUMBER_OF_ERROR_FILES)
        fi
    fi
done

set -- "${corrected_arguments_array[@]}"

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS -q --name "$0" -- "$@")
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
            echo "--help                 Print helps"
            echo "--date                 Print current date"
            echo "--logs number_of_files Create number_of_files log files with index, date and script use"
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
        -e|--error)
            create_error_files $2
            shift 2
            ;;
        --)
            shift
            break
            ;;
    esac
done