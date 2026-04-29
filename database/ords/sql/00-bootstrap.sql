DECLARE
  v_schema_enabled NUMBER := 0;
BEGIN
  SELECT COUNT(*)
  INTO v_schema_enabled
  FROM user_ords_schemas
  WHERE pattern = 'student_api'
    AND status = 'ENABLED';

  IF v_schema_enabled = 0 THEN
    ORDS.ENABLE_SCHEMA(
      p_enabled => TRUE,
      p_schema  => 'APP',
      p_url_mapping_type => 'BASE_PATH',
      p_url_mapping_pattern => 'student_api',
      p_auto_rest_auth => FALSE
    );
  END IF;

  BEGIN
    ORDS.DELETE_MODULE(p_module_name => 'student_api_health');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;

  BEGIN
    ORDS.DELETE_MODULE(p_module_name => 'student_api_auth');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
END;
/