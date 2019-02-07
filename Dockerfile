FROM library/docker:stable

ENV HOME_DIR=/opt/crontab
RUN apk add --no-cache --virtual .run-deps bash jq \
    && mkdir -p ${HOME_DIR}/jobs ${HOME_DIR}/projects \
    && adduser -S docker -D \
    && touch /var/log/cron.log \
    && chmod 644 /var/log/cron.log \
    && apk -Uuv add groff less python py-pip \
    && pip install awscli \
    && apk --purge -v del py-pip \
    && rm /var/cache/apk/*

ADD root /etc/crontabs/root

HEALTHCHECK --interval=5s --timeout=3s \
    CMD ps aux | grep '[c]rond' || exit 1

CMD ["crond","-f"]
