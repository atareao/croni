# croni

This is a simple container with a cron.

## Use

Create a file name `crontab.txt` as the sample in the repo, and bind the volume so is accesible for the container, as you can see in the `docker-compose.yml` file.

For example, the `crontab.txt`

```bash
* * * * * echo $(date) >> /proc/1/fd/1
* * * * * curl google.es >> /proc/1/fd/1
```

And the `docker-compose.yml`

```bash
version: '3.7'

services:
  croni:
    image: atareao/croni:v1.3
    restart: always
    init: true
    container_name: croni
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - ./crontab.txt:/crontab.txt:ro
    environment:
      - LOGLEVEL=debug
```

Look the line,

```bash
- ./crontab.txt:/crontab.txt:ro
```




