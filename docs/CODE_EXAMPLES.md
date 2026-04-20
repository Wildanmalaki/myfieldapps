# Code Examples From This Project

Dokumen ini menjelaskan contoh nyata dari codebase kamu sendiri.

## 1. Contoh Model

### User model

File:

- `lib/models/user_model.dart`

Fungsi model ini:

- menyimpan data user
- mengubah data ke map dengan `toMap()`
- membaca data dari map dengan `fromMap()`

Contoh:

```dart
final user = UserModel(
  id: 1,
  username: 'Wildan',
  email: 'wildan@mail.com',
  password: '123456',
  role: 'user booking',
);
```

Ini cocok disebut model karena:

- tidak punya `BuildContext`
- tidak akses Firebase
- tidak render UI

## 2. Contoh Service

### FirebaseService

File:

- `lib/service/firebase_service.dart`

Peran service ini:

- akses Firestore
- akses Firebase Storage
- menyediakan operasi dasar seperti create, update, delete, query

Ini contoh fungsi service:

```dart
Future<void> updateDocument({
  required String collectionPath,
  required int id,
  required Map<String, dynamic> data,
}) async {
  await collection(collectionPath)
      .doc(id.toString())
      .set(data, SetOptions(merge: true));
}
```

Kenapa ini service:

- tugasnya berbicara ke Firebase SDK
- belum menyimpan rule bisnis domain tertentu

## 3. Contoh Repository Facade Sementara

### DatabaseHelper

File:

- `lib/database/database_helper.dart`

Saat ini `DatabaseHelper` berfungsi seperti repository gabungan.

Contoh fungsi:

```dart
Future<void> updateUserProfile({
  required int userId,
  String? username,
  String? photoUrl,
}) async {
  final updates = <String, dynamic>{};

  if (username != null) {
    updates['username'] = username;
  }
  if (photoUrl != null) {
    updates['photoUrl'] = photoUrl;
  }

  if (updates.isEmpty) return;

  await _firebaseService.updateDocument(
    collectionPath: _usersCollection,
    id: userId,
    data: updates,
  );
}
```

Fungsi di atas sebaiknya nanti dipindahkan ke:

- `ProfileRepository`

## 4. Contoh UI Function

### Ganti profile

Sumber utama saat ini:

- `lib/views/account_page.dart`

Function yang menangani ganti nama profile:

- `_showEditProfileDialog()`

Function ini adalah fungsi UI karena:

- membuka dialog
- mengambil input user
- menampilkan snackbar
- memanggil `DatabaseHelper`

Alur sederhananya:

1. buka dialog
2. user isi nama baru
3. validasi input
4. kirim perubahan ke `DatabaseHelper.updateUserProfile`
5. update state UI

Target refactor yang disarankan:

- dialog tetap di page
- validasi ringan tetap di page
- proses update data tetap lewat repository

## 5. Contoh Function Booking

Sumber utama:

- `lib/views/detail_booking.dart`

Contoh function:

- `_loadBookedSlots()`
- `_doesOverlapWithBookings(...)`
- `_findFirstAvailableStartHour(...)`

Saat ini function-function ini masih hidup di page karena sangat dekat dengan UI booking.

Itu masih wajar untuk sekarang, tetapi kalau logic booking makin besar, sebaiknya dipindah ke:

- `BookingAvailabilityService`
- atau `BookingController`

## 6. Contoh Data Lapangan

Sumber:

- `lib/models/field_location_data.dart`

File ini sekarang cocok dipakai sebagai data domain pendukung untuk fitur lapangan.

Contoh isi:

```dart
FieldLocationData(
  fieldName: 'Dekings Arena',
  shortLocation: 'Lubang Buaya',
  fullAddress: 'Jl. Manunggal XVII ...',
  latitude: -6.297126,
  longitude: 106.894443,
)
```

Target jangka menengah:

- pindahkan ke `features/field/domain/models/field_location.dart`
- buat seed data di `features/field/data/field_seed_data.dart`

## 7. Aturan Praktis Memisahkan Kode

### Kalau kode ini UI

Simpan di:

- `presentation/pages/`
- `presentation/widgets/`

Contoh:

- dialog edit profile
- card lapangan
- bottom navbar

### Kalau kode ini model

Simpan di:

- `domain/models/`

Contoh:

- `UserModel`
- `Booking`
- `EventModel`

### Kalau kode ini service

Simpan di:

- `shared/services/`
- atau `core/services/`

Contoh:

- Firebase service
- notification service
- image upload service

### Kalau kode ini repository

Simpan di:

- `data/repositories/`

Contoh:

- `ProfileRepository`
- `BookingRepository`

## 8. Rekomendasi Refactor Pertama yang Paling Worth It

Kalau mau rapih dengan effort paling masuk akal, mulai dari:

1. satukan profile page ke satu file utama
2. satukan event model ke satu file utama
3. pecah `DatabaseHelper` per domain
4. pindahkan `bottomnavbar.dart` ke folder navigasi bersama
5. pindahkan data lapangan ke folder feature field

