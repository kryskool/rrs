-- Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
-- All rights reserved.

CREATE OR REPLACE FUNCTION rrd.min(timestamp with time zone, timestamp with time zone) RETURNS timestamp with time zone
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;
GRANT EXECUTE ON FUNCTION rrd.min(timestamptz, timestamptz) TO PUBLIC;
