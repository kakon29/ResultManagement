drop table results;
drop table student;
drop table course;


create table student(
  roll number(7) NOT NULL,
  name varchar2(10) NOT NULL,
  department varchar2(10) NOT NULL,
  year integer NOT NULL
);


create table course(
course_id  varchar2(10) NOT NULL,
course_name varchar2(40),
year  number(1) NOT NULL,
term  number(1)
);

create table results(
c_roll number(7),
c_id varchar2(10),
cgpa number(3,2)
);




-- start using alter statement
   
   alter table student add primary key(name);
   alter table student drop primary key;
   alter table student add primary key(roll);
   alter table course  add primary key(course_id);
   alter table results add primary key(c_roll);
   alter table results add foreign key (c_roll) references student (roll) ON DELETE CASCADE;
   alter table results add foreign key (c_id) references course (course_id) ON DELETE CASCADE;
   alter table student add age number(7);
   alter table course modify year integer;

-- end using alter statement
   





-- start describing table

   describe student;
   describe course;
   describe results;

-- end describing table





-- start trigger using
   
   create or replace trigger check_year before insert on course
    for each row
      declare
         c_min constant integer := 1;
         c_max constant integer := 4;
      begin
          if :new.year > c_max OR :new.year < c_min THEN
          RAISE_APPLICATION_ERROR(-20000,'Year is invalid');
      end if;
      end check_year;
      /
 
-- end trigger using





-- start inserting data into tables

  insert into student values(1207001,'Aziz','CSE',1,21);
  insert into student values(1207002,'Masum','CSE',1,21);
  insert into student values(1207003,'Tanim','CSE',2,22);
  insert into student values(1207004,'Opu','CSE',2,22);
  insert into student values(1207005,'Golap','CSE',3,23);
  insert into student values(1207012,'Masba','CSE',3,23);


  insert into course values('CSE-1101','Computer Basics',1,1);
  insert into course values('CSE-1201','Object Oriented Programming',2,2);
  insert into course values('CSE-1207','Discrete Mathmatics',3,2);
  insert into course values('CSE-2101','Data Structures and Algorithms',4,1);
  insert into course values('CSE-2102','Digital Logic Design',2,1);
  insert into course values('CSE-3109','Database Systems',3,1);

  insert into results values(1207001,'CSE-1101',3.94);
  insert into results values(1207003,'CSE-1201',3.80);
  insert into results values(1207002,'CSE-1101',3.50);
  insert into results values(1207004,'CSE-2101',3.75);
  insert into results values(1207005,'CSE-1101',3.89);
  insert into results values(1207012,'CSE-3109',3.90);

-- end inserting data into tables
  




-- start showing data using select clause
   
   select * from student;
   select * from course;
   select * from results;
   select c_roll,c_id from results where  cgpa>3.50 and cgpa<3.90;

-- end showing data using select clause






-- start updating information

   update results set cgpa = 3.90 where c_roll = 1207002;
   update course set course_name = 'Computer Basics and Programming' where course_id = 'CSE-1101';

-- end updating information






-- start delete information
   
   delete from student where roll=1207012;
   delete from results where c_roll=1207005;

-- end delete information






-- start aggregate function using

   select max(cgpa) from results;
   select min(cgpa) from results;
   select sum(cgpa) from results;
   select avg(cgpa) from results;
   select c_roll,count(cgpa) from results group by c_roll;

-- end aggregate function using







-- start subquery using with select statement

   select s.roll,s.name from student s where s.roll IN (select r.c_roll from student s,results r where s.roll=r.c_roll);
   
   select roll,name from student where roll=1207001 UNION select s.roll,s.name from student s where s.roll IN (select         r.c_roll from student s,results r where s.roll=r.c_roll);
   
   select roll,name from student where roll=1207001 INTERSECT select s.roll,s.name from student s where s.roll IN (select     r.c_roll from student s,results r where s.roll=r.c_roll);

   select s.roll,s.name from student s where s.roll IN (select r.c_roll from student s,results r where  s.roll=r.c_roll)      MINUS select roll,name from student where roll=1207001;

-- end subquery using with select statement








-- start join operation
   
   select s.roll,c.course_name from student s inner join course c on s.year=c.year;
   select s.roll,c.course_name from student s left  outer join course c on s.year=c.year;
   select s.roll,c.course_name from student s right outer join course c on s.year=c.year;
   select s.roll,c.course_name from student s full outer join course c on s.year=c.year;

-- end join operation 








-- start pl/sql section
  
   set serveroutput on
   declare
      maximum_cgpa  results.cgpa%type;
   begin
      select max(cgpa) into maximum_cgpa from results;
      dbms_output.put_line('The maximum cgpa is : ' || maximum_cgpa);
  end;
/
-- end pl/sql section 







-- start cursor using
  
  declare
     s_id   student.roll%type;
     s_name student.name%type;
     s_dept student.department%type;
     s_year student.year%type;
     cursor s_student is select roll,name,department,year from student;

  begin
     open s_student;
     loop
       fetch s_student into s_id,s_name,s_dept,s_year;
       exit when s_student%notfound;
       dbms_output.put_line(s_id || ' ' || s_name || ' ' || s_dept || ' ' || s_year);
    end loop;
    close s_student;
  end;
  /
-- end cursor using







-- start procedure using
  
   set serveroutput on
   
   create or replace procedure showresult is 
   r_cgpa   results.cgpa%type;
   r_c_id   results.c_id%type;
   r_c_roll results.c_roll%type;

   begin
     r_cgpa:=3.94;
     select c_roll,c_id into r_c_roll,r_c_id from results where r_cgpa=results.cgpa;
     dbms_output.put_line(r_c_roll || ' ' || r_c_id);
   end;
   /
   show errors

  begin
     showresult;
  end;
  /

-- end procedure using










-- start function using return

   create or replace function avg_cgpacalculation return number is 
   avg_gpa   results.cgpa%type;
  
   begin
     select avg(cgpa) into avg_gpa from results;
     return avg_gpa;    
   end;
   /
   show errors
   
   set serveroutput on
   declare
     c number(3,2);
   begin
     c:=avg_cgpacalculation();
     dbms_output.put_line('Average cgpa: ' || c);
   end;
  /
           
-- end function using return








-- start rollback using
  
   select * from student;
   delete from student;
   rollback;
   select * from student;
   insert into student values(1207029,'kakon','CSE',1,21);
   savepoint  cont_7;
   insert into student values(1207028,'Tanmoy','CSE',2,21);
   savepoint  cont_8;
   rollback to cont_7;
   select * from student;

-- end rollback using
   

commit;




  
