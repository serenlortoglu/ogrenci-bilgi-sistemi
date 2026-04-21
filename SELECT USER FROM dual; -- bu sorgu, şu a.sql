SELECT USER FROM dual; -- bu sorgu, şu anda oturum açmış olan kullanıcıyı gösterir.
-- "dual" tablosu, Oracle veritabanında tek bir satır ve tek bir sütun içeren özel bir tablodur ve genellikle tek bir değer döndürmek için kullanılır.

SELECT object_name, object_type
FROM user_objects
WHERE object_name LIKE 'ORDS%';

SELECT * FROM SYSTEM.STUDENTS;


GRANT SELECT, INSERT, UPDATE, DELETE ON STUDENTS TO STUDENT_API;-- Bu sorgu, STUDENTS tablosuna SELECT, INSERT, UPDATE ve DELETE izinlerini STUDENT_API adlı kullanıcıya verir.
GRANT SELECT, INSERT, UPDATE, DELETE ON TEACHERS TO STUDENT_API;
GRANT SELECT, INSERT, UPDATE, DELETE ON COURSES TO STUDENT_API;
GRANT SELECT, INSERT, UPDATE, DELETE ON GRADES TO STUDENT_API;
GRANT SELECT, INSERT, UPDATE, DELETE ON ATTENDANCE TO STUDENT_API;
GRANT SELECT, INSERT, UPDATE, DELETE ON USERS TO STUDENT_API;

SELECT * FROM SYSTEM.STUDENTS;


BEGIN
  ORDS.DEFINE_MODULE(
    p_module_name    => 'students',
    p_base_path      => '/students/',
    p_items_per_page => 25
  );

  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'students',
    p_pattern     => 'list'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'students',
    p_pattern     => 'list',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_query,
    p_source      => 'SELECT * FROM SYSTEM.STUDENTS'
  );

  COMMIT;
END;
/

GRANT EXECUTE ON ORDS_METADATA.ORDS TO STUDENT_API;

SELECT owner, object_name
FROM all_objects
WHERE object_name = 'ORDS';

GRANT EXECUTE ON ORDS_METADATA.ORDS TO STUDENT_API;

SELECT owner, object_name, object_type
FROM all_objects
WHERE object_name LIKE 'ORDS%';

GRANT EXECUTE ON ORDS TO STUDENT_API;


SELECT * FROM dual;