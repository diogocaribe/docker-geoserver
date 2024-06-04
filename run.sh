#!/bin/sh

msg_usage='Usage: run.sh --<env>\n\nOptions: \n\t--local (development)\n\t--proxy (homo/production)\n'

if [ $# -ne 1 ]; then
    echo ${msg_usage}
    exit 1
else
    case "$1" in
        --local) compose_file='docker-compose.yml'
            ;;
        --proxy) compose_file='docker-compose-proxy.yml'
            ;;
        --*) echo "bad option: '$1'\n"
            ;;
        *) echo "bad option: '$1'\n"
            ;;
    esac

    if [ -z ${compose_file+x} ]; then
        echo ${msg_usage}
    else
        if [ ! -f ".env" ]; then
            echo "ERROR: File not found '.env'. Exiting..."
            exit 1
        fi

        . ./.env 
        export $(grep --regexp ^[A-Z] .env | cut -d= -f1)

        docker-compose --file ${compose_file} --compatibility up --detach --force-recreate --build
    fi
fi

exit 0
