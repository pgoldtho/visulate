set define ^
declare
  type cou_list_type is table of number;

  procedure gen_table( p_cou_list   in cou_list_type
                     , p_totals_yn  in varchar2 := 'Y') is
                     
    cursor cur_content(p_cou in number) is
    select PST0452 total_population
    ,      PST0402
    ,      PST1202 population_growth
    ,      POP0102
    ,      AGE1352
    ,      AGE2952
    ,      AGE7752
    ,      SEX2552
    ,      RHI1252
    ,      RHI2252
    ,      RHI3252
    ,      RHI4252
    ,      RHI5252
    ,      RHI6252
    ,      RHI7252
    ,      RHI8252
    ,      POP7152
    ,      POP6452
    ,      POP8152
    ,      EDU6352 high_school
    ,      EDU6852 higher_ed
    ,      VET6052
    ,      LFE3052 travel_time
    ,      HSG0102 housing_units
    ,      HSG4452 owner_occupied
    ,      HSG0962 multi_units
    ,      HSG4952 median_unit_price
    ,      HSD4102
    ,      HSD3102
    ,      INC9102 per_captia_income
    ,      INC1102 median_household_income
    ,      PVY0202 poverty_pct
    ,      BZA0102 non_farm_estab
    ,      BZA1102 non_farm_employment
    ,      BZA1152 non_farm_employment_growth
    ,      NES0102 non_employ_establishments
    ,      SBO0012 total_firms
    ,      SBO3152
    ,      SBO1152
    ,      SBO2152
    ,      SBO5152
    ,      SBO4152
    ,      SBO0152
    ,      MAN4502 manufacturing_total
    ,      WTN2202 wholesale_total
    ,      RTN1302 retail_total
    ,      RTN1312
    ,      AFN1202 accommodation_food
    ,      (MAN4502 + WTN2202 + RTN1302 +  AFN1202)/1000 ecconomy_size
    ,      BPS0302 building_permits
    ,      LND1102 land_area
    ,      POP0602 population_density
    ,      name
    from ldr_county_data d
    ,    ldr_counties c
    where c.STATECOU = p_cou
    and c.statecou = d.statecou;
    
    v_pop   number := 0;
    v_econ  number := 0;
    v_grow  number := 0;
    v_inc   number := 0;
    v_unit  number := 0;
    v_price number := 0;
    v_count number := 0;
    
  begin
    dbms_output.put_line('<p><strong>Quick Facts</strong></p>');
    dbms_output.put_line('<table class="datatable">');
    dbms_output.put_line('<tr><th>County</th>'
                       ||'<th>Population<br/>2012</th>'
                       ||'<th>Ecconomic Activity<br>2007 (Millions)</th>'                       
                       ||'<th>Population Growth<br/>2010 to 2012</th>'
                       ||'<th>Median Household<br/>Income 2011</th>'
                       ||'<th>Housing <br/>Units</th>'
                       ||'<th>Median Price<br/>2007 to 2011</th>'
                       ||'</th></tr>');
    for i in p_cou_list.FIRST .. p_cou_list.LAST loop
      for c_rec in cur_content(p_cou_list(i)) loop
        v_pop   := v_pop + c_rec.total_population;
        v_econ  := v_econ + c_rec.ecconomy_size;
        v_grow  := v_grow + c_rec.population_growth;
        v_inc   := v_inc + c_rec.median_household_income;
        v_unit  := v_unit + c_rec.housing_units;
        v_price := v_price + c_rec.median_unit_price;
        v_count := v_count + 1;
      
        dbms_output.put_line('<tr><td><a href="/rental/visulate_search.php?REPORT_CODE=CITY&state=FL&county='
                           ||upper(replace(c_rec.name, ' County'))||'">'||c_rec.name||'</a>'
                           ||'</td><td style="text-align:right">'||to_char(c_rec.total_population, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.ecconomy_size, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.population_growth, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(c_rec.median_household_income, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.housing_units, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(c_rec.median_unit_price, '$999,999,999')
                           ||'</td></tr>');      

      end loop;
    end loop;
    if p_totals_yn = 'Y' and v_count > 0 then
    
         dbms_output.put_line('<tr><td>Total'
                           ||'</td><td style="text-align:right">'||to_char(v_pop, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_econ, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_grow/v_count, '90.9')||'%'
                           ||'</td><td style="text-align:right">'||to_char(v_inc/v_count, '$999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_unit, '999,999,999')
                           ||'</td><td style="text-align:right">'||to_char(v_price/v_count, '$999,999,999')
                           ||'</td></tr>');    
    end if;
    
    dbms_output.put_line('</table>');
  end gen_table;
  
  procedure prn_regions is
    v_region_list  cou_list_type;
  begin
    v_region_list := cou_list_type(12061, 12111, 12085, 12099, 12011, 12086, 12087);
    gen_table(v_region_list);

    v_region_list := cou_list_type(12017, 12053, 12101, 12057, 12103, 12105, 12081, 12115);
    gen_table(v_region_list);
    
    v_region_list := cou_list_type(12009, 12097, 12095, 12117, 12069, 12127, 12119);
    gen_table(v_region_list);    
    
    v_region_list := cou_list_type(12003, 12019, 12031, 12089, 12107, 12109, 12035);
    gen_table(v_region_list);    
    
    v_region_list := cou_list_type(12033, 12115, 12091, 12131, 12059, 12063, 12133, 12005, 12013, 12077, 12045, 12037, 12039, 12073, 12065, 12129);
    gen_table(v_region_list);    
    
    v_region_list := cou_list_type(12015, 12071, 12021);
    gen_table(v_region_list);    
    
    v_region_list := cou_list_type(12079, 12047, 12123, 12121, 12125, 12007, 12067, 12029, 12075, 12041, 12001, 12083, 12023);
    gen_table(v_region_list);    
    
    v_region_list := cou_list_type(12049, 12055, 12093, 12027, 12043, 12051);
    gen_table(v_region_list);    
   
    
  end prn_regions;
/*
Alachua County - 12001
Baker County - 12003
Bay County - 12005
Bradford County - 12007
Brevard County - 12009
Broward County - 12011
Calhoun County - 12013
Charlotte County - 12015
Citrus County - 12017
Clay County - 12019
Collier County - 12021
Columbia County - 12023
DeSoto County - 12027
Dixie County - 12029
Duval County - 12031
Escambia County - 12033
Flagler County - 12035
Franklin County - 12037
Gadsden County - 12039
Gilchrist County - 12041
Glades County - 12043
Gulf County - 12045
Hamilton County - 12047
Hardee County - 12049
Hendry County - 12051
Hernando County - 12053
Highlands County - 12055
Hillsborough County - 12057
Holmes County - 12059
Indian River County - 12061
Jackson County - 12063
Jefferson County - 12065
Lafayette County - 12067
Lake County - 12069
Lee County - 12071
Leon County - 12073
Levy County - 12075
Liberty County - 12077
Madison County - 12079
Manatee County - 12081
Marion County - 12083
Martin County - 12085
Miami-Dade County - 12086
Monroe County - 12087
Nassau County - 12089
Okaloosa County - 12091
Okeechobee County - 12093
Orange County - 12095
Osceola County - 12097
Palm Beach County - 12099
Pasco County - 12101
Pinellas County - 12103
Polk County - 12105
Putnam County - 12107
St. Johns County - 12109
St. Lucie County - 12111
Santa Rosa County - 12113
Sarasota County - 12115
Seminole County - 12117
Sumter County - 12119
Suwannee County - 12121
Taylor County - 12123
Union County - 12125
Volusia County - 12127
Wakulla County - 12129
Walton County - 12131
Washington County - 12133
*/


begin
  prn_regions;
end;
/
