/*
DELETE FROM client;
INSERT INTO client VALUES
    ("c00001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk"),
    ("a00001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk"),
    ("ca0001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk"),
    ("c00002","Justin","Sullivan","144 Perry Rise, London, SE23 2QP",19560408,"02083331198","justin.sullivan@nma"),
    ("c00003","Stuart","Morrow","144 Perry Rise, London, SE23 2QP",19580210,"02083331198","stuart.morrow.nma.org.uk"),
    ("c00004","Rob","Heaton","145 Perry Rise, London, SE23 2QP",20150701,"02083331199","rob.heaton@nma.org.uk")
;
*/

/*
DELETE FROM credit_card;
DELETE FROM client;
INSERT INTO client VALUES ("c00001","Doug","Cooper","144 Perry Rise, London, SE23 2QP",19750508,"02083331198","doug_cooper2000@yahoo.co.uk");
INSERT INTO credit_card VALUES
    ("1234567890123456","Douglas","Cooper","144 Perry Rise, London, SE23 2QP","Visa Debit","20120101","20160331","","123","c00001"),
    ("1234567890123456","Douglas","Cooper","144 Perry Rise, London, SE23 2QP","Visa Debit","20120101","20160331","","123","c00002"),
    ("1234567890123456","Douglas","Cooper","144 Perry Rise, London, SE23 2QP","Visa Debit","20120101","20110331","","123","c00002")
;
*/

/*
DELETE FROM accommodation;
INSERT INTO accommodation VALUES
    ("a00001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",""),
    ("r00001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com",""),
    ("ar0001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com","")
;
*/

/*
SET SESSION sql_mode = 'STRICT_ALL_TABLES';
DELETE FROM room WHERE 1>0;
DELETE FROM accommodation WHERE 1>0;
INSERT INTO accommodation VALUES ("a00001","Grand Hotel","Mother Teresa Boulevard, 10000 Prishtina","0038138220210","info@grandhotel-pr.com","A communist-era concrete monstrosity blighting the centre of Prishtina. No idea how many rooms it has but it\'s pretty big. Not recommended for anything except demolition.","http://www.grandhotel-pr.com","");
INSERT INTO room VALUES
     ("r00001","A charming room with double bed and en suite bathroom.","Double",2,120.00,"full board","a00001")
    ,("a00001","A charming room with double bed and en suite bathroom.","Double",2,120.00,"full board","a00001")
    ,("ra0001","A charming room with double bed and en suite bathroom.","Double",2,120.00,"full board","a00001")
    ,("r00002","A charming room with double bed and en suite bathroom.","Double",12,120.00,"full board","a00001")
    ,("r00003","A charming room with double bed and en suite bathroom.","Palace",2,120.00,"full board","a00001")
    ,("r00004","A charming room with double bed and en suite bathroom.","Double",2,120.00,"full badger","a00001")
    ,("r00005","A charming room with double bed and en suite bathroom.","Double",2,120.00,"full board","a00002")
;
*/

