FROM alpine:3.16

ENV TZ=Europe/Madrid


RUN apk add --update --no-cache \
            curl~=7.83 \
            dcron~=4.5 \
            libcap~=2.64 \
            su-exec~=0.2 \
            tzdata~=2022 && \
    rm -rf /var/cache/apk && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    mkdir /crontab

COPY entrypoint.sh start.sh /

WORKDIR /crontab

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
CMD ["/bin/sh", "/start.sh"]
