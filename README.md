# **pml** Project Folder Flutter
<br><br>
# Praktikum sesi 4 – Layout (Declarative UI & Responsive Design)
## Tugas Praktikum 2
<br><br>
## Praktikum 5 - Layout Sederhana
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 51" src="https://github.com/user-attachments/assets/bb73d27f-a6cb-499e-8ee4-f8657090aed1" />
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 51 (1)" src="https://github.com/user-attachments/assets/a1a4fc8c-4925-4f91-8b0c-3351f490ef03" />

Membuat kartu profil sederhana sebelum dashboard responsif yang seperti ada di modul, hasilnya terlihat seperti gambar sebelah kiri.   
Untuk gambar sebelah kanan adalah hasil dari eksperimen yang telah dilakukan sesuai dengan petunjuk yang ada di modul.
- Hasil ekperimen pertama adalah ketika menghapus `expanded`, maka yang terjadi adalah jika teks yang diisi panjang maka teks tersebut akan merentang terus ke kanan sampai melewati batas lebar `container`, karena tidal lagi dibatasi oleh ruang sisa yang sebagaimana adalah fungsi dari `expanded`.
- Hasil eksperimen kedua adalah mengubah `mainAxisSize: mainAxisSize.min` menjadi nilai default atau dihapus, maka yang terjadi adladah `column` kartu warna biru muda itu menjadi panjang vertikal mengisi seluruh ruang kosong yang tersisa di layar
- Hasil eksperimen ketiga adalah menambahkan satu baris data (Email), maka yang terjadi adalah menambah baris baru berupa ”Email” di bawah dengan menggunakan pola yang sama seperti NIM dan Kelas

<br><br><br>
## Praktikum 6 - Membuat Dashboard Responsif
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 51 (2)" src="https://github.com/user-attachments/assets/e0397813-0af1-482e-84c5-698d019b146b" />
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 52" src="https://github.com/user-attachments/assets/a6bde587-1d3c-4d27-abaf-55cfe731ed91" />

Membuat dashboard responsif yang sesuai dengan modul, kemudian mengubahnya dashboard dari `Stateless` menjadi `Stateful` dan mencoba berbagai eksperimennya dari yang ubah breakpoint, ubah themeMode, uji aplikasi sampai dengan penambahan semantic atau label. 
<br><br><br>
## Hasil Tampilan Aplikasi Dashboard Academic Overview dari Tugas Utama
Berikut adalah hasil implementasi antarmuka deklaratif (Declarative UI) dan desain responsif (Responsive Design) beserta fitur pergantian tema (Light/Dark Mode):   

**1. Tampilan Layar Sempit (1 Kolom / Mobile)**   
<img width="230" height="515" alt="academic_overview_narrow_dark" src="https://github.com/user-attachments/assets/a37c13df-435d-40e6-aa5d-e8772e1428df" />
<img width="230" height="515" alt="academic_overview_narrow" src="https://github.com/user-attachments/assets/f4da7106-b073-45aa-82b2-a6c7a21f9275" />

**2. Tampilan Layar Lebar (2 Kolom / Tablet & Web)**   
<img width="720" height="480" alt="academic_overview_wide_dark" src="https://github.com/user-attachments/assets/e035f9d8-1f85-4fbe-a238-17cd4483cc25" />
<img width="720" height="480" alt="academic_overview_wide" src="https://github.com/user-attachments/assets/205f1b1d-62bb-416d-b7ad-70e920e7f848" />
<br><br><br>
## Implementasi Kode Utama (Refactoring & Responsive)   
Sesuai instruksi modul, saya telah melakukan refactoring kode agar lebih rapi, dapat digunakan ulang (reusable), dan responsif

**1. Logika Responsif menggunakan LayoutBuilder**   
Aplikasi menggunakan `LayoutBuilder` dengan breakpoint 700px. Jika layar lebih lebar dari 700px, kartu informasi akan disusun menjadi 2 kolom menggunakan `Row` dan `Expanded`. Jika kurang, disusun menjadi 1 kolom menggunakan `Column`.
<img width="940" height="415" alt="image" src="https://github.com/user-attachments/assets/33d4f825-7b10-4246-b736-7f7dad3ed9fc" />

**2. Pembuatan Widget Reusable (AcademicInfoCard)**   
Saya memisahkan UI kartu informasi ke dalam `StatelessWidget` mandiri bernama `AcademicInfoCard`. Hal ini menghilangkan duplikasi kode dan mempermudah pengaturan parameter seperti warna, ikon, dan progres.   
<img width="540" height="246" alt="image" src="https://github.com/user-attachments/assets/d89983e1-0755-4713-b5ab-646e4fb9c4a2" />

## Bukti Hasil Testing   
Saya telah menjalankan pengujian dasar (testing) menggunakan perintah flutter test untuk memverifikasi perilaku responsif aplikasi (peralihan dari 1 kolom ke 2 kolom) sesuai dengan yang diinstruksikan.   
<img width="620" height="270" alt="image" src="https://github.com/user-attachments/assets/bb7c9c63-76b1-406a-a339-d54d5f066479" />
