#! /bin/bash

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

for (( i=1; i<=$#; i++))
do
    if [ ${!i} == "--date" ]; then
        date
    elif [ ${!i} == "--logs" ]; then
        number_of_logs=$((i+1))
        create_log_files ${!number_of_logs}
    fi
done