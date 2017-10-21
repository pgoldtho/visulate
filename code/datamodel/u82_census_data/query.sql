select puma, median(trunc(rntp*adjhsg/1000000)) from asc_pums_housing where  rntp is not null group by puma order by puma; -- rent
select puma, median(trunc(insp*adjhsg/1000000)) from asc_pums_housing where  insp is not null group by puma order by puma; -- insurance
select puma, median(trunc(fincp*adjinc/1000000)) from asc_pums_housing where  fincp is not null group by puma order by puma; -- household income

--
-- Median SFH Size  (MI = 1744)
--
select zipcode, median(sq_ft)
from pr_properties p
,    pr_property_usage pu
where p.prop_id = pu.prop_id
and pu.ucode in (110, 90001)
group by zipcode
order by zipcode;

--
-- Median Insurance (MI = 1674)
--
select z.zipcode, median(trunc(insp*adjhsg/1000000))
from asc_pums_housing h
,    asc_zipuma z
where  insp is not null
and z.puma2k = h.puma
group by zipcode
order by zipcode;

--
-- Median Rent (MI = 825)
--
select z.zipcode, median(trunc(rntp*adjhsg/1000000))
from asc_pums_housing h
,    asc_zipuma z
where  rntp is not null
and z.puma2k = h.puma
group by zipcode
order by zipcode;

-- 3bed = $1,031
select z.zipcode, bds, median(trunc(rntp*adjhsg/1000000))
from asc_pums_housing h
,    asc_zipuma z
where  rntp is not null
and z.puma2k = h.puma
group by zipcode, bds
order by zipcode, bds;

-- Gross Rent (MI = 1,190)
select z.zipcode, median(trunc(grntp*adjhsg/1000000))
from asc_pums_housing h
,    asc_zipuma z
where grntp is not null
and z.puma2k = h.puma
and bds = 3
group by zipcode
order by zipcode;

-- Gross Rent as Percentage of Gross Income (MI=29)
select z.zipcode, median(grpip)
from asc_pums_housing h
,    asc_zipuma z
where grpip is not null
and z.puma2k = h.puma
and bds = 3
group by zipcode
order by zipcode;


-- First Mortgage (MI = 1,253)
select z.zipcode, median(trunc(mrgp*adjhsg/1000000))
from asc_pums_housing h
,    asc_zipuma z
where mrgp is not null
and z.puma2k = h.puma
and bds = 3
group by zipcode
order by zipcode;

-- Selected Monthly owner costs (1,205)
select z.zipcode,  median(trunc(smocp*adjhsg/1000000))
from asc_pums_housing h
,    asc_zipuma z
where smocp is not null
and z.puma2k = h.puma
and bds = 3
group by zipcode
order by zipcode;



--
-- Household Income (MI = 74276.5)
--
select z.zipcode, median(trunc(fincp*adjinc/1000000))
from asc_pums_housing h
,    asc_zipuma z
where fincp is not null
and z.puma2k = h.puma
group by zipcode
order by zipcode;


--
-- Rnt as % of Household Income
--
select z.zipcode, median(grpip)
from asc_pums_housing h
,    asc_zipuma z
where grpip is not null
and z.puma2k = h.puma
and zipcode in (32952, 32780)
group by zipcode
order by zipcode;




--
-- Count Rented Properties (MI=632)
--
select z.zipcode, count(*)
from asc_pums_housing h
,    asc_zipuma z
where ten = 3
and z.puma2k = h.puma
group by zipcode
order by zipcode;

--
-- Count Vacant Rentals (MI=79)  vacancy % = 79/(79+632)*100 = 11.1%
--
select z.zipcode, count(*)
from asc_pums_housing h
,    asc_zipuma z
where vacs = 1
and z.puma2k = h.puma
group by zipcode
order by zipcode;



--
-- Household Income Renters (MI = 45214)
--
select median(trunc(fincp*adjinc/1000000))
from asc_pums_housing h
,    asc_zipuma z
where  grntp is not null
and z.puma2k = h.puma
and zipcode = 32952;



select   round(min(fincp*adjinc/1000000), 2) min_sal
  ,      round(PERCENTILE_DISC(0.125) within group (order by fincp*adjinc/1000000), 2) c_median
  ,      round(PERCENTILE_DISC(0.25) within group (order by fincp*adjinc/1000000), 2) c_max
  ,      round(median(fincp*adjinc/1000000), 2) b_median
  ,      round(PERCENTILE_DISC(0.75) within group (order by fincp*adjinc/1000000), 2) a_min
  ,      round(PERCENTILE_DISC(0.875) within group (order by fincp*adjinc/1000000), 2) a_median
  ,      round(max(fincp*adjinc/1000000), 2) max_sal
from asc_pums_housing h
,    asc_zipuma z
where z.puma2k = h.puma
and zipcode = 32952
and fincp > 0

select zipcode
  ,      round(PERCENTILE_DISC(0.125) within group (order by fincp*adjinc/1000000) * 0.025) c_min
  ,      round(PERCENTILE_DISC(0.25) within group (order by fincp*adjinc/1000000) * 0.025)  c_median
  ,      round(PERCENTILE_DISC(0.375) within group (order by fincp*adjinc/1000000) * 0.025)  c_max
  ,      round(median(fincp*adjinc/1000000) * 0.025)  b_median
  ,      round(PERCENTILE_DISC(0.75) within group (order by fincp*adjinc/1000000) * 0.025)  a_min
  ,      round(PERCENTILE_DISC(0.875) within group (order by fincp*adjinc/1000000) * 0.025)  a_median
  ,      round(PERCENTILE_DISC(0.9) within group (order by fincp*adjinc/1000000) * 0.025)  a_max
from asc_pums_housing h
,    asc_zipuma z
where z.puma2k = h.puma
and zipcode = 32796
and grntp is not null
and fincp > 0;

Renter Income
select zipcode
  ,      round(PERCENTILE_DISC(0.25) within group (order by fincp*adjinc/1000000) * 0.025) pct20
  ,      round(PERCENTILE_DISC(0.3) within group (order by fincp*adjinc/1000000) * 0.025) pct30
  ,      round(PERCENTILE_DISC(0.4) within group (order by fincp*adjinc/1000000) * 0.025) pct40
  ,      round(median(fincp*adjinc/1000000) * 0.025)  pct50
  ,      round(PERCENTILE_DISC(0.6) within group (order by fincp*adjinc/1000000) * 0.025)  pct60
  ,      round(PERCENTILE_DISC(0.7) within group (order by fincp*adjinc/1000000) * 0.025)  pct70
  ,      round(PERCENTILE_DISC(0.8) within group (order by fincp*adjinc/1000000) * 0.025)  pct80
  ,      round(PERCENTILE_DISC(0.9) within group (order by fincp*adjinc/1000000) * 0.025)  pct90
  ,      round(PERCENTILE_DISC(0.95) within group (order by fincp*adjinc/1000000) * 0.025)  pct95
from asc_pums_housing h
,    asc_zipuma z
where z.puma2k = h.puma
and zipcode in (32754, 32775, 32780, 32781, 32782, 32783, 32796, 32815, 32899, 32901,
                32902, 32903, 32904, 32905, 32906, 32907, 32908, 32909, 32910, 32911,
                32912, 32919, 32920, 32922, 32923, 32924, 32925, 32926, 32927, 32931,
                32932, 32934, 32935, 32936, 32937, 32940, 32941, 32949, 32950, 32951,
                32952, 32953, 32954, 32955, 32956, 32959, 32976 )
and grntp is not null
and fincp > 0
group by zipcode
order by zipcode;


Target House Price
select zipcode
  ,      round(PERCENTILE_DISC(0.25) within group (order by fincp*adjinc/1000000) * 2.7) pct20
  ,      round(PERCENTILE_DISC(0.3) within group (order by fincp*adjinc/1000000) * 2.7) pct30
  ,      round(PERCENTILE_DISC(0.4) within group (order by fincp*adjinc/1000000) * 2.7) pct40
  ,      round(median(fincp*adjinc/1000000) * 2.7)  pct50
  ,      round(PERCENTILE_DISC(0.6) within group (order by fincp*adjinc/1000000) * 2.7)  pct60
  ,      round(PERCENTILE_DISC(0.7) within group (order by fincp*adjinc/1000000) * 2.7)  pct70
  ,      round(PERCENTILE_DISC(0.8) within group (order by fincp*adjinc/1000000) * 2.7)  pct80
  ,      round(PERCENTILE_DISC(0.9) within group (order by fincp*adjinc/1000000) * 2.7)  pct90
  ,      round(PERCENTILE_DISC(0.95) within group (order by fincp*adjinc/1000000) * 2.7)  pct95
from asc_pums_housing h
,    asc_zipuma z
where z.puma2k = h.puma
and zipcode in (32754, 32775, 32780, 32781, 32782, 32783, 32796, 32815, 32899, 32901,
                32902, 32903, 32904, 32905, 32906, 32907, 32908, 32909, 32910, 32911,
                32912, 32919, 32920, 32922, 32923, 32924, 32925, 32926, 32927, 32931,
                32932, 32934, 32935, 32936, 32937, 32940, 32941, 32949, 32950, 32951,
                32952, 32953, 32954, 32955, 32956, 32959, 32976 )
and fincp > 0
group by zipcode
order by zipcode;



select zipcode
  ,      round(PERCENTILE_DISC(0.25) within group (order by tax_value)) pct20
  ,      round(PERCENTILE_DISC(0.3) within group (order by tax_value)) pct30
  ,      round(PERCENTILE_DISC(0.4) within group (order by tax_value)) pct40
  ,      round(median(tax_value))  pct50
  ,      round(PERCENTILE_DISC(0.6) within group (order by tax_value))  pct60
  ,      round(PERCENTILE_DISC(0.7) within group (order by tax_value))  pct70
  ,      round(PERCENTILE_DISC(0.8) within group (order by tax_value))  pct80
  ,      round(PERCENTILE_DISC(0.9) within group (order by tax_value))  pct90
  ,      round(PERCENTILE_DISC(0.95) within group (order by tax_value))  pct95
from pr_properties p
,    pr_taxes t
,    pr_property_usage pu
where p.prop_id = pu.prop_id
and pu.ucode in (110, 90001)
and p.prop_id = t.prop_id
and t.tax_year = 2011
and p.zipcode in
               ('32754', '32775', '32780', '32781', '32782', '32783', '32796', '32815', '32899', '32901',
                '32902', '32903', '32904', '32905', '32906', '32907', '32908', '32909', '32910', '32911',
                '32912', '32919', '32920', '32922', '32923', '32924', '32925', '32926', '32927', '32931',
                '32932', '32934', '32935', '32936', '32937', '32940', '32941', '32949', '32950', '32951',
                '32952', '32953', '32954', '32955', '32956', '32959', '32976' )
group by zipcode
order by zipcode;


   ZIPCODE      PCT20      PCT30      PCT40      PCT50      PCT60      PCT70      PCT80      PCT90      PCT95
---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
     32754        509        580        748        917       1153       1379       1703       2170       2927
     32780        572        662        865       1072       1298       1517       1854       2647       3324
     32796        510        590        772        965       1205       1441       1741       2447       3207
     32901        590        647        768        960       1159       1351       1671       2096       2469
     32903        684        780        984       1176       1414       1675       2032       2930       3721
     32904        590        647        768        960       1159       1351       1671       2096       2469
     32905        597        633        755        942       1100       1302       1543       1837       2306
     32907        597        633        755        942       1100       1302       1543       1837       2306
     32908        590        647        768        960       1159       1351       1671       2096       2469
     32909        590        647        768        960       1159       1351       1671       2096       2469
     32920        684        780        984       1176       1414       1675       2032       2930       3721
     32922        510        590        772        965       1205       1441       1741       2447       3207
     32925        684        780        984       1176       1414       1675       2032       2930       3721
     32926        510        590        772        965       1205       1441       1741       2447       3207
     32927        510        590        772        965       1205       1441       1741       2447       3207
     32931        684        780        984       1176       1414       1675       2032       2930       3721
     32934        576        655        786       1006       1230       1515       1881       2247       2589
     32935        576        655        786       1006       1230       1515       1881       2247       2589
     32937        684        780        984       1176       1414       1675       2032       2930       3721
     32940        537        619        778        977       1222       1478       1782       2279       3032
     32949        624        684        866       1056       1227       1474       1755       2367       3138
     32950        597        633        755        942       1100       1302       1543       1837       2306
     32951        684        780        984       1176       1414       1675       2032       2930       3721
     32952        684        780        984       1176       1414       1675       2032       2930       3721
     32953        684        780        984       1176       1414       1675       2032       2930       3721
     32955        537        619        778        977       1222       1478       1782       2279       3032
     32976        597        633        755        942       1100       1302       1543       1837       2306

27 rows selected.

2010 values

ZIPCODE      PCT20      PCT30      PCT40      PCT50      PCT60      PCT70      PCT80      PCT90      PCT95
------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
32754        57250      64880      81500     101355     125280     146000     174380     215580     246820
32780        58290      62000      70710      81090      95000     110560     132100     161750     194490
32796        55750      58510      65060      71745      81230      93180     107360     131670     174250
32901        51470      55880      67630      79460      89430      97720     109700     128960     153010
32903       119510     127230     146410     164960     189840     223130     265820     345460     447470
32904        83270      94660     112200     121950     133650     144770     162570     194420     222380
32905        50260      52970      57720      62590      69640      82430      96380     116240     136090
32907        68470      71560      76920      82205      87920      94880     103230     116950     131790
32908        66060      70950      78660      88110      94750      99490     107060     124770     145980
32909        65690      71160      77750      84840      92630      99840     111050     140340     187650
32920        85390      89660     100370     106570     112420     122620     138510     164110     215230
32922        43960      46050      49570      53050      56580      61680      70330      90540     121800
32926        62950      67790      79250      93360     107560     121420     138280     168020     200350
32927        71990      75030      80680      86230      92180      99580     110910     129300     148680
32931       128970     135490     149170     167650     188990     220650     265040     318750     410270
32934       115820     120380     133360     151425     170340     189620     219870     271070     326490
32935        58260      61280      68020      75590      84640      94780     107780     127480     147360
32937        98700     104510     114790     125455     136980     153450     192880     281300     386410
32940       113880     120420     132060     144820     159730     176270     203830     253480     323870
32949       126730     136450     158290     179885     200850     220590     241180     277140     325320
32950       121150     127350     139420     152305     165800     184570     213310     255660     302430
32951       141360     152400     172680     191625     220260     253320     315130     436270     596680
32952        85780      93730     116080     138935     163250     189930     227540     326990     446110
32953        82880      90290     108370     131310     149790     170980     195910     240090     302730
32955        83100      89810     104560     121145     135080     150870     184110     235600     284970
32976        72290      79210      96650     109630     123410     147060     179740     265760     382900

26 rows selected.


House price targets

  ZIPCODE       PCT20      PCT30      PCT40      PCT50      PCT60      PCT70      PCT80      PCT90      PCT95
---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
     32754     102143     115624     142049     168384     199492     235257     283447     365988     459562
     32780     111885     124815     153957     184942     222412     269951     329634     445377     571027
     32796     105419     119412     146773     172336     207674     246963     300004     382011     481391
     32901      97101     107485     131964     161134     191852     232931     282054     371677     465307
     32903     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32904      97101     107485     131964     161134     191852     232931     282054     371677     465307
     32905      86168      98272     119117     141885     171201     203444     247158     328910     402229
     32907      86168      98272     119117     141885     171201     203444     247158     328910     402229
     32908      97101     107485     131964     161134     191852     232931     282054     371677     465307
     32909      97101     107485     131964     161134     191852     232931     282054     371677     465307
     32920     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32922     105419     119412     146773     172336     207674     246963     300004     382011     481391
     32925     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32926     105419     119412     146773     172336     207674     246963     300004     382011     481391
     32927     105419     119412     146773     172336     207674     246963     300004     382011     481391
     32931     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32934     107527     119117     149009     181013     217190     261744     316256     407040     528881
     32935     107527     119117     149009     181013     217190     261744     316256     407040     528881
     32937     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32940     106643     119129     147617     177416     211433     252576     307332     391629     497612
     32949     101391     115468     140856     172040     205918     254670     319085     438882     574741
     32950      86168      98272     119117     141885     171201     203444     247158     328910     402229
     32951     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32952     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32953     119117     134163     166764     201058     252015     302966     382942     521806     756041
     32955     106643     119129     147617     177416     211433     252576     307332     391629     497612
     32976      86168      98272     119117     141885     171201     203444     247158     328910     402229

select p.prop_id
    ,      tax_value
    ,      round (PERCENT_RANK () over (order by tax_value) *100) pct_val
    from pr_properties p
    ,    pr_taxes t
    ,    pr_property_usage pu
    ,    pr_property_owners o
    ,    pr_properties op
    where p.puma=2102
    and t.prop_id = p.prop_id
    and p.prop_id = pu.prop_id
    and pu.ucode in (110, 113, 121, 135, 212, 213, 214, 414, 90001, 90002, 90004)
    and o.prop_id = p.prop_id
    and o.mailing_id != o.prop_id
    and o.mailing_id = op.prop_id
    and utl_match.jaro_winkler_similarity(p.address1, op.address1) < 85
    order by tax_value;


select median(trunc(fincp*adjinc/1000000))
from asc_pums_housing 
where  grntp is not null
and puma = 2102;

select trunc(fincp*adjinc/1000000)
from asc_pums_housing
where  grntp is not null
and puma = 2102;


select trunc(fincp*adjinc/1000000) income
,      round (PERCENT_RANK () over (order by trunc(fincp*adjinc/1000000)) *100) pct_val
from asc_pums_housing
where grntp is not null
and fincp is not null
and puma = 2102
order by 1;



select v.percentile, v.value_amount, v2.value_amount
from pr_pums_values v
,    pr_pums_values v2
where v.puma = 2102
and v.puma = v2.puma
and v.value_type = 'RENT-VALUE'
and v2.value_type = 'TAX-VALUE'
and v.percentile = v2.percentile
order by v.percentile;
 