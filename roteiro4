/* Anna Beatriz Lucena Lira
Matrícula: 119110382
Roteiro 4 - Banco de Dados 1
*/

-- QUESTÃO 1 Retornar todos os elementos da tabela department
SELECT * FROM department;

-- QUESTÃO 2 Retornar todos os elementos da tabela dependent
SELECT * FROM dependent;

-- QUESTÃO 3 Retornar todos os elementos da tabela dept_locations
SELECT * FROM dept_locations;

-- QUESTÃO 4 Retornar todos os elementos da tabela employee
SELECT * FROM employee;

-- QUESTÃO 5 Retornar todos os elementos da tabela project
SELECT * FROM project;

-- QUESTÃO 6 Retornar todos os elementos da tabela works_on
SELECT * FROM works_on;

-- QUESTÃO 7 Retornar os nomes (primeiro e último) dos funcionários homens
SELECT fname, lname FROM employee WHERE sex = 'M';

-- QUESTÃO 8 Retornar os nomes (primeiro) dos funcionários homens que não pussuem supervisor
SELECT fname FROM employee WHERE sex = 'M' AND superssn IS NULL;

-- QUESTÃO 9 Retornar os nomes dos funcionários (primeiro) e o nome (primeiro) do seu supervisor, apenas para os funcionários que possuem supervisor
SELECT e.fname, s.fname FROM employee AS e, employee AS s WHERE e.superssn IS NOT NULL AND e.superssn = s.ssn; 

-- QUESTÃO 10 Retornar os nomes (primeiro) dos funcionários supervisionados por Franklin
SELECT e.fname, s.fname FROM employee AS e, employee AS s WHERE s.fname = 'Franklin' AND e.superssn = s.ssn;

-- QUESTÃO 11 Retornar os nomes dos departamentos e suas localizações
SELECT d.dname, dl.dlocation FROM department AS d, dept_locations AS dl WHERE d.dnumber = dl.dnumber;

-- QUESTÃO 12 Retornar os nomes dos departamentos localizados em cidades que começam com a letra 'S'
SELECT d.dname FROM department AS d, dept_locations AS dl WHERE d.dnumber = dl.dnumber AND dl.dlocation LIKE 'S%';

-- QUESTÃO 13 Retornar os nomes (primeiro e último) dos funcionários e seus dependentes (apenas para os funcionários que possuem dependentes
SELECT e.fname, e.lname, dt.dependent_name FROM employee AS e, dependent AS dt WHERE dt.essn = e.ssn;

-- QUESTÃO 14 Retornar o nome completo dos funcionários que possuem salário maior do que 50 mil. A relação de retorno deve ter apenas duas colunas: "full_name" e "salary". O nome completo deve ser formado pela concatenação dos valores das 3 colunas com dados sobre nome. Use o operador || para concatenar strings
SELECT (e.fname || ' ' || e.minit || ' ' || e.lname) AS full_name, e.salary FROM employee AS e WHERE e.salary > 50000;

-- QUESTÃO 15 Retornar os projetos (nome) e os departamentos responsáveis (nome)
SELECT p.pname, d.dname FROM project AS p, department AS d WHERE d.dnumber = p.dnum;

-- QUESTÃO 16 Retornar os projetos (nome) e os gerentes dos departamentos responsáveis (primeiro nome). Retornar resultados apenas para os projetos com código maior do que 30
SELECT p.pname, e.fname FROM project AS p, employee AS e, department AS d WHERE d.dnumber = p.dnum AND e.ssn = d.mgrssn AND p.pnumber > 30;

-- QUESTÃO 17 Retornar os projetos (nome) e os funcionários que trabalham neles (primeiro nome).
SELECT p.pname, e.fname FROM project AS p, employee AS e, works_on AS w WHERE w.pno = p.pnumber AND w.essn = e.ssn;

-- QUESTÃO 18 Retornar os nomes dos dependentes dos funcionários que trabalham no projeto 91. Retornar também o nome (primeiro) do funcionário e o relacionamento entre eles.
SELECT e.fname, ddt.dependent_name, ddt.relationship FROM dependent AS ddt, project AS p, works_on AS w, employee AS e WHERE e.ssn = ddt.essn AND e.ssn = w.essn AND p.pnumber = 91 AND p.pnumber = w.pno;

