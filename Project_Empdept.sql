create database Empdept;

use Empdept;

CREATE TABLE Dept (
    deptno INT PRIMARY KEY,
    dname VARCHAR(20),
    loc VARCHAR(20)
);

insert into Dept (deptno,dname,loc) values
(10,"OPERATIONS","BOSTON"),
(20,"RESEARCH","DALLAS"),
(30,"SALES","CHICAGO"),
(40,"ACCOUNTING","NEW YORK");

CREATE TABLE Employee (
    empno INT UNIQUE NOT NULL,
    ename VARCHAR(20),
    job VARCHAR(20) default "CLERK",
    mgr INT,
    hiredate DATE,
    sal DECIMAL(8 , 2 ),
    comm DECIMAL(8 , 2 ),
    deptno INT REFERENCES Dept (deptno),
    CHECK (sal > 0)
);

insert into employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) values
(7369,"SMITH","CLERK",7902,'1890-12-17',800.00,NULL,20),
(7499,"ALLEN","SALESMAN",7698,'1981-02-20',1600.00,300.00,30),
(7521,"WARD","SALESMAN",7698,'1981-02-22',1250.00,500.00,30),
(7566,"JONES","MANAGER",7839,'1981-04-02',2975.00,NULL,20),
(7654,"MARTIN","SALESMAN",7698,'1981-09-28',1250.00,1400.00,30),
(7698,"BLAKE","MANAGER",7839,'1981-05-01',2850.00,NULL,30),
(7782,"CLARK","MANAGER",7839,'1981-06-09',2450.00,NULL,10),
(7788,"SCOTT","ANALYST",7566,'1987-04-19',3000.00,NULL,20),
(7839,"KING","PRESIDENT",NULL,'1981-11-17',5000.00,NULL,10),
(7844,"TURNER","SALESMAN",7698,'1981-09-08',1500.00,0.00,30),
(7876,"ADAMS","CLERK",7788,'1987-05-23',1100.00,NULL,20),
(7900,"JAMES","CLERK",7698,'1981-12-03',950.00,NULL,30),
(7902,"FORD","ANALYST",7566,'1981-12-03',3000.00,NULL,20),
(7934,"MILLER","CLERK",7782,'1982-01-23',1300.00,NULL,10);

# Q. List the Names and salary of the employee whose salary is greater than 1000
SELECT 
    ename, sal
FROM
    employee
WHERE
    sal > 1000;

# Q. List the details of the employees who have joined before end of September 81
SELECT 
    *
FROM
    employee
WHERE
    hiredate < '1981-09-30';
    
# Q. List Employee Names having I as second character.
SELECT 
    ename
FROM
    employee
WHERE
    ename LIKE '_I%';
    
# Q. List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns
    SELECT 
    ename,
    sal,
    sal * 0.40 AS Allowances,
    sal * 0.10 AS Provident_Fund,
    (sal + (sal * 0.40) - (sal * 0.10)) AS Net_Salary
FROM
    employee;
    
# Q. List Employee Names with designations who does not report to anybody
SELECT 
    ename, job
FROM
    employee
WHERE
    mgr IS NULL;
    
# Q. List Empno, Ename and Salary in the ascending order of salary.  
SELECT 
    empno, ename, sal
FROM
    employee
ORDER BY sal;
    
# Q. How many jobs are available in the Organization ?   
SELECT DISTINCT
    COUNT(DISTINCT job) AS no_of_jobs_in_organization
FROM
    employee;
    
# Q. Determine total payable salary of salesman category    
SELECT 
    SUM(sal) AS total_payable_salary
FROM
    employee
WHERE
    job = 'SALESMAN';
    
# Q. List average monthly salary for each job within each department   
SELECT 
    deptno, job, AVG(sal) AS average_monthly_salary
FROM
    employee
GROUP BY deptno , job
ORDER BY deptno;

# Q. Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.
SELECT 
    ename, sal, dname, dept.deptno
FROM
    employee,
    dept
WHERE
    employee.deptno = dept.deptno
ORDER BY deptno;
    
# JOB Grades table     
CREATE TABLE Job_grades (
    grade CHAR,
    lowest_sal INT,
    highest_Sal INT
);
    
insert into job_grades(grade,lowest_sal,highest_sal)values
('A',0,999),
('B',1000,1999),
('C',2000,2999),
('D',3000,3999),
('E',4000,5000) ;  

# Q. Display the last name, salary and  Corresponding Grade.
SELECT 
    ename, sal, grade
FROM
    employee
        JOIN
    job_grades ON employee.sal BETWEEN job_grades.lowest_sal AND job_grades.highest_Sal;

/*	Display the Emp name and the Manager name under whom the Employee works in the below format .
Emp Report to Mgr*/
SELECT 
    employee.deptno,
    employee.ename,
    employee.job,
    m.ename AS 'Manager'
FROM
    employee
        LEFT JOIN
    employee m ON employee.mgr = m.empno
ORDER BY deptno;

# Q. Display Empname and Total sal where Total Sal (sal + Comm)
SELECT 
    ename, (sal + IFNULL(comm, 0)) AS Total_salary
FROM
    employee;
  
# Q.Display Empname and Sal whose empno is a odd number
SELECT 
    empno, ename, sal
FROM
    employee
WHERE
    empno % 2 <> 0;


# Q.Display Empname,Rank of sal in Organisation , Rank of Sal in their department
SELECT 
	ename,sal,deptno,dense_rank() over(order by sal desc) as organisation_sal_rank, dense_rank() over(partition by deptno order by sal desc) as dept_sal_rank 
FROM 
	employee;


# Q. Display Top 3 Empnames based on their Salary
 SELECT 
    ename, sal
FROM
    employee
ORDER BY sal DESC
LIMIT 3;

# Q. Display Empname who has highest Salary in Each Department.

SELECT 
    ename, deptno, sal
FROM
    employee
WHERE
    sal IN (SELECT 
            MAX(sal) AS Highest_salary
        FROM
            employee
        GROUP BY deptno);




