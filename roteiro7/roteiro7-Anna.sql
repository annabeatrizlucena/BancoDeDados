-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-05-01 03:49:38.397

-- tables
-- Table: Compoe
CREATE TABLE Compoe (
    id_jogo int  NOT NULL,
    id_set int  NOT NULL,
    CONSTRAINT Compoe_pk PRIMARY KEY (id_jogo,id_set)
);

-- Table: Jogo
CREATE TABLE Jogo (
    id serial  NOT NULL,
    nome_time1 varchar(30)  NOT NULL,
    nome_time2 varchar(30)  NOT NULL,
    hora timestamp  NOT NULL,
    jogador_destaque varchar(60)  NOT NULL,
    vencedor varchar(30)  NOT NULL,
    arbitro1 varchar(60)  NOT NULL,
    arbitro2 varchar(60)  NOT NULL,
    categoria varchar(10)  NOT NULL,
    descricao_extra text  NULL,
    CONSTRAINT Jogo_pk PRIMARY KEY (id)
);

-- Table: Jogou_em
CREATE TABLE Jogou_em (
    posicao varchar(15)  NOT NULL,
    substituido_por varchar(60)  NULL,
    pontos_feitos int  NOT NULL,
    Pessoa_cpf char(11)  NOT NULL,
    Jogo_id int  NOT NULL,
    CONSTRAINT Jogou_em_pk PRIMARY KEY (Pessoa_cpf,Jogo_id)
);

-- Table: Pessoa
CREATE TABLE Pessoa (
    cpf char(11)  NOT NULL,
    nome varchar(30)  NOT NULL,
    sobrenome varchar(30)  NOT NULL,
    data_nascimento date  NOT NULL,
    nome_equipe varchar(30)  NOT NULL,
    tipo varchar(20)  NOT NULL,
    genero varchar(10)  NOT NULL,
    data_ingresso date  NOT NULL,
    CONSTRAINT Pessoa_pk PRIMARY KEY (cpf)
);

-- Table: Set
CREATE TABLE Set (
    id serial  NOT NULL,
    id_jogo int  NOT NULL,
    pont_time1 int  NOT NULL,
    pont_time2 int  NOT NULL,
    CONSTRAINT Set_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: Jogo_Compoe (table: Compoe)
ALTER TABLE Compoe ADD CONSTRAINT Jogo_Compoe
    FOREIGN KEY (id_jogo)
    REFERENCES Jogo (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Jogou_em_Jogo (table: Jogou_em)
ALTER TABLE Jogou_em ADD CONSTRAINT Jogou_em_Jogo
    FOREIGN KEY (Jogo_id)
    REFERENCES Jogo (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Jogou_em_Pessoa (table: Jogou_em)
ALTER TABLE Jogou_em ADD CONSTRAINT Jogou_em_Pessoa
    FOREIGN KEY (Pessoa_cpf)
    REFERENCES Pessoa (cpf)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Set_Compoe (table: Compoe)
ALTER TABLE Compoe ADD CONSTRAINT Set_Compoe
    FOREIGN KEY (id_set)
    REFERENCES Set (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.


-- POVOANDO O BANCO DE DADOS

--TIME 1
--------------------------------------------------------------------------------------------------------------------------------
INSERT INTO pessoa VALUES ('12345678901', 'Anna', 'Lira', '2001-11-11', 'UFCG-sede', 'jogador', 'feminino', '2019-04-20');
INSERT INTO pessoa VALUES ('10101010101', 'Larissa', 'Farias', '1998-08-27', 'UFCG-sede', 'jogador', 'feminino', '2019-04-20');
INSERT INTO pessoa VALUES ('22222222222', 'Cecília', 'Pereira', '1998-07-13', 'UFCG-sede', 'jogador', 'feminino', '2019-04-20');
INSERT INTO pessoa VALUES ('00900900900', 'Emanuelle', 'Silva', '1999-10-25', 'UFCG-sede', 'jogador', 'feminino', '2018-04-02');
INSERT INTO pessoa VALUES ('33443344334', 'Ayani', 'Lins', '2000-10-19', 'UFCG-sede', 'jogador', 'feminino', '2018-04-02');
INSERT INTO pessoa VALUES ('65656565656', 'Fábia', 'Barros', '2001-02-05', 'UFCG-sede', 'jogador', 'feminino', '2018-04-02');
INSERT INTO pessoa VALUES ('77777777777', 'Eduarda', 'Castro', '2000-04-04', 'UFCG-sede', 'jogador', 'feminino', '2018-04-02');
INSERT INTO pessoa VALUES ('98765432101', 'Magda', 'Leite', '1999-06-16', 'UFCG-sede', 'jogador', 'feminino', '2018-04-02');
INSERT INTO pessoa VALUES ('09870987098', 'Melanie', 'Oliveira', '1999-07-11', 'UFCG-sede', 'jogador', 'feminino', '2019-07-14');
INSERT INTO pessoa VALUES ('11111111111', 'Maggie', 'Martins', '1999-04-08', 'UFCG-sede', 'jogador', 'feminino', '2019-07-14');

-- TREINADOR
INSERT INTO pessoa VALUES ('84072380479', 'Ivanice', 'Pinheiro', '1984-12-11', 'UFCG-sede', 'treinador', 'feminino', '2018-04-02');
-----------------------------------------------------------------------------------------------------------------------------------

-- TIME 2
-----------------------------------------------------------------------------------------------------------------------------------
INSERT INTO pessoa VALUES ('12121212121', 'Marisa ', 'Barros', '1998-04-06', 'UFCG-patos', 'jogador', 'feminino', '2017-06-11');
INSERT INTO pessoa VALUES ('13131313131', 'Giovana', 'Agra', '2001-03-26', 'UFCG-patos', 'jogador', 'feminino', '2017-06-11');
INSERT INTO pessoa VALUES ('14141414141', 'Mariana', 'Marques', '2001-05-17', 'UFCG-patos', 'jogador', 'feminino', '2017-06-11');
INSERT INTO pessoa VALUES ('76767676767', 'Isabelle', 'Barbosa', '2001-11-22', 'UFCG-patos', 'jogador', 'feminino', '2017-06-11');
INSERT INTO pessoa VALUES ('98989898989', 'Camila', 'Ricarte', '2000-12-30', 'UFCG-patos', 'jogador', 'feminino', '2018-05-20');
INSERT INTO pessoa VALUES ('06547382901', 'Julia', 'Monteiro', '2000-09-14', 'UFCG-patos', 'jogador', 'feminino', '2018-05-20');
INSERT INTO pessoa VALUES ('34567218920', 'Luana', 'Nóbrega', '2000-08-11', 'UFCG-patos', 'jogador', 'feminino', '2018-05-20');
INSERT INTO pessoa VALUES ('88888888888', 'Alice', 'Lemos', '2000-10-06', 'UFCG-patos', 'jogador', 'feminino', '2018-05-20');
INSERT INTO pessoa VALUES ('76272930939', 'Gabriela', 'Albuquerque', '2001-01-05', 'UFCG-patos', 'jogador', 'feminino', '2018-05-20');
INSERT INTO pessoa VALUES ('08398437487', 'Bruna', 'Palhano', '1997-03-25', 'UFCG-patos', 'jogador', 'feminino', '2018-05-20');

-- TREINADOR
INSERT INTO pessoa VALUES ('83038383883', 'Ivana', 'Muniz', '1988-04-04', 'UFCG-patos', 'treinador', 'feminino', '2018-05-20');
-----------------------------------------------------------------------------------------------------------------------------------

-- TIME 3
----------------------------------------------------------------------------------------------------------------------------------
INSERT INTO pessoa VALUES ('66666666661', 'Luiza', 'Ataide', '1998-07-24', 'UFCG-cuité', 'jogador', 'feminino', '2019-03-03');
INSERT INTO pessoa VALUES ('99999999999', 'Evelyn', 'Lopes', '1999-12-09', 'UFCG-cuité', 'jogador', 'feminino', '2019-03-03');
INSERT INTO pessoa VALUES ('08709804302', 'Beatrice', 'Veloso', '2001-11-10', 'UFCG-cuité', 'jogador', 'feminino', '2019-03-03');
INSERT INTO pessoa VALUES ('12387690347', 'Rebeca', 'Torres', '2001-09-13', 'UFCG-cuité', 'jogador', 'feminino', '2019-03-03');
INSERT INTO pessoa VALUES ('23456098765', 'Maria', 'Bento', '2000-08-28', 'UFCG-cuité', 'jogador', 'feminino', '2018-11-10');
INSERT INTO pessoa VALUES ('55555555555', 'Sarah', 'Cavalcanti', '2000-03-11', 'UFCG-cuité', 'jogador', 'feminino', '2018-11-10');
INSERT INTO pessoa VALUES ('12312312312', 'Vitoria', 'Diniz', '2001-10-04', 'UFCG-cuité', 'jogador', 'feminino', '2018-11-10');
INSERT INTO pessoa VALUES ('96272939436', 'Ariana', 'Sobral', '1998-07-21', 'UFCG-cuité', 'jogador', 'feminino', '2018-11-10');
INSERT INTO pessoa VALUES ('55668899004', 'Natalia', 'Vidal', '2000-08-05', 'UFCG-cuité', 'jogador', 'feminino', '2018-11-10');
INSERT INTO pessoa VALUES ('12345789602', 'Emanuele', 'Fernandes', '2000-02-25', 'UFCG-cuité', 'jogador', 'feminino', '2018-11-10');

-- TREINADOR
INSERT INTO pessoa VALUES ('21912990894', 'Leandro', 'Dutra', '1982-06-05', 'UFCG-cuité', 'treinador', 'masculino', '2019-03-03');

------------------------------------------------------------------------------------------------------------------------------------

--JOGO 1
------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO jogo VALUES (default, 'UFCG-sede', 'UFCG-cuité', '2021-04-29 09:00:00', 'Anna Lira', 'UFCG-sede', 'Pedro Lima', 'Marcus Xavier', 'feminino', 'A jogadora Rebeca Torres se machucou e teve que ser levada até o hospital');
------------------------------------------------------------------------------------------------------------------------------------

--JOGO 2
------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO jogo VALUES (default, 'UFCG-cuité', 'UFCG-patos', '2021-04-29 12:00:00', 'Alice Lemos', 'UFCG-cuité', 'Mateus Dumont', 'Marcus Xavier', 'feminino', null);
-------------------------------------------------------------------------------------------------------------------------------------

--JOGO 3
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO jogo VALUES (default, 'UFCG-patos', 'UFCG-sede', '2021-04-29 14:30:00', 'Larissa Farias', 'UFCG-sede', 'Laerte Simplicio', 'Danilo Ferras', 'feminino','Jogo muito acirrado, mas a torcida fez a diferença em prol do campus sede');
-------------------------------------------------------------------------------------------------------------------------------------

--JOGOU_EM

-- JOGO 1
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO jogou_em VALUES ('central', null, 24, '12345678901', 1);
INSERT INTO jogou_em VALUES ('central', null, 12, '10101010101', 1);
INSERT INTO jogou_em VALUES ('ponteira', 'Melanie Oliveira', 6, '22222222222', 1);
INSERT INTO jogou_em VALUES ('oposta', null, 11, '00900900900', 1);
INSERT INTO jogou_em VALUES ('ponteira', 'Fábia Barros', 8, '77777777777', 1);
INSERT INTO jogou_em VALUES ('levantadora', null, 2, '11111111111', 1);
INSERT INTO jogou_em VALUES ('ponteira', null, 6, '09870987098', 1);
INSERT INTO jogou_em VALUES ('ponteira', null, 6, '65656565656', 1);

INSERT INTO jogou_em VALUES ('ponteira', null, 13, '23456098765', 1);
INSERT INTO jogou_em VALUES ('ponteira', null, 10, '08709804302', 1);
INSERT INTO jogou_em VALUES ('central', null, 8, '96272939436', 1);
INSERT INTO jogou_em VALUES ('central', null, 8, '12312312312', 1);
INSERT INTO jogou_em VALUES ('levantadora',null , 6, '55668899004', 1);
INSERT INTO jogou_em VALUES ('líbero', null, 5, '55555555555', 1);
INSERT INTO jogou_em VALUES ('oposta', 'Luiza Ataide', 7, '12387690347', 1);
INSERT INTO jogou_em VALUES ('oposta', null, 11, '66666666661', 1);
----------------------------------------------------------------------------------------------------------------------------------------

-- JOGO 2
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO jogou_em VALUES ('central', null, 21, '08709804302', 2);
INSERT INTO jogou_em VALUES ('central', 'Luiza Ataide', 7, '99999999999', 2);
INSERT INTO jogou_em VALUES ('central', null, 15, '66666666661', 2);
INSERT INTO jogou_em VALUES ('oposta', null, 13, '23456098765', 2);
INSERT INTO jogou_em VALUES ('levantadora', null, 4, '55668899004', 2);
INSERT INTO jogou_em VALUES ('oposta', null, 14, '96272939436', 2);
INSERT INTO jogou_em VALUES ('líbero', null, 9, '55555555555', 2);
INSERT INTO jogou_em VALUES ('ponteira', null, 14, '12312312312', 2);

INSERT INTO jogou_em VALUES ('ponteira', 'Camila Ricarte', 10, '14141414141', 2);
INSERT INTO jogou_em VALUES ('ponteira', 'Isabelle Barbosa', 10, '76767676767', 2);
INSERT INTO jogou_em VALUES ('ponteira', null, 13, '98989898989', 2);
INSERT INTO jogou_em VALUES ('ponteira', null, 9, '06547382901', 2);
INSERT INTO jogou_em VALUES ('central', null, 7, '34567218920', 2);
INSERT INTO jogou_em VALUES ('central', null, 18, '88888888888', 2);
INSERT INTO jogou_em VALUES ('levantadora', null, 8, '76272930939', 2);
INSERT INTO jogou_em VALUES ('oposta', null, 12, '08398437487', 2); 
----------------------------------------------------------------------------------------------------------------------------------------

-- JOGO 3
-------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO jogou_em VALUES ('central', null, 10, '12345678901', 3);
INSERT INTO jogou_em VALUES ('central', null, 17, '10101010101', 3);
INSERT INTO jogou_em VALUES ('ponteira', null, 11, '22222222222', 3);
INSERT INTO jogou_em VALUES ('oposta', null, 10, '00900900900', 3);
INSERT INTO jogou_em VALUES ('ponteira', null, 0, '77777777777', 3);
INSERT INTO jogou_em VALUES ('levantadora', null, 11, '11111111111', 3);
INSERT INTO jogou_em VALUES ('ponteira', null, 0, '09870987098', 3);
INSERT INTO jogou_em VALUES ('ponteira', null, 16, '65656565656', 3);

INSERT INTO jogou_em VALUES ('ponteira', null, 12, '14141414141', 3); 
INSERT INTO jogou_em VALUES ('ponteira', null, 9, '76767676767', 3); 
INSERT INTO jogou_em VALUES ('ponteira', null, 0, '98989898989', 3); 
INSERT INTO jogou_em VALUES ('ponteira', 'Mariana Marques', 6, '06547382901', 3); 
INSERT INTO jogou_em VALUES ('central', null, 5, '34567218920', 3); 
INSERT INTO jogou_em VALUES ('central', null, 12, '88888888888', 3); 
INSERT INTO jogou_em VALUES ('levantadora', null, 8, '13131313131', 3);
INSERT INTO jogou_em VALUES ('oposta', null, 8, '12121212121', 3); 
----------------------------------------------------------------------------------------------------------------------------------------

-- ADICIONANDO OS SETS DOS RESPECTIVOS JOGOS

-- JOGO 1
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO set VALUES (default, 1, 25, 22);
INSERT INTO set VALUES (default, 1, 25, 23);
INSERT INTO set VALUES (default, 1, 25, 23);
-----------------------------------------------------------------------------------------------------------------------------------------

-- JOGO 2
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO set VALUES (default, 2, 25, 23);
INSERT INTO set VALUES (default, 2, 22, 25);
INSERT INTO set VALUES (default, 2, 25, 20);
INSERT INTO set VALUES (default, 2, 25, 19);
-----------------------------------------------------------------------------------------------------------------------------------------

-- JOGO 3
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO set VALUES (default, 3, 25, 20);
INSERT INTO set VALUES (default, 3, 22, 22);
INSERT INTO set VALUES (default, 3, 25, 18);


