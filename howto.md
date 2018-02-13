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

* Variabel `SourcePath` bertipe data `string` untuk pengaturan lokasi *folder* tempat meletakkan berkas kode program (*source code*) program Pascal untuk ditampilkan. Unit WebCRT otomatis menampilkan tautan ke berkas kode program. Nilai bawaan adalah `'../pascal'` (sebuah *folder* bernama `pascal` di luar *folder* program berada).

* Variabel `IsWebInput` bertipe data `boolean` untuk mengetahui apakah program menerima masukan dari sisi-depan (*front-end*) atau peramban (*browser*) supaya bisa dikelola lebih lanjut. Ini untuk membedakan perilaku program berdasarkan ada atau tidaknya masukan.

## DAFTAR PROSEDUR DAN FUNGSI

### Pembuka Dan Penutup HTML

* Prosedur `Clrscr()` untuk tanda pembuka berkas HTML yg akan dikirim oleh program. Prosedur ini harus dipanggil **pertama kali** dalam program. Jika tidak maka berkas HTML menjadi salah karena tidak lengkap. Prosedur ini adalah versi singkat dari prosedur `OpenHTML(isPost)`.

* Prosedur `OpenHTML(isPost)` untuk tanda pembuka berkas HTML yg akan dikirim oleh program. Prosedur ini memiliki parameter `isPost` bertipe data `boolean` untuk mengatur metode masukan web, apakah dengan metode `GET` (`isPost` bernilai `false`) atau dengan metode `POST` (`isPost` bernilai `true`). Nilai bawaan parameter ini adalah `true` (metode `POST`).

* Prosedur `CloseHTML(submit)` untuk tanda penutup berkas HTML yg akan dikirim oleh program. Prosedur ini memiliki parameter `submit` bertipe data `boolean` untuk mengatur pemasangan tombol `SUBMIT` di akhir laman. Nilai bawaan parameter ini adalah `true` (ada tombol `SUBMIT`).

* Prosedur `WebReadln()` untuk tanda penutup berkas HTML yg akan dikirim oleh program. Prosedur ini harus dipanggil *terakhir kali* dalam program. Jika tidak maka berkas HTML menjadi salah karena tidak lengkap. Prosedur ini adalah versi singkat dari prosedur `CloseHTML(submit)`.

Sebaiknya gunakan pasangan `Clrscr`–`WebReadln` jika ingin kode program yg sederhana dan klasik. Dan gunakan pasangan `OpenHTML`–`CloseHTML` jika ingin mengubah nilai bawaan parameter.

##### Contoh program 1: Program paling sederhana.
```pascal
program test_1;

uses webCRT;

{ program paling sederhana yg hanya menampilkan halaman kosong }
begin
  Clrscr;     // atau OpenHTML(true);
  WebReadln;  // atau CloseHTML(false);
end.

```

### Menampilkan Nilai

* Prosedur `WebWrite(value)` dan `WebWriteln(value)` untuk menampilkan nilai dalam berkas HTML yg akan dikirim oleh program. Prosedur ini memiliki parameter `value` bertipe data yg didukung antara lain `string`, `integer`, `double`, dan `boolean`. Prosedur ini gunanya mirip dengan prosedur klasik Pascal `Write()` dan `Writeln()`, tapi tidak bisa menerima beragam parameter sekaligus.

* Prosedur `WebWrite(value,width)` untuk menampilkan nilai dalam berkas HTML dengan lebar tertentu. Prosedur ini memiliki dua parameter yaitu `value` untuk data yg akan ditampilkan dan `width` untuk lebar yg diinginkan dalam satuan *pixel*. Prosedur ini berguna untuk menampilkan deretan label untuk masukan HTML yg rata kiri, seperti yg dicontohkan dalam demo program.

* Prosedur `WebPageHeader(title,level)` untuk menampilkan judul HTML dengan marka HTML `<h?>`. Prosedur ini memiliki dua parameter yaitu `title` bertipe data `string` untuk teks judul halaman dan `level` bertipe data `integer` untuk tingkat kedalaman judul (nilai yg diterima adalah 1–6).

* Prosedur `WebPageTitle(title,subtitle)` untuk menampilkan tulisan pasangan judul dan subjudul dengan marka HTML `<big>`. Prosedur ini memiliki dua parameter yaitu `title` untuk teks judul dan `subtitle` untuk teks subjudul, keduanya bertipe data `string`.

* Prosedur `WebWriteVar(key,value)` untuk meletakkan variabel tersembunyi dalam berkas HTML yg dikirim. Prosedur ini memiliki dua parameter yaitu `key` untuk nama variabel dan `value` untuk nilai variabel.

* Prosedur `WebWriteBlock(text)` untuk menampilkan tulisan HTML dengan marka HTML `<blockquote>`. Prosedur ini hanya memiliki satu parameter saja yaitu `text` bertipe data `string` untuk teks yg ingin ditampilkan.

* Fungsi `WebGetLink(url,caption): string` untuk mendapatkan teks HTML dengan marka `<a>`. Fungsi ini memiliki dua parameter yaitu `url` bertipe data `string` untuk alamat tautan dan `caption` bertipe data `string` untuk teks tampilan tautan. Untuk menampilkan tautan hasil fungsi ini, bisa menggunakan prosedur-prosedur untuk menampilkan nilai di atas.

##### Contoh program 2: Menampilkan tulisan.
```pascal
program test_2;

uses webCRT;

{ contoh program menampilkan judul dan tulisan }
begin
  Clrscr;
  
  // judul laman
  WebPageHeader('Ini Judul Laman',2);
  // teks di laman
  WebWriteln('Halo dunia!');
  WebWriteln('Laman ini dibuat dengan Pascal dan unit WebCRT!');
  
  WebReadln;
end.
```

### Mengambil Nilai

* Prosedur `WebRead(value)` dan `WebReadln(value)` untuk mengambil nilai yg diterima dari peramban. Prosedur ini memiliki parameter `value` sebagai variabel bertipe data yg didukung antara lain `string`, `integer`, `double`, dan `boolean`. Prosedur ini gunanya mirip dengan prosedur klasik Pascal `Read()` dan `Readln()`. Prosedur ini akan menampilkan kontrol masukan yg sesuai pada laman HTML. Jika `value` bertipe data `boolean` maka prosedur ini membutuhkan satu parameter tambahan `label` untuk teks pada kontrol masukan berupa centang (*check box*).

    **Catatan:** Jika prosedur `WebRead()` dan `WebReadln()` dipanggil tanpa menyertakan parameter `value` maka prosedur memberi perilaku yg berbeda, yaitu menjadi penutup berkas HTML yg dikirim. Lihat penjelasan di bagian **Penutup dan Pembuka HTML** di atas. Ini sekadar simulasi sederhana kebiasaan penggunaan prosedur `Readln()` di akhir program *console*.

* Fungsi `WebReadVar(key): string` untuk mengambil nilai variabel tersembunyi dari data yg diterima dari peramban. Fungsi ini memiliki satu parameter `key` bertipe data `string` untuk nama variabel yg akan diambil nilainya. Fungsi ini merupakan pasangan dari prosedur `WebWriteVar(key,value)`.

* Prosedur `WebReadMemo(text)` untuk mengambil nilai dari kontrol memo dari peramban. Prosedur ini memiliki satu parameter yaitu `text` sebagai variabel bertipe data `string` untuk menampung teks dari memo. Secara bawaan, kontrol memo akan menambahkan baris baru setelahnya. Jika ingin menambahkan teks persis setelah memo, tambahkan parameter kedua bernilai `false`.

* Fungsi `WebReadOption(option,labels)` untuk mengambil nilai dari kontrol pilihan ganda (*radio button*) dari peramban. Fungsi ini memiliki dua parameter yaitu `option` sebagai variabel bertipe data `integer` untuk menunjukkan nomor urut (*index*) pilihan ganda yg dipilih dan `labels` untuk daftar teks yg ditampilkan pada kontrol pilihan ganda. Parameter `labels` bisa menerima data berupa deret teks (*array of string*), bisa pula berupa teks dengan pemisah (*delimited string*). Keluaran fungsi ini bertipe data `string` berisi teks label yg terpilih. Secara bawaan, kontrol pilihan ganda akan tampil berderet secara horisontal alias tidak ada penambahan baris baru. Jika ingin menambahkan baris baru setelah kontrol pilihan ganda, tambahkan parameter ketiga bernilai `true`.

* Fungsi `WebReadSelect(select,labels)` untuk mengambil nilai dari kontrol seleksi (*combo box*) dari peramban. Fungsi ini memiliki dua parameter yaitu `select` sebagai variabel bertipe data `integer` untuk menunjukkan nomor urut pilihan yg dipilih dan `labels` untuk daftar teks yg ditampilkan pada kontrol seleksi. Parameter `labels` bisa menerima data berupa deret teks (*array of string*), bisa pula berupa teks dengan pemisah (*delimited string*). Keluaran fungsi ini bertipe data `string` berisi teks label yg terpilih. Secara bawaan, kontrol seleksi tidak menambahkan baris baru setelahnya. Jika ingin menambahkan baris baru setelah kontrol seleksi, tambahkan parameter ketiga bernilai `true`.

* Prosedur `WebReadButton(clicked,caption)` untuk mengambil nilai dari kontrol tombol (*button*) dari peramban. Prosedur ini memiliki dua parameter yaitu `clicked` sebagai variabel bertipe data `boolean` untuk menunjukkan status tombol diklik (`true`) atau tidak (`false`) dan `caption` untuk teks yg ditampilkan pada tombol.

**Catatan:** Perlu diperhatikan bahwa sebaiknya dilakukan pengecekan ada tidaknya kiriman data dari peramban sebelum mengambil nilainya, yaitu dengan membaca variabel global `IsWebInput` untuk mencegah kesalahan pembacaan data.

##### Contoh program 3: Mengambil nilai sederhana.
```pascal
program test_3;

uses webCRT;

var
  n: string;
  k: boolean;

begin
  Clrscr;
  WebPageHeader('Siapa Kamu?');

  // teks untuk input nama
  WebWrite('Ketik namamu: ');
  // kontrol untuk input nama
  WebReadln(n);
  
  // teks untuk input kelamin
  WebWrite('Kamu perempuan? ');
  // kontrol untuk input nama
  WebReadln(k,'Ya.');
  
  // uji adanya data dari peramban
  if IsWebInput then
  begin
    if n <> '' then
    begin
      // tampilkan tanggapan yg sesuai
      WebWrite('Hai, '+n+'! Senang berkenalan dengan ');
      if k then WebWriteln('gadis cantik.')
        else WebWriteln('pemuda ganteng.');
    end
    else
      WebWriteln('Wah, kamu tidak mau berkenalan denganku ya?');
  end;
  
  WebReadln;
end.
```

##### Contoh program 4: Mengambil nilai dengan kontrol lanjut.
```pascal
program test_4;

uses webCRT;

var
  mmo: string;
  opt: integer;
  sel: integer;
  btn: boolean;
  o,s: string;

begin
  Clrscr;
  WebPageHeader('Isian Data');
  
  // masukan memo
  WebWrite('Alamat rumah: ');
  WebReadMemo(mmo);
  // masukan pilihan ganda dengan delimited string
  WebWrite('Warganegara: ');
  o := WebReadOption(opt,'WNI;WNA',true);
  // masukan pilihan seleksi dengan array of string
  WebWrite('Pulau tinggal: ');
  s := WebReadSelect(sel,['Sumatera','Jawa','Kalimantan','Sulawesi','Papua']);
  WebWriteln;
  // masukan tombol
  WebReadButton(btn,' KIRIM ');
  WebWriteln;
  
  if IsWebInput then
  begin
    // keterangan
    WebWriteln;
    WebWriteln('<b>Data Yg Diterima</b>');
  
    // tampilkan teks memo
    WebWrite('Alamat rumah: ');
    if mmo <> '' then WebWriteln(mmo)
      else WebWriteln('[kosong]');
    
    // uji nilai pilihan ganda
    WebWrite('Warganegara: ');
    if o <> '' then WebWriteln(o) 
      else WebWriteln('[tidak memilih]');
    
    // uji nilai seleksi
    WebWrite('Pulau tinggal: ');
    WebWriteln(s);
    
    // uji nilai tombol
    if btn then WebWriteln('Data tersimpan!')
      else WebWriteln('Data belum tersimpan!');
  end;
  
  WebReadln;
end.
```
**Catatan:** Perhatikan perbedaan perilaku program antara mengeklik tombol `KIRIM` dengan tombol `SUBMIT`.

Keluaran dari contoh program 4 di atas tampak kurang rapi. Ini karena kontrol input langsung menempel pada teks label di sebelahnya. Agar tampilan lebih rapi, semua kontrol input perlu dibuat rata kiri dengan jarak yg sama. Inilah manfaat parameter kedua pada prosedur `WebWrite()` yg bertipe data `integer` untuk memberi jarak terhadap elemen HTML selanjutnya. Contoh program 4 di atas perlu sedikit perubahan agar tata letaknya menjadi lebih rapi.

##### Contoh program 5: Merapikan letak kontrol input.
```pascal
program test_5;

uses webCRT;

const
  w = 120; // lebar untuk teks label

var
  mmo: string;
  opt: integer;
  sel: integer;
  btn: boolean;
  o,s: string;

begin
  Clrscr;
  WebPageHeader('Isian Data');
  
  // masukan memo
  WebWrite('Alamat rumah: ',w);
  WebReadMemo(mmo);
  // masukan pilihan ganda dengan delimited string
  WebWrite('Warganegara: ',w);
  o := WebReadOption(opt,'WNI;WNA',true);
  // masukan pilihan seleksi dengan array of string
  WebWrite('Pulau tinggal: ',w);
  s := WebReadSelect(sel,['Sumatera','Jawa','Kalimantan','Sulawesi','Papua']);
  WebWriteln;
  // garis pemisah
  WebWriteLine(w);
  // masukan tombol
  WebWrite('',w); // jarak kosong sebelah kiri
  WebReadButton(btn,' KIRIM ');
  WebWriteln;
  
  if IsWebInput then
  begin
    // keterangan
    WebWriteln;
    WebWriteln('<b>Data Yg Diterima</b>');
  
    // tampilkan teks memo
    WebWrite('Alamat rumah: ');
    if mmo <> '' then WebWriteln(mmo)
      else WebWriteln('[kosong]');
    
    // uji nilai pilihan ganda
    WebWrite('Warganegara: ');
    if o <> '' then WebWriteln(o) 
      else WebWriteln('[tidak memilih]');
    
    // uji nilai seleksi
    WebWrite('Pulau tinggal: ');
    WebWriteln(s);
    
    // uji nilai tombol
    if btn then WebWriteln('Data tersimpan!')
      else WebWriteln('Data belum tersimpan!');
  end;
  
  WebReadln;
end.
```

Berikut tampilan contoh program 5 di atas di peramban Android:

![WebCRT output on mobile](https://github.com/git-bee/webCRT/blob/patch-1/webcrt_mobile_output.jpg)

## KESIMPULAN

Menggunakan unit WebCRT cukup mudah, hampir tak ada bedanya dengan menulis program *console*. Hanya tinggal menambahkan awalan `Web` pada setiap pemanggilan prosedur `Write/ln()` dan `Read/ln()`. Secara umum, program web yg dibuat menggunakan unit WebCRT terdiri dari 3 bagian, yaitu:

1. Pembuka dan penutup HTML.
    Pembuka ditandai dengan prosedur `Clrscr` atau `OpenHTML` dan penutup ditandai dengan prosedur `WebReadln` atau `CloseHTML`.

2. Laman awal saat belum ada masukan.
    Yaitu semua kode program yg tidak berada dalam pengecekan variabel `IsWebInput` akan selalu langsung ditampilkan di laman HTML yg dikirim.

3. Laman tanggapan setelah ada masukan.
    Yaitu semua kode program yg berada dalam pengecekan variabel `IsWebInput` akan ditampilkan **setelah** ada data yg diterima oleh program.

Atau dalam *pseudocode* dituliskan sebagai berikut:
```pseudo
begin
  open html
  
  print text and input control
  
  if web input ≠ empty then
    print response to input
  
  close html
end
```

Untuk contoh program yg lebih rumit, misalnya penggunaan tabel dan daftar HTML, silakan pelajari program demo yg bisa dicoba di [sini](https://pak.lebah.web.id/webdemo.cgi).

**PERHATIAN:** Pastikan Anda mengunduh kode program WebCRT terbaru karena ada tambahan prosedur yg digunakan dalam contoh program di atas.
