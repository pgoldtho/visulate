declare 
  procedure add_code( p_ucode  in number
                   , p_desc   in varchar2
                   , p_parent in number := null) is
    v_count pls_integer;
  begin
    select count(*) into v_count
    from pr_usage_codes
    where ucode = p_ucode;
    if v_count = 0 then
      insert into pr_usage_codes (ucode, description, parent_ucode)
      values (p_ucode, p_desc, p_parent);
    else
      update pr_usage_codes
      set description = p_desc
      ,   parent_ucode = p_parent 
      where ucode = p_ucode;
    end if;
  end add_code;

  procedure ins_codes is
  begin
    add_code(91000, 'Residential Property');
    add_code(90000, 'Vacant Residential', 3);
    add_code(90001, 'Single Family', 91000); 
    add_code(90002, 'Mobile Home', 91000); 
    add_code(90003, 'Multi-family - 10 units or more', 91000); 
    add_code(90004, 'Condominium', 91000); 
    add_code(90005, 'Cooperative', 91000); 
    add_code(90006, 'Retirement Home not eligible for exemption.', 91000); 
    add_code(90007, 'Miscellaneous Residential (migrant camp or boarding home.)', 91000);
    add_code(90008, 'Multi-family - less than 10 units ', 91000);
    add_code(90009, 'Undefined - Reserved for Use by Department of Revenue', 91000);
                                  
    add_code(92000, 'Commercial Property');
    add_code(90010, 'Vacant Commercial', 3); 
    add_code(90011, 'Store, one story', 92000); 
    add_code(90012, 'Mixed use - store and office or store and residential or residential combination', 92000); 
    add_code(90013, 'Department Store', 92000); 
    add_code(90014, 'Supermarket', 92000);
    add_code(90015, 'Regional Shopping Center', 92000); 
    add_code(90016, 'Community Shopping Center', 92000); 
    add_code(90017, 'Office building, non-professional service building, one story', 92000); 
    add_code(90018, 'Office building, non-professional service building, multi-story', 92000); 
    add_code(90019, 'Professional service building', 92000); 
    add_code(90020, 'Airport (private or commercial), bus terminal, marine terminal, pier or marina.', 92000); 
    add_code(90021, 'Restaurant, cafeteria', 92000); 
    add_code(90022, 'Drive-in Restaurant', 92000);
    add_code(90023, 'Financial institution (bank, saving and loan company, mortgage company, credit services)', 92000); 
    add_code(90024, 'Insurance company office', 92000); 
    add_code(90025, 'Repair service shop (excluding automotive)', 92000);
    add_code(90026, 'Service station', 92000); 
    add_code(90027, 'Auto sales, auto repair and storage or auto service shop', 92000);
    add_code(90028, 'Parking lot (commercial or patron) or mobile home park', 92000); 
    add_code(90029, 'Wholesale outlet, produce house or manufacturing outlet', 92000);
    add_code(90030, 'Florist or greenhouse', 92000); 
    add_code(90031, 'Drive-in theater or open stadium', 92000); 
    add_code(90032, 'Enclosed theater or auditorium', 92000);
    add_code(90033, 'Nightclub, cocktail lounge or bar', 92000);
    add_code(90034, 'Bowling alley, skating rink, pool hall or enclosed arena', 92000);
    add_code(90035, 'Tourist attraction, permanent exhibit or other entertainment facilities', 92000);
    add_code(90036, ' Camp', 92000); 
    add_code(90037, 'Race track: horse, auto or dog', 92000); 
    add_code(90038, 'Golf course or driving range', 92000); 
    add_code(90039, 'Hotel or motel', 92000);
 
    add_code(93000, 'Industrial Property');
    add_code(90040, 'Vacant Industrial', 3); 
    add_code(90041, 'Light manufacturing', 93000); 
    add_code(90042, 'Heavy industrial', 93000); 
    add_code(90043, 'Lumber yard, sawmill or planing mill', 93000); 
    add_code(90044, 'Packing plant (fruit and vegetable or meat packing)', 93000);   
    add_code(90045, 'Cannery, fruit and vegetable, bottler or brewers, distillery or winery', 93000); 
    add_code(90046, 'Food processing', 93000); 
    add_code(90047, 'Mineral processing, cement plant,refinery, clay plants or gravel plant', 93000);                                                                                                                        
    add_code(90048, 'Warehousing, distribution terminal, trucking terminal, or van and storage warehousing', 93000);  
    add_code(90049, 'Open storage (building supplies, auto wrecking, fuel, equipment or material storage)', 93000); 

    add_code(94000, 'Agricultural Property', 3);
    add_code(90050, 'Improved agricultural', 94000);  
    add_code(90051, 'Cropland soil capability Class I', 3); 
    add_code(90052, 'Cropland soil capability Class II', 3); 
    add_code(90053, 'Cropland soil capability Class III', 3); 
    add_code(90054, 'Timberland - site index 90 and above', 3); 
    add_code(90055, 'Timberland - site index 80 to 89', 3); 
    add_code(90056, 'Timberland - site index 70 to 79', 3); 
    add_code(90057, 'Timberland - site index 60 to 69', 3); 
    add_code(90058, 'Timberland - site index 50 to 59', 3); 
    add_code(90059, 'Timberland not classified by site index to Pines', 3);                          
    add_code(90060,  'Grazing land soil capability Class I', 3); 
    add_code(90061, 'Grazing land soil capability Class II', 3); 
    add_code(90062, 'Grazing land soil capability Class III', 3); 
    add_code(90063, 'Grazing land soil capability Class IV', 3); 
    add_code(90064, 'Grazing land soil capability Class V', 3); 
    add_code(90065, 'Grazing land soil capability Class VI', 3); 
    add_code(90066, 'Orchard Groves, Citrus, etc.', 3); 
    add_code(90067, 'Poultry, bees, tropical fish, rabbits, etc.', 3); 
    add_code(90068, 'Dairies, feed lots', 3); 
    add_code(90069, 'Ornamentals, miscellaneous agricultural', 3);

    add_code(95000, 'Institutional Property');
    add_code(90070, 'Vacant Institutional Property', 3);                     
    add_code(90071, 'Church', 95000); 
    add_code(90072, 'Private school or college', 95000);
    add_code(90073, 'Privately owned hospital', 95000); 
    add_code(90074, 'Home for the aged', 95000); 
    add_code(90075, 'Orphanage, other non-profit or charitable services', 95000);  
    add_code(90076, 'Mortuary, cemetery or crematorium', 95000);  
    add_code(90077, 'Club, lodge or union hall', 95000); 
    add_code(90078, 'Sanitarium or convalescent rest home', 95000);  
    add_code(90079, 'Cultural organization, facility', 95000); 
 
    add_code(96000, 'Government Property');
    add_code(90080, 'Government Undefined', 96000);  
    add_code(90081, 'Military', 96000);   
    add_code(90082, 'Forest, park or recreational area', 96000);   
    add_code(90083, 'Public county school', 96000);  
    add_code(90084, 'College', 96000);   
    add_code(90085, 'Hospital', 96000);   
    add_code(90086, 'County Owned', 96000);        
    add_code(90087, 'State Owned', 96000);  
    add_code(90088, 'Federal Owned', 96000);  
    add_code(90089, 'Municipal Owned', 96000);  

    add_code(97000, 'Miscellaneous Property');
    add_code(90090, 'Leasehold interests (government owned property leased by a non-governmental lessee)', 97000);   
    add_code(90091, 'Utility', 97000);   
    add_code(90092, 'Mining land, petroleum land, or gas land', 3);    
    add_code(90093, 'Subsurface rights', 3);    
    add_code(90094, 'Right-of-way, street, road, irrigation channel, ditch, etc.', 3);    
    add_code(90095, 'River, lake or submerged land', 3);    
    add_code(90096, 'Sewage disposal, solid waste, borrow pit, drainage reservoir, waste land, marsh, sand dune or swamp', 3);    
    add_code(90097, 'Outdoor recreational or high-water recharge subject', 3);
    add_code(90098, 'Centrally assessed', 97000);    
    add_code(90099, 'Acreage not zoned agricultural with or without extra features', 3);   
  end ins_codes;
  
  begin
    ins_codes;
  end;
/  