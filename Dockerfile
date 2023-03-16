FROM nginxinc/nginx-unprivileged:stable-alpine

USER root

RUN set -ex && apk add --no-cache bash sed zip

RUN rm /etc/nginx/conf.d/default.conf

RUN mkdir -p /opt/tx/html
RUN mkdir -p /opt/tx/.tx
RUN cd /opt/tx && curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash

COPY .transifexrc /opt/tx/
COPY tx-config /opt/tx/.tx/config
COPY index.html.template indico.png /opt/tx/html/

COPY nginx.conf /etc/nginx/conf.d/

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# OpenShift runs containers using an arbitrarily assigned user ID for security reasons
# This user is always in the root group so it is needed to grant privileges to group 0.
RUN chgrp -R 0 /var/* /etc/nginx && chmod -R g+rwX /var/* /etc/nginx
RUN chgrp -R 0 /opt/* && chmod -R g+rwX /opt/*

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
