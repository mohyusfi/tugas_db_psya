-- ============================================================================
-- TUGAS PERTEMUAN 9 - BASIS DATA (MYSQL CONSOLE)
-- NAMA    : MOH YUSFI LAKHAFIDUN
-- STAMBUK : F5512520089
-- ============================================================================
-- FORMAT NAMA DATABASE: Stambuk_namadatabase
-- 1. F5512520089_tokoonline
-- 2. F5512520089_rumahsakit
-- 3. F5512520089_akademik
-- ============================================================================


-- ============================================================================
-- BAGIAN 1: PEMBUATAN DATABASE 1 & 5 TABEL BESERTA RELASINYA
-- NAMA DATABASE: F5512520089_tokoonline
-- ============================================================================

DROP DATABASE IF EXISTS F5512520089_tokoonline;
CREATE DATABASE F5512520089_tokoonline;
USE F5512520089_tokoonline;


-- Tabel 1.1: kategori_produk (Entitas Induk Kategori)
CREATE TABLE kategori_produk (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi TEXT
) ENGINE=InnoDB;

-- Tabel 1.2: produk (Relasi Many-to-One dengan kategori_produk)
-- Relasi: Satu kategori bisa memiliki banyak produk (1:N)
CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT PRIMARY KEY,
    nama_produk VARCHAR(150) NOT NULL,
    id_kategori INT NOT NULL,
    harga DECIMAL(12, 2) NOT NULL,

    stok INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_produk_kategori 
        FOREIGN KEY (id_kategori) REFERENCES kategori_produk(id_kategori)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabel 1.3: pelanggan (Entitas Data Pelanggan)
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama_lengkap VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    no_hp VARCHAR(20),
    alamat TEXT
) ENGINE=InnoDB;

-- Tabel 1.4: pesanan (Relasi Many-to-One dengan pelanggan)
-- Relasi: Satu pelanggan dapat membuat banyak pesanan (1:N)
CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT PRIMARY KEY,
    tgl_pesanan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_pelanggan INT NOT NULL,
    total_bayar DECIMAL(12, 2) NOT NULL DEFAULT 0,
    status_pesanan ENUM('Menunggu', 'Diproses', 'Dikirim', 'Selesai', 'Batal') DEFAULT 'Menunggu',
    CONSTRAINT fk_pesanan_pelanggan 
        FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabel 1.5: detail_pesanan (Jembatan relasi Many-to-Many antara pesanan dan produk)
-- Relasi: Satu pesanan berisi banyak item produk, satu produk bisa di banyak pesanan (N:M)
CREATE TABLE detail_pesanan (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    kuantitas INT NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_detail_pesanan 
        FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_produk 
        FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Verifikasi tabel Database 1
SHOW TABLES;


-- ============================================================================
-- BAGIAN 2: PEMBUATAN DATABASE 2 & 5 TABEL BESERTA RELASINYA
-- NAMA DATABASE: F5512520089_rumahsakit
-- (TIDAK ADA NAMA TABEL YANG SAMA DENGAN DATABASE LAIN)
-- ============================================================================

DROP DATABASE IF EXISTS F5512520089_rumahsakit;
CREATE DATABASE F5512520089_rumahsakit;
USE F5512520089_rumahsakit;

-- Tabel 2.1: spesialisasi_dokter (Entitas Induk Spesialisasi)
CREATE TABLE spesialisasi_dokter (
    id_spesialisasi INT AUTO_INCREMENT PRIMARY KEY,
    nama_spesialisasi VARCHAR(100) NOT NULL,
    gedung_praktek VARCHAR(50)
) ENGINE=InnoDB;

-- Tabel 2.2: dokter (Relasi Many-to-One dengan spesialisasi_dokter)
-- Relasi: Satu bidang spesialisasi dapat dinaungi oleh banyak dokter (1:N)
CREATE TABLE dokter (
    id_dokter INT AUTO_INCREMENT PRIMARY KEY,
    nama_dokter VARCHAR(150) NOT NULL,
    id_spesialisasi INT NOT NULL,
    no_sip VARCHAR(50) NOT NULL UNIQUE,
    tarif_konsultasi DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_dokter_spesialisasi 
        FOREIGN KEY (id_spesialisasi) REFERENCES spesialisasi_dokter(id_spesialisasi)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabel 2.3: pasien (Entitas Data Pasien)
CREATE TABLE pasien (
    id_pasien INT AUTO_INCREMENT PRIMARY KEY,
    nama_pasien VARCHAR(150) NOT NULL,
    tgl_lahir DATE NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    gol_darah ENUM('A', 'B', 'AB', 'O')
) ENGINE=InnoDB;

-- Tabel 2.4: rekam_medis (Relasi dengan pasien dan dokter)
-- Relasi: Satu pasien bisa memiliki banyak riwayat pemeriksaan oleh dokter (1:N)
CREATE TABLE rekam_medis (
    id_rekam INT AUTO_INCREMENT PRIMARY KEY,
    tgl_pemeriksaan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_pasien INT NOT NULL,
    id_dokter INT NOT NULL,
    keluhan TEXT NOT NULL,
    diagnosa TEXT NOT NULL,
    CONSTRAINT fk_rekam_pasien 
        FOREIGN KEY (id_pasien) REFERENCES pasien(id_pasien)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_rekam_dokter 
        FOREIGN KEY (id_dokter) REFERENCES dokter(id_dokter)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabel 2.5: resep_obat (Relasi One-to-Many dengan rekam_medis)
-- Relasi: Satu hasil rekam medis dapat mencakup pemberian beberapa resep obat (1:N)
CREATE TABLE resep_obat (
    id_resep INT AUTO_INCREMENT PRIMARY KEY,
    id_rekam INT NOT NULL,
    nama_obat VARCHAR(100) NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    aturan_pakai VARCHAR(100) NOT NULL,
    CONSTRAINT fk_resep_rekam 
        FOREIGN KEY (id_rekam) REFERENCES rekam_medis(id_rekam)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Verifikasi tabel Database 2
SHOW TABLES;


-- ============================================================================
-- BAGIAN 3: PEMBUATAN DATABASE 3 & 5 TABEL BESERTA RELASINYA
-- NAMA DATABASE: F5512520089_akademik
-- (TIDAK ADA NAMA TABEL YANG SAMA DENGAN DATABASE LAIN)
-- ============================================================================

DROP DATABASE IF EXISTS F5512520089_akademik;
CREATE DATABASE F5512520089_akademik;
USE F5512520089_akademik;

-- Tabel 3.1: fakultas (Entitas Induk Fakultas)
CREATE TABLE fakultas (
    id_fakultas INT AUTO_INCREMENT PRIMARY KEY,
    nama_fakultas VARCHAR(100) NOT NULL,
    nama_dekan VARCHAR(150)
) ENGINE=InnoDB;

-- Tabel 3.2: program_studi (Relasi Many-to-One dengan fakultas)
-- Relasi: Satu fakultas membawahi banyak program studi (1:N)
CREATE TABLE program_studi (
    id_prodi INT AUTO_INCREMENT PRIMARY KEY,
    nama_prodi VARCHAR(100) NOT NULL,
    id_fakultas INT NOT NULL,
    jenjang ENUM('D3', 'S1', 'S2', 'S3') DEFAULT 'S1',
    akreditasi VARCHAR(5) DEFAULT 'A',
    CONSTRAINT fk_prodi_fakultas 
        FOREIGN KEY (id_fakultas) REFERENCES fakultas(id_fakultas)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabel 3.3: dosen (Relasi Many-to-One dengan program_studi)
-- Relasi: Satu program studi menjadi homebase banyak dosen (1:N)
CREATE TABLE dosen (
    id_dosen INT AUTO_INCREMENT PRIMARY KEY,
    nidn VARCHAR(20) NOT NULL UNIQUE,
    nama_dosen VARCHAR(150) NOT NULL,
    id_prodi INT NOT NULL,
    email_kampus VARCHAR(100),
    CONSTRAINT fk_dosen_prodi 
        FOREIGN KEY (id_prodi) REFERENCES program_studi(id_prodi)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabel 3.4: mata_kuliah (Entitas Data Mata Kuliah)
CREATE TABLE mata_kuliah (
    id_mk INT AUTO_INCREMENT PRIMARY KEY,
    kode_mk VARCHAR(15) NOT NULL UNIQUE,
    nama_mk VARCHAR(150) NOT NULL,
    sks INT NOT NULL,
    semester INT NOT NULL
) ENGINE=InnoDB;

-- Tabel 3.5: rencana_studi (Relasi antara program studi, mata kuliah, dan dosen pengampu)
-- Relasi: Mengatur penawaran mata kuliah oleh prodi yang diampu dosen pada semester tertentu
CREATE TABLE rencana_studi (
    id_krs INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(10) NOT NULL,
    id_prodi INT NOT NULL,
    id_mk INT NOT NULL,
    id_dosen INT NOT NULL,
    kelas VARCHAR(5) NOT NULL,
    CONSTRAINT fk_krs_prodi 
        FOREIGN KEY (id_prodi) REFERENCES program_studi(id_prodi)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_krs_mk 
        FOREIGN KEY (id_mk) REFERENCES mata_kuliah(id_mk)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_krs_dosen 
        FOREIGN KEY (id_dosen) REFERENCES dosen(id_dosen)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Verifikasi tabel Database 3
SHOW TABLES;


-- ============================================================================
-- BAGIAN 4: PEMBUATAN 4 USER DENGAN HAK AKSES BERBEDA
-- 1 Sebagai Administrator (Super Admin)
-- 3 Sebagai Admin Pengelola pada masing-masing database
-- ============================================================================

-- Bersihkan user jika sebelumnya sudah ada
DROP USER IF EXISTS 'super_admin'@'localhost';
DROP USER IF EXISTS 'admin_toko'@'localhost';
DROP USER IF EXISTS 'admin_rs'@'localhost';
DROP USER IF EXISTS 'admin_akademik'@'localhost';

-- 4.1 Buat User 1: Administrator (Super Admin - Akses Semua Database)
CREATE USER 'super_admin'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON *.* TO 'super_admin'@'localhost' WITH GRANT OPTION;

-- 4.2 Buat User 2: Admin Pengelola Database 1 (Toko Online)
CREATE USER 'admin_toko'@'localhost' IDENTIFIED BY 'TokoPass123!';
GRANT ALL PRIVILEGES ON F5512520089_tokoonline.* TO 'admin_toko'@'localhost';

-- 4.3 Buat User 3: Admin Pengelola Database 2 (Rumah Sakit)
CREATE USER 'admin_rs'@'localhost' IDENTIFIED BY 'RsPass123!';
GRANT ALL PRIVILEGES ON F5512520089_rumahsakit.* TO 'admin_rs'@'localhost';

-- 4.4 Buat User 4: Admin Pengelola Database 3 (Akademik)
CREATE USER 'admin_akademik'@'localhost' IDENTIFIED BY 'AkadPass123!';
GRANT ALL PRIVILEGES ON F5512520089_akademik.* TO 'admin_akademik'@'localhost';

-- Terapkan perubahan hak akses
FLUSH PRIVILEGES;

-- Cek hak akses masing-masing user (Screenshot Console)
SHOW GRANTS FOR 'super_admin'@'localhost';
SHOW GRANTS FOR 'admin_toko'@'localhost';
SHOW GRANTS FOR 'admin_rs'@'localhost';
SHOW GRANTS FOR 'admin_akademik'@'localhost';


-- ============================================================================
-- BAGIAN 5: SIMULASI PENCABUTAN IZIN AKSES 1 USER MENJADI READ ONLY
-- User Target: 'admin_toko'@'localhost'
-- ============================================================================

-- Langkah 5.1: Cek hak akses awal user admin_toko
SHOW GRANTS FOR 'admin_toko'@'localhost';

-- Langkah 5.2: Cabut seluruh hak akses yang ada pada database toko online
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_toko'@'localhost';

-- Langkah 5.3: Berikan HANYA izin membaca data (SELECT / Read Only)
GRANT SELECT ON F5512520089_tokoonline.* TO 'admin_toko'@'localhost';

-- Terapkan perubahan
FLUSH PRIVILEGES;

-- Langkah 5.4: Verifikasi hak akses baru (Pastikan hanya SELECT yang tampil)
SHOW GRANTS FOR 'admin_toko'@'localhost';

-- Uji simulasi (Jalankan query ini jika login sebagai admin_toko):
-- 1. SELECT (BERHASIL - Karena Read Only):
--    SELECT * FROM F5512520089_tokoonline.pelanggan;
-- 2. INSERT / DROP / UPDATE (DITOLAK / ERROR 1142):
--    INSERT INTO F5512520089_tokoonline.pelanggan (nama_lengkap, email) VALUES ('Budi', 'budi@mail.com');
--    -- Output: ERROR 1142 (42000): INSERT command denied to user 'admin_toko'@'localhost' for table 'pelanggan'


-- ============================================================================
-- BAGIAN 6: PENAMBAHAN 1 KOLOM DAN DILETAKKAN SETELAH KOLOM KE-2
-- Target Tabel : tabel 'pelanggan' pada database 'F5512520089_tokoonline'
-- Struktur Awal:
-- 1. id_pelanggan
-- 2. nama_lengkap
-- 3. email
-- 4. no_hp
-- 5. alamat
-- Aksi         : Menambahkan kolom 'nomor_identitas' persis SETELAH 'nama_lengkap' (kolom ke-2)
-- ============================================================================

USE F5512520089_tokoonline;

-- Langkah 6.1: Tampilkan struktur tabel SEBELUM penambahan kolom
DESCRIBE pelanggan;

-- Langkah 6.2: Jalankan perintah ALTER TABLE untuk menambahkan kolom setelah kolom ke-2
ALTER TABLE pelanggan 
ADD COLUMN nomor_identitas VARCHAR(20) NOT NULL AFTER nama_lengkap;

-- Langkah 6.3: Tampilkan struktur tabel SESUDAH penambahan kolom
-- Perhatikan bahwa 'nomor_identitas' sekarang berada di urutan ke-3 (persis setelah kolom ke-2)
DESCRIBE pelanggan;

-- ============================================================================
-- AKHIR DARI SCRIPT
-- ============================================================================
