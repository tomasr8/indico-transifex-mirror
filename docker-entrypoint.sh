#!/bin/bash

pull_translations() {
    echo "Pulling translations.."
    cd /opt/tx
    /opt/tx/tx --token=$TRANSIFEX_API_TOKEN --root-config=/opt/tx/.transifexrc pull --all -f
    rm -f translations.zip
    zip -r translations.zip translations/
}

pull_translations
nginx -g "daemon off;"

# while true
# do
#    sleep 10
#    pull_translations
# done

