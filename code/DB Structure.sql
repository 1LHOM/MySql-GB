DROP DATABASE IF EXISTS online_school;

CREATE DATABASE online_school;

USE online_school;

DROP TABLE IF EXISTS countries;
CREATE TABLE countries(
	id TINYINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	short_name varchar(60) UNIQUE,
	alpha_3_code char(3) UNIQUE );

DROP TABLE IF EXISTS study_groups;
CREATE TABLE study_groups(
	id SERIAL PRIMARY KEY,
	fullname varchar(250),
	short_name char(10),
	description text );

DROP TABLE IF EXISTS course_categories;
CREATE TABLE course_categories(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar(100)
);

DROP TABLE IF EXISTS academic_status;
CREATE TABLE academic_status(
	id TINYINT(1) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
	name varchar(20) UNIQUE
);

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	firstname varchar(50),
	lastname varchar(50),
	middlename varchar(50),
	email varchar(100) UNIQUE,
	password_hash varchar(100),
	phone bigint UNSIGNED UNIQUE,
	INDEX user_idx(firstname, lastname));

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
	name VARCHAR(255),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP);

DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
	id SERIAL PRIMARY KEY,
	user_id bigint UNSIGNED NOT NULL,
	comment text,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
	media_type_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	filename VARCHAR(255),
	filesize INT,
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (media_type_id) REFERENCES media_types(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos(
	id SERIAL PRIMARY KEY,
	media_id bigint UNSIGNED NOT NULL,
	FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers(
	id SERIAL PRIMARY KEY,
	user_id bigint UNSIGNED NOT NULL UNIQUE,
	gender char(1),
	birthday date,
	photo_id bigint UNSIGNED,
	country_id TINYINT UNSIGNED,
	created_at DATETIME DEFAULT now(),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (photo_id) REFERENCES photos(id),
	FOREIGN KEY (country_id) REFERENCES countries(id)
);

DROP TABLE IF EXISTS lec_documents;
CREATE TABLE lec_documents(
	id SERIAL PRIMARY KEY,
	name varchar(100),
	media_id bigint UNSIGNED NOT NULL,
	teacher_id bigint UNSIGNED NOT NULL,
	FOREIGN KEY (media_id) REFERENCES media(id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

DROP TABLE IF EXISTS lec_videos;
CREATE TABLE lec_videos(
	id SERIAL PRIMARY KEY,
	name varchar(100),
	media_id bigint UNSIGNED NOT NULL,
	teacher_id bigint UNSIGNED NOT NULL,
	FOREIGN KEY (media_id) REFERENCES media(id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

DROP TABLE IF EXISTS lec_materials;
CREATE TABLE lec_materials(
	id SERIAL PRIMARY KEY,
	name varchar(100),
	teacher_id bigint UNSIGNED NOT NULL,
	lec_doc_id bigint UNSIGNED DEFAULT NULL,
	lec_video_id bigint UNSIGNED DEFAULT NULL,
	comment_id bigint UNSIGNED DEFAULT NULL,
	FOREIGN KEY (lec_doc_id) REFERENCES lec_documents(id),
	FOREIGN KEY (lec_video_id) REFERENCES lec_videos(id),
	FOREIGN KEY (comment_id) REFERENCES comments(id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),

);

DROP TABLE IF EXISTS courses;
CREATE TABLE courses(
	id SERIAL PRIMARY KEY,
	teacher_id bigint UNSIGNED NOT NULL,
	name varchar(150),
	course_category_id TINYINT UNSIGNED NOT NULL,
	lec_material_id bigint UNSIGNED NOT NULL,
	description text,
	start_date datetime,
	end_date datetime,
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	FOREIGN KEY (course_category_id) REFERENCES course_categories(id),
	FOREIGN KEY (lec_material_id) REFERENCES lec_materials(id)
);

DROP TABLE IF EXISTS students;
CREATE TABLE students(
	id SERIAL PRIMARY KEY,
	user_id bigint UNSIGNED NOT NULL UNIQUE,
	gender char(1),
	birthday date,
	photo_id bigint UNSIGNED,
	study_groups_id bigint UNSIGNED,
	course_id bigint UNSIGNED,
	academic_status_id TINYINT(1) UNSIGNED,
	country_id TINYINT UNSIGNED,
	created_at datetime DEFAULT now(),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (photo_id) REFERENCES photos(id),
	FOREIGN KEY (study_groups_id) REFERENCES study_groups(id),
	FOREIGN KEY (course_id) REFERENCES courses(id),
	FOREIGN KEY (academic_status_id) REFERENCES academic_status(id),
	FOREIGN KEY (country_id) REFERENCES countries(id)	
);

DROP TABLE IF EXISTS hw_docs;
CREATE TABLE hw_docs(
	id SERIAL PRIMARY KEY,
	student_id bigint UNSIGNED NOT NULL,
	media_id bigint UNSIGNED NOT NULL,
	FOREIGN KEY (media_id) REFERENCES media(id),
	FOREIGN KEY (student_id) REFERENCES students(id)
);

DROP TABLE IF EXISTS homeworks;
CREATE TABLE homeworks(
	id SERIAL PRIMARY KEY,
	course_id bigint UNSIGNED NOT NULL,
	teacher_id bigint UNSIGNED NOT NULL,
	student_id bigint UNSIGNED NOT NULL,
	name varchar(255),
	hw_doc_id bigint UNSIGNED NOT NULL,
	date_attachment datetime DEFAULT now() ON UPDATE current_timestamp,
	is_checked boolean,
	grade TINYINT UNSIGNED DEFAULT NULL,
	comment_id bigint UNSIGNED NOT NULL,
	FOREIGN KEY (course_id) REFERENCES courses(id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	FOREIGN KEY (student_id) REFERENCES students(id),
	FOREIGN KEY (hw_doc_id) REFERENCES hw_docs(id),
	FOREIGN KEY (comment_id) REFERENCES comments(id)
);




