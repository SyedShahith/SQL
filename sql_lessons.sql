create database banking;
use banking;
create table accountdetails(
acid integer primary key auto_increment,
acname varchar(30) not null,
age tinyint,
actype varchar(7) check(actype='savings' or actype='current'),
gender varchar(6) check(gender='male' or gender='female'),
balance integer check(balance>0));
select * from account_details;
insert into accountdetails(acname,age,actype,gender,balance) values('magesh',21,'current','male',15000);
drop table accountdetails;
create table transaction_details(
transaction_id integer primary key,
Amount integer not null,
acid integer,
foreign key(acid) references accountdetails(acid),
transaction_date date);
select* from transaction_details;
insert into transaction_details values(1012,3000,5,'2024-10-20','debit');
update transaction_details set transaction_type='debit' where transaction_id !=1001;
rename table accountdetails to account_details;
alter table account_details rename column acid to account_id;
alter table account_details rename column acname to account_name;
alter table account_details add account_status varchar(10) default("Active");
set SQL_SAFE_UPDATES=0;
alter table transaction_details modify column transaction_date date;
alter table transaction_details modify column transaction_date date;
Delimiter $$
create trigger account_updater after insert on transaction_details for each row
begin
declare var_account_id integer;
declare var_transaction_id integer;
declare var_balance integer;
declare var_amount integer;
declare var_type varchar(6);
select max(transaction_id) into var_transaction_id from transaction_details;
select acid into var_account_id from transaction_details where transaction_id=var_transaction_id;
select transaction_type into var_type from transaction_details where transaction_id=var_transaction_id;
select Amount into var_amount from transaction_details where transaction_id=var_transaction_id;
if var_type='credit'
then
update account_details set balance=balance+var_amount where account_id=var_account_id;
else
update account_details set balance=balance-var_amount where account_id=var_account_id;
end if;


end;
drop trigger account_updater;
alter table transaction_details add column transaction_type varchar(6);
set global log_bin_trust_function_creators=1;