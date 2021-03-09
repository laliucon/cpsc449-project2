PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    unique (id, username, email)
);

DROP TABLE IF EXISTS followers; 
CREATE TABLE followers (
    id INTEGER PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (following_id) REFERENCES users(id),
    UNIQUE (follower_id, following_id)
);

INSERT INTO users(id, username, email, password) VALUES(1,'hung','hungcun1996@gmail.com','12345678');
INSERT INTO users(id, username, email, password) VALUES(2,'hungcun','laliucon2@gmail.com','cunhung');
INSERT INTO users(id, username, email, password) VALUES(3,'cun','cunhung1996@gmail.com','abcdefgh');
INSERT INTO followers(follower_id, following_id) VALUES (1,2);
INSERT INTO followers(follower_id, following_id) VALUES (1,3);
INSERT INTO followers(follower_id, following_id) VALUES (2,1);
INSERT INTO followers(follower_id, following_id) VALUES (2,3);
INSERT INTO follwoers(follower_id, following_id) VALUES (3,2);
COMMIT;