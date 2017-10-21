select round(pv.value_amount /1200)      monthly_rent
                          ,      round(pv.value_amount/100 )       annual_rent
                          ,      round(pv.value_amount * pd.vacancy_rate/10000) vacancy_amount
                          ,      pd.vacancy_rate
                          ,      round(v.replacement * p.sq_ft)  insurance
                          ,      round(t.tax_amount)  TAX
                          ,      round(v.maintenance * p.sq_ft)  maintenance
                          ,      round(v.utilities * p.sq_ft)  utilities
                          ,      v.cap_rate
                          ,      v.mgt_percent
                          ,      round (pv.value_amount * v.mgt_percent / 10000) mgt_amount
                          ,      round(v.median_price * z.city_wt * p.sq_ft) median_market_value
                          ,      round(v.min_price * z.city_wt * p.sq_ft) low_market_value
                          ,      round(v.max_price * z.city_wt * p.sq_ft) high_market_value
                          ,      round(pv.value_amount / p.sq_ft /100) rent
                          ,      v.prop_class
                          ,      v.min_price
                          ,      v.median_price
                          ,      v.max_price
                          ,      v.year
                          ,      c.name city
                          ,      c.county
                          ,      c.state
                          ,      p.prop_class pclass
                     from pr_properties p
                     ,    pr_property_usage pu
                     ,    rnt_city_zipcodes cz
                     ,    rnt_cities c
                     ,    pr_values v
                     ,    pr_usage_codes uc
                     ,    pr_taxes t
                     ,    rnt_zipcodes z
                     ,    pr_pums_data pd
                     ,    pr_pums_values pv
                     where p.prop_id = &prop_id
                     and p.prop_id = pu.prop_id
                      and (v.ucode = uc.ucode or
                           v.ucode = uc.parent_ucode)
                      and uc.ucode = pu.ucode
                      and z.zipcode = cz.zipcode
                      and to_number(p.zipcode) = z.zipcode
                      and cz.city_id = c.city_id
                      and v.city_id = c.city_id
                      and t.prop_id = p.prop_id
                      and t.current_yn = 'Y'
                      and p.puma_percentile = pv.percentile
                      and pv.value_type = 'RR-INCOME'
                      and pv.puma = pd.puma
                      and pd.puma = p.puma
                      and v.year = (select max(year)
                                    from pr_values v2
                                    where v2.prop_class = v.prop_class
                                    and v2.ucode = v.ucode
                                    and v2.city_id = v.city_id);