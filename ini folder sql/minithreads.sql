-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 14, 2026 at 10:42 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `minithreads`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookmarks`
--

CREATE TABLE `bookmarks` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bookmarks`
--

INSERT INTO `bookmarks` (`id`, `user_id`, `post_id`, `created_at`, `updated_at`) VALUES
('019eb13a-2b53-70f4-a732-06d8775ee99e', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019eb13a-10f6-739b-b83f-5fc23963d65d', '2026-06-10 04:10:39', '2026-06-10 04:10:39'),
('019eb24f-9b15-7147-bc28-4060ae1cafff', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019eb14f-7702-71a5-b13f-2cba330a66eb', '2026-06-10 09:13:42', '2026-06-10 09:13:42'),
('019eb26e-86c0-70c8-bb3b-2a7109feda62', '019eb26d-dcfd-727b-a939-e5e369854170', '019eb14f-7702-71a5-b13f-2cba330a66eb', '2026-06-10 09:47:28', '2026-06-10 09:47:28'),
('019ebfa2-d6f6-732e-a976-5790b766b44a', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8aea-7232-acb5-f3eb2b81a754', '2026-06-12 23:19:40', '2026-06-12 23:19:40');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `parent_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `parent_id`, `created_at`, `updated_at`) VALUES
('019ea608-8a14-7386-8474-da55e31e6002', 'Teknologi', 'teknologi', 'Diskusi seputar gadget, software, dan inovasi terbaru.', NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a1a-7211-a2b4-87341b76c200', 'Programming', 'programming', 'Tempat berbagi kode, tutorial, dan tips programming.', NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a1e-700c-828c-37062c6f082a', 'Kesehatan', 'kesehatan', 'Informasi dan tips menjaga kesehatan tubuh dan mental.', NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a23-725c-b263-d913c3fedde5', 'Gaya Hidup', 'gaya-hidup', 'Diskusi hobi, fashion, dan aktivitas sehari-hari.', NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a28-71ef-9364-8d7522870cde', 'Pendidikan', 'pendidikan', 'Berbagi ilmu pengetahuan, beasiswa, dan info kampus.', NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a2d-72b1-899a-45837730d478', 'Hiburan', 'hiburan', 'Film, musik, game, dan berita selebriti.', NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ec506-5905-72ce-a531-10248440dc13', 'Kpopp', 'kpopp', NULL, NULL, '2026-06-14 00:26:28', '2026-06-14 02:25:13');

-- --------------------------------------------------------

--
-- Table structure for table `claps`
--

CREATE TABLE `claps` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clapable_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clapable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `count` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_edited` tinyint(1) NOT NULL DEFAULT '0',
  `vote_score` int NOT NULL DEFAULT '0',
  `is_accepted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `post_id`, `user_id`, `parent_id`, `body`, `is_edited`, `vote_score`, `is_accepted`, `created_at`, `updated_at`, `deleted_at`) VALUES
('019eb24e-eae5-7001-aaae-07d06ccc98c3', '019eb14f-7702-71a5-b13f-2cba330a66eb', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'aa', 1, 1, 0, '2026-06-10 09:12:56', '2026-06-13 21:11:28', NULL),
('019eb24f-009a-720b-8157-3f9431211683', '019eb14f-7702-71a5-b13f-2cba330a66eb', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'a', 0, 1, 0, '2026-06-10 09:13:02', '2026-06-10 09:47:43', NULL),
('019eb26e-99ed-726c-a22b-e8fda6b2d827', '019eb14f-7702-71a5-b13f-2cba330a66eb', '019eb26d-dcfd-727b-a939-e5e369854170', NULL, 'eee', 0, 0, 0, '2026-06-10 09:47:33', '2026-06-10 09:47:33', NULL),
('019ebf9a-1475-732b-bfe9-228dafd11620', '019eb14f-7702-71a5-b13f-2cba330a66eb', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'hahahhahahhahahahahha', 0, 0, 0, '2026-06-12 23:10:06', '2026-06-12 23:10:06', NULL),
('019ebf9a-5d8e-7323-81ea-fb6ffcb159e0', '019eb14f-7702-71a5-b13f-2cba330a66eb', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'hahahhahahhahahahahhahah', 0, 0, 0, '2026-06-12 23:10:25', '2026-06-12 23:10:25', NULL),
('019ebf9c-d89a-7017-80af-8d390d0727fe', '019ea608-8ae0-7250-9064-a3c0d3fe5130', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'hahahahahahaha', 0, 0, 0, '2026-06-12 23:13:07', '2026-06-12 23:13:07', NULL),
('019ebf9d-5d32-7259-927f-3bdc5b58632d', '019ea608-8ae0-7250-9064-a3c0d3fe5130', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'kkkkkkiiiiiiiiiiiiiiiiiiiiiiii', 0, 0, 0, '2026-06-12 23:13:41', '2026-06-12 23:13:41', NULL),
('019ebf9e-b5bb-7022-92dd-c6d8d81fb03a', '019ebf9e-6e48-726e-8670-96af21b1725b', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'tessgsgsgsggssggsgs', 0, 0, 1, '2026-06-12 23:15:10', '2026-06-13 21:10:51', NULL),
('019ebf9f-1017-7138-a8e1-da7344af7f6b', '019ea608-8aab-7399-b025-6c1951efa3b3', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'kkkkkkkkkkkkkkkkkkkk', 0, 0, 0, '2026-06-12 23:15:33', '2026-06-12 23:15:33', NULL),
('019ebf9f-30fe-72b7-8938-b552b79eddc7', '019ea608-8aab-7399-b025-6c1951efa3b3', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'teststststststs', 0, 0, 0, '2026-06-12 23:15:41', '2026-06-12 23:15:41', NULL),
('019ebfa1-c210-71e4-b2ab-ad7ae2edc44d', '019ea608-8aab-7399-b025-6c1951efa3b3', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'dhenddddss', 0, 0, 0, '2026-06-12 23:18:29', '2026-06-12 23:18:29', NULL),
('019ebfa1-ee35-707d-9c8d-6ccbe43bda12', '019ea608-8aab-7399-b025-6c1951efa3b3', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'dheni mac ku', 0, 0, 0, '2026-06-12 23:18:41', '2026-06-12 23:18:41', NULL),
('019ebfa3-93dd-721a-ab5f-ef96c3032d12', '019ea608-8aea-7232-acb5-f3eb2b81a754', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'dheni mac jkuuu', 0, 0, 0, '2026-06-12 23:20:29', '2026-06-12 23:20:29', NULL),
('019ebfa5-ffdb-7314-b4b4-ae9094818a2f', '019ebf9e-6e48-726e-8670-96af21b1725b', '019ebfa5-77e3-737f-8aaa-6a57ea8f9b13', NULL, 'hwwwwaaaaaaaaaaaaaa', 1, 0, 0, '2026-06-12 23:23:07', '2026-06-13 07:57:35', NULL),
('019ec1ea-ced6-7119-89e8-adce60a98913', '019ec1d2-a072-708b-843d-7439ca4359fe', '019ec1d7-81a1-710e-a095-8217ed855a53', NULL, 'adssdsdsdsdsdsdsss', 0, 0, 1, '2026-06-13 09:57:31', '2026-06-13 10:05:51', NULL),
('019ec50f-206c-71e5-b090-dc1aa9623920', '019ec1d2-a072-708b-843d-7439ca4359fe', '019eb132-5bdb-73ad-81df-faad1b3250a6', NULL, 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh', 0, 0, 0, '2026-06-14 00:36:03', '2026-06-14 00:36:03', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `comment_edit_histories`
--

CREATE TABLE `comment_edit_histories` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `edit_number` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comment_edit_histories`
--

INSERT INTO `comment_edit_histories` (`id`, `comment_id`, `user_id`, `old_content`, `new_content`, `edit_number`, `created_at`, `updated_at`) VALUES
('22b9de2d-467a-4dee-88b7-0644ecf1b569', '019eb24e-eae5-7001-aaae-07d06ccc98c3', '019eb132-5bdb-73ad-81df-faad1b3250a6', 'a', 'aa', 1, '2026-06-10 09:13:11', '2026-06-10 09:13:11'),
('f7da815a-203e-4f72-b246-2a315ed9c8b4', '019ebfa5-ffdb-7314-b4b4-ae9094818a2f', '019ebfa5-77e3-737f-8aaa-6a57ea8f9b13', 'hwwwwaaaaaaaaaaaaaaa', 'hwwwwaaaaaaaaaaaaaa', 1, '2026-06-13 07:57:35', '2026-06-13 07:57:35');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `follows`
--

CREATE TABLE `follows` (
  `follower_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `following_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `follows`
--

INSERT INTO `follows` (`follower_id`, `following_id`, `created_at`, `updated_at`) VALUES
('019eb132-5bdb-73ad-81df-faad1b3250a6', '019eb26d-dcfd-727b-a939-e5e369854170', '2026-06-10 09:52:10', '2026-06-10 09:52:10'),
('019eb26d-dcfd-727b-a939-e5e369854170', '019eb132-5bdb-73ad-81df-faad1b3250a6', '2026-06-10 09:53:02', '2026-06-10 09:53:02');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `queue`, `payload`, `attempts`, `reserved_at`, `available_at`, `created_at`) VALUES
(1, 'default', '{\"uuid\":\"5ebe1f94-f394-47a7-a057-56ba7ee2d185\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a0a-7085-8b48-5ef3bb954c43\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostVotedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"cb4a83fd-eb1a-4c50-bb51-f5587f5825a6\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\";s:7:\\\"message\\\";s:79:\\\"dg memberikan upvote pada postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781091298,\"delay\":null}', 0, NULL, 1781091298, 1781091298),
(2, 'default', '{\"uuid\":\"25c422b5-fdcd-4527-885b-dc94c62317b9\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-84e3-7001-a5e8-6c510b21b322\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostLikedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a96-70ce-adae-e79656d0fa37\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"88b777b4-fe0d-4d13-befd-d42140fcd0be\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_liked\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_liked\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8a96-70ce-adae-e79656d0fa37\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-1: 3tAYYXJkmI\\\";s:7:\\\"message\\\";s:65:\\\"dg menyukai postinganmu: \\\"Judul Postingan Dummy Ke-1: 3tAYYXJkmI\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781092077,\"delay\":null}', 0, NULL, 1781092077, 1781092077),
(3, 'default', '{\"uuid\":\"13e0ada2-b478-407a-a8d6-7b9935be9095\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostLikedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019eb14f-7702-71a5-b13f-2cba330a66eb\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"f7ac7bba-229a-4114-9cd1-ffc8f23451dd\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_liked\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_liked\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:8:\\\"username\\\";s:2:\\\"df\\\";s:7:\\\"post_id\\\";s:36:\\\"019eb14f-7702-71a5-b13f-2cba330a66eb\\\";s:10:\\\"post_title\\\";s:25:\\\"ini kapaan slese nya yach\\\";s:7:\\\"message\\\";s:52:\\\"df menyukai postinganmu: \\\"ini kapaan slese nya yach\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781110047,\"delay\":null}', 0, NULL, 1781110047, 1781110047),
(4, 'default', '{\"uuid\":\"16ad7b8a-fb21-493b-b5bd-a1e43fbc9074\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019eb14f-7702-71a5-b13f-2cba330a66eb\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019eb26e-99ed-726c-a22b-e8fda6b2d827\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"333613ef-90af-4083-ac7a-c41b00df021d\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:8:\\\"username\\\";s:2:\\\"df\\\";s:7:\\\"post_id\\\";s:36:\\\"019eb14f-7702-71a5-b13f-2cba330a66eb\\\";s:10:\\\"post_title\\\";s:25:\\\"ini kapaan slese nya yach\\\";s:10:\\\"comment_id\\\";s:36:\\\"019eb26e-99ed-726c-a22b-e8fda6b2d827\\\";s:7:\\\"message\\\";s:58:\\\"df berkomentar di postinganmu: \\\"ini kapaan slese nya yach\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781110053,\"delay\":null}', 0, NULL, 1781110053, 1781110053),
(5, 'default', '{\"uuid\":\"fd3d14a7-4d07-443d-a999-9d4ddbf98b3c\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostVotedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019eb14f-7702-71a5-b13f-2cba330a66eb\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"9dc267a0-e509-4894-a18c-32ac77de53a6\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:8:\\\"username\\\";s:2:\\\"df\\\";s:7:\\\"post_id\\\";s:36:\\\"019eb14f-7702-71a5-b13f-2cba330a66eb\\\";s:10:\\\"post_title\\\";s:25:\\\"ini kapaan slese nya yach\\\";s:7:\\\"message\\\";s:66:\\\"df memberikan upvote pada postinganmu: \\\"ini kapaan slese nya yach\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781110056,\"delay\":null}', 0, NULL, 1781110056, 1781110056),
(6, 'default', '{\"uuid\":\"bd7a8489-5f08-45e9-93a7-931235208d0d\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:42:\\\"App\\\\Notifications\\\\UserFollowedNotification\\\":2:{s:11:\\\"\\u0000*\\u0000follower\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"28688deb-1350-47e7-a98b-30b8d5df6565\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:13:\\\"user_followed\\\";s:4:\\\"data\\\";a:4:{s:4:\\\"type\\\";s:13:\\\"user_followed\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"message\\\";s:29:\\\"dg mulai mengikuti kamu, bro!\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781110330,\"delay\":null}', 0, NULL, 1781110330, 1781110330),
(7, 'default', '{\"uuid\":\"ccebc70b-6bbf-41c6-81b9-b17e41c86dc6\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:42:\\\"App\\\\Notifications\\\\UserFollowedNotification\\\":2:{s:11:\\\"\\u0000*\\u0000follower\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"2521bc6c-9710-4df4-894d-7493f55c60c9\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:13:\\\"user_followed\\\";s:4:\\\"data\\\";a:4:{s:4:\\\"type\\\";s:13:\\\"user_followed\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb26d-dcfd-727b-a939-e5e369854170\\\";s:8:\\\"username\\\";s:2:\\\"df\\\";s:7:\\\"message\\\";s:29:\\\"df mulai mengikuti kamu, bro!\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781110382,\"delay\":null}', 0, NULL, 1781110382, 1781110382),
(8, 'default', '{\"uuid\":\"00f22b61-a5f3-4408-8bda-5f5968135837\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a01-717b-a225-e9775a5c70eb\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8ae0-7250-9064-a3c0d3fe5130\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebf9c-d89a-7017-80af-8d390d0727fe\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"9e5c23eb-b3c8-4c46-9616-d1118ebd377c\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8ae0-7250-9064-a3c0d3fe5130\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-7: l8fbPL39kO\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebf9c-d89a-7017-80af-8d390d0727fe\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-7: l8fbPL39kO\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331187,\"delay\":null}', 0, NULL, 1781331187, 1781331187),
(9, 'default', '{\"uuid\":\"26a71015-0022-4ec4-a643-5f284bc048dd\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a01-717b-a225-e9775a5c70eb\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8ae0-7250-9064-a3c0d3fe5130\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebf9d-5d32-7259-927f-3bdc5b58632d\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"4edc0568-8775-4b62-afcd-d6124de0da58\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8ae0-7250-9064-a3c0d3fe5130\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-7: l8fbPL39kO\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebf9d-5d32-7259-927f-3bdc5b58632d\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-7: l8fbPL39kO\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331221,\"delay\":null}', 0, NULL, 1781331221, 1781331221),
(10, 'default', '{\"uuid\":\"3b29fc48-c5f3-4b71-9217-5b5cf60e83ce\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a0a-7085-8b48-5ef3bb954c43\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebf9f-1017-7138-a8e1-da7344af7f6b\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"d8451946-3b5c-491f-98b5-1006f9e0fbe8\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebf9f-1017-7138-a8e1-da7344af7f6b\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331333,\"delay\":null}', 0, NULL, 1781331333, 1781331333),
(11, 'default', '{\"uuid\":\"9efb7d22-227f-4a19-8b30-d4fae0f8c228\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a0a-7085-8b48-5ef3bb954c43\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebf9f-30fe-72b7-8938-b552b79eddc7\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"7e1b4272-b487-47d4-860c-b716fbf730f7\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebf9f-30fe-72b7-8938-b552b79eddc7\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331341,\"delay\":null}', 0, NULL, 1781331341, 1781331341),
(12, 'default', '{\"uuid\":\"8d436dd6-6bcc-4f11-99d9-d75cf514cd03\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a0a-7085-8b48-5ef3bb954c43\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebfa1-c210-71e4-b2ab-ad7ae2edc44d\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"c82cdcfd-a7a3-4cbd-887d-bbbd2f7dbdc0\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebfa1-c210-71e4-b2ab-ad7ae2edc44d\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331509,\"delay\":null}', 0, NULL, 1781331509, 1781331509),
(13, 'default', '{\"uuid\":\"2db83e46-abbc-4cf8-a64c-43773425b4f8\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8a0a-7085-8b48-5ef3bb954c43\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebfa1-ee35-707d-9c8d-6ccbe43bda12\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"ea2eeff0-84fe-411b-bfb4-31163fa0e129\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aab-7399-b025-6c1951efa3b3\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebfa1-ee35-707d-9c8d-6ccbe43bda12\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331521,\"delay\":null}', 0, NULL, 1781331521, 1781331521),
(14, 'default', '{\"uuid\":\"9455cc1f-1bb4-4a5f-8cb4-8e9a10cd7b21\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-89f2-7311-8f2b-8135d5ae8afc\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostVotedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aea-7232-acb5-f3eb2b81a754\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"014bde75-bb50-49dc-8621-03efb48cedf5\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aea-7232-acb5-f3eb2b81a754\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\";s:7:\\\"message\\\";s:79:\\\"dg memberikan upvote pada postinganmu: \\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331576,\"delay\":null}', 0, NULL, 1781331576, 1781331576),
(15, 'default', '{\"uuid\":\"b7f2d48f-1dde-41d5-871a-4a3437c5e319\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-89f2-7311-8f2b-8135d5ae8afc\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostLikedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aea-7232-acb5-f3eb2b81a754\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"1d9c769a-c3d2-4952-9070-f95898b28f62\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_liked\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_liked\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aea-7232-acb5-f3eb2b81a754\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\";s:7:\\\"message\\\";s:65:\\\"dg menyukai postinganmu: \\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331579,\"delay\":null}', 0, NULL, 1781331579, 1781331579),
(16, 'default', '{\"uuid\":\"6111a2f5-78c7-4def-b049-faed1c519b92\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-89f2-7311-8f2b-8135d5ae8afc\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ea608-8aea-7232-acb5-f3eb2b81a754\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebfa3-93dd-721a-ab5f-ef96c3032d12\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"4bd7ad33-3a45-41cc-987d-2d4f4589df1f\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ea608-8aea-7232-acb5-f3eb2b81a754\\\";s:10:\\\"post_title\\\";s:38:\\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebfa3-93dd-721a-ab5f-ef96c3032d12\\\";s:7:\\\"message\\\";s:71:\\\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331629,\"delay\":null}', 0, NULL, 1781331629, 1781331629),
(17, 'default', '{\"uuid\":\"ea29c4a6-f16b-4061-b8bf-a80b86d3d44c\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ebf9e-6e48-726e-8670-96af21b1725b\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ebfa5-ffdb-7314-b4b4-ae9094818a2f\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ebfa5-77e3-737f-8aaa-6a57ea8f9b13\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"d88823e8-a050-46dc-8fe7-e2b8d62d180e\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019ebfa5-77e3-737f-8aaa-6a57ea8f9b13\\\";s:8:\\\"username\\\";s:5:\\\"dheni\\\";s:7:\\\"post_id\\\";s:36:\\\"019ebf9e-6e48-726e-8670-96af21b1725b\\\";s:10:\\\"post_title\\\";s:17:\\\"dsdasdasbd bnsdbs\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ebfa5-ffdb-7314-b4b4-ae9094818a2f\\\";s:7:\\\"message\\\";s:53:\\\"dheni berkomentar di postinganmu: \\\"dsdasdasbd bnsdbs\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781331787,\"delay\":null}', 0, NULL, 1781331787, 1781331787);
INSERT INTO `jobs` (`id`, `queue`, `payload`, `attempts`, `reserved_at`, `available_at`, `created_at`) VALUES
(18, 'default', '{\"uuid\":\"e5b5e070-b77e-4fe6-a646-cf50fb481e30\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:39:\\\"App\\\\Notifications\\\\PostVotedNotification\\\":3:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"08a74165-1f8b-4fe8-b6fe-17322e3d87af\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:4:\\\"data\\\";a:6:{s:4:\\\"type\\\";s:10:\\\"post_voted\\\";s:7:\\\"user_id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:8:\\\"username\\\";s:6:\\\"melvin\\\";s:7:\\\"post_id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:10:\\\"post_title\\\";s:10:\\\"tes arsips\\\";s:7:\\\"message\\\";s:55:\\\"melvin memberikan upvote pada postinganmu: \\\"tes arsips\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781368603,\"delay\":null}', 0, NULL, 1781368603, 1781368603),
(19, 'default', '{\"uuid\":\"d4913a90-cabb-4ae4-932c-c12f4169cf90\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:40:\\\"App\\\\Notifications\\\\NewCommentNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"b6891c88-dca1-4e10-b548-4e49c172855b\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:11:\\\"new_comment\\\";s:7:\\\"user_id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:8:\\\"username\\\";s:6:\\\"melvin\\\";s:7:\\\"post_id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:10:\\\"post_title\\\";s:10:\\\"tes arsips\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:7:\\\"message\\\";s:47:\\\"melvin berkomentar di postinganmu: \\\"tes arsips\\\"\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781369851,\"delay\":null}', 0, NULL, 1781369851, 1781369851),
(20, 'default', '{\"uuid\":\"ab0ec1af-8894-4372-8556-974252e18e86\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:44:\\\"App\\\\Notifications\\\\AnswerAcceptedNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"8487eaf5-efdc-4e5e-a621-63f365c8b076\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:10:\\\"post_title\\\";s:10:\\\"tes arsips\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:7:\\\"message\\\";s:85:\\\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781369871,\"delay\":null}', 0, NULL, 1781369871, 1781369871),
(21, 'default', '{\"uuid\":\"9a8788c3-dc22-4c15-8401-3a7e63fd7acf\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:44:\\\"App\\\\Notifications\\\\AnswerAcceptedNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"f87885dd-a39a-411b-9040-25bbb17a619a\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:10:\\\"post_title\\\";s:10:\\\"tes arsips\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:7:\\\"message\\\";s:85:\\\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781369895,\"delay\":null}', 0, NULL, 1781369895, 1781369895),
(22, 'default', '{\"uuid\":\"1a32ab29-f7a5-4b1f-a781-e4b78f6aeb4b\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:44:\\\"App\\\\Notifications\\\\AnswerAcceptedNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"24b1d10b-e4b2-4f43-a3d8-e64b2d5b658b\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:10:\\\"post_title\\\";s:10:\\\"tes arsips\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:7:\\\"message\\\";s:85:\\\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781370204,\"delay\":null}', 0, NULL, 1781370204, 1781370204),
(23, 'default', '{\"uuid\":\"6ab96d31-28bd-41b9-989e-720580feaaed\",\"displayName\":\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":17:{s:5:\\\"event\\\";O:60:\\\"Illuminate\\\\Notifications\\\\Events\\\\BroadcastNotificationCreated\\\":3:{s:10:\\\"notifiable\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d7-81a1-710e-a095-8217ed855a53\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:12:\\\"notification\\\";O:44:\\\"App\\\\Notifications\\\\AnswerAcceptedNotification\\\":4:{s:7:\\\"\\u0000*\\u0000post\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\Post\\\";s:2:\\\"id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"\\u0000*\\u0000comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:7:\\\"\\u0000*\\u0000user\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:2:\\\"id\\\";s:36:\\\"17225886-a42b-4b72-b5ed-658ae0e36d6f\\\";}s:4:\\\"data\\\";a:2:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:4:\\\"data\\\";a:7:{s:4:\\\"type\\\";s:15:\\\"answer_accepted\\\";s:7:\\\"user_id\\\";s:36:\\\"019eb132-5bdb-73ad-81df-faad1b3250a6\\\";s:8:\\\"username\\\";s:2:\\\"dg\\\";s:7:\\\"post_id\\\";s:36:\\\"019ec1d2-a072-708b-843d-7439ca4359fe\\\";s:10:\\\"post_title\\\";s:10:\\\"tes arsips\\\";s:10:\\\"comment_id\\\";s:36:\\\"019ec1ea-ced6-7119-89e8-adce60a98913\\\";s:7:\\\"message\\\";s:85:\\\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\\\";}}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:23:\\\"deleteWhenMissingModels\\\";b:1;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781370351,\"delay\":null}', 0, NULL, 1781370351, 1781370351);

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`id`, `user_id`, `target_id`, `target_type`, `created_at`, `updated_at`) VALUES
('019eb13a-30a9-71e2-b273-68354a697b5e', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019eb13a-10f6-739b-b83f-5fc23963d65d', 'post', '2026-06-10 04:10:41', '2026-06-10 04:10:41'),
('019eb24f-0e3e-7190-81e3-9db5fbbd43e8', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'post', '2026-06-10 09:13:05', '2026-06-10 09:13:05'),
('019eb26e-81b7-70b3-9cfd-1b046bc5c755', '019eb26d-dcfd-727b-a939-e5e369854170', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'post', '2026-06-10 09:47:27', '2026-06-10 09:47:27'),
('019ebfa2-d057-720d-8a33-c7c759a17a54', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8aea-7232-acb5-f3eb2b81a754', 'post', '2026-06-12 23:19:38', '2026-06-12 23:19:38');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_06_03_114421_create_roles_table', 1),
(5, '2026_06_03_114422_create_categories_table', 1),
(6, '2026_06_03_114422_create_tags_table', 1),
(7, '2026_06_03_114423_create_posts_table', 1),
(8, '2026_06_03_114424_create_comments_table', 1),
(9, '2026_06_03_114425_create_votes_table', 1),
(10, '2026_06_03_114426_create_likes_table', 1),
(11, '2026_06_03_114427_create_follows_table', 1),
(12, '2026_06_03_114427_create_points_logs_table', 1),
(13, '2026_06_03_120155_create_user_roles_table', 1),
(14, '2026_06_03_120156_create_post_tags_table', 1),
(15, '2026_06_03_123201_create_personal_access_tokens_table', 1),
(16, '2026_06_04_000200_create_bookmarks_table', 1),
(17, '2026_06_04_000200_create_claps_table', 1),
(18, '2026_06_04_000201_add_published_at_to_posts_table', 1),
(19, '2026_06_04_001536_add_slug_to_posts_table', 1),
(20, '2026_06_05_030029_add_soft_deletes_to_posts_and_comments_table', 1),
(21, '2026_06_05_121815_add_edit_tracking_to_posts_and_comments_tables', 1),
(22, '2026_06_05_121815_create_comment_edit_histories_table', 1),
(23, '2026_06_05_121815_create_post_edit_histories_table', 1),
(24, '2026_06_06_110634_create_notifications_table', 1),
(25, '2026_06_06_112542_create_reports_table', 1),
(26, '2026_06_06_121342_add_closed_at_to_posts_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('014bde75-bb50-49dc-8621-03efb48cedf5', 'App\\Notifications\\PostVotedNotification', 'App\\Models\\User', '019ea608-89f2-7311-8f2b-8135d5ae8afc', '{\"type\":\"post_voted\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aea-7232-acb5-f3eb2b81a754\",\"post_title\":\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\",\"message\":\"dg memberikan upvote pada postinganmu: \\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\"\"}', NULL, '2026-06-12 23:19:36', '2026-06-12 23:19:36'),
('08a74165-1f8b-4fe8-b6fe-17322e3d87af', 'App\\Notifications\\PostVotedNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"post_voted\",\"user_id\":\"019ec1d7-81a1-710e-a095-8217ed855a53\",\"username\":\"melvin\",\"post_id\":\"019ec1d2-a072-708b-843d-7439ca4359fe\",\"post_title\":\"tes arsips\",\"message\":\"melvin memberikan upvote pada postinganmu: \\\"tes arsips\\\"\"}', NULL, '2026-06-13 09:36:43', '2026-06-13 09:36:43'),
('17225886-a42b-4b72-b5ed-658ae0e36d6f', 'App\\Notifications\\AnswerAcceptedNotification', 'App\\Models\\User', '019ec1d7-81a1-710e-a095-8217ed855a53', '{\"type\":\"answer_accepted\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ec1d2-a072-708b-843d-7439ca4359fe\",\"post_title\":\"tes arsips\",\"comment_id\":\"019ec1ea-ced6-7119-89e8-adce60a98913\",\"message\":\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\"}', NULL, '2026-06-13 10:05:51', '2026-06-13 10:05:51'),
('1d9c769a-c3d2-4952-9070-f95898b28f62', 'App\\Notifications\\PostLikedNotification', 'App\\Models\\User', '019ea608-89f2-7311-8f2b-8135d5ae8afc', '{\"type\":\"post_liked\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aea-7232-acb5-f3eb2b81a754\",\"post_title\":\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\",\"message\":\"dg menyukai postinganmu: \\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\"\"}', NULL, '2026-06-12 23:19:38', '2026-06-12 23:19:38'),
('1ed32242-4f7c-433f-b4ad-50746a909491', 'App\\Notifications\\ReportApprovedNotification', 'App\\Models\\User', '019ebb96-6e79-723e-94ce-2706968f8f0d', '{\"title\":\"Laporan Anda Telah Disetujui\",\"type\":\"report_approved\",\"message\":\"Laporan yang Anda ajukan terhadap pelanggaran konten\\/user telah disetujui oleh tim moderator. Tindakan kompensasi dan penegakan kebijakan telah dilakukan sesuai aturan komunitas. Terima kasih atas kontribusi Anda!\"}', NULL, '2026-06-12 04:28:06', '2026-06-12 04:28:06'),
('24b1d10b-e4b2-4f43-a3d8-e64b2d5b658b', 'App\\Notifications\\AnswerAcceptedNotification', 'App\\Models\\User', '019ec1d7-81a1-710e-a095-8217ed855a53', '{\"type\":\"answer_accepted\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ec1d2-a072-708b-843d-7439ca4359fe\",\"post_title\":\"tes arsips\",\"comment_id\":\"019ec1ea-ced6-7119-89e8-adce60a98913\",\"message\":\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\"}', NULL, '2026-06-13 10:03:24', '2026-06-13 10:03:24'),
('2521bc6c-9710-4df4-894d-7493f55c60c9', 'App\\Notifications\\UserFollowedNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"user_followed\",\"user_id\":\"019eb26d-dcfd-727b-a939-e5e369854170\",\"username\":\"df\",\"message\":\"df mulai mengikuti kamu, bro!\"}', '2026-06-11 23:16:38', '2026-06-10 09:53:02', '2026-06-11 23:16:38'),
('28688deb-1350-47e7-a98b-30b8d5df6565', 'App\\Notifications\\UserFollowedNotification', 'App\\Models\\User', '019eb26d-dcfd-727b-a939-e5e369854170', '{\"type\":\"user_followed\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"message\":\"dg mulai mengikuti kamu, bro!\"}', NULL, '2026-06-10 09:52:10', '2026-06-10 09:52:10'),
('333613ef-90af-4083-ac7a-c41b00df021d', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"new_comment\",\"user_id\":\"019eb26d-dcfd-727b-a939-e5e369854170\",\"username\":\"df\",\"post_id\":\"019eb14f-7702-71a5-b13f-2cba330a66eb\",\"post_title\":\"ini kapaan slese nya yach\",\"comment_id\":\"019eb26e-99ed-726c-a22b-e8fda6b2d827\",\"message\":\"df berkomentar di postinganmu: \\\"ini kapaan slese nya yach\\\"\"}', '2026-06-10 23:40:15', '2026-06-10 09:47:33', '2026-06-10 23:40:15'),
('4bd7ad33-3a45-41cc-987d-2d4f4589df1f', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-89f2-7311-8f2b-8135d5ae8afc', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aea-7232-acb5-f3eb2b81a754\",\"post_title\":\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\",\"comment_id\":\"019ebfa3-93dd-721a-ab5f-ef96c3032d12\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-8: Ap0sR8zBVk\\\"\"}', NULL, '2026-06-12 23:20:29', '2026-06-12 23:20:29'),
('4edc0568-8775-4b62-afcd-d6124de0da58', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-8a01-717b-a225-e9775a5c70eb', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8ae0-7250-9064-a3c0d3fe5130\",\"post_title\":\"Judul Postingan Dummy Ke-7: l8fbPL39kO\",\"comment_id\":\"019ebf9d-5d32-7259-927f-3bdc5b58632d\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-7: l8fbPL39kO\\\"\"}', NULL, '2026-06-12 23:13:41', '2026-06-12 23:13:41'),
('7387aed0-c9fa-40f3-8519-292d8f47a207', 'App\\Notifications\\ReportApprovedNotification', 'App\\Models\\User', '019ebb98-f12f-7016-b439-54e90d62e91e', '{\"title\":\"Laporan Anda Telah Disetujui\",\"type\":\"report_approved\",\"message\":\"Laporan yang Anda ajukan terhadap pelanggaran konten\\/user telah disetujui oleh tim moderator. Tindakan kompensasi dan penegakan kebijakan telah dilakukan sesuai aturan komunitas. Terima kasih atas kontribusi Anda!\"}', NULL, '2026-06-12 04:30:42', '2026-06-12 04:30:42'),
('7e1b4272-b487-47d4-860c-b716fbf730f7', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aab-7399-b025-6c1951efa3b3\",\"post_title\":\"Judul Postingan Dummy Ke-2: vux49wrRsf\",\"comment_id\":\"019ebf9f-30fe-72b7-8938-b552b79eddc7\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\"}', NULL, '2026-06-12 23:15:41', '2026-06-12 23:15:41'),
('8487eaf5-efdc-4e5e-a621-63f365c8b076', 'App\\Notifications\\AnswerAcceptedNotification', 'App\\Models\\User', '019ec1d7-81a1-710e-a095-8217ed855a53', '{\"type\":\"answer_accepted\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ec1d2-a072-708b-843d-7439ca4359fe\",\"post_title\":\"tes arsips\",\"comment_id\":\"019ec1ea-ced6-7119-89e8-adce60a98913\",\"message\":\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\"}', NULL, '2026-06-13 09:57:51', '2026-06-13 09:57:51'),
('88b777b4-fe0d-4d13-befd-d42140fcd0be', 'App\\Notifications\\PostLikedNotification', 'App\\Models\\User', '019ea608-84e3-7001-a5e8-6c510b21b322', '{\"type\":\"post_liked\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8a96-70ce-adae-e79656d0fa37\",\"post_title\":\"Judul Postingan Dummy Ke-1: 3tAYYXJkmI\",\"message\":\"dg menyukai postinganmu: \\\"Judul Postingan Dummy Ke-1: 3tAYYXJkmI\\\"\"}', NULL, '2026-06-10 04:47:57', '2026-06-10 04:47:57'),
('9dc267a0-e509-4894-a18c-32ac77de53a6', 'App\\Notifications\\PostVotedNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"post_voted\",\"user_id\":\"019eb26d-dcfd-727b-a939-e5e369854170\",\"username\":\"df\",\"post_id\":\"019eb14f-7702-71a5-b13f-2cba330a66eb\",\"post_title\":\"ini kapaan slese nya yach\",\"message\":\"df memberikan upvote pada postinganmu: \\\"ini kapaan slese nya yach\\\"\"}', '2026-06-10 23:37:28', '2026-06-10 09:47:36', '2026-06-10 23:37:28'),
('9e5c23eb-b3c8-4c46-9616-d1118ebd377c', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-8a01-717b-a225-e9775a5c70eb', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8ae0-7250-9064-a3c0d3fe5130\",\"post_title\":\"Judul Postingan Dummy Ke-7: l8fbPL39kO\",\"comment_id\":\"019ebf9c-d89a-7017-80af-8d390d0727fe\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-7: l8fbPL39kO\\\"\"}', NULL, '2026-06-12 23:13:07', '2026-06-12 23:13:07'),
('b6891c88-dca1-4e10-b548-4e49c172855b', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"new_comment\",\"user_id\":\"019ec1d7-81a1-710e-a095-8217ed855a53\",\"username\":\"melvin\",\"post_id\":\"019ec1d2-a072-708b-843d-7439ca4359fe\",\"post_title\":\"tes arsips\",\"comment_id\":\"019ec1ea-ced6-7119-89e8-adce60a98913\",\"message\":\"melvin berkomentar di postinganmu: \\\"tes arsips\\\"\"}', NULL, '2026-06-13 09:57:31', '2026-06-13 09:57:31'),
('c82cdcfd-a7a3-4cbd-887d-bbbd2f7dbdc0', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aab-7399-b025-6c1951efa3b3\",\"post_title\":\"Judul Postingan Dummy Ke-2: vux49wrRsf\",\"comment_id\":\"019ebfa1-c210-71e4-b2ab-ad7ae2edc44d\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\"}', NULL, '2026-06-12 23:18:29', '2026-06-12 23:18:29'),
('cb4a83fd-eb1a-4c50-bb51-f5587f5825a6', 'App\\Notifications\\PostVotedNotification', 'App\\Models\\User', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '{\"type\":\"post_voted\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aab-7399-b025-6c1951efa3b3\",\"post_title\":\"Judul Postingan Dummy Ke-2: vux49wrRsf\",\"message\":\"dg memberikan upvote pada postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\"}', NULL, '2026-06-10 04:34:58', '2026-06-10 04:34:58'),
('d8451946-3b5c-491f-98b5-1006f9e0fbe8', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aab-7399-b025-6c1951efa3b3\",\"post_title\":\"Judul Postingan Dummy Ke-2: vux49wrRsf\",\"comment_id\":\"019ebf9f-1017-7138-a8e1-da7344af7f6b\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\"}', NULL, '2026-06-12 23:15:33', '2026-06-12 23:15:33'),
('d88823e8-a050-46dc-8fe7-e2b8d62d180e', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"new_comment\",\"user_id\":\"019ebfa5-77e3-737f-8aaa-6a57ea8f9b13\",\"username\":\"dheni\",\"post_id\":\"019ebf9e-6e48-726e-8670-96af21b1725b\",\"post_title\":\"dsdasdasbd bnsdbs\",\"comment_id\":\"019ebfa5-ffdb-7314-b4b4-ae9094818a2f\",\"message\":\"dheni berkomentar di postinganmu: \\\"dsdasdasbd bnsdbs\\\"\"}', NULL, '2026-06-12 23:23:07', '2026-06-12 23:23:07'),
('ea2eeff0-84fe-411b-bfb4-31163fa0e129', 'App\\Notifications\\NewCommentNotification', 'App\\Models\\User', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '{\"type\":\"new_comment\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ea608-8aab-7399-b025-6c1951efa3b3\",\"post_title\":\"Judul Postingan Dummy Ke-2: vux49wrRsf\",\"comment_id\":\"019ebfa1-ee35-707d-9c8d-6ccbe43bda12\",\"message\":\"dg berkomentar di postinganmu: \\\"Judul Postingan Dummy Ke-2: vux49wrRsf\\\"\"}', NULL, '2026-06-12 23:18:41', '2026-06-12 23:18:41'),
('f7ac7bba-229a-4114-9cd1-ffc8f23451dd', 'App\\Notifications\\PostLikedNotification', 'App\\Models\\User', '019eb132-5bdb-73ad-81df-faad1b3250a6', '{\"type\":\"post_liked\",\"user_id\":\"019eb26d-dcfd-727b-a939-e5e369854170\",\"username\":\"df\",\"post_id\":\"019eb14f-7702-71a5-b13f-2cba330a66eb\",\"post_title\":\"ini kapaan slese nya yach\",\"message\":\"df menyukai postinganmu: \\\"ini kapaan slese nya yach\\\"\"}', '2026-06-12 23:11:24', '2026-06-10 09:47:27', '2026-06-12 23:11:24'),
('f87885dd-a39a-411b-9040-25bbb17a619a', 'App\\Notifications\\AnswerAcceptedNotification', 'App\\Models\\User', '019ec1d7-81a1-710e-a095-8217ed855a53', '{\"type\":\"answer_accepted\",\"user_id\":\"019eb132-5bdb-73ad-81df-faad1b3250a6\",\"username\":\"dg\",\"post_id\":\"019ec1d2-a072-708b-843d-7439ca4359fe\",\"post_title\":\"tes arsips\",\"comment_id\":\"019ec1ea-ced6-7119-89e8-adce60a98913\",\"message\":\"Selamat! Jawabanmu di postingan \\\"tes arsips\\\" dipilih sebagai jawaban terbaik oleh dg.\"}', NULL, '2026-06-13 09:58:15', '2026-06-13 09:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `points_logs`
--

CREATE TABLE `points_logs` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `points` int NOT NULL,
  `action_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `points_logs`
--

INSERT INTO `points_logs` (`id`, `user_id`, `points`, `action_type`, `reference_id`, `description`, `created_at`, `updated_at`) VALUES
('019eb13a-30bf-72b9-8b3b-fa99991fffe2', '019eb132-5bdb-73ad-81df-faad1b3250a6', 10, 'post_liked', '019eb13a-10f6-739b-b83f-5fc23963d65d', 'Menyukai postingan: aww', '2026-06-10 04:10:41', '2026-06-10 04:10:41'),
('019eb150-6b42-72e5-87c4-b7ff3ef9806f', '019eb132-5bdb-73ad-81df-faad1b3250a6', 5, 'new_upvote', '019ea608-8aab-7399-b025-6c1951efa3b3', 'Memberikan upvote pada post: Judul Postingan Dummy Ke-2: vux49wrRsf', '2026-06-10 04:34:58', '2026-06-10 04:34:58'),
('019eb15c-4e9e-7350-887f-d112574f7ba0', '019eb132-5bdb-73ad-81df-faad1b3250a6', 10, 'post_liked', '019ea608-8a96-70ce-adae-e79656d0fa37', 'Menyukai postingan: Judul Postingan Dummy Ke-1: 3tAYYXJkmI', '2026-06-10 04:47:57', '2026-06-10 04:47:57'),
('019eb15c-54f4-73a1-8952-06303322ddd8', '019eb132-5bdb-73ad-81df-faad1b3250a6', -10, 'post_unliked', '019ea608-8a96-70ce-adae-e79656d0fa37', 'Batal menyukai postingan: Judul Postingan Dummy Ke-1: 3tAYYXJkmI', '2026-06-10 04:47:58', '2026-06-10 04:47:58'),
('019eb24f-0e4a-715d-b544-99479d2fa307', '019eb132-5bdb-73ad-81df-faad1b3250a6', 10, 'post_liked', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'Menyukai postingan: ini kapaan slese nya yach', '2026-06-10 09:13:05', '2026-06-10 09:13:05'),
('019eb26e-81c3-72af-9307-c9e4d05e8590', '019eb26d-dcfd-727b-a939-e5e369854170', 10, 'post_liked', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'Menyukai postingan: ini kapaan slese nya yach', '2026-06-10 09:47:27', '2026-06-10 09:47:27'),
('019eb26e-a4fe-7162-afa8-d69d12104e45', '019eb26d-dcfd-727b-a939-e5e369854170', 5, 'new_upvote', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'Memberikan upvote pada post: ini kapaan slese nya yach', '2026-06-10 09:47:36', '2026-06-10 09:47:36'),
('019eb26e-aa98-700e-8cd0-c6f5b56e1be2', '019eb26d-dcfd-727b-a939-e5e369854170', 5, 'new_upvote', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'Memberikan upvote pada komentar', '2026-06-10 09:47:37', '2026-06-10 09:47:37'),
('019eb26e-c1a8-700c-9fa2-85276afd0139', '019eb26d-dcfd-727b-a939-e5e369854170', 5, 'new_upvote', '019eb24f-009a-720b-8157-3f9431211683', 'Memberikan upvote pada komentar', '2026-06-10 09:47:43', '2026-06-10 09:47:43'),
('019ebfa2-c65c-726f-9aad-c96239134610', '019eb132-5bdb-73ad-81df-faad1b3250a6', 5, 'new_upvote', '019ea608-8aea-7232-acb5-f3eb2b81a754', 'Memberikan upvote pada post: Judul Postingan Dummy Ke-8: Ap0sR8zBVk', '2026-06-12 23:19:36', '2026-06-12 23:19:36'),
('019ebfa2-d061-72b9-b909-9b25f46b1ad0', '019eb132-5bdb-73ad-81df-faad1b3250a6', 10, 'post_liked', '019ea608-8aea-7232-acb5-f3eb2b81a754', 'Menyukai postingan: Judul Postingan Dummy Ke-8: Ap0sR8zBVk', '2026-06-12 23:19:38', '2026-06-12 23:19:38'),
('019ec1d7-c255-730b-8021-04ab5450e0f3', '019ec1d7-81a1-710e-a095-8217ed855a53', 5, 'new_upvote', '019ec1d2-a072-708b-843d-7439ca4359fe', 'Memberikan upvote pada post: tes arsips', '2026-06-13 09:36:43', '2026-06-13 09:36:43'),
('019ec1eb-1bde-7383-8413-12242d6e1fb4', '019ec1d7-81a1-710e-a095-8217ed855a53', 15, 'accepted_answer_received', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: tes arsips', '2026-06-13 09:57:51', '2026-06-13 09:57:51'),
('019ec1eb-23bd-71d8-adc0-568bce10fa0d', '019ec1d7-81a1-710e-a095-8217ed855a53', -15, 'accepted_answer_revoked', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Jawaban terbaik dicabut pada post: tes arsips', '2026-06-13 09:57:53', '2026-06-13 09:57:53'),
('019ec1eb-7882-719c-bf12-2425b1383001', '019ec1d7-81a1-710e-a095-8217ed855a53', 15, 'accepted_answer_received', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: tes arsips', '2026-06-13 09:58:15', '2026-06-13 09:58:15'),
('019ec1eb-7c96-7294-a1cc-0a1666fdb226', '019ec1d7-81a1-710e-a095-8217ed855a53', -15, 'accepted_answer_revoked', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Jawaban terbaik dicabut pada post: tes arsips', '2026-06-13 09:58:16', '2026-06-13 09:58:16'),
('019ec1f0-333c-73d8-9352-cbc0284d3262', '019ec1d7-81a1-710e-a095-8217ed855a53', 15, 'accepted_answer_received', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: tes arsips', '2026-06-13 10:03:24', '2026-06-13 10:03:24'),
('019ec1f0-3a1d-7129-b066-b8785de0946b', '019ec1d7-81a1-710e-a095-8217ed855a53', -15, 'accepted_answer_revoked', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Jawaban terbaik dicabut pada post: tes arsips', '2026-06-13 10:03:26', '2026-06-13 10:03:26'),
('019ec1f2-7064-72a8-9184-7e10c61726b4', '019ec1d7-81a1-710e-a095-8217ed855a53', 15, 'accepted_answer_received', '019ec1ea-ced6-7119-89e8-adce60a98913', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: tes arsips', '2026-06-13 10:05:51', '2026-06-13 10:05:51'),
('019ec453-427d-73a9-9dc2-6683233fb6a3', '019eb132-5bdb-73ad-81df-faad1b3250a6', 15, 'accepted_answer_received', '019ebf9e-b5bb-7022-92dd-c6d8d81fb03a', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: dsdasdasbd bnsdbs', '2026-06-13 21:10:51', '2026-06-13 21:10:51'),
('019ec453-89dd-738d-9b6a-b7bb257ce734', '019eb132-5bdb-73ad-81df-faad1b3250a6', 15, 'accepted_answer_received', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: ini kapaan slese nya yach', '2026-06-13 21:11:09', '2026-06-13 21:11:09'),
('019ec453-aeec-72c5-8ab4-4f627cfd278f', '019eb132-5bdb-73ad-81df-faad1b3250a6', -15, 'accepted_answer_revoked', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'Jawaban terbaik dicabut pada post: ini kapaan slese nya yach', '2026-06-13 21:11:19', '2026-06-13 21:11:19'),
('019ec453-bb69-7164-a7c1-cf5728da453f', '019eb132-5bdb-73ad-81df-faad1b3250a6', 15, 'accepted_answer_received', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'Selamat! Jawabanmu terpilih sebagai yang terbaik di: ini kapaan slese nya yach', '2026-06-13 21:11:22', '2026-06-13 21:11:22'),
('019ec453-d520-7311-ad9f-71a7e32d0df8', '019eb132-5bdb-73ad-81df-faad1b3250a6', -15, 'accepted_answer_revoked', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'Jawaban terbaik dicabut pada post: ini kapaan slese nya yach', '2026-06-13 21:11:28', '2026-06-13 21:11:28');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `closed_at` timestamp NULL DEFAULT NULL,
  `edit_count` int NOT NULL DEFAULT '0',
  `published_at` timestamp NULL DEFAULT NULL,
  `view_count` int NOT NULL DEFAULT '0',
  `vote_score` int NOT NULL DEFAULT '0',
  `is_answered` tinyint(1) NOT NULL DEFAULT '0',
  `accepted_answer_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `category_id`, `title`, `slug`, `body`, `status`, `closed_at`, `edit_count`, `published_at`, `view_count`, `vote_score`, `is_answered`, `accepted_answer_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
('019ea608-8a96-70ce-adae-e79656d0fa37', '019ea608-84e3-7001-a5e8-6c510b21b322', '019ea608-8a1a-7211-a2b4-87341b76c200', 'Judul Postingan Dummy Ke-1: 3tAYYXJkmI', 'judul-postingan-dummy-ke-1-3tayyxjkmi-qMulI', 'Ini adalah isi konten dummy untuk postingan ke-1. GTiTWLpwAMxyG9EDQ2INT2GKv36IMu4ULHwuF5TnuBLjZyRPvWiPpMhoiWqJqxJhkbOiwIKISwUK6wLVxwOK7EzmxpXXzUfjMUeH', 'open', NULL, 0, NULL, 32, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-14 02:54:33', NULL),
('019ea608-8aab-7399-b025-6c1951efa3b3', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '019ea608-8a14-7386-8474-da55e31e6002', 'Judul Postingan Dummy Ke-2: vux49wrRsf', 'judul-postingan-dummy-ke-2-vux49wrrsf-HCHEZ', 'Ini adalah isi konten dummy untuk postingan ke-2. twu5PipJpjnnPoI4OfgspvtsUAHQs6bwt1sLwPHoo8x11GuHPiu5Sd5capO1kmdY6SaCH7jEPWgczuJMJUVijlaBSWYdw2smJXGY', 'open', NULL, 0, NULL, 16, 1, 0, NULL, '2026-06-08 00:00:38', '2026-06-13 08:56:44', NULL),
('019ea608-8ab6-72da-99e4-a44ae10e1a24', '019ea608-8a0a-7085-8b48-5ef3bb954c43', '019ea608-8a23-725c-b263-d913c3fedde5', 'Judul Postingan Dummy Ke-3: TBDyhwri7R', 'judul-postingan-dummy-ke-3-tbdyhwri7r-PT2R0', 'Ini adalah isi konten dummy untuk postingan ke-3. MmZMxlb5alqmWezYjgID9frxSeatppkyYdl0rOqD77QIwWylx7Np8KcxQRiyGuY2xmPkzPyIbHTtWeFuiIsk16teq49RnNuH8EGx', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8ac0-7235-b8ec-441b2c82fc25', '019ea608-84e3-7001-a5e8-6c510b21b322', '019ea608-8a1a-7211-a2b4-87341b76c200', 'Judul Postingan Dummy Ke-4: 2sNkwLjuL4', 'judul-postingan-dummy-ke-4-2snkwljul4-Z9qO9', 'Ini adalah isi konten dummy untuk postingan ke-4. tUkOBLzxAyMGU9qnkZtMjQ8GkR74gtdyXrJ6jXLjEn26cgb2jMGI2X0tAaHnFEmSaqN4miUH1RLuezxDl9hGq11RDhx7RK06Q52c', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8acc-73f3-8bfc-ca63f27c27cc', '019ea608-84e3-7001-a5e8-6c510b21b322', '019ea608-8a2d-72b1-899a-45837730d478', 'Judul Postingan Dummy Ke-5: AWrbFJ0icF', 'judul-postingan-dummy-ke-5-awrbfj0icf-aFMTy', 'Ini adalah isi konten dummy untuk postingan ke-5. wMSLkClU1ioUhgZlAoBaT2jewKzFmCZjd7gavVuOGDI1uZ4c0BXFU0I2ExRkxPJuyl2xbzXLa11thuDNhst08LynZHqHuil5ATNk', 'open', NULL, 0, NULL, 2, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-10 23:46:45', NULL),
('019ea608-8ad6-7058-b2d6-c80befeffa67', '019ea608-8a05-7016-b5d1-0ce80737caa1', '019ea608-8a14-7386-8474-da55e31e6002', 'Judul Postingan Dummy Ke-6: Bg9nw4KFc5', 'judul-postingan-dummy-ke-6-bg9nw4kfc5-amNMJ', 'Ini adalah isi konten dummy untuk postingan ke-6. e45xxIrD2lih1WsKotw0vtE4pGIRFTC0jWRPzSNoXQ7JZp7b5nBtp8XDJzPfIY0X6kNAUAiDmLLOFyBANVeWOEncBso4WkCZ0CMz', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8ae0-7250-9064-a3c0d3fe5130', '019ea608-8a01-717b-a225-e9775a5c70eb', '019ea608-8a23-725c-b263-d913c3fedde5', 'Judul Postingan Dummy Ke-7: l8fbPL39kO', 'judul-postingan-dummy-ke-7-l8fbpl39ko-VC8Qg', 'Ini adalah isi konten dummy untuk postingan ke-7. OVzgcg1kEZOxvUW3cWjiFtB0dFoIWqTaQnTqsUwzqgNGh0CfFs56r9UXcM7xR7WufYbbASJmDZkkQuHRBGCsTAG6wkIhhAS2XEzB', 'open', NULL, 0, NULL, 1, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-12 23:12:40', NULL),
('019ea608-8aea-7232-acb5-f3eb2b81a754', '019ea608-89f2-7311-8f2b-8135d5ae8afc', '019ea608-8a2d-72b1-899a-45837730d478', 'Judul Postingan Dummy Ke-8: Ap0sR8zBVk', 'judul-postingan-dummy-ke-8-ap0sr8zbvk-j3Gfu', 'Ini adalah isi konten dummy untuk postingan ke-8. OKloMwSHSVh8dprxdqqem1wQzLmqnDWBQUn2K7sE883ZPPOzLaT2QN91AhmpaoQT5sLhJn0sINvIGnAhdnJOzPe0sav6WCmrgJtf', 'open', NULL, 0, NULL, 4, 1, 0, NULL, '2026-06-08 00:00:38', '2026-06-12 23:20:29', NULL),
('019ea608-8af3-73ab-ad80-6a0f0b39ad64', '019ea608-8a05-7016-b5d1-0ce80737caa1', '019ea608-8a23-725c-b263-d913c3fedde5', 'Judul Postingan Dummy Ke-9: 5vaKinUdMC', 'judul-postingan-dummy-ke-9-5vakinudmc-x1Jyb', 'Ini adalah isi konten dummy untuk postingan ke-9. k4aB9P1om3BT0uGtnLbbqrAFrTJ04uZHuTL4Ndva03Shvh4GX4vzH2v4DipF2QpEgU2BtsBgMMZu8FnQCbn4e65aiT18sfZ2CFMh', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8afc-7148-9cd4-b5f5014b803f', '019ea608-8a05-7016-b5d1-0ce80737caa1', '019ea608-8a1e-700c-828c-37062c6f082a', 'Judul Postingan Dummy Ke-10: Dn1H8ETqmP', 'judul-postingan-dummy-ke-10-dn1h8etqmp-SvMKi', 'Ini adalah isi konten dummy untuk postingan ke-10. LVH7H3f407uZaqHWl80OvYwBoHCSuqNh0fidBmKyq4wgy5EHmSFA1sNTjMtUDVuyFHBMQfeC4dMrztVYn1nMSAA7KcKBmn7DA8UY', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b06-73e6-b570-e4502527f2dc', '019ea608-84d2-7004-9db6-7de55d3d86fa', '019ea608-8a28-71ef-9364-8d7522870cde', 'Judul Postingan Dummy Ke-11: uTBf6rMY3E', 'judul-postingan-dummy-ke-11-utbf6rmy3e-KHl1L', 'Ini adalah isi konten dummy untuk postingan ke-11. KICnXVhlWAo2AdVSd83kIhY2ItcwZfTIZ4i4xyz4r4L4g4sTvny3mdOqJCrKaEkHmrdxA21PTeeePgQYfx8L8q0sZJNSaeJsdMma', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b10-738a-8fe5-54ed8c0f93bb', '019ea608-8a01-717b-a225-e9775a5c70eb', '019ea608-8a14-7386-8474-da55e31e6002', 'Judul Postingan Dummy Ke-12: pppo4nyB9W', 'judul-postingan-dummy-ke-12-pppo4nyb9w-ksAzS', 'Ini adalah isi konten dummy untuk postingan ke-12. K2Q1HhrQ7fGiRLVpsM0xkJRR3KvVmtHOpXXukVzwNLWkiuaS42ol1VW8d2NcE0Q2tsuK9aNaeG1GOoFL8JCxYAFTh0f7a30JYPcL', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b19-72e1-bf13-44cb63fdb993', '019ea608-84e3-7001-a5e8-6c510b21b322', '019ea608-8a28-71ef-9364-8d7522870cde', 'Judul Postingan Dummy Ke-13: NHxgaiFig8', 'judul-postingan-dummy-ke-13-nhxgaifig8-WUs3i', 'Ini adalah isi konten dummy untuk postingan ke-13. Vtx9Uxc25z6S5SmEvPsCQvIp8RukHWRM5Sv4x02AgE9Qva702E468ZrmsmxHedKtQi2Hyvu7Kq1nWBuG3o7YpbVYH7xcXiOCN6BY', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b23-7207-834e-dc6d00b6d602', '019ea608-8a05-7016-b5d1-0ce80737caa1', '019ea608-8a1a-7211-a2b4-87341b76c200', 'Judul Postingan Dummy Ke-14: CihXs40xrd', 'judul-postingan-dummy-ke-14-cihxs40xrd-cB83s', 'Ini adalah isi konten dummy untuk postingan ke-14. Rf8veGqR3dgFbggOxuW3QsJJmwMPCxK7ZtnE6sOh8nCwvVx9mc8UbdHKzxNDBw2IwmTb3QknjYNfbGa05J7PmSsHyd4IW0Ey7Ful', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b2d-7176-b9a3-a205ebe2c92d', '019ea608-8a05-7016-b5d1-0ce80737caa1', '019ea608-8a1a-7211-a2b4-87341b76c200', 'Judul Postingan Dummy Ke-15: HqrQw7ybDe', 'judul-postingan-dummy-ke-15-hqrqw7ybde-NYhGt', 'Ini adalah isi konten dummy untuk postingan ke-15. lGSiWDWZrtitucWlZl4R9H0WaixNUhAvYTx4hqS22eOAvLwbmqCYjPC9NpTBNFv9m1roFFau2k4DE5jS7PcFxkTtRug4WAQwhIpL', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b36-72bf-a1d0-b5eb0b013857', '019ea608-84d2-7004-9db6-7de55d3d86fa', '019ea608-8a23-725c-b263-d913c3fedde5', 'Judul Postingan Dummy Ke-16: QnAIXKltxv', 'judul-postingan-dummy-ke-16-qnaixkltxv-IYygr', 'Ini adalah isi konten dummy untuk postingan ke-16. GgYY5JImDsSmbWISXi8qEasoOItIDYo0LskW81NB3YuQwjbbXIBjRJKMUjdHBuLCLJfQ0NzXIwubmRlxAYCklGW4u01yvXsoy7NE', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b3f-7343-885e-22f969f937d9', '019ea608-84d2-7004-9db6-7de55d3d86fa', '019ea608-8a28-71ef-9364-8d7522870cde', 'Judul Postingan Dummy Ke-17: cF93aqjaiT', 'judul-postingan-dummy-ke-17-cf93aqjait-TNwgk', 'Ini adalah isi konten dummy untuk postingan ke-17. 9wU1ePdAGXwJcybj4jDgtUNzKfXBXNNFRlgi2PiWUGonkAckC7AmUsWDq81tnfwz7k0f9J85ftcntDTzJgGZnLUR506TMzDRZMIp', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b49-73a8-a8db-d7f81873b111', '019ea608-84e9-70c0-9620-0386c6564a6a', '019ea608-8a1a-7211-a2b4-87341b76c200', 'Judul Postingan Dummy Ke-18: FPjG2Paors', 'judul-postingan-dummy-ke-18-fpjg2paors-d943N', 'Ini adalah isi konten dummy untuk postingan ke-18. dPLnJfixIOh0nxhXxEXkzi0H3Yb9XLEXPLHdBdHIJFWaMA909RcnMH88l7PsXF6NObFoBXuJHRbArAA0JsMVOFEqindDY9gVCrZj', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b51-733b-8cf6-af1d78a77818', '019ea608-84e3-7001-a5e8-6c510b21b322', '019ea608-8a28-71ef-9364-8d7522870cde', 'Judul Postingan Dummy Ke-19: yDo6hm3rJX', 'judul-postingan-dummy-ke-19-ydo6hm3rjx-FCEUE', 'Ini adalah isi konten dummy untuk postingan ke-19. VGe3Q2VsLgAN02WXOG0gJ8Ck4FiZiEFCzetbmzXHTVoTKdOM0AJ32vCBXIYlonc31yzchKBCfPt2nRXmA5plMt6juyudh180P8ZI', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019ea608-8b5b-7151-be39-a844fd046918', '019ea608-89f2-7311-8f2b-8135d5ae8afc', '019ea608-8a28-71ef-9364-8d7522870cde', 'Judul Postingan Dummy Ke-20: LaC2SwAPES', 'judul-postingan-dummy-ke-20-lac2swapes-ItYlw', 'Ini adalah isi konten dummy untuk postingan ke-20. t94gTJ0bdCgUEknTAe4DPUIIt6WOwCjYre1TZ9VGspl6EPPttk5RSPfw6RMwqBe97cP0aHkESCZT1GJvBtZPC7fCDPUjcp2CTnVF', 'open', NULL, 0, NULL, 0, 0, 0, NULL, '2026-06-08 00:00:38', '2026-06-08 00:00:38', NULL),
('019eb13a-10f6-739b-b83f-5fc23963d65d', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8a14-7386-8474-da55e31e6002', 'aww', 'aww-E4X5C', 'aww', 'open', NULL, 0, NULL, 6, 0, 0, NULL, '2026-06-10 04:10:33', '2026-06-13 23:40:04', NULL),
('019eb14f-7702-71a5-b13f-2cba330a66eb', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8a23-725c-b263-d913c3fedde5', 'ini kapaan slese nya yach', 'ini-kapaan-slese-nya-yach-ir6e4', 'lelah, letih, lapar', 'open', NULL, 0, NULL, 82, 1, 0, NULL, '2026-06-10 04:33:55', '2026-06-13 21:11:29', NULL),
('019eb54f-46fb-72d6-a560-77b98b9a7482', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8a14-7386-8474-da55e31e6002', 'tes', 'tes-5CXKI', 'fdgfg', 'open', NULL, 0, NULL, 6, 0, 0, NULL, '2026-06-10 23:12:12', '2026-06-10 23:46:10', '2026-06-10 23:46:10'),
('019ebf9e-6e48-726e-8670-96af21b1725b', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8a14-7386-8474-da55e31e6002', 'dsdasdasbd bnsdbs', 'dsdasdasbd-bnsdbs-YOfYl', 'assvfhsf shb fms mnd vnm sajfbsam cn vdb snmsajfashbdsahd', 'closed', '2026-06-13 21:10:54', 0, NULL, 27, 0, 1, '019ebf9e-b5bb-7022-92dd-c6d8d81fb03a', '2026-06-12 23:14:51', '2026-06-13 21:10:55', NULL),
('019ec1d2-a072-708b-843d-7439ca4359fe', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8a1e-700c-828c-37062c6f082a', 'tes arsips', 'tes-arsips-bEv6L', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'open', NULL, 0, NULL, 45, 1, 1, '019ec1ea-ced6-7119-89e8-adce60a98913', '2026-06-13 09:31:06', '2026-06-14 03:23:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_edit_histories`
--

CREATE TABLE `post_edit_histories` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_body` text COLLATE utf8mb4_unicode_ci,
  `new_body` text COLLATE utf8mb4_unicode_ci,
  `edit_number` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_tags`
--

CREATE TABLE `post_tags` (
  `post_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `post_tags`
--

INSERT INTO `post_tags` (`post_id`, `tag_id`) VALUES
('019ea608-8aab-7399-b025-6c1951efa3b3', '019ea608-8a38-731f-93e9-7fc23e8e97d6'),
('019ea608-8ac0-7235-b8ec-441b2c82fc25', '019ea608-8a41-713f-abee-489a2ad5d6a4'),
('019ea608-8afc-7148-9cd4-b5f5014b803f', '019ea608-8a41-713f-abee-489a2ad5d6a4'),
('019eb54f-46fb-72d6-a560-77b98b9a7482', '019ea608-8a41-713f-abee-489a2ad5d6a4'),
('019ec1d2-a072-708b-843d-7439ca4359fe', '019ea608-8a41-713f-abee-489a2ad5d6a4'),
('019ea608-8b49-73a8-a8db-d7f81873b111', '019ea608-8a4e-728d-9c66-8e5451034c9a'),
('019eb13a-10f6-739b-b83f-5fc23963d65d', '019ea608-8a4e-728d-9c66-8e5451034c9a'),
('019ea608-8a96-70ce-adae-e79656d0fa37', '019ea608-8a54-7107-9709-99fb9312fa10'),
('019ea608-8ab6-72da-99e4-a44ae10e1a24', '019ea608-8a54-7107-9709-99fb9312fa10'),
('019ea608-8af3-73ab-ad80-6a0f0b39ad64', '019ea608-8a59-7009-892f-adfaa59514d7'),
('019ea608-8afc-7148-9cd4-b5f5014b803f', '019ea608-8a59-7009-892f-adfaa59514d7'),
('019ea608-8b36-72bf-a1d0-b5eb0b013857', '019ea608-8a59-7009-892f-adfaa59514d7'),
('019ea608-8ae0-7250-9064-a3c0d3fe5130', '019ea608-8a5e-739d-b70e-661481fd75c6'),
('019ea608-8aea-7232-acb5-f3eb2b81a754', '019ea608-8a5e-739d-b70e-661481fd75c6'),
('019ea608-8af3-73ab-ad80-6a0f0b39ad64', '019ea608-8a5e-739d-b70e-661481fd75c6'),
('019ea608-8ac0-7235-b8ec-441b2c82fc25', '019ea608-8a63-70cc-a388-bfc3b2f85b2c'),
('019ea608-8b06-73e6-b570-e4502527f2dc', '019ea608-8a63-70cc-a388-bfc3b2f85b2c'),
('019ea608-8b19-72e1-bf13-44cb63fdb993', '019ea608-8a63-70cc-a388-bfc3b2f85b2c'),
('019ea608-8b2d-7176-b9a3-a205ebe2c92d', '019ea608-8a63-70cc-a388-bfc3b2f85b2c'),
('019ea608-8ae0-7250-9064-a3c0d3fe5130', '019ea608-8a68-7026-a75a-82c60c6ba34a'),
('019ea608-8b10-738a-8fe5-54ed8c0f93bb', '019ea608-8a68-7026-a75a-82c60c6ba34a'),
('019ea608-8b23-7207-834e-dc6d00b6d602', '019ea608-8a68-7026-a75a-82c60c6ba34a'),
('019eb14f-7702-71a5-b13f-2cba330a66eb', '019ea608-8a68-7026-a75a-82c60c6ba34a'),
('019ea608-8aab-7399-b025-6c1951efa3b3', '019ea608-8a6d-716b-8171-fc183b2c34ad'),
('019ea608-8acc-73f3-8bfc-ca63f27c27cc', '019ea608-8a6d-716b-8171-fc183b2c34ad'),
('019ea608-8b06-73e6-b570-e4502527f2dc', '019ea608-8a6d-716b-8171-fc183b2c34ad'),
('019ea608-8b10-738a-8fe5-54ed8c0f93bb', '019ea608-8a6d-716b-8171-fc183b2c34ad'),
('019ea608-8b3f-7343-885e-22f969f937d9', '019ea608-8a6d-716b-8171-fc183b2c34ad'),
('019ea608-8a96-70ce-adae-e79656d0fa37', '019ea608-8a72-7209-9e0f-ebcb735c2341'),
('019ea608-8acc-73f3-8bfc-ca63f27c27cc', '019ea608-8a72-7209-9e0f-ebcb735c2341'),
('019ea608-8b06-73e6-b570-e4502527f2dc', '019ea608-8a72-7209-9e0f-ebcb735c2341'),
('019ea608-8b5b-7151-be39-a844fd046918', '019ea608-8a72-7209-9e0f-ebcb735c2341'),
('019ea608-8ad6-7058-b2d6-c80befeffa67', '019ea608-8a76-7022-99ce-49470c1ea110'),
('019ea608-8af3-73ab-ad80-6a0f0b39ad64', '019ea608-8a76-7022-99ce-49470c1ea110'),
('019ea608-8b10-738a-8fe5-54ed8c0f93bb', '019ea608-8a76-7022-99ce-49470c1ea110'),
('019ea608-8b19-72e1-bf13-44cb63fdb993', '019ea608-8a76-7022-99ce-49470c1ea110'),
('019ea608-8b51-733b-8cf6-af1d78a77818', '019ea608-8a76-7022-99ce-49470c1ea110'),
('019ea608-8b5b-7151-be39-a844fd046918', '019ea608-8a76-7022-99ce-49470c1ea110'),
('019ea608-8ae0-7250-9064-a3c0d3fe5130', '019ea608-8a7b-71b4-9fdb-7ac2b8731409'),
('019ea608-8b51-733b-8cf6-af1d78a77818', '019ea608-8a7b-71b4-9fdb-7ac2b8731409'),
('019ea608-8acc-73f3-8bfc-ca63f27c27cc', '019ea608-8a80-7139-811d-d8b6461b08dd'),
('019ea608-8b3f-7343-885e-22f969f937d9', '019ea608-8a80-7139-811d-d8b6461b08dd'),
('019ea608-8ad6-7058-b2d6-c80befeffa67', '019ea608-8a84-73ed-9fd4-60e2a9a40d7d'),
('019ebf9e-6e48-726e-8670-96af21b1725b', '019ebf9e-30c5-71fa-aca1-844139136ae4'),
('019ec1d2-a072-708b-843d-7439ca4359fe', '019ebf9e-30c5-71fa-aca1-844139136ae4');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('pending','reviewed','resolved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `resolved_by` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `moderator_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `user_id`, `target_id`, `target_type`, `reason`, `description`, `status`, `resolved_by`, `moderator_notes`, `created_at`, `updated_at`) VALUES
('019ebb96-9be1-705b-993e-f3ed6ad43553', '019ebb96-6e79-723e-94ce-2706968f8f0d', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'post', 'Konten mengandung spam atau iklan tidak diinginkan.', 'Laporan otomatis oleh Cypress.', 'resolved', '019eb132-5bdb-73ad-81df-faad1b3250a6', 'Selesai diproses oleh Admin via Cypress.', '2026-06-12 04:27:50', '2026-06-12 04:28:06'),
('019ebb99-183a-73c8-a5c3-bca0b6c24695', '019ebb98-f12f-7016-b439-54e90d62e91e', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'post', 'Konten mengandung spam atau iklan tidak diinginkan.', 'Laporan otomatis oleh Cypress.', 'resolved', '019eb132-5bdb-73ad-81df-faad1b3250a6', 'Selesai diproses oleh Admin via Cypress.', '2026-06-12 04:30:33', '2026-06-12 04:30:42'),
('019ebfa3-6829-736e-bfdf-8a38c09f22ed', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8aea-7232-acb5-f3eb2b81a754', 'post', 'Konten mengandung spam atau iklan tidak diinginkan.', 'dhennnn', 'pending', NULL, NULL, '2026-06-12 23:20:17', '2026-06-12 23:20:17');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usage_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`, `slug`, `color`, `usage_count`, `created_at`, `updated_at`) VALUES
('019ea608-8a38-731f-93e9-7fc23e8e97d6', 'Laravel', 'laravel', '#0c4ee9', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a41-713f-abee-489a2ad5d6a4', 'React', 'react', '#0e98f2', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a49-7224-959a-b0c8a4561897', 'Vue', 'vue', '#3e0cd4', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a4e-728d-9c66-8e5451034c9a', 'Tailwind', 'tailwind', '#28ffc6', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a54-7107-9709-99fb9312fa10', 'Python', 'python', '#4b135f', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a59-7009-892f-adfaa59514d7', 'PHP', 'php', '#3b177e', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a5e-739d-b70e-661481fd75c6', 'Fitness', 'fitness', '#fc7886', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a63-70cc-a388-bfc3b2f85b2c', 'Nutrisi', 'nutrisi', '#7f1c5b', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a68-7026-a75a-82c60c6ba34a', 'Traveling', 'traveling', '#9c8013', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a6d-716b-8171-fc183b2c34ad', 'Kopi', 'kopi', '#dc9c05', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a72-7209-9e0f-ebcb735c2341', 'Gaming', 'gaming', '#720c4a', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a76-7022-99ce-49470c1ea110', 'AI', 'ai', '#e547db', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a7b-71b4-9fdb-7ac2b8731409', 'Blockchain', 'blockchain', '#f86a2a', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a80-7139-811d-d8b6461b08dd', 'Cloud', 'cloud', '#33567e', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a84-73ed-9fd4-60e2a9a40d7d', 'CyberSecurity', 'cybersecurity', '#5d5e7c', 0, '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ebf9e-30c5-71fa-aca1-844139136ae4', 'rpl', 'rpl', '#3B82F6', 0, '2026-06-12 23:14:35', '2026-06-12 23:14:35'),
('019ec1c5-71aa-7223-a862-7168d71e4b98', 'as', 'as', '#3B82F6', 0, '2026-06-13 09:16:42', '2026-06-13 09:16:42'),
('019ec1c5-7af5-73bd-84ef-35a316287293', 'sss', 'sss', '#3B82F6', 0, '2026-06-13 09:16:45', '2026-06-13 09:16:45'),
('019ec1c7-b118-7378-83b7-c288effe3f29', 'graw', 'graw', '#bd288e', 0, '2026-06-13 09:19:10', '2026-06-13 09:19:10'),
('019ec5a9-37fc-70a8-b110-3261fb1d1fd8', 'tes', 'tes', '#bd2887', 0, '2026-06-14 03:24:22', '2026-06-14 03:24:22');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `reputation_points` int NOT NULL DEFAULT '0',
  `level` enum('user','moderator','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `email_verified_at`, `password_hash`, `avatar_url`, `bio`, `reputation_points`, `level`, `remember_token`, `created_at`, `updated_at`) VALUES
('019ea608-84d2-7004-9db6-7de55d3d86fa', 'admin_super', 'admin@minithreads.com', NULL, '$2y$12$PTBRv7kj.6YwAEnXs0Opu.Bix0Z6BsWZ22ipWou7PkJ1bM5Vgv6UO', NULL, 'Saya adalah Admin Super di Mini Threads.', 0, 'user', NULL, '2026-06-08 00:00:36', '2026-06-14 02:42:19'),
('019ea608-84e3-7001-a5e8-6c510b21b322', 'mod_kece', 'moderator@minithreads.com', NULL, '$2y$12$2IdftOhFIiR5H9Mxo5Ey7uw75bp4S6NgUqdc92Rb77izrtV12QUHK', NULL, 'Moderator yang siap menjaga komunitas.', 0, 'moderator', NULL, '2026-06-08 00:00:36', '2026-06-08 00:00:36'),
('019ea608-84e9-70c0-9620-0386c6564a6a', 'user_biasa', 'user@minithreads.com', NULL, '$2y$12$G.BczrMOGbo5GslysseEXeCXwSR1IrsrJmHDKdS4tQIfbiCb/Mwhu', NULL, 'Hanya user biasa yang suka membaca.', 0, 'user', NULL, '2026-06-08 00:00:36', '2026-06-08 00:00:36'),
('019ea608-89f2-7311-8f2b-8135d5ae8afc', 'hkertzmann', 'kevon73@example.net', '2026-06-08 00:00:36', '$2y$12$1ucPdop3lmbZ85SGifB/SOFGNcsRLqy14/eZkSpO8KqJb5vrQWHg6', NULL, NULL, 0, 'user', 'AVE6RBk0yH', '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-89fd-700a-938d-aae09d67453e', 'wunsch.bianka', 'smcclure@example.com', '2026-06-08 00:00:37', '$2y$12$0cQhyzOKnHyr5zzynSZjw.2av8Gu.2HL/HdPgpi.uZX54iQQX5Oxu', NULL, NULL, 0, 'user', 'd1EudSvThB', '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a01-717b-a225-e9775a5c70eb', 'watson.fritsch', 'bridie09@example.net', '2026-06-08 00:00:37', '$2y$12$JJ/Qj32VybIG.LsUcgrr/OKVIx36hxzPKjR.IuNf9rQwXtpOIzmd.', NULL, NULL, 0, 'moderator', 'NWeoGIS5o8', '2026-06-08 00:00:38', '2026-06-12 23:12:21'),
('019ea608-8a05-7016-b5d1-0ce80737caa1', 'mohamed62', 'norbert.weissnat@example.org', '2026-06-08 00:00:37', '$2y$12$uVqDILJoDZUAxawPl9cJ9OS4AuApeQZHfRXjxeIH6EO34xAn.iqkS', NULL, NULL, 0, 'user', 'zvYNUfaaes', '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019ea608-8a0a-7085-8b48-5ef3bb954c43', 'rice.shaun', 'thompson.libbie@example.org', '2026-06-08 00:00:37', '$2y$12$9U.u4rJposTch/02ZG6YFe.T5ryEqUhViNnEO9FZ8u91UfE2yaWDG', NULL, NULL, 0, 'user', 'fQUSSq8zQh', '2026-06-08 00:00:38', '2026-06-08 00:00:38'),
('019eaaee-db66-733e-bf9a-aed12c62697f', 'dhe', 'dhe@gmail.com', NULL, '$2y$12$1VxfsjNCnCgoVburtnGRreN.bXY8kMvdo9J4Iwwh0LH9enAnfG7r6', NULL, NULL, 0, 'moderator', NULL, '2026-06-08 22:50:40', '2026-06-08 22:50:40'),
('019eab24-f616-707a-90de-3a3c641bc8ee', 'user', 'user@gmail.com', NULL, '$2y$12$T5H2BOgW2bssNKK5KoP9g.0ogXISQ2QB.EzFWAM0TZBNU51JJ3q2y', NULL, NULL, 0, 'user', NULL, '2026-06-08 23:49:46', '2026-06-08 23:49:46'),
('019eab3d-cfd7-71e8-82ad-8e8b6120a755', 'anggara', 'arangga@gmail.com', NULL, '$2y$12$zWauE8AHUpRfjRvHTNIXWuLkuMDyjCzNfhdwItYN2tryY8/2WwwoG', NULL, NULL, 0, 'user', NULL, '2026-06-09 00:16:55', '2026-06-09 00:16:55'),
('019eb132-5bdb-73ad-81df-faad1b3250a6', 'jandhok', 'dg@gmail.com', NULL, '$2y$12$3rjdMgh8HN5ZmZcHyrOfzeOECzl6djyCfTdITWaTZiLJ3rPUOuXZa', 'http://127.0.0.1:8000/storage/avatars/t8PHoZ6xERaXaKZ0bkXsffb0rCpMJE63XRl0nMCg.jpg', 'gg', 75, 'admin', NULL, '2026-06-10 04:02:08', '2026-06-14 00:25:42'),
('019eb151-bfc3-7359-9bc2-58ed56f171c9', 'bt', 'bt@gmail.com', NULL, '$2y$12$rIOXOaP4fw5tvVHEzDRnp.Uxm4NGHbPGrQWWH5Su9U3Ogq4x/l2mu', NULL, NULL, 0, 'moderator', NULL, '2026-06-10 04:36:25', '2026-06-12 23:08:07'),
('019eb169-350f-709f-b731-4014868edac0', 'hai', 'hai@gmail.com', NULL, '$2y$12$LcMv/29.O2Y1v/UCZV6ldec3WXvovJFkwD/VSUy62KQW8X6QQu.5y', NULL, NULL, 0, 'user', NULL, '2026-06-10 05:02:02', '2026-06-10 05:02:02'),
('019eb248-68b7-724b-9868-ce56b8e80d09', 'testuser', 'test@test.com', NULL, '$2y$12$WSLyzLzwx.UaieKpz1bkuuZSIzDwq9HOSOarmmRISXu5t/oUybh9u', NULL, NULL, 0, 'user', NULL, '2026-06-10 09:05:50', '2026-06-10 09:05:50'),
('019eb26d-dcfd-727b-a939-e5e369854170', 'df', 'df@gmail.com', NULL, '$2y$12$dx4fwC8oCptHDYbcAZd1oOQSOeU7AuMjjcKVQ7OCDo6aIOXoo2SdG', NULL, NULL, 25, 'user', NULL, '2026-06-10 09:46:44', '2026-06-10 09:47:43'),
('019eb5f9-8a0a-7219-a53c-39e115185697', 'cypress_bm_1781169488954', 'cypress_bm_1781169488954@test.com', NULL, '$2y$12$hfP0dwnl6dl9QtZaWUHhmOaN2XF7RGCBMdnwqZ6x3r2WtuX83/lpu', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:18:10', '2026-06-11 02:18:10'),
('019eb5fa-2884-703b-ae31-efca82079c01', 'cypress_bm_1781169530492', 'cypress_bm_1781169530492@test.com', NULL, '$2y$12$qVs.2U0qRUTGaiUdUMUlbu1KI/UIsKyFWjLsLoTSrv9VPU4RkbTBy', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:18:51', '2026-06-11 02:18:51'),
('019eb5fa-476d-70eb-8234-4f61f558bb7c', 'cypress_bm_1781169538225', 'cypress_bm_1781169538225@test.com', NULL, '$2y$12$a44bIWooHPgCiRuhrY/cteu48g/sHsXTG.AJJx1v3Z/8RR/Jaghs.', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:18:58', '2026-06-11 02:18:58'),
('019eb5fa-d1e9-7136-9c9b-83c81915c31a', 'cypress_create_1781169573832', 'cypress_create_1781169573832@test.com', NULL, '$2y$12$eMZMLvOeSuDNrpCwlx1oIOzuUjyEKWv4pg9CHGpksi0haGM4HUQPW', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:19:34', '2026-06-11 02:19:34'),
('019eb5fb-1e8a-72ce-8bf2-93c0b4e1380f', 'cypress_create_1781169593532', 'cypress_create_1781169593532@test.com', NULL, '$2y$12$VnCgTbrMIkshHIs0r1HBSugf9XqHrR18ILtPcY.HaYmtKsh5uKd5a', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:19:53', '2026-06-11 02:19:53'),
('019eb5fc-41df-70f1-852d-2fb24964e565', 'cypress_create_1781169667635', 'cypress_create_1781169667635@test.com', NULL, '$2y$12$8XGf5XOwCFmeCbiVyJNQpeNzEUfXIlsed5jUL3mYoj4D8tf.AtiPy', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:21:08', '2026-06-11 02:21:08'),
('019eb5fc-80d7-7085-a4ad-ece3d8bd268b', 'cypress_create_1781169684181', 'cypress_create_1781169684181@test.com', NULL, '$2y$12$m3LYNDK35AdoTadNhmBD7.J2MgRzAFXzDahu6FeQ6IO.NfsqsqmLS', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:21:24', '2026-06-11 02:21:24'),
('019eb5fc-9ce4-7086-ad33-d5af56c6ca4a', 'cypress_create_1781169689925', 'cypress_create_1781169689925@test.com', NULL, '$2y$12$3bYElHIaH5oCK/omNLbKY.NgTqomv8ZHzkXmRTwUnEAB1Lf7UP.YK', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:21:31', '2026-06-11 02:21:31'),
('019eb5fd-d0fe-7345-b364-fb1659e8d807', 'cypress_create_1781169770010', 'cypress_create_1781169770010@test.com', NULL, '$2y$12$.9VUWFoOcFzFLtp456WTcu5SoYUmiYuO.gXnIq6RUHs8ep/Hywg3O', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:22:50', '2026-06-11 02:22:50'),
('019eb5fe-1b9c-72b6-a2b3-c0b84a6ab087', 'cypress_edge_1781169789282', 'cypress_edge_1781169789282@test.com', NULL, '$2y$12$3dZzlhE/N4tI92MSjlTwWe7v/jY./PVC.XMtR6PoEVL.ilfRDPex.', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:23:09', '2026-06-11 02:23:09'),
('019eb5fe-5571-72f7-b848-337c2c4fff6d', 'cypress_home_1781169804048', 'cypress_home_1781169804048@test.com', NULL, '$2y$12$3uDJBC9QU4D74oq7qvmcgeILCH4Fbu/8.WrhsxfRQvBm0kYi.LDSW', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:23:24', '2026-06-11 02:23:24'),
('019eb5ff-f733-7149-8278-690e8be26d77', 'user6578', 'user6578@test.com', NULL, '$2y$12$v2VbiKGKDI6E79l4TYUrKeJS4/3SeVzCtHCbpKQ91Y/ncVvEmM8aC', NULL, NULL, 0, 'user', NULL, '2026-06-11 02:25:11', '2026-06-11 02:25:11'),
('019eba80-95d0-7348-be0d-d42c41fa7e08', 'user8886', 'user8886@test.com', NULL, '$2y$12$06C344LsJM5T4dgVUWj.X.JdTF20aHOXtspJcs5IxCTP2Tp5S2T5G', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:24:09', '2026-06-11 23:24:09'),
('019eba81-1261-73fa-ac12-91118d44e42e', 'user8255', 'user8255@test.com', NULL, '$2y$12$7bn/a6MbfD2wBTgqDKthLuNWnZC3MoHyLK5r16sNLgCj6EJKCKjyu', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:24:41', '2026-06-11 23:24:41'),
('019eba81-5fb9-726f-a708-075ddedd9cf8', 'cypress_edge_1781245500917', 'cypress_edge_1781245500917@test.com', NULL, '$2y$12$WVgc5YNk.BvO4HXunlDUOOKsQhmyZqeOzT0BD25E7plYloZ7DLO.e', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:25:01', '2026-06-11 23:25:01'),
('019eba81-a5fa-73ed-9078-7d73e73299a5', 'cypress_edge_1781245518860', 'cypress_edge_1781245518860@test.com', NULL, '$2y$12$JsyGDHGQR.JOLzjpafJB2upa3XDgI4nd//nXHI/6dMgdwc3frDkWG', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:25:19', '2026-06-11 23:25:19'),
('019eba81-f69e-73a3-b956-acf41d2533f4', 'user6456', 'user6456@test.com', NULL, '$2y$12$y5ytGSGNEKWcgKvGpOZc4OUeLdB2xBr9n2VgHcYYjXJVR5FVk9kMy', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:25:39', '2026-06-11 23:25:39'),
('019eba85-c537-7087-9755-f0ce11d43e91', 'user4991', 'user4991@test.com', NULL, '$2y$12$quxLtz4wpM6BWBLrri6ZvuE7yEap8eRzyIqnGmfdwrwx8jKglS3g.', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:29:49', '2026-06-11 23:29:49'),
('019eba86-5703-7361-a2fd-3481da708c59', 'user6051', 'user6051@test.com', NULL, '$2y$12$WSo8A2DE5G33xLTpe4rxNu8fGSYZ8WuxABdzyMUQduG7ic0H6BqFu', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:30:26', '2026-06-11 23:30:26'),
('019eba86-bcda-706d-a7b7-7f0bab3cb865', 'user3043', 'user3043@test.com', NULL, '$2y$12$EE33nMrGE0PsKXCIZvORPOjD0OuU0KYra.pVhoEgXcovvkFVKAbq.', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:30:52', '2026-06-11 23:30:52'),
('019eba87-bfc4-704f-83ba-f6d2cfd82a1c', 'user9626', 'user9626@test.com', NULL, '$2y$12$DyjxSEOiCQFTkkw/MoY3ku/E53RhW3u56YfNTvf7t6ot/NP7OZzk6', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:31:59', '2026-06-11 23:31:59'),
('019eba88-0c8a-7253-a574-670eb519655b', 'user4042', 'user4042@test.com', NULL, '$2y$12$76g5Blt82nyTKqso8kqvJOjNdZooXnwRHf28h2ie7Ic89BeFIhXp.', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:32:18', '2026-06-11 23:32:18'),
('019eba88-fa00-73d8-82de-03d7e2c1de1a', 'user1981', 'user1981@test.com', NULL, '$2y$12$ouzZB7gHaO/R9bFQxdHdgOZ1qLWwRVi/bikWl6SIMMTiDOsQwhELC', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:33:19', '2026-06-11 23:33:19'),
('019eba8a-35af-7073-b163-b7d1133fc939', 'user7544', 'user7544@test.com', NULL, '$2y$12$8d7THuMuHUu6DsfYwYgVgu9gInxbqN6aVA6xC1nLkVvRgxqVGGA9m', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:34:40', '2026-06-11 23:34:40'),
('019eba8b-b1d7-705a-80a8-97f0c9e98c60', 'user8715', 'user8715@test.com', NULL, '$2y$12$lUtPoI1LaQpdZelTCvCqW.gUid6ajBZV64UvxJXNjqPxyjzKVVTPu', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:36:17', '2026-06-11 23:36:17'),
('019eba8d-a38f-709f-b022-84c0f8dfb60b', 'user2458', 'user2458@test.com', NULL, '$2y$12$ZOlX0FE0o8/8q1pIp6bHvOyv/Wr4POUZfyPvfxKMET400ssXBhLqa', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:38:25', '2026-06-11 23:38:25'),
('019eba90-796a-7164-8902-099d5867dce5', 'user7397', 'user7397@test.com', NULL, '$2y$12$ToyKjP0AHYjBi3/0HqucDOq2vcjeXL4oIhMBDu4pKGt8kpRumF7Tq', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:41:30', '2026-06-11 23:41:30'),
('019eba91-1fbd-707f-9396-591c3013d579', 'user6518', 'user6518@test.com', NULL, '$2y$12$Qj7pnAH7HZMke1PSM35y0eFZNr7.2H5TJqGP.ODUGuFe3wySOBf0q', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:42:13', '2026-06-11 23:42:13'),
('019eba91-78ae-70fb-963f-41c096cd4900', 'user5575', 'user5575@test.com', NULL, '$2y$12$VpmlcDf49Dm.qtDGoPqcmeM4OFmu4vVUZPv631ex8adloCe/ybD7q', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:42:36', '2026-06-11 23:42:36'),
('019eba92-0131-71e0-862a-cbd012171e8a', 'user3496', 'user3496@test.com', NULL, '$2y$12$4K.G2tIIpdTgVFq0h1ZPnu3ikPT4pr8sHJgLjHdnvpjskKo0CUym2', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:43:11', '2026-06-11 23:43:11'),
('019eba92-4032-735e-ad7d-d7473df42f2c', 'user1233', 'user1233@test.com', NULL, '$2y$12$m7ARcE7jCW9gx25HJq3mceScL8ShO82iLPqCafC19tqFfXli3VpKm', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:43:27', '2026-06-11 23:43:27'),
('019eba92-74ee-7096-bb78-441cbd0eac77', 'cypress_edge_1781246620257', 'cypress_edge_1781246620257@test.com', NULL, '$2y$12$CbALpOwRZ2uQIe91/3HK2.FdGhGgfkuBHBBJhHq8.elRhFNliZCkG', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:43:40', '2026-06-11 23:43:40'),
('019eba92-ae42-71d6-bb9b-9d1878b8a8ac', 'user7711', 'user7711@test.com', NULL, '$2y$12$cyVFBSa2Z60iCYbsV4ItXuEFghOnSiWcAhyF2ExrikWV6/U3jTKH2', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:43:55', '2026-06-11 23:43:55'),
('019eba93-186e-73f5-867d-28aedf085449', 'user7846', 'user7846@test.com', NULL, '$2y$12$aILk.AqvMTZ.ckps1GAbVegQZOw5UsrxvKH7FoV1pIVGIZb8xr/7m', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:44:22', '2026-06-11 23:44:22'),
('019eba93-a585-7003-a6e7-0bc9f970a69e', 'user3212', 'user3212@test.com', NULL, '$2y$12$P4TsOSvyNuBW6D7i21i0l.RaTcvaOdfd3ITKXf6Wk6wbFpdc25dxu', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:44:58', '2026-06-11 23:44:58'),
('019eba93-ce4a-72b9-b06e-c3e55bd0de77', 'cypress_prof_1781246708682', 'cypress_prof_1781246708682@test.com', NULL, '$2y$12$fY5RA2ak0Um6vpeGdVsyie.RfgEfbR7AvdoBDpX3kJbUlR7cbd1Re', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:45:09', '2026-06-11 23:45:09'),
('019eba94-111d-7044-a381-b07945f44907', 'user6043', 'user6043@test.com', NULL, '$2y$12$.gioFeOfE6AYh68kymMZpuMhadTzV.hLeYE8X/8Ks9rHxg5GuXxSa', NULL, NULL, 0, 'user', NULL, '2026-06-11 23:45:26', '2026-06-11 23:45:26'),
('019ebaad-6acc-73f6-8c4c-2f244f01b570', 'user6594', 'user6594@test.com', NULL, '$2y$12$nSvXg/F.9Q/iQpa6H/aRK.JQU2osg.JHfd0bACQW9upw6zzaS7YOu', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:13:07', '2026-06-12 00:13:07'),
('019ebaae-31f6-71a6-bcd6-759b94035021', 'user1670', 'user1670@test.com', NULL, '$2y$12$bTQ2hsfCDHqofx9f.V9m8eWdwiH8a0k9BlIWSY6V.xL1C3ROjTABq', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:13:58', '2026-06-12 00:13:58'),
('019ebaae-9373-72b7-bb67-568410e8e70c', 'user6751', 'user6751@test.com', NULL, '$2y$12$YncHt8J4YK3KHt8Qjj0a..xrkOyE1ekckcSO5U8R/goqbo3pEHBRW', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:14:23', '2026-06-12 00:14:23'),
('019ebaae-d2b0-721f-918f-6a3a902ff618', 'cypress_edge_1781248479201', 'cypress_edge_1781248479201@test.com', NULL, '$2y$12$ve0.rsYNl7/Ad70ycJov8OIWBFMFP5A.rEv.zTOzRlg/A5tGgJ9c6', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:14:39', '2026-06-12 00:14:39'),
('019ebaaf-0b78-7357-8eae-e347f8632dd4', 'user2355', 'user2355@test.com', NULL, '$2y$12$yBJB7QKvhpybu003lJk5gut5gCN/s7AVdmt7QahA9hfixJ0bOihs6', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:14:54', '2026-06-12 00:14:54'),
('019ebaaf-87b4-7127-9502-ce588f1fcd78', 'user6822', 'user6822@test.com', NULL, '$2y$12$bh3iDdaVtw.bCKQ57PzTouXbmWdtoU56zfV4iRwlxK.KxcTMkveEy', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:15:26', '2026-06-12 00:15:26'),
('019ebaaf-ecfb-7125-804b-f702c21c4ca1', 'user8732', 'user8732@test.com', NULL, '$2y$12$17bZhErxN0b71AGRrPFFjengIEWt48r7UrQEl5JnNUpfvmNYUqr.2', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:15:52', '2026-06-12 00:15:52'),
('019ebab0-34f7-7271-bab8-27c568a135e4', 'cypress_prof_1781248569967', 'cypress_prof_1781248569967@test.com', NULL, '$2y$12$mMkIlR.lQfguQKfEpxXdYeT/gaG/Jx6SNkCeD70IR0WMNOA40GMUC', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:16:10', '2026-06-12 00:16:10'),
('019ebab0-a1f1-7341-9b7e-61ec94ac6d64', 'user6546', 'user6546@test.com', NULL, '$2y$12$QfQkhMt1J6uW4ELZi64/vuidFt.7xAjqhAASH3WTDk9jXGXU6jaWm', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:16:38', '2026-06-12 00:16:38'),
('019ebab0-dda0-7247-adf5-9b4b75dc8246', 'user7168', 'user7168@test.com', NULL, '$2y$12$3TE/QjC68pKBROvxUGeSWOaLul/7zr78lIdyTUfdIMRIIwxv4mOci', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:16:53', '2026-06-12 00:16:53'),
('019ebab1-a9d7-71b6-922b-b5701ba19f5e', 'user2757', 'user2757@test.com', NULL, '$2y$12$1oNDSkni68zYgmlbuQCEc.calj1TAZb5mtkGoVRxsHKubSqJx4d3q', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:17:46', '2026-06-12 00:17:46'),
('019ebab2-0b24-71ae-9fbc-8f8a2f06a853', 'cypress_prof_1781248690207', 'cypress_prof_1781248690207@test.com', NULL, '$2y$12$v1xzfeyUgCxdN9alD/TSbeLptQIXVpNXK.AB4DNgkAp68Lbd1Pfru', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:18:10', '2026-06-12 00:18:10'),
('019ebab2-8a73-7263-bf65-cabcabb3b2fa', 'user4770', 'user4770@test.com', NULL, '$2y$12$NHxshzRC930i8qP2JP5BIOEBgymA7XskRYTy0msLhJE6DmsqbikPa', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:18:43', '2026-06-12 00:18:43'),
('019ebab2-fa13-73a9-a20e-b3ed9f2a71fc', 'user1642', 'user1642@test.com', NULL, '$2y$12$xWcZQtta0wOQdDabVz5TQuHjuMc/yv/SrOI0u9og/a2.qs2ZAnXSa', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:19:12', '2026-06-12 00:19:12'),
('019ebad2-67b6-7344-bbd3-48dc0eb33e01', 'disturw', 'dis@gmail.com', NULL, '$2y$12$N9WQLVsMo9Y.MukRbRwzEeYkALMmSZmrwYj9KZnUZcAI6kf7wsLpy', NULL, NULL, 0, 'user', NULL, '2026-06-12 00:53:31', '2026-06-12 00:53:31'),
('019ebb81-a149-72c0-a869-5acd5a5ff752', 'uniqueuser123', 'uniqueuser123@example.com', NULL, '$2y$12$XiBRnmL98zkBZpl4FHO43uP98QMkFDzBVt0/QZCRL9jYZG9WDjYO6', NULL, NULL, 0, 'user', NULL, '2026-06-12 04:04:55', '2026-06-12 04:04:55'),
('019ebb95-47e1-70c9-9b7c-1fadfc8fcd35', 'reportuser5782', 'reportuser5782@test.com', NULL, '$2y$12$Tt7y5hy60AwIXN5XCbvSSeb7AvoUwB9GFcgnUbGwyKm1U81aOKm4e', NULL, NULL, 0, 'user', NULL, '2026-06-12 04:26:23', '2026-06-12 04:26:23'),
('019ebb96-6e79-723e-94ce-2706968f8f0d', 'reportuser3736', 'reportuser3736@test.com', NULL, '$2y$12$UCduosgAm5mUCFFhVB1gseiZu1u0Ebm4A3WVSseg2LLteMrcWNtlO', NULL, NULL, 0, 'user', NULL, '2026-06-12 04:27:38', '2026-06-12 04:27:38'),
('019ebb98-f12f-7016-b439-54e90d62e91e', 'reportuser5747', 'reportuser5747@test.com', NULL, '$2y$12$UxxkkrFuTDmFcBPsCBw7e.WZLYcsFeaS.5usNBNN9fh6bo1NcyLx2', NULL, NULL, 0, 'user', NULL, '2026-06-12 04:30:23', '2026-06-12 04:30:23'),
('019ebfa5-77e3-737f-8aaa-6a57ea8f9b13', 'dheni', 'dheni@gmail.com', NULL, '$2y$12$1IOVPsnLeA4vya5AwzpgROXfRgFjN2FO0463EPg1qzwg27LWp.ADO', NULL, NULL, 0, 'user', NULL, '2026-06-12 23:22:32', '2026-06-12 23:22:32'),
('019ec1d7-81a1-710e-a095-8217ed855a53', 'melvin', 'melvin@gmail.com', NULL, '$2y$12$9QO2O6abXulgnxGwQJivXOggpb.Paw8zopZva3D2WDx3i/i9HLxQy', NULL, NULL, 20, 'user', NULL, '2026-06-13 09:36:26', '2026-06-13 10:05:51'),
('019ec55c-076e-7087-87e4-a5afed2ad45c', 'modtest', 'modtest@gmail.com', NULL, '$2y$12$2gAxcRWXiTPv4wtBXbEBQ.N4WXsXr813v7UbRRcx.Yy2Z2DbvFF.i', NULL, NULL, 0, 'user', NULL, '2026-06-14 02:00:03', '2026-06-14 02:00:03'),
('019ec595-dfd4-7340-8012-99e8cec3c54f', 'admin_target_1781431392512', 'admin_target_1781431392512@test.com', NULL, '$2y$12$JoElABQcVIYLYMMflFU65eiH.7OKGVxZF8VzdTZJccQyxpKXizP0i', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:03:14', '2026-06-14 03:03:14'),
('019ec597-c47e-7104-b332-9aba4f021a9f', 'admin_target_1781431516734', 'admin_target_1781431516734@test.com', NULL, '$2y$12$nFQI2NtnFviZ8Grn6M4ijOUPahSJsDmlrZLuNifn7aKY5wJe/HnZO', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:05:18', '2026-06-14 03:05:18'),
('019ec597-dbca-72f0-af82-4e6c495690bd', 'admin_target_1781431522229', 'admin_target_1781431522229@test.com', NULL, '$2y$12$.i7cBMTQ7pycZ815IVTbtO88GfCIbZs2/4xgeHTnpIWCFoCPgVkAO', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:05:24', '2026-06-14 03:05:24'),
('019ec597-e944-718f-b35b-5e370987447a', 'admin_target_1781431524539', 'admin_target_1781431524539@test.com', NULL, '$2y$12$Nb8xsXHEbRxNnuE/MmTTBu6QBXqvraCoIGg7dYezVfZqDQ3plpN8G', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:05:27', '2026-06-14 03:05:27'),
('019ec597-f62c-724b-b2c1-e303ac091611', 'admin_target_1781431528225', 'admin_target_1781431528225@test.com', NULL, '$2y$12$Amhw7dYO.CoOHyZ81/61fO/z4YN0od3PkVLvzla2UTs8r/1l5SqYS', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:05:31', '2026-06-14 03:05:31'),
('019ec598-0aaa-72a5-b5eb-09b38b78e61f', 'admin_target_1781431533672', 'admin_target_1781431533672@test.com', NULL, '$2y$12$qBYvL2/K6gG1uNaZD.Y9dOx/bd5Vx.2vsdRPu0x.LTSZCsKtfnRoe', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:05:36', '2026-06-14 03:05:36'),
('019ec598-32d6-71fc-8e82-2d7d2f492627', 'admin_target_1781431545000', 'admin_target_1781431545000@test.com', NULL, '$2y$12$isYB.Sg9CWHb.K7KbVX4TeaH.DxQ9NuguaAQ6pd6lFlZfc9iSd73u', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:05:46', '2026-06-14 03:06:34'),
('019ec59b-77fa-731c-90f3-84b8117842a8', 'admin_target_1781431759109', 'admin_target_1781431759109@test.com', NULL, '$2y$12$X8Pt9Emqo/rB/ki12FOGQOsfZ.oklWT6utBhb5oqPBuxfarDhwYVi', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:09:20', '2026-06-14 03:09:20'),
('019ec59c-8319-727f-95fe-4be163802b31', 'admin_target_1781431827307', 'admin_target_1781431827307@test.com', NULL, '$2y$12$2ZaRyjc1.xUwJvybZyFYBe0P9GrkyUcMIexU84AyFHzAMpPl0aD0y', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:10:29', '2026-06-14 03:10:29'),
('019ec5b0-7d2e-7245-91b9-54774a13c180', 'user_1781433125970', 'user_1781433125970@test.com', NULL, '$2y$12$ZuRYxhewuoJCk/CTholRU.skZwR0tw99TWRWKPxFKnyk0b8xiA7Ti', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:32:18', '2026-06-14 03:32:18'),
('019ec5b2-dfd4-7095-ba2c-5007bcd26f9d', 'user_1781433281168', 'user_1781433281168@test.com', NULL, '$2y$12$RMffcz84dYYtSGY0bxX47OrxhD5JwXr5LE9l.deQgInViuaU.9lfu', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:34:54', '2026-06-14 03:34:54'),
('019ec5b9-81ee-71f3-84cc-aef236221f67', 'user_1781433717052', 'user_1781433717052@test.com', NULL, '$2y$12$dZKrxeldJzw/nyJ2LqaM7uHTJyJrrunQajas0LUBBqhxlAtCOxV96', NULL, NULL, 0, 'user', NULL, '2026-06-14 03:42:09', '2026-06-14 03:42:09');

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vote_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `votes`
--

INSERT INTO `votes` (`id`, `user_id`, `target_id`, `target_type`, `vote_type`, `created_at`, `updated_at`) VALUES
('019eb150-6b34-7247-8969-7e60192cc96e', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8aab-7399-b025-6c1951efa3b3', 'post', 'up', '2026-06-10 04:34:58', '2026-06-10 04:34:58'),
('019eb26e-a4f2-707c-8820-412879b069e1', '019eb26d-dcfd-727b-a939-e5e369854170', '019eb14f-7702-71a5-b13f-2cba330a66eb', 'post', 'up', '2026-06-10 09:47:36', '2026-06-10 09:47:36'),
('019eb26e-aa8f-7352-85f8-c801e301f499', '019eb26d-dcfd-727b-a939-e5e369854170', '019eb24e-eae5-7001-aaae-07d06ccc98c3', 'comment', 'up', '2026-06-10 09:47:37', '2026-06-10 09:47:37'),
('019eb26e-c19a-70f5-83da-f308a820aaca', '019eb26d-dcfd-727b-a939-e5e369854170', '019eb24f-009a-720b-8157-3f9431211683', 'comment', 'up', '2026-06-10 09:47:43', '2026-06-10 09:47:43'),
('019ebfa2-c64d-713f-bf7a-e5f80d2c179f', '019eb132-5bdb-73ad-81df-faad1b3250a6', '019ea608-8aea-7232-acb5-f3eb2b81a754', 'post', 'up', '2026-06-12 23:19:36', '2026-06-12 23:19:36'),
('019ec1d7-c244-7260-b969-cd322ebd27d6', '019ec1d7-81a1-710e-a095-8217ed855a53', '019ec1d2-a072-708b-843d-7439ca4359fe', 'post', 'up', '2026-06-13 09:36:43', '2026-06-13 09:36:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bookmarks_user_id_post_id_unique` (`user_id`,`post_id`),
  ADD KEY `bookmarks_post_id_foreign` (`post_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`),
  ADD KEY `categories_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `claps`
--
ALTER TABLE `claps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `claps_user_id_clapable_id_clapable_type_unique` (`user_id`,`clapable_id`,`clapable_type`),
  ADD KEY `claps_clapable_id_clapable_type_index` (`clapable_id`,`clapable_type`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_post_id_index` (`post_id`),
  ADD KEY `comments_user_id_index` (`user_id`),
  ADD KEY `comments_parent_id_index` (`parent_id`);

--
-- Indexes for table `comment_edit_histories`
--
ALTER TABLE `comment_edit_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comment_edit_histories_comment_id_foreign` (`comment_id`),
  ADD KEY `comment_edit_histories_user_id_foreign` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `follows`
--
ALTER TABLE `follows`
  ADD PRIMARY KEY (`follower_id`,`following_id`),
  ADD KEY `follows_following_id_foreign` (`following_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `likes_user_id_target_id_target_type_unique` (`user_id`,`target_id`,`target_type`),
  ADD KEY `likes_target_id_target_type_index` (`target_id`,`target_type`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `points_logs`
--
ALTER TABLE `points_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `points_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `posts_slug_unique` (`slug`),
  ADD KEY `posts_user_id_index` (`user_id`),
  ADD KEY `posts_category_id_index` (`category_id`),
  ADD KEY `posts_accepted_answer_id_foreign` (`accepted_answer_id`);

--
-- Indexes for table `post_edit_histories`
--
ALTER TABLE `post_edit_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_edit_histories_post_id_foreign` (`post_id`),
  ADD KEY `post_edit_histories_user_id_foreign` (`user_id`);

--
-- Indexes for table `post_tags`
--
ALTER TABLE `post_tags`
  ADD PRIMARY KEY (`post_id`,`tag_id`),
  ADD KEY `post_tags_tag_id_foreign` (`tag_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reports_user_id_foreign` (`user_id`),
  ADD KEY `reports_resolved_by_foreign` (`resolved_by`),
  ADD KEY `reports_target_id_target_type_index` (`target_id`,`target_type`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tags_slug_unique` (`slug`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `user_roles_role_id_foreign` (`role_id`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `votes_user_id_target_id_target_type_unique` (`user_id`,`target_id`,`target_type`),
  ADD KEY `votes_target_id_target_type_index` (`target_id`,`target_type`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD CONSTRAINT `bookmarks_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookmarks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `claps`
--
ALTER TABLE `claps`
  ADD CONSTRAINT `claps_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comment_edit_histories`
--
ALTER TABLE `comment_edit_histories`
  ADD CONSTRAINT `comment_edit_histories_comment_id_foreign` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comment_edit_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `follows`
--
ALTER TABLE `follows`
  ADD CONSTRAINT `follows_follower_id_foreign` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `follows_following_id_foreign` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `points_logs`
--
ALTER TABLE `points_logs`
  ADD CONSTRAINT `points_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_accepted_answer_id_foreign` FOREIGN KEY (`accepted_answer_id`) REFERENCES `comments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `posts_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_edit_histories`
--
ALTER TABLE `post_edit_histories`
  ADD CONSTRAINT `post_edit_histories_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_edit_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_tags`
--
ALTER TABLE `post_tags`
  ADD CONSTRAINT `post_tags_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_tags_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_resolved_by_foreign` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `votes`
--
ALTER TABLE `votes`
  ADD CONSTRAINT `votes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
