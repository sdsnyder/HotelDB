
-- Sequence for Customer table 
create sequence CUSTOMER_ID_SEQ
start with 1
increment by 1;
 
-- Sequence for HotelBranch table 
create sequence HOTEL_ID_SEQ
start with 10
increment by 1;
 
-- Sequence for Reservation table
create sequence RESV_ID_SEQ
start with 100
increment by 10;
 
--- Sequence for Room table
create sequence Room_ID_SEQ
start with 100
increment by 1;
 
-- Sequence for Services table
create sequence Service_ID_SEQ
start with 1
increment by 1;
 
-- Sequence for Invoice table
create sequence INVOICE_ID_SEQ
start with 200
increment by 1;
 
CREATE TABLE Customer (
	customer_ID NUMBER NOT NULL,
	c_first_name VARCHAR2(30) NOT NULL,
	c_last_name VARCHAR2(30) NOT NULL,
	c_street VARCHAR2(60) NOT NULL,
	c_city VARCHAR2(30)NOT NULL,
	c_state VARCHAR2(20) NOT NULL,
	c_zip_code VARCHAR(10)NOT NULL,
	c_phone VARCHAR(12),
	c_credit_no VARCHAR2(15)NOT NULL,
	primary key (customer_ID)
);
 
create table Hotel_Branch(
	Hotel_ID NUMBER NOT NULL,
	h_name VARCHAR2(30) NOT NULL,
	h_street VARCHAR2(60) NOT NULL,
	h_city VARCHAR2(30)NOT NULL,
	h_state VARCHAR(20) NOT NULL,
	h_zip_code VARCHAR2(10)NOT NULL,
	h_phone VARCHAR2(12),
	h_num_rooms NUMBER,
	h_status VARCHAR2(30),
	primary key (Hotel_ID)
);
 
create table Reservation(
	Resv_ID NUMBER NOT NULL,
	r_customer_ID NUMBER,
	r_Hotel_ID NUMBER,
	r_reserv_Date DATE,
	r_reserv_start_Date DATE,
	r_reserv_end_Date DATE,
	r_check_In_date DATE,
	r_check_Out_date DATE, 
	r_ isCancelled VARCHAR2(30),
	primary key (Resv_ID),
	foreign key (r_customer_ID) references Customer(Customer_ID),
	foreign key (r_Hotel_ID) references Hotel_Branch(Hotel_ID)
);
 
create table Room(
	Room_ID NUMBER NOT NULL,
	rm_Resv_ID  NUMBER NOT NULL,
	rm_Hotel_ID NUMBER NOT NULL,
	rm_number VARCHAR2(20),
	rm_room_Type VARCHAR2(30) NOT NULL,
	rm_description VARCHAR2(60),
	rm_Rate_per_day NUMBER(9,2) NOT NULL,
	rm_status_IsActive VARCHAR2(30),	
	Primary key(Room_ID),
	Foreign key (rm_Resv_ID )references Reservation(Resv_ID),
	Foreign key (rm_Hotel_ID) references Hotel_Branch(Hotel_ID)	
);
 
create table Services(
	Service_ID NUMBER NOT NULL,
	s_Resv_ID NUMBER,
	s_service_type VARCHAR2(30) NOT NULL,
	s_description  VARCHAR2(60) NOT NULL,
	s_Price NUMBER(9,2),
	s_Qty NUMBER,
	s_service_date DATE,
	primary key (Service_ID),
	Foreign key (s_Resv_ID)references Reservation(Resv_ID)
);
 
create table Invoice(
	Invoice_ID NUMBER NOT NULL, 
	i_Customer_ID NUMBER,
	i_invoice_number VARCHAR2(30),
	i_invoice_date DATE,
	i_invoice_total NUMBER(9,2),
	i_payment_total NUMBER(9,2),
	i_payment_date DATE,
	primary key (Invoice_ID),
	foreign key (i_Customer_ID) references Customer(Customer_ID)
 
);
 
COMMIT;
 
--customer
 
insert into Customer VALUES (CUSTOMER_ID_SEQ.nextval,'John','Manhattan','123 Home St','Columbus','OH','43203','614-715-8000','2427');
 
insert into Customer VALUES (CUSTOMER_ID_SEQ.nextval,'Ralph','Hinnebusch','321 North St Buffalo','NY','14213','716-881-3303','1657');
 
insert into Customer VALUES (CUSTOMER_ID_SEQ.nextval,'Kathy','Reynolds','231 South St','Frederick','MD','21703','301-694-7899','4961');
 
insert into Customer VALUES (CUSTOMER_ID_SEQ.nextval,'Alice','Klein','132 East St','Philadelphia','PA','19112','877-792-9455','3965');
 
insert into Customer VALUES (CUSTOMER_ID_SEQ.nextval,'Hope','Doe','432 West St','Orlando','FL','32817','407-853-4828','7239');		
 
--Hotel_Branch
 
insert into Hotel_Branch VALUES (HOTEL_ID_SEQ.nextval,'Dunes Manor','2800 Baltimore Ave','Ocean City','MD','21842','410-289-1100',50,'Active');
 
insert into Hotel_Branch VALUES (HOTEL_ID_SEQ.nextval,'The Westgate','1055 2nd Ave','San Diego','CA','92101','800-522-1564',50,'SOLD');
 
insert into Hotel_Branch VALUES (HOTEL_ID_SEQ.nextval,'Hotel Contessa','306 W Market St','San Antonio','TX','78205','866-435-0900',50,'Active');
 
insert into Hotel_Branch VALUES (HOTEL_ID_SEQ.nextval,'The Roosevelt','45 E 45th St','New York','NY','10017','212-6619-600',50,'Active');
 
insert into Hotel_Branch VALUES (HOTEL_ID_SEQ.nextval,'Comfort Suites','2416 N Orange Ave','Orlando','FL','32804','407-641-1280',50,'Active');
 
--Reservation
 
insert into Reservation VALUES (RESV_ID_SEQ.nextval,1,10,TO_DATE('19-AUG-20','DD-MON-RR'),TO_DATE('19-NOV-20','DD-MON-RR'),TO_DATE('28-NOV-20','DD-MON-RR'),TO_DATE('19-NOV-20','DD-MON-RR'),TO_DATE('28-NOV-20','DD-MON-RR'));
 
insert into Reservation VALUES (RESV_ID_SEQ.nextval,2,11,TO_DATE('24-SEP-20','DD-MON-RR'),TO_DATE('24-DEC-20','DD-MON-RR'),TO_DATE('03-JAN-20','DD-MON-RR'),TO_DATE('24-DEC-20','DD-MON-RR'));	
 
insert into Reservation VALUES (RESV_ID_SEQ.nextval,3,12,TO_DATE('01-JAN-21','DD-MON-RR'),TO_DATE('23-JAN-21','DD-MON-RR'),TO_DATE('25-JAN-21','DD-MON-RR'),TO_DATE('23-JAN-21','DD-MON-RR'),TO_DATE('25-JAN-21','DD-MON-RR'));	
 
insert into Reservation VALUES (RESV_ID_SEQ.nextval,4,13,TO_DATE('25-JAN-21','DD-MON-RR'),TO_DATE('10-FEB-21','DD-MON-RR'),TO_DATE('16-FEB-21','DD-MON-RR'),TO_DATE('10-FEB-21','DD-MON-RR'),TO_DATE('16-FEB-21','DD-MON-RR'));	
 
insert into Reservation VALUES (RESV_ID_SEQ.nextval,5,14,TO_DATE('15-OCT-20','DD-MON-RR'),TO_DATE('27-OCT-20','DD-MON-RR'),TO_DATE('01-NOV-20','DD-MON-RR'),null,null,'YES');
 
--Room
 
insert into Room VALUES (Room_ID_SEQ.nextval,140,10,'RM259','single','1-bed',100.00,'NO');
 
insert into Room VALUES (Room_ID_SEQ.nextval,120,11,'RM140','double','2-beds',200.00,'NO');
 
insert into Room VALUES (Room_ID_SEQ.nextval,130,12,'RM350','conference','200 seater',1000.00,'NO');
 
insert into Room VALUES (Room_ID_SEQ.nextval,110,13,'RM262','suite','single family',500.00,'YES');
 
insert into Room VALUES (Room_ID_SEQ.nextval,100,14,'RM364','double','2-beds',200.00,'NO');
 
--Services
 
insert into Services VALUES (Service_ID_SEQ.nextval,100,'Restaurant','meal per person',20.00,1,TO_DATE('19-NOV-20','DD-MON-RR'));
 
insert into Services VALUES (Service_ID_SEQ.nextval,100,'Movies','gnre',5.00,2,TO_DATE('20-NOV-20','DD-MON-RR'));
 
insert into Services VALUES (Service_ID_SEQ.nextval,100,'Laundry','Fluff and Fold Services',10.00,1,TO_DATE('25-NOV-20','DD-MON-RR'));
 
insert into Services VALUES (Service_ID_SEQ.nextval,110,'Movies','gnre','20.00',1,TO_DATE('27-DEC-20','DD-MON-RR'));

insert into Services VALUES (Service_ID_SEQ.nextval,110,'Restaurant','meal per person',20.00,1,TO_DATE('26-DEC-20','DD-MON-RR'));
 
--Invoice
 
insert into Invoice VALUES (INVOICE_ID_SEQ.nextval,1,'INV3345',TO_DATE('19-AUG-20','DD-MON-RR'),1440.00,1440.00,TO_DATE('19-AUG-20','DD-MON-RR'));
 
insert into Invoice VALUES (INVOICE_ID_SEQ.nextval,2,'INV3346',TO_DATE('24-SEP-20','DD-MON-RR'),5040.00,5040.00,TO_DATE('24-SEP-20','DD-MON-RR'));
 
insert into Invoice VALUES (INVOICE_ID_SEQ.nextval,3,'INV3347',TO_DATE('01-JAN-21','DD-MON-RR'),400.00,400.00,TO_DATE('01-JAN-21','DD-MON-RR'));	
 
insert into Invoice VALUES (INVOICE_ID_SEQ.nextval,4,'INV3348',TO_DATE('25-JAN-21','DD-MON-RR'),6000.00,6000.00,TO_DATE('25-JAN-21','DD-MON-RR'));
 
insert into Invoice VALUES (INVOICE_ID_SEQ.nextval,5,'INV3349',TO_DATE('15-OCT-20','DD-MON-RR'),2400.00,2400.00,TO_DATE('15-OCT-20','DD-MON-RR'));
 
