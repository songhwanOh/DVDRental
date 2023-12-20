-- Q1
SELECT 
	filmTitle,
	categoryName,
	COUNT(filmTitle) AS rentalCount
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
ORDER BY 1;

	
	select * from rental;