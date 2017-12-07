#!/bin/bash

fireMessage(){
    echo $1
    echo "Press any key to go back"
    read confirm
}

createDbsDir(){
    if mkdir -p $PWD/databases
    then
        echo "Dir 'databases' Created .. "
    else
        firMessage "Databases Dir creation error"
    fi
}

clear

echo "Username ?"
read USERNAME

echo "Password ?"
read PASSWORD

databases=`mysql -u $USERNAME -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
dbs=( $databases )

createDbsDir

while true
do
    clear
        echo "1. Export ALL (${#dbs[@]} Database)"
        echo "0. Exit"

    read -r line

    case $line in
        1)
             for db in $databases; do
                if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
                    echo "Dumping database: $db"
                    mysqldump -u $USERNAME -p$PASSWORD --databases $db > $PWD/databases/`date +%Y%m%d`.$db.sql
                fi
             done

             fireMessage "Done"
        ;;
        0)
            clear
            echo "Good Bye ..."
            exit 1
        ;;
    esac

done