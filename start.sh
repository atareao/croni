#!/bin/sh

sudo /bin/chown -R poduser:poduser /crontab
crond -c /crontab -f -d 1

