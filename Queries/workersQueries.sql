-- 1. Find out those workers whose fee is between 10 and 12.
SELECT (name,fee) FROM workers WHERE CAST(fee AS numeric) BETWEEN  10 AND 12;

-- 2. What are the jobs of the workers assigned to the 435 building?
SELECT (name,job) FROM workers JOIN assignments a on workers.id = a.worker_id WHERE a.building_id = 435;

-- 3. Find out the name of each worker and his supervisor.
SELECT employees.name AS Employees, supervisor.name AS Supervisor FROM workers employees JOIN workers supervisor ON employees.supervisor_id = supervisor.id AND employees.id <> supervisor.id;

-- 4. Get the names of those workers assigned to offices.
SELECT DISTINCT (name) FROM workers JOIN assignments a on workers.id = a.worker_id JOIN buildings b on b.id = a.building_id WHERE b.type = 'office';

-- 5. Which workers receive a higher hourly rate than their supervisor?
SELECT employees.name AS Employees, supervisor.name AS Supervisor FROM workers employees JOIN workers supervisor ON employees.supervisor_id = supervisor.id WHERE employees.fee > supervisor.fee;

-- 6. What is the total number of days that have been spent plumbing in the 312 building?
SELECT SUM(days) FROM workers JOIN assignments a on workers.id = a.worker_id JOIN buildings b on b.id = a.building_id WHERE job = 'plumber' AND building_id = 312;

-- 7. How many different types of jobs are there?
SELECT count(DISTINCT job) FROM workers;

-- 8. For each supervisor, what is the highest hourly rate paid to a worker who reports to that supervisor?
SELECT supervisor.name AS Supervisor, max(employees.fee)
FROM workers employees
    JOIN workers supervisor ON employees.supervisor_id = supervisor.id
GROUP BY supervisor.name;

-- 9. For each supervisor who supervises more than one worker, what is the highest fee for a worker reporting to that supervisor?
SELECT supervisor.name AS Supervisor, max(employees.fee) FROM workers employees JOIN workers supervisor ON employees.supervisor_id = supervisor.id WHERE employees.id != supervisor.supervisor_id GROUP BY supervisor.name;

-- 10. For each type of building, what is the average quality level of category 1 buildings?
-- Consider only those buildings that have a maximum quality level no higher than 3.
SELECT type, AVG(level) FROM buildings WHERE category = 1 AND level <= 3 GROUP BY type;

-- 11. Which workers receive less than the average hourly rate?
SELECT name,fee FROM workers WHERE fee::numeric < (
    SELECT AVG(fee :: numeric) FROM workers
    );

-- 12. Which workers receive a lower hourly rate than the average of workers in the same job?
SELECT name,job FROM workers WHERE fee::numeric < (
    SELECT AVG(fee :: numeric) FROM workers
) GROUP BY job, name;

SELECT name,job FROM workers w1 WHERE fee::numeric < (
    SELECT AVG(fee :: numeric) FROM workers w2 WHERE w1.job = w2.job
) GROUP BY job, name;

-- 13. Which workers receive less than the average hourly rate of workers who report to the same supervisor as him?
SELECT w.name
FROM workers w
WHERE w.fee :: numeric < (
    SELECT AVG(w2.fee :: numeric)
    FROM workers w2
    WHERE w2.supervisor_id = w.supervisor_id
);
SELECT supervisor_id, AVG(fee :: numeric) FROM workers GROUP BY supervisor_id;

-- 14. Select the name of those electricians assigned to the building 435 and the date they started working there.
SELECT name, min(start_date)FROM workers JOIN assignments a on workers.id = a.worker_id
WHERE job = 'electrician' AND building_id = 435
GROUP BY name;

-- 15. What supervisors have workers who have a fee above 12?
SELECT DISTINCT w1.supervisor_id
FROM workers w1
         JOIN workers w2 ON w1.id = w2.supervisor_id
WHERE w2.fee :: numeric > 12;

-- 16. Increase the hourly rate of all workers supervised by Supervisor C. COULOMB by 5 percent
UPDATE workers
SET fee = fee * 1.05
WHERE supervisor_id = (SELECT id FROM workers WHERE name = 'C. Coulomb');