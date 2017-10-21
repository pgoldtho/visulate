create index mls_listings_n6 on mls_listings(LISTING_DATE) tablespace mls_data2;

alter table pr_sources add county_id  number;
alter table pr_sources add constraint pr_sources_r1
foreign key (county_id) references rnt_cities(city_id);

create index pr_sources_n1 on pr_sources(county_id);

begin
update pr_sources set county_id = 30294 where source_id = 11; -- ALACHUA Alachua Property Appraiser
update pr_sources set county_id = 30295 where source_id = 12; -- BAKER Baker Property Appraiser
update pr_sources set county_id = 30296 where source_id = 13; -- BAY Bay Property Appraiser
update pr_sources set county_id = 30297 where source_id = 14; -- BRADFORD Bradford Property Appraiser
update pr_sources set county_id = 30298 where source_id = 3; -- BREVARD Brevard Property Appraiser
update pr_sources set county_id = 30299 where source_id = 16; -- BROWARD Broward Property Appraiser
update pr_sources set county_id = 30300 where source_id = 17; -- CALHOUN Calhoun Property Appraiser
update pr_sources set county_id = 30301 where source_id = 18; -- CHARLOTTE Charlotte Property Appraiser
update pr_sources set county_id = 30302 where source_id = 19; -- CITRUS Citrus Property Appraiser
update pr_sources set county_id = 30303 where source_id = 20; -- CLAY Clay Property Appraiser
update pr_sources set county_id = 30304 where source_id = 21; -- COLLIER Collier Property Appraiser
update pr_sources set county_id = 30305 where source_id = 22; -- COLUMBIA Columbia Property Appraiser
update pr_sources set county_id = 30306 where source_id = 24; -- DESOTO Desoto Property Appraiser
update pr_sources set county_id = 30307 where source_id = 25; -- DIXIE Dixie Property Appraiser
update pr_sources set county_id = 30308 where source_id = 26; -- DUVAL Duval Property Appraiser
update pr_sources set county_id = 30309 where source_id = 27; -- ESCAMBIA Escambia Property Appraiser
update pr_sources set county_id = 30310 where source_id = 28; -- FLAGLER Flagler Property Appraiser
update pr_sources set county_id = 30311 where source_id = 29; -- FRANKLIN Franklin Property Appraiser
update pr_sources set county_id = 30312 where source_id = 30; -- GADSDEN Gadsden Property Appraiser
update pr_sources set county_id = 30313 where source_id = 31; -- GILCHRIST Gilchrist Property Appraiser
update pr_sources set county_id = 30314 where source_id = 32; -- GLADES Glades Property Appraiser
update pr_sources set county_id = 30315 where source_id = 33; -- GULF Gulf Property Appraiser
update pr_sources set county_id = 30316 where source_id = 34; -- HAMILTON Hamilton Property Appraiser
update pr_sources set county_id = 30317 where source_id = 35; -- HARDEE Hardee Property Appraiser
update pr_sources set county_id = 30318 where source_id = 36; -- HENDRY Hendry Property Appraiser
update pr_sources set county_id = 30319 where source_id = 37; -- HERNANDO Hernando Property Appraiser
update pr_sources set county_id = 30320 where source_id = 38; -- HIGHLANDS Highlands Property Appraiser
update pr_sources set county_id = 30321 where source_id = 39; -- HILLSBOROUGH Hillsborough Property Appraiser
update pr_sources set county_id = 30322 where source_id = 40; -- HOLMES Holmes Property Appraiser
update pr_sources set county_id = 30323 where source_id = 41; -- INDIAN RIVER Indian River Property Appraiser
update pr_sources set county_id = 30324 where source_id = 42; -- JACKSON Jackson Property Appraiser
update pr_sources set county_id = 30325 where source_id = 43; -- JEFFERSON Jefferson Property Appraiser
update pr_sources set county_id = 30326 where source_id = 44; -- LAFAYETTE Lafayette Property Appraiser
update pr_sources set county_id = 30327 where source_id = 45; -- LAKE Lake Property Appraiser
update pr_sources set county_id = 30328 where source_id = 46; -- LEE Lee Property Appraiser
update pr_sources set county_id = 30329 where source_id = 47; -- LEON Leon Property Appraiser
update pr_sources set county_id = 30330 where source_id = 48; -- LEVY Levy Property Appraiser
update pr_sources set county_id = 30331 where source_id = 49; -- LIBERTY Liberty Property Appraiser
update pr_sources set county_id = 30332 where source_id = 50; -- MADISON Madison Property Appraiser
update pr_sources set county_id = 30333 where source_id = 51; -- MANATEE Manatee Property Appraiser
update pr_sources set county_id = 30334 where source_id = 52; -- MARION Marion Property Appraiser
update pr_sources set county_id = 30335 where source_id = 53; -- MARTIN Martin Property Appraiser
update pr_sources set county_id = 30337 where source_id = 54; -- MONROE Monroe Property Appraiser
update pr_sources set county_id = 30338 where source_id = 55; -- NASSAU Nassau Property Appraiser
update pr_sources set county_id = 30339 where source_id = 56; -- OKALOOSA Okaloosa Property Appraiser
update pr_sources set county_id = 30340 where source_id = 57; -- OKEECHOBEE Okeechobee Property Appraiser
update pr_sources set county_id = 30341 where source_id = 5; -- ORANGE Orange County Property Appraiser
update pr_sources set county_id = 30342 where source_id = 59; -- OSCEOLA Osceola Property Appraiser
update pr_sources set county_id = 30343 where source_id = 60; -- PALM BEACH Palm Beach Property Appraiser
update pr_sources set county_id = 30344 where source_id = 61; -- PASCO Pasco Property Appraiser
update pr_sources set county_id = 30345 where source_id = 62; -- PINELLAS Pinellas Property Appraiser
update pr_sources set county_id = 30346 where source_id = 63; -- POLK Polk Property Appraiser
update pr_sources set county_id = 30347 where source_id = 64; -- PUTNAM Putnam Property Appraiser
update pr_sources set county_id = 30350 where source_id = 67; -- SANTA ROSA Santa Rosa Property Appraiser
update pr_sources set county_id = 30351 where source_id = 68; -- SARASOTA Sarasota Property Appraiser
update pr_sources set county_id = 30352 where source_id = 69; -- SEMINOLE Seminole Property Appraiser
update pr_sources set county_id = 30353 where source_id = 70; -- SUMTER Sumter Property Appraiser
update pr_sources set county_id = 30354 where source_id = 71; -- SUWANNEE Suwannee Property Appraiser
update pr_sources set county_id = 30355 where source_id = 72; -- TAYLOR Taylor Property Appraiser
update pr_sources set county_id = 30356 where source_id = 73; -- UNION Union Property Appraiser
update pr_sources set county_id = 30357 where source_id = 4; -- VOLUSIA Volusia County Property Appraiser
update pr_sources set county_id = 30358 where source_id = 75; -- WAKULLA Wakulla Property Appraiser
update pr_sources set county_id = 30359 where source_id = 76; -- WALTON Walton Property Appraiser
update pr_sources set county_id = 30360 where source_id = 77; -- WASHINGTON Washington Property Appraiser

update pr_sources set county_id = 30336 where source_id = 23; -- MIAMI-DADE Miami Dade Property Appraiser
update pr_sources set county_id = 30348 where source_id = 65; -- SAINT JOHNS St. Johns Property Appraiser
update pr_sources set county_id = 30349 where source_id = 66; -- SAINT LUCIE St. Lucie Property Appraiser
end;
/