FROM alpine:3.13

ENV TZ=Europe/Madrid

RUN apk add --update --no-cache tini curl dcron libcap tzdata sudo && \
    rm -rf /var/cache/apk && \
    addgroup -g 1000 -S poduser && \
    adduser -u 1000 -S poduser -G poduser&& \
    chown poduser:poduser /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    mkdir /crontab && \
    chown poduser:poduser /crontab && \
    echo "poduser ALL=(ALL) NOPASSWD: /bin/chown" > /etc/sudoers.d/poduser

COPY start.sh /start.sh


USER poduser
WORKDIR crontab

ENTRYPOINT ["tini", "--"]
CMD ["/bin/sh", "/start.sh"]

