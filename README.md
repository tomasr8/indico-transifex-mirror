# Transifex mirror for Indico

This repo provides a public mirror for the Indico translations on Transifex. Normally, to access the translations you need an account and/or an API token. Since this mirror is public, no authentication is necessary.

The mirror as available at [https://test-indico-transifex-mirror.app.cern.ch](https://test-indico-transifex-mirror.app.cern.ch). The translations are provided as a [single zip file](https://test-indico-transifex-mirror.app.cern.ch/translations.zip).

The usecase for this mirror is automating translation-related tasks. It is currently used with the [development Docker setup](https://github.com/indico/indico-containers) which uses this mirror so that you don't need to provide an API token when running the setup.

The mirror is a simple Nginx app running on Openshift. It pulls the latest translations from Transifex once every 15 minutes and caches them in order to avoid any [API rate limits](https://transifex.github.io/openapi/index.html#section/Rate-Limit).

If you use this mirror to manually download the translations, you should unzip the file and place the contents inside the `indico/translations` folder in your indico repository.

You can also use this script:

```sh
wget https://test-indico-transifex-mirror.app.cern.ch/translations.zip
unzip translations.zip
# Delete existing translations
rm -R ${INDICO_REPO_PATH}/indico/translations/*/
# Move the current translations
mv translations/* ${INDICO_REPO_PATH}/indico/translations/
rm -r translations
```
