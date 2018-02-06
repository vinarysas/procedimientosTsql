USE SFGPRODU;
--  DDL for Package Body SFGESTADOALERTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGESTADOALERTA */ 

  -- Creates a new record in the ESTADOALERTA table
IF OBJECT_ID('WSXML_SFG.SFGESTADOALERTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOALERTA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOALERTA_AddRecord(@p_NOMESTADOALERTA        NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_ESTADOALERTA_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ESTADOALERTA
      ( NOMESTADOALERTA, CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMESTADOALERTA,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ESTADOALERTA_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the ESTADOALERTA table.
IF OBJECT_ID('WSXML_SFG.SFGESTADOALERTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOALERTA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOALERTA_UpdateRecord(@pk_ID_ESTADOALERTA       NUMERIC(22,0),
                         @p_NOMESTADOALERTA        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.ESTADOALERTA
       SET NOMESTADOALERTA        = @p_NOMESTADOALERTA,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ESTADOALERTA = @pk_ID_ESTADOALERTA;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the ESTADOALERTA table.

  -- Deletes the set of rows from the ESTADOALERTA table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the ESTADOALERTA table.
IF OBJECT_ID('WSXML_SFG.SFGESTADOALERTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOALERTA_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOALERTA_GetRecord(@pk_ID_ESTADOALERTA NUMERIC(22,0)
                                                             ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.ESTADOALERTA
     WHERE ID_ESTADOALERTA = @pk_ID_ESTADOALERTA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_ESTADOALERTA,
             NOMESTADOALERTA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ESTADOALERTA
       WHERE ID_ESTADOALERTA = @pk_ID_ESTADOALERTA;
	   
  END;
GO

  -- Returns a query resultset from table ESTADOALERTA
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
  IF OBJECT_ID('WSXML_SFG.SFGESTADOALERTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOALERTA_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOALERTA_GetList(@p_active NUMERIC(22,0)
                                                           ) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_ESTADOALERTA,
             NOMESTADOALERTA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ESTADOALERTA
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	   
  END;
GO
  -- Returns a query result from table ESTADOALERTA
-- given the search criteria and sorting condition.

-- Returns a query result from table ESTADOALERTA
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file






