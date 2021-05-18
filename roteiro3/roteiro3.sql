--estabelecendo os possíveis valores para os Estados dos endereços
CREATE TYPE estados AS ENUM('MARANHÃO', 'PIAUÍ', 'CEARÁ', 'RIO GRANDE DO NORTE', 'PARAÍBA', 'PERNAMBUCO', 'ALAGOAS', 'SERGIPE', 'BAHIA');



CREATE TABLE farmacia(
id integer NOT NULL,
bairro varchar(50) UNIQUE NOT NULL,
cidade varchar(40) NOT NULL,
estado estados NOT NULL,
cep char(8),
gerente_cpf char(11) UNIQUE,
tipo varchar(6) NOT NULL,
telefone varchar(11) NOT NULL,
CONSTRAINT farmacia_tipo_chk check(tipo = 'SEDE' or tipo = 'FILIAL'),
CONSTRAINT sede_exclusiva EXCLUDE USING gist(tipo with =) where (tipo = 'SEDE'),
CONSTRAINT farmacia_pkey PRIMARY KEY(id)
);

--estabelecendo os possíveis valores para os cargos dos funcionários
CREATE TYPE cargos AS ENUM('FARMACÊUTICO', 'VENDEDOR', 'ENTREGADOR', 'CAIXA', 'ADMINISTRADOR');


CREATE TABLE funcionario(
cpf char(11) NOT NULL,
nome varchar(80) NOT NULL,
data_nascimento date NOT NULL,
cargo cargos NOT NULL,
gerente boolean,
id_farmacia integer,
CONSTRAINT funcionario_pkey PRIMARY KEY(cpf),
CONSTRAINT gerente_valido_chk CHECK (((gerente = TRUE) AND (cargo = 'FARMACÊUTICO' OR cargo = 'ADMINISTRADOR')) OR (gerente = FALSE))
);


ALTER TABLE farmacia ADD CONSTRAINT funcionario_gerente_cpf_fkey FOREIGN KEY(gerente_cpf) REFERENCES funcionario(cpf);
ALTER TABLE funcionario ADD CONSTRAINT farmacia_id_farmacia_fkey FOREIGN KEY(id_farmacia) REFERENCES farmacia(id);


CREATE TABLE medicamento(
id integer NOT NULL,
receita_obrigatoria boolean NOT NULL,
valor numeric NOT NULL,
nome varchar(50) NOT NULL,
CONSTRAINT medicamento_pkey PRIMARY KEY(id)
);

CREATE TABLE cliente(
nome varchar(80) NOT NULL,
cpf char(11) NOT NULL,
data_nascimento date NOT NULL,
telefone varchar(11) NOT NULL,
CONSTRAINT cliente_pkey PRIMARY KEY(cpf),
CONSTRAINT idade_valida_chk CHECK (EXTRACT (YEAR FROM age(data_nascimento)) >= 18)
); 




--estabelecendo os possíveis valores para o tipo de endereço
CREATE TYPE tipo_end AS ENUM('RESIDÊNCIA', 'TRABALHO', 'OUTRO');


--optei por criar a tabela endereços para adicionar os diferentes endereços de um cliente
CREATE TABLE endereço(
id serial,
cliente_cpf char(11) NOT NULL,
tipo_endereço tipo_end NOT NULL,
bairro varchar(50) NOT NULL,
cidade varchar(40) NOT NULL,
estado estados NOT NULL,
cep char(8),
complemento_endereço varchar(200),
CONSTRAINT endereço_pkey PRIMARY KEY(id),
CONSTRAINT cliente_cliente_cpf_fkey FOREIGN KEY(cliente_cpf) REFERENCES cliente(cpf)
);

CREATE TABLE entregas(
id serial,
cpf_cliente char(11) NOT NULL,
cpf_funcionario char(11) NOT NULL,
tipo_endereço tipo_end NOT NULL,
CONSTRAINT entregas_pkey PRIMARY KEY(id),
CONSTRAINT cliente_cpf_cliente_fkey FOREIGN KEY(cpf_cliente) REFERENCES cliente(cpf)
);

CREATE TABLE venda(
id serial,
id_entrega integer,
cpf_cliente char(11),
cpf_funcionario char(11) NOT NULL,
id_medicamento integer NOT NULL,
valor numeric NOT NULL,
receita_obrigatoria boolean NOT NULL,
tipo_funcionario cargos NOT NULL,
CONSTRAINT venda_pkey PRIMARY KEY(id),
CONSTRAINT entrega_id_entrega_fkey FOREIGN KEY(id_entrega) REFERENCES entregas(id), 
CONSTRAINT cliente_cpf_cliente_fkey FOREIGN KEY(cpf_cliente) REFERENCES cliente(cpf),
CONSTRAINT venda_valida_chk CHECK (((cpf_cliente is NOT NULL) AND (receita_obrigatoria = true)) OR (receita_obrigatoria = false)),
CONSTRAINT cargo_funcionario_chk CHECK (tipo_funcionario = 'VENDEDOR')
);

ALTER TABLE venda ADD CONSTRAINT venda_cpf_funcionario_fkey FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf) ON DELETE RESTRICT;
ALTER TABLE venda ADD CONSTRAINT venda_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES medicamento(id) ON DELETE RESTRICT;





--CASOS DE TESTE

--1 CADASTRANDO FARMÁCIA SEM SER SEDE OU FILIAL, VIOLA A CONSTRAINT DE TIPO DE FARMÁCIA VÁLIDO
INSERT INTO farmacia VALUES(1000, 'ALTO BRANCO','CAMPINA GRANDE', 'PARAÍBA', '58401677', '00000000000', 'OUTRO', '83999999999');
--ERROR:  new row for relation "farmacia" violates check constraint "farmacia_tipo_chk"
--DETAIL:  Failing row contains (1000, ALTO BRANCO, CAMPINA GRANDE, PARAÍBA, 58401677, 00000000000, OUTRO, 83999999999).

-- 2 CADASTRANDO FARMÁCIA FILIAL - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO farmacia VALUES(1001, 'ALTO BRANCO','CAMPINA GRANDE', 'PARAÍBA', '58401600', NULL, 'FILIAL', '83999990000');
--INSERT 0 1

-- 3 CADASTRANDO UM FUNCIONÁIO GERENTE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('10101010100', 'Gabriel Silva', '1985-10-11', 'ADMINISTRADOR', TRUE, '1001');
--INSERT 0 1

-- 4 ATUALIZANDO O GERENTE NA FARMÁCIA - DEVE SER EXECUTADO COM SUCESSO
UPDATE farmacia SET gerente_cpf = '10101010100' WHERE (id = 1001);
--UPDATE 1
  
--5 CADASTRANDO FARMÁCIA SEDE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO farmacia VALUES(1002, 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401700', NULL, 'SEDE', '83999909090');
--INSERT 0 1

-- 6 CADASTRANDO GERENTE COM CARGO INVÁLIDO - NÃO DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('12121212120', 'Laura Farias', '1988-06-05', 'ENTREGADOR', TRUE, '1002');
--ERROR:  new row for relation "funcionario" violates check constraint "gerente_valido_chk"
--DETAIL:  Failing row contains (12121212120, Laura Farias, 1988-06-05, ENTREGADOR, t, 1002).


-- 7 CADASTRANDO FUNCIONARIO GERENTE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('11111111111', 'Marcio Rocha', '1988-11-01', 'ADMINISTRADOR', TRUE, '1002');
--INSERT 0 1

-- ASSOCIANDO UM GERENTE A UMA FARMÁCIA - DEVE SER EXECUTADO COM SUCESSO
UPDATE farmacia SET gerente_cpf = '11111111111' WHERE (id = 1002);
--UPDATE 1

-- 8 TENTANDO CADASTRAR OUTRA FARMÁCIA SEDE, VIOLA O COMANDO DE EXCLUSIVIDADE DE FARMÁCIA SEDE - NÃO DEVE SER EXECUTADO COM SUCESSO
INSERT INTO farmacia VALUES(1003, 'CENTRO', 'CAMPINA GRANDE', 'PARAÍBA', '59501444', '10000000000', 'SEDE', '83990000000');
--ERROR:  conflicting key value violates exclusion constraint "sede_exclusiva"
--DETAIL:  Key (tipo)=(SEDE) conflicts with existing key (tipo)=(SEDE).

-- 9 CADASTRANDO FARMÁCIA EM MESMO BAIRRO JÁ CADASTRADO, VIOLA A CONSTRAINT DE UNICIDADE DO BAIRRO  - NÃO DEVE SER EXECUTADO COM SUCESSO
INSERT INTO farmacia VALUES(1004, 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401700', '20000000000', 'FILIAL', '83988888888');
--ERROR:  duplicate key value violates unique constraint "farmacia_bairro_key"
--DETAIL:  Key (bairro)=(CATOLÉ) already exists.


-- 10 CADASTRANDO FUNCIONÁRIO COM CARGO INVÁLIDO, VIOLA A CONSTRAINT DE TIPO DE FUNCIONÁRIO VÁLIDO - NÃO DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('20508945389', 'FERNANDO SILVA', '1990-05-04', 'EXTERNO', FALSE, '1001');
--ERROR:  invalid input value for enum cargos: "EXTERNO"
--LINE 1: ...ES('20508945389', 'FERNANDO SILVA', '1990-05-04', 'EXTERNO',...


-- 11 CADASTRANDO FUNCIONÁRIO SEM ALOCAÇÃO EM FARMÁCIA - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('09009009000', 'Maria Luisa', '1995-08-08', 'CAIXA', FALSE, NULL);
--INSERT 0 1

-- 12 CADASTRANDO UM CLIENTE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO cliente VALUES('Ivete Sangalo', '88776655443', '1977-07-07', '83998256101'); 
--INSERT 0 1


-- 12 CADASTRANDO ENTREGADOR - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('22222222222', 'Aderbal José', '1990-10-12', 'ENTREGADOR', FALSE, 1002);
--INSERT 0 1

--13 CADASTRANDO ENDEREÇO DE RESIDÊNCIA DO CLIENTE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO endereço VALUES(default,'88776655443','RESIDÊNCIA', 'PALMEIRA', 'CAMPINA GRANDE', 'PARAÍBA', '58401222', NULL);
--INSERT 0 1

-- 14  CADASTRANDO ENDEREÇO DE TRABALHO DO MESMO CLIENTE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO endereço VALUES(default,'88776655443','TRABALHO', 'CENTRO', 'CAMPINA GRANDE', 'PARAÍBA', '58401000', 'Meu endereço de trabalho');
--INSERT 0 1

-- 15 CADASTRANDO ENDEREÇO DE TRABALHO DO MESMO CLIENTE - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO endereço VALUES(default,'88776655443','OUTRO', 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401111', 'Edereço da casa da minha mãe');
--INSERT 0 1

-- 16 CADASTRANDO CLIENTE COM IDADE INVÁLIDA, NÃO É PERMITIDO - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO cliente VALUES('Valentina Muniz', '88776655997', '2018-01-01', '83998765432');
--ERROR:  new row for relation "cliente" violates check constraint "idade_valida_chk"
--DETAIL:  Failing row contains (Valentina Muniz, 88776655997, 2018-01-01, 83998765432).

-- 17 CADASTRANDO MEDICAMENTO DE RECEITA OBRIGATÓRIA - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO medicamento VALUES (01, TRUE, 39.9, 'TYLENOL');
--INSERT 0 1

-- 18 CADASTRANDO MEDICAMENTO SEM RECEITA OBRIGATÓRIA - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO medicamento VALUES (02, FALSE, 20.0, 'DIPIRONA');
--INSERT 0 1

-- 19 CADASTRANDO FUNCIONÁRIO VENDEDOR - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO funcionario VALUES('11881155667', 'Felipe Freitas', '1989-03-03', 'VENDEDOR', FALSE, 1002);
--INSERT 0 1

-- 20 VENDA PARA CLIENTE NÃO CADASTRADO - SEM ENTREGA - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO venda VALUES (default, NULL, NULL, '11881155667',02, 20.0, FALSE, 'VENDEDOR');
--INSERT 0 1

-- 21 VENDA REMÉDIO COM RECEITA OBRIGATÓRIA PARA CLIENTE CADASTRADO - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO venda VALUES (default, NULL, '88776655443', '11881155667',01, 39.9, TRUE, 'VENDEDOR');
--INSERT 0 1

-- 22 VENDA REMÉDIO COM RECEITA OBRIGATÓRIA PARA CLIENTE NÃO CADASTRADO - RETORNA ERRO POIS OPERAÇÃO É INVÁLIDA
INSERT INTO venda VALUES (default, NULL, NULL, '11881155667',01, 39.9, TRUE, 'VENDEDOR');
--ERROR:  new row for relation "venda" violates check constraint "venda_valida_chk"
--DETAIL:  Failing row contains (6, null, null, 11881155667, 1, 39.9, t, VENDEDOR).

-- 23 VENDA COM FUNCIONÁRIO DO TIPO DIFERENTE DE VENDEDOR - RETORNA ERRO POIS APENAS FUNCIONÁRIO DO TIPO VENDEDOR PODE VENDER
INSERT INTO venda VALUES (default, NULL, '88776655443', '11111111111',02, 20.0, FALSE, 'ADMINISTRADOR');
--ERROR:  new row for relation "venda" violates check constraint "cargo_funcionario_chk"
--DETAIL:  Failing row contains (7, null, 88776655443, 11111111111, 2, 20.0, f, ADMINISTRADOR).

--24 REMOVENDO UM FUNCIONÁRIO ASSOCIADO A UMA VENDA - A REMOÇÃO NÃO DEVE SER REALIZADA
DELETE FROM funcionario WHERE (cpf = '11881155667');
--ERROR:  update or delete on table "funcionario" violates foreign key constraint "venda_cpf_funcionario_fkey" on table "venda"
--DETAIL:  Key (cpf)=(11881155667) is still referenced from table "venda".

-- 25 REMOVENDO UM MEDICAMENTO ASSOCIADO A UMA VENDA - A REMOÇÃO NÃO DEVE SER REALIZADA
DELETE FROM medicamento WHERE (id = 02);
--ERROR:  update or delete on table "medicamento" violates foreign key constraint "venda_id_medicamento_fkey" on table "venda"
--DETAIL:  Key (id)=(2) is still referenced from table "venda".

-- 26 CADASTRANDO ENTREGA PARA CLIENTE CADASTRADO - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO entregas VALUES (default, '88776655443', '22222222222', 'RESIDÊNCIA');
--INSERT 0 1

-- 27 CADASTRANDO ENTREGA PARA CLIENTE NÃO CADASTRADO - NÃO PODE SER REALIZADA
INSERT INTO entregas VALUES (default, NULL, '22222222222', 'RESIDÊNCIA');
--ERROR:  null value in column "cpf_cliente" violates not-null constraint
--DETAIL:  Failing row contains (2, null, 22222222222, RESIDÊNCIA).

-- 28 TESTANDO VENDA COM ENTREGA - DEVE SER EXECUTADO COM SUCESSO
INSERT INTO venda VALUES (default, 1, '88776655443', '22222222222',02, 20.0, FALSE, 'VENDEDOR');
--INSERT 0 1
