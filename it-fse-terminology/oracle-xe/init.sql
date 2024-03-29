create user terminology identified by terminology;
GRANT ALL PRIVILEGES TO terminology;
CREATE TABLE terminology.ROLES ( ID VARCHAR(36) PRIMARY KEY, DESCRIPTION VARCHAR(255) );
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'ADMIN'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'ARCHITECT'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'APPROVER'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'AUTHOR_CS'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'AUTHOR_VS'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'AUTHOR_CM'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'CONSUMER'); 
INSERT INTO terminology.ROLES VALUES(SYS_GUID(), 'EDS');