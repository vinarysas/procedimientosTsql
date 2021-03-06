USE SFGPRODU;
--  DDL for Package Body SFGSORTEO_L1LIAB01_PRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGSORTEO_L1LIAB01_PRODUCTO */ 

  --Add Record in the table SORTEO_L1LIAB01_PRODUCTO
  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_L1LIAB01_PRODUCTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSORTEO_L1LIAB01_PRODUCTO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSORTEO_L1LIAB01_PRODUCTO_AddRecord(@p_CODSORTEO_L1LIAB01          NUMERIC(22,0),
					  @p_NOMPRODUCTO                 VARCHAR,
					  @p_TOT_SORT_TOT_GANADO         NUMERIC(22,0),
					  @p_TOT_SORT_PAG_ANT            NUMERIC(22,0),
					  @p_TOT_SORT_PAG_HOY            NUMERIC(22,0),
					  @p_TOT_SORT_PURG_EXPIR         NUMERIC(22,0),
					  @p_TOT_SORT_PEND               NUMERIC(22,0),
					  @p_TOT_SORT_RETEFUENTE         NUMERIC(22,0),
					  @p_TOT_SORT_IMP_IND_X_PREM     NUMERIC(22,0),
					  @p_FONDO_RESERVA_SORT          NUMERIC(22,0),
					  @p_FECHAHORAMODIFICACION       DATETIME,
					  @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
					  @p_ACTIVE                      NUMERIC(22,0),
					  @p_ID_SORTEO_L1LIAB01_PROD_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @p_CODPRODUCTO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @p_CODPRODUCTO = ID_PRODUCTO FROM WSXML_SFG.PRODUCTO WHERE NOMPRODUCTO = @p_NOMPRODUCTO;

    INSERT INTO WSXML_SFG.SORTEO_L1LIAB01_PRODUCTO (
										  CODSORTEO_L1LIAB01,
										  CODPRODUCTO,
										  TOT_SORT_TOT_GANADO,
										  TOT_SORT_PAG_ANT,
										  TOT_SORT_PAG_HOY,
										  TOT_SORT_PURG_EXPIR,
										  TOT_SORT_PEND,
										  TOT_SORT_RETEFUENTE,
										  TOT_SORT_IMP_IND_X_PREM,
										  FONDO_RESERVA_SORT,
										  FECHAHORAMODIFICACION,
										  CODUSUARIOMODIFICACION,
										  ACTIVE)
    VALUES (
			@p_CODSORTEO_L1LIAB01,
			@p_CODPRODUCTO,
			@p_TOT_SORT_TOT_GANADO,
			@p_TOT_SORT_PAG_ANT,
			@p_TOT_SORT_PAG_HOY,
			@p_TOT_SORT_PURG_EXPIR,
			@p_TOT_SORT_PEND,
			@p_TOT_SORT_RETEFUENTE,
			@p_TOT_SORT_IMP_IND_X_PREM,
			@p_FONDO_RESERVA_SORT,
			@p_FECHAHORAMODIFICACION,
			@p_CODUSUARIOMODIFICACION,
			@p_ACTIVE);
    SET @p_ID_SORTEO_L1LIAB01_PROD_out = SCOPE_IDENTITY();
  END;
GO






