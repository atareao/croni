FROM alpine:3.18

RUN apk add --update --no-cache \
            curl~=8.1 \
            dcron~=4.5 \
            libcap~=2.69 && \
    rm -rf /var/cache/apk && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    addgroup -g 1000 -S dockerus && \
    adduser -u 1000 -S dockerus -G dockerus && \
    chown dockerus:dockerus /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    mkdir /crontab && \
    chown -R dockerus:dockerus /crontab

COPY --chown=dockerus:dockerus start.sh /start.sh
USER dockerus
WORKDIR /crontab

CMD ["/bin/sh", "/start.sh"]
