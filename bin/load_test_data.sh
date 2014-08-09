#!/bin/bash

dbhost='localhost'
dbname='kostour'
dbuser='ksadmin'
dbpass='HzTdNxsamcupLWZxGohO'

mysqlimport -c client_id,first_name,last_name,address_line_1,address_line_2,address_line_3,address_line_4,postcode,country,date_of_birth,tel_no,email_address \
            -h"$dbhost" -u"$dbuser" -p"$dbpass" --fields-terminated-by=',' --lines-terminated-by='\n' --fields-optionally-enclosed-by='"' --ignore-lines=1 \
            $dbname --delete test_data/client.csv;

#mysqlimport -c card_no,first_name,last_name,address_line_1,address_line_2,address_line_3,address_line_4,postcode,country,card_type,start_date,end_date,issue_no,ccv_code,client_id \
#            -h$dbhost -u"$dbuser" -p"$dbpass" --fields-terminated-by=',' --lines-terminated-by='\n' --fields-optionally-enclosed-by='"' --ignore-lines=1 \
#            $dbname --delete test_data/credit_card.csv;

#mysqlimport -c accom_id,name,address_line_1,address_line_2,address_line_3,address_line_4,postcode,country,tel_no,email_address,description,website_url \
#            -h$dbhost -u"$dbuser" -p"$dbpass" --fields-terminated-by=',' --lines-terminated-by='\n' --fields-optionally-enclosed-by='"' --ignore-lines=1 \
#            $dbname --delete test_data/accommodation.csv;


#mysqlimport -c accom_id,name,address_line_1,address_line_2,address_line_3,address_line_4,postcode,country,tel_no,email_address,description,website_url \
#            -h$dbhost -u"$dbuser" -p"$dbpass" --fields-terminated-by=',' --lines-terminated-by='\n' --fields-optionally-enclosed-by='"' --ignore-lines=1 \
#            $dbname --delete test_data/accommodation.csv;
