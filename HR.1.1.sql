-- 1. MOSTRAR LOS NOMBRES Y APELLIDOS DE TODOS LOS EMPLEADOS CON SU RESPECTIVO NOMBRE DEL DEPARTAMENTO AL CUAL PERTENECEN
SELECT 
    em.first_name AS NOMBRE,
    em.last_name AS APELLIDO,
    de.department_name AS DEPARTAMENTO
FROM employees em
    INNER JOIN departments de ON de.department_id = em.department_id;

-- 2. MOSTRAR LOS NOMBRES Y APELLIDOS DE TODOS LOS EMPLEADOS CON SU RESPECTIVO NOMBRE DEL DEPARTAMENTO AL CUAL PERTEBECEN DE 
--AQUELLOS CUYA FECHA DE CONTRATO ESTE ENTRE '10/07/2005 AND 16/07/2006'
SELECT 
    em.first_name AS NOMBRE,
    em.last_name AS APELLIDO,
    de.department_name AS DEPARTAMENTO
FROM employees em
    INNER JOIN departments de ON de.department_id = em.department_id
    WHERE em.hire_date BETWEEN '10/07/2005' AND '16/07/2006';

-- 3. REALICE UNA CONSULTA QUE MUESTRE EL NOMBRE Y APELLIDO DE LOS EMPLEADOS QUE TRABAJAN PARA DEPARTAMENTOS QUE ESTAN LOCALIZADOS 
--EN PAISES CUYO NOMBRE COMIENZA CON LA LETRA C, QUE MUESTRE EL NOMBRE DEL PAIS.

SELECT
    em.first_name AS NOMBRE,
    em.last_name AS APELLIDO,
    de.department_name AS DEPARTAMENTO,
    co.country_name AS PAIS
FROM employees em
    INNER JOIN departments de ON de.department_id = em.department_id
    INNER JOIN locations lo ON lo.location_id = de.location_id
    INNER JOIN countries co ON co.country_id = lo.country_id
    WHERE UPPER(co.country_name) LIKE 'C%';

-- 4. MUESTRE EL SALARIO MAS ALTO, MAS BAJO, SALARIO TOTAL DE LA PLANILLA Y SALARIO PROMEDIO DE LA TABLA EMPLEADOS. 
--ETIQUETE LAS COLUMNAS COMO <<SALARIO MAXIMO>>, <<SALARIO MINIMO>>, <<SALARIO PLANILLA>> Y <<SALARIO PROMEDIO>> RESPECTIVAMENTE. 
--REDONDEE LOS RESULTADOS AL VALOR ENTERO MAS CERCANO, CON UN FORMATO NUMRICO PARA LA MONEDA DE DOLARES.

SELECT 
    TO_CHAR(MAX(ROUND(em.salary)),'$999,999,999.00') AS "SALARIO MAXIMO",
    TO_CHAR(MIN(ROUND(em.salary)),'$999,999,999.00') AS "SALARIO MINIMO",
    TO_CHAR(SUM(ROUND(em.salary)),'$999,999,999.00') AS "SALARIO PLANILLA",
    TO_CHAR(AVG(ROUND(em.salary)),'$999,999,999.00') AS "SALARIO PROMEDIO"
FROM employees em; 

-- 5. ESCRIBA UNA CONSULTA QUE MUESTRE LA CANTIDAD DE PERSONAS QUE TIENEN EL MISMO PUESTO 
--Y A CUANTO ASCIENDE LA SUMA TOTAL DE SUS SALARIOS.
--EL RESULTADO DEBE MOSTRARSE EN ORDEN DESENDENTE POR EL PUESTO QUE TIENE LA MAYOR CANTIDAD DE EMPLEADOS

SELECT
    jo.job_title AS PUESTO,
    COUNT(em.job_id) AS ID,
    TO_CHAR(ROUND(SUM(em.salary)),'999,999.00') AS SALRIO
FROM jobs jo
    INNER JOIN employees em ON jo.job_id = em.job_id
    GROUP BY jo.job_title
    ORDER BY 2 DESC;

-- 6. REALICE UNA CONSULTA QUE LISTE EL NOMBRE Y APELLIDO, SALARIO DEL EMPLEADO, EL NOMBRE DEL DEPARTAMENTO AL QUE PERTENECE,
--LA DIRECCION, EL CODIGO POSTAL Y LA CUIDAD DONDE ESTA UBICADO EL DEPARTAMENTO, SE DEBE MOSTRAR UNICAMENTE AQUELLOS QUE 
--SEAN DEL DEPARTAMENTO 100.80 Y 50 RESPECTIVAMENTE, ADEMAS DEBEN PERTENECER UNICAMENTE A LA CIUDAD DEL SUR DE SAN FRANCISCO
--Y EL RANGO DE SALARIO DEBE SER ENTRE 4000 Y 8000 INCLUYENDO LOS VALORES LIMITES.

SELECT
    em.first_name AS NOMBRE,
    em.last_name AS APELLIDO,
    em.salary AS SALARIO,
    de.department_name DEPARTAMENTO,
    loc.street_address AS DIRECCION,
    loc.postal_code AS CODIGO_POSTAL,
    loc.city AS CIUDAD,
    loc.state_province AS PROVINCIA
FROM
    employees em
    INNER JOIN departments de ON em.department_id = de.department_id
    INNER JOIN locations loc ON de.location_id = loc.location_id
WHERE   em.salary BETWEEN 4000 AND 8000
    AND loc.city = 'South San Francisco'
ORDER BY 3;
    
-- 7. POR DEPARTAMENTO SE NECESITA SABER QUIÉNES SON LOS EMPLEADOS QUE TIENEN MAYOR TIEMPO EN LA EMPRESA.

SELECT
    emp.hire_date AS ANTIGUEDAD,
    dep.department_name AS DEPARTAMENTO,
    emp.first_name AS NOMBRE
FROM
    employees emp
    INNER JOIN departments dep ON emp.department_id = dep.department_id
WHERE (emp.hire_date, dep.department_name) IN
    (
    SELECT 
        MIN(em.hire_date),
        de.department_name
    FROM
        employees em
        INNER JOIN departments de ON em.department_id = de.department_id
    GROUP BY de.department_name
    )
;




-- 8. DEL ESQUEMA HR SE NECESITA SABER CUÁNTOS EMPLEADOS GANAN COMISIÓN. LA EVALUACIÓN SE REALIZA POR DEPARTAMENTO.

SELECT
    COUNT(em.commission_pct) AS EMPLEADOS_COMISION,
    de.department_name AS DEPARTAMENTO
FROM
    employees em
    INNER JOIN departments de ON em.department_id = de.department_id
WHERE
    em.commission_pct >= 0
   -- AND 
GROUP BY de.department_name
;

-- 9. DESARROLLE UNA CONSULTA DONDE MUESTRE EL CODIGO DE EMPLEADO, SALARIO, NOMBRE DE REGION, NOMBRE DE PAIS,
--ESTADO DE LA PROVINCIA, CODIGO DE APARTAMENTO DONDE CUMPLA LAS SIGUIENTES CONDICIONES:
-- A)* QUE LOS EMPLEADOS QUE SELECCIONES SU SALARIO SEA MAYOR AL PROMEDIO DE SU DEPARTAMENTO
-- B)* QUE NO SELECCIONES LOS DEL ESTADO DE LA PROVINCIA TEXAS
-- C)* QUE ORDENE LA INFORMACION POR CODIGO DE EMPLEADO ASCENDENTE
-- D)* QUE NO ESCOJA LOS DEL DEPARTAMENTO DE FINANZAS (FINANCE)


SELECT 
    emp.employee_id AS ID_EMPLEADO,
    emp.salary AS SALARIO,
    reg.region_name AS REGION,
    cou.country_name AS PAIS,
    loc.state_province AS PROVINCIA,
    emp.department_id AS DEPARTAMENTO_ID,
    dep.department_name AS NOMBRE_DEPARTAMENTO
FROM 
    locations loc
    INNER JOIN departments dep ON dep.location_id = loc.location_id
    INNER JOIN countries cou ON loc.country_id = cou.country_id
    INNER JOIN employees emp ON emp.department_id = dep.department_id
    INNER JOIN regions reg ON cou.region_id = reg.region_id
WHERE

    emp.salary > (SELECT
                    AVG(emps.salary)                    
                  FROM
                    employees emps
                  WHERE
                    emps.department_id = emp.department_id
                  GROUP BY emps.department_id
                  )
                
    AND UPPER (loc.state_province) != 'TEXAS' 
    AND dep.department_id != 108    
ORDER BY 1 ASC
;

-- 10. MOSTRAR EL NOMBRE, CODIGO DE DEPARTAMENTO Y SALARIO DE LOS EMPLEADOS ESPECIFICANDO QUE ES BAJO SI ES MENOR A 6000, REGULAR SI ESTA ENTRE 6000
-- Y MENOR DE 10000 Y ALTO SI ES MAYOR O IGUAL A 10000 EN UNA COLUMNA LLAMADA CATEGORIA PARA LOS EMPLEADOS QUE ESTAN EN LOS DEPARTAMENTOS 
-- CON IDENTIFICADOR MENORES O IGUALES A 30.

SELECT
    em.first_name AS NOMBRE,
    em.last_name AS APELLIDO,
    em.department_id AS ID_DEPARTAMENTO,
    em.salary AS SALARIO,
    CASE
        WHEN salary < 6000 THEN 'BAJO'
        WHEN salary BETWEEN 6000 AND 9999 THEN 'REGULAR'
        WHEN salary >= 10000 THEN 'ALTO'
        END AS CATEGORIA
FROM
    employees em
WHERE
    em.department_id <= 30
;    
    
