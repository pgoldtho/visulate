declare
  procedure insert_media( p_name     in varchar2
                        , p_count    in number
                        , p_start    in number := 1
                        , p_city_id  in number := null) is

    

    v_media_id   number;
    v_city_name  varchar2(35);
    v_city_id    number;
    v_region_id  number;
    v_county_yn  varchar2(1);
    vx_region_id number;
    

  begin
    v_city_name := upper(p_name);
    v_city_name := replace(v_city_name, '_', ' ');

    if p_city_id is not null then
      v_city_id := p_city_id;
      select region_id
      into  v_region_id
      from rnt_cities
      where city_id = p_city_id;
    else
      select city_id, region_id
      into v_city_id, v_region_id
      from rnt_cities
      where state = 'FL'
      and name = v_city_name
      and rownum = 1;
    end if;

    for i in p_start .. p_count loop
      if i = 1 then
        v_county_yn  := 'Y';
        vx_region_id := v_region_id;
      else
        v_county_yn  := 'N';
        vx_region_id := null;
      end if;
      
      v_media_id := rnt_city_media_pkg.insert_row
                     ( X_NAME         => p_name||'-'||i||'.jpg'
                     , X_MEDIA_TYPE   => 'image/jpeg'
                     , X_CITY_ID      => v_city_id
                     , X_REGION_ID    => vx_region_id
                     , X_TITLE        => initcap(v_city_name)||' '||i||'/'||p_count
                     , X_ASPECT_RATIO => '16:10'
                     , X_COUNTY_YN    => v_county_yn);
    end loop;
  end insert_media;
  
  procedure retitle( p_old_title  in varchar2
                   , p_new_title  in varchar2) is
                   
  begin
    update rnt_city_media
    set title = p_new_title
    where title = p_old_title;
  end retitle;

  procedure insert_media is
  begin
  /*
    insert_media('alachua', 2);
    insert_media('altamonte_springs', 2);
    insert_media('anna_maria', 6);
    insert_media('apollo_beach', 2);
    insert_media('apopka', 4);
    insert_media('arcadia', 1);
    insert_media('boca_grande', 3);
    insert_media('boca_raton', 11);
    insert_media('bonita_springs', 6);
    insert_media('boynton_beach', 6);    
    insert_media('bradenton', 2);
    insert_media('branford', 1);
    insert_media('cape_canaveral', 7);
    insert_media('captiva', 5);
    insert_media('cedar_key', 7);
    insert_media('clearwater', 4);
    insert_media('cocoa_beach', 6);
    insert_media('dania', 3);
    insert_media('daytona_beach', 9);
    insert_media('deerfield_beach', 2);
    insert_media('deland', 2);
    insert_media('delray_beach', 3);
    insert_media('destin', 5);
    insert_media('estero', 3);
    insert_media('everglades_city', 2);
    insert_media('fernandina_beach', 13);
    insert_media('flagler_beach', 2);
    insert_media('fort_lauderdale', 4);
    insert_media('fort_myers', 5);
    insert_media('fort_pierce', 1);
    insert_media('fort_walton_beach', 2);
    insert_media('gainesville', 5);
    insert_media('haines_city', 1);
    insert_media('high_springs', 4);
    insert_media('hollywood', 3);
    insert_media('homestead', 6);
    insert_media('homosassa', 2);
    insert_media('inglis', 1);
    insert_media('inverness', 1);
    insert_media('islamorada',3 );
    insert_media('jacksonville_beach', 3);
    insert_media('jacksonville', 5);
    insert_media('jupiter', 5);
    insert_media('key_biscayne', 6);
    insert_media('key_largo', 7);
    insert_media('key_west', 13);
    insert_media('kissimmee', 4);
    insert_media('lake_monroe', 1);
    insert_media('lake_placid', 1);
    insert_media('lakeland', 1);
    insert_media('loxahatchee', 4);
    insert_media('lynn_haven', 1);
    insert_media('maitland', 1);
    insert_media('marco_island', 2);
    insert_media('merritt_island', 5);
    insert_media('mexico_beach', 2);
    insert_media('miami_beach', 12);
    insert_media('miami', 17);
    insert_media('miramar_beach', 1);
    insert_media('moore_haven', 1);
    insert_media('naples', 5);
    insert_media('new_smyrna_beach', 6);
    insert_media('nokomis', 2);
    insert_media('ocala', 6);
    insert_media('ochopee', 2);
    insert_media('okeechobee', 3);
    insert_media('olustee', 1);
    insert_media('orlando', 11);
    insert_media('ormond_beach', 5);
    insert_media('panama_city_beach', 5);
    insert_media('pensacola', 8);
    insert_media('pompano_beach', 1);
    insert_media('ponte_vedra_beach', 2);
    insert_media('ruskin', 1);
    insert_media('saint_augustine', 7);
    insert_media('saint_marks', 2);
    insert_media('saint_petersburg', 5);
    insert_media('sanford', 6);
    insert_media('sanibel', 5);
    insert_media('sarasota', 16);
    insert_media('satellite_beach', 7);
    insert_media('sebring', 1);
    insert_media('stuart', 7);
    insert_media('summerland_key', 4);
    insert_media('suwannee', 1);
    insert_media('tallahassee', 8);
    insert_media('tampa', 5);
    insert_media('tarpon_springs', 2);
    insert_media('tavernier', 2);
    insert_media('thonotosassa', 1);
    insert_media('venice', 1);
    insert_media('vero_beach', 4);
    insert_media('west_palm_beach', 7);
    insert_media('cocoa', 12);

    insert_media('apalachicola', 9);
    insert_media('eastpoint', 2);
    insert_media('fountain', 3);
    insert_media('greenville', 5);
    insert_media('lamont', 2);
    insert_media('lee', 4);
    insert_media('lloyd', 4);
    insert_media('madison', 10);
    insert_media('monticello', 9);
    insert_media('palm_bay', 15);
    insert_media('panama_city', 5);
    insert_media('pinetta', 5);
    insert_media('port_saint_joe', 5);
    insert_media('wacissa', 6);
    insert_media('youngstown', 1);
   
    insert_media('mexico_beach', 5, 3);
    insert_media('lynn_haven', 3, 2);
        
    retitle('Mexico Beach 1/2',  'Mexico Beach 1/5');
    retitle('Mexico Beach 2/2',  'Mexico Beach 2/5');
    retitle('Lynn Haven 1/1', 'Lynn Haven 1/3');

    insert_media('rockledge', 4);
    

    insert_media('melbourne', 10);
    insert_media('melbourne_beach', 7);
    insert_media('indialantic', 6);
    insert_media('sebastian', 5);
    insert_media('malabar', 5);
    insert_media('grant', 6);
    
    insert_media('mims', 11);        
    insert_media('titusville', 10);
  
    insert_media('fellsmere', 7);
    insert_media('vero_beach', 13, 5);
    retitle('Vero Beach 1/4',  'Vero Beach 1/13');
    retitle('Vero Beach 2/4',  'Vero Beach 2/13');
    retitle('Vero Beach 3/4',  'Vero Beach 3/13');
    retitle('Vero Beach 4/4',  'Vero Beach 4/13');
    
    insert_media('sebastian_inlet', 6, 1, 10140);

    insert_media('chattahoochee', 8);
    insert_media('gretna', 4);
    insert_media('quincy', 9);
    insert_media('marianna', 3);
    insert_media('crawfordville', 3);
    insert_media('panacea', 10);
    insert_media('saint_marks', 10, 3);
    insert_media('sopchoppy', 5);
    insert_media('glen_saint_mary', 5);
    insert_media('macclenny', 9);
    insert_media('sanderson', 5);

    retitle('Saint Marks 1/2',  'Saint Marks 1/10');

    insert_media('fort_pierce', 10, 2);
    insert_media('port_saint_lucie', 6);

    retitle('Fort Pierce 1/1',  'Fort Pierce 1/10');
    update rnt_city_media
    set aspect_ratio='16:10'
    ,   region_id = 1
    ,   county_yn = 'Y'
    where name='fort_pierce-1.jpg';

    insert_media('chiefland', 6);
    insert_media('cross_city', 6);
    insert_media('old_town', 5);
    insert_media('perry', 9);
    insert_media('salem', 5);
    insert_media('williston', 4);

    insert_media('', );


    insert_media('geneva', 9);
    insert_media('lake_mary', 7);
    insert_media('oviedo', 8);
    insert_media('longwood', 13);
    insert_media('winter_springs', 11);


    insert_media('oak_hill', 8);    
    insert_media('dundee', 9);
    insert_media('winter_haven', 9);
    insert_media('lakeland', 4, 2);
    retitle('Lakeland 1/1',  'Lakeland 1/4');

    insert_media('opa_locka', 9);
    insert_media('north_miami_beach', 9);
    insert_media('palm_beach', 9);
    insert_media('pompano_beach', 7, 2);
    retitle('Pompano Beach 1/1',  'Pompano Beach 1/7');
    insert_media('hialeah', 7);

    insert_media('lake_worth', 7);
    insert_media('palm_beach_gardens', 8);


    insert_media('clermont', 8);
    insert_media('minneola', 3);
    insert_media('leesburg', 4);
    insert_media('tavares', 9);
    insert_media('eustis', 7);
    insert_media('mount_dora', 7);
 
    insert_media('port_orange', 9);
    insert_media('edgewater', 7);

    insert_media('christmas', 9);
*/
    insert_media('hosford', 7);
    insert_media('telogia', 4);
    insert_media('bristol', 7);
    insert_media('blountstown', 11);
    insert_media('chipley', 11);
    insert_media('wausau', 5);
    insert_media('vernon', 3);
    insert_media('panama_city_beach', 10, 6);
    retitle('Panama City Beach 1/5',  'Pompano Beach 1/10');
    retitle('Panama City Beach 2/5',  'Pompano Beach 2/10');
    retitle('Panama City Beach 3/5',  'Pompano Beach 3/10');
    retitle('Panama City Beach 4/5',  'Pompano Beach 4/10');
    retitle('Panama City Beach 5/5',  'Pompano Beach 5/10');
    insert_media('mayo', 9);
    insert_media('bell', 4);
    insert_media('trenton', 9);
    insert_media('newberry', 7);

  end insert_media;

  procedure set_aspect(p_name in varchar2) is
  begin
    update rnt_city_media
    set aspect_ratio='10:16'
    ,   region_id = null
    ,   county_yn = 'N'
    where name=p_name;
  end set_aspect;

  procedure set_aspect_ratios is
  begin
    set_aspect('anna_maria-4.jpg');
    set_aspect('anna_maria-6.jpg');
    set_aspect('apollo_beach-1.jpg');
    set_aspect('apollo_beach-2.jpg');
    set_aspect('boca_grande-3.jpg');
    set_aspect('bonita_springs-3.jpg');
    set_aspect('cocoa_beach.jpg');
    set_aspect('boynton_beach-3.jpg');
    set_aspect('fernandina_beach-9.jpg');
    set_aspect('fort_pierce-1.jpg');
    set_aspect('gainesville-2.jpg');
    set_aspect('high_springs-4.jpg');
    set_aspect('key_largo-6.jpg');
    set_aspect('key_west-10.jpg');
    set_aspect('maitland-1.jpg');
    set_aspect('merritt_island-5.jpg');
    set_aspect('miami-5.jpg');
    set_aspect('miami-10.jpg');
    set_aspect('orlando-4.jpg');
    set_aspect('orlando-6.jpg');
    set_aspect('orlando-7.jpg');
    set_aspect('pensacola-3.jpg');
    set_aspect('ponte_vedra_beach-1.jpg');
    set_aspect('ponte_vedra_beach-2.jpg');
    set_aspect('ruskin-1.jpg');
    set_aspect('saint_marks-2.jpg');
    set_aspect('sanford-3.jpg');
    set_aspect('sanibel-3.jpg');
    set_aspect('sarasota-4.jpg');
    set_aspect('sarasota-7.jpg');
    set_aspect('stuart-2.jpg');
    set_aspect('stuart-5.jpg');
    set_aspect('summerland_key-2.jpg');
    set_aspect('suwannee-1.jpg');
    set_aspect('tallahassee-2.jpg');
    set_aspect('tallahassee-3.jpg');
    set_aspect('tallahassee-4.jpg');
    set_aspect('tallahassee-7.jpg');
    set_aspect('tavernier-2.jpg');
    set_aspect('vero_beach-3.jpg');
    
  end set_aspect_ratios;

begin
  insert_media;
  --set_aspect_ratios;
end;
/
