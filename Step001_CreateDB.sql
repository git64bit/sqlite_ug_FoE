-- Create the sqlite_ug_FoE.sqlite3 database file before running this script
-- Creating the auditor table
CREATE TABLE FoE_aaAuditor (
  aaPK INTEGER PRIMARY KEY AUTOINCREMENT
, aaToken VARCHAR (64)
, aaTable VARCHAR (64)
, aaROWID INTEGER (8)
, aaSQLText TEXT
, aaUUID CHAR (36)
, dbStatusID INTEGER (4)
, aaTimeStamp DEFAULT CURRENT_TIMESTAMP);
INSERT INTO FoE_aaAuditor (
  aaToken
, aaTable
, aaROWID
, aaSQLText
, aaUUID
, dbStatusID)
VALUES(
  'CREATE'
, 'FoE_aaAuditor'
, 0
, ''
, '96d6b400-e237-11e5-bef5-0002a5d5c51b'
, 0);
-- END of creating the auditor table
--
-- Creating the self-documentation table
CREATE TABLE FoE_ddSelfDoc (
  aaPK INTEGER PRIMARY KEY AUTOINCREMENT
, ddToken VARCHAR (64)
, ddText TEXT
, dbStatusID INTEGER (4)
, aaTimeStamp DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO FoE_aaAuditor (
  aaToken
, aaTable
, aaROWID
, aaSQLText
, aaUUID
, dbStatusID)
VALUES(
  'CREATE'
, 'FoE_ddSelfDoc'
, last_insert_rowid()
, ''
, '96d6b400-e237-11e5-bef5-0002a5d5c51b'
, 0);
-- END of creating the self-documentation table
--
-- Creating the AFTER INSERT Trigger
CREATE TRIGGER "tgINSERT-AFTER_FoE_SelfDoc" AFTER INSERT ON FoE_ddSelfDoc FOR EACH ROW BEGIN INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaUUID, dbStatusID)
VALUES ('INSERT', 'FoE_ddSelfDoc', last_insert_rowid(), '96d6b400-e237-11e5-bef5-0002a5d5c51b', 0); END;
-- END of creating the AFTER INSERT trigger
--
-- Creating the AFTER UPDATE Trigger
CREATE TRIGGER "tgUPDATE-AFTER_FoE_SelfDoc" AFTER UPDATE ON FoE_ddSelfDoc FOR EACH ROW BEGIN INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaSQLText, aaUUID, dbStatusID)
VALUES ('UPDATE', 'FoE_ddSelfDoc', OLD.aaPK,
'PREW-ddToken: ' || OLD.ddToken ||'~PREW-ddText: ' || OLD.ddText || '~PREW-dbStatusID: ' || OLD.dbStatusID || '~PREW-aaTimeStamp: ' || OLD.aaTimeStamp, 
'96d6b400-e237-11e5-bef5-0002a5d5c51b', 0); END;
-- END of creating the AFTER UPDATE trigger
--
-- Documenting the database 
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgINSERT-AFTER_FoE_ddSelfDoc','Trigger in the ddSelfDoc table, records INSERTs', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgUPDATE-AFTER_FoE_ddSelfDoc','Trigger in the ddSelfDoc table, records UPDATEs. Note, deleting a record should be done by updating the dbStatusID in place of using DELETE', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('FoE_aaAuditor','Audit data table to record all database activities related to INSERT, SELECT and UPDATE. DELETE is not recorded - so purging by scripts do not record itself', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('FoE_ddSelfDoc','Data table describing table names, field names and other text used repeatedly throughout the database', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('aaToken','A field in the FoE_aaAuditor table, holding a single word entry. It describes most standard SQL activities - such as INSERT or UPDATE for records, AUTO for automated processes, etc. It should be a single word - but this rule is not checked or enforced by the database.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('aaTable','A field in the FoE_aaAuditor table, holding the name of the database table which was the target of the activity shown in the aaToken field.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('aaSQLText','Before UPDATE the entire record is concanated and copied here as a audit and roll-back measure', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('aaUUID','A field in the FoE_aaAuditor table, holding the ID of the user who performed the database activity. NOTE: This is currently set to a single ID owned by the database owner, or the approved scripts. This is not intended for fine-grained user activity audit but for some fundamental database usage recording', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbStatusID','This is a standard field, present in every data table. Its value could be made to relate to a record in a dbStatus table, describing the most relevant information about the record. When this is 0 (zero), there is no issue and the status is all clear.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('aaTimeStamp','This is a standard field, present in every data table. It holds the UNC time when the record was first created. This is a static field - it does not get updated.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('ddToken','The name of a database, its tables, fields and other designators. It also contains a dictionary of database-related values, such as the entry 0xFFFF, which is assigned to show an error status and holds a standard error message.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('ddText','Describes the purpose of the record entry - such as this text', 0);
-- END of documenting the database
--
-- Creating the Standardized Database Messages table
CREATE TABLE FoE_dbMessages ( 
  aaPK INTEGER PRIMARY KEY AUTOINCREMENT
, dbID INTEGER (8) NOT NULL
, dbTableName VARCHAR (32) NOT NULL DEFAULT ''
, dbMessageCategory CHAR (3) NOT NULL DEFAULT '-K-'
, dbMessagePriority INTEGER NOT NULL DEFAULT 0
, dbMessageTitle VARCHAR (64) NOT NULL DEFAULT 'Status: OK'
, dbMessageText TEXT NOT NULL DEFAULT 'This is the default status message: nothing to report.'
, dbStatusID INTEGER (4) 
, aaTimeStamp DEFAULT CURRENT_TIMESTAMP);
INSERT INTO FoE_aaAuditor (
  aaToken
, aaTable
, aaROWID
, aaSQLText
, aaUUID
, dbStatusID) 
VALUES(
  'CREATE'
, 'FoE_dbMessages'
, 0
, ''
, '96d6b400-e237-11e5-bef5-0002a5d5c51b'
, 0);
-- END of creating the Standard Database Messages table
--
-- Creating the AFTER INSERT Trigger
CREATE TRIGGER "tgINSERT-AFTER_FoE_dbMessages" AFTER INSERT ON FoE_dbMessages FOR EACH ROW BEGIN INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaUUID, dbStatusID)
VALUES ('INSERT', 'FoE_dbMessages', last_insert_rowid(), '96d6b400-e237-11e5-bef5-0002a5d5c51b', 0); END;
-- END of creating the AFTER INSERT trigger
--
-- Creating the AFTER UPDATE Trigger
CREATE TRIGGER "tgUPDATE-AFTER_FoE_dbMessages" AFTER UPDATE ON FoE_dbMessages FOR EACH ROW BEGIN INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaSQLText, aaUUID, dbStatusID)
VALUES ('UPDATE', 'FoE_dbMessages', OLD.aaPK,
'~PREW-dbID: ' || OLD.dbID ||
'~PREW-dbTableName: ' || OLD.dbTableName ||
'~PREW-dbMessageCategory: ' || OLD.dbMessageCategory ||
'~PREW-dbMessagePriority: ' || OLD.dbMessagePriority ||
'~PREW-dbMessageTitle: ' || OLD.dbMessageTitle ||
'~PREW-dbMessageText: ' || OLD.dbMessageText ||
'~PREW-dbStatusID: ' || OLD.dbStatusID ||
'~PREW-aaTimeStamp: ' || OLD.aaTimeStamp,  
'96d6b400-e237-11e5-bef5-0002a5d5c51b', 0); END;
-- END of creating the AFTER UPDATE trigger
--
-- Documenting the database 
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgINSERT-AFTER_FoE_dbMessages','Trigger in the ddSelfDoc table, records INSERTs', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgUPDATE-AFTER_FoE_dbMessages','Trigger in the ddSelfDoc table, records UPDATEs. Note, deleting a record should be done by updating the dbStatusID in place of using DELETE', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('FoE_dbMessages','This table holds all messages that may be standardized and reused, for the purpose of communicating with both the administrators and the end users.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbID','This fields holds the values in the standard dbStatusID, which is part of every table. The default value 0 (zero) is created when the FoE_dbMessages table was created.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbTableName','Holds the name of the table where the message is specific to that table. Otherwise this field holds an empty string - NOT a NULL, but an empty string.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbMessageCategory','Any 3-character string, may be used to group messages that may or may not standardized.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbMessagePriority','Any negative or positive integer, may be used to prioritize by non-standardized ways.', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbMessageTitle','A brief description only', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('dbMessageText','Full message details. External links and references may be included - but note that those are not quaranteed to stay accurate or available, so duplicate the info here as much as possible.', 0);
-- END of documenting the database
