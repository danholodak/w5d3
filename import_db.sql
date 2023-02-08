PRAGMA foreign_keys = ON;

-- write create table statements
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;




CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)

);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)

);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)

);

--seed tables with INSERT statements

INSERT INTO 
    users (fname, lname)
VALUES
    ('Spongebob', 'Squarepants'),
    ('Squidward', 'Tentacles'),
    ('Sandy', 'Cheeks'),
    ('Patrick', 'Star'),
    ('Eugene', 'Krabs'),
    ('Sheldon', 'Plankton'),
    ('Random', 'Fish');

INSERT INTO
    questions(title, body, author_id)
VALUES
    ('first question', 'How does one catch a jellyfish?', (SELECT id from users WHERE fname = 'Spongebob')),
    ('just curious', 'What is the secret Krabby Patty Secret Formula?', (SELECT id from users WHERE fname = 'Sheldon')),
    ('phonecall', 'Is this the Krusty Krab?', (SELECT id from users WHERE fname = 'Random')),
    ('Hobbies', 'What is the best hobby?', (SELECT id from users WHERE fname = 'Random')),
    ('bubbles', 'How do I blow bubbles?', (SELECT id from users WHERE fname = 'Squidward'));

INSERT INTO
    question_follows(follower_id, question_id)
VALUES
    ((SELECT id from users WHERE fname = 'Random'), (SELECT id from questions WHERE title = 'first question')),
    ((SELECT id from users WHERE fname = 'Squidward'), (SELECT id from questions WHERE title = 'just curious')),
    ((SELECT id from users WHERE fname = 'Spongebob'), (SELECT id from questions WHERE title = 'phonecall')),
    ((SELECT id from users WHERE fname = 'Sandy'), (SELECT id from questions WHERE title = 'Hobbies')),
    ((SELECT id from users WHERE fname = 'Random'), (SELECT id from questions WHERE title = 'bubbles'));

INSERT INTO
    question_likes(question_id, user_id)
VALUES
    ((SELECT id from questions WHERE title = 'first question'), (SELECT id from users WHERE fname = 'Sandy')),
    ((SELECT id from questions WHERE title = 'just curious'), (SELECT id from users WHERE fname = 'Squidward')),
    ((SELECT id from questions WHERE title = 'phonecall'), (SELECT id from users WHERE fname = 'Squidward')),
    ((SELECT id from questions WHERE title = 'Hobbies'), (SELECT id from users WHERE fname = 'Patrick')),
    ((SELECT id from questions WHERE title = 'bubbles'), (SELECT id from users WHERE fname = 'Sandy')),
    ((SELECT id from questions WHERE title = 'bubbles'), (SELECT id from users WHERE fname = 'Eugene'));

INSERT INTO
    replies(question_id, author_id, body)
VALUES
    ((SELECT id from questions WHERE title = 'first question'), (SELECT id from users WHERE fname = 'Patrick'), 'Firmly grasp it in your hand'),
    ((SELECT id from questions WHERE title = 'just curious'), (SELECT id from users WHERE fname = 'Eugene'), 'Ye aint gettin me Krabby Patty Formular!!!'),
    ((SELECT id from questions WHERE title = 'phonecall'), (SELECT id from users WHERE fname = 'Patrick'), 'No! This is Patrick!!'),
    ((SELECT id from questions WHERE title = 'Hobbies'), (SELECT id from users WHERE fname = 'Sandy'), 'Karate!'),
    ((SELECT id from questions WHERE title = 'Hobbies'), (SELECT id from users WHERE fname = 'Squidward'), 'Clarinet'),
    ((SELECT id from questions WHERE title = 'bubbles'), (SELECT id from users WHERE fname = 'Spongebob'), 'Technique, Squidward!');
    

INSERT INTO
    replies(question_id, parent_reply, author_id, body)
VALUES
    ((SELECT id from questions WHERE title = 'first question'), (SELECT id from replies WHERE BODY LIKE 'Firmly%'), (SELECT id from users WHERE fname = 'Squidward'), 'AAAHHH!'),
    ((SELECT id from questions WHERE title = 'Hobbies'), (SELECT id from replies WHERE BODY LIKE 'Karat%'), (SELECT id from users WHERE fname = 'Spongebob'), 'Kay Rah Tay!'),
    ((SELECT id from questions WHERE title = 'bubbles'), (SELECT id from replies WHERE BODY LIKE 'Technique%'), (SELECT id from users WHERE fname = 'Patrick'), 'TECHNIIIQUE!');

