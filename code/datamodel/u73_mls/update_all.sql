begin
  alter session set nls_date_format='dd-mon-yyyy';
  --mls_mfr_pkg.get_by_type('CommercialProperty', 'all');
  mls_mfr_pkg.get_by_type('ResidentialProperty', 'all');
  mls_mfr_pkg.get_by_type('IncomeProperty', 'all');
  mls_mfr_pkg.get_by_type('VacantLand', 'all');
  --mls_mfr_pkg.get_by_type('Rental', 'all');
  mls_mfr_pkg.update_price_ranges;
  pr_rets_pkg.set_inactive(7);
end;
/
