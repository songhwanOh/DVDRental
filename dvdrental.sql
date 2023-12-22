-- Q1 Query used for first insight
SELECT 
	filmTitle,
	categoryName,
	COUNT(filmTitle) AS rentalCount,
	RANK() OVER(ORDER BY COUNT(filmTitle) DESC) AS rentalRank
FROM (
	SELECT 
		f.title AS filmTitle,
		c.name AS categoryName,
		r.rental_date AS rentalDate
	FROM category c
		JOIN film_category fc ON c.category_id = fc.category_id
		JOIN film f ON fc.film_id = f.film_id
		JOIN inventory i ON f.film_id = i.film_id
		JOIN rental r ON i.inventory_id = r.inventory_id) t1
GROUP BY 1,2
HAVING COUNT(filmTitle) > 30;

-- Q2 Query used for second insight
SELECT
	f.title AS filmTitle,
	c.name AS categoryName,
	ROUND(AVG(f.rental_duration) OVER (), 0) AS avg_rental_duration,
	NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile
FROM category c
	JOIN film_category fc ON c.category_id = fc.category_id
	JOIN film f ON fc.film_id = f.film_id
WHERE LOWER(c.name) IN ('children', 'music', 'family', 'animation')
ORDER BY 
	quartile,
	filmTitle;

-- Q3 Query used for third insight
WITH RentalDurationQuartiles AS (
    SELECT
		f.title AS filmTitle,
		c.name AS categoryName,
		ROUND(AVG(f.rental_duration) OVER (), 0) AS avg_rental_duration,
		NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile
	FROM category c
		JOIN film_category fc ON c.category_id = fc.category_id
		JOIN film f ON fc.film_id = f.film_id
	WHERE LOWER(c.name) IN ('children', 'music', 'family', 'animation')
)
SELECT
    categoryName AS "Category",
    CASE
        WHEN quartile = 1 THEN '1st Quartile'
        WHEN quartile = 2 THEN '2nd Quartile'
        WHEN quartile = 3 THEN '3rd Quarter'
        ELSE '4th Quartile'
    END AS standard_quartile,
    COUNT(*) AS "Count"
FROM RentalDurationQuartiles
GROUP BY categoryName, quartile
ORDER BY categoryName, quartile;

-- Q4 Query used for fourth insight
SELECT
	EXTRACT (MONTH FROM rental_date) AS rental_month,
	EXTRACT (YEAR FROM rental_date) AS rental_year,
	store_id,
	COUNT(rental_date) AS count_rentals
FROM
	rental r
	JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY 
	rental_month, 
	rental_year, 
	store_id
ORDER BY 
	rental_year,
	rental_month,
	count_rentals DESC;
	
