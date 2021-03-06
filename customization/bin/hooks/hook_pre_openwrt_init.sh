#!/bin/sh

# ---- TEMPLATE ----

# Hook for modifcation stuff before 
#          piratebox/bin/install  ... openwrt 
# is started


if [ !  -f $1 ] ; then 
  echo "Config-File $1 not found..." 
  exit 255
fi

#Load config
. $1 

#Load openwrt-common config and procedures file!
. /etc/piratebox.config


# You can uncommend this line to see when hook is starting:
echo "------------------ Running $0 ------------------"

pbx_cfg="/etc/piratebox.config"

echo "Backup $pbx_cfg"


# Load configuration
. /etc/ext.config
. $ext_linktarget/etc/piratebox.config

# Load function libraries
. $ext_linktarget/usr/share/piratebox/piratebox.common


uci set "system.@system[0].hostname=the.wrong"

# AP Client Isolation
uci set wireless.@wifi-iface[0].isolate='1'

# Redirect all incoming port 80 requests
fw_redirect_entry=$(uci show firewall | grep 'http_pbx'  | cut -d '.' -f 2)
uci set firewall."$fw_redirect_entry".enabled='1'

pb_setSSID "The.Wrong"
uci commit


if ! grep -q 'contentuser' /etc/passwd ; then 
	uid=500
	gid=$( grep nogroup /etc/group  | cut -d ':' -f 3 )
	if grep -q -e "$uid" /etc/passwd; then
		uid=601
	fi
	echo "contentuser:x:${uid}:${gid}:Content Admin:/opt/piratebox/share:/bin/ash" \
		>> /etc/passwd
fi
