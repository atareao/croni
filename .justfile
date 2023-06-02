user    := "atareao"
name    := `basename ${PWD}`
version := `git tag -l  | tail -n1`

build:
    echo {{version}}
    echo {{name}}
    podman build -t {{user}}/{{name}}:{{version}} \
                 -t {{user}}/{{name}}:latest \
                 .

create:
    #!/usr/bin/env bash
    set -euxo pipefail
    for ARCH in amd64 arm64 arm-v7 arm-v6; do
        echo "Building ${ARCH}"
        buildah build \
                --pull \
                --tag "docker.io/{{user}}/{{name}}:{{version}}-${ARCH}" \
                --tag "docker.io/{{user}}/{{name}}:latest-${ARCH}" \
                --arch ${ARCH} \
                .
    done
    for VERSION in {{version}} latest; do
        echo "Creating manifest for ${VERSION}"
        buildah manifest create "docker.io/{{user}}/{{name}}:${VERSION}" \
                "docker.io/{{user}}/{{name}}:${VERSION}-amd64" \
                "docker.io/{{user}}/{{name}}:${VERSION}-arm64" \
                "docker.io/{{user}}/{{name}}:${VERSION}-arm-v7" \
                "docker.io/{{user}}/{{name}}:${VERSION}-arm-v6"
        echo "Push manifest for ${VERSION}"
        buildah manifest push \
                --all \
                "docker.io/{{user}}/{{name}}:${VERSION}" \
                "docker://docker.io/{{user}}/{{name}}:${VERSION}"
        echo "Delete manifest for ${VERSION}"
        buildah manifest rm \
                "docker.io/{{user}}/{{name}}:${VERSION}"
    done

run:
    podman run --rm \
               --init \
               --name croni \
               --init \
               --volume /etc/timezone:/etc/timezone:ro \
               --volume /etc/localtime:/etc/localtime:ro \
               --env-file croni.env \
               -v ${PWD}/crontab:/crontab \
               {{user}}/{{name}}:{{version}}

sh:
    podman run --rm \
               -it \
               --name croni \
               --init \
               --env-file croni.env \
               -v ${PWD}/crontab:/crontab \
               {{user}}/{{name}}:{{version}} \
               sh

push:
    podman push {{user}}/{{name}}:{{version}}
    podman push {{user}}/{{name}}:latest
