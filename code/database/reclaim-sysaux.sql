column segment heading 'Segment Name' format a32
column file_name heading 'File Name' format a40
column segment_type heading 'Segment Type' format a20
select
                file_name,
                segment_type,
                owner||'.'||segment_name segment,
                block_id,
                blockIdMB
        from
        (
         select
              ex.owner owner,
              ex.segment_name segment_name,
              ex.segment_type segment_type,
              ex.block_id block_id,
              df.file_name file_name,
              trunc((ex.block_id*(ts.block_size))/1024/1024,2) blockIdMB
      from
              dba_extents ex, dba_data_files df, dba_tablespaces ts
              where df.file_id = &file_id
              and df.file_id = ex.file_id
              and df.tablespace_name = ts.tablespace_name
              order by ex.block_id desc
      )
      where rownum <= 100
/


ALTER INDEX I_SCHEDULER_JOB_RUN_DETAILS REBUILD COMPUTE STATISTICS;
ALTER INDEX SCHEDULER$_INSTANCE_PK REBUILD COMPUTE STATISTICS;

>>>>>>
SELECT 'alter index WRH$_SEG_STAT_PK REBUILD PARTITION '||PARTITION_NAME ||' COMPUTE STATISTICS;'
FROM dba_ind_partitions  where INDEX_NAME='WRH$_SEG_STAT_PK';

alter index WRH$_SEG_STAT_PK REBUILD PARTITION WRH$_SEG_STAT_MXDB_MXSN  COMPUTE STATISTICS;
alter index WRH$_SEG_STAT_PK REBUILD PARTITION  WRH$_SEG_ST_1425995271_0 COMPUTE STATISTICS;
alter index WRH$_SEG_STAT_PK REBUILD PARTITION  WRH$_SEG_ST_1508179497_0 COMPUTE STATISTICS;

>>>>>>
SELECT 'alter index WRH$_FILESTATXS_PK REBUILD PARTITION '||PARTITION_NAME ||' COMPUTE STATISTICS;'
FROM dba_ind_partitions  where INDEX_NAME='WRH$_FILESTATXS_PK';

alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILESTATXS_MXDB_MXSN  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1425995271_17553  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1425995271_17574  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1425995271_17598  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION  WRH$_FILEST_1425995271_17622 COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION  WRH$_FILEST_1425995271_17646 COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1425995271_17670  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION  WRH$_FILEST_1425995271_17694 COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1425995271_17718  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1425995271_17742  COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION  WRH$_FILEST_1425995271_17766 COMPUTE STATISTICS;
alter index WRH$_FILESTATXS_PK REBUILD PARTITION WRH$_FILEST_1508179497_0  COMPUTE STATISTICS;

>>>>>>
SELECT 'alter index SYS.WRH$_SQLSTAT_PK REBUILD PARTITION '||PARTITION_NAME ||' COMPUTE STATISTICS;'
FROM dba_ind_partitions  where INDEX_NAME='WRH$_SQLSTAT_PK';

CREATE TABLESPACE sysaux_temp DATAFILE '/home/oradata/vis14/sysauxtmp.dbf' SIZE 1M AUTOEXTEND ON NEXT 1M;

SELECT DISTINCT 'ALTER USER '||owner||' QUOTA UNLIMITED ON sysaux_temp;'
FROM dba_tables WHERE tablespace_name='SYSAUX';



>>>>>>
SELECT 'alter table WRH$_FILESTATXS move partition '||partition_name||' tablespace sysaux_temp;'
FROM user_tab_partitions WHERE table_name = 'WRH$_FILESTATXS';

alter table WRH$_FILESTATXS move partition WRH$_FILESTATXS_MXDB_MXSN tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17553 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17574 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17598 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17622 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17646 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17670 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17694 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17718 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17742 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17766 tablespace sysaux_temp;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1508179497_0 tablespace sysaux_temp;

>>>>>>
SELECT 'alter table WRH$_SEG_STAT move partition '||partition_name||' tablespace sysaux_temp;'
FROM user_tab_partitions WHERE table_name = 'WRH$_SEG_STAT';

alter table WRH$_SEG_STAT move partition WRH$_SEG_STAT_MXDB_MXSN tablespace sysaux_temp;
alter table WRH$_SEG_STAT move partition WRH$_SEG_ST_1425995271_0 tablespace sysaux_temp;
alter table WRH$_SEG_STAT move partition WRH$_SEG_ST_1508179497_0 tablespace sysaux_temp;

>>>>>>
alter TABLE  SYS.WRH$_SYSMETRIC_SUMMARY MOVE TABLESPACE sysaux_temp;
alter TABLE  SYS.SCHEDULER$_EVENT_LOG MOVE TABLESPACE sysaux_temp;
alter TABLE  PERFSTAT.STATS$SNAPSHOT MOVE TABLESPACE sysaux_temp;
alter TABLE  SYS.SCHEDULER$_JOB_RUN_DETAILS MOVE TABLESPACE sysaux_temp;

alter database datafile '/ssd2/oradata/vis14/sysaux01.dbf' resize 2G;


alter TABLE  SYS.WRH$_SYSMETRIC_SUMMARY MOVE TABLESPACE sysaux;
alter TABLE  SYS.SCHEDULER$_EVENT_LOG MOVE TABLESPACE sysaux;
alter TABLE  PERFSTAT.STATS$SNAPSHOT MOVE TABLESPACE sysaux;
alter TABLE  SYS.SCHEDULER$_JOB_RUN_DETAILS MOVE TABLESPACE sysaux;





alter table WRH$_SEG_STAT move partition WRH$_SEG_STAT_MXDB_MXSN tablespace sysaux;
alter table WRH$_SEG_STAT move partition WRH$_SEG_ST_1425995271_0 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILESTATXS_MXDB_MXSN tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17553 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17574 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17598 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17622 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17646 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17670 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17694 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17718 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17742 tablespace sysaux;



alter table WRH$_SEG_STAT move partition WRH$_SEG_STAT_MXDB_MXSN tablespace sysaux;
alter table WRH$_SEG_STAT move partition WRH$_SEG_ST_1425995271_0 tablespace sysaux;
alter table WRH$_SEG_STAT move partition WRH$_SEG_ST_1508179497_0 tablespace sysaux;

alter table WRH$_FILESTATXS move partition WRH$_FILESTATXS_MXDB_MXSN tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17553 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17574 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17598 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17622 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17646 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17670 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17694 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17718 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17742 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1425995271_17766 tablespace sysaux;
alter table WRH$_FILESTATXS move partition WRH$_FILEST_1508179497_0 tablespace sysaux;

drop tablespace sysaux_temp;

EXEC DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'WRH$_FILESTATXS')
EXEC DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'WRH$_SEG_STAT')
EXEC DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'WRH$_SYSMETRIC_SUMMARY')
EXEC DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'SCHEDULER$_EVENT_LOG')
EXEC DBMS_STATS.GATHER_TABLE_STATS ('PERFSTAT', 'STATS$SNAPSHOT')
EXEC DBMS_STATS.GATHER_TABLE_STATS ('SYS', 'SCHEDULER$_JOB_RUN_DETAILS')





