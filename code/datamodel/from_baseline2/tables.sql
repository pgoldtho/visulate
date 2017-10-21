CREATE TABLE RNT_BUSINESS_UNITS
(
  BUSINESS_ID         NUMBER                    NOT NULL,
  BUSINESS_NAME       VARCHAR2(60 BYTE)         NOT NULL,
  PARENT_BUSINESS_ID  NUMBER                    NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_BUSINESS_UNITS IS 'Business units separate properties by ownership or usage.  Property managers who manage properties for more than one person can use business units to separate their properties by owner.    Single owner users may want to divide their properties into different classifications e.g. commercial and residential'
/

COMMENT ON COLUMN RNT_BUSINESS_UNITS.BUSINESS_ID IS 'System generated primary key'
/

COMMENT ON COLUMN RNT_BUSINESS_UNITS.PARENT_BUSINESS_ID IS 'Parent ID'
/

COMMENT ON COLUMN RNT_BUSINESS_UNITS.BUSINESS_NAME IS 'A unique name for the business unit'
/


CREATE TABLE RNT_LOOKUP_TYPES
(
  LOOKUP_TYPE_ID           NUMBER               NOT NULL,
  LOOKUP_TYPE_CODE         VARCHAR2(30 BYTE)    NOT NULL,
  LOOKUP_TYPE_DESCRIPTION  VARCHAR2(80 BYTE)    NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


CREATE TABLE RNT_LOOKUP_VALUES
(
  LOOKUP_VALUE_ID  NUMBER                       NOT NULL,
  LOOKUP_CODE      VARCHAR2(80 BYTE)            NOT NULL,
  LOOKUP_VALUE     VARCHAR2(80 BYTE)                NULL,
  LOOKUP_TYPE_ID   NUMBER                       NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


CREATE TABLE RNT_PAYMENT_TYPES
(
  PAYMENT_TYPE_ID    NUMBER                     NOT NULL,
  PAYMENT_TYPE_NAME  VARCHAR2(30 BYTE)          NOT NULL,
  DEPRECIATION_TERM  NUMBER                         NULL,
  DESCRIPTION        VARCHAR2(4000 BYTE)            NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PAYMENT_TYPES IS 'Classification table for payments.  Payments must be classified for tax purposes.  This classification affects the period over which a payment can be depreciated.  This allows the cost of a capital improvement to be recognized over the life of the improvement.  For example, the cost of adding a new roof to a building might be depreciated over 10 years.'
/

COMMENT ON COLUMN RNT_PAYMENT_TYPES.PAYMENT_TYPE_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_PAYMENT_TYPES.PAYMENT_TYPE_NAME IS 'Payment classifier'
/

COMMENT ON COLUMN RNT_PAYMENT_TYPES.DEPRECIATION_TERM IS 'Tax depreciation term in years for payments of this type'
/

COMMENT ON COLUMN RNT_PAYMENT_TYPES.DESCRIPTION IS 'Short description'
/


CREATE TABLE RNT_PROPERTIES
(
  PROPERTY_ID        NUMBER                     NOT NULL,
  BUSINESS_ID        NUMBER                     NOT NULL,
  UNITS              NUMBER                     DEFAULT 1                     NOT NULL,
  ADDRESS1           VARCHAR2(60 BYTE)          NOT NULL,
  ADDRESS2           VARCHAR2(60 BYTE)              NULL,
  CITY               VARCHAR2(60 BYTE)          NOT NULL,
  STATE              VARCHAR2(2 BYTE)           NOT NULL,
  ZIPCODE            NUMBER                     NOT NULL,
  DATE_PURCHASED     DATE                       NOT NULL,
  PURCHASE_PRICE     NUMBER                     NOT NULL,
  LAND_VALUE         NUMBER                     NOT NULL,
  DEPRECIATION_TERM  NUMBER                     DEFAULT 27.5                  NOT NULL,
  YEAR_BUILT         NUMBER                         NULL,
  BUILDING_SIZE      NUMBER                         NULL,
  LOT_SIZE           NUMBER                         NULL,
  DATE_SOLD          DATE                           NULL,
  SALE_AMOUNT        NUMBER                         NULL,
  NOTE_YN            VARCHAR2(1 BYTE)               NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PROPERTIES IS 'Record details of buildings that are managed in the system.  Residential properties may contain multiple rentable units'
/

COMMENT ON COLUMN RNT_PROPERTIES.PROPERTY_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_PROPERTIES.BUSINESS_ID IS 'Foreign key to RNT_BUSINESS_UNITS'
/

COMMENT ON COLUMN RNT_PROPERTIES.UNITS IS '!may be deleted - we calculate count. A count of the total number of rentable units in the property'
/

COMMENT ON COLUMN RNT_PROPERTIES.ADDRESS1 IS 'Address line 1'
/

COMMENT ON COLUMN RNT_PROPERTIES.ADDRESS2 IS 'Address line 2'
/

COMMENT ON COLUMN RNT_PROPERTIES.DATE_PURCHASED IS 'Date that the property was purchased'
/

COMMENT ON COLUMN RNT_PROPERTIES.PURCHASE_PRICE IS 'Price paid'
/

COMMENT ON COLUMN RNT_PROPERTIES.LAND_VALUE IS 'Land value at time of purchase'
/

COMMENT ON COLUMN RNT_PROPERTIES.DEPRECIATION_TERM IS 'Depreciation term in years, typically 27.5 for residential properties and 39 years for commercial'
/

COMMENT ON COLUMN RNT_PROPERTIES.YEAR_BUILT IS 'The year that the property was constructed'
/

COMMENT ON COLUMN RNT_PROPERTIES.BUILDING_SIZE IS 'Total conditioned space in square feet'
/

COMMENT ON COLUMN RNT_PROPERTIES.LOT_SIZE IS 'in acres e.g. 0.25, 0.125 etc'
/

COMMENT ON COLUMN RNT_PROPERTIES.DATE_SOLD IS 'The date this property was sold to another party'
/

COMMENT ON COLUMN RNT_PROPERTIES.SALE_AMOUNT IS 'The amount it sold for'
/

COMMENT ON COLUMN RNT_PROPERTIES.NOTE_YN IS 'Is there a loan associcate with this sale?'
/


CREATE TABLE RNT_PROPERTY_UNITS
(
  UNIT_ID      NUMBER                           NOT NULL,
  PROPERTY_ID  NUMBER                           NOT NULL,
  UNIT_NAME    VARCHAR2(32 BYTE)                DEFAULT 'Unit 1'              NOT NULL,
  UNIT_SIZE    NUMBER                               NULL,
  BEDROOMS     NUMBER                               NULL,
  BATHROOMS    NUMBER                               NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PROPERTY_UNITS IS 'A rentable unit in a building'
/

COMMENT ON COLUMN RNT_PROPERTY_UNITS.UNIT_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_PROPERTY_UNITS.PROPERTY_ID IS 'The property that this unit exists in'
/

COMMENT ON COLUMN RNT_PROPERTY_UNITS.UNIT_NAME IS 'Name of the unit e.g. Unit 1'
/

COMMENT ON COLUMN RNT_PROPERTY_UNITS.UNIT_SIZE IS 'Living space in square feet'
/

COMMENT ON COLUMN RNT_PROPERTY_UNITS.BEDROOMS IS 'Total of the number of bedrooms in the unit'
/

COMMENT ON COLUMN RNT_PROPERTY_UNITS.BATHROOMS IS 'Number of bathrooms'
/


CREATE TABLE RNT_PROPERTY_VALUE
(
  VALUE_ID      NUMBER(8)                       NOT NULL,
  PROPERTY_ID   NUMBER                          NOT NULL,
  VALUE_DATE    DATE                            NOT NULL,
  VALUE_METHOD  VARCHAR2(30 BYTE)               NOT NULL,
  VALUE         NUMBER                          NOT NULL,
  CAP_RATE      NUMBER                              NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PROPERTY_VALUE IS 'Records the value of a property over time.  Values may be calculated, estimated or actual.  An actual value reflects the price that a property sold for on a given date.  Estimates are produced by evaluating the sale price of similar comparable properties often reffered to as "Comps".  Values can be calculated by  dividing the net operating income by a percentage value known as the capitialization or "CAP" rate.'
/

COMMENT ON COLUMN RNT_PROPERTY_VALUE.VALUE_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_PROPERTY_VALUE.PROPERTY_ID IS 'FK to RNT_PROPERTIES'
/

COMMENT ON COLUMN RNT_PROPERTY_VALUE.VALUE_DATE IS 'Date of the valuation'
/

COMMENT ON COLUMN RNT_PROPERTY_VALUE.VALUE_METHOD IS 'Method used to evaluate the property value.  Valid values are Sale, Estimate, Cap Rate'
/

COMMENT ON COLUMN RNT_PROPERTY_VALUE.VALUE IS 'Estimated value'
/

COMMENT ON COLUMN RNT_PROPERTY_VALUE.CAP_RATE IS 'The  cap rate used to calculate the value'
/


CREATE TABLE RNT_SUPPLIERS
(
  SUPPLIER_ID    NUMBER                         NOT NULL,
  NAME           VARCHAR2(60 BYTE)              NOT NULL,
  PHONE1         VARCHAR2(30 BYTE)              NOT NULL,
  PHONE2         VARCHAR2(30 BYTE)                  NULL,
  ADDRESS1       VARCHAR2(60 BYTE)                  NULL,
  ADDRESS2       VARCHAR2(60 BYTE)                  NULL,
  CITY           VARCHAR2(30 BYTE)                  NULL,
  STATE          VARCHAR2(2 BYTE)                   NULL,
  ZIPCODE        NUMBER                             NULL,
  SSN            VARCHAR2(11 BYTE)                  NULL,
  EMAIL_ADDRESS  VARCHAR2(100 BYTE)                 NULL,
  COMMENTS       VARCHAR2(4000 BYTE)                NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_SUPPLIERS IS 'RNT_SUPPLIERS records details of contractors, and service suppliers.  '
/

COMMENT ON COLUMN RNT_SUPPLIERS.SUPPLIER_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_SUPPLIERS.NAME IS 'Contractor Name'
/

COMMENT ON COLUMN RNT_SUPPLIERS.PHONE1 IS 'Primary phone number'
/

COMMENT ON COLUMN RNT_SUPPLIERS.PHONE2 IS 'Alternate phone number'
/

COMMENT ON COLUMN RNT_SUPPLIERS.ADDRESS1 IS 'Address line 1'
/

COMMENT ON COLUMN RNT_SUPPLIERS.ADDRESS2 IS 'Address line 2'
/

COMMENT ON COLUMN RNT_SUPPLIERS.CITY IS 'City'
/

COMMENT ON COLUMN RNT_SUPPLIERS.STATE IS 'State'
/

COMMENT ON COLUMN RNT_SUPPLIERS.ZIPCODE IS 'Zipcode'
/

COMMENT ON COLUMN RNT_SUPPLIERS.SSN IS 'SSN for non incorporated contractor'
/

COMMENT ON COLUMN RNT_SUPPLIERS.EMAIL_ADDRESS IS 'email address'
/

COMMENT ON COLUMN RNT_SUPPLIERS.COMMENTS IS 'Notes and comments'
/


CREATE TABLE RNT_TENANCY_AGREEMENT
(
  AGREEMENT_ID     NUMBER                       NOT NULL,
  UNIT_ID          NUMBER                       NOT NULL,
  AGREEMENT_DATE   DATE                         NOT NULL,
  TERM             NUMBER                       NOT NULL,
  AMOUNT           NUMBER                       NOT NULL,
  AMOUNT_PERIOD    VARCHAR2(30 BYTE)            NOT NULL,
  EFFECTIVE_DATE   DATE                         NOT NULL,
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


CREATE TABLE RNT_TENANT
(
  TENANT_ID           NUMBER                    NOT NULL,
  FIRST_NAME          VARCHAR2(30 BYTE)         NOT NULL,
  LAST_NAME           VARCHAR2(30 BYTE)         NOT NULL,
  UNIT_APPLIED_FOR    NUMBER                    NOT NULL,
  AGREEMENT_ID        NUMBER                        NULL,
  STATUS              VARCHAR2(30 BYTE)         NOT NULL,
  DEPOSIT_BALANCE     NUMBER                    NOT NULL,
  LAST_MONTH_BALANCE  NUMBER                    NOT NULL,
  PHONE1              VARCHAR2(16 BYTE)             NULL,
  PHONE2              VARCHAR2(16 BYTE)             NULL,
  EMAIL_ADDRESS       VARCHAR2(100 BYTE)            NULL,
  SSN                 VARCHAR2(11 BYTE)             NULL,
  DRIVERS_LICENSE     VARCHAR2(100 BYTE)            NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_TENANT IS 'Records details of current and past tenants plus applications received'
/

COMMENT ON COLUMN RNT_TENANT.TENANT_ID IS 'System generated pk'
/

COMMENT ON COLUMN RNT_TENANT.FIRST_NAME IS 'First of given name'
/

COMMENT ON COLUMN RNT_TENANT.LAST_NAME IS 'Surname'
/

COMMENT ON COLUMN RNT_TENANT.UNIT_APPLIED_FOR IS 'FK to unit applied for'
/

COMMENT ON COLUMN RNT_TENANT.AGREEMENT_ID IS 'FK to rental agreement'
/

COMMENT ON COLUMN RNT_TENANT.STATUS IS 'E.g. active, former'
/

COMMENT ON COLUMN RNT_TENANT.DEPOSIT_BALANCE IS 'Total current deposit balance'
/

COMMENT ON COLUMN RNT_TENANT.LAST_MONTH_BALANCE IS 'Total of last month balance'
/

COMMENT ON COLUMN RNT_TENANT.PHONE1 IS 'Primary phone number'
/

COMMENT ON COLUMN RNT_TENANT.PHONE2 IS 'Secondary phone number'
/

COMMENT ON COLUMN RNT_TENANT.EMAIL_ADDRESS IS 'Email address'
/

COMMENT ON COLUMN RNT_TENANT.SSN IS 'SSN '
/

COMMENT ON COLUMN RNT_TENANT.DRIVERS_LICENSE IS 'DL number'
/


CREATE TABLE RNT_USER_ROLES
(
  ROLE_ID    NUMBER                             NOT NULL,
  ROLE_CODE  VARCHAR2(10 BYTE)                  NOT NULL,
  ROLE_NAME  VARCHAR2(30 BYTE)                  NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_USER_ROLES IS 'Roles for users.'
/

COMMENT ON COLUMN RNT_USER_ROLES.ROLE_ID IS 'Role ID'
/

COMMENT ON COLUMN RNT_USER_ROLES.ROLE_CODE IS 'Internal code'
/

COMMENT ON COLUMN RNT_USER_ROLES.ROLE_NAME IS 'Display name'
/


CREATE TABLE RNT_USERS
(
  USER_ID        NUMBER                         NOT NULL,
  USER_LOGIN     VARCHAR2(20 BYTE)              NOT NULL,
  USER_NAME      VARCHAR2(50 BYTE)              NOT NULL,
  USER_PASSWORD  VARCHAR2(64 BYTE)              NOT NULL,
  IS_ACTIVE_YN   VARCHAR2(1 BYTE)               NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_USERS IS 'User who using system'
/

COMMENT ON COLUMN RNT_USERS.USER_ID IS 'User ID'
/

COMMENT ON COLUMN RNT_USERS.USER_LOGIN IS 'Login for user'
/

COMMENT ON COLUMN RNT_USERS.USER_NAME IS 'User name '
/

COMMENT ON COLUMN RNT_USERS.USER_PASSWORD IS 'User password'
/

COMMENT ON COLUMN RNT_USERS.IS_ACTIVE_YN IS 'Y is user is active, else N'
/


CREATE TABLE RNT_USER_ASSIGNMENTS
(
  USER_ASSIGN_ID  NUMBER                        NOT NULL,
  ROLE_ID         NUMBER                        NOT NULL,
  USER_ID         NUMBER                        NOT NULL,
  BUSINESS_ID     NUMBER                        NOT NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_USER_ASSIGNMENTS IS 'User assignments on role. '
/

COMMENT ON COLUMN RNT_USER_ASSIGNMENTS.USER_ASSIGN_ID IS 'Assignment ID'
/

COMMENT ON COLUMN RNT_USER_ASSIGNMENTS.ROLE_ID IS 'Role ID'
/

COMMENT ON COLUMN RNT_USER_ASSIGNMENTS.USER_ID IS 'User ID'
/

COMMENT ON COLUMN RNT_USER_ASSIGNMENTS.BUSINESS_ID IS 'Business ID'
/


CREATE UNIQUE INDEX RNT_BUSINESS_UNITS_U1 ON RNT_BUSINESS_UNITS
(PARENT_BUSINESS_ID, BUSINESS_NAME)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_BUSINESS_UNITS_PK ON RNT_BUSINESS_UNITS
(BUSINESS_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_LOOKUP_TYPES_PK ON RNT_LOOKUP_TYPES
(LOOKUP_TYPE_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_LOOKUP_TYPES_U1 ON RNT_LOOKUP_TYPES
(LOOKUP_TYPE_CODE)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_LOOKUP_VALUES_PK ON RNT_LOOKUP_VALUES
(LOOKUP_VALUE_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_LOOKUP_VALUES_U1 ON RNT_LOOKUP_VALUES
(LOOKUP_TYPE_ID, LOOKUP_CODE)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PAYMENT_TYPES_PK ON RNT_PAYMENT_TYPES
(PAYMENT_TYPE_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PAYMENT_TYPES_UK1 ON RNT_PAYMENT_TYPES
(PAYMENT_TYPE_NAME)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTIES_PK ON RNT_PROPERTIES
(PROPERTY_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTIES_UK1 ON RNT_PROPERTIES
(ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTY_UNITS_PK ON RNT_PROPERTY_UNITS
(UNIT_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTY_UNITS_UK1 ON RNT_PROPERTY_UNITS
(PROPERTY_ID, UNIT_NAME)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTY_VALUE_PK ON RNT_PROPERTY_VALUE
(VALUE_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTY_VALUE_UK1 ON RNT_PROPERTY_VALUE
(PROPERTY_ID, VALUE_DATE, VALUE_METHOD)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_CONTRACTORS_PK ON RNT_SUPPLIERS
(SUPPLIER_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_CONTRACTORS_UK1 ON RNT_SUPPLIERS
(NAME)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_TENANCY_AGREEMENT_PK ON RNT_TENANCY_AGREEMENT
(AGREEMENT_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_TENANCY_AGREEMENT_UK1 ON RNT_TENANCY_AGREEMENT
(UNIT_ID, AGREEMENT_DATE)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_TENANT_PK ON RNT_TENANT
(TENANT_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_TENANT_UK1 ON RNT_TENANT
(FIRST_NAME, LAST_NAME)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_USER_PK ON RNT_USERS
(USER_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_USER_U1 ON RNT_USERS
(USER_LOGIN)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_USER_ASSIGNMENTS_PK ON RNT_USER_ASSIGNMENTS
(USER_ASSIGN_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_USER_ASSIGNMENTS_U1 ON RNT_USER_ASSIGNMENTS
(ROLE_ID, USER_ID, BUSINESS_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_USER_ROLES_PK ON RNT_USER_ROLES
(ROLE_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_USER_ROLES_U1 ON RNT_USER_ROLES
(ROLE_CODE)
LOGGING
NOPARALLEL
/


CREATE TABLE RNT_AGREEMENT_ACTIONS
(
  ACTION_ID     NUMBER                          NOT NULL,
  AGREEMENT_ID  NUMBER                          NOT NULL,
  ACTION_DATE   DATE                            NOT NULL,
  ACTION_TYPE   VARCHAR2(30 BYTE)               NOT NULL,
  COMMENTS      VARCHAR2(4000 BYTE)                 NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_AGREEMENT_ACTIONS IS 'Evictions and court orders associated with a tenancy agreement'
/

COMMENT ON COLUMN RNT_AGREEMENT_ACTIONS.ACTION_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_AGREEMENT_ACTIONS.AGREEMENT_ID IS 'FK to RNT_TENANCY_AGREEMENT'
/

COMMENT ON COLUMN RNT_AGREEMENT_ACTIONS.ACTION_DATE IS 'Date that action was performed'
/

COMMENT ON COLUMN RNT_AGREEMENT_ACTIONS.ACTION_TYPE IS 'Action Classification'
/

COMMENT ON COLUMN RNT_AGREEMENT_ACTIONS.COMMENTS IS 'Short description'
/


CREATE TABLE RNT_LOANS
(
  LOAN_ID             NUMBER                    NOT NULL,
  PROPERTY_ID         NUMBER                    NOT NULL,
  POSITION            NUMBER                    NOT NULL,
  LOAN_DATE           DATE                      NOT NULL,
  LOAN_AMOUNT         NUMBER                    NOT NULL,
  TERM                NUMBER                    NOT NULL,
  INTEREST_RATE       NUMBER                    NOT NULL,
  CREDIT_LINE_YN      VARCHAR2(1 BYTE)          NOT NULL,
  ARM_YN              VARCHAR2(1 BYTE)          NOT NULL,
  BALLOON_DATE        DATE                          NULL,
  AMORTIZATION_START  DATE                          NULL,
  SETTLEMENT_DATE     DATE                          NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_LOANS IS 'Properties are typically purchased using using loans which are secured against the property.  Credit lines may be extended against properties which are already owned to release equity for other purchases.    Loans can be adjustable rate (ARM) or fixed rate mortgages.  Balloon mortgages are loans where the balance of the loan becomes due before the the end of the term.  '
/

COMMENT ON COLUMN RNT_LOANS.LOAN_ID IS 'System generate PK'
/

COMMENT ON COLUMN RNT_LOANS.PROPERTY_ID IS 'The property that this loan was secured against'
/

COMMENT ON COLUMN RNT_LOANS.POSITION IS 'Is this the 1st, 2nd or 3rd loan secured against this property'
/

COMMENT ON COLUMN RNT_LOANS.LOAN_DATE IS 'Date that the loan was made'
/

COMMENT ON COLUMN RNT_LOANS.LOAN_AMOUNT IS 'Amount borrowed'
/

COMMENT ON COLUMN RNT_LOANS.TERM IS 'The time in years that the loan must be repaid'
/

COMMENT ON COLUMN RNT_LOANS.INTEREST_RATE IS 'The current interest rate for the loan'
/

COMMENT ON COLUMN RNT_LOANS.CREDIT_LINE_YN IS 'Is this loan a line of credit?'
/

COMMENT ON COLUMN RNT_LOANS.ARM_YN IS 'Is the interest rate adjustable?'
/

COMMENT ON COLUMN RNT_LOANS.BALLOON_DATE IS 'The date that the full amount of this loan becomes due for a balloon mortgage'
/

COMMENT ON COLUMN RNT_LOANS.AMORTIZATION_START IS 'The data that amortization of this loan will begin'
/

COMMENT ON COLUMN RNT_LOANS.SETTLEMENT_DATE IS 'The date that this loan was settled'
/


CREATE TABLE RNT_PAYMENTS
(
  PAYMENT_ID        NUMBER                      NOT NULL,
  PAYMENT_DATE      DATE                        NOT NULL,
  DESCRIPTION       VARCHAR2(256 BYTE)          NOT NULL,
  PAID_OR_RECEIVED  VARCHAR2(16 BYTE)           DEFAULT 'PAID'                NOT NULL,
  AMOUNT            NUMBER                      NOT NULL,
  TENANT_ID         NUMBER                          NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PAYMENTS IS 'Records details of payments made or received for allocation to an account.  This allows a single payment to be divided into multiple accounts.  It also provides a holding area for payments that cannot be allocated immediately.  Examples:  Contractor presents a single invoice for work performed on multiple properties.   Tenant makes a rent payment into the bank without identifying the property that it applies to.   Home Depot or Lowes Receipt lists supplies for multiple properties.  Unused supplies are return to a store for a credit refund  Transfer payments can be made to remove funds from the last month or deposit balance for a tenant. '
/

COMMENT ON COLUMN RNT_PAYMENTS.PAYMENT_ID IS 'System generated primary key'
/

COMMENT ON COLUMN RNT_PAYMENTS.PAYMENT_DATE IS 'The date this payment was made or received'
/

COMMENT ON COLUMN RNT_PAYMENTS.DESCRIPTION IS 'e.g. Home Depot receipt, Bank Payment'
/

COMMENT ON COLUMN RNT_PAYMENTS.PAID_OR_RECEIVED IS 'Does this payment releate to a payment made or an amount received?'
/

COMMENT ON COLUMN RNT_PAYMENTS.AMOUNT IS 'The value of the payment'
/


CREATE TABLE RNT_PROPERTY_EXPENSES
(
  EXPENSE_ID         NUMBER                     NOT NULL,
  PROPERTY_ID        NUMBER                     NOT NULL,
  EVENT_DATE         DATE                       NOT NULL,
  DESCRIPTION        VARCHAR2(4000 BYTE)        NOT NULL,
  RECURRING_YN       VARCHAR2(1 BYTE)           DEFAULT 'N'                   NOT NULL,
  RECURRING_PERIOD   VARCHAR2(20 BYTE)          DEFAULT 'N/A'                     NULL,
  RECURRING_ENDDATE  DATE                           NULL,
  UNIT_ID            NUMBER                         NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PROPERTY_EXPENSES IS 'Records details of property event occurrences.  These could include repairs and maintenance, scheduled services like lawn care or pest control.  All actions that result in a property expense should have an entry in this table.  Some expenses are recurring.  They reoccur on a regular bases.  Examples could include lawn care or pest control '
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.EXPENSE_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.PROPERTY_ID IS 'FK to RNT_PROPERTIES'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.EVENT_DATE IS 'Date that event occurred'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.DESCRIPTION IS 'Event description'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.RECURRING_YN IS 'Is this a recurring expense?'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.RECURRING_PERIOD IS 'Time to next ocurrence of this event.  System uses this to generate next payment in Accounts Payable'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.RECURRING_ENDDATE IS 'The final date for a recurring event'
/

COMMENT ON COLUMN RNT_PROPERTY_EXPENSES.UNIT_ID IS 'FK to Unit for multi unit properties'
/


CREATE UNIQUE INDEX RNT_AGREEMENT_ACTIONS_PK ON RNT_AGREEMENT_ACTIONS
(ACTION_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_AGREEMENT_ACTIONS_UK1 ON RNT_AGREEMENT_ACTIONS
(AGREEMENT_ID, ACTION_DATE, ACTION_TYPE)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_LOANS_PK ON RNT_LOANS
(LOAN_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_LOANS_UK2 ON RNT_LOANS
(PROPERTY_ID, POSITION)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PAYMENTS_PK ON RNT_PAYMENTS
(PAYMENT_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PAYMENTS_UK1 ON RNT_PAYMENTS
(PAYMENT_DATE, DESCRIPTION)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTY_EXPENSES_PK ON RNT_PROPERTY_EXPENSES
(EXPENSE_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PROPERTY_HISTORY_UK1 ON RNT_PROPERTY_EXPENSES
(PROPERTY_ID, EVENT_DATE, UNIT_ID, DESCRIPTION)
LOGGING
NOPARALLEL
/


CREATE TABLE RNT_ACCOUNTS_PAYABLE
(
  AP_ID             NUMBER                      NOT NULL,
  PAYMENT_DUE_DATE  DATE                        NOT NULL,
  AMOUNT            NUMBER                      NOT NULL,
  PAYMENT_TYPE_ID   NUMBER                      NOT NULL,
  EXPENSE_ID        NUMBER                      NOT NULL,
  LOAN_ID           NUMBER                          NULL,
  SUPPLIER_ID       NUMBER                          NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_ACCOUNTS_PAYABLE IS 'Amounts owed by us for goods or services.  Each payment must be classified by payment type and associated with a property expense.'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.AP_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.PAYMENT_DUE_DATE IS 'The date that a payment is due'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.AMOUNT IS 'Amount due'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.PAYMENT_TYPE_ID IS 'Foreign key to RNT_PAYMENT_TYPES'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.EXPENSE_ID IS 'Foreign key to RNT_PROPERTY_EXPENSES'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.LOAN_ID IS 'FK to RNT_LOANS'
/

COMMENT ON COLUMN RNT_ACCOUNTS_PAYABLE.SUPPLIER_ID IS 'Foreign key to RNT_SUPPLIERS'
/


CREATE TABLE RNT_ACCOUNTS_RECEIVABLE
(
  AR_ID             NUMBER                      NOT NULL,
  PAYMENT_DUE_DATE  DATE                        NOT NULL,
  AMOUNT            NUMBER                      NOT NULL,
  PAYMENT_TYPE      NUMBER                          NULL,
  TENANT_ID         NUMBER                          NULL,
  AGREEMENT_ID      NUMBER                          NULL,
  LOAN_ID           NUMBER                          NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_ACCOUNTS_RECEIVABLE IS 'Records details of payments due to us.  These could be directly from tenants for deposits and last months rent.  They can also be rent payments in connection with a tenancy agreeement.  The system generates AR records automatically based on the terms of the tenancy agreement.  '
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.AR_ID IS 'System Generated PK'
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_DUE_DATE IS 'Date the payment is due'
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.AMOUNT IS 'Amount due'
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.PAYMENT_TYPE IS 'FK to RNT_PAYMENT_TYPES'
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.TENANT_ID IS 'FK to RNT_TENTANTS'
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.AGREEMENT_ID IS 'FK to RNT_TENANCY_AGREEMENT used to record deposit, last month etc'
/

COMMENT ON COLUMN RNT_ACCOUNTS_RECEIVABLE.LOAN_ID IS 'FK to RNT_LOANS for Mortgage notes'
/


CREATE TABLE RNT_PAYMENT_ALLOCATIONS
(
  PAY_ALLOC_ID  NUMBER                          NOT NULL,
  PAYMENT_DATE  DATE                            NOT NULL,
  AMOUNT        NUMBER                              NULL,
  AR_ID         NUMBER                              NULL,
  AP_ID         NUMBER                              NULL,
  PAYMENT_ID    NUMBER                              NULL
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE RNT_PAYMENT_ALLOCATIONS IS 'Records the payment of AR and AP entries.  Each AR or AP entry may have more than one payment allocation.  Tenants may make partial payments against rent due.'
/

COMMENT ON COLUMN RNT_PAYMENT_ALLOCATIONS.PAY_ALLOC_ID IS 'System generated PK'
/

COMMENT ON COLUMN RNT_PAYMENT_ALLOCATIONS.PAYMENT_DATE IS 'Date the payment was made'
/

COMMENT ON COLUMN RNT_PAYMENT_ALLOCATIONS.AMOUNT IS 'Amount Paid'
/

COMMENT ON COLUMN RNT_PAYMENT_ALLOCATIONS.AR_ID IS 'Payment for Accounts Receivable ID'
/

COMMENT ON COLUMN RNT_PAYMENT_ALLOCATIONS.AP_ID IS 'Payment of Accounts Payable ID'
/

COMMENT ON COLUMN RNT_PAYMENT_ALLOCATIONS.PAYMENT_ID IS 'Foreign key to RNT_PAYMENTS'
/


CREATE UNIQUE INDEX RNT_ACCOUNTS_PAYABLE_PK ON RNT_ACCOUNTS_PAYABLE
(AP_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_ACCOUNTS_RECEIVABLE_PK ON RNT_ACCOUNTS_RECEIVABLE
(AR_ID)
LOGGING
NOPARALLEL
/


CREATE UNIQUE INDEX RNT_PAYMENT_ALLOC_PK ON RNT_PAYMENT_ALLOCATIONS
(PAY_ALLOC_ID)
LOGGING
NOPARALLEL
/


ALTER TABLE RNT_BUSINESS_UNITS ADD (
  CONSTRAINT RNT_BUSINESS_UNITS_PK
 PRIMARY KEY
 (BUSINESS_ID))
/


ALTER TABLE RNT_LOOKUP_TYPES ADD (
  CONSTRAINT RNT_LOOKUP_TYPES_PK
 PRIMARY KEY
 (LOOKUP_TYPE_ID))
/


ALTER TABLE RNT_LOOKUP_VALUES ADD (
  CONSTRAINT RNT_LOOKUP_VALUES_PK
 PRIMARY KEY
 (LOOKUP_VALUE_ID))
/


ALTER TABLE RNT_PAYMENT_TYPES ADD (
  CONSTRAINT RNT_PAYMENT_TYPES_PK
 PRIMARY KEY
 (PAYMENT_TYPE_ID))
/

ALTER TABLE RNT_PAYMENT_TYPES ADD (
  CONSTRAINT RNT_PAYMENT_TYPES_UK1
 UNIQUE (PAYMENT_TYPE_NAME))
/


ALTER TABLE RNT_PROPERTIES ADD (
  CONSTRAINT RNT_PROPERTIES_CK1
 CHECK (state in ('FL', 'NC')))
/

ALTER TABLE RNT_PROPERTIES ADD (
  CONSTRAINT RNT_PROPERTIES_PK
 PRIMARY KEY
 (PROPERTY_ID))
/

ALTER TABLE RNT_PROPERTIES ADD (
  CONSTRAINT RNT_PROPERTIES_UK1
 UNIQUE (ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE))
/


ALTER TABLE RNT_PROPERTY_UNITS ADD (
  CONSTRAINT RNT_PROPERTY_UNITS_PK
 PRIMARY KEY
 (UNIT_ID))
/

ALTER TABLE RNT_PROPERTY_UNITS ADD (
  CONSTRAINT RNT_PROPERTY_UNITS_UK1
 UNIQUE (PROPERTY_ID, UNIT_NAME))
/


ALTER TABLE RNT_PROPERTY_VALUE ADD (
  CONSTRAINT RNT_PROPERTY_VALUE_PK
 PRIMARY KEY
 (VALUE_ID))
/

ALTER TABLE RNT_PROPERTY_VALUE ADD (
  CONSTRAINT RNT_PROPERTY_VALUE_UK1
 UNIQUE (PROPERTY_ID, VALUE_DATE, VALUE_METHOD))
/


ALTER TABLE RNT_SUPPLIERS ADD (
  CONSTRAINT RNT_CONTRACTORS_PK
 PRIMARY KEY
 (SUPPLIER_ID))
/

ALTER TABLE RNT_SUPPLIERS ADD (
  CONSTRAINT RNT_CONTRACTORS_UK1
 UNIQUE (NAME))
/


ALTER TABLE RNT_TENANCY_AGREEMENT ADD (
  CONSTRAINT RNT_TENANCY_AGREEMENT_PK
 PRIMARY KEY
 (AGREEMENT_ID))
/

ALTER TABLE RNT_TENANCY_AGREEMENT ADD (
  CONSTRAINT RNT_TENANCY_AGREEMENT_UK1
 UNIQUE (UNIT_ID, AGREEMENT_DATE))
/


ALTER TABLE RNT_TENANT ADD (
  CONSTRAINT RNT_TENANT_PK
 PRIMARY KEY
 (TENANT_ID))
/

ALTER TABLE RNT_TENANT ADD (
  CONSTRAINT RNT_TENANT_UK1
 UNIQUE (FIRST_NAME, LAST_NAME))
/


ALTER TABLE RNT_USER_ROLES ADD (
  CONSTRAINT RNT_USER_ROLES_PK
 PRIMARY KEY
 (ROLE_ID))
/


ALTER TABLE RNT_USERS ADD (
  CONSTRAINT RNT_USER_PK
 PRIMARY KEY
 (USER_ID))
/


ALTER TABLE RNT_USER_ASSIGNMENTS ADD (
  CONSTRAINT RNT_USER_ASSIGNMENTS_PK
 PRIMARY KEY
 (USER_ASSIGN_ID))
/


ALTER TABLE RNT_AGREEMENT_ACTIONS ADD (
  CONSTRAINT RNT_AGREEMENT_ACTIONS_PK
 PRIMARY KEY
 (ACTION_ID))
/

ALTER TABLE RNT_AGREEMENT_ACTIONS ADD (
  CONSTRAINT RNT_AGREEMENT_ACTIONS_UK1
 UNIQUE (AGREEMENT_ID, ACTION_DATE, ACTION_TYPE))
/


ALTER TABLE RNT_LOANS ADD (
  CONSTRAINT RNT_LOANS_PK
 PRIMARY KEY
 (LOAN_ID))
/

ALTER TABLE RNT_LOANS ADD (
  CONSTRAINT RNT_LOANS_UK2
 UNIQUE (PROPERTY_ID, POSITION))
/


ALTER TABLE RNT_PAYMENTS ADD (
  CONSTRAINT RNT_PAYMENTS_PK
 PRIMARY KEY
 (PAYMENT_ID))
/

ALTER TABLE RNT_PAYMENTS ADD (
  CONSTRAINT RNT_PAYMENTS_UK1
 UNIQUE (PAYMENT_DATE, DESCRIPTION))
/


ALTER TABLE RNT_PROPERTY_EXPENSES ADD (
  CONSTRAINT RNT_PROPERTY_EXPENSES_PK
 PRIMARY KEY
 (EXPENSE_ID))
/

ALTER TABLE RNT_PROPERTY_EXPENSES ADD (
  CONSTRAINT RNT_PROPERTY_HISTORY_UK1
 UNIQUE (PROPERTY_ID, EVENT_DATE, UNIT_ID, DESCRIPTION))
/


ALTER TABLE RNT_ACCOUNTS_PAYABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_PAYABLE_PK
 PRIMARY KEY
 (AP_ID))
/


ALTER TABLE RNT_ACCOUNTS_RECEIVABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_RECEIVABLE_PK
 PRIMARY KEY
 (AR_ID))
/


ALTER TABLE RNT_PAYMENT_ALLOCATIONS ADD (
  CONSTRAINT RNT_PAYMENT_ALLOC_PK
 PRIMARY KEY
 (PAY_ALLOC_ID))
/


ALTER TABLE RNT_LOOKUP_VALUES ADD (
  CONSTRAINT RNT_LOOKUP_VALUES_FK 
 FOREIGN KEY (LOOKUP_TYPE_ID) 
 REFERENCES RNT_LOOKUP_TYPES (LOOKUP_TYPE_ID))
/


ALTER TABLE RNT_PROPERTIES ADD (
  CONSTRAINT RNT_PROPERTIES_FK 
 FOREIGN KEY (BUSINESS_ID) 
 REFERENCES RNT_BUSINESS_UNITS (BUSINESS_ID))
/


ALTER TABLE RNT_PROPERTY_UNITS ADD (
  CONSTRAINT RNT_PROPERTY_UNITS_FK1 
 FOREIGN KEY (PROPERTY_ID) 
 REFERENCES RNT_PROPERTIES (PROPERTY_ID))
/


ALTER TABLE RNT_PROPERTY_VALUE ADD (
  CONSTRAINT RNT_PROPERTY_VALUE_FK 
 FOREIGN KEY (PROPERTY_ID) 
 REFERENCES RNT_PROPERTIES (PROPERTY_ID))
/


ALTER TABLE RNT_TENANCY_AGREEMENT ADD (
  CONSTRAINT RNT_TENANCY_AGREEMENT_FK 
 FOREIGN KEY (UNIT_ID) 
 REFERENCES RNT_PROPERTY_UNITS (UNIT_ID))
/


ALTER TABLE RNT_TENANT ADD (
  CONSTRAINT RNT_TENANT_FK 
 FOREIGN KEY (AGREEMENT_ID) 
 REFERENCES RNT_TENANCY_AGREEMENT (AGREEMENT_ID))
/

ALTER TABLE RNT_TENANT ADD (
  CONSTRAINT RNT_TENANT_FK2 
 FOREIGN KEY (UNIT_APPLIED_FOR) 
 REFERENCES RNT_PROPERTY_UNITS (UNIT_ID))
/


ALTER TABLE RNT_USER_ASSIGNMENTS ADD (
  CONSTRAINT RNT_USER_ASSIGNMENTS_FK1 
 FOREIGN KEY (USER_ID) 
 REFERENCES RNT_USERS (USER_ID))
/

ALTER TABLE RNT_USER_ASSIGNMENTS ADD (
  CONSTRAINT RNT_USER_ASSIGNMENTS_FK2 
 FOREIGN KEY (ROLE_ID) 
 REFERENCES RNT_USER_ROLES (ROLE_ID))
/

ALTER TABLE RNT_USER_ASSIGNMENTS ADD (
  CONSTRAINT RNT_USER_ASSIGNMENTS_FK3 
 FOREIGN KEY (BUSINESS_ID) 
 REFERENCES RNT_BUSINESS_UNITS (BUSINESS_ID))
/


ALTER TABLE RNT_AGREEMENT_ACTIONS ADD (
  CONSTRAINT RNT_AGREEMENT_ACTIONS_FK 
 FOREIGN KEY (AGREEMENT_ID) 
 REFERENCES RNT_TENANCY_AGREEMENT (AGREEMENT_ID))
/


ALTER TABLE RNT_LOANS ADD (
  CONSTRAINT RNT_LOANS_FK 
 FOREIGN KEY (PROPERTY_ID) 
 REFERENCES RNT_PROPERTIES (PROPERTY_ID))
/


ALTER TABLE RNT_PAYMENTS ADD (
  CONSTRAINT RNT_PAYMENTS_RNT_TENANT_FK 
 FOREIGN KEY (TENANT_ID) 
 REFERENCES RNT_TENANT (TENANT_ID))
/


ALTER TABLE RNT_PROPERTY_EXPENSES ADD (
  CONSTRAINT RNT_PROPERTY_HISTORY_FK2 
 FOREIGN KEY (UNIT_ID) 
 REFERENCES RNT_PROPERTY_UNITS (UNIT_ID))
/

ALTER TABLE RNT_PROPERTY_EXPENSES ADD (
  CONSTRAINT RNT_PROPERTY_HISTORY_FK 
 FOREIGN KEY (PROPERTY_ID) 
 REFERENCES RNT_PROPERTIES (PROPERTY_ID))
/


ALTER TABLE RNT_ACCOUNTS_PAYABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_PAYABLE_FK 
 FOREIGN KEY (PAYMENT_TYPE_ID) 
 REFERENCES RNT_PAYMENT_TYPES (PAYMENT_TYPE_ID))
/

ALTER TABLE RNT_ACCOUNTS_PAYABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_PAYABLE_FK4 
 FOREIGN KEY (LOAN_ID) 
 REFERENCES RNT_LOANS (LOAN_ID))
/

ALTER TABLE RNT_ACCOUNTS_PAYABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_PAYABLE_FK1 
 FOREIGN KEY (EXPENSE_ID) 
 REFERENCES RNT_PROPERTY_EXPENSES (EXPENSE_ID))
/

ALTER TABLE RNT_ACCOUNTS_PAYABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_PAYABLE_FK2 
 FOREIGN KEY (SUPPLIER_ID) 
 REFERENCES RNT_SUPPLIERS (SUPPLIER_ID))
/


ALTER TABLE RNT_ACCOUNTS_RECEIVABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_RECEIVABLE_FK 
 FOREIGN KEY (TENANT_ID) 
 REFERENCES RNT_TENANT (TENANT_ID))
/

ALTER TABLE RNT_ACCOUNTS_RECEIVABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_RECEIVABLE_FK3 
 FOREIGN KEY (LOAN_ID) 
 REFERENCES RNT_LOANS (LOAN_ID))
/

ALTER TABLE RNT_ACCOUNTS_RECEIVABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_RECEIVABLE_FK4 
 FOREIGN KEY (PAYMENT_TYPE) 
 REFERENCES RNT_PAYMENT_TYPES (PAYMENT_TYPE_ID))
/

ALTER TABLE RNT_ACCOUNTS_RECEIVABLE ADD (
  CONSTRAINT RNT_ACCOUNTS_RECEIVABLE_FK2 
 FOREIGN KEY (AGREEMENT_ID) 
 REFERENCES RNT_TENANCY_AGREEMENT (AGREEMENT_ID))
/


ALTER TABLE RNT_PAYMENT_ALLOCATIONS ADD (
  CONSTRAINT RNT_PAYMENTS_RNT_ACCOUNTS_FK2 
 FOREIGN KEY (AR_ID) 
 REFERENCES RNT_ACCOUNTS_RECEIVABLE (AR_ID))
/

ALTER TABLE RNT_PAYMENT_ALLOCATIONS ADD (
  CONSTRAINT RNT_PAYMENTS_RNT_ACCOUNTS_FK1 
 FOREIGN KEY (AP_ID) 
 REFERENCES RNT_ACCOUNTS_PAYABLE (AP_ID))
/

ALTER TABLE RNT_PAYMENT_ALLOCATIONS ADD (
  CONSTRAINT RNT_PAYMENT_ALLOCATIONS_FK 
 FOREIGN KEY (PAYMENT_ID) 
 REFERENCES RNT_PAYMENTS (PAYMENT_ID))
/
