
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

SELECT * FROM employee;

--Find all employees
SELECT first_name, last_name
FROM employee;

--Find all clients
SELECT client_name
FROM client;

--Find all employees ordered-by salary
SELECT *
FROM employee
ORDER BY salary;

--Find all employees ordered-by salary (highest-to-lowest)
SELECT *
FROM employee
ORDER BY salary DESC;

--Find all employees ordered-by sex, then name
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

--Find the first-five-employees in the table
SELECT *
FROM employee
LIMIT 5;

--Find the first and last names of all the employees
SELECT first_name, last_name
FROM employee;

--Find the forename and the surname of all the employees (This is exactly what we have done right above as well but I want the returned columns to be named as 'forename' and 'surname')
SELECT first_name AS forename, last_name AS surname
FROM employee;

--Find out all the different genders
SELECT sex 
FROM employee
GROUP BY sex;

--I can also do the above using the 'DISTINCT' function.
SELECT DISTINCT sex 
FROM employee;

--Find the number of employees
SELECT COUNT(emp_id)
FROM employee;

--Find the number of employees with supervisors
SELECT COUNT(super_id)
FROM employee;

--Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE birth_day > '1970-01-01' AND sex = 'F';

--Find the average of all-employees-salaries
SELECT (SUM(salary)/COUNT(emp_id))
FROM employee;

--I can also just use the built-in AVG function for this without having to calculate the avg myself
SELECT AVG(salary)
FROM employee;

--Avg salary of all male employees
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

--Find the sum of all employees salaries
SELECT SUM(salary)
FROM employee;

--Find out how many males and females in the company
SELECT sex, COUNT(sex)
FROM employee
GROUP BY sex; 

/*
ORDER BY : sorting
GROUP BY : agregation
*/

--Find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

--Find the total sales for each client
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;

--Find any client who are an LLC
SELECT client_name 
FROM client 
WHERE client_name LIKE '%LLC%';

/*
% : any number of characters
_ : 1-character

1. so f.e. let's say my name (Rahal) was in the employee table and I want to find out what other 'Rahal's are there in the company as well

Code1 :
SELECT first_name
FROM employee
WHERE first_name LIKE '%Rahal%'

Code2 :
SELECT first_name
FROM employee
WHERE first_name LIKE '%Rah_l'

Code 2 I have a feeling is not used as much as the '%'s since the '%'s capture anything and '_'s capture just one-character.
*/

--Find all the branch-suppliers who's in the 'label' business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% label%';

SELECT *
FROM branch_supplier;
--The reason 'Stamford Labels' didn't show is because there's a typo when we initially inserted the data - instead of 'labels' we've put 'lables'. 

--Find any employee born in October
SELECT *
FROM employee;

SELECT first_name, last_name, birth_day
FROM employee
WHERE birth_day LIKE '%_10_%';

--Find any clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%';

/*

--UNIONs
* a UNION is used to combine 2 or more SELECT statements - Let's see an example below

Rules:
* I have to query the same no. of columns from all tables (I can't get 1 column from one table and 2 from another - it has to be 1 from both or 2 from both and so on...).
* This guy says all the columns we're querying needs to be of the same data type as well but I don't think its true cause the code I wrote right below works - last_name is VARCHAR and branch_id is INT.

*/

--Get a list of all employee-names and all branch-names
SELECT first_name AS name_branch_client, last_name AS Name_BranchId_ClientId
FROM employee
UNION
SELECT branch_name, branch_id
FROM branch
UNION
SELECT client_name, client_id
FROM client; 

SELECT *
FROM branch;

--Get a list of all Client & Branch-Supplier names
SELECT client_name AS client_supplier_name
FROM client 
UNION
SELECT supplier_name
FROM branch_supplier;

SELECT *
FROM client;

SELECT *
FROM branch_supplier;

--Find a list of all the money spent & earned by the company
SELECT salary AS ctc_rtc, first_name
FROM employee
UNION
SELECT total_sales, emp_id
FROM works_with;

/*

--JOINs
* are used to combine records from multiple tables together using a related column between them (foreign key). 

Types:
1. Inner : This only joins the records that match from both tables - this becomes a problem when one-table has null-values f.e. So here we are trying to find the managers to all the branches combining the records of both the 'employee' & 'branch' tables. But the 'branch' table has a branch named 'Buffalo' that does not have a manager assigned to it yet - so if we use an inner here, everything but 'Buffalo' will be returned.
2. LEFT : Joins the tables ON all of the records from the table-on-the-left (the first table).
3. RIGHT : Joins the tables ON all of the records from the table-on-the-right (the second table).
4. FULL OUTER JOIN : This guy says 'it combines all of the records from both tables to make the join regardless of the selection criteria (employee.emp_id = branch.mgr_id) being met' - Try this out

*/

--Adding a new record to the 'branch' table
INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

SELECT *
FROM branch;

--Find all the branches and the names of their respective managers (we're gonna be using an 'inner join' for this).
SELECT *
FROM branch;

SELECT *
FROM employee;

--inner JOIN
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee 
JOIN branch 
ON employee.emp_id = branch.mgr_id;

--LEFT JOIN
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee 
LEFT JOIN branch 
ON employee.emp_id = branch.mgr_id;

--RIGHT JOIN
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee 
RIGHT JOIN branch 
ON employee.emp_id = branch.mgr_id;

/*

--Nested Queries
> Sounds very similar to a UNION but ig let's find out if there are any differences between the two.
> *So to answer my doubt above, its not the same thing! Nested Queries don't just join columns from different tables into a single-output-column; in fact what it does is, it takes the result of one query and matches it to another query and returns the values that matches both queries.

*/

--Find the names of all the employees who has sold over 30,000 to a single client 
SELECT employee.first_name, employee.last_name
FROM employee 
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000);

--Find all the clients that are managed by the branch Michael Scott manages. Assume you know Michael's ID.
SELECT client.client_name
FROM client 
WHERE client.branch_id IN (
    SELECT branch.branch_id
    FROM branch 
    WHERE branch.mgr_id = 102);
--Here I can also use '=' instead of the 'IN'


/*

--ON DELETE SET NULL and ON DELETE CASCADE
* He says these are to delete records from the db when there's a foreign key associated with it.

1. ON DELETE SET NULL : this will set the deleted record/cell to NULL

So f.e. look at this code we executed before,

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

The last line of the code basically means that if the emp_id from the employee-table is deleted, the mgr_id in the branch-table needs to be set to NULL.


2. ON DELETE CASCADE : this will delete the entire record from the db - in other words, the record will cease to exsist.
CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

So here basically since its ON DELETE CASCADE, if a particular branch_id is deleted, the db is going to delete all the records pertinent to that branch_id

*** IMPORTANT: if in any table, the foreign key is also the primary key or a part of the primary key, then we have to set it to ON DELETE CASCADE cause otherwise we're going to run into trouble - meaning we can't have a primary key set to NULL cause a primary key is absolutely crucial for a table. 

*/



--Triggers

--Creating this table to add the triggers; meaning this is where the output of the triggers will be returned into
CREATE TABLE trigger_test (
    message VARCHAR(40)
);

SELECT * 
FROM trigger_test;

/*

--we're going to make a trigger where when a new record is added to the employee-table, the trigger will execute and return the message 'added new employee' (and this will be recorded in the table to we created right above 'trigger_test')

DELIMITER $$
CREATE 
    TRIGGER my_trigger BEFORE INSERT 
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;

--The indentation we have used here is very important cause the code will not execute if not. The indentation style here is a bit weird to me but I'll try to clarify that with someone else.
--Actually no upon further research through gpt, I found out that indentation does not matter in SQL (see gpt's response below)

gpt:
Short answer:
No — technically, indentation in SQL doesn't matter for execution.
SQL is not whitespace-sensitive like Python or YAML. The parser only cares about correct keywords, structure, and terminators (DELIMITER, ;, $$ etc).

*/

INSERT INTO employee VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

SELECT *
FROM trigger_test;

/*
--I can also link specific info from the record that's being added into the returned-trigger-message
DELIMITER $$
CREATE 
    TRIGGER my_trigger1 
    BEFORE INSERT ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES(NEW.first_name);
END$$
DELIMITER ;
*/

--imma add in a new record to the employee table to see if this new trigger works
INSERT INTO employee VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

SELECT *
FROM employee;

--Complex Triggers : ELSE IF ELSEIF - These can also be called 'Conditional Triggers' (why? well lol if I can't understand that I should just stop DS and go home lol)
DELIMITER $$
CREATE 
    TRIGGER my_trigger2 BEFORE INSERT ON employee --i can use INSERT UPDATE DELETE - meaning i can create triggers anytime i wanna INSERT UPDATE or DELETE --I can also do AFTER 
    FOR EACH ROW BEGIN 
    IF NEW.sex = 'M' THEN 
        INSERT INTO trigger_test VALUES('added male employee');
        ELSEIF NEW.sex = 'F' THEN 
        INSERT INTO trigger_test VALUES('added female employee');
        ELSE
        INSERT INTO trigger_test VALUES('added other employee');
    END IF;
END$$
DELIMITER ;

INSERT INTO employee VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

