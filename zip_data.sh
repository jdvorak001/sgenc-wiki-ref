#!/usr/bin/env bash

# This script packs the current local copy as a data.zip for the dataset
#
# It stores the files in a stable order.

ARCHIVE_FILE=data.zip

# remove the archive file silently
rm -f $ARCHIVE_FILE 2>/dev/null

# form the list of files and add those to the zip archive
find data -type f \( -name \*.csv -o -name \*.json \) | \
sort -r | \
zip -q9 -@ $ARCHIVE_FILE

# produce a summary
unzip -ll $ARCHIVE_FILE | \
sed -e '22a\
...\
Totals:' -e '22,/--------/d'
