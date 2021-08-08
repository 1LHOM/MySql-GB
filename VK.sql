DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

USE vk;

CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(50), 
	lastname VARCHAR(50),
	email VARCHAR(100) UNIQUE,
	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED UNIQUE,
	
	INDEX user_firstname_lastname_idx(firstname, lastname)
)
;

DROP TABLE IF EXISTS profiles;

CREATE TABLE profiles(
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
	gender CHAR(1),
	birthday DATE,
	photo_id BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW(), 
	hometown VARCHAR(100)
	
	-- FOREIGN KEY (photo_id) REFERENCES media(id)
);

ALTER table profiles ADD CONSTRAINT fk_user_id
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON UPDATE CASCADE --  Значение по умолчанию
	ON DELETE RESTRICT; --  Значение по умолчанию
	
DROP TABLE IF EXISTS messages;

CREATE TABLE messages(
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL, 
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
); 

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests(
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	`status` ENUM('requested', 'approved', 'declined', 'unfriended'),
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
	FOREIGN KEY (target_user_id) REFERENCES users(id)
);

ALTER TABLE friend_requests
ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;

CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(50),
	admin_user BIGINT UNSIGNED NOT NULL,
	member_user BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name),
	FOREIGN KEY (admin_user) REFERENCES users(id),
	FOREIGN KEY (member_user) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;

CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	
	PRIMARY KEY (user_id, community_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
	name VARCHAR(255),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
	media_type_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	filename VARCHAR(255),
	`size` INT,
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW()

);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(50),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos(
	id SERIAL,
	album_id BIGINT UNSIGNED NULL,
	media_id BIGINT UNSIGNED NULL,
	
	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
	id SERIAL,
	user_id BIGINT UNSIGNED NULL,
	comment_text TEXT,
	
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts(
	id SERIAL,
	post_text TEXT,
	user_id BIGINT UNSIGNED NOT NULL,
	likes_id BIGINT UNSIGNED NOT NULL,
	comments_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id),
	FOREIGN KEY (likes_id) REFERENCES likes(id),
	FOREIGN KEY (comments_id) REFERENCES comments(id)

);


