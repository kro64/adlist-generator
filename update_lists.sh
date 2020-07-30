#!/bin/bash

DIR=/opt/adblock_updater
AD_LIST=$(curl -s https://v.firebog.net/hosts/lists.php?type=tick)
OUT=$DIR/ad_blacklist
TEMP=$DIR/temp
UNBOUND_CONF=$DIR/ad_blacklist.conf

#--- Functions ---#

convert_to_unbound() {
while read LINE; do
	echo local-zone: \"$LINE\" redirect >> $UNBOUND_CONF; echo local-data: \"$LINE A 127.0.0.1\" >> $UNBOUND_CONF;
done < $OUT
}


# Make sure working directory exists
mkdir -p $DIR

# Clean the old blacklist
echo > $OUT

# Get latest ad domains (careful for rate limiting)
for i in ${AD_LIST}; 
	do curl -s $i >> $OUT
done

# Process the blacklist
# Removing #
sed -i '/^#/d' $OUT
# Removing IPs
sed -i -r 's/([0-9]{1,3}\.){3}[0-9]{1,3}//g' $OUT
# Removing spaces etc.
awk '{print $1}' $OUT > $TEMP; mv $TEMP $OUT
# Removing empty lines
awk 'NF' $OUT > $TEMP; mv $TEMP $OUT
# Remove carriage return ^M
sed -i 's/\r$//' $OUT


echo > $UNBOUND_CONF
convert_to_unbound
