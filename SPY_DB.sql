-- Creating Database
/*
CREATE DATABASE "SPY";
*/

-- I switched to the "SPY" database using the pgAdmin 4 interface

CREATE TABLE underlying (
	date DATE PRIMARY KEY,
	high DECIMAL(6,2) NOT NULL,
	low DECIMAL(6,2) NOT NULL,
	open DECIMAL(6,2) NOT NULL,
	close DECIMAL(6,2) NOT NULL,
	volume INT NOT NULL
);


CREATE TABLE options (
    date DATE,
    strike SMALLINT,
    option CHAR(1),
    expiration DATE,
    high DECIMAL(4,2) NOT NULL,
    low DECIMAL(4,2) NOT NULL,
    open DECIMAL(4,2) NOT NULL,
    close DECIMAL(4,2) NOT NULL,
    volume INT NOT NULL,
    PRIMARY KEY(date, strike, option, expiration),
    CONSTRAINT option_constraint CHECK (option IN ('C', 'P')),
    FOREIGN KEY (date) REFERENCES underlying(date)
);


