-- DATA ENGINEERING --

/* Create tables and import each CSV */

-- Delete previous tables.
DROP TABLE dept_emp;
DROP TABLE dept_manager;
DROP TABLE salaries;
DROP TABLE titles;
DROP TABLE departments;
DROP TABLE employees;

-- Create tables.

CREATE TABLE departments (
    dept_no VARCHAR,
    dept_name VARCHAR  NOT NULL, 
	-- Here department number is PK and would be FK in other tables
    CONSTRAINT PK_departments PRIMARY KEY (dept_no)
);

CREATE TABLE employees (
    emp_no VARCHAR,
    birth_date VARCHAR  NOT NULL ,
    first_name VARCHAR  NOT NULL ,
    last_name VARCHAR  NOT NULL ,
    gender VARCHAR  NOT NULL ,
    hire_date VARCHAR  NOT NULL,
	-- Here employee number is PK and would be FK in other tables
    CONSTRAINT PK_Employees PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
    emp_no VARCHAR,
    dept_no VARCHAR,
    from_date VARCHAR  NOT NULL ,
    to_date VARCHAR  NOT NULL,
	-- Department and employee id are PK
	PRIMARY KEY(emp_no, dept_no), 
	-- And FK to relate the info to other table
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no), 
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR  NOT NULL ,
    emp_no VARCHAR  NOT NULL ,
    from_date VARCHAR  NOT NULL ,
    to_date VARCHAR  NOT NULL, 
	--Also works without assigning a PK
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE salaries (
    emp_no VARCHAR  NOT NULL ,
    salary VARCHAR  NOT NULL ,
    from_date VARCHAR  NOT NULL ,
    to_date VARCHAR  NOT NULL,
	PRIMARY KEY(emp_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE titles (
    emp_no VARCHAR,
    title VARCHAR  NOT NULL ,
    from_date VARCHAR  NOT NULL ,
    to_date VARCHAR  NOT NULL,
	-- Can work without assigning PK only FK
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);

-- Some visualization.
-- First add the employees and departments csv then the rest.
SELECT * FROM dept_emp;
SELECT * FROM departments;
SELECT * FROM salaries; 
SELECT * FROM titles;

-- DATA ANALYSIS --

/* * 1. List the following details of each employee: 
employee number, last name, first name, gender, and salary. */

-- CREATE table with these data
CREATE TABLE emp_salary AS
	-- SELECT column data and FROM which table, add extra column for salaries
    SELECT employees.emp_no, employees.first_name, employees.last_name, employees.gender, salary.salary
    FROM employees
	-- Add new data to previous info 
	-- (JOIN sec_table AS column ON main_table.PK = column_sec_table.samePKasFK)
	JOIN salaries AS salary 
	ON employees.emp_no = salary.emp_no 
	
SELECT * FROM emp_salary;

/* * 2. List employees who were hired in 1986. */

-- Using wildcard '%'. Here is not necessary to use = as operator, just the LIKE operator
CREATE TABLE emp_hire AS
	SELECT employees.emp_no, employees.hire_date
	FROM employees WHERE employees.hire_date LIKE '1986%'
	
SELECT * FROM emp_hire;

/* * 3. List the manager of each department with the following information: 
department number, department name, the manager's employee number, 
last name, first name, and start and end employment dates. */

-- SELECT the columns and data FROM table and add extra columns
CREATE TABLE manager_dept AS
	SELECT dept_manager.dept_no, dept_manager.emp_no, dept_manager.from_date, dept_manager.to_date, dept_name.dept_name, first_name.first_name, last_name.last_name
	FROM dept_manager
	-- Add information
	-- JOIN table AS column ON main_table.PK = sec_table.samePKasFK
	JOIN departments AS dept_name
	ON dept_manager.dept_no = dept_name.dept_no
	JOIN employees AS first_name  
	ON dept_manager.emp_no = first_name.emp_no
	JOIN employees AS last_name 
	ON dept_manager.emp_no = last_name.emp_no 
	
SELECT * FROM manager_dept;

/* * 4. List the department of each employee with the following information: 
employee number, last name, first name, and department name. */

CREATE TABLE emp_dept AS
	-- SELECT data FROM table and add columns for new info. 
	SELECT employees.emp_no, employees.first_name, employees.last_name, dept_name.dept_name
	FROM employees
	-- To know the department name, we need to go through the dept_emp table using dept_no (not added to the columns before)
	JOIN dept_emp AS dept_no 
	ON employees.emp_no = dept_no.emp_no
	JOIN departments AS dept_name
	ON dept_no.dept_no = dept_name.dept_no 
	
SELECT * FROM emp_dept;

/* * 5. List all employees whose first name is "Hercules" and last names begin with "B." */

-- Using the wildcard '%'
CREATE TABLE emp_hercules AS
	SELECT employees.first_name, employees.last_name
	FROM employees WHERE employees.first_name = 'Hercules' AND employees.last_name LIKE 'B%'
	
SELECT * FROM emp_hercules;

/* * 6. List all employees in the Sales department, 
including their employee number, last name, first name, and department name. */

CREATE TABLE emp_sales AS 
	-- SELECT column info and add more columns
	SELECT dept_emp.emp_no, dept_name.dept_name, first_name.first_name, last_name.last_name
	FROM dept_emp
	-- Also, to access the department name, we go through dept_emp table
	JOIN departments AS dept_name 
	ON dept_emp.dept_no = dept_name.dept_no 
	JOIN employees AS first_name
	ON dept_emp.emp_no = first_name.emp_no
	JOIN employees AS last_name
	ON dept_emp.emp_no = last_name.emp_no WHERE dept_name = 'Sales'
	-- The WHERE clause goes after all JOINs :)

SELECT * FROM emp_sales;

/* * 7. List all employees in the Sales and Development departments, 
including their employee number, last name, first name, and department name. */

-- Using the previous block adding the 'Development' department
CREATE TABLE emp_sales_develp AS
	SELECT dept_emp.emp_no, dept_name.dept_name, first_name.first_name, last_name.last_name
	FROM dept_emp
	JOIN departments AS dept_name 
	ON dept_emp.dept_no = dept_name.dept_no 
	JOIN employees AS first_name
	ON dept_emp.emp_no = first_name.emp_no
	JOIN employees AS last_name
	ON dept_emp.emp_no = last_name.emp_no
	WHERE dept_name = 'Sales' OR dept_name = 'Development'
	
SELECT * FROM emp_sales_develp ;

/* * 8. In descending order, list the frequency count of employee last names, 
i.e., how many employees share each last name. */

-- Using GROUP BY for each unique last name and COUNT them
CREATE TABLE emp_uniq_last AS
	SELECT last_name, COUNT(last_name) AS CountOf
	FROM employees
	GROUP BY last_name
	ORDER BY countof DESC;

SELECT * FROM emp_uniq_last;

/* * BONUS: Average salary by title. */

-- SELECTING the titles information with salaries
CREATE TABLE emp_titles_test AS
	SELECT titles.title, salary.salary
	FROM titles
	JOIN emp_salary AS salary 
	ON titles.emp_no = salary.emp_no

-- Since column 'salary' is VARCHAR and cannot be used for AVG function, 
--another column is ADDED to convert to INT and DROP the old column
ALTER TABLE emp_titles_test
ADD salary_int INT;
UPDATE emp_titles_test SET salary_int = CAST(salary AS INT);
ALTER TABLE emp_titles_test
DROP COLUMN salary;

-- CREATE new table to GROUP the titles and have the AVG salary 
CREATE TABLE emp_titles_slr AS SELECT title, 
	ROUND(AVG(salary_int),0) FROM emp_titles_test
	GROUP BY title;

SELECT * FROM emp_titles_slr
