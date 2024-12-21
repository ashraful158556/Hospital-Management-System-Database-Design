CREATE TABLE IF NOT EXISTS `Patients` (
    `PatientID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `Name` VARCHAR(255) NOT NULL,
    `Age` INT NOT NULL,
    `Gender` VARCHAR(10) NOT NULL,
    `Address` VARCHAR(255),
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100),
    `EmergencyContact` VARCHAR(20),
    `MedicalHistory` TEXT,
    PRIMARY KEY (`PatientID`)
);

CREATE TABLE IF NOT EXISTS `Departments` (
    `DepartmentID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `DepartmentName` VARCHAR(255) NOT NULL,
    `Description` TEXT,
    `Location` VARCHAR(255),
    PRIMARY KEY (`DepartmentID`)
);

CREATE TABLE IF NOT EXISTS `Doctors` (
    `DoctorID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `Name` VARCHAR(255) NOT NULL,
    `Specialty` VARCHAR(255) NOT NULL,
    `DepartmentID` INT,
    `Phone` VARCHAR(20),
    `Email` VARCHAR(100),
    `Availability` VARCHAR(100),
    PRIMARY KEY (`DoctorID`),
    FOREIGN KEY (`DepartmentID`) REFERENCES `Departments`(`DepartmentID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Appointments` (
    `AppointmentID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `PatientID` INT NOT NULL,
    `DoctorID` INT NOT NULL,
    `Date` DATE NOT NULL,
    `Time` TIME NOT NULL,
    `Status` VARCHAR(50),
    `Notes` TEXT,
    PRIMARY KEY (`AppointmentID`),
    FOREIGN KEY (`PatientID`) REFERENCES `Patients`(`PatientID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`DoctorID`) REFERENCES `Doctors`(`DoctorID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `MedicalRecords` (
    `RecordID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `PatientID` INT NOT NULL,
    `AppointmentID` INT,
    `RecordDate` DATE NOT NULL,
    `Diagnosis` TEXT,
    `Treatment` TEXT,
    `Prescription` TEXT,
    PRIMARY KEY (`RecordID`),
    FOREIGN KEY (`PatientID`) REFERENCES `Patients`(`PatientID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`AppointmentID`) REFERENCES `Appointments`(`AppointmentID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Billing` (
    `BillID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `PatientID` INT NOT NULL,
    `AppointmentID` INT,
    `Amount` DECIMAL(10, 2) NOT NULL,
    `PaymentDate` DATE NOT NULL,
    `PaymentMethod` VARCHAR(50),
    `Status` VARCHAR(50),
    PRIMARY KEY (`BillID`),
    FOREIGN KEY (`PatientID`) REFERENCES `Patients`(`PatientID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`AppointmentID`) REFERENCES `Appointments`(`AppointmentID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Staff` (
    `StaffID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `Name` VARCHAR(255) NOT NULL,
    `Role` VARCHAR(255) NOT NULL,
    `Phone` VARCHAR(20),
    `Email` VARCHAR(100),
    `Address` VARCHAR(255),
    `DepartmentID` INT,
    PRIMARY KEY (`StaffID`),
    FOREIGN KEY (`DepartmentID`) REFERENCES `Departments`(`DepartmentID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Rooms` (
    `RoomID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `RoomNumber` VARCHAR(50) NOT NULL,
    `RoomType` VARCHAR(50),
    `Status` VARCHAR(50),
    `AssignedPatientID` INT,
    PRIMARY KEY (`RoomID`),
    FOREIGN KEY (`AssignedPatientID`) REFERENCES `Patients`(`PatientID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Inventory` (
    `ItemID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `ItemName` VARCHAR(255) NOT NULL,
    `Quantity` INT NOT NULL,
    `Category` VARCHAR(255),
    `LastUpdated` DATE NOT NULL,
    PRIMARY KEY (`ItemID`)
);

CREATE TABLE IF NOT EXISTS `LabTests` (
    `TestID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `PatientID` INT NOT NULL,
    `AppointmentID` INT,
    `TestName` VARCHAR(255) NOT NULL,
    `TestDate` DATE NOT NULL,
    `Results` TEXT,
    PRIMARY KEY (`TestID`),
    FOREIGN KEY (`PatientID`) REFERENCES `Patients`(`PatientID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`AppointmentID`) REFERENCES `Appointments`(`AppointmentID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Feedback` (
    `FeedbackID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `PatientID` INT NOT NULL,
    `DoctorID` INT,
    `FeedbackDate` DATE NOT NULL,
    `Comments` TEXT,
    `Rating` INT,
    PRIMARY KEY (`FeedbackID`),
    FOREIGN KEY (`PatientID`) REFERENCES `Patients`(`PatientID`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`DoctorID`) REFERENCES `Doctors`(`DoctorID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `UserAccounts` (
    `UserID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `Username` VARCHAR(100) NOT NULL UNIQUE,
    `PasswordHash` VARCHAR(255) NOT NULL,
    `Role` VARCHAR(50),
    `StaffID` INT,
    PRIMARY KEY (`UserID`),
    FOREIGN KEY (`StaffID`) REFERENCES `Staff`(`StaffID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `AccessControl` (
    `RoleID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `RoleName` VARCHAR(50) NOT NULL,
    `Permissions` TEXT,
    PRIMARY KEY (`RoleID`)
);

CREATE TABLE IF NOT EXISTS `AuditLogs` (
    `LogID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `UserID` INT,
    `Action` VARCHAR(255) NOT NULL,
    `Timestamp` DATETIME NOT NULL,
    PRIMARY KEY (`LogID`),
    FOREIGN KEY (`UserID`) REFERENCES `UserAccounts`(`UserID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Reporting` (
    `ReportID` INT AUTO_INCREMENT NOT NULL UNIQUE,
    `ReportName` VARCHAR(255) NOT NULL,
    `GeneratedBy` INT,
    `GeneratedDate` DATE NOT NULL,
    `DataSummary` TEXT,
    PRIMARY KEY (`ReportID`),
    FOREIGN KEY (`GeneratedBy`) REFERENCES `UserAccounts`(`UserID`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
