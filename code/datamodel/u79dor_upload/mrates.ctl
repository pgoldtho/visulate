load data
 infile *
 truncate into table pr_millage_rates
 fields terminated by "," optionally enclosed by '"'
 (year, id, county, millage, rent_rate)
begindata
2012,11,"Alachua",23.88,10.14
2012,12,"Baker",17.38,8.81
2012,13,"Bay",12.36,10.38
2012,14,"Bradford",18.4,7.05
2012,3,"Brevard",20.09,10.39
2012,16,"Broward",20.98,16.24
2012,17,"Calhoun",17.59,6.54
2012,18,"Charlotte",16.91,12.34
2012,19,"Citrus",16.24,11.18
2012,20,"Clay",16.38,10.57
2012,21,"Collier",11.74,11.08
2012,22,"Columbia",18.32,9.08
2012,23,"Miami-Dade",20.32,13.99
2012,24,"DeSoto",16.21,7.99
2012,25,"Dixie",22.02,6.34
2012,26,"Duval",7.92,10.57
2012,27,"Escambia",16.27,10.76
2012,28,"Flagler",18.63,10.76
2012,29,"Franklin",11.56,8.43
2012,30,"Gadsden",18.18,9.19
2012,31,"Gilchrist",18.09,10.14
2012,32,"Glades",20.06,9.44
2012,33,"Gulf",15.6,8.5
2012,34,"Hamilton",19.02,7.03
2012,35,"Hardee",17.58,8.28
2012,36,"Hendry",20.52,9.72
2012,37,"Hernando",16.12,11.59
2012,38,"Highlands",16.4,9.57
2012,39,"Hillsborough",20.73,11.59
2012,40,"Holmes",15.94,6.37
2012,41,"Indian River",16.24,8.99
2012,42,"Jackson",14.57,6.63
2012,43,"Jefferson",17.41,9.19
2012,44,"Lafayette",17.57,7.22
2012,45,"Lake",16.83,11.44
2012,46,"Lee",17.83,10.44
2012,47,"Leon",18.67,9.19
2012,48,"Levy",17.32,6.72
2012,49,"Liberty",18.25,6.54
2012,50,"Madison",18.78,6.97
2012,51,"Manatee",17.02,10.88
2012,52,"Marion",16.25,8.14
2012,53,"Martin",16.57,10.37
2012,54,"Monroe",10.12,18.76
2012,55,"Nassau",16.43,10.57
2012,56,"Okaloosa",13.69,11.05
2012,57,"Okeechobee",18.72,10.31
2012,5,"Orange",18.08,11.44
2012,59,"Osceola",17.05,11.44
2012,60,"Palm Beach",20.95,12.92
2012,61,"Pasco",16.49,11.59
2012,62,"Pinellas",20.54,11.59
2012,63,"Polk",17.55,9.5
2012,64,"Putnam",18.4,6.55
2012,65,"Saint Johns",16.39,10.57
2012,66,"Saint Lucie",22.87,10.37
2012,67,"Santa Rosa",14.65,10.76
2012,68,"Sarasota",14.28,10.88
2012,69,"Seminole",16.95,11.44
2012,70,"Sumter",13.56,9.17
2012,71,"Suwannee",17.47,7.05
2012,72,"Taylor",16.82,5.59
2012,73,"Union",19.36,6.58
2012,4,"Volusia",23.51,9.33
2012,75,"Wakulla",17.23,7.44
2012,76,"Walton",9.67,8.8
2012,77,"Washington",18.1,7.44