PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    username VARCHAR NOT NULL PRIMARY KEY,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    unique (username, email)
);

DROP TABLE IF EXISTS followers; 
CREATE TABLE followers (
    username INTEGER NOT NULL PRIMARY KEY,
    userToFollow INTEGER NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username),
    FOREIGN KEY (userToFollow) REFERENCES users(username)
);


DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
    username VARCHAR NOT NULL PRIMARY KEY,
    text VARCHAR NOT NULL,
    timestamp DATETIME,
    FOREIGN KEY (username) REFERENCES users(username)
);

INSERT INTO users(username, email, password) VALUES('hung','hungcun1996@gmail.com','12345678');
INSERT INTO users(username, email, password) VALUES('hungcun','laliucon2@gmail.com','cunhung');
INSERT INTO users(username, email, password) VALUES('cun','cunhung1996@gmail.com','abcdefgh');
INSERT INTO followers(username, userToFollow) VALUES ('hung','hungcun');
INSERT INTO followers(username, userToFollow) VALUES ('hung','cun');
INSERT INTO followers(username, userToFollow) VALUES ('hungcun','hung');
INSERT INTO followers(username, userToFollow) VALUES ('hungcun','cun');
INSERT INTO followers(username, userToFollow) VALUES ('cun','hungcun');
INSERT INTO posts(username, text, timestamp) VALUES('hung', 'what a day','2021-03-05 14:14:14.141')
INSERT INTO posts(username, text, timestamp) VALUES('cun', 'example text','2021-03-05 11:16:10.00')
INSERT INTO posts(username, text, timestamp) VALUES('hungcun', 'example text from hungcun','2021-03-05 1:14:14.1')
INSERT INTO posts(username, text, timestamp) VALUES('hungcun', 'another text','2021-03-05 8:5:8.141')
INSERT INTO posts(username, text, timestamp) VALUES('cun', 'abcd','2021-03-05 15:15:12.12')