USE SFGPRODU;
--  DDL for Package Body SFGPLANTILLAEXCEL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPLANTILLAEXCEL */ 

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCEL_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_AddRecord(@p_NOMBREPLANTILLA         VARCHAR,
                      @p_HOJAEXCEL               VARCHAR,
                      @p_ACTIVO                  NUMERIC(22,0),
                      @p_FECHAHORAMODIFICACION   DATETIME,
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ID_PLANTILLAEXCEL       NUMERIC(22,0) OUT)
 AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PLANTILLAEXCEL
      (
        NOMBREPLANTILLA,
        HOJAEXCEL,
        ACTIVO,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMBREPLANTILLA,
       @p_HOJAEXCEL,
       @p_ACTIVO,
       @p_FECHAHORAMODIFICACION,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PLANTILLAEXCEL = SCOPE_IDENTITY();
--    NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCEL_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_UpdateRecord;
GO


CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_UpdateRecord( @pk_ID_PLANTILLAEXCEL        NUMERIC(22,0),
                          @p_NOMBREPLANTILLA         VARCHAR,
                          @p_HOJAEXCEL               VARCHAR,
                          @p_ACTIVO                  NUMERIC(22,0),
                          @p_FECHAHORAMODIFICACION   DATETIME,
                          @p_CODUSUARIOMODIFICACION  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
     UPDATE WSXML_SFG.PLANTILLAEXCEL
       SET NOMBREPLANTILLA          = @p_NOMBREPLANTILLA,
           HOJAEXCEL                = @p_HOJAEXCEL,
           ACTIVO                   = @p_ACTIVO,
           FECHAHORAMODIFICACION    = @p_FECHAHORAMODIFICACION,
           CODUSUARIOMODIFICACION   = @p_CODUSUARIOMODIFICACION
     WHERE ID_PLANTILLAEXCEL = @pk_ID_PLANTILLAEXCEL;
    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
--    NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCEL_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetRecord(@pk_ID_PLANTILLAEXCEL NUMERIC(22,0)
                                                         ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PLANTILLAEXCEL
     WHERE ID_PLANTILLAEXCEL = @pk_ID_PLANTILLAEXCEL;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      
	  SELECT A.ID_PLANTILLAEXCEL,
             A.NOMBREPLANTILLA,
             A.HOJAEXCEL,
             A.ACTIVO,
             A.FECHAHORAMODIFICACION,
             A.CODUSUARIOMODIFICACION
      FROM WSXML_SFG.PLANTILLAEXCEL A
      WHERE A.ID_PLANTILLAEXCEL = @pk_ID_PLANTILLAEXCEL;
	  
--      NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCEL_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetList;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetList(@p_active NUMERIC(22,0)
                                                       ) AS
  BEGIN
  SET NOCOUNT ON;
    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_PLANTILLAEXCEL,
             NOMBREPLANTILLA,
             HOJAEXCEL,
             ACTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION
       FROM WSXML_SFG.PLANTILLAEXCEL
       WHERE ACTIVO = CASE WHEN @p_active = -1 THEN ACTIVO ELSE @p_active END;
	   
--    NULL;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCEL_GetListByUsuario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetListByUsuario;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetListByUsuario(@p_ACTIVE NUMERIC(22,0), 
                                                               @p_CODUSUARIODESTINO NUMERIC(22,0)
																)
  AS   BEGIN
   SET NOCOUNT ON;
   
      SELECT ID_PLANTILLAEXCEL,
             NOMBREPLANTILLA,
             HOJAEXCEL,
             ACTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION
      FROM WSXML_SFG.PLANTILLAEXCEL
      WHERE CODUSUARIOMODIFICACION = @p_CODUSUARIODESTINO
        AND ACTIVO = CASE WHEN @p_ACTIVE = -1 THEN ACTIVO ELSE @p_ACTIVE END;
		
   -- NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCEL_GetListByPlantilla', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetListByPlantilla;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCEL_GetListByPlantilla(@p_ACTIVE NUMERIC(22,0), 
                                                                 @p_NOMBREPLANTILLA VARCHAR
																  )
  AS   BEGIN
   SET NOCOUNT ON;
   
      SELECT ID_PLANTILLAEXCEL,
             NOMBREPLANTILLA,
             HOJAEXCEL,
             ACTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION
      FROM WSXML_SFG.PLANTILLAEXCEL
      WHERE NOMBREPLANTILLA = @p_NOMBREPLANTILLA
        AND ACTIVO = CASE WHEN @p_ACTIVE = -1 THEN ACTIVO ELSE @p_ACTIVE END;
		
   -- NULL;
  END;
GO






