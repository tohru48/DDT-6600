# DDTank 6.5 - İstemci ve Sunucu Kaynak Kodları

Bu depo, popüler tank tabanlı çok oyunculu oyun olan DDTank'ın 6.5 sürümünün tam kaynak kodlarını içerir.

## İçerik

- **Flash_Project**: Oyunun istemci (client) tarafı kaynak kodları. ActionScript ile geliştirilmiş Flash tabanlı oyun arayüzü ve oyun mantığı.
- **Source**: Oyunun sunucu (server) tarafı kaynak kodları. C# ile yazılmış sunucu uygulaması, oyun mantığı ve veritabanı işlemleri.
- **Db**: Veritabanı dosyaları ve yapılandırma.
- **Request**: Oyun servisi ve istemci arasında API köprüsü görevi gören web servis dosyaları.
- **WebSimple**: Oyunun web sitesi dosyaları ve IIS dağıtım için gerekli dosyalar.

## Kullanılan Teknolojiler

- **Veritabanı**: SQL Server (SSMS 22.3 ile yönetilir)
- **Web Dağıtımı**: IIS (Internet Information Services)
- **Sunucu Emülatörü**: Source klasöründeki Service klasörlerinde bulunan debug exe dosyaları emülatör olarak kullanılır
- **İstemci**: Flash/ActionScript
- **Sunucu**: .NET/C#

## Kurulum ve Yapılandırma

### 1. Veritabanı Kurulumu
- SQL Server'ı yükleyin (SSMS 22.3 önerilir)
- Db klasöründeki veritabanı dosyalarını kullanarak veritabanınızı oluşturun

### 2. Yapılandırma Dosyaları
Aşağıdaki dosyaları kendi sistem ayarlarınıza göre düzenleyin:

#### app.config (Source klasöründe)
```xml
<connectionStrings>
  <add name="DefaultConnection" connectionString="Server=YOUR_SQL_SERVER;Database=YOUR_DB_NAME;User Id=YOUR_USERNAME;Password=YOUR_PASSWORD;" />
</connectionStrings>
```

#### battle.xml
Oyun savaş ayarlarını kendi ihtiyaçlarınıza göre yapılandırın.

#### web.config (WebSimple klasöründe)
```xml
<appSettings>
  <add key="SqlConnectionString" value="Server=YOUR_SQL_SERVER;Database=YOUR_DB_NAME;User Id=YOUR_USERNAME;Password=YOUR_PASSWORD;" />
</appSettings>
```

### 3. IP Adresi Ayarları
- **Localhost için**: Yapılandırma dosyalarındaki IP adreslerini `127.0.0.1` veya `localhost` olarak bırakın
- **Sunucu için**: Tüm yapılandırma dosyalarındaki IP adreslerini sunucunuzun IPv4 adresi ile değiştirin

### 4. IIS Yapılandırması
- WebSimple klasörünü IIS'e yayınlayın
- Uygulama havuzunu .NET Framework için yapılandırın
- Gerekli izinleri ayarlayın

### 5. Sunucu Başlatma
- Source klasöründeki Service exe dosyalarını çalıştırın
- Web servislerini başlatın
- İstemciyi Flash_Project üzerinden çalıştırın

## Önemli Notlar

- Tüm yapılandırma dosyalarındaki SQL bağlantı bilgilerini kendi veritabanı ayarlarınıza göre güncelleyin
- Güvenlik nedeniyle production ortamında güçlü şifreler kullanın
- Firewall ayarlarını gerekli portlar için açın
- İlk çalıştırmada veritabanı tablolarının oluşturulduğundan emin olun

## Sorun Giderme

- Bağlantı sorunları için IP adreslerini ve SQL bağlantı bilgilerini kontrol edin
- IIS hataları için uygulama havuzu ayarlarını kontrol edin
- Veritabanı hataları için SQL Server servislerinin çalıştığından emin olun

Bu kaynak kodlar eğitim ve geliştirme amaçlı paylaşılmıştır.