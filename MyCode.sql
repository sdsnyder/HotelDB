-- Sebastian Snyder

--Function/Procedure 1


--before script;
select * from Reservation;
--6. Make a reservation: Input parameters:Hotel ID , guest’s name, start date, end date, room type, date of reservation, etc. X
--Output: reservation ID (this is called confirmation code in real-life). X
--NOTE: Only one guest per reservation. However, the same guest can make multiple reservations. X
--Also, make sure that there is availability of that room type before a reservation is made.


--function script;
create or replace function customerCheck (cfname_in varchar, clname_in varchar)
return number
AS
cid_out number;   
BEGIN 
select customer_ID into cid_out -- puts existing customer ID value into cid_out 
from Customer 
where c_first_name = cfname_in AND c_last_name = clname_in; -- checks for matching customer name betweeen Customer table and input parameters
return cid_out; -- returns matching customer ID 
exception
  when no_data_found then -- if a matching customer is not found then, 
	insert into Customer values (CUSTOMER_ID_SEQ.nextval, cfname_in, clname_in, 'unknown', 'unknown', 'unknown', 'unknown', 'unknown', 'unknown'); -- creates a new customer record to assign a customer ID and store their name
	select customer_ID into cid_out -- puts existing customer ID value into cid_out 
	from Customer 
	where c_first_name = cfname_in AND c_last_name = clname_in;
	return cid_out; 
  when others then
	dbms_output.put_line('An unexpected error has occured!'); -- if something goes horribly wrong 
end;

-- procedure script
create or replace procedure makeReservation (hid_in number, cfname_in varchar, clname_in varchar, srtd_in date, endd_in date, rmt_in varchar, resdate_in date)
is 
c_code number; -- creates var to store new reservation id/confirmation code
cid customer.customer_ID%type; --creates var to store return variable from customerCheck function
rmCheck varchar(256); --creates var to easily compare values of the room status for If/Else statements 
begin
select COUNT(*) into rmCheck --looks for room status
from room
where rm_room_Type = rmt_in AND rm_status_IsActive = 'NO'; -- specifies which room type to check status of based on input parameter 
if rmCheck <= 0 then -- if the room type requested is not available, the customer is informed via the following message:
	dbms_output.put_line('Sorry, this room is not available.');
else -- if the room status is not active then:
	cid:= customerCheck(cfname_in, clname_in); -- the customer check function is run and stored in the variable 'cid'
  	insert into Reservation values (RESV_ID_SEQ.nextval, cid, hid_in, resdate_in, srtd_in, endd_in, null, null, null); --creates a new reservation record based on next reservation ID in the sequence, customer ID from customerCheck, and remaining input parameters
  	select resv_id into c_code -- stores new resv_ID in var for output
  	from Reservation
  	where r_customer_ID = cid AND r_Hotel_ID = hid_in AND r_Reserv_Date = resdate_in AND r_reserv_start_Date = srtd_in AND r_reserv_end_Date = endd_in;--comparators to ensure proper resv_ID is selected 
  --	UPDATE room 
	--SET rm_resv_id = c_code
--	WHERE rmt_in = room.rm_room_Type AND hid_in = room.rm_Hotel_ID;
--	dbms_output.put_line('Your reservation ID/ confirmation code is: ' || c_code); --final output 
end if;
exception
  when others then
	dbms_output.put_line('your reservation could not be created at this time. We apologize for the inconvienence');
end;


--calling #6
set serveroutput on; 
execute makeReservation(10,'Kei','Sanbe', TO_DATE('21-DEC-20','DD-MON-RR'), TO_DATE('31-DEC-20','DD-MON-RR'), 'double', TO_DATE('01-DEC-20','DD-MON-RR'));


--Function/Procedure 2


-- Before script;
select * from reservation;
-- 7. Find a reservation: Input is guest’s name and date, and hotel ID. Output is reservation ID
--Function script
create or replace function findReservation (fname_in varchar, lname_in varchar, rdate_in date, hid_in number) -- takes in customer name, reserved check-in date and hotel id;
return number is resid_out reservation.resv_id%type; -- creates return variable the same type as Reservation ID 
BEGIN
SELECT resv_id 
into resid_out -- Places Reservation ID into return variable 
from reservation, customer
where r_hotel_id = hid_in AND r_check_in_date = rdate_in AND customer.c_last_name = lname_in AND customer.c_first_name = fname_in; -- compares input parameters to existing table values to find the matching reservation ID;
return resid_out; -- returns matching reservation ID;
exception
  when no_data_found then
    dbms_output.put_line('We were unable to find a reservation with the records provided');
end;


--calling function;
set serveroutput on;
DECLARE
r number; -- declares variable to store function output;
BEGIN
r := findReservation('Kathy','Reynolds',TO_DATE('23-JAN-21','DD-MON-RR'),12); -- calls function and stores output in r;
dbms_output.put_line ('The reservation ID is ' || r);
END;


--Function/Procedure 3


-- Before script;
select * from reservation;

--Sebastian Snyder
--8. Cancel a reservation: Input the reservationID and mark the reservation as cancelled (do NOT delete it)
--Procedure script
create or replace procedure cancelReservation (resid_in number) --procedure takes in a reservation ID number;
is
begin
  update Reservation -- Updates reservation table;
     set r_isCancelled= 'YES' -- sets cancellation status to YES;
   where Reservation.Resv_ID = resid_in; -- Finds where input parameter matches table value and accordingly updates the cancellation status;
exception
  when no_data_found then
    dbms_output.put_line('A reservation with that ID was not found in our system.');
end;

--Procedure execution;
set serveroutput on;
execute cancelReservation(130); --executes procedure for reservation ID 130;

--after script;
select * from reservation; 


--Function/Procedure 4


--ShowCancelations: Print all canceled reservations in the hotel management system. Show reservation ID, hotel name, location, guest name, room type, dates

-- before script; 
select * from Reservation; 

--Sebastian Snyder (ShowCancelations: Print all canceled reservations in the hotel management system. Show reservation ID, hotel name, location, guest name, room type, dates)
create or replace procedure showCancelations
is 
cursor cancelations IS 
SELECT Resv_ID,       r_reserv_start_Date, r_reserv_end_Date, h_name,    h_zip_code, c_first_name, c_last_name, rm_room_Type
from Reservation, Hotel_Branch, Customer, Room 
where Reservation.r_isCancelled = 'YES' AND Reservation.r_Hotel_ID = Hotel_Branch.Hotel_ID AND Reservation.r_customer_ID = Customer.Customer_ID AND Room.rm_Resv_ID = Reservation.Resv_ID; -- selects all the specified table values where the reservation is cancelled
Reservation_ID NUMBER; -- from :
startd DATE;
rend DATE;
hotelname varchar(30);
hotelzip varchar(10);
cfirst varchar(30);
clast varchar(30);
roomt varchar(30); -- to :variables to store individual values ^
reportline varchar(256); -- variables to store output line 
begin 
open cancelations;
dbms_output.put_line('Reservation_ID, start Date, end Date, hotel name, hotelzip, customer first name, customer last name, room type');
loop -- loops for each occurance of a cancelation and outputs the specified values 
  FETCH cancelations INTO Reservation_ID, startd, rend, hotelname, hotelzip, cfirst, clast, roomt;
  exit when cancelations%notfound;
  reportline := Reservation_ID|| ' ' ||startd || ' ' ||rend ||' ' ||hotelname || ' ' || hotelzip ||' ' || cfirst ||' ' ||clast || ' ' ||roomt;
  dbms_output.put_line(reportline);
end loop;
close cancelations;
exception no_data_found then 
dbms_output.put_line("Unable to display results");
end; 

-- script used to call procedure
set serveroutput on;
execute showCancelations();


--SELECT Resv_ID,       r_reserv_start_Date, r_reserv_end_Date, h_name,    h_zip_code, c_first_name, c_last_name, rm_room_Type

--from Reservation, Hotel_Branch, Customer, Room 
--where Reservation.r_isCancelled = 'YES' AND Reservation.r_Hotel_ID = Hotel_Branch.Hotel_ID AND Reservation.r_customer_ID = Customer.Customer_ID AND Room.rm_Resv_ID = Reservation.Resv_ID; 
--INTO  Reservation_ID, start,               rend,              hotelname, hotelzip,   cfirst,       clast,       roomt
--end;
--create view showCancelationview AS 
--SELECT Resv_ID, r_reserv_start_Date, r_reserv_end_Date, h_name, h_zip_code, c_first_name, c_last_name, rm_room_Type
--from Reservation, Hotel_Branch, Customer, Room 
--where Reservation.r_isCancelled = 'YES' AND Reservation.r_Hotel_ID = Hotel_Branch.Hotel_ID AND Reservation.r_customer_ID = Customer.Customer_ID AND Room.rm_Resv_ID = Reservation.Resv_ID; 
--Rev1 
create or replace procedure showCancelations
declare 
begin
  select Resv_ID, r_reserv_start, r_reserv_end, h_name, h_zip_code, c_first_name, c_last_name, rm_room_Type -- Selects reservation ID, start and end dates, hotel name and location, guest name, and room type
  from Reservation, Hotel_Branch, Customer, Room -- from their respective tables 
  where Reservation.r_isCancelled = 'YES' AND Reservation.r_Hotel_ID = Hotel_Branch.Hotel_ID AND Reservation.r_customer_ID = Customer.Customer_ID AND Room.rm_Resv_ID = Reservation.Resv_ID; --only where the reservation status is cancelled and the cancelled reservation's information matches the input data
exception
  when no_data_found then
    dbms_output.put_line("No cancellations were found"); -- if none are selected, "No cancellations were found. "
end;

-- 2/1 PLS-00103: Encountered the symbol "DECLARE" when expecting one of the following: ( ; is with authid as cluster compress order using compiled wrapped external deterministic parallel_enable pipelined result_cache
-- 10/4 PLS-00103: Encountered the symbol "end-of-file" when expecting on e of the following: ( begin case declare end exception exit f or goto if loop mod null pragma raise return select update whi le with <an identifier> <a double-quoted delimited-identifier> <a bind variable> << continue close current delete fetch lock insert open rollback savepoint set sql execute commit forall merge pipe purge

--Rev2 
create or replace procedure showCancelations
as 
declare

begin

  select Resv_ID, r_reserv_start_Date, r_reserv_end_Date, h_name, h_zip_code, c_first_name, c_last_name, rm_room_Type INTO

  from Reservation, Hotel_Branch, Customer, Room 
  where Reservation.r_isCancelled = 'YES' AND Reservation.r_Hotel_ID = Hotel_Branch.Hotel_ID AND Reservation.r_customer_ID = Customer.Customer_ID AND Room.rm_Resv_ID = Reservation.Resv_ID; 
exception
  when no_data_found then
    dbms_output.put_line('No cancellations were found');
end;

--1/28 PLS-00103: Encountered the symbol ")" when expecting one of the f ollowing: <an identifier> <a double-quoted delimited-identifi er> current delete exists prior

