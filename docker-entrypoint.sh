#!/bin/bash

pull_translations() {
    echo "Pulling translations from Transifex..."
    cd /opt/tx
    ./tx --token=$TRANSIFEX_API_TOKEN --root-config=/opt/tx/.transifexrc pull --all -f
    rm -f translations.zip
    zip -r translations.zip translations/
}

set_last_updated() {
    last_update=$(date +"%Y-%m-%dT%H:%M:%S%z")
    sed "s/\${LAST_UPDATE}/$last_update/g" /opt/tx/html/index.html.template > /opt/tx/html/index.html
}

pull_translations
set_last_updated
echo "Starting nginx..."
nginx -g "daemon off;" &

while true; do
    now=$(date +'%H:%M:%S')
    echo "[$now] Sleeping for 15m..."
    sleep 15m
    pull_translations
    set_last_updated
done
