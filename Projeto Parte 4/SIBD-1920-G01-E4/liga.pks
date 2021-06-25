-- ----------------------------------------------------------------------------
-- SIBD 2019/2020 - Etapa 4 do projeto
-- Numero do grupo: 01
-- Diogo Pinto, n.52763, t.14
-- Francisco Ramalho, n.53472, t.12
-- Joao Funenga, n.53504, t.12
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE liga IS

  PROCEDURE regista_clube (
    sigla_in       IN clube.sigla%TYPE,
    nome_in        IN clube.nome%TYPE,
    localidade_in  IN clube.localidade%TYPE);
  
  PROCEDURE regista_jogadora (
    nif_in         IN jogadora.nif%TYPE,
    nome_in        IN jogadora.nome%TYPE,
	  nascimento_in  IN jogadora.nascimento%TYPE,
	  clube_in       IN jogadora.clube%TYPE);

  PROCEDURE regista_jogo (
    casa_in         IN jogo.casa%TYPE,
	  visitante_in    IN jogo.visitante%TYPE,
	  jornada_in      IN jogo.jornada%TYPE,
	  espetadores_in  IN jogo.espetadores%TYPE);
 
  PROCEDURE regista_participacao (
    jogadora_in     IN participa.jogadora%TYPE,
	  jornada_in      IN jogo.jornada%TYPE,
    golos_in        IN participa.golos%TYPE);
	
  PROCEDURE remove_participacao (
    jogadora_in     IN participa.jogadora%TYPE,
	  jornada_in      IN jogo.jornada%TYPE);

  PROCEDURE remove_jogo (
    casa_in         IN jogo.casa%TYPE,
	  visitante_in    IN jogo.visitante%TYPE);

  -- PROCEDURE AUXILIAR
  PROCEDURE remove_jogo_aux (
    casa_in IN jogo.casa%TYPE,
    visitante_in IN jogo.visitante%TYPE,
    j_nif IN jogadora.nif%TYPE,
    j_clube IN jogadora.clube%TYPE,
    jornada_in IN jogo.jornada%TYPE );
	
  PROCEDURE remove_jogadora (
    nif_in          IN jogadora.nif%TYPE);
	
  PROCEDURE remove_clube (
    sigla_in 		IN clube.sigla%TYPE);
	
  FUNCTION lista_participacoes_jogos (    
    nif_in          IN jogadora.nif%TYPE);
  RETURN SYS_REFCURSOR;
	
END liga;
/