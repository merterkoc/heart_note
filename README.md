# Heart Note - Flutter Uygulaması
# flutter build apk --release --dart-define=GEMINI_API_KEY=AIzaSyADRAipJbD2m3WzCdRPrLW2W_-Xjlmr7wI
## Proje Açıklaması

Heart Note, kullanıcıların duygusal ve kişisel notlar oluşturmasına yardımcı olan bir Flutter uygulamasıdır. Bu uygulama, yapay zeka (AI) teknolojilerini kullanarak yaratıcı mesajlar oluşturmayı ve kullanıcıların duygusal ifadelerini zenginleştirmeyi amaçlar.

## Özellikler

-   **AI Destekli Mesaj Oluşturma:** Kullanıcılar, belirli anahtar kelimeler ve kategoriler seçerek AI'nın yardımıyla özel mesajlar oluşturabilir.
-   **Kişiselleştirilmiş Hitaplar:** Kullanıcılar, mesajlarına uygun farklı hitap tonları seçebilirler.
-   **Görsel Oluşturma:** AI, mesajlara uygun görseller oluşturarak duygusal ifadeleri destekler.
-   **Mesaj Geçmişi:** Oluşturulan mesajlar kaydedilir ve kullanıcılar daha sonra bu mesajlara erişebilir.
-   **Tema Seçenekleri:** Kullanıcılar, uygulamanın temasını kişisel tercihlerine göre değiştirebilirler.
-   **Onboarding Deneyimi:** Yeni kullanıcılar için uygulamanın özelliklerini eğlenceli ve bilgilendirici bir şekilde tanıtan bir onboarding süreci bulunur.

## Kurulum

1.  **Flutter SDK'sını Yükleyin:**

    Eğer Flutter SDK'sı yüklü değilse, [Flutter resmi web sitesinden](https://flutter.dev/docs/get-started/install) işletim sisteminize uygun olanı indirin ve kurun.
2.  **Projeyi Klone Edin:**

    ```bash
    git clone [GitHub Proje URL'si]
    cd [Proje Dizini]
    ```
3.  **Bağımlılıkları Yükleyin:**

    ```bash
    flutter pub get
    ```
4.  **API Anahtarlarını Ayarlayın:**

    Uygulama, Gemini ve Hugging Face API'lerini kullanır. Bu API'ler için gerekli olan anahtarları `--dart-define` parametresi ile belirtin:

    ```bash
    flutter run --dart-define=GENERATIVE_MODEL_API_KEY=YOUR_GEMINI_API_KEY --dart-define=HUGGING_FACE_API_KEY=YOUR_HUGGING_FACE_API_KEY
    ```

    `YOUR_GEMINI_API_KEY` ve `YOUR_HUGGING_FACE_API_KEY` yerine kendi API anahtarlarınızı yazın.
5.  **Uygulamayı Çalıştırın:**

    ```bash
    flutter run
    ```

## Bağımlılıklar

-   `cupertino_icons`: iOS stil ikonları
-   `equatable`: Nesne eşitliğini kolaylaştırmak için
-   `flutter_bloc`: Uygulama durumunu yönetmek için
-   `go_router`: Sayfalar arası yönlendirme için
-   `google_fonts`: Google fontlarını kullanmak için
-   `google_generative_ai`: Google'ın üretken yapay zeka modellerini kullanmak için
-   `http`: HTTP istekleri yapmak için
-   `package_info_plus`: Uygulama bilgisi almak için
-   `path_provider`: Dosya yolu işlemlerini yönetmek için
-   `shared_preferences`: Basit veri saklama işlemleri için
-   `share_plus`: İçeriği paylaşmak için
-   `dots_indicator`: Sayfa göstergesi için
-   `lottie`: Lottie animasyonları için

## Proje Yapısı

```bash
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec
rm -Rf ios/Podfile.lock
pod cache clean --all
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cd ios
arch -x86_64 pod install
cd ..
flutter build ios --release --flavor dev
```
