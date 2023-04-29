/*
    You can get the Sakila DB on her Github:
    https://github.com/jOOQ/sakila

    And the ERD (Entity-Relationship Diagram) here:
    https://www.jooq.org/sakila
*/

-- 1. Mostrar nombres y apellidos de todos los actores.
SELECT first_name,last_name FROM actor;

-- 2. Mostrar el nombre y apellido de cada actor en una sola columna, en mayúscula.
-- Nombrar a la columna "Nombre del actor".
SELECT CONCAT_WS(', ',first_name,last_name) as "Actor's Name" FROM actor;

-- 3. Mostrar el ID, nombre y apellido de un actor, sabiendo que su nombre es "Joe".
SELECT actor_id,first_name,last_name FROM actor WHERE first_name = upper('Joe');

-- 4. Mostrar los actores cuyo apellido contenga "GEN".
SELECT first_name,last_name FROM actor WHERE upper(last_name) LIKE upper('%GEN%');

-- 5. Mostrar los actores cuyo apellido contenga "LI".
-- Ordena las filas por apellido y nombre (en ese orden).
SELECT first_name,last_name FROM actor WHERE upper(last_name) LIKE upper('%LI%') ORDER BY last_name, first_name;

-- 6. Usando la función IN, mostrar el nombre y apellido de todos los clientes llamados "Terry", "Jessie" o "Alice".
SELECT first_name,last_name FROM customer WHERE first_name IN ('Terry','Jessie','Alice');

-- 7. Mostrar el apellido de cada actor y la cantidad de actores que tienen ese apellido.
SELECT last_name, COUNT(first_name) FROM actor GROUP BY last_name;

-- 8. Mostrar cada apellido de actor y la cantidad de actores que lo tienen, pero únicamente si lo tienen al menos dos actores.
SELECT last_name, COUNT(first_name)FROM actor GROUP BY last_name HAVING COUNT(first_name) >= 2;

-- 9. Usando join, mostrar el nombre, apellido y dirección de cada miembro de la plantilla.
SELECT first_name,last_name,address FROM staff JOIN address ON staff.address_id = address.address_id;

-- 10. Mostrar el total recaudado por cada empleado durante agosto de 2005.
SELECT first_name,SUM(amount)
FROM staff
    JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment_date BETWEEN '2022-05-01' AND '2022-05-31'
GROUP BY first_name;

-- 11. Mostrar la cantidad de actores por cada película.
SELECT title,SUM(actor_id) FROM film JOIN film_actor ON film.film_id = film_actor.film_id GROUP BY title;

-- 12. ¿Cuántas copias hay inventariadas en el sistema de la película "Hunchback Impossible"?
SELECT title, COUNT(inventory.film_id)
FROM film
    JOIN inventory ON film.film_id = inventory.film_id
WHERE upper(title) = upper('Hunchback Impossible')
GROUP BY title;

-- 13. Mostrar el total de dinero pagado por cada cliente, en el caso de que haya realizado compras.
-- Ordenar los resultados por apellido de forma ascendente.
SELECT first_name, SUM(amount) FROM customer JOIN payment ON customer.customer_id = payment.customer_id GROUP BY first_name, last_name ORDER BY last_name;

-- 14. Mostrar el nombre y correo electrónico de todos los clientes canadienses.
SELECT first_name,last_name,email
FROM customer
    JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country oN city.country_id = country.country_id
WHERE upper(country.country) = upper('Canada');

-- 15. Identificar todas las películas familiares.
SELECT title FROM film
    JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
WHERE upper(category.name) = upper('Family');

-- 16. Mostrar las películas más arrendadas en orden descendente.
SELECT title, COUNT(rental.inventory_id) FROM film
    JOIN inventory ON film.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY COUNT(rental.inventory_id) DESC;

-- 17. Mostrar el dinero recaudado por cada tienda. - NO SE SI ES LOS STAFF
SELECT store.store_id,SUM(amount) FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;


-- 18. Actores que tengan una x en el nombre o en el apellido
SELECT first_name,last_name FROM actor WHERE (upper(first_name) LIKE upper('%x%')) OR (upper(last_name) LIKE upper('%x%'));

-- 19. Direcciones de california que tengan ‘274’ en el número de teléfono
SELECT address FROM address
WHERE upper(district) = upper('California') AND phone LIKE '%274%';
-- 20. Películas ‘Épicas’ (Epic) o ‘Brillantes’ (brilliant) que duren más de 180 minutos
SELECT title FROM film
WHERE (upper(description) LIKE upper('%Epic%')
OR upper(description) LIKE upper('%brillant%'))
AND length > 180;

-- 21. Películas que duren entre 100 y 120 minutos o entre 50 y 70 minutos
SELECT title,length FROM film WHERE length BETWEEN 100 AND 120 OR length BETWEEN 50 AND 70;

-- 22. Películas que cuesten 0.99, 2.99 y tengan un rating ‘g’ o ‘r’ y que traten de cocodrilos (crocodile)
SELECT title,rating,rental_rate
FROM film
WHERE
    (rental_rate = 0.99 OR rental_rate = 2.99)
        AND
    (rating = 'G' OR rating = 'R')
        AND
    upper(description) LIKE upper('%crocodile%');

-- 23. Which actors have the first name ‘Scarlett’
SELECT first_name,last_name FROM actor WHERE upper(first_name) = upper('Scarlett');

-- 24. Which actors have the last name ‘Johansson’
SELECT first_name,last_name FROM actor WHERE upper(last_name) = upper('Johansson');

-- 25. How many distinct actors last names are there?
SELECT COUNT(DISTINCT last_name) FROM actor;

-- 26. Which last names are not repeated?
SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) = 1;

-- 27. Which last names appear more than once?
SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;
-- 28. Which actor has appeared in the most films?
select concat(a.FIRST_NAME,' ', a.LAST_NAME) as "Full Name"
FROM film_actor f INNER JOIN actor a ON f.actor_id = a.actor_id
GROUP BY a.first_name,a.last_name
ORDER BY COUNT(f.actor_id) DESC
LIMIT 1;

-- 29. Is ‘Academy Dinosaur’ available for rent from Store 1?
SELECT title
FROM film
         JOIN inventory ON film.film_id = inventory.film_id
WHERE store_id = 1 AND upper(title) = upper('Academy Dinosaur') AND EXISTS(
    SELECT rental_id FROM rental WHERE rental.inventory_id = inventory.inventory_id AND return_date IS NOT NULL
    );

-- 30.Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .
SELECT customer_id,first_name, last_name FROM customer where upper(first_name) = upper('Mary'); -- 1
SELECT film_id,title,length FROM film WHERE upper(title) = upper('Academy Dinosaur'); -- 1
SELECT * FROM inventory WHERE film_id = 1;
SELECT * FROM rental ;
SELECT * FROM staff;
SELECT customer_id FROM customer WHERE upper(first_name) = upper('Mary') AND upper(last_name) = upper('Smith');

SELECT  * FROM inventory;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id) VALUES
    (now(),
    (SELECT inventory_id FROM film JOIN inventory ON film.film_id = inventory.film_id WHERE upper(title) = upper('Academy Dinosaur') AND store_id = 1 LIMIT 1),
    (SELECT customer_id FROM customer WHERE upper(first_name) = upper('Mary') AND upper(last_name) = upper('Smith')),
    null,
    (SELECT staff_id FROM staff WHERE upper(first_name) = upper('Mike') AND upper(last_name) = upper('Hillyer')
));
    SELECT * FROM staff;

-- 31. When is ‘Academy Dinosaur’ due?
SELECT title,CONCAT(rental_duration::varchar,rentaL_date::varchar,'DAYS') FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE upper(title) = upper('Academy Dinosaur');

SELECT rental_date, rental_duration, rental_date + interval '1' day * rental_duration AS due_date
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE upper(title) = upper('Academy Dinosaur');

-- 32. What is that average running time of all the films in the sakila DB?
SELECT AVG(length) AS "Duracion Media" FROM film;

-- 33. What is the average running time of films by category?
SELECT category.name,round(AVG(length),2) AS "Duracion Media" FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

-- 34.Why does this query return the empty set?
select * from film natural join inventory;
-- Ya que el Natural Join junta por los nombre de los campos
-- en esta query junta film_id de ambas pero también junta LAST_UPDATE

-- 35. What are the names of all the languages in the database (sorted alphabetically)?
SELECT name FROM language ORDER BY name;

-- 36. Return the full names (first and last) of actors with “SON” in their last name, ordered by their first name.
SELECT concat(first_name,' ',last_name) AS "Nombre Completo" FROM actor WHERE upper(last_name) LIKE upper('%SON%') ORDER BY first_name;

-- 37. Find all the addresses where the second address is not empty (i.e., contains some text), and return these second addresses sorted.
SELECT address,address2 FROM address WHERE address2 LIKE '_%' ORDER BY address2;

-- 38. Return the first and last names of actors who played in a film involving a “Crocodile”
-- and a “Shark”, along with the release year of the movie, sorted by the actors’ last names.
SELECT first_name,last_name,release_year FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE upper(description) LIKE upper('%Shark%') AND upper(description) LIKE upper('%Crocodile%')
ORDER BY last_name;

SELECT title,description FROM film WHERE upper(description) LIKE upper('%Shark%') AND upper(description) LIKE upper('%Crocodile%');

-- 39.Find all the film categories in which there are between 55 and 65 films. Return the
-- names of these categories and the number of films per category, sorted by the number of films.
SELECT name, COUNT(film_id) as numero_peliculas FROM category
JOIN film_category ON category.category_id = film_category.category_id
GROUP BY name
HAVING COUNT(film_id) BETWEEN 55 AND 65
ORDER BY numero_peliculas;

-- 40.In how many film categories is the average difference between the film replacement
-- cost and the rental rate larger than 17?
SELECT name,COUNT(film_category.category_id)
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY name
HAVING AVG(replacement_cost - rental_rate) > 17;

-- 42. Find the names (first and last) of all the actors and costumers whose first name is
-- the same as the first name of the actor with ID 8Do not return the actor with ID 8 himself. Note that you cannot use the name of the actor with ID 8 as a constant
-- (only the ID). There is more than one way to solve this question, but you need to
-- provide only one solution.
SELECT first_name,last_name
FROM actor
WHERE first_name = (
    SELECT first_name
    FROM actor
    WHERE actor_id = 8
) AND actor_id <> 8
 UNION
SELECT first_name,last_name
FROM customer
WHERE first_name = (
    SELECT first_name
    FROM actor
    WHERE actor_id = 8
) ;

-- 43.Find the actors who played a role in the movie 'Annie Hall'. Return all the fields of
-- actor table.
-- No existe la película 'Annie Hall'
SELECT * FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE upper(title) = upper('ANNIE IDENTITY');