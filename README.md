# Proyek 1 Manajemen Basis Data: Docker & PostgreSQL RBAC
**Nama:** Al Ghifari  
**NIM:** 1247050118  
**Mata Kuliah:** Manajemen Basis Data  

## 1. Setup Kontainer & Konfigurasi Port
- **PostgreSQL:** Port eksternal `22118` (via DBeaver).
- **pgAdmin4:** Port eksternal `44118` (via `http://localhost:44118`).
- **Akses Internal:** pgAdmin4 terhubung ke PostgreSQL via host `postgres_ghifari` di port `5432` (internal Docker).

<img width="694" height="549" alt="PGADMIN" src="https://github.com/user-attachments/assets/b010c0ab-16b1-4715-81bf-e5132748e435" />
<img width="476" height="443" alt="DOCKER" src="https://github.com/user-attachments/assets/7aec65e8-640c-4586-b934-9a9daf1df80a" />

*Status container Docker berjalan dan bukti akses PostgreSQL dari internal Docker menggunakan pgAdmin.*

## 2. Pembuatan Skema dan Tabel
Skema `SALAM` dengan tabel `mahasiswas`. Aturan yang diterapkan:
- **Primary Key:** `nim`
- **Unique Constraint:** `email_kampus`
- **Check Constraint:** Validasi SKS dan kewajiban mengisi prodi kedua jika status *Double Degree* = TRUE.

### Bukti Constraint Bekerja
<img width="1232" height="681" alt="bukti admin" src="https://github.com/user-attachments/assets/0c90cb48-3d50-4f8a-969a-778db474e12b" />

*Sistem menolak insert data Double Degree (TRUE) dengan prodi kedua kosong (NULL).*

## 3. Role-Based Access Control (RBAC)

### A. `backend_dev` (CRUD)
<img width="839" height="681" alt="backend" src="https://github.com/user-attachments/assets/20a3ddef-b08a-4ca1-82ad-bc98168e50b1" />

- Hak akses manipulasi data berfungsi. Eksekusi `UPDATE` SKS berhasil dilakukan.

### B. `bi_dev` (Read/Select Only)
<img width="1237" height="476" alt="bi" src="https://github.com/user-attachments/assets/a847af48-46cb-49c0-bb34-52ed9eee840b" />

- Sistem menolak eksekusi `DELETE` (`Permission denied`). Aturan *Read-Only* berhasil diterapkan.

### C. `data_engineer` (ALL PRIVILEGES)
<img width="1194" height="440" alt="data engineer" src="https://github.com/user-attachments/assets/337a3651-bcce-4b05-8d5b-80da1dc8a98d" />

- Hak akses penuh terbukti. Role berhasil mengeksekusi DDL `CREATE TABLE`.

## 4. Lampiran Dokumentasi

<img width="1920" height="1026" alt="SCHEMA PGADMIN" src="https://github.com/user-attachments/assets/d3398d21-5da8-4377-89ad-ebfc11678e2b" />
*Struktur Skema SALAM di pgAdmin.*

<img width="1920" height="1026" alt="PGADMIN ADA TABLE" src="https://github.com/user-attachments/assets/57f871ec-64e2-43dc-ac9a-6106a9a94756" />
*Tabel mahasiswas beserta datanya di dalam pgAdmin.*

<img width="418" height="462" alt="ROLES" src="https://github.com/user-attachments/assets/296dde6a-e575-4243-938d-86232e4b1a06" />
*Daftar User/Roles di database.*

<img width="1920" height="998" alt="PDM" src="https://github.com/user-attachments/assets/a55ea877-69be-4894-bda1-42cab722ccad" />
*Physical Data Model (PDM) yang menghubungkan entitas akademik.*
