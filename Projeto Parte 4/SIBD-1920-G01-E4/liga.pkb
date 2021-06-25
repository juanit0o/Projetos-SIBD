-- ----------------------------------------------------------------------------
-- SIBD 2019/2020 - Etapa 4 do projeto
-- Numero do grupo: 01
-- Diogo Pinto, n.52763, t.14
-- Francisco Ramalho, n.53472, t.12
-- Joao Funenga, n.53504, t.12
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY liga IS

  PROCEDURE regista_clube (
    sigla_in       IN clube.sigla%TYPE,
    nome_in        IN clube.nome%TYPE,
    localidade_in  IN clube.localidade%TYPE)
  IS
  BEGIN
    INSERT INTO clube (sigla, nome, localidade)
		VALUES (sigla_in, nome_in, localidade_in);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN 
      RAISE_APPLICATION_ERROR(-20001, 'Clube com sigla/nome igual ja existe.');
  END regista_clube; 
-- ----------------------------------------------------------------------------
  PROCEDURE regista_jogadora (
    nif_in         IN jogadora.nif%TYPE,
    nome_in        IN jogadora.nome%TYPE,
	  nascimento_in  IN jogadora.nascimento%TYPE,
	  clube_in       IN jogadora.clube%TYPE)
  IS
    total_jogadoras_clube NUMBER;
  BEGIN
  -- total jogadoras do clube
    SELECT COUNT(*) INTO total_jogadoras_clube
    FROM jogadora J
    WHERE J.clube = clube_in; 
  -- cada clube admite um maximo de 22 jogadoras
  IF (total_jogadoras_clube >= 22) THEN
    RAISE_APPLICATION_ERROR(-20002, 'Clube sem vagas.');
  ELSIF (nascimento_in < 1970 OR nascimento_in > 2010) THEN
    RAISE_APPLICATION_ERROR(-20003, 'Jogadora tem de nascer entre 1970 e 2010');
	ELSE
		INSERT INTO jogadora (nif, nome, nascimento, clube)
			VALUES (nif_in, nome_in, nascimento_in, clube_in);
  END IF;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  RAISE_APPLICATION_ERROR (-20004, 'Essa jogadora ja existe.');
  END regista_jogadora;
-- ----------------------------------------------------------------------------
  PROCEDURE regista_jogo (     
    casa_in         IN jogo.casa%TYPE,
	  visitante_in    IN jogo.visitante%TYPE,
	  jornada_in      IN jogo.jornada%TYPE,
	  espetadores_in  IN jogo.espetadores%TYPE)
  IS
    numero_jogos_ja_jogados NUMBER;
  BEGIN
	  SELECT COUNT(*) INTO numero_jogos_ja_jogados
		FROM jogo J
		WHERE J.jornada = jornada_in
    AND (J.casa = casa_in 
		    OR J.casa = visitante_in
		    OR J.visitante = casa_in 
		    OR J.visitante = visitante_in);	   
    IF (casa_in = visitante_in) THEN                                                               
      RAISE_APPLICATION_ERROR(-20005, 'Clube da casa tem de ser diferente do visitante');
    ELSIF (numero_jogos_ja_jogados > 0) THEN
		  RAISE_APPLICATION_ERROR(-20006, 'Pelo menos um dos clubes ja jogou nesta jornada.');
    ELSIF (jornada_in NOT BETWEEN 1 AND 30) THEN
		  RAISE_APPLICATION_ERROR(-20006, 'Jornada invalida.');
    ELSIF (espetadores_in NOT BETWEEN 0 AND 65000) THEN
		  RAISE_APPLICATION_ERROR(-20006, 'Numero de espetadores invalido.');
		ELSE
		  INSERT INTO jogo (casa, visitante, jornada, espetadores)
		  VALUES (casa_in, visitante_in, jornada_in, espetadores_in);
		END IF;
   END regista_jogo;
-- ----------------------------------------------------------------------------
  PROCEDURE regista_participacao (                              
    jogadora_in     IN participa.jogadora%TYPE,                 
	  jornada_in      IN jogo.jornada%TYPE,
	  golos_in        IN participa.golos%TYPE)
  IS
    jogo_casa jogo.casa%TYPE;
    jogo_visitante jogo.visitante%TYPE;
  BEGIN
    SELECT J.casa INTO jogo_casa
    FROM jogo J, jogadora Jg
    WHERE jornada_in = J.jornada
    AND (J.casa = Jg.clube OR J.visitante = Jg.clube)
    AND Jg.nif = jogadora_in;
    --      
    SELECT J.visitante INTO jogo_visitante
    FROM jogo J, jogadora Jg
    WHERE jornada_in = J.jornada
    AND (J.casa = Jg.clube OR J.visitante = Jg.clube)
    AND Jg.nif = jogadora_in;
    --
    INSERT INTO participa (jogadora, casa, visitante, golos)
    VALUES (jogadora_in, jogo_casa, jogo_visitante, golos_in);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20005, 'Essa jogadora ja participa');
    WHEN OTHERS THEN
      BEGIN
        IF (SQLCODE = -2290) THEN
          RAISE_APPLICATION_ERROR(-20006, 'Os golos tem de ser iguais ou maiores que 0');
        ELSE
          RAISE_APPLICATION_ERROR(-20005, 'Jogo/Jornada nao existe.');
        END IF;
        RAISE;
      END;
  END regista_participacao;
-- ----------------------------------------------------------------------------
  PROCEDURE remove_participacao (
    jogadora_in     IN participa.jogadora%TYPE,
	  jornada_in      IN jogo.jornada%TYPE)
  IS
  BEGIN
    DELETE FROM participa P
    WHERE P.jogadora = jogadora_in 
    AND EXISTS (SELECT * 
                FROM jogo J
                WHERE P.casa = J.casa
                AND P.visitante = J.visitante
                AND J.jornada = jornada_in);  
    IF (SQL%ROWCOUNT = 0) THEN
      RAISE_APPLICATION_ERROR(-20007, 'Nao existe nada para remover.');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN RAISE;
  END remove_participacao;
-- ----------------------------------------------------------------------------
  PROCEDURE remove_jogo (                      
    casa_in         IN jogo.casa%TYPE,
	  visitante_in    IN jogo.visitante%TYPE)
  IS
    jogo_jornada NUMBER;
    CURSOR cursor_jogadora IS SELECT nif, clube FROM jogadora;
    TYPE tabela_local_jogadora IS TABLE OF cursor_jogadora%ROWTYPE;
    jogadora tabela_local_jogadora;
  BEGIN
    SELECT Jg.jornada INTO jogo_jornada
    FROM jogo Jg
    WHERE Jg.casa = casa_in
    AND Jg.visitante = visitante_in;
    --
    OPEN cursor_jogadora;
    FETCH cursor_jogadora BULK COLLECT INTO jogadora;
    CLOSE cursor_jogadora;
    --
    IF(jogadora.COUNT > 0) THEN
      FOR pos IN jogadora.FIRST .. jogadora.LAST loop
        remove_jogo_aux(casa_in, visitante_in, jogadora(pos).nif, jogadora(pos).clube, jogo_jornada);
      END LOOP;
    END IF;
    --
    DELETE FROM jogo WHERE (casa = casa_in AND visitante = visitante_in);
    --
  EXCEPTION
    WHEN OTHERS THEN 
      BEGIN
        IF(cursor_jogadora%ISOPEN) THEN
          CLOSE cursor_jogadora;
        END IF;
        RAISE;
      END;	
  END remove_jogo;

  PROCEDURE remove_jogo_aux (
    casa_in IN jogo.casa%TYPE,
    visitante_in IN jogo.visitante%TYPE,
    j_nif IN jogadora.nif%TYPE,
    j_clube IN jogadora.clube%TYPE,
    jornada_in IN jogo.jornada%TYPE )
  IS
    number_of_participa NUMBER;
  BEGIN
    SELECT COUNT(*) INTO number_of_participa
    FROM jogadora J, jogo Jg, participa P
    WHERE Jg.casa = casa_in
    AND Jg.visitante = visitante_in
    AND (Jg.casa = j_clube OR Jg.visitante = j_clube)
    AND Jg.jornada = jornada_in
    AND P.jogadora = j_nif
    AND P.casa = casa_in
    AND P.visitante = visitante_in;
    --
    IF(number_of_participa > 0) THEN
      remove_participacao(j_nif, jornada_in);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN RAISE;
  END remove_jogo_aux;
-- ----------------------------------------------------------------------------
  PROCEDURE remove_jogadora (                  
    nif_in          IN jogadora.nif%TYPE)
  IS
    CURSOR cursor_participacao IS SELECT DISTINCT Jg.jornada 
                                   FROM jogo Jg, participa P, jogadora J
                                   WHERE J.nif = nif_in
                                   AND P.jogadora = J.nif
                                   AND (Jg.casa = J.clube OR Jg.visitante = J.clube)
                                   ORDER BY Jg.jornada;
    TYPE tabela_local_participacao IS TABLE OF cursor_participacao%ROWTYPE;
    participa tabela_local_participacao;
    --
  BEGIN
    OPEN cursor_participacao;
    FETCH cursor_participacao BULK COLLECT INTO participa;
    CLOSE cursor_participacao;
    --
    IF(participa.COUNT > 0) THEN
      FOR pos IN participa.FIRST .. participa.LAST LOOP
        remove_participacao(nif_in, participa(pos).jornada);
      END LOOP;
    END IF;
    --
    DELETE FROM jogadora WHERE (nif = nif_in);
    --
  EXCEPTION
    WHEN OTHERS THEN RAISE;
	END remove_jogadora;
-- ----------------------------------------------------------------------------
  PROCEDURE remove_clube (                   
    sigla_in 		IN clube.sigla%TYPE)
  IS
    CURSOR cursor_jogadora is SELECT J.nif
                              FROM jogadora J
                              WHERE J.clube = sigla_in;
    TYPE tabela_local_jogadora IS TABLE OF cursor_jogadora%ROWTYPE;
    jogadora tabela_local_jogadora;
    --
    CURSOR cursor_jogo is SELECT Jg.casa, Jg.visitante
                          FROM jogo Jg
                          WHERE (Jg.casa = sigla_in OR Jg.visitante = sigla_in);
    TYPE tabela_local_jogo IS TABLE OF cursor_jogo%ROWTYPE;
    jogo tabela_local_jogo;
    --
  BEGIN
    OPEN cursor_jogadora;
    FETCH cursor_jogadora BULK COLLECT INTO jogadora;
    CLOSE cursor_jogadora;
    --
    OPEN cursor_jogo;
    FETCH cursor_jogo BULK COLLECT INTO jogo;
    CLOSE cursor_jogo;
    --
    IF(jogadora.COUNT > 0) THEN
      FOR pos IN jogadora.FIRST .. jogadora.LAST LOOP
        remove_jogadora(jogadora(pos).nif);
      END LOOP;
    END IF;
    --
    IF(jogo.COUNT > 0) THEN
      FOR pos IN jogo.FIRST .. jogo.LAST LOOP
        remove_jogo(jogo(pos).casa, jogo(pos).visitante);
      END LOOP;
    END IF;
      --
    DELETE FROM clube WHERE (sigla = sigla_in);
    --
  EXCEPTION
    WHEN OTHERS THEN RAISE;
  END remove_clube;
-- ----------------------------------------------------------------------------
  FUNCTION lista_participacoes_jogos (        
    nif_in          IN jogadora.nif%TYPE)
    RETURN SYS_REFCURSOR
  IS
    cursor_participacoes SYS_REFCURSOR;
  BEGIN
    OPEN cursor_participacoes FOR
      SELECT *
        FROM (SELECT J.nif, J.nome, C1.nome AS CASA, C2.nome AS VISITANTE, P.golos
              FROM jogadora J, clube C1, clube C2, participa P
              WHERE J.nif = P.jogadora
			  AND J.nif = nif_in
              AND (J.clube = P.casa OR J.clube = P.visitante)
              AND C1.sigla = P.casa AND C2.sigla = P.visitante);
    RETURN cursor_participacoes;
  --
  EXCEPTION
    WHEN OTHERS THEN RAISE;
  END lista_participacoes_jogos;
END liga;
/