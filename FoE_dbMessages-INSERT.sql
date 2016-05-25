-- Standardized Messages
INSERT INTO FoE_dbMessages (dbID, dbTableName, dbMessageCategory, dbMessagePriority, dbMessageTitle, dbMessageText, dbStatusID) VALUES ( -10010, '', 'i9-', 0, 'Incomplete',
'This record needs to be completed.', 0
);
INSERT INTO FoE_dbMessages (dbID, dbTableName, dbMessageCategory, dbMessagePriority, dbMessageTitle, dbMessageText, dbStatusID) VALUES ( -10011, '', 'i9-', 0, 'Needs Verification',
'This record is complete, but still needs to be reviewed and approved.', 0
);
INSERT INTO FoE_dbMessages (dbID, dbTableName, dbMessageCategory, dbMessagePriority, dbMessageTitle, dbMessageText, dbStatusID) VALUES ( -10012, '', 'i9-', 0, 'Needs Correction',
'This record was reviewed and found to contain errors.', 0
);
INSERT INTO FoE_dbMessages (dbID, dbTableName, dbMessageCategory, dbMessagePriority, dbMessageTitle, dbMessageText, dbStatusID) VALUES ( -10013, '', 'i9-', 0, 'Corrected',
'This record containing errors before is now corrected, needs approval.', 0
);
-- END of Standardized Messages
