begin
  --dbms_mview.refresh('PR_SALES_MV', 'C');
  --dbms_mview.refresh('PR_SALES_SUMMARY_MV', 'C');

  dbms_mview.refresh('PR_LAND_SUMMARY_MV', 'C');
  dbms_mview.refresh('PR_LAND_SALES_MV', 'C');
  dbms_mview.refresh('PR_COMMERCIAL_SUMMARY_MV', 'C');
  dbms_mview.refresh('PR_COMMERCIAL_SALES_MV', 'C');
  dbms_mview.refresh('PR_COUNTY_SUMMARY_MV', 'C');
end;
/