
-- Drop Tables if Existing
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- Create tables and import data from the corresponding CSV files

CREATE TABLE departments (	
    dept_no VARCHAR(9) NOT NULL,
    dept_name VARCHAR(9),
    CONSTRAINT departments_pkey PRIMARY KEY (dept_no)
);

SELECT *
FROM departments;

CREATE TABLE dept_emp (
    emp_no INT,
    dept_no VARCHAR(10)
);

SELECT *
FROM dept_emp;

CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	CONSTRAINT dept_manager_pkey PRIMARY KEY (dept_no, emp_no)
);

SELECT *
FROM dept_manager;

CREATE TABLE employees (
	emp_no INT NOT NULL,
    emp_title_id VARCHAR NOT NULL,
    birth_date VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    sex VARCHAR,
    hire_date VARCHAR,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_no),
    CONSTRAINT unique_emp_no UNIQUE (emp_no),
    CONSTRAINT uq_emp_no UNIQUE (emp_no)
);

SELECT *
FROM employees;

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT,
	CONSTRAINT salaries_pkey PRIMARY KEY (emp_no)
);

SELECT *
FROM salaries;

CREATE TABLE titles (
    title_id VARCHAR NOT NULL,
    title VARCHAR,
    CONSTRAINT titles_pkey PRIMARY KEY (title_id),
    CONSTRAINT uq_titles_title_id UNIQUE (title_id)
);

SELECT *
FROM titles;

-- Add a unique constraint
ALTER TABLE "titles" ADD CONSTRAINT "uq_titles_title_id" UNIQUE ("title_id");

-- Add the foreign key constraint to the employees table
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");


-- Add a unique constraint 
ALTER TABLE "departments" ADD CONSTRAINT "unique_dept_no" UNIQUE ("dept_no");

-- Add the foreign key constraint to the dept_manager table
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

--Add a uniques contraint
ALTER TABLE employees
ADD CONSTRAINT unique_emp_no UNIQUE (emp_no);

--Add the foreign key constraint
ALTER TABLE dept_manager
DROP CONSTRAINT fk_dept_manager_emp_no;

ALTER TABLE dept_manager
ADD CONSTRAINT fk_dept_manager_emp_no
FOREIGN KEY (emp_no) REFERENCES employees (emp_no);

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");


-- Query * FROM Each Table Confirming Data
SELECT * FROM departments;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;


--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;


--2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name Like 'B%'

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT departments.dept_name, employees.last_name, employees.first_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
OR departments.dept_name = 'Development';

--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;