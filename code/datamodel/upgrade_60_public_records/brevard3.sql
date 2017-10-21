set define '^'
declare


begin



pr_records_pkg.insert_usage_code( X_UCODE        => 1                                                                               
                                , X_DESCRIPTION  => 'Residential'                                
                                , X_PARENT_UCODE => null);                                                                              
                                                                                                                                    

pr_records_pkg.insert_usage_code( X_UCODE        => 2 
                                , X_DESCRIPTION  => 'Commercial' 
                                , X_PARENT_UCODE => null);
                                                                                                                                    
                                                                               
pr_records_pkg.insert_usage_code( X_UCODE        => 3                                                
                                , X_DESCRIPTION  => 'Land'                              
                                , X_PARENT_UCODE => null);     


pr_records_pkg.insert_usage_code( X_UCODE        => 4                                                
                                , X_DESCRIPTION  => 'Mobile/Manufactured'                            
                                , X_PARENT_UCODE => null);     

                                                                         



pr_records_pkg.insert_usage_code( X_UCODE        => 11 
                                , X_DESCRIPTION  => 'Multifamily' 
                                , X_PARENT_UCODE => 2);

pr_records_pkg.insert_usage_code( X_UCODE        => 12 
                                , X_DESCRIPTION  => 'Office' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 13 
                                , X_DESCRIPTION  => 'Industrial' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 14 
                                , X_DESCRIPTION  => 'Retail' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 15 
                                , X_DESCRIPTION  => 'Shopping Center' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 16 
                                , X_DESCRIPTION  => 'Agricultural' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 17 
                                , X_DESCRIPTION  => 'Hotel & Motel' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 18 
                                , X_DESCRIPTION  => 'Senior Housing' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 19 
                                , X_DESCRIPTION  => 'Health Care' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 23 
                                , X_DESCRIPTION  => 'Sports & Entertaining' 
                                , X_PARENT_UCODE => 2);
                                             
pr_records_pkg.insert_usage_code( X_UCODE        => 24 
                                , X_DESCRIPTION  => 'Special Purpose' 
                                , X_PARENT_UCODE => 2);

                                           

end;
/     