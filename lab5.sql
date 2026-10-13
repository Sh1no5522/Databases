-- Task 1.1
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age >= 18 AND age <= 65),
    salary NUMERIC CHECK (salary > 0)
);

-- Task 1.2
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (regular_price > 0 AND discount_price > 0 AND discount_price < regular_price)
);

-- Task 1.3
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests >= 1 AND num_guests <= 10),
    CONSTRAINT valid_dates CHECK (check_out_date > check_in_date)
);

-- Task 1.4
INSERT INTO employees VALUES (1, 'John', 'Doe', 25, 50000), (2, 'Jane', 'Smith', 30, 60000);
INSERT INTO products_catalog VALUES (1, 'Laptop', 1000, 900), (2, 'Mouse', 50, 40);
INSERT INTO bookings VALUES (1, '2026-10-15', '2026-10-20', 2), (2, '2026-11-01', '2026-11-05', 4);

-- INSERT INTO employees VALUES (3, 'Kid', 'A', 15, 1000); 
-- INSERT INTO products_catalog VALUES (3, 'Bad Item', 100, 150);
-- INSERT INTO bookings VALUES (3, '2026-10-20', '2026-10-15', 5);

-- Task 2.1
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

-- Task 2.2
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

-- Task 2.3
INSERT INTO customers VALUES (1, 'test1@mail.com', '123456789', '2026-10-13');
INSERT INTO customers VALUES (2, 'test2@mail.com', NULL, '2026-10-13');
INSERT INTO inventory VALUES (1, 'Desk', 10, 150.00, CURRENT_TIMESTAMP);

-- INSERT INTO customers VALUES (NULL, 'test3@mail.com', '111', '2026-10-13');
-- INSERT INTO inventory VALUES (2, NULL, 5, 10.0, CURRENT_TIMESTAMP);

-- Task 3.1 & 3.3
CREATE TABLE users (
    user_id INTEGER,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP
);
ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

INSERT INTO users VALUES (1, 'johndoe', 'john@mail.com', CURRENT_TIMESTAMP);
-- INSERT INTO users VALUES (2, 'johndoe', 'other@mail.com', CURRENT_TIMESTAMP);

-- Task 3.2
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

-- Task 4.1
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);
INSERT INTO departments VALUES (1, 'IT', 'Floor 1'), (2, 'HR', 'Floor 2'), (3, 'Sales', 'Floor 3');

-- INSERT INTO departments VALUES (1, 'Marketing', 'Floor 4');
-- INSERT INTO departments VALUES (NULL, 'Finance', 'Floor 5');

-- Task 4.2
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

-- Task 4.3
/* 
1. PRIMARY KEY prohibits NULLs; UNIQUE allows NULLs.
2. Single-column is for one main ID; Composite is for unique combinations (like student + course).
3. A table can only have one main anchor (PK) but multiple unique attributes (UNIQUE). 
*/

-- Task 5.1
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);
INSERT INTO employees_dept VALUES (1, 'Alice', 1, '2026-01-01');
-- INSERT INTO employees_dept VALUES (2, 'Bob', 999, '2026-01-01');

-- Task 5.2
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);
CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);
INSERT INTO authors VALUES (1, 'George Orwell', 'UK');
INSERT INTO publishers VALUES (1, 'Penguin Books', 'London');
INSERT INTO books VALUES (1, '1984', 1, 1, 1949, '1234567890');

-- Task 5.3
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);
CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);
CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO products_fk VALUES (1, 'Phone', 1);
-- DELETE FROM categories WHERE category_id = 1; /* Fails due to RESTRICT */

INSERT INTO orders VALUES (1, '2026-10-13');
INSERT INTO order_items VALUES (1, 1, 1, 5);
DELETE FROM orders WHERE order_id = 1; /* CASCADE automatically deletes from order_items */

-- Task 6.1
CREATE TABLE ecom_customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE
);

CREATE TABLE ecom_products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC CHECK (price >= 0),
    stock_quantity INTEGER CHECK (stock_quantity >= 0)
);

CREATE TABLE ecom_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES ecom_customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    total_amount NUMERIC CHECK (total_amount >= 0),
    status TEXT CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE ecom_order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES ecom_orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES ecom_products(product_id) ON DELETE RESTRICT,
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC CHECK (unit_price >= 0)
);

INSERT INTO ecom_customers VALUES 
(1, 'John Smith', 'john.smith@mail.com', '111', '2026-01-01'),
(2, 'Jane Doe', 'jane.doe@mail.com', '222', '2026-02-01'),
(3, 'Mike Ross', 'mike.r@mail.com', '333', '2026-03-01'),
(4, 'Rachel Green', 'rachel.g@mail.com', '444', '2026-04-01'),
(5, 'Harvey Specter', 'harvey.s@mail.com', '555', '2026-05-01');

INSERT INTO ecom_products VALUES
(1, 'Laptop', 'Gaming Laptop', 1500.00, 10),
(2, 'Mouse', 'Wireless Mouse', 25.00, 50),
(3, 'Keyboard', 'Mechanical', 80.00, 30),
(4, 'Monitor', '4K Display', 300.00, 15),
(5, 'Headset', 'Noise Cancelling', 100.00, 20);

INSERT INTO ecom_orders VALUES
(1, 1, '2026-10-01', 1525.00, 'delivered'),
(2, 2, '2026-10-05', 80.00, 'shipped'),
(3, 3, '2026-10-10', 300.00, 'processing'),
(4, 4, '2026-10-11', 100.00, 'pending'),
(5, 5, '2026-10-12', 0.00, 'cancelled');

INSERT INTO ecom_order_details VALUES
(1, 1, 1, 1, 1500.00),
(2, 1, 2, 1, 25.00),
(3, 2, 3, 1, 80.00),
(4, 3, 4, 1, 300.00),
(5, 4, 5, 1, 100.00);

-- INSERT INTO ecom_orders VALUES (6, 1, '2026-10-13', 50, 'lost_in_transit'); 
-- INSERT INTO ecom_products VALUES (6, 'Free Item', 'Desc', -10, 5);