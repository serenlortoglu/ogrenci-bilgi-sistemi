BEGIN
  ORDS.DEFINE_MODULE(
    p_module_name    => 'student_api_auth',
    p_base_path      => 'auth/',
    p_items_per_page => 0,
    p_status         => 'PUBLISHED'
  );
END;
/