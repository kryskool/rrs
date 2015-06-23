-- Copyright (c) 2004, Jim C. Nasby (decibel@rrs.decibel.org)
-- All rights reserved.

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

CREATE SCHEMA rrd;
GRANT USAGE ON SCHEMA rrd TO PUBLIC;

SET search_path = rrd, pg_catalog;

CREATE TABLE rrd (
    rrd_id integer NOT NULL CONSTRAINT rrd_rrd__rrd_id PRIMARY KEY
    , keep_buckets integer NOT NULL
    , parent integer CONSTRAINT rrd_rrd__rrd_parent REFERENCES rrd(rrd_id)
    , parent_buckets integer
    , time_per_bucket interval(0) NOT NULL
    , rrd_name character varying(40) NOT NULL CONSTRAINT rrd_rrd__rrd_name UNIQUE
    , CONSTRAINT rrd_rrd__ck_parent_rrd_id CHECK (((parent IS NULL) OR (parent < rrd_id)))
) WITHOUT OIDS;


CREATE TABLE source (
    source_id serial NOT NULL CONSTRAINT rrd_source__source_id PRIMARY KEY
    , source_name character varying(80) CONSTRAINT rrd_source__source_name UNIQUE
    , insert_table text NOT NULL
    , source_table text NOT NULL
    , source_timestamptz_field text NOT NULL
    , group_clause text NOT NULL
    , insert_aggregate_fields text NOT NULL
    , primary_aggregate text NOT NULL
    , rrd_aggregate text NOT NULL
) WITHOUT OIDS;


CREATE TABLE source_status (
    rrd_id integer NOT NULL CONSTRAINT rrd_source_status__rrd_id REFERENCES rrd(rrd_id) ON DELETE CASCADE
    , source_id integer NOT NULL CONSTRAINT rrd_source_status__source_id REFERENCES source(source_id) ON DELETE CASCADE
    , last_end_time timestamp with time zone NOT NULL
) WITHOUT OIDS;



CREATE TABLE bucket (
    bucket_id serial NOT NULL CONSTRAINT rrd_bucket__bucket_id PRIMARY KEY
    , rrd_id integer NOT NULL CONSTRAINT rrd_bucket__rrd_id REFERENCES rrd(rrd_id)
    , end_time timestamp with time zone NOT NULL
    , prev_end_time timestamp with time zone NOT NULL
    , CONSTRAINT rrd_bucket__rrd_id__end_time UNIQUE (rrd_id, end_time)
) WITHOUT OIDS;



COPY rrd (rrd_id, keep_buckets, parent, parent_buckets, time_per_bucket, rrd_name) FROM stdin;
1	60	\N	\N	00:01:00	last hour
2	60	1	4	00:04:00	last 4 hours
3	60	2	3	00:12:00	last 12 hours
4	48	1	30	00:30:00	last day
5	56	4	6	03:00:00	last week
6	168	4	8	04:00:00	last month
7	365	6	6	1 day	last year
\.


COPY source (source_id, source_name, insert_table, source_table, source_timestamptz_field, group_clause, insert_aggregate_fields, primary_aggregate, rrd_aggregate) FROM stdin;
1	page_log	page_log.rrd	page_log.log	log_time	page_id,project_id,other	hits,min_hits,max_hits,total_duration,min_duration,max_duration	count(*),count(*),count(*),sum(duration),min(duration),max(duration)	sum(hits),min(min_hits),max(max_hits),sum(total_duration),min(min_duration),max(max_duration)
\.



GRANT SELECT ON rrd TO PUBLIC;
GRANT SELECT ON source TO PUBLIC;
GRANT SELECT,UPDATE ON source_source_id_seq TO PUBLIC;
GRANT ALL ON bucket TO PUBLIC;
GRANT ALL ON source_status TO PUBLIC;
GRANT SELECT,UPDATE ON bucket_bucket_id_seq TO PUBLIC;

