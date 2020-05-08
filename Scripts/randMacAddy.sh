#!/bin/bash

MAC=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`

ifconfig en0 ether ${MAC}
