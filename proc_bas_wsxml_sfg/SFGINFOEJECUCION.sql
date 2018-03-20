USE SFGPRODU;
--  DDL for Package Body SFGINFOEJECUCION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINFOEJECUCION */ 

  IF OBJECT_ID('WSXML_SFG.SFGINFOEJECUCION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOEJECUCION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOEJECUCION_AddRecord(@p_NOMEJECUCION           NVARCHAR(2000),
                      @p_ENSAMBLADO             NVARCHAR(2000),
                      @p_CLASE                  NVARCHAR(2000),
                      @p_METODO                 NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_INFOEJECUCION_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.INFOEJECUCION (
                               NOMEJECUCION,
                               ENSAMBLADO,
                               CLASE,
                               METODO,
                               CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMEJECUCION,
            @p_ENSAMBLADO,
            @p_CLASE,
            @p_METODO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_INFOEJECUCION_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOEJECUCION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOEJECUCION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOEJECUCION_UpdateRecord(@pk_ID_INFOEJECUCION      NUMERIC(22,0),
                         @p_NOMEJECUCION           NVARCHAR(2000),
                         @p_ENSAMBLADO             NVARCHAR(2000),
                         @p_CLASE                  NVARCHAR(2000),
                         @p_METODO                 NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.INFOEJECUCION
       SET NOMEJECUCION           = @p_NOMEJECUCION,
           ENSAMBLADO             = @p_ENSAMBLADO,
           CLASE                  = @p_CLASE,
           METODO                 = @p_METODO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_INFOEJECUCION = @pk_ID_INFOEJECUCION;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOEJECUCION_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOEJECUCION_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOEJECUCION_DeactivateRecord(@pk_ID_INFOEJECUCION NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.INFOEJECUCION
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_INFOEJECUCION = @pk_ID_INFOEJECUCION;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOEJECUCION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOEJECUCION_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINFOEJECUCION_GetRecord(@pk_ID_INFOEJECUCION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.INFOEJECUCION WHERE ID_INFOEJECUCION = @pk_ID_INFOEJECUCION;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_INFOEJECUCION,
             NOMEJECUCION,
             ENSAMBLADO,
             CLASE,
             METODO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.INFOEJECUCION
      WHERE ID_INFOEJECUCION = @pk_ID_INFOEJECUCION;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOEJECUCION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOEJECUCION_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINFOEJECUCION_GetList AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_INFOEJECUCION,
             NOMEJECUCION,
             ENSAMBLADO,
             CLASE,
             METODO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.INFOEJECUCION
      ORDER BY NOMEJECUCION;
		  
  END;
GO






