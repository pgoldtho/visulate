set define ^

begin

-- R-VACANT RESIDENTIAL LAND - MULTI FAMILY PLATTED                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 7                                                                               
                                , X_DESCRIPTION  => 'Vacant Residential Land - Multi Family Platted'                                
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT MULTI-FAMILY UNPLATTED LESS THAN 5 ACRES                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 8                                                                               
                                , X_DESCRIPTION  => 'Vacant Multi-Family Unplatted Less Than 5 Acres'                               
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT SINGLE FAMILY UNPLATTED LESS THAN 5 ACRES                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 9                                                                               
                                , X_DESCRIPTION  => 'Vacant Single Family Unplatted Less Than 5 Acres'                              
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT RESIDENTIAL LAND - SINGLE FAMILY PLATTED                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 10                                                                              
                                , X_DESCRIPTION  => 'Vacant Residential Land - Single Family Platted'                               
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT MOBILE HOME SITE - PLATTED                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 20                                                                              
                                , X_DESCRIPTION  => 'Vacant Mobile Home Site - Platted'                                             
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT MOBILE HOME SITE - UNPLATTED                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 21                                                                              
                                , X_DESCRIPTION  => 'Vacant Mobile Home Site - Unplatted'                                           
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT RESIDENTIAL COMMON AREA                                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 33                                                                              
                                , X_DESCRIPTION  => 'Vacant Residential Common Area'                                                
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT CONDOMINIUM UNIT -   LAND                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 40                                                                              
                                , X_DESCRIPTION  => 'Condominium Unit - Vacant Land'                                                
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM UNIT WITH UTILITIES                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 41                                                                              
                                , X_DESCRIPTION  => 'Condominium Unit With Utilities'                                               
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-VACANT CO-OP   LAND                                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 50                                                                              
                                , X_DESCRIPTION  => 'Co-Op Vacant Land'                                                             
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT CO-OP   WITH UTILITIES                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 51                                                                              
                                , X_DESCRIPTION  => 'Co-Op Vacant With Utilities'                                                   
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-SINGLE FAMILY RESIDENCE                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 110                                                                             
                                , X_DESCRIPTION  => 'Single Family Residence'                                                       
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-SINGLE FAMILY - MODULAR                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 113                                                                             
                                , X_DESCRIPTION  => 'Single Family - Modular'                                                       
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-1/2 DUPLEX USED AS SFR                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 121                                                                             
                                , X_DESCRIPTION  => '1/2 Duplex Used As Sfr'                                                        
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-RESIDENTIAL RELATED AMENITIES                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 132                                                                             
                                , X_DESCRIPTION  => 'Residential Related Amenities'                                                 
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-IMPROVED RESIDENTIAL COMMON AREA                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 133                                                                             
                                , X_DESCRIPTION  => 'Improved Residential Common Area'                                              
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-TOWNHOUSE                                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 135                                                                             
                                , X_DESCRIPTION  => 'Townhouse'                                                                     
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-RESIDENTIAL IMPROVEMENT NOT SUITABLE FOR OCCUPANCY                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 164                                                                             
                                , X_DESCRIPTION  => 'Residential Improvement Not Suitable For Occupancy'                            
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- M-MANUFACTURED HOUSING-SINGLE                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 212                                                                             
                                , X_DESCRIPTION  => 'Manufactured Housing-Single'                                                   
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- M-MANUFACTURED HOUSING-DOUBLE                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 213                                                                             
                                , X_DESCRIPTION  => 'Manufactured Housing-Double'                                                   
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- M-MANUFACTURED HOUSING-TRIPLE                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 214                                                                             
                                , X_DESCRIPTION  => 'Manufactured Housing-Triple'                                                   
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- M-RESIDENTIAL RELATED AMMENITY ON MANUFACT URED HOME SITE                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 232                                                                             
                                , X_DESCRIPTION  => 'Residential Related Ammenity On Manufactured Home Site'                       
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-MANUFACTURED HOUSING RENTAL LOT W/IMPROVEMENTS (WITH MANUFACTURED HOME)                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 237                                                                             
                                , X_DESCRIPTION  => 'Manufactured Housing Rental Lot W/Improvements (With Manufactured Home)'       
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-MANUFACTURED HOUSING RENTAL LOT WITH IMPROVEMENTS (NO MANUFACTURED HOME)                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 238                                                                             
                                , X_DESCRIPTION  => 'Manufactured Housing Rental Lot With Improvements (No Manufactured Home)'      
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-MANUFACTURED HOUSING RENTAL LOT WITHOUT IMPROVEMENTS (NO MANUFACTURED HOME)                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 239                                                                             
                                , X_DESCRIPTION  => 'Manufactured Housing Rental Lot Without Improvements (No Manufactured Home)'   
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- M-MANUFACTURED HOME NOT SUITABLE FOR OCCUP ANCY                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 264                                                                             
                                , X_DESCRIPTION  => 'Manufactured Home Not Suitable For Occup Ancy'                                 
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-GARDEN APARTMENTS - 1 STORY - 10 TO 49 UNITS                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 351                                                                             
                                , X_DESCRIPTION  => 'Garden Apartments - 1 Story - 10 To 49 Units'                                  
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-GARDEN APARTMENTS - 1 STORY - 50 UNITS AND UP                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 352                                                                             
                                , X_DESCRIPTION  => 'Garden Apartments - 1 Story - 50 Units And Up'                                 
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-LOW RISE APARTMENTS- 10 TO 49 UNITS- 2 OR 3 STORIES                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 353                                                                             
                                , X_DESCRIPTION  => 'Low Rise Apartments- 10 To 49 Units- 2 Or 3 Stories'                           
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-LOW RISE APARTMENTS- 50 UNITS AND UP- 2 OR 3 STORIES                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 354                                                                             
                                , X_DESCRIPTION  => 'Low Rise Apartments- 50 Units And Up- 2 Or 3 Stories'                          
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-HIGH RISE APARTMENTS- 4 STORIES AND UP                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 355                                                                             
                                , X_DESCRIPTION  => 'High Rise Apartments- 4 Stories And Up'                                        
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-TOWNHOUSE APARTMENTS                                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 356                                                                             
                                , X_DESCRIPTION  => 'Townhouse Apartments'                                                          
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM UNIT                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 414                                                                             
                                , X_DESCRIPTION  => 'Condominium Unit'                                                              
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-TIME SHARE CONDO                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 421                                                                             
                                , X_DESCRIPTION  => 'Time Share Condo'                                                              
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM - MANUFACTURED HOME PARK                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 422                                                                             
                                , X_DESCRIPTION  => 'Condominium - Manufactured Home Park'                                          
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM - RESIDENTIAL UNIT USED IN C ONJUNCTION WITH ANOTHER UNIT                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 430                                                                             
                                , X_DESCRIPTION  => 'Condominium - Residential Unit Used In Conjunction With Another Unit'         
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM-TRANSFERABLE LIMITED COMMON element                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 432                                                                             
                                , X_DESCRIPTION  => 'Condominium-Transferable Limited Common Element'                               
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-IMPROVED CONDOMINIUM COMMON AREA                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 433                                                                             
                                , X_DESCRIPTION  => 'Improved Condominium Common Area'                                              
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CONDO MANUFACTURED HOUSING RENTAL LOT W/IMPROVEMENTS (WITH MANUFACTURED HOME)                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 437                                                                             
                                , X_DESCRIPTION  => 'Condo Manufactured Housing Rental Lot W/Improvements (With Manufactured Home)' 
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM - IMPROVED WITH NO MANUFACTU RED HOME                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 438                                                                             
                                , X_DESCRIPTION  => 'Condominium - Improved With No Manufactured Home'                             
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM UNIT WITH SITE IMPROVEMENTS                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 441                                                                             
                                , X_DESCRIPTION  => 'Condominium Unit With Site Improvements'                                       
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM NOT SUITABLE FOR OCCUPANCY                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 464                                                                             
                                , X_DESCRIPTION  => 'Condominium Not Suitable For Occupancy'                                        
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CONDOMINIUM - MISCELLANEOUS (NOT COVERED  BY OTHER CODES)                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 465                                                                             
                                , X_DESCRIPTION  => 'Condominium - Miscellaneous (Not Covered  By Other Codes)'                     
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-COOPERATIVE                                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 514                                                                             
                                , X_DESCRIPTION  => 'Cooperative'                                                                   
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-CO-OP MANUFACTURED HOME - IMPROVED                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 522                                                                             
                                , X_DESCRIPTION  => 'Co-Op Manufactured Home - Improved'                                            
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-CO-OP MANUFACTURED HOUSING RENTAL LOT W/IMPROVEMENTS (WITH MANUFACTURED HOME)                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 537                                                                             
                                , X_DESCRIPTION  => 'Co-Op Manufactured Housing Rental Lot W/Improvements (With Manufactured Home)' 
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-CO-OP IMPROVED (WITHOUT MANUFACTURED HOM E)                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 538                                                                             
                                , X_DESCRIPTION  => 'Co-Op Improved (Without Manufactured Home)'                                   
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- M-CO-OP WITH SITE IMPROVEMENTS                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 541                                                                             
                                , X_DESCRIPTION  => 'Co-Op With Site Improvements'                                                  
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-CO-OP NOT SUITABLE FOR OCCUPANCY                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 564                                                                             
                                , X_DESCRIPTION  => 'Co-Op Not Suitable For Occupancy'                                              
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-RETIREMENT HOME                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 616                                                                             
                                , X_DESCRIPTION  => 'Retirement Home'                                                               
                                , X_PARENT_UCODE => 18);                                                                              
                                                                                                                                    
-- C-MIGRANT CAMPS, BOARDING HOMES, ETC                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 700                                                                             
                                , X_DESCRIPTION  => 'Migrant Camps, Boarding Homes, Etc'                                            
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-BED AND BREAKFAST                                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 719                                                                             
                                , X_DESCRIPTION  => 'Bed And Breakfast'                                                             
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- R-HOUSE AND IMPROVEMENT NOT SUITABLE FOR OCCUPANCY                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 815                                                                             
                                , X_DESCRIPTION  => 'House And Improvement Not Suitable For Occupancy'                              
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-HOUSE AND MOBILE HOME                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 817                                                                             
                                , X_DESCRIPTION  => 'House And Mobile Home'                                                         
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-TWO OR THREE MOBILE HOMES, NOT A PARK                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 818                                                                             
                                , X_DESCRIPTION  => 'Two Or Three Mobile Homes, Not A Park'                                         
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- RC-TWO RESIDENTIAL UNITS - NOT ATTACHED                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 819                                                                             
                                , X_DESCRIPTION  => 'Two Residential Units - Not Attached'                                          
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- C-DUPLEX                                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 820                                                                             
                                , X_DESCRIPTION  => 'Duplex'                                                                        
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-TRIPLEX                                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 830                                                                             
                                , X_DESCRIPTION  => 'Triplex'                                                                       
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- R-TWO OR MORE TOWNHOUSES                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 834                                                                             
                                , X_DESCRIPTION  => 'Two Or More Townhouses'                                                        
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- R-TWO OR MORE MANUFACTURED HOUSING RENTAL LOTS (WITH MANUFACTURED HOME(S)                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 837                                                                             
                                , X_DESCRIPTION  => 'Two Or More Manufactured Housing Rental Lots (With Manufactured Home(S)'       
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-TWO OR MORE MANUFACTURED HOUSING RENTAL LOTS (WITHOUT MANUFACTURED HOME(S)                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 838                                                                             
                                , X_DESCRIPTION  => 'Two Or More Manufactured Housing Rental Lots (Without Manufactured Home(S)'    
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- R-THREE OR FOUR LIVING UNITS - NOT ATTACHED                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 839                                                                             
                                , X_DESCRIPTION  => 'Three Or Four Living Units - Not Attached'                                     
                                , X_PARENT_UCODE => 1);                                                                              
                                                                                                                                    
-- C-QUADRUPLEX                                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 840                                                                             
                                , X_DESCRIPTION  => 'Quadruplex'                                                                    
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-MULTIPLE LIVING UNITS (5 TO 9 UNITS)                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 850                                                                             
                                , X_DESCRIPTION  => 'Multiple Living Units (5 To 9 Units)'                                          
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-MULTIPLE LIVING UNITS (5 TO 9 UNITS)-NOT  ATTACHED                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 859                                                                             
                                , X_DESCRIPTION  => 'Multiple Living Units (5 To 9 Units)-Not  Attached'                            
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-MULTI-FAMILY IMPROVEMENT NOT SUITABLE FO R OCCUPANCY                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 864                                                                             
                                , X_DESCRIPTION  => 'Multi-Family Improvement Not Suitable For Occupancy'                          
                                , X_PARENT_UCODE => 11);                                                                              
                                                                                                                                    
-- C-VACANT COMMERCIAL LAND                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 1000                                                                            
                                , X_DESCRIPTION  => 'Vacant Commercial Land'                                                        
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT COMMERCIAL COMMON AREA                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 1033                                                                            
                                , X_DESCRIPTION  => 'Vacant Commercial Common Area'                                                 
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-RETAIL STORE- 1 UNIT                                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 1100                                                                            
                                , X_DESCRIPTION  => 'Retail Store- 1 Unit'                                                          
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-CONDOMINIUM - STORE                                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 1104                                                                            
                                , X_DESCRIPTION  => 'Condominium - Store'                                                           
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-RETAIL DRUGSTORE - NOT ATTACHED                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 1105                                                                            
                                , X_DESCRIPTION  => 'Retail Drugstore - Not Attached'                                               
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-RETAIL STORE - MULTIPLE UNITS                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 1110                                                                            
                                , X_DESCRIPTION  => 'Retail Store - Multiple Units'                                                 
                                , X_PARENT_UCODE => 15);                                                                              
                                                                                                                                    
-- -RETAIL TIRE STORE                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 1115                                                                            
                                , X_DESCRIPTION  => 'Retail Tire Store'                                                             
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-CONVENIENCE STORE                                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 1125                                                                            
                                , X_DESCRIPTION  => 'Convenience Store'                                                             
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-CONVENIENCE STORE WITH GAS PUMP                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 1130                                                                            
                                , X_DESCRIPTION  => 'Convenience Store With Gas Pump'                                               
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-RETAIL- SHELL BUILDING                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 1138                                                                            
                                , X_DESCRIPTION  => 'Retail- Shell Building'                                                        
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-WAREHOUSE DISCOUNT STORE                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 1150                                                                            
                                , X_DESCRIPTION  => 'Warehouse Discount Store'                                                      
                                , X_PARENT_UCODE => 15);                                                                              
                                                                                                                                    
-- C-COMMERCIAL SHELL BLDG (CONDO)                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 1204                                                                            
                                , X_DESCRIPTION  => 'Commercial Shell Bldg (Condo)'                                                 
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-MIXED USE- COMMERCIAL PROPERTY                                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 1210                                                                            
                                , X_DESCRIPTION  => 'Mixed Use- Commercial Property'                                                
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-COMMERCIAL RELATED AMENITIES                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 1222                                                                            
                                , X_DESCRIPTION  => 'Commercial Related Amenities'                                                  
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-IMPROVED COMMERCIAL COMMON AREA                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 1233                                                                            
                                , X_DESCRIPTION  => 'Improved Commercial Common Area'                                               
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-COMMERICAL SHELL BLDG (OTHER)                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 1238                                                                            
                                , X_DESCRIPTION  => 'Commerical Shell Bldg (Other)'                                                 
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-COMMERCIAL IMPROVEMENT NOT SUITABLE FOR OCCUPANCY                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 1264                                                                            
                                , X_DESCRIPTION  => 'Commercial Improvement Not Suitable For Occupancy'                             
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-DEPARTMENT STORE                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 1300                                                                            
                                , X_DESCRIPTION  => 'Department Store'                                                              
                                , X_PARENT_UCODE => 15);                                                                              
                                                                                                                                    
-- C-SUPERMARKET                                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 1400                                                                            
                                , X_DESCRIPTION  => 'Supermarket'                                                                   
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-REGIONAL SHOPPING MALL                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 1500                                                                            
                                , X_DESCRIPTION  => 'Regional Shopping Mall'                                                        
                                , X_PARENT_UCODE => 15);                                                                              
                                                                                                                                    
-- C-SHOPPING COMPLEX - COMMUNITY/ NEIGHBORHOOD                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 1600                                                                            
                                , X_DESCRIPTION  => 'Shopping Complex - Community/ Neighborhood'                                    
                                , X_PARENT_UCODE => 15);                                                                              
                                                                                                                                    
-- C-SHOPPING CENTER  - NEIGHBORHOOD                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 1610                                                                            
                                , X_DESCRIPTION  => 'Shopping Center  - Neighborhood'                                               
                                , X_PARENT_UCODE => 15);                                                                              
                                                                                                                                    
-- C-OFFICE BUILDING- SINGLE TENANT- 1 STORY                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 1700                                                                            
                                , X_DESCRIPTION  => 'Office Building- Single Tenant- 1 Story'                                       
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-CONDOMINIUM OFFICE UNIT                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 1704                                                                            
                                , X_DESCRIPTION  => 'Condominium Office Unit'                                                       
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-OFFICE BUILDING- MULTI TENANT- 1 STORY                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 1710                                                                            
                                , X_DESCRIPTION  => 'Office Building- Multi Tenant- 1 Story'                                        
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-OFFICE- SHELL BUILDING                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 1738                                                                            
                                , X_DESCRIPTION  => 'Office- Shell Building'                                                        
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-OFFICE BUILDING- SINGLE TENANT- 2 OR MORE STORIES                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 1800                                                                            
                                , X_DESCRIPTION  => 'Office Building- Single Tenant- 2 Or More Stories'                             
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-OFFICE BUILDING- MULTI TENANT- 2 OR MORE STORIES                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 1810                                                                            
                                , X_DESCRIPTION  => 'Office Building- Multi Tenant- 2 Or More Stories'                              
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-PROFESSIONAL BUILDING- SINGLE TENANT-  1 STORY                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 1900                                                                            
                                , X_DESCRIPTION  => 'Professional Building- Single Tenant-  1 Story'                                
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-PROFESSIONAL BUILDING- MULTI TENANT- 1 STORY                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 1910                                                                            
                                , X_DESCRIPTION  => 'Professional Building- Multi Tenant- 1 Story'                                  
                                , X_PARENT_UCODE => 12 );                                                                              
                                                                                                                                    
-- C-PROFESSIONAL BUILDING- SINGLE TENANT- 2  OR MORE STORIES                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 1920                                                                            
                                , X_DESCRIPTION  => 'Professional Building- Single Tenant- 2  Or More Stories'                      
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-PROFESSIONAL BUILDING- MULTI TENANT- 2 OR MORE STORIES                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 1930                                                                            
                                , X_DESCRIPTION  => 'Professional Building- Multi Tenant- 2 Or More Stories'                        
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-PROFESSIONAL/OFFICE COMPLEX                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 1940                                                                            
                                , X_DESCRIPTION  => 'Professional/Office Complex'                                                   
                                , X_PARENT_UCODE => 12);                                                                              
                                                                                                                                    
-- C-DAY CARE CENTER                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 1950                                                                            
                                , X_DESCRIPTION  => 'Day Care Center'                                                               
                                , X_PARENT_UCODE => 19);                                                                              
                                                                                                                                    
-- C-RADIO OR TV STATION                                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 1960                                                                            
                                , X_DESCRIPTION  => 'Radio Or Tv Station'                                                           
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-AIRPORTS - PRIVATE                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 2000                                                                            
                                , X_DESCRIPTION  => 'Airports - Private'                                                            
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-AIRPORTS - COMMERCIAL                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 2010                                                                            
                                , X_DESCRIPTION  => 'Airports - Commercial'                                                         
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-MARINAS                                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 2015                                                                            
                                , X_DESCRIPTION  => 'Marinas'                                                                       
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-RESTAURANT / CAFETERIA                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 2100                                                                            
                                , X_DESCRIPTION  => 'Restaurant / Cafeteria'                                                        
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-CONDOMINIUM-RESTAURANT                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 2104                                                                            
                                , X_DESCRIPTION  => 'Condominium-Restaurant'                                                        
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-FAST FOOD RESTAURANT                                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 2110                                                                            
                                , X_DESCRIPTION  => 'Fast Food Restaurant'                                                          
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-FINANCIAL INSTITUTION                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 2300                                                                            
                                , X_DESCRIPTION  => 'Financial Institution'                                                         
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-FINANCIAL INSTITUTION - BRANCH FACILITY                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 2310                                                                            
                                , X_DESCRIPTION  => 'Financial Institution - Branch Facility'                                       
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-INSURANCE CO. - OFFICE                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 2400                                                                            
                                , X_DESCRIPTION  => 'Insurance Co. - Office'                                                        
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-SERVICE SHOP, RADIO & T.V. REPAIR, REFRIGERATION SERVICE,PAINT SHOP, ELEC                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 2500                                                                            
                                , X_DESCRIPTION  => 'Service Shop, Radio & T.V. Repair, Refrigeration Service,Paint Shop, Elec'     
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-SERVICE STATION                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 2600                                                                            
                                , X_DESCRIPTION  => 'Service Station'                                                               
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-DEALERSHIP SALES / SERVICE CENTER                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 2700                                                                            
                                , X_DESCRIPTION  => 'Dealership Sales / Service Center'                                             
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-GARAGE / AUTO-BODY /AUTO PAINT SHOP                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 2710                                                                            
                                , X_DESCRIPTION  => 'Garage / Auto-Body /Auto Paint Shop'                                           
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-MINI-LUBE SERVICE SPECIALIST                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 2715                                                                            
                                , X_DESCRIPTION  => 'Mini-Lube Service Specialist'                                                  
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-CAR WASH                                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 2720                                                                            
                                , X_DESCRIPTION  => 'Car Wash'                                                                      
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-USED AUTOMOBILE SALES                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 2730                                                                            
                                , X_DESCRIPTION  => 'Used Automobile Sales'                                                         
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-PARKING LOT  - COMMERCIAL                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 2800                                                                            
                                , X_DESCRIPTION  => 'Parking Lot  - Commercial'                                                     
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-PARKING LOT  - PATRON                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 2810                                                                            
                                , X_DESCRIPTION  => 'Parking Lot  - Patron'                                                         
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 4 TO 9 SPACES RENTALS                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 2890                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 4 To 9 Spaces Rentals'                                   
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 10 TO 25 SPACES RENTALS                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 2891                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 10 To 25 Spaces Rentals'                                 
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 26 TO 50 SPACES RENTALS                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 2892                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 26 To 50 Spaces Rentals'                                 
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 51 TO 100 SPACES RENTALS                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 2893                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 51 To 100 Spaces Rentals'                                
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 101 TO 150 SPACES RENTALS                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 2894                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 101 To 150 Spaces Rentals'                               
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 151 TO 200 SPACES RENTALS                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 2895                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 151 To 200 Spaces Rentals'                               
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-MANUF. HOUSING PARK - 201 & MORE SPACES RENTALS                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 2896                                                                            
                                , X_DESCRIPTION  => 'Manuf. Housing Park - 201 & More Spaces Rentals'                               
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-WHOLESALE OUTLET                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 2900                                                                            
                                , X_DESCRIPTION  => 'Wholesale Outlet'                                                              
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-PRODUCE HOUSE                                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 2910                                                                            
                                , X_DESCRIPTION  => 'Produce House'                                                                 
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-FLORIST                                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 3000                                                                            
                                , X_DESCRIPTION  => 'Florist'                                                                       
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-GREENHOUSE                                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 3010                                                                            
                                , X_DESCRIPTION  => 'Greenhouse'                                                                    
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-NURSERY (NON-AGRIC. CLASSIFICATION)                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 3020                                                                            
                                , X_DESCRIPTION  => 'Nursery (Non-Agric. Classification)'                                           
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-HORSE STABLES                                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 3030                                                                            
                                , X_DESCRIPTION  => 'Horse Stables'                                                                 
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-DOG KENNEL                                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 3040                                                                            
                                , X_DESCRIPTION  => 'Dog Kennel'                                                                    
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-THEATRE  (DRIVE-IN)                                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 3100                                                                            
                                , X_DESCRIPTION  => 'Theatre  (Drive-In)'                                                           
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-STADIUM  (NOT ENCLOSED)                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 3120                                                                            
                                , X_DESCRIPTION  => 'Stadium  (Not Enclosed)'                                                       
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-AUDITORIUM  (ENCLOSED)                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 3200                                                                            
                                , X_DESCRIPTION  => 'Auditorium  (Enclosed)'                                                        
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-THEATRE (ENCLOSED)                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 3210                                                                            
                                , X_DESCRIPTION  => 'Theatre (Enclosed)'                                                            
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-RECREATION HALL                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 3220                                                                            
                                , X_DESCRIPTION  => 'Recreation Hall'                                                               
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-FITNESS CENTER                                                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 3230                                                                            
                                , X_DESCRIPTION  => 'Fitness Center'                                                                
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-NIGHT CLUBS, COCKTAIL LOUNGES, BARS                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 3300                                                                            
                                , X_DESCRIPTION  => 'Night Clubs, Cocktail Lounges, Bars'                                           
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-BOWLING ALLEYS, SKATING RINKS, AND POOL HALLS                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 3400                                                                            
                                , X_DESCRIPTION  => 'Bowling Alleys, Skating Rinks, And Pool Halls'                                 
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-ARENA  (ENCLOSED)                                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 3430                                                                            
                                , X_DESCRIPTION  => 'Arena  (Enclosed)'                                                             
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-ARENA  (OPEN AIR) WITH SUPPORTING FACILITIES                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 3440                                                                            
                                , X_DESCRIPTION  => 'Arena  (Open Air) With Supporting Facilities'                                  
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-FLEA MARKET                                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 3450                                                                            
                                , X_DESCRIPTION  => 'Flea Market'                                                                   
                                , X_PARENT_UCODE => 14);                                                                              
                                                                                                                                    
-- C-TOURIST ATTRACTION                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 3500                                                                            
                                , X_DESCRIPTION  => 'Tourist Attraction'                                                            
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-PERMANENT EXHIBIT                                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 3510                                                                            
                                , X_DESCRIPTION  => 'Permanent Exhibit'                                                             
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-CAMP  (OTHER THAN FOR MOBILE HOMES)                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 3600                                                                            
                                , X_DESCRIPTION  => 'Camp  (Other Than For Mobile Homes)'                                           
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-CAMPGROUND (TRAILERS, CAMPERS & TENTS)                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 3610                                                                            
                                , X_DESCRIPTION  => 'Campground (Trailers, Campers & Tents)'                                        
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-LABOR CAMP                                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 3693                                                                            
                                , X_DESCRIPTION  => 'Labor Camp'                                                                    
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-RACE TRACK / WAGERING ATTRACTION                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 3700                                                                            
                                , X_DESCRIPTION  => 'Race Track / Wagering Attraction'                                              
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-CORRECTIONAL FACILITY                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 3710                                                                            
                                , X_DESCRIPTION  => 'Correctional Facility'                                                         
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-POSTAL FACILITY                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 3720                                                                            
                                , X_DESCRIPTION  => 'Postal Facility'                                                               
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-GOLF COURSE                                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 3800                                                                            
                                , X_DESCRIPTION  => 'Golf Course'                                                                   
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-DRIVING RANGE                                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 3810                                                                            
                                , X_DESCRIPTION  => 'Driving Range'                                                                 
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-COUNTRY CLUB / SUPPORT FACILITIES                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 3820                                                                            
                                , X_DESCRIPTION  => 'Country Club / Support Facilities'                                             
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-MOTOR INN                                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 3900                                                                            
                                , X_DESCRIPTION  => 'Motor Inn'                                                                     
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-LIMITED SERVICE HOTEL                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 3910                                                                            
                                , X_DESCRIPTION  => 'Limited Service Hotel'                                                         
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-FULL SERVICE HOTEL                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 3920                                                                            
                                , X_DESCRIPTION  => 'Full Service Hotel'                                                            
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-EXTENDED STAY OR SUITE HOTEL                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 3930                                                                            
                                , X_DESCRIPTION  => 'Extended Stay Or Suite Hotel'                                                  
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-LUXURY HOTEL/RESORT                                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 3940                                                                            
                                , X_DESCRIPTION  => 'Luxury Hotel/Resort'                                                           
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-CONVENTION HOTEL/RESORT                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 3950                                                                            
                                , X_DESCRIPTION  => 'Convention Hotel/Resort'                                                       
                                , X_PARENT_UCODE => 17);                                                                              
                                                                                                                                    
-- C-VACANT INDUSTRIAL LAND                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 4000                                                                            
                                , X_DESCRIPTION  => 'Vacant Industrial Land'                                                        
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-LIGHT MANUFACTURING,SMALL EQUIPT.MFG. PLANTS,SM.MACHINE SHOPS,INSTRUMENT MFG.,                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 4100                                                                            
                                , X_DESCRIPTION  => 'Light Manufacturing,Small Equipt.Mfg. Plants,Sm.Machine Shops,Instrument Mfg.,'
                                                                                                                                    
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-HEAVY INDUSTRIAL,HEAVY EQUIPMENT MFG., LARGE MACHINE SHOPS,FOUNDRIES,STEEL                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 4200                                                                            
                                , X_DESCRIPTION  => 'Heavy Industrial,Heavy Equipment Mfg., Large Machine Shops,Foundries,Steel'    
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-LUMBER YARD, SAWMILL, PLANING MILL                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 4300                                                                            
                                , X_DESCRIPTION  => 'Lumber Yard, Sawmill, Planing Mill'                                            
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-PACKING PLANT, FRUIT & VEGETABLE PACKING PLANT, MEAT PACKING PLANT                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 4400                                                                            
                                , X_DESCRIPTION  => 'Packing Plant, Fruit & Vegetable Packing Plant, Meat Packing Plant'            
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-CANNERIES, FRUIT & VEGETABLE, BOTTLERS & BREWERS DISTILLERIES, WINERIES                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 4500                                                                            
                                , X_DESCRIPTION  => 'Canneries, Fruit & Vegetable, Bottlers & Brewers Distilleries, Wineries'       
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-OTHER FOOD PROCESSING, CANDY FACTORIES, BAKERIES, POTATO CHIP FACTORIES                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 4600                                                                            
                                , X_DESCRIPTION  => 'Other Food Processing, Candy Factories, Bakeries, Potato Chip Factories'       
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-MINERAL PROCESSING, PHOSPHATE PROCESSING REFINERY, CLAY PLANT, ROCK & GRAVEL                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 4700                                                                            
                                , X_DESCRIPTION  => 'Mineral Processing, Phosphate Processing Refinery, Clay Plant, Rock & Gravel'  
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-CONCRETE / ASPHALT PLANT                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 4710                                                                            
                                , X_DESCRIPTION  => 'Concrete / Asphalt Plant'                                                      
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-WAREHOUSING, DISTRIBUTION_TERMINAL, TRUCKING TERMINAL, VAN & STORAGE                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 4800                                                                            
                                , X_DESCRIPTION  => 'Warehousing, Distribution_Terminal, Trucking Terminal, Van & Storage'          
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-CONDOMINIUM - WAREHOUSING                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 4804                                                                            
                                , X_DESCRIPTION  => 'Condominium - Warehousing'                                                     
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-MINI-WAREHOUSING                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 4810                                                                            
                                , X_DESCRIPTION  => 'Mini-Warehousing'                                                              
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-WAREHOUSE - FLEX SPACE                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 4830                                                                            
                                , X_DESCRIPTION  => 'Warehouse - Flex Space'                                                        
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-OPEN STORAGE, NEW AND USED BUILDING SUPPLIES, JUNK YARDS, AUTO WRECKING,FUEL                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 4900                                                                            
                                , X_DESCRIPTION  => 'Open Storage, New And Used Building Supplies, Junk Yards, Auto Wrecking,Fuel'  
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-VACANT CROPLAND - SOIL CAPABILITY CLASS I                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 5100                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class I Vacant'                                     
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-CROPLAND - SOIL CAPABILITY CLASS I WITH RESIDENCE                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 5110                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class I With Residence'                             
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-CROPLAND - SOIL CAPABILITY CLASS I WITH BUILDINGS OTHER THAN RESIDENCE                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 5120                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class I With Buildings Other Than Residence'        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT CROPLAND - SOIL CAPABILITY CLASS II                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 5200                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class Ii Vacant'                                    
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-CROPLAND - SOIL CAPABILITY CLASS II WITH RESIDENCE                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 5210                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class Ii With Residence'                            
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-CROPLAND - SOIL CAPABILITY CLASS II WITH BUILDINGS OTHER THAN RESIDENCE                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 5220                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class Ii With Buildings Other Than Residence'       
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT CROPLAND - SOIL CAPABILITY CLASS III                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 5300                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class Iii Vacant'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-CROPLAND - SOIL CAPABILITY CLASS III WITH RESIDENCE                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 5310                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class Iii With Residence'                           
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-CROPLAND - SOIL CAPABILITY CLASS III WITH BUILDINGS OTHER THAN RESIDENCE                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 5320                                                                            
                                , X_DESCRIPTION  => 'Cropland - Soil Capability Class Iii With Buildings Other Than Residence'      
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT TIMBERLAND-SLASHPINE INDEX 90 AND ABOVE                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 5400                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slashpine Index 90 And Above Vacant'                                
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-TIMBERLAND-SLASHPINE INDEX 90 & ABOVE WITH IMPROVEMENTS                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 5410                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slashpine Index 90 & Above With Improvements'                       
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT TIMBERLAND-SLASH PINE INDEX 80 TO 89                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 5500                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 80 To 89 Vacant'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-TIMBERLAND-SLASH PINE INDEX 80 TO 89 WITH IMPROVEMENTS                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 5510                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 80 To 89 With Improvements'                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT TIMBERLAND-SLASH PINE INDEX 70 TO 79                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 5600                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 70 To 79 Vacant'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-TIMBERLAND-SLASH PINE INDEX 70 TO 79 WITH IMPROVEMENTS                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 5610                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 70 To 79 With Improvements'                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT TIMBERLAND-SLASH PINE INDEX 60 TO 69                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 5700                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 60 To 69 Vacant'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-TIMBERLAND-SLASH PINE INDEX 60 TO 69 WITH IMPROVEMENTS                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 5710                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 60 To 69 With Improvements'                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT TIMBERLAND-SLASH PINE INDEX 50 TO 59                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 5800                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 50 To 59 Vacant'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                   
-- C-TIMBERLAND-SLASH PINE INDEX 50 TO 59 WITH IMPROVEMENTS                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 5810                                                                            
                                , X_DESCRIPTION  => 'Timberland-Slash Pine Index 50 To 59 With Improvements'                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT TIMBERLAND-NOT CLASSIFIED BY SITE INDEX TO PINES                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 5900                                                                            
                                , X_DESCRIPTION  => 'Timberland-Not Classified By Site Index To Pines Vacant'                       
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-TIMBERLAND-NOT CLASSIFIED BY SITE INDEX WITH IMPROVEMENTS                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 5910                                                                            
                                , X_DESCRIPTION  => 'Timberland-Not Classified By Site Index With Improvements'                     
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT GRAZING LAND - SOIL CAPABILITY CLASS I                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 6000                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class I Vacant'                                 
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-GRAZING LAND - SOIL CAPABILITY CLASS I WITH RESIDENCE                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 6010                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class I With Residence'                         
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-GRAZING LAND - SOIL CAPABILITY CLASS I WITH BUILDINGS OTHER THAN RESIDENCE                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 6020                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class I With Buildings Other Than Residence'    
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT GRAZING LAND - SOIL CAPABILITY CLASS II                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 6100                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Ii Vacant'                                
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-GRAZING LAND - SOIL CAPABILITY CLASS II WITH RESIDENCE                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 6110                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Ii With Residence'                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-GRAZING LAND - SOIL CAPABILITY CLASS II WITH BUILDINGS OTHER THAN RESIDENCE                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 6120                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Ii With Buildings Other Than Residence'   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT GRAZING LAND - SOIL CAPABILITY CLASS III                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 6200                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Iii Vacant'                               
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-GRAZING LAND - SOIL CAPABILITY CLASS III WITH RESIDENCE                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 6210                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Iii With Residence'                       
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-GRAZING LAND - SOIL CAPABILITY CLASS III WITH BUILDINGS OTHER THAN RESIDENCE                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 6220                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Iii With Buildings Other Than Residence'  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT GRAZING LAND - SOIL CAPABILITY CLASS IV                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 6300                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Iv Vacant'                                
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-GRAZING LAND - SOIL CAPABILITY CLASS IV WITH RESIDENCE                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 6310                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Iv With Residence'                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-GRAZING LAND - SOIL CAPABILITY CLASS IV WITH BUILDINGS OTHER THAN RESIDENCE                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 6320                                                                            
                                , X_DESCRIPTION  => 'Grazing Land - Soil Capability Class Iv With Buildings Other Than Residence'   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT GRAZING LAND-SOIL CAPABILITY CLASS V                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 6400                                                                            
                                , X_DESCRIPTION  => 'Grazing Land-Soil Capability Class V Vacant'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-GRAZING LAND-SOIL CAPABILITY CLASS V WITH RESIDENCE                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 6410                                                                            
                                , X_DESCRIPTION  => 'Grazing Land-Soil Capability Class V With Residence'                           
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-GRAZING LAND-SOIL CAPABILITY CLASS V WITH BUILDINGS OTHER THAN RESIDENCE                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 6420                                                                            
                                , X_DESCRIPTION  => 'Grazing Land-Soil Capability Class V With Buildings Other Than Residence'      
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT GRAZING LAND-SOIL CAPABILITY CLASS VI                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 6500                                                                            
                                , X_DESCRIPTION  => 'Grazing Land-Soil Capability Class Vi Vacant'                                  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-GRAZING LAND-SOIL CAPABILITY CLASS VI WITH RESIDENCE                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 6510                                                                            
                                , X_DESCRIPTION  => 'Grazing Land-Soil Capability Class Vi With Residence'                          
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-SOIL CAPABILITY CLASS VI WITH BUILDINGS OTHER THAN RESIDENCE                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 6520                                                                            
                                , X_DESCRIPTION  => 'Soil Capability Class Vi With Buildings Other Than Residence'                  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                   
-- C-VACANT ORCHARD GROVES-ALL GROVES                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 6600                                                                            
                                , X_DESCRIPTION  => 'Orchard Groves-All Groves Vacant'                                              
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-ORCHARD GROVES-ALL GROVES WITH RESIDENCE                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 6610                                                                            
                                , X_DESCRIPTION  => 'Orchard Groves-All Groves With Residence'                                      
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-ORCHARD GROVES-ALL GROVES WITH BUILDINGS OTHER THAN RESIDENCE                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 6620                                                                            
                                , X_DESCRIPTION  => 'Orchard Groves-All Groves With Buildings Other Than Residence'                 
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT ORCHARD GROVES-PART GROVE AND PART NOT PLANTED                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 6630                                                                            
                                , X_DESCRIPTION  => 'Orchard Groves-Part Grove And Part Not Planted Vacant'                         
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-ORCHARD GROVES-PART GROVE AND PART NOT PLANTED WITH RESIDENCE                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 6640                                                                            
                                , X_DESCRIPTION  => 'Orchard Groves-Part Grove And Part Not Planted With Residence'                 
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-ORCHARD GROVES-PART GROVE AND PART NOT PLANTED WITH BUILDINGS OTHER THAN                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 6650                                                                            
                                , X_DESCRIPTION  => 'Orchard Groves-Part Grove And Part Not Planted With Buildings Other Than'      
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT COMBINATION-PART ORCHARD GROVES AND PART PASTURE LAND-                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 6660                                                                            
                                , X_DESCRIPTION  => 'Combination-Part Orchard Groves And Part Pasture Land-Vacant'                  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-COMBINATION-PART ORCHARD GROVES AND PART PASTURE LAND WITH BUILDINGS OTHER                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 6670                                                                            
                                , X_DESCRIPTION  => 'Combination-Part Orchard Groves And Part Pasture Land With Buildings Other'    
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-COMBINATION-PART ORCHARD GROVES AND PART PASTURE LAND WITH RESIDENCE                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 6680                                                                            
                                , X_DESCRIPTION  => 'Combination-Part Orchard Groves And Part Pasture Land With Residence'          
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT MIXED TROPICAL FRUITS                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 6690                                                                            
                                , X_DESCRIPTION  => 'Mixed Tropical Fruits Vacant'                                                  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- R-MIXED TROPICAL FRUITS WITH RESIDENCE                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 6691                                                                            
                                , X_DESCRIPTION  => 'Mixed Tropical Fruits With Residence'                                          
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-MIXED TROPICAL FRUITS WITH BUILDING OTHER THAN RESIDENCE                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 6692                                                                            
                                , X_DESCRIPTION  => 'Mixed Tropical Fruits With Building Other Than Residence'                      
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-POULTRY FARMS                                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 6700                                                                            
                                , X_DESCRIPTION  => 'Poultry Farms'                                                                 
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-RABBIT FARMS                                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 6710                                                                            
                                , X_DESCRIPTION  => 'Rabbit Farms'                                                                  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-TROPICAL FISH FARMS                                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 6720                                                                            
                                , X_DESCRIPTION  => 'Tropical Fish Farms'                                                           
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-BEES (HONEY) FARMS                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 6730                                                                            
                                , X_DESCRIPTION  => 'Bees (Honey) Farms'                                                            
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-DAIRIES-WITH BUILDINGS OTHER THAN RESIDENCE                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 6800                                                                            
                                , X_DESCRIPTION  => 'Dairies-With Buildings Other Than Residence'                                   
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-DAIRIES-WITH RESIDENCE                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 6810                                                                            
                                , X_DESCRIPTION  => 'Dairies-With Residence'                                                        
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT FEED LOTS                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 6820                                                                            
                                , X_DESCRIPTION  => 'Feed Lots Vacant'                                                              
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT NURSERYS-                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 6900                                                                            
                                , X_DESCRIPTION  => 'Nurserys-Vacant'                                                               
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-NURSERYS-WITH RESIDENCE                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 6910                                                                            
                                , X_DESCRIPTION  => 'Nurserys-With Residence'                                                       
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-NURSERYS-WITH BUILDINGS OTHER THAN RESIDENCE                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 6920                                                                            
                                , X_DESCRIPTION  => 'Nurserys-With Buildings Other Than Residence'                                  
                                , X_PARENT_UCODE => 16);                                                                              
                                                                                                                                    
-- C-VACANT LAND - INSTITUTIONAL                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 7000                                                                            
                                , X_DESCRIPTION  => 'Vacant Land - Institutional'                                                   
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-CHURCH                                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 7100                                                                            
                                , X_DESCRIPTION  => 'Church'                                                                        
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-SCHOOL -PRIVATE                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 7200                                                                            
                                , X_DESCRIPTION  => 'School -Private'                                                               
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-SCHOOL -PRIVATE-CHURCH OWNED                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 7210                                                                            
                                , X_DESCRIPTION  => 'School -Private-Church Owned'                                                  
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-CHURCH OWNED EDUCATIONAL BUILDING                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 7211                                                                            
                                , X_DESCRIPTION  => 'Church Owned Educational Building'                                             
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-COLLEGE -PRIVATE                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 7220                                                                            
                                , X_DESCRIPTION  => 'College -Private'                                                              
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-FRATERNITY OR SORORITY HOME                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 7230                                                                            
                                , X_DESCRIPTION  => 'Fraternity Or Sorority Home'                                                   
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-HOSPITAL -GENERAL-PRIVATELY OWNED                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 7300                                                                            
                                , X_DESCRIPTION  => 'Hospital -General-Privately Owned'                                             
                                , X_PARENT_UCODE => 19);                                                                              
                                                                                                                                    
-- C-CLINIC                                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 7310                                                                            
                                , X_DESCRIPTION  => 'Clinic'                                                                        
                                , X_PARENT_UCODE => 19);                                                                              
                                                                                                                                    
-- C-HOME FOR THE AGED                                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 7400                                                                            
                                , X_DESCRIPTION  => 'Home For The Aged'                                                             
                                , X_PARENT_UCODE => 18);                                                                              
                                                                                                                                    
-- C-ASSISTED CARE LIVING FACILITY                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 7500                                                                            
                                , X_DESCRIPTION  => 'Assisted Care Living Facility'                                                 
                                , X_PARENT_UCODE => 18);                                                                              
                                                                                                                                    
-- C-CHILDRENS HOME                                                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 7510                                                                            
                                , X_DESCRIPTION  => 'Childrens Home'                                                                
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-MORTUARY                                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 7600                                                                            
                                , X_DESCRIPTION  => 'Mortuary'                                                                      
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-CEMETERY                                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 7610                                                                            
                                , X_DESCRIPTION  => 'Cemetery'                                                                      
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-CREMATORIUM                                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 7620                                                                            
                                , X_DESCRIPTION  => 'Crematorium'                                                                   
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-CLUBS, LODGES, AND UNION HALLS                                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 7700                                                                            
                                , X_DESCRIPTION  => 'Clubs, Lodges, And Union Halls'                                                
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-GYMNASIUM                                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 7800                                                                            
                                , X_DESCRIPTION  => 'Gymnasium'                                                                     
                                , X_PARENT_UCODE => 23);                                                                              
                                                                                                                                    
-- C-FIRE STATION                                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 7810                                                                            
                                , X_DESCRIPTION  => 'Fire Station'                                                                  
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- -LIBRARY                                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 7820                                                                            
                                , X_DESCRIPTION  => 'Library'                                                                       
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-CONVALESCENT HOME (NURSING HOME)                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 7841                                                                            
                                , X_DESCRIPTION  => 'Convalescent Home (Nursing Home)'                                              
                                , X_PARENT_UCODE => 19);                                                                              
                                                                                                                                    
-- C-VACANT MILITARY-  LAND                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 8100                                                                            
                                , X_DESCRIPTION  => 'Military-Vacant Land'                                                          
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-MILITARY-IMPROVED LAND                                                                                                         
pr_records_pkg.insert_usage_code( X_UCODE        => 8110                                                                            
                                , X_DESCRIPTION  => 'Military-Improved Land'                                                        
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT FOREST PARK                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 8200                                                                            
                                , X_DESCRIPTION  => 'Forest Park Vacant'                                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT RECREATIONAL AREA (GOVERNMENTAL)                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 8210                                                                            
                                , X_DESCRIPTION  => 'Recreational Area (Governmental) Vacant'                                       
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-SCHOOL -PUBLIC-IMPROVED PARCELS                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 8300                                                                            
                                , X_DESCRIPTION  => 'School -Public-Improved Parcels'                                               
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT SCHOOL -PUBLIC-  PARCELS                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 8310                                                                            
                                , X_DESCRIPTION  => 'School -Public-Vacant Parcels'                                                 
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-COLLEGE                                                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 8400                                                                            
                                , X_DESCRIPTION  => 'College'                                                                       
                                , X_PARENT_UCODE => 24);                                                                              
                                                                                                                                    
-- C-HOSPITAL                                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 8500                                                                            
                                , X_DESCRIPTION  => 'Hospital'                                                                      
                                , X_PARENT_UCODE => 19);                                                                              
                                                                                                                                    
-- C-VACANT COUNTY OWNED LAND-  (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 8600                                                                            
                                , X_DESCRIPTION  => 'County Owned Land-Vacant (That Does Not Qualify In Another Code)'              
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-COUNTY OWNED LAND-IMPROVED (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 8610                                                                            
                                , X_DESCRIPTION  => 'County Owned Land-Improved (That Does Not Qualify In Another Code)'            
                                , X_PARENT_UCODE => 4);                                                                              
                                                                                                                                    
-- C-UTILITY DIVISION PROPERTIES                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 8620                                                                            
                                , X_DESCRIPTION  => 'Utility Division Properties'                                                   
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-VACANT BREVARD COUNTY-AGENCIES OTHER THAN BOARD OF COUNTY COMMISSIONERS,                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 8630                                                                            
                                , X_DESCRIPTION  => 'Brevard County-Agencies Other Than Board Of County Commissioners, Vacant'      
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-BREVARD COUNTY-AGENCIES OTHER THAN BOARD OF COUNTY COMMISSIONERS, IMPROVED                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 8640                                                                            
                                , X_DESCRIPTION  => 'Brevard County-Agencies Other Than Board Of County Commissioners, Improved'    
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT HOUSING AUTHORITY -                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 8650                                                                            
                                , X_DESCRIPTION  => 'Housing Authority -Vacant'                                                     
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-HOUSING AUTHORITY -IMPROVED                                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 8660                                                                            
                                , X_DESCRIPTION  => 'Housing Authority -Improved'                                                   
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT CANAVERAL PORT AUTHORITY -                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 8670                                                                            
                                , X_DESCRIPTION  => 'Canaveral Port Authority - Vacant'                                             
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-CANAVERAL PORT AUTHORITY - IMPROVED                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 8680                                                                            
                                , X_DESCRIPTION  => 'Canaveral Port Authority - Improved'                                           
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT STATE OWNED LAND-  (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 8700                                                                            
                                , X_DESCRIPTION  => 'State Owned Land-Vacant (That Does Not Qualify In Another Code)'               
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-STATE OWNED LAND-IMPROVED (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 8710                                                                            
                                , X_DESCRIPTION  => 'State Owned Land-Improved (That Does Not Qualify In Another Code)'             
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT FEDERAL OWNED LAND-  (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 8800                                                                            
                                , X_DESCRIPTION  => 'Federal Owned Land-Vacant (That Does Not Qualify In Another Code)'             
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-FEDERAL OWNED LAND-IMPROVED (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 8810                                                                            
                                , X_DESCRIPTION  => 'Federal Owned Land-Improved (That Does Not Qualify In Another Code)'           
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT MUNICIPAL OWNED LAND-  (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 8900                                                                            
                                , X_DESCRIPTION  => 'Municipal Owned Land-Vacant (That Does Not Qualify In Another Code)'           
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-MUNICIPAL OWNED LAND-IMPROVED (THAT DOES NOT QUALIFY IN ANOTHER CODE)                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 8910                                                                            
                                , X_DESCRIPTION  => 'Municipal Owned Land-Improved (That Does Not Qualify In Another Code)'         
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT MELBOURNE AIRPORT AUTHORITY-                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 8920                                                                            
                                , X_DESCRIPTION  => 'Airport Authority-Vacant'                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-MELBOURNE AIRPORT AUTHORITY-IMPROVED                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 8930                                                                            
                                , X_DESCRIPTION  => 'Airport Authority-Improved'                                          
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT LEASED COUNTY/CITY PROPERTY-                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 9000                                                                            
                                , X_DESCRIPTION  => 'Leased County/City Property-Vacant'                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-LEASED COUNTY/CITY PROPERTY-IMPROVED                                                                                           
pr_records_pkg.insert_usage_code( X_UCODE        => 9010                                                                            
                                , X_DESCRIPTION  => 'Leased County/City Property-Improved'                                          
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-UTILITY-GAS COMPANIES-IMPROVED                                                                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 9100                                                                            
                                , X_DESCRIPTION  => 'Utility-Gas Companies-Improved'                                                
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-LOCALLY ASSESSED RAILROAD PROPERTY                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 9105                                                                            
                                , X_DESCRIPTION  => 'Locally Assessed Railroad Property'                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT UTILITY-GAS COMPANIES-                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 9110                                                                            
                                , X_DESCRIPTION  => 'Utility-Gas Companies-Vacant'                                                  
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-UTILITY-ELECTRIC COS. IMPROVED                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 9120                                                                            
                                , X_DESCRIPTION  => 'Utility-Electric Co. Improved'                                               
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT UTILITY-ELECTRIC COS.                                                                                                  
pr_records_pkg.insert_usage_code( X_UCODE        => 9130                                                                            
                                , X_DESCRIPTION  => 'Utility-Electric Co. Vacant'                                                 
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-UTILITY-TEL & TEL-IMPROVED                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 9140                                                                            
                                , X_DESCRIPTION  => 'Utility-Tel & Tel-Improved'                                                    
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT UTILITY-TEL & TEL-                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 9150                                                                            
                                , X_DESCRIPTION  => 'Utility-Tel & Tel-Vacant'                                                      
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-WATER & SEWER SERVICE                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 9170                                                                            
                                , X_DESCRIPTION  => 'Water & Sewer Service'                                                         
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-PIPE LINE                                                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 9180                                                                            
                                , X_DESCRIPTION  => 'Pipe Line'                                                                     
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- C-CANAL                                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 9190                                                                            
                                , X_DESCRIPTION  => 'Canal'                                                                         
                                , X_PARENT_UCODE => 13);                                                                              
                                                                                                                                    
-- R-VACANT SUBSURFACE RIGHTS                                                                                                       
pr_records_pkg.insert_usage_code( X_UCODE        => 9300                                                                            
                                , X_DESCRIPTION  => 'Subsurface Rights Vacant'                                                      
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-RIGHT OF WAY STREET, ROAD, ETC - PUBLIC                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 9400                                                                            
                                , X_DESCRIPTION  => 'Right Of Way Street, Road, Etc - Public'                                       
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- RC-RIGHT OF WAY STREET, ROAD, ETC - PRIVATE                                                                                      
pr_records_pkg.insert_usage_code( X_UCODE        => 9410                                                                            
                                , X_DESCRIPTION  => 'Right Of Way Street, Road, Etc - Private'                                      
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-IMPROVEMENT NOT SUITABLE TO ANY OTHER CODE                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 9465                                                                            
                                , X_DESCRIPTION  => 'Improvement Not Suitable To Any Other Code'                                    
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-ASSESSMENT ARREARS                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 9499                                                                            
                                , X_DESCRIPTION  => 'Assessment Arrears'                                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-RIVERS AND LAKES                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 9500                                                                            
                                , X_DESCRIPTION  => 'Rivers And Lakes'                                                              
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-SUBMERGED LANDS                                                                                                                
pr_records_pkg.insert_usage_code( X_UCODE        => 9510                                                                            
                                , X_DESCRIPTION  => 'Submerged Lands'                                                               
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-WASTE LAND                                                                                                                     
pr_records_pkg.insert_usage_code( X_UCODE        => 9600                                                                            
                                , X_DESCRIPTION  => 'Waste Land'                                                                    
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT MARSH                                                                                                                   
pr_records_pkg.insert_usage_code( X_UCODE        => 9610                                                                            
                                , X_DESCRIPTION  => 'Marsh Vacant'                                                                  
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT SAND DUNE                                                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 9620                                                                            
                                , X_DESCRIPTION  => 'Sand Dune Vacant'                                                              
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-SWAMP                                                                                                                          
pr_records_pkg.insert_usage_code( X_UCODE        => 9630                                                                            
                                , X_DESCRIPTION  => 'Swamp'                                                                         
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT RECREATIONAL OR PARK LANDS                                                                                              
pr_records_pkg.insert_usage_code( X_UCODE        => 9700                                                                            
                                , X_DESCRIPTION  => 'Recreational Or Park Lands Vacant'                                             
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-CENTRALLY ASSESSED                                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 9800                                                                            
                                , X_DESCRIPTION  => 'Centrally Assessed'                                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT ALL ACREAGE-OTHER THAN GOVERNMENT OWNED AND NOT ZONED AGRICULTURAL-  AN                                                 
pr_records_pkg.insert_usage_code( X_UCODE        => 9900                                                                            
                                , X_DESCRIPTION  => 'All Acreage-Other Than Government Owned And Not Zoned Agricultural-Vacant' 
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT RESIDENTIAL LAND MULTI-FAMILY UNPLATTED 5 ACRES AND GREATER                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 9908                                                                            
                                , X_DESCRIPTION  => 'Vacant Residential Land Multi-Family Unplatted 5 Acres And Greater'            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-VACANT RESIDENTIAL LAND-SINGLE FAMILY UNPLATTED 5 ACRES AND GREATER                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 9909                                                                            
                                , X_DESCRIPTION  => 'Vacant Residential Land-Single Family Unplatted 5 Acres And Greater'           
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT SITE APPROVED FOR CELLULAR TOWER                                                                                        
pr_records_pkg.insert_usage_code( X_UCODE        => 9910                                                                            
                                , X_DESCRIPTION  => 'Vacant Site Approved For Cellular Tower'                                       
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT AGRICULTURAL ZONED LAND (NOT IN USE)                                                                                    
pr_records_pkg.insert_usage_code( X_UCODE        => 9920                                                                            
                                , X_DESCRIPTION  => 'Vacant Agricultural Zoned Land (Not In Use)'                                   
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- C-VACANT SITE APPROVED FOR BILLBOARD                                                                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 9930                                                                            
                                , X_DESCRIPTION  => 'Vacant Site Approved For Billboard'                                            
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
-- R-NON TAXABLE CONDOMINIUM COMMON AREA                                                                                            
pr_records_pkg.insert_usage_code( X_UCODE        => 9990                                                                            
                                , X_DESCRIPTION  => 'Non Taxable Condominium Common Area'                                           
                                , X_PARENT_UCODE => 3);                                                                              
                                                                                                                                    
end;
/