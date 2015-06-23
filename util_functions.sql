-- Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
-- All rights reserved.
--
-- $Id: util_functions.sql 6 2004-12-03 05:41:35Z decibel $

CREATE OR REPLACE FUNCTION rrs.min(timestamp with time zone, timestamp with time zone) RETURNS timestamp with time zone
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;
GRANT EXECUTE ON FUNCTION rrs.min(timestamptz, timestamptz) TO PUBLIC;

-- vi: expandtab sw=4 ts=4
