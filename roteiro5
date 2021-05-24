/* Anna Beatriz Lucena Lira
Matrícula: 119110382
Roteiro 5 - Banco de Dados 1
*/

-- 1 Retornar quantas funcionárias estão cadastradas
SELECT COUNT(*) FROM employee AS e WHERE e.sex = 'F';

-- 2 Retornar a média de salário dos funcionários homens que moram no estado do Texas
SELECT AVG(e.salary) FROM employee AS e WHERE e.sex = 'M' and e.address LIKE '%, TX';

-- 3 Retornar o ssn dos supervisores e a quantidade de funcionários que cada um deles supervisiona (comtar também os que não são supervisionados por ninguém). Ordenar o resultado pela quantidade.
SELECT e.superssn AS ssn_supervisor, COUNT(*) AS qtd_supervisionados FROM employee AS e GROUP BY e.superssn ORDER BY qtd_supervisionados ASC;

-- 4 Para cada funcionário que supervisiona alguém, retornar seu nome e a quantidade de funcionários que supervisiona. O resultado deve ser ordenado pela quantidade de funcionários supervisionados. A consulta NÃO deve conter uma cláusula WHERE.
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS s JOIN employee AS e ON (s.ssn = e.superssn)) GROUP BY s.fname ORDER BY count(*) ASC;

-- 5 Faça uma consulta equivalente à anterior, porém considerando os funcionários que não possuem supervisor (note que o resultado possui uma linha a mais do que o resultado da questão anterior). Esra consulta também NÃO deve conter cláusula WHERE.
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS s RIGHT OUTER JOIN employee AS e ON (s.ssn = e.superssn)) GROUP BY s.fname ORDER BY count(*) ASC;

-- 6 Retornar a quantidade de funcionários que trambalham no(s) projeto(s) que contém menos funcionários.
SELECT MIN(COUNT) AS qtd FROM (SELECT COUNT(*) FROM works_on GROUP BY pno) AS works;

-- 7  Faça uma consulta equivalente à anterior, porém, retorne também o número do projeto.
SELECT pno AS num_projeto, qtd_geral AS qtd_func
FROM (
      (SELECT pno, COUNT(*) AS qtd_geral
        FROM works_on
        GROUP BY pno
      ) AS proj_qtd
 JOIN
     (SELECT MIN(COUNT) AS min_qtd FROM (
       SELECT COUNT(*) FROM works_on GROUP BY pno) AS qtds ) AS min_proj
  ON proj_qtd.qtd_geral = min_proj.min_qtd
);


-- 8 Retornar a média salarial por projeto
SELECT proj.pnumber AS num_proj, AVG(e.salary) AS media_sal FROM employee AS e, project AS proj, works_on AS w WHERE e.ssn = w.essn AND w.pno = proj.pnumber GROUP BY proj.pnumber;

-- 9 Altere a consulta anterior para retornar também os nomes dos projetos
SELECT proj.pnumber AS num_proj, proj.pname AS proj_nome, AVG(e.salary) AS media_sal FROM employee AS e, project AS proj, works_on AS w WHERE e.ssn = w.essn AND w.pno = proj.pnumber GROUP BY proj.pnumber;	

-- 10 Observe que o projeto 92 tem a maior média salarial. Faça uma consulta para retornar os funcionários que não trabalham neste projeto mas que possuam salário maior do que todos os funconários que trabalham neste projeto. Basta retornar o primeiro nome e o salário destes funcionários. O número 92 pode aparecer na consulta
SELECT e.fname, e.salary FROM employee AS e WHERE e.salary > ALL (SELECT f.salary FROM employee AS f, works_on AS w WHERE w.essn = f.ssn AND w.pno = 92); 

-- 11 Retornar a quantidade de projetos por funcionário, ordenado pela quantidade
SELECT e.ssn, COUNT(w.pno) AS qtd_proj FROM (employee AS e LEFT OUTER JOIN works_on AS w ON (w.essn = e.ssn)) GROUP BY e.ssn ORDER BY qtd_proj;

-- 12 Retornar a quantidade de funcionários por projeto (incluindo os funcionários "sem projeto"). Retornar apenas os projetos que possuem menos de 5 funcionários. Ordenar pela quantidade.
SELECT w.pno AS num_proj, COUNT(e.ssn) AS qtd_func FROM (works_on AS w RIGHT OUTER JOIN employee AS e ON ( w.essn = e.ssn))GROUP BY w.pno HAVING COUNT(e.ssn) < 5 ORDER BY qtd_func ASC;

-- 13 Usando consultas aninhadas e sem usar junções, formule uma consulta para retornar os primeiros nomes dos funcionários que trabalham no(s) projeto(s) localizado(s) em Sugarland e que possuem dependentes
SELECT e.fname 
FROM employee AS e
WHERE e.ssn IN (SELECT w.essn FROM works_on AS w WHERE w.pno IN (SELECT proj.pnumber FROM project AS proj WHERE proj.plocation = 'Sugarland')) 
AND e.ssn IN (SELECT essn FROM dependent) GROUP BY fname;


-- 14 Sem usar IN e sem usar nenhum tipo de junção (nem mesmo as junções feitas com produto cartesiano + filtragem usando cláusula WHERE), formule uma consulta para retornar o(s) departamentos que não possuem projetos. Não é proibido que a consulta contenha cláusula WHERE
SELECT d.dname FROM department AS d WHERE NOT EXISTS (SELECT * from project AS proj WHERE proj.dnum = d.dnumber);

-- 15 Retornar o primeiro e o último nome do(s) funcionário(s) que trabalham em todos os projetos em que trabalha o funcionário com ssn 123456789
SELECT DISTINCT e.fname, e.lname FROM employee AS e WHERE NOT EXISTS ((SELECT w.pno FROM works_on AS w WHERE w.essn = '123456789') EXCEPT (SELECT w2.pno FROM works_on AS w2 WHERE e.ssn = w2.essn AND NOT(w2.essn = '123456789')));

-- Para os incansáveis:
-- 16

SELECT e.fname, e.salary
FROM employee AS e
WHERE e.salary > ALL (
	SELECT e.salary
	FROM employee AS e, works_on AS w, (
	
	(SELECT proj.pnumber AS proj_num, AVG(e.salary) AS media_sal   
	FROM project AS proj, employee AS e, works_on AS w 
	WHERE proj.pnumber = w.pno AND w.essn = e.ssn 
    GROUP BY proj.pnumber) AS medias_projs
            
    JOIN 
   
	(SELECT MAX(media_proj) AS max_media
    FROM(
    	SELECT AVG(e.salary) AS media_proj 
        FROM project AS proj, employee AS e, works_on AS w
        WHERE proj.pnumber = w.pno AND w.essn = e.ssn 
        GROUP BY proj.pnumber, proj.pname)
     	AS all_medias)
    	AS max_media_projs
    	ON medias_projs.media_sal = max_media_projs.max_media)
  		AS sal_max_media_proj
        	
WHERE w.pno = sal_max_media_proj.proj_num AND w.essn = e.ssn);

