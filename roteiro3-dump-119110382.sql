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

ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_id_medicamento_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_funcionario_fkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT funcionario_gerente_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT farmacia_id_farmacia_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT entrega_id_entrega_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT cliente_cpf_cliente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT cliente_cpf_cliente_fkey;
ALTER TABLE ONLY public."endereço" DROP CONSTRAINT cliente_cliente_cpf_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT sede_exclusiva;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_gerente_cpf_key;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_bairro_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public."endereço" DROP CONSTRAINT "endereço_pkey";
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
ALTER TABLE public.venda ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entregas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public."endereço" ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.venda_id_seq;
DROP TABLE public.venda;
DROP TABLE public.medicamento;
DROP TABLE public.funcionario;
DROP TABLE public.farmacia;
DROP SEQUENCE public.entregas_id_seq;
DROP TABLE public.entregas;
DROP SEQUENCE public."endereço_id_seq";
DROP TABLE public."endereço";
DROP TABLE public.cliente;
DROP TYPE public.tipo_end;
DROP TYPE public.estados;
DROP TYPE public.cargos;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: cargos; Type: TYPE; Schema: public; Owner: annabll
--

CREATE TYPE public.cargos AS ENUM (
    'FARMACÊUTICO',
    'VENDEDOR',
    'ENTREGADOR',
    'CAIXA',
    'ADMINISTRADOR'
);


ALTER TYPE public.cargos OWNER TO annabll;

--
-- Name: estados; Type: TYPE; Schema: public; Owner: annabll
--

CREATE TYPE public.estados AS ENUM (
    'MARANHÃO',
    'PIAUÍ',
    'CEARÁ',
    'RIO GRANDE DO NORTE',
    'PARAÍBA',
    'PERNAMBUCO',
    'ALAGOAS',
    'SERGIPE',
    'BAHIA'
);


ALTER TYPE public.estados OWNER TO annabll;

--
-- Name: tipo_end; Type: TYPE; Schema: public; Owner: annabll
--

CREATE TYPE public.tipo_end AS ENUM (
    'RESIDÊNCIA',
    'TRABALHO',
    'OUTRO'
);


ALTER TYPE public.tipo_end OWNER TO annabll;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.cliente (
    nome character varying(80) NOT NULL,
    cpf character(11) NOT NULL,
    data_nascimento date NOT NULL,
    telefone character varying(11) NOT NULL,
    CONSTRAINT idade_valida_chk CHECK ((date_part('year'::text, age((data_nascimento)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.cliente OWNER TO annabll;

--
-- Name: endereço; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public."endereço" (
    id integer NOT NULL,
    cliente_cpf character(11) NOT NULL,
    "tipo_endereço" public.tipo_end NOT NULL,
    bairro character varying(50) NOT NULL,
    cidade character varying(40) NOT NULL,
    estado public.estados NOT NULL,
    cep character(8),
    "complemento_endereço" character varying(200)
);


ALTER TABLE public."endereço" OWNER TO annabll;

--
-- Name: endereço_id_seq; Type: SEQUENCE; Schema: public; Owner: annabll
--

CREATE SEQUENCE public."endereço_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."endereço_id_seq" OWNER TO annabll;

--
-- Name: endereço_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: annabll
--

ALTER SEQUENCE public."endereço_id_seq" OWNED BY public."endereço".id;


--
-- Name: entregas; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.entregas (
    id integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    cpf_funcionario character(11) NOT NULL,
    "tipo_endereço" public.tipo_end NOT NULL
);


ALTER TABLE public.entregas OWNER TO annabll;

--
-- Name: entregas_id_seq; Type: SEQUENCE; Schema: public; Owner: annabll
--

CREATE SEQUENCE public.entregas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregas_id_seq OWNER TO annabll;

--
-- Name: entregas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: annabll
--

ALTER SEQUENCE public.entregas_id_seq OWNED BY public.entregas.id;


--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    bairro character varying(50) NOT NULL,
    cidade character varying(40) NOT NULL,
    estado public.estados NOT NULL,
    cep character(8),
    gerente_cpf character(11),
    tipo character varying(6) NOT NULL,
    telefone character varying(11) NOT NULL,
    CONSTRAINT farmacia_tipo_chk CHECK ((((tipo)::text = 'SEDE'::text) OR ((tipo)::text = 'FILIAL'::text)))
);


ALTER TABLE public.farmacia OWNER TO annabll;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome character varying(80) NOT NULL,
    data_nascimento date NOT NULL,
    cargo public.cargos NOT NULL,
    gerente boolean,
    id_farmacia integer,
    CONSTRAINT gerente_valido_chk CHECK ((((gerente = true) AND ((cargo = 'FARMACÊUTICO'::public.cargos) OR (cargo = 'ADMINISTRADOR'::public.cargos))) OR (gerente = false)))
);


ALTER TABLE public.funcionario OWNER TO annabll;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    receita_obrigatoria boolean NOT NULL,
    valor numeric NOT NULL,
    nome character varying(50) NOT NULL
);


ALTER TABLE public.medicamento OWNER TO annabll;

--
-- Name: venda; Type: TABLE; Schema: public; Owner: annabll
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    id_entrega integer,
    cpf_cliente character(11),
    cpf_funcionario character(11) NOT NULL,
    id_medicamento integer NOT NULL,
    valor numeric NOT NULL,
    receita_obrigatoria boolean NOT NULL,
    tipo_funcionario public.cargos NOT NULL,
    CONSTRAINT cargo_funcionario_chk CHECK ((tipo_funcionario = 'VENDEDOR'::public.cargos)),
    CONSTRAINT venda_valida_chk CHECK ((((cpf_cliente IS NOT NULL) AND (receita_obrigatoria = true)) OR (receita_obrigatoria = false)))
);


ALTER TABLE public.venda OWNER TO annabll;

--
-- Name: venda_id_seq; Type: SEQUENCE; Schema: public; Owner: annabll
--

CREATE SEQUENCE public.venda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venda_id_seq OWNER TO annabll;

--
-- Name: venda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: annabll
--

ALTER SEQUENCE public.venda_id_seq OWNED BY public.venda.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public."endereço" ALTER COLUMN id SET DEFAULT nextval('public."endereço_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.entregas ALTER COLUMN id SET DEFAULT nextval('public.entregas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.venda ALTER COLUMN id SET DEFAULT nextval('public.venda_id_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.cliente (nome, cpf, data_nascimento, telefone) VALUES ('Ivete Sangalo', '88776655443', '1977-07-07', '83998256101');


--
-- Data for Name: endereço; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public."endereço" (id, cliente_cpf, "tipo_endereço", bairro, cidade, estado, cep, "complemento_endereço") VALUES (1, '88776655443', 'RESIDÊNCIA', 'PALMEIRA', 'CAMPINA GRANDE', 'PARAÍBA', '58401222', NULL);
INSERT INTO public."endereço" (id, cliente_cpf, "tipo_endereço", bairro, cidade, estado, cep, "complemento_endereço") VALUES (2, '88776655443', 'TRABALHO', 'CENTRO', 'CAMPINA GRANDE', 'PARAÍBA', '58401000', 'Meu endereço de trabalho');
INSERT INTO public."endereço" (id, cliente_cpf, "tipo_endereço", bairro, cidade, estado, cep, "complemento_endereço") VALUES (3, '88776655443', 'OUTRO', 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401111', 'Edereço da casa da minha mãe');


--
-- Name: endereço_id_seq; Type: SEQUENCE SET; Schema: public; Owner: annabll
--

SELECT pg_catalog.setval('public."endereço_id_seq"', 3, true);


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.entregas (id, cpf_cliente, cpf_funcionario, "tipo_endereço") VALUES (1, '88776655443', '22222222222', 'RESIDÊNCIA');


--
-- Name: entregas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: annabll
--

SELECT pg_catalog.setval('public.entregas_id_seq', 2, true);


--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.farmacia (id, bairro, cidade, estado, cep, gerente_cpf, tipo, telefone) VALUES (1001, 'ALTO BRANCO', 'CAMPINA GRANDE', 'PARAÍBA', '58401600', '10101010100', 'FILIAL', '83999990000');
INSERT INTO public.farmacia (id, bairro, cidade, estado, cep, gerente_cpf, tipo, telefone) VALUES (1002, 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401700', '11111111111', 'SEDE', '83999909090');


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.funcionario (cpf, nome, data_nascimento, cargo, gerente, id_farmacia) VALUES ('10101010100', 'Gabriel Silva', '1985-10-11', 'ADMINISTRADOR', true, 1001);
INSERT INTO public.funcionario (cpf, nome, data_nascimento, cargo, gerente, id_farmacia) VALUES ('11111111111', 'Marcio Rocha', '1988-11-01', 'ADMINISTRADOR', true, 1002);
INSERT INTO public.funcionario (cpf, nome, data_nascimento, cargo, gerente, id_farmacia) VALUES ('09009009000', 'Maria Luisa', '1995-08-08', 'CAIXA', false, NULL);
INSERT INTO public.funcionario (cpf, nome, data_nascimento, cargo, gerente, id_farmacia) VALUES ('22222222222', 'Aderbal José', '1990-10-12', 'ENTREGADOR', false, 1002);
INSERT INTO public.funcionario (cpf, nome, data_nascimento, cargo, gerente, id_farmacia) VALUES ('11881155667', 'Felipe Freitas', '1989-03-03', 'VENDEDOR', false, 1002);


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.medicamento (id, receita_obrigatoria, valor, nome) VALUES (1, true, 39.9, 'TYLENOL');
INSERT INTO public.medicamento (id, receita_obrigatoria, valor, nome) VALUES (2, false, 20.0, 'DIPIRONA');


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: annabll
--

INSERT INTO public.venda (id, id_entrega, cpf_cliente, cpf_funcionario, id_medicamento, valor, receita_obrigatoria, tipo_funcionario) VALUES (1, NULL, NULL, '11881155667', 2, 20.0, false, 'VENDEDOR');
INSERT INTO public.venda (id, id_entrega, cpf_cliente, cpf_funcionario, id_medicamento, valor, receita_obrigatoria, tipo_funcionario) VALUES (2, NULL, '88776655443', '11881155667', 1, 39.9, true, 'VENDEDOR');
INSERT INTO public.venda (id, id_entrega, cpf_cliente, cpf_funcionario, id_medicamento, valor, receita_obrigatoria, tipo_funcionario) VALUES (5, 1, '88776655443', '22222222222', 2, 20.0, false, 'VENDEDOR');


--
-- Name: venda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: annabll
--

SELECT pg_catalog.setval('public.venda_id_seq', 5, true);


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);


--
-- Name: endereço_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public."endereço"
    ADD CONSTRAINT "endereço_pkey" PRIMARY KEY (id);


--
-- Name: entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id);


--
-- Name: farmacia_bairro_key; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_bairro_key UNIQUE (bairro);


--
-- Name: farmacia_gerente_cpf_key; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_gerente_cpf_key UNIQUE (gerente_cpf);


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id);


--
-- Name: sede_exclusiva; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT sede_exclusiva EXCLUDE USING gist (tipo WITH =) WHERE (((tipo)::text = 'SEDE'::text));


--
-- Name: venda_pkey; Type: CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: cliente_cliente_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public."endereço"
    ADD CONSTRAINT cliente_cliente_cpf_fkey FOREIGN KEY (cliente_cpf) REFERENCES public.cliente(cpf);


--
-- Name: cliente_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT cliente_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: cliente_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT cliente_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: entrega_id_entrega_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT entrega_id_entrega_fkey FOREIGN KEY (id_entrega) REFERENCES public.entregas(id);


--
-- Name: farmacia_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT farmacia_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacia(id);


--
-- Name: funcionario_gerente_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT funcionario_gerente_cpf_fkey FOREIGN KEY (gerente_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: venda_cpf_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_funcionario_fkey FOREIGN KEY (cpf_funcionario) REFERENCES public.funcionario(cpf) ON DELETE RESTRICT;


--
-- Name: venda_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: annabll
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES public.medicamento(id) ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


--COMENTÁRIOS ADICIONAIS

--CASOS DE TESTE

--1 CADASTRANDO FARMÁCIA SEM SER SEDE OU FILIAL, VIOLA A CONSTRAINT DE TIPO DE FARMÁCIA VÁLIDO
--INSERT INTO farmacia VALUES(1000, 'ALTO BRANCO','CAMPINA GRANDE', 'PARAÍBA', '58401677', '00000000000', 'OUTRO', '83999999999');
--ERROR:  new row for relation "farmacia" violates check constraint "farmacia_tipo_chk"
--DETAIL:  Failing row contains (1000, ALTO BRANCO, CAMPINA GRANDE, PARAÍBA, 58401677, 00000000000, OUTRO, 83999999999).

-- 2 CADASTRANDO FARMÁCIA FILIAL - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO farmacia VALUES(1001, 'ALTO BRANCO','CAMPINA GRANDE', 'PARAÍBA', '58401600', NULL, 'FILIAL', '83999990000');
--INSERT 0 1

-- 3 CADASTRANDO UM FUNCIONÁIO GERENTE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('10101010100', 'Gabriel Silva', '1985-10-11', 'ADMINISTRADOR', TRUE, '1001');
--INSERT 0 1

-- 4 ATUALIZANDO O GERENTE NA FARMÁCIA - DEVE SER EXECUTADO COM SUCESSO
--UPDATE farmacia SET gerente_cpf = '10101010100' WHERE (id = 1001);
--UPDATE 1
  
--5 CADASTRANDO FARMÁCIA SEDE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO farmacia VALUES(1002, 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401700', NULL, 'SEDE', '83999909090');
--INSERT 0 1

-- 6 CADASTRANDO GERENTE COM CARGO INVÁLIDO - NÃO DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('12121212120', 'Laura Farias', '1988-06-05', 'ENTREGADOR', TRUE, '1002');
--ERROR:  new row for relation "funcionario" violates check constraint "gerente_valido_chk"
--DETAIL:  Failing row contains (12121212120, Laura Farias, 1988-06-05, ENTREGADOR, t, 1002).


-- 7 CADASTRANDO FUNCIONARIO GERENTE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('11111111111', 'Marcio Rocha', '1988-11-01', 'ADMINISTRADOR', TRUE, '1002');
--INSERT 0 1

-- ASSOCIANDO UM GERENTE A UMA FARMÁCIA - DEVE SER EXECUTADO COM SUCESSO
--UPDATE farmacia SET gerente_cpf = '11111111111' WHERE (id = 1002);
--UPDATE 1

-- 8 TENTANDO CADASTRAR OUTRA FARMÁCIA SEDE, VIOLA O COMANDO DE EXCLUSIVIDADE DE FARMÁCIA SEDE - NÃO DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO farmacia VALUES(1003, 'CENTRO', 'CAMPINA GRANDE', 'PARAÍBA', '59501444', '10000000000', 'SEDE', '83990000000');
--ERROR:  conflicting key value violates exclusion constraint "sede_exclusiva"
--DETAIL:  Key (tipo)=(SEDE) conflicts with existing key (tipo)=(SEDE).

-- 9 CADASTRANDO FARMÁCIA EM MESMO BAIRRO JÁ CADASTRADO, VIOLA A CONSTRAINT DE UNICIDADE DO BAIRRO  - NÃO DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO farmacia VALUES(1004, 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401700', '20000000000', 'FILIAL', '83988888888');
--ERROR:  duplicate key value violates unique constraint "farmacia_bairro_key"
--DETAIL:  Key (bairro)=(CATOLÉ) already exists.


-- 10 CADASTRANDO FUNCIONÁRIO COM CARGO INVÁLIDO, VIOLA A CONSTRAINT DE TIPO DE FUNCIONÁRIO VÁLIDO - NÃO DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('20508945389', 'FERNANDO SILVA', '1990-05-04', 'EXTERNO', FALSE, '1001');
--ERROR:  invalid input value for enum cargos: "EXTERNO"
--LINE 1: ...ES('20508945389', 'FERNANDO SILVA', '1990-05-04', 'EXTERNO',...


-- 11 CADASTRANDO FUNCIONÁRIO SEM ALOCAÇÃO EM FARMÁCIA - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('09009009000', 'Maria Luisa', '1995-08-08', 'CAIXA', FALSE, NULL);
--INSERT 0 1

-- 12 CADASTRANDO UM CLIENTE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO cliente VALUES('Ivete Sangalo', '88776655443', '1977-07-07', '83998256101'); 
--INSERT 0 1


-- 12 CADASTRANDO ENTREGADOR - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('22222222222', 'Aderbal José', '1990-10-12', 'ENTREGADOR', FALSE, 1002);
--INSERT 0 1

--13 CADASTRANDO ENDEREÇO DE RESIDÊNCIA DO CLIENTE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO endereço VALUES(default,'88776655443','RESIDÊNCIA', 'PALMEIRA', 'CAMPINA GRANDE', 'PARAÍBA', '58401222', NULL);
--INSERT 0 1

-- 14  CADASTRANDO ENDEREÇO DE TRABALHO DO MESMO CLIENTE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO endereço VALUES(default,'88776655443','TRABALHO', 'CENTRO', 'CAMPINA GRANDE', 'PARAÍBA', '58401000', 'Meu endereço de trabalho');
--INSERT 0 1

-- 15 CADASTRANDO ENDEREÇO DE TRABALHO DO MESMO CLIENTE - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO endereço VALUES(default,'88776655443','OUTRO', 'CATOLÉ', 'CAMPINA GRANDE', 'PARAÍBA', '58401111', 'Edereço da casa da minha mãe');
--INSERT 0 1

-- 16 CADASTRANDO CLIENTE COM IDADE INVÁLIDA, NÃO É PERMITIDO - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO cliente VALUES('Valentina Muniz', '88776655997', '2018-01-01', '83998765432');
--ERROR:  new row for relation "cliente" violates check constraint "idade_valida_chk"
--DETAIL:  Failing row contains (Valentina Muniz, 88776655997, 2018-01-01, 83998765432).

-- 17 CADASTRANDO MEDICAMENTO DE RECEITA OBRIGATÓRIA - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO medicamento VALUES (01, TRUE, 39.9, 'TYLENOL');
--INSERT 0 1

-- 18 CADASTRANDO MEDICAMENTO SEM RECEITA OBRIGATÓRIA - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO medicamento VALUES (02, FALSE, 20.0, 'DIPIRONA');
--INSERT 0 1

-- 19 CADASTRANDO FUNCIONÁRIO VENDEDOR - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO funcionario VALUES('11881155667', 'Felipe Freitas', '1989-03-03', 'VENDEDOR', FALSE, 1002);
--INSERT 0 1

-- 20 VENDA PARA CLIENTE NÃO CADASTRADO - SEM ENTREGA - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO venda VALUES (default, NULL, NULL, '11881155667',02, 20.0, FALSE, 'VENDEDOR');
--INSERT 0 1

-- 21 VENDA REMÉDIO COM RECEITA OBRIGATÓRIA PARA CLIENTE CADASTRADO - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO venda VALUES (default, NULL, '88776655443', '11881155667',01, 39.9, TRUE, 'VENDEDOR');
--INSERT 0 1

-- 22 VENDA REMÉDIO COM RECEITA OBRIGATÓRIA PARA CLIENTE NÃO CADASTRADO - RETORNA ERRO POIS OPERAÇÃO É INVÁLIDA
--INSERT INTO venda VALUES (default, NULL, NULL, '11881155667',01, 39.9, TRUE, 'VENDEDOR');
--ERROR:  new row for relation "venda" violates check constraint "venda_valida_chk"
--DETAIL:  Failing row contains (6, null, null, 11881155667, 1, 39.9, t, VENDEDOR).

-- 23 VENDA COM FUNCIONÁRIO DO TIPO DIFERENTE DE VENDEDOR - RETORNA ERRO POIS APENAS FUNCIONÁRIO DO TIPO VENDEDOR PODE VENDER
--INSERT INTO venda VALUES (default, NULL, '88776655443', '11111111111',02, 20.0, FALSE, 'ADMINISTRADOR');
--ERROR:  new row for relation "venda" violates check constraint "cargo_funcionario_chk"
--DETAIL:  Failing row contains (7, null, 88776655443, 11111111111, 2, 20.0, f, ADMINISTRADOR).

--24 REMOVENDO UM FUNCIONÁRIO ASSOCIADO A UMA VENDA - A REMOÇÃO NÃO DEVE SER REALIZADA
--DELETE FROM funcionario WHERE (cpf = '11881155667');
--ERROR:  update or delete on table "funcionario" violates foreign key constraint "venda_cpf_funcionario_fkey" on table "venda"
--DETAIL:  Key (cpf)=(11881155667) is still referenced from table "venda".

-- 25 REMOVENDO UM MEDICAMENTO ASSOCIADO A UMA VENDA - A REMOÇÃO NÃO DEVE SER REALIZADA
--DELETE FROM medicamento WHERE (id = 02);
--ERROR:  update or delete on table "medicamento" violates foreign key constraint "venda_id_medicamento_fkey" on table "venda"
--DETAIL:  Key (id)=(2) is still referenced from table "venda".

-- 26 CADASTRANDO ENTREGA PARA CLIENTE CADASTRADO - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO entregas VALUES (default, '88776655443', '22222222222', 'RESIDÊNCIA');
--INSERT 0 1

-- 27 CADASTRANDO ENTREGA PARA CLIENTE NÃO CADASTRADO - NÃO PODE SER REALIZADA
--INSERT INTO entregas VALUES (default, NULL, '22222222222', 'RESIDÊNCIA');
--ERROR:  null value in column "cpf_cliente" violates not-null constraint
--DETAIL:  Failing row contains (2, null, 22222222222, RESIDÊNCIA).

-- 28 TESTANDO VENDA COM ENTREGA - DEVE SER EXECUTADO COM SUCESSO
--INSERT INTO venda VALUES (default, 1, '88776655443', '22222222222',02, 20.0, FALSE, 'VENDEDOR');
--INSERT 0 1

