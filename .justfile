user    := "atareao"
name    := `basename ${PWD}`
version := `git tag -l  | tail -n1`

build:
    echo {{version}}
    echo {{name}}
    podman build -t {{user}}/{{name}}:{{version}} \
                 -t {{user}}/{{name}}:latest \
                 .

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
