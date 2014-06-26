/*
********************************
* Name:    create_tables.sql 
* Author:  Doug Cooper 
* Version: 1.2
*
* Version History
* 1.0: Initial code
* 1.1: MySQL does not support CREATE DOMAIN.
*      Use standard types and add constraints
*      to table definition instead.
* 1.2: CHECK constraints unsupported too.
*      Rewritten to use triggers instead.
*********************************
*/

-- What will we do with this?
-- CREATE DOMAIN picture_galleries

DROP TABLE IF EXISTS books_transport;
DROP TABLE IF EXISTS books_room;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS attraction;
DROP TABLE IF EXISTS activity;
DROP TABLE IF EXISTS transport;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS accommodation;
DROP TABLE IF EXISTS credit_card;
DROP TABLE IF EXISTS client;

CREATE TABLE client (
    client_id UNSIGNED MEDIUMINT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address VARCHAR(200) NOT NULL,
    date_of_birth DATE,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,

    PRIMARY KEY (client_id)
);

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
    client_id CHAR(6) NOT NULL,

    PRIMARY KEY (card_no)
);

CREATE TABLE accommodation (
    accom_id UNSIGNED MEDIUMINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    description VARCHAR(1000),
    website_url VARCHAR(200),
    -- picture_gallery picture_galleries,

    PRIMARY KEY (accom_id)
);

CREATE TABLE room (
    room_id CHAR(6) NOT NULL,
    description VARCHAR(1000),
    room_type VARCHAR(9) NOT NULL,
    capacity SMALLINT NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis VARCHAR(15) NOT NULL,
    accom_id CHAR(6) NOT NULL,

    PRIMARY KEY (room_id)
);

CREATE TABLE booking (
    booking_id UNSIGNED MEDIUMINT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    booking_type VARCHAR(13) NOT NULL,
    start_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_date DATE,
    end_time TIME,
    price DECIMAL(6,2) NOT NULL,
    client_id CHAR(6) NOT NULL,
    card_no NUMERIC(16,0) NOT NULL,

    PRIMARY KEY (booking_id)
);

CREATE TABLE transport (
    transport_id UNSIGNED MEDIUMINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    website_url VARCHAR(200),
    description VARCHAR(1000),
    -- picture_gallery picture_galleries,
    transport_type VARCHAR(8) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis VARCHAR(15) NOT NULL,

    PRIMARY KEY (transport_id)
);

CREATE TABLE activity (
    activity_id UNSIGNED MEDIUMINT NOT NULL,
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

    PRIMARY KEY (activity_id)
);

CREATE TABLE attraction (
    attraction_id UNSIGNED MEDIUMINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    website_url VARCHAR(200),
    description VARCHAR(1000),
    -- picture_gallery picture_galleries,
    attraction_type VARCHAR(8) NOT NULL,
    opening_hours VARCHAR(100) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis VARCHAR(10) NOT NULL,

    PRIMARY KEY (attraction_id)
);

CREATE TABLE books (
    
    /* Check how to  implement supertypes */
    
    booking_id UNSIGNED MEDIUMINT NOT NULL,
    thing_to_do_id UNSIGNED MEDIUMINT NOT NULL,

    PRIMARY KEY (booking_id, thing_to_do_id)
);

CREATE TABLE books_room (
    booking_id UNSIGNED MEDIUMINT NOT NULL,
    room_id UNSIGNED MEDIUMINT NOT NULL,

    PRIMARY KEY (booking_id, room_id)
);

CREATE TABLE books_transport (
    booking_id UNSIGNED MEDIUMINT NOT NULL,
    transport_id UNSIGNED MEDIUMINT NOT NULL,

    PRIMARY KEY (booking_id, transport_id)
);

ALTER TABLE credit_card
    ADD CONSTRAINT credit_card_in_pays_with
        FOREIGN KEY (client_id) REFERENCES client(client_id);

ALTER TABLE room
    ADD CONSTRAINT room_in_contains
        FOREIGN KEY (accom_id) REFERENCES accommodation(accom_id);

ALTER TABLE booking
    ADD CONSTRAINT booking_in_requests
        FOREIGN KEY (client_id) REFERENCES client(client_id),

    ADD CONSTRAINT booking_in_pays_for
        FOREIGN KEY (card_no) REFERENCES credit_card(card_no);

ALTER TABLE books
    ADD CONSTRAINT books_in_booking_b
        FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

    /* Not sure what to do here
    ADD CONSTRAINT books_in_thing_to_do_b
        FOREIGN KEY (thing_to_do_id) REFERENCES -- activity or attraction
    */

ALTER TABLE books_room
    ADD CONSTRAINT books_room_in_booking_br
        FOREIGN KEY (booking_id) REFERENCES booking(booking_id),

    ADD CONSTRAINT books_room_in_room_br
        FOREIGN KEY (room_id) REFERENCES room(room_id);

ALTER TABLE books_transport
    ADD CONSTRAINT books_transport_in_booking_bt
        FOREIGN KEY (booking_id) REFERENCES booking(booking_id),

    ADD CONSTRAINT books_transport_in_transport_bt
        FOREIGN KEY (transport_id) REFERENCES transport(transport_id);

ALTER TABLE client
    ADD CONSTRAINT mandatory_in_pays_with
        CHECK (client_id IN
               (SELECT DISTINCT client_id FROM credit_card));

ALTER TABLE credit_card
    ADD CONSTRAINT valid_client_ids
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(client_id, 1, 1) = 'c'
               AND CAST(SUBSTR(client_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999));

ALTER TABLE accommodation
    ADD CONSTRAINT mandatory_in_contains
        CHECK (accom_id IN (SELECT DISTINCT accom_id FROM room)),

    ADD CONSTRAINT valid_acccom_ids
        /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(accom_id, 1, 1) = 'a'
                AND CAST(SUBSTR(accom_id, 2, 5) AS UNSIGNED INT)
                    BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_email_address
        /* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%');



ALTER TABLE room
    ADD CONSTRAINT valid_room_ids
        /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(room_id, 1, 1) = 'r'
                AND CAST(SUBSTR(room_id, 2, 5) AS UNSIGNED INT)
                    BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_room_types
        /* Check if this needs to be in constraints section of ERD */
        CHECK (room_type IN ('Single', 'Double', 'Twin', 'Suite', 'Apartment')),

    ADD CONSTRAINT valid_room_capacities
        /* Check if this needs to be in constraints section of ERD */
        CHECK (capacity BETWEEN 1 AND 10),

    ADD CONSTRAINT valid_room_price_basis
    /* Check if this needs to be in constraints section of ERD */
        CHECK (price_basis IN ('full board', 'half board', 'bed & breakfast', 'room only'));

ALTER TABLE booking
    ADD CONSTRAINT valid_booking_ids
        /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(booking_id, 1, 1) = 'b'
                AND CAST(SUBSTR(booking_id, 2, 5) AS UNSIGNED INT)
                    BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_client_ids
        /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(client_id, 1, 1) = 'c'
                AND CAST(SUBSTR(client_id, 2, 5) AS UNSIGNED INT)
                    BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_booking_type
    /* Check if this needs to be in constraints section of ERD */
    CHECK (VALUE IN ('Accommodation', 'Activity', 'Attraction', 'Transport')),

    /* Constraint c1: A Booking entity must take part in exactly one occurrence of
       either the BookingB, BookingBR or BookingBT relationship.
    */
    ADD CONSTRAINT c1
        CHECK ((booking_type = 'Accommodation'
               AND (booking_id IN
                    (SELECT DISTINCT booking_id FROM books_room))
              ) OR
               (booking_type IN ('Activity', 'Attraction')
               AND (booking_id IN
                    (SELECT DISTINCT booking_id FROM books))
              ) OR
               (booking_type = 'Transport'
               AND (booking_id IN
                    (SELECT DISTINCT booking_id FROM books_transport))
              ));

ALTER TABLE activity
    ADD CONSTRAINT valid_thing_to_do_id
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(thing_to_do_id, 1, 2) = 'th'
                AND CAST(SUBSTR(booking_id, 3, 5) AS UNSIGNED INT)
                    BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_email_address
        /* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%'),

    ADD CONSTRAINT valid_activity_type
        /* Check if this needs to be in constraints section of ERD */
        CHECK (activity_type IN ('Cultural', 'Hiking', 'Climbing', 'Winter Sports')),

    ADD CONSTRAINT valid_activity_price_basis
        /* Check if this needs to be in constraints section of ERD */
        CHECK (VALUE IN ('Per Day', 'Per Person', 'Per Person Per Day')),

    /* Constraint c4: An activity�s end date must be on or after its start date. */
    /* Constraint c5: If an activity starts and ends on the same day, the end time must be after the start time. */
    ADD CONSTRAINT c4c5
        CHECK ((start_date < end_date) OR
              ((start_date = end_date) AND
               (start_time < end_time)));

ALTER TABLE attraction
    ADD CONSTRAINT valid_thing_to_do_id
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(thing_to_do_id, 1, 2) = 'th'
               AND CAST(SUBSTR(booking_id, 3, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_email_address
        /* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%'),

    ADD CONSTRAINT valid_attraction_type
    /* Check if this needs to be in constraints section of ERD */
       CHECK (attraction_type IN ('Cultural')),

    ADD CONSTRAINT valid_attraction_price_basis
    /* Check if this needs to be in constraints section of ERD */
        CHECK(price_basis IN ('Adult', 'Child', 'Concession'));

ALTER TABLE transport
    ADD CONSTRAINT valid_transport_id
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(transport_id, 1, 1) = 't'
               AND CAST(SUBSTR(transport_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_transport_type
    /* Check if this needs to be in constraints section of ERD */
        CHECK (transport_type IN ('Plane', 'Bus', 'Train', 'Taxi', 'Hire Car')),

    ADD CONSTRAINT valid_email_address
    /* Check if this needs to be in constraints section of ERD */
        CHECK (email_address REGEXP '%@%\.%');

ALTER TABLE books
    ADD CONSTRAINT valid_thing_to_do_id
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(thing_to_do_id, 1, 2) = 'th'
               AND CAST(SUBSTR(booking_id, 3, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_booking_ids
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(booking_id, 1, 1) = 'b'
               AND CAST(SUBSTR(booking_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999));

ALTER TABLE books_room
    ADD CONSTRAINT valid_room_ids
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(room_id, 1, 1) = 'r'
               AND CAST(SUBSTR(room_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_booking_ids
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(booking_id, 1, 1) = 'b'
               AND CAST(SUBSTR(booking_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999));

ALTER TABLE books_transport
    ADD CONSTRAINT valid_transport_id
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(transport_id, 1, 1) = 't'
               AND CAST(SUBSTR(transport_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999)),

    ADD CONSTRAINT valid_booking_ids
    /* Check if this needs to be in constraints section of ERD */
        CHECK ((SUBSTR(booking_id, 1, 1) = 'b'
               AND CAST(SUBSTR(booking_id, 2, 5) AS UNSIGNED INT)
                   BETWEEN 00000 AND 99999));

CREATE TRIGGER validate_client BEFORE INSERT ON client
FOR EACH ROW
BEGIN
    -- Client IDs are 5-digit integers
    IF (client_id NOT BETWEEN 00000 AND 99999)
	THEN
	    SIGNAL SQLSTATE 45001
		SET MESSAGE_TEXT := 'Client ID invalid.';
	END IF;

    -- Email address must have the form <name>@<host>.<domain>
	IF (email_address NOT REGEXP '%@%\.%')
	THEN
	    SIGNAL SQLSTATE '45002'
		SET MESSAGE_TEXT := 'Email adddress invalid.';
	END IF;

    /* Constraint c2: A client�s date of birth must be before the current date.
       That is, the value of the DateOfBirth attribute of an instance of the Client
       entity type must be before the current date.
    */
    IF (date_of_birth > CURRENT_DATE)
	THEN
	    SIGNAL SQLSTATE '45003'
		SET MESSAGE_TEXT := 'Date of birth must be before today.';
	END IF;
END

-- Credit card type must be one of a finite list.
-- Start date must be before end date.
CREATE TRIGGER valid_credit_card BEFORE INSERT ON credit_card
FOR EACH ROW
BEGIN
    IF (credit_card_type NOT IN ('Visa Credit', 'Visa Debit', 'Mastercard Credit', 'Mastercard Debit'))
	THEN
	    SIGNAL SQLSTATE '45004'
		SET MESSAGE_TEXT := 'Unknown card type.';
	ELSIF (start_date >= end_date)
	THEN
	    SIGNAL SQLSTATE '45005'
		SET MESSAGE_TEXT 'Credit card start date must be before end date.';
	ENDIF;
END

