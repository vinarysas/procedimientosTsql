USE SFGPRODU;
--  DDL for Package Body SFGTIPOESTACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOESTACION */ 

  IF OBJECT_ID('WSXML_SFG.SFGTIPOESTACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOESTACION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOESTACION_AddRecord(@p_NOMTIPOESTACION        NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TIPOESTACION_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPOESTACION (
                              NOMTIPOESTACION,
                              CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMTIPOESTACION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPOESTACION_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOESTACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOESTACION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOESTACION_UpdateRecord(@pk_ID_TIPOESTACION       NUMERIC(22,0),
                         @p_NOMTIPOESTACION        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.TIPOESTACION
       SET NOMTIPOESTACION        = @p_NOMTIPOESTACION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TIPOESTACION = @pk_ID_TIPOESTACION;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGTIPOESTACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOESTACION_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOESTACION_GetRecord(@pk_ID_TIPOESTACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.TIPOESTACION WHERE ID_TIPOESTACION = @pk_ID_TIPOESTACION;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_TIPOESTACION,
             NOMTIPOESTACION,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.TIPOESTACION
      WHERE ID_TIPOESTACION = @pk_ID_TIPOESTACION;
  END;
GO 



IF OBJECT_ID('WSXML_SFG.SFGTIPOESTACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOESTACION_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOESTACION_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_TIPOESTACION,
             NOMTIPOESTACION,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.TIPOESTACION
      WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END
  END;
GO






