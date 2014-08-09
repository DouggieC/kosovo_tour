DELETE FROM credit_card;
DELETE FROM client;
DELETE FROM room;
DELETE FROM accommodation;

-- DELETE FROM client;
INSERT INTO client VALUES
     ("c00001","Doug","Cooper","144 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","19750508","02083331198","doug_cooper2000@yahoo.co.uk")
    ,("c00002","Justin","Sullivan","143 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","19560408","02083331198","justin.sullivan@nma.org.uk")
    ,("c00003","Stuart","Morrow","142 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","19580210","02083331198","stuart.morrow@nma.org.uk")
    ,("c00004","Rob","Heaton","145 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","19550701","02083331199","rob.heaton@nma.org.uk")
;
/*
     ("c00001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk"),
     ("a00001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk"),
     ("ca0001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk"),
     ("c00002","Justin","Sullivan","144 Perry Rise, London, SE23 2QP",19560408,"02083331198","justin.sullivan@nma"),
     ("c00003","Stuart","Morrow","144 Perry Rise, London, SE23 2QP",19580210,"02083331198","stuart.morrow.nma.org.uk"),
     ("c00004","Rob","Heaton","145 Perry Rise, London, SE23 2QP",20150701,"02083331199","rob.heaton@nma.org.uk")
;
*/

-- DELETE FROM credit_card;
-- DELETE FROM client;
-- INSERT INTO client VALUES ("c00001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk");
INSERT INTO credit_card (card_no,first_name,last_name,address_line_1,address_line_2,address_line_3,address_line_4,postcode,country,card_type,start_date,end_date,issue_no,ccv_code,client_id) VALUES
     ("1234567890123456","Doug","Cooper","144 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","2","20120101","20160331",NULL,"123","c00001")
    ,("2345678901234567","Doug","Cooper","144 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","1","20120101","20160331",NULL,"123","c00001")
    ,("3456789012345678","Justin","Sullivan","143 Perry Rise",NULL,NULL,"London","SE23 2QP","UK","3","20120101","20160331",NULL,"123","c00002")
;
/*
     ("1234567890123456","Douglas","Cooper","144 Perry Rise, London, SE23 2QP","Visa Debit","20120101","20160331",NULL,"123","c00001"),
     ("1234567890123456","Douglas","Cooper","144 Perry Rise, London, SE23 2QP","Visa Debit","20120101","20160331",NULL,"123","c00002"),
     ("1234567890123456","Douglas","Cooper","144 Perry Rise, London, SE23 2QP","Visa Debit","20120101","20110331",NULL,"123","c00002")
;
*/

-- DELETE FROM accommodation;
INSERT INTO accommodation VALUES
     ("a00001","Grand Hotel","Mother Teresa Boulevard",NULL,NULL,"Prishtina","10000","Kosova","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it's pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",NULL)
    ,("a00002","Hotel Prishtina","Rr. Pashko Vasa 20",NULL,NULL,"Prishtina","10000","Kosova","0038138220210","info@hotelprishtina.com","A hideous, gold-covered, neo-classical hotel near the centre of Prishtina. Large and new, but with typical local taste.","http://www.hotelprishtina.com",NULL)
    ,("a00003","Hotel Pinocchio","Rr 24 Maji 115","Dragodan",NULL,"Prishtina","10020","Kosova","0038138220210","pinocchiohotel-ks@hotmail.com","A small, friendly hotel in the Dragodan area of Prishtina, near several embassies. The restaurant is one of the best in town.","http://www.pinocchio-hotel.com",NULL)
    ,("a00004","Hotel Dukagjini","Sheshi i Deshmoreve 2",NULL,NULL,"Peja","30000","Kosova","0038138771177","info@hoteldukagjini.com","Some details about the Hotel Dukagjin","http://www.hoteldukagjini.com/",NULL)
    ,("a00005","Hangjik","Rr. Dardania","Runjeva",NULL,"Nr Kacanik","71000","Kosova","0038138771177","info@hangjik.com","Hangjik is a renovated traditional stone and adobe dwelling located in the valley of the River Nerodime between the Shar and Karadak mountains of southern Kosovo.  The nearest town is Kaçanik midway between the capital Pristina and the Macedonian capital Skopje.","http://www.hangjik.com/",NULL)
;
/*
     ("a00001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",NULL),
     ("r00001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",NULL),
     ("ar0001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",NULL)
;
*/

SET SESSION sql_mode = 'STRICT_ALL_TABLES';
-- DELETE FROM room WHERE 1>0;
-- DELETE FROM accommodation WHERE 1>0;
-- INSERT INTO accommodation VALUES ("a00001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",NULL);
INSERT INTO room VALUES
     ("r00001","A charming room with double bed and en suite bathroom.",2,2,120.00,1,"a00001")
    ,("r00002","A charming room with single bed and en suite bathroom.",1,1,80.00,1,"a00001")
    ,("r00003","A charming room with double bed and en suite bathroom.",2,2,130.00,2,"a00001")
    ,("r00004","A charming room with twin beds and en suite bathroom.",3,2,100.00,2,"a00001")
    ,("r00005","A charming room with double bed and en suite bathroom.",2,2,180.00,2,"a00002")
    ,("r00006","A charming room with single bed and en suite bathroom.",1,1,120.00,2,"a00002")
    ,("r00007","A charming room with double bed and en suite bathroom.",2,2,180.00,3,"a00003")
    ,("r00008","A charming room with single bed and en suite bathroom.",1,1,120.00,1,"a00003")
    ,("r00009","A charming room with double bed and en suite bathroom.",2,2,90.00,1,"a00004")
    ,("r00010","A beautiful apartment in a converted barn with cooking facilities.",5,4,220.00,4,"a00005")
    ,("r00011","A beautiful apartment in an old house with cooking facilities.",5,6,280.00,4,"a00005")
;

