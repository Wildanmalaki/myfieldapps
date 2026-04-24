# ⚽ MyField Apps

**MyField Apps** adalah aplikasi Flutter yang dirancang untuk membantu pengguna menemukan, melihat, dan mengelola informasi seputar lapangan olahraga.  
Aplikasi ini dibuat dengan tampilan mobile-friendly, animasi modern, serta fitur pendukung seperti review lapangan, penyimpanan data lokal, dan pengelolaan gambar.

---

## 📌 Tentang Project

MyField Apps merupakan project aplikasi berbasis **Flutter** yang dapat dijalankan di berbagai platform, seperti Android, iOS, Web, Windows, macOS, dan Linux.

Aplikasi ini cocok digunakan sebagai sistem sederhana untuk menampilkan informasi lapangan, memberikan review, serta menyimpan data secara lokal menggunakan database SQLite.

---

## ✨ Fitur Utama

- 🏟️ **Informasi Lapangan**  
  Menampilkan data lapangan olahraga yang dapat dilihat oleh pengguna.

- ⭐ **Review Lapangan**  
  Pengguna dapat menambahkan review atau ulasan terhadap lapangan tertentu.

- 🖼️ **Upload / Pilih Gambar**  
  Mendukung pemilihan gambar menggunakan package `image_picker`.

- 💾 **Penyimpanan Lokal**  
  Menggunakan `sqflite` dan `path_provider` untuk menyimpan data secara lokal di perangkat.

- 🎬 **Animasi Interaktif**  
  Menggunakan `lottie` dan `animate_do` agar tampilan aplikasi lebih menarik.

- 🎨 **Custom App Icon**  
  Menggunakan `flutter_launcher_icons` untuk mengatur ikon aplikasi.

- 📱 **Multi-platform**  
  Dapat dijalankan di Android, iOS, Web, Windows, macOS, dan Linux.

---

## 🛠️ Teknologi yang Digunakan

Project ini dibangun menggunakan:

- **Flutter**
- **Dart**
- **Sqflite**
- **Path Provider**
- **Image Picker**
- **Shared Preferences**
- **Lottie**
- **Animate Do**
- **Flutter Launcher Icons**
- **Cupertino Icons**

---

## 📁 Struktur Folder

```bash
myfieldapps/
├── android/
├── assets/
│   ├── images/
│   └── icons/
├── ios/
├── lib/
│   ├── main.dart
│   ├── views/
│   └── fieldreview/
├── linux/
├── macos/
├── test/
├── web/
├── windows/
├── analysis_options.yaml
├── devtools_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
