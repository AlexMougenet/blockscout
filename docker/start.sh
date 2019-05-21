#!/bin/bash
#To execute the script you need to specify an IP address that blockscout will use to connect to the node

IP_ADDR=$1

ETHEREUM_JSONRPC_VARIANT=geth ETHEREUM_JSONRPC_HTTP_URL=http://$IP_ADDR:8545/ ETHEREUM_JSONRPC_WS_URL=ws://$IP_ADDR:8546/ make start
