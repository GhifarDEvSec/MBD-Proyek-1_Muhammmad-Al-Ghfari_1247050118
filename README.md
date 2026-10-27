# Proyek 1 Manajemen Basis Data: Docker & PostgreSQL RBAC
**Nama:** Al Ghifari 
**NIM:** 1247050118  
**Mata Kuliah:**Manajemen Basis Data

## 1. Setup Kontainer & Konfigurasi Port
Proyek ini menggunakan Docker untuk menjalankan PostgreSQL dan pgAdmin4 dalam satu jaringan internal.
* **PostgreSQL:** Diekspos ke eksternal pada port `22118` (Dapat diakses melalui aplikasi DBeaver).
* **pgAdmin4:** Diekspos pada port `44118` (Dapat diakses melalui browser di `http://localhost:44118`).
* **Akses Internal:** pgAdmin4 terhubung ke PostgreSQL menggunakan nama host `postgres_ghifari` pada port bawaan `5432` di dalam jaringan Docker.

<img width="694" height="549" alt="PGADMIN" src="https://github.com/user-attachments/assets/b010c0ab-16b1-4715-81bf-e5132748e435" />

<img width="476" height="443" alt="DOCKER" src="https://github.com/user-attachments/assets/7aec65e8-640c-4586-b934-9a9daf1df80a" />

*Keterangan: Bukti akses PostgreSQL dari internal Docker menggunakan pgAdmin4.*

## 2. Pembuatan Skema dan Tabel
Skema database dibuat dengan nama `SALAM`. Di dalamnya terdapat tabel `mahasiswas` yang mengimplementasikan fitur pembeda (*Double Degree* dan pencatatan akademik) dengan aturan berikut:
* **Primary Key:** `nim`
* **Unique Constraint:** `email_kampus`
* **Check Constraint:** Memastikan logika *Double Degree* (Jika status aktif, prodi kedua wajib diisi) dan validasi nilai SKS.

### Bukti Constraint Bekerja

<img width="1232" height="681" alt="bukti admin" src="https://github.com/user-attachments/assets/0c90cb48-3d50-4f8a-969a-778db474e12b" />

*Keterangan: Sistem berhasil menolak *insert* data mahasiswa yang berstatus Double Degree (TRUE) namun prodi keduanya dikosongkan (NULL).*

## 3. Role-Based Access Control (RBAC) & Pembuktian Aturan
Tiga *user/role* baru telah dibuat dengan batasan hak akses yang berbeda-beda. Berikut adalah pembuktian bahwa aturan masing-masing *role* berfungsi:

### A. Role: `backend_dev` (CRUD Semua Tabel)

<img width="839" height="681" alt="backend" src="https://github.com/user-attachments/assets/20a3ddef-b08a-4ca1-82ad-bc98168e50b1" />

* **Deskripsi:** Role ini memiliki hak akses untuk Create, Read, Update, dan Delete data. Pada gambar di atas, `backend_dev` berhasil melakukan eksekusi `UPDATE` pada data SKS mahasiswa, membuktikan hak akses manipulasi datanya berfungsi dengan baik.

### B. Role: `bi_dev` (Hanya Read/Select)

<img width="1237" height="476" alt="bi" src="https://github.com/user-attachments/assets/a847af48-46cb-49c0-bb34-52ed9eee840b" />

* **Deskripsi:** Role ini dibatasi hanya untuk membaca (*Select*) data. Pada gambar di atas, sistem menolak keras (`Permission denied`) ketika `bi_dev` mencoba mengeksekusi perintah `DELETE` pada tabel `mahasiswas`. Aturan keamanan berhasil diterapkan.

### C. Role: `data_engineer` (Hak Akses Penuh / ALL PRIVILEGES)

<img width="1194" height="440" alt="data engineer" src="https://github.com/user-attachments/assets/337a3651-bcce-4b05-8d5b-80da1dc8a98d" />

* **Deskripsi:** Role ini merupakan kasta tertinggi yang dapat memodifikasi struktur database.
*  Pada gambar di atas, `data_engineer` berhasil mengeksekusi DDL `CREATE TABLE` untuk membuat tabel log riwayat baru di dalam skema `SALAM`.

**Lampiran Dokumentasi** 
<img width="1920" height="1026" alt="SCHEMA PGADMIN" src="https://github.com/user-attachments/assets/d3398d21-5da8-4377-89ad-ebfc11678e2b" />

<img width="1920" height="1026" alt="PGADMIN ADA TABLE" src="https://github.com/user-attachments/assets/57f871ec-64e2-43dc-ac9a-6106a9a94756" />

<img width="418" height="462" alt="ROLES" src="https://github.com/user-attachments/assets/296dde6a-e575-4243-938d-86232e4b1a06" />



![ERD PDM](PDM.png)
*Keterangan: Physical Data Model (PDM) dari skema SALAM yang menghubungkan entitas mahasiswa dan mata kuliah melalui tabel transaksi akademik.*
