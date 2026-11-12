GRANT SELECT, INSERT, UPDATE, DELETE
ON saha_communautaires.*
TO 'saha_app'@'localhost';

FLUSH PRIVILEGES;
SHOW GRANTS FOR 'saha_app'@'localhost';

ALTER USER 'saha_app'@'localhost'
IDENTIFIED BY 'Aigle2267@';

