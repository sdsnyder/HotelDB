--Multi-script: 

set serveroutput on; 
--a
execute makeReservation(11, 'John', 'Smith', TO_DATE('01-AUG-21','DD-MON-RR'), TO_DATE('10-AUG-21','DD-MON-RR'), 'suite', TO_DATE('07-DEC-20','DD-MON-RR'));
--b
execute makeReservation(10, 'First', 'Last', TO_DATE('19-NOV-21','DD-MON-RR'), TO_DATE('28-NOV-21','DD-MON-RR'), 'single', TO_DATE('07-DEC-20','DD-MON-RR'));
--c
execute makeReservation(13, 'Arnold', 'Patterson', TO_DATE('01-JAN-21','DD-MON-RR'), TO_DATE('05-JAN-21','DD-MON-RR'), 'conference', TO_DATE('07-DEC-20','DD-MON-RR'));
--d
execute makeReservation(13, 'Arnold', 'Patterson', TO_DATE('01-JAN-21','DD-MON-RR'), TO_DATE('05-JAN-21','DD-MON-RR'), 'double', TO_DATE('07-DEC-20','DD-MON-RR'));
--e
DECLARE
r number;
BEGIN
r := findReservation('Arnold','Patterson',TO_DATE('07-DEC-20','DD-MON-RR'),13);
dbms_output.put_line ('The reservation ID is ' || r);
END;
--f
execute makeReservation(13, 'Mary', 'Wise', TO_DATE('10-JAN-21','DD-MON-RR'), TO_DATE('15-JAN-21','DD-MON-RR'), 'single', TO_DATE('07-DEC-20','DD-MON-RR'));
--g
execute makeReservation((13, 'Mary', 'Wise', TO_DATE('01-JAN-21','DD-MON-RR'), TO_DATE('05-JAN-21','DD-MON-RR'), 'double', TO_DATE('07-DEC-20','DD-MON-RR')););
--h
execute cancelReservation(insert output from part D here );
--i
execute cancelReservation(insert output from part A here );
--j
execute showCancelations();


--Single script 
--a
set serveroutput on; 
dbms_output.put_line('a.	Make a reservation at hotel H2 by John Smith from Aug 1 – Aug 10 for a suite'); 
execute makeReservation(11, 'John', 'Smith', TO_DATE('01-AUG-21','DD-MON-RR'), TO_DATE('10-AUG-21','DD-MON-RR'), 'suite', TO_DATE('07-DEC-20','DD-MON-RR'));

--b
set serveroutput on; 
dbms_output.put_line('b.	Make any reservation at hotel H1 (already sold – should print out appropriate msg)'); 
execute makeReservation(10, 'First', 'Last', TO_DATE('19-NOV-21','DD-MON-RR'), TO_DATE('28-NOV-21','DD-MON-RR'), 'single', TO_DATE('07-DEC-20','DD-MON-RR'));

--c
set serveroutput on; 
dbms_output.put_line('c.	Make a reservation by Arnold Patterson for conference hall at H4 from Jan 1 – Jan 5'); 
execute makeReservation(13, 'Arnold', 'Patterson', TO_DATE('01-JAN-21','DD-MON-RR'), TO_DATE('05-JAN-21','DD-MON-RR'), 'conference', TO_DATE('07-DEC-20','DD-MON-RR'));

--d
set serveroutput on; 
dbms_output.put_line('d.	Make a reservation by Arnold Patterson for double room at H4 from Jan 1 – Jan 5'); 
execute makeReservation(13, 'Arnold', 'Patterson', TO_DATE('01-JAN-21','DD-MON-RR'), TO_DATE('05-JAN-21','DD-MON-RR'), 'double', TO_DATE('07-DEC-20','DD-MON-RR'));

--e
set serveroutput on; 
dbms_output.put_line('e.	Find the reservation of Arnold Patterson'); 
DECLARE
r number;
BEGIN
r := findReservation('Arnold','Patterson',TO_DATE('07-DEC-20','DD-MON-RR'),13);
dbms_output.put_line ('The reservation ID is ' || r);
END;

--f
set serveroutput on; 
dbms_output.put_line('f.	Make a reservation by Mary Wise for single at H4 from Jan 10 – Jan 15'); 
execute makeReservation(13, 'Mary', 'Wise', TO_DATE('10-JAN-21','DD-MON-RR'), TO_DATE('15-JAN-21','DD-MON-RR'), 'single', TO_DATE('07-DEC-20','DD-MON-RR'));

--g
set serveroutput on; 
dbms_output.put_line('g.	Make a reservation by Mary Wise for a double at H4 from Jan 1 – Jan 5'); 
execute makeReservation((13, 'Mary', 'Wise', TO_DATE('01-JAN-21','DD-MON-RR'), TO_DATE('05-JAN-21','DD-MON-RR'), 'double', TO_DATE('07-DEC-20','DD-MON-RR'));

 --h
set serveroutput on;
dbms_output.put_line('h.	Cancel reservation of Arnold Patterson for double room'); 
execute cancelReservation(insert output from part D here );

 --i
set serveroutput on;
dbms_output.put_line('i.	Cancel reservation of John Smith'); 
execute cancelReservation(insert output from part A here );

--j
set serveroutput on; 
dbms_output.put_line('j.	Show cancelations'); 
execute showCancelations();

