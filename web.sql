CREATE TABLE postdetail (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date DATE,
    image VARCHAR(255),
    content TEXT,
    rate NUMERIC(3, 2)
);
CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    date DATE,
    idpost INT,
    FOREIGN KEY (idpost) REFERENCES postdetail(id) ON DELETE CASCADE
);
