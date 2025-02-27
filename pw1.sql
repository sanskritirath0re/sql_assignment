use mavenmovies;

-- SQL COMMANDS

-- 2. List all details of actors
SELECT * FROM actor;

-- 3. List all customer information from DB.
SELECT * FROM customer;

-- 4. List different countries.
SELECT DISTINCT country FROM address;

-- 5. Display all active customers.
SELECT * FROM customer WHERE active = 1;

-- 6. List of all rental IDs for customer with ID 1.
SELECT rental_id FROM rental WHERE customer_id = 1;

-- 7. Display all the films whose rental duration is greater than 5.
SELECT * FROM film WHERE rental_duration > 5;

-- 8. List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT COUNT(*) FROM film WHERE replacement_cost > 15 AND replacement_cost < 20;

-- 9. Display the count of unique first names of actors.
SELECT COUNT(DISTINCT first_name) FROM actor;

-- 10. Display the first 10 records from the customer table.
SELECT * FROM customer LIMIT 10;

-- 11. Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT * FROM customer WHERE first_name LIKE 'B%' LIMIT 3;

-- 12. Display the names of the first 5 movies which are rated as ‘G’.
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

-- 13. Find all customers whose first name starts with "a".
SELECT * FROM customer WHERE first_name LIKE 'A%';

-- 14. Find all customers whose first name ends with "a".
SELECT * FROM customer WHERE first_name LIKE '%a';

-- 15. Display the list of first 4 cities which start and end with ‘a’.
SELECT city FROM city WHERE city LIKE 'A%' AND city LIKE '%a' LIMIT 4;

-- 16. Find all customers whose first name has "NI" in any position.
SELECT * FROM customer WHERE first_name LIKE '%NI%';

-- 17. Find all customers whose first name has "r" in the second position.
SELECT * FROM customer WHERE first_name LIKE '_r%';

-- 18. Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT * FROM customer WHERE first_name LIKE 'A%' AND LENGTH(first_name) >= 5;

-- 19. Find all customers whose first name starts with "a" and ends with "o".
SELECT * FROM customer WHERE first_name LIKE 'A%o';

-- 20. Get the films with pg and pg-13 rating using IN operator.
SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

-- 21. Get the films with length between 50 to 100 using BETWEEN operator.
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- 22. Get the top 50 actors using LIMIT operator.
SELECT * FROM actor LIMIT 50;

-- 23. Get the distinct film ids from inventory table.
SELECT DISTINCT film_id FROM inventory;

-- FUNCTIONS

-- Question 1: Retrieve the total number of rentals made in the Sakila database
SELECT COUNT(*) AS total_rentals
FROM rental;

-- Question 2: Find the average rental duration (in days) of movies rented from the Sakila database
SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration
FROM rental;

-- Question 3: Display the first name and last name of customers in uppercase
SELECT UPPER(first_name) AS first_name_upper, UPPER(last_name) AS last_name_upper
FROM customer;

-- Question 4: Extract the month from the rental date and display it alongside the rental ID
SELECT rental_id, MONTH(rental_date) AS rental_month
FROM rental;

-- Question 5: Retrieve the count of rentals for each customer (display customer ID and the count of rentals)
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Question 6: Find the total revenue generated by each store
SELECT store_id, SUM(amount) AS total_revenue
FROM payment
GROUP BY store_id;

-- Question 7: Determine the total number of rentals for each category of movies
SELECT c.name AS category_name, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- Question 8: Find the average rental rate of movies in each language
SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- JOINS

-- Question 9: Display the title of the movie, customer's first name, and last name who rented it
SELECT f.title AS movie_title, c.first_name AS customer_first_name, c.last_name AS customer_last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Question 10: Retrieve the names of all actors who have appeared in the film "Gone with the Wind"
SELECT a.first_name AS actor_first_name, a.last_name AS actor_last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Gone with the Wind';

-- Question 11: Retrieve the customer names along with the total amount they've spent on rentals
SELECT c.first_name AS customer_first_name, c.last_name AS customer_last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Question 12: List the titles of movies rented by each customer in a particular city (e.g., 'London')
SELECT f.title AS movie_title, c.first_name AS customer_first_name, c.last_name AS customer_last_name, ci.city AS city_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY f.title, c.customer_id, c.first_name, c.last_name, ci.city;

-- ADVANCE JOIN AND GROUP BY

-- Question 13: Display the top 5 rented movies along with the number of times they've been rented
SELECT f.title AS movie_title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

-- Question 14: Determine the customers who have rented movies from both stores (store ID 1 and store ID 2)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;

-- WINDOWS FUNCTIONS

-- 1. Rank the customers based on the total amount they've spent on rentals
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spending_rank
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY spending_rank;

-- 2. Calculate the cumulative revenue generated by each film over time
SELECT f.title AS film_title, p.payment_date, SUM(p.amount) AS daily_revenue,
       SUM(SUM(p.amount)) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title, p.payment_date
ORDER BY f.title, p.payment_date;

-- 3. Determine the average rental duration for each film, considering films with similar lengths
SELECT f.title AS film_title, f.length, AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.length;

-- 4. Identify the top 3 films in each category based on their rental counts
SELECT c.name AS category_name, f.title AS film_title, COUNT(r.rental_id) AS rental_count,
       RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS rank_in_category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name, f.title
HAVING rank_in_category <= 3;

-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers
WITH CustomerRentals AS (
    SELECT customer_id, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY customer_id
), 
AverageRentals AS (
    SELECT AVG(total_rentals) AS avg_rentals
    FROM CustomerRentals
)
SELECT cr.customer_id, cr.total_rentals, ar.avg_rentals,
       (cr.total_rentals - ar.avg_rentals) AS rental_difference
FROM CustomerRentals cr
CROSS JOIN AverageRentals ar;

-- 6. Find the monthly revenue trend for the entire rental store over time
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, SUM(amount) AS monthly_revenue
FROM payment
GROUP BY month
ORDER BY month;

-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers
WITH TotalSpending AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
), SpendingThreshold AS (
    SELECT PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total_spent) AS top_20_percent
    FROM TotalSpending
)
SELECT c.customer_id, c.total_spent
FROM TotalSpending c
JOIN SpendingThreshold st ON c.total_spent >= st.top_20_percent;

-- 8. Calculate the running total of rentals per category, ordered by rental count
SELECT c.name AS category_name, f.title AS film_title, COUNT(r.rental_id) AS rental_count,
       SUM(COUNT(r.rental_id)) OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS running_total
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name, f.title
ORDER BY c.name, rental_count DESC;

-- 9. Find the films that have been rented less than the average rental count for their respective categories
WITH CategoryAverages AS (
    SELECT c.name AS category_name, AVG(rental_count) AS avg_rentals_per_category
    FROM (
        SELECT fc.category_id, COUNT(r.rental_id) AS rental_count
        FROM rental r
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        JOIN film_category fc ON f.film_id = fc.film_id
        GROUP BY fc.category_id, f.film_id
    ) AS FilmRentalCounts
    JOIN category c ON FilmRentalCounts.category_id = c.category_id
    GROUP BY c.name
)
SELECT f.title AS film_title, c.name AS category_name, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, c.name
HAVING COUNT(r.rental_id) < (
    SELECT avg_rentals_per_category
    FROM CategoryAverages
    WHERE CategoryAverages.category_name = c.name
);

-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, SUM(amount) AS monthly_revenue
FROM payment
GROUP BY month
ORDER BY monthly_revenue DESC
LIMIT 5;


-- NORMALIZATION AND CTE

-- 5
WITH actor_film_count AS (
    SELECT 
        a.first_name || ' ' || a.last_name AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM 
        actor a
    JOIN 
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY 
        a.actor_id
)
SELECT 
    actor_name,
    film_count
FROM 
    actor_film_count;

-- 6
WITH film_language_details AS (
    SELECT 
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM 
        film f
    JOIN 
        language l ON f.language_id = l.language_id
)
SELECT 
    film_title,
    language_name,
    rental_rate
FROM 
    film_language_details;

-- 7
WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        SUM(p.amount) AS total_revenue
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id
)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    cr.total_revenue
FROM 
    customer_revenue cr
JOIN 
    customer c ON cr.customer_id = c.customer_id;

-- 8
WITH ranked_films AS (
    SELECT 
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS rental_rank
    FROM 
        film
)
SELECT 
    title,
    rental_duration,
    rental_rank
FROM 
    ranked_films;

-- 9
WITH frequent_customers AS (
    SELECT 
        p.customer_id,
        COUNT(p.payment_id) AS rental_count
    FROM 
        payment p
    GROUP BY 
        p.customer_id
    HAVING 
        COUNT(p.payment_id) > 2
)
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    fc.rental_count
FROM 
    frequent_customers fc
JOIN 
    customer c ON fc.customer_id = c.customer_id;

-- 10
WITH monthly_rentals AS (
    SELECT 
        YEAR(rental_date) AS rental_year,
        MONTH(rental_date) AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM 
        rental
    GROUP BY 
        YEAR(rental_date), MONTH(rental_date)
)
SELECT 
    rental_year,
    rental_month,
    total_rentals
FROM 
    monthly_rentals
ORDER BY 
    rental_year DESC, rental_month DESC;

-- 11
WITH actor_pairs AS (
    SELECT 
        fa1.actor_id AS actor_1_id,
        fa2.actor_id AS actor_2_id,
        fa1.film_id
    FROM 
        film_actor fa1
    JOIN 
        film_actor fa2 
        ON fa1.film_id = fa2.film_id
    WHERE 
        fa1.actor_id < fa2.actor_id -- This ensures no duplicate pairs (A, B) and (B, A)
)
SELECT 
    a1.first_name || ' ' || a1.last_name AS actor_1,
    a2.first_name || ' ' || a2.last_name AS actor_2,
    fp.film_id
FROM 
    actor_pairs fp
JOIN 
    actor a1 ON fp.actor_1_id = a1.actor_id
JOIN 
    actor a2 ON fp.actor_2_id = a2.actor_id
ORDER BY 
    film_id, actor_1, actor_2;

-- 12
WITH RECURSIVE staff_hierarchy AS (
    -- Base case: Select the specific manager
    SELECT 
        staff_id,
        first_name || ' ' || last_name AS employee_name,
        reports_to
    FROM 
        staff
    WHERE 
        staff_id = 1  -- Specify the manager's staff_id here

    UNION ALL

    -- Recursive case: Select employees who report to the current staff in the hierarchy
    SELECT 
        s.staff_id,
        s.first_name || ' ' || s.last_name AS employee_name,
        s.reports_to
    FROM 
        staff s
    JOIN 
        staff_hierarchy sh ON s.reports_to = sh.staff_id
)
SELECT 
    staff_id,
    employee_name,
    reports_to
FROM 
    staff_hierarchy
ORDER BY 
    employee_name;

