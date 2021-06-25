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
--jornada 1
--jogo 1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SLB','SCP','1','1');
--jogo 2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('FCP','CDF','1','1000');
--jornada 2
--jogo 1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('CDF','SLB','2','16000');
--jogo 2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SCP','FCP','2','56000');
--jornada 3
--jogo 1
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('FCP','SLB','3','65000');
--jogo 2
INSERT INTO jogo (casa, visitante, jornada, espetadores)
VALUES ('SCP','CDF','3','12000');
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
VALUES (200000013,'Mariana Nunes', 1999, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000014,'Heloísa Leite', 1999, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000015,'Marina Mota Fé', 1996, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000016,'Cecilia Artur', 2000, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube) --jogadora com nome costa mas que nao vai marcar golos
VALUES (200000017,'Fraca Costa', 2000, 'CDF');
INSERT INTO jogadora (nif, nome, nascimento, clube)
VALUES (200000018,'Segundo Costa', 2000, 'CDF');
--
--inserts participa
--jogadoras benfica no jogo1 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'SLB', 'SCP', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'SLB', 'SCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'SLB', 'SCP', 0);
--jogadoras sporting no jogo1 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000009, 'SLB', 'SCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000010, 'SLB', 'SCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'SLB', 'SCP', 0);
--jogadoras porto no jogo2 da jornada 1
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'FCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'FCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'FCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000008, 'FCP', 'CDF', 2);
--jogadoras feirense no jogo2 da jornada 1
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

--jogadoras feirense no jogo 1 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos) --50000 ESPETADORES e jogou em casa
VALUES (200000013, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) --50000 ESPETADORES e jogou em casa
VALUES (200000014, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000015, 'CDF', 'SLB', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000018, 'CDF', 'SLB', 0);
--jogadoras benfica no jogo 1 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'CDF', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000004, 'CDF', 'SLB', 2);
--jogadoras sporting no jogo 2 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000009, 'SCP', 'FCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000010, 'SCP', 'FCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'SCP', 'FCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000012, 'SCP', 'FCP', 0);
--jogadoras porto no jogo 2 da jornada 2
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'SCP', 'FCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'SCP', 'FCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'SCP', 'FCP', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000008, 'SCP', 'FCP', 2);

--jogadoras porto no jogo 1 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000005, 'FCP', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000006, 'FCP', 'SLB', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000007, 'FCP', 'SLB', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000008, 'FCP', 'SLB', 0);
--jogadoras benfica no jogo 1 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000001, 'FCP', 'SLB', 3);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000002, 'FCP', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000003, 'FCP', 'SLB', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000004, 'FCP', 'SLB', 2);
--jogadoras sporting no jogo 2 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000009, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) 
VALUES (200000010, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000011, 'SCP', 'CDF', 0);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000012, 'SCP', 'CDF', 0);
--jogadoras feirense no jogo 2 da jornada 3
INSERT INTO participa (jogadora, casa, visitante, golos) --50000 ESPETADORES e jogou em casa
VALUES (200000013, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos) --50000 ESPETADORES e jogou em casa
VALUES (200000014, 'SCP', 'CDF', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000015, 'SCP', 'CDF', 2);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (200000018, 'SCP', 'CDF', 3);


/*
SELECT DISTINCT JOGOS.casa, J.nome, J.nif
FROM jogadora J, participa Pa, (SELECT Jg.casa, Jg.visitante, Jg.espetadores
                                FROM jogo Jg
                                WHERE Jg.espetadores > (SELECT AVG(Jg2.espetadores)
                                                        FROM jogo Jg2
                                                        )
                                ) JOGOS
WHERE J.nif = Pa.jogadora
AND Pa.casa = JOGOS.casa
AND Pa.visitante = JOGOS.visitante
AND J.nascimento < 2000
ORDER BY J.nome, J.nif;
*/




/*
SELECT Jg.jornada, Jg.casa, Jg.visitante
FROM jogo Jg
ORDER BY Jg.jornada;


SELECT DISTINCT Jg.jornada, Jg.casa, Jg.visitante
FROM jogo Jg, participa P, jogadora J, clube C
WHERE J.nif=P.jogadora
AND P.casa = Jg.casa
AND P.visitante = Jg.visitante
ORDER BY Jg.jornada;

AND GOLOS = (SELECT SUM(P.golos)
            FROM 
            )
            
            participa P, jogadora J, clube C
*/

/*
SELECT DISTINCT Jg.jornada, Jg.casa, Jg.visitante
FROM jogo Jg
ORDER BY Jg.jornada;
*/

/*
SELECT Jg.jornada, Jg.casa, Jg.visitante, P.golos, J.clube, J.nome
FROM jogo Jg, participa P, jogadora J
WHERE P.casa = Jg.casa
AND J.clube = P.casa
AND J.nif = P.jogadora
AND Jg.jornada = 1
GROUP BY Jg.jornada, Jg.casa, Jg.visitante, P.golos, J.clube, J.nome
ORDER BY Jg.jornada;
*/


--------------------------------------------------------

CREATE OR REPLACE VIEW GOLOS_CASA AS
SELECT DISTINCT Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
FROM jogo Jg, participa P, jogadora J
--identificar o jogo
WHERE P.casa = Jg.casa
AND P.visitante = Jg.visitante
--apenas os golos das que jogam em casa
AND P.jogadora = J.nif
AND J.clube = Jg.casa
--
AND P.golos > 0
GROUP BY Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
ORDER BY Jg.jornada, Jg.casa;

-------------------------------------------------------------

CREATE OR REPLACE VIEW GOLOS_VISITANTE AS
SELECT DISTINCT Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
FROM jogo Jg, participa P, jogadora J
--identificar o jogo
WHERE P.casa = Jg.casa
AND P.visitante = Jg.visitante
--apenas os golos das que jogam como visitante
AND P.jogadora = J.nif
AND J.clube = Jg.visitante
--
AND P.golos > 0
GROUP BY Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
ORDER BY Jg.jornada, Jg.casa;

-------------------------------------------------------------

SELECT Jg.jornada, Jg.casa, SUM(Gc.golos), Jg.visitante, SUM(Gv.golos)
FROM jogo Jg, GOLOS_CASA Gc, GOLOS_VISITANTE Gv
WHERE Jg.casa = Gc.casa
AND Jg.visitante = Gv.visitante
ORDER BY Jg.jornada;




/*
SELECT DISTINCT Jg.jornada, C.nome, MAX(SUM(P.golos))
FROM clube C, participa P, jogadora J, jogo Jg
WHERE ((C.sigla = P.casa) OR (C.sigla = P.visitante))
AND (Jg.casa = P.casa)
AND (Jg.visitante = P.visitante)
AND (P.jogadora = J.nif)
AND (J.clube <> C.sigla)
GROUP BY Jg.jornada ASC, C.nome ASC
HAVING (SUM(P.golos) = SELECT P.golos
                            FROM clube C, participa P, jogadora J, jogo Jg
                            WHERE ((C.sigla = P.casa) OR (C.sigla = P.visitante))
                            AND (Jg.casa = P.casa)
                            AND (Jg.visitante = P.visitante)
                            AND (P.jogadora = J.nif)
                            AND (J.clube <> C.sigla)    

        );
*/



--
--clube
-- sigla CHAR(3)
-- nome VARCHAR2(80)
-- localidade
--jogo
-- casa (sigla)
-- visitant (sigla)
-- jornada NUMBER(2)
-- espetadores NUMBER(5)
--jogadora
-- nif NUMBER(9)
-- nome VARCHAR2(80)
-- nascimento NUMBER(4)
-- clube (sigla)
--participa
-- jogadora (nif)
-- casa (sigla)
-- visitante (sigla)
-- golos NUMBER(2)
--

--uma solucao do cinco

SELECT Jg2.jornada, Jg2.casa, Gc.golos, Jg2.visitante, Gv.golos
--
FROM jogo Jg2, (SELECT DISTINCT Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
                FROM jogo Jg, participa P, jogadora J
              --identificar o jogo
                WHERE P.casa = Jg.casa
                AND P.visitante = Jg.visitante
                --apenas os golos das que jogam em casa
                AND P.jogadora = J.nif
                AND J.clube = Jg.casa
                --
                AND P.golos > 0
                GROUP BY Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
                ORDER BY Jg.jornada, Jg.casa) GC,
                (SELECT DISTINCT Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
                FROM jogo Jg, participa P, jogadora J
                --identificar o jogo
                WHERE P.casa = Jg.casa
                AND P.visitante = Jg.visitante
                --apenas os golos das que jogam como visitante
                AND P.jogadora = J.nif
                AND J.clube = Jg.visitante
                --
                AND P.golos > 0
                GROUP BY Jg.jornada, Jg.casa, Jg.visitante, P.jogadora, P.golos
                ORDER BY Jg.jornada, Jg.casa) GV
--
WHERE Jg2.casa = Gc.casa
AND Jg2.visitante = Gv.visitante
AND GC.golos = (SELECT SUM(GC.golos)
                FROM GC 
                WHERE GC.casa = Jg2.casa
                AND GC.jornada=Jg2.jornada)
AND GV.golos = (SELECT SUM(GC.golos)
                FROM GV
                WHERE GV.visitante = Jg2.visitante
                AND GV.jornada=Jg2.jornada);
--ORDER BY Jg2.jornada;