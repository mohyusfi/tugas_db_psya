-- ==============================================================================
-- TUGAS PERTEMUAN 10: DATA MANIPULATION LANGUAGE (DML) & QUERY LANJUTAN
-- NAMA    : MOH YUSFI LAKHAFIDUN
-- STAMBUK : F5512520089 (STAMBUK GANJIL)
-- PRODI   : S1 TEKNIK INFORMATIKA - UNIVERSITAS TADULAKO
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. PERSIAPAN DATABASE DAN TABEL
-- ------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS f5512520089_akademik;
USE f5512520089_akademik;

-- Hapus tabel lama jika ada (untuk menjaga kebersihan pengujian)
DROP TABLE IF EXISTS mahasiswa;
DROP TABLE IF EXISTS mata_kuliah;

-- Tabel 1: mahasiswa
CREATE TABLE mahasiswa (
    id_mhs INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(15) NOT NULL UNIQUE,
    nama VARCHAR(100) NOT NULL,
    prodi VARCHAR(50) NOT NULL,
    angkatan INT NOT NULL,
    ipk DECIMAL(3,2) NOT NULL,
    status_aktif ENUM('Aktif', 'Cuti', 'Lulus') DEFAULT 'Aktif'
);

-- Tabel 2: mata_kuliah
CREATE TABLE mata_kuliah (
    id_mk INT AUTO_INCREMENT PRIMARY KEY,
    kode_mk VARCHAR(10) NOT NULL UNIQUE,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT NOT NULL,
    semester INT NOT NULL,
    ruangan VARCHAR(20) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 2. MENAMBAH 10 BARIS DATA PADA MASING-MASING TABEL
-- ------------------------------------------------------------------------------

-- Tambah 10 baris data pada tabel mahasiswa
INSERT INTO mahasiswa (nim, nama, prodi, angkatan, ipk, status_aktif) VALUES
('F5512520001', 'Ahmad Fauzan', 'Teknik Informatika', 2025, 3.75, 'Aktif'),
('F5512520002', 'Budi Santoso', 'Sistem Informasi', 2024, 3.20, 'Aktif'),
('F5512520003', 'Citra Lestari', 'Teknik Informatika', 2025, 3.60, 'Aktif'),
('F5512520004', 'Deni Saputra', 'Teknik Komputer', 2023, 2.95, 'Aktif'),
('F5512520005', 'Eka Putri', 'Teknik Informatika', 2024, 3.85, 'Aktif'),
('F5512520006', 'Fajar Ramadhan', 'Sistem Informasi', 2025, 3.40, 'Aktif'),
('F5512520007', 'Gita Anggraini', 'Teknik Informatika', 2023, 3.55, 'Aktif'),
('F5512520008', 'Hendra Wijaya', 'Teknik Komputer', 2024, 3.10, 'Aktif'),
('F5512520009', 'Indah Permata', 'Teknik Informatika', 2025, 3.65, 'Aktif'),
('F5512520010', 'Joko Susilo', 'Sistem Informasi', 2023, 3.30, 'Aktif');

-- Tampilkan 10 data mahasiswa setelah INSERT
SELECT * FROM mahasiswa;

-- Tambah 10 baris data pada tabel mata_kuliah
INSERT INTO mata_kuliah (kode_mk, nama_mk, sks, semester, ruangan) VALUES
('IF101', 'Dasar Pemrograman', 3, 1, 'Lab Komputer 1'),
('IF102', 'Logika Matematika', 2, 1, 'Ruang 101'),
('IF201', 'Struktur Data', 3, 2, 'Lab Komputer 2'),
('IF202', 'Arsitektur Komputer', 3, 2, 'Ruang 102'),
('IF301', 'Basis Data', 3, 3, 'Lab Basis Data'),
('IF302', 'Sistem Operasi', 3, 3, 'Ruang 201'),
('IF401', 'Rekayasa Perangkat Lunak', 3, 4, 'Ruang 202'),
('IF402', 'Jaringan Komputer', 3, 4, 'Lab Jaringan'),
('IF501', 'Pemrograman Web', 3, 5, 'Lab Komputer 1'),
('IF502', 'Kecerdasan Buatan', 3, 5, 'Ruang 301');

-- Tampilkan 10 data mata_kuliah setelah INSERT
SELECT * FROM mata_kuliah;

-- ------------------------------------------------------------------------------
-- 3. OPERASI PERUBAHAN (UPDATE) BARIS GANJIL UNTUK STAMBUK GANJIL (F5512520089)
--    Perubahan dilakukan pada baris 1, 3, 5, 7, dan 9
-- ------------------------------------------------------------------------------

-- Update Baris Ganjil pada tabel mahasiswa
UPDATE mahasiswa SET nama = 'Ahmad Fauzan Pratama', ipk = 3.90 WHERE id_mhs = 1;
UPDATE mahasiswa SET prodi = 'Sistem Informasi Terpadu', ipk = 3.80 WHERE id_mhs = 3;
UPDATE mahasiswa SET nama = 'Eka Putri Rahmawati', status_aktif = 'Cuti' WHERE id_mhs = 5;
UPDATE mahasiswa SET ipk = 3.88, angkatan = 2024 WHERE id_mhs = 7;
UPDATE mahasiswa SET nama = 'Indah Permata Sari', prodi = 'Teknik Komputer' WHERE id_mhs = 9;

-- Tampilkan hasil perubahan tabel mahasiswa (Perhatikan baris 1, 3, 5, 7, 9)
SELECT * FROM mahasiswa;

-- Update Baris Ganjil pada tabel mata_kuliah
UPDATE mata_kuliah SET sks = 4, ruangan = 'Lab Riset 1' WHERE id_mk = 1;
UPDATE mata_kuliah SET nama_mk = 'Struktur Data & Algoritma Lanjut', sks = 4 WHERE id_mk = 3;
UPDATE mata_kuliah SET ruangan = 'Ruang Teori 205' WHERE id_mk = 5;
UPDATE mata_kuliah SET sks = 4, semester = 5 WHERE id_mk = 7;
UPDATE mata_kuliah SET nama_mk = 'Pemrograman Web Lanjut', ruangan = 'Lab Multimedia' WHERE id_mk = 9;

-- Tampilkan hasil perubahan tabel mata_kuliah (Perhatikan baris 1, 3, 5, 7, 9)
SELECT * FROM mata_kuliah;

-- ------------------------------------------------------------------------------
-- 4. PERINTAH SELECT MEMILIH DATA MENJADI 3 JENIS KRITERIA
-- ------------------------------------------------------------------------------

-- Kriteria 1: Berdasarkan kesamaan nilai kategorikal (WHERE prodi = ...)
SELECT id_mhs, nim, nama, prodi, ipk 
FROM mahasiswa 
WHERE prodi = 'Teknik Informatika';

SELECT kode_mk, nama_mk, sks, ruangan 
FROM mata_kuliah 
WHERE sks = 3;

-- Kriteria 2: Berdasarkan perbandingan nilai numerik / range (WHERE ipk >= ...)
SELECT id_mhs, nim, nama, prodi, ipk 
FROM mahasiswa 
WHERE ipk >= 3.50;

SELECT kode_mk, nama_mk, sks, semester 
FROM mata_kuliah 
WHERE semester <= 3;

-- Kriteria 3: Berdasarkan pencarian pola teks (WHERE nama LIKE ...)
SELECT id_mhs, nim, nama, prodi, status_aktif 
FROM mahasiswa 
WHERE nama LIKE 'A%' OR nama LIKE 'E%';

SELECT kode_mk, nama_mk, sks, ruangan 
FROM mata_kuliah 
WHERE nama_mk LIKE '%Data%';

-- ------------------------------------------------------------------------------
-- 5. PERINTAH SELECT MENAMPILKAN DATA DARI URUTAN BARIS KE-3 HINGGA KE-7
--    (Menggunakan LIMIT offset, row_count -> offset 2, jumlah 5 baris)
-- ------------------------------------------------------------------------------

-- Menampilkan baris ke-3 sampai ke-7 tabel mahasiswa
SELECT * FROM mahasiswa 
ORDER BY id_mhs ASC 
LIMIT 2, 5;

-- Menampilkan baris ke-3 sampai ke-7 tabel mata_kuliah
SELECT * FROM mata_kuliah 
ORDER BY id_mk ASC 
LIMIT 2, 5;

-- ------------------------------------------------------------------------------
-- 6. PERINTAH MENGHAPUS DATA KE-9 PADA MASING-MASING TABEL
-- ------------------------------------------------------------------------------

-- Hapus data ke-9 pada tabel mahasiswa (id_mhs = 9)
DELETE FROM mahasiswa WHERE id_mhs = 9;

-- Hapus data ke-9 pada tabel mata_kuliah (id_mk = 9)
DELETE FROM mata_kuliah WHERE id_mk = 9;

-- Verifikasi akhir untuk memastikan data ke-9 telah terhapus
SELECT * FROM mahasiswa;
SELECT * FROM mata_kuliah;
