CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(24) NOT NULL,
  `last_active` int(10) unsigned NOT NULL,
  `contents` text NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `last_active` (`last_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `roles` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'login', 'Login privileges, granted after account confirmation'),
(2, 'admin', 'Administrative user, has access to everything.');

CREATE TABLE IF NOT EXISTS `roles_users` (
  `user_id` INT(10) UNSIGNED NOT NULL,
  `role_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(127) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` char(64) NOT NULL,
  `logins` int(10) unsigned NOT NULL DEFAULT '0',
  `created` int(10) unsigned DEFAULT NULL,
  `last_login` int(10) unsigned DEFAULT NULL,
  `timezone_id` int(11) unsigned DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `about` mediumtext DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `gravatar` int(1) DEFAULT NULL,
  `post_count` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `user_tokens` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) UNSIGNED NOT NULL,
  `user_agent` VARCHAR(40) NOT NULL,
  `token` VARCHAR(40) NOT NULL,
  `created` INT(10) UNSIGNED NOT NULL,
  `expires` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_token` (`token`),
  KEY `fk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


ALTER TABLE `roles_users`
  ADD CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS `forum_categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(30) NOT NULL,
  `description` varchar(50) NOT NULL,
  `locked` int(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci AUTO_INCREMENT=4;

INSERT INTO `forum_categories` (`id`, `title`, `description`, `locked`) VALUES
(1, 'News', 'Only admins can create topics here', 1),
(2, 'General', 'General discussions', 0),
(3, 'Marketplace', 'Buy and sell items', 0);


CREATE TABLE IF NOT EXISTS `forum_posts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `content` text NOT NULL,
  `created` int(10) NOT NULL,
  `updated` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci AUTO_INCREMENT=1;


CREATE TABLE IF NOT EXISTS `forum_topics` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `title` varchar(30) NOT NULL,
  `status` varchar(12) NOT NULL,
  `total` int(6) NOT NULL,
  `created` int(10) NOT NULL,
  `last_post_id` int(11) unsigned NOT NULL,
  `sticky` int(10) NOT NULL,
  `locked` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci AUTO_INCREMENT=1;


CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `created` int(10) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `text` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `user_timezones` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `timezone` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=225 ;

INSERT INTO `user_timezones` (`id`, `timezone`, `name`) VALUES
(1, 'Pacific/Midway', '(GMT-11:00) Midway Island'),
(2, 'US/Samoa', '(GMT-11:00) Samoa'),
(3, 'US/Hawaii', '(GMT-10:00) Hawaii'),
(4, 'US/Alaska', '(GMT-09:00) Alaska'),
(5, 'US/Pacific', '(GMT-08:00) Pacific Time (US &amp; Canada)'),
(6, 'America/Tijuana', '(GMT-08:00) Tijuana'),
(7, 'US/Arizona', '(GMT-07:00) Arizona'),
(8, 'US/Mountain', '(GMT-07:00) Mountain Time (US &amp; Canada)'),
(9, 'America/Chihuahua', '(GMT-07:00) Chihuahua'),
(10, 'America/Mazatlan', '(GMT-07:00) Mazatlan'),
(11, 'America/Mexico_City', '(GMT-06:00) Mexico City'),
(12, 'America/Monterrey', '(GMT-06:00) Monterrey'),
(13, 'Canada/Saskatchewan', '(GMT-06:00) Saskatchewan'),
(14, 'US/Central', '(GMT-06:00) Central Time (US &amp; Canada)'),
(15, 'US/Eastern', '(GMT-05:00) Eastern Time (US &amp; Canada)'),
(16, 'US/East-Indiana', '(GMT-05:00) Indiana (East)'),
(17, 'America/Bogota', '(GMT-05:00) Bogota'),
(18, 'America/Lima', '(GMT-05:00) Lima'),
(19, 'America/Caracas', '(GMT-04:30) Caracas'),
(20, 'Canada/Atlantic', '(GMT-04:00) Atlantic Time (Canada)'),
(21, 'America/La_Paz', '(GMT-04:00) La Paz'),
(22, 'America/Santiago', '(GMT-04:00) Santiago'),
(23, 'Canada/Newfoundland', '(GMT-03:30) Newfoundland'),
(24, 'America/Buenos_Aires', '(GMT-03:00) Buenos Aires'),
(25, 'Greenland', '(GMT-03:00) Greenland'),
(26, 'Atlantic/Stanley', '(GMT-02:00) Stanley'),
(27, 'Atlantic/Azores', '(GMT-01:00) Azores'),
(28, 'Atlantic/Cape_Verde', '(GMT-01:00) Cape Verde Is.'),
(29, 'Africa/Casablanca', '(GMT) Casablanca'),
(30, 'Europe/Dublin', '(GMT) Dublin'),
(31, 'Europe/Lisbon', '(GMT) Lisbon'),
(32, 'Europe/London', '(GMT) London'),
(33, 'Africa/Monrovia', '(GMT) Monrovia'),
(34, 'Europe/Amsterdam', '(GMT+01:00) Amsterdam'),
(35, 'Europe/Belgrade', '(GMT+01:00) Belgrade'),
(36, 'Europe/Berlin', '(GMT+01:00) Berlin'),
(37, 'Europe/Bratislava', '(GMT+01:00) Bratislava'),
(38, 'Europe/Brussels', '(GMT+01:00) Brussels'),
(39, 'Europe/Budapest', '(GMT+01:00) Budapest'),
(40, 'Europe/Copenhagen', '(GMT+01:00) Copenhagen'),
(41, 'Europe/Ljubljana', '(GMT+01:00) Ljubljana'),
(42, 'Europe/Madrid', '(GMT+01:00) Madrid'),
(43, 'Europe/Paris', '(GMT+01:00) Paris'),
(44, 'Europe/Prague', '(GMT+01:00) Prague'),
(45, 'Europe/Rome', '(GMT+01:00) Rome'),
(46, 'Europe/Sarajevo', '(GMT+01:00) Sarajevo'),
(47, 'Europe/Skopje', '(GMT+01:00) Skopje'),
(48, 'Europe/Stockholm', '(GMT+01:00) Stockholm'),
(49, 'Europe/Vienna', '(GMT+01:00) Vienna'),
(50, 'Europe/Warsaw', '(GMT+01:00) Warsaw'),
(51, 'Europe/Zagreb', '(GMT+01:00) Zagreb'),
(52, 'Europe/Athens', '(GMT+02:00) Athens'),
(53, 'Europe/Bucharest', '(GMT+02:00) Bucharest'),
(54, 'Africa/Cairo', '(GMT+02:00) Cairo'),
(55, 'Africa/Harare', '(GMT+02:00) Harare'),
(56, 'Europe/Helsinki', '(GMT+02:00) Helsinki'),
(57, 'Europe/Istanbul', '(GMT+02:00) Istanbul'),
(58, 'Asia/Jerusalem', '(GMT+02:00) Jerusalem'),
(59, 'Europe/Kiev', '(GMT+02:00) Kyiv'),
(60, 'Europe/Minsk', '(GMT+02:00) Minsk'),
(61, 'Europe/Riga', '(GMT+02:00) Riga'),
(62, 'Europe/Sofia', '(GMT+02:00) Sofia'),
(63, 'Europe/Tallinn', '(GMT+02:00) Tallinn'),
(64, 'Europe/Vilnius', '(GMT+02:00) Vilnius'),
(65, 'Asia/Baghdad', '(GMT+03:00) Baghdad'),
(66, 'Asia/Kuwait', '(GMT+03:00) Kuwait'),
(67, 'Africa/Nairobi', '(GMT+03:00) Nairobi'),
(68, 'Asia/Riyadh', '(GMT+03:00) Riyadh'),
(69, 'Asia/Tehran', '(GMT+03:30) Tehran'),
(70, 'Europe/Moscow', '(GMT+04:00) Moscow'),
(71, 'Asia/Baku', '(GMT+04:00) Baku'),
(72, 'Europe/Volgograd', '(GMT+04:00) Volgograd'),
(73, 'Asia/Muscat', '(GMT+04:00) Muscat'),
(74, 'Asia/Tbilisi', '(GMT+04:00) Tbilisi'),
(75, 'Asia/Yerevan', '(GMT+04:00) Yerevan'),
(76, 'Asia/Kabul', '(GMT+04:30) Kabul'),
(77, 'Asia/Karachi', '(GMT+05:00) Karachi'),
(78, 'Asia/Tashkent', '(GMT+05:00) Tashkent'),
(79, 'Asia/Kolkata', '(GMT+05:30) Kolkata'),
(80, 'Asia/Kathmandu', '(GMT+05:45) Kathmandu'),
(81, 'Asia/Yekaterinburg', '(GMT+06:00) Ekaterinburg'),
(82, 'Asia/Almaty', '(GMT+06:00) Almaty'),
(83, 'Asia/Dhaka', '(GMT+06:00) Dhaka'),
(84, 'Asia/Novosibirsk', '(GMT+07:00) Novosibirsk'),
(85, 'Asia/Bangkok', '(GMT+07:00) Bangkok'),
(86, 'Asia/Jakarta', '(GMT+07:00) Jakarta'),
(87, 'Asia/Krasnoyarsk', '(GMT+08:00) Krasnoyarsk'),
(88, 'Asia/Chongqing', '(GMT+08:00) Chongqing'),
(89, 'Asia/Hong_Kong', '(GMT+08:00) Hong Kong'),
(90, 'Asia/Kuala_Lumpur', '(GMT+08:00) Kuala Lumpur'),
(91, 'Australia/Perth', '(GMT+08:00) Perth'),
(92, 'Asia/Singapore', '(GMT+08:00) Singapore'),
(93, 'Asia/Taipei', '(GMT+08:00) Taipei'),
(94, 'Asia/Ulaanbaatar', '(GMT+08:00) Ulaan Bataar'),
(95, 'Asia/Urumqi', '(GMT+08:00) Urumqi'),
(96, 'Asia/Irkutsk', '(GMT+09:00) Irkutsk'),
(97, 'Asia/Seoul', '(GMT+09:00) Seoul'),
(98, 'Asia/Tokyo', '(GMT+09:00) Tokyo'),
(99, 'Australia/Adelaide', '(GMT+09:30) Adelaide'),
(100, 'Australia/Darwin', '(GMT+09:30) Darwin'),
(101, 'Asia/Yakutsk', '(GMT+10:00) Yakutsk'),
(102, 'Australia/Brisbane', '(GMT+10:00) Brisbane'),
(103, 'Australia/Canberra', '(GMT+10:00) Canberra'),
(104, 'Pacific/Guam', '(GMT+10:00) Guam'),
(105, 'Australia/Hobart', '(GMT+10:00) Hobart'),
(106, 'Australia/Melbourne', '(GMT+10:00) Melbourne'),
(107, 'Pacific/Port_Moresby', '(GMT+10:00) Port Moresby'),
(108, 'Australia/Sydney', '(GMT+10:00) Sydney'),
(109, 'Asia/Vladivostok', '(GMT+11:00) Vladivostok'),
(110, 'Asia/Magadan', '(GMT+12:00) Magadan'),
(111, 'Pacific/Auckland', '(GMT+12:00) Auckland'),
(112, 'Pacific/Fiji', '(GMT+12:00) Fiji'),
(113, 'Pacific/Midway', '(GMT-11:00) Midway Island'),
(114, 'US/Samoa', '(GMT-11:00) Samoa'),
(115, 'US/Hawaii', '(GMT-10:00) Hawaii'),
(116, 'US/Alaska', '(GMT-09:00) Alaska'),
(117, 'US/Pacific', '(GMT-08:00) Pacific Time (US &amp; Canada)'),
(118, 'America/Tijuana', '(GMT-08:00) Tijuana'),
(119, 'US/Arizona', '(GMT-07:00) Arizona'),
(120, 'US/Mountain', '(GMT-07:00) Mountain Time (US &amp; Canada)'),
(121, 'America/Chihuahua', '(GMT-07:00) Chihuahua'),
(122, 'America/Mazatlan', '(GMT-07:00) Mazatlan'),
(123, 'America/Mexico_City', '(GMT-06:00) Mexico City'),
(124, 'America/Monterrey', '(GMT-06:00) Monterrey'),
(125, 'Canada/Saskatchewan', '(GMT-06:00) Saskatchewan'),
(126, 'US/Central', '(GMT-06:00) Central Time (US &amp; Canada)'),
(127, 'US/Eastern', '(GMT-05:00) Eastern Time (US &amp; Canada)'),
(128, 'US/East-Indiana', '(GMT-05:00) Indiana (East)'),
(129, 'America/Bogota', '(GMT-05:00) Bogota'),
(130, 'America/Lima', '(GMT-05:00) Lima'),
(131, 'America/Caracas', '(GMT-04:30) Caracas'),
(132, 'Canada/Atlantic', '(GMT-04:00) Atlantic Time (Canada)'),
(133, 'America/La_Paz', '(GMT-04:00) La Paz'),
(134, 'America/Santiago', '(GMT-04:00) Santiago'),
(135, 'Canada/Newfoundland', '(GMT-03:30) Newfoundland'),
(136, 'America/Buenos_Aires', '(GMT-03:00) Buenos Aires'),
(137, 'Greenland', '(GMT-03:00) Greenland'),
(138, 'Atlantic/Stanley', '(GMT-02:00) Stanley'),
(139, 'Atlantic/Azores', '(GMT-01:00) Azores'),
(140, 'Atlantic/Cape_Verde', '(GMT-01:00) Cape Verde Is.'),
(141, 'Africa/Casablanca', '(GMT) Casablanca'),
(142, 'Europe/Dublin', '(GMT) Dublin'),
(143, 'Europe/Lisbon', '(GMT) Lisbon'),
(144, 'Europe/London', '(GMT) London'),
(145, 'Africa/Monrovia', '(GMT) Monrovia'),
(146, 'Europe/Amsterdam', '(GMT+01:00) Amsterdam'),
(147, 'Europe/Belgrade', '(GMT+01:00) Belgrade'),
(148, 'Europe/Berlin', '(GMT+01:00) Berlin'),
(149, 'Europe/Bratislava', '(GMT+01:00) Bratislava'),
(150, 'Europe/Brussels', '(GMT+01:00) Brussels'),
(151, 'Europe/Budapest', '(GMT+01:00) Budapest'),
(152, 'Europe/Copenhagen', '(GMT+01:00) Copenhagen'),
(153, 'Europe/Ljubljana', '(GMT+01:00) Ljubljana'),
(154, 'Europe/Madrid', '(GMT+01:00) Madrid'),
(155, 'Europe/Paris', '(GMT+01:00) Paris'),
(156, 'Europe/Prague', '(GMT+01:00) Prague'),
(157, 'Europe/Rome', '(GMT+01:00) Rome'),
(158, 'Europe/Sarajevo', '(GMT+01:00) Sarajevo'),
(159, 'Europe/Skopje', '(GMT+01:00) Skopje'),
(160, 'Europe/Stockholm', '(GMT+01:00) Stockholm'),
(161, 'Europe/Vienna', '(GMT+01:00) Vienna'),
(162, 'Europe/Warsaw', '(GMT+01:00) Warsaw'),
(163, 'Europe/Zagreb', '(GMT+01:00) Zagreb'),
(164, 'Europe/Athens', '(GMT+02:00) Athens'),
(165, 'Europe/Bucharest', '(GMT+02:00) Bucharest'),
(166, 'Africa/Cairo', '(GMT+02:00) Cairo'),
(167, 'Africa/Harare', '(GMT+02:00) Harare'),
(168, 'Europe/Helsinki', '(GMT+02:00) Helsinki'),
(169, 'Europe/Istanbul', '(GMT+02:00) Istanbul'),
(170, 'Asia/Jerusalem', '(GMT+02:00) Jerusalem'),
(171, 'Europe/Kiev', '(GMT+02:00) Kyiv'),
(172, 'Europe/Minsk', '(GMT+02:00) Minsk'),
(173, 'Europe/Riga', '(GMT+02:00) Riga'),
(174, 'Europe/Sofia', '(GMT+02:00) Sofia'),
(175, 'Europe/Tallinn', '(GMT+02:00) Tallinn'),
(176, 'Europe/Vilnius', '(GMT+02:00) Vilnius'),
(177, 'Asia/Baghdad', '(GMT+03:00) Baghdad'),
(178, 'Asia/Kuwait', '(GMT+03:00) Kuwait'),
(179, 'Africa/Nairobi', '(GMT+03:00) Nairobi'),
(180, 'Asia/Riyadh', '(GMT+03:00) Riyadh'),
(181, 'Asia/Tehran', '(GMT+03:30) Tehran'),
(182, 'Europe/Moscow', '(GMT+04:00) Moscow'),
(183, 'Asia/Baku', '(GMT+04:00) Baku'),
(184, 'Europe/Volgograd', '(GMT+04:00) Volgograd'),
(185, 'Asia/Muscat', '(GMT+04:00) Muscat'),
(186, 'Asia/Tbilisi', '(GMT+04:00) Tbilisi'),
(187, 'Asia/Yerevan', '(GMT+04:00) Yerevan'),
(188, 'Asia/Kabul', '(GMT+04:30) Kabul'),
(189, 'Asia/Karachi', '(GMT+05:00) Karachi'),
(190, 'Asia/Tashkent', '(GMT+05:00) Tashkent'),
(191, 'Asia/Kolkata', '(GMT+05:30) Kolkata'),
(192, 'Asia/Kathmandu', '(GMT+05:45) Kathmandu'),
(193, 'Asia/Yekaterinburg', '(GMT+06:00) Ekaterinburg'),
(194, 'Asia/Almaty', '(GMT+06:00) Almaty'),
(195, 'Asia/Dhaka', '(GMT+06:00) Dhaka'),
(196, 'Asia/Novosibirsk', '(GMT+07:00) Novosibirsk'),
(197, 'Asia/Bangkok', '(GMT+07:00) Bangkok'),
(198, 'Asia/Jakarta', '(GMT+07:00) Jakarta'),
(199, 'Asia/Krasnoyarsk', '(GMT+08:00) Krasnoyarsk'),
(200, 'Asia/Chongqing', '(GMT+08:00) Chongqing'),
(201, 'Asia/Hong_Kong', '(GMT+08:00) Hong Kong'),
(202, 'Asia/Kuala_Lumpur', '(GMT+08:00) Kuala Lumpur'),
(203, 'Australia/Perth', '(GMT+08:00) Perth'),
(204, 'Asia/Singapore', '(GMT+08:00) Singapore'),
(205, 'Asia/Taipei', '(GMT+08:00) Taipei'),
(206, 'Asia/Ulaanbaatar', '(GMT+08:00) Ulaan Bataar'),
(207, 'Asia/Urumqi', '(GMT+08:00) Urumqi'),
(208, 'Asia/Irkutsk', '(GMT+09:00) Irkutsk'),
(209, 'Asia/Seoul', '(GMT+09:00) Seoul'),
(210, 'Asia/Tokyo', '(GMT+09:00) Tokyo'),
(211, 'Australia/Adelaide', '(GMT+09:30) Adelaide'),
(212, 'Australia/Darwin', '(GMT+09:30) Darwin'),
(213, 'Asia/Yakutsk', '(GMT+10:00) Yakutsk'),
(214, 'Australia/Brisbane', '(GMT+10:00) Brisbane'),
(215, 'Australia/Canberra', '(GMT+10:00) Canberra'),
(216, 'Pacific/Guam', '(GMT+10:00) Guam'),
(217, 'Australia/Hobart', '(GMT+10:00) Hobart'),
(218, 'Australia/Melbourne', '(GMT+10:00) Melbourne'),
(219, 'Pacific/Port_Moresby', '(GMT+10:00) Port Moresby'),
(220, 'Australia/Sydney', '(GMT+10:00) Sydney'),
(221, 'Asia/Vladivostok', '(GMT+11:00) Vladivostok'),
(222, 'Asia/Magadan', '(GMT+12:00) Magadan'),
(223, 'Pacific/Auckland', '(GMT+12:00) Auckland'),
(224, 'Pacific/Fiji', '(GMT+12:00) Fiji');

CREATE TABLE IF NOT EXISTS `pets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `created` int(10) NOT NULL,
  `abandoned` int(10) NOT NULL,
  `active` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `race_id` int(6) NOT NULL,
  `colour_id` int(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `pet_colours` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `locked` int(1) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `image` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

INSERT INTO `pet_colours` (`id`, `locked`, `name`, `description`, `image`) VALUES
(1, 0, 'Black', 'Black colour', 'black.png'),
(2, 0, 'Blue', 'Blue colour', 'blue.png'),
(3, 0, 'Green', 'Green colour', 'green.png'),
(4, 0, 'Red', 'Red colour', 'red.png'),
(5, 0, 'White', 'White colour', 'white.png'),
(6, 0, 'Yellow', 'Yellow colour', 'yellow.png'),
(7, 1, 'Outline', 'Special outline colour', 'outline.png');

CREATE TABLE IF NOT EXISTS `pet_races` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

INSERT INTO `pet_races` (`id`, `name`, `description`) VALUES
(1, 'Koorai', 'The Koorai'),
(2, 'Zedro', 'The Zedro.');
