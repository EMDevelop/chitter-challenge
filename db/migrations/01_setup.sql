
CREATE DATABASE chitter;
CREATE DATABASE chitter_test;

-- for both Chitter and chitter_test run
CREATE TABLE  users (
  ID BIGSERIAL NOT NULL PRIMARY KEY,
  user_name varchar(60),
  email varchar(100),
  password varchar(60)
);

CREATE TABLE  message (
  ID BIGSERIAL NOT NULL PRIMARY KEY,
  ID_USERS INT NOT NULL REFERENCES users(ID),
  message VARCHAR(200),
  createdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


