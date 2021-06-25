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

CREATE TABLE epoca (
  ano   NUMBER(4)    CONSTRAINT nn_ano    NOT NULL,
--
  CONSTRAINT pk_epoca
    PRIMARY KEY (ano),
--
  CONSTRAINT ck_ano
    CHECK (ano > 0)
);

CREATE TABLE jornada (    --Entidade fraca
  numero   NUMBER(3)      CONSTRAINT nn_numero            NOT NULL,
  ano,      --NUMBER(4)      CONSTRAINT nn_ano_jornada       NOT NULL,
--
  CONSTRAINT pk_jornada
    PRIMARY KEY (numero,ano),
--   
  CONSTRAINT fk_ano
    FOREIGN KEY (ano)
    REFERENCES epoca(ano) ON DELETE CASCADE,
--
  CONSTRAINT ck_numero
    CHECK (numero >0),
--
  CONSTRAINT ck_ano_jornada
    CHECK (ano >0)
);

CREATE TABLE clube (
  nome              VARCHAR2(30)    CONSTRAINT nn_nome_clube        NOT NULL,
  data_fundacao     DATE            CONSTRAINT nn_data_fundacao     NOT NULL,
--
  CONSTRAINT pk_clube
    PRIMARY KEY (nome)
);

CREATE TABLE jogo (
  hora_fim                  INTERVAL DAY TO SECOND    CONSTRAINT nn_hora_fim                NOT NULL,        --Ver se da TIME
  hora_incio                INTERVAL DAY TO SECOND    CONSTRAINT nn_hora_incio              NOT NULL,
  dia                       DATE                      CONSTRAINT nn_dia                     NOT NULL,       --ver se este dia pertence ao ano da epoca
  ano_epoca,                 --NUMBER(4)                 CONSTRAINT nn_ano_epoca_jogo          NOT NULL,
  espetadores               NUMBER(6),
  nome_clube_visitante,      --VARCHAR2(30)              CONSTRAINT nn_nome_clube_visitante    NOT NULL,
  nome_clube_casa,           --VARCHAR2(30)              CONSTRAINT nn_nome_clube_casa         NOT NULL,
  num_jornada,               --NUMBER(3)                 CONSTRAINT nn_num_jornada             NOT NULL,
--
  CONSTRAINT pk_jogo
   PRIMARY KEY (ano_epoca, nome_clube_visitante, nome_clube_casa, num_jornada),
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
   CONSTRAINT ck_dia_ano_epoca                                      --ria para confirmar se o ano do dia do jogo eh igual ao ano da epoca
    CHECK (ano_epoca = EXTRACT (YEAR FROM dia))
);

CREATE TABLE pessoa (
  nif              NUMBER(6)      CONSTRAINT nn_nif                 NOT NULL,
  nome             VARCHAR(100)   CONSTRAINT nn_nome_pessoa         NOT NULL,
  data_nascimento  DATE           CONSTRAINT nn_data_nascimento     NOT NULL,
  sexo             VARCHAR(10)    CONSTRAINT nn_sexo                NOT NULL,
  telemovel        NUMBER(9)      CONSTRAINT nn_telemovel           NOT NULL,
  epoca_ano,
--
  CONSTRAINT pk_pessoa
    PRIMARY KEY (nif),
--
  CONSTRAINT fk_ano_pessoa
    FOREIGN KEY (epoca_ano)
    REFERENCES epoca(ano),
--   
  CONSTRAINT ck_data_nascimento
    CHECK (EXTRACT(YEAR FROM data_nascimento) < epoca_ano),
--      
  CONSTRAINT un_telemovel
    UNIQUE (telemovel)
);

CREATE TABLE jogadora (
  nif_jogadora,   --NUMBER(6)    CONSTRAINT nn_nif_jogadora    NOT NULL,
--
  CONSTRAINT pk_jogadora
    PRIMARY KEY (nif_jogadora),
--  
  CONSTRAINT fk_nif_jogadora
    FOREIGN KEY (nif_jogadora)
    REFERENCES pessoa(nif)
);

CREATE TABLE treinador (
  nif_treinador,         --NUMBER(6)     CONSTRAINT nn_nif_treinador       NOT NULL,
  tptd                  NUMBER(6)     CONSTRAINT nn_tptd                NOT NULL,
  nivel                 NUMBER(1)     CONSTRAINT nn_nivel               NOT NULL,
  data_validade         DATE          CONSTRAINT nn_data_validade       NOT NULL,
  --data_nasc_treinador,
--
  CONSTRAINT ck_nivel
    CHECK (nivel BETWEEN 1 AND 3),
--
  CONSTRAINT pk_treinador
    PRIMARY KEY (nif_treinador),
--    
  CONSTRAINT fk_nif_treinador
    FOREIGN KEY (nif_treinador)
    REFERENCES pessoa(nif)
--
 -- CONSTRAINT ck_nascimento_validade
  -- CHECK (data_nasc_treinador < data_validade)
);

CREATE TABLE participa (
  minuto_entrada            NUMBER(3),                                                                              -- CONSTRAINT nn_minuto_entrada        NOT NULL, pode nao chegar a entrar
  minuto_saida              NUMBER(3),                                                                              --CONSTRAINT nn_minuto_saida          NOT NULL, pode nao sai
  --nif_jogadora,              --NUMBER(6)      CONSTRAINT nn_nif_jogadora_part              NOT NULL,
  nome_clube_visitante,
  nome_clube_casa,
  num_jornada,
  num_ano_epoca,
--
  CONSTRAINT pk_participa
    PRIMARY KEY (nome_clube_visitante, nome_clube_casa, num_jornada, num_ano_epoca),
--
  CONSTRAINT fk_participa
   FOREIGN KEY (num_ano_epoca, nome_clube_visitante, nome_clube_casa,  num_jornada)
   REFERENCES jogo(ano_epoca, nome_clube_visitante, nome_clube_casa, num_jornada)
--   
  --CONSTRAINT fk_nif_jogadora_part    --para ficar a saber o clube da jogadora (explicado na tabela em) saber se eh casa se eh visitante
   --FOREIGN KEY (nif_jogadora)
   --REFERENCES estah_tabela(nif_jogadora)
-- 
  --CONSTRAINT ck_minutos_part
    --CHECK (minuto_entrada <> NULL AND minuto_saida <> NULL AND minuto_entrada < minuto_saida)
);

CREATE TABLE em_tabela (
  clube_nome,
  epoca_ano,
  nif_treinador,
  -- LIGAR EM A ESTAH
--  
  CONSTRAINT pk_em
    PRIMARY KEY (clube_nome, epoca_ano, nif_treinador),
--
  CONSTRAINT fk_clube_nome_em
    FOREIGN KEY (clube_nome)
    REFERENCES clube(nome),
--    
  CONSTRAINT fk_ano_epoca_em
    FOREIGN KEY (epoca_ano)
    REFERENCES epoca(ano),
--    
  CONSTRAINT fk_nif_treinador_em            --Como a seta representa 0 ou 1 nao eh preciso constraint CONFIRMAR
    FOREIGN KEY (nif_treinador)
    REFERENCES treinador(nif_treinador)
);

CREATE TABLE estah_tabela (
  nif_jogadora,        --NUMBER(9)    CONSTRAINT nn_nif_jogadora_estah    NOT NULL,        --POR TODOS OS NIFS A NOVE E NUMEROS A 10
  cartao_licenca      NUMBER(6)    CONSTRAINT nn_cartao_licenca       NOT NULL,
--
  CONSTRAINT pk_estah
    PRIMARY KEY (nif_jogadora, cartao_licenca),
--
  CONSTRAINT un_cartao_licenca
    UNIQUE (cartao_licenca),
--  
 CONSTRAINT fk_nif_jogadora_estah
   FOREIGN KEY (nif_jogadora)
   REFERENCES jogadora(nif_jogadora)
);

INSERT INTO epoca (ano) VALUES (2019);
INSERT INTO jornada (numero) VALUES (001);
INSERT INTO clube (nome, data_fundacao) VALUES (teste, TO_DATE('17/12/2015', 'DD/MM/YYYY'));