alter table pr_properties 
add comp_props_t property_list_t
nested table comp_props_t store as pr_property_comps;