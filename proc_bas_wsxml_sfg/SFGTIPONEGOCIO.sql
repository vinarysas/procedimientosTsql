USE SFGPRODU;
--  DDL for Package Body SFGTIPONEGOCIO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPONEGOCIO */ 

IF OBJECT_ID('WSXML_SFG.SFGTIPONEGOCIO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_AddRecord(@p_NOMTIPONEGOCIO         NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TIPONEGOCIO_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPONEGOCIO (
                             NOMTIPONEGOCIO,
                             CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMTIPONEGOCIO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPONEGOCIO_out = SCOPE_IDENTITY();

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGTIPONEGOCIO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_UpdateRecord(@pk_ID_TIPONEGOCIO       NUMERIC(22,0),
                         @p_NOMTIPONEGOCIO        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.TIPONEGOCIO
       SET NOMTIPONEGOCIO        = @p_NOMTIPONEGOCIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TIPONEGOCIO = @pk_ID_TIPONEGOCIO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGTIPONEGOCIO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_GetRecord(@pk_ID_TIPONEGOCIO NUMERIC(22,0)
                                                    ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.TIPONEGOCIO WHERE ID_TIPONEGOCIO = @pk_ID_TIPONEGOCIO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_TIPONEGOCIO,
             NOMTIPONEGOCIO,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.TIPONEGOCIO
      WHERE ID_TIPONEGOCIO = @pk_ID_TIPONEGOCIO;
	  
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGTIPONEGOCIO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_GetList;
GO


  CREATE PROCEDURE WSXML_SFG.SFGTIPONEGOCIO_GetList(@p_ACTIVE NUMERIC(22,0)
                                                    ) AS
  BEGIN
  SET NOCOUNT ON;
   
      SELECT ID_TIPONEGOCIO,
             NOMTIPONEGOCIO,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.TIPONEGOCIO
      WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
	  
  END;
GO






