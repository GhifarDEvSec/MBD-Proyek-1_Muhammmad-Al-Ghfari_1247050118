<div align="center">
  <h2><b>PROYEK 1 MANAJEMEN BASIS DATA</b></h2>
</div>
<br>
<p>
  <b>Disusun Oleh:</b><br>
  Muhammad Al Ghifari Gunawan<br>
  NIM: 1247050118<br>
  Mata Kuliah: Manajemen Basis Data
</p>

## I. Setup Kontainer & Konfigurasi Port

Proyek ini menggunakan infrastruktur Docker untuk menjalankan PostgreSQL dan pgAdmin4 dalam satu jaringan internal yang terisolasi.

*   **PostgreSQL:** Terekspos ke eksternal pada port `22118` (diakses melalui DBeaver).
*   **pgAdmin4:** Terekspos ke eksternal pada port `44118` (diakses melalui `http://localhost:44118`).
*   **Koneksi Internal:** pgAdmin4 berkomunikasi langsung dengan PostgreSQL menggunakan host `postgres_ghifari` pada port bawaan `5432` di dalam jaringan internal Docker.

<p align="center">
  <img src="https://github.com/user-attachments/assets/b010c0ab-16b1-4715-81bf-e5132748e435" alt="PGADMIN" width="600"><br><br>
  <img src="https://github.com/user-attachments/assets/7aec65e8-640c-4586-b934-9a9daf1df80a" alt="DOCKER" width="500"><br>
  <i><b>Gambar 1.</b> Status container Docker berjalan dan bukti akses PostgreSQL dari internal Docker menggunakan pgAdmin.</i>
</p>

---

## II. Pembuatan Skema dan Tabel

Skema database didefinisikan dengan nama `SALAM`, yang menaungi tabel `mahasiswas`. **Sebagai fitur pembeda utama dari rancangan mahasiswa lain, tabel ini mengimplementasikan logika pencatatan *Double Degree* khusus.** Struktur ini dikawal oleh batasan (*constraints*) yang ketat:

*   **Primary Key:** Atribut `nim`.
*   **Unique Constraint:** Atribut `email_kampus` untuk mencegah duplikasi data.
*   **Check Constraint (Fitur Pembeda):** Validasi logika *Double Degree* yang mewajibkan pengisian entitas Program Studi kedua jika mahasiswa berstatus *Double Degree* (`TRUE`), serta validasi batas nilai SKS.

<p align="center">
  <img src="https://github.com/user-attachments/assets/0c90cb48-3d50-4f8a-969a-778db474e12b" alt="Bukti Admin" width="800"><br>
  <i><b>Gambar 2. (Bukti Constraint)</b> Sistem berhasil memblokir/menolak eksekusi insert data Double Degree (TRUE) yang entitas prodi keduanya dikosongkan (NULL).</i>
</p>

---

## III. Role-Based Access Control (RBAC)

Implementasi keamanan database dilakukan dengan membagi hak akses ke dalam tiga tingkatan pengguna (*roles*):

### A. Role: `backend_dev` (Hak Akses Manipulasi Data / CRUD)
<p align="center">
  <img src="https://github.com/user-attachments/assets/20a3ddef-b08a-4ca1-82ad-bc98168e50b1" alt="Backend Dev" width="700"><br>
  <i><b>Gambar 3.</b> Eksekusi UPDATE SKS berhasil dilakukan. Role ini terbukti berfungsi dengan baik untuk manipulasi data (Create, Read, Update, Delete).</i>
</p>

### B. Role: `bi_dev` (Hak Akses Read-Only)
<p align="center">
  <img src="https://github.com/user-attachments/assets/a847af48-46cb-49c0-bb34-52ed9eee840b" alt="BI Dev" width="800"><br>
  <i><b>Gambar 4.</b> Sistem menolak keras eksekusi DELETE (Permission denied). Aturan Read-Only berhasil mencegah manipulasi data secara mutlak.</i>
</p>

### C. Role: `data_engineer` (Hak Akses Penuh / ALL PRIVILEGES)
<p align="center">
  <img src="https://github.com/user-attachments/assets/337a3651-bcce-4b05-8d5b-80da1dc8a98d" alt="Data Engineer" width="800"><br>
  <i><b>Gambar 5.</b> Eksekusi DDL (CREATE TABLE) berhasil. Role ini terbukti memiliki hak akses tertinggi untuk memodifikasi struktur sistem database.</i>
</p>

---

## IV. Lampiran Dokumentasi

<p align="center">
  <img src="https://github.com/user-attachments/assets/296dde6a-e575-4243-938d-86232e4b1a06" alt="Roles" width="300"><br>
  <i><b>Lampiran 1.</b> Daftar hierarki User/Roles yang telah dibuat pada sistem.</i>
</p>
<br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d3398d21-5da8-4377-89ad-ebfc11678e2b" alt="Schema pgAdmin" width="800"><br>
  <i><b>Lampiran 2.</b> Struktur Skema SALAM di dalam environment pgAdmin4.</i>
</p>
<br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/57f871ec-64e2-43dc-ac9a-6106a9a94756" alt="pgAdmin Ada Table" width="800"><br>
  <i><b>Lampiran 3.</b> Tampilan isi data pada tabel mahasiswas yang diakses melalui pgAdmin4.</i>
</p>
<br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/a55ea877-69be-4894-bda1-42cab722ccad" alt="PDM" width="800"><br>
  <i><b>Lampiran 4.</b> Physical Data Model (PDM) yang merepresentasikan relasi entitas akademik.</i>
</p>
