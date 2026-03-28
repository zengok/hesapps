# HesApps 2026 Edition 🚀

Hoşgeldiniz! HesApps uygulamasının **Glassmorphism 2.0 tasarımı**, **Riverpod reaktivitesi** ve **2026 yasal finans kodlarıyla** evrimleşmiş "Clean Architecture" temelli profesyonel versiyonudur.

## 🎯 Değer Önerisi ve 2026 Finans/Sağlık Kodları
Bu proje sadece bir hesap makinesi değil; aynı zamanda Türkiye'nin güncel ve 2026 enflasyon/gelecek tahminlerine dayalı formüller barındıran kompleks bir finans uygulamasıdır.

- **Kümülatif Maaş Modeli (2026)**: Yeni %15'ten %40'a sıçrayan ve toplanan gelir vergisi matrah sistemleriyle entegredir. E2E simülasyonları ile kanıtlanmıştır.
- **Kesin Hesap Kredi Modeli (PMT)**: Decimal paketi sayesinde `floating-point` hataları sıfırlanmış; faiz formüllerine KGF, BSMV ve KKDF gibi vergiler (`1.30` katsayısı) mutlak kesinlikle giydirilmiştir.
- **Biyometrik Sağlık Hesaplayıcı**: Gelişmiş BMI ve Mifflin-St Jeor katsayıları eşliğinde BMR (Kalori ihtiyacı) saptaması.
- **Akıllı Offline-Mode**: Dio paketi ile API üzerinden kur bilgisi alınırken, aynı anda SharedPreferences üzerine cihaz belleğine kazınır. İnternet koptuğunda kurlar kaldığı yerden çalışmaya devam eder.

## ✨ Modern "Glassmorphism 2.0" Mimari Tasarımı
Eski moda Flat ekranlar yerine tamamen "Bento Grid" (Masonry) mantığında asimetrik GlassCard hücreleri kullanılmıştır. Ekranda klavye yerine tamamen projenin dokusuna ait **GlassNumericPad** açılır, arayüzde ise Blur / Fade-In / Shimmer gibi animasyon teknikleri kullanılarak elit bir "FinTech" hissi verilir.
`Adaptive Blur` donanım optimizasyonu kullanılarak düşük performanslı Android cihazlarda render kasılmalarının önüne geçilir (Dynamic Sigma Toggling).

## 🛠 Kullanılan Teknolojiler

- **Mimari:** Clean Architecture (Domain Driven Design pratikleri)
- **State Yönetimi:** Flutter Riverpod (`AsyncNotifier` reaktif entegrasyonu)
- **Navigation:** GoRouter (`ShellRoute` yapılı Floating Bottom Navigation)
- **Güvenlik & Tip:** Freezed (Immutable) ve Decimal
- **Animasyon:** flutter_animate ve RepaintBoundary (infografik outputları)

## 📦 Kurulum ve Çalıştırma

Terminali açın ve komutları çalıştırın:
```bash
# Projeyi ve Paketleri İndirin
flutter pub get

# Freezed kodlarını tetikleyin
flutter pub run build_runner build -d

# Uygulamayı çalıştırın
flutter run
```

## 🧪 Test Ortamı (Unit Tests & E2E)
Tüm iş motorlarımız (CalculateCredit, CalculateSalary vb.) unit test kapsamındadır. 2026 E2E Maaş simülasyonunu görmek için:
> `flutter test test/salary_simulation_e2e_test.dart`

Bu simülasyon maaşın aydan aya vergi dilimlerince nasıl ezilip daraldığını matematiksel bir kesinlikte test eder ve kanıtlar.

Projeye ilginiz için teşekkürler! Happy Coding!
