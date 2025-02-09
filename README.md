# Database Perpustakaan Sekolah

## 📌 Deskripsi Proyek
Repository ini berisi skema dan implementasi database untuk sistem **Perpustakaan Sekolah**, yang mencakup:
- **Tabel buku, siswa, dan peminjaman**
- **Stored Procedures untuk Insert, Update, Delete, dan Query Khusus**
- **Triggers untuk otomatisasi stok buku**
- **Pengelolaan peminjaman dan pengembalian buku**

## 🏗 Struktur Database
### 📚 Tabel `buku`
| id_buku | judul_buku | penulis | kategori | stok |
|---------|------------|---------|----------|------|
| INT (PK) | VARCHAR(255) | VARCHAR(255) | VARCHAR(100) | INT |

### 👨‍🎓 Tabel `siswa`
| id_siswa | nama | kelas |
|----------|------|-------|
| INT (PK) | VARCHAR(255) | VARCHAR(50) |

### 📖 Tabel `peminjaman`
| id_peminjaman | id_siswa (FK) | id_buku (FK) | tanggal_pinjam | tanggal_kembali | status |
|--------------|-------------|------------|--------------|--------------|--------|
| INT (PK) | INT | INT | DATE | DATE | ENUM('Dipinjam', 'Dikembalikan') |

## 🚀 Fitur Database

### **1️⃣ Pembuatan Database dan Tabel**
```sql
CREATE DATABASE db_perpus;
USE db_perpus;
```

### **2️⃣ Insert, Update, Delete Data**
```sql
CALL InsertBuku('Judul Buku', 'Penulis', 'Kategori', 10);
CALL UpdateBuku(1, 5);
CALL DeleteBuku(3);
```

### **3️⃣ Stored Procedures**
| Stored Procedure | Fungsi |
|-----------------|--------|
| `InsertBuku` | Menambahkan data buku baru |
| `UpdateBuku` | Memperbarui stok buku |
| `DeleteBuku` | Menghapus buku (dengan opsi soft delete) |
| `KembalikanBuku` | Mengubah status peminjaman menjadi dikembalikan |
| `SiswaPeminjam` | Menampilkan daftar siswa yang pernah meminjam |
| `SemuaSiswa` | Menampilkan semua siswa, termasuk yang tidak pernah meminjam |
| `SemuaBuku` | Menampilkan semua buku, termasuk yang belum pernah dipinjam |

### **4️⃣ Triggers (Otomatisasi Stok Buku)**
| Trigger | Fungsi |
|---------|--------|
| `KurangiStok` | Mengurangi stok buku saat dipinjam |
| `TambahStok` | Menambah stok buku saat dikembalikan |

### **5️⃣ Cara Menguji Stored Procedure dan Trigger**
#### 🔹 **Stok Berkurang Saat Dipinjam**
```sql
INSERT INTO peminjaman (id_siswa, id_buku, tanggal_pinjam, status) 
VALUES (1, 2, CURDATE(), 'Dipinjam');
SELECT * FROM buku WHERE id_buku = 2;
```

#### 🔹 **Stok Bertambah Saat Dikembalikan**
```sql
UPDATE peminjaman SET status = 'Dikembalikan' WHERE id_peminjaman = 1;
SELECT * FROM buku WHERE id_buku = 2;
```

#### 🔹 **Menampilkan Semua Siswa**
```sql
CALL SemuaSiswa();
```

#### 🔹 **Menampilkan Semua Buku**
```sql
CALL SemuaBuku();
```

## 🛠 Fitur yang Digunakan
- **MySQL** sebagai database utama
- **Stored Procedures & Triggers** untuk otomatisasi
- **GitHub** sebagai sistem kontrol versi
