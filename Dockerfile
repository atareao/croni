FROM alpine:3.16

ENV TZ=Europe/Madrid

RUN apk add --update --no-cache \
            curl~=7.83 \
            dcron~=4.5 \
            libcap~=2.64 \
            tzdata~=2022c && \
    rm -rf /var/cache/apk && \
    addgroup -g 1000 -S dockerus && \
    adduser -u 1000 -S dockerus -G dockerus&& \
    chown dockerus:dockerus /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    mkdir /crontab && \
    chown dockerus:dockerus /crontab

COPY start.sh /start.sh

USER dockerus
WORKDIR /crontab

CMD ["/bin/sh", "/start.sh"]

