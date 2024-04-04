ALTER DATABASE postgres SET timezone TO 'Asia/Tashkent';
CREATE EXTENSION PGCRYPTO;

CREATE TYPE STATUS AS ENUM ('ACTIVE','INACTIVE');
CREATE TYPE PRODUCT_KINDS AS ENUM ('CATEGORY','TYPE','COUNTRY','MARKING','SIDE');

CREATE FUNCTION HASH_MAKE(password VARCHAR, len INT DEFAULT 6) RETURNS VARCHAR(60) AS
$F$
BEGIN
    IF LENGTH(TRIM(PASSWORD)) = 0 OR LENGTH(TRIM(PASSWORD)) < len THEN
        RAISE EXCEPTION 'password cannot be empty or length cannot be less than %', len;
    END IF;

    RETURN CRYPT(PASSWORD, GEN_SALT('BF'));
END
$F$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE FUNCTION HASH_CHECK(HASH VARCHAR, PASSWORD VARCHAR) RETURNS BOOLEAN AS
$F$
BEGIN
    RETURN HASH = CRYPT(PASSWORD, HASH);
END
$F$ LANGUAGE PLPGSQL IMMUTABLE;