CREATE TABLE tarefas(
id_tarefas integer,
descriçao varchar(100),
cpf_funcionario char(11),
prioridade integer,
status char(1)
 );


INSERT INTO tarefas VALUES(2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');


INSERT INTO tarefas VALUES(2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');


INSERT INTO tarefas VALUES(null, null, null, null, null);


INSERT INTO tarefas VALUES(2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');
--ERROR:  value too long for type character(11)


INSERT INTO tarefas VALUES(2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');
--ERROR:  value too long for type character(1)

--questão 2

INSERT INTO tarefas VALUES(2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');
--ERROR:  integer out of range

ALTER TABLE tarefas ALTER COLUMN id_tarefas TYPE bigint;
--ALTER TABLE



INSERT INTO tarefas VALUES(2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');


ALTER TABLE tarefas ALTER COLUMN prioridade TYPE smallint;

INSERT INTO tarefas VALUES(2147483649, 'limpar portas da entrada principal', '32322525199',32768, 'A');
--ERROR:  smallint out of range

INSERT INTO tarefas VALUES(2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A');
--ERROR:  smallint out of range

INSERT INTO tarefas VALUES(2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A');



INSERT INTO tarefas VALUES(2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');




--questao 4

ALTER TABLE tarefas ALTER COLUMN id_tarefas SET NOT NULL;
--ERROR:  column "id_tarefas" contains null values


ALTER TABLE tarefas ALTER COLUMN descriçao SET NOT NULL;
--ERROR:  column "descriçao" contains null values

ALTER TABLE tarefas ALTER COLUMN cpf_funcionario SET NOT NULL;
--ERROR:  column "cpf_funcionario" contains null values


ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
--ERROR:  column "prioridade" contains null values

ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;
--ERROR:  column "status" contains null values

--alterando nome dos atributos
ALTER TABLE tarefas RENAME COLUMN id_tarefas TO id;
--ALTER TABLE
ALTER TABLE tarefas RENAME COLUMN descriçao TO descricao;
--ALTER TABLE
ALTER TABLE tarefas RENAME COLUMN cpf_funcionario TO func_resp_cpf;
--ALTER TABLE

DELETE FROM tarefas WHERE id IS NULL;
--DELETE 1


-- adicionando o set not null
ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
--ALTER TABLE
ALTER TABLE tarefas ALTER descricao SET NOT NULL;
--ALTER TABLE
ALTER TABLE tarefas ALTER func_resp_cpf SET NOT NULL;
--ALTER TABLE
ALTER TABLE tarefas ALTER prioridade SET NOT NULL;
--ALTER TABLE
ALTER TABLE tarefas ALTER status SET NOT NULL;
--ALTER TABLE

--questao 5

INSERT INTO tarefas VALUES(2147483653, 'limpar portas do 1o andar', '32323232911',2, 'A');


ALTER TABLE tarefas ADD CONSTRAINT tarefas_pkey PRIMARY KEY(id);
--ALTER TABLE

INSERT INTO tarefas VALUES(2147483653, 'aparar a grama da área frontal', '32323232911',3, 'A');
--ERROR:  duplicate key value violates unique constraint "tarefas_pkey"
--DETAIL:  Key (id)=(2147483653) already exists.


--questao 6

--a

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_func_resp_cpf_valido CHECK(LENGTH(func_resp_cpf) = 11);

--adicionando com cpf menor

INSERT INTO tarefas VALUES(2147483000, 'aparar a grama da área frontal', '323232',3, 'A');
--ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_func_resp_cpf_valido"
--DETAIL:  Failing row contains (2147483000, aparar a grama da área frontal, 323232     , 3, A).


--adicionando com cpf maior 

INSERT INTO tarefas VALUES(2147483000, 'aparar a grama da área frontal', '323232000000000000',3, 'A');
--ERROR:  value too long for type character(11)


--b

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_status_possiveis CHECK (status = 'P' OR status = 'E' OR status = 'C');
--ERROR:  check constraint "tarefas_chk_status_possiveis" is violated by some row


UPDATE tarefas SET status = 'P' WHERE status = 'A';
--UPDATE 4
UPDATE tarefas SET status = 'E' WHERE status = 'R';
--UPDATE 0
UPDATE tarefas SET status = 'C' WHERE status = 'F';
--UPDATE 2


ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_status_possiveis CHECK (status = 'P' OR status = 'E' OR status = 'C');
--ALTER TABLE



-- questao 7

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridades_possiveis CHECK (prioridade >= 0 AND prioridade <=5 );
--ERROR:  check constraint "tarefas_chk_prioridades_possiveis" is violated by some row

UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridades_possiveis CHECK (prioridade >= 0 AND prioridade <=5 );


-- questao 8

CREATE TABLE funcionario(
cpf char(11) NOT NULL,
data_nasc date NOT NULL,
nome varchar(80) NOT NULL,
funcao varchar(11) NOT NULL,
nivel char(1) NOT NULL,
superior_cpf char(11),
CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY(superior_cpf) REFERENCES funcionario(cpf),
CONSTRAINT funcionario_pkey PRIMARY KEY(cpf),
CONSTRAINT funcionario_funcao_valida_chk CHECK ((funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL) OR (funcao = 'SUP_LIMPEZA')),
CONSTRAINT funcionario_niveis_validos_chk CHECK (nivel = 'J' OR nivel = 'P' OR nivel = 'S')
);
--CREATE TABLE



INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA','S', null); 



INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA','J', 12345678911); 



INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA','J', null); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_valida_chk"
--DETAIL:  Failing row contains (12345678913, 1980-04-09, joao da Silva, LIMPEZA, J, null).


-- questao 9

-- execuções corretas

--1 inserir funcionario superior S
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90080070060', '1988-04-25', 'Jorge', 'SUP_LIMPEZA','S', null); 



--2 inserir outro funcionario superior S

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('50040030020', '1987-11-30', 'Cristiano', 'SUP_LIMPEZA','S', null); 



--3 inserir outro funcionario superior P
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40030020010', '1995-02-02', 'Leonardo', 'SUP_LIMPEZA','P', null);




--4 inserir outro funcionario superior S

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60050040030', '1994-01-21', 'Marcos', 'SUP_LIMPEZA','S', null); 




--5 inserir outro funcionario superior P
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60050040031', '1993-11-11', 'Gabriel', 'SUP_LIMPEZA','P', null); 


--6 inserir funcionario J limpeza
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40070089000', '2000-09-09', 'Pietro', 'LIMPEZA','J', '90080070060');


--7 inserir funcionario P limpeza
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40000000000', '1999-05-20', 'Enzo', 'LIMPEZA','P', '50040030020');


--8 inserir outro funcionario J limpeza

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40009999999', '1999-10-11', 'Felipe', 'LIMPEZA','J', '40030020010');


--9 inserir funcionario superior S
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('80101010101', '1987-11-21', 'Paschoal', 'SUP_LIMPEZA','S', null); 


--10 inserir funcionario superior P
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('91191919111', '1988-06-06', 'Pedro Coelho', 'SUP_LIMPEZA','P', null); 



-- execuções que causam erro


--1  viola restrição de nivel pois nivel nao existe
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60976549182', '1991-02-11', 'Aristoteles Silva', 'LIMPEZA','T', '25678901876'); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_niveis_validos"
--DETAIL:  Failing row contains (60976549182, 1991-02-11, Aristoteles Silva, LIMPEZA, T, 25678901876).

--2 viola restição de not null do cpf do funcionario
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES (null, '1999-01-01', 'Maria Silva', 'LIMPEZA','J', '25678901876'); 
--ERROR:  null value in column "cpf" violates not-null constraint
--DETAIL:  Failing row contains (null, 1999-01-01, Maria Silva, LIMPEZA, J, 25678901876).

--3 viola restição do tipo de funcionario pois tipo nao existe
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20709822222', '1990-08-21', 'Pedro Henrique Barbosa', 'ATENDENTE','J', null); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_valida_chk"
--DETAIL:  Failing row contains (20709822222, 1990-08-21, Pedro Henrique Barbosa, ATENDENTE, J, null).

--4 viola restrição de not null do nome do funcionario
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20755555903', '1970-03-05', null, 'SUP_LIMPEZA','S', null); 
--ERROR:  null value in column "nome" violates not-null constraint
--DETAIL:  Failing row contains (20755555903, 1970-03-05, null, SUP_LIMPEZA, S, null).


--5 viola restrição de not null da data de nascimento do funcionario
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('36589076542',null, 'Maria Cecilia Barros', 'SUP_LIMPEZA','S', null); 
--ERROR:  null value in column "data_nasc" violates not-null constraint
--DETAIL:  Failing row contains (36589076542, null, Maria Cecilia Barros, SUP_LIMPEZA, S, null).

--6 viola restrição de not null da função do funcionario
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('36588888888','2000-08-09', 'Maria Cecilia Barros',null,'J', '11111111111'); 

--ERROR:  null value in column "funcao" violates not-null constraint
--DETAIL:  Failing row contains (36588888888, 2000-08-09, Maria Cecilia Barros, null, J, 11111111111).

--7 viola restrição de not null do nivel do funcionario
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90876409217','1988-10-11', 'Cesar Ribeiro','LIMPEZA',null, '80123498501'); 
--ERROR:  null value in column "nivel" violates not-null constraint
--DETAIL:  Failing row contains (90876409217, 1988-10-11, Cesar Ribeiro, LIMPEZA, null, 80123498501).


--8 viola restrição de not null do cpf do superior quando a função do funcionário é limpeza
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90876409217','1992-07-05', 'Marcelo Pereira','LIMPEZA','P', null); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_valida_chk"
--DETAIL:  Failing row contains (90876409217, 1992-07-05, Marcelo Pereira, LIMPEZA, P, null).

--9 viola restrição de foreign key pois cpf do superior nao existe cadastrado
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('96576409217','1996-10-10', 'Eduardo de Menezes','LIMPEZA','P', '90909090900');
--ERROR:  insert or update on table "funcionario" violates foreign key constraint "funcionario_superior_cpf_fkey"
--DETAIL:  Key (superior_cpf)=(90909090900) is not present in table "funcionario".

--10 viola varias restrições pois tenta inserir uma tupla com apenas valores null (declara erro no cpf que é not null pois pega o primeiro valor)
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES (null,null,null,null,null, null);
--ERROR:  null value in column "cpf" violates not-null constraint
--DETAIL:  Failing row contains (null, null, null, null, null, null).


--questão 10


--inserindo funcionarios para nao causar erro ao adicionar constraint de foreign key

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1999-11-30', 'Alef Silva', 'SUP_LIMPEZA', 'P', null),
('98765432111', '1999-10-20', 'Antonio Lira', 'LIMPEZA', 'J', '80101010101'),
('32323232955', '1988-12-01', 'Thiago Mota', 'SUP_LIMPEZA', 'P', null),
('32323232911', '2000-01-01', 'Isaac Newton', 'LIMPEZA', 'P', '80101010101');
--INSERT 0 4


-- opção 1

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY(func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE CASCADE; 
--ALTER TABLE

SELECT FROM funcionario WHERE cpf = '32323232911';
--
--(1 row)
DELETE FROM funcionario WHERE cpf = '32323232911';
--DELETE 1


--OPÇÃO 2

ALTER TABLE tarefas DROP constraint tarefas_func_resp_cpf_fkey;
--ALTER TABLE

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE RESTRICT;
--ALTER TABLE

INSERT INTO tarefas VALUES(2147483650, 'limpar portas do térreo', '91191919111', 4, 'P');

DELETE FROM funcionario WHERE cpf = '91191919111';
--ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"
--DETAIL:  Key (cpf)=(91191919111) is still referenced from table "tarefas".


--questão 11

--mudando o tipo

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;

ALTER TABLE tarefas ADD CONSTRAINT func_resp_cpf_chk CHECK((status = 'E' Or status = 'C') AND func_resp_cpf IS NOT NULL) OR (status = 'P'));

ALTER TABLE tarefas DROP constraint tarefas_func_resp_cpf_fkey;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE SET NULL;
--ALTER TABLE


INSERT INTO tarefas VALUES(2147499999, 'limpar portas do térreo', '40070089000', 4, 'E');
--INSERT 0 1


--REMOVENDO CPF COM STATUS E

DELETE FROM funcionario WHERE cpf = '40070089000';
--ERROR:  null value in column "func_resp_cpf" violates not-null constraint
--DETAIL:  Failing row contains (2147499999, limpar portas do térreo, null, 4, E).
--CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

-- REMOVENDO CPF COM STATUS C

DELETE FROM funcionario WHERE cpf = '98765432122';
--ERROR:  null value in column "func_resp_cpf" violates not-null constraint
--DETAIL:  Failing row contains (2147483647, limpar janelas da sala 203, null, 1, C).
--CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

--REMOVENDO COM STATUS P
DELETE FROM funcionario WHERE cpf = '32323232911';
--DELETE 1
