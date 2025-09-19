# JobLensCV - ATS-Optimized Resume Builder

JobLensCV, ATS (Applicant Tracking System) uyumlu CV'ler oluşturmaya yardımcı olan profesyonel bir Flutter uygulamasıdır.

## 🚀 Özellikler

### ✅ Tamamlanan Özellikler

#### 1. **Eğitim ve İş Deneyimi Giriş Ekranları**
- **Eğitim Girişi**: Kurum, derece, alan, tarih bilgileri
- **İş Deneyimi Girişi**: Şirket, pozisyon, açıklama, başarılar
- **ATS Optimizasyon İpuçları**: Her formda gerçek zamanlı öneriler
- **Tarih Yönetimi**: Mevcut pozisyon/eğitim için "şu anda" seçenekleri
- **Form Validasyonu**: Kapsamlı doğrulama sistemi

#### 2. **Profil Yönetimi Sistemi**
- **Temel Bilgiler**: Ad, email, telefon, konum
- **Profesyonel Özet**: ATS-dostu özet yazma
- **Dinamik Profil Görüntüleme**: Eğitim ve deneyim listesi
- **Gerçek Zamanlı ATS Puanlama**: Profil tamamlandıkça puan hesaplama

#### 3. **ATS Optimizasyon Algoritmaları**
- **Çok Boyutlu Puanlama Sistemi**:
  - Profil Tamamlılığı (30%)
  - Anahtar Kelime Optimizasyonu (25%)
  - İçerik Kalitesi (20%)
  - Format ve Yapı (15%)
  - Deneyim İlişkisi (10%)
- **Akıllı Anahtar Kelime Analizi**
- **Ölçülebilir Başarı Tespiti**
- **ATS-Dostu Format Kontrolü**

#### 4. **İş İlanı Analiz Sistemi**
- **URL'den Otomatik Analiz** (simülasyon)
- **Manuel Metin Girişi**
- **Anahtar Kelime Çıkarımı**
- **Beceri Tespiti**
- **Optimizasyon Önerileri**

#### 5. **Modern UI/UX Tasarım**
- **ATS-Dostu Renk Paleti**
- **Professional Tema Sistemi**
- **Responsive Tasarım**
- **Bottom Navigation**
- **Material Design 3**

#### 6. **Kapsamlı Utilities**
- **Form Validasyon Sistemi**
- **ATS İçerik Analizi**
- **Tarih ve Süre Hesaplamaları**
- **Puan Renklendirme Sistemi**
- **Hata ve Başarı Bildirimleri**

### 🔄 Geliştirme Aşamasında

- CV Template Seçim Sistemi
- PDF Oluşturma
- Veri Persistance (Hive/SharedPreferences)
- Gelişmiş AI Entegrasyonu
- İş İlanı URL Parsing
- Export/Import Fonksiyonları

## 🛠️ Teknik Yapı

### Dosya Organizasyonu
```
lib/
├── config/
│   ├── constants.dart      # Uygulama sabitleri ve ATS anahtar kelimeleri
│   └── themes.dart         # Professional tema sistemi
├── data/
│   ├── models/             # Veri modelleri (UserProfile, Education, Experience, etc.)
│   └── services/
│       └── ats_service.dart # ATS analiz ve puanlama servisi
├── screens/
│   ├── home_screen.dart    # Ana dashboard ve navigasyon
│   ├── profile/
│   │   ├── profile_screen.dart           # Ana profil yönetimi
│   │   ├── education_input_screen.dart   # Eğitim girişi
│   │   └── experience_input_screen.dart  # İş deneyimi girişi
│   └── cv_creation/
│       └── job_posting_input_screen.dart # İş ilanı analizi
└── utils/
    ├── validators.dart     # Form doğrulama fonksiyonları
    └── helpers.dart        # Yardımcı fonksiyonlar ve ATS hesaplamaları
```

### Kullanılan Teknolojiler
- **Flutter**: Cross-platform mobile development
- **GetX**: State management ve navigation
- **Material Design 3**: Modern UI framework
- **Dart**: Programming language

### ATS Optimizasyon Algoritması

#### Puanlama Kriterleri
1. **Profil Tamamlılığı (30%)**
   - Temel bilgi kontrolü
   - Zorunlu alan doldurma oranı
   - İletişim bilgisi format kontrolü

2. **Anahtar Kelime Optimizasyonu (25%)**
   - İş ilanı ile profil kelime eşleşmesi
   - Teknik beceri keyword yoğunluğu
   - İçerik-gereksinim uyum analizi

3. **İçerik Kalitesi (20%)**
   - Action verb kullanımı
   - Ölçülebilir başarı sayısı
   - Metin uzunluğu optimizasyonu

4. **Format ve Yapı (15%)**
   - ATS-dostu formatting
   - Standart bölüm başlıkları
   - Tutarlı tarih formatları

5. **Deneyim İlişkisi (10%)**
   - Pozisyon-hedef iş uyumu
   - Sektör deneyimi analizi
   - Kariyer progresyonu

## 📱 Kullanım

### Profil Oluşturma
1. Ana ekrandan "Profile" sekmesine gidin
2. Temel bilgilerinizi doldurun
3. "Add Experience" ile iş deneyimlerinizi ekleyin
4. "Add Education" ile eğitim bilgilerinizi ekleyin
5. ATS puanınızı gerçek zamanlı takip edin

### İş İlanı Analizi
1. "Dashboard" sekmesinden "Analyze Job" seçin
2. İş ilanı URL'si girin veya metni yapıştırın
3. Analiz sonuçlarını inceleyin
4. Önerilen optimizasyonları profilinize uygulayın

### ATS Puanınızı Artırma
- Profil bölümlerini eksiksiz doldurun
- İş tanımındaki anahtar kelimeleri kullanın
- Ölçülebilir başarılarınızı (%, sayı, miktar) belirtin
- Action verb'ler kullanın (Achieved, Developed, Managed)
- Profesyonel özet yazın (50-500 karakter arası)

## 🎯 ATS İpuçları

### ✅ Yapılması Gerekenler
- Standart bölüm başlıkları kullanın
- Anahtar kelimeleri organik şekilde dahil edin
- Ölçülebilir başarıları vurgulayın
- Basit ve temiz formatlama yapın
- PDF veya DOCX formatında kaydedin

### ❌ Yapılmaması Gerekenler
- Yaratıcı bölüm başlıkları kullanmayın
- Tablolar, sütunlar, grafik kullanmayın
- Özel karakterlerden kaçının
- Header/footer kullanmayın
- Resim ve logo eklemeyin

## 🚧 Geliştirme Notları

Bu proje aktif geliştirme aşamasındadır. Şu anda temel profil yönetimi ve ATS analiz özellikleri tamamlanmıştır. 

### Sonraki Adımlar
- Template seçim sistemi
- PDF export özelliği
- Gelişmiş AI entegrasyonu
- Cloud sync ve backup
- Multi-language support

## 📄 Lisans

Bu proje açık kaynak kodludur ve eğitim amaçlı geliştirilmiştir.

## 👨‍💻 Geliştirici

**FurkanTheNazim** - [GitHub Profili](https://github.com/FurkanTheNazim)

### Önemli Depolarım
- [Post-Defence](https://github.com/FurkanTheNazim/Post-Defence)
- [Game Designer Portfolio](https://github.com/FurkanTheNazim/v0-game-designer-portfolio-v01)
- [My Pipex](https://github.com/FurkanTheNazim/my-pipex)

---

*JobLensCV ile ATS sistemlerini geçen, işverenlerin dikkatini çeken profesyonel CV'ler oluşturun!*
