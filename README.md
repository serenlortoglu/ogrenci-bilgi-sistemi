                                                          ÖĞRENCİ BİLGİ SİSTEMİ PROJESİ 
Proje Hakkında

Öğrenci Bilgi Sistemi, eğitim kurumlarında öğrenci, öğretmen ve idari personel arasındaki akademik süreçlerin düzenli ve güvenli şekilde yürütülmesini sağlamak amacıyla geliştirilmiştir. Sistem; öğrenci kayıtları, ders atamaları, not işlemleri ve devamsızlık takibi gibi süreçlerin merkezi bir yapı üzerinden yönetilmesini sağlar. Kullanıcılar yetkilerine göre sisteme erişebilir ve işlemlerini güvenli bir ortamda gerçekleştirebilir.

ORDS Testleri

Projede ORDS smoke testleri `scripts/test-ords.sh` ile çalıştırılır. Script veritabanı kurmaz veya seed etmez; sadece çalışmakta olan ORDS servisinin temel HTTP yüzeyini doğrular. Concrete schema endpoint kontrollerini varsayılan olarak `database/ords.sql` içindeki yayımlanmış `GET` rotalarından otomatik algılar ve ayrıca seed kullanıcı ile auth login akışını doğrular. Varsayılan olarak JSON istek gövdelerini ve auth/users ile auth/login çağrılarının JSON response bilgisini daha okunabilir olacak şekilde formatlayıp stdout'a yazar.

Yerel ortamda ORDS servisini başlatmak için:

```bash
docker compose up -d oracleservice ords
```

Varsayılan kontrol seti:

```text
- /ords
- /ords/_/db-api/stable/
- /ords/student_api/auth/users
- /ords/student_api/health
- /ords/student_api/health/live
- /ords/student_api/health/ready
- ve `database/ords.sql` içinden algılanan diğer yayımlanmış statik `GET` endpoint'leri
```

Projeye daha uygun auth endpoint örnekleri:

```text
POST /ords/student_api/auth/login
POST /ords/student_api/auth/register
GET  /ords/student_api/auth/users
```

Çalıştırmak için:

```bash
./scripts/test-ords.sh
```

Eğer ORDS container'ı henüz çalışmıyorsa script artık bunu açıkça söyler. Stack'i script içinden başlatmak için:

```bash
./scripts/test-ords.sh --start-stack
```

Farklı bir ORDS adresi veya alias ile çalıştırmak için:

```bash
ORDS_BASE_URL=http://localhost:8080/ords ORDS_SCHEMA_ALIAS=my_alias ORDS_SCHEMA_PATH=health ./scripts/test-ords.sh
```

Varsayılan login smoke check `student1 / 1234` seed kullanıcısını kullanır. Gerekirse override edebilirsiniz:

```bash
ORDS_AUTH_LOGIN_USERNAME=student1 ORDS_AUTH_LOGIN_PASSWORD=1234 ./scripts/test-ords.sh
```

JSON request body çıktısını kapatmak için:

```bash
ORDS_SHOW_REQUEST_BODY=0 ./scripts/test-ords.sh
```

JSON response body çıktısını kapatmak için:

```bash
ORDS_SHOW_RESPONSE_BODY=0 ./scripts/test-ords.sh
```

Algılamayı farklı bir SQL dosyasından yapmak için:

```bash
ORDS_ROUTE_SOURCE=./database/ords.sql ./scripts/test-ords.sh
```

Schema alias kontrolünü kapatmak için:

```bash
./scripts/test-ords.sh --no-schema-check
```

Login smoke check'i kapatmak için:

```bash
./scripts/test-ords.sh --no-auth-check
```

Swagger UI arayüzünü açmak için:

```bash
docker compose up -d swagger-ui
```

Ardından şu adresi açın:

```text
http://localhost:8081
```

Swagger UI, ORDS tarafından üretilen OpenAPI dokümanlarını şu katalogdan okur ve aynı origin üzerinden proxy ile yükler:

```text
http://localhost:8080/ords/student_api/open-api-catalog/
```

Endpoint algılama birim testlerini çalıştırmak için:

```bash
bash ./scripts/test-ords-unit.sh
```

Testler artık küçük ve ayrı dosyalara bölünmüştür:

```text
scripts/tests/ords/auth-users-endpoint-test.sh
scripts/tests/ords/health-endpoint-test.sh
scripts/tests/ords/health-live-endpoint-test.sh
scripts/tests/ords/health-ready-endpoint-test.sh
scripts/tests/ords/static-get-filter-test.sh
scripts/tests/ords/explicit-override-test.sh
```


 



