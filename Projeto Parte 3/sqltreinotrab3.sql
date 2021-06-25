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
    sigla VARCHAR2(3), -- Para simplificar a referenciação de um clube.
    nome VARCHAR2(80) CONSTRAINT nn_clube_nome NOT NULL,
    localidade VARCHAR2(80) CONSTRAINT nn_clube_distrito NOT NULL,
--
    CONSTRAINT pk_clube
    PRIMARY KEY (sigla),
--
    CONSTRAINT un_clube_nome -- Nome é chave candidata.
    UNIQUE (nome)
);
-- ----------------------------------------------------------------------------
CREATE TABLE jogo (
    casa, -- Clube que joga em casa.
    visitante, -- Clube visitante.
    jornada NUMBER(2) CONSTRAINT nn_jogo_jornada NOT NULL,
    espetadores NUMBER(5), -- Pode ser NULL se não existirem dados.
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
    CONSTRAINT ck_jogo_espetadores -- Restrição é satisfeita mesmo
    CHECK (espetadores BETWEEN 0 AND 65000) -- que espetadores seja NULL.
);
-- ----------------------------------------------------------------------------
CREATE TABLE jogadora (
    nif NUMBER(9), -- Número de identificação fiscal.
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
    CHECK (nascimento BETWEEN 1970 AND 2010) -- Só o ano de nascimento.
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
    CHECK (golos >= 0) -- Só golos na outra baliza (sem autogolos).
);
-- ----------------------------------------------------------------------------
--inserts clubes
INSERT INTO clube (sigla, nome, localidade)
VALUES ('SLB','Sport Lisboa e Benfica','Lisboa');
INSERT INTO clube (sigla, nome, localidade)
VALUES ('FCP','Futebol Clube do Porto','Porto');
INSERT INTO clube (sigla, nome, localidade)
VALUES ('SCP','Sporting Clube de Portugal','Lisboa');
INSERT INTO clube (sigla, nome, localidade)
VALUES ('CDF','Clube Desportivo Feirense','Santa Maria da Feira');
--
--inserts jogos
--jogo1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SLB','SCP','1','52345');
--jogo2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('FCP','CDF','1','33345');
--
--inserts jogadoras
--SLB
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000001,'Claudia Costa', 1999, 'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000002,'Joana Reis', 2001, 'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000003,'Rita Rodrigues', 1997, 'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000004,'Joana Reis', 2000, 'SLB');
--FCP
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000005,'Carla Afonso', 1998, 'FCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000006,'Ana Paiva', 1997, 'FCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000007,'Rita Fé', 1996, 'FCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000008,'Maria Almeida', 2000, 'FCP');
--SCP
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000009,'Sophia Janeiro', 2001, 'SCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000010,'Alice Felix', '2001', 'SCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000011,'Maria Eduarda', 1996, 'SCP');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000012,'Beatriz Costa', 2000, 'SCP');
--CDF
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000013,'Mariana Nunes', 2003, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000014,'Heloísa Leite', 2001, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000015,'Marina Mota Fé', 1996, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000016,'Cecilia Artur', 2000, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)  --jogadora com nome costa mas que nao vai marcar golos
VALUES (200000017,'Fraca Costa', 2000, 'CDF');
--
--inserts participa
--jogadoras benfica no jogo1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'SLB', 'SCP', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'SLB', 'SCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'SLB', 'SCP', 0);
--jogadoras sporting no jogo1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'SLB', 'SCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'SLB', 'SCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'SLB', 'SCP', 0);
--jogadoras porto no jogo2
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000009, 'FCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000010, 'FCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000012, 'FCP', 'CDF', 2);
--jogadoras feirense no jogo2
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000013, 'FCP', 'CDF', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000014, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000015, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000016, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)    --jogadora com nome costa e que nao marca golos
VALUES (200000017, 'FCP', 'CDF', 0);
--
--
--SELECTS
--1
--SELECT C.nome, 2019-J.nascimento AS idade, J.nome, J.nif   
--FROM jogadora J, clube C, participa P  							-- o j2 aqui vai ser usado onde?
--WHERE (J.nome LIKE '% Costa')
--AND (J.clube = C.sigla)             							--clube dela é o C, associar | mudei a primeira cena p (ele vai buscar a tabela jogadora a cluna Clube e nao sigla)
--AND (C.localidade LIKE 'Lisboa')    							--clube pertence a Lisboa
--AND (J.nif = P.jogadora)       									--no idea, ir buscar o nif da jogadora a tabela participa (posso fazer isto sequer?)
--AND (P.golos >= 1)                  							--usar quem tem mais do q 1 golo
--ORDER BY C.nome ASC, idade DESC, J.nome ASC, J.nif ASC;         --AS ORDENS DAS MERDAS ESTAO TODAS MAL WTF

--2
SELECT J.nif, J.nome, C.nome
FROM jogadora J, clube C, participa P
WHERE (J.clube = C.sigla)
AND (J.nif = P.jogadora)
AND (J.nif IN (SELECT P.jogadora, COUNT(*) 
			   FROM participa P, jogadora J
			   WHERE (J.clube <> P.casa)
               GROUP BY P.jogadora
              HAVING COUNT(*) <= 5))
ORDER BY C.nome, J.nif;
--

--3
--SELECT J.nif, J.nome
--FROM jogadora J
--WHERE (J.nascimento <= 2000)
--AND (J.nif IN (SELECT P.jogadora, Jg.espetadores
--			   FROM participa P, jogo Jg
--			   WHERE --marcar pelo menos 1 golo em todos os jogos
--			   AND Jg.espetadores > AVG ALL(SELECT SUM (espetadores)
--											FROM jogo))) 					--como ver se marcaram golos em tds os jogos? Acho q se usa uma palavrinha qq meia merdosa e n encontro
--ORDER BY J.nome, J.nif;

--4

--
 --clube
 --   sigla CHAR(3)
 --   nome VARCHAR2(80)
 --   localidade
 --jogo
 --   casa     (sigla)
 --   visitant (sigla)
 --   jornada NUMBER(2)
 --   espetadores NUMBER(5)
 --jogadora
 --   nif NUMBER(9)
 --   nome VARCHAR2(80)
 --   nascimento NUMBER(4)
 --   clube (sigla)
 --participa
 --   jogadora (nif)
 --   casa (sigla)
 --   visitante (sigla)
 --   golos NUMBER(2)
--

