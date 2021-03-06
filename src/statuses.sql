CREATE OR REPLACE TABLE MACHINIC.STATUSES 
  (STATUS_CODE FOR STATCD        DECIMAL(5,0) NOT NULL,
  STATUS_DESCRIPTION FOR DESCR         CHAR(100),
  LAST_MODIFIED FOR MODIFIED    TIMESTAMP
        NOT NULL GENERATED ALWAYS FOR EACH ROW ON UPDATE AS ROW CHANGE TIMESTAMP,
  PRIMARY KEY(STATUS_CODE))