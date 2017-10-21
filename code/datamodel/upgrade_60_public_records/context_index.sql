grant create trigger to rntmgr;

GRANT EXECUTE ON CTX_CLS    TO rntmgr;
GRANT EXECUTE ON CTX_DDL    TO rntmgr;
GRANT EXECUTE ON CTX_DOC    TO rntmgr;
GRANT EXECUTE ON CTX_OUTPUT TO rntmgr;
GRANT EXECUTE ON CTX_QUERY  TO rntmgr;
GRANT EXECUTE ON CTX_REPORT TO rntmgr;
GRANT EXECUTE ON CTX_THES   TO rntmgr;


alter table pr_properties modify city varchar2(30);

CREATE INDEX pr_owner_x1 ON pr_owners(owner_name) INDEXTYPE IS CTXSYS.CTXCAT

begin
  ctx_ddl.create_index_set('pr_city_iset');
  ctx_ddl.add_index('pr_city_iset','city'); 
end;
/


CREATE INDEX pr_properties_x1 ON pr_properties(address1) INDEXTYPE IS CTXSYS.CTXCAT
PARAMETERS ('index set pr_city_iset');



