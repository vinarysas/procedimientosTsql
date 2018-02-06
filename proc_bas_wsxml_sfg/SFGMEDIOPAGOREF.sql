USE SFGPRODU;
--  DDL for Package Body SFGMEDIOPAGOREF
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGMEDIOPAGOREF */ 

IF OBJECT_ID('WSXML_SFG.SFGMEDIOPAGOREF_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_AddRecord;
GO


CREATE     PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_AddRecord(@p_NUMEROREFERENCIA       NVARCHAR(2000),
                      @p_CODDETALLEPAGO         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_MEDIOPAGOREF_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.MEDIOPAGOREF (
                                NUMEROREFERENCIA,
                                CODDETALLEPAGO,
                                CODUSUARIOMODIFICACION)
    VALUES (
            @p_NUMEROREFERENCIA,
            @p_CODDETALLEPAGO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_MEDIOPAGOREF_out = SCOPE_IDENTITY();

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGMEDIOPAGOREF_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_UpdateRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_UpdateRecord(@pk_ID_MEDIOPAGOREF       NUMERIC(22,0),
                         @p_NUMEROREFERENCIA       NVARCHAR(2000),
                         @p_CODDETALLEPAGO         NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.MEDIOPAGOREF
       SET NUMEROREFERENCIA       = @p_NUMEROREFERENCIA,
           CODDETALLEPAGO         = @p_CODDETALLEPAGO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
    WHERE ID_MEDIOPAGOREF = @pk_ID_MEDIOPAGOREF;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGMEDIOPAGOREF_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_GetRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_GetRecord(@pk_ID_MEDIOPAGOREF NUMERIC(22,0)
                                                       ) AS
 BEGIN
    DECLARE @l_count NUMERIC(22,0);
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*)
    FROM WSXML_SFG.MEDIOPAGOREF
    WHERE ID_MEDIOPAGOREF = @pk_ID_MEDIOPAGOREF;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be returned along the row data to support concurrency.
     
      SELECT ID_MEDIOPAGOREF,
             NUMEROREFERENCIA,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.MEDIOPAGOREF
      WHERE ID_MEDIOPAGOREF = @pk_ID_MEDIOPAGOREF;
	  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGMEDIOPAGOREF_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_GetList;
GO
  CREATE PROCEDURE WSXML_SFG.SFGMEDIOPAGOREF_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_MEDIOPAGOREF,
             NUMEROREFERENCIA,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.MEDIOPAGOREF
      WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	  
  END;
GO






