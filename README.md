<div align="center">

# 🥭 AKIBAT MENCURI

### *Animasi Dakwah Islami*

**"Carilah rezeki yang halal & berkah"**

Sebuah film animasi pendek interaktif yang mengangkat kisah pertaubatan
seorang anak desa — dibangun sepenuhnya dari kode, tanpa satu pun gambar raster.

<br>

![Processing](https://img.shields.io/badge/Processing-Java%20Mode-006699?style=for-the-badge&logo=processingfoundation&logoColor=white)
![Genre](https://img.shields.io/badge/Genre-Dakwah%20Islami-2E7C3A?style=for-the-badge)
![Durasi](https://img.shields.io/badge/Durasi-%C2%B15%20menit-orange?style=for-the-badge)
![Resolusi](https://img.shields.io/badge/Kanvas-1280%C3%97720-blueviolet?style=for-the-badge)

**🎓 Informatics EXPO UII 2026 — Grafika & Multimedia**
**oleh TIM Stickmation**

</div>

---

## 🎬 Tentang Proyek Ini

**Akibat Mencuri** adalah animasi 2D bergaya *stick figure* yang dibuat sepenuhnya
menggunakan **Processing (Java Mode)**. Yang membuatnya istimewa: **tidak ada satu pun
file gambar (`.png`/`.jpg`) yang dipakai.** Seluruh tokoh, pemandangan pedesaan, masjid,
matahari, awan, hewan, hingga langit senja — semuanya **digambar secara prosedural lewat
kode** menggunakan bentuk dasar (garis, elips, kurva) yang dipadukan dengan **transformasi
geometri** (translasi, rotasi, dan dilatasi/zoom).

Animasi ini berjalan otomatis selama ±5 menit, lengkap dengan **dubbing suara**,
**backsound tiap adegan**, dan **efek suara hewan**, lalu berulang dengan sendirinya —
cocok untuk diputar sebagai *looping showcase* di stan pameran.

---

## 📖 Ceritanya Tentang Apa?

Kisah tentang **Rangga**, seorang anak desa yang punya kebiasaan buruk: mengambil barang
yang bukan miliknya. Cerita mengalir melalui **5 adegan** di pedesaan yang asri:

| # | 📍 Lokasi | 🎞️ Adegan |
|---|-----------|-----------|
| 1 | 🥭 **Kebun Mangga Pak Budi** | Rangga tergoda mencuri mangga, lalu tertangkap basah dan kabur. |
| 2 | 🏪 **Warung Desa** | Karena lapar, ia diam-diam mengambil dagangan — nyaris ketahuan seekor kucing. |
| 3 | 🐔 **Halaman Rumah Warga** | Ia mencoba mencuri ayam, gagal, dan mulai merasa hatinya **tidak pernah tenang**. |
| 4 | 🌇 **Jalan Desa (sore)** | Bertemu **Pak Ustad**. Dengan wajah gelisah, Rangga mengakui kesalahannya. |
| 5 | 🕌 **Depan Masjid (senja)** | Pak Ustad menuntunnya bertaubat. Rangga menyesal, dan **Pak Budi datang memaafkannya**. |

Cerita ditutup dengan **layar penutup malam berbintang** berisi pesan moral dan *end credits*
yang bergulir naik.

---

## 💡 Pesan Moral

> ### *"Mencuri merugikan diri & orang lain. Carilah rezeki yang halal."*

- 🤲 **Mencuri itu haram** — Allah melarang memakan harta sesama dengan jalan yang batil.
- 🌾 **Rezeki halal, meski sedikit, jauh lebih berkah** daripada banyak harta hasil mencuri.
- 😟 **Perbuatan buruk membuat hati gelisah** — Rangga selalu deg-degan setiap mengambil yang bukan haknya.
- 🚪 **Pintu taubat selalu terbuka** — kembalikan hak orang lain, minta maaf, dan bekerja dengan jujur.
- 🤝 **Memaafkan itu mulia** — Pak Budi menerima taubat Rangga dan mengajak memperbaiki keadaan bersama.

---

## ✨ Sorotan Teknis (Grafika & Multimedia)

- 🎨 **100% *procedural art*** — nol gambar raster; semua digambar dari primitif Processing.
- 🔄 **Transformasi geometri** — rotasi sinar matahari & ornamen bintang, dilatasi (zoom) di klimaks adegan masjid.
- 🌅 **Latar dinamis** — langit bergradasi dari pagi → sore → senja → malam berbintang, lengkap dengan awan, burung, dan kabut.
- 🚶 **Sistem karakter** — tokoh punya state `IDLE / WALK / RUN`, arah hadap, dan aksi (membawa barang, sedih).
- 💬 **Sistem dialog** — balon percakapan muncul terjadwal per detik, tersinkron dengan dubbing.
- 🔊 **Audio berlapis** — backsound per adegan + dubbing tiap tokoh + SFX hewan, dengan manajemen suara agar tidak "bocor" antar-adegan.
- 🎞️ **Transisi sinematik** — *fade* antar-adegan, intro judul beranimasi, dan *end credits* bergulir.
- ⏱️ **Berjalan & berulang otomatis** — ideal untuk *looping* tanpa pengawasan di stan pameran.

---

## 🚀 Cara Install & Menjalankan

### 1. Prasyarat
- **[Processing IDE](https://processing.org/download)** (versi 3.x atau 4.x) — mode **Java**.
- Library **Sound** (untuk audio).

### 2. Pasang Library Sound
Di Processing IDE:
```
Sketch  →  Import Library...  →  Manage Libraries...
```
Cari **"Sound"** (oleh The Processing Foundation), lalu klik **Install**.

### 3. Buka & Jalankan
1. **Clone** atau unduh repositori ini:
   ```bash
   git clone <url-repositori-ini>
   ```
2. Buka file **`Animasi_Akibat_Mencuri.pde`** dengan Processing.
   > ⚠️ Pastikan **seluruh file `.pde`** dan folder **`data/`** berada di dalam satu folder bernama `Animasi_Akibat_Mencuri`. Processing memuat semua tab `.pde` dalam folder yang sama secara otomatis.
3. Tekan tombol **▶ Run** (atau `Ctrl + R`).

Jendela animasi berukuran **1280 × 720** akan terbuka dan langsung memutar intro → 5 adegan → penutup, lalu **berulang dengan sendirinya**.

---

## 🎮 Kontrol (Interaktif)

Berguna saat presentasi atau demo di stan pameran:

| Tombol | Fungsi |
|:------:|--------|
| `Spasi` / `Enter` / `Klik` | Lewati intro, langsung mulai cerita |
| `1` – `5` | Loncat ke adegan tertentu |
| `←` / `→` | Geser ke adegan sebelumnya / berikutnya |
| `0` | Ulang dari awal |
| `P` | Jeda / lanjut (pause) |
| `D` | Tampilkan info debug (nomor adegan, waktu, durasi) |

---

## 📁 Struktur Proyek

```
Animasi_Akibat_Mencuri/
├── Animasi_Akibat_Mencuri.pde   # File utama: setup, draw, palet, kontrol
├── SceneManager.pde             # Pengatur alur, waktu & transisi antar-adegan
├── Scenes.pde                   # Isi 5 adegan, dialog, intro & layar penutup
├── Character.pde                # Kelas tokoh (Rangga, Pak Budi, Pak Ustad)
├── Environment.pde              # Pohon, rumah, masjid, langit, matahari, dll.
├── Animals.pde                  # Ayam & kucing beranimasi
├── SpeechBubble.pde             # Balon dialog
├── Sound.pde                    # Manajemen musik, dubbing & efek suara
└── data/
    ├── music/                   # Backsound intro, outro & scene 1–5
    ├── dialog/                  # Dubbing: Rangga, Pak Budi, Pak Ustad
    └── sfx/                     # Suara ayam & kucing
```

---

## 👥 TIM Stickmation

| Nama | Peran |
|------|-------|
| **Luqman Hakim Ar-Razi** | Programmer & Animator · Pembuat Cerita & Dokumentasi |
| **Muhammad Farid Bin Junardi** | Pengisi Suara (Rangga) · Penyusun Laporan & Dokumentasi |
| **M. Bintang Satriaji Egidia** | Pengisi Suara (Pak Ustad) |
| **Muhammad Farhan Yusuf Azizi** | Pengisi Suara (Pak Budi) |
| **Muh. Syarif Hidayatullah** | Penyusun Laporan & Dokumentasi |

---

<div align="center">

### 🕌 Terima Kasih

*Dibuat untuk memenuhi Tugas Besar mata kuliah **Grafika & Multimedia***
*serta dipamerkan pada **Informatics EXPO UII 2026***

**"Rezeki halal, meski sedikit, jauh lebih berkah.
Pintu taubat selalu terbuka bagi yang mau memperbaiki diri."**

</div>
