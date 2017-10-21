declare
  cursor cur_corps is
  select    COR_NUMBER
  ,         COR_NAME
  ,         COR_STATUS
  ,         COR_FILING_TYPE
  ,         COR_PRINC_ADD_1
  ,         COR_PRINC_ADD_2
  ,         COR_PRINC_CITY
  ,         COR_PRINC_STATE
  ,         substr(BCOR_PRINC_ZIP, 1, 5) BCOR_PRINC_ZIP5
  ,         substr(BCOR_PRINC_ZIP, 7, 10) BCOR_PRINC_ZIP4
  ,         COR_PRINC_COUNTRY
  ,         COR_MAIL_ADD_1
  ,         COR_MAIL_ADD_2
  ,         COR_MAIL_CITY
  ,         COR_MAIL_STATE
  ,         substr(COR_MAIL_ZIP, 1, 5) COR_MAIL_ZIP5
  ,         substr(COR_MAIL_ZIP, 7, 10) COR_MAIL_ZIP4  
  ,         COR_MAIL_COUNTRY
  ,         COR_FILE_DATE
  ,         COR_FEI_NUMBER
  ,         MORE_THAN_SIX_OFF_FLAG
  ,         LAST_TRX_DATE
  ,         STATE_COUNTRY
  ,         REPORT_YEAR_1
  ,         HOUSE_FLAG_1
  ,         REPORT_DATE_1
  ,         REPORT_YEAR_2
  ,         HOUSE_FLAG_2
  ,         REPORT_DATE_2
  ,         REPORT_YEAR_3
  ,         HOUSE_FLAG_3
  ,         REPORT_DATE_3
  ,         RA_NAME
  ,         RA_NAME_TYPE
  ,         RA_ADD_1
  ,         RA_CITY
  ,         RA_STATE
  ,         RA_ZIP5
  ,         RA_ZIP4
  ,         PRINC1_TITLE
  ,         PRINC1_NAME_TYPE
  ,         PRINC1_NAME
  ,         PRINC1_ADD_1
  ,         PRINC1_CITY
  ,         PRINC1_STATE
  ,         PRINC1_ZIP5
  ,         PRINC1_ZIP4
  ,         PRINC2_TITLE
  ,         PRINC2_NAME_TYPE
  ,         PRINC2_NAME
  ,         PRINC2_ADD_1
  ,         PRINC2_CITY
  ,         PRINC2_STATE
  ,         PRINC2_ZIP5
  ,         PRINC2_ZIP4
  ,         PRINC3_TITLE
  ,         PRINC3_NAME_TYPE
  ,         PRINC3_NAME
  ,         PRINC3_ADD_1
  ,         PRINC3_CITY
  ,         PRINC3_STATE
  ,         PRINC3_ZIP5
  ,         PRINC3_ZIP4
  ,         PRINC4_TITLE
  ,         PRINC4_NAME_TYPE
  ,         PRINC4_NAME
  ,         PRINC4_ADD_1
  ,         PRINC4_CITY
  ,         PRINC4_STATE
  ,         PRINC4_ZIP5
  ,         PRINC4_ZIP4
  ,         PRINC5_TITLE
  ,         PRINC5_NAME_TYPE
  ,         PRINC5_NAME
  ,         PRINC5_ADD_1
  ,         PRINC5_CITY
  ,         PRINC5_STATE
  ,         PRINC5_ZIP5
  ,         PRINC5_ZIP4
  ,         PRINC6_TITLE
  ,         PRINC6_NAME_TYPE
  ,         PRINC6_NAME
  ,         PRINC6_ADD_1
  ,         PRINC6_CITY
  ,         PRINC6_STATE
  ,         PRINC6_ZIP5
  ,         PRINC6_ZIP4 
  from sunbiz s
  , pr_corporations c
  where s.cor_number = c.corp_number;
  
  c_number      varchar2(20);
  v_pnid        number;
  v_locid       number;
  
begin
  for c_rec in cur_corps loop
    pr_locations_pkg.insert_corp_location
                     ( X_ADDRESS1 => c_rec.COR_PRINC_ADD_1
                     , X_ADDRESS2 => c_rec.COR_PRINC_ADD_2
                     , X_CITY     => c_rec.COR_PRINC_CITY
                     , X_STATE    => c_rec.COR_PRINC_STATE
                     , X_ZIP5     => c_rec.BCOR_PRINC_ZIP5
                     , X_ZIP4     => c_rec.BCOR_PRINC_ZIP4
                     , X_COUNTRY  => c_rec.COR_PRINC_COUNTRY
	                 , X_CORP_NUMBER => c_rec.COR_NUMBER
		             , X_LOC_TYPE => 'PRIN'  );
					 
     commit;
  pr_locations_pkg.insert_corp_location
                     ( X_ADDRESS1 => c_rec.COR_MAIL_ADD_1
                     , X_ADDRESS2 => c_rec.COR_MAIL_ADD_2
                     , X_CITY     => c_rec.COR_MAIL_CITY
                     , X_STATE    => c_rec.COR_MAIL_STATE
                     , X_ZIP5     => c_rec.COR_MAIL_ZIP5
                     , X_ZIP4     => c_rec.COR_MAIL_ZIP4
                     , X_COUNTRY  => c_rec.COR_MAIL_COUNTRY
	                 , X_CORP_NUMBER => c_rec.COR_NUMBER
		             , X_LOC_TYPE => 'MAIL'  );					 
 
     commit;
  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.RA_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.RA_CITY
                     , X_STATE    => c_rec.RA_STATE
                     , X_ZIP5     => c_rec.RA_ZIP5
                     , X_ZIP4     => c_rec.RA_ZIP4
                     , X_COUNTRY  => 'US'
		             , X_PN_TYPE  => c_rec.RA_NAME_TYPE
                     , X_PN_NAME  => c_rec.RA_NAME
		             , X_CORP_NUMBER => c_rec.COR_NUMBER
		             , X_TITLE_CODE => 'R' ); 
 
     commit;
  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.PRINC1_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.PRINC1_CITY
                     , X_STATE    => c_rec.PRINC1_STATE
                     , X_ZIP5     => c_rec.PRINC1_ZIP5
                     , X_ZIP4     => c_rec.PRINC1_ZIP4
                     , X_COUNTRY  => 'US'
                     , X_PN_TYPE  => c_rec.PRINC1_NAME_TYPE
                     , X_PN_NAME  => c_rec.PRINC1_NAME
                     , X_CORP_NUMBER => c_rec.COR_NUMBER
                     , X_TITLE_CODE => c_rec.PRINC1_TITLE ); 
     commit;

  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.PRINC2_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.PRINC2_CITY
                     , X_STATE    => c_rec.PRINC2_STATE
                     , X_ZIP5     => c_rec.PRINC2_ZIP5
                     , X_ZIP4     => c_rec.PRINC2_ZIP4
                     , X_COUNTRY  => 'US'
                     , X_PN_TYPE  => c_rec.PRINC2_NAME_TYPE
                     , X_PN_NAME  => c_rec.PRINC2_NAME
                     , X_CORP_NUMBER => c_rec.COR_NUMBER
                     , X_TITLE_CODE => c_rec.PRINC2_TITLE ); 
     commit;
  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.PRINC3_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.PRINC3_CITY
                     , X_STATE    => c_rec.PRINC3_STATE
                     , X_ZIP5     => c_rec.PRINC3_ZIP5
                     , X_ZIP4     => c_rec.PRINC3_ZIP4
                     , X_COUNTRY  => 'US'
                     , X_PN_TYPE  => c_rec.PRINC3_NAME_TYPE
                     , X_PN_NAME  => c_rec.PRINC3_NAME
                     , X_CORP_NUMBER => c_rec.COR_NUMBER
                     , X_TITLE_CODE => c_rec.PRINC3_TITLE ); 
      commit;
  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.PRINC4_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.PRINC4_CITY
                     , X_STATE    => c_rec.PRINC4_STATE
                     , X_ZIP5     => c_rec.PRINC4_ZIP5
                     , X_ZIP4     => c_rec.PRINC4_ZIP4
                     , X_COUNTRY  => 'US'
                     , X_PN_TYPE  => c_rec.PRINC4_NAME_TYPE
                     , X_PN_NAME  => c_rec.PRINC4_NAME
                     , X_CORP_NUMBER => c_rec.COR_NUMBER
                     , X_TITLE_CODE => c_rec.PRINC4_TITLE );
     commit;
  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.PRINC5_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.PRINC5_CITY
                     , X_STATE    => c_rec.PRINC5_STATE
                     , X_ZIP5     => c_rec.PRINC5_ZIP5
                     , X_ZIP4     => c_rec.PRINC5_ZIP4
                     , X_COUNTRY  => 'US'
                     , X_PN_TYPE  => c_rec.PRINC5_NAME_TYPE
                     , X_PN_NAME  => c_rec.PRINC5_NAME
                     , X_CORP_NUMBER => c_rec.COR_NUMBER
                     , X_TITLE_CODE => c_rec.PRINC5_TITLE );
     commit;
  pr_locations_pkg.insert_principal_location
                     ( X_ADDRESS1 => c_rec.PRINC6_ADD_1
                     , X_ADDRESS2 => ''
                     , X_CITY     => c_rec.PRINC6_CITY
                     , X_STATE    => c_rec.PRINC6_STATE
                     , X_ZIP5     => c_rec.PRINC6_ZIP5
                     , X_ZIP4     => c_rec.PRINC6_ZIP4
                     , X_COUNTRY  => 'US'
                     , X_PN_TYPE  => c_rec.PRINC6_NAME_TYPE
                     , X_PN_NAME  => c_rec.PRINC6_NAME
                     , X_CORP_NUMBER => c_rec.COR_NUMBER
                     , X_TITLE_CODE => c_rec.PRINC6_TITLE );
     commit; 
   end loop;
end;
/ 

