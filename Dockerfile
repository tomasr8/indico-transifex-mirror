FROM nginxinc/nginx-unprivileged:stable-alpine

USER root

RUN set -ex && apk add --no-cache bash zip

RUN rm /etc/nginx/conf.d/default.conf

RUN mkdir -p /opt/tx
RUN cd /opt/tx && curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash

EXPOSE 8080

# OpenShift runs containers using an arbitrarily assigned user ID for security reasons
# This user is always in the root group so it is needed to grant privileges to group 0.
RUN chgrp -R 0 /var/* /etc/nginx && chmod -R g+rwX /var/* /etc/nginx

COPY .transifexrc /opt/tx
COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
