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
--
-- Creating the Coins Buildings table
CREATE TABLE FoE_CxBuildings ( 
  aaPK INTEGER PRIMARY KEY AUTOINCREMENT
, CxID INTEGER (8) NOT NULL
, CxName VARCHAR (64) NOT NULL
, CxAge VARCHAR (32) NOT NULL
, CxTech VARCHAR (32) NOT NULL
, CxPopCount INTEGER (4) NOT NULL
, CxCoinYield INTEGER (4) NOT NULL
, CxYieldCycle INTEGER (4) NOT NULL
, CxSWPixels INTEGER (2) NOT NULL
, CxNWPixels INTEGER (2) NOT NULL
, CxRoadWidth INTEGER (2) NOT NULL
, CxBuildTime INTEGER (4) NOT NULL
, CxBuildDiamonds INTEGER (4) NOT NULL
, CxBuildCoins INTEGER (4) NOT NULL
, CxBuildSupplies INTEGER (4) NOT NULL
, CxSellCoins INTEGER (4) DEFAULT 0
, CxSellSupplies INTEGER (4) DEFAULT 0
, CxCF_PopPerSQR REAL (4, 2) DEFAULT 0.00
, CxCF_CoinsPerSQR REAL (4, 2) DEFAULT 0.00
, CxCF_SecondsPerCoinPerPop REAL (4, 2) DEFAULT 0.00
, CxCF_SecondsPerCoinPerSQR REAL (4, 2) DEFAULT 0.00
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
, 'FoE_CxBuildings'
, 0
, ''
, '96d6b400-e237-11e5-bef5-0002a5d5c51b'
, 0);
-- END of creating the Coins Buildings table
--
-- Creating the AFTER INSERT Trigger
CREATE TRIGGER "tgINSERT-AFTER_FoE_CxBuildings" AFTER INSERT ON FoE_CxBuildings FOR EACH ROW BEGIN 
-- Task One Update Audit
INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaUUID, dbStatusID)
VALUES ('INSERT', 'FoE_CxBuildings', last_insert_rowid(), '96d6b400-e237-11e5-bef5-0002a5d5c51b', 0);
-- Task Two Calculate Fields
UPDATE FoE_CxBuildings SET 
  CxCF_PopPerSQR = ((CxPopCount*1.0) / ((CxSWPixels*1.0)*(CxNWPixels*1.0)))
, CxCF_CoinsPerSQR = ((CxCoinYield*1.0) / ((CxSWPixels*1.0)*(CxNWPixels*1.0)))
, CxCF_SecondsPerCoinPerPop = ((CxYieldCycle*1.0) / ((CxPopCount*1.0) / (CxCoinYield*1.0)))
, CxCF_SecondsPerCoinPerSQR = (((CxYieldCycle*1.0) / (CxCoinYield*1.0)) / ((CxSWPixels*1.0)*(CxNWPixels*1.0)))
WHERE aaPK = NEW.aaPK; END;
-- END of creating the AFTER INSERT trigger
--
-- Creating the AFTER UPDATE Trigger
CREATE TRIGGER "tgUPDATE-AFTER_FoE_CxBuildings" AFTER UPDATE ON FoE_CxBuildings FOR EACH ROW BEGIN INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaSQLText, aaUUID, dbStatusID)
VALUES ('UPDATE', 'FoE_CxBuildings', OLD.aaPK,
'PREW-CxID: ' || OLD.CxID ||
'~PREW-CxName: ' || OLD.CxName ||
'~PREW-CxAge: ' || OLD.CxAge ||
'~PREW-CxTech: ' || OLD.CxTech ||
'~PREW-CxPopCount: ' || OLD.CxPopCount ||
'~PREW-CxCoinYield: ' || OLD.CxCoinYield ||
'~PREW-CxYieldCycle: ' || OLD.CxYieldCycle ||
'~PREW-CxSWPixels: ' || OLD.CxSWPixels ||
'~PREW-CxNWPixels: ' || OLD.CxNWPixels ||
'~PREW-CxRoadWidth: ' || OLD.CxRoadWidth ||
'~PREW-CxBuildTime: ' || OLD.CxBuildTime ||
'~PREW-CxBuildDiamonds: ' || OLD.CxBuildDiamonds ||
'~PREW-CxBuildCoins: ' || OLD.CxBuildCoins ||
'~PREW-CxBuildSupplies: ' || OLD.CxBuildSupplies ||
'~PREW-CxSellCoins: ' || OLD.CxSellCoins ||
'~PREW-CxSellSupplies: ' || OLD.CxSellSupplies ||
'~PREW-CxCF_PopPerSQR: ' || OLD.CxCF_PopPerSQR ||
'~PREW-CxCF_CoinsPerSQR: ' || OLD.CxCF_CoinsPerSQR ||
'~PREW-CxCF_SecondsPerCoinPerPop: ' || OLD.CxCF_SecondsPerCoinPerPop ||
'~PREW-CxCF_SecondsPerCoinPerSQR: ' || OLD.CxCF_SecondsPerCoinPerSQR ||
'~PREW-dbStatusID: ' || OLD.dbStatusID ||
'~PREW-aaTimeStamp: ' || OLD.aaTimeStamp, 
'96d6b400-e237-11e5-bef5-0002a5d5c51b', 0); END;
-- END of creating the AFTER UPDATE trigger
--
-- Documenting the database 
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgINSERT-AFTER_FoE_CxBuildings','Trigger in the FoE_CxBuildings table, records new record insertions', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgUPDATE-AFTER_FoE_CxBuildings','Trigger in the FoE_CxBuildings table, records updates', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('FoE_CxBuildings','Data table, holding game information about houses', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxID','Manually generated. The table has auto primary key, so if this is not needed then ignore', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxName','The name of the house as it appears in the game interface', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxAge','The age where the house first becomes available', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxTech','The name of the Technology which unlocks it', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxPopCount','Population count, assumes not up-gradable houses', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxCoinYield','The amount of coins this house generates', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxYieldCycle','The time in seconds it takes to generate the coins', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxSWPixels','Size alongside the SW-NE edge', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxNWPixels','Size alongside the NW-SE edge', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxRoadWidth','The width of road required in pixels - 0 when none required', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxBuildTime','The number of seconds it takes to build', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxBuildDiamonds','The building cost in Diamonds', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxBuildCoins','The coin part of the building cost', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxBuildSupplies','The supply part of the building cost', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxSellCoins','Coins recovered by selling this house, set to -1 when not yet recorded', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxSellSupplies','Supplies recovered by selling this house, set to -1 when not yet recorded', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxCF_PopPerSQR','Calculated Field (CF) as CxCF_PopPerSQR = (CxPopCount / (CxSWPixels*CxNWPixels))', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxCF_CoinsPerSQR','Calculated Field (CF) as CxCF_CoinsPerSQR = (CxCoinYield / (CxSWPixels*CxNWPixels))', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxCF_SecondsPerCoinPerPop','Calculated Field (CF) as CxCF_SecondsPerCoinPerPop = (CxYieldCycle /(CxPopCount / CxCoinYield))', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('CxCF_SecondsPerCoinPerSQR','Calculated Field (CF) as CxCF_SecondsPerCoinPerSQR = ((CxYieldCycle / CxCoinYield) / (CxSWPixels*CxNWPixels)) ', 0);
-- END of documenting the database
--
-- Creating the Supply Buildings table
CREATE TABLE FoE_SxBuildings ( 
  aaPK INTEGER PRIMARY KEY AUTOINCREMENT
, SxID INTEGER (8) NOT NULL
, SxName VARCHAR (64) NOT NULL
, SxAge VARCHAR (32) NOT NULL
, SxTech VARCHAR (32) NOT NULL
, SxPopRequired INTEGER (4) NOT NULL
, SxSupplyYieldFiveMinutes_AA INTEGER (4) NOT NULL
, SxSupplyYieldFifteenMinutes_BB INTEGER (4) NOT NULL
, SxSupplyYieldOneHour_CC INTEGER (4) NOT NULL
, SxSupplyYieldFourHours_DD INTEGER (4) NOT NULL
, SxSupplyYieldEightHours_EE INTEGER (4) NOT NULL
, SxSupplyYieldOneDay_FF INTEGER (4) NOT NULL
, SxSupplyYieldTwoDays_GG INTEGER (4) NOT NULL
, SxSWPixels INTEGER (2) NOT NULL
, SxNWPixels INTEGER (2) NOT NULL
, SxRoadWidth INTEGER (2) NOT NULL
, SxBuildTime INTEGER (4) NOT NULL
, SxBuildDiamonds INTEGER (4) NOT NULL
, SxBuildCoins INTEGER (4) NOT NULL
, SxBuildSupplies INTEGER (4) NOT NULL
, SxSellCoins INTEGER (4) DEFAULT 0
, SxSellSupplies INTEGER (4) DEFAULT 0
, SxCF_AA_Rate_BB REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Rate_CC REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Rate_DD REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Rate_EE REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Rate_FF REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Rate_GG REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Per_Pop REAL (4, 2) DEFAULT 0.00
, SxCF_AA_Per_SQR REAL (4, 2) DEFAULT 0.00
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
, 'FoE_SxBuildings'
, 0
, ''
, '96d6b400-e237-11e5-bef5-0002a5d5c51b'
, 0);
-- END of creating the Supply Buildings table
--
-- Creating the AFTER INSERT Trigger
CREATE TRIGGER "tgINSERT-AFTER_FoE_SxBuildings" AFTER INSERT ON FoE_SxBuildings FOR EACH ROW BEGIN 
-- Task One Update Audit
INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaUUID, dbStatusID)
VALUES ('INSERT', 'FoE_SxBuildings', last_insert_rowid(), '96d6b400-e237-11e5-bef5-0002a5d5c51b', 0);
-- Task Two Calculate Fields
UPDATE FoE_SxBuildings SET 
  -- SxCF_AA_Rate_BB = ((SxSupplyYieldFifteenMinutes_BB*1.0) / 3.0)
  SxCF_AA_Rate_BB = ((((SxSupplyYieldFifteenMinutes_BB*1.0) / 3.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)
, SxCF_AA_Rate_CC = ((((SxSupplyYieldOneHour_CC*1.0) / 12.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)
, SxCF_AA_Rate_DD = ((((SxSupplyYieldFourHours_DD*1.0) / 48.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)
, SxCF_AA_Rate_EE = ((((SxSupplyYieldEightHours_EE*1.0) / 96.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)
, SxCF_AA_Rate_FF = ((((SxSupplyYieldOneDay_FF*1.0) / 288.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)
, SxCF_AA_Rate_GG = ((((SxSupplyYieldTwoDays_GG*1.0) / 576.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)
, SxCF_AA_Per_Pop = (SxSupplyYieldFiveMinutes_AA*1.0) / (SxPopRequired*1.0)
, SxCF_AA_Per_SQR = ((SxSupplyYieldFiveMinutes_AA*1.0) / ((SxSWPixels*1.0)*(SxNWPixels*1.0)))
WHERE aaPK = NEW.aaPK; END;
-- END of creating the AFTER INSERT trigger
--
-- Creating the AFTER UPDATE Trigger
CREATE TRIGGER "tgUPDATE-AFTER_FoE_SxBuildings" AFTER UPDATE ON FoE_SxBuildings FOR EACH ROW BEGIN INSERT INTO FoE_aaAuditor (aaToken, aaTable, aaROWID, aaSQLText, aaUUID, dbStatusID)
VALUES ('UPDATE', 'FoE_SxBuildings', OLD.aaPK,
'PREW-SxID: ' || OLD.SxID ||
'~PREW-SxName: ' || OLD.SxName ||
'~PREW-SxAge: ' || OLD.SxAge ||
'~PREW-SxTech: ' || OLD.SxTech ||
'~PREW-SxPopRequired: ' || OLD.SxPopRequired ||
'~PREW-SxSupplyYieldFiveMinutes_AA: ' || OLD.SxSupplyYieldFiveMinutes_AA ||
'~PREW-SxSupplyYieldFifteenMinutes_BB: ' || OLD.SxSupplyYieldFifteenMinutes_BB ||
'~PREW-SxSupplyYieldOneHour_CC: ' || OLD.SxSupplyYieldOneHour_CC ||
'~PREW-SxSupplyYieldFourHours_DD: ' || OLD.SxSupplyYieldFourHours_DD ||
'~PREW-SxSupplyYieldEightHours_EE: ' || OLD.SxSupplyYieldEightHours_EE ||
'~PREW-SxSupplyYieldOneDay_FF: ' || OLD.SxSupplyYieldOneDay_FF ||
'~PREW-SxSupplyYieldTwoDays_GG: ' || OLD.SxSupplyYieldTwoDays_GG ||
'~PREW-SxSWPixels: ' || OLD.SxSWPixels ||
'~PREW-SxNWPixels: ' || OLD.SxNWPixels ||
'~PREW-SxRoadWidth: ' || OLD.SxRoadWidth ||
'~PREW-SxBuildTime: ' || OLD.SxBuildTime ||
'~PREW-SxBuildDiamonds: ' || OLD.SxBuildDiamonds ||
'~PREW-SxBuildCoins: ' || OLD.SxBuildCoins ||
'~PREW-SxBuildSupplies: ' || OLD.SxBuildSupplies ||
'~PREW-SxSellCoins: ' || OLD.SxSellCoins ||
'~PREW-SxSellSupplies: ' || OLD.SxSellSupplies ||
'~PREW-SxCF_AA_Rate_BB: ' || OLD.SxCF_AA_Rate_BB ||
'~PREW-SxCF_AA_Rate_CC: ' || OLD.SxCF_AA_Rate_CC ||
'~PREW-SxCF_AA_Rate_DD: ' || OLD.SxCF_AA_Rate_DD ||
'~PREW-SxCF_AA_Rate_EE: ' || OLD.SxCF_AA_Rate_EE ||
'~PREW-SxCF_AA_Rate_FF: ' || OLD.SxCF_AA_Rate_FF ||
'~PREW-SxCF_AA_Rate_GG: ' || OLD.SxCF_AA_Rate_GG ||
'~PREW-SxCF_AA_Per_Pop: ' || OLD.SxCF_AA_Per_Pop ||
'~PREW-SxCF_AA_Per_SQR: ' || OLD.SxCF_AA_Per_SQR ||
'~PREW-dbStatusID: ' || OLD.dbStatusID ||
'~PREW-aaTimeStamp: ' || OLD.aaTimeStamp, 
'96d6b400-e237-11e5-bef5-0002a5d5c51b', 0); END;
-- END of creating the AFTER UPDATE trigger
--
-- Documenting the database 
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgINSERT-AFTER_FoE_SxBuildings','Trigger in the FoE_SxBuildings table, records new record insertions', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('tgUPDATE-AFTER_FoE_SxBuildings','Trigger in the FoE_SxBuildings table, records updates', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('FoE_SxBuildings','Data table, holding game information about supply buildings', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxID','Manually generated. The table has auto primary key, so if this is not needed then ignore', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxName','The name of the building as it appears in the game interface', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxAge','The age where the building first becomes available', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxTech','The name of the Technology which unlocks th building', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxPopRequired','Population count, assumes not up-gradable building', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldFiveMinutes_AA','The amount supply the building generates in 5-minutes cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldFifteenMinutes_BB','The amount supply the building generates in 15-minutes cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldOneHour_CC','The amount supply the building generates in 1-hour cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldFourHours_DD','The amount supply the building generates in 4-hours cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldEightHours_EE','The amount supply the building generates in 8-hours cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldOneDay_FF','The amount supply the building generates in 1-day cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSupplyYieldTwoDays_GG','The amount supply the building generates in 2-days cycle', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSWPixels','Size alongside the SW-NE edge', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxNWPixels','Size alongside the NW-SE edge', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxRoadWidth','The width of road required in pixels - 0 when none required', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxBuildTime','The number of seconds it takes to build', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxBuildDiamonds','The building cost in Diamonds', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxBuildCoins','The coin part of the building cost', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxBuildSupplies','The supply part of the building cost', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSellCoins','Coins recovered by selling this house, set to -1 when not yet recorded', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxSellSupplies','Supplies recovered by selling this house, set to -1 when not yet recorded', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Rate_BB','Calculated Field (CF) as SxCF_AA_Rate_BB = ((((SxSupplyYieldFifteenMinutes_BB*1.0) / 3.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Rate_CC','Calculated Field (CF) as SxCF_AA_Rate_CC = ((((SxSupplyYieldOneHour_CC*1.0) / 12.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Rate_DD','Calculated Field (CF) as SxCF_AA_Rate_DD = ((((SxSupplyYieldFourHours_DD*1.0) / 48.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Rate_EE','Calculated Field (CF) as SxCF_AA_Rate_EE = ((((SxSupplyYieldEightHours_EE*1.0) / 96.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Rate_FF','Calculated Field (CF) as SxCF_AA_Rate_FF = ((((SxSupplyYieldOneDay_FF*1.0) / 288.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Rate_GG','Calculated Field (CF) as SxCF_AA_Rate_GG = ((((SxSupplyYieldTwoDays_GG*1.0) / 576.0) / (SxSupplyYieldFiveMinutes_AA*1.0))*100.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Per_Pop','Calculated Field (CF) as SxCF_AA_Per_Pop = (SxSupplyYieldFiveMinutes_AA*1.0) / (SxPopRequired*1.0)', 0);
INSERT INTO FoE_ddSelfDoc (ddToken, ddText, dbStatusID) VALUES ('SxCF_AA_Per_SQR','Calculated Field (CF) as SxCF_AA_Per_Pop = ((SxSupplyYieldFiveMinutes_AA*1.0) / ((SxSWPixels*1.0)*(SxNWPixels*1.0)))', 0);
-- END of documenting the database
