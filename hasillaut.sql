-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 28, 2021 at 04:30 PM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hasillaut`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `username_admin` varchar(100) DEFAULT NULL,
  `password_admin` varchar(255) DEFAULT NULL,
  `email_admin` varchar(100) DEFAULT NULL,
  `foto_admin` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `username_admin`, `password_admin`, `email_admin`, `foto_admin`) VALUES
(101, 'bagusmerta', '$2y$10$7yDF8LGURnnMrUy/z4GkM.3Cl3s3K8HLyIV67NDIt8BOBoSwiAQGW', 'bagusokelah@gmail.com', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `totalHarga` decimal(10,0) DEFAULT NULL,
  `totalBarang` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `totalHarga`, `totalBarang`) VALUES
(1, 15, '1700000', 3),
(5, 17, '0', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cartlist`
--

CREATE TABLE `cartlist` (
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `unitPrice` decimal(10,0) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cartlist`
--

INSERT INTO `cartlist` (`cart_id`, `product_id`, `unitPrice`, `quantity`) VALUES
(1, 13, '800000', 2),
(1, 16, '100000', 1);

--
-- Triggers `cartlist`
--
DELIMITER $$
CREATE TRIGGER `delete_item` AFTER DELETE ON `cartlist` FOR EACH ROW BEGIN
	UPDATE cart SET totalHarga = totalHarga - (OLD.quantity* OLD.unitPrice), totalBarang = totalBarang - (OLD.quantity) 
    WHERE cart_id = OLD.cart_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `new_item` AFTER INSERT ON `cartlist` FOR EACH ROW BEGIN
	UPDATE cart SET totalHarga = totalHarga + (NEW.unitPrice * NEW.quantity), totalBarang = totalBarang + NEW.quantity
    WHERE cart_id = NEW.cart_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_item` AFTER UPDATE ON `cartlist` FOR EACH ROW BEGIN
	IF NEW.quantity > OLD.quantity THEN 
    	UPDATE cart SET totalHarga = totalHarga + (NEW.unitPrice*NEW.quantity - OLD.unitPrice*OLD.quantity), totalBarang = totalBarang + (NEW.quantity - OLD.quantity) WHERE cart_id = OLD.cart_id;
    ELSEIF NEW.quantity < OLD.quantity THEN
    	UPDATE cart SET totalHarga = totalHarga - (OLD.unitPrice*OLD.quantity -NEW.unitPrice*NEW.quantity), totalBarang = totalBarang - (OLD.quantity - NEW.quantity) WHERE cart_id = OLD.cart_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `kategori_id` int(11) NOT NULL,
  `nama_kategori` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`kategori_id`, `nama_kategori`) VALUES
(1, 'Tangkapan'),
(2, 'Olahan'),
(3, 'Cumi'),
(4, 'Bercangkang'),
(5, 'Unik'),
(6, 'Tumbuhan'),
(7, 'Ikan Laut');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `cart_id` int(11) DEFAULT NULL,
  `product_order` varchar(255) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `alamat_order` varchar(255) DEFAULT NULL,
  `total_order` decimal(10,0) DEFAULT NULL,
  `total_quantity` int(11) DEFAULT NULL,
  `order_via` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `cart_id`, `product_order`, `order_date`, `alamat_order`, `total_order`, `total_quantity`, `order_via`) VALUES
(43, 1, 'Ikan Cupangs, Ikan Hiu, nori laut, Ikan Paus', '2021-05-28', 'Jalan Anggrek', '680000', 10, 'e-banking');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `kode_product` int(11) DEFAULT NULL,
  `nama_product` varchar(100) DEFAULT NULL,
  `desc_product` varchar(100) DEFAULT NULL,
  `harga_product` decimal(10,2) DEFAULT NULL,
  `foto_product` varchar(255) DEFAULT NULL,
  `kategori_product` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `kode_product`, `nama_product`, `desc_product`, `harga_product`, `foto_product`, `kategori_product`) VALUES
(12, 101, 'Udang Windu', 'Saat ini udang menjadi komoditi ekspor perikanan nomor satu di Indonesia. Setidaknya ada dua jenis u', '20000.00', '3503.jpg', 4),
(13, 101, 'Kerang Ajaib Bikini Bottom', 'Kulit Kerang Ajaib adalah benda ajaib yang digunakan oleh SpongeBob dan Patrick untuk menjawab semua', '800000.00', '7623.jpeg', 5),
(14, 101, 'Ikan Hiu', ' Manfaat kuliner sirip hiu dipercaya sebagai menghaluskan kulit, meningkatkan kemampuan seksual, men', '80000.00', '3818.jpg', 7),
(15, 101, 'Cumi', 'Selain mengandung protein tinggi, cumi-cumi juga mengandung asam amino penting dan mineral seperti n', '10000.00', '8860.jpeg', 3),
(16, 101, 'Lobster', 'Di Indonesia, lobster adalah salah satu panganan bahari yang disukai karena dagingnya tebal dan rasa', '100000.00', '1971.jpg', 4),
(17, 101, 'kerang enakk', 'Hewan laut yang biasa menjadi seafood antara lain adalah kerang. Kerang adalah hewan air bertubuh lu', '14000.00', '5670.jpg', 4),
(18, 101, 'Rumput Laut Putih', 'Tanaman ini telah jamak dimanfaatkan masyarakat sebagai bahan makanan. Tak hanya menjadi campuran es', '15000.00', '7643.jpg', 6),
(19, 101, 'Kepiting Alaska', 'Kepiting raja Alaska, Paralithodes camtschaticus, juga disebut kepiting Kamchatka atau kepiting raja', '450000.00', '8489.jpg', 4),
(20, 101, 'Ikan Salmon', 'Salmon atau salem adalah jenis ikan dari famili Salmonidae. Ikan lain yang berada dalam satu famili ', '70000.00', '4015.jpg', 7);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `first_name` varchar(10) DEFAULT NULL,
  `last_name` varchar(10) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `foto` varchar(225) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alamat` varchar(50) DEFAULT NULL,
  `kota` varchar(20) DEFAULT NULL,
  `provinsi` varchar(20) DEFAULT NULL,
  `kodepos` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `first_name`, `last_name`, `email`, `foto`, `no_hp`, `alamat`, `kota`, `provinsi`, `kodepos`) VALUES
(15, 'komang', '$2y$10$r6f3Ef8881imzWbdVPy.0e40YJki04v10RTuOmsqJK70yf4h/XBty', 'komang', 'silal', 'silalmang@email.com', '8781.jpg', '089234123321', 'Jalan California Melbourne Forest', 'Monkey Forest', 'Bali', '1234'),
(17, 'ragiltopa', '$2y$10$CcDdW3tRvRAzAXwBo/uJlugbOweEN0hJ6OChBywk0oAOCSCcCX0yq', 'ragil', 'topa', 'ragiltopa@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `new_cart` AFTER INSERT ON `users` FOR EACH ROW BEGIN
	INSERT INTO cart(user_id, totalHarga, totalBarang)
    VALUES(NEW.user_id, 0, 0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `wish_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`wish_id`, `user_id`, `product_id`) VALUES
(8, 15, 19),
(9, 15, 18);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`) USING BTREE;

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cartlist`
--
ALTER TABLE `cartlist`
  ADD PRIMARY KEY (`cart_id`,`product_id`) USING BTREE,
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`kategori_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `cart_id` (`cart_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `kode_product` (`kode_product`),
  ADD KEY `kategori_product` (`kategori_product`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`wish_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `kategori_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `wish_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `cartlist`
--
ALTER TABLE `cartlist`
  ADD CONSTRAINT `cartlist_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`) ON DELETE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`kode_product`) REFERENCES `admin` (`admin_id`),
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`kategori_product`) REFERENCES `kategori` (`kategori_id`);

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
