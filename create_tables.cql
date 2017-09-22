USE replicated_data;

/* Create a User-Defined Type https://cassandra.apache.org/doc/latest/cql/types.html?highlight=frozen#user-defined-types */
CREATE TYPE IF NOT EXISTS address (
	state text,
	city text,
	zip_code int,
	street text,
);

/* Create a Table that uses the UDT */
CREATE TABLE IF NOT EXISTS people (
	id int,
	name text,
	age int,
	height float,
	location frozen <address>,
	phones set<text>,
	PRIMARY KEY ((id, name), age)
);
