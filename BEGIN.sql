BEGIN
    -- 1. MODULE
    ORDS.DEFINE_MODULE(
        p_module_name    => 'auth',
        p_base_path      => '/auth/',
        p_items_per_page => 0
    );

    -- 2. TEMPLATE
    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'auth',
        p_pattern     => 'users'
    );

    -- 3. HANDLER
    ORDS.DEFINE_HANDLER(
        p_module_name => 'auth',
        p_pattern     => 'users',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_query,
        p_source      => '
            SELECT id, username, email, created_at
            FROM users
        '
    );

    COMMIT;
END;
/

BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema  => 'STUDENT_API',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'student-api',
        p_auto_rest_auth => FALSE
    );
END;
/

COMMIT;


BEGIN
  ORDS.DELETE_MODULE(p_module_name => 'auth');

  ORDS.DEFINE_SERVICE(
    p_module_name => 'auth',
    p_base_path   => '/auth/',
    p_pattern     => 'users',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_query,
    p_source      => 'select id, username, email, created_at from users'
  );

  COMMIT;
END;
/

SELECT * FROM users;

CREATE TABLE users (
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    username VARCHAR2(100),
    email VARCHAR2(100),
    password_hash VARCHAR2(200),
    created_at DATE DEFAULT SYSDATE
);

INSERT INTO users (username, email, password_hash)
VALUES ('test', 'test@mail.com', '123');

COMMIT;

BEGIN
  ORDS.DELETE_MODULE('auth');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_SERVICE(
    p_module_name => 'auth',
    p_base_path   => '/auth/',
    p_pattern     => 'users',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_query,
    p_source      => 'select id, username, email, created_at from users'
  );
  COMMIT;
END;
/