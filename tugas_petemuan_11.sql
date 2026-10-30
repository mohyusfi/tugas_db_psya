-- ==============================================================================
-- TUGAS PERTEMUAN 11: RELASI TABEL, OPERASI JOIN & FUNGSI AGREGAT
-- NAMA    : MOH YUSFI LAKHAFIDUN
-- STAMBUK : F5512520089
-- PRODI   : S1 TEKNIK INFORMATIKA - UNIVERSITAS TADULAKO
-- BASIS DATA : f5512520089_perpustakaan
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. PEMBUATAN DATABASE SESUAI FORMAT Stambuk_namadatabase
-- ------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS f5512520089_perpustakaan;
USE f5512520089_perpustakaan;

-- Hapus tabel lama jika ada (urutan drop: child table dulu, baru parent table)
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS anggota;

-- ------------------------------------------------------------------------------
-- 2. PEMBUATAN 3 TABEL RELASIONAL (PRIMARY KEY & FOREIGN KEY)
-- ------------------------------------------------------------------------------

-- Tabel 1 (Parent): anggota
CREATE TABLE anggota (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(15) NOT NULL UNIQUE,
    nama VARCHAR(100) NOT NULL,
    jurusan VARCHAR(50) NOT NULL,
    total_poin INT NOT NULL DEFAULT 0
);

-- Tabel 2 (Parent): buku
CREATE TABLE buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul_buku VARCHAR(150) NOT NULL,
    kategori VARCHAR(50) NOT NULL,
    tahun_terbit INT NOT NULL,
    stok_buku INT NOT NULL DEFAULT 1
);

-- Tabel 3 (Child): peminjaman (Memiliki relasi FK ke tabel anggota dan buku)
CREATE TABLE peminjaman (
    id_pinjam INT AUTO_INCREMENT PRIMARY KEY,
    id_anggota INT,
    id_buku INT,
    tgl_pinjam DATE NOT NULL,
    durasi_hari INT NOT NULL,
    denda INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_peminjaman_buku FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tampilkan struktur tabel relasional
DESCRIBE anggota;
DESCRIBE buku;
DESCRIBE peminjaman;

-- ------------------------------------------------------------------------------
-- 3. INSERT DATA PADA KETIGA TABEL
--    Catatan: Disediakan beberapa record tanpa transaksi agar membuktikan
--    karakteristik NULL pada operasi LEFT JOIN dan RIGHT JOIN secara visual.
-- ------------------------------------------------------------------------------

-- Insert data anggota (id 1-6)
-- Catatan: Anggota id 5 dan 6 sengaja belum meminjam buku untuk pengujian LEFT JOIN
INSERT INTO anggota (nim, nama, jurusan, total_poin) VALUES
('F5512520089', 'Moh. Yusfi Lakhafidun', 'Teknik Informatika', 95),
('F5512520011', 'Lidiya Maharani', 'Teknik Informatika', 85),
('F5512520022', 'Winda Tesalonika', 'Teknik Informatika', 90),
('F5512520033', 'Ilham Arifin', 'Sistem Informasi', 70),
('F5512520044', 'Nefaldi Syahputra', 'Teknik Komputer', 60),
('F5512520055', 'Alifias Dewantara', 'Teknik Informatika', 50);

-- Insert data buku (id 1-6)
-- Catatan: Buku id 5 dan 6 sengaja belum pernah dipinjam untuk pengujian RIGHT JOIN
INSERT INTO buku (judul_buku, kategori, tahun_terbit, stok_buku) VALUES
('Dasar Algoritma dan Pemrograman', 'Informatika', 2021, 12),
('Desain Relasional Basis Data MySQL', 'Basis Data', 2023, 8),
('Arsitektur REST API Modern', 'Pemrograman Web', 2024, 15),
('Kecerdasan Buatan dan Robotika', 'AI', 2022, 5),
('Analisis Keamanan Jaringan Komputer', 'Keamanan', 2020, 3),
('Manajemen Proyek Perangkat Lunak Agile', 'Manajemen', 2025, 7);

-- Insert data peminjaman (menghubungkan anggota 1-4 dengan buku 1-4)
INSERT INTO peminjaman (id_anggota, id_buku, tgl_pinjam, durasi_hari, denda) VALUES
(1, 2, '2026-10-01', 7, 0),
(1, 3, '2026-10-10', 14, 5000),
(2, 1, '2026-10-05', 5, 0),
(3, 4, '2026-10-12', 10, 2000),
(4, 2, '2026-10-15', 7, 0);

-- Tampilkan data masing-masing tabel
SELECT * FROM anggota;
SELECT * FROM buku;
SELECT * FROM peminjaman;

-- ------------------------------------------------------------------------------
-- 4. IMPLEMENTASI 3 PERINTAH JOIN (INNER, LEFT, RIGHT)
-- ------------------------------------------------------------------------------

-- A. INNER JOIN: Hanya menampilkan data yang berelasi di kedua belah tabel
-- (Hanya anggota yang pernah meminjam dan buku yang pernah dipinjam)
SELECT 
    p.id_pinjam,
    a.nim,
    a.nama AS nama_peminjam,
    b.judul_buku,
    b.kategori,
    p.tgl_pinjam,
    p.durasi_hari,
    p.denda
FROM peminjaman p
INNER JOIN anggota a ON p.id_anggota = a.id_anggota
INNER JOIN buku b ON p.id_buku = b.id_buku;

-- B. LEFT JOIN: Menampilkan seluruh baris dari tabel kiri (anggota)
-- Anggota yang belum pernah meminjam (Nefaldi dan Alifias) tetap tampil dengan nilai NULL
SELECT 
    a.id_anggota,
    a.nim,
    a.nama AS nama_anggota,
    a.jurusan,
    p.id_pinjam,
    p.tgl_pinjam,
    p.durasi_hari,
    p.denda
FROM anggota a
LEFT JOIN peminjaman p ON a.id_anggota = p.id_anggota;

-- C. RIGHT JOIN: Menampilkan seluruh baris dari tabel kanan (buku)
-- Buku yang belum pernah dipinjam (Keamanan Jaringan & Agile) tetap tampil dengan nilai peminjam NULL
SELECT 
    b.id_buku,
    b.judul_buku,
    b.kategori,
    b.stok_buku,
    p.id_pinjam,
    p.id_anggota,
    p.tgl_pinjam
FROM peminjaman p
RIGHT JOIN buku b ON p.id_buku = b.id_buku;

-- ------------------------------------------------------------------------------
-- 5. FUNGSI AGREGAT: MENCARI NILAI MAX, MIN, DAN HITUNG JUMLAH BARIS (COUNT)
--    PADA MASING-MASING TABEL
-- ------------------------------------------------------------------------------

-- Tabel 1: anggota
SELECT 
    MAX(total_poin) AS nilai_max_poin,
    MIN(total_poin) AS nilai_min_poin,
    COUNT(*) AS total_baris_anggota
FROM anggota;

-- Tabel 2: buku
SELECT 
    MAX(tahun_terbit) AS nilai_max_tahun,
    MIN(tahun_terbit) AS nilai_min_tahun,
    MAX(stok_buku) AS nilai_max_stok,
    MIN(stok_buku) AS nilai_min_stok,
    COUNT(*) AS total_baris_buku
FROM buku;

-- Tabel 3: peminjaman
SELECT 
    MAX(durasi_hari) AS nilai_max_durasi,
    MIN(durasi_hari) AS nilai_min_durasi,
    MAX(denda) AS nilai_max_denda,
    MIN(denda) AS nilai_min_denda,
    COUNT(*) AS total_baris_peminjaman
FROM peminjaman;
