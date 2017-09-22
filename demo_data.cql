DROP KEYSPACE demoKeyspace;
CREATE KEYSPACE demoKeyspace WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };

USE demoKeyspace;

DROP TABLE people;
DROP TYPE address;

CREATE TYPE address (
	state text,
	city text,
	zip_code int,
	street text,
);

CREATE TABLE people (
	id int,
	name text,
	age int,
	height float,
	location frozen <address>,
	phones set<text>,
	PRIMARY KEY ((id, name), age)
);

/* CREATE */

INSERT INTO people (id, name, age, height, location, phones)
VALUES (1, 'Adam', 25, 5.10, {state: 'CA', city: 'San Jose', zip_code: 95112, street: '4th Street'}, {'4086447221', '4086710231'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (2, 'Joe', 40, 5.10, {state: 'FL', city: 'Venice', zip_code: 34293, street: 'Willow Street'}, {'6406778231'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (3, 'Sarah', 25, 5.11, {state: 'PA', city: 'Nazareth', zip_code: 18064, street: '6th Street'}, {'7775556666', '8881110512'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (4, 'Jane', 21, 5.7, {state: 'PA', city: 'Nazareth', zip_code: 18064, street: '6th Street'}, {'4317800456'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (5, 'Glenn', 82, 5.4, {state: 'NJ', city: 'Piscataway', zip_code: 08854, street: 'Liberty Street'}, {'3016789087'});


SELECT * FROM people;

/*READ*/

SELECT name FROM people WHERE age = 25;  /* Will fail because column is not yet indexed */

CREATE INDEX ON people (age); 

SELECT name FROM people WHERE age = 25; 

SELECT * FROM people WHERE phones CONTAINS '7775556666'; /* Select person that owns phone number 7775556666 */

/*UPDATE*/

UPDATE people SET location = {state: 'CA', city: 'San Francisco', zip_code: 95077, street: '7th Street'} WHERE id = 1 AND name = 'Adam' AND age = 25;

SELECT name, location FROM people;

UPDATE people SET phones = phones + {'3015554808'} WHERE id = 5 AND name = 'Glenn' AND age = 82;

SELECT name, phones FROM people;

UPDATE people SET height = 6.5 WHERE id = 3 AND name = 'Sarah' AND age = 25;

SELECT name, height FROM people;


/*DELETE*/

DELETE FROM people WHERE name = 'Adam';

UPDATE people SET phones = phones - {'3016789087'} WHERE id = 5 AND name = 'Glenn' AND age = 82;
