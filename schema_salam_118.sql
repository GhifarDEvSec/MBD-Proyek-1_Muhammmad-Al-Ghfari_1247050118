CREATE SCHEMA SALAM;
    -- Tabel Mahasiswa dengan fitur Double Degree dan SKS
CREATE TABLE mahasiswas (
    nim VARCHAR(20) PRIMARY KEY, 
    nama_lengkap VARCHAR(150) NOT NULL,
    email_kampus VARCHAR(100) UNIQUE NOT NULL, 
    
    -- Atribut Akademik Utama & Double Degree
    prodi_utama VARCHAR(100) NOT NULL,
    is_double_degree BOOLEAN DEFAULT FALSE,
    prodi_kedua VARCHAR(100),
    total_sks_diambil INT DEFAULT 0,
    ipk_sementara NUMERIC(3,2) DEFAULT 0.00,

    -- Check Constraint 1: Logika Double Degree (Jika status aktif, prodi kedua wajib diisi)
    CONSTRAINT chk_double_degree CHECK (
        (is_double_degree = FALSE AND prodi_kedua IS NULL) OR
        (is_double_degree > FALSE AND prodi_kedua IS NOT NULL)
    ),
    
    -- Check Constraint 2: Validasi SKS tidak boleh negatif
    CONSTRAINT chk_sks_valid CHECK (total_sks_diambil >= 0),
    
    -- Check Constraint 3: Validasi rentang IPK akademik (0.00 - 4.00)
    CONSTRAINT chk_ipk_valid CHECK (ipk_sementara >= 0.00 AND ipk_sementara <= 4.00)
);

-- Tabel Mata Kuliah (Pendukung Relasi Akademik)
CREATE TABLE mata_kuliah (
    kode_mk VARCHAR(15) PRIMARY KEY,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT NOT NULL CHECK (sks > 0),
    semester_kurikulum INT NOT NULL CHECK (semester_kurikulum BETWEEN 1 AND 8)
);

-- Tabel Transaksi Studi / KPRS (Relasi Many-to-Many Mahasiswa dan Mata Kuliah)
CREATE TABLE krs_mahasiswa (
    id_krs SERIAL PRIMARY KEY,
    nim VARCHAR(20) NOT NULL,
    kode_mk VARCHAR(15) NOT NULL,
    nilai_huruf VARCHAR(2) DEFAULT 'T',
    
    CONSTRAINT fk_krs_mahasiswa FOREIGN KEY (nim) 
        REFERENCES mahasiswas(nim) ON DELETE CASCADE,
    CONSTRAINT fk_krs_matkul FOREIGN KEY (kode_mk) 
        REFERENCES mata_kuliah(kode_mk) ON DELETE RESTRICT,
    
    -- Mencegah mahasiswa mengambil matkul kembar di semester yang sama
    CONSTRAINT unique_mhs_matkul UNIQUE (nim, kode_mk)
);


-- PEMBUATAN INDEX UNTUK PERFORMA DATABASE

CREATE INDEX idx_mhs_prodi ON mahasiswas(prodi_utama);
CREATE INDEX idx_krs_nim ON krs_mahasiswa(nim);



-- MANAJEMEN USER & ROLE

-- A. Role backend_dev (CRUD semua tabel)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'backend_dev') THEN
        CREATE ROLE backend_dev WITH LOGIN PASSWORD 'backend123';
    END IF;
END $$;
GRANT USAGE ON SCHEMA SALAM TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;

-- B. Role bi_dev (Hanya Read / Select semua tabel)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'bi_dev') THEN
        CREATE ROLE bi_dev WITH LOGIN PASSWORD 'bidev123';
    END IF;
END $$;
GRANT USAGE ON SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;

-- C. Role data_engineer (Hak Akses Penuh: CREATE, MODIFY, DROP, CRUD)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'data_engineer') THEN
        CREATE ROLE data_engineer WITH LOGIN PASSWORD 'de123';
    END IF;
END $$;
GRANT ALL PRIVILEGES ON SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA SALAM TO data_engineer;