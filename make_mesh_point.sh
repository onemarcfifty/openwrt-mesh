#!/bin/ash

# Turn an OpenWrt dumb access point into a Wi-fi mesh point

# use at your own risk !!!!
# backup your router first !!!!
# script expects factory settings+1st script to be executed!!!!
# the script might not run on all hardware !!!

# ######################
# you may customize this
# ######################

MESH_NAME="my_mesh"
MESH_PWD="T0psecret"
MESH_RADIO=radio0
MESH_CHANNEL=1

WIFI_NAME="my_wifi"
WIFI_PWD="SuperSecret"
WIFI_RADIO=radio1
WIFI_CHANNEL=36
WIFI_MOBDOMAIN='1234'

# install the wpad mesh package

opkg update
opkg install --force-overwrite wpad-mesh-openssl

# delete the "OpenWrt" radios

uci delete wireless.default_radio0
uci delete wireless.default_radio1

# create the mesh Wifi

uci set wireless.wifinet0=wifi-iface
uci set wireless.wifinet0.device=$MESH_RADIO
uci set wireless.wifinet0.mode='mesh'
uci set wireless.wifinet0.encryption='sae'
uci set wireless.wifinet0.mesh_id=$MESH_NAME
uci set wireless.wifinet0.mesh_fwding='1'
uci set wireless.wifinet0.mesh_rssi_threshold='0'
uci set wireless.wifinet0.key=$MESH_PWD
uci set wireless.wifinet0.network='lan'
uci set "wireless.$MESH_RADIO.channel"=$MESH_CHANNEL
uci delete "wireless.$MESH_RADIO.disabled"   

# create the AP Wifi

uci set wireless.wifinet1=wifi-iface
uci set wireless.wifinet1.device=$WIFI_RADIO
uci set wireless.wifinet1.mode='ap'
uci set wireless.wifinet1.ssid=$WIFI_NAME
uci set wireless.wifinet1.encryption='psk2'
uci set wireless.wifinet1.key=$WIFI_PWD
uci set wireless.wifinet1.ieee80211r='1'
uci set wireless.wifinet1.mobility_domain=$WIFI_MOBDOMAIN
uci set wireless.wifinet1.ft_over_ds='0'
uci set wireless.wifinet1.ft_psk_generate_local='1'
uci set wireless.wifinet1.network='lan'
uci set "wireless.$WIFI_RADIO.channel"=$WIFI_CHANNEL
uci delete "wireless.$WIFI_RADIO.disabled"   

uci commit

wifi down
/etc/init.d/wpad restart
wifi up
