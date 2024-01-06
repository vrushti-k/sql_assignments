CREATE DATABASE IF NOT EXISTS Business;

USE Business;

CREATE TABLE IF NOT EXISTS customers(
customer_id int not null primary key,
name varchar(20) not null,
email varchar(25) not null unique
);

CREATE TABLE IF NOT EXISTS Items(
item_id int not null primary key,
name varchar(20) not null,
Price int not null
);

CREATE TABLE IF NOT EXISTS orders(
order_id int primary key,
customer_id int not null,
item_id int not null,
quantity int not null,
foreign key customerid_fk(customer_id)
	REFERENCES customers(customer_id)
    on update cascade
    on delete no action,
foreign key itemid_fk(item_id)
	REFERENCES Items(item_id)
    on update cascade
    on delete no action
);

insert into customers(customer_id, name, email)
values(1, 'Rosalyn Rivera', 'rr@adatum.com'), (2, 'Jayne Sargen', 'jayne@test.com'), (3, 'Dean Luong', 'dean@test.com');

insert into items(item_id, name, Price)
values(1, 'Chair', 200), (2, 'Table', 100), (3, 'Lamp', 50);

insert into orders(order_id, customer_id, item_id, quantity)
values(1, 2, 1, 1), (2, 2, 2, 3), (3, 3, 3, 5);

select * from customers;
select * from Items;
select * from orders;

