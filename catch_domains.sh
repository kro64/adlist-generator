#!/bin/bash

SCRIPT_PATH=/opt/adblock_updater/dnsdumpster/dnsdumpster/
OUT=/tmp/temp-domains.txt
RESULT_CONF=/tmp/dnsdump-youtube-ads.conf

$(which python) $SCRIPT_PATH/execute_catch.py 2> /dev/null | grep "^r" | awk '{print $1}' | sed 's/<br//g' > /tmp/temp-domains.txt


# Generate config for unbound

for i in $(cat $OUT); do echo local-zone: \"$i\" redirect; echo local-data: \"$i A 127.0.0.1\"; done > $RESULT_CONF
