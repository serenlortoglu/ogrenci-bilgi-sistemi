BEGIN
  ORDS.DEFINE_MODULE(
    p_module_name    => 'student_api_health',
    p_base_path      => 'health/',
    p_items_per_page => 0,
    p_status         => 'PUBLISHED'
  );
END;
/