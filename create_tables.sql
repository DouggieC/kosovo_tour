/*
********************************************************** 
* Name:    create_tables.sql
* Author:  Doug Cooper
* Version: 2.1
*
* Version History
* 1.0: Initial code
* 1.1: MySQL does not support CREATE DOMAIN.
*      Use standard types and add constraints
*      to table definition instead.
* 1.2: CHECK constraints unsupported too.
*      Rewritten to use triggers instead.
*      Enumerated lists added as ENUMs where appropriate.
* 2.0: Hefty rewrite to fully implement changes mentioned
*      in 1.1 & 1.2 above.
*      Also added error handling
* 2.1: Don't use MYSQL_ERRNO for user-defined errors. Changed to
*      Use SQLSTATE '45xxx' instead.
**********************************************************
*/

DROP PROCEDURE IF EXISTS validate_id;
DROP PROCEDURE IF EXISTS validate_email;
DROP PROCEDURE IF EXISTS validate_client;
DROP PROCEDURE IF EXISTS validate_credit_card;
DROP PROCEDURE IF EXISTS validate_accommodation;
DROP PROCEDURE IF EXISTS validate_room;
DROP PROCEDURE IF EXISTS validate_booking;
DROP PROCEDURE IF EXISTS validate_thing_to_do;
DROP PROCEDURE IF EXISTS validate_transport;
DROP PROCEDURE IF EXISTS validate_books;
DROP PROCEDURE IF EXISTS validate_books_room;
DROP PROCEDURE IF EXISTS validate_books_transport;

DROP TRIGGER IF EXISTS validate_client_on_insert;
DROP TRIGGER IF EXISTS validate_client_on_update;
DROP TRIGGER IF EXISTS validate_credit_card_on_insert;
DROP TRIGGER IF EXISTS validate_credit_card_on_update;
DROP TRIGGER IF EXISTS validate_accommodation_on_insert;
DROP TRIGGER IF EXISTS validate_accommodation_on_update;
DROP TRIGGER IF EXISTS validate_room_on_insert;
DROP TRIGGER IF EXISTS validate_room_on_update;
DROP TRIGGER IF EXISTS validate_booking_on_insert;
DROP TRIGGER IF EXISTS validate_booking_on_update;
DROP TRIGGER IF EXISTS validate_thing_to_do_on_insert;
DROP TRIGGER IF EXISTS validate_thing_to_do_on_update;
DROP TRIGGER IF EXISTS validate_transport_on_insert;
DROP TRIGGER IF EXISTS validate_transport_on_update;
DROP TRIGGER IF EXISTS validate_books_on_insert;
DROP TRIGGER IF EXISTS validate_books_on_update;
DROP TRIGGER IF EXISTS validate_books_room_on_insert;
DROP TRIGGER IF EXISTS validate_books_room_on_update;
DROP TRIGGER IF EXISTS validate_books_transport_on_insert;
DROP TRIGGER IF EXISTS validate_books_transport_on_update;

DROP TABLE IF EXISTS books_transport;
DROP TABLE IF EXISTS books_room;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS thing_to_do;
DROP TABLE IF EXISTS transport;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS accommodation;
DROP TABLE IF EXISTS credit_card;
DROP TABLE IF EXISTS client;

CREATE TABLE client (
    client_id CHAR(6) NOT NULL,
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
    card_type ENUM('Visa Credit', 'Visa Debit', 'Mastercard Credit', 'Mastercard Debit') NOT NULL,
    start_date DATE,
    end_date DATE NOT NULL,
    issue_no NUMERIC(3,0),
    ccv_code NUMERIC(3,0) NOT NULL,
    client_id CHAR(6) NOT NULL,

    PRIMARY KEY (card_no)
);

CREATE TABLE accommodation (
    accom_id CHAR(6) NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    description VARCHAR(1000),
    website_url VARCHAR(200),
    picture MEDIUMBLOB,

    PRIMARY KEY (accom_id)
);

CREATE TABLE room (
    room_id CHAR(6) NOT NULL,
    description VARCHAR(1000),
    room_type ENUM('Single', 'Double', 'Twin', 'Suite', 'Apartment') NOT NULL,
    capacity SMALLINT NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis ENUM('full board', 'half board', 'bed & breakfast', 'room only') NOT NULL,
    accom_id CHAR(6) NOT NULL,

    PRIMARY KEY (room_id)
);

CREATE TABLE booking (
    booking_id CHAR(6) NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    booking_type ENUM('Accommodation', 'Activity', 'Attraction', 'Transport') NOT NULL,
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
    transport_id CHAR(6) NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    website_url VARCHAR(200),
    description VARCHAR(1000),
    picture MEDIUMBLOB,
    transport_type ENUM('Plane', 'Bus', 'Train', 'Taxi', 'Hire Car') NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    price_basis VARCHAR(15) NOT NULL,

    PRIMARY KEY (transport_id)
);

CREATE TABLE thing_to_do (
    thing_to_do_id CHAR(6) NOT NULL,
    thing_type ENUM('Activity', 'Accommodation') NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    tel_no VARCHAR(15),
    email_address VARCHAR(40) NOT NULL,
    website_url VARCHAR(200),
    description VARCHAR(1000),
    picture MEDIUMBLOB,
    price DECIMAL(6,2) NOT NULL,
    price_basis ENUM('Per Day', 'Per Person', 'Per Person Per Day', 'Adult', 'Child', 'Concession') NOT NULL,

    -- Just for activities
    activity_type ENUM('Cultural', 'Hiking', 'Climbing', 'Winter Sports'), -- NOT NULL
    start_point VARCHAR(200),
    start_date DATE,
    start_time TIME,
    end_date DATE,
    end_time TIME,

    -- Just for attractions
    attraction_type ENUM('Cultural'), -- NOT NULL,
    opening_hours VARCHAR(100), -- NOT NULL,

    PRIMARY KEY (thing_to_do_id)
);

CREATE TABLE books (
    booking_id CHAR(6) NOT NULL,
    thing_to_do_id CHAR(6) NOT NULL,

    PRIMARY KEY (booking_id, thing_to_do_id)
);

CREATE TABLE books_room (
    booking_id CHAR(6) NOT NULL,
    room_id CHAR(6) NOT NULL,

    PRIMARY KEY (booking_id, room_id)
);

CREATE TABLE books_transport (
    booking_id CHAR(6) NOT NULL,
    transport_id CHAR(6) NOT NULL,

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
CREATE PROCEDURE validate_id (IN id CHAR(6), OUT exit_status INT)
BEGIN
    DECLARE id_pref CHAR(1);
    DECLARE id_suff CHAR(5);
    DECLARE id_name VARCHAR(25);
    DECLARE id_suff_int INT;

    SET id_pref = SUBSTR(id,1,1);
    SET id_suff = SUBSTR(id,2,5);
    SET id_suff_int = CAST(id_suff AS UNSIGNED INTEGER);

    CASE id_pref
        WHEN 'c' THEN SET id_name = 'Client';
        WHEN 'a' THEN SET id_name = 'Accommodation';
        WHEN 'r' THEN SET id_name = 'Room';
        WHEN 't' THEN SET id_name = 'Activity or attraction';
        WHEN 'v' THEN SET id_name = 'Transport';
        WHEN 'b' THEN SET id_name = 'Booking';
        ELSE CALL invalid_id;
    END CASE;

    IF id_suff_int NOT BETWEEN 00000 AND 99999
    THEN
        CALL invalid_id;
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_email (IN email_addr VARCHAR(40), OUT exit_status INT)
BEGIN
    IF (email_address NOT REGEXP '%@%\.%')
    THEN
        CALL invalid_email_address;
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_client (IN my_client_id CHAR(6), IN my_email_addr VARCHAR(40), IN my_dob DATE, OUT exit_status INT)
BEGIN
    -- Client IDs are c99999
    CALL validate_id(my_client_id);

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_addr);

    /* Constraint c2: A client's date of birth must be before the current date.
       That is, the value of the DateOfBirth attribute of an instance of the Client
       entity type must be before the current date.
    */
    IF (my_dob > CURRENT_DATE)
    THEN
        CALL invalid_date_of_birth;
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_credit_card (IN my_start_date DATE, IN my_end_date DATE, OUT exit_status INT)
BEGIN
    -- Start date must be before end date.
    IF (my_start_date >= my_end_date)
    THEN
        CALL invalid_credit_card_date_range;
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_accommodation(IN my_accom_id CHAR(6), IN my_email_addr VARCHAR(40), OUT exit_status INT)
BEGIN
    -- Accommodation IDs are a99999
    CALL validate_id(my_accom_id);

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_addr);

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_room (IN my_room_id CHAR(6), IN my_capacity SMALLINT, OUT exit_status INT)
BEGIN
    -- Room IDs are r99999
    CALL validate_id(my_room_id);

    IF (my_capacity NOT BETWEEN 1 AND 10)
    THEN
        CALL room_capacity_out_of_range();
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_booking (IN my_booking_id CHAR(6), IN my_client_id CHAR(6), IN my_booking_type VARCHAR(13), OUT exit_status INT)
BEGIN
    -- Booking IDs are b99999
    CALL validate_id(my_booking_id);

    -- Client IDs are c99999
    CALL validate_id(my_client_id);

    /* Constraint c1: A Booking entity must take part in exactly one occurrence of
       either the BookingB, BookingBR or BookingBT relationship.
    */
    IF (NOT ((my_booking_type = 'Accommodation'
               AND (my_booking_id IN
                    (SELECT DISTINCT booking_id FROM books_room))
              ) OR
               (my_booking_type IN ('Activity', 'Attraction')
               AND (my_booking_id IN
                    (SELECT DISTINCT booking_id FROM books))
              ) OR
               (my_booking_type = 'Transport'
               AND (booking_id IN
                    (SELECT DISTINCT booking_id FROM books_transport))
              ))
        )
    THEN
        CALL booking_incorrect();
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_thing_to_do (IN my_thing_to_do_id CHAR(6), IN my_email_addr VARCHAR(40), IN my_thing_type VARCHAR(10),
                                       IN my_activity_type VARCHAR(13), IN my_attraction_type VARCHAR(8), IN my_start_date DATE,
                                       IN my_start_time TIME, IN my_end_date DATE, IN my_end_time TIME, IN my_opening_hours VARCHAR(100),
                                       OUT exit_status INT)
BEGIN
    -- ThingToDo IDs are t99999
    CALL validate_id(my_thing_to_do_id);

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_address);

    IF (my_thing_type = 'Activity')
    THEN
        -- NOT NULL constraint for activity type
        IF (my_activity_type IS NULL)
        THEN
            CALL null_activity_type();
        END IF;

        -- NOT NULL constraint for start date and time
        IF (my_start_date IS NULL OR my_start_time IS NULL)
        THEN
            CALL null_start_date_time();
        END IF;

        -- Constraint c4: An activitys end date must be on or after its start date.
        -- Constraint c5: If an activity starts and ends on the same day, the end time must be after the start time.
        IF (NOT ((my_start_date < my_end_date) OR
                ((my_start_date = my_end_date) AND
                 (my_start_time < my_end_time)))
            )
        THEN
            CALL invalid_activity_start_date_time();
        END IF;
    ELSEIF (my_thing_type = 'Attraction')
    THEN
        -- NOT NULL constraint for attraction type
        IF (my_attraction_type IS NULL)
        THEN
            CALL null_attraction_type();
        END IF;

        -- NOT NULL constraint for opening hours
        IF (my_opening_hours IS NULL)
        THEN
            CALL null_opening_hours();
        END IF;
    ELSE
        CALL invalid_thing_to_do_type();
    END IF;

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_transport (IN my_transport_id CHAR(6), IN my_email_addr VARCHAR(40), OUT exit_status INT)
BEGIN
    -- Transport IDs are v99999 (v for vehicle - t already used for thing_to_do)
    CALL validate_id(my_transport_id);

    -- Email address must have the form <name>@<host>.<domain>
    CALL validate_email(my_email_address);

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_books (IN my_thing_to_do_id CHAR(6), IN my_booking_id CHAR(6), OUT exit_status INT)
BEGIN
    -- Thing-to-do IDs are t99999
    CALL validate_id(my_thing_to_do_id);

    -- Booking IDs are b99999
    CALL validate_id(my_booking_id);

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_books_room (IN my_room_id CHAR(6), IN my_booking_id CHAR(6), OUT exit_status INT)
BEGIN
    -- Room IDs are r99999
    CALL validate_id(my_room_id);

    -- Booking IDs are b99999
    CALL validate_id(my_booking_id);

    SET exit_status = 0;
END $$

CREATE PROCEDURE validate_books_transport (IN my_transport_id CHAR(6), IN my_booking_id CHAR(6), OUT exit_status INT)
BEGIN
    -- Transport IDs are v99999
    CALL validate_id(my_transport_id);

    -- Booking IDs are b99999
    CALL validate_id(my_booking_id);

    SET exit_status = 0;
END $$
DELIMITER ;

CREATE TRIGGER validate_client_on_insert BEFORE INSERT ON client
FOR EACH ROW
BEGIN
    CALL validate_client(NEW.client_id, NEW.email_address, NEW.date_of_birth);
END

CREATE TRIGGER validate_client_on_update BEFORE UPDATE ON client
FOR EACH ROW
BEGIN
    CALL validate_client(NEW.client_id, NEW.email_address, NEW.date_of_birth);
END

CREATE TRIGGER validate_credit_card_on_insert BEFORE INSERT ON credit_card
FOR EACH ROW
BEGIN
    CALL validate_credit_card(NEW.start_date, NEW.end_date);
END

CREATE TRIGGER validate_credit_card_on_update BEFORE UPDATE ON credit_card
FOR EACH ROW
BEGIN
    CALL validate_credit_card(NEW.start_date, NEW.end_date);
END

CREATE TRIGGER validate_accommodation_on_insert BEFORE INSERT ON accommodation
FOR EACH ROW
BEGIN
    CALL validate_accommodation(NEW.accom_id, NEW.email_address);
END

CREATE TRIGGER validate_accommodation_on_update BEFORE UPDATE ON accommodation
FOR EACH ROW
BEGIN
    CALL validate_accommodation(NEW.accom_id, NEW.email_address);
END

CREATE TRIGGER validate_room_on_insert BEFORE INSERT ON room
FOR EACH ROW
BEGIN
    CALL validate_room(NEW.room_id, NEW.capacity);
END

CREATE TRIGGER validate_room_on_update BEFORE UPDATE ON room
FOR EACH ROW
BEGIN
    CALL validate_room(NEW.room_id, NEW.capacity);
END

CREATE TRIGGER validate_booking_on_insert BEFORE INSERT ON booking
FOR EACH ROW
BEGIN
    CALL validate_booking(NEW.booking_id, NEW.client_id, NEW.booking_type);
END

CREATE TRIGGER validate_booking_on_update BEFORE UPDATE ON booking
FOR EACH ROW
BEGIN
    CALL validate_booking(NEW.booking_id, NEW.client_id, NEW.booking_type);
END

CREATE TRIGGER validate_thing_to_do_on_insert BEFORE INSERT ON thing_to_do
FOR EACH ROW
BEGIN
    CALL validate_thing_to_do(NEW.thing_to_do_id, NEW.email_address, NEW.thing_type, NEW.activity_type,
                              NEW.attraction_type, NEW.start_date, NEW.start_time, NEW.end_date, NEW.end_time, NEW.opening_hours);
END

CREATE TRIGGER validate_thing_to_do_on_update BEFORE UPDATE ON thing_to_do
FOR EACH ROW
BEGIN
    CALL validate_thing_to_do(NEW.thing_to_do_id, NEW.email_address, NEW.thing_type, NEW.start_date, NEW.start_time, NEW.end_date, NEW.end_time, NEW.opening_hours);
END

CREATE TRIGGER validate_transport_on_insert BEFORE INSERT ON transport
FOR EACH ROW
BEGIN
    CALL validate_transport(NEW.transport_id, NEW.email_address);
END

CREATE TRIGGER validate_transport_on_update BEFORE UPDATE ON transport
FOR EACH ROW
BEGIN
    CALL validate_transport(NEW.transport_id, NEW.email_address);
END

CREATE TRIGGER validate_books_on_insert BEFORE INSERT ON books
FOR EACH ROW
BEGIN
    CALL validate_books(NEW.thing_to_do_id, NEW.booking_id);
END

CREATE TRIGGER validate_books_on_update BEFORE UPDATE ON books
FOR EACH ROW
BEGIN
    CALL validate_books(NEW.thing_to_do_id, NEW.booking_id);
END

CREATE TRIGGER validate_books_room_on_insert BEFORE INSERT ON books_room
FOR EACH ROW
BEGIN
    CALL validate_books_room(NEW.room_id, NEW.booking_id);
END

CREATE TRIGGER validate_books_room_on_update BEFORE UPDATE ON books_room
FOR EACH ROW
BEGIN
    CALL validate_books_room(NEW.room_id, NEW.booking_id);
END

CREATE TRIGGER validate_books_transport_on_insert BEFORE INSERT ON books_transport
FOR EACH ROW
BEGIN
    CALL validate_books_transport(NEW.transport_id, NEW.booking_id);
END

CREATE TRIGGER validate_books_transport_on_update BEFORE UPDATE ON books_transport
FOR EACH ROW
BEGIN
    CALL validate_books_transport(NEW.transport_id, NEW.booking_id);
END

