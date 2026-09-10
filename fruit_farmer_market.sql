CREATE DATABASE  IF NOT EXISTS `fruit_farmer_market` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `fruit_farmer_market`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: fruit_farmer_market
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `work_date` date NOT NULL,
  `check_in` timestamp NULL DEFAULT NULL,
  `check_out` timestamp NULL DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PRESENT',
  `note` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_staff_date` (`staff_id`,`work_date`),
  CONSTRAINT `fk_attendance_staff` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES (1,6,'2026-08-21','2026-08-21 16:19:34','2026-08-21 16:21:27','PRESENT',NULL),(2,3,'2026-09-05','2026-09-05 03:13:01',NULL,'PRESENT',NULL);
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Trái cây Việt Nam','Các loại trái cây đặc sản tươi ngon từ các vùng miền Việt Nam.','ACTIVE','2026-08-14 14:22:43'),(2,'Trái cây nhập khẩu','Trái cây cao cấp nhập khẩu trực tiếp từ Mỹ, Úc, New Zealand...','ACTIVE','2026-08-14 14:22:43'),(3,'Trái cây theo mùa','Những thức quả ngon nhất theo từng mùa trong năm.','ACTIVE','2026-08-14 14:22:43'),(4,'Combo trái cây','Set trái cây mix sẵn, phù hợp biếu tặng hoặc gia đình.','ACTIVE','2026-08-14 14:22:43'),(5,'Trái cây hữu cơ','Trồng theo tiêu chuẩn Organic, không hóa chất.','ACTIVE','2026-08-14 14:22:43'),(6,'alo123','123','ACTIVE','2026-09-06 16:54:29');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) DEFAULT 'ORDER',
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `quantity` int NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_order_details_order` (`order_id`),
  CONSTRAINT `fk_order_details_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,1,13,'Kiwi Vàng New Zealand',240000.00,5,1200000.00),(2,2,5,'Nho Xanh Không Hạt Autumn Crisp',280000.00,5,1400000.00),(3,3,13,'Kiwi Vàng New Zealand',240000.00,1,240000.00),(4,4,13,'Kiwi Vàng New Zealand',240000.00,2,480000.00),(5,5,13,'Kiwi Vàng New Zealand',240000.00,1,240000.00),(6,6,13,'Kiwi Vàng New Zealand',240000.00,6,1440000.00),(7,7,13,'Kiwi Vàng New Zealand',240000.00,5,1200000.00),(8,8,17,'Khánh T2',1699000.00,3,5097000.00),(9,9,11,'Chuối Già Nam Mỹ (Cavendish)',25000.00,1,25000.00),(10,10,17,'Khánh T2',1699000.00,2,3398000.00),(11,11,18,'Usagi bel',1000000.00,5,5000000.00),(12,12,18,'Usagi bel',1000000.00,1,1000000.00),(13,13,18,'Usagi bel',1000000.00,1,1000000.00),(14,14,17,'Khánh T2',1699000.00,1,1699000.00),(15,15,12,'Thanh Long Ruột Đỏ',40000.00,5,200000.00),(16,16,17,'Khánh T2',1699000.00,1,1699000.00),(17,17,18,'Usagi bel',1000000.00,3,3000000.00),(18,18,17,'Khánh T2',1699000.00,13,22087000.00),(19,19,13,'Kiwi Vàng New Zealand',240000.00,3,720000.00),(20,20,17,'Khánh T2',1699000.00,2,3398000.00),(21,20,15,'Dưa Lưới Tròn',80000.00,2,160000.00),(22,21,13,'Kiwi Vàng New Zealand',240000.00,10,2400000.00),(23,22,13,'Kiwi Vàng New Zealand',240000.00,1,240000.00);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_status_history`
--

DROP TABLE IF EXISTS `order_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) NOT NULL,
  `changed_by` int DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` text,
  PRIMARY KEY (`id`),
  KEY `fk_history_order` (`order_id`),
  KEY `fk_history_user` (`changed_by`),
  CONSTRAINT `fk_history_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_history_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_status_history`
--

LOCK TABLES `order_status_history` WRITE;
/*!40000 ALTER TABLE `order_status_history` DISABLE KEYS */;
INSERT INTO `order_status_history` VALUES (1,8,'CONFIRMED','PREPARING',6,'2026-08-21 15:40:16','Staff cập nhật trạng thái'),(2,8,'PREPARING','SHIPPING',6,'2026-08-21 15:40:17','Staff cập nhật trạng thái'),(3,8,'SHIPPING','COMPLETED',6,'2026-08-21 15:40:18','Staff cập nhật trạng thái'),(4,7,'PREPARING','SHIPPING',6,'2026-08-21 15:40:26','Staff cập nhật trạng thái'),(5,7,'SHIPPING','COMPLETED',6,'2026-08-21 15:40:31','Staff cập nhật trạng thái'),(6,3,'PENDING','CANCELLED',6,'2026-08-21 15:49:28','Lười ship'),(7,1,'PENDING','CANCELLED',6,'2026-08-21 15:49:59','Lười giao hàng lắm tự đi mà làm'),(8,6,'SHIPPING','COMPLETED',6,'2026-08-21 15:50:18','Staff cập nhật trạng thái'),(9,2,'PENDING','CONFIRMED',6,'2026-08-21 15:50:23','Staff cập nhật trạng thái'),(10,2,'CONFIRMED','PREPARING',6,'2026-08-21 15:50:26','Staff cập nhật trạng thái'),(11,2,'PREPARING','SHIPPING',6,'2026-08-21 15:50:28','Staff cập nhật trạng thái'),(12,2,'SHIPPING','COMPLETED',6,'2026-08-21 15:50:30','Staff cập nhật trạng thái'),(13,9,NULL,'COMPLETED',6,'2026-08-21 16:01:01','Tạo đơn tại quầy (POS)'),(14,10,NULL,'COMPLETED',6,'2026-08-21 16:01:36','Tạo đơn tại quầy (POS)'),(15,10,'SHIPPING','COMPLETED',3,'2026-09-05 03:12:24','Staff cập nhật trạng thái'),(16,15,NULL,'COMPLETED',3,'2026-09-05 04:23:02','Tạo đơn tại quầy (POS)'),(17,19,'PENDING','CONFIRMED',3,'2026-09-06 15:59:09','Staff cập nhật trạng thái'),(18,19,'CONFIRMED','PREPARING',3,'2026-09-06 15:59:11','Staff cập nhật trạng thái'),(19,19,'PREPARING','SHIPPING',3,'2026-09-06 15:59:15','Staff cập nhật trạng thái');
/*!40000 ALTER TABLE `order_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `receiver_phone` varchar(50) NOT NULL,
  `receiver_address` varchar(500) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `order_status` varchar(50) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_source` enum('WEBSITE','STORE') DEFAULT 'WEBSITE',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',1200000.00,'TRANSFER_QR','PENDING','CANCELLED','','2026-08-20 02:23:16','WEBSITE'),(2,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',1400000.00,'TRANSFER_QR','PENDING','COMPLETED','','2026-08-20 02:24:14','WEBSITE'),(3,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',240000.00,'COD','PENDING','CANCELLED','','2026-08-20 02:24:55','WEBSITE'),(4,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',480000.00,'TRANSFER_QR','PENDING','CANCELLED','','2026-08-20 02:25:27','WEBSITE'),(5,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',240000.00,'COD','PENDING','PENDING','','2026-08-20 02:34:58','WEBSITE'),(6,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',1440000.00,'COD','PENDING','COMPLETED','','2026-08-20 02:39:20','WEBSITE'),(7,5,'Đỗ Phát Đạt','01234567899','Chưa cập nhật',1200000.00,'COD','PENDING','COMPLETED','','2026-08-20 02:40:18','WEBSITE'),(8,7,'nguyenvana','01234567890','Chưa cập nhật',5097000.00,'COD','PENDING','COMPLETED','','2026-08-21 14:30:09','WEBSITE'),(9,NULL,'Khách lẻ','0346960955','Mua tại quầy',25000.00,'BANKING','PAID','COMPLETED','Nhân viên Đỗ Phát Đạt tạo đơn.','2026-08-21 16:01:01','STORE'),(10,NULL,'Khách lẻ','','Mua tại quầy',3398000.00,'BANKING','PAID','CONFIRMED','Nhân viên Đỗ Phát Đạt tạo đơn.','2026-08-21 16:01:36','STORE'),(11,7,'nguyenvana','01234567890','Chưa cập nhật',5000000.00,'TRANSFER_QR','PENDING','PENDING','','2026-09-05 04:01:02','WEBSITE'),(12,7,'nguyenvana','01234567890','Chưa cập nhật',1000000.00,'COD','PENDING','PENDING','','2026-09-05 04:01:26','WEBSITE'),(13,7,'nguyenvana','01234567890','Chưa cập nhật',1000000.00,'COD','PENDING','PENDING','','2026-09-05 04:07:58','WEBSITE'),(14,7,'nguyenvana','01234567890','Chưa cập nhật',1699000.00,'COD','PENDING','PENDING','','2026-09-05 04:09:35','WEBSITE'),(15,NULL,'Khách lẻ','','Mua tại quầy',200000.00,'CASH','PAID','COMPLETED','Nhân viên Nguyễn Văn A tạo đơn.','2026-09-05 04:23:02','STORE'),(16,7,'nguyenvana','01234567890','Chưa cập nhật',1699000.00,'COD','PENDING','PENDING','','2026-09-06 14:13:02','WEBSITE'),(17,7,'hello1234','01234567890','Chưa cập nhật',3000000.00,'TRANSFER_QR','PENDING','COMPLETED','test chuc nang thanh toan','2026-09-06 14:14:27','WEBSITE'),(18,7,'khachhang','01234567890','Chưa cập nhật',22087000.00,'COD','PENDING','CANCELLED','','2026-09-06 14:42:48','WEBSITE'),(19,7,'duc viet','01234567890','Chưa cập nhật',720000.00,'COD','PENDING','COMPLETED','','2026-09-06 14:43:33','WEBSITE'),(20,7,'hello','01234567890','89 lê đức thọ',3558000.00,'COD','PENDING','CONFIRMED','','2026-09-06 16:22:13','WEBSITE'),(21,7,'anh dat','01234567890','89 lê đức thọ',2400000.00,'COD','PENDING','PREPARING','','2026-09-06 16:23:19','WEBSITE'),(22,7,'hello','01234567890','89 lê đức thọ',240000.00,'COD','PENDING','CONFIRMED','','2026-09-06 16:23:52','WEBSITE');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text,
  `price` double NOT NULL,
  `unit` varchar(20) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE','HIDDEN') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `idx_product_name` (`name`),
  KEY `idx_product_price` (`price`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,2,'Táo Fuji Nhật Bản','Táo Fuji giòn ngọt, vỏ đỏ sậm',150000,'kg',50,'tao-fuji.jpg','Nhật Bản','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(2,2,'Táo Envy New Zealand','Táo Envy thơm đặc trưng, thịt táo giòn đanh',220000,'kg',40,'tao-envy.jpg','New Zealand','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(3,2,'Cam Mỹ Không Hạt','Cam ngọt nước, múi to, không hạt',120000,'kg',100,'cam-my.jpg','Mỹ','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(4,1,'Cam Cao Phong','Cam đặc sản Hòa Bình, vị chua ngọt thanh mát',45000,'kg',200,'cam-cao-phong.jpg','Hòa Bình, VN','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(5,2,'Nho Xanh Không Hạt Autumn Crisp','Nho quả to, giòn rụm, ngọt lịm',280000,'kg',25,'nho-xanh.jpg','Úc','ACTIVE','2026-08-14 14:22:43','2026-08-20 02:24:14'),(6,2,'Nho Đỏ Mỹ','Nho đỏ quả thuôn dài, ngọt đậm',210000,'kg',35,'nho-do.jpg','Mỹ','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(7,1,'Dâu Tây Đà Lạt','Dâu giống Nhật trồng tại Đà Lạt, chua ngọt hài hòa',250000,'hộp',20,'dau-tay.jpg','Đà Lạt, VN','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(8,1,'Xoài Cát Hòa Lộc','Xoài loại 1, thơm nức nở, thịt dẻo ngọt',85000,'kg',60,'xoai-cat.jpg','Tiền Giang, VN','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(9,2,'Xoài Úc R2E2','Trái to, hạt lép, vị ngọt thanh',110000,'kg',45,'xoai-uc.jpg','Úc','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(10,1,'Bơ 034 Lâm Đồng','Bơ sáp dẻo, trái dài, hạt nhỏ',60000,'kg',80,'bo-034.jpg','Lâm Đồng, VN','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(11,1,'Chuối Già Nam Mỹ (Cavendish)','Chuối trồng chuẩn VietGAP, chín tự nhiên',25000,'kg',149,'chuoi.jpg','Đồng Nai, VN','ACTIVE','2026-08-14 14:22:43','2026-08-21 16:01:01'),(12,1,'Thanh Long Ruột Đỏ','Vị ngọt thanh, giải nhiệt cực tốt',40000,'kg',95,'thanh-long.jpg','Bình Thuận, VN','ACTIVE','2026-08-14 14:22:43','2026-09-05 04:23:02'),(13,2,'Kiwi Vàng New Zealand','Kiwi vàng ngọt ngào, giàu vitamin C',240000,'kg',12,'kiwi.jpg','New Zealand','ACTIVE','2026-08-14 14:22:43','2026-09-06 16:23:52'),(14,2,'Lê Nâu Hàn Quốc','Quả to, mọng nước, vị ngọt mát',130000,'kg',70,'le-han-quoc.jpg','Hàn Quốc','ACTIVE','2026-08-14 14:22:43','2026-08-14 14:22:43'),(15,1,'Dưa Lưới Tròn','Trồng nhà màng, lưới nứt đều, ruột cam giòn',80000,'quả',48,'dua-luoi.jpg','Việt Nam','ACTIVE','2026-08-14 14:22:43','2026-09-06 16:22:13'),(16,1,'Khánh T1','',150000,'kg',0,'tao-fuji.jpg','','INACTIVE','2026-08-21 14:00:19','2026-08-21 14:11:45'),(17,2,'Khánh T2','',1699000,'kg',83,'https://cdn.hstatic.net/products/200000528965/nho-mau-don-han-quoc-klever-fruit_646268c0e9634dfd8e650f0774d03e02_master.jpg','','ACTIVE','2026-08-21 14:11:14','2026-09-06 16:22:13'),(18,2,'Usagi bel','',1000000,'kg',10,'https://www.bing.com/th/id/OIP.1SZtK4heHlXtL6dGpzEdFgHaEK?w=193&h=135&c=8&rs=1&qlt=90&o=6&dpr=2.3&pid=ImgAns&rm=2','Japan','ACTIVE','2026-08-22 09:56:05','2026-09-08 02:48:05'),(19,1,'ừa','ừ',100000000,'kg',20,'https://cdn.hstatic.net/products/200000528965/nho-mau-don-han-quoc-klever-fruit_646268c0e9634dfd8e650f0774d03e02_master.jpg','Nhật Bản','ACTIVE','2026-09-06 16:43:25','2026-09-08 01:57:07'),(20,6,'Khánh cute','',100000,'kg',5,'Office365.png','Nhật Bản','ACTIVE','2026-09-08 02:44:30','2026-09-08 03:07:44'),(21,1,'Khánh T2','',12,'kg',14,'','','INACTIVE','2026-09-08 02:57:05','2026-09-08 02:57:09');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `order_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `reviews_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_vouchers`
--

DROP TABLE IF EXISTS `user_vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `voucher_id` int NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `collected_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_voucher` (`user_id`,`voucher_id`),
  KEY `voucher_id` (`voucher_id`),
  KEY `idx_user_voucher_wallet` (`user_id`,`is_used`),
  CONSTRAINT `user_vouchers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_vouchers_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_vouchers`
--

LOCK TABLES `user_vouchers` WRITE;
/*!40000 ALTER TABLE `user_vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `role` enum('CUSTOMER','STAFF','ADMIN') DEFAULT 'CUSTOMER',
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `avatar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Quản trị viên','admin@fruitfarmermarket.com','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','0988888888','Hà Nội','ADMIN','ACTIVE','2026-08-14 14:22:43',NULL),(2,'Khách Hàng Một','customer@gmail.com','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','0912345678','Việt Trì, Phú Thọ','CUSTOMER','ACTIVE','2026-08-14 14:22:43',NULL),(3,'Nguyễn Văn A','nhanvien@gmail.com','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','0909090909','Hà Nội','STAFF','ACTIVE','2026-08-14 14:22:43',NULL),(4,'Trần Thị B','tranthib@gmail.com','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','0933333333','TP.HCM','CUSTOMER','ACTIVE','2026-08-14 14:22:43',NULL),(5,'Đỗ Phát Đạt','admin@gmail.com','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','01234567899','Chưa cập nhật','ADMIN','ACTIVE','2026-08-18 03:34:50',NULL),(6,'Đỗ Phát Đạt','1234@gmail.com','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','01234567899','Chưa cập nhật','STAFF','ACTIVE','2026-08-18 04:37:59',NULL),(7,'hello','nguyenvana1@gmail.com','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4','01234567890','89 lê đức thọ','CUSTOMER','ACTIVE','2026-08-21 14:29:22','user_7_Office365.png');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `type` enum('PERCENT','AMOUNT','FREESHIP') DEFAULT 'AMOUNT',
  `discount_value` decimal(12,2) NOT NULL,
  `max_discount_amount` decimal(12,2) DEFAULT NULL,
  `min_order_amount` decimal(12,2) DEFAULT '0.00',
  `usage_limit` int DEFAULT '100',
  `used_count` int DEFAULT '0',
  `expiry_date` date NOT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_voucher_code` (`code`),
  KEY `idx_voucher_active` (`status`,`expiry_date`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` VALUES (1,'TEST VOUCHER','PERCENT',22.00,220000.00,200000.00,100,0,'2026-09-10','ACTIVE','2026-09-08 03:47:45'),(2,'A+ JAVA CORE','AMOUNT',5.00,500000.00,1000000.00,100,0,'2026-09-15','ACTIVE','2026-09-08 03:49:33'),(3,'HIHIHIHI','AMOUNT',30.00,1000000.00,4000000.00,20,0,'2026-09-15','ACTIVE','2026-09-08 03:51:21');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_my_vouchers`
--

DROP TABLE IF EXISTS `vw_my_vouchers`;
/*!50001 DROP VIEW IF EXISTS `vw_my_vouchers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_my_vouchers` AS SELECT 
 1 AS `user_id`,
 1 AS `voucher_id`,
 1 AS `code`,
 1 AS `type`,
 1 AS `discount_value`,
 1 AS `min_order_amount`,
 1 AS `expiry_date`,
 1 AS `is_used`,
 1 AS `current_state`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_my_vouchers`
--

/*!50001 DROP VIEW IF EXISTS `vw_my_vouchers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_my_vouchers` AS select `uv`.`user_id` AS `user_id`,`v`.`id` AS `voucher_id`,`v`.`code` AS `code`,`v`.`type` AS `type`,`v`.`discount_value` AS `discount_value`,`v`.`min_order_amount` AS `min_order_amount`,`v`.`expiry_date` AS `expiry_date`,`uv`.`is_used` AS `is_used`,(case when (`v`.`expiry_date` < curdate()) then 'EXPIRED' when (`uv`.`is_used` = true) then 'USED' else 'AVAILABLE' end) AS `current_state` from (`user_vouchers` `uv` join `vouchers` `v` on((`uv`.`voucher_id` = `v`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-10 10:16:45
