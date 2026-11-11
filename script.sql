-- ==========================================
-- 0. CONFIGURACIÓN INICIAL
-- ==========================================
DROP DATABASE IF EXISTS CoworkingyOficinas;
CREATE DATABASE CoworkingyOficinas;
USE CoworkingyOficinas;

-- ==========================================
-- 1. EMPRESAS Y USUARIOS
-- ==========================================
CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nit VARCHAR(20) UNIQUE,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identification VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    age INT NOT NULL,                
    phone VARCHAR(20) NOT NULL,
    register_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_blocked BOOLEAN DEFAULT FALSE,
    id_company INT,
    FOREIGN KEY (id_company) REFERENCES companies(id) ON DELETE SET NULL
);

-- ==========================================
-- 2. MEMBRESÍAS
-- ==========================================
CREATE TABLE memberships_states (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL 
);

CREATE TABLE types_memberships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_membership VARCHAR(50) NOT NULL,
    duration_days INT NOT NULL,      
    base_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE user_memberships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_type_membership INT NOT NULL,
    id_membership_state INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (id_type_membership) REFERENCES types_memberships(id),
    FOREIGN KEY (id_membership_state) REFERENCES memberships_states(id)
);

-- ==========================================
-- 3. ESPACIOS Y RESERVAS
-- ==========================================
CREATE TABLE type_workspaces (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    base_capacity INT NOT NULL,
    price_per_hour DECIMAL(10,2) NOT NULL
);

CREATE TABLE workspaces (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_type_workspace INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_type_workspace) REFERENCES type_workspaces(id)
);

CREATE TABLE status_reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(50) NOT NULL 
);

CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_workspace INT NOT NULL,
    reservation_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Pendiente',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    start_date DATETIME NOT NULL,
    id_status INT NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_workspace) REFERENCES workspaces(id),
    FOREIGN KEY (id_status) REFERENCES status_reservations(id)
);

-- ==========================================
-- 4. SERVICIOS ADICIONALES
-- ==========================================
CREATE TABLE types_additional_services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(250),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE services_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_service INT NOT NULL,
    quantity INT DEFAULT 1,
    acquisition_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_service) REFERENCES types_additional_services(id)
);

-- ==========================================
-- 5. PAGOS Y FACTURACIÓN
-- ==========================================
CREATE TABLE payment_states (
    id INT AUTO_INCREMENT PRIMARY KEY,
    state VARCHAR(50) NOT NULL
);

CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method VARCHAR(100) NOT NULL
);

CREATE TABLE invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_company INT,                
    issue_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    id_payment_state INT NOT NULL,
    expiration_date DATE NOT NULL,   
    cancellation_reason VARCHAR(100),
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_company) REFERENCES companies(id),
    FOREIGN KEY (id_payment_state) REFERENCES payment_states(id)
);

CREATE TABLE invoice_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_invoice INT NOT NULL,
    concept_type VARCHAR(50) NOT NULL, 
    id_concept INT NOT NULL,
    description VARCHAR(200) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_invoice) REFERENCES invoices(id) ON DELETE CASCADE
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_invoice INT NOT NULL,
    id_payment_method INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    reference_number VARCHAR(100),
    FOREIGN KEY (id_invoice) REFERENCES invoices(id),
    FOREIGN KEY (id_payment_method) REFERENCES payment_methods(id)
);

CREATE TABLE refunds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_reservation INT NOT NULL,
    id_payment INT NULL,
    amount DECIMAL(10,2) NOT NULL,
    refund_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(250),
    FOREIGN KEY (id_reservation) REFERENCES reservations(id),
    FOREIGN KEY (id_payment) REFERENCES payments(id)
);

CREATE TABLE late_fees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_invoice INT NOT NULL,
    surcharge DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_invoice) REFERENCES invoices(id)
);

-- ==========================================
-- 6. CONTROL DE ACCESOS
-- ==========================================
CREATE TABLE type_credentials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL 
);

CREATE TABLE credentials_access (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_type_credential INT NOT NULL,
    code VARCHAR(150) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_type_credential) REFERENCES type_credentials(id)
);

CREATE TABLE access_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_credential INT NOT NULL,
    access_type ENUM('ENTRY', 'EXIT') NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,    
    access_time DATETIME DEFAULT CURRENT_TIMESTAMP,  
    observations VARCHAR(250),
    FOREIGN KEY (id_user) REFERENCES users(id),
    FOREIGN KEY (id_credential) REFERENCES credentials_access(id)
);

-- ==========================================
-- 7. LOGS, NOTIFICACIONES Y REPORTES
-- ==========================================
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT,
    action_type VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    description VARCHAR(250),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT,
    title VARCHAR(100) NOT NULL,
    message VARCHAR(250) NOT NULL,
    notification_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendiente','Enviada','Leida') DEFAULT 'Pendiente',
    FOREIGN KEY (id_user) REFERENCES users(id)
);

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(250)
);


-- Calcula el vencimiento antes de guardar la fila, sin actualizar la misma tabla.
-- Se conserva la regla del ejercicio: 30 días desde la fecha inicial.
CREATE TRIGGER trg_membership_end_date_calculate
BEFORE INSERT ON user_memberships
FOR EACH ROW
SET NEW.end_date = DATE_ADD(NEW.start_date, INTERVAL 30 DAY);
