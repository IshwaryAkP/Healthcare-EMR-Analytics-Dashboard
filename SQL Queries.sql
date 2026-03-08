use healthcare;
select * from doctor;
select * from labtest;
select * from treatment;
select * from visit;
select * from patient;
describe patient;
ALTER TABLE patient 
CHANGE `ï»¿Patient_ID` Patient_ID INT;
SHOW COLUMNS FROM visit;
ALTER TABLE patient 
CHANGE `ï»¿Patient _ID` Patient_ID INT;
ALTER TABLE visit CHANGE `Visit ID` Visit_ID TEXT;
ALTER TABLE visit CHANGE `Patient ID` Patient_ID TEXT;
ALTER TABLE visit CHANGE `Doctor ID` Doctor_ID TEXT;
ALTER TABLE visit CHANGE `Visit Date` Visit_Date DATETIME;
ALTER TABLE visit CHANGE `Follow Up Required` Follow_Up_Required TEXT;
ALTER TABLE treatment CHANGE `Treatment ID` Treatment_ID TEXT;
ALTER TABLE treatment CHANGE `Visit ID` Visit_ID TEXT;
ALTER TABLE treatment CHANGE `Medication Prescribed` Medication_Prescribed TEXT;
ALTER TABLE treatment CHANGE `Treatment Cost` Treatment_Cost DOUBLE;
ALTER TABLE labtest CHANGE `Lab Result ID` Lab_Result_ID TEXT;
ALTER TABLE labtest CHANGE `Visit ID` Visit_ID TEXT;
ALTER TABLE labtest CHANGE `Test Name` Test_Name TEXT;
ALTER TABLE labtest CHANGE `Test Date` Test_Date TEXT;
ALTER TABLE doctor CHANGE `Doctor ID` Doctor_ID INT;
ALTER TABLE doctor CHANGE `Doctor Name` Doctor_Name TEXT;
ALTER TABLE doctor CHANGE `Phone Number` Phone_Number TEXT;
ALTER TABLE doctor CHANGE `Years Of Experience` Years_Of_Experience INT;
ALTER TABLE doctor CHANGE `Hospital Affiliation` Hospital_Affiliation TEXT;
SHOW COLUMNS FROM visit;
USE healthcare;
SHOW COLUMNS FROM patient;
USE healthcare;
USE healthcare;

SELECT 
    CONCAT(p.`First _Name`, ' ', p.Last_Name) AS Patient_Name,
    d.`Doctor Name`,
    v.`Visit Date`,
    v.Diagnosis,
    t.`Medication Prescribed`,
    l.`Test Name`,
    l.`Test Result`
FROM patient p
JOIN visit v 
    ON p.Patient_ID = v.`Patient ID`
JOIN doctor d
    ON v.`Doctor ID` = d.Doctor_ID
LEFT JOIN treatment t 
    ON v.Visit_ID = t.`Visit ID`
LEFT JOIN labtest l 
    ON v.Visit_ID = l.`Visit ID`;

use healthcare;

-- Total Patients

SELECT COUNT(*) AS Total_Patients
FROM patient;
SELECT COUNT(DISTINCT Patient_ID) AS Total_Patients
FROM patient;

-- Total Doctors

SELECT COUNT(DISTINCT Doctor_ID) AS Total_Doctors
FROM doctor;

-- total Visits

SELECT COUNT(*) AS Total_Visits
FROM visit;
SELECT COUNT(DISTINCT Visit_ID) AS Total_Visits
FROM visit;

-- Average Age of Patients

SELECT ROUND(AVG(Age), 2) AS Average_Age
FROM patient;

-- Top 5 Diagnosed Conditions

SELECT 
    Diagnosis,
    COUNT(*) AS Total_Cases
FROM visit
WHERE Diagnosis IS NOT NULL
GROUP BY Diagnosis
ORDER BY Total_Cases DESC
LIMIT 5;

-- Follow-Up Rate

SELECT 
ROUND(
SUM(CASE WHEN Follow_Up_Required = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),2)
    AS Follow_Up_Rate_Percentage
FROM visit;

-- Treatment cost per visit

SELECT 
    ROUND(AVG(Visit_Total), 2) AS Avg_Treatment_Cost_Per_Visit
FROM (
    SELECT 
        v.Visit_ID,
        COALESCE(SUM(t.Treatment_Cost), 0) AS Visit_Total
    FROM visit v
    LEFT JOIN treatment t 
        ON v.Visit_ID = t.`Visit ID`
    GROUP BY v.Visit_ID
) AS Visit_Costs;

-- Total lab test conducted 

SELECT COUNT(*) AS Total_Lab_Tests
FROM labtest;

-- Percentage of Abnormal Lab Results

SELECT 
    ROUND(
        SUM(CASE WHEN `Test Result` = 'Abnormal' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
    2) AS Abnormal_Lab_Result_Percentage
FROM labtest;

-- Doctor Workload (Avg. Patients Per Doctor)

SELECT 
    ROUND(
        (SELECT COUNT(*) FROM visit) * 1.0 
        / (SELECT COUNT(*) FROM doctor),
    2) AS Avg_Patients_Per_Doctor;
    

