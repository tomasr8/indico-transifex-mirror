#!/bin/bash

pull_translations() {
    echo "Pulling translations from Transifex..."
    cd /opt/tx
    ./tx --token=$TRANSIFEX_API_TOKEN --root-config=/opt/tx/.transifexrc pull --all -f
    rm -f translations.zip
    zip -r translations.zip translations/
}

pull_translations
echo "Starting nginx..."
nginx -g "daemon off;" &

while true; do
    now=$(date +'%H:%M:%S')
    echo "[$now] Sleeping for 15m..."
    sleep 15m
    pull_translations
done
