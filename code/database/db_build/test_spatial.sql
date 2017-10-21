select p2.prop_id
                     ,      initcap(p2.address1) address1
                     ,      sdo_nn_distance(1)
                     from pr_properties p
               ,     pr_properties p2
               where p.prop_id  = 837819
               and p.prop_id != p2.prop_id
               and sdo_nn
                        ( p2.geo_location
                        , p.geo_location
                        , 'sdo_num_res=10', 1) = 'TRUE'
                                 order by 3