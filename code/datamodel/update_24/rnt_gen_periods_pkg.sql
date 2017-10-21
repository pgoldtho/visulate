CREATE OR REPLACE package        RNT_GEN_PERIODS_PKG as

function gen_period_rows(start_date date, end_date date, x_period_type varchar2) return T2REC_DATE_TABLE;
end;
/

SHOW ERRORS;

CREATE OR REPLACE package body        RNT_GEN_PERIODS_PKG as
/*
 CREATE OR REPLACE TYPE T2REC_DATE AS OBJECT(START_DATE DATE, END_DATE DATE);
 CREATE OR REPLACE type T2REC_DATE_TABLE as table of T2REC_DATE
*/

/*
  function gen_rows(start_date date, end_date date, x_period_type varchar2) return date_range_tbl pipelined
  is
    cur_date date;
    next_date date;
    t t_rec; 
  begin

    cur_date := trunc(start_date);
    next_date := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_NEXT_PERIOD_DATE(cur_date, x_period_type); 
    while (cur_date <= trunc(end_date))
    loop
      t.from_date := cur_date;
      t.to_date := next_date-1; 
      pipe row(t);

      cur_date := next_date;
      next_date := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_NEXT_PERIOD_DATE(cur_date, x_period_type);
    end loop;
    return;

  end;
*/  
function gen_period_rows(start_date date, end_date date, x_period_type varchar2) return T2REC_DATE_TABLE
is
    cur_date date;
    next_date date;
    rec T2REC_DATE;
    ret T2REC_DATE_TABLE := T2REC_DATE_TABLE();
  begin

    cur_date := trunc(start_date);
    next_date := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_NEXT_PERIOD_DATE(cur_date, x_period_type); 
    while (cur_date <= trunc(end_date))
    loop
      rec := T2REC_DATE(START_DATE => cur_date,
                        END_DATE => next_date-1);
                        /* 
      rec.START_DATE := cur_date;
      rec.END_DATE := next_date-1;
      */
      ret.EXTEND();
      ret(ret.COUNT) := rec;

      cur_date := next_date;
      next_date := RNT_ACCOUNTS_RECEIVABLE_PKG.GET_NEXT_PERIOD_DATE(cur_date, x_period_type);
    end loop;
    return ret;
  end;
 
end;
/

SHOW ERRORS;
