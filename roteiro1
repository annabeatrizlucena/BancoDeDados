/* BD 1
ROTEIRO 1B - BANCO DE DADOS PARA UMA SEGURADORA DE AUTOMÓVEIS
ANNA BEATRIZ LUCENA LIRA - 119110382
*/

-- QUESTÕES 1 e 2

/*DADOS DO AUTOMÓVEL
todo automóvel possui uma placa (que irá lhe identificar unicamente), um modelo, o ano de fabricação, uma marca, um chassi, o nome do seu proprietário e o cpf do seu proprietário (já que, não necessariamente, o segurado é o dono do automóvel)
*/
CREATE TABLE automovel(
placa char(7),
modelo varchar(20),
ano integer,
marca varchar(20),
chassi char(17),
nome_proprietario varchar(80),
cpf_proprietario char(11),
valor numeric
);

/*DADOS DO SEGURADO
todo segurado possui um nome e um sobrenome (decidi colocar em campos diferentes para uma possível manipulação no fututo), um cpf (seu identificador único), uma data de nascimento, um telefone para contato, um email (que será opcional), um endereço e seu respectivo CEP
*/
CREATE TABLE segurado(
nome varchar(40),
sobrenome varchar(40),
cpf integer,
data_nascimento date,
telefone varchar(20),
email varchar(40),
endereço text,
cep integer
);

/*DADOS DO PERITO
todo perito possui um nome e um sobrenome(em campos diferentes pelo mesmo motivo descrito no segurado), um cpf(que lhe identifica unicamente), um telefone para contato e a quantidade de perícias realizadas para empresa (uma vez que a futuramente a empresa precisará desse dado para uma uma futura bonificação ou algo do tipo)
*/
CREATE TABLE perito(
nome varchar(40),
sobrenome varchar(40),
cpf integer,
telefone varchar(20),
quantidade_pericias integer
);

/*DADOS DA OFICINA
toda oficina possui um nome, um cnpj(que irá lhe identificar unicamente), um telefone para contato, e endereço e seu respectivo CEP
*/
CREATE TABLE oficina(
nome varchar(40),
cnpj integer,
telefone varchar(20),
endereço text,
cep integer
);

/*DADOS DO SEGURO
todo seguro possui um identificador único, o cpf do segurado(contratante), a placa do automóvel segurado, uma descrição (com detalhes do serviço contratado), uma data de ativação (data de contratação), uma data de vencimento (até quando o seguro é válido) e um valor (valor de contrato)
*/
CREATE TABLE seguro(
id serial,
cpf_segurado integer,
placa_automovel char(7),
descrição text,
data_de_ativação date,
data_de_vencimento date,
valor numeric
);

/*DADOS DO SINISTRO
todo sinistro possui a placa do autómovel envolvido, o nome do condutor do veículo no momento do acontecimento, o cpf do segurado, uma descrição do acontecimento, o nome de quem comunicou o acontecimento, a data e a hora da ocorrência, o local da ocorrência, também possui um id do seguro contratado para o veículo envolvido no acontecimento e um identificador único
*/
CREATE TABLE sinistro(
placa_automovel char(7),
nome_motorista varchar(80),
cpf_segurado integer,
descrição text,
nome_comunicador varchar(80),
data_hora_ocorrencia timestamp,
local_ocorrencia text,
id_seguro integer,
id serial
);

/*DADOS DA PERICIA
toda perícia possui o cpf do perito, a placa do automovel periciado, a data a hora da realização da perícia, um laudo descrito pelo perito, um valor booleano que representa se o automovel tever perda total, um orçamento estimado dos danos e um identificador
*/
CREATE TABLE pericia(
cpf_perito integer,
placa_automovel char(7),
data_hora timestamp,
laudo text,
perda_total boolean,
orçamento_estimado numeric,
id serial
);

/*DADOS DO REPARO
todo serviço de reparo guarda a placa do automovel reparado, o cnpj da oficina que realizou o serviço, o valor do serviço, a data de entrada do automovel na oficina, a data de saida do automovel na oficina, uma descrição do serviço e um identificador
*/
CREATE TABLE reparo(
placa_automovel char(7),
cnpj_oficina integer,
valor numeric,
data_entrada date,
data_saida date,
descrição text,
id serial
);


-- QUESTÃO 3
-- adicionando as chaves primárias de cada relação

ALTER TABLE automovel ADD PRIMARY KEY (placa);
ALTER TABLE segurado ADD PRIMARY KEY (cpf);
ALTER TABLE perito ADD PRIMARY KEY (cpf);
ALTER TABLE oficina ADD PRIMARY KEY (cnpj);
ALTER TABLE seguro ADD PRIMARY KEY (id);
ALTER TABLE sinistro ADD PRIMARY KEY (id);
ALTER TABLE pericia ADD PRIMARY KEY (id);
ALTER TABLE reparo ADD PRIMARY KEY (id);



-- QUESTÃO 4
-- definindo a/as chave(s) estrangeira(s) de cada relação 


ALTER TABLE seguro ADD CONSTRAINT segurado_cpf_fkey FOREIGN KEY (cpf_segurado) REFERENCES segurado(cpf);

ALTER TABLE seguro ADD CONSTRAINT automovel_placa_fkey FOREIGN KEY (placa_automovel) REFERENCES automovel(placa);

ALTER TABLE sinistro ADD CONSTRAINT automovel_placa_fkey FOREIGN KEY (placa_automovel) REFERENCES automovel(placa);

ALTER TABLE sinistro ADD CONSTRAINT segurado_cpf_fkey FOREIGN KEY (cpf_segurado) REFERENCES segurado(cpf);

ALTER TABLE sinistro ADD CONSTRAINT seguro_id_fkey FOREIGN KEY (id_seguro) REFERENCES seguro(id);

ALTER TABLE pericia ADD CONSTRAINT automovel_placa_fkey FOREIGN KEY (placa_automovel) REFERENCES automovel(placa);

ALTER TABLE pericia ADD CONSTRAINT perito_cpf_fkey FOREIGN KEY (cpf_perito) REFERENCES perito(cpf);

ALTER TABLE reparo ADD CONSTRAINT automovel_placa_fkey FOREIGN KEY (placa_automovel) REFERENCES automovel(placa);

ALTER TABLE reparo ADD CONSTRAINT oficina_cnpj_fkey FOREIGN KEY (cnpj_oficina) REFERENCES oficina(cnpj);



-- QUESTÃO 6
-- remoção das tabelas criadas, atenção pois a ordem de remoção importa (já que algumas relações referenciam outras)

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE oficina;
DROP TABLE perito;
DROP TABLE segurado ;
DROP TABLE automovel;


-- QUESTÕES 7 e 8
-- criando novamente as relações, agora com as constraints de chaves primárias e chaves estrangeiras definidas
-- os atributos estabelecidos como NOT NULL serão muito importantes para o funcionamento do banco, por isso não podem tem referência nula

CREATE TABLE automovel(
placa char(7) NOT NULL,
modelo varchar(20) NOT NULL,
ano integer NOT NULL,
marca varchar(20) NOT NULL,
chassi char(17) NOT NULL,
nome_proprietario varchar(80) NOT NULL,
cpf_proprietario char(11) NOT NULL,
valor numeric NOT NULL,
CONSTRAINT automovel_pkey PRIMARY KEY(placa)
);


CREATE TABLE segurado(
nome varchar(40) NOT NULL,
sobrenome varchar(40) NOT NULL,
cpf integer NOT NULL,
data_nascimento date NOT NULL,
telefone varchar(20) NOT NULL,
email varchar(40),
endereço text NOT NULL,
cep integer NOT NULL,
CONSTRAINT segurado_pkey PRIMARY KEY(cpf)
);

CREATE TABLE perito(
nome varchar(40) NOT NULL,
sobrenome varchar(40) NOT NULL,
cpf integer NOT NULL,
telefone varchar(20) NOT NULL,
quantidade_pericias integer NOT NULL,
CONSTRAINT perito_pkey PRIMARY KEY(cpf)
);

CREATE TABLE oficina(
nome varchar(40) NOT NULL,
cnpj integer NOT NULL,
telefone varchar(20) NOT NULL,
endereço text NOT NULL,
cep integer NOT NULL,
CONSTRAINT oficina_pkey PRIMARY KEY(cnpj)
);

CREATE TABLE seguro(
id serial NOT NULL,
cpf_segurado integer NOT NULL,
placa_automovel char(7) NOT NULL,
descrição text NOT NULL,
data_de_ativação date NOT NULL,
data_de_vencimento date NOT NULL,
valor numeric NOT NULL,
CONSTRAINT seguro_pkey PRIMARY KEY(id),
CONSTRAINT segurado_cpf_fkey FOREIGN KEY(cpf_segurado) REFERENCES segurado(cpf)
);

CREATE TABLE sinistro(
placa_automovel char(7) NOT NULL,
nome_motorista varchar(80) NOT NULL,
cpf_segurado integer NOT NULL,
descrição text NOT NULL,
nome_comunicador varchar(80) NOT NULL,
data_hora_ocorrencia timestamp NOT NULL,
local_ocorrencia text NOT NULL,
id_seguro integer NOT NULL,
id serial NOT NULL,
CONSTRAINT sinistro_pkey PRIMARY KEY(id),
CONSTRAINT automovel_placa_fkey FOREIGN KEY(placa_automovel) REFERENCES automovel(placa),
CONSTRAINT segurado_cpf_fkey FOREIGN KEY(cpf_segurado) REFERENCES segurado(cpf),
CONSTRAINT seguro_id_fkey FOREIGN KEY(id_seguro) REFERENCES seguro(id)
);

CREATE TABLE pericia(
cpf_perito integer NOT NULL,
placa_automovel char(7) NOT NULL,
data_hora timestamp NOT NULL,
laudo text NOT NULL,
perda_total boolean NOT NULL,
orçamento_estimado numeric NOT NULL,
id serial NOT NULL,
CONSTRAINT pericia_pkey PRIMARY KEY(id),
CONSTRAINT peritol_cpf_fkey FOREIGN KEY(cpf_perito) REFERENCES perito(cpf),
CONSTRAINT automovel_placa_fkey FOREIGN KEY(placa_automovel) REFERENCES automovel(placa)
);

CREATE TABLE reparo(
placa_automovel char(7) NOT NULL,
cnpj_oficina integer NOT NULL,
valor numeric NOT NULL,
data_entrada date NOT NULL,
data_saida date NOT NULL,
descrição text NOT NULL,
id serial NOT NULL,
CONSTRAINT reparo_pkey PRIMARY KEY(id),
CONSTRAINT automovel_placa_fkey FOREIGN KEY(placa_automovel) REFERENCES automovel(placa),
CONSTRAINT oficina_cnpj_fkey FOREIGN KEY(cnpj_oficina) REFERENCES oficina(cnpj)
);

-- QUESTÃO 9 
-- removendo as tabelas com cuidado nas relações. Também poderia ser feito conforme a remoção feita na QUESTÃO 6

DROP TABLE automovel CASCADE;
DROP TABLE segurado CASCADE;
DROP TABLE perito CASCADE;
DROP TABLE oficina CASCADE;
DROP TABLE seguro CASCADE;
DROP TABLE sinistro;
DROP TABLE pericia;
DROP TABLE reparo;

-- QUESTÃO 10
/* Para um esquema mais complexo poderia ser criada uma relação para os dependentes do segurado no contrato, uma relação referente aos tipos dos seguros existentes, bem como uma relação referente aos tipos de sinistros existentes. 
*/


