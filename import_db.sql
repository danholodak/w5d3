PRAGMA foreign_keys = ON;

-- write create table statements

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id FOREIGN KEY

);

CREATE TABLE question_follows(

);

CREATE TABLE replies(

);

CREATE TABLE question_likes(

);

--seed tables with INSERT statements