USE SFGPRODU;
--  DDL for Package Body SFGTAREA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTAREA */ 

  -- Creates a new record in the TAREA table
  IF OBJECT_ID('WSXML_SFG.SFGTAREA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTAREA_AddRecord(@p_NOMTAREA               NVARCHAR(2000),
                      @p_FECHAEJECUCIONTAREA    DATETIME,
                      @p_NUMREINTENTOS          NUMERIC(22,0),
                      @p_CODPERIODICIDAD        NUMERIC(22,0),
                      @p_FRECUENCIA             NUMERIC(22,0),
                      @p_ID_TAREA_PREDECESOR    NUMERIC(22,0),
                      @p_AGENTE_EJECUTOR        NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TAREA_out           NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TAREA
      (
       NOMTAREA,
       FECHAEJECUCIONTAREA,
       NUMREINTENTOS,
       CODPERIODICIDAD,
       FRECUENCIA,
       ID_TAREA_PREDECESOR,
       AGENTE_EJECUTOR,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMTAREA,
       @p_FECHAEJECUCIONTAREA,
       @p_NUMREINTENTOS,
       @p_CODPERIODICIDAD,
       @p_FRECUENCIA,
       CASE WHEN @p_ID_TAREA_PREDECESOR > 0 THEN @p_ID_TAREA_PREDECESOR ELSE NULL END,
       @p_AGENTE_EJECUTOR,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TAREA_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the TAREA table.
  IF OBJECT_ID('WSXML_SFG.SFGTAREA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTAREA_UpdateRecord(@pk_ID_TAREA              NUMERIC(22,0),
                         @p_NOMTAREA               NVARCHAR(2000),
                         @p_FECHAEJECUCIONTAREA    DATETIME,
                         @p_NUMREINTENTOS          NUMERIC(22,0),
                         @p_CODPERIODICIDAD        NUMERIC(22,0),
                         @p_FRECUENCIA             NUMERIC(22,0),
                         @p_ID_TAREA_PREDECESOR    NUMERIC(22,0),
                         @p_AGENTE_EJECUTOR        NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.TAREA
       SET NOMTAREA               = @p_NOMTAREA,
           FECHAEJECUCIONTAREA    = @p_FECHAEJECUCIONTAREA,
           NUMREINTENTOS          = @p_NUMREINTENTOS,
           CODPERIODICIDAD        = @p_CODPERIODICIDAD,
           FRECUENCIA             = @p_FRECUENCIA,
           ID_TAREA_PREDECESOR    = CASE WHEN @p_ID_TAREA_PREDECESOR > 0 THEN @p_ID_TAREA_PREDECESOR ELSE NULL END,
           AGENTE_EJECUTOR        = @p_AGENTE_EJECUTOR,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TAREA = @pk_ID_TAREA;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the TAREA table.

  -- Deletes the set of rows from the TAREA table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the TAREA table.
  IF OBJECT_ID('WSXML_SFG.SFGTAREA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTAREA_GetRecord(@pk_ID_TAREA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.TAREA
     WHERE ID_TAREA = @pk_ID_TAREA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.

      SELECT T.ID_TAREA,
             T.NOMTAREA,
             T.FECHAEJECUCIONTAREA,
             T.NUMREINTENTOS,
             T.CODPERIODICIDAD,
             P.NOMPERIODICIDAD,
             T.FRECUENCIA,
             T.ID_TAREA_PREDECESOR,
             PR.NOMTAREA NOM_TAREA_PREDECESOR,
             T.AGENTE_EJECUTOR,
             T.FECHAHORAMODIFICACION,
             T.CODUSUARIOMODIFICACION,
             T.ACTIVE
      FROM WSXML_SFG.TAREA T
      LEFT OUTER JOIN PERIORICIDAD P
        ON (T.CODPERIODICIDAD = P.ID_PERIORICIDAD)
      LEFT OUTER JOIN TAREA PR
        ON (T.ID_TAREA_PREDECESOR = PR.ID_TAREA)
      WHERE T.ID_TAREA = @pk_ID_TAREA;
  END;
GO

  -- Returns a query resultset from table TAREA
  -- given the search criteria and sorting condition.
  -- It will return a subset of the data based
  -- on the current page number and batch size.  Table joins can
  -- be performed if the join clause is specified.
  --
  -- If the resultset is not empty, it will return:
  --    1) The total number of rows which match the condition;
  --    2) The resultset in the current page
  -- If nothing matches the search condition, it will return:
  --    1) count is 0 ;
  --    2) empty resultset.

  IF OBJECT_ID('WSXML_SFG.SFGTAREA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTAREA_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT T.ID_TAREA,
             T.NOMTAREA,
             T.FECHAEJECUCIONTAREA,
             T.NUMREINTENTOS,
             T.CODPERIODICIDAD,
             P.NOMPERIODICIDAD,
             T.FRECUENCIA,
             T.ID_TAREA_PREDECESOR,
             PR.NOMTAREA NOM_TAREA_PREDECESOR,
             T.AGENTE_EJECUTOR,
             T.FECHAHORAMODIFICACION,
             T.CODUSUARIOMODIFICACION,
             T.ACTIVE
      FROM WSXML_SFG.TAREA T
      LEFT OUTER JOIN PERIORICIDAD P
        ON (T.CODPERIODICIDAD = P.ID_PERIORICIDAD)
      LEFT OUTER JOIN TAREA PR
        ON (T.ID_TAREA_PREDECESOR = PR.ID_TAREA)
      WHERE T.ACTIVE = CASE WHEN @p_active = -1 THEN T.ACTIVE ELSE @p_active END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTAREA_GetListByName', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_GetListByName;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTAREA_GetListByName(@p_NOMTAREA NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT T.ID_TAREA,
             T.NOMTAREA,
             T.FECHAEJECUCIONTAREA,
             T.NUMREINTENTOS,
             T.CODPERIODICIDAD,
             P.NOMPERIODICIDAD,
             T.FRECUENCIA,
             T.ID_TAREA_PREDECESOR,
             AGENTE_EJECUTOR,
             T.FECHAHORAMODIFICACION,
             T.CODUSUARIOMODIFICACION,
             T.ACTIVE
      FROM WSXML_SFG.TAREA T
      LEFT OUTER JOIN PERIORICIDAD P ON (T.CODPERIODICIDAD = P.ID_PERIORICIDAD)
      WHERE T.NOMTAREA = @p_NOMTAREA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTAREA_DeleteSubTasks', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_DeleteSubTasks;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTAREA_DeleteSubTasks(@pk_ID_TAREA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    DELETE WSXML_SFG.DETALLETAREA WHERE CODTAREA = @pk_ID_TAREA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTAREA_AppendSubTask', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_AppendSubTask;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTAREA_AppendSubTask(@pk_ID_TAREA           NUMERIC(22,0),
                          @p_NOMDETALLETAREA     NVARCHAR(2000),
                          @p_CODINFOEJECUCION    NUMERIC(22,0),
                          @p_PARAMETRO           NVARCHAR(2000),
                          @p_ORDEN               NUMERIC(22,0),
                          @p_CODIGOPREDECESOR    NUMERIC(22,0),
                          @p_ID_DETALLETAREA_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @p_CODINFOEJECUCIONWARNING NUMERIC(22,0);
    DECLARE @p_CODINFOEJECUCIONERROR   NUMERIC(22,0);
    DECLARE @xCODUSUARIOMODIFICACION   NUMERIC(22,0) = 1;
    DECLARE @xCODESTADOTAREAESPERADO   NUMERIC(22,0) = 3;
   
  SET NOCOUNT ON;
    BEGIN
		BEGIN TRY
		  SELECT @p_CODINFOEJECUCIONWARNING = CODINFOEJECUCIONWARNING, @p_CODINFOEJECUCIONERROR = CODINFOEJECUCIONERROR
		  FROM WSXML_SFG.INFOEJECUCIONCONJUNTO
		  WHERE CODINFOEJECUCION = @p_CODINFOEJECUCION;
		END TRY
		BEGIN CATCH
			  SELECT NULL;
		END CATCH
    
    
    END;

    INSERT INTO WSXML_SFG.DETALLETAREA (
                              CODTAREA,
                              NOMDETALLETAREA,
                              CODINFOEJECUCION,
                              PARAMETRO,
                              CODINFOEJECUCIONWARNING,
                              CODINFOEJECUCIONERROR,
                              CODUSUARIOMODIFICACION,
                              TIENEPREDECESOR,
                              ORDEN)
    VALUES (
            @pk_ID_TAREA,
            @p_NOMDETALLETAREA,
            @p_CODINFOEJECUCION,
            @p_PARAMETRO,
            @p_CODINFOEJECUCIONWARNING,
            @p_CODINFOEJECUCIONERROR,
            @xCODUSUARIOMODIFICACION,
            CASE WHEN @p_CODIGOPREDECESOR > 0 THEN 1 ELSE 0 END,
            @p_ORDEN);
    SET @p_ID_DETALLETAREA_out = SCOPE_IDENTITY();
    IF @p_CODIGOPREDECESOR > 0 BEGIN
      INSERT INTO WSXML_SFG.PREDECESORDETALLETAREA (
                                          CODDETALLETAREAAEJECUTAR,
                                          CODDETALLETAREAEJECUTADA,
                                          CODESTADOTAREAESPERADO,
                                          CODUSUARIOMODIFICACION)
      VALUES (
              @p_ID_DETALLETAREA_out,
              @p_CODIGOPREDECESOR,
              @xCODESTADOTAREAESPERADO,
              @xCODUSUARIOMODIFICACION);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTAREA_DeleteTask', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTAREA_DeleteTask;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTAREA_DeleteTask(@pk_ID_TAREA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    DELETE FROM WSXML_SFG.TAREA WHERE ID_TAREA = @pk_ID_TAREA;
  END;
GO






