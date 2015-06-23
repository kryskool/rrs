-- Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
-- All rights reserved.
--
-- $Id: rrs.sql 27 2005-01-22 19:11:38Z decibel $

SET client_encoding = 'SQL_ASCII';

SET search_path = rrs, pg_catalog;

REVOKE ALL ON bucket FROM PUBLIC;
REVOKE ALL ON source_status FROM PUBLIC;
GRANT SELECT ON bucket TO PUBLIC;
GRANT SELECT ON source_status TO PUBLIC;

-- vi: expandtab sw=4 ts=4
