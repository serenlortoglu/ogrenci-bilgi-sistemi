BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'student_api_health',
    p_pattern     => '.'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'student_api_health',
    p_pattern     => '.',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_query_one_row,
    p_source      => 'select ''ok'' as status, ''student_api'' as schema_alias from dual'
  );
END;
/