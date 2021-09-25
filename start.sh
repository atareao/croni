#!/bin/sh

#sudo /bin/chown -R poduser:poduser /crontab

# Usage: crond -fbS -l N -d N -L LOGFILE -c DIR
# 
#     -f  Foreground
#     -b  Background (default)
#     -S  Log to syslog (default)
#     -l N    Set log level. Most verbose:0, default:8
#     -d N    Set log level, log to stderr
#     -L FILE Log to FILE
#     -c DIR  Cron dir. Default:/var/spool/cron/crontabs

# -l emerg or panic  LOG_EMERG   0   [* system is unusable *]
# -l alert           LOG_ALERT   1   [* action must be taken immediately *]
# -l crit            LOG_CRIT    2   [* critical conditions *]
# -l error or err    LOG_ERR     3   [* error conditions *]
# -l warn or warning LOG_WARNING 4   [* warning conditions *]
# -l notice          LOG_NOTICE  5   [* normal but significant condition *] the default
# -l info            LOG_INFO    6   [* informational *]
# -l debug           LOG_DEBUG   7   [* debug-level messages *] same as -d option 

DEBUG=${DEBUG:-debug}
crond -c /crontab -f -l ${DEBUG}
