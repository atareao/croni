#!/bin/sh

sudo /bin/chown -R poduser:poduser /crontab

# Usage: crond -fbS -l N -d N -L LOGFILE -c DIR
# 
#     -f  Foreground
#     -b  Background (default)
#     -S  Log to syslog (default)
#     -l N    Set log level. Most verbose:0, default:8
#     -d N    Set log level, log to stderr
#     -L FILE Log to FILE
#     -c DIR  Cron dir. Default:/var/spool/cron/crontabs

DEBUG=${8:-$DEBUG}
crond -c /crontab -f -d ${DEBUG}

