/*
 Navicat Premium Dump SQL

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 90300 (9.3.0)
 Source Host           : localhost:3306
 Source Schema         : library

 Target Server Type    : MySQL
 Target Server Version : 90300 (9.3.0)
 File Encoding         : 65001

 Date: 09/12/2025 19:03:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `book_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `author` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `price` int NOT NULL COMMENT 'Price of the book',
  `total_borrowed` int NOT NULL COMMENT 'How many times borrowed',
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Book introduction',
  PRIMARY KEY (`book_title`) USING BTREE,
  INDEX `price`(`price` ASC) USING BTREE,
  INDEX `total_borrowed`(`total_borrowed` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES ('1984', 'George Orwell', 18, 210, 'A dystopian story depicting a totalitarian regime where surveillance and propaganda dominate daily life. It follows Winston Smith as he struggles against a government that controls truth itself.');
INSERT INTO `book` VALUES ('Animal Farm', 'George Orwell', 12, 191, 'A political allegory in which farm animals overthrow their human owner. Their attempt to build an equal society collapses as power and corruption reshape the farm’s new leadership.');
INSERT INTO `book` VALUES ('Brave New World', 'Aldous Huxley', 21, 155, 'A futuristic society built on genetic engineering and constant pleasure. Bernard Marx begins questioning a world where individuality is suppressed in favor of artificial stability and control.');
INSERT INTO `book` VALUES ('Fahrenheit 451', 'Ray Bradbury', 18, 110, 'In a society where books are banned and critical thinking is discouraged, fireman Guy Montag begins to question his role in destroying knowledge, sparking a rebellion within himself.');
INSERT INTO `book` VALUES ('Jane Eyre', 'Charlotte Brontë', 15, 125, 'The life of an orphaned girl who grows into a strong, independent woman. Jane’s resilience and moral conviction guide her through hardship, love, and the search for belonging.');
INSERT INTO `book` VALUES ('Moby Dick', 'Herman Melville', 19, 76, 'An epic journey of obsession as Captain Ahab relentlessly hunts the great white whale. The novel blends adventure with deep reflections on fate, nature, and the human spirit.');
INSERT INTO `book` VALUES ('Pride and Prejudice', 'Jane Austen', 15, 120, 'A timeless romantic novel exploring themes of class, reputation, and love through the witty and independent Elizabeth Bennet, whose sharp insights challenge the societal norms of her time.');
INSERT INTO `book` VALUES ('The Alchemist', 'Paulo Coelho', 13, 166, 'A philosophical journey following Santiago, a shepherd who travels across deserts in search of treasure. His quest reveals lessons about destiny, dreams, and the importance of self-discovery.');
INSERT INTO `book` VALUES ('The Catcher in the Rye', 'J.D. Salinger', 17, 130, 'Holden Caulfield narrates his struggles with identity, loneliness, and growing up. The novel captures teenage rebellion and emotional confusion with raw honesty and lasting cultural influence.');
INSERT INTO `book` VALUES ('The Chronicles of Narnia', 'C.S. Lewis', 22, 178, 'A magical world accessed through a wardrobe invites children into battles of good and evil. The series blends adventure and spiritual symbolism in unforgettable fantasy storytelling.');
INSERT INTO `book` VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 14, 98, 'A tale of wealth, ambition, and illusion in the Jazz Age. Through Nick Carraway’s eyes, the mysterious Jay Gatsby’s pursuit of love reveals the emptiness beneath glittering American dreams.');
INSERT INTO `book` VALUES ('The Hobbit', 'J.R.R. Tolkien', 20, 203, 'Bilbo Baggins is drawn into an unexpected adventure with dwarves and a wizard. The journey, full of danger and wonder, lays the foundation for Tolkien’s epic Middle-earth legend.');
INSERT INTO `book` VALUES ('The Lord of the Rings', 'J.R.R. Tolkien', 25, 230, 'A vast epic following Frodo Baggins as he attempts to destroy a powerful ring. Themes of courage, friendship, and sacrifice define this cornerstone of modern fantasy literature.');
INSERT INTO `book` VALUES ('The Picture of Dorian Gray', 'Oscar Wilde', 16, 143, 'Dorian Gray remains youthful while his portrait ages and reflects his corruption. The novel explores beauty, morality, and the consequences of living without responsibility or restraint.');
INSERT INTO `book` VALUES ('To Kill a Mockingbird', 'Harper Lee', 16, 143, 'A powerful story of racial injustice and moral growth, told through young Scout Finch. Her father, lawyer Atticus Finch, defends an innocent man, challenging prejudice in a divided Southern town.');

-- ----------------------------
-- Table structure for borrow_log
-- ----------------------------
DROP TABLE IF EXISTS `borrow_log`;
CREATE TABLE `borrow_log`  (
  `borrow_id` int NOT NULL,
  `borrower_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `librarian_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `process_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `finished` int NOT NULL DEFAULT 0 COMMENT 'Whether the borrow is completed',
  PRIMARY KEY (`borrow_id`) USING BTREE,
  INDEX `borrower_phone`(`borrower_phone` ASC) USING BTREE,
  INDEX `librarian_id`(`librarian_id` ASC) USING BTREE,
  CONSTRAINT `fk_borrow` FOREIGN KEY (`borrow_id`) REFERENCES `borrow_order` (`borrow_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_librarian` FOREIGN KEY (`librarian_id`) REFERENCES `librarian` (`librarian_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrow_log
-- ----------------------------
INSERT INTO `borrow_log` VALUES (1, '18067311581', 'L001', '2025/12/9 13:10:30', 0);
INSERT INTO `borrow_log` VALUES (4, '13936295057', 'L001', '2025/12/9 17:41:34', 0);
INSERT INTO `borrow_log` VALUES (5, '13936295057', 'L001', '2025/12/9 17:41:36', 0);
INSERT INTO `borrow_log` VALUES (6, '13936295057', 'L001', '2025/12/9 17:23:36', 0);

-- ----------------------------
-- Table structure for borrow_method
-- ----------------------------
DROP TABLE IF EXISTS `borrow_method`;
CREATE TABLE `borrow_method`  (
  `method_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `count` int NOT NULL COMMENT 'number of borrows using this method',
  PRIMARY KEY (`method_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrow_method
-- ----------------------------
INSERT INTO `borrow_method` VALUES ('On-site', 62);
INSERT INTO `borrow_method` VALUES ('Online Reservation', 113);

-- ----------------------------
-- Table structure for borrow_order
-- ----------------------------
DROP TABLE IF EXISTS `borrow_order`;
CREATE TABLE `borrow_order`  (
  `borrow_id` int NOT NULL AUTO_INCREMENT,
  `book_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `borrow_method` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Borrowing method',
  `borrower_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `borrower_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `borrower_address` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `status` int NULL DEFAULT 0 COMMENT '0=new, 1=processing, 2=finished',
  `borrow_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`borrow_id`) USING BTREE,
  INDEX `book_title`(`book_title` ASC) USING BTREE,
  INDEX `borrow_method`(`borrow_method` ASC) USING BTREE,
  INDEX `borrower_phone`(`borrower_phone` ASC) USING BTREE,
  INDEX `borrower_name`(`borrower_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrow_order
-- ----------------------------
INSERT INTO `borrow_order` VALUES (1, '1984', 'On-site', '18067311581', 'Alice Johnson', 'Dorm 1', 1, '2025-09-21 10:32:12');
INSERT INTO `borrow_order` VALUES (2, 'Moby Dick', 'Online Reservation', '13936295057', 'Tom Hardy', 'Dorm 3', 2, '2025-10-21 10:45:12');
INSERT INTO `borrow_order` VALUES (3, 'Animal Farm', 'Online Reservation', '13936295057', 'Tom Hardy', 'Dorm 3', 2, '2025-12-08  23:15:45');
INSERT INTO `borrow_order` VALUES (4, 'Brave New World', 'Online Reservation', '13936295057', 'Tom Hardy', 'Dorm 3', 1, '2025-12-09  11:09:56');
INSERT INTO `borrow_order` VALUES (5, 'The Alchemist', 'On-site', '13936295057', 'Tom Hardy', 'Dorm 3', 2, '2025-12-09 12:15:25');
INSERT INTO `borrow_order` VALUES (6, 'To Kill a Mockingbird', 'Online Reservation', '13936295057', 'Tom Hardy', 'Dorm 3', 1, '2025-12-09 17:23:13');
INSERT INTO `borrow_order` VALUES (7, 'The Hobbit', 'On-site', '13936295057', 'Tom Hardy', 'Dorm 3', 0, '2025-12-09 17:43:46');

-- ----------------------------
-- Table structure for librarian
-- ----------------------------
DROP TABLE IF EXISTS `librarian`;
CREATE TABLE `librarian`  (
  `librarian_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `librarian_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `librarian_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`librarian_id`) USING BTREE,
  INDEX `librarian_name`(`librarian_name` ASC) USING BTREE,
  INDEX `librarian_phone`(`librarian_phone` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of librarian
-- ----------------------------
INSERT INTO `librarian` VALUES ('L001', 'Alice Johnson', '555-2314');
INSERT INTO `librarian` VALUES ('L002', 'Mark Smith', '555-9823');
INSERT INTO `librarian` VALUES ('L003', 'Emma Brown', '555-7732');
INSERT INTO `librarian` VALUES ('L004', 'Brian Linde', '555-9283');

-- ----------------------------
-- Table structure for library_staff
-- ----------------------------
DROP TABLE IF EXISTS `library_staff`;
CREATE TABLE `library_staff`  (
  `staff_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `staff_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `assigned_section` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Book section the staff manages',
  PRIMARY KEY (`staff_id`) USING BTREE,
  INDEX `staff_name`(`staff_name` ASC) USING BTREE,
  INDEX `assigned_section`(`assigned_section` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of library_staff
-- ----------------------------
INSERT INTO `library_staff` VALUES ('S001', 'wang wenwei', 'History');
INSERT INTO `library_staff` VALUES ('S002', 'yin mingye', 'Science Fiction');
INSERT INTO `library_staff` VALUES ('S003', 'lyu haoming', 'Classics');
INSERT INTO `library_staff` VALUES ('S004', 'you liangjun', 'Music');
INSERT INTO `library_staff` VALUES ('S005', 'xia chunqiu', 'Romanticism');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `telephone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `role` int NOT NULL COMMENT '0=reader, 1=admin',
  `linked_librarian_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `username`(`username` ASC) USING BTREE,
  INDEX `telephone`(`telephone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (2, 'alice', '123456789', '18067311581', 1, 'L001');
INSERT INTO `user` VALUES (3, 'tom', 'abcdef', '13936295057', 0, '');

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile`  (
  `id` int UNSIGNED NULL DEFAULT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `sex` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `age` int NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  INDEX `id`(`id` ASC) USING BTREE,
  CONSTRAINT `user_profile_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_profile
-- ----------------------------
INSERT INTO `user_profile` VALUES (2, 'Alice Johnson', 'Female', 22, 'alice@example.com', '18067311581', 'alice');
INSERT INTO `user_profile` VALUES (3, 'Tom Hardy', 'Male', 24, 'tom@example.com', '13936295057', 'tom');

-- ----------------------------
-- View structure for completed_borrow
-- ----------------------------
DROP VIEW IF EXISTS `completed_borrow`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `completed_borrow` AS select `bo`.`borrow_id` AS `borrow_id`,`bo`.`book_title` AS `book_title`,`bo`.`borrow_method` AS `borrow_method`,`bo`.`borrower_phone` AS `borrower_phone`,`bo`.`borrower_name` AS `borrower_name`,`bo`.`borrower_address` AS `borrower_address`,`bl`.`librarian_id` AS `librarian_id`,`bl`.`process_time` AS `process_time`,`l`.`librarian_phone` AS `librarian_phone` from ((`borrow_order` `bo` join `borrow_log` `bl` on((`bo`.`borrow_id` = `bl`.`borrow_id`))) join `librarian` `l` on((`bl`.`librarian_id` = `l`.`librarian_id`))) where (`bo`.`status` = 2);

-- ----------------------------
-- View structure for processing_borrow
-- ----------------------------
DROP VIEW IF EXISTS `processing_borrow`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `processing_borrow` AS select `bo`.`borrow_id` AS `borrow_id`,`bo`.`book_title` AS `book_title`,`bo`.`borrow_method` AS `borrow_method`,`bo`.`borrower_phone` AS `borrower_phone`,`bo`.`borrower_name` AS `borrower_name`,`bo`.`borrower_address` AS `borrower_address`,`bl`.`librarian_id` AS `librarian_id`,`bl`.`process_time` AS `process_time`,`l`.`librarian_phone` AS `librarian_phone` from ((`borrow_order` `bo` join `borrow_log` `bl` on((`bo`.`borrow_id` = `bl`.`borrow_id`))) join `librarian` `l` on((`bl`.`librarian_id` = `l`.`librarian_id`))) where (`bo`.`status` = 1);

-- ----------------------------
-- Triggers structure for table borrow_order
-- ----------------------------
DROP TRIGGER IF EXISTS `borrow_insert`;
delimiter ;;
CREATE TRIGGER `borrow_insert` AFTER INSERT ON `borrow_order` FOR EACH ROW BEGIN
  UPDATE borrow_method
  SET count = count + 1
  WHERE method_name = NEW.borrow_method;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table borrow_order
-- ----------------------------
DROP TRIGGER IF EXISTS `book_borrow_count`;
delimiter ;;
CREATE TRIGGER `book_borrow_count` AFTER INSERT ON `borrow_order` FOR EACH ROW BEGIN
  UPDATE book
  SET total_borrowed = total_borrowed + 1
  WHERE book.book_title = NEW.book_title;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table borrow_order
-- ----------------------------
DROP TRIGGER IF EXISTS `borrow_update`;
delimiter ;;
CREATE TRIGGER `borrow_update` AFTER UPDATE ON `borrow_order` FOR EACH ROW BEGIN
  IF (NEW.borrow_method != OLD.borrow_method) THEN
    UPDATE borrow_method SET count = count - 1 WHERE method_name = OLD.borrow_method;
    UPDATE borrow_method SET count = count + 1 WHERE method_name = NEW.borrow_method;
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table borrow_order
-- ----------------------------
DROP TRIGGER IF EXISTS `borrow_delete`;
delimiter ;;
CREATE TRIGGER `borrow_delete` AFTER DELETE ON `borrow_order` FOR EACH ROW BEGIN
  UPDATE borrow_method
  SET count = count - 1
  WHERE method_name = OLD.borrow_method;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table borrow_order
-- ----------------------------
DROP TRIGGER IF EXISTS `book_borrow_delete`;
delimiter ;;
CREATE TRIGGER `book_borrow_delete` AFTER DELETE ON `borrow_order` FOR EACH ROW BEGIN
  UPDATE book
  SET total_borrowed = total_borrowed - 1
  WHERE book.book_title = OLD.book_title;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
