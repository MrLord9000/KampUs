-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Czas generowania: 28 Sty 2020, 01:28
-- Wersja serwera: 8.0.19
-- Wersja PHP: 7.2.24-0ubuntu0.18.04.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `mobilki2019test`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `accounts`
--

CREATE TABLE `accounts` (
  `id` int NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `salt` varchar(256) NOT NULL,
  `nickname` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `accounts`
--

INSERT INTO `accounts` (`id`, `email`, `password`, `salt`, `nickname`) VALUES
(2, 'aaa', 'bbb', 'Zp3N05z3RYkixbfLigS6wW6lykPFekZVujodbHbbFsBRxiPbNiVxikB2fEPh7MhGXnJcjhhQaFAaEncR0uuqQBB11rS5vxb5fSiMNUDQiaZjC1R1LzvAbUBLPm6rkF1qxv43EZfFxe9Q19qQkl0NAUDwKnPAqpKmCCT6inL9eRofGdmwwgLEAMDcnzslwqc14Shqgtt5gaKBHTlvFjiFbKbOa4OtJazelMukbxTnTY5X1U8v5iEa7LEZFO6Ds5wv', 'ccc'),
(4, 'test', 'asdf', 'QCnzueFX4gGHzCSIIZmIyawXw3UVSx8lL0z15lEVtrOtqLRJgS5ehCov0Wemfn4AZDGQvwNCtTHeLlFrY2esGCNbABiNx4v5b5E8tNqH9D5BalsF0FlV1yvM0aSy6VQojfUrHkpWYB5zLaVuRJm62xThYMBhK4fyWnJxeeEuvL7Zn6HSflH2XjkLSfgczBGsErXF864gcDdpP43gM151MyDPYVeUGgoUiyGaGo7Bjf3EUeZAsojx3PvGbz1rAkOO', NULL),
(5, 'test2', 'qwerty', 'K8esuq8BFIg9rtBUHFLC77PPhc7U5zSjHX58dY0hbGzF8RGGIDCUrJX3Qb0JX7GTn0ix2XIa0mgDiWCVIgyEMMexasTBmGlF3v8I4tp7padndtPWVYX0DzgYWSPxqaYuBcfn7JRvkmn3dGrR4BooNxLlVDr4l0V7yQycIEbLZWt54BvJJW3a62VqLEIa5mAyRqQZIEZg0WVnsn2japj06TqSU3zbaK0yrcqliNRfocF50Oa27ex0t5gQHM1nMqEc', NULL),
(9, 'test3', 'haslo', '6vKHGnCI4IclpDrjgje2J3KBCZDsSnJFbKuKIpZECH5FheVlK9tshsp744Ip4gHWr6tQAfYNb6P8qukhHnFHTAlIRW0dMufkZNVgNJuwF87jL38qQOp50dwZ82fGrGbOThdeIH6eshKM7Bi65Cs3FaHZSRRZFSa3DF3NU8jLaUCaUfEWSwJhjyChhFsLbDwyO7mhNsIAwcUH4fQGbt0Fc461DraY2pLeKBgvGlTEoRfuS9qSzEUv4PGgYiZievNj', NULL),
(10, 'jankowalskilol89@gmail.com', 'qwerty', 'HbzWeMvO9wn8oXnLDZsedGCsnXZs7hviykYKKjTD14R27ckFyLLxTaECwK7wamPzWQ1OYuVak8Up2i98h1vFINR87B6ITcI7s2lR8AyYTXgzwZ1jNbxkGELgXyh4OhbiIPavJkWsLj6xAUorDKzGBNow9rsMejRLAJ0GKOUYQWO26gfAR2Jego20f67BfB3X0n8huidXWzEBzo1WT9Q7ZcSAy2iVfnfiYjtxsOOFnuQIurFNpOGEdwFce4b72Nxn', NULL),
(11, 'jankowalski89lol@gmail.com', 'qwerty', '12F6SHP48Y3NLb9HTSLdh78tri2SGnxEujWPHcKh1vxFB3ZZiEAEaKGeyINetwEZw1Yf9hVrFMUIe1ZC9bafeS7SpDkHExv14CtJWGRPYFpJzY4SvS1OszzoHWBio9SscLfdWVai8XI3zWEIKvQjAJZUoU30Y9IdOX1Cf8iUEHG5f00obM87adHaafcqbjlzOfdz37xuiGn0xAUhD9R4emT5xeer9XfDOmeAQ2Na6gKcpD1kDnKegqYpL8lb5ROX', NULL),
(13, 'qweweqewqweq', 'ewqewqqwewqewq', 'tbLa8wISDmJD2OcrWKHg2BfIwDG7xsYFTq2ISFBU2WDbv9YfOcOsvibNFi0D2UOKP1hZhXU1yK8tjPcEXFfXoRujPvEBj0AtZ0y7fPOcjEaJpTwnbgBnsGmFOcjU0MANZfQab86LJJknqU5RLw7jMOHwlJ75OtFt8pKSCisJX0dpjvuXwLhYzpWcmJ3il0mfpw85PXtWmQxpAbrCpLwkw986OdJNbwnPj8aJ46qKCDMX3kG5meYVJezF49XWkxez', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `comments`
--

CREATE TABLE `comments` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `loc_id` int NOT NULL,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `locations`
--

CREATE TABLE `locations` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `name` tinytext NOT NULL,
  `description` text NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `category` enum('Dining','University','Entertainment','Parking','Emergency','Other') NOT NULL DEFAULT 'Other'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `locations`
--

INSERT INTO `locations` (`id`, `user_id`, `name`, `description`, `latitude`, `longitude`, `verified`, `category`) VALUES
(60, 2, 'aaa', 'bbbb', 51.75574539412503, 19.45102136582136, 0, 'Dining'),
(61, 4, 'test', 'eipdwbvpiuewvb', 51.75810880938963, 19.45956688374281, 0, 'Entertainment'),
(62, 2, 'test tag #2', 'asdfghjkl', 51.751525057876236, 19.46353990584612, 0, 'Emergency'),
(73, 2, 'Test rozrywka', 'Veniam anim proident consectetur cupidatat tempor qui minim culpa dolore exercitation minim eiusmod officia. Dolor cupidatat nostrud elit consectetur irure enim irure excepteur deserunt adipisicing. Ex duis esse cupidatat ullamco. Culpa anim sunt nostrud ex non laboris sint dolor culpa non. Consequat proident ipsum voluptate ut quis duis ut. Culpa velit excepteur nisi dolor ipsum. Tempor eu est ut ut minim voluptate. Officia ad cillum duis labore do. Nostrud enim et esse elit anim aute ut incididunt commodo incididunt magna commodo duis quis. Mollit commodo in pariatur amet proident incididunt nulla ea. Dolore aliquip proident velit in. Deserunt mollit fugiat nulla ut quis aute elit incididunt deserunt sint officia irure Lorem.', 51.74933856356204, 19.453411549329758, 0, 'Entertainment'),
(74, 2, 'Test parking', 'Veniam anim proident consectetur cupidatat tempor qui minim culpa dolore exercitation minim eiusmod officia. Dolor cupidatat nostrud elit consectetur irure enim irure excepteur deserunt adipisicing. Ex duis esse cupidatat ullamco. Culpa anim sunt nostrud ex non laboris sint dolor culpa non. Consequat proident ipsum voluptate ut quis duis ut. Culpa velit excepteur nisi dolor ipsum. Tempor eu est ut ut minim voluptate. Officia ad cillum duis labore do. Nostrud enim et esse elit anim aute ut incididunt commodo incididunt magna commodo duis quis. Mollit commodo in pariatur amet proident incididunt nulla ea. Dolore aliquip proident velit in. Deserunt mollit fugiat nulla ut quis aute elit incididunt deserunt sint officia irure Lorem.', 51.74723250456793, 19.461114518344402, 0, 'Parking');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `loc_tag`
--

CREATE TABLE `loc_tag` (
  `id` int NOT NULL,
  `loc_id` int NOT NULL,
  `tag_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `loc_tag`
--

INSERT INTO `loc_tag` (`id`, `loc_id`, `tag_id`) VALUES
(2, 62, 179),
(3, 62, 180),
(4, 62, 77);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tags`
--

CREATE TABLE `tags` (
  `id` int NOT NULL,
  `tag` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `tags`
--

INSERT INTO `tags` (`id`, `tag`) VALUES
(36, '111'),
(37, '222'),
(1, 'kampus B'),
(179, 't1'),
(180, 't2'),
(77, 't3'),
(3, 'TEST_TAG');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `thumbs`
--

CREATE TABLE `thumbs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `loc_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeksy dla tabeli `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loc_id` (`loc_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeksy dla tabeli `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeksy dla tabeli `loc_tag`
--
ALTER TABLE `loc_tag`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loc_id` (`loc_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indeksy dla tabeli `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tag` (`tag`);

--
-- Indeksy dla tabeli `thumbs`
--
ALTER TABLE `thumbs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`,`loc_id`),
  ADD KEY `loc_id` (`loc_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT dla tabeli `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT dla tabeli `loc_tag`
--
ALTER TABLE `loc_tag`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=187;

--
-- AUTO_INCREMENT dla tabeli `thumbs`
--
ALTER TABLE `thumbs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`loc_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`id`);

--
-- Ograniczenia dla tabeli `locations`
--
ALTER TABLE `locations`
  ADD CONSTRAINT `locations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`id`);

--
-- Ograniczenia dla tabeli `loc_tag`
--
ALTER TABLE `loc_tag`
  ADD CONSTRAINT `loc_tag_ibfk_1` FOREIGN KEY (`loc_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `loc_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`);

--
-- Ograniczenia dla tabeli `thumbs`
--
ALTER TABLE `thumbs`
  ADD CONSTRAINT `thumbs_ibfk_1` FOREIGN KEY (`loc_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `thumbs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
