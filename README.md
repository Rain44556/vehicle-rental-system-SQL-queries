## Vehicle Rental Management System 

This documentation provides a technical breakdown of various SQL queries used to manage and analyze data within a vehicle rental database schema. It focuses on retrieving meaningful insights from relational data using joins, subqueries, filtering, grouping, and aggregation.

The following tables are used in these query examples:
* Users (customers)
* Vehicles available for rent
* Bookings made by users

### DATABASE SCHEMA

* **Users:** Contains customer details like id, name, unigue email, phone, role.
* **Vehicles:** Stores information such as id, name type, model, unique registration_number, renatal price and status.
* **bookings:** This database table shows the connecting users and vehicles wth booking dates, statuses and total costing.

### SOLUTION of QUERIES

**query-1: Booking Details with Joins**

Retrieve booking information along with Customer name and Vehicle name

```sql
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
  ```
*Explanation*: This query uses a double INNER JOIN to link the bookings table with both users and vehicles.

 **query-2: Vehicles Never Booked (Using EXISTS)**

Find all vehicles that have never been booked

```sql
SELECT * FROM vehicles AS v
WHERE NOT EXISTS (
    SELECT b.booking_id FROM bookings AS b
    WHERE b.vehicle_id = v.vehicle_id
  )
ORDER BY v.rental_price ASC
```
*Explanation*: The NOT EXISTS clause filters out vehicles that appear in the bookings table, returning only unused vehicles and finally sorts the results.

  **query-3: Specific Available Vehicles (Using WHERE)**

Retrieve all available vehicles of a specific type

```sql
SELECT * FROM vehicles
WHERE type = 'car' AND status = 'available'
```
*Explanation*: Filters vehicles based on both type and availability status.

  **query-4: total number of bookings(Using GROUP BY and HAVING)**

Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings

```sql
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
```

*Explanation*: Uses GROUP BY and HAVING to group vehicles by name and calculate the total number of bookings for each vehicle.