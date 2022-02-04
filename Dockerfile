FROM alpine:3.15

ENV TZ=Europe/Madrid

RUN apk add --update --no-cache tini curl dcron libcap tzdata && \
    rm -rf /var/cache/apk && \
    addgroup -g 1000 -S dockerus && \
    adduser -u 1000 -S dockerus -G dockerus&& \
    chown dockerus:dockerus /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    mkdir /crontab && \
    chown dockerus:dockerus /crontab

COPY start.sh /start.sh

USER dockerus
WORKDIR crontab

ENTRYPOINT ["tini", "--"]
CMD ["/bin/sh", "/start.sh"]

