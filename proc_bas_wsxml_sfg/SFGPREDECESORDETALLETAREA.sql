USE SFGPRODU;
--  DDL for Package Body SFGPREDECESORDETALLETAREA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPREDECESORDETALLETAREA */ 

  -- Creates a new record in the PREDECESORDETALLETAREA table
  IF OBJECT_ID('WSXML_SFG.SFGPREDECESORDETALLETAREA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_AddRecord(@p_CODDETALLETAREA              NUMERIC(22,0),
                      @p_CODPREDECESOR                NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @P_CODESTADOTAREAESPERADO       NUMERIC(22,0),
                      @p_ID_PREDECESORDETALLETARE_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PREDECESORDETALLETAREA
      (
       CODDETALLETAREAAEJECUTAR,
       CODDETALLETAREAEJECUTADA,
       CODUSUARIOMODIFICACION,
       CODESTADOTAREAESPERADO)
    VALUES
      (
       @p_CODDETALLETAREA,
       @p_CODPREDECESOR,
       @p_CODUSUARIOMODIFICACION,
       @P_CODESTADOTAREAESPERADO);
    SET @p_ID_PREDECESORDETALLETARE_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the PREDECESORDETALLETAREA table.
  IF OBJECT_ID('WSXML_SFG.SFGPREDECESORDETALLETAREA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_UpdateRecord(@pk_ID_PREDECESORDETALLETAREA NUMERIC(22,0),
                         @p_CODDETALLETAREA            NUMERIC(22,0),
                         @p_CODPREDECESOR              NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                         @p_ACTIVE                     NUMERIC(22,0),
                         @p_CODESTADOTAREAESPERADO     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PREDECESORDETALLETAREA
       SET CODDETALLETAREAAEJECUTAR = @p_CODDETALLETAREA,
           CODDETALLETAREAEJECUTADA = @p_CODPREDECESOR,
           CODUSUARIOMODIFICACION   = @p_CODUSUARIOMODIFICACION,
           ACTIVE                   = @p_ACTIVE,
           CODESTADOTAREAESPERADO   = @p_CODESTADOTAREAESPERADO
     WHERE ID_PREDECESORDETALLETAREA = @pk_ID_PREDECESORDETALLETAREA;

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

  -- Deletes a record from the PREDECESORDETALLETAREA table.

  -- Deletes the set of rows from the PREDECESORDETALLETAREA table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the PREDECESORDETALLETAREA table.
  IF OBJECT_ID('WSXML_SFG.SFGPREDECESORDETALLETAREA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_GetRecord(@pk_ID_PREDECESORDETALLETAREA NUMERIC(22,0)
                                                ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PREDECESORDETALLETAREA
     WHERE ID_PREDECESORDETALLETAREA = @pk_ID_PREDECESORDETALLETAREA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
		
      SELECT ID_PREDECESORDETALLETAREA,
             CODDETALLETAREAAEJECUTAR,
             CODDETALLETAREAEJECUTADA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             CODESTADOTAREAESPERADO
        FROM WSXML_SFG.PREDECESORDETALLETAREA
       WHERE ID_PREDECESORDETALLETAREA = @pk_ID_PREDECESORDETALLETAREA;
	;
  END;
GO

  -- Returns a query resultset from table PREDECESORDETALLETAREA
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
  IF OBJECT_ID('WSXML_SFG.SFGPREDECESORDETALLETAREA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
		
      SELECT ID_PREDECESORDETALLETAREA,
             CODDETALLETAREAAEJECUTAR,
             CODDETALLETAREAEJECUTADA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             CODESTADOTAREAESPERADO
        FROM WSXML_SFG.PREDECESORDETALLETAREA
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPREDECESORDETALLETAREA_GetListByDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_GetListByDetalle;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_GetListByDetalle(@p_active          NUMERIC(22,0),
                            @p_CODDETALLETAREA NUMERIC(22,0)
                                            ) AS
  BEGIN
  SET NOCOUNT ON;
    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT PREDECESORDETALLETAREA.ID_PREDECESORDETALLETAREA,
             PREDECESORDETALLETAREA.CODDETALLETAREAAEJECUTAR,
             PREDECESORDETALLETAREA.CODDETALLETAREAEJECUTADA,
             DETALLETAREA.NOMDETALLETAREA NOMDETALLETAREAEJECUTADA,
             PREDECESORDETALLETAREA.FECHAHORAMODIFICACION,
             PREDECESORDETALLETAREA.CODUSUARIOMODIFICACION,
             PREDECESORDETALLETAREA.ACTIVE,
             PREDECESORDETALLETAREA.CODESTADOTAREAESPERADO
        FROM WSXML_SFG.PREDECESORDETALLETAREA
        LEFT OUTER JOIN DETALLETAREA ON (PREDECESORDETALLETAREA.CODDETALLETAREAEJECUTADA =
                                          DETALLETAREA.ID_DETALLETAREA)
       WHERE CODDETALLETAREAAEJECUTAR = @p_CODDETALLETAREA
         AND PREDECESORDETALLETAREA.ACTIVE = CASE WHEN
       @p_active = -1 THEN PREDECESORDETALLETAREA.ACTIVE ELSE @p_active END;
	;

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPREDECESORDETALLETAREA_DeleteByDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_DeleteByDetalle;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPREDECESORDETALLETAREA_DeleteByDetalle(@p_CODDETALLETAREA NUMERIC(22,0),
                            @p_NUMROWS_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    SELECT @p_NUMROWS_out = COUNT(*)
      FROM WSXML_SFG.PREDECESORDETALLETAREA
     WHERE CODDETALLETAREAAEJECUTAR = @p_CODDETALLETAREA
       AND ACTIVE = 1;

    UPDATE WSXML_SFG.PREDECESORDETALLETAREA
       SET ACTIVE = 0
     WHERE CODDETALLETAREAAEJECUTAR = @p_CODDETALLETAREA;

  END;
GO

-- Returns a query result from table PREDECESORDETALLETAREA
-- given the search criteria and sorting condition.

-- Returns a query result from table PREDECESORDETALLETAREA
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file

