ALTER TABLE RNT_TENANCY_AGREEMENT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE RNT_TENANCY_AGREEMENT CASCADE CONSTRAINTS
/

CREATE TABLE RNT_TENANCY_AGREEMENT
(
  AGREEMENT_ID     NUMBER                       NOT NULL,
  UNIT_ID          NUMBER                       NOT NULL,
  AGREEMENT_DATE   DATE                             NULL,
  TERM             NUMBER                       NOT NULL,
  AMOUNT           NUMBER                       NOT NULL,
  AMOUNT_PERIOD    VARCHAR2(30 BYTE)            NOT NULL,
  DATE_AVAILABLE   DATE                         NOT NULL,
  DEPOSIT          NUMBER                           NULL,
  LAST_MONTH       NUMBER                           NULL,
  DISCOUNT_AMOUNT  NUMBER                           NULL,
  DISCOUNT_TYPE    VARCHAR2(30 BYTE)                NULL,
  DISCOUNT_PERIOD  NUMBER                           NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_TENANCY_AGREEMENT IS 'An agreement between two or more parties to rent a building or a unit in a building.  Agreements are typically fixed length 12 month agreements or month to month.  A  discount may be applied for prompt payment.  Alternatively, a late fee could be charged if a payment id overdue.  The discount amount column records the value of this charge and the discount type identifies the type Fee or Discount'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.AGREEMENT_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.UNIT_ID IS 'fk to identify unit rented'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.AGREEMENT_DATE IS 'Date that the agreement was signed '
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.TERM IS 'Duration of the agreement in months'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.AMOUNT IS 'Rent amount'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.AMOUNT_PERIOD IS 'period that rent is due '
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.DEPOSIT IS 'The required deposit amount'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.LAST_MONTH IS 'Requied last month amount'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.DISCOUNT_AMOUNT IS 'Prompt payment discount or late fee amount'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.DISCOUNT_TYPE IS 'Discount or late fee'
/

COMMENT ON COLUMN RNT_TENANCY_AGREEMENT.DISCOUNT_PERIOD IS 'Number of days before adjustement is applied'
/


CREATE UNIQUE INDEX RNT_TENANCY_AGREEMENT_PK ON RNT_TENANCY_AGREEMENT
(AGREEMENT_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_TENANCY_AGREEMENT_UK1 ON RNT_TENANCY_AGREEMENT
(UNIT_ID, DATE_AVAILABLE)
LOGGING
NOPARALLEL
/


ALTER TABLE RNT_TENANCY_AGREEMENT ADD (
  CONSTRAINT RNT_TENANCY_AGREEMENT_PK
 PRIMARY KEY
 (AGREEMENT_ID))
/


ALTER TABLE RNT_TENANCY_AGREEMENT ADD (
  CONSTRAINT RNT_TENANCY_AGREEMENT_FK 
 FOREIGN KEY (UNIT_ID) 
 REFERENCES RNT_PROPERTY_UNITS (UNIT_ID))
/
