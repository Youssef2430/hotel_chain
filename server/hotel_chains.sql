CREATE TABLE chains (
  chain_id serial PRIMARY KEY
);

CREATE TABLE hotels (
  hotel_id serial PRIMARY KEY,
  chain_id serial,
  hname varchar NOT NULL,
  rating int NOT NULL CHECK (rating > 0 AND rating <= 5),
  email varchar NOT NULL,
  phone_number varchar[],
  address varchar NOT NULL,
  manager_id int
);

CREATE TABLE central_office (
  office_id serial,
  chain_id serial,
  email varchar NOT NULL,
  phone_number varchar[] NOT NULL,
  address varchar NOT NULL,
  PRIMARY KEY (office_id, chain_id)
);

CREATE TABLE rooms (
  room_number int NOT NULL UNIQUE,
  hotel_id serial,
  view varchar,
  price int NOT NULL,
  capacity int NOT NULL,
  extendable boolean NOT NULL,
  amenities varchar,
  damaged boolean,
  customer_id serial,
  FOREIGN KEY (hotel_id) 
  REFERENCES hotels (hotel_id) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
  PRIMARY KEY (room_number, hotel_id)
);

CREATE TABLE person (
  SIN serial PRIMARY KEY,
  fullname varchar NOT NULL,
  gender varchar,
  phone_number varchar[],
  address varchar[]
);

CREATE TABLE customers (
  SIN serial,
  email varchar NOT NULL,
  password varchar NOT NULL,
  customer_id serial PRIMARY KEY,
  registration_date date NOT NULL
);

CREATE TABLE employees (
  SIN serial,
  email varchar NOT NULL,
  password varchar NOT NULL,
  role varchar,
  employee_id serial PRIMARY KEY,
  hotel_id serial
);

CREATE TABLE reservation (
  reservation_id serial PRIMARY KEY,
  chain_id serial,
  hotel_id serial,
  room_number int,
  customer_id serial,
  employee_id serial,
  date daterange,
  status varchar,
  active boolean
);

ALTER TABLE hotels ADD FOREIGN KEY (manager_id) REFERENCES employees (employee_id);

ALTER TABLE hotels ADD FOREIGN KEY (chain_id) REFERENCES chains (chain_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE central_office ADD FOREIGN KEY (chain_id) REFERENCES chains (chain_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE rooms ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id);

ALTER TABLE rooms ADD FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE customers ADD FOREIGN KEY (SIN) REFERENCES person (SIN) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE employees ADD FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id);

ALTER TABLE employees ADD FOREIGN KEY (SIN) REFERENCES person (SIN) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE reservation ADD FOREIGN KEY (chain_id) REFERENCES chains (chain_id) ON UPDATE CASCADE;

ALTER TABLE reservation ADD FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id) ON UPDATE CASCADE;

ALTER TABLE reservation ADD FOREIGN KEY (room_number) REFERENCES rooms (room_number) ON UPDATE CASCADE;

ALTER TABLE reservation ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON UPDATE CASCADE;

ALTER TABLE reservation ADD FOREIGN KEY (employee_id) REFERENCES employees (employee_id) ON UPDATE CASCADE;













