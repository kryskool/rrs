#!/bin/sh
#
# Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
# All rights reserved.

USER=$1
DBNAME=$2

psql -e -U $USER -f rrd.sql $DBNAME
psql -e -U $USER -f util_functions.sql $DBNAME
psql -e -U $USER -f rrd_functions.sql $DBNAME
