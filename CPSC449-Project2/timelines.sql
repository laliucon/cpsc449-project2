PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    unique (username, email)
);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    text VARCHAR NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users(id,username, email, password) VALUES(1,'hung','hungcun1996@gmail.com','12345678');
INSERT INTO users(id,username, email, password) VALUES(2,'hungcun','laliucon2@gmail.com','cunhung');
INSERT INTO users(id,username, email, password) VALUES(3,'cun','cunhung1996@gmail.com','abcdefgh');
INSERT INTO posts(user_id, text) VALUES(1, 'It is a beautiful day');
INSERT INTO posts(user_id, text) VALUES(1, 'cannot wait to see my grade');
COMMIT;