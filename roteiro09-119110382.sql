--QUESTÃO 1
--A
CREATE VIEW vw_dptmgr 
AS SELECT d.dnumber, e.fname, e.lname 
FROM department AS d, employee AS e 
WHERE d.mgrssn = e.ssn;


----------------------------------------------------------------------------------------
--B
CREATE VIEW vw_empl_houston 
AS SELECT ssn, fname 
FROM employee 
WHERE address LIKE '%Houston%';


----------------------------------------------------------------------------------------
--C
CREATE VIEW vw_deptstats 
AS SELECT dnumber, dname, count(*) AS qtd_employee 
FROM department AS d, employee AS e
WHERE d.dnumber = e.dno GROUP BY d.dnumber;

----------------------------------------------------------------------------------------
--D
CREATE VIEW vw_projstats 
AS SELECT pno, count(*) 
FROM works_on 
GROUP BY pno;



-----------------------------------------------------------------------------------------

-- QUESTÃO 2
SELECT * FROM vw_dptmgr;
SELECT * FROM vw_empl_houston;
SELECT * FROM vw_deptstats;
SELECT * FROM vw_projstats;

-----------------------------------------------------------------------------------------

-- QUESTÃO 3
DROP VIEW vw_dptmgr;
DROP VIEW vw_empl_houston;
DROP VIEW vw_deptstats;
DROP VIEW vw_projstats;

-----------------------------------------------------------------------------------------

-- QUESTÃO 4
CREATE OR REPLACE FUNCTION check_age(emp_ssn char(9))
RETURNS varchar(7) AS
$$

DECLARE
employee_age integer;
BEGIN
    
    	SELECT date_part('year'::text, age((bdate)::timestamp WITH time zone))
    	INTO employee_age
    	FROM employee AS e
    	WHERE e.ssn = emp_ssn;
    	
	IF (employee_age >= 50) THEN RETURN 'SENIOR';
	ELSIF (employee_age <50 and employee_age >= 0) THEN RETURN 'YOUNG';
        ELSIF (employee_age IS NULL) THEN RETURN 'UNKNOWN';
        ELSE RETURN 'INVALID';
        	
	END IF;
   	 
END;
$$  LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------

-- QUESTÃO 5

CREATE OR REPLACE FUNCTION check_mgr() 
RETURNS TRIGGER AS $check_mgr$

DECLARE
employee_dno integer;
number_subordinates integer;
    BEGIN
     	SELECT e.dno 
     	FROM employee AS e 
     	INTO employee_dno
     	WHERE e.ssn = NEW.mgrssn;
     	
     	SELECT count(*)
     	FROM employee AS e
     	INTO number_subordinates
     	WHERE e.superssn = NEW.mgrssn;
     	
     	
        IF (NEW.dnumber <> employee_dno OR NEW.mgrssn IS NULL OR NEW.mgrssn NOT IN (SELECT ssn FROM employee)) THEN
            RAISE EXCEPTION 'manager must be a department''s employee';
        END IF;
        
        IF check_age(NEW.mgrssn) <> 'SENIOR' THEN
            RAISE EXCEPTION 'manager must be a SENIOR employee';
        END IF;
        IF (number_subordinates = 0 OR number_subordinates IS NULL) THEN
            RAISE EXCEPTION 'manager must have supevisees';
        END IF;
        RETURN NEW;
    END;
$check_mgr$ LANGUAGE plpgsql;



CREATE TRIGGER check_mgr BEFORE INSERT OR UPDATE ON department
    FOR EACH ROW EXECUTE PROCEDURE check_mgr();


