DROP TABLE IF EXISTS `Userss`;
CREATE TABLE Userss (
  name VARCHAR(20)   PRIMARY KEY ,
    password   VARCHAR(10) NOT NULL,
    age  int  DEFAULT  0
);