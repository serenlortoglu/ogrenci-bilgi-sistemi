BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'student_api_auth',
    p_pattern     => 'users'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'student_api_auth',
    p_pattern     => 'users',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_query,
    p_source      => q'[
      select id, username, role
      from users
      order by id
    ]'
  );
END;
/