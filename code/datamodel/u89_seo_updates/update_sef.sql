alter session set nls_date_format='dd-mon-yyyy';
exec mls_sef_pkg.get_by_type('ResidentialProperty', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('ResidentialProperty', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('ResidentialProperty', 'PALMBCH', 'all')
exec mls_sef_pkg.get_by_type('Condos', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('Condos', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('Condos', 'PALMBCH', 'all')
exec mls_sef_pkg.get_by_type('IncomeProperty', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('IncomeProperty', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('IncomeProperty', 'PALMBCH', 'all')
exec mls_sef_pkg.get_by_type('ResidentialLand', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('ResidentialLand', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('ResidentialLand', 'PALMBCH', 'all')
exec mls_sef_pkg.get_by_type('CommercialLand', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('CommercialLand', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('CommercialLand', 'PALMBCH', 'all')
exec mls_sef_pkg.get_by_type('CommercialProperty', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('CommercialProperty', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('CommercialProperty', 'PALMBCH', 'all')
exec mls_sef_pkg.get_by_type('Business', 'BROWARD', 'all')
exec mls_sef_pkg.get_by_type('Business', 'DADE', 'all')
exec mls_sef_pkg.get_by_type('Business', 'PALMBCH', 'all')
exec mls_sef_pkg.update_mls
