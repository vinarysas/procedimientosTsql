USE SFGPRODU;
--  DDL for Package Body SFGESTADOPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGESTADOPDV */ 

IF OBJECT_ID('WSXML_SFG.SFGESTADOPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOPDV_AddRecord(@p_NOMESTADOPDV           NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_ESTADOPDV_out       NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ESTADOPDV (
                             NOMESTADOPDV,
                             CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMESTADOPDV,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ESTADOPDV_out = SCOPE_IDENTITY();

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGESTADOPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOPDV_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGESTADOPDV_UpdateRecord(@pk_ID_ESTADOPDV       NUMERIC(22,0),
                         @p_NOMESTADOPDV        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ESTADOPDV
       SET NOMESTADOPDV        = @p_NOMESTADOPDV,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ESTADOPDV = @pk_ID_ESTADOPDV;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
	
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGESTADOPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOPDV_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGESTADOPDV_GetRecord(@pk_ID_ESTADOPDV NUMERIC(22,0)
                                                  ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ESTADOPDV WHERE ID_ESTADOPDV = @pk_ID_ESTADOPDV;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_ESTADOPDV,
             NOMESTADOPDV,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.ESTADOPDV
      WHERE ID_ESTADOPDV = @pk_ID_ESTADOPDV;
	  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGESTADOPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOPDV_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGESTADOPDV_GetList(@p_ACTIVE NUMERIC(22,0)
                                                ) AS
  BEGIN
  SET NOCOUNT ON;
     
      SELECT ID_ESTADOPDV,
             NOMESTADOPDV,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.ESTADOPDV
      WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
	  
  END;
GO






