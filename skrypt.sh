#! /bin/bash

create_log_files() {
    for i in {1..100}
    do
        echo "${i} $(date) skrypt.sh" > logs$i.txt
    done
}

for var in "$@"
do
    if [ $var == "--date" ]; then
        date
    elif [ $var == "--logs" ]; then
        create_log_files
    fi
done