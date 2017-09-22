USE replicated_data;

INSERT INTO people (id, name, age, height, location, phones)
VALUES (1, 'Adam', 25, 5.10, {state: 'CA', city: 'San Jose', zip_code: 95112, street: '4th Street'}, {'4086447221', '4086710231'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (2, 'Joe', 40, 5.10, {state: 'FL', city: 'Miami', zip_code: 34293, street: 'Willow Street'}, {'6406778231'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (3, 'Sarah', 25, 5.11, {state: 'PA', city: 'Philadelphia', zip_code: 18064, street: '6th Street'}, {'7775556666', '8881110512'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (4, 'Jane', 21, 5.7, {state: 'PA', city: 'Philadelphia', zip_code: 18064, street: '6th Street'}, {'4317800456'});

INSERT INTO people (id, name, age, height, location, phones)
VALUES (5, 'Glenn', 82, 5.4, {state: 'NJ', city: 'Trenton', zip_code: 08854, street: 'Liberty Street'}, {'3016789087'});
