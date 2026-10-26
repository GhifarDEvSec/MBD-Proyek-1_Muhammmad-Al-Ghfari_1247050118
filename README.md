# Proyek 1 Manajemen Basis Data: Docker & PostgreSQL RBAC
**Nama:** Muhammad Al Ghifari Gunawan  
**NIM:** 1247050118  
**Kelas:** [Isi Kelas Anda]  

## 1. Setup Kontainer & Konfigurasi Port
Proyek ini menggunakan Docker untuk menjalankan PostgreSQL dan pgAdmin4 dalam satu jaringan internal.
* **PostgreSQL:** Diekspos ke eksternal pada port `22118` (Dapat diakses melalui aplikasi DBeaver).
* **pgAdmin4:** Diekspos pada port `44118` (Dapat diakses melalui browser di `http://localhost:44118`).
* **Akses Internal:** pgAdmin4 terhubung ke PostgreSQL menggunakan nama host `postgres_ghifari` pada port bawaan `5432` di dalam jaringan Docker.

![Bukti PGAdmin](PGADMIN.png)
*Keterangan: Bukti akses PostgreSQL dari internal Docker menggunakan pgAdmin4.*

## 2. Pembuatan Skema dan Tabel
Skema database dibuat dengan nama `SALAM`. Di dalamnya terdapat tabel `mahasiswas` yang mengimplementasikan fitur pembeda (*Double Degree* dan pencatatan akademik) dengan aturan berikut:
* **Primary Key:** `nim`
* **Unique Constraint:** `email_kampus`
* **Check Constraint:** Memastikan logika *Double Degree* (Jika status aktif, prodi kedua wajib diisi) dan validasi nilai SKS.

### Bukti Constraint Bekerja
![Bukti Constraint](bukti_admin.png) 
*Keterangan: Sistem berhasil menolak *insert* data mahasiswa yang berstatus Double Degree (TRUE) namun prodi keduanya dikosongkan (NULL).*

## 3. Role-Based Access Control (RBAC) & Pembuktian Aturan
Tiga *user/role* baru telah dibuat dengan batasan hak akses yang berbeda-beda. Berikut adalah pembuktian bahwa aturan masing-masing *role* berfungsi:

### A. Role: `backend_dev` (CRUD Semua Tabel)
![Bukti Backend Dev](backend.png)
* **Deskripsi:** Role ini memiliki hak akses untuk Create, Read, Update, dan Delete data. Pada gambar di atas, `backend_dev` berhasil melakukan eksekusi `UPDATE` pada data SKS mahasiswa, membuktikan hak akses manipulasi datanya berfungsi dengan baik.

### B. Role: `bi_dev` (Hanya Read/Select)
![Bukti BI Dev](bi.png)
* **Deskripsi:** Role ini dibatasi hanya untuk membaca (*Select*) data. Pada gambar di atas, sistem menolak keras (`Permission denied`) ketika `bi_dev` mencoba mengeksekusi perintah `DELETE` pada tabel `mahasiswas`. Aturan keamanan berhasil diterapkan.

### C. Role: `data_engineer` (Hak Akses Penuh / ALL PRIVILEGES)
![Bukti Data Engineer](data_engineer.png)
* **Deskripsi:** Role ini merupakan kasta tertinggi yang dapat memodifikasi struktur database. Pada gambar di atas, `data_engineer` berhasil mengeksekusi DDL `CREATE TABLE` untuk membuat tabel log riwayat baru di dalam skema `SALAM`.

## 4. Entity Relationship Diagram (ERD)
![ERD PDM](PDM.png)
*Keterangan: Physical Data Model (PDM) dari skema SALAM yang menghubungkan entitas mahasiswa dan mata kuliah melalui tabel transaksi akademik.*
