-- a. What is the list of all instrument rentals in inventory?
-- (Show the list displayed in Figure 1, along with any other rentals in your database.)

SELECT instr_type, rental.*
FROM instrument, rental
WHERE instrument.serial_num = rental.serial_num;

-- b. What are the youngest and oldest customers of Uptown Rentals?
-- One SQL program to display both.

SELECT cust_fname, cust_age
FROM customer
WHERE cust_age = (SELECT MAX(cust_age) FROM customer)

UNION

SELECT cust_fname, cust_age
FROM customer
WHERE cust_age = (SELECT MIN(cust_age) FROM customer);

-- c. List the aggregated (summed) rental amounts per customer.
-- Sequence the result to show the customer with the highest rental amount first.

SELECT cust_fname, SUM(daily_rentalfee) AS 'sum'
FROM customer INNER JOIN rental
ON customer.cust_email = rental.cust_email
GROUP BY cust_fname
ORDER BY sum DESC;

-- d. Which customer has the most rentals (the highest count) across all time?

SELECT cust_fname, COUNT(rental.cust_email) as 'count'
FROM CUSTOMER INNER JOIN RENTAL
ON customer.cust_email = rental.cust_email
GROUP BY cust_fname, customer.cust_email
ORDER BY count DESC
LIMIT 1;

-- e. Which customer had the most rentals in January 2025, 
-- and what was their average rental total per rental?

SELECT cust_fname, COUNT(rental.cust_email) as 'count',
AVG(rental.daily_rentalfee) as 'average'
FROM customer INNER JOIN rental
ON customer.cust_email = rental.cust_email
WHERE rental.rental_date BETWEEN '2015-01-1' AND '2015-01-31'
GROUP BY cust_fname;

-- f. Which staff member (name) is associated with the most rentals in January 2025?

SELECT staff_fname, COUNT(rental.staff_id) as 'frequency'
FROM staff INNER JOIN rental
ON staff.staff_id = rental.staff_id
WHERE rental.rental_date BETWEEN '2015-01-1' AND '2015-01-31'
GROUP BY staff_fname
ORDER BY frequency desc
LIMIT 1;

-- g.	For each customer that has an overdue rental, how many days have passed since the rental was due?
SELECT cust_fname, SUM(DATEDIFF(return_date, due_date))
FROM customer INNER JOIN rental
ON customer.cust_email = rental.cust_email
WHERE return_date > due_date
GROUP BY cust_fname;

-- h.	What is the total rental amount by Rental tier?
SELECT tier.rental_tier, SUM(rental.daily_rentalfee * DATEDIFF(return_date, rental_date)) AS total_rental_amount
FROM tier
INNER JOIN instrument ON tier.rental_tier = instrument.rental_tier
INNER JOIN rental ON rental.serial_num = instrument.serial_num
GROUP BY tier.rental_tier WITH ROLLUP;

--  i.	Who are the top three store staff members in terms of total rental amounts?
SELECT staff_fname, SUM(daily_rentalfee) AS 'highest'
FROM staff INNER JOIN rental
ON staff.staff_id = rental.staff_id
GROUP BY staff_fname
ORDER BY highest DESC;

-- j.	What is the total rental amount by instrument type, where the instrument type is Flute or Bass Guitar?
SELECT instr_type, SUM(daily_rentalfee) 'total_amount'
FROM instrument INNER JOIN rental
ON instrument.serial_num = rental.serial_num
WHERE instr_type = 'Bass Guitar' OR instr_type = 'Flute'
GROUP BY instr_type;

--  k.	What is the name of any customer who has two or more overdue rentals?
SELECT cust_fname
FROM customer INNER JOIN rental
ON customer.cust_email = rental.cust_email
WHERE (DATEDIFF(return_date, due_date)) > 0
GROUP BY cust_fname
HAVING COUNT(*) >= 2;

--  l.	List all of the instruments in inventory in 2025 that were damaged upon return or needed maintenance. 
-- Include the employee that handled the rental, the repair cost, and the maintenance date
SELECT main_date, staff_fname, repair_cost, instr_condition
FROM maintenance INNER JOIN staff
ON maintenance.staff_id = staff.staff_id
WHERE instr_condition IN ('Bad', 'Terrible')
AND main_date BETWEEN '2015-01-01' AND '2015-12-31';


-- m Create a query of your choice that includes a subquery.
-- Find Customers with overdue rentals
SELECT cust_fname, cust_lname, (SELECT COUNT(*)
FROM rental, customer
WHERE rental.cust_email = customer.cust_email AND
DATEDIFF(return_date, due_date) > 0) AS overdue_count
FROM customer
WHERE customer.cust_email IN
(SELECT rental.cust_email
FROM rental
WHERE DATEDIFF(return_date, due_date) > 0);

-- n.	Add another meaningful query of your choice. For example, you could create a query that answers the following question:
 -- What is the name of any customer who has rented 3 or more Woodwind instruments?
SELECT cust_fname, COUNT(instr_type) AS 'flute'
FROM customer INNER JOIN rental
ON customer.cust_email = rental.cust_email
JOIN instrument ON rental.serial_num = instrument.serial_num
WHERE instr_type = 'Flute'
GROUP BY cust_fname
HAVING flute >= 2;


