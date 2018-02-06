USE SFGPRODU;
--  DDL for Package Body SFGTOTAL_JUEGO_CATEG_L1LIAB01
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTOTAL_JUEGO_CATEG_L1LIAB01 */ 

  --Add Record in the table TOTAL_JUEGO_CATEG_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGTOTAL_JUEGO_CATEG_L1LIAB01_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTOTAL_JUEGO_CATEG_L1LIAB01_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTOTAL_JUEGO_CATEG_L1LIAB01_AddRecord(@p_CODCONTROL_L1LIAB01            NUMERIC(22,0),
					  @p_CODCATEGO_ACIERTO_L1LIAB01     NUMERIC(22,0),
					  @p_TOT_JUE_TOT_GANADO             NUMERIC(22,0),
					  @p_TOT_JUE_PAG_ANT                NUMERIC(22,0),
					  @p_TOT_JUE_PAG_HOY                NUMERIC(22,0),
					  @p_TOT_JUE_PURG_EXPIR             NUMERIC(22,0),
					  @p_TOT_JUE_PEND                   NUMERIC(22,0),
					  @p_TOT_JUE_RETEFUENTE             NUMERIC(22,0),
					  @p_TOT_JUE_IMP_IND_X_PREM         NUMERIC(22,0),
					  @p_FECHAHORAMODIFICACION          DATETIME,
					  @p_CODUSUARIOMODIFICACION         NUMERIC(22,0),
					  @p_ACTIVE                         NUMERIC(22,0),
					  @p_ID_TOT_JUE_CAT_L1LIAB01_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TOTAL_JUEGO_CATEG_L1LIAB01 (
											CODCONTROL_L1LIAB01,
											CODCATEGORIA_ACIERTOS_L1LIAB01,
											TOT_JUE_TOT_GANADO,
											TOT_JUE_PAG_ANT,
											TOT_JUE_PAG_HOY,
											TOT_JUE_PURG_EXPIR,
											TOT_JUE_PEND,
											TOT_JUE_RETEFUENTE,
											TOT_JUE_IMP_IND_X_PREM,
											FECHAHORAMODIFICACION,
											CODUSUARIOMODIFICACION,
											ACTIVE)
    VALUES (
			@p_CODCONTROL_L1LIAB01,
			@p_CODCATEGO_ACIERTO_L1LIAB01,
			@p_TOT_JUE_TOT_GANADO,
			@p_TOT_JUE_PAG_ANT,
			@p_TOT_JUE_PAG_HOY,
			@p_TOT_JUE_PURG_EXPIR,
			@p_TOT_JUE_PEND,
			@p_TOT_JUE_RETEFUENTE,
			@p_TOT_JUE_IMP_IND_X_PREM,
			@p_FECHAHORAMODIFICACION,
			@p_CODUSUARIOMODIFICACION,
			@p_ACTIVE);
    SET @p_ID_TOT_JUE_CAT_L1LIAB01_out = SCOPE_IDENTITY();
  END;
GO






