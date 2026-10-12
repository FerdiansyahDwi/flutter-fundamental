# **pml** Project Folder Flutter
<br><br>
# Praktikum sesi 4 – Layout (Declarative UI & Responsive Design)
## Tugas Praktikum 1
<br><br>
## Praktikum 1
<img width="520" height="230" alt="image" src="https://github.com/user-attachments/assets/091e6ea3-adfd-4ee2-a9cf-b42734d98bf8" />

Melanjutkan project yang sudah dibuat pada pertemuan ke 3 dengan membuat branch baru bernama `pertemuan_4` pada github agar folder dari pertemuan ke 3 tidak mengalami perubahan dan masih tersimpan dalam branch `main`.   
Mengidentifikasi secara langsung dari contoh layout yang diberikan dengan menggambarkan ulang tentang layout yang digunakan dari contoh tersebut
<br><br><br>
## Praktikum 2
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 50 (1)" src="https://github.com/user-attachments/assets/577065d3-53c6-4c10-9eb1-1015bc1ab885" />

Membuat tombol yang berisi 3 kolom yaitu `icon` dan `teks`. Karena untuk membuat setiap kolom memiliki kode yang hampir sama, maka caranya adalah membuat kolom bernama `_buildButton()` yang mempunyai parameter warna, icon dan text yang berfungsi untuk memudahkan membuat 3 kolom itu. Jadi setelah membuat fungsi `_buildButton` maka tinggal dipanggil nanti di dalam `children` yang ada di dalam `container`.  
<br><br><br>
## Praktikum 3
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 50 (1)" src="https://github.com/user-attachments/assets/577065d3-53c6-4c10-9eb1-1015bc1ab885" />

Membuat text section dengan cara membuat `padding` baru di bawah persis button row tadi dengan membuat perintah `child: Text(“isi text”)` maka langsung nanti textnya akan terlihat di bagian bawah 3 kolom button tersebut
<br><br><br>
## Praktikum 4
<img width="200" height="380" alt="WhatsApp Image 2026-10-12 at 11 25 50" src="https://github.com/user-attachments/assets/21a93cab-bf4c-4e7e-ad6e-e9e36730c852" />

Menambahkan gambar pada aplikasi ini dengan cara memasukkan file gambar yang telah di download ke dalam folder `assets` kemudian set nama file gambar tersebut di dalam file `pubspec.yaml` kemudaian menambahkan asset gambar ke dalam `body` dan mengubah menjadi `ListView` bukan `column`, karena `ListView` mendukung scroll yang dinamis saat aplikasi berjalan di perangkat yang resoluinya kecil.
<br><br><br>
