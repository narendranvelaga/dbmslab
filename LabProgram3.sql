/* Consider the schema for Company Database:
EMPLOYEE(SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
DEPARTMENT(DNo, DName, MgrSSN, MgrStartDate)
DLOCATION(DNo,DLoc)
PROJECT(PNo, PName, PLocation, DNo)
WORKS_ON(SSN, PNo, Hours) */

CREATE TABLE DEPARTMENT (
    DNo INT PRIMARY KEY,
    DName VARCHAR(50),
    MgrSSN CHAR(9),
    MgrStartDate DATE
);

CREATE TABLE EMPLOYEE (
    SSN CHAR(9) PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10 , 2 ),
    SuperSSN CHAR(9),
    DNo INT,
    FOREIGN KEY (SuperSSN)
        REFERENCES EMPLOYEE (SSN),
    FOREIGN KEY (DNo)
        REFERENCES DEPARTMENT (DNo)
);

CREATE TABLE DLOCATION (
    DNo INT,
    DLoc VARCHAR(50),
    PRIMARY KEY (DNo , DLoc),
    FOREIGN KEY (DNo)
        REFERENCES DEPARTMENT (DNo)
);

CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY,
    PName VARCHAR(50),
    PLocation VARCHAR(50),
    DNo INT,
    FOREIGN KEY (DNo)
        REFERENCES DEPARTMENT (DNo)
);

CREATE TABLE WORKS_ON (
    SSN CHAR(9),
    PNo INT,
    Hours DECIMAL(5 , 2 ),
    PRIMARY KEY (SSN , PNo),
    FOREIGN KEY (SSN)
        REFERENCES EMPLOYEE (SSN),
    FOREIGN KEY (PNo)
        REFERENCES PROJECT (PNo)
);





INSERT INTO DEPARTMENT VALUES (1, 'HR', '123456789', '2020-01-01'); 
INSERT INTO DEPARTMENT VALUES (2, 'Engineering', '987654321', '2019-03-15'); 
INSERT INTO DEPARTMENT VALUES (3, 'Marketing', '456789123', '2021-06-10'); 
INSERT INTO DEPARTMENT VALUES (4, 'Sales', '789123456', '2018-11-23'); 
INSERT INTO DEPARTMENT VALUES (5, 'Accounts', '321654987', '2017-08-01');


INSERT INTO EMPLOYEE VALUES ('123456789', 'John Doe', '123 Elm St', 'M', 50000, NULL, 1);
INSERT INTO EMPLOYEE VALUES ('987654321', 'Jane Smith', '456 Oak St', 'F', 60000, '123456789', 2);
INSERT INTO EMPLOYEE VALUES ('456789123', 'Robert Hegde', '789 Pine St', 'M', 55000, '987654321', 3);
INSERT INTO EMPLOYEE VALUES ('789123456', 'Maria Johnson', '101 Maple St', 'F', 45000, '456789123', 4);
INSERT INTO EMPLOYEE VALUES ('321654987', 'Michael Hegde', '202 Birch St', 'M', 70000, '789123456', 5);

INSERT INTO DLOCATION VALUES (1, 'New York'); 
INSERT INTO DLOCATION VALUES (2, 'San Francisco'); 
INSERT INTO DLOCATION VALUES (3, 'Los Angeles');
INSERT INTO DLOCATION VALUES (4, 'Chicago'); 
INSERT INTO DLOCATION VALUES (5, 'Houston');

INSERT INTO PROJECT VALUES (101, 'Project A', 'New York', 1); 
INSERT INTO PROJECT VALUES (102, 'Project B', 'San Francisco', 2); 
INSERT INTO PROJECT VALUES (103, 'AI', 'Los Angeles', 3); 
INSERT INTO PROJECT VALUES (104, 'Project D', 'Chicago', 4); 
INSERT INTO PROJECT VALUES (105, 'Project E', 'Houston', 5);

INSERT INTO WORKS_ON VALUES ('123456789', 101, 20); 
INSERT INTO WORKS_ON VALUES ('987654321', 102, 25); 
INSERT INTO WORKS_ON VALUES ('456789123', 103, 30); 
INSERT INTO WORKS_ON VALUES ('789123456', 104, 35); 
INSERT INTO WORKS_ON VALUES ('321654987', 105, 40); 
INSERT INTO WORKS_ON VALUES ('123456789', 103, 15); 
INSERT INTO WORKS_ON VALUES ('456789123', 105, 10);





/* 1) Make a list of all project numbers for projects that involve an employee whose last name is ‘Hegde’, 
either as a worker or as a manager of the department that controls the project. */
SELECT DISTINCT
    P.PNo
FROM
    PROJECT P
        LEFT JOIN
    WORKS_ON W ON P.PNo = W.PNo
        LEFT JOIN
    EMPLOYEE E1 ON W.SSN = E1.SSN
        LEFT JOIN
    DEPARTMENT D ON P.DNo = D.DNo
        LEFT JOIN
    EMPLOYEE E2 ON D.MgrSSN = E2.SSN
WHERE
    E1.Name LIKE '%Hegde%'
        OR E2.Name LIKE '%Hegde%';


/* 2) Show the resulting salaries if every employee working on the ‘AI’ project is given a 10 percent raise. */
SELECT 
    E.SSN, E.Name, E.Salary * 1.10 AS NewSalary
FROM
    EMPLOYEE E
        JOIN
    WORKS_ON W ON E.SSN = W.SSN
        JOIN
    PROJECT P ON W.PNo = P.PNo
WHERE
    P.PName = 'AI';


/* 3) Find the sum of the salaries of all employees of the ‘Accounts’ department,
as well as the maximum salary, the minimum salary, and the average salary in this department. */
SELECT 
    SUM(E.Salary) AS TotalSalary,
    MAX(E.Salary) AS MaxSalary,
    MIN(E.Salary) AS MinSalary,
    AVG(E.Salary) AS AvgSalary
FROM
    EMPLOYEE E
        JOIN
    DEPARTMENT D ON E.DNo = D.DNo
WHERE
    D.DName = 'Accounts';


/* 4) Retrieve the name of each employee who works on all the projects controlled 
by department number 5 (use NOT EXISTS operator). */
SELECT 
    E.Name
FROM
    EMPLOYEE E
WHERE
    NOT EXISTS( SELECT 
            P.PNo
        FROM
            PROJECT P
        WHERE
            P.DNo = 5
                AND NOT EXISTS( SELECT 
                    W.SSN
                FROM
                    WORKS_ON W
                WHERE
                    W.PNo = P.PNo AND W.SSN = E.SSN));


/* 5) For each department that has more than five employees,retrieve the department number 
and the number of its employees who are earning more than Rs.6,00,000 per month. */
SELECT 
    D.DNo, COUNT(E.SSN) AS NumEmployees
FROM
    DEPARTMENT D
        JOIN
    EMPLOYEE E ON D.DNo = E.DNo
WHERE
    E.Salary > 60000
GROUP BY D.DNo
HAVING COUNT(E.SSN) >= 1;



















