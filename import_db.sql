PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);


CREATE TABLE replies ( 
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,

    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    replier_id INTEGER NOT NULL,


    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES user(id),
    FOREIGN KEY (replier_id) REFERENCES user(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    likes INTEGER NOT NULL,

    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('first1', 'last1'),
    ('first2', 'last2'),
    ('first3', 'last3'),
    ('first4', 'last4');
