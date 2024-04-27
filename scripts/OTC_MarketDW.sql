#script to generate dw

CREATE SCHEMA IF NOT EXISTS "otcmarket";

CREATE  TABLE "otcmarket".dim_date ( 
	date_id              bigint  NOT NULL  ,
	yearnumber           integer    ,
	quarternumber        integer    ,
	monthnumber          integer    ,
	monthname            varchar(25)    ,
	weekofmonth          integer    ,
	weekofyear           integer    ,
	daynumber            integer    ,
	dayofweek            integer    ,
	dayname              varchar(25)    ,
	dateisoformat        date    ,
	CONSTRAINT pk_dim_date PRIMARY KEY ( date_id )
 );

CREATE  TABLE "otcmarket".dim_location ( 
	location_id          bigint  NOT NULL  ,
	country              varchar(25)    ,
	"state"              varchar(25)    ,
	CONSTRAINT pk_dim_location PRIMARY KEY ( location_id )
 );

CREATE  TABLE "otcmarket".dim_security ( 
	cusip                varchar(9)  NOT NULL  ,
	compid               integer    ,
	symbol               varchar(10)    ,
	company_name         varchar(50)    ,
	sec_type             varchar(25)    ,
	sec_name             varchar(50)    ,
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
	csuip                varchar(9)    ,
	tier_id              integer    ,
	venue_id             integer    ,
	status_id            integer    ,
	location_id          integer    ,
	closingbest_biddateid date    ,
	closingbest_askdateid date    ,
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
	CONSTRAINT pk_facts_price PRIMARY KEY ( fact_id )
 );

CREATE UNIQUE INDEX unq_closingbest_biddate ON "otcmarket".facts_price ( closingbest_biddateid );

CREATE UNIQUE INDEX unq_closingbest_askdate ON "otcmarket".facts_price ( closingbest_askdateid );
