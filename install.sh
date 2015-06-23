#!/bin/sh
#
# $Id: install.sh 13 2005-01-17 23:32:26Z decibel $
#
# Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
# All rights reserved.

USER=$1
DBNAME=$2

psql -U $USER -f rrs.sql $DBNAME
psql -U $USER -f util_functions.sql $DBNAME
psql -U $USER -f rrs_functions.sql $DBNAME
