BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'student_api_health',
    p_pattern     => 'ready'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'student_api_health',
    p_pattern     => 'ready',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_query_one_row,
    p_source      => q'[select 'ready' as status, sys_context('USERENV', 'DB_NAME') as db_name from dual]'
  );
END;
/