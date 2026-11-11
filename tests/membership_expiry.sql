-- Ejecutar únicamente después de script.sql, en la instancia de práctica.
USE CoworkingyOficinas;
DROP PROCEDURE IF EXISTS assert_membership_expiry;
DELIMITER //
CREATE PROCEDURE assert_membership_expiry()
BEGIN
    IF NOT (@actual_end_date <=> DATE('2026-01-31')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FAIL: vencimiento incorrecto';
    END IF;
END//
DELIMITER ;
START TRANSACTION;
INSERT INTO users (identification, first_name, last_name, email, age, phone)
VALUES ('audit-member-test', 'Prueba', 'Local', 'audit-membership-test@example.com', 20, '0000000');
SET @test_user = LAST_INSERT_ID();
INSERT INTO types_memberships (type_membership, duration_days, base_price) VALUES ('Prueba', 30, 10);
SET @test_type = LAST_INSERT_ID();
INSERT INTO memberships_states (name) VALUES ('Prueba');
SET @test_state = LAST_INSERT_ID();
INSERT INTO user_memberships (id_user, id_type_membership, id_membership_state, start_date, end_date)
VALUES (@test_user, @test_type, @test_state, '2026-01-01', '2026-01-01');
SET @test_membership = LAST_INSERT_ID();
SELECT end_date INTO @actual_end_date FROM user_memberships WHERE id = @test_membership;
CALL assert_membership_expiry();
ROLLBACK;
DROP PROCEDURE assert_membership_expiry;
SELECT 'PASS: vencimiento a los 30 días' AS resultado;
