/*
********************************************************** 
* Name:    create_tables.sql
* Author:  Doug Cooper
* Version: 2.11
* Date:    01-07-2014
*
* Version History
* 1.0:  Initial code
* 1.1:  MySQL does not support CREATE DOMAIN.
*       Use standard types and add constraints
*       to table definition instead.
* 1.2:  CHECK constraints unsupported too.
*       Rewritten to use triggers instead.
*       Enumerated lists added as ENUMs where appropriate.
* 2.0:  Hefty rewrite to fully implement changes mentioned
*       in 1.1 & 1.2 above.
*       Also added error handling
* 2.1:  Don't use MYSQL_ERRNO for user-defined errors. Changed to
*       Use SQLSTATE '45xxx' instead.
* 2.2:  SIGNAL does not appear to work correctly for error
*       handling. Reverted to invalid proc call instead.
* 2.3:  Correct syntax for SIGNAL. Revert to this method rather
*       then invalid procedure call.
* 2.4:  Improve error handling for IDs and email addresses.
* 2.5:  Replace ENUMs with lookup tables - this is std SQL and
*       more easily maintained.
* 2.6:  Drop whole DB & recreate rather than dropping individual
*       tables.
* 2.7:  Address stored in multiple lines instead of one large
*       VARCHAR(200).
* 2.8:  Add table to hold last-used IDs.
* 2.9:  Corrections to procedure get_next_id()
* 2.10: Correct errors in validate_booking() procedure
* 2.11: Corrections to procedure get_next_id()
**********************************************************
*/

-- Delete the database if it exists already, then recreate it
DROP DATABASE IF EXISTS kostour;
CREATE DATABASE kostour DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE kostour;

-- client holds details of those looking to holiday in Kosovo
CREATE TABLE client (
    client_id CHAR(6) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_line_1 VARCHAR(50) NOT NULL,
    address_line_2 VARCHAR(50),
    address_line_3 VARCHAR(50),
    address_line_4 VARCHAR(50),
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,

    PRIMARY KEY (client_id)
);

-- Client's credit card details
CREATE TABLE credit_card (
    card_no NUMERIC(16,0) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_line_1 VARCHAR(50) NOT NULL,
    address_line_2 VARCHAR(50),
    address_line_3 VARCHAR(50),
    address_line_4 VARCHAR(50),
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    card_type INT NOT NULL,
    start_date DATE,
    end_date DATE NOT NULL,
    issue_no NUMERIC(3,0),
    ccv_code NUMERIC(3,0) NOT NULL,
    client_id CHAR(6) NOT NULL,

    PRIMARY KEY (card_no)
);

-- Overall details of an accomodation provider, eg hotel name
CREATE TABLE accommodation (
    accom_id CHAR(6) NOT NULL,
    name VARCHAR(100) NOT NULL,
    address_line_1 VARCHAR(50) NOT NULL,
    address_line_2 VARCHAR(50),
    address_line_3 VARCHAR(50),
    address_line_4 VARCHAR(50),
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    description VARCHAR(1000),
    website_url VARCHAR(200),
    picture MEDIUMBLOB,

    PRIMARY KEY (accom_id)
);

-- Details of individual rooms within an accomodation
CREATE TABLE room (
    room_id CHAR(6) NOT NULL,
    description VARCHAR(1000),
    room_type INT NOT NULL,
    capacity SMALLINT NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis INT NOT NULL,
    accom_id CHAR(6) NOT NULL,

    PRIMARY KEY (room_id)
);

-- Details of a booking made by a client
CREATE TABLE booking (
    booking_id CHAR(6) NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    booking_type INT NOT NULL,
    start_date DATE NOT NULL,
    start_time TIME,
    end_date DATE,
    end_time TIME,
    price DECIMAL(6,2) NOT NULL,
    client_id CHAR(6) NOT NULL,
    card_no NUMERIC(16,0) NOT NULL,

    PRIMARY KEY (booking_id)
);

-- Details of transport providers available
CREATE TABLE transport (
    transport_id CHAR(6) NOT NULL,
    name VARCHAR(100) NOT NULL,
    address_line_1 VARCHAR(50) NOT NULL,
    address_line_2 VARCHAR(50),
    address_line_3 VARCHAR(50),
    address_line_4 VARCHAR(50),
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    website_url VARCHAR(200),
    description VARCHAR(1000),
    picture MEDIUMBLOB,
    transport_type INT NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis VARCHAR(15) NOT NULL,

    PRIMARY KEY (transport_id)
);

-- Represents ThingToDo supertype, comprising Activity and Attraction subtypes.
-- thing_type column is used to indicate which subtype is represented.
CREATE TABLE thing_to_do (
    thing_to_do_id CHAR(6) NOT NULL,
    thing_type INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address_line_1 VARCHAR(50) NOT NULL,
    address_line_2 VARCHAR(50),
    address_line_3 VARCHAR(50),
    address_line_4 VARCHAR(50),
    postcode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    website_url VARCHAR(200),
    description VARCHAR(1000),
    picture MEDIUMBLOB,
    price DECIMAL(6,2) NOT NULL,

    -- Just for activities
    activity_type INT,
    start_point VARCHAR(200),
    start_date DATE,
    start_time TIME,
    end_date DATE,
    end_time TIME,
    act_price_basis INT,

    -- Just for attractions
    attraction_type INT,
    opening_hours VARCHAR(100),
    attr_price_basis INT,

    PRIMARY KEY (thing_to_do_id)
);

-- R-for-R approach to resolve m:n Books relationship
CREATE TABLE books (
    booking_id CHAR(6) NOT NULL,
    thing_to_do_id CHAR(6) NOT NULL,

    PRIMARY KEY (booking_id, thing_to_do_id)
);

-- R-for-R approach to resolve m:n BooksRoom relationship
CREATE TABLE books_room (
    booking_id CHAR(6) NOT NULL,
    room_id CHAR(6) NOT NULL,

    PRIMARY KEY (booking_id, room_id)
);

-- R-for-R approach to resolve m:n BooksTransport relationship
CREATE TABLE books_transport (
    booking_id CHAR(6) NOT NULL,
    transport_id CHAR(6) NOT NULL,

    PRIMARY KEY (booking_id, transport_id)
);

-- Valid types of credit / debit card
CREATE TABLE card_type (
    card_type_id INT NOT NULL AUTO_INCREMENT,
    card_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (card_type_id)
);

-- Valid types of room
CREATE TABLE room_type (
    room_type_id INT AUTO_INCREMENT,
    room_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (room_type_id)
);

-- Valid room price bases
CREATE TABLE room_price_basis (
    room_pb_id INT AUTO_INCREMENT,
    room_price_basis VARCHAR(30) NOT NULL,

    PRIMARY KEY (room_pb_id)
);

-- Valid types of booking
CREATE TABLE booking_type (
    booking_type_id INT AUTO_INCREMENT,
    booking_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (booking_type_id)
);

-- Valid types of transport
CREATE TABLE transport_type (
    trans_type_id INT AUTO_INCREMENT,
    transport_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (trans_type_id)
);

-- Valid types of thing to do
CREATE TABLE thing_type (
    thing_type_id INT AUTO_INCREMENT,
    thing_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (thing_type_id)
);

-- Valid types of activity
CREATE TABLE activity_type (
    act_type_id INT AUTO_INCREMENT,
    activity_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (act_type_id)
);

-- Valid activity price bases
CREATE TABLE activity_price_basis (
    act_pb_id INT AUTO_INCREMENT,
    activity_price_basis VARCHAR(30) NOT NULL,

    PRIMARY KEY (act_pb_id)
);

-- Valid types of attraction
CREATE TABLE attraction_type (
    attr_type_id INT AUTO_INCREMENT,
    attraction_type VARCHAR(30) NOT NULL,

    PRIMARY KEY (attr_type_id)
);

-- Valid attraction price bases
CREATE TABLE attraction_price_basis (
    attr_pb_id INT AUTO_INCREMENT,
    attrattrion_price_basis VARCHAR(30) NOT NULL,

    PRIMARY KEY (attr_pb_id)
);

-- Store last used IDs for inserting new rows
CREATE TABLE last_used_id (
    -- Setting PK to ENUM with one value ensures
    -- there is never more than one row.
    last_used_pk   ENUM('0') NOT NULL PRIMARY KEY,
    client_id      CHAR(6)   NOT NULL,
    accom_id       CHAR(6)   NOT NULL,
    room_id        CHAR(6)   NOT NULL,
    booking_id     CHAR(6)   NOT NULL,
    transport_id   CHAR(6)   NOT NULL,
    thing_to_do_id CHAR(6)   NOT NULL
);

ALTER TABLE credit_card
    ADD CONSTRAINT credit_card_in_pays_with
        FOREIGN KEY (client_id) REFERENCES client(client_id),

    ADD CONSTRAINT credit_card_in_card_is_a
        FOREIGN KEY (card_type) REFERENCES card_type(card_type_id);

ALTER TABLE room
    ADD CONSTRAINT room_in_contains
        FOREIGN KEY (accom_id) REFERENCES accommodation(accom_id),

    ADD CONSTRAINT room_in_room_is_a
        FOREIGN KEY (room_type) REFERENCES room_type(room_type_id),

    ADD CONSTRAINT room_in_room_is_charged
        FOREIGN KEY (price_basis) REFERENCES room_price_basis(room_pb_id);

ALTER TABLE booking
    ADD CONSTRAINT booking_in_requests
        FOREIGN KEY (client_id) REFERENCES client(client_id),

    ADD CONSTRAINT booking_in_pays_for
        FOREIGN KEY (card_no) REFERENCES credit_card(card_no),

    ADD CONSTRAINT booking_in_booking_is_for
        FOREIGN KEY (booking_type) REFERENCES booking_type(booking_type_id);

ALTER TABLE transport
    ADD CONSTRAINT transport_in_transport_is_a
        FOREIGN KEY (transport_type) REFERENCES transport_type(trans_type_id);

ALTER TABLE thing_to_do
    ADD CONSTRAINT thing_to_do_in_thing_is_a
        FOREIGN KEY (thing_type) REFERENCES thing_type(thing_type_id),

    ADD CONSTRAINT thing_to_do_in_activity_is_a
        FOREIGN KEY (activity_type) REFERENCES activity_type(act_type_id),

    ADD CONSTRAINT thing_to_do_in_attraction_is_a
        FOREIGN KEY (attraction_type) REFERENCES attraction_type(attr_type_id),

    ADD CONSTRAINT thing_to_do_in_activity_is_charged
        FOREIGN KEY (act_price_basis) REFERENCES activity_price_basis(act_pb_id),

    ADD CONSTRAINT thing_to_do_in_attraction_is_charged
        FOREIGN KEY (attr_price_basis) REFERENCES attraction_price_basis(attr_pb_id);

ALTER TABLE books
    ADD CONSTRAINT books_in_booking_b
        FOREIGN KEY (booking_id) REFERENCES booking(booking_id),

    ADD CONSTRAINT books_in_thing_to_do_b
        FOREIGN KEY (thing_to_do_id) REFERENCES thing_to_do(thing_to_do_id);

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

DELIMITER $$
-- Make sure the ID (PK) is valid
-- Should be [cartvb]00000
CREATE PROCEDURE validate_id (IN id CHAR(6), IN id_should_be CHAR(1))
BEGIN
    DECLARE id_pref CHAR(1);
    DECLARE id_suff CHAR(5);
    DECLARE id_name VARCHAR(25);
    DECLARE id_suff_int INT;
    DECLARE err_msg VARCHAR(50);

    SET id_pref = SUBSTR(id,1,1);
    SET id_suff = SUBSTR(id,2,5);
    SET id_suff_int = CAST(id_suff AS UNSIGNED INTEGER);

    CASE id_should_be
        WHEN 'c' THEN SET id_name = 'Client';
        WHEN 'a' THEN SET id_name = 'Accommodation';
        WHEN 'r' THEN SET id_name = 'Room';
        WHEN 't' THEN SET id_name = 'Activity or attraction';
        WHEN 'v' THEN SET id_name = 'Transport';
        WHEN 'b' THEN SET id_name = 'Booking';
        ELSE
            BEGIN
                SET err_msg=CONCAT(id_name, ' ID invalid: ', id);
                SIGNAL SQLSTATE '45001'
                    SET MESSAGE_TEXT='ID invalid.';
            END;
    END CASE;

    IF id_pref <> id_should_be
    THEN
        BEGIN
            SET err_msg=CONCAT(id_name, ' ID invalid: ', id);
             SIGNAL SQLSTATE '45001'
                 SET MESSAGE_TEXT=err_msg;
        END;
    END IF;

    IF id_suff_int NOT BETWEEN 00001 AND 99999
    THEN
        BEGIN
            SET err_msg=CONCAT(id_name, ' ID invalid: ', id);
             SIGNAL SQLSTATE '45001'
                 SET MESSAGE_TEXT=err_msg;
        END;
    END IF;

END $$

-- Email address must contain an `@' symbol and FQDN containing
-- at least one `.', i.e. <name>@<host>.<domain>
CREATE PROCEDURE validate_email (IN email_addr VARCHAR(40))
BEGIN
    DECLARE err_msg VARCHAR(100);

    IF (email_addr NOT REGEXP '^[^@]+@[^@]+\.[^@]{2,}')
    THEN
        BEGIN
            SET err_msg=CONCAT('Invalid email address: ', email_addr);
            SIGNAL SQLSTATE '45002'
                SET MESSAGE_TEXT=err_msg;
        END;
    END IF;

END $$

CREATE PROCEDURE validate_client (IN my_client_id CHAR(6), IN my_email_addr VARCHAR(40), IN my_dob DATE)
BEGIN
    -- Client IDs are c99999
    CALL validate_id(my_client_id, 'c');

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_addr);

    /* Constraint c2: A client's date of birth must be before the current date.
       That is, the value of the DateOfBirth attribute of an instance of the Client
       entity type must be before the current date.
    */
    IF (my_dob > CURRENT_DATE)
    THEN
        SIGNAL SQLSTATE '45003'
            SET MESSAGE_TEXT='Invalid date of birth.';
    END IF;
END $$

CREATE PROCEDURE validate_credit_card (IN my_start_date DATE, IN my_end_date DATE)
BEGIN
    -- Start date must be before end date.
    IF (my_start_date >= my_end_date)
    THEN
        SIGNAL SQLSTATE '45005'
            SET MESSAGE_TEXT='Invalid credit card date range.';
    END IF;

END $$

CREATE PROCEDURE validate_accommodation(IN my_accom_id CHAR(6), IN my_email_addr VARCHAR(40))
BEGIN
    -- Accommodation IDs are a99999
    CALL validate_id(my_accom_id, 'a');

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_addr);

END $$

CREATE PROCEDURE validate_room (IN my_room_id CHAR(6), IN my_capacity SMALLINT)
BEGIN
    -- Room IDs are r99999
    CALL validate_id(my_room_id, 'r');

    IF (my_capacity NOT BETWEEN 1 AND 10)
    THEN
        SIGNAL SQLSTATE '45007'
            SET MESSAGE_TEXT='Room capacity out of range.';
    END IF;

END $$

CREATE PROCEDURE validate_booking (IN my_booking_id CHAR(6), IN my_client_id CHAR(6), IN my_booking_type VARCHAR(13))
BEGIN
    -- Booking IDs are b99999
    CALL validate_id(my_booking_id, 'b');

    -- Client IDs are c99999
    CALL validate_id(my_client_id, 'c');

    /* Constraint c1: A Booking entity must take part in exactly one occurrence of
       either the BookingB, BookingBR or BookingBT relationship.
       Booking types are: 1 - accommodation, 2 - activity, 3 - attraction & 4 - transport.
       All stored in booking_type table.
    */
    IF (NOT ((my_booking_type = '1'
               AND (my_booking_id IN
                    (SELECT DISTINCT booking_id FROM books_room))
              ) OR
               (my_booking_type IN ('2', '3')
               AND (my_booking_id IN
                    (SELECT DISTINCT booking_id FROM books))
              ) OR
               (my_booking_type = '4'
               AND (my_booking_id IN
                    (SELECT DISTINCT booking_id FROM books_transport))
              ))
        )
    THEN
        SIGNAL SQLSTATE '45009'
            SET MESSAGE_TEXT='Invalid booking type.';
    END IF;

END $$

CREATE PROCEDURE validate_thing_to_do (IN my_thing_to_do_id CHAR(6), IN my_email_addr VARCHAR(40), IN my_thing_type VARCHAR(10),
                                       IN my_activity_type VARCHAR(13), IN my_attraction_type VARCHAR(8), IN my_start_date DATE,
                                       IN my_start_time TIME, IN my_end_date DATE, IN my_end_time TIME, IN my_opening_hours VARCHAR(100))
BEGIN
    -- ThingToDo IDs are t99999
    CALL validate_id(my_thing_to_do_id, 't');

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_address);

    IF (my_thing_type = 'Activity')
    THEN
        -- NOT NULL constraint for activity type
        IF (my_activity_type IS NULL)
        THEN
            SIGNAL SQLSTATE '45011'
                SET MESSAGE_TEXT='Invalid activity type.';
        END IF;

        -- NOT NULL constraint for start date and time
        IF (my_start_date IS NULL OR my_start_time IS NULL)
        THEN
            SIGNAL SQLSTATE '45013'
                SET MESSAGE_TEXT='Invalid start date / time.';
        END IF;

        -- Constraint c4: An activity's end date must be on or after its start date.
        -- Constraint c5: If an activity starts and ends on the same day, the end time must be after the start time.
        IF (NOT ((my_start_date < my_end_date) OR
                ((my_start_date = my_end_date) AND
                 (my_start_time < my_end_time)))
            )
        THEN
            SIGNAL SQLSTATE '45013'
                SET MESSAGE_TEXT='Invalid start date / time.';
        END IF;
    ELSEIF (my_thing_type = 'Attraction')
    THEN
        -- NOT NULL constraint for attraction type
        IF (my_attraction_type IS NULL)
        THEN
            SIGNAL SQLSTATE '45014'
                SET MESSAGE_TEXT='Invalid attraction type.';
        END IF;

        -- NOT NULL constraint for opening hours
        IF (my_opening_hours IS NULL)
        THEN
            SIGNAL SQLSTATE '45016'
                SET MESSAGE_TEXT='Invalid opening hours.';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45017'
            SET MESSAGE_TEXT='Invalid activity / attraction type.';
    END IF;

END $$

CREATE PROCEDURE validate_transport (IN my_transport_id CHAR(6), IN my_email_addr VARCHAR(40))
BEGIN
    -- Transport IDs are v99999 (v for vehicle - t already used for thing_to_do)
    CALL validate_id(my_transport_id, 'v');

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_address);

END $$

CREATE PROCEDURE validate_books (IN my_thing_to_do_id CHAR(6), IN my_booking_id CHAR(6))
BEGIN
    -- Thing-to-do IDs are t99999
    CALL validate_id(my_thing_to_do_id, 't');

    -- Booking IDs are b99999
    CALL validate_id(my_booking_id, 'b');

END $$

CREATE PROCEDURE validate_books_room (IN my_room_id CHAR(6), IN my_booking_id CHAR(6))
BEGIN
    -- Room IDs are r99999
    CALL validate_id(my_room_id, 'r');

    -- Booking IDs are b99999
    CALL validate_id(my_booking_id, 'b');

END $$

CREATE PROCEDURE validate_books_transport (IN my_transport_id CHAR(6), IN my_booking_id CHAR(6))
BEGIN
    -- Transport IDs are v99999
    CALL validate_id(my_transport_id, 'v');

    -- Booking IDs are b99999
    CALL validate_id(my_booking_id, 'b');

END $$

CREATE PROCEDURE get_next_id (IN my_id_type CHAR(1), OUT next_id CHAR(6))
BEGIN

    DECLARE id_field VARCHAR(15);
    DECLARE err_msg VARCHAR(50);
    DECLARE t1 VARCHAR(50);
    DECLARE stmt VARCHAR(50);
    DECLARE curr_id CHAR(6);

    -- What sort of ID number are we dealing with?
    CASE my_id_type
        WHEN 'c' THEN SET id_field = 'client_id';
        WHEN 'a' THEN SET id_field = 'accom_id';
        WHEN 'r' THEN SET id_field = 'room_id';
        WHEN 't' THEN SET id_field = 'thing_to_do_id';
        WHEN 'v' THEN SET id_field = 'transport_id';
        WHEN 'b' THEN SET id_field = 'booking_id';
        ELSE
            BEGIN
                SET err_msg=CONCAT(my_id_type, ' ID type invalid.');
                SIGNAL SQLSTATE '45001'
                    SET MESSAGE_TEXT='ID type invalid.';
            END;
    END CASE;

    -- Get the last used ID from the table
    SET @t1 := CONCAT('SELECT ', id_field, ' INTO @curr_id FROM last_used_id LIMIT 1');
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Increment the last used ID to get the new one, and assign to output variable
    SET next_id = CONCAT(SUBSTR(@curr_id,1,1), LPAD(CAST(SUBSTR(@curr_id,2,5) AS UNSIGNED INTEGER) + 1, 5, '0'));

    -- Update the table with the new ID
    SET @t1 := CONCAT('UPDATE last_used_id SET ', id_field, '= ?');
    SET @update_id = next_id;
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING @update_id;
    DEALLOCATE PREPARE stmt;

END $$

CREATE TRIGGER validate_client_on_insert BEFORE INSERT ON client
FOR EACH ROW
BEGIN
    CALL validate_client(NEW.client_id, NEW.email_address, NEW.date_of_birth);
END $$

CREATE TRIGGER validate_client_on_update BEFORE UPDATE ON client
FOR EACH ROW
BEGIN
    CALL validate_client(NEW.client_id, NEW.email_address, NEW.date_of_birth);
END $$

CREATE TRIGGER validate_credit_card_on_insert BEFORE INSERT ON credit_card
FOR EACH ROW
BEGIN
    CALL validate_credit_card(NEW.start_date, NEW.end_date);
END $$

CREATE TRIGGER validate_credit_card_on_update BEFORE UPDATE ON credit_card
FOR EACH ROW
BEGIN
    CALL validate_credit_card(NEW.start_date, NEW.end_date);
END $$

CREATE TRIGGER validate_accommodation_on_insert BEFORE INSERT ON accommodation
FOR EACH ROW
BEGIN
    CALL validate_accommodation(NEW.accom_id, NEW.email_address);
END $$

CREATE TRIGGER validate_accommodation_on_update BEFORE UPDATE ON accommodation
FOR EACH ROW
BEGIN
    CALL validate_accommodation(NEW.accom_id, NEW.email_address);
END $$

CREATE TRIGGER validate_room_on_insert BEFORE INSERT ON room
FOR EACH ROW
BEGIN
    CALL validate_room(NEW.room_id, NEW.capacity);
END $$

CREATE TRIGGER validate_room_on_update BEFORE UPDATE ON room
FOR EACH ROW
BEGIN
    CALL validate_room(NEW.room_id, NEW.capacity);
END $$

CREATE TRIGGER validate_booking_on_insert BEFORE INSERT ON booking
FOR EACH ROW
BEGIN
    CALL validate_booking(NEW.booking_id, NEW.client_id, NEW.booking_type);
END $$

CREATE TRIGGER validate_booking_on_update BEFORE UPDATE ON booking
FOR EACH ROW
BEGIN
    CALL validate_booking(NEW.booking_id, NEW.client_id, NEW.booking_type);
END $$

CREATE TRIGGER validate_thing_to_do_on_insert BEFORE INSERT ON thing_to_do
FOR EACH ROW
BEGIN
    CALL validate_thing_to_do(NEW.thing_to_do_id, NEW.email_address, NEW.thing_type, NEW.activity_type,
                              NEW.attraction_type, NEW.start_date, NEW.start_time, NEW.end_date, NEW.end_time, NEW.opening_hours);
END $$

CREATE TRIGGER validate_thing_to_do_on_update BEFORE UPDATE ON thing_to_do
FOR EACH ROW
BEGIN
    CALL validate_thing_to_do(NEW.thing_to_do_id, NEW.email_address, NEW.thing_type, NEW.start_date, NEW.start_time, NEW.end_date, NEW.end_time, NEW.opening_hours);
END $$

CREATE TRIGGER validate_transport_on_insert BEFORE INSERT ON transport
FOR EACH ROW
BEGIN
    CALL validate_transport(NEW.transport_id, NEW.email_address);
END $$

CREATE TRIGGER validate_transport_on_update BEFORE UPDATE ON transport
FOR EACH ROW
BEGIN
    CALL validate_transport(NEW.transport_id, NEW.email_address);
END $$

CREATE TRIGGER validate_books_on_insert BEFORE INSERT ON books
FOR EACH ROW
BEGIN
    CALL validate_books(NEW.thing_to_do_id, NEW.booking_id);
END $$

CREATE TRIGGER validate_books_on_update BEFORE UPDATE ON books
FOR EACH ROW
BEGIN
    CALL validate_books(NEW.thing_to_do_id, NEW.booking_id);
END $$

CREATE TRIGGER validate_books_room_on_insert BEFORE INSERT ON books_room
FOR EACH ROW
BEGIN
    CALL validate_books_room(NEW.room_id, NEW.booking_id);
END $$

CREATE TRIGGER validate_books_room_on_update BEFORE UPDATE ON books_room
FOR EACH ROW
BEGIN
    CALL validate_books_room(NEW.room_id, NEW.booking_id);
END $$

CREATE TRIGGER validate_books_transport_on_insert BEFORE INSERT ON books_transport
FOR EACH ROW
BEGIN
    CALL validate_books_transport(NEW.transport_id, NEW.booking_id);
END $$

CREATE TRIGGER validate_books_transport_on_update BEFORE UPDATE ON books_transport
FOR EACH ROW
BEGIN
    CALL validate_books_transport(NEW.transport_id, NEW.booking_id);
END $$
DELIMITER ;

-- Populate lookup tables with lists
INSERT INTO card_type VALUES
    ('','Visa Credit'),
    ('','Visa Debit'),
    ('','Mastercard Credit'),
    ('','Mastercard Debit')
;

INSERT INTO room_type VALUES
    ('','Single'),
    ('','Double'),
    ('','Twin'),
    ('','Suite'),
    ('','Apartment')
;

INSERT INTO room_price_basis VALUES
    ('','full board'),
    ('','half board'),
    ('','bed & breakfast'),
    ('','room only')
;

INSERT INTO booking_type VALUES
    ('','Accommodation'),
    ('','Activity'),
    ('','Attraction'),
    ('','Transport')
;

INSERT INTO transport_type VALUES
    ('','Bus'),
    ('','Train'),
    ('','Taxi'),
    ('','Hire Car')
;

INSERT INTO thing_type VALUES
    ('','Activity'),
    ('','Accommodation')
;

INSERT INTO activity_type VALUES
    ('','Cultural'),
    ('','Hiking'),
    ('','Climbing'),
    ('','Winter Sports')
;

INSERT INTO activity_price_basis VALUES
    ('','Per Day'),
    ('','Per Person'),
    ('','Per Person Per Day')
;

INSERT INTO attraction_type VALUES
    ('','Cultural')
;

INSERT INTO attraction_price_basis VALUES
    ('','Adult'),
    ('','Child'),
    ('','Concession')
;

INSERT INTO last_used_id VALUES ('0', 'c00000', 'a00000', 'r00000', 'b00000', 'v00000', 't00000');

