DROP TABLE jornada;
DROP TABLE epoca;
DROP TABLE jogadora;
DROP TABLE treinador;
DROP TABLE pessoa;


CREATE TABLE pessoa (
  nif              NUMBER(6)      CONSTRAINT nn_nif                 NOT NULL,
  nome             VARCHAR(100)   CONSTRAINT nn_nome                NOT NULL,
  data_nascimento  DATE           CONSTRAINT nn_data_nascimento     NOT NULL,
  sexo             VARCHAR(10)    CONSTRAINT nn_sexo                NOT NULL,
  telemovel        NUMBER(9)      CONSTRAINT nn_telemovel           NOT NULL,
--
  CONSTRAINT pk_pessoa
    PRIMARY KEY (nif),
--
  CONSTRAINT nsei_data_nascimento
      ANTERIOR_A ano_da_primeira_epoca_em_q_esteve_num_clube            --nsei
--      
  CONSTRAINT un_telemovel
    UNIQUE (telemovel),
);




CREATE TABLE jogadora (  -- https://stackoverflow.com/questions/4361381/how-do-we-implement-an-is-a-relationship
  nif_jogadora   NUMBER(6)    CONSTRAINT nn_nif_jogadora    NOT NULL
  REFERENCES pessoa(nif),
--
  CONSTRAINT pk_jogadora
    PRIMARY KEY (nif_jogadora),
--
);



CREATE TABLE treinador (
  nif_treinador    NUMBER(6)     CONSTRAINT nn_nif_treinador    NOT NULL REFERENCES pessoa(nif),
  tptd             NUMBER(20)    CONSTRAINT nn_tptd             NOT NULL,
  nivel            VARCHAR(1)    CONSTRAINT nn_nivel            NOT NULL,
  data_validade    DATE          CONSTRAINT nn_data_validade    NOT NULL,
--
  CONSTRAINT pk_treinador
    PRIMARY KEY (nif_treinador),
--
  CONSTRAINT un_tptd    --o que e o tptd
    UNIQUE (tptd),
    
    --escrever rias
);


CREATE TABLE epoca (
  ano   NUMBER(4)    CONSTRAINT nn_ano    NOT NULL,
--
  CONSTRAINT pk_epoca
    PRIMARY KEY (ano),
--
  CONSTRAINT un_ano
    UNIQUE (ano),
--
  CONSTRAINT ck_ano
    CHECK (ano > 0)
);



CREATE TABLE jornada (    --Entidade fraca
  numero   NUMBER(100)    CONSTRAINT nn_numero    NOT NULL,
  ano      NUMBER(4)      CONSTRAINT nn_ano       NOT NULL,
--
  CONSTRAINT pk_jornada
    PRIMARY KEY (numero,ano),
--   
  CONSTRAINT fk_ano
    FOREIGN KEY (ano)
    REFERENCES epoca(ano) ON DELETE CASCADE
--
  CONSTRAINT un_numero
    UNIQUE (numero),
--
  CONSTRAINT ck_numero
    CHECK (numero >0),
--
  CONSTRAINT ck_ano
    CHECK (ano >0)
);


CREATE TABLE clube (
  nome              VARCHAR2(30)    CONSTRAINT nn_nome              NOT NULL,
  data_fundacao     DATE            CONSTRAINT nn_data_fundacao     NOT NULL,
--
  CONSTRAINT pk_clube
    PRIMARY KEY (nome),
--
  CONSTRAINT un_nome
    UNIQUE (nome),
);


CREATE TABLE jogo (    --tabela sem primary key?
  hora_fim              TIME(0)         CONSTRAINT nn_hora_fim          NOT NULL,
  hora_incio            TIME(0)         CONSTRAINT nn_hora_incio        NOT NULL,
  dia                   DATE            CONSTRAINT nn_dia               NOT NULL,
  espetadores           NUMBER(5),                                                  --pode nao ter espetadores
);

CREATE TABLE participa ( -- so entra aqui quem participa sempre? caso apenas entrem aqui apenas os que participam, entao tem de ter minuto de entrada E/OU saida
  minuto_entrada        NUMBER(3),   -- CONSTRAINT nn_minuto_entrada        NOT NULL, pode nao chegar a entrar
  minuto_saida          DATE,         --CONSTRAINT nn_minuto_saida          NOT NULL, pode nao sai
);
