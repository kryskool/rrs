#!/bin/sh
#
# $Id: update.sh 27 2005-01-22 19:11:38Z decibel $
#
# Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
# All rights reserved.

USER=$1
DBNAME=$2

psql -U $USER -f update/0.2-0.3/rrs.sql $DBNAME
psql -U $USER -f util_functions.sql $DBNAME
psql -U $USER -f rrs_functions.sql $DBNAME
