-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Employees" (
    "emp_no" VARCHAR   NOT NULL,
    "birth_day" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Dept_Employees" (
    "emp_no" VARCHAR   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "start_date" VARCHAR   NOT NULL,
    "end_date" VARCHAR   NOT NULL
);

CREATE TABLE "Dept_Manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" VARCHAR   NOT NULL,
    "star_date_man" VARCHAR   NOT NULL,
    "end_date_man" VARCHAR   NOT NULL
);

CREATE TABLE "Salaries" (
    "emp_no" VARCHAR   NOT NULL,
    "salaries" VARCHAR   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

CREATE TABLE "Titles" (
    "emp_no" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date_t" VARCHAR   NOT NULL,
    "to_date_t" VARCHAR   NOT NULL
);

ALTER TABLE "Dept_Employees" ADD CONSTRAINT "fk_Dept_Employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Dept_Employees" ADD CONSTRAINT "fk_Dept_Employees_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_Manager" ADD CONSTRAINT "fk_Dept_Manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_Manager" ADD CONSTRAINT "fk_Dept_Manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Titles" ADD CONSTRAINT "fk_Titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

