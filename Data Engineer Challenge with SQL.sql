-- 1. Produk DQLab Mart
SELECT
  no_urut,
  kode_produk,
  nama_produk,
  harga
FROM ms_produk
WHERE harga > 50000
AND harga < 150000;

-- 2. Thumb drive di DQLab Mart
SELECT
  no_urut,
  kode_produk,
  nama_produk,
  harga
FROM ms_produk
WHERE nama_produk LIKE "%Flashdisk%";

-- 3. Pelanggan Bergelar
SELECT
  *
FROM ms_pelanggan
WHERE nama_pelanggan LIKE "%S.H%"
OR nama_pelanggan LIKE "%Ir.%"
OR nama_pelanggan LIKE "%Drs.%";   

-- 4. Mengurutkan Nama Pelanggan
SELECT
  nama_pelanggan
FROM ms_pelanggan
ORDER BY nama_pelanggan ASC;

-- 5. Mengurutkan Nama Pelanggan Tanpa Gelar
SELECT
  nama_pelanggan
FROM ms_pelanggan
ORDER BY CASE
  WHEN LEFT(nama_pelanggan, 3) = 'Ir.' THEN SUBSTRING(nama_pelanggan, 5, 100)
  ELSE nama_pelanggan
END ASC;

-- 6. Nama Pelanggan yang Paling Panjang
SELECT
  nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN ((SELECT
  MAX(LENGTH(nama_pelanggan))
FROM ms_pelanggan))
ORDER BY LENGTH(nama_pelanggan) DESC;

-- 7. Nama Pelanggan yang Paling Panjang dengan Gelar
SELECT
  nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN ((SELECT
  MAX(LENGTH(nama_pelanggan))
FROM ms_pelanggan))
OR LENGTH(nama_pelanggan) IN ((SELECT
  MIN(LENGTH(nama_pelanggan))
FROM ms_pelanggan))
ORDER BY LENGTH(nama_pelanggan) DESC;

-- 8. Kuantitas Produk yang Banyak Terjual
SELECT
  mp.kode_produk,
  mp.nama_produk,
  SUM(qty) AS total_qty
FROM ms_produk AS mp
JOIN tr_penjualan_detail AS tpd
  ON mp.kode_produk = tpd.kode_produk
GROUP BY 1,
         2
HAVING SUM(qty) > (SELECT
  MAX(qty)
FROM tr_penjualan_detail);

-- 9. Pelanggan Paling Tinggi Nilai Belanjanya
SELECT
  mp.kode_pelanggan,
  mp.nama_pelanggan,
  SUM(tpd.harga_satuan * tpd.qty) AS total_harga
FROM ms_pelanggan AS mp
JOIN tr_penjualan AS tp
  ON mp.kode_pelanggan = tp.kode_pelanggan
JOIN tr_penjualan_detail AS tpd
  ON tp.kode_transaksi = tpd.kode_transaksi
GROUP BY mp.kode_pelanggan,
         mp.nama_pelanggan
ORDER BY total_harga DESC
LIMIT 1;

-- 10. Pelanggan yang Belum Pernah Berbelanja
SELECT
  kode_pelanggan,
  nama_pelanggan,
  alamat
FROM ms_pelanggan mp
WHERE mp.kode_pelanggan NOT IN (SELECT
  kode_pelanggan
FROM tr_penjualan)

-- 11. Transaksi Belanja dengan Daftar Belanja lebih dari 1
SELECT
  tp.kode_transaksi,
  tp.kode_pelanggan,
  mp.nama_pelanggan,
  tp.tanggal_transaksi,
  COUNT(tpd.kode_produk) AS jumlah_detail
FROM tr_penjualan tp
JOIN ms_pelanggan mp
  ON tp.kode_pelanggan = mp.kode_pelanggan
JOIN tr_penjualan_detail tpd
  ON tp.kode_transaksi = tpd.kode_transaksi
GROUP BY tp.kode_transaksi,
         tp.kode_pelanggan,
         mp.nama_pelanggan,
         tp.tanggal_transaksi
HAVING COUNT(tpd.kode_produk) > 1;
