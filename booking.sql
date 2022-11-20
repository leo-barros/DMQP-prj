-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 20, 2022 at 07:25 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `booking`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `phone` bigint(20) NOT NULL,
  `gender` enum('m','f','o') DEFAULT 'm',
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `bdate` date NOT NULL,
  `age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`phone`, `gender`, `fname`, `lname`, `bdate`, `age`) VALUES
(9096652976, 'm', 'vaughan', 'dsouza', '2002-09-27', 20),
(9423884797, 'm', 'Leo', 'Barros', '2001-09-25', 21);

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `bdate_insert` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
    SET new.age=DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), new.bdate)), '%Y') + 0;
  END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `bdate_update` BEFORE UPDATE ON `customer` FOR EACH ROW BEGIN
    SET new.age=DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), new.bdate)), '%Y') + 0;
  END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `Dnumber` int(11) NOT NULL,
  `type` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`Dnumber`, `type`) VALUES
(1, 'Cleaning');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `empid` int(11) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `street` varchar(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `city` varchar(20) NOT NULL,
  `salary` bigint(20) NOT NULL,
  `dno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `maintains`
--

CREATE TABLE `maintains` (
  `Dno` int(11) NOT NULL,
  `scr_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `maintains`
--

INSERT INTO `maintains` (`Dno`, `scr_no`) VALUES
(1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `movie`
--

CREATE TABLE `movie` (
  `mid` int(11) NOT NULL,
  `screen_no` int(11) NOT NULL,
  `duration_mins` int(11) NOT NULL,
  `rating` varchar(10) DEFAULT NULL,
  `title` longtext NOT NULL,
  `language` varchar(10) NOT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movie`
--

INSERT INTO `movie` (`mid`, `screen_no`, `duration_mins`, `rating`, `title`, `language`, `genre`, `description`) VALUES
(4, 4, 120, '4', 'The Martian', 'English', NULL, NULL),
(5, 5, 120, '5', 'Black Panther', 'Hindi', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `screen`
--

CREATE TABLE `screen` (
  `floor` int(11) NOT NULL,
  `scr_no` int(11) NOT NULL,
  `dimension` varchar(10) NOT NULL,
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `screen`
--

INSERT INTO `screen` (`floor`, `scr_no`, `dimension`, `capacity`) VALUES
(3, 4, '2d', 10),
(2, 5, '45', 45),
(3, 6, '2d', 20);

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `tic_id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `seat_no` int(11) NOT NULL,
  `mtime` varchar(10) NOT NULL,
  `mdate` date NOT NULL,
  `tid` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`tic_id`, `movie_id`, `seat_no`, `mtime`, `mdate`, `tid`) VALUES
(5, 5, 2, '9:00am', '2022-11-25', '45e2a585'),
(7, 5, 3, '9:00am', '2022-11-25', '86cd3197'),
(9, 5, 1, '9:00am', '2022-11-25', 'f6ee49df'),
(10, 5, 5, '9:00am', '2022-11-25', 'accd7923'),
(14, 5, 37, '9:00am', '2022-11-25', '3fa73315'),
(15, 5, 4, '9:00am', '2022-11-25', '543887ec');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `trid` varchar(11) NOT NULL,
  `no_of_tickets` int(11) NOT NULL,
  `mode_of_pay` varchar(20) NOT NULL,
  `price` int(11) NOT NULL,
  `tdate` date NOT NULL,
  `cust_phone` bigint(20) DEFAULT NULL,
  `time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`trid`, `no_of_tickets`, `mode_of_pay`, `price`, `tdate`, `cust_phone`, `time`) VALUES
('0a80856c', 1, 'cash', 200, '2022-11-20', 9423884797, '11:03:37'),
('39a2a161', 1, 'cash', 200, '2022-11-19', 9423884797, '23:42:13'),
('3fa73315', 1, 'cash', 200, '2022-11-20', 9423884797, '11:22:17'),
('45e2a585', 1, 'gpay', 200, '2022-11-19', 9423884797, '23:31:21'),
('543887ec', 1, 'gpay', 200, '2022-11-20', 9423884797, '11:33:52'),
('5f8c711d', 1, 'cash', 200, '2022-11-19', 9423884797, '23:33:58'),
('7f30ce20', 1, 'cash', 200, '2022-11-20', 9423884797, '10:58:52'),
('86cd3197', 1, 'cash', 200, '2022-11-19', 9423884797, '23:41:02'),
('accd7923', 1, 'cash', 200, '2022-11-20', 9423884797, '10:49:57'),
('b1f53f04', 1, 'cash', 200, '2022-11-20', 9423884797, '10:57:36'),
('f6ee49df', 1, 'cash', 200, '2022-11-20', 9423884797, '10:46:52');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`phone`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`Dnumber`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`empid`),
  ADD KEY `fk_dept_no` (`dno`);

--
-- Indexes for table `maintains`
--
ALTER TABLE `maintains`
  ADD PRIMARY KEY (`Dno`,`scr_no`),
  ADD KEY `fk_scr_no` (`scr_no`);

--
-- Indexes for table `movie`
--
ALTER TABLE `movie`
  ADD PRIMARY KEY (`mid`),
  ADD KEY `fk_screen_no` (`screen_no`);

--
-- Indexes for table `screen`
--
ALTER TABLE `screen`
  ADD PRIMARY KEY (`scr_no`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`tic_id`),
  ADD KEY `fk_movie_id` (`movie_id`),
  ADD KEY `fk_trid` (`tid`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`trid`),
  ADD KEY `fk_cust_ph` (`cust_phone`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dnumber` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `empid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `movie`
--
ALTER TABLE `movie`
  MODIFY `mid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `screen`
--
ALTER TABLE `screen`
  MODIFY `scr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `tic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `fk_dept_no` FOREIGN KEY (`dno`) REFERENCES `department` (`Dnumber`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `maintains`
--
ALTER TABLE `maintains`
  ADD CONSTRAINT `fk_dno` FOREIGN KEY (`Dno`) REFERENCES `department` (`Dnumber`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_scr_no` FOREIGN KEY (`scr_no`) REFERENCES `screen` (`scr_no`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `movie`
--
ALTER TABLE `movie`
  ADD CONSTRAINT `fk_screen_no` FOREIGN KEY (`screen_no`) REFERENCES `screen` (`scr_no`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `fk_movie_id` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_trid` FOREIGN KEY (`tid`) REFERENCES `transaction` (`trid`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `fk_cust_ph` FOREIGN KEY (`cust_phone`) REFERENCES `customer` (`phone`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;