USE SFGPRODU;
--  DDL for Package Body SFGPLANTILLAEXCELDETALLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPLANTILLAEXCELDETALLE */ 

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCELDETALLE_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_AddRecord(@p_CODPLANTILLAEXCEL         NUMERIC(22,0),
                      @p_COLUMNA                   VARCHAR,
                      @p_TIPODATO                  VARCHAR,
                      @p_VALIDACION                VARCHAR,
                      @p_ACTIVE                    NUMERIC(22,0),
                      @p_FECHAHORAMODIFICACION     DATETIME,
                      @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                      @p_ID_PLANTILLAEXCELDETALLE  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PLANTILLAEXCELDETALLE
      (
        CODPLANTILLAEXCEL,
        COLUMNA,
        TIPODATO,
        VALIDACION,
        ACTIVO,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODPLANTILLAEXCEL,
       @p_COLUMNA,
       @p_TIPODATO,
       @p_VALIDACION,
       @p_ACTIVE,
       @p_FECHAHORAMODIFICACION,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PLANTILLAEXCELDETALLE = SCOPE_IDENTITY();
--    NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCELDETALLE_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_UpdateRecord( @pk_ID_PLANTILLAEXCELDETALLE   NUMERIC(22,0),
                          @p_CODPLANTILLAEXCEL           NUMERIC(22,0),
                          @p_COLUMNA                     VARCHAR,
                          @p_TIPODATO                    VARCHAR,
                          @p_VALIDACION                  VARCHAR,
                          @p_ACTIVE                      NUMERIC(22,0),
                          @p_FECHAHORAMODIFICACION       DATETIME,
                          @p_CODUSUARIOMODIFICACION      NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
     UPDATE WSXML_SFG.PLANTILLAEXCELDETALLE
       SET CODPLANTILLAEXCEL          = @p_CODPLANTILLAEXCEL,
           COLUMNA                    = @p_COLUMNA,
           TIPODATO                   = @p_TIPODATO,
           VALIDACION                 = @p_VALIDACION,
           ACTIVO                     = @p_ACTIVE,
           FECHAHORAMODIFICACION      = @p_FECHAHORAMODIFICACION,
           CODUSUARIOMODIFICACION     = @p_CODUSUARIOMODIFICACION
     WHERE ID_PLANTILLAEXCELDETALLE = @pk_ID_PLANTILLAEXCELDETALLE;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  --  NULL;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetRecord(@pk_ID_PLANTILLAEXCELDETALLE NUMERIC(22,0)
                                                                )
  AS
  BEGIN   DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PLANTILLAEXCELDETALLE
     WHERE ID_PLANTILLAEXCELDETALLE = @pk_ID_PLANTILLAEXCELDETALLE;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      
	  SELECT A.ID_PLANTILLAEXCELDETALLE,
             A.CODPLANTILLAEXCEL,
             A.COLUMNA,
             A.TIPODATO,
             A.VALIDACION,
             A.ACTIVO,
             A.FECHAHORAMODIFICACION,
             A.CODUSUARIOMODIFICACION,
             A.TIPOCOLUMNA
      FROM WSXML_SFG.PLANTILLAEXCELDETALLE A
      WHERE A.ID_PLANTILLAEXCELDETALLE = @pk_ID_PLANTILLAEXCELDETALLE;
	  
--      NULL;
  --  NULL;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetList;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetList(@p_active NUMERIC(22,0)
                                                              ) AS
  BEGIN
  SET NOCOUNT ON;
    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_PLANTILLAEXCELDETALLE,
             CODPLANTILLAEXCEL,
             COLUMNA,
             TIPODATO,
             VALIDACION,
             ACTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             TIPOCOLUMNA
       FROM WSXML_SFG.PLANTILLAEXCELDETALLE
       WHERE ACTIVO = CASE WHEN @p_active = -1 THEN ACTIVO ELSE @p_active END;
	   
  --  NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetListByCodPlantillaExcel', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetListByCodPlantillaExcel;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPLANTILLAEXCELDETALLE_GetListByCodPlantillaExcel(@p_ACTIVE NUMERIC(22,0), 
                                                                                @p_CODPLANTILLAEXCEL NUMERIC(22,0)
																				 ) AS
  BEGIN
  SET NOCOUNT ON;
    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      
	  SELECT ID_PLANTILLAEXCELDETALLE,
             CODPLANTILLAEXCEL,
             COLUMNA,
             TIPODATO,
             VALIDACION,
             ACTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             TIPOCOLUMNA
       FROM WSXML_SFG.PLANTILLAEXCELDETALLE
       WHERE CODPLANTILLAEXCEL= @p_CODPLANTILLAEXCEL AND
       ACTIVO = CASE WHEN @p_ACTIVE = -1 THEN ACTIVO ELSE @p_ACTIVE END;
	   
  --  NULL;
  END;
GO






