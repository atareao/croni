user    := "atareao"
name    := `basename ${PWD}`
version := `git tag -l  | tail -n1`

build:
    echo {{version}}
    echo {{name}}
    docker build -t {{user}}/{{name}}:{{version}} \
                 -t {{user}}/{{name}}:latest \
                 .

    #--platform linux/arm/v7,linux/amd64,linux/arm64/v8 \
create:
     docker buildx build \
        --progress=plain \
        --platform=linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 \
        --tag {{user}}/{{name}}:latest \
        --tag  {{user}}/{{name}}:{{version}} \
        --push \
        .
run:
    docker run --rm \
               --init \
               --name croni \
               --init \
               --volume /etc/timezone:/etc/timezone:ro \
               --volume /etc/localtime:/etc/localtime:ro \
               --env-file croni.env \
               -v ${PWD}/crontab:/crontab \
               {{user}}/{{name}}:{{version}}

sh:
    docker run --rm \
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
