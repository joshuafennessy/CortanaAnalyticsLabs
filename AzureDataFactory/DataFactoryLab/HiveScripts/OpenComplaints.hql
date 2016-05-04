DROP TABLE IF EXISTS OpenComplaints;

CREATE EXTERNAL TABLE OpenComplaints 
(
   DateRecv     DATE,
   Age          INT,
   Company      STRING,
   ID           STRING,
   Product      STRING,
   Issue        STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED  BY ','
STORED AS TEXTFILE LOCATION '/OpenComplaints/';

INSERT OVERWRITE TABLE OpenComplaints
SELECT
   TO_DATE(from_unixtime(UNIX_TIMESTAMP(DateRecv, 'MM/dd/yyyy')))
   ,datediff(from_unixtime(unix_timestamp()),TO_DATE(from_unixtime(UNIX_TIMESTAMP(DateRecv, 'MM/dd/yyyy'))))
   ,Company
   ,ID
   ,Product
   ,Issue
FROM RawComplaints
WHERE 
   ResponseCust = 'In progress'
   AND DateRecv <>  'Date received';


--SELECT * FROM OpenComplaints LIMIT 100;
