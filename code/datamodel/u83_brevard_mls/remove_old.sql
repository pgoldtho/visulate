exec pr_rets_pkg.set_inactive(6)

update rnt_menu_pages
set sub_page='Osceola'
where sub_page='Space Coast'
and page_name='homePage'
and menu_name='items'
and tab_name='find'; 

alter session set nls_date_format='dd-mon-yyyy';

