#!/usr/bin/env bash

# This script updates the local raw data repository
# to make it up-to-date copy with the Cesnet VM where the data is collected.

rsync -auv 78.128.250.224:data/sgenc-data/ data/
 