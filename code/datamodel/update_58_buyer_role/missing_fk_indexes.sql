spool index_creation
-------------------------------                                                 
-- RNT_USER_ASSIGNMENTS                                                         
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_USER_ASSIGNMENTS_PK                                               
---- USER_ASSIGN_ID                                                             
--USERS - RNT_USER_ASSIGNMENTS_U1                                               
---- ROLE_ID                                                                    
---- USER_ID                                                                    
---- BUSINESS_ID                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_user_assignments_n1                                            
on rnt_user_assignments (business_id) tablespace users;                         
--                                                                              
create index rnt_user_assignments_n2                                            
on rnt_user_assignments (user_id) tablespace users;                             
-------------------------------                                                 
-- RNT_ACCOUNTS_PAYABLE                                                         
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_ACCOUNTS_PAYABLE_I1                                               
---- PAYMENT_TYPE_ID                                                            
---- SUPPLIER_ID                                                                
---- PAYMENT_PROPERTY_ID                                                        
---- BUSINESS_ID                                                                
---- RECORD_TYPE                                                                
---- AP_ID                                                                      
--USERS - RNT_ACCOUNTS_PAYABLE_PK                                               
---- AP_ID                                                                      
-- New indexes:                                                                 
--                                                                              
create index rnt_accounts_payable_n1                                            
on rnt_accounts_payable (payment_property_id) tablespace users;                 
--                                                                              
create index rnt_accounts_payable_n2                                            
on rnt_accounts_payable (loan_id) tablespace users;                             
--                                                                              
create index rnt_accounts_payable_n3                                            
on rnt_accounts_payable (supplier_id) tablespace users;                         
--                                                                              
create index rnt_accounts_payable_n4                                            
on rnt_accounts_payable (expense_id) tablespace users;                          
-------------------------------                                                 
-- RNT_ACCOUNTS_RECEIVABLE                                                      
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_ACCOUNTS_RECEIVABLE_I1                                            
---- AR_ID                                                                      
---- PAYMENT_TYPE                                                               
---- TENANT_ID                                                                  
---- AGREEMENT_ID                                                               
---- LOAN_ID                                                                    
---- BUSINESS_ID                                                                
---- IS_GENERATED_YN                                                            
---- AGREEMENT_ACTION_ID                                                        
---- PAYMENT_PROPERTY_ID                                                        
---- SOURCE_PAYMENT_ID                                                          
---- RECORD_TYPE                                                                
--USERS - RNT_ACCOUNTS_RECEIVABLE_PK                                            
---- AR_ID                                                                      
-- New indexes:                                                                 
--                                                                              
create index rnt_accounts_receivable_n1                                         
on rnt_accounts_receivable (source_payment_id) tablespace users;                
--                                                                              
create index rnt_accounts_receivable_n2                                         
on rnt_accounts_receivable (loan_id) tablespace users;                          
--                                                                              
create index rnt_accounts_receivable_n3                                         
on rnt_accounts_receivable (payment_type) tablespace users;                     
--                                                                              
create index rnt_accounts_receivable_n4                                         
on rnt_accounts_receivable (agreement_action_id) tablespace users;              
--                                                                              
create index rnt_accounts_receivable_n5                                         
on rnt_accounts_receivable (tenant_id) tablespace users;                        
--                                                                              
create index rnt_accounts_receivable_n6                                         
on rnt_accounts_receivable (payment_property_id) tablespace users;              
-------------------------------                                                 
-- RNT_EXPENSE_ITEMS                                                            
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_EXPENSE_ITEMS_PK                                                  
---- EXPENSE_ITEM_ID                                                            
--USERS - RNT_EXPENSE_ITEMS_U1                                                  
---- EXPENSE_ID                                                                 
---- SUPPLIER_ID                                                                
---- ITEM_NAME                                                                  
-- New indexes:                                                                 
--                                                                              
create index rnt_expense_items_n1                                               
on rnt_expense_items (supplier_id) tablespace users;                            
-------------------------------                                                 
-- RNT_SECTION8_OFFICES_BU                                                      
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_SECTION8_OFFICES_BU_PK                                            
---- SECTION8_BUSINESS_ID                                                       
--USERS - RNT_SECTION8_OFFICES_BU_U1                                            
---- SECTION8_ID                                                                
---- BUSINESS_ID                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_section8_offices_bu_n1                                         
on rnt_section8_offices_bu (business_id) tablespace users;                      
-------------------------------                                                 
-- RNT_PROPERTY_EXPENSES                                                        
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_PROPERTY_EXPENSES_PK                                              
---- EXPENSE_ID                                                                 
--USERS - RNT_PROPERTY_HISTORY_UK1                                              
---- PROPERTY_ID                                                                
---- EVENT_DATE                                                                 
---- UNIT_ID                                                                    
---- DESCRIPTION                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_property_expenses_n1                                           
on rnt_property_expenses (unit_id) tablespace users;                            
-------------------------------                                                 
-- RNT_SUPPLIERS_OLD                                                            
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_CONTRACTORS_PK                                                    
---- SUPPLIER_ID                                                                
--USERS - RNT_CONTRACTORS_UK1                                                   
---- NAME                                                                       
---- BUSINESS_ID                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_contractors_n1                                                 
on rnt_suppliers_old (business_id) tablespace users;                            
-------------------------------                                                 
-- RNT_BU_SUPPLIERS                                                             
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_BU_SUPPLIERS_PK                                                   
---- BU_SUPPLIER_ID                                                             
--USERS - RNT_BU_SUPPLIERS_U1                                                   
---- BUSINESS_ID                                                                
---- SUPPLIER_ID                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_bu_suppliers_n1                                                
on rnt_bu_suppliers (supplier_id) tablespace users;                             
-------------------------------                                                 
-- RNT_PAYMENTS                                                                 
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_PAYMENTS_PK                                                       
---- PAYMENT_ID                                                                 
--USERS - RNT_PAYMENTS_UK1                                                      
---- PAYMENT_DATE                                                               
---- DESCRIPTION                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_payments_n1                                                    
on rnt_payments (tenant_id) tablespace users;                                   
-------------------------------                                                 
-- RNT_PEOPLE_BU                                                                
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_PEOPLE_BU_PK                                                      
---- PEOPLE_BUSINESS_ID                                                         
--USERS - RNT_PEOPLE_BU_U1                                                      
---- PEOPLE_ID                                                                  
---- BUSINESS_ID                                                                
-- New indexes:                                                                 
--                                                                              
create index rnt_people_bu_n1                                                   
on rnt_people_bu (business_id) tablespace users;                                
-------------------------------                                                 
-- RNT_PROPERTY_PHOTOS                                                          
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_PROPERTY_PHOTOS_PK                                                
---- PHOTO_ID                                                                   
-- New indexes:                                                                 
--                                                                              
create index rnt_property_photos_n1                                             
on rnt_property_photos (property_id) tablespace users;                          
-------------------------------                                                 
-- RNT_PROPERTY_ESTIMATES                                                       
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_PROPERTY_ESTIMATES_PK                                             
---- PROPERTY_ESTIMATES_ID                                                      
--USERS - RNT_PROPERTY_ESTIMATES_U1                                             
---- PROPERTY_ID                                                                
---- BUSINESS_ID                                                                
---- ESTIMATE_YEAR                                                              
---- ESTIMATE_TITLE                                                             
-- New indexes:                                                                 
--                                                                              
create index rnt_property_estimates_n1                                          
on rnt_property_estimates (business_id) tablespace users;                       
-------------------------------                                                 
-- RNT_TENANT                                                                   
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_TENANT_PK                                                         
---- TENANT_ID                                                                  
--USERS - RNT_TENANT_U1                                                         
---- AGREEMENT_ID                                                               
---- PEOPLE_ID                                                                  
-- New indexes:                                                                 
--                                                                              
create index rnt_tenant_n1                                                      
on rnt_tenant (section8_id) tablespace users;                                   
--                                                                              
create index rnt_tenant_n2                                                      
on rnt_tenant (people_id) tablespace users;                                     
-------------------------------                                                 
-- RNT_PAYMENT_ALLOCATIONS                                                      
-------------------------------                                                 
-- Existing indexes:                                                            
--USERS - RNT_PAYMENT_ALLOCATIONS_I1                                            
---- PAY_ALLOC_ID                                                               
---- PAYMENT_ID                                                                 
---- AR_ID                                                                      
---- AP_ID                                                                      
--USERS - RNT_PAYMENT_ALLOC_PK                                                  
---- PAY_ALLOC_ID                                                               
-- New indexes:                                                                 
--                                                                              
create index rnt_payment_alloc_n1                                               
on rnt_payment_allocations (payment_id) tablespace users;                       
--                                                                              
create index rnt_payment_alloc_n2                                               
on rnt_payment_allocations (ap_id) tablespace users;                            
--                                                                              
create index rnt_payment_alloc_n3                                               
on rnt_payment_allocations (ar_id) tablespace users;                            

spool off
