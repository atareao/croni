FROM alpine:3.13

ENV TZ=Europe/Madrid

RUN apk add --update --no-cache tini curl dcron libcap tzdata && \
    rm -rf /var/cache/apk && \
    addgroup -g 1000 -S dockeruser && \
    adduser -u 1000 -S dockeruser -G dockeruser&& \
    chown dockeruser:dockeruser /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    mkdir /crontab && \
    chown dockeruser:dockeruser /crontab

COPY start.sh /start.sh

USER dockeruser
WORKDIR crontab

ENTRYPOINT ["tini", "--"]
CMD ["/bin/sh", "/start.sh"]

