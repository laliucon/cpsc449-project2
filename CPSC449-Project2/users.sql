PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    username VARCHAR NOT NULL PRIMARY KEY,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    UNIQUE(id, username, email)
);

DROP TABLE IF EXISTS followers; 
CREATE TABLE followers (
    username VARCHAR NOT NULL PRIMARY KEY,
    userToFollow VARCHAR NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username),
    FOREIGN KEY (userToFollow) REFERENCES users(username)
);

INSERT INTO users(username, email, password) VALUES('hung','hungcun1996@gmail.com','12345678');
INSERT INTO users(username, email, password) VALUES('hungcun','laliucon2@gmail.com','cunhung');
INSERT INTO users(username, email, password) VALUES('cun','cunhung1996@gmail.com','abcdefgh');
INSERT INTO followers(username, userToFollow) VALUES ('hung','hungcun');
INSERT INTO followers(username, userToFollow) VALUES ('hung','cun');
INSERT INTO followers(username, userToFollow) VALUES ('hungcun','hung');
INSERT INTO followers(username, userToFollow) VALUES ('hungcun','cun');
INSERT INTO followers(username, userToFollow) VALUES ('cun','hungcun');
COMMIT;