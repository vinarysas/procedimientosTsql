USE SFGPRODU;
--  DDL for Package Body SFGDETALLE_L1LIAB01
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLE_L1LIAB01 */ 

  --Add Record in the table DETALLE_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGDETALLE_L1LIAB01_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLE_L1LIAB01_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLE_L1LIAB01_AddRecord(@p_CODSORTEO_L1LIAB01_PRODUCTO    NUMERIC(22,0),
					  @p_CODCATEGO_ACIERTOS_L1LIAB01    NUMERIC(22,0),
					  @p_TOT_GANADO                     NUMERIC(22,0),
					  @p_PAG_ANT                        NUMERIC(22,0),
					  @p_PAG_HOY                        NUMERIC(22,0),
					  @p_PURG_EXPIR                     NUMERIC(22,0),
					  @p_PEND                           NUMERIC(22,0),
					  @p_RETEFUENTE                     NUMERIC(22,0),
					  @p_IMP_IND_X_PREM                 NUMERIC(22,0),
					  @p_FECHAHORAMODIFICACION          DATETIME,
					  @p_CODUSUARIOMODIFICACION         NUMERIC(22,0),
					  @p_ACTIVE                         NUMERIC(22,0),
					  @p_ID_DETALLE_L1LIAB01_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DETALLE_L1LIAB01 (
								  CODSORTEO_L1LIAB01_PRODUCTO,
								  CODCATEGORIA_ACIERTOS_L1LIAB01,
								  TOT_GANADO,
								  PAG_ANT,
								  PAG_HOY,
								  PURG_EXPIR,
								  PEND,
								  RETEFUENTE,
								  IMP_IND_X_PREM,
								  FECHAHORAMODIFICACION,
								  CODUSUARIOMODIFICACION,
								  ACTIVE)
    VALUES (
			@p_CODSORTEO_L1LIAB01_PRODUCTO,
			@p_CODCATEGO_ACIERTOS_L1LIAB01,
			@p_TOT_GANADO,
			@p_PAG_ANT,
			@p_PAG_HOY,
			@p_PURG_EXPIR,
			@p_PEND,
			@p_RETEFUENTE,
			@p_IMP_IND_X_PREM,
			@p_FECHAHORAMODIFICACION,
			@p_CODUSUARIOMODIFICACION,
			@p_ACTIVE);
    SET @p_ID_DETALLE_L1LIAB01_out = SCOPE_IDENTITY();
  END;
GO






