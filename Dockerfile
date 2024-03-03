FROM alpine:3.19

ENV USER=dockerus \
    UID=10001 \
    HOME=cronitab

RUN apk add --update --no-cache \
            tzdata~=2024 \
            curl~=8.5 \
            dcron~=4.5 \
            libcap~=2.69 && \
    rm -rf /var/lib/app/lists* && \
    rm -rf /var/cache/apk && \
    adduser \
        --disabled-password \
        --gecos "" \
        --home "/${HOME}" \
        --shell "/sbin/nologin" \
        --uid "${UID}" \
        "${USER}" && \
    chown "${USER}:${USER}" /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond && \
    touch "/${HOME}/${USER}" && \
    chown -R "${USER}:${USER}" "/${HOME}"

COPY --chown="${USER}:${USER}" run.sh /run.sh

WORKDIR "$HOME"
USER "${USER}"

CMD ["/bin/sh", "/run.sh"]
