CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(20),
    major VARCHAR(20)
); -- Query to create a table that contains 'student_id, name & major' as columns along with their assigned data types. --This is also known as 'defining the dbSchema'.

DESCRIBE Student; -- This describes what the table 'Student' looks like.

DROP TABLE Student; -- Query to delete the table 'Student'.

ALTER TABLE Student ADD gpa DECIMAL(3,2); -- Adding the new column 'gpa' to the 'Student' table and assigning it a DECIMAL-data-type-with-total-3-digits-with-2DecimalPoints.

ALTER TABLE Student DROP COLUMN gpa; --Deleting the 'gpa' column.

INSERT INTO Student VALUES(1,'Jack','Biology'); --Adding values to the 'Student' table.

SELECT * FROM Student; --Select '* = everything/all' from the StudentTable. 

INSERT INTO Student VALUES(2,'Kate','Sociology');

/* Let's say we need to enter
student_id = 3
name = Claire
major = N/A (we don't know) */

INSERT INTO Student(student_id,name) VALUES(3,'Claire');

INSERT INTO Student VALUES(4,'Jack','Biology');
INSERT INTO Student VALUES(5,'Mike','Computer Science');

CREATE TABLE Student1 (
    student_id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL, --'NOT NULL' = cannot be null
    major VARCHAR(20) UNIQUE --Has to be unique - It has the same functionality as a PrimaryKey but idk if I can call both the same yet. lol GOT my answer: a PrimaryKey is both NOT NULL & UNIQUE.
);

    SELECT * FROM Student1;

INSERT INTO Student1 VALUES(1,'Jack','Biology');
INSERT INTO Student1 VALUES(2,'Kate','Sociology');
INSERT INTO Student1 VALUES(3,NULL,'Chemistry'); --Error: Column 'name' cannot be null
INSERT INTO Student1 VALUES(4,'Jack','Biology'); --Error: Duplicate entry 'Biology' for key 'student1.major' Error Code: ER_DUP_ENTRY
INSERT INTO Student1 VALUES(5,'Mike','Computer Science');

CREATE TABLE Student2 (
    student_id INT PRIMARY KEY,
    name VARCHAR(20),
    major VARCHAR(20) DEFAULT 'Undecided'); --If I forget to enter someones major, it'll say 'Undecided'.

    SELECT * FROM Student2;

    INSERT INTO Student2(student_id,name) VALUES(1,'Jack');

CREATE TABLE Student3 (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    major VARCHAR(20) DEFAULT 'Undecided'); --The PrimaryKey auto-increments - so no need to manually keep assigning the student_id for each student. 

    SELECT * FROM Student3;

    INSERT INTO Student3(name,major) VALUES('Jack','Biology');
    INSERT INTO Student3(name,major) VALUES('Kate','Sociology');

CREATE TABLE Student4 (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    major VARCHAR(20) DEFAULT 'Undecided');

    SELECT * FROM Student4;

    INSERT INTO Student4(name,major) VALUES('Jack','Biology');
    INSERT INTO Student4(name,major) VALUES('Kate','Sociology');
    INSERT INTO Student4(name,major) VALUES('Claire','Chemistry');
    INSERT INTO Student4(name,major) VALUES('Jack','Biology');
    INSERT INTO Student4(name,major) VALUES('Mike','Computer Science');

    UPDATE Student4
    SET major = 'Comp Sci'
    WHERE major = 'Computer Science'; --Pretty straight forward; I just updated 'Computer Science' on the major column to 'Comp Sci' - This affects all the cells in column that has 'Computer Science' (basically updates it to 'Comp Sci').

    --Let's say I want to change the major of student_id = 4 (Jack) to Comp Sci as well,
    UPDATE Student4
    SET major = 'Comp Sci'
    WHERE student_id = 4;

    --Anyone with a major of either 'Bio'/'Chemistry', will now needs to be updated as 'Bio-Chem'.
    UPDATE Student4
    SET major = 'Bio-Chem'
    WHERE major = 'Bio' OR major = 'Chemistry';

    --Say I want to change the name & major of student_id = 1 to, 'Tom' and 'Undecided'
    UPDATE Student4
    SET name = 'Tom', major = 'Undecided'
    WHERE student_id = 1;

    --Say I want to take off student_id = 5 (Mike) from the table
    DELETE FROM Student4
    WHERE student_id = 5;

    --Say I want to delete everyone with name = 'Tom' and major = 'Undecided'
    DELETE FROM Student4
    WHERE name = 'Tom' AND major = 'Undecided';

    --I'm NOT gonna run this code cause I need the Student4 table but just fyi,
    DELETE FROM Student4; 
    --This will delete all the records from the Student4 table. 

    --Okay so all the updates I made to Student4, imma need it back! So I'm just going to delete all the records from the table and reinstate. 

    --Extract all the names from Student4
    SELECT name 
    FROM Student4;

    --Select the name & major
    SELECT name,major
    FROM Student4;

    --This is another way to select name & major. I don't really see myself using this casue its a longer code but this guy says as we move on and our codes get more complex that it'll come in handy.
    SELECT Student4.name, Student4.major
    FROM Student4;

    --Extract the same info (name & major) but I want 'name' as the first column and want it sorted alphabetically (a-z). 
    SELECT name,major
    FROM Student4
    ORDER BY name;
    --So remember 'ORDER BY' is to sort.

    --Now do the same thing but I want it sorted by name (descending).
    SELECT name,major
    FROM Student4
    ORDER BY name DESC;
    --'ASC' is ascending. But when we use ORDER BY for the first time the default sorting method is ascending.

    --I can ORDER BY anything! I can even OrderBy something that's not being returned from the query (but obviously it has to be a column that exists within the table). F.e. I want only the name & major returned but I want the output sorted by their student_id asc.
    SELECT name,major
    FROM Student4
    ORDER BY student_id;

    --I want all the info from the Student4 table, sorted by major first, then student_id ASC.
    SELECT *
    FROM Student4
    ORDER BY major,student_id;

    --I want the first-2-records from the Student4 table.
    SELECT *
    FROM Student4
    LIMIT 2;

    --I want all the info from Student4, sort them by thier StudentIds DESC and only select the first-2-records from there.
    SELECT *
    FROM Student4
    ORDER BY student_id DESC 
    LIMIT 2;

    --Get me all the info about all the students from Student4 who's major = biology
    SELECT *
    FROM Student4
    WHERE major = 'Biology';

    --'<>' This means 'not equal to' in SQL. In Python its 'NOT()'. Anyyways moving on...

    --I want all of the info from Student4 who's named 'Kate','Claire' or 'Mike'.
    SELECT *
    FROM Student4
    WHERE name IN('Kate','Claire','Mike');

    

