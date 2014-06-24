/*
********************************
* Name:    create_tables.sql 
* Author:  Doug Cooper 
* Version: 1.0 
*
* Version History
* 1.0: Initial code
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
CREATE DOMAIN client_ids AS CHAR(6)
	CHECK (SUBSTR(VALUE, 1, 1) = 'c'
			AND CAST(SUBSTR(VALUE, 2, 5) AS SMALLINT)
				BETWEEN 00000 AND 99999)

CREATE DOMAIN first_names AS VARCHAR(20)
CREATE DOMAIN last_names AS VARCHAR(20)
CREATE DOMAIN address AS VARCHAR(200)
/* Decide on tel no representation */
CREATE DOMAIN telephone_nos AS
/* Need check constraint for {text}@{text} */
CREATE DOMAIN email_addresses AS VARCHAR(40)
CREATE DOMAIN credit_card_nos AS NUMERIC(16, 0)
CREATE DOMAIN credit_card_types AS VARCHAR(17)
	CHECK (VALUE IN ('Visa Credit', 'Visa Debit', 'Mastercard Credit', 'Mastercard Debit'))
CREATE DOMAIN issue_nos AS DECIMAL(3, 0)
CREATE DOMAIN ccv_codes AS NUMERIC(3, 0)
CREATE DOMAIN accom_ids AS CHAR(6)
	CHECK (SUBSTR(VALUE, 1, 1) = 'a'
			AND CAST(SUBSTR(VALUE, 2, 5) AS SMALLINT)
				BETWEEN 00001 AND 99999)
CREATE DOMAIN hotel_names AS VARCHAR(100)
CREATE DOMAIN descriptions AS VARCHAR(1000)
CREATE DOMAIN urls AS VARCHAR(200)
/* What will we do with this? */
CREATE DOMAIN picture_galleries
CREATE DOMAIN room_ids AS CHAR(6)
	CHECK (SUBSTR(VALUE, 1, 1) = 'r'
			AND CAST(SUBSTR(VALUE, 2, 5) AS SMALLINT)
				BETWEEN 00001 AND 99999)
CREATE DOMAIN room_types AS VARCHAR(9)
	CHECK (VALUE IN ('Single', 'Double', 'Twin', 'Suite', 'Apartment'))
CREATE DOMAIN room_capacities AS SMALLINT
	CHECK (VALUE BETWEEN 1 AND 10)
CREATE DOMAIN prices AS DECIMAL(6, 2)
CREATE DOMAIN room_price_bases AS VARCHAR(15)
	CHECK (VALUE IN ('full board', 'half board', 'bed & breakfast', 'room only'))
CREATE DOMAIN booking_ids AS CHAR(6)
	CHECK (SUBSTR(VALUE, 1, 1) = 'b'
			AND CAST(SUBSTR(VALUE, 2, 5) AS SMALLINT)
				BETWEEN 00001 AND 99999)
CREATE DOMAIN booking_types as VARCHAR()
	CHECK (VALUE IN ('Accommodation', 'Activity', 'Attraction', 'Transport'))
CREATE DOMAIN transport_ids AS CHAR(7)
	CHECK (SUBSTR(VALUE, 1, 2) = 'tr'
			AND CAST(SUBSTR(VALUE, 3, 5) AS SMALLINT)
				BETWEEN 00001 AND 99999)
CREATE DOMAIN transport_names AS VARCHAR(100)
CREATE DOMAIN transport_types AS VARCHAR(8)
	CHECK (VALUE IN ('Plane', 'Bus', 'Train', 'Taxi', 'Hire Car'))
CREATE DOMAIN things_to_do_ids AS CHAR(7)
	CHECK (SUBSTR(VALUE, 1, 2) = 'th'
			AND CAST(SUBSTR(VALUE, 3, 5) AS SMALLINT)
				BETWEEN 00001 AND 99999)
CREATE DOMAIN activity_names AS VARCHAR(100)
CREATE DOMAIN activity_types AS VARCHAR()
	CHECK (VALUE IN ('Cultural', 'Hiking', 'Climbing', 'Winter Sports'))
CREATE DOMAIN activity_price_bases AS VARCHAR(18)
	CHECK (VALUE IN ('Per Day', 'Per Person', 'Per Person Per Day'))
CREATE DOMAIN attraction_names AS VARCHAR(100)
CREATE DOMAIN attraction_types AS VARCHAR(8)
	CHECK (VALUE IN ('Cultural'))
CREATE DOMAIN attraction_price_bases AS VARCHAR(10)
	CHECK(VALUE IN ('Adult', 'Child', 'Concession'))

	
CREATE TABLE client (
	client_id client_ids NOT NULL,
	first_name first_names NOT NULL,
	last_name last_names NOT NULL,
	address addresses NOT NULL,
	date_of_birth DATE,
	tel_no telephone_nos,
	email_address email_addresses NOT NULL,
	
	PRIMARY KEY client_id,
)

CREATE TABLE credit_card (
	card_no credit_card_nos NOT NULL,
	first_name first_names NOT NULL,
	last_name last_names NOT NULL,
	address addresses NOT NULL,
	card_type credit_card_types NOT NULL,
	start_date DATE,
	end_date DATE NOT NULL,
	issue_no issues_nos,
	ccv_code ccv_codes NOT NULL,
	client_id client_ids NOT NULL,
	
	PRIMARY KEY card_no,
)

CREATE TABLE accommodation (
	accom_id accom_ids NOT NULL,
	name hotel_names NOT NULL,
	address addresses NOT NULL,
	tel_no telephone_nos,
	email_address email_addresses NOT NULL,
	description descriptions,
	website_url urls,
	picture_gallery picture_galleries,
	
	PRIMARY KEY accom_id,
)

CREATE TABLE room (
	room_id room_ids NOT NULL,
	description descriptions,
	room_type room_types NOT NULL,
	capacity room_capacities NOT NULL,
	price prices NOT NULL,
	price_basis room_price_bases NOT NULL,
	accom_id accom_ids NOT NULL,
	
	PRIMARY KEY room_id,
)

CREATE TABLE booking (
	booking_id booking_ids NOT NULL,
	booking_date DATE NOT NULL,
	booking_time TIME NOT NULL,
	booking_type booking_types NOT NULL,
	start_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_date DATE,
	end_time TIME,
	price prices NOT NULL,
	client_id client_ids NOT NULL,
	card_no credit_card_nos NOT NULL,
	
	PRIMARY KEY booking_id,
)

CREATE TABLE transport (
	transport_id transport_ids NOT NULL,
	name transport_names NOT NULL,
	address addresses,
	tel_no telephone_nos,
	email_address email_addresses NOT NULL,
	website_url urls,
	description descriptions,
	picture_gallery picture_galleries,
	transport_type transport_types NOT NULL,
	price prices NOT NULL,
	price_basis trans_price_bases NOT NULL,
	
	PRIMARY KEY transport_id
)

CREATE TABLE activity (
	activity_id things_to_do_ids NOT NULL,
	name activity_names NOT NULL,
	address addresses,
	tel_no telephone_nos,
	email_address email_addresses NOT NULL,
	website_url urls,
	description descriptions,
	picture_gallery picture_galleries,
	activity_type activity_types NOT NULL,
	start_point addresses,
	start_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_date DATE,
	end_time TIME,
	price prices NOT NULL,
	price_basis activity_price_bases NOT NULL,
	
	PRIMARY KEY activity_id,
)

CREATE TABLE attraction (
	attraction_id things_to_do_ids NOT NULL,
	name attraction_names NOT NULL,
	address addresses,
	tel_no telephone_nos,
	email_address email_addresses NOT NULL,
	website_url urls,
	description descriptions,
	picture_gallery picture_galleries,
	attraction_type attraction_types NOT NULL,
	opening_hours opening_times NOT NULL,
	price prices NOT NULL,
	price_basis attraction_price_bases NOT NULL,
	
	PRIMARY KEY attraction_id
)

CREATE TABLE books (
	
	/* Check how to  implement supertypes */
	
	booking_id booking_ids NOT NULL,
	thing_to_do_id thing_to_do_ids NOT NULL,
	
	PRIMARY KEY (booking_id, thing_to_do_id),
)

CREATE TABLE books_room (
	booking_id booking_ids NOT NULL,
	room_id room_ids NOT NULL,
	 to 99999
	PRIMARY KEY (booking_id, room_id),
)

CREATE TABLE books_transport (
	booking_id booking_ids NOT NULL,
	transport_id transport_ids NOT NULL,
	
	PRIMARY KEY (booking_id, transport_id),
	
)

ALTER TABLE credit_card
	CONSTRAINT credit_card_in_pays_with
		FOREIGN KEY client_id REFERENCES client,
	
ALTER TABLE room
	CONSTRAINT room_in_contains
		FOREIGN KEY accom_id REFERENCES accommodation

ALTER TABLE booking
	CONSTRAINT booking_in_requests
		FOREIGN KEY client_id REFERENCES client,
		
	CONSTRAINT booking_in_pays_for
		FOREIGN KEY card_no REFERENCES credit_card

ALTER TABLE books
	CONSTRAINT books_in_booking_b
		FOREIGN KEY booking_id REFERENCES booking,
	
	CONSTRAINT books_in_thing_to_do_b
		FOREIGN KEY things_to_do_id REFERENCES /* activity or attraction */

ALTER TABLE books_room
	CONSTRAINT books_room_in_booking_br
		FOREIGN KEY booking_id REFERENCES booking,
	
	CONSTRAINT books_room_in_room_br
		FOREIGN KEY room_id REFERENCES room

ALTER TABLE books_transport
	CONSTRAINT books_transport_in_booking_bt
		FOREIGN KEY booking_id REFERENCES booking,
		
	CONSTRAINT books_transport_in_transport_bt
		FOREIGN KEY transport_id REFERENCES transport

ALTER TABLE client
    CONSTRAINT mandatory_in_pays_with
	 	CHECK (client_id IN
	   	    	(SELECT DISTINCT client_id
	    	    	 FROM credit_card)),
	
	/* Constraint c2: A client’s date of birth must be before the current date. That is, the value of the DateOfBirth attribute of an instance of the Client entity type must be before the current date. */
	CONSTRAINT c2
		CHECK (date_of_birth < CURRENT_DATE)
	

ALTER TABLE credit_card
	/* Constraint c3: A credit card’s start date must be before its end date. */
	CONSTRAINT c3
		CHECK (start_date < end_date)

ALTER TABLE accommodation
	CONSTRAINT mandatory_in_contains
		CHECK (accom_id IN
				(SELECT DISTINCT accom_id
				 FROM room))

ALTER TABLE booking
	/* Constraint c1: A Booking entity must take part in exactly one occurrence of either the BookingB, BookingBR or BookingBT relationship. */
	CONSTRAINT c1
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
	/* Constraint c4: An activity’s end date must be on or after its start date. */
	/* Constraint c5: If an activity starts and ends on the same day, the end time must be after the start time. */
	CONSTRAINT c4c5
		CHECK ((start_date < end_date) OR
				((start_date = end_date) AND
				 (start_time < end_time)))	

