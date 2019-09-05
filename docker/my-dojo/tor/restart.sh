#!/bin/bash
set -e

# Set permissions for bitcoind
echo "## Set permissions on /var/lib/tor dir ###"
chmod 750 /var/lib/tor

echo "## Start tor #############################"

tor_options=(
  --SocksPort 172.28.1.4:9050
  --SocksPolicy "accept 172.28.0.0/16"
  --SocksPolicy "reject *"
  --DataDirectory /var/lib/tor/.tor
  --DataDirectoryGroupReadable 1
  --HiddenServiceDir /var/lib/tor/hsv2dojo
  --HiddenServiceVersion 2
  --HiddenServicePort "80 172.29.1.3:80"
  --HiddenServiceDir /var/lib/tor/hsv3dojo
  --HiddenServiceVersion 3
  --HiddenServicePort "80 172.29.1.3:80"
  --HiddenServiceDir /var/lib/tor/hsv2bitcoind
  --HiddenServiceVersion 2
  --HiddenServicePort "8333 172.28.1.5:8333"
  --HiddenServiceDirGroupReadable 1
)

if [ "$TOR_USE_BRIDGES" == "on" ]; then
  tor_options+=(--ClientTransportPlugin "obfs4 exec /usr/local/bin/obfs4proxy")
  tor_options+=(--UseBridges 1)
  tor_options+=(--Bridge "obfs4 $TOR_BRIDGE_1_IP_PORT $TOR_BRIDGE_1_ID cert=$TOR_BRIDGE_1_CERT iat-mode=$TOR_BRIDGE_1_IAT_MODE")
  tor_options+=(--Bridge "obfs4 $TOR_BRIDGE_2_IP_PORT $TOR_BRIDGE_2_ID cert=$TOR_BRIDGE_2_CERT iat-mode=$TOR_BRIDGE_2_IAT_MODE")
  tor_options+=(--Bridge "obfs4 $TOR_BRIDGE_3_IP_PORT $TOR_BRIDGE_3_ID cert=$TOR_BRIDGE_3_CERT iat-mode=$TOR_BRIDGE_3_IAT_MODE")
fi

tor "${tor_options[@]}"
