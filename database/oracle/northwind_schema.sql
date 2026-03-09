-- ########################################################
-- # File: northwind_schema.sql
-- # Author: Seren
-- # Description: Northwind şemasını oluşturur.
-- # Convention: Git_Convention.md yönergelerine uygundur.
-- ########################################################

CREATE USER northwind IDENTIFIED BY northwind
  DEFAULT TABLESPACE users
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON users;

GRANT CONNECT, RESOURCE TO northwind;
ALTER USER northwind QUOTA UNLIMITED ON users;
