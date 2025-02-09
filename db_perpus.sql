-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 09, 2025 at 02:21 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpus`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteBuku` (IN `id` INT)   BEGIN
    DELETE FROM buku WHERE id_buku = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBuku` (IN `j_buku` VARCHAR(255), IN `p_buku` VARCHAR(255), IN `k_buku` VARCHAR(100), IN `s_buku` INT)   BEGIN
    INSERT INTO buku (judul_buku, penulis, kategori, stok) VALUES (j_buku, p_buku, k_buku, s_buku);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `KembalikanBuku` (IN `id_p` INT)   BEGIN
    UPDATE peminjaman SET status = 'Dikembalikan', tanggal_kembali = CURDATE() WHERE id_peminjaman = id_p;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SemuaBuku` ()   BEGIN
    SELECT b.id_buku, b.judul_buku, COALESCE(p.id_peminjaman, 'Belum Pernah Dipinjam') AS status_peminjaman
    FROM buku b
    LEFT JOIN peminjaman p ON b.id_buku = p.id_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SemuaSiswa` ()   BEGIN
    SELECT s.id_siswa, s.nama, s.kelas, COALESCE(p.id_peminjaman, 'Belum Meminjam') AS status_peminjaman
    FROM siswa s
    LEFT JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShowAllBuku` ()   BEGIN
    SELECT * FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShowAllPeminjaman` ()   BEGIN
    SELECT * FROM peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShowAllSiswa` ()   BEGIN
    SELECT * FROM siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SiswaPeminjam` ()   BEGIN
    SELECT DISTINCT s.id_siswa, s.nama, s.kelas FROM siswa s
    JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBuku` (IN `id` INT, IN `new_stok` INT)   BEGIN
    UPDATE buku SET stok = new_stok WHERE id_buku = id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int NOT NULL,
  `judul_buku` varchar(255) DEFAULT NULL,
  `penulis` varchar(255) DEFAULT NULL,
  `kategori` varchar(100) DEFAULT NULL,
  `stok` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul_buku`, `penulis`, `kategori`, `stok`) VALUES
(1, 'Algoritma dan Pemrograman', 'Andi Wijaya', 'Teknologi', 5),
(2, 'Dasar-dasar Database', 'Budi Santoso', 'Teknologi', 10),
(4, 'Sejarah Dunia', 'John Smith', 'Sejarah', 4),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 8),
(6, 'Fisika Dasar', 'Albert Einstein', 'Sains', 6),
(7, 'Kimia Organik', 'Siti Aminah', 'Sains', 5),
(8, 'Teknik Elektro', 'Ridwan Hakim', 'Teknik', 7),
(9, 'Manajemen Waktu', 'Steven Covey', 'Pengembangan', 8),
(10, 'Strategi Belajar Efektif', 'Tony Buzan', 'Pendidikan', 6),
(11, 'Bahasa Inggris untuk Pemula', 'Jane Doe', 'Bahasa', 10),
(12, 'Cerita Rakyat Nusantara', 'Lestari Dewi', 'Sastra', 9),
(13, 'Sistem Operasi', 'Dian Kurniawan', 'Teknologi', 6),
(14, 'Jaringan Komputer', 'Ahmad Fauzi', 'Teknologi', 5),
(15, 'Biologi Dasar', 'Budi Rahman', 'Sains', 7);

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int NOT NULL,
  `id_siswa` int DEFAULT NULL,
  `id_buku` int DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `status` enum('Dipinjam','Dikembalikan') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_siswa`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(1, 1, 2, '2025-02-01', '2025-02-09', 'Dikembalikan'),
(2, 2, 5, '2025-01-28', '2025-02-04', 'Dikembalikan'),
(3, 3, 4, '2025-02-02', '2025-02-09', 'Dikembalikan'),
(4, 4, 1, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(6, 1, 2, '2025-02-09', '2025-02-16', 'Dipinjam'),
(7, 2, 2, '2025-02-09', '2025-02-16', 'Dipinjam');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `KurangiStok` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
    UPDATE buku SET stok = stok - 1 WHERE id_buku = NEW.id_buku;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TambahStok` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF NEW.status = 'Dikembalikan' THEN
        UPDATE buku SET stok = stok + 1 WHERE id_buku = NEW.id_buku;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `kelas` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `nama`, `kelas`) VALUES
(1, 'Andi Saputra', 'X-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL'),
(4, 'Dewi Kurniawan', 'XI-TKJ'),
(5, 'Eko Prasetyo', 'XII-RPL');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_siswa` (`id_siswa`),
  ADD KEY `peminjaman_ibfk_2` (`id_buku`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_siswa`) REFERENCES `siswa` (`id_siswa`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
