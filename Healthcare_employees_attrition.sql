-- Demographics Table
-- Explore data from demographics table
SELECT * FROM healthcareemployees.demographics;

-- Find any NULL values by cyling through columns 1 to 8
SELECT * FROM healthcareemployees.demographics ORDER BY 8;

-- Find out the maximum and minimum age amongst the employees
SELECT MAX(Age) AS max_age, MIN(Age) AS min_age FROM healthcareemployees.demographics;

-- Find out the average age amongest the employees
SELECT AVG(Age) AS mean_age FROM healthcareemployees.demographics;

-- Count the number of employees' gender
SELECT Gender, COUNT(Gender) as count_gender From healthcareemployees.demographics Group By Gender;

-- Count the number of employees' marital status
SELECT MaritalStatus, COUNT(MaritalStatus) AS count_maritalstatus FROM healthcareemployees.demographics GROUP BY MaritalStatus;

-- Work Information Table
-- Explore data from workinfo table
SELECT * FROM healthcareemployees.workinfo;

-- Find any NULL values by cyling through columns 1 to 28
SELECT * FROM healthcareemployees.workinfo ORDER BY 28;

-- Count the number of employees' attrition
SELECT Attrition, COUNT(Attrition) AS count_attrition FROM healthcareemployees.workinfo GROUP BY Attrition;

-- Count the number of attrition by job role
SELECT JobRole, Attrition, COUNT(Attrition) From healthcareemployees.workinfo Where Attrition = 'Yes' Group by JobRole, Attrition;

-- Calculate the percentage of job roles among attrition
SELECT 
    JobRole,
    Attrition,
    COUNT(JobRole) AS count_job,
    (COUNT(JobRole) * 100 / (SELECT COUNT(JobRole) FROM healthcareemployees.workinfo)) AS percentage
FROM
    healthcareemployees.workinfo
GROUP BY JobRole , Attrition
ORDER BY 2 DESC;

-- Join two tables
SELECT 
    *
FROM
    healthcareemployees.demographics demo
        JOIN
    healthcareemployees.workinfo info ON demo.EmployeeID = info.EmployeeID;

-- Select EmployeeID, Age, Gender, Attrition, Job Role from combined table
SELECT 
    demo.EmployeeID,
    demo.Age,
    demo.Gender,
    info.Attrition,
    info.JobRole
FROM
    healthcareemployees.demographics demo
        JOIN
    healthcareemployees.workinfo info ON demo.EmployeeID = info.EmployeeID;

-- Select EmployeeID, Age, Gender, Attrition, Job Role, Monthly earned from combined table
SELECT 
    demo.EmployeeID,
    demo.Age,
    demo.Gender,
    info.Attrition,
    info.JobRole,
    info.HourlyRate * info.StandardHours AS Monthly_earned
FROM
    healthcareemployees.demographics demo
        JOIN
    healthcareemployees.workinfo info ON demo.EmployeeID = info.EmployeeID;

-- Create Common Table Expressions (CTE) --> The objective is to check if the employees receive their income according to the hours of work that they put into 
WITH Monthearned (EmployeeID, Age, Gender, Attrition, JobRole, IncomeVsEarned) 
AS (SELECT 
    demo.EmployeeID,
    demo.Age,
    demo.Gender,
    info.Attrition,
    info.JobRole,
    MonthlyIncome/(info.HourlyRate * info.StandardHours) AS incomevsearned
FROM
    healthcareemployees.demographics demo
        JOIN
    healthcareemployees.workinfo info ON demo.EmployeeID = info.EmployeeID)
SELECT *, incomevsearned*100 as percentage FROM Monthearned ORDER BY 7;

-- An alternative to CTE is to create a temp table --> Same objective as above
USE healthcareemployees;

DROP Table if exists percentmonthearned;
CREATE TABLE percentmonthearned
(EmployeeID NUMERIC, 
Age NUMERIC, 
Gender VARCHAR(20), 
Attrition VARCHAR(20), 
JobRole VARCHAR(20), 
IncomeVsEarned NUMERIC);

INSERT INTO percentmonthearned (
EmployeeID, 
Age, 
Gender, 
Attrition, 
JobRole, 
IncomeVsEarned)

SELECT 
    demo.EmployeeID,
    demo.Age,
    demo.Gender,
    info.Attrition,
    info.JobRole,
    MonthlyIncome/(info.HourlyRate * info.StandardHours) AS incomevsearned
FROM
    healthcareemployees.demographics demo
        JOIN
    healthcareemployees.workinfo info ON demo.EmployeeID = info.EmployeeID;
    
SELECT *, incomevsearned*100 as percentage FROM percentmonthearned ORDER BY 7;

-- Create View
CREATE VIEW joined_tables AS
SELECT 
    demo.EmployeeID,
    demo.Age,
    demo.Gender,
    info.Attrition,
    info.JobRole,
    info.HourlyRate * info.StandardHours AS Monthly_earned
FROM
    healthcareemployees.demographics demo
        JOIN
    healthcareemployees.workinfo info ON demo.EmployeeID = info.EmployeeID;