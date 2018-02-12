# CARA MENGGUNAKAN UNIT WEBCRT

Unit WebCRT terinspirasi oleh unit klasik Pascal yaitu unit CRT. Unit WebCRT bertujuan untuk memudahkan pemula dalam membuat aplikasi web sederhana. Dengan unit WebCRT, membuat aplikasi web sederhana bisa semudah membuat aplikasi *console* dengan perintah Pascal klasik seperti `writeln` dan `readln`. Misalnya untuk mengerjakan tugas pemrograman dari sekolah atau kampus. Atau bisa juga dipakai untuk sekadar bermain-main dengan algoritma. Karena menghasilkan aplikasi web, program yg dibuat dengan unit WebCRT bisa dipasang di server web dan diakses langsung melalui internet.

Unit WebCRT menghasilkan aplikasi web dengan antarmuka CGI. Pengguna unit ini dianggap telah paham cara pemakaian dan pemasangan server web dengan segala konfigurasinya untuk menjalankan aplikasi web CGI. Seluruh server web seharusnya mendukung antarmuka CGI karena ini salah satu antarmuka yg paling dasar dan sederhana.

## PRASYARAT

1. Sistem operasi yg didukung oleh FreePascal.
2. Server web (Apache, Nginx, dan sebagainya).
3. Server web yg telah terkonfigurasi untuk aplikasi CGI.

## DAFTAR VARIABEL GLOBAL

* Variabel `csvSplitter` bertipe data `string` untuk pengaturan karakter pemisah deret teks (*string*) menjadi deret (*array*) dinamis. Nilai bawaan (*default*) adalah `';'` (titik koma).

* Variabel `ResourcePath` bertipe data `string` untuk pengaturan lokasi *folder* tempat meletakkan berkas pendukung HTML, baik itu berkas CSS, Javascript, gambar, *font*, dan lain sebagainya. Nilai bawaan adalah `'res'`.

* Variabel `SourcePath` bertipe data `string` untuk pengaturan lokasi *folder* tempat meletakkan berkas kode program (*source code*) program Pascal untuk ditampilkan. Unit WebCRT otomatis menampilkan tautan ke berkas kode program. Nilai bawaan adalah `'../pascal'` (sebuah *folder* bernama `pascal` satu tingkat di luar *folder* program berada).

* Variabel `IsWebInput` bertipe data `boolean` untuk mengetahui apakah program menerima masukan dari sisi-depan (*front-end*) atau peramban (*browser*) supaya bisa dikelola lebih lanjut. Ini untuk membedakan perilaku program berdasarkan ada atau tidaknya masukan.

## DAFTAR PROSEDUR DAN FUNGSI

### Pembuka Dan Penutup HTML

* Prosedur `Clrscr()` untuk tanda pembuka berkas HTML yg akan dikirim oleh program. Prosedur ini harus dipanggil **pertama kali** dalam program. Jika tidak maka berkas HTML menjadi salah karena tidak lengkap. Prosedur ini adalah versi singkat dari prosedur `OpenHTML(isPost)`.

* Prosedur `OpenHTML(isPost)` untuk tanda pembuka berkas HTML yg akan dikirim oleh program. Prosedur ini memiliki parameter `isPost` bertipe data `boolean` untuk mengatur metode masukan web, apakah dengan metode `GET` (`isPost` bernilai `false`) atau dengan metode `POST` (`isPost` bernilai `true`). Nilai bawaan parameter ini adalah `true` (metode `POST`).

* Prosedur `CloseHTML(submit)` untuk tanda penutup berkas HTML yg akan dikirim oleh program. Prosedur ini memiliki parameter `submit` bertipe data `boolean` untuk mengatur pemasangan tombol `SUBMIT` di akhir laman. Nilai bawaan parameter ini adalah `true` (ada tombol `SUBMIT`).

* Prosedur `WebReadln()` untuk tanda penutup berkas HTML yg akan dikirim oleh program. Prosedur ini harus dipanggil *terakhir kali* dalam program. Jika tidak maka berkas HTML menjadi salah karena tidak lengkap. Prosedur ini adalah versi singkat dari prosedur `CloseHTML(submit)`.

Sebaiknya gunakan pasangan `Clrscr`–`WebReadln` jika ingin kode program yg sederhana dan klasik. Dan gunakan pasangan `OpenHTML`–`CloseHTML` jika ingin mengubah nilai bawaan parameter.

### Menampilkan Nilai

* Prosedur `WebWrite(value)` dan `WebWriteln(value)` untuk menampilkan nilai dalam berkas HTML yg akan dikirim oleh program. Prosedur ini memiliki parameter `value` dengan tipe data yg didukung antara lain `string`, `integer`, `double`, dan `boolean`. Prosedur ini gunanya mirip dengan prosedur klasik Pascal `Write()` dan `Writeln()`, tapi tidak bisa menerima beragam parameter sekaligus.

* Prosedur `WebWrite(value,width)` untuk menampilkan nilai dalam berkas HTML dengan lebar tertentu. Prosedur ini memiliki dua parameter yaitu `value` untuk data yg akan ditampilkan dan `width` untuk lebar yg diinginkan dalam satuan *pixel*. Prosedur ini berguna untuk menampilkan deretan label untuk masukan HTML yg rata kiri, seperti yg dicontohkan dalam demo program.

* Prosedur `WebPageHeader(title,level)` untuk menampilkan judul HTML dengan marka HTML `<h?>`. Prosedur ini memiliki dua parameter yaitu `title` bertipe data `string` untuk teks judul halaman dan `level` bertipe data `integer` untuk tingkat kedalaman judul (nilai yg diterima adalah 1–6).

* Prosedur `WebPageTitle(title,subtitle)` untuk menampilkan tulisan pasangan judul dan subjudul dengan marka HTML `<big>`. Prosedur ini memiliki dua parameter yaitu `title` untuk teks judul dan `subtitle` untuk teks subjudul, keduanya bertipe data `string`.

* Prosedur `WebWriteVar(key,value)` untuk meletakkan variabel tersembunyi dalam berkas HTML yg dikirim. Prosedur ini memiliki dua parameter yaitu `key` untuk nama variabel dan `value` untuk nilai variabel.

* Prosedur `WebWriteBlock(text)` untuk menampilkan tulisan HTML dengan marka HTML `<blockquote>`. Prosedur ini hanya memiliki satu parameter saja yaitu `text` bertipe data `string` untuk teks yg ingin ditampilkan.

* Fungsi `WebGetLink(url,caption): string` untuk mendapatkan teks HTML dengan marka `<a>`. Fungsi ini memiliki dua parameter yaitu `url` bertipe data `string` untuk alamat tautan dan `caption` bertipe data `string` untuk teks tampilan tautan. Untuk menampilkan tautan hasil fungsi ini, bisa menggunakan prosedur-prosedur untuk menampilkan nilai di atas.

### Membaca Nilai

* 




