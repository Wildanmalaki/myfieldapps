# MyField Architecture Guide

## Tujuan

Dokumen ini menjelaskan:

- struktur project saat ini
- masalah arsitektur yang ada
- struktur target yang lebih rapi
- keputusan file mana yang dipakai sebagai sumber utama

Dokumen ini sengaja dibuat sesuai kondisi codebase sekarang, bukan template umum.

## Struktur Saat Ini

Folder utama di `lib/` saat ini:

- `database/`
- `fieldreview/`
- `models/`
- `service/`
- `views/`
- `widget/`

Struktur ini masih berjalan, tetapi beberapa concern masih bercampur:

- halaman UI ada di `views/`
- reusable widget masih sedikit dan belum dipisah per fitur
- model domain ada yang dobel
- service dan database helper masih berperan seperti repository sekaligus gateway data
- ada file halaman profil yang isinya duplikat

## Masalah yang Perlu Dibereskan

### 1. File ganda untuk profile

Saat ini ada beberapa file yang terkait profile:

- `lib/views/account_page.dart`
- `lib/views/profile.dart`
- `lib/views/user_profile_page.dart`
- `lib/views/profile_page.dart`

Kondisi sekarang:

- `account_page.dart` adalah implementasi aktif yang paling layak dijadikan sumber utama
- `profile_page.dart` adalah alias ke `account_page.dart`
- `profile.dart` dan `user_profile_page.dart` berisi implementasi lama yang duplikat

Keputusan yang disarankan:

- pakai `account_page.dart` sebagai source of truth sementara
- jangan tambah logic baru ke `profile.dart` dan `user_profile_page.dart`
- dalam refactor berikutnya, pindahkan isi `account_page.dart` ke lokasi final:
  - `lib/features/profile/presentation/pages/profile_page.dart`

### 2. Model event dobel

Saat ini ada:

- `lib/models/event_model.dart`
- `lib/models/model_event.dart`

Kondisi sekarang:

- `event_model.dart` lebih lengkap dan lebih cocok dipakai
- `model_event.dart` adalah model event lama yang lebih sederhana

Keputusan yang disarankan:

- jadikan `event_model.dart` sebagai model utama
- hindari penggunaan `model_event.dart` untuk kode baru
- di tahap refactor berikutnya, hapus dependency ke `model_event.dart`

### 3. DatabaseHelper terlalu gemuk

`lib/database/database_helper.dart` saat ini menangani:

- user
- booking
- review
- event

Secara praktik, file ini bukan lagi helper kecil, tapi sudah berfungsi seperti repository facade.

Keputusan yang disarankan:

- jangan tambah tanggung jawab baru ke `DatabaseHelper`
- pecah bertahap menjadi repository per domain:
  - `user_repository.dart`
  - `booking_repository.dart`
  - `event_repository.dart`
  - `review_repository.dart`

### 4. Service masih campur infra dan use case

Contoh:

- `firebase_service.dart` sudah bagus sebagai low-level infra service
- `notification_service.dart` juga sudah cocok sebagai infra service

Yang perlu dijaga:

- service infra hanya urus akses SDK/API
- business rule jangan ditaruh di service infra
- business rule pindah ke repository atau controller/use case

## Struktur Target yang Disarankan

Struktur target yang cocok untuk project ini:

```text
lib/
  app/
    app.dart
    routes.dart
    theme/

  core/
    constants/
    errors/
    utils/
    extensions/

  shared/
    widgets/
    services/
    navigation/

  features/
    auth/
      data/
      domain/
      presentation/

    booking/
      data/
      domain/
      presentation/

    field/
      data/
      domain/
      presentation/

    event/
      data/
      domain/
      presentation/

    profile/
      data/
      domain/
      presentation/

    review/
      data/
      domain/
      presentation/

  firebase_options.dart
  main.dart
```

## Mapping Dari Struktur Lama ke Struktur Baru

### Auth

Pindahkan:

- `views/login_page.dart`
- `views/pendaftaran_page.dart`

Ke target:

- `features/auth/presentation/pages/login_page.dart`
- `features/auth/presentation/pages/register_page.dart`

### Booking

Pindahkan:

- `views/bookings_page.dart`
- `views/detail_booking.dart`
- `views/payment_page.dart`
- `models/booking_model.dart`

Ke target:

- `features/booking/presentation/pages/...`
- `features/booking/domain/models/booking.dart`

### Field

Pindahkan:

- potongan data lapangan dari `views/home_page.dart`
- `models/lapangan_model.dart`
- `models/field_location_data.dart`

Ke target:

- `features/field/data/field_seed_data.dart`
- `features/field/domain/models/field_model.dart`
- `features/field/domain/models/field_location.dart`

### Profile

Pindahkan:

- `views/account_page.dart`
- `models/user_model.dart`

Ke target:

- `features/profile/presentation/pages/profile_page.dart`
- `features/profile/domain/models/user_profile.dart`

### Shared UI

Pindahkan:

- `widget/bottomnavbar.dart`

Ke target:

- `shared/navigation/bottom_navbar.dart`

## Aturan Layer

### Model

Model hanya menyimpan data dan mapping.

Contoh yang sudah benar:

- `UserModel.toMap()`
- `UserModel.fromMap()`
- `Booking.copyWith()`

Model tidak boleh:

- baca `BuildContext`
- show snackbar
- push route
- akses Firebase langsung

### Service

Service dipakai untuk akses framework atau SDK.

Contoh:

- `FirebaseService`
- `NotificationService`

Service tidak cocok untuk:

- aturan booking
- validasi form UI
- alur login lengkap

### Repository

Repository menghubungkan model dan service.

Contoh target:

- `BookingRepository.createBooking()`
- `ProfileRepository.updateProfile()`

Repository boleh:

- pakai `FirebaseService`
- ubah map ke model
- gabungkan beberapa query

### Page / Widget

Page hanya fokus pada:

- menampilkan data
- menangani aksi user
- memanggil repository/controller

Page sebaiknya tidak:

- menyimpan data seed besar
- memuat logic mapping yang terlalu berat
- memuat query data lintas domain dalam satu file panjang

## Source of Truth Sementara

Sampai refactor folder selesai, pakai aturan ini:

- user model utama: `lib/models/user_model.dart`
- booking model utama: `lib/models/booking_model.dart`
- event model utama: `lib/models/event_model.dart`
- profile page utama: `lib/views/account_page.dart`
- alias profile page: `lib/views/profile_page.dart`
- data akses Firebase utama: `lib/service/firebase_service.dart`
- facade repository sementara: `lib/database/database_helper.dart`

## Urutan Refactor yang Aman

Lakukan bertahap agar fitur tidak rusak.

### Tahap 1

- dokumentasikan arsitektur
- tentukan canonical files
- hentikan penambahan logic ke file duplikat

### Tahap 2

- buat folder `features/`
- pindahkan per fitur tanpa mengubah logic besar
- perbarui import satu per satu

### Tahap 3

- pecah `DatabaseHelper` menjadi repository per fitur
- pindahkan business logic dari page ke repository/controller

### Tahap 4

- hapus file lama yang sudah tidak dipakai
- rapikan nama class dan file agar konsisten

