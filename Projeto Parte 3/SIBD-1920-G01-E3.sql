-- ----------------------------------------------------------------------------
DROP TABLE participa;
DROP TABLE jogadora;
DROP TABLE jogo;
DROP TABLE clube;
-- ----------------------------------------------------------------------------
CREATE TABLE clube (
	sigla VARCHAR(3), -- Para simplificar a referenciação de um clube.
	nome VARCHAR(80) CONSTRAINT nn_clube_nome NOT NULL,
	localidade VARCHAR(80) CONSTRAINT nn_clube_distrito NOT NULL,
--
 CONSTRAINT pk_clube
 PRIMARY KEY (sigla),
--
 CONSTRAINT un_clube_nome -- Nome é chave candidata.
 UNIQUE (nome)
);
-- ----------------------------------------------------------------------------
CREATE TABLE jogo (
	casa VARCHAR(3), -- Clube que joga em casa.
	visitante VARCHAR(3), -- Clube visitante.
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
	nome VARCHAR(80) CONSTRAINT nn_jogadora_nome NOT NULL,
	nascimento NUMBER(4) CONSTRAINT nn_jogadora_nascimento NOT NULL,
	clube VARCHAR(3) CONSTRAINT nn_jogadora_clube NOT NULL,
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
	jogadora NUMBER(9),
	casa VARCHAR(3), -- Clube da casa no jogo em que a jogadora participa.
	visitante VARCHAR(3), -- Clube visitante no mesmo jogo.
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
INSERT INTO clube (sigla, nome, localidadde) VALUES ('SLB', 'BENFICA', 'LISBOA');
INSERT INTO clube (sigla, nome, localidadde) VALUES ('SCP', 'SPORTING', 'ALVALADE');

INSERT INTO JOGO (casa, visitante, jornada, espetadores)
VALUES ('SLB', 'SCP', 1, 123);  
INSERT INTO JOGO (nome_clube_casa, nome_clube_visitante, num_jornada, espetadores)
VALUES ('SCP', 'SLB', 1, 124);    

INSERT INTO jogadora (nif, nome, nascimento, clube) 
VALUES (100000001, 'JOANA Costa', 2000,'SLB');
INSERT INTO jogadora (nif, nome, nascimento, clube) 
VALUES (100000002, 'INES', 2001,'SCP');

INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (100000001, 'SLB', 'SCP', 1);
INSERT INTO participa (jogadora, casa, visitante, golos)
VALUES (100000002, 'SCP', 'SLB', 2);
--
SELECT J.nif, J.nome, J.nascimento
FROM jogadora J
WHERE nome LIKE '%Costa'