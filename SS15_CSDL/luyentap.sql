create database sell_management;
use sell_management;
create table customers(
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(100) 
);
create table products(
	product_id int primary key auto_increment,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
    quantity int not null check(quantity >= 0),
    category varchar(100) not null
);
create table employees(
	employee_id int primary key auto_increment,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);
create table orders(
	order_id int primary key auto_increment ,
    customer_id int ,
    employee_id int,
    order_date datetime default current_timestamp,
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(customer_id),
    foreign key (employee_id) references employees(employee_id)
);
create table order_detail(
	order_detail_id int primary key auto_increment,
    order_id int ,
    product_id int,
    quantity int not null check(quantity > 0),
    unit_price decimal(10,2) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);
-- cau 3
alter table customers
add column email varchar(100) not null unique;
-- alter table employees
-- add column birthday date;
alter table employees
drop column birthday ;
-- cau 4
INSERT INTO customers (customer_name, phone, address,email) VALUES
('Nguyễn Văn A', '0987654321', 'Hà Nội','nva@gmail.com'),
('Trần Thị B', '0976543210', 'Hồ Chí Minh','ttb@gmail.com'),
('Lê Văn C', '0965432109', 'Đà Nẵng','ltc@gmail.com'),
('Phạm Thị D', '0954321098', 'Hải Phòng','ptd@gmail.com'),
('Hoàng Văn E', '0943210987', 'Cần Thơ','hve@gmail.com');
-- Chèn dữ liệu vào bảng sản phẩm
INSERT INTO products (product_name, price, quantity, category) VALUES
('Laptop Dell', 15000000.00, 10, 'Electronics'),
('iPhone 13', 20000000.00, 15, 'Mobile'),
('Samsung Galaxy S22', 18000000.00, 20, 'Mobile'),
('MacBook Air', 25000000.00, 8, 'Electronics'),
('Tai nghe Sony', 2000000.00, 30, 'Accessories');
-- update products
-- set product_name = 'Tai nghe aidpods', quantity = 120
-- where product_id = 5;
-- Chèn dữ liệu vào bảng nhân viên
INSERT INTO employees (employee_name, birthday, position, salary, revenue) VALUES
('Nguyễn Thị H', '1990-05-10', 'Quản lý', 25000000.00, 50000000.00),
('Lê Văn K', '1995-08-20', 'Nhân viên bán hàng', 12000000.00, 20000000.00),
('Trần Thị M', '1988-12-15', 'Nhân viên kho', 10000000.00, 0),
('Hoàng Văn N', '1992-03-05', 'Nhân viên bán hàng', 13000000.00, 25000000.00),
('Phạm Thị O', '1997-06-22', 'Nhân viên hỗ trợ', 11000000.00, 0);

-- Chèn dữ liệu vào bảng đơn hàng
INSERT INTO orders (customer_id, employee_id, total_amount) VALUES
(1, 2, 20000000.00),
(2, 4, 18000000.00),
(3, 2, 15000000.00),
(4, 4, 25000000.00),
(5, 1, 30000000.00);

-- Chèn dữ liệu vào bảng chi tiết đơn hàng
INSERT INTO order_detail (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 1, 20000000.00),
(2, 3, 1, 18000000.00),
(3, 1, 1, 15000000.00),
(4, 4, 1, 25000000.00),
(5, 5, 2, 10000000.00);
-- cau 5
-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách hàng, tên khách hàng, email, số điện thoại và địa chỉ
select customer_id,customer_name,email,phone,address from customers;
-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name= “Laptop Dell XPS” và price = 99.99
update products
set product_name = 'Laptop Dell XPS' , price = 99.99
where product_id = 1;
-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt hàng.
select o.order_id,c.customer_name,e.employee_name,sum(o.total_amount) as totalmoney,o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
group by o.order_id;
-- cau 6
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn
select o.customer_id,c.customer_name,count(o.order_id) totalorder
from orders o 
join customers c on o.customer_id = c.customer_id
group by o.customer_id;
-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm : mã nhân viên, tên nhân viên, doanh thu
select employee_id,employee_name,revenue
from employees;
-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại. Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần
select p.product_id,p.product_name,sum(p.quantity) as order_quantity
from products p
join order_detail od on p.product_id = od.product_id
group by p.product_id
having order_quantity > 100
order by order_quantity desc;
-- cau 7
-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng
SELECT customer_id, customer_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);
-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select * from products where price > (select avg(price) as avg_product from products);
-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_spent)
    FROM (
        SELECT customer_id, SUM(total_amount) AS total_spent
        FROM Orders
        GROUP BY customer_id
    ) AS customer_spending
);
-- cau 8. 1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự ngày đặt mới nhất
create view view_order_list as
select o.order_id,c.customer_name,e.employee_name,o.total_amount,o.order_date
from orders o
join employees e on o.employee_id = e.employee_id
join customers c on o.customer_id = c.customer_id;
select * from view_order_list
order by order_date desc;
-- drop view view_order_list
-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp theo số lượng giảm dần
create view view_order_detail_product as
select od.order_detail_id,p.product_name,od.quantity,od.unit_price
from order_detail od
join products p on od.product_id = p.product_id
order by od.quantity desc;
-- cau 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã nhân viên và tổng doanh thu) , thực hiện thêm mới dữ liệu vào bảng nhân viên và trả về mã nhân viên vừa mới thêm
DELIMITER &&
create procedure proc_insert_employee(
	employee_name varchar(100),
    position varchar(50),
    salary decimal(10,2),
    out new_employee_id int
)
begin 
	insert into employees(employee_name,position,salary) 
    values (employee_name,position,salary);
    set new_employee_id = last_insert_id();
end &&
DELIMITER 
call proc_insert_employee('Pham Van Minh','Developer',1500.00,@new_id);
select @new_id;
select * from employees;
-- cau 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo mã đặt hàng.
DELIMITER &&
create procedure proc_get_orderdetails(p_order_id int)
begin 
	select order_detail_id,order_id,product_id,quantity,unit_price from order_detail where order_id = p_order_id;
end &&
DELIMITER &&
call proc_get_orderdetails(2);
-- cau 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.
DELIMITER &&
create procedure proc_cal_total_amount_by_order(p_order_id int , out p_total_products int)
begin 
	select count(distinct product_id) into p_total_products
    from order_detail 
    where order_id = p_order_id;
end &&
DELIMITER &&
CALL proc_cal_total_amount_by_order(1, @total_products);
SELECT @total_products AS TotalProductTypes;
-- cau 10 Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng sản 
-- phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. Nếu số lượng trong kho không đủ thì ném ra thông báo lỗi
--  “Số lượng sản phẩm trong kho không đủ” và hủy thao tác chèn.
DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON order_detail
FOR EACH ROW
BEGIN
    DECLARE stock_available INT;
    -- Lấy số lượng sản phẩm hiện có trong kho
    SELECT stock_quantity INTO stock_available
    FROM Products
    WHERE product_id = NEW.product_id;
    -- Kiểm tra nếu số lượng tồn kho không đủ thì báo lỗi và hủy thao tác chèn
    IF stock_available IS NULL OR stock_available < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        -- Cập nhật số lượng sản phẩm trong kho sau khi đặt hàng
        UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END //
DELIMITER ;
-- drop trigger trigger_after_insert_order_details
INSERT INTO order_detail (order_id, product_id, quantity, unit_price)
VALUES (2, 1, 1000, 10.00);
-- cau 11
drop procedure proc_insert_order_details;
DELIMITER //
CREATE PROCEDURE proc_insert_order_details (
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_total_price DECIMAL(10,2);
    DECLARE v_order_exists INT;
    -- Bắt đầu Transaction
    START TRANSACTION;
    -- Kiểm tra xem mã hóa đơn có tồn tại trong bảng Orders không
    SELECT COUNT(*) INTO v_order_exists FROM Orders WHERE order_id = p_order_id;
    IF v_order_exists = 0 THEN
        -- Nếu không tồn tại, báo lỗi và rollback
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
        ROLLBACK;
    ELSE
        -- Tính tổng tiền của sản phẩm trong đơn hàng
        SET v_total_price = p_quantity * p_unit_price;
        -- Chèn dữ liệu vào bảng order_detail
        INSERT INTO order_detail (order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);
        -- Cập nhật tổng tiền của đơn hàng trong bảng Orders
        UPDATE Orders
        SET total_amount = total_amount + v_total_price
        WHERE order_id = p_order_id;
        COMMIT;
    END IF;
END //
DELIMITER ;
CALL proc_insert_order_details(1001, 2, 5, 10.00);
select * from order_detail;

