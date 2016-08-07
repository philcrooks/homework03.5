DROP TABLE fixtures;
DROP TABLE teams;
DROP TABLE referees;
DROP TABLE grounds;
DROP TABLE countries;

CREATE TABLE countries (
  id serial4 primary key,
  name varchar(255)
);

CREATE TABLE teams (
  id serial4 primary key,
  name varchar(255),
  city varchar(255),
  country_id int4 references countries(id)
);

CREATE TABLE referees (
  id serial4 primary key,
  name varchar(255),
  country_id int4 references countries(id)
);

CREATE TABLE grounds (
  id serial4 primary key,
  name varchar(255),
  city varchar(255),
  country_id int4 references countries(id),
  capacity int4
);

CREATE TABLE fixtures (
  id serial4 primary key,
  home_team_id int4 references teams(id),
  away_team_id int4 references teams(id),
  referee_id int4 references referees(id),
  ground_id int4 references grounds(id),
  round_no int2,
  home_score int2,
  away_score int2,
  home_try_count int2,
  away_try_count int2,
  attendance int4
);