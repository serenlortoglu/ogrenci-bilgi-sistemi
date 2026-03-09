                                                                TEKNİK TASARIM DÖKÜMANI 
1. Sistem Mimarisi
 Öğrenci Bilgi Sistemi, veritabanı merkezli bir mimari üzerine kurulacaktır. Sistemin temelini Oracle veritabanı oluşturur. Tüm akademik veriler merkezi veritabanında saklanır ve işlemler doğrudan veritabanı üzerinden yürütülür.
Sistem üç ana katmandan oluşur:
* Veritabanı Katmanı: Verilerin saklandığı ve yönetildiği katmandır.

* İş Mantığı Katmanı: Akademik işlemlerin kurallarını yöneten PL/SQL prosedürleri ve fonksiyonlarından oluşur.

* Servis Katmanı: ORDS aracılığıyla veritabanı işlemlerinin web servislerine dönüştürülmesini sağlar.

Bu yapı sayesinde sistem güvenli, ölçeklenebilir ve yönetilebilir bir mimariye sahip olur.

2. Veritabanı Tasarımı

Sistemde öğrenci, öğretmen, ders ve akademik süreçleri temsil eden ilişkisel tablolar yer alacaktır. Tablolar arasında birincil anahtar ve yabancı anahtar ilişkileri kurularak veri bütünlüğü sağlanacaktır.

Temel tablolar şunlardır:

* Öğrenciler tablosu

* Öğretmenler tablosu

* Dersler tablosu

* Notlar tablosu

* Devamsızlık tablosu

* Kullanıcılar ve roller tablosu

Bu yapı sayesinde akademik veriler düzenli ve ilişkisel bir biçimde saklanır.


3. İş Mantığının PL/SQL ile Geliştirilmesi

Sistemin iş kuralları PL/SQL kullanılarak veritabanı seviyesinde geliştirilmiştir.
* Öğrenci kayıt işlemleri
* Ders atamaları 
* Not hesaplamaları
* Devamsızlık takibi  
* Yetkilendirme kontrolleri 
PL/SQL prosedür ve fonksiyonları ile yönetilmektedir. Bu yapı sistem güvenliği ve işlem performansını artırmaktadır.

4. ORDS ile Web Servislerinin Oluşturulması

Oracle REST Data Services (ORDS), veritabanı işlemlerini RESTful web servislerine dönüştürmek için kullanılacaktır.

ORDS sayesinde:

* PL/SQL prosedürleri HTTP istekleri ile çalıştırılabilir

* JSON formatında veri alışverişi yapılabilir

* Web ve mobil uygulamalar sisteme bağlanabilir

* Güvenli API altyapısı oluşturulur.

Örneğin:

* Öğrenci listeleme servisi

* Not giriş servisi

* Devamsızlık sorgulama servisi

* Ders kayıt servisi

Bu servisler sayesinde sistem dış uygulamalarla entegre çalışabilir.

5. Güvenlik ve Yetkilendirme

* Sistem güvenliği veritabanı ve servis katmanında sağlanacaktır.

* Kullanıcı kimlik doğrulama işlemleri veritabanı üzerinden yürütülür

* Rol bazlı yetkilendirme uygulanır

* Her kullanıcı yalnızca kendi yetkisine uygun işlemleri gerçekleştirebilir

* ORDS üzerinden yapılan servis çağrıları güvenlik filtrelerinden geçirilir

Bu yapı sayesinde veri gizliliği ve sistem bütünlüğü korunur.

6. Sistem İşleyiş Akışı

* Kullanıcı sisteme giriş yapar.

* Yetkileri doğrulanır.

* İlgili PL/SQL prosedürleri çalıştırılır.

* ORDS aracılığıyla sonuçlar istemciye iletilir.

* İşlem sonuçları veritabanında saklanır.

Bu süreç tüm akademik işlemler için standart bir işlem akışı sağlar.

7. Performans ve Ölçeklenebilirlik

PL/SQL prosedürlerinin veritabanı üzerinde çalışması sayesinde sistem yüksek performansla işlem yapabilir. ORDS servis yapısı ise aynı anda çok sayıda kullanıcıya hizmet verebilecek ölçeklenebilir bir altyapı sunar.

8. Sonuç

Bu teknik yapı sayesinde Öğrenci Bilgi Sistemi:

* Güvenli

* Merkezi yönetilebilir

* Yüksek performanslı

* Web uyumlu

* Genişletilebilir

bir yazılım çözümü olarak geliştirilecektir.
