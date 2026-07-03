--1: ME116: the measure with 090158 should be failed ---
Update m_quota_order_number set end_date=to_date('2026-05-29', 'yyyy-mm-dd') where sid=3767;
commit;

--2: After ME116 is failed: edit the measure's end date with 090158 from 2026-05-30 to 2026-05-29
-- the record should be passed
-- Set end date of origin CL of 091946. The measure with 091946 should be failed because of ME119
Update m_quota_order_number_origin set end_date=to_date('2026-05-29', 'yyyy-mm-dd') where sid=9185;
commit;

--3: Set origin of 091946 from CL to CN and the origin end date = null
-- ME117 should be failed but not: is it expected? --
Update m_quota_order_number_origin set geog_area_id='CN', sid_geog_area=439, end_date=null where sid=9185;
commit;


--4: Set the origin CN back to CL and end date = 2026-05-29
--  Add a new origin CN with start date = 2026-05-30. The measure should be failed because of ME119
Update m_quota_order_number_origin set geog_area_id='CL', sid_geog_area=205, end_date=to_date('2026-05-29', 'yyyy-mm-dd') where sid=9185;
Insert into m_quota_order_number_origin(SID, SID_QUOTA_ORDER_NUMBER, start_date, geog_area_id, sid_geog_area, X_national) values(9999, 4254, to_date('30-05-2026', 'dd-mm-yyyy'), 'CN', 439, 0);
commit;

--4: Update orgin CN to CL then origin CL will expand to null end date
-- ME119 should be ok now
Update m_quota_order_number_origin set geog_area_id='CL', sid_geog_area=205 where sid=9999;
commit;


-- Rollback 
Update M_measure set end_date=to_date('2026-05-30', 'yyyy-mm-dd') where sid=3819756;
Update m_quota_order_number set end_date=null where sid=3767;
Update m_quota_order_number_origin set end_date=null where sid=9185;
delete from m_quota_order_number_origin where sid=9999;

Delete from mx_entity_log_search_criteria where entity_logging_record_sid in (select sid from mx_entity_logging_record where file_id='TDK26113');
Delete from mx_entity_logging_record where file_id='TDK26113';
Delete from mx_data_input_files where file_id='TDK26113';

commit;
