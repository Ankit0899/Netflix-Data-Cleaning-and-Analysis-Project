CREATE TABLE netflix (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(10),              -- Movie or TV Show
    title VARCHAR(255),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(100),
    date_added DATE,
    release_year INT,
    rating VARCHAR(10),           -- e.g., PG-13, TV-MA, etc.
    duration VARCHAR(20),         -- e.g., "90 min" or "1 Season"
    listed_in TEXT,               -- Genres/categories
    description TEXT
);
