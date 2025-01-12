# Alışkanlık Yönetimi Akışı

## İçindekiler
1. [Alışkanlık Oluşturma](#alışkanlık-oluşturma)
2. [Alışkanlık Takibi](#alışkanlık-takibi)
3. [Alışkanlık Tamamlama](#alışkanlık-tamamlama)
4. [Streak Sistemi](#streak-sistemi)
5. [Veri Yapısı](#veri-yapısı)

## Alışkanlık Oluşturma

Kullanıcılar iki farklı şekilde alışkanlık oluşturabilir:

1. **Önerilen Alışkanlıklar**
   - Sağlık & Fitness
   - Kişisel Gelişim
   - Üretkenlik
   kategorilerinden hazır şablonları seçebilirler.

2. **Özel Alışkanlık Oluşturma**
   Kullanıcılar kendi alışkanlıklarını şu özelliklerle oluşturabilir:
   - Başlık
   - İkon
   - Hedef Tipi (süre/miktar)
   - Hedef Değeri
   - Frekans (günlük/haftalık/aylık/özel)
   - Zorluk Seviyesi (1-5 arası)
   - Bildirim Zamanı

## Alışkanlık Takibi

### Görüntüleme
- Ana sayfada günlük alışkanlıklar listelenir
- Tamamlanan ve tamamlanmayan alışkanlıklar ayrı gruplandırılır
- Her alışkanlık için:
  - İkon
  - Başlık
  - Hedef bilgisi
  - Tamamlanma durumu gösterilir

### Filtreleme
- Günlük alışkanlıklar her zaman görüntülenir
- Özel frekanslı alışkanlıklar sadece belirlenen günlerde görüntülenir
- Tamamlanan alışkanlıklar ayrı bir bölümde gösterilir

## Alışkanlık Tamamlama

### Tamamlama İşlemi
1. Kullanıcı alışkanlığı tamamladığında:
   - Tamamlanma tarihi kaydedilir
   - Streak hesaplanır
   - UI güncellenir

### Geri Alma
- Kullanıcı tamamlama işlemini geri alabilir
- Geri alma durumunda:
  - Tamamlanma kaydı silinir
  - Streak güncellenir
  - UI güncellenir

## Streak Sistemi

### Streak Hesaplama
- Her gün tüm alışkanlıklar tamamlandığında streak artar
- Herhangi bir gün alışkanlık tamamlanmazsa streak sıfırlanır
- En yüksek streak kaydı tutulur

### Kutlama Sistemi
- Her 7 günlük streak'te kutlama animasyonu gösterilir
- Kullanıcının motivasyonunu artırmak için görsel geri bildirimler sunulur

## Veri Yapısı

### HabitEntity Özellikleri
- id: Benzersiz tanımlayıcı
- title: Alışkanlık başlığı
- iconPath: İkon yolu
- targetType: Hedef tipi (süre/miktar)
- targetValue: Hedef değeri
- frequency: Frekans
- customDays: Özel günler (varsa)
- notificationTime: Bildirim zamanı
- difficulty: Zorluk seviyesi (1-5)
- completions: Tamamlanma tarihleri
- currentStreak: Mevcut streak
- bestStreak: En yüksek streak

### Veri Saklama
- Hive veritabanı kullanılır
- Veriler local olarak saklanır
- CRUD işlemleri için repository pattern kullanılır

## İstatistikler

Kullanıcılar alışkanlıklarını şu periyotlarda takip edebilir:
- Günlük
- Aylık
- Yıllık

Her periyot için:
- Tamamlanan alışkanlık sayısı
- Başarı oranı
- En uzun streak
gibi metrikler gösterilir. 