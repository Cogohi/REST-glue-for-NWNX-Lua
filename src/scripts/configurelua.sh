#!/bin/bash
apt-get update
apt-get install -y luarocks
luarocks install luasocket
luarocks install luasec
