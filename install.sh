#!/bin/sh
#
# $Id: install.sh 6 2004-12-03 05:41:35Z decibel $
#
# Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
# All rights reserved.

USER=$1
DBNAME=$2

psql -e -U $USER -f rrs.sql $DBNAME
psql -e -U $USER -f util_functions.sql $DBNAME
psql -e -U $USER -f rrs_functions.sql $DBNAME
