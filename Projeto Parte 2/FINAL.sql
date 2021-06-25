-- ---------------------------------------
-- SIBD 2019/2020 - Etapa 2 do projeto
-- Numero do grupo: 01
-- Diogo Pinto, n.52763, t.14
-- Francisco Ramalho, n.53472, t.12
-- João Funenga, n.53504, t.12
-- ---------------------------------------

-- ------------ DROP TABLE ---------------
DROP TABLE em_tabela;
DROP TABLE participa;
DROP TABLE estah_tabela;
DROP TABLE treinador;
DROP TABLE jogadora;
DROP TABLE pessoa;
DROP TABLE jogo;
DROP TABLE clube;
DROP TABLE jornada;
DROP TABLE epoca;

-- ------------ CREATE TABLE -------------
CREATE TABLE epoca (
  ano   NUMBER(4)    CONSTRAINT nn_ano    NOT NULL,
--
  CONSTRAINT pk_epoca
    PRIMARY KEY (ano)
);

CREATE TABLE jornada (
  numero   NUMBER(3)      CONSTRAINT nn_numero    NOT NULL,
  ano,
--
  CONSTRAINT pk_jornada
    PRIMARY KEY (numero,ano),
--   
  CONSTRAINT fk_ano
    FOREIGN KEY (ano)
    REFERENCES epoca(ano) ON DELETE CASCADE,
--
  -- RIA 13
  CONSTRAINT ck_numero_comeca_1
    CHECK (numero > 0)
);

CREATE TABLE clube (
  nome              VARCHAR2(30)    CONSTRAINT nn_nome_clube        NOT NULL,
  data_fundacao     DATE            CONSTRAINT nn_data_fundacao     NOT NULL,
--
  CONSTRAINT pk_clube
    PRIMARY KEY (nome)
);

CREATE TABLE jogo (
  hora_inicio               INTERVAL DAY TO SECOND    CONSTRAINT nn_hora_incio              NOT NULL,
  hora_fim                  INTERVAL DAY TO SECOND    CONSTRAINT nn_hora_fim                NOT NULL,
  dia                       DATE                      CONSTRAINT nn_dia                     NOT NULL,
  espetadores               NUMBER(6),
  nome_clube_visitante,
  nome_clube_casa,
  ano_epoca,
  num_jornada,
--
  CONSTRAINT pk_jogo
   PRIMARY KEY (ano_epoca, num_jornada),
--
  CONSTRAINT fk_nome_clube_visitante
   FOREIGN KEY (nome_clube_visitante)
   REFERENCES clube(nome),
--
  CONSTRAINT fk_num_jornada
   FOREIGN KEY (num_jornada, ano_epoca)
   REFERENCES jornada(numero, ano),
-- 
  CONSTRAINT fk_nome_clube_casa
   FOREIGN KEY (nome_clube_casa)
   REFERENCES clube(nome),
--
  -- RIA 1
  CONSTRAINT ck_clube_diferente
    CHECK (nome_clube_casa <> nome_clube_visitante),
--
  -- RIA 4
   CONSTRAINT ck_dia_ano_epoca
    CHECK (ano_epoca = EXTRACT (YEAR FROM dia)),
--    
  -- RIA 9
  CONSTRAINT ck_hora_diferente
    CHECK (hora_inicio < hora_fim)
);

CREATE TABLE pessoa (
  nif              NUMBER(9)      CONSTRAINT nn_nif                 NOT NULL,
  nome             VARCHAR(100)   CONSTRAINT nn_nome_pessoa         NOT NULL,
  data_nascimento  DATE           CONSTRAINT nn_data_nascimento     NOT NULL,
  sexo             VARCHAR(1)     CONSTRAINT nn_sexo                NOT NULL,
  telemovel        NUMBER(9)      CONSTRAINT nn_telemovel           NOT NULL,
--
  CONSTRAINT pk_pessoa
    PRIMARY KEY (nif),
--
  CONSTRAINT un_telemovel
    UNIQUE (telemovel)
);

CREATE TABLE jogadora (
  nif_jogadora,
--
  CONSTRAINT pk_jogadora
    PRIMARY KEY (nif_jogadora),
--  
  CONSTRAINT fk_nif_jogadora
    FOREIGN KEY (nif_jogadora)
    REFERENCES pessoa(nif)
);

CREATE TABLE treinador (
  nif_treinador,
  tptd                  NUMBER(6)     CONSTRAINT nn_tptd                NOT NULL,
  nivel                 NUMBER(1)     CONSTRAINT nn_nivel               NOT NULL,
  data_validade         DATE          CONSTRAINT nn_data_validade       NOT NULL,
  epoca_treina,
--
  CONSTRAINT pk_treinador
    PRIMARY KEY (nif_treinador),
--    
  CONSTRAINT fk_nif_treinador
    FOREIGN KEY (nif_treinador)
    REFERENCES pessoa(nif),
--
  CONSTRAINT fk_epoca_treina
    FOREIGN KEY (epoca_treina)
    REFERENCES epoca(ano),
--
  -- RIA 8 
  CONSTRAINT ck_titulo_epoca
    CHECK (EXTRACT(YEAR FROM data_validade) > epoca_treina),
--
  -- RIA 14
  CONSTRAINT ck_nivel
    CHECK (nivel BETWEEN 1 AND 3)
);

CREATE TABLE participa (
  minuto_entrada            NUMBER(2),
  minuto_saida              NUMBER(2),
  nif_jogadora,
  num_jornada,
  num_ano_epoca,
--
  CONSTRAINT pk_participa
    PRIMARY KEY (num_jornada, num_ano_epoca, nif_jogadora),
--
  CONSTRAINT fk_participa
   FOREIGN KEY (num_ano_epoca, num_jornada)
   REFERENCES jogo(ano_epoca, num_jornada),
--   
  CONSTRAINT fk_nif_jogadora_part
   FOREIGN KEY (nif_jogadora)
   REFERENCES jogadora(nif_jogadora),
--
  --RIA 10
  CONSTRAINT ck_minutos_part
    CHECK (minuto_entrada < minuto_saida),
--
  -- RIA 11
  CONSTRAINT ck_minutos_entrada_saida
    CHECK (minuto_entrada >= 0 AND minuto_saida <= 90)
);

CREATE TABLE em_tabela (
  clube_nome,
  epoca_ano,
  nif_treinador,
  nif_jogadora,
--  
  CONSTRAINT pk_em
    PRIMARY KEY (clube_nome, epoca_ano, nif_treinador, nif_jogadora),
--
  CONSTRAINT fk_clube_nome_em
    FOREIGN KEY (clube_nome)
    REFERENCES clube(nome),
--    
  CONSTRAINT fk_ano_epoca_em
    FOREIGN KEY (epoca_ano)
    REFERENCES epoca(ano),
--    
  CONSTRAINT fk_nif_treinador_em
    FOREIGN KEY (nif_treinador)
    REFERENCES treinador(nif_treinador),
--    
  CONSTRAINT fk_nif_jogadora_em
    FOREIGN KEY (nif_jogadora)
    REFERENCES jogadora(nif_jogadora)
);

CREATE TABLE estah_tabela (
  nif_jogadora,
  cartao_licenca      NUMBER(6)    CONSTRAINT nn_cartao_licenca       NOT NULL,
--
  CONSTRAINT pk_estah
    PRIMARY KEY (nif_jogadora, cartao_licenca),
--  
 CONSTRAINT fk_nif_jogadora_estah
   FOREIGN KEY (nif_jogadora)
   REFERENCES jogadora(nif_jogadora)
);

-- -------- RIAs NAO SUPORTADAS ---------- 
  -- RIA 2
    --CONSTRAINT ck_clube_epoca
    --CHECK (clube_epoca_casa = ano_epoca AND clube_epoca_vist = ano_epoca),
  -- RIA 3
    --CONSTRAINT ck_jogadora_epoca
    --CHECK (jogadora_epoca = jogo_epoca),
  -- RIA 5
    --CONSTRAINT ck_data_fundacao
    --CHECK (EXTRACT(YEAR FROM data_fundacao) < prim_ano_epoca)
  -- RIA 6
    --CONSTRAINT ck_data_nascimento
    --CHECK (EXTRACT(YEAR FROM data_nascimento) < epoca_ano),
  -- RIA 7
    --CONSTRAINT ck_nascimento_validade
    --CHECK (data_nasc_treinador < data_validade),
  -- RIA 12 - Não pertence ao trabalho (GOLO)
  -- RIA 15 - Codigo já implementa esta ria

-- ------------ INSERT INTO --------------
INSERT INTO epoca (ano) VALUES (2019);
INSERT INTO epoca (ano) VALUES (2020);
INSERT INTO epoca (ano) VALUES (2021);

INSERT INTO jornada (numero, ano) VALUES (001, 2019);
INSERT INTO jornada (numero, ano) VALUES (002, 2019);
INSERT INTO jornada (numero, ano) VALUES (001, 2020);
INSERT INTO jornada (numero, ano) VALUES (002, 2020);

INSERT INTO clube (nome, data_fundacao) VALUES ('Clube A', TO_DATE('01/01/2000', 'DD/MM/YYYY'));
INSERT INTO clube (nome, data_fundacao) VALUES ('Clube B', TO_DATE('10/10/2005', 'DD/MM/YYYY'));

INSERT INTO JOGO (hora_inicio, hora_fim, dia, espetadores, nome_clube_casa, nome_clube_visitante, ano_epoca, num_jornada)
VALUES (interval '0 10:30:00' day(0) to second, interval '0 12:00:00' day(0) to second, TO_DATE('07/11/2020', 'DD/MM/YYYY'), 010000, 'Clube A', 'Clube B', 2020, 001);  
INSERT INTO JOGO (hora_inicio, hora_fim, dia, espetadores, nome_clube_casa, nome_clube_visitante, ano_epoca, num_jornada)
VALUES (interval '0 10:30:00' day(0) to second, interval '0 12:00:00' day(0) to second, TO_DATE('07/11/2020', 'DD/MM/YYYY'), 010000, 'Clube B', 'Clube A', 2020, 002);  

INSERT INTO pessoa (nome, sexo, nif, data_nascimento, telemovel)
VALUES ('Pessoa A', 'M', 100000001, TO_DATE('01/01/1990', 'DD/MM/YYYY'), 920000000);
INSERT INTO pessoa (nome, sexo, nif, data_nascimento, telemovel)
VALUES ('Pessoa B', 'M', 100000002, TO_DATE('02/02/1991', 'DD/MM/YYYY'), 920000001);
INSERT INTO pessoa (nome, sexo, nif, data_nascimento, telemovel)
VALUES ('Pessoa C', 'F', 100000003, TO_DATE('03/03/1992', 'DD/MM/YYYY'), 920000002);
INSERT INTO pessoa (nome, sexo, nif, data_nascimento, telemovel)
VALUES ('Pessoa D', 'F', 100000004, TO_DATE('04/04/1993', 'DD/MM/YYYY'), 920000003);

INSERT INTO treinador (nif_treinador, tptd, nivel, data_validade, epoca_treina)
VALUES (100000001, 100001, 3, TO_DATE('01/01/2025', 'DD/MM/YYYY'), 2020);
INSERT INTO treinador (nif_treinador, tptd, nivel, data_validade, epoca_treina)
VALUES (100000002, 100002, 2, TO_DATE('01/01/2030', 'DD/MM/YYYY'), 2020);

INSERT INTO jogadora (nif_jogadora) VALUES (100000003);
INSERT INTO jogadora (nif_jogadora) VALUES (100000004);

INSERT INTO participa (minuto_entrada, minuto_saida, nif_jogadora, num_jornada, num_ano_epoca)
VALUES (0, 90, 100000003, 001, 2020);
INSERT INTO participa (minuto_entrada, minuto_saida, nif_jogadora, num_jornada, num_ano_epoca)
VALUES (0, 75, 100000004, 001, 2020);

INSERT INTO em_tabela (clube_nome, epoca_ano, nif_treinador, nif_jogadora)
VALUES ('Clube A', 2020, 100000001, 100000003);
INSERT INTO em_tabela (clube_nome, epoca_ano, nif_treinador, nif_jogadora)
VALUES ('Clube B', 2020, 100000002, 100000004);

INSERT INTO estah_tabela (nif_jogadora, cartao_licenca)
VALUES (100000003, 100001);
INSERT INTO estah_tabela (nif_jogadora, cartao_licenca)
VALUES (100000004, 100002);