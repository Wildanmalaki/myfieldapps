# MyField Codebase Reference

Dokumen ini adalah katalog semua file utama di project `MyField`, beserta fungsi file, class penting, dan hubungan antar file.

---

## 1. Entry Point dan App Setup

### `lib/main.dart`

Fungsi:

- entry point aplikasi
- inisialisasi Firebase
- inisialisasi notification service
- menjalankan `MyApp`

Class penting:

- `MyApp`

Catatan:

- `home` awal aplikasi diarahkan ke `SplashScreen`
- theme mode dikontrol oleh `AppThemeController` dari `settings_page.dart`

### `lib/firebase_options.dart`

Fungsi:

- menyimpan konfigurasi Firebase per platform

Class penting:

- `DefaultFirebaseOptions`

Catatan:

- file ini generated oleh FlutterFire CLI
- jangan edit manual kecuali kamu benar-benar tahu konsekuensinya

---

## 2. Data Layer dan Backend Access

### `lib/service/firebase_service.dart`

Fungsi:

- wrapper low-level untuk Firestore dan Firebase Storage
- create/update/delete/query document
- upload file ke Firebase Storage

Class penting:

- `FirebaseService`

Dipakai oleh:

- `DatabaseHelper`

Catatan:

- ini adalah infra service
- tidak sebaiknya menyimpan business rule UI

### `lib/database/database_helper.dart`

Fungsi:

- facade data sementara untuk semua domain
- user login dan profile
- booking
- review
- event

Class penting:

- `DatabaseHelper`

Method penting:

- `insertUser`
- `loginUser`
- `getUserByEmail`
- `getUserById`
- `updateUserProfile`
- `ensureGoogleUser`
- `insertBooking`
- `getBookingsByUser`
- `getBookingsByFieldAndDate`
- `insertReview`
- `getReviews`
- `insertEvent`
- `getEvents`
- `updateEvent`

Catatan:

- file ini sekarang bertindak seperti repository gabungan
- nantinya paling bagus dipecah per fitur

### `lib/service/notification_service.dart`

Fungsi:

- konfigurasi local notifications
- schedule promo notification berkala

Class penting:

- `NotificationService`

Catatan:

- dipanggil di `main.dart`

---

## 3. Domain Models

### `lib/models/user_model.dart`

Fungsi:

- model data user
- mapping dari dan ke map Firebase

Class penting:

- `UserModel`

Field utama:

- `id`
- `username`
- `email`
- `password`
- `role`
- `photoUrl`

Method penting:

- `toMap()`
- `fromMap()`
- getter `displayName`

### `lib/models/booking_model.dart`

Fungsi:

- model data booking
- menyimpan status booking dan pembayaran

Class penting:

- `Booking`

Field utama:

- `lapangan`
- `userID`
- `tanggal`
- `waktu`
- `startHour`
- `endHour`
- `durationHours`
- `status`
- `harga`
- `invoiceNumber`
- `paymentMethod`
- `paymentStatus`

Method penting:

- `toMap()`
- `fromMap()`
- `copyWith()`

### `lib/models/event_model.dart`

Fungsi:

- model event komunitas versi utama

Class penting:

- `EventModel`
- `EventParticipant`

Field penting:

- `title`
- `sport`
- `date`
- `time`
- `location`
- `players`
- `participants`
- `creatorName`
- `creatorId`

Catatan:

- ini adalah event model utama yang sebaiknya dipakai ke depan

### `lib/models/model_event.dart`

Fungsi:

- model event lama yang lebih sederhana

Class penting:

- `Event`

Catatan:

- sebaiknya dipensiunkan bertahap
- jangan dipakai untuk fitur baru

### `lib/models/lapangan_model.dart`

Fungsi:

- model sederhana untuk lapangan

Class penting:

- `Lapangan`

Catatan:

- saat ini data lapangan lebih banyak langsung hidup di `home_page.dart`
- model ini masih bisa dipakai sebagai dasar refactor fitur lapangan

### `lib/models/field_location_data.dart`

Fungsi:

- menyimpan alamat dan koordinat lapangan
- registry lokasi lapangan

Class penting:

- `FieldLocationData`
- `FieldLocationRegistry`

Dipakai oleh:

- `home_page.dart`
- `detail_booking.dart`

Catatan:

- ini sekarang jadi sumber data lokasi lapangan

---

## 4. Navigation dan Widget Bersama

### `lib/widget/bottomnavbar.dart`

Fungsi:

- bottom navigation utama setelah user login

Class penting:

- `BottomNavbar`
- `_BottomNavbarState`

Page yang dipasang:

- `HomePage`
- `BookingsPage`
- `CommunityPage`
- `AccountPage`

Catatan:

- file ini sebaiknya nanti dipindah ke folder navigasi/shared

---

## 5. Views / Pages

### `lib/views/splash.dart`

Fungsi:

- halaman splash awal
- menampilkan logo/app intro sebelum menuju halaman berikutnya

Class penting:

- `SplashScreen`

### `lib/views/login_page.dart`

Fungsi:

- login user dengan email/password
- login dengan Google

Class penting:

- `LoginPage`
- `_LoginPage`

Dependensi utama:

- `DatabaseHelper`
- `FirebaseAuth`
- `GoogleSignIn`
- `BottomNavbar`

Function penting:

- `loginUser()`
- `loginWithGoogle()`

### `lib/views/pendaftaran_page.dart`

Fungsi:

- registrasi user baru

Class penting:

- `PendaftaranUser`
- `_PendaftaranUserState`

Dependensi utama:

- `DatabaseHelper`
- `UserModel`

### `lib/views/home_page.dart`

Fungsi:

- halaman beranda utama
- menampilkan rekomendasi lapangan
- menampilkan nearby fields
- menampilkan promo
- menghitung jarak lapangan terhadap user

Class penting:

- `HomePage`
- `_HomePageState`
- `FeatureCard`
- `NearbyCard`
- `_NetworkCardImage`

Data helper internal:

- `_FieldPriceData`
- `_NearbyFieldData`

Logic penting:

- slider lapangan rekomendasi
- pembacaan lokasi user dengan `Geolocator`
- perhitungan jarak lapangan
- sorting daftar `Lapangan Terdekat`

### `lib/views/detail_booking.dart`

Fungsi:

- detail lapangan
- pemilihan tanggal
- pemilihan jam
- pemilihan durasi
- validasi tabrakan slot booking
- buka lokasi lapangan di Google Maps

Class penting:

- `DetailBooking`
- `_DetailBookingState`

Dependensi utama:

- `DatabaseHelper`
- `Booking`
- `PaymentPage`
- `ReviewListPage`
- `url_launcher`

Function penting:

- `_loadBookedSlots()`
- `_doesOverlapWithBookings(...)`
- `_findFirstAvailableStartHour(...)`
- `_openInMaps()`

### `lib/views/payment_page.dart`

Fungsi:

- halaman pembayaran booking
- menampilkan draft booking
- memilih metode pembayaran
- membuat invoice
- menampilkan invoice page

Class penting:

- `PaymentPage`
- `_PaymentPageState`
- `BookingInvoicePage`
- `_InvoiceSection`
- `_InvoiceRow`
- `_InvoiceTimelineItem`
- `_PaymentMethodOption`
- `_DummyQrPainter`

### `lib/views/bookings_page.dart`

Fungsi:

- menampilkan daftar booking milik user

Class penting:

- `BookingsPage`
- `_BookingsPageState`

Dependensi utama:

- `DatabaseHelper`
- `Booking`

### `lib/views/community_page.dart`

Fungsi:

- menampilkan daftar event komunitas
- filter kategori olahraga
- navigasi ke form join event
- navigasi ke create event

Class penting:

- `CommunityPage`
- `_CommunityPageState`

Dependensi utama:

- `DatabaseHelper`
- `EventModel`
- `CreateEventPage`
- `FormJoinEventPage`

Function penting:

- `loadEvents()`
- `deleteEvent(int id)`

### `lib/views/create_event_page.dart`

Fungsi:

- membuat event komunitas baru

Class penting:

- `CreateEventPage`
- `_CreateEventPageState`

Dependensi utama:

- `EventModel`
- `DatabaseHelper`

### `lib/views/form_join_event.dart`

Fungsi:

- form untuk join event komunitas

Class penting:

- `FormJoinEventPage`
- `_FormJoinEventPageState`

Dependensi utama:

- `EventModel`
- `DatabaseHelper`

### `lib/views/settings_page.dart`

Fungsi:

- halaman settings
- mengatur dark mode / theme mode

Class penting:

- `AppThemeController`
- `SettingsPage`

Catatan:

- `AppThemeController` dipakai di `main.dart`

### `lib/views/account_page.dart`

Fungsi:

- profile page utama yang aktif saat ini
- ganti nama profile
- ganti foto profile
- tampilkan statistik booking
- tampilkan history booking

Class penting:

- `AccountPage`
- `_AccountPageState`

Dependensi utama:

- `DatabaseHelper`
- `Booking`
- `image_picker`
- `image_cropper`

Function penting:

- `_loadProfileData()`
- `_refreshProfileFromDatabase()`
- `_showEditProfileDialog()`
- `_changeProfilePhoto()`
- `_showMessage(String message)`

### `lib/views/profile_page.dart`

Fungsi:

- alias/wrapper ke `AccountPage`

Class penting:

- `ProfilePage`

Catatan:

- dibuat sebagai adapter supaya referensi lama ke `ProfilePage` tetap aman

### `lib/views/profile.dart`

Fungsi:

- implementasi profile lama

Class penting:

- `ProfilePage`
- `_ProfilePageState`

Catatan:

- isi sangat mirip dengan file profile/account lain
- sebaiknya tidak dipakai lagi untuk logic baru

### `lib/views/user_profile_page.dart`

Fungsi:

- implementasi profile lama yang duplikat

Class penting:

- `ProfilePage`
- `_ProfilePageState`

Catatan:

- file ini duplikat terhadap profile/account page
- kandidat pembersihan di refactor berikutnya

---

## 6. Field Review Feature

### `lib/fieldreview/models/field_review_model.dart`

Fungsi:

- model review lapangan

Class penting:

- `FieldReview`

### `lib/fieldreview/view/add_review_page.dart`

Fungsi:

- form menambah review lapangan

Class penting:

- `AddReviewPage`
- `_AddReviewPageState`

### `lib/fieldreview/view/review_list_page.dart`

Fungsi:

- daftar review untuk lapangan tertentu

Class penting:

- `ReviewListPage`
- `_ReviewListPageState`

---

## 7. File Khusus / Bukan Kode Utama

### `lib/lib.zip`

Fungsi:

- file arsip di dalam folder `lib`

Catatan:

- bukan bagian source code Dart aktif
- sebaiknya dipindah keluar `lib/` agar tidak membingungkan

---

## 8. Alur Data Utama

### Login biasa

Alur:

1. `LoginPage.loginUser()`
2. `DatabaseHelper.loginUser(...)`
3. `FirebaseService.getDocumentByFields(...)`
4. hasil diubah ke `UserModel`
5. user masuk ke `BottomNavbar`

### Login Google

Alur:

1. `LoginPage.loginWithGoogle()`
2. `GoogleSignIn.authenticate()`
3. `FirebaseAuth.signInWithCredential(...)`
4. `DatabaseHelper.ensureGoogleUser(...)`
5. user masuk ke `BottomNavbar`

### Booking lapangan

Alur:

1. user pilih lapangan dari `HomePage`
2. masuk ke `DetailBooking`
3. pilih tanggal, jam, durasi
4. validasi slot bentrok
5. buat draft `Booking`
6. lanjut ke `PaymentPage`
7. simpan booking melalui `DatabaseHelper`

### Edit profile

Alur:

1. user buka `AccountPage`
2. pilih edit nama atau foto
3. page memanggil `DatabaseHelper.updateUserProfile(...)`
4. `DatabaseHelper` meneruskan ke `FirebaseService.updateDocument(...)`
5. UI di-refresh

---

## 9. File yang Perlu Perhatian Khusus

### Duplikat / transitional files

- `profile.dart`
- `profile_page.dart`
- `user_profile_page.dart`
- `account_page.dart`
- `model_event.dart`

### File besar yang sebaiknya dipisah bertahap

- `home_page.dart`
- `detail_booking.dart`
- `payment_page.dart`
- `community_page.dart`
- `database_helper.dart`

### Folder yang sebaiknya dibersihkan

- `lib/API`
- `lib/UHAMKA TUGAS`

Catatan:

- jika folder tersebut tidak dipakai aktif oleh import project, pertimbangkan dipindah atau dibersihkan agar arsitektur lebih jelas

---

## 10. Rekomendasi Navigasi Cepat Untuk Developer

Kalau kamu mau memahami project dengan cepat, baca urutan file ini:

1. `lib/main.dart`
2. `lib/widget/bottomnavbar.dart`
3. `lib/views/login_page.dart`
4. `lib/views/home_page.dart`
5. `lib/views/detail_booking.dart`
6. `lib/views/payment_page.dart`
7. `lib/views/account_page.dart`
8. `lib/database/database_helper.dart`
9. `lib/service/firebase_service.dart`
10. `lib/models/*.dart`

