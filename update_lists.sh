#!/bin/bash

DIR=/opt/adblock_updater
AD_LIST=$(curl -s https://v.firebog.net/hosts/lists.php?type=tick)
CONF=$DIR/ad_blacklist.conf
TEMP=$DIR/temp

# Make sure working directory exists
mkdir -p $DIR

# Clean the old blacklist
echo > $CONF

# Update
for i in ${AD_LIST}; 
	do curl -s $i >> $CONF
done

# Process the blacklist
# Removing #
sed -i '/^#/d' $CONF
# Removing IPs
sed -i -r 's/([0-9]{1,3}\.){3}[0-9]{1,3}//g' $CONF
# Removing spaces etc.
awk '{print $1}' $CONF > $TEMP; mv $TEMP $CONF
# Removing empty lines
awk 'NF' $CONF > $TEMP; mv $TEMP $CONF
# Remove carriage return ^M
sed -i 's/\r$//' $CONF
