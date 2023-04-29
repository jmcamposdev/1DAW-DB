-- 2. Get the salary of each employee with his or her name.
SELECT (first_name,last_name,salary) FROM employees;

-- 3. Get all the different salaries of the employees.
SELECT DISTINCT salary FROM employees;

-- 4. Find out what employees are working for the department number 2.
SELECT (first_name,last_name,salary,employees.department_id) FROM employees WHERE department_id = 2;

-- 5. Find out all the employees from the departments 1 and 2.
SELECT (first_name,last_name,salary,employees.department_id) FROM employees WHERE department_id = 1 OR department_id = 2;

-- 6. Find out all the employees with unknown salary.
SELECT (first_name,last_name) from employees WHERE salary IS NULL;

-- 7. Look for all the employees from Sidney.
SELECT (first_name,last_name) FROM employees JOIN departments d on employees.department_id = d.department_id JOIN projects p on d.department_id = p.department_id WHERE p.place = 'Sidney';

-- 8. Look for all the employees from towns starting with S (e.g. Stockholm, Sidney, etc.).
SELECT (first_name,last_name,p.place) FROM employees JOIN departments d on employees.department_id = d.department_id JOIN projects p on d.department_id = p.department_id WHERE p.place LIKE 'S%';
SELECT (first_name,last_name)
FROM employees
JOIN works_in ON employees.employee_id = works_in.employee_id
JOIN projects ON works_in.project_id = projects.project_id
WHERE projects.place LIKE 'M%';
-- 9. What employees have no supervisor?
SELECT (first_name,last_name) FROM employees WHERE supervisor_id IS NULL;

-- 10. What employees are supervisors?
SELECT DISTINCT (e.employee_id,e.supervisor_id,e.first_name,e.last_name) FROM employees e JOIN employees em ON e.employee_id = em.supervisor_id;

-- 11. Find out all the employees from the ‘Research’ department.
SELECT (first_name,last_name,departments.name) FROM employees JOIN departments ON employees.department_id = departments.department_id WHERE departments.name = 'Research';

-- 12. Find out all the employees from the ‘Research’ department, along with the department data.
SELECT (first_name,last_name,departments.name) FROM employees JOIN departments ON employees.department_id = departments.department_id WHERE departments.name IN ('Research','Data');

-- 13. Get the list with all the employees along with their supervisors.
SELECT (e.first_name,e.last_name,em.first_name,em.last_name) FROM employees e,employees em WHERE e.supervisor_id = em.employee_id;
-- SELECT employees.first_name, employees.last_name, supervisors.first_name, supervisors.last_name FROM employees JOIN employees AS supervisors ON employees.supervisor_id = supervisors.employee_id;

-- 14. Get the combinations of employees with their departments.
SELECT employees.first_name, employees.last_name, departments.name FROM employees JOIN departments ON employees.department_id = departments.department_id;

-- 15. Get the list of all the departments along with the names of their employees. The result must
-- be sorted:
-- ◦ In descending order for the department name.
-- ◦ In ascending order for employee surname.
SELECT (d.name,e.first_name,e.last_name) FROM employees e JOIN departments d on e.department_id = d.department_id ORDER BY d.name DESC,e.last_name;

-- 16. Calculate the total salaries, the higest salary, the lowest one and the average salary for all the employees.
SELECT SUM(salary),MAX(salary),MIN(salary),AVG(salary::numeric) FROM employees;

-- 17. Calculate the total salaries, the higest salary, the lowest one and the average salary for all the employees
-- from the ‘Research’ department.
SELECT SUM(salary) as total_salaries,
       MAX(salary) as highest_salary,
       MIN(salary) as lowest_salary,
       AVG(salary::numeric) as average_salary FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE name = 'Research');

-- 18. How many people work in the ‘Research department’?
SELECT COUNT(*) FROM departments d JOIN employees e ON e.department_id = d.department_id WHERE d.department_id = 2;

-- 19. How many different salaries are in the database?
SELECT COUNT(DISTINCT salary) FROM employees;

-- 20. Find out what employees have worked in projects from other departments different to the
-- one they are assigned to.
SELECT (e.first_name,e.last_name,e.department_id,p.department_id) FROM employees e JOIN works_in wi on e.employee_id = wi.employee_id JOIN projects p on p.project_id = wi.project_id WHERE e.department_id != p.department_id;

-- 21. What’s the total budget for each department?
SELECT (d.name,SUM(p.budget))FROM departments d JOIN projects p on d.department_id = p.department_id
group by d.name;