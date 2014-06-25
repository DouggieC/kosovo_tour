/*
********************************
* Name:    create_tables.sql 
* Author:  Doug Cooper 
* Version: 1.1
*
* Version History
* 1.0: Initial code
* 1.1: MySQL does not support CREATE DOMAIN.
*      Use standard types and add constraints
*      to table definition instead.
 *********************************
*/

/* 1) Define all domains
 * 2) Define all columns of tables using CREATE TABLE statements,
 *    including all the column, primary key & uniqueness constraints
 * 3) Define all of the foreign keys using ALTER TABLE statements
 * 4) Define table constraints by using either check constraints or
 *    triggers; use ALTER TABLE or CREATE TRIGGER statements
 * M359 Block 4, p309
 */

-- What will we do with this?
-- CREATE DOMAIN picture_galleries

	
CREATE TABLE client (
	client_id CHAR(6) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	address VARCHAR(200) NOT NULL,
	date_of_birth DATE,
	tel_no VARCHAR(15),
	email_address VARCHAR(40) NOT NULL,
	
	PRIMARY KEY client_id
)

CREATE TABLE credit_card (
	card_no NUMERIC(16,0) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	address VARCHAR(200) NOT NULL,
	card_type VARCHAR(17) NOT NULL,
	start_date DATE,
	end_date DATE NOT NULL,
	issue_no NUMERIC(3,0),
	ccv_code NUMERIC(3,0) NOT NULL,
	client_id client_ids NOT NULL,
	
	PRIMARY KEY card_no
)

CREATE TABLE accommodation (
	accom_id CHAR(6) NOT NULL,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(200) NOT NULL,
	tel_no VARCHAR(15),
	email_address VARCHAR(40) NOT NULL,
	description VARCHAR(1000),
	website_url VARCHAR(200),
	-- picture_gallery picture_galleries,
	
	PRIMARY KEY accom_id
)

CREATE TABLE room (
	room_id CHAR(6) NOT NULL,
	description VARCHAR(1000),
	room_type VARCHAR(9) NOT NULL,
	capacity SMALLINT NOT NULL,
	price DECIMAL(6,2) NOT NULL,
	price_basis VARCHAR(15) NOT NULL,
	accom_id CHAR(6) NOT NULL,
	
	PRIMARY KEY room_id
)

CREATE TABLE booking (
	booking_id CHAR(6) NOT NULL,
	booking_date DATE NOT NULL,
	booking_time TIME NOT NULL,
	booking_type VARCHAR(13) NOT NULL,
	start_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_date DATE,
	end_time TIME,
	price DECIMAL(6,2) NOT NULL,
	client_id client_ids NOT NULL,
	card_no NUMERIC(16,0) NOT NULL,
	
	PRIMARY KEY booking_id
)

CREATE TABLE transport (
	transport_id CHAR(6) NOT NULL,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(200),
	tel_no VARCHAR(15),
	email_address VARCHAR(40) NOT NULL,
	website_url VARCHAR(200),
	description VARCHAR(1000),
	-- picture_gallery picture_galleries,
	transport_type VARCHAR(8) NOT NULL,
	price DECIMAL(6,2) NOT NULL,
	price_basis trans_price_bases NOT NULL,
	
	PRIMARY KEY transport_id
)

CREATE TABLE activity (
	activity_id CHAR(7) NOT NULL,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(200),
	tel_no VARCHAR(15),
	email_address VARCHAR(40) NOT NULL,
	website_url VARCHAR(200),
	description VARCHAR(1000),
	-- picture_gallery picture_galleries,
	activity_type VARCHAR(13) NOT NULL,
	start_point VARCHAR(200),
	start_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_date DATE,
	end_time TIME,
	price DECIMAL(6,2) NOT NULL,
	price_basis VARCHAR(18) NOT NULL,
	
	PRIMARY KEY activity_id
)

CREATE TABLE attraction (
	attraction_id CHAR(7) NOT NULL,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(200),
	tel_no VARCHAR(15),
	email_address VARCHAR(40) NOT NULL,
	website_url VARCHAR(200),
	description VARCHAR(1000),
	-- picture_gallery picture_galleries,
	attraction_type VARCHAR(8) NOT NULL,
	opening_hours opening_times NOT NULL,
	price DECIMAL(6,2) NOT NULL,
	price_basis VARCHAR(10) NOT NULL,
	
	PRIMARY KEY attraction_id
)

CREATE TABLE books (
	
	/* Check how to  implement supertypes */
	
	booking_id CHAR(6) NOT NULL,
	thing_to_do_id CHAR(7) NOT NULL,
	
	PRIMARY KEY (booking_id, thing_to_do_id)
)

CREATE TABLE books_room (
	booking_id CHAR(6) NOT NULL,
	room_id CHAR(6) NOT NULL,
	 to 99999
	PRIMARY KEY (booking_id, room_id)
)

CREATE TABLE books_transport (
	booking_id CHAR(6) NOT NULL,
	transport_id CHAR(6) NOT NULL,
	
	PRIMARY KEY (booking_id, transport_id)
)

ALTER TABLE credit_card
	ADD CONSTRAINT credit_card_in_pays_with
		    FOREIGN KEY client_id REFERENCES client
	
ALTER TABLE room
	ADD CONSTRAINT room_in_contains
    		FOREIGN KEY accom_id REFERENCES accommodation

ALTER TABLE booking
	ADD CONSTRAINT booking_in_requests
    		FOREIGN KEY client_id REFERENCES client,
		
	ADD CONSTRAINT booking_in_pays_for
	    	FOREIGN KEY card_no REFERENCES credit_card

ALTER TABLE books
	ADD CONSTRAINT books_in_booking_b
    		FOREIGN KEY booking_id REFERENCES booking,
	
	ADD CONSTRAINT books_in_thing_to_do_b
	    	FOREIGN KEY thing_to_do_id REFERENCES -- activity or attraction

ALTER TABLE books_room
	ADD CONSTRAINT books_room_in_booking_br
		    FOREIGN KEY booking_id REFERENCES booking,
	
	ADD CONSTRAINT books_room_in_room_br
    		FOREIGN KEY room_id REFERENCES room

ALTER TABLE books_transport
	ADD CONSTRAINT books_transport_in_booking_bt
	    	FOREIGN KEY booking_id REFERENCES booking,
		
	ADD CONSTRAINT books_transport_in_transport_bt
		    FOREIGN KEY transport_id REFERENCES transport

ALTER TABLE client
    ADD CONSTRAINT valid_client_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(client_id, 1, 1) = 'c'
		       	AND CAST(SUBSTR(client_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
    ADD CONSTRAINT valid_email_address
	/* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%'),

    ADD CONSTRAINT mandatory_in_pays_with
	 	CHECK (client_id IN
	   	    	(SELECT DISTINCT client_id
	    	    	 FROM credit_card)),
	
	/* Constraint c2: A client’s date of birth must be before the current date. That is, the value of the DateOfBirth attribute of an instance of the Client entity type must be before the current date. */
	ADD CONSTRAINT c2
		CHECK (date_of_birth < CURRENT_DATE)
	

ALTER TABLE credit_card
    ADD CONSTRAINT valid_credit_card_type
	/* Check if this needs to be in constraints section of ERD */
	    CHECK (credit_card_type IN ('Visa Credit', 'Visa Debit', 'Mastercard Credit', 'Mastercard Debit')),
	
	/* Constraint c3: A credit card’s start date must be before its end date. */
	ADD CONSTRAINT c3
		CHECK (start_date < end_date)

ALTER TABLE accommodation
	ADD CONSTRAINT mandatory_in_contains
		CHECK (accom_id IN
				(SELECT DISTINCT accom_id
				 FROM room)),

	 ADD CONSTRAINT valid_acccom_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(accom_id, 1, 1) = 'a'
		       	AND CAST(SUBSTR(accom_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
	ADD CONSTRAINT valid_email_address
	/* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%')

ALTER TABLE room
    ADD CONSTRAINT valid_room_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(room_id, 1, 1) = 'r'
		       	AND CAST(SUBSTR(room_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
    ADD CONSTRAINT valid_room_types
	/* Check if this needs to be in constraints section of ERD */
    	CHECK (room_type IN ('Single', 'Double', 'Twin', 'Suite', 'Apartment')),
		
	ADD CONSTRAINT valid_room_capacities
	/* Check if this needs to be in constraints section of ERD */
		CHECK (capacity BETWEEN 1 AND 10),
		
	ADD CONSTRAINT valid_room_price_basis
	/* Check if this needs to be in constraints section of ERD */
		CHECK (price_basis IN ('full board', 'half board', 'bed & breakfast', 'room only'))


					
ALTER TABLE booking
    ADD CONSTRAINT valid_booking_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(booking_id, 1, 1) = 'b'
		       	AND CAST(SUBSTR(booking_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
    ADD CONSTRAINT valid_booking_type
	/* Check if this needs to be in constraints section of ERD */
    	CHECK (VALUE IN ('Accommodation', 'Activity', 'Attraction', 'Transport')),

		/* Constraint c1: A Booking entity must take part in exactly one occurrence of either the BookingB, BookingBR or BookingBT relationship. */
	ADD CONSTRAINT c1
		CHECK ((booking_type = 'Accommodation'
					AND (booking_id IN
							(SELECT DISTINCT booking_id
							 FROM books_room))
				) OR
				(booking_type IN ('Activity', 'Attraction')
					AND (booking_id IN
							(SELECT DISTINCT booking_id
							 FROM books))
				) OR
				(booking_type = 'Transport'
					AND (booking_id IN
							(SELECT DISTINCT booking_id
							 FROM books_transport))
				))				

ALTER TABLE activity
    ADD CONSTRAINT valid_thing_to_do_id
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(thing_to_do_id, 1, 2) = 'th'
		       	AND CAST(SUBSTR(booking_id, 3, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
	ADD CONSTRAINT valid_email_address
	/* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%'),

    ADD CONSTRAINT valid_activity_type
	/* Check if this needs to be in constraints section of ERD */
    	CHECK (activity_type IN ('Cultural', 'Hiking', 'Climbing', 'Winter Sports')),

    ADD CONSTRAINT valid_activity_price_basis
	/* Check if this needs to be in constraints section of ERD */
    	CHECK (VALUE IN ('Per Day', 'Per Person', 'Per Person Per Day')),
		
    /* Constraint c4: An activity’s end date must be on or after its start date. */
	/* Constraint c5: If an activity starts and ends on the same day, the end time must be after the start time. */
	ADD CONSTRAINT c4c5
		CHECK ((start_date < end_date) OR
				((start_date = end_date) AND
				 (start_time < end_time)))	

ALTER TABLE attraction
    ADD CONSTRAINT valid_thing_to_do_id
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(thing_to_do_id, 1, 2) = 'th'
		       	AND CAST(SUBSTR(booking_id, 3, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
	ADD CONSTRAINT valid_email_address
	/* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%'),
		
    ADD CONSTRAINT valid_attraction_type
	/* Check if this needs to be in constraints section of ERD */
		CHECK (VALUE IN ('Cultural')),

    ADD CONSTRAINT valid_attraction_price_basis
	/* Check if this needs to be in constraints section of ERD */
		CHECK(VALUE IN ('Adult', 'Child', 'Concession'))

ALTER TABLE transport
    ADD CONSTRAINT valid_transport_id
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(transport_id, 1, 1) = 't'
		       	AND CAST(SUBSTR(transport_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),

    ADD CONSTRAINT valid_transport_type
	/* Check if this needs to be in constraints section of ERD */
	    CHECK (transport_type IN ('Plane', 'Bus', 'Train', 'Taxi', 'Hire Car')),
					
	ADD CONSTRAINT valid_email_address
	/* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%')

ALTER TABLE books
    ADD CONSTRAINT valid_thing_to_do_id
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(thing_to_do_id, 1, 2) = 'th'
		       	AND CAST(SUBSTR(booking_id, 3, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
    ADD CONSTRAINT valid_booking_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(booking_id, 1, 1) = 'b'
		       	AND CAST(SUBSTR(booking_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999)
					
ALTER TABLE books_room
    ADD CONSTRAINT valid_room_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(room_id, 1, 1) = 'r'
		       	AND CAST(SUBSTR(room_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),

    ADD CONSTRAINT valid_booking_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(booking_id, 1, 1) = 'b'
		       	AND CAST(SUBSTR(booking_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999)
					
ALTER TABLE books_transport
    ADD CONSTRAINT valid_transport_id
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(transport_id, 1, 1) = 't'
		       	AND CAST(SUBSTR(transport_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999),
					
    ADD CONSTRAINT valid_booking_ids
	/* Check if this needs to be in constraints section of ERD */
        CHECK (SUBSTR(booking_id, 1, 1) = 'b'
		       	AND CAST(SUBSTR(booking_id, 2, 5) AS SMALLINT)
			        BETWEEN 00000 AND 99999)
					
					