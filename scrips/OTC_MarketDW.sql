#script to generate dw

CREATE SCHEMA IF NOT EXISTS "otcmarket";

CREATE  TABLE "otcmarket".dim_date ( 
	date_id              bigint  NOT NULL  ,
	"year"               integer    ,
	quarter              integer    ,
	monthnumber          integer    ,
	monthname            varchar(25)    ,
	weekofmonth          integer    ,
	weekofyear           integer    ,
	dayname              varchar(25)    ,
	daynumber            integer    ,
	dateisoformat        date    ,
	CONSTRAINT pk_dim_date PRIMARY KEY ( date_id )
 );

CREATE  TABLE "otcmarket".dim_location ( 
	location_id          bigint  NOT NULL  ,
	country              varchar(25)    ,
	"state"              varchar(25)    ,
	CONSTRAINT pk_dim_location PRIMARY KEY ( location_id )
 );

CREATE  TABLE "otcmarket".dim_sec ( 
	cusip                varchar(9)  NOT NULL  ,
	compid               integer    ,
	symbol               varchar(10)    ,
	sec_type             integer    ,
	sec_name             varchar(50)    ,
	sec_class            varchar(2)    ,
	sector               varchar(25)    ,
	caveat_emptor        varchar(2)    ,
	dad_pal              varchar(75)    ,
	CONSTRAINT pk_dim_sec PRIMARY KEY ( cusip )
 );

CREATE  TABLE "otcmarket".dim_status ( 
	status_id            bigint  NOT NULL  ,
	status_name          varchar(20)    ,
	CONSTRAINT pk_dim_status PRIMARY KEY ( status_id )
 );

CREATE  TABLE "otcmarket".dim_tier ( 
	tier_id              bigint  NOT NULL  ,
	tier_name            varchar(50)    ,
	CONSTRAINT pk_dim_tier PRIMARY KEY ( tier_id )
 );

CREATE  TABLE "otcmarket".dim_venue ( 
	venue_id             bigint  NOT NULL  ,
	venue_name           varchar(20)    ,
	CONSTRAINT pk_dim_venue PRIMARY KEY ( venue_id )
 );

CREATE  TABLE "otcmarket".entity ( 
 );

CREATE  TABLE "otcmarket".facts_price ( 
	fact_id              bigint  NOT NULL  ,
	csuip                integer    ,
	open_price           numeric(2,2)    ,
	high_price           numeric(2,2)    ,
	low_price            numeric(2,2)    ,
	last_price           numeric(2,2)    ,
	previous_closeprice  numeric(2,2)    ,
	shares_outstanding   integer    ,
	bfcmmid              integer    ,
	closingbest_bid      numeric(2,2)    ,
	closingbest_ask      numeric(2,2)    ,
	spread               numeric(2,2)    ,
	dollar_vol           numeric(2,2)    ,
	share_vol            integer    ,
	closingbest_biddate  date    ,
	closingbest_askdate  date    ,
	date_id              date    ,
	tier_id              integer    ,
	venue_id             integer    ,
	status_id            integer    ,
	location_id          integer    ,
	CONSTRAINT pk_facts_price PRIMARY KEY ( fact_id )
 );

CREATE UNIQUE INDEX unq_closingbest_biddate ON "otcmarket".facts_price ( closingbest_biddate );

CREATE UNIQUE INDEX unq_closingbest_askdate ON "otcmarket".facts_price ( closingbest_askdate );
