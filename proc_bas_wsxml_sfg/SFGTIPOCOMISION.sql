USE SFGPRODU;
--  DDL for Package Body SFGTIPOCOMISION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOCOMISION */ 

  -- Creates a new record in the TIPOCOMISION table
  IF OBJECT_ID('WSXML_SFG.SFGTIPOCOMISION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCOMISION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOCOMISION_AddRecord(@p_NOMTIPOCOMISION        NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TIPOCOMISION_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPOCOMISION
      ( NOMTIPOCOMISION, CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMTIPOCOMISION,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPOCOMISION_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the TIPOCOMISION table.
  IF OBJECT_ID('WSXML_SFG.SFGTIPOCOMISION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCOMISION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOCOMISION_UpdateRecord(@pk_ID_TIPOCOMISION       NUMERIC(22,0),
                         @p_NOMTIPOCOMISION        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.TIPOCOMISION
       SET NOMTIPOCOMISION        = @p_NOMTIPOCOMISION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TIPOCOMISION = @pk_ID_TIPOCOMISION;

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

  -- Deletes a record from the TIPOCOMISION table.

  -- Deletes the set of rows from the TIPOCOMISION table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the TIPOCOMISION table.
  IF OBJECT_ID('WSXML_SFG.SFGTIPOCOMISION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCOMISION_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOCOMISION_GetRecord(@pk_ID_TIPOCOMISION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.TIPOCOMISION
     WHERE ID_TIPOCOMISION = @pk_ID_TIPOCOMISION;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT ID_TIPOCOMISION,
             NOMTIPOCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOCOMISION
       WHERE ID_TIPOCOMISION = @pk_ID_TIPOCOMISION;
  END;
GO

  -- Returns a query resultset from table TIPOCOMISION
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
  IF OBJECT_ID('WSXML_SFG.SFGTIPOCOMISION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOCOMISION_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOCOMISION_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT ID_TIPOCOMISION,
             NOMTIPOCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOCOMISION
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;


  END;
GO
  -- Returns a query result from table TIPOCOMISION
-- given the search criteria and sorting condition.

-- Returns a query result from table TIPOCOMISION
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file






