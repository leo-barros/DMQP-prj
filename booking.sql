-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 25, 2022 at 01:34 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

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
-- Stand-in structure for view `aboveavgseats`
-- (See below for the actual view)
--
CREATE TABLE `aboveavgseats` (
`floor` int(11)
,`scr_no` int(11)
,`capacity` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(4) NOT NULL,
  `username` varchar(12) NOT NULL,
  `hash` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `hash`) VALUES
(1, 'admin', 'pbkdf2:sha25'),
(3, 'leo', 'pbkdf2:sha256:260000$FDESZThw$c5bad925ff4cfb4a65f9749dcc047b6b69a51c13a906f33d12500c1f52a6cca5');

-- --------------------------------------------------------

--
-- Stand-in structure for view `allnamer`
-- (See below for the actual view)
--
CREATE TABLE `allnamer` (
`fname` varchar(20)
,`lname` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `collectionperday`
-- (See below for the actual view)
--
CREATE TABLE `collectionperday` (
`date` date
,`income per day` bigint(24)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `collectionpermovie`
-- (See below for the actual view)
--
CREATE TABLE `collectionpermovie` (
`movie_id` int(11)
,`title` longtext
,`income per movie` bigint(24)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `custnemp`
-- (See below for the actual view)
--
CREATE TABLE `custnemp` (
`fname` varchar(20)
,`lname` varchar(20)
);

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
  `age` int(11) DEFAULT NULL,
  `hashp` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`phone`, `gender`, `fname`, `lname`, `bdate`, `age`, `hashp`) VALUES
(1234567890, 'm', 'varad', 'kelkar', '2002-07-07', 20, NULL),
(9096652976, 'm', 'vaughan', 'dsouza', '2002-09-27', 20, NULL),
(9421281860, 'm', 'Duane', 'Rodrigues', '2012-01-01', 10, NULL),
(9423884797, 'm', 'Leo', 'Barros', '2001-09-25', 21, NULL);

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
DELIMITER $$
CREATE TRIGGER `before_customer_insert` AFTER INSERT ON `customer` FOR EACH ROW INSERT INTO customer_audit
 SET id=new.phone,
    fname=new.fname,
    lname=new.lname,
    `registered`=CURRENT_DATE(),
    `reg_time`=CURTIME()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_audit`
--

CREATE TABLE `customer_audit` (
  `id` bigint(20) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `registered` date NOT NULL,
  `reg_time` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_audit`
--

INSERT INTO `customer_audit` (`id`, `fname`, `lname`, `registered`, `reg_time`) VALUES
(1234567890, 'varad', 'kelkar', '2022-11-22', '22:03:32'),
(9096652976, 'vaughan', 'dsouza', '2022-11-22', '22:03:32'),
(9421281860, 'Duane', 'Rodrigues', '2022-11-22', '22:03:32'),
(9423884797, 'Leo', 'Barros', '2022-11-22', '22:03:32');

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
(1, 'Cleaning'),
(2, 'Sound'),
(3, 'Lighting');

-- --------------------------------------------------------

--
-- Stand-in structure for view `deptemployee`
-- (See below for the actual view)
--
CREATE TABLE `deptemployee` (
`Dnumber` int(11)
,`type` varchar(20)
,`empid` int(11)
,`fname` varchar(20)
,`lname` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `empdept`
-- (See below for the actual view)
--
CREATE TABLE `empdept` (
`empid` int(11)
,`fname` varchar(20)
,`lname` varchar(20)
,`departmentType` varchar(20)
);

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
  `dno` int(11) DEFAULT NULL,
  `adder_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`empid`, `gender`, `fname`, `lname`, `street`, `state`, `city`, `salary`, `dno`, `adder_id`) VALUES
(1, 'm', 'Isaiah', 'Dcosta', 'Varca', 'Goa', 'Margao', 10000, 1, 1),
(2, 'm', 'joshua', 'couthino', 'bakers', 'goa', 'manchester', 12000, 2, 1),
(3, 'm', 'swizel', ' antao', 'utopia', 'goa', ' varca', 10000, 2, 3),
(4, 'm', 'sanket', 'shenoy', 'elm', 'goa', 'vat', 12000, 3, 3),
(5, 'm', 'varad', 'kelkar', 'b13', 'goa', 'fartoda', 12000, 3, 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `empnevercustomer`
-- (See below for the actual view)
--
CREATE TABLE `empnevercustomer` (
`fname` varchar(20)
,`lname` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `longestmovie`
-- (See below for the actual view)
--
CREATE TABLE `longestmovie` (
`mid` int(11)
,`title` longtext
,`max(``duration_mins``)` int(11)
);

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
(1, 1),
(1, 5),
(2, 1),
(2, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `minsal`
-- (See below for the actual view)
--
CREATE TABLE `minsal` (
`empid` int(11)
,`fname` varchar(20)
,`lname` varchar(20)
,`salary` bigint(20)
);

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
(4, 4, 120, 'UA', 'The Martian', 'English', 'sci-fi', NULL),
(5, 5, 150, 'R', 'Black Panther', 'Hindi', 'action', NULL),
(12, 6, 170, 'UA', 'burnt', 'french', 'drama', 'Adam Jones was the chef at a high-class Parisian restaurant owned by his mentor Jean-Luc, until his drug use and temperamental behavior destroyed his career and the restaurant. In the aftermath, Adam went into self-imposed exile in New Orleans by shucking'),
(13, 1, 165, 'PG-13', 'modern family', 'english', 'comedy', NULL),
(14, 4, 180, 'UA', 'sunrise', 'portuguese', 'romance', NULL);

--
-- Triggers `movie`
--
DELIMITER $$
CREATE TRIGGER `before_movie_delete` BEFORE DELETE ON `movie` FOR EACH ROW INSERT INTO movie_history
 SET id=old.mid,
     title=old.title,
    `language`=old.`language`,
    `genre`=old.`genre`,
    `delete`=CURRENT_DATE(),
    `del_time`=CURTIME()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `moviemoderateduration`
-- (See below for the actual view)
--
CREATE TABLE `moviemoderateduration` (
`mid` int(11)
,`screen_no` int(11)
,`duration_mins` int(11)
,`title` longtext
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `movieshowing`
-- (See below for the actual view)
--
CREATE TABLE `movieshowing` (
`movie_id` int(11)
,`datetime` varchar(21)
,`title` longtext
,`duration_mins` int(11)
,`screen_no` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `movie_history`
--

CREATE TABLE `movie_history` (
  `id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `lang` varchar(10) NOT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `deleted` date NOT NULL,
  `del_time` varchar(10) DEFAULT NULL,
  `action` varchar(10) NOT NULL DEFAULT 'deleted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movie_history`
--

INSERT INTO `movie_history` (`id`, `title`, `lang`, `genre`, `deleted`, `del_time`, `action`) VALUES
(13, 'patterson', 'spanish', 'drama', '2022-11-22', '00:20:04', 'deleted');

-- --------------------------------------------------------

--
-- Stand-in structure for view `nooftickets`
-- (See below for the actual view)
--
CREATE TABLE `nooftickets` (
`trid` varchar(11)
,`no_of_tickets` bigint(21)
,`mode_of_pay` varchar(20)
,`price` int(11)
,`tdate` date
,`cust_phone` bigint(20)
,`time` time
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `sceenmovie`
-- (See below for the actual view)
--
CREATE TABLE `sceenmovie` (
`scr_no` int(11)
,`movieTitle` longtext
);

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
(2, 1, '2d', 50),
(2, 2, '3D', 30),
(3, 4, '2d', 10),
(2, 5, '3d', 45),
(3, 6, '2d', 20);

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `tic_id` int(11) NOT NULL,
  `seat_no` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `mtime` varchar(10) NOT NULL,
  `mdate` date NOT NULL,
  `tid` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`tic_id`, `seat_no`, `movie_id`, `mtime`, `mdate`, `tid`) VALUES
(5, 2, 5, '9:00am', '2022-11-25', '45e2a585'),
(7, 3, 5, '9:00am', '2022-11-25', '86cd3197'),
(9, 1, 5, '9:00am', '2022-11-25', 'f6ee49df'),
(10, 5, 5, '9:00am', '2022-11-25', 'accd7923'),
(14, 37, 5, '9:00am', '2022-11-25', '3fa73315'),
(39, 4, 5, '9:00am', '2022-11-25', 'cae5cc16'),
(44, 6, 5, '9:00am', '2022-11-25', 'cae5cc16'),
(47, 7, 5, '9:00am', '2022-11-25', '6051052c'),
(48, 8, 5, '9:00am', '2022-11-25', '6051052c'),
(49, 9, 5, '9:00am', '2022-11-25', '01213968'),
(50, 10, 5, '9:00am', '2022-11-25', '01213968'),
(51, 11, 5, '9:00am', '2022-11-25', '01213968'),
(55, 13, 5, '9:00am', '2022-11-25', 'ac6d1039'),
(56, 14, 5, '9:00am', '2022-11-25', 'ac6d1039'),
(57, 1, 4, '5:00pm', '2022-11-21', 'c8a7be17'),
(58, 2, 4, '5:00pm', '2022-11-21', 'c8a7be17'),
(59, 1, 4, '5:00pm', '2022-11-23', '2419c381'),
(60, 2, 4, '5:00pm', '2022-11-23', '2419c381'),
(62, 2, 5, '12:00pm', '2022-11-22', 'bafcc4b1'),
(63, 3, 5, '12:00pm', '2022-11-22', 'bafcc4b1');

-- --------------------------------------------------------

--
-- Stand-in structure for view `ticketspermovie`
-- (See below for the actual view)
--
CREATE TABLE `ticketspermovie` (
`mid` int(11)
,`no of tickets` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `timedate`
-- (See below for the actual view)
--
CREATE TABLE `timedate` (
`floor` int(11)
,`scr_no` int(11)
,`timeday` varchar(21)
,`capacity` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `timedate2`
-- (See below for the actual view)
--
CREATE TABLE `timedate2` (
`floor` int(11)
,`scr_no` int(11)
,`timeday` varchar(21)
,`occupied` bigint(21)
,`capacity` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `timedate3`
-- (See below for the actual view)
--
CREATE TABLE `timedate3` (
`floor` int(11)
,`scr_no` int(11)
,`timeday` varchar(21)
,`occupied` bigint(21)
,`capacity` int(11)
,`ratioFull` decimal(27,4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `top3customer`
-- (See below for the actual view)
--
CREATE TABLE `top3customer` (
`fname` varchar(20)
,`lname` varchar(20)
,`total` decimal(32,0)
);

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
('00720bf4', 2, 'cash', 200, '2022-11-20', 9423884797, '13:25:33'),
('01213968', 3, 'gpay', 200, '2022-11-20', 9423884797, '13:51:57'),
('0689522c', 1, 'cash', 200, '2022-11-20', 9423884797, '11:57:00'),
('0a80856c', 1, 'cash', 200, '2022-11-20', 9423884797, '11:03:37'),
('2419c381', 2, 'gpay', 200, '2022-11-21', 9423884797, '13:05:52'),
('39a2a161', 1, 'cash', 200, '2022-11-19', 9423884797, '23:42:13'),
('3fa73315', 1, 'cash', 200, '2022-11-20', 9423884797, '11:22:17'),
('45e2a585', 1, 'gpay', 200, '2022-11-19', 9423884797, '23:31:21'),
('543887ec', 1, 'gpay', 200, '2022-11-20', 9423884797, '11:33:52'),
('554bacc3', 2, 'cash', 200, '2022-11-20', 9423884797, '13:44:53'),
('5f8c711d', 1, 'cash', 200, '2022-11-19', 9423884797, '23:33:58'),
('6051052c', 2, 'cash', 200, '2022-11-20', 9423884797, '13:51:08'),
('6178abbb', 2, 'cash', 200, '2022-11-21', 9423884797, '13:06:58'),
('7f30ce20', 1, 'cash', 200, '2022-11-20', 9423884797, '10:58:52'),
('86cd3197', 1, 'cash', 200, '2022-11-19', 9423884797, '23:41:02'),
('9f163e99', 3, 'gpay', 200, '2022-11-20', 9423884797, '13:52:34'),
('ac6d1039', 2, 'credit card', 200, '2022-11-20', 9423884797, '17:08:42'),
('accd7923', 1, 'cash', 200, '2022-11-20', 9423884797, '10:49:57'),
('b1f53f04', 1, 'cash', 200, '2022-11-20', 9423884797, '10:57:36'),
('bafcc4b1', 2, 'debit card', 200, '2022-11-21', 9423884797, '21:11:46'),
('c6e8413f', 2, 'cash', 200, '2022-11-20', 9423884797, '13:47:25'),
('c8a7be17', 2, 'debit card', 200, '2022-11-21', 9423884797, '12:40:52'),
('cae5cc16', 2, 'cash', 200, '2022-11-20', 9423884797, '13:37:05'),
('df6017d4', 2, 'cash', 200, '2022-11-20', 9423884797, '13:47:42'),
('f6ee49df', 1, 'cash', 200, '2022-11-20', 9423884797, '10:46:52');

-- --------------------------------------------------------

--
-- Structure for view `aboveavgseats`
--
DROP TABLE IF EXISTS `aboveavgseats`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `aboveavgseats`  AS SELECT `screen`.`floor` AS `floor`, `screen`.`scr_no` AS `scr_no`, `screen`.`capacity` AS `capacity` FROM `screen` WHERE `screen`.`capacity` > (select avg(`screen`.`capacity`) from `screen`)  ;

-- --------------------------------------------------------

--
-- Structure for view `allnamer`
--
DROP TABLE IF EXISTS `allnamer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `allnamer`  AS SELECT `employee`.`fname` AS `fname`, `employee`.`lname` AS `lname` FROM `employee` union select `customer`.`fname` AS `fname`,`customer`.`lname` AS `lname` from `customer` order by `fname`,`lname`  ;

-- --------------------------------------------------------

--
-- Structure for view `collectionperday`
--
DROP TABLE IF EXISTS `collectionperday`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `collectionperday`  AS SELECT `ticket`.`mdate` AS `date`, count(`ticket`.`seat_no`) * 200 AS `income per day` FROM `ticket` GROUP BY `ticket`.`mdate``mdate`  ;

-- --------------------------------------------------------

--
-- Structure for view `collectionpermovie`
--
DROP TABLE IF EXISTS `collectionpermovie`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `collectionpermovie`  AS SELECT `ticket`.`movie_id` AS `movie_id`, `movie`.`title` AS `title`, count(`ticket`.`seat_no`) * 200 AS `income per movie` FROM (`ticket` join `movie` on(`ticket`.`movie_id` = `movie`.`mid`)) GROUP BY `ticket`.`movie_id``movie_id`  ;

-- --------------------------------------------------------

--
-- Structure for view `custnemp`
--
DROP TABLE IF EXISTS `custnemp`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `custnemp`  AS SELECT `employee`.`fname` AS `fname`, `employee`.`lname` AS `lname` FROM `employee` intersect select `customer`.`fname` AS `fname`,`customer`.`lname` AS `lname` from `customer` order by `fname`,`lname`  ;

-- --------------------------------------------------------

--
-- Structure for view `deptemployee`
--
DROP TABLE IF EXISTS `deptemployee`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `deptemployee`  AS SELECT `department`.`Dnumber` AS `Dnumber`, `department`.`type` AS `type`, `employee`.`empid` AS `empid`, `employee`.`fname` AS `fname`, `employee`.`lname` AS `lname` FROM (`department` join `employee` on(`department`.`Dnumber` = `employee`.`dno`))  ;

-- --------------------------------------------------------

--
-- Structure for view `empdept`
--
DROP TABLE IF EXISTS `empdept`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `empdept`  AS SELECT `employee`.`empid` AS `empid`, `employee`.`fname` AS `fname`, `employee`.`lname` AS `lname`, `department`.`type` AS `departmentType` FROM (`employee` left join `department` on(`employee`.`dno` = `department`.`Dnumber`)) WHERE `employee`.`dno` = (select `department`.`Dnumber` from `department` where `department`.`type` = 'sound')  ;

-- --------------------------------------------------------

--
-- Structure for view `empnevercustomer`
--
DROP TABLE IF EXISTS `empnevercustomer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `empnevercustomer`  AS SELECT `employee`.`fname` AS `fname`, `employee`.`lname` AS `lname` FROM `employee` WHERE !(`employee`.`fname` in (select `customer`.`fname` from `customer`)) ORDER BY `employee`.`fname` ASC  ;

-- --------------------------------------------------------

--
-- Structure for view `longestmovie`
--
DROP TABLE IF EXISTS `longestmovie`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `longestmovie`  AS SELECT `movie`.`mid` AS `mid`, `movie`.`title` AS `title`, max(`movie`.`duration_mins`) AS `max(``duration_mins``)` FROM `movie``movie`  ;

-- --------------------------------------------------------

--
-- Structure for view `minsal`
--
DROP TABLE IF EXISTS `minsal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `minsal`  AS SELECT `employee`.`empid` AS `empid`, `employee`.`fname` AS `fname`, `employee`.`lname` AS `lname`, `employee`.`salary` AS `salary` FROM `employee` WHERE `employee`.`salary` = (select min(`employee`.`salary`) from `employee`)  ;

-- --------------------------------------------------------

--
-- Structure for view `moviemoderateduration`
--
DROP TABLE IF EXISTS `moviemoderateduration`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `moviemoderateduration`  AS SELECT `movie`.`mid` AS `mid`, `movie`.`screen_no` AS `screen_no`, `movie`.`duration_mins` AS `duration_mins`, `movie`.`title` AS `title` FROM `movie` WHERE `movie`.`duration_mins` between 120 and 165165  ;

-- --------------------------------------------------------

--
-- Structure for view `movieshowing`
--
DROP TABLE IF EXISTS `movieshowing`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `movieshowing`  AS SELECT `ticket`.`movie_id` AS `movie_id`, concat_ws(' ',`ticket`.`mdate`,`ticket`.`mtime`) AS `datetime`, `movie`.`title` AS `title`, `movie`.`duration_mins` AS `duration_mins`, `movie`.`screen_no` AS `screen_no` FROM (`ticket` join `movie` on(`ticket`.`movie_id` = `movie`.`mid`)) GROUP BY concat_ws(' ',`ticket`.`mdate`,`ticket`.`mtime`)  ;

-- --------------------------------------------------------

--
-- Structure for view `nooftickets`
--
DROP TABLE IF EXISTS `nooftickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nooftickets`  AS SELECT `transaction`.`trid` AS `trid`, count(`ticket`.`tid`) AS `no_of_tickets`, `transaction`.`mode_of_pay` AS `mode_of_pay`, `transaction`.`price` AS `price`, `transaction`.`tdate` AS `tdate`, `transaction`.`cust_phone` AS `cust_phone`, `transaction`.`time` AS `time` FROM (`transaction` join `ticket` on(`transaction`.`trid` = `ticket`.`tid`)) GROUP BY `ticket`.`tid``tid`  ;

-- --------------------------------------------------------

--
-- Structure for view `sceenmovie`
--
DROP TABLE IF EXISTS `sceenmovie`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sceenmovie`  AS SELECT `screen`.`scr_no` AS `scr_no`, `movie`.`title` AS `movieTitle` FROM (`screen` left join `movie` on(`screen`.`scr_no` = `movie`.`screen_no`)) ORDER BY `screen`.`scr_no` ASC  ;

-- --------------------------------------------------------

--
-- Structure for view `ticketspermovie`
--
DROP TABLE IF EXISTS `ticketspermovie`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ticketspermovie`  AS SELECT `movie`.`mid` AS `mid`, count(`ticket`.`seat_no`) AS `no of tickets` FROM (`movie` join `ticket` on(`movie`.`mid` = `ticket`.`movie_id`)) GROUP BY `movie`.`mid``mid`  ;

-- --------------------------------------------------------

--
-- Structure for view `timedate`
--
DROP TABLE IF EXISTS `timedate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `timedate`  AS SELECT `screen`.`floor` AS `floor`, `screen`.`scr_no` AS `scr_no`, concat_ws(',',`ticket`.`mdate`,`ticket`.`mtime`) AS `timeday`, `screen`.`capacity` AS `capacity` FROM ((`screen` join `movie` on(`screen`.`scr_no` = `movie`.`screen_no`)) join `ticket` on(`movie`.`mid` = `ticket`.`movie_id`))  ;

-- --------------------------------------------------------

--
-- Structure for view `timedate2`
--
DROP TABLE IF EXISTS `timedate2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `timedate2`  AS SELECT `timedate`.`floor` AS `floor`, `timedate`.`scr_no` AS `scr_no`, `timedate`.`timeday` AS `timeday`, count(`timedate`.`timeday`) AS `occupied`, `timedate`.`capacity` AS `capacity` FROM `timedate` GROUP BY `timedate`.`timeday` ORDER BY `timedate`.`timeday` ASC  ;

-- --------------------------------------------------------

--
-- Structure for view `timedate3`
--
DROP TABLE IF EXISTS `timedate3`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `timedate3`  AS SELECT `timedate2`.`floor` AS `floor`, `timedate2`.`scr_no` AS `scr_no`, `timedate2`.`timeday` AS `timeday`, `timedate2`.`occupied` AS `occupied`, `timedate2`.`capacity` AS `capacity`, `timedate2`.`occupied`/ `timedate2`.`capacity` * 100 AS `ratioFull` FROM `timedate2` ORDER BY `timedate2`.`timeday` ASC  ;

-- --------------------------------------------------------

--
-- Structure for view `top3customer`
--
DROP TABLE IF EXISTS `top3customer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `top3customer`  AS SELECT `customer`.`fname` AS `fname`, `customer`.`lname` AS `lname`, sum(`transaction`.`price`) AS `total` FROM (`customer` join `transaction` on(`customer`.`phone` = `transaction`.`cust_phone`)) GROUP BY `customer`.`phone` ORDER BY sum(`transaction`.`price`) DESC, `customer`.`fname` ASC LIMIT 0, 33  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`phone`);

--
-- Indexes for table `customer_audit`
--
ALTER TABLE `customer_audit`
  ADD PRIMARY KEY (`id`);

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
  ADD KEY `fk_dept_no` (`dno`),
  ADD KEY `fk_admin_no` (`adder_id`);

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
-- Indexes for table `movie_history`
--
ALTER TABLE `movie_history`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `Dnumber` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `empid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `movie`
--
ALTER TABLE `movie`
  MODIFY `mid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `screen`
--
ALTER TABLE `screen`
  MODIFY `scr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `tic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `fk_admin_no` FOREIGN KEY (`adder_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dept_no` FOREIGN KEY (`Dno`) REFERENCES `department` (`Dnumber`) ON DELETE SET NULL ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_trid` FOREIGN KEY (`tid`) REFERENCES `transaction` (`trid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `fk_cust_ph` FOREIGN KEY (`cust_phone`) REFERENCES `customer` (`phone`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
