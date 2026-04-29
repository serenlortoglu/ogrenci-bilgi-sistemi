BEGIN
  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'student_api_auth',
    p_pattern     => 'login'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name   => 'student_api_auth',
    p_pattern       => 'login',
    p_method        => 'POST',
    p_mimes_allowed => 'application/json',
    p_source_type   => ORDS.source_type_plsql,
    p_source        => q'[
      declare
        l_user_id users.id%type;
        l_role users.role%type;
        l_username users.username%type;
        l_message varchar2(4000);

        function escape_json(p_text in varchar2) return varchar2 is
        begin
          return replace(replace(nvl(p_text, ''), '\', '\\'), '"', '\"');
        end;

        procedure write_json_response(p_payload in varchar2) is
        begin
          owa_util.mime_header('application/json', false);
          htp.p('Cache-Control: no-store');
          owa_util.http_header_close;
          htp.prn(p_payload);
        end;
      begin
        l_username := trim(:username);

        login_user_proc(
          p_username => l_username,
          p_password => :password,
          p_user_id  => l_user_id,
          p_role     => l_role
        );

        :status_code := 200;
        write_json_response(
          '{"authenticated":true,"user_id":' || l_user_id ||
          ',"username":"' || escape_json(l_username) ||
          '","role":"' || escape_json(l_role) ||
          '","message":"Giris basarili"}'
        );
      exception
        when others then
          l_message := sqlerrm;
          :status_code := case
            when sqlcode = -20002 then 401
            else 400
          end;
          write_json_response(
            '{"authenticated":false,"error_code":' || abs(sqlcode) ||
            ',"message":"' || escape_json(l_message) || '"}'
          );
      end;
    ]'
  );

  ORDS.DEFINE_PARAMETER(
    p_module_name        => 'student_api_auth',
    p_pattern            => 'login',
    p_method             => 'POST',
    p_name               => 'X-APEX-STATUS-CODE',
    p_bind_variable_name => 'status_code',
    p_source_type        => 'HEADER',
    p_access_method      => 'OUT'
  );
END;
/