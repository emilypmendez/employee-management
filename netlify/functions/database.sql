/*
CUNY - Lehman College
Department of Computer Science
CMP 420 - Database Systems
Spring 2024
Group Final Project: "School of the Natural Social Sciences Database - SNSSD"

Students:
Ljupcho Atansov
Emily Portalatin-Mendez
*/

set foreign_key_checks = 0;
CREATE DATABASE IF NOT EXISTS SNSSD;
use SNSSD;

#-----------------------------------------------TABLE DEFINITIONS-------------------------------------------------#
/*
1. Write SQL queries to create the NSS database and all your relations for the database.
Add primary keys for your relations and foreign keys where necessary and all other necessary integrity constraints. */

-- Drop Tables Safely
DROP TABLE IF EXISTS department;                    /* prevent duplicates */
DROP TABLE IF EXISTS employee;                      /* prevent duplicates */
DROP TABLE IF EXISTS staff;                         /* prevent duplicates */
DROP TABLE IF EXISTS faculty;                       /* prevent duplicates */
DROP TABLE IF EXISTS areas_of_teaching_interests;   /* prevent duplicates */
DROP TABLE IF EXISTS areas_of_research_interests;   /* prevent duplicates */
DROP TABLE IF EXISTS course;                        /* prevent duplicates */
DROP TABLE IF EXISTS course_section;                /* prevent duplicates */
DROP TABLE IF EXISTS advises;                       /* prevent duplicates */
DROP TABLE IF EXISTS mandatory_courses;             /* prevent duplicates */
DROP TABLE IF EXISTS requerements_courses;          /* prevent duplicates */
DROP TABLE IF EXISTS ellective_courses;             /* prevent duplicates */
DROP TABLE IF EXISTS honors;                        /* prevent duplicates */
DROP TABLE IF EXISTS majors_in;                     /* prevent duplicates */
DROP TABLE IF EXISTS major;                         /* prevent duplicates */
DROP TABLE IF EXISTS employment_record;             /* prevent duplicates */
DROP TABLE IF EXISTS enroled;                       /* prevent duplicates */
DROP TABLE IF EXISTS cheating_incident;             /* prevent duplicates */
DROP TABLE IF EXISTS alumnus;                       /* prevent duplicates */
DROP TABLE IF EXISTS student;                       /* prevent duplicates */
DROP TABLE IF EXISTS employer;                      /* prevent duplicates */

-- Create Tables
#-- #1 -- #
create table department(
    department_id		int,
    d_name				varchar(255)		unique  not null,
    office_locaton		varchar(20),
    phone				char(10)		unique,
    se_emplid			int,
    cf_emplid			int,
    foreign key(se_emplid) references employee(e_emplid)
    on delete cascade on update cascade,
    foreign key(cf_emplid) references faculty(fe_emplid)
    on delete cascade on update cascade,
    primary key (department_id)
);
select * from employee where fname='ljupcho';
select * from employment_record;



#--2--#
create table employee(
    e_emplid		INT		    not null AUTO_INCREMENT,
    fname			varchar(50),
    minit			varchar(1),
    lname			varchar(50),
    ssn				char(9),
    phone			char(15),
    email			varchar(50),
    appt			varchar(5),
    building		varchar(8),
    street			varchar(20),
    city			varchar(20),
    country			varchar(30),
    zip				varchar(10),
    date_of_hire	date,
    office_location	varchar(20),
    department_id	INT,
    primary key 	(e_emplid),
    foreign key		(department_id) references department(department_id)
    -- foreign key     (d_name) references department(d_name)
    on delete set null on update cascade
);

#--3--#
create table staff(
    se_emplid 	int				not null,
    position	varchar(30)		not null,
    foreign key (se_emplid) references employee (e_emplid)
    on delete cascade on update cascade,
    primary key (se_emplid, position)
);

#--4--#
create table faculty(
    fe_emplid		INT,
    f_rank			varchar(20)		not null,
    specialization	varchar(20),
    foreign key(fe_emplid) references employee(e_emplid),
    primary key (fe_emplid,f_rank)
);
CREATE INDEX idx_f_rank ON faculty (f_rank);

#--5--#
create table areas_of_teaching_interests(
    fe_emplid					INT,
    f_rank						varchar(20),
    area_of_teaching_interest	varchar(20),
    foreign key (fe_emplid) references faculty (fe_emplid)
    on delete cascade on update cascade,
    foreign key (f_rank) references faculty (f_rank)
    on delete cascade on update cascade,
    primary key (fe_emplid, f_rank, area_of_teaching_interest)
);

#--6--#
create table areas_of_research_interests(
    fe_emplid					INT,
    f_rank						varchar(20),
    area_of_research_interest	varchar(20),
    foreign key (fe_emplid) references faculty (fe_emplid)
    on delete cascade on update cascade,
    foreign key (f_rank) references faculty (f_rank)
    on delete cascade on update cascade,
    primary key (fe_emplid, f_rank, area_of_research_interest)
);

#--7--#
create table course(
    course_id			int,
    course_name			varchar(30)		unique,
    course_code			INT				unique,
    hours				decimal(10,2),
    credits				int,
    corse_description			varchar(170),
    department_id		INT,
    foreign key(department_id) references department(department_id)
    on delete cascade on update cascade,
    PRIMARY KEY (course_id)
);

#--8--#
create table course_section(
    course_id				int,
    section_id				int		not null,
    room_number				int		check(room_number > 0 and room_number < 999),
    course_secton_schedule	varchar(120),
    tf_emplid				int,
    semester				varchar(10),
    s_year					INT		check(s_year > 1600 and s_year < 9999),
    foreign key(course_id) references course(course_id)
    on delete cascade on update cascade,
    foreign key(tf_emplid) references faculty(fe_emplid)
    on delete cascade on update cascade,
    primary key(course_id, section_id)
);
-- drop table course_section;


#--9--#
create table advises(
    fe_emplid		int,
    major_name		varchar(50),
    foreign key (fe_emplid) references faculty(fe_emplid)
    on delete cascade on update cascade,
    foreign key (major_name) references major(major_name)
    on delete cascade on update cascade,
    primary key (fe_emplid, major_name)
);
-- DROP TABLE ADVISES;

#--10--#
create table mandatory_courses(
    major_name		varchar(50),
    course_id		int,
    foreign key (major_name) references major(major_name)
    on delete cascade on update cascade,
    foreign key (course_id) references course(course_id)
    on delete cascade on update cascade,
    primary key (major_name, course_id)	
);
-- drop table mandatory_courses;

#--11--#
create table requerements_courses(
    major_name		varchar(50),
    course_id		int,
    foreign key (major_name) references major(major_name)
    on delete cascade on update cascade,
    foreign key (course_id) references course(course_id)
    on delete cascade on update cascade,
    primary key (major_name, course_id)	
);
-- DROP TABLE requerements_courses;

#--12--#
create table ellective_courses(
    major_name		varchar(50),
    course_id		int,
    foreign key (major_name) references major(major_name)
    on delete cascade on update cascade,
    foreign key (course_id) references course(course_id)
    on delete cascade on update cascade,
    primary key (major_name, course_id)	
);
-- drop table ellective_courses;

#--13--#
create table honors(
    s_emplid		int,
    honor			varchar(70),
    foreign key (s_emplid) references student(s_emplid)
    on delete cascade on update cascade,
    primary key (s_emplid, honor)
);
-- drop table honors;

#--14--#
create table majors_in(
    major_name		varchar(50),
    s_emplid		int,
    foreign key (major_name) references major(major_name)
    on delete cascade on update cascade,
    foreign key (s_emplid) references student(s_emplid)
    on delete cascade on update cascade,
    primary key (major_name, s_emplid)
);
-- drop table majors_in;


#--15--#
create table major(
    major_name						varchar(50),
    major_description				varchar(130),
    type_of_degree					varchar(10),
    number_of_credits_to_graduate	int,
    primary key(major_name)
);
-- drop table major;


#--16--#
create table employment_record(
    s_emplid						int,
    employer_id						int,
    job_title						varchar(90),
    start_date						date,
    end_date						date,
    foreign key	(s_emplid) references student(s_emplid)
    on delete cascade on update cascade,
    foreign key	(employer_id) references employer(employer_id)
    on delete cascade on update cascade,
    primary key (s_emplid, employer_id)
);
-- drop table employment_record;

#--17--#
create table enroled(
    course_id						int,
    section_id						int,
    s_emplid						int,
    grade_earned					char(1),
    foreign key (course_id) references course_secton(course_id)
    on delete cascade on update cascade,
    foreign key (section_id) references course_secton(section_id)
    on delete cascade on update cascade,
    foreign key	(s_emplid) references student(s_emplid)
    on delete cascade on update cascade,
    primary key (course_id, section_id, s_emplid)
);

#--18--#
create table cheating_incident(
    course_id						int,
    section_id						int,
    s_emplid						int,
    cheating_incident_date			date,
    cheating_incident_description	varchar(50),
    resolution						varchar(30),
    foreign key (course_id) references course_secton(course_id)
    on delete cascade on update cascade,
    foreign key (section_id) references course_secton(section_id)
    on delete cascade on update cascade,
    foreign key	(s_emplid) references student(s_emplid)
    on delete cascade on update cascade,
    primary key (course_id, section_id, s_emplid)
);

#--19--#
create table alumnus(
    s_emplid					int,
    graduation_year				INT		check(graduation_year > 1900 and graduation_year < 9999),
    degree_earned				varchar(90),
    foreign key (s_emplid) references student(s_emplid)
    on delete cascade on update cascade,
    primary key (s_emplid)
);
-- drop table alumnus;

#--20--#
create table student(
    s_emplid					int,
    fname						varchar(15)		not null,
    minit						varchar(3),
    lname						varchar(20)		not null,
    dob							date,
    phone						char(10)		unique,
    email						varchar(30)		unique,
    appt						varchar(15),
    building					varchar(40),
    street						varchar(20),
    city						varchar(20),
    country						varchar(30),
    zip							varchar(10),
    primary key (s_emplid)
);
-- drop table student;

#--21--#
create table employer(
    employer_id					int,
    employer_name				varchar(80)			unique,
    industry					varchar(120),
    building					varchar(80),
    street						varchar(120),
    city						varchar(120),
    country						varchar(130),
    zip							varchar(20),
    primary key (employer_id)
);
-- drop table employer;

#-----------------------------------------------INSERTING DATA INTO TABLES-------------------------------------------------#
/*
2. Write queries that insert 15 or more records in all your relations you have created above.
*/

#--1 INSERTING INTO EMPLOYEE --#
INSERT INTO employee (e_emplid, fname, minit, lname, ssn, phone, email, appt, building, street, city, country, zip, date_of_hire, office_location, department_id) VALUES
(1, 'John', 'D', 'Doe', '123456789', '1234567890', 'john@example.com', '101', 'Bldg A', 'Main St', 'City A', 'Country A', '12345', '2024-01-01', 'Office A', 1),
(2, 'Jane', 'M', 'Smith', '987654321', '9876543210', 'jane@example.com', '102', 'Bldg B', 'High St', 'City B', 'Country B', '54321', '2024-02-02', 'Office B', 2),
(3, 'Michael', 'J', 'Johnson', '456789012', '4567890123', 'michael@example.com', '103', 'Bldg C', 'Park Ave', 'City C', 'Country C', '67890', '2024-03-03', 'Office C', 3),
(4, 'Emily', 'A', 'Brown', '789012345', '7890123456', 'emily@example.com', '104', 'Bldg D', 'Elm St', 'City D', 'Country D', '01234', '2024-04-04', 'Office D', 4),
(5, 'David', 'S', 'Jones', '234567890', '2345678901', 'david@example.com', '105', 'Bldg E', 'Oak St', 'City E', 'Country E', '56789', '2024-05-05', 'Office E', 5),
(6, 'Sarah', 'L', 'Wilson', '890123456', '8901234567', 'sarah@example.com', '106', 'Bldg F', 'Cedar St', 'City F', 'Country F', '90123', '2024-06-06', 'Office F', 6),
(7, 'Matthew', 'P', 'Taylor', '345678901', '3456789012', 'matthew@example.com', '107', 'Bldg G', 'Pine St', 'City G', 'Country G', '23456', '2024-07-07', 'Office G', 7),
(8, 'Emma', 'R', 'Martinez', '901234567', '9012345678', 'emma@example.com', '108', 'Bldg H', 'Maple St', 'City H', 'Country H', '78901', '2024-08-08', 'Office H', 1),
(9, 'Daniel', 'T', 'Anderson', '456789012', '4567890123', 'daniel@example.com', '109', 'Bldg I', 'Walnut St', 'City I', 'Country I', '34567', '2024-09-09', 'Office I', 3),
(10, 'Olivia', 'C', 'Garcia', '123456789', '1234567890', 'olivia@example.com', '110', 'Bldg J', 'Birch St', 'City J', 'Country J', '89012', '2024-10-10', 'Office J', 2),
(11, 'William', 'E', 'Lopez', '890123456', '8901234567', 'william@example.com', '111', 'Bldg K', 'Sycamore St', 'City K', 'Country K', '45678', '2024-11-11', 'Office K', 4),
(12, 'Ava', 'F', 'Hernandez', '234567890', '2345678901', 'ava@example.com', '112', 'Bldg L', 'Chestnut St', 'City L', 'Country L', '01234', '2024-12-12', 'Office L', 5),
(13, 'James', 'G', 'Clark', '901234567', '9012345678', 'james@example.com', '113', 'Bldg M', 'Cherry St', 'City M', 'Country M', '56789', '2024-01-01', 'Office M', 6),
(14, 'Sophia', 'H', 'Young', '345678901', '3456789012', 'sophia@example.com', '114', 'Bldg N', 'Apple St', 'City N', 'Country N', '12345', '2024-02-02', 'Office N', 7),
(15, 'Benjamin', 'I', 'King', '890123456', '8901234567', 'benjamin@example.com', '115', 'Bldg O', 'Pear St', 'City O', 'Country O', '54321', '2024-03-03', 'Office O', 1),
(16, 'Charlotte', 'J', 'Wright', '234567890', '2345678901', 'charlotte@example.com', '116', 'Bldg P', 'Plum St', 'City P', 'Country P', '67890', '2024-04-04', 'Office P', 2),
(17, 'Ljupcho', null, 'Atanasov', '111222333', '2033211233', 'ljupchoatanasov@example.com', 117, '50123', 'Water St', 'City Q', 'Countdry Q', '10000', '2022-04-02', 'Office O', 2),
(18, 'Emily', null, 'Mendez', '123123123', '2011231234', 'emilymendez@example.com', 118, '6789','Sky St', 'City Q', 'Country Q', '10000', '2020-09-09', 'Office B', 7);

select * from employee;

#--2 INSERTING INTO STAFF --#
insert into staff (se_emplid, position)
values
(1, 'Administration'), (2, 'Administration'), (3, 'Administration'), 
(4, 'Academic Advising'), (5, 'Academic Advising'), 
(6, 'Sanitation'), (7, 'Sanitation'),
(8, 'Security'), (9, 'Security'), 
(10, 'IT'), (11, 'IT'), 
(12, 'Student Services');

select * from staff;

#--3 INSERTING RECORDS INTO FACULTY --#
INSERT INTO faculty (fe_emplid, f_rank, specialization) VALUES
(1, 'Professor', 'Computer Science'),
(2, 'Assistant Professor', 'Electrical Eng'),
(3, 'Associate Professor', 'Mechanical Eng'),
(4, 'Professor', 'Physics'),
(5, 'Professor', 'Biology'),
(13, 'Assistant Professor', 'Chemistry'),
(14, 'Associate Professor', 'Mathematics'),
(15, 'Professor', 'Psychology'),
(16, 'Associate Professor', 'Sociology'),
(17, 'Professor', 'Economics'),
(18, 'Professor', 'History');

select * from faculty;

#--4 INSERTING INTO AREA_OF_TEACHING_INTERESTS --#
INSERT INTO areas_of_teaching_interests (fe_emplid, f_rank, area_of_teaching_interest) VALUES
(1, 'Professor', 'Computer Networks'),
(1, 'Professor', 'Database Systems'),
(2, 'Assistant Professor', 'Power Systems'),
(2, 'Assistant Professor', 'Signal Processing'),
(3, 'Associate Professor', 'Thermodynamics'),
(3, 'Associate Professor', 'Fluid Mechanics'),
(4, 'Professor', 'Quantum Mechanics'),
(5, 'Professor', 'Genetics'),
(13, 'Assistant Professor', 'Organic Chemistry'),
(13, 'Associate Professor', 'Algebra'),
(15, 'Professor', 'Cognitive Psychology'),
(15, 'Professor', 'General Psychology'),
(16, 'Associate Professor', 'Algebra'),
(16, 'Assistant Professor', 'Organic Chemistry'),
(17, 'Professor', 'Algebra'),
(18, 'Professor', 'Bronze Age'),
(18, 'Professor', 'Prahystoric Age');

select * from areas_of_teaching_interests order by fe_emplid;

#--5 INSERTING INTO AREA_OF_RESEARCH_INTERESTS --#
INSERT INTO areas_of_research_interests (fe_emplid, f_rank, area_of_research_interest) VALUES
(1, 'Professor', 'AI'),
(1, 'Professor', 'Machine Learning'),
(2, 'Assistant Professor', 'Renewable Energy'),
(2, 'Assistant Professor', 'Smart Grids'),
(3, 'Associate Professor', 'Nanotechnology'),
(3, 'Associate Professor', 'Material Science'),
(4, 'Professor', 'Astrophysics'),
(4, 'Professor', 'Cosmology'),
(5, 'Professor', 'Bioinformatics'),
(5, 'Professor', 'Neuroscience'),
(13, 'Professor', 'Software Engineering'),
(13, 'Professor', 'Cloud Computing'),
(14, 'Assistant Professor', 'Data Science'),
(14, 'Assistant Professor', 'Big Data'),
(15, 'Associate Professor', 'Robotics'),
(15, 'Associate Professor', 'Computer Vision'),
(16, 'Professor', 'Env. Science'),
(16, 'Professor', 'Climate Change'),
(17, 'Assistant Professor', 'Art History'),
(17, 'Assistant Professor', 'Literature'),
(18, 'Associate Professor', 'History'),
(18, 'Associate Professor', 'Political Science');

select * from areas_of_research_interests order by fe_emplid;

#--6 INSERTING INTO COURSE --#
INSERT INTO course (course_id, course_name, course_code, hours, credits, corse_description, department_id) VALUES
(1, 'Introduction to Biology', 101, 3.0, 4, 'An introductory course covering basic concepts in biology.', 1),
(2, 'Calculus I', 201, 4.0, 4, 'An introductory course in single-variable calculus.', 2),
(3, 'English Composition', 301, 3.0, 3, 'A writing-intensive course focusing on composition and rhetoric.', 3),
(4, 'Introduction to Psychology', 401, 3.0, 3, 'An overview of the major concepts and theories in psychology.', 4),
(5, 'Principles of Economics', 501, 3.0, 3, 'An introduction to the basic principles of microeconomics and macroeconomics.', 5),
(6, 'Computer Programming I', 601, 4.0, 4, 'An introductory course in computer programming using a high-level language.', 6),
(7, 'Introduction to Sociology', 701, 3.0, 3, 'An overview of the fundamental concepts and theories in sociology.', 7),
(8, 'World History', 801, 3.0, 3, 'A survey of world history from ancient civilizations to the present.', 1),
(9, 'Chemistry Fundamentals', 901, 4.0, 4, 'A foundational course covering basic principles and concepts in chemistry.', 2),
(10, 'Introduction to Linguistics', 1001, 3.0, 3, 'An introduction to the scientific study of language and its structure.', 3),
(11, 'Art History', 1101, 3.0, 3, 'A survey of the history of art from prehistoric times to the present.', 4),
(12, 'Environmental Science', 1201, 4.0, 4, 'An interdisciplinary study of environmental issues and their impact on ecosystems.', 5),
(13, 'Digital Marketing', 1301, 3.0, 3, 'An overview of marketing strategies and tactics in the digital age.', 6),
(14, 'Introduction to Anthropology', 1401, 3.0, 3, 'An introduction to the study of human societies and cultures.', 7),
(15, 'Microbiology', 1501, 4.0, 4, 'A study of microorganisms and their role in various biological processes.', 1),
(16, 'Organic Chemistry', 1601, 4.0, 4, 'A study of the structure, properties, and reactions of organic compounds.', 2),
(17, 'Statistics', 1701, 3.0, 3, 'An introduction to statistical methods and data analysis.', 3),
(18, 'Ethics', 1801, 3.0, 3, 'An examination of moral philosophy and ethical issues in contemporary society.', 4),
(19, 'Astrophysics', 1901, 4.0, 4, 'An introduction to the principles of astrophysics and cosmology.', 5),
(20, 'Introduction to Film Studies', 2001, 3.0, 3, 'An overview of the history, theory, and analysis of film as an art form.', 6);

select * from course;

#--7 INSERTING VALUES INTO COURSE_SECTION --#
INSERT INTO course_section (course_id, section_id, room_number, course_secton_schedule, tf_emplid, semester, s_year) VALUES
(1, 1, 101, 'Mon/Wed 9:00 AM - 10:30 AM', 1, 'Fall', 2024),
(1, 2, 102, 'Tue/Thu 9:00 AM - 10:30 AM', 2, 'Spring', 2025),
(2, 1, 103, 'Mon/Wed/Fri 11:00 AM - 12:00 PM', 3, 'Fall', 2024),
(2, 2, 104, 'Tue/Thu 1:00 PM - 2:30 PM', 4, 'Spring', 2025),
(3, 1, 105, 'Tue/Thu 11:00 AM - 12:30 PM', 5, 'Fall', 2024),
(3, 2, 106, 'Mon/Wed 1:00 PM - 2:30 PM', 6, 'Spring', 2025),
(4, 1, 107, 'Mon/Wed 3:00 PM - 4:30 PM', 7, 'Fall', 2024),
(4, 2, 108, 'Tue/Thu 3:00 PM - 4:30 PM', 8, 'Spring', 2025),
(5, 1, 109, 'Mon/Wed/Fri 9:00 AM - 10:00 AM', 9, 'Fall', 2024),
(5, 2, 110, 'Tue/Thu 2:00 PM - 3:30 PM', 10, 'Spring', 2025),
(6, 1, 111, 'Mon/Wed 10:00 AM - 11:30 AM', 11, 'Fall', 2024),
(6, 2, 112, 'Tue/Thu 10:00 AM - 11:30 AM', 12, 'Spring', 2025),
(7, 1, 113, 'Mon/Wed/Fri 1:00 PM - 2:00 PM', 13, 'Fall', 2024),
(7, 2, 114, 'Tue/Thu 11:30 AM - 1:00 PM', 14, 'Spring', 2025),
(8, 1, 115, 'Mon/Wed 2:30 PM - 4:00 PM', 15, 'Fall', 2024),
(8, 2, 116, 'Tue/Thu 4:00 PM - 5:30 PM', 16, 'Spring', 2025),
(9, 1, 117, 'Mon/Wed/Fri 10:00 AM - 11:00 AM', 17, 'Fall', 2024),
(9, 2, 118, 'Tue/Thu 9:00 AM - 10:30 AM', 18, 'Spring', 2025),
(10, 1, 119, 'Mon/Wed/Fri 11:00 AM - 12:00 PM', 19, 'Fall', 2024),
(10, 2, 120, 'Tue/Thu 1:30 PM - 3:00 PM', 20, 'Spring', 2025),
(11, 1, 121, 'Mon/Wed 1:30 PM - 3:00 PM', 1, 'Fall', 2024),
(11, 2, 122, 'Tue/Thu 10:00 AM - 11:30 AM', 2, 'Spring', 2025),
(12, 1, 123, 'Mon/Wed/Fri 2:00 PM - 3:00 PM', 3, 'Fall', 2024),
(12, 2, 124, 'Tue/Thu 2:30 PM - 4:00 PM', 4, 'Spring', 2025),
(13, 1, 125, 'Mon/Wed 4:00 PM - 5:30 PM', 5, 'Fall', 2024),
(13, 2, 126, 'Tue/Thu 1:00 PM - 2:30 PM', 6, 'Spring', 2025),
(14, 1, 127, 'Mon/Wed 9:30 AM - 11:00 AM', 7, 'Fall', 2024),
(14, 2, 128, 'Tue/Thu 11:00 AM - 12:30 PM', 8, 'Spring', 2025),
(15, 1, 129, 'Mon/Wed/Fri 10:00 AM - 11:00 AM', 9, 'Fall', 2024),
(15, 2, 130, 'Tue/Thu 9:30 AM - 11:00 AM', 10, 'Spring', 2025),
(16, 1, 131, 'Mon/Wed 3:30 PM - 5:00 PM', 11, 'Fall', 2024),
(16, 2, 132, 'Tue/Thu 2:00 PM - 3:30 PM', 12, 'Spring', 2025),
(17, 1, 133, 'Mon/Wed/Fri 9:00 AM - 10:00 AM', 13, 'Fall', 2024),
(17, 2, 134, 'Tue/Thu 10:30 AM - 12:00 PM', 14, 'Spring', 2025),
(18, 1, 135, 'Mon/Wed/Fri 1:00 PM - 2:00 PM', 15, 'Fall', 2024),
(18, 2, 136, 'Tue/Thu 2:30 PM - 4:00 PM', 16, 'Spring', 2025),
(19, 1, 137, 'Mon/Wed 11:00 AM - 12:30 PM', 17, 'Fall', 2024),
(19, 2, 138, 'Tue/Thu 9:00 AM - 10:30 AM', 18, 'Spring', 2025),
(20, 1, 139, 'Mon/Wed/Fri 10:30 AM - 11:30 AM', 19, 'Fall', 2024),
(20, 2, 140, 'Tue/Thu 1:00 PM - 2:30 PM', 20, 'Spring', 2025);

select * from course_section;

#--8 INSERTING RECORDS INTO DEPARTMENT --#
INSERT INTO department (department_id, d_name, office_locaton, phone, se_emplid, cf_emplid) VALUES
(1, 'Computer Science', 'Building A', '1234567890', 1, 13),
(2, 'Engineering', 'Building B', '2345678901', 2, 14),
(3, 'Physics', 'Building C', '3456789012', 3, 15),
(4, 'Biology', 'Building D', '4567890123', 4, 16),
(5, 'Chemistry', 'Building E', '5678901234', 5, 17),
(6, 'Mathematics', 'Building F', '6789012345', 6, 18),
(7, 'Economics', 'Building G', '7890123456', 7, 8);

select * from department;
delete from department;
-- drop table department;

#--9 INSERTING INTO ADVISES --#
INSERT INTO advises (fe_emplid, major_name) VALUES
(1, 'Computer Science'),
(2, 'Engineering'),
(3, 'Physics'),
(4, 'Biology'),
(5, 'Chemistry'),
(13, 'Mathematics'),
(14, 'Economics'),
(15, 'English'),
(16, 'History'),
(17, 'Psychology'),
(18, 'Sociology');

select * from advises order by fe_emplid;

#--10 INSERTING RECORDS INTO MANDATORY_COURSES --#
INSERT INTO mandatory_courses (major_name, course_id) VALUES
('Computer Science', 1),
('Computer Science', 2),
('Computer Science', 3),
('Computer Science', 4),
('Computer Science', 5),
('Computer Science', 6),
('Electrical Engineering', 7),
('Electrical Engineering', 8),
('Electrical Engineering', 9),
('Electrical Engineering', 10),
('Electrical Engineering', 11),
('Physics', 12),
('Physics', 13),
('Physics', 14),
('Biology', 15),
('Biology', 16),
('Chemistry', 17),
('Chemistry', 18),
('Mathematics', 19),
('Mathematics', 20);

select * from mandatory_courses;

#--11 INSERTING RECORDS INTO requerements_courses --#
INSERT INTO requerements_courses (major_name, course_id) VALUES
('Computer Science', 1),
('Computer Science', 2),
('Computer Science', 3),
('Computer Science', 4),
('Electrical Engineering', 5),
('Electrical Engineering', 6),
('Electrical Engineering', 7),
('Physics', 8),
('Physics', 9),
('Physics', 10),
('Biology', 11),
('Biology', 12),
('Biology', 13),
('Chemistry', 14),
('Chemistry', 15),
('Chemistry', 16),
('Mathematics', 17),
('Mathematics', 18),
('Mathematics', 19),
('Mathematics', 20);

select * from requerements_courses;

#--12 INSERTING RECORDS INTO ellective_courses --#
INSERT INTO ellective_courses (major_name, course_id) VALUES
('Computer Science', 17),
('Computer Science', 18),
('Computer Science', 19),
('Electrical Engineering', 20),
('Electrical Engineering', 19),
('Electrical Engineering', 18),
('Physics', 17),
('Physics', 18),
('Physics', 19),
('Biology', 14),
('Biology', 15),
('Biology', 16),
('Chemistry', 11),
('Chemistry', 12),
('Chemistry', 13),
('Mathematics', 8),
('Mathematics', 9),
('Mathematics', 10);

select * from ellective_courses;

#--13 INSERTING RECORDS INTO HONORS --#
INSERT INTO honors (s_emplid, honor) VALUES
(1, 'Dean''s List'),
(1, 'Scholarship Award'),
(2, 'President''s Award'),
(3, 'Honors Society'),
(4, 'Excellence in Research'),
(5, 'Outstanding Leadership'),
(6, 'Community Service Award'),
(7, 'Best Thesis Award'),
(8, 'Research Fellowship'),
(9, 'Leadership Award'),
(10, 'Excellence in Teaching'),
(11, 'Academic Achievement Award'),
(12, 'Service Learning Award'),
(13, 'Innovation Award'),
(14, 'Public Speaking Award'),
(15, 'Creative Writing Award'),
(16, 'Athletic Achievement Award'),
(17, 'Volunteer of the Year'),
(18, 'Diversity Champion'),
(19, 'Environmental Stewardship Award'),
(20, 'Entrepreneurship Award'),
(21, 'Artistic Excellence Award'),
(22, 'Musician of the Year'),
(23, 'Dance Achievement Award'),
(24, 'Theater Excellence Award'),
(25, 'Film Making Award'),
(26, 'Photography Award'),
(27, 'Graphic Design Award'),
(28, 'Fashion Design Award'),
(29, 'Culinary Arts Award'),
(30, 'Engineering Achievement Award'),
(1, 'Student Ambassador Award'),
(2, 'Global Citizenship Award'),
(3, 'Community Engagement Award'),
(4, 'STEM Innovator Award'),
(5, 'Digital Marketing Award'),
(6, 'Financial Literacy Award'),
(7, 'Health and Wellness Award');

select * from honors;
delete from honors;

#--14 INSERTING RECORDS INTO majors_in --#
INSERT INTO majors_in (major_name, s_emplid) VALUES
('Computer Science', 101),
('Computer Science', 102),
('Computer Science', 103),
('Computer Science', 104),
('Computer Science', 105),
('Electrical Engineering', 106),
('Electrical Engineering', 107),
('Electrical Engineering', 108),
('Electrical Engineering', 109),
('Physics', 110),
('Physics', 111),
('Physics', 112),
('Biology', 113),
('Biology', 114),
('Chemistry', 115),
('Chemistry', 116),
('Mathematics', 117),
('Mathematics', 118),
('Computer Science', 119),
('Computer Science', 120),
('Computer Science', 121),
('Electrical Engineering', 122),
('Electrical Engineering', 123),
('Electrical Engineering', 124),
('Physics', 125),
('Biology', 126),
('Chemistry', 127),
('Mathematics', 128),
('Mathematics', 129),
('Mathematics', 130);

select * from majors_in;

#--15 INSERTING RECORDS INTO MAJOR --#
INSERT INTO major (major_name, major_description, type_of_degree, number_of_credits_to_graduate) VALUES
('Computer Science', 'Study of computers and computational systems', 'Bachelor', 120),
('Electrical Engineering', 'Study of electrical systems and devices', 'Bachelor', 130),
('Physics', 'Study of matter, energy, space, and time', 'Bachelor', 120),
('Biology', 'Study of living organisms and their interactions', 'Bachelor', 125),
('Chemistry', 'Study of the composition, structure, properties, and reactions of matter', 'Bachelor', 128),
('Mathematics', 'Study of numbers, quantities, and shapes', 'Bachelor', 122);

SELECT * FROM MAJOR;

#--16 INSERTING RECORDS INTO employment_record --#
INSERT INTO employment_record (s_emplid, employer_id, job_title, start_date, end_date) VALUES
(101, 1, 'Software Engineer Intern', '2023-06-15', '2023-12-15'),
(102, 2, 'Financial Analyst', '2022-08-20', '2023-05-20'),
(103, 3, 'Manufacturing Engineer', '2023-02-10', '2023-10-10'),
(104, 4, 'Product Manager', '2023-04-05', '2024-01-05'),
(105, 5, 'Bank Teller', '2022-11-01', '2023-08-01'),
(106, 6, 'Pharmaceutical Researcher', '2023-07-15', '2024-03-15'),
(107, 7, 'Renewable Energy Technician', '2023-09-20', '2024-04-20'),
(108, 8, 'Retail Sales Associate', '2023-01-10', '2023-09-10'),
(109, 9, 'Data Analyst', '2022-10-05', '2023-06-05'),
(110, 10, 'Construction Manager', '2023-03-01', '2023-11-01');

select * from employment_record;

#--17 INSERTING RECORDS INTO enroled --#
INSERT INTO enroled (course_id, section_id, s_emplid, grade_earned) VALUES
(1, 1, 11, 'A'),
(2, 2, 12, 'B'),
(3, 3, 13, 'C'),
(4, 4, 14, 'B'),
(5, 5, 15, 'A'),
(6, 6, 16, 'B'),
(7, 7, 17, 'C'),
(8, 8, 18, 'A'),
(9, 9, 19, 'B'),
(10, 10, 20, 'C'),
(11, 11, 21, 'A'),
(12, 12, 22, 'B'),
(13, 13, 23, 'C'),
(14, 14, 24, 'A'),
(15, 15, 25, 'B'),
(16, 16, 26, 'C'),
(17, 17, 27, 'A'),
(18, 18, 28, 'B'),
(19, 19, 29, 'C'),
(20, 20, 30, 'A');
INSERT INTO enroled (course_id, section_id, s_emplid, grade_earned) VALUES
(1, 1, 16, 'B'),
(1, 2, 16, 'A'),
(2, 1, 16, 'B'),
(2, 2, 16, 'C');

select * from enroled;

#--18 INSERTING RECORDS INTO cheating_incident --#
INSERT INTO cheating_incident (course_id, section_id, s_emplid, cheating_incident_date, cheating_incident_description, resolution) VALUES
(1, 1, 11, '2024-03-15', 'Copying from another student', 'Warning Issued'),
(2, 2, 12, '2024-04-01', 'Plagiarism in assignment', 'Probation'),
(3, 3, 13, '2024-02-20', 'Using unauthorized materials during exam', 'Expulsion'),
(4, 4, 14, '2024-05-10', 'Collaborating on take-home quiz', 'Community Service');

select * from cheating_incident;

#--19 INSERTING RECORDS INTO alumnus --#
INSERT INTO alumnus (s_emplid, graduation_year, degree_earned) VALUES
(1, 2020, 'Bachelor of Science'),
(2, 2019, 'Bachelor of Engineering'),
(3, 2021, 'Bachelor of Arts'),
(4, 2018, 'Bachelor of Science'),
(5, 2022, 'Bachelor of Arts'),
(6, 2023, 'Bachelor of Engineering'),
(7, 2020, 'Bachelor of Science'),
(8, 2019, 'Bachelor of Engineering'),
(9, 2021, 'Bachelor of Science'),
(10, 2022, 'Bachelor of Arts');

select * from alumnus;

#--20 INSERTING RECORDS INTO STUDENT --#
INSERT INTO student (s_emplid, fname, minit, lname, dob, phone, email, appt, building, street, city, country, zip) VALUES
(1, 'Michael', 'A', 'Johnson', '2000-05-15', '1234567890', 'michael@student.com', 'Apt 1', 'Student Building', 'Park Ave', 'City X', 'Country X', '12345'),
(2, 'Emily', 'B', 'Brown', '2001-07-20', '2345678981', 'emily@student.com', 'Apt 2', 'Student Residence', 'Elm St', 'City Y', 'Country Y', '23456'),
(3, 'Daniel', 'C', 'Anderson', '2000-12-10', '3456789712', 'daniel@student.com', 'Apt 3', 'Student House', 'Walnut St', 'City Z', 'Country Z', '34567'),
(4, 'Olivia', 'D', 'Garcia', '2001-03-25', '4567880123', 'olivia@student.com', 'Apt 4', 'Student Dormitory', 'Birch St', 'City W', 'Country W', '45678'),
(5, 'William', 'E', 'Lopez', '2000-09-05', '5678911234', 'william@student.com', 'Apt 5', 'Student Complex', 'Sycamore St', 'City V', 'Country V', '56789'),
(6, 'Ava', 'F', 'Hernandez', '2001-01-30', '6789512345', 'ava@student.com', 'Apt 6', 'Student Lodge', 'Chestnut St', 'City U', 'Country U', '67890'),
(7, 'James', 'G', 'Clark', '2000-08-12', '7891123456', 'james@student.com', 'Apt 7', 'Student Apartments', 'Cherry St', 'City T', 'Country T', '78901'),
(8, 'Sophia', 'H', 'Young', '2001-02-18', '8901234467', 'sophia@student.com', 'Apt 8', 'Student Tower', 'Apple St', 'City S', 'Country S', '89012'),
(9, 'Benjamin', 'I', 'King', '2000-06-22', '9912345678', 'benjamin@student.com', 'Apt 9', 'Student Residence Hall', 'Pear St', 'City R', 'Country R', '90123'),
(10, 'Charlotte', 'J', 'Wright', '2001-04-08', '2123456789', 'charlotte@student.com', 'Apt 10', 'Student House', 'Plum St', 'City Q', 'Country Q', '01234'),
(11, 'Henry', 'K', 'Adams', '2000-10-17', '1234567899', 'henry@student.com', 'Apt 11', 'Student Building', 'Waterlemon St', 'City P', 'Country P', '12345'),
(12, 'Emma', 'L', 'Lewis', '2001-11-03', '2345678901', 'emma@student.com', 'Apt 12', 'Student Residence', 'Maple St', 'City O', 'Country O', '23456'),
(13, 'David', 'M', 'Hall', '2000-07-29', '3456789012', 'david@student.com', 'Apt 13', 'Student House', 'Oak St', 'City N', 'Country N', '34567'),
(14, 'Isabella', 'N', 'Scott', '2001-12-14', '4567890123', 'isabella@student.com', 'Apt 14', 'Student Dormitory', 'Pine St', 'City M', 'Country M', '45678'),
(15, 'Lucas', 'O', 'Green', '2000-05-03', '5678991234', 'lucas@student.com', 'Apt 15', 'Student Complex', 'Cedar St', 'City L', 'Country L', '56789'),
(16, 'Mia', 'P', 'Robinson', '2001-08-19', '6781012345', 'mia@student.com', 'Apt 16', 'Student Lodge', 'Beech St', 'City K', 'Country K', '67890'),
(17, 'Ethan', 'Q', 'Evans', '2000-11-11', '7990123456', 'ethan@student.com', 'Apt 17', 'Student Apartments', 'Poplar St', 'City J', 'Country J', '78901'),
(18, 'Liam', 'R', 'Nelson', '2001-01-07', '8971234567', 'liam@student.com', 'Apt 18', 'Student Tower', 'Palm St', 'City I', 'Country I', '89012'),
(19, 'Amelia', 'S', 'Carter', '2000-09-14', '9712345658', 'amelia@student.com', 'Apt 19', 'Student Residence Hall', 'Hickory St', 'City H', 'Country H', '90123'),
(20, 'Harper', 'T', 'Baker', '2001-02-23', '1012345678', 'harper@student.com', 'Apt 20', 'Student House', 'Birch St', 'City G', 'Country G', '01234'),
(21, 'Evelyn', 'U', 'Rivera', '2000-06-07', '1234577892', 'evelyn@student.com', 'Apt 21', 'Student Building', 'Sycamore St', 'City F', 'Country F', '12345'),
(22, 'Alexander', 'V', 'Long', '2001-10-26', '2345878901', 'alexander@student.com', 'Apt 22', 'Student Residence', 'Chestnut St', 'City E', 'Country E', '23456'),
(23, 'Ella', 'W', 'Gonzalez', '2000-08-02', '3446789012', 'ella@student.com', 'Apt 23', 'Student House', 'Cherry St', 'City D', 'Country D', '34567'),
(24, 'Sebastian', 'X', 'Scott', '2001-03-11', '4967890123', 'sebastian@student.com', 'Apt 24', 'Student Dormitory', 'Apple St', 'City C', 'Country C', '45678'),
(25, 'Avery', 'Y', 'Young', '2000-07-14', '5678901234', 'avery@student.com', 'Apt 25', 'Student Complex', 'Oak St', 'City B', 'Country B', '56789'),
(26, 'Mason', 'Z', 'Griffin', '2001-12-31', '6789012345', 'mason@student.com', 'Apt 26', 'Student Lodge', 'Beech St', 'City A', 'Country A', '67890'),
(27, 'Sophie', 'AA', 'Stewart', '2000-08-27', '7890123456', 'sophie@student.com', 'Apt 27', 'Student Apartments', 'Poplar St', 'City Z', 'Country Z', '78901'),
(28, 'Jackson', 'BB', 'Bell', '2001-01-13', '8901234567', 'jackson@student.com', 'Apt 28', 'Student Tower', 'Palm St', 'City Y', 'Country Y', '89012'),
(29, 'Chloe', 'CC', 'Howard', '2000-05-25', '9012345678', 'chloe@student.com', 'Apt 29', 'Student Residence Hall', 'Hickory St', 'City X', 'Country X', '90123'),
(30, 'Daniel', 'DD', 'Gray', '2001-10-11', '0123456789', 'danielg@student.com', 'Apt 30', 'Student House', 'Birch St', 'City W', 'Country W', '01234');

select * from student;
delete from student;

#--21 INSERTING RECORDS INTO employer --#
INSERT INTO employer (employer_id, employer_name, industry, building, street, city, country, zip) VALUES
(1, 'ABC Corporation', 'Technology', 'Building A', 'Main Street', 'Tech City', 'Digital Land', '12345'),
(2, 'XYZ Enterprises', 'Finance', 'Tower B', 'Finance Avenue', 'Banktown', 'Moneyland', '54321'),
(3, 'Acme Inc.', 'Manufacturing', 'Factory C', 'Industrial Road', 'Manufactureville', 'Productopia', '67890'),
(4, 'Tech Innovators Ltd.', 'Technology', 'Innovation Center', 'Tech Street', 'Innovatetown', 'Techland', '98765'),
(5, 'Global Bank', 'Finance', 'Bank Building', 'Financial Boulevard', 'Money City', 'World Bankia', '13579'),
(6, 'Pharma Solutions', 'Healthcare', 'Pharma Tower', 'Medicine Street', 'Healthcare City', 'Medica', '24680'),
(7, 'Green Energy Corp.', 'Energy', 'Green Tower', 'Renewable Avenue', 'Eco City', 'Greenland', '97531'),
(8, 'Retail Giants Inc.', 'Retail', 'Retail Hub', 'Market Street', 'Shopping City', 'Shopville', '86420'),
(9, 'Data Analytics Group', 'Technology', 'Data Center', 'Analytics Avenue', 'Data City', 'Datania', '75319'),
(10, 'Construction Solutions', 'Construction', 'Construction HQ', 'Building Road', 'Construction City', 'Constructia', '36982'),
(11, 'BioTech Innovations', 'Biotechnology', 'BioTech Center', 'Science Street', 'Bio City', 'Biotechia', '48273'),
(12, 'Logistics Experts Ltd.', 'Logistics', 'Logistics Hub', 'Transport Road', 'Logistics City', 'Logistiland', '27148'),
(13, 'Education Systems Inc.', 'Education', 'Education Center', 'Learning Lane', 'Education City', 'Educa', '61724'),
(14, 'Media Group Ltd.', 'Media', 'Media House', 'Media Street', 'Media City', 'Medialand', '82476'),
(15, 'Consulting Partners LLC', 'Consulting', 'Consulting Center', 'Advice Avenue', 'Consulting City', 'Consultia', '93725');

select * from employer;

#-----------------------------------------------QUERIES-------------------------------------------------#
/*
3. Write simple select statements that retrieve records from the tables without any condition. (1 Select statement per table) 
*/
#-- *********** There are " select * " statements after each data entry ************** --#

/*
4. Write 1 simple select statement that retrieves records from all the tables using some simple condition. 
(1 Select statement per table)
*/

#--1--#
select fname, minit, lname from employee
where fname like ('%a%') and lname like '%m%';

#--2--#
select * from staff where se_emplid = 12 or se_emplid = 11 or se_emplid = 10;

#--3--#
select * from faculty where f_rank = 'Professor';

#--4--#
select * from areas_of_teaching_interests where area_of_teaching_interest = 'Algebra' order by fe_emplid;

#--5--#
select * from areas_of_research_interests where area_of_research_interest like '%History%' order by fe_emplid;

#--6--#
select * from course where course_code > 400 and course_code < 800;

#--7--#
select * from course_section where course_secton_schedule like 'Mon/Wed/Fri%';

#--8--#
select * from department where d_name = 'Computer Science';

#--9--#
select * from advises where fe_emplid > 2 and fe_emplid < 10 order by fe_emplid;

#--10--#
select * from mandatory_courses where major_name = 'Physics';

#--11--#
select * from requerements_courses where course_id > 3 and course_id < 9;

#--12--#
select * from ellective_courses where major_name = 'Biology';

#--13--#
select * from honors where s_emplid > 101 and s_emplid < 111;

#--14--#
select * from majors_in where major_name = 'Electrical Engineering';

#--15--#
SELECT * FROM MAJOR where number_of_credits_to_graduate > 123 and number_of_credits_to_graduate < 130;

#--16--#
select * from employment_record where job_title like '% % %';

#--17--#
select * from enroled where grade_earned = 'C';

#--18--#
select * from cheating_incident where cheating_incident_date > '2024-02-20' and cheating_incident_date < '2024-04-01';

#--19--#
select * from alumnus where degree_earned = 'Bachelor of Science';

#--20--#
select * from student where minit like '%a';

#--21--#
select * from employer where industry = 'Technology';

/*
5. Write 3 advanced select statements that select data from two or more of your tables. 
You can use exists, and, join etc.
*/

#--1--#
select employee.fname, employee.minit, employee.lname from employee, faculty 
where e_emplid = fe_emplid
	and fe_emplid = (select tf_emplid from course_section where course_id = 1 and section_id = 2);
    
#--2--#
select employee.fname, employee.minit, employee.lname from employee, faculty, advises, major
where e_emplid = faculty.fe_emplid
	and faculty.fe_emplid = advises.fe_emplid 
    and advises.major_name = major.major_name
    and major.major_name = 'Computer Science';
    
#--3--#
select honor from honors, student, alumnus
where	 honors.s_emplid = alumnus.s_emplid 
	 and alumnus.s_emplid = student.s_emplid 
	 and student.fname = 'Ava' 
	 and student.minit =  'F' 
	 and student.lname = 'Hernandez';

/*
6. Write a query that retrieves students who have all A letter grades.
*/
select * from student, enroled
where student.s_emplid = enroled.s_emplid and grade_earned = 'A';

/*
7. Write a query to retrieve the names of students who have not taken more than 5 courses.
*/
SELECT s.fname, s.minit, s.lname
FROM student s
JOIN (
    SELECT s_emplid, COUNT(*) AS num_courses
    FROM enroled
    GROUP BY s_emplid
    HAVING COUNT(*) > 5
) AS course_counts ON s.s_emplid = course_counts.s_emplid;
# --in our database there are no students that are taking more than 5 courses, --#
# --but we can try to find the names of students that are taking more than 1 course --#

select s.fname, s.minit, s.lname
from student s
join (
    select s_emplid, COUNT(*) AS num_courses
    from enroled
    group by s_emplid
    having COUNT(*) >= 2
) as course_counts on s.s_emplid = course_counts.s_emplid;

/*
8. Write 6 update statements that update certain records based on some conditions
*/

#--1--#
update employee
set minit = 'Z' where e_emplid = 15;
select * from employee;

#--2--#
update student
set fname = 'Alaska' where s_emplid = 4;
select * from student;

#--3--#
update employer
set employer_name = 'Geminini' where employer_id = 3;
select * from employer;

#--4--#
update alumnus
set graduation_year = 2026 where s_emplid = 2;
select * from alumnus;

#--5--#
update course
set hours = 2.5 where course_id = 1;
select * from course;

#--6--#
update department 
set office_locaton = 'Nowhere' where department_id = 7;
select * from department;

/*
9. Write 3 statements that delete a record from a table based on some condition.
*/

#--1--#
delete  from employee where e_emplid = 1;
select * from employee;

#--2--#
delete from student where s_emplid = 2;
select * from student;

#--3--#
delete from employer where employer_id = 3;
select * from employer;

/*
10. Write a query to retrieve the names of students who were caught cheating in at least one course.
*/
select distinct fname, minit, lname, resolution, cheating_incident_description from student, cheating_incident
where student.s_emplid = cheating_incident.s_emplid;

/*
11. Write a query to retrieve the names of instructors who have reported most cheating incidents.
*/
select e.fname, e.minit, e.lname
from employee e
join faculty f on e.e_emplid = f.fe_emplid
join course_section cs on f.fe_emplid = cs.tf_emplid
join cheating_incident c on cs.course_id = c.course_id
                         and cs.section_id = c.section_id
group by e.fname, e.minit, e.lname
order by COUNT(*) desc;

/*
12. Write a query to retrieve the names of instructors who have never reported any cheating incidents.
*/
select e.fname, e.minit, e.lname
from employee e
join faculty f on e.e_emplid = f.fe_emplid
left join course_section cs on f.fe_emplid = cs.tf_emplid
left join cheating_incident c on cs.course_id = c.course_id
                               and cs.section_id = c.section_id
where c.course_id is null
group by e.fname, e.minit, e.lname;

/*
13. Write a query to retrieve the name of the most recently hired instructor.
*/
select fname, minit, lname
from employee
where e_emplid in (
    select fe_emplid
    from faculty
)
order by date_of_hire desc;

