/* 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.
 * Заполните их текущими датой и временем. */

UPDATE users
	SET  created_at = now(), updated_at = now(); 

/* 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at 
 * были заданы типом VARCHAR и в них долгое время помещались значения
 *  в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
 * сохранив введённые ранее значения. */

DROP TABLE IF EXISTS test_users;

CREATE TABLE test_users(
	created_at VARCHAR(255),
	updated_at VARCHAR(255)
);

INSERT INTO test_users (created_at, updated_at)
VALUES ('15.10.2007 15:10', '20.10.2017 13:10'),
		('23.02.2015 15:30', '4.01.2017 3:10');

UPDATE test_users
SET created_at = str_to_date(created_at, '%e.%m.%Y %k:%i'),
	updated_at = str_to_date(updated_at, '%e.%m.%Y %k:%i');

ALTER TABLE test_users
MODIFY created_at DATETIME 
DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE test_users
MODIFY updated_at DATETIME 
DEFAULT CURRENT_TIMESTAMP 
ON UPDATE CURRENT_TIMESTAMP;

/* 3. В таблице складских запасов storehouses_products в поле value
 * могут встречаться самые разные цифры: 0, если товар закончился 
 * и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
 * чтобы они выводились в порядке увеличения значения value. 
 * Однако нулевые запасы должны выводиться в конце, после всех */

DROP TABLE IF EXISTS storehouses_products;

CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouses_id INT UNSIGNED,
  products_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (value) 
VALUES (0), (2500), (0), (30), (500), (1);

SELECT * FROM storehouses_products 
ORDER BY IF (value > 0, 0, 1), value;

/* 4. (по желанию) Из таблицы users необходимо извлечь пользователей, 
 * родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august) */

SELECT MONTHNAME(birthday_at) AS birthday_month
FROM users 
WHERE MONTH(birthday_at) = 5 OR MONTH(birthday_at) = 8 
GROUP BY birthday_month 
ORDER BY birthday_month ;

/* 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
 * Отсортируйте записи в порядке, заданном в списке IN. */

SELECT * FROM catalogs WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

###################################################### 
 
# «Агрегация данных»

/* 1. Подсчитайте средний возраст пользователей в таблице users. */

# Version 1
SELECT sum(YEAR(now()) - YEAR(birthday_at))/count(id) AS Avearge_age_of_users FROM users;

# Version 2
SELECT avg(YEAR(now())- YEAR(birthday_at)) AS Avearge_age_of_users FROM users;


/* 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

SELECT  
	dayname(concat(YEAR(now()),'-', MONTH(birthday_at),'-', DAY(birthday_at))) AS week_days,
	count(*) AS number_of_birthdays, 
	group_concat(name order by name desc separator ', ') AS name_of_users 
FROM users 
GROUP BY week_days
ORDER BY number_of_birthdays DESC;





