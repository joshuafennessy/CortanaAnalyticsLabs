DROP TABLE IF EXISTS RawComplaints;
CREATE EXTERNAL TABLE RawComplaints (
   DateRecv         STRING,
   Product			STRING,
   SubProduct		STRING,
   Issue			STRING,
   SubIssue			STRING,
   Narrative		STRING,
   ResponsePub		STRING,
   Company			STRING,
   State			STRING,
   Zip				STRING,
   Tags             STRING,
   Consent          STRING,
   Src   			STRING,
   DateCompany		STRING,
   ResponseCust		STRING,
   Timely			STRING,
   Disputed			STRING,
   Id				STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED  BY ','
STORED AS TEXTFILE LOCATION '/RawComplaints/';