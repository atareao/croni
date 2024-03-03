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
               --volume ${PWD}/crontab.txt:/crontab.txt:ro \
               --env TZ=Europe/Madrid \
               --env LOGLEVEL=debug \
               -v ${PWD}/crontab:/crontab \
               {{user}}/{{name}}:{{version}}

sh:
    docker run --rm \
               -it \
               --init \
               --name croni \
               --volume ${PWD}/crontab.txt:/crontab.txt:ro \
               --env TZ=Europe/Madrid \
               --env LOGLEVEL=debug \
               -v ${PWD}/crontab:/crontab \
               {{user}}/{{name}}:{{version}} \
               sh

push:
    docker push {{user}}/{{name}}:{{version}}
    docker push {{user}}/{{name}}:latest
