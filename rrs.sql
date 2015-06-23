-- Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
-- All rights reserved.
--
-- $Id: rrs.sql 13 2005-01-17 23:32:26Z decibel $

SET client_encoding = 'SQL_ASCII';

CREATE SCHEMA rrs;
GRANT USAGE ON SCHEMA rrs TO PUBLIC;

SET search_path = rrs, pg_catalog;

CREATE TABLE rrs (
    rrs_id integer NOT NULL CONSTRAINT rrs_rrs__rrs_id PRIMARY KEY
    , keep_buckets integer NOT NULL
    , parent integer CONSTRAINT rrs_rrs__rrs_parent REFERENCES rrs(rrs_id)
    , parent_buckets integer
    , time_per_bucket interval(0) NOT NULL
    , rrs_name character varying(40) NOT NULL CONSTRAINT rrs_rrs__rrs_name UNIQUE
    , CONSTRAINT rrs_rrs__ck_parent_rrs_id CHECK (((parent IS NULL) OR (parent < rrs_id)))
) WITHOUT OIDS;


CREATE TABLE source (
    source_id serial NOT NULL CONSTRAINT rrs_source__source_id PRIMARY KEY
    , source_name character varying(80) CONSTRAINT rrs_source__source_name UNIQUE
    , insert_table text NOT NULL
    , source_table text NOT NULL
    , source_timestamptz_field text NOT NULL
    , group_clause text NOT NULL
    , insert_aggregate_fields text NOT NULL
    , primary_aggregate text NOT NULL
    , rrs_aggregate text NOT NULL
) WITHOUT OIDS;


CREATE TABLE source_status (
    rrs_id integer NOT NULL CONSTRAINT rrs_source_status__rrs_id REFERENCES rrs(rrs_id) ON DELETE CASCADE
    , source_id integer NOT NULL CONSTRAINT rrs_source_status__source_id REFERENCES source(source_id) ON DELETE CASCADE
    , last_end_time timestamp with time zone NOT NULL
) WITHOUT OIDS;



CREATE TABLE bucket (
    bucket_id serial NOT NULL CONSTRAINT rrs_bucket__bucket_id PRIMARY KEY
    , rrs_id integer NOT NULL CONSTRAINT rrs_bucket__rrs_id REFERENCES rrs(rrs_id)
    , end_time timestamp with time zone NOT NULL
    , prev_end_time timestamp with time zone NOT NULL
    , CONSTRAINT rrs_bucket__rrs_id__end_time UNIQUE (rrs_id, end_time)
) WITHOUT OIDS;



COPY rrs (rrs_id, keep_buckets, parent, parent_buckets, time_per_bucket, rrs_name) FROM stdin;
1	60	\N	\N	00:01:00	last hour
2	60	1	4	00:04:00	last 4 hours
3	60	2	3	00:12:00	last 12 hours
4	48	1	30	00:30:00	last day
5	56	4	6	03:00:00	last week
6	168	4	8	04:00:00	last month
7	365	6	6	1 day	last year
\.


/*
COPY source (source_name, insert_table, source_table, source_timestamptz_field, group_clause, insert_aggregate_fields, primary_aggregate, rrs_aggregate) FROM stdin;
page_log.rrs	page_log.log	log_time	page_id,project_id,other	hits,min_hits,max_hits,total_duration,min_duration,max_duration	count(*),count(*),count(*),sum(duration),min(duration),max(duration)	sum(hits),min(min_hits),max(max_hits),sum(total_duration),min(min_duration),max(max_duration)
\.
*/


GRANT SELECT ON rrs TO PUBLIC;
GRANT SELECT ON source TO PUBLIC;
GRANT SELECT,UPDATE ON source_source_id_seq TO PUBLIC;
GRANT ALL ON bucket TO PUBLIC;
GRANT ALL ON source_status TO PUBLIC;
GRANT SELECT,UPDATE ON bucket_bucket_id_seq TO PUBLIC;

-- vi: expandtab sw=4 ts=4
