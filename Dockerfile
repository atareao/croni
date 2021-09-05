FROM alpine:3.13

ENV TZ=Europe/Madrid

RUN apk add --update --no-cache tini curl dcron libcap tzdata && \
    rm -rf /var/cache/apk && \
    addgroup -g 10001 poduser && \
    adduser -u 10001 -G poduser -h /home/poduser -D poduser && \
    chown poduser:poduser /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond

COPY poduser  /crontab/poduser
RUN chown -R poduser:poduser /crontab

USER poduser
WORKDIR crontab

ENTRYPOINT ["tini", "--"]
CMD ["crond", "-c", "/crontab", "-f", "-d", "2"]

