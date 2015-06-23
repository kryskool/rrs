-- Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
-- All rights reserved.
--
-- $Id: util_functions.sql 13 2005-01-17 23:32:26Z decibel $

CREATE OR REPLACE FUNCTION rrs.update_lock(oid, int) RETURNS int AS '
DECLARE
    -- Code to set or clear a userlock returns -1 if userlock code isn''t installed, 1 on sucess and 0 on failure

    p_oid ALIAS FOR $1;
    p_set ALIAS FOR $2;
BEGIN
    -- See if the locking code even exists
    -- We can''t use regprocedure::oid because it will generate an error if the procedure doesn''t exist.
    IF NOT EXISTS (
            SELECT *
                FROM pg_proc
                WHERE proname=''user_write_lock_oid''
                    AND pronargs = 1
                    AND proargtypes=''26''
        )
    THEN
        RETURN -1;
    END IF;

    IF p_set = 1 THEN
        RETURN user_write_lock_oid(p_oid);
    ELSE
        RETURN user_write_unlock_oid(p_oid);
    END IF;
END;
' LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rrs.min(timestamp with time zone, timestamp with time zone) RETURNS timestamp with time zone
    AS '
    SELECT CASE WHEN $1 < $2 THEN $1 ELSE $2 END
    '
    LANGUAGE sql IMMUTABLE STRICT;
GRANT EXECUTE ON FUNCTION rrs.min(timestamptz, timestamptz) TO PUBLIC;

-- vi: expandtab sw=4 ts=4
