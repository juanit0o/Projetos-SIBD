-- ----------------------------------------------------------------------------
-- SIBD 2019/2020 - Etapa 4 do projeto
-- Numero do grupo: 01
-- Diogo Pinto, n.52763, t.14
-- Francisco Ramalho, n.53472, t.12
-- Joao Funenga, n.53504, t.12
-- ----------------------------------------------------------------------------
-- clube(sigla, nome, localidade)
-- jogo(casa, visitante, jornada, espetadores)
-- jogadora(nif, nome, nascimento, clube)
-- participa(jogadora, casa, visitante, golos)
-- ----------------------------------------------------------------------------
DROP TABLE participa;
DROP TABLE jogadora;
DROP TABLE jogo;
DROP TABLE clube;
-- ----------------------------------------------------------------------------
CREATE TABLE clube (
    sigla CHAR(3), -- Para simplificar a referencia��o de um clube.
    nome VARCHAR2(80) CONSTRAINT nn_clube_nome NOT NULL,
    localidade VARCHAR2(80) CONSTRAINT nn_clube_distrito NOT NULL,
--
    CONSTRAINT pk_clube
    PRIMARY KEY (sigla),
--
    CONSTRAINT un_clube_nome -- Nome � chave candidata.
    UNIQUE (nome)
);
-- ----------------------------------------------------------------------------
CREATE TABLE jogo (
    casa, -- Clube que joga em casa.
    visitante, -- Clube visitante.
    jornada NUMBER(2) CONSTRAINT nn_jogo_jornada NOT NULL,
    espetadores NUMBER(5), -- Pode ser NULL se n�o existirem dados.
--
    CONSTRAINT pk_jogo
    PRIMARY KEY (casa, visitante),
--
    CONSTRAINT fk_jogo_casa
    FOREIGN KEY (casa)
    REFERENCES clube(sigla),
    CONSTRAINT fk_jogo_visitante
    FOREIGN KEY (visitante)
    REFERENCES clube(sigla),
--
    CONSTRAINT ck_jogo_clubes
    CHECK (casa <> visitante),
    CONSTRAINT ck_jogo_jornada
    CHECK (jornada BETWEEN 1 AND 30),
    CONSTRAINT ck_jogo_espetadores -- Restri��o � satisfeita mesmo
    CHECK (espetadores BETWEEN 0 AND 65000) -- que espetadores seja NULL.
);
-- ----------------------------------------------------------------------------
CREATE TABLE jogadora (
    nif NUMBER(9), -- N�mero de identifica��o fiscal.
    nome VARCHAR2(80) CONSTRAINT nn_jogadora_nome NOT NULL,
    nascimento NUMBER(4) CONSTRAINT nn_jogadora_nascimento NOT NULL,
    clube CONSTRAINT nn_jogadora_clube NOT NULL,
--
    CONSTRAINT pk_jogadora
    PRIMARY KEY (nif),
--
    CONSTRAINT fk_jogadora_clube
    FOREIGN KEY (clube)
    REFERENCES clube(sigla),
--
    CONSTRAINT ck_jogadora_nif
    CHECK (nif > 0),
    CONSTRAINT ck_jogadora_nascimento
    CHECK (nascimento BETWEEN 1970 AND 2010) -- S� o ano de nascimento.
);
-- ----------------------------------------------------------------------------
CREATE TABLE participa (
    jogadora,
    casa, -- Clube da casa no jogo em que a jogadora participa.
    visitante, -- Clube visitante no mesmo jogo.
    golos NUMBER(2) CONSTRAINT nn_participa_golos NOT NULL,
--
    CONSTRAINT pk_participa
    PRIMARY KEY (jogadora, casa, visitante),
--
    CONSTRAINT fk_participa_jogadora
    FOREIGN KEY (jogadora)
    REFERENCES jogadora(nif),
    CONSTRAINT fk_participa_jogo
    FOREIGN KEY (casa, visitante)
    REFERENCES jogo(casa, visitante),
--
    CONSTRAINT ck_participa_golos
    CHECK (golos >= 0) -- S� golos na outra baliza (sem autogolos).
);
-- ----------------------------------------------------------------------------
-- Inserts clubes
INSERT INTO clube (sigla, nome, localidade)
VALUES ('SLB','Sport Lisboa e Benfica','Lisboa');
INSERT INTO clube (sigla, nome, localidade)
VALUES ('FCP','Futebol Clube do Porto','Porto');
INSERT INTO clube (sigla, nome, localidade)
VALUES ('SCP','Sporting Clube de Portugal','Lisboa');
INSERT INTO clube (sigla, nome, localidade)
VALUES ('CDF','Clube Desportivo Feirense','Santa Maria da Feira');
--
-- Inserts jogos
-- Jornada 1
-- Jogo 1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SLB','SCP','1','1');
-- Jogo 2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('FCP','CDF','1','1000');
-- Jornada 2
-- Jogo 1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('CDF','SLB','2','16000');
-- Jogo 2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SCP','FCP','2','56000');
-- Jornada 3
-- Jogo 1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('FCP','SLB','3','65000');
-- Jogo 2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SCP','CDF','3','12000');
--
-- Inserts jogadoras
-- SLB
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000001,'Claudia Costa', 1999, 'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000002,'Joana Reis', 2001, 'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000003,'Rita Rodrigues', 1997, 'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000004,'Joana Reis', 2000, 'SLB');
-- FCP
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000005,'Carla Afonso', 1998, 'FCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000006,'Ana Paiva', 1997, 'FCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000007,'Rita F�', 1996, 'FCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000008,'Maria Almeida', 2000, 'FCP');
-- SCP
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000009,'Sophia Janeiro', 2001, 'SCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000010,'Alice Felix', '2001', 'SCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000011,'Maria Eduarda', 1996, 'SCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000012,'Beatriz Costa', 2000, 'SCP');
-- CDF
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000013,'Mariana Nunes', 1999, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000014,'Helo�sa Leite', 1999, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000015,'Marina Mota F�', 1996, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000016,'Cecilia Artur', 2000, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube) --jogadora com nome costa mas que nao vai marcar golos
VALUES (200000017,'Fraca Costa', 2000, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000018,'Segundo Costa', 2000, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000019,'Beatriz Banco', 1999, 'CDF');
--
-- Inserts participa
-- Jogadoras benfica no jogo1 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'SLB', 'SCP', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'SLB', 'SCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'SLB', 'SCP', 0);
-- Jogadoras sporting no jogo1 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000009, 'SLB', 'SCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000010, 'SLB', 'SCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'SLB', 'SCP', 0);
-- Jogadoras porto no jogo2 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'FCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'FCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000008, 'FCP', 'CDF', 2);
-- Jogadoras feirense no jogo2 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000013, 'FCP', 'CDF', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000014, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000015, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000016, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos) --jogadora com nome costa e que nao marca golos
VALUES (200000017, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos) --jogadora que nnc jogou em casa e jogou fora <5 x
VALUES (200000018, 'FCP', 'CDF', 0);
--
-- Jogadoras feirense no jogo 1 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos) --50000 ESPETADORES e jogou em casa
VALUES (200000013, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) --50000 ESPETADORES e jogou em casa
VALUES (200000014, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000015, 'CDF', 'SLB', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000018, 'CDF', 'SLB', 0);
-- Jogadoras benfica no jogo 1 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000004, 'CDF', 'SLB', 2);
-- Jogadoras sporting no jogo 2 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000009, 'SCP', 'FCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000010, 'SCP', 'FCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'SCP', 'FCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000012, 'SCP', 'FCP', 0);
-- Jogadoras porto no jogo 2 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'SCP', 'FCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'SCP', 'FCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'SCP', 'FCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000008, 'SCP', 'FCP', 2);
--
-- Jogadoras porto no jogo 1 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'FCP', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'FCP', 'SLB', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'FCP', 'SLB', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000008, 'FCP', 'SLB', 0);
-- Jogadoras benfica no jogo 1 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'FCP', 'SLB', 3);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'FCP', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'FCP', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000004, 'FCP', 'SLB', 2);
-- Jogadoras sporting no jogo 2 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000009, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000010, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'SCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000012, 'SCP', 'CDF', 0);
-- Jogadoras feirense no jogo 2 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000013, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000014, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000015, 'SCP', 'CDF', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000018, 'SCP', 'CDF', 3);
--
COMMIT;