USE ComputerSpace;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- THÊM SẢN PHẨM 
-- =========================
INSERT INTO SAN_PHAM (TenSP, MaLoaiSP, ThuongHieu, GiaBan, SoLuongTon, BaoHanhThang, MoTaNgan, TrangThai) VALUES

-- ===== MAINBOARD (MaLoaiSP = 1) - MaSP 22-28 =====
('ASUS PRIME B760M-A WIFI DDR5',                1, 'ASUS',     4200000, 28, 36, 'Mainboard Intel B760, mATX, DDR5, WiFi 6',                  1),
('MSI PRO B650-P WIFI',                         1, 'MSI',      4500000, 22, 36, 'Mainboard AMD B650, ATX, DDR5, WiFi 6E, PCIe 4.0',          1),
('Gigabyte Z790 AORUS MASTER',                  1, 'Gigabyte', 12500000, 8, 36, 'Mainboard cao cấp Z790, E-ATX, DDR5 8000+, Thunderbolt 4', 1),
('ASRock B650M PG Riptide',                     1, 'ASRock',   3500000, 25, 36, 'Mainboard AMD B650, mATX, DDR5, giá tốt',                   1),
('ASUS ROG MAXIMUS Z790 HERO',                  1, 'ASUS',     16500000, 5, 36, 'Mainboard flagship Z790, E-ATX, DDR5, 5G LAN, WiFi 6E',    1),
('MSI MPG B760I EDGE WIFI DDR4',                1, 'MSI',      4800000, 15, 36, 'Mainboard Intel B760, Mini-ITX, DDR4, WiFi 6E',             1),
('Gigabyte X670E AORUS XTREME',                 1, 'Gigabyte', 22500000, 3, 36, 'Mainboard flagship AM5, E-ATX, DDR5, 10G LAN, Thunderbolt',1),

-- ===== CPU (MaLoaiSP = 2) - MaSP 29-36 =====
('Intel Core i7-13700K',                        2, 'Intel',    9500000, 18, 36, 'CPU Intel Gen 13, 16 nhân, 5.4GHz Turbo, không có quạt',   1),
('Intel Core i3-13100F',                        2, 'Intel',    2800000, 40, 36, 'CPU Intel Gen 13, 4 nhân 8 luồng, không tích hợp GPU',      1),
('AMD Ryzen 7 7700X',                           2, 'AMD',      9200000, 15, 36, 'CPU AMD Zen 4, 8 nhân 16 luồng, 5.4GHz Boost',              1),
('AMD Ryzen 5 7600',                            2, 'AMD',      5800000, 30, 36, 'CPU AMD Zen 4, 6 nhân 12 luồng, 5.1GHz Boost, kèm tản',     1),
('AMD Ryzen 5 5600',                            2, 'AMD',      3200000, 45, 36, 'CPU AMD Zen 3, 6 nhân 12 luồng, AM4, kèm tản Wraith Stealth',1),
('Intel Core i9-14900K',                        2, 'Intel',    14500000, 8, 36, 'CPU Intel Gen 14, 24 nhân, 6.0GHz Turbo, top tier',         1),
('AMD Ryzen 7 7800X3D',                         2, 'AMD',      11500000, 10, 36, 'CPU gaming hàng đầu, 8 nhân, 96MB cache 3D V-Cache',       1),
('Intel Core i5-12400F',                        2, 'Intel',    3800000, 35, 36, 'CPU Intel Gen 12, 6 nhân 12 luồng, không có GPU',           1),

-- ===== VGA (MaLoaiSP = 3) - MaSP 37-44 =====
('NVIDIA RTX 4080 SUPER Founders Edition',      3, 'NVIDIA',   28500000, 6, 36, 'GPU RTX 4080 Super, 16GB GDDR6X, ray tracing đỉnh cao',    1),
('ASUS DUAL RTX 4060 OC 8GB',                   3, 'ASUS',     8500000, 25, 36, 'GPU RTX 4060, GDDR6 8GB, 2 quạt, gọn nhẹ',                  1),
('MSI VENTUS 2X RTX 4060 Ti 8GB',               3, 'MSI',      11500000, 18, 36, 'GPU RTX 4060 Ti, GDDR6 8GB, hiệu năng/giá tốt',             1),
('Gigabyte RTX 4070 SUPER WINDFORCE OC 12GB',   3, 'Gigabyte', 16500000, 12, 36, 'GPU RTX 4070 Super, GDDR6X 12GB, 3 quạt WINDFORCE',        1),
('PowerColor Hellhound RX 7800 XT 16GB',        3, 'PowerColor',14200000,10, 36, 'GPU AMD RX 7800 XT, GDDR6 16GB, custom Hellhound',         1),
('Sapphire Pulse RX 7700 XT 12GB',              3, 'Sapphire', 11800000, 14, 36, 'GPU AMD RX 7700 XT, GDDR6 12GB, dual BIOS',                 1),
('ASUS TUF RTX 3060 OC 12GB',                   3, 'ASUS',     7500000, 20, 36, 'GPU RTX 3060, GDDR6 12GB, 3 quạt TUF Gaming',               1),
('MSI SUPRIM X RTX 4090 24GB',                  3, 'MSI',      48500000, 3, 36, 'GPU RTX 4090 phiên bản SUPRIM X, làm mát cao cấp',         1),

-- ===== CASE (MaLoaiSP = 4) - MaSP 45-50 =====
('Corsair 4000D Airflow',                       4, 'Corsair',  2500000, 22, 24, 'Case Mid Tower, mặt trước mesh, 2 quạt SP120 sẵn',          1),
('Fractal Design Meshify 2 Compact',            4, 'Fractal Design', 2900000, 15, 24, 'Case Mid Tower, mặt mesh, hỗ trợ E-ATX, đẹp tinh tế',1),
('Cooler Master MasterBox TD500 Mesh V2',       4, 'Cooler Master', 2200000, 30, 24, 'Case Mid Tower, mesh, 3 quạt ARGB SickleFlow sẵn',     1),
('DeepCool CH560 Digital',                      4, 'DeepCool', 2400000, 25, 24, 'Case Mid Tower, màn hình hiển thị nhiệt độ, 4 quạt sẵn',     1),
('Lian Li Lancool 216',                         4, 'Lian Li',  2700000, 18, 24, 'Case Mid Tower, mặt trước mesh, 2 quạt 160mm ARGB',          1),
('NZXT H9 Flow',                                4, 'NZXT',     3500000, 12, 24, 'Case Mid Tower dual chamber, kính cường lực 2 mặt',          1),

-- ===== NGUỒN (MaLoaiSP = 5) - MaSP 51-56 =====
('Cooler Master MWE 650W Bronze V2',            5, 'Cooler Master', 1500000, 35, 60, 'PSU 650W, 80+ Bronze, non-modular, bảo hành 5 năm',    1),
('Corsair RM850e 850W 80+ Gold',                5, 'Corsair',  3500000, 22, 84, 'PSU fully modular 850W, 80+ Gold, ATX 3.0, 12VHPWR',        1),
('Seasonic Prime TX-1000 1000W 80+ Titanium',   5, 'Seasonic', 7500000, 8, 144, 'PSU cao cấp 1000W, 80+ Titanium, fully modular',           1),
('FSP Hydro G PRO 750W 80+ Gold',               5, 'FSP',      2700000, 25, 120, 'PSU 750W, 80+ Gold, fully modular, bảo hành 10 năm',       1),
('Super Flower Leadex VII Gold 1000W',          5, 'Super Flower', 4800000, 12, 120, 'PSU 1000W, 80+ Gold ATX 3.0, fully modular',           1),
('be quiet! Pure Power 12 M 750W',              5, 'be quiet!',2900000, 15, 60, 'PSU 750W, 80+ Gold, fully modular, quạt cực êm',            1),

-- ===== TẢN NHIỆT (MaLoaiSP = 6) - MaSP 57-62 =====
('DeepCool AK620 Digital',                      6, 'DeepCool', 1800000, 28, 36, 'Tản khí dual tower, 2 quạt 120mm, có màn hình LCD',         1),
('Arctic Liquid Freezer III 360 ARGB',          6, 'Arctic',   3800000, 18, 72, 'Tản nước AIO 360mm, ARGB, 3 quạt P12, hiệu năng top',       1),
('Cooler Master Hyper 212 Black Edition',       6, 'Cooler Master', 850000, 50, 24, 'Tản khí phổ biến, 1 quạt 120mm, giá rẻ, hiệu quả',     1),
('Corsair iCUE H150i ELITE LCD XT',             6, 'Corsair',  5200000, 8, 60, 'Tản nước AIO 360mm, màn LCD 2.1 inch, RGB',                 1),
('Thermalright Peerless Assassin 120 SE',       6, 'Thermalright', 950000, 40, 36, 'Tản khí dual tower giá rẻ, hiệu năng vượt trội',        1),
('Lian Li Galahad II Trinity 240mm',            6, 'Lian Li',  2800000, 15, 36, 'Tản nước AIO 240mm, ARGB tích hợp, ống dây bọc',            1),

-- ===== Ổ CỨNG (MaLoaiSP = 7) - MaSP 63-70 =====
('Samsung 990 PRO 2TB NVMe PCIe 4.0',           7, 'Samsung',  4800000, 20, 60, 'SSD NVMe Gen 4, đọc 7450MB/s, ghi 6900MB/s',                1),
('Kingston NV2 500GB NVMe PCIe 4.0',            7, 'Kingston', 950000, 60, 36, 'SSD NVMe Gen 4 giá rẻ, đọc 3500MB/s',                        1),
('Crucial T700 1TB NVMe PCIe 5.0',              7, 'Crucial',  4500000, 12, 60, 'SSD NVMe Gen 5, đọc 11700MB/s, có heatsink',                1),
('WD Blue 4TB HDD 5400RPM',                     7, 'Western Digital', 2200000, 25, 24, 'HDD 3.5 inch, 4TB, 5400RPM, dung lượng lớn',     1),
('Samsung 980 500GB NVMe PCIe 3.0',             7, 'Samsung',  1100000, 45, 60, 'SSD NVMe Gen 3, đọc 3100MB/s, không heatsink',              1),
('Crucial MX500 500GB SATA SSD',                7, 'Crucial',  1050000, 50, 60, 'SSD SATA 2.5 inch, đọc 560MB/s, dùng cho laptop/PC cũ',     1),
('Seagate IronWolf 4TB NAS HDD',                7, 'Seagate',  3200000, 18, 36, 'HDD 3.5 inch, 4TB, 5900RPM, chuyên dụng NAS',               1),
('Lexar NM790 2TB NVMe PCIe 4.0',               7, 'Lexar',    3200000, 22, 60, 'SSD NVMe Gen 4, đọc 7400MB/s, ghi 6500MB/s',                1),

-- ===== RAM (MaLoaiSP = 8) - MaSP 71-77 =====
('G.Skill Ripjaws S5 DDR5 32GB 5600MHz',        8, 'G.Skill',  3200000, 30, 36, 'RAM DDR5 2x16GB, 5600MHz, low profile, không LED',          1),
('Corsair Dominator Platinum RGB DDR5 32GB 6000MHz', 8, 'Corsair', 5800000, 15, 36, 'RAM DDR5 2x16GB, 6000MHz, RGB, top tier',           1),
('Kingston Fury Renegade DDR5 32GB 6400MHz',    8, 'Kingston', 4500000, 20, 36, 'RAM DDR5 2x16GB, 6400MHz, tản nhôm cao cấp',                1),
('Corsair Vengeance LPX DDR4 32GB 3600MHz',     8, 'Corsair',  2500000, 35, 36, 'RAM DDR4 2x16GB, 3600MHz, low profile',                     1),
('G.Skill Trident Z RGB DDR4 16GB 3600MHz',     8, 'G.Skill',  1900000, 28, 36, 'RAM DDR4 2x8GB, 3600MHz, RGB, tản nhiệt nhôm',              1),
('TeamGroup T-Force Delta RGB DDR5 32GB 6000MHz',8,'TeamGroup',3500000, 25, 36, 'RAM DDR5 2x16GB, 6000MHz, RGB, giá hợp lý',                 1),
('Crucial Pro DDR5 64GB 5600MHz',               8, 'Crucial',  6500000, 12, 36, 'RAM DDR5 2x32GB, 5600MHz, dung lượng lớn cho workstation',  1);

-- =========================
-- ẢNH SẢN PHẨM (cho sản phẩm mới)
-- =========================
INSERT INTO ANH_SAN_PHAM (MaSP, DuongDanAnh, LaAnhDaiDien) VALUES
-- Mainboard
(22, '/images/products/asus-prime-b760m-a-1.jpg', 1),
(23, '/images/products/msi-pro-b650p-1.jpg', 1),
(24, '/images/products/gigabyte-z790-aorus-master-1.jpg', 1),
(24, '/images/products/gigabyte-z790-aorus-master-2.jpg', 0),
(25, '/images/products/asrock-b650m-pg-riptide-1.jpg', 1),
(26, '/images/products/asus-rog-maximus-z790-hero-1.jpg', 1),
(26, '/images/products/asus-rog-maximus-z790-hero-2.jpg', 0),
(27, '/images/products/msi-mpg-b760i-edge-1.jpg', 1),
(28, '/images/products/gigabyte-x670e-aorus-xtreme-1.jpg', 1),
-- CPU
(29, '/images/products/intel-i7-13700k-1.jpg', 1),
(30, '/images/products/intel-i3-13100f-1.jpg', 1),
(31, '/images/products/amd-ryzen7-7700x-1.jpg', 1),
(32, '/images/products/amd-ryzen5-7600-1.jpg', 1),
(33, '/images/products/amd-ryzen5-5600-1.jpg', 1),
(34, '/images/products/intel-i9-14900k-1.jpg', 1),
(34, '/images/products/intel-i9-14900k-2.jpg', 0),
(35, '/images/products/amd-ryzen7-7800x3d-1.jpg', 1),
(36, '/images/products/intel-i5-12400f-1.jpg', 1),
-- VGA
(37, '/images/products/nvidia-rtx4080super-fe-1.jpg', 1),
(37, '/images/products/nvidia-rtx4080super-fe-2.jpg', 0),
(38, '/images/products/asus-dual-rtx4060-1.jpg', 1),
(39, '/images/products/msi-ventus-rtx4060ti-1.jpg', 1),
(40, '/images/products/gigabyte-rtx4070super-1.jpg', 1),
(40, '/images/products/gigabyte-rtx4070super-2.jpg', 0),
(41, '/images/products/powercolor-rx7800xt-1.jpg', 1),
(42, '/images/products/sapphire-pulse-rx7700xt-1.jpg', 1),
(43, '/images/products/asus-tuf-rtx3060-1.jpg', 1),
(44, '/images/products/msi-suprim-rtx4090-1.jpg', 1),
(44, '/images/products/msi-suprim-rtx4090-2.jpg', 0),
-- Case
(45, '/images/products/corsair-4000d-airflow-1.jpg', 1),
(46, '/images/products/fractal-meshify2-compact-1.jpg', 1),
(47, '/images/products/coolermaster-td500-mesh-1.jpg', 1),
(48, '/images/products/deepcool-ch560-digital-1.jpg', 1),
(49, '/images/products/lianli-lancool216-1.jpg', 1),
(50, '/images/products/nzxt-h9-flow-1.jpg', 1),
-- Nguồn
(51, '/images/products/cm-mwe-650-bronze-1.jpg', 1),
(52, '/images/products/corsair-rm850e-1.jpg', 1),
(53, '/images/products/seasonic-prime-tx1000-1.jpg', 1),
(54, '/images/products/fsp-hydro-g-pro-750-1.jpg', 1),
(55, '/images/products/superflower-leadex-vii-1000-1.jpg', 1),
(56, '/images/products/bequiet-pure-power-12m-750-1.jpg', 1),
-- Tản nhiệt
(57, '/images/products/deepcool-ak620-digital-1.jpg', 1),
(58, '/images/products/arctic-liquid-freezer3-360-1.jpg', 1),
(59, '/images/products/cm-hyper212-black-1.jpg', 1),
(60, '/images/products/corsair-h150i-elite-lcd-1.jpg', 1),
(61, '/images/products/thermalright-pa120se-1.jpg', 1),
(62, '/images/products/lianli-galahad2-240-1.jpg', 1),
-- Ổ cứng
(63, '/images/products/samsung-990pro-2tb-1.jpg', 1),
(64, '/images/products/kingston-nv2-500gb-1.jpg', 1),
(65, '/images/products/crucial-t700-1tb-1.jpg', 1),
(66, '/images/products/wd-blue-4tb-1.jpg', 1),
(67, '/images/products/samsung-980-500gb-1.jpg', 1),
(68, '/images/products/crucial-mx500-500gb-1.jpg', 1),
(69, '/images/products/seagate-ironwolf-4tb-1.jpg', 1),
(70, '/images/products/lexar-nm790-2tb-1.jpg', 1),
-- RAM
(71, '/images/products/gskill-ripjaws-s5-32gb-1.jpg', 1),
(72, '/images/products/corsair-dominator-platinum-1.jpg', 1),
(72, '/images/products/corsair-dominator-platinum-2.jpg', 0),
(73, '/images/products/kingston-fury-renegade-ddr5-1.jpg', 1),
(74, '/images/products/corsair-vengeance-lpx-ddr4-1.jpg', 1),
(75, '/images/products/gskill-tridentz-rgb-ddr4-1.jpg', 1),
(76, '/images/products/teamgroup-tforce-delta-1.jpg', 1),
(77, '/images/products/crucial-pro-ddr5-64gb-1.jpg', 1);

-- =========================
-- CHI TIẾT MAINBOARD (22-28)
-- =========================
INSERT INTO CHI_TIET_MAIN VALUES
(22, 'Intel B760', 'LGA1700', 'mATX',  'Intel 12th/13th Gen', 4, 'DDR5', '128GB', 'PCIe 4.0 x16, PCIe 4.0 x1',           4, 2, 'HDMI 2.1, DisplayPort 1.4',          NULL),
(23, 'AMD B650',   'AM5',     'ATX',   'Ryzen 7000 Series',   4, 'DDR5', '128GB', 'PCIe 4.0 x16, PCIe 4.0 x1 (x2)',      4, 2, 'HDMI 2.1, DisplayPort 1.4',          NULL),
(24, 'Intel Z790', 'LGA1700', 'E-ATX', 'Intel 12th/13th Gen', 4, 'DDR5', '192GB', 'PCIe 5.0 x16, PCIe 4.0 x16, x1',      6, 5, 'HDMI 2.1, Thunderbolt 4 x2',         NULL),
(25, 'AMD B650',   'AM5',     'mATX',  'Ryzen 7000 Series',   4, 'DDR5', '128GB', 'PCIe 4.0 x16, PCIe 4.0 x1',           4, 2, 'HDMI 2.1, DisplayPort 1.4',          NULL),
(26, 'Intel Z790', 'LGA1700', 'E-ATX', 'Intel 12th/13th/14th Gen', 4, 'DDR5', '192GB', 'PCIe 5.0 x16, PCIe 4.0 x16, x1', 6, 5, 'HDMI 2.1, Thunderbolt 4 x2',         NULL),
(27, 'Intel B760', 'LGA1700', 'Mini-ITX', 'Intel 12th/13th Gen', 2, 'DDR4', '64GB', 'PCIe 4.0 x16',                     4, 2, 'HDMI 2.1, DisplayPort 1.4',          NULL),
(28, 'AMD X670E',  'AM5',     'E-ATX', 'Ryzen 7000 Series',   4, 'DDR5', '128GB', 'PCIe 5.0 x16, PCIe 5.0 x16, x1',      8, 5, 'HDMI 2.1, DisplayPort 1.4',          NULL);

-- =========================
-- CHI TIẾT CPU (29-36)
-- =========================
INSERT INTO CHI_TIET_CPU VALUES
(29, 'Intel', 'Core i7-13700K',  'LGA1700', 16, 24, '3.4 GHz', '5.4 GHz', '80KB', '24MB', '125W (PL1) / 253W (PL2)', 1),
(30, 'Intel', 'Core i3-13100F',  'LGA1700', 4,  8,  '3.4 GHz', '4.5 GHz', '80KB', '12MB', '58W (PL1) / 89W (PL2)',   0),
(31, 'AMD',   'Ryzen 7 7700X',   'AM5',     8,  16, '4.5 GHz', '5.4 GHz', '512KB','8MB',  '105W',                    1),
(32, 'AMD',   'Ryzen 5 7600',    'AM5',     6,  12, '3.8 GHz', '5.1 GHz', '384KB','6MB',  '65W',                     1),
(33, 'AMD',   'Ryzen 5 5600',    'AM4',     6,  12, '3.5 GHz', '4.4 GHz', '384KB','3MB',  '65W',                     0),
(34, 'Intel', 'Core i9-14900K',  'LGA1700', 24, 32, '3.2 GHz', '6.0 GHz', '80KB', '32MB', '125W (PL1) / 253W (PL2)', 1),
(35, 'AMD',   'Ryzen 7 7800X3D', 'AM5',     8,  16, '4.2 GHz', '5.0 GHz', '512KB','8MB',  '120W',                    1),
(36, 'Intel', 'Core i5-12400F',  'LGA1700', 6,  12, '2.5 GHz', '4.4 GHz', '80KB', '7.5MB','65W (PL1) / 117W (PL2)',  0);

-- =========================
-- CHI TIẾT VGA (37-44)
-- =========================
INSERT INTO CHI_TIET_VGA VALUES
(37, 'NVIDIA', '16GB GDDR6X', 'GDDR6X', '256-bit', '2550 MHz Boost', '320W', 'HDMI 2.1 x1, DP 1.4a x3', 3, '304 x 137 x 61 mm', '16-pin PCIe 5.0 x1'),
(38, 'NVIDIA', '8GB GDDR6',   'GDDR6',  '128-bit', '2475 MHz Boost', '115W', 'HDMI 2.1 x1, DP 1.4a x3', 2, '227 x 124 x 50 mm', '8-pin PCIe x1'),
(39, 'NVIDIA', '8GB GDDR6',   'GDDR6',  '128-bit', '2535 MHz Boost', '160W', 'HDMI 2.1 x1, DP 1.4a x3', 2, '247 x 130 x 49 mm', '8-pin PCIe x1'),
(40, 'NVIDIA', '12GB GDDR6X', 'GDDR6X', '192-bit', '2475 MHz Boost', '220W', 'HDMI 2.1 x1, DP 1.4a x3', 3, '301 x 130 x 56 mm', '16-pin PCIe 5.0 x1'),
(41, 'AMD',    '16GB GDDR6',  'GDDR6',  '256-bit', '2520 MHz Game',  '263W', 'HDMI 2.1 x1, DP 2.1 x3',  3, '320 x 130 x 50 mm', '8-pin PCIe x2'),
(42, 'AMD',    '12GB GDDR6',  'GDDR6',  '192-bit', '2171 MHz Game',  '245W', 'HDMI 2.1 x1, DP 2.1 x3',  3, '280 x 120 x 47 mm', '8-pin PCIe x2'),
(43, 'NVIDIA', '12GB GDDR6',  'GDDR6',  '192-bit', '1837 MHz Boost', '170W', 'HDMI 2.1 x2, DP 1.4a x3', 3, '300 x 127 x 51 mm', '8-pin PCIe x1'),
(44, 'NVIDIA', '24GB GDDR6X', 'GDDR6X', '384-bit', '2640 MHz Boost', '450W', 'HDMI 2.1 x1, DP 1.4a x3', 3, '358 x 150 x 76 mm', '16-pin PCIe 5.0 x1');

-- =========================
-- CHI TIẾT CASE (45-50)
-- =========================
INSERT INTO CHI_TIET_CASE VALUES
(45, 'E-ATX / ATX / mATX / ITX', 'Đen/Trắng', 'Thép + Kính cường lực',   '453 x 230 x 466 mm', 'ATX (≤180mm)', 6, 1, 'USB-A 3.0 x1, USB-C 3.1 x1, Audio'),
(46, 'E-ATX / ATX / mATX / ITX', 'Đen/Trắng', 'Thép + Kính cường lực',   '475 x 215 x 424 mm', 'ATX (≤175mm)', 7, 1, 'USB-A 3.0 x2, USB-C 3.1 x1, Audio'),
(47, 'E-ATX / ATX / mATX / ITX', 'Đen',       'Thép + Kính cường lực',   '498 x 232 x 467 mm', 'ATX (≤180mm)', 7, 1, 'USB-A 3.0 x2, USB-C 3.2 x1, Audio'),
(48, 'E-ATX / ATX / mATX / ITX', 'Đen/Trắng', 'Thép + Kính cường lực',   '482 x 233 x 471 mm', 'ATX (≤175mm)', 9, 1, 'USB-A 3.0 x2, USB-C 3.2 x1, Audio'),
(49, 'E-ATX / ATX / mATX / ITX', 'Đen/Trắng', 'Thép + Kính cường lực',   '480 x 230 x 459 mm', 'ATX (≤180mm)', 7, 1, 'USB-A 3.0 x2, USB-C 3.2 x1, Audio'),
(50, 'E-ATX / ATX / mATX / ITX', 'Đen/Trắng', 'Thép + Kính cường lực',   '495 x 290 x 466 mm', 'ATX (≤200mm)', 9, 1, 'USB-A 3.0 x2, USB-C 3.2 x1, Audio');

-- =========================
-- CHI TIẾT NGUỒN (51-56)
-- =========================
INSERT INTO CHI_TIET_NGUON VALUES
(51, '650W',  '80+ Bronze',   'Non-modular',   '150 x 86 x 140 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x1, PCIe 8-pin x2, SATA x6, Molex x3'),
(52, '850W',  '80+ Gold',     'Fully Modular', '150 x 86 x 140 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 16-pin x1, SATA x9, Molex x4'),
(53, '1000W', '80+ Titanium', 'Fully Modular', '170 x 86 x 150 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 8-pin x6, SATA x12, Molex x5'),
(54, '750W',  '80+ Gold',     'Fully Modular', '150 x 86 x 150 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 8-pin x4, SATA x8, Molex x4'),
(55, '1000W', '80+ Gold',     'Fully Modular', '160 x 86 x 150 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 16-pin x1, SATA x12, Molex x4'),
(56, '750W',  '80+ Gold',     'Fully Modular', '150 x 86 x 160 mm', '100-240V ~ 50/60Hz', '24-pin ATX x1, EPS 8-pin x2, PCIe 8-pin x4, SATA x9, Molex x4');

-- =========================
-- CHI TIẾT TẢN NHIỆT (57-62)
-- =========================
INSERT INTO CHI_TIET_TAN_NHIET VALUES
(57, 'Air Cooler (Tower)',     'LGA1700/1200/115x, AM5/AM4', NULL,    2, '500 - 1850 RPM', '≤28 dB(A)',   'Có màn hình LCD', '129 x 138 x 160 mm'),
(58, 'AIO Liquid Cooler',      'LGA1700/1200/115x, AM5/AM4', '360mm', 3, '200 - 1900 RPM', '≤22.5 dB(A)', 'ARGB',            '398 x 120 x 38 mm (Radiator)'),
(59, 'Air Cooler (Single Tower)', 'LGA1700/1200/115x, AM5/AM4', NULL, 1, '650 - 2000 RPM', '≤26 dB(A)',   'Không LED',       '120 x 80 x 159 mm'),
(60, 'AIO Liquid Cooler',      'LGA1700/1200/115x, AM5/AM4', '360mm', 3, '450 - 2400 RPM', '≤36 dB(A)',   'RGB + LCD 2.1"',  '397 x 120 x 27 mm (Radiator)'),
(61, 'Air Cooler (Dual Tower)','LGA1700/1200/115x, AM5/AM4', NULL,    2, '500 - 1550 RPM', '≤25.6 dB(A)', 'Không LED',       '125 x 110 x 155 mm'),
(62, 'AIO Liquid Cooler',      'LGA1700/1200/115x, AM5/AM4', '240mm', 2, '500 - 2100 RPM', '≤30 dB(A)',   'ARGB',            '277 x 120 x 27 mm (Radiator)');

-- =========================
-- CHI TIẾT Ổ CỨNG (63-70)
-- =========================
INSERT INTO CHI_TIET_O_CUNG VALUES
(63, 'SSD', '2TB',   'NVMe PCIe 4.0', 'M.2 2280', 'Đọc: 7450 MB/s, Ghi: 6900 MB/s'),
(64, 'SSD', '500GB', 'NVMe PCIe 4.0', 'M.2 2280', 'Đọc: 3500 MB/s, Ghi: 2100 MB/s'),
(65, 'SSD', '1TB',   'NVMe PCIe 5.0', 'M.2 2280', 'Đọc: 11700 MB/s, Ghi: 9500 MB/s'),
(66, 'HDD', '4TB',   'SATA III',      '3.5 inch', 'Đọc: ~180 MB/s, Ghi: ~180 MB/s (5400RPM)'),
(67, 'SSD', '500GB', 'NVMe PCIe 3.0', 'M.2 2280', 'Đọc: 3100 MB/s, Ghi: 2600 MB/s'),
(68, 'SSD', '500GB', 'SATA III',      '2.5 inch', 'Đọc: 560 MB/s, Ghi: 510 MB/s'),
(69, 'HDD', '4TB',   'SATA III',      '3.5 inch', 'Đọc: ~210 MB/s, Ghi: ~210 MB/s (5900RPM)'),
(70, 'SSD', '2TB',   'NVMe PCIe 4.0', 'M.2 2280', 'Đọc: 7400 MB/s, Ghi: 6500 MB/s');

-- =========================
-- CHI TIẾT RAM (71-77)
-- =========================
INSERT INTO CHI_TIET_RAM VALUES
(71, 'DDR5', '32GB (2x16GB)', '5600 MHz', '1.25V', 2),
(72, 'DDR5', '32GB (2x16GB)', '6000 MHz', '1.40V', 2),
(73, 'DDR5', '32GB (2x16GB)', '6400 MHz', '1.40V', 2),
(74, 'DDR4', '32GB (2x16GB)', '3600 MHz', '1.35V', 2),
(75, 'DDR4', '16GB (2x8GB)',  '3600 MHz', '1.35V', 2),
(76, 'DDR5', '32GB (2x16GB)', '6000 MHz', '1.35V', 2),
(77, 'DDR5', '64GB (2x32GB)', '5600 MHz', '1.10V', 2);

-- =========================
-- THÊM KHUYẾN MÃI MỚI ÁP DỤNG CHO SẢN PHẨM MỚI
-- =========================
INSERT INTO KHUYEN_MAI (TenKM, LoaiGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, TrangThai, MaNV) VALUES
('Mid Year Sale - Giảm 8% CPU Intel Gen 13/14', 'PHAN_TRAM', 8.00,    '2025-05-01 00:00:00', '2025-06-30 23:59:59', 1, 1),
('Combo Build PC - Giảm 7% VGA RTX 40 Series',  'PHAN_TRAM', 7.00,    '2025-05-01 00:00:00', '2025-07-31 23:59:59', 1, 2),
('Giảm 300.000đ cho Tản nhiệt AIO',             'SO_TIEN',   300000,  '2025-05-05 00:00:00', '2025-06-15 23:59:59', 1, 1),
('Khuyến mãi SSD - Giảm 10% NVMe Gen 4',        'PHAN_TRAM', 10.00,   '2025-05-10 00:00:00', '2025-06-10 23:59:59', 1, 2);

INSERT INTO KHUYEN_MAI_SAN_PHAM (MaKM, MaSP) VALUES
-- KM5: CPU Intel Gen 13/14
(5, 4), (5, 5), (5, 29), (5, 30), (5, 34), (5, 36),
-- KM6: VGA RTX 40 Series
(6, 7), (6, 8), (6, 37), (6, 38), (6, 39), (6, 40), (6, 44),
-- KM7: Tản nhiệt AIO
(7, 15), (7, 58), (7, 60), (7, 62),
-- KM8: SSD NVMe Gen 4
(8, 17), (8, 63), (8, 64), (8, 70);

SET FOREIGN_KEY_CHECKS = 1;