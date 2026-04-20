# Refactor Playbook

## Prinsip Refactor

- refactor sedikit demi sedikit
- pastikan `flutter analyze` tetap hijau
- pindahkan file dulu, baru rapikan logic
- jangan gabungkan rename, move, dan rewrite besar dalam satu langkah

## Command yang Sering Dipakai

### Analisis dan formatting

```powershell
flutter analyze
dart format lib test
```

### Cari file dan referensi

```powershell
rg --files lib
rg -n "ProfilePage|AccountPage|EventModel|DatabaseHelper" lib
```

### Cari file duplikat

```powershell
rg -n "class ProfilePage" lib
rg -n "class EventModel|class Event" lib\models
```

## Checklist Refactor per File

Saat mau memindahkan file:

1. tentukan file canonical
2. cek semua import yang memakai file lama
3. pindahkan file ke folder target
4. update import
5. jalankan `flutter analyze`

## Contoh Tahap Refactor Nyata

### Contoh 1: Profile page

Kondisi sekarang:

- logic utama ada di `lib/views/account_page.dart`
- alias ada di `lib/views/profile_page.dart`
- implementasi lama masih ada di `profile.dart` dan `user_profile_page.dart`

Refactor aman:

1. buat folder target:

```powershell
New-Item -ItemType Directory lib\features\profile\presentation\pages -Force
```

2. pindahkan file utama:

```powershell
Move-Item lib\views\account_page.dart lib\features\profile\presentation\pages\profile_page.dart
```

3. update import yang lama ke file baru

4. biarkan `lib/views/profile_page.dart` sementara menjadi adapter/alias

### Contoh 2: Event model

Target:

- `event_model.dart` tetap dipakai
- `model_event.dart` dipensiunkan

Langkah:

```powershell
rg -n "model_event.dart|Event\(" lib
```

Lalu:

- ganti pemakaian `Event` lama ke `EventModel`
- setelah semua pindah, hapus `model_event.dart`

### Contoh 3: DatabaseHelper ke repository

Target folder:

```text
lib/features/booking/data/repositories/booking_repository.dart
lib/features/profile/data/repositories/profile_repository.dart
lib/features/event/data/repositories/event_repository.dart
```

Contoh repository awal:

```dart
class BookingRepository {
  BookingRepository(this._firebaseService);

  final FirebaseService _firebaseService;

  Future<List<Booking>> getBookingsByUser(int userId) async {
    final result = await _firebaseService.getDocumentsByFields(
      collectionPath: 'bookings',
      filters: {'userId': userId},
    );

    return result.map(Booking.fromMap).toList();
  }
}
```

## Rule Penamaan

### File

- file pakai `snake_case.dart`
- nama file harus menggambarkan isi

Contoh:

- `profile_page.dart`
- `booking_repository.dart`
- `field_location_data.dart`

### Class

- class pakai `PascalCase`
- nama class sesuai tanggung jawab

Contoh:

- `ProfilePage`
- `BookingRepository`
- `FirebaseService`

### Function

- pakai nama kerja yang jelas

Contoh yang bagus:

- `updateUserProfile`
- `ensureGoogleUser`
- `getBookingsByFieldAndDate`

Contoh yang perlu dihindari:

- `doStuff`
- `processData`
- `handle`

## Kapan Membuat Folder Baru

Buat folder baru kalau:

- file sudah lebih dari 3-4 untuk satu domain
- ada model, repo, page, widget dalam domain yang sama
- logic mulai menyebar di banyak file tak beraturan

Tidak perlu buru-buru buat folder baru kalau:

- fitur masih satu file kecil
- belum ada reuse
- belum ada domain jelas

