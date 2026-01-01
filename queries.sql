------ user_table -------
CREATE TABLE users (
  user_id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  email varchar(100) UNIQUE,
  phone int,
  role varchar(50) CHECK (role IN ('Admin', 'Customer'))
)

INSERT INTO users (name, email, phone, role)
VALUES 
('Alice', 'alice@example.com', 1234567890, 'Customer'),
('Bob', 'bob@example.com', 0987654321, 'Admin'),
('Charlie', 'charlie@example.com', 1122334455, 'Customer');



----- vehicle_table -----
CREATE TABLE vehicles (
  vehicle_id serial PRIMARY KEY,
  name varchar(150) NOT NULL,
  type varchar(20) CHECK (type IN ('car', 'bike', 'truck')),
  model int,
  registration_number varchar(100) UNIQUE,
  rental_price int CHECK (rental_price > 0),
  status varchar(50) CHECK (status IN ('available', 'rented', 'maintenance'))
)

  INSERT INTO vehicles (
    name,
    type,
    model,
    registration_number,
    rental_price,
    status)
VALUES
  ('Toyota Corolla', 'car', 2022, 'ABC-123', 50, 'available'),
  ('Honda Civic', 'car', 2021, 'DEF-456', 60, 'rented'),
  ('Yamaha R15', 'bike', 2023, 'GHI-789', 30, 'available'),
  ('Ford F-150', 'truck', 2020, 'JKL-012', '100', 'maintenance');
  

  -- Find all vehicles that have never been booked
SELECT * FROM vehicles AS v
WHERE NOT EXISTS (
    SELECT b.booking_id FROM bookings AS b
    WHERE b.vehicle_id = v.vehicle_id
  )
ORDER BY v.rental_price ASC
  
  -- Retrieve all available vehicles of a specific type
SELECT * FROM vehicles
WHERE type = 'car' AND status = 'available'



------- booking_table --------
CREATE TABLE bookings (
  booking_id serial PRIMARY KEY,
  user_id int REFERENCES users (user_id),
  vehicle_id int REFERENCES vehicles (vehicle_id),
  start_date date,
  end_date date,
  status varchar(50) CHECK (status IN ('completed', 'confirmed', 'pending')),
  total_cost int CHECK (total_cost > 0)
)

INSERT INTO bookings (
    user_id,
    vehicle_id,
    start_date,
    end_date,
    status,
    total_cost)
VALUES
  (1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
  (1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
  (3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
  (1, 1, '2023-12-01', '2023-12-12', 'pending', 100);

  -- Retrieve booking information along with Customer name and Vehicle name
SELECT
  booking_id,
  u.name AS customer_name,
  v.name AS vehicle_name,
  start_date,
  end_date,
  b.status
FROM
  bookings AS b
  INNER JOIN users AS u ON b.user_id = u.user_id
  INNER JOIN vehicles AS v ON b.vehicle_id = v.vehicle_id

  
  -- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings
SELECT
  v.name AS vehicle_name,
  count(*) AS total_bookings
FROM
  bookings AS b
  INNER JOIN vehicles AS v ON b.vehicle_id = v.vehicle_id
GROUP BY
  v.name
HAVING
  count(*) > 2