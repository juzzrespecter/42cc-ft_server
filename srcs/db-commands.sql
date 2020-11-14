CREATE DATABASE wp_database;
GRANT ALL ON wp_database.* TO 'wp_user'@'localhost' IDENTIFIED BY 'wp_passwd';
GRANT ALL ON phpmyadmin.* TO 'pma_test'@'localhost' IDENTIFIED BY 'pmapass_test';
FLUSH PRIVILEGES;
