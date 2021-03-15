--Comentários

--QUESTÃO 1:
--A partir dos comandos inferi que tarefas possuiria um id do tipo integer, uma descrição do tipo varchar, um cpf do funcionario responsavel do tipo char(11), um número inteiro que representa a sequencia de realização da atividade e um status do tipo char.


--QUESTÃO 2:
--Ao adicionar tarefa com id 2147483648 obtive um erro de integer out of range:
--INSERT INTO tarefas VALUES(2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');
--ERROR:  integer out of range
--Para deixar correto alterei o tipo do id de integer para bigint pois suporta o intervalo de números pedido.

--QUESTÃO 3:
--Como o número de prioridade deve suportar até o 32767, tive que mudar o tipo de prioridade
--Para deixar correto alterei o tipo para smallint (que obedece o limite estabelecido)

--QUESTÃO 4:
--Tentei alterar alguns atributos para NOT NULL e dava erro pois tinha uma tarefa cadastrada com atributos Null. O erro apontado:
--ERROR:  column "id_tarefas" contains null values
-- Removi esta tarefa que continha atributos null
-- Alterei os mesmos atributos para NOT NULL e depois alterei os nomes dos atributos seguindo o padrão pedido.

--QUESTÃO 5:
-- Alterei o id para ser chave primária e não permitir repetição
--Para confirmar, tentei inserir uma tupla com id repetido e retornou um erro, conforme o esperado
--ERROR:  duplicate key value violates unique constraint "tarefas_pkey"
--DETAIL:  Key (id)=(2147483653) already exists.


--QUESTÃO 6:
--A
--Adicionei um check para estabelecer que um cpf cadastrado deve ter exatamente 11 dígitos
--Testei a adição de tuplas com cpf menor e cpf maior que 11 e deu erro de inserção (o que mostra que o check está funcionando)
--Exemplo: 
--ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_func_resp_cpf_valido"
--DETAIL:  Failing row contains (2147483000, aparar a grama da área frontal, 323232     , 3, A).

--B
-- Primeiro adicionei um check que determinava os novos tipos de status. Como algumas tuplas estavam com os status desatualizados, retornou um erro
--ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_status_possiveis CHECK (status = 'P' OR status = 'E' OR status = 'C');
--ERROR:  check constraint "tarefas_chk_status_possiveis" is violated by some row
--Para consertar isso tive que atualizar as tuplas que tinham o status A, R ou F (através do UPDATE) para P, E ou C respectivamente.
--Depois adicionei um check para estabelecer os valores válidos para status.


--QUESTÃO 7:
--Primeiro adicionei um check que determinava os novos valores de prioriade. Retornou um erro pois alguns valores estavam desatualizados
--ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridades_possiveis CHECK (prioridade >= 0 AND prioridade <=5 );
--ERROR:  check constraint "tarefas_chk_prioridades_possiveis" is violated by some row
--Depois atualizei todas as tarefas que tinham prioridade maior que 5 para 5. 
--Por ultimo adicionei um check para estabelecer que os valores válidos para prioridade são maiores ou igual a zero e menores ou igual a 5.

--QUESTÃO 8:
--Criando a relação funcionário. Estabeleci que cada funcionário tem um cpf não nulo, uma data de nascimento não nula, um nome não nulo, uma função não nula, um nível não nulo e um cpf do superior(que pode ser null quando o funcionário é um superior).
--Adicionei um check para validar a função do funcionário
--Adicionei um check para validar o nível do funcionário
--O seguinte comando retorna um erro pois viola o check de que funcionário "LIMPEZA" não pode ter superior null
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA','J', null); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_valida_chk"
--DETAIL:  Failing row contains (12345678913, 1980-04-09, joao da Silva, LIMPEZA, J, null).

--QUESTÃO 9:
--Criei algumas inserções que obtiveram êxito
--Criei outras inserções que acusaram erro:
--1  viola restrição de nivel pois nivel nao existe
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60976549182', '1991-02-11', 'Aristoteles Silva', 'LIMPEZA','T', '25678901876'); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_niveis_validos"
--DETAIL:  Failing row contains (60976549182, 1991-02-11, Aristoteles Silva, LIMPEZA, T, 25678901876).

--2 viola restição de not null do cpf do funcionario
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES (null, '1999-01-01', 'Maria Silva', 'LIMPEZA','J', '25678901876'); 
--ERROR:  null value in column "cpf" violates not-null constraint
--DETAIL:  Failing row contains (null, 1999-01-01, Maria Silva, LIMPEZA, J, 25678901876).

--3 viola restição do tipo de funcionario pois tipo nao existe
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20709822222', '1990-08-21', 'Pedro Henrique Barbosa', 'ATENDENTE','J', null); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_valida_chk"
--DETAIL:  Failing row contains (20709822222, 1990-08-21, Pedro Henrique Barbosa, ATENDENTE, J, null).

--4 viola restrição de not null do nome do funcionario
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('20755555903', '1970-03-05', null, 'SUP_LIMPEZA','S', null); 
--ERROR:  null value in column "nome" violates not-null constraint
--DETAIL:  Failing row contains (20755555903, 1970-03-05, null, SUP_LIMPEZA, S, null).


--5 viola restrição de not null da data de nascimento do funcionario
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('36589076542',null, 'Maria Cecilia Barros', 'SUP_LIMPEZA','S', null); 
--ERROR:  null value in column "data_nasc" violates not-null constraint
--DETAIL:  Failing row contains (36589076542, null, Maria Cecilia Barros, SUP_LIMPEZA, S, null).

--6 viola restrição de not null da função do funcionario
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('36588888888','2000-08-09', 'Maria Cecilia Barros',null,'J', '11111111111'); 
--ERROR:  null value in column "funcao" violates not-null constraint
--DETAIL:  Failing row contains (36588888888, 2000-08-09, Maria Cecilia Barros, null, J, 11111111111).

--7 viola restrição de not null do nivel do funcionario
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90876409217','1988-10-11', 'Cesar Ribeiro','LIMPEZA',null, '80123498501'); 
--ERROR:  null value in column "nivel" violates not-null constraint
--DETAIL:  Failing row contains (90876409217, 1988-10-11, Cesar Ribeiro, LIMPEZA, null, 80123498501).


--8 viola restrição de not null do cpf do superior quando a função do funcionário é limpeza
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90876409217','1992-07-05', 'Marcelo Pereira','LIMPEZA','P', null); 
--ERROR:  new row for relation "funcionario" violates check constraint "funcionario_funcao_valida_chk"
--DETAIL:  Failing row contains (90876409217, 1992-07-05, Marcelo Pereira, LIMPEZA, P, null).

--9 viola restrição de foreign key pois cpf do superior nao existe cadastrado
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('96576409217','1996-10-10', 'Eduardo de Menezes','LIMPEZA','P', '90909090900');
--ERROR:  insert or update on table "funcionario" violates foreign key constraint "funcionario_superior_cpf_fkey"
--DETAIL:  Key (superior_cpf)=(90909090900) is not present in table "funcionario".

--10 viola varias restrições pois tenta inserir uma tupla com apenas valores null (declara erro no cpf que é not null pois pega o primeiro valor)
--INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES (null,null,null,null,null, null);
--ERROR:  null value in column "cpf" violates not-null constraint
--DETAIL:  Failing row contains (null, null, null, null, null, null).

--QUESTÃO 10:
--Primeiro cadastrei no banco funcionários que já tinham seu cpf associados a uma tarefa (para evitar erro).

--Opção 1:
-- Adicionei a Constraint de chave estrangeira para relacionar as tabelas e estabeleci o padrão de remoção em cascata. Depois removi um funcionário.

--Opção 2:
-- Removi a Constraint feita no passo anterior e criei novamente mudando o padrão de remoção para RESTRICT. Depois tentei remover um funcionário associado a uma tarefa e causou erro justamente pelo padrão RESTRICT.
--DELETE FROM funcionario WHERE cpf = '91191919111';
--ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"
--DETAIL:  Key (cpf)=(91191919111) is still referenced from table "tarefas".

--QUESTÃO 11:
--Como o cpf do funcionário agora pode ser Null, removi a constraint NOT NULL. Depois adicionei um check para validar o status da tarefa (só o status P possibilita que o cpf do funcionário pode ser NULL). Após isso, removi a constraint RESTRICT para adicioná-la novamente agora para DELETE SET NULL. 
--Para confirmar o DELETE SET NULL, removi funcionário associado a uma tarefa com status P e obtive sucesso. No caso das tarefas com status C ou E, a remoção do funcionário associado não pode ser feita pois fere o que foi definido anteriormente.
--Erros obtidos:

--Ao remorver com status E: 
--ERROR:  null value in column "func_resp_cpf" violates not-null constraint
--DETAIL:  Failing row contains (2147499999, limpar portas do térreo, null, 4, E).
--CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

--Ao remover com status C:
--DELETE FROM funcionario WHERE cpf = '98765432122';
--ERROR:  null value in column "func_resp_cpf" violates not-null constraint
--DETAIL:  Failing row contains (2147483647, limpar janelas da sala 203, null, 1, C).
--CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf""

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(80) NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcionario_funcao_valida_chk CHECK (((((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT funcionario_niveis_validos_chk CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar)))
);


ALTER TABLE public.funcionario OWNER TO annabll;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao character varying(100) NOT NULL,
    func_resp_cpf character(11),
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT tarefas_chk_func_resp_cpf_valido CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT tarefas_chk_prioridades_possiveis CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT tarefas_chk_status_possiveis CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO annabll;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90080070060', '1988-04-25', 'Jorge', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('50040030020', '1987-11-30', 'Cristiano', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40030020010', '1995-02-02', 'Leonardo', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60050040030', '1994-01-21', 'Marcos', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('60050040031', '1993-11-11', 'Gabriel', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40070089000', '2000-09-09', 'Pietro', 'LIMPEZA', 'J', '90080070060');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40000000000', '1999-05-20', 'Enzo', 'LIMPEZA', 'P', '50040030020');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40009999999', '1999-10-11', 'Felipe', 'LIMPEZA', 'J', '40030020010');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('80101010101', '1987-11-21', 'Paschoal', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('91191919111', '1988-06-06', 'Pedro Coelho', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1999-11-30', 'Alef Silva', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1999-10-20', 'Antonio Lira', 'LIMPEZA', 'J', '80101010101');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1988-12-01', 'Thiago Mota', 'SUP_LIMPEZA', 'P', NULL);


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483650, 'limpar portas do térreo', '91191919111', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147499999, 'limpar portas do térreo', '40070089000', 4, 'E');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar', NULL, 2, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483651, 'limpar portas do 1o andar', NULL, 5, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483652, 'limpar portas do 2o andar', NULL, 5, 'P');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

