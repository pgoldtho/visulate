select p.description, count(*)
from pr_usage_codes p
,    pr_usage_codes c
,    pr_property_usage pu
where p.ucode = c.parent_ucode
and pu.ucode = c.ucode
group by p.description
order by 1

DESCRIPTION                                          COUNT(*)
-------------------------------------------------- ----------
Agricultural                                              286
Agricultural Property                                   22049
Commercial                                                269
Commercial Property                                    229799
Government Property                                     66910
Health Care                                                43
Hotel & Motel                                              29
Industrial                                               1492
Industrial Property                                     69001
Institutional Property                                  38522
Land                                                  1158834
Miscellaneous Property                                   7908
Mobile/Manufactured                                      7119
Multifamily                                              3651
Office                                                    710
Residential                                             25112
Residential Property                                  6594984
Retail                                                    491
Senior Housing                                            137
Shopping Center                                          1315
Special Purpose                                           620
Sports & Entertaining                                    1312

22 rows selected.

select lpad(' ', level*2, ' ')|| ucode||' - '|| description
from pr_usage_codes
start with parent_ucode is null
connect by prior ucode = parent_ucode
SQL> /

LPAD('',LEVEL*2,'')||UCODE||'-'||DESCRIPTION
------------------------------------------------------------------------------------------------------------------------------------
  1 - Residential
    41 - Condominium Unit With Utilities
    110 - Single Family Residence
    113 - Single Family - Modular
    121 - 1/2 Duplex Used As Sfr
    132 - Residential Related Amenities
    133 - Improved Residential Common Area
    135 - Townhouse
    164 - Residential Improvement Not Suitable For Occupancy
    232 - Residential Related Ammenity On Manufactured Home Site
    414 - Condominium Unit
    421 - Time Share Condo
    430 - Condominium - Residential Unit Used In Conjunction With Another Unit
    432 - Condominium-Transferable Limited Common Element
    433 - Improved Condominium Common Area
    438 - Condominium - Improved With No Manufactured Home
    441 - Condominium Unit With Site Improvements
    464 - Condominium Not Suitable For Occupancy
    465 - Condominium - Miscellaneous (Not Covered  By Other Codes)
    514 - Cooperative
    815 - House And Improvement Not Suitable For Occupancy
    819 - Two Residential Units - Not Attached
    834 - Two Or More Townhouses
    839 - Three Or Four Living Units - Not Attached

  91000 - Residential Property
    90001 - Single Family


    90004 - Condominium
    90005 - Cooperative
    


    90009 - Undefined - Reserved for Use by Department of Revenue


  2 - Commercial
    11 - Multifamily
      351 - Garden Apartments - 1 Story - 10 To 49 Units
      352 - Garden Apartments - 1 Story - 50 Units And Up
      353 - Low Rise Apartments- 10 To 49 Units- 2 Or 3 Stories
      354 - Low Rise Apartments- 50 Units And Up- 2 Or 3 Stories
      355 - High Rise Apartments- 4 Stories And Up
      356 - Townhouse Apartments
      820 - Duplex
      830 - Triplex
      840 - Quadruplex
      850 - Multiple Living Units (5 To 9 Units)
      859 - Multiple Living Units (5 To 9 Units)-Not  Attached
      864 - Multi-Family Improvement Not Suitable For Occupancy

    90003 - Multi-family - 10 units or more
    90008 - Multi-family - less than 10 units


    12 - Office
      1700 - Office Building- Single Tenant- 1 Story
      1704 - Condominium Office Unit
      1710 - Office Building- Multi Tenant- 1 Story
      1738 - Office- Shell Building
      1800 - Office Building- Single Tenant- 2 Or More Stories
      1810 - Office Building- Multi Tenant- 2 Or More Stories
      1900 - Professional Building- Single Tenant-  1 Story
      1910 - Professional Building- Multi Tenant- 1 Story
      1920 - Professional Building- Single Tenant- 2  Or More Stories
      1930 - Professional Building- Multi Tenant- 2 Or More Stories
      1940 - Professional/Office Complex
    90017 - Office building, non-professional service building, one story
    90018 - Office building, non-professional service building, multi-story
    90019 - Professional service building
    90024 - Insurance company office


    13 - Industrial
      1204 - Commercial Shell Bldg (Condo)
      1210 - Mixed Use- Commercial Property
      1238 - Commerical Shell Bldg (Other)
      1264 - Commercial Improvement Not Suitable For Occupancy
      2800 - Parking Lot  - Commercial
      3710 - Correctional Facility
      3720 - Postal Facility
      4100 - Light Manufacturing,Small Equipt.Mfg. Plants,Sm.Machine Shops,Instrument Mfg.,
      4200 - Heavy Industrial,Heavy Equipment Mfg., Large Machine Shops,Foundries,Steel
      4300 - Lumber Yard, Sawmill, Planing Mill
      4400 - Packing Plant, Fruit & Vegetable Packing Plant, Meat Packing Plant
      4500 - Canneries, Fruit & Vegetable, Bottlers & Brewers Distilleries, Wineries
      4600 - Other Food Processing, Candy Factories, Bakeries, Potato Chip Factories
      4700 - Mineral Processing, Phosphate Processing Refinery, Clay Plant, Rock & Gravel
      4710 - Concrete / Asphalt Plant
      4800 - Warehousing, Distribution_Terminal, Trucking Terminal, Van & Storage
      4804 - Condominium - Warehousing
      4810 - Mini-Warehousing
      4830 - Warehouse - Flex Space
      4900 - Open Storage, New And Used Building Supplies, Junk Yards, Auto Wrecking,Fuel
      8620 - Utility Division Properties
      9170 - Water & Sewer Service
      9180 - Pipe Line
      9190 - Canal
  93000 - Industrial Property
    90041 - Light manufacturing
    90042 - Heavy industrial
    90043 - Lumber yard, sawmill or planing mill
    90044 - Packing plant (fruit and vegetable or meat packing)
    90045 - Cannery, fruit and vegetable, bottler or brewers, distillery or winery
    90046 - Food processing
    90047 - Mineral processing, cement plant,refinery, clay plants or gravel plant
    90048 - Warehousing, distribution terminal, trucking terminal, or van and storage warehousing
    90049 - Open storage (building supplies, auto wrecking, fuel, equipment or material storage)



    14 - Retail
      1100 - Retail Store- 1 Unit
      1104 - Condominium - Store
      1105 - Retail Drugstore - Not Attached
      1115 - Retail Tire Store
      1125 - Convenience Store
      1130 - Convenience Store With Gas Pump
      1138 - Retail- Shell Building
      1400 - Supermarket
      2100 - Restaurant / Cafeteria
      2104 - Condominium-Restaurant
      2110 - Fast Food Restaurant
      2300 - Financial Institution
      2310 - Financial Institution - Branch Facility
      2400 - Insurance Co. - Office
      2500 - Service Shop, Radio & T.V. Repair, Refrigeration Service,Paint Shop, Elec
      2600 - Service Station
      2700 - Dealership Sales / Service Center
      2710 - Garage / Auto-Body /Auto Paint Shop
      2715 - Mini-Lube Service Specialist
      2720 - Car Wash
      2730 - Used Automobile Sales
      2810 - Parking Lot  - Patron
      2900 - Wholesale Outlet
      2910 - Produce House
      3000 - Florist
      3450 - Flea Market

    90011 - Store, one story
    90012 - Mixed use - store and office or store and residential or residential combination
    90013 - Department Store
    90014 - Supermarket
    90015 - Regional Shopping Center
    90016 - Community Shopping Center
    90021 - Restaurant, cafeteria
    90022 - Drive-in Restaurant
    90023 - Financial institution (bank, saving and loan company, mortgage company, credit services)
    90025 - Repair service shop (excluding automotive)
    90026 - Service station
    90027 - Auto sales, auto repair and storage or auto service shop
    90029 - Wholesale outlet, produce house or manufacturing outlet
    90030 - Florist or greenhouse


    15 - Shopping Center
      1110 - Retail Store - Multiple Units
      1150 - Warehouse Discount Store
      1300 - Department Store
      1500 - Regional Shopping Mall
      1600 - Shopping Complex - Community/ Neighborhood
      1610 - Shopping Center  - Neighborhood


    16 - Agricultural
      5100 - Cropland - Soil Capability Class I Vacant
      5110 - Cropland - Soil Capability Class I With Residence
      5120 - Cropland - Soil Capability Class I With Buildings Other Than Residence
      5200 - Cropland - Soil Capability Class Ii Vacant
      5210 - Cropland - Soil Capability Class Ii With Residence
      5220 - Cropland - Soil Capability Class Ii With Buildings Other Than Residence
      5300 - Cropland - Soil Capability Class Iii Vacant
      5310 - Cropland - Soil Capability Class Iii With Residence
      5320 - Cropland - Soil Capability Class Iii With Buildings Other Than Residence
      5400 - Timberland-Slashpine Index 90 And Above Vacant
      5410 - Timberland-Slashpine Index 90 & Above With Improvements
      5500 - Timberland-Slash Pine Index 80 To 89 Vacant
      5510 - Timberland-Slash Pine Index 80 To 89 With Improvements
      5600 - Timberland-Slash Pine Index 70 To 79 Vacant
      5610 - Timberland-Slash Pine Index 70 To 79 With Improvements
      5700 - Timberland-Slash Pine Index 60 To 69 Vacant
      5710 - Timberland-Slash Pine Index 60 To 69 With Improvements
      5800 - Timberland-Slash Pine Index 50 To 59 Vacant
      5810 - Timberland-Slash Pine Index 50 To 59 With Improvements
      5900 - Timberland-Not Classified By Site Index To Pines Vacant
      5910 - Timberland-Not Classified By Site Index With Improvements
      6000 - Grazing Land - Soil Capability Class I Vacant
      6010 - Grazing Land - Soil Capability Class I With Residence
      6020 - Grazing Land - Soil Capability Class I With Buildings Other Than Residence
      6100 - Grazing Land - Soil Capability Class Ii Vacant
      6110 - Grazing Land - Soil Capability Class Ii With Residence
      6120 - Grazing Land - Soil Capability Class Ii With Buildings Other Than Residence
      6200 - Grazing Land - Soil Capability Class Iii Vacant
      6210 - Grazing Land - Soil Capability Class Iii With Residence
      6220 - Grazing Land - Soil Capability Class Iii With Buildings Other Than Residence
      6300 - Grazing Land - Soil Capability Class Iv Vacant
      6310 - Grazing Land - Soil Capability Class Iv With Residence
      6320 - Grazing Land - Soil Capability Class Iv With Buildings Other Than Residence
      6400 - Grazing Land-Soil Capability Class V Vacant
      6410 - Grazing Land-Soil Capability Class V With Residence
      6420 - Grazing Land-Soil Capability Class V With Buildings Other Than Residence
      6500 - Grazing Land-Soil Capability Class Vi Vacant
      6510 - Grazing Land-Soil Capability Class Vi With Residence
      6520 - Soil Capability Class Vi With Buildings Other Than Residence
      6600 - Orchard Groves-All Groves Vacant
      6610 - Orchard Groves-All Groves With Residence
      6620 - Orchard Groves-All Groves With Buildings Other Than Residence
      6630 - Orchard Groves-Part Grove And Part Not Planted Vacant
      6640 - Orchard Groves-Part Grove And Part Not Planted With Residence
      6650 - Orchard Groves-Part Grove And Part Not Planted With Buildings Other Than
      6660 - Combination-Part Orchard Groves And Part Pasture Land-Vacant
      6670 - Combination-Part Orchard Groves And Part Pasture Land With Buildings Other
      6680 - Combination-Part Orchard Groves And Part Pasture Land With Residence
      6690 - Mixed Tropical Fruits Vacant
      6691 - Mixed Tropical Fruits With Residence
      6692 - Mixed Tropical Fruits With Building Other Than Residence
      6700 - Poultry Farms
      6710 - Rabbit Farms
      6720 - Tropical Fish Farms
      6730 - Bees (Honey) Farms
      6800 - Dairies-With Buildings Other Than Residence
      6810 - Dairies-With Residence
      6820 - Feed Lots Vacant
      6900 - Nurserys-Vacant
      6910 - Nurserys-With Residence
      6920 - Nurserys-With Buildings Other Than Residence
    90051 - Cropland soil capability Class I
    90052 - Cropland soil capability Class II
    90053 - Cropland soil capability Class III
    90054 - Timberland - site index 90 and above
    90055 - Timberland - site index 80 to 89
    90056 - Timberland - site index 70 to 79
    90057 - Timberland - site index 60 to 69
    90058 - Timberland - site index 50 to 59
    90059 - Timberland not classified by site index to Pines
    90060 - Grazing land soil capability Class I
    90061 - Grazing land soil capability Class II
    90062 - Grazing land soil capability Class III
    90063 - Grazing land soil capability Class IV
    90064 - Grazing land soil capability Class V
    90065 - Grazing land soil capability Class VI
    90066 - Orchard Groves, Citrus, etc.
    90067 - Poultry, bees, tropical fish, rabbits, etc.
    90068 - Dairies, feed lots
    90069 - Ornamentals, miscellaneous agricultural

    94000 - Agricultural Property
    90050 - Improved agricultural


    17 - Hotel & Motel
      700 - Migrant Camps, Boarding Homes, Etc
      719 - Bed And Breakfast
      3900 - Motor Inn
      3910 - Limited Service Hotel
      3920 - Full Service Hotel
      3930 - Extended Stay Or Suite Hotel
      3940 - Luxury Hotel/Resort
      3950 - Convention Hotel/Resort
    90007 - Miscellaneous Residential (migrant camp or boarding home.)
    90039 - Hotel or motel

    18 - Senior Housing
      616 - Retirement Home
      7400 - Home For The Aged
      7500 - Assisted Care Living Facility
90006 - Retirement Home not eligible for exemption.
    90074 - Home for the aged


    19 - Health Care
      1950 - Day Care Center
      7300 - Hospital -General-Privately Owned
      7310 - Clinic
      7841 - Convalescent Home (Nursing Home)
      8500 - Hospital
    90073 - Privately owned hospital
    90078 - Sanitarium or convalescent rest home



    23 - Sports & Entertaining
      3100 - Theatre  (Drive-In)
      3120 - Stadium  (Not Enclosed)
      3200 - Auditorium  (Enclosed)
      3210 - Theatre (Enclosed)
      3220 - Recreation Hall
      3230 - Fitness Center
      3300 - Night Clubs, Cocktail Lounges, Bars
      3400 - Bowling Alleys, Skating Rinks, And Pool Halls
      3430 - Arena  (Enclosed)
      3440 - Arena  (Open Air) With Supporting Facilities
      3500 - Tourist Attraction
      3510 - Permanent Exhibit
      3600 - Camp  (Other Than For Mobile Homes)
      3610 - Campground (Trailers, Campers & Tents)
      3700 - Race Track / Wagering Attraction
      3800 - Golf Course
      3810 - Driving Range
      3820 - Country Club / Support Facilities
      7700 - Clubs, Lodges, And Union Halls
      7800 - Gymnasium
    90035 - Tourist attraction, permanent exhibit or other entertainment facilities
    90036 -  Camp
    90037 - Race track: horse, auto or dog
    90038 - Golf course or driving range
    90031 - Drive-in theater or open stadium
    90032 - Enclosed theater or auditorium
    90034 - Bowling alley, skating rink, pool hall or enclosed arena
90033 - Nightclub, cocktail lounge or bar


    24 - Special Purpose
      1222 - Commercial Related Amenities
      1233 - Improved Commercial Common Area
      1960 - Radio Or Tv Station
      2000 - Airports - Private
      2010 - Airports - Commercial
      2015 - Marinas
      3010 - Greenhouse
      3020 - Nursery (Non-Agric. Classification)
      3030 - Horse Stables
      3040 - Dog Kennel
      3693 - Labor Camp
      7100 - Church
      7200 - School -Private
      7210 - School -Private-Church Owned
      7211 - Church Owned Educational Building
      7220 - College -Private
      7230 - Fraternity Or Sorority Home
      7510 - Childrens Home
      7600 - Mortuary
      7610 - Cemetery
      7620 - Crematorium
      7810 - Fire Station
      7820 - Library
      8400 - College
    90020 - Airport (private or commercial), bus terminal, marine terminal, pier or marina.

  95000 - Institutional Property
    90071 - Church
    90072 - Private school or college


    90075 - Orphanage, other non-profit or charitable services
    90076 - Mortuary, cemetery or crematorium
    90077 - Club, lodge or union hall

    90079 - Cultural organization, facility


  3 - Land
    7 - Vacant Residential Land - Multi Family Platted
    8 - Vacant Multi-Family Unplatted Less Than 5 Acres
    9 - Vacant Single Family Unplatted Less Than 5 Acres
    10 - Vacant Residential Land - Single Family Platted
    20 - Vacant Mobile Home Site - Platted
    21 - Vacant Mobile Home Site - Unplatted
    33 - Vacant Residential Common Area
    40 - Condominium Unit - Vacant Land
    50 - Co-Op Vacant Land
    51 - Co-Op Vacant With Utilities
    1000 - Vacant Commercial Land
    1033 - Vacant Commercial Common Area
    4000 - Vacant Industrial Land
    7000 - Vacant Land - Institutional
    8100 - Military-Vacant Land
    8110 - Military-Improved Land
    8200 - Forest Park Vacant
    8210 - Recreational Area (Governmental) Vacant
    8300 - School -Public-Improved Parcels
    8310 - School -Public-Vacant Parcels
    8630 - Brevard County-Agencies Other Than Board Of County Commissioners, Vacant
    8640 - Brevard County-Agencies Other Than Board Of County Commissioners, Improved
    8650 - Housing Authority -Vacant
    8660 - Housing Authority -Improved
    8670 - Canaveral Port Authority - Vacant
    8680 - Canaveral Port Authority - Improved
    8700 - State Owned Land-Vacant (That Does Not Qualify In Another Code)
    8710 - State Owned Land-Improved (That Does Not Qualify In Another Code)
    8800 - Federal Owned Land-Vacant (That Does Not Qualify In Another Code)
    8810 - Federal Owned Land-Improved (That Does Not Qualify In Another Code)
    8900 - Municipal Owned Land-Vacant (That Does Not Qualify In Another Code)
    8910 - Municipal Owned Land-Improved (That Does Not Qualify In Another Code)
    8920 - Airport Authority-Vacant
    8930 - Airport Authority-Improved
    9000 - Leased County/City Property-Vacant
    9010 - Leased County/City Property-Improved
    9100 - Utility-Gas Companies-Improved
    9105 - Locally Assessed Railroad Property
    9110 - Utility-Gas Companies-Vacant
    9120 - Utility-Electric Co. Improved
    9130 - Utility-Electric Co. Vacant
    9140 - Utility-Tel & Tel-Improved
    9150 - Utility-Tel & Tel-Vacant
    9200 - Mining and Prod of Pet and Gas
    9300 - Subsurface Rights Vacant
    9400 - Right Of Way Street, Road, Etc - Public
    9410 - Right Of Way Street, Road, Etc - Private
    9465 - Improvement Not Suitable To Any Other Code
    9499 - Assessment Arrears
    9500 - Rivers And Lakes
    9510 - Submerged Lands
    9600 - Waste Land
    9610 - Marsh Vacant
    9620 - Sand Dune Vacant
    9630 - Swamp
    9700 - Recreational Or Park Lands Vacant
    9800 - Centrally Assessed
    9900 - All Acreage-Other Than Government Owned And Not Zoned Agricultural-Vacant
    9908 - Vacant Residential Land Multi-Family Unplatted 5 Acres And Greater
    9909 - Vacant Residential Land-Single Family Unplatted 5 Acres And Greater
    9910 - Vacant Site Approved For Cellular Tower
    9920 - Vacant Agricultural Zoned Land (Not In Use)
    9930 - Vacant Site Approved For Billboard
    9990 - Non Taxable Condominium Common Area
    90000 - Vacant Residential
    90010 - Vacant Commercial
    90040 - Vacant Industrial
    90070 - Vacant Institutional Property
    90092 - Mining land, petroleum land, or gas land
    90093 - Subsurface rights
    90094 - Right-of-way, street, road, irrigation channel, ditch, etc.
    90095 - River, lake or submerged land
    90096 - Sewage disposal, solid waste, borrow pit, drainage reservoir, waste land, marsh, sand dune or swamp
    90097 - Outdoor recreational or high-water recharge subject
    90099 - Acreage not zoned agricultural with or without extra features

      
    90028 - Parking lot (commercial or patron) or mobile home park

  4 - Mobile/Manufactured
    212 - Manufactured Housing-Single
    213 - Manufactured Housing-Double
    214 - Manufactured Housing-Triple
    237 - Manufactured Housing Rental Lot W/Improvements (With Manufactured Home)
    238 - Manufactured Housing Rental Lot With Improvements (No Manufactured Home)
    239 - Manufactured Housing Rental Lot Without Improvements (No Manufactured Home)
    264 - Manufactured Home Not Suitable For Occup Ancy
    422 - Condominium - Manufactured Home Park
    437 - Condo Manufactured Housing Rental Lot W/Improvements (With Manufactured Home)
    522 - Co-Op Manufactured Home - Improved
    537 - Co-Op Manufactured Housing Rental Lot W/Improvements (With Manufactured Home)
    538 - Co-Op Improved (Without Manufactured Home)
    541 - Co-Op With Site Improvements
    564 - Co-Op Not Suitable For Occupancy
    817 - House And Mobile Home
    818 - Two Or Three Mobile Homes, Not A Park
    837 - Two Or More Manufactured Housing Rental Lots (With Manufactured Home(S)
    838 - Two Or More Manufactured Housing Rental Lots (Without Manufactured Home(S)
    2890 - Manuf. Housing Park - 4 To 9 Spaces Rentals
    2891 - Manuf. Housing Park - 10 To 25 Spaces Rentals
    2892 - Manuf. Housing Park - 26 To 50 Spaces Rentals
    2893 - Manuf. Housing Park - 51 To 100 Spaces Rentals
    2894 - Manuf. Housing Park - 101 To 150 Spaces Rentals
    2895 - Manuf. Housing Park - 151 To 200 Spaces Rentals
    2896 - Manuf. Housing Park - 201 & More Spaces Rentals
    8600 - County Owned Land-Vacant (That Does Not Qualify In Another Code)
    8610 - County Owned Land-Improved (That Does Not Qualify In Another Code)

    90002 - Mobile Home




  96000 - Government Property
    90080 - Government Undefined
    90081 - Military
    90082 - Forest, park or recreational area
    90083 - Public county school
    90084 - College
    90085 - Hospital
    90086 - County Owned
    90087 - State Owned
    90088 - Federal Owned
    90089 - Municipal Owned
  97000 - Miscellaneous Property
    90090 - Leasehold interests (government owned property leased by a non-governmental lessee)
    90091 - Utility
    90098 - Centrally assessed

436 rows selected.
