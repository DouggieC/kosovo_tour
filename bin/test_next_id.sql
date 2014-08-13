DROP PROCEDURE IF EXISTS test_next_id;

DELIMITER $$

CREATE PROCEDURE test_next_id (IN my_id_type CHAR(1), OUT next_id CHAR(6))
BEGIN
    -- DECLARE id_pref CHAR(1);
    -- DECLARE id_suff CHAR(5);
    -- DECLARE id_suff_int INT;
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

    /*
    SET id_pref = SUBSTR(curr_id,1,1);
    SET id_suff = SUBSTR(curr_id,2,5);
    SET id_suff_int = CAST(id_suff AS UNSIGNED INTEGER) + 1;

    SET next_id = CONCAT(id_pref, id_suff_int);
    */

    -- Increment the last used ID to get the new one, and assign to output variable
    SET next_id = CONCAT(SUBSTR(@curr_id,1,1), LPAD(CAST(SUBSTR(@curr_id,2,5) AS UNSIGNED INTEGER) + 1,5,'0'));

    -- Update the table with the new ID
    -- SET @t1 := CONCAT('UPDATE last_used_id SET ', id_field, '=', next_id, ' WHERE last_used_pk = 0');
    -- SET @t1 := CONCAT('UPDATE last_used_id SET ', id_field, '= ? WHERE last_used_pk = 0');
    SET @t1 := CONCAT('UPDATE last_used_id SET ', id_field, '= ?');
    SET @update_id = next_id;
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING @update_id;
    DEALLOCATE PREPARE stmt;

END $$

DELIMITER ;

CALL test_next_id('a', @myId);

SELECT CONCAT('@myId: /', @myId, '/');
