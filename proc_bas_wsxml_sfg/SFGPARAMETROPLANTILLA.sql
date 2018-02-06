USE SFGPRODU;
--  DDL for Package Body SFGPARAMETROPLANTILLA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPARAMETROPLANTILLA */ 

  -- Returns a specific record from the PARAMETRO table.
  IF OBJECT_ID('WSXML_SFG.SFGPARAMETROPLANTILLA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPARAMETROPLANTILLA_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPARAMETROPLANTILLA_GetRecord(@pk_ID_PARAMETRO NUMERIC(22,0)
                                   ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PARAMETRO
     WHERE ID_PARAMETRO = @pk_ID_PARAMETRO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
		
      SELECT ID_PARAMETROPLANTILLA,
             NOMPARAMETROPLANTILLA,
             DESCRIPCION,
             VALOR,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             CAMPO
      FROM WSXML_SFG.PARAMETROPLANTILLA
      WHERE ID_PARAMETROPLANTILLA = @pk_ID_PARAMETRO;
	;	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPARAMETROPLANTILLA_GetRecordByKey', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPARAMETROPLANTILLA_GetRecordByKey;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPARAMETROPLANTILLA_GetRecordByKey(@p_NOMPARAMETRO NVARCHAR(2000)
                                       ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PARAMETROPLANTILLA
     WHERE NOMPARAMETROPLANTILLA = @p_NOMPARAMETRO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
			
      SELECT ID_PARAMETROPLANTILLA,
             NOMPARAMETROPLANTILLA,
             DESCRIPCION,
             VALOR,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             CAMPO
      FROM WSXML_SFG.PARAMETROPLANTILLA
      WHERE NOMPARAMETROPLANTILLA = @p_NOMPARAMETRO;
	;	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPARAMETROPLANTILLA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPARAMETROPLANTILLA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPARAMETROPLANTILLA_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
				
      SELECT ID_PARAMETROPLANTILLA,
             NOMPARAMETROPLANTILLA,
             DESCRIPCION,
             VALOR,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             CAMPO
      FROM WSXML_SFG.PARAMETROPLANTILLA
      WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	;	
  END;
GO






