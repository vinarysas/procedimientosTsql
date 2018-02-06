USE SFGPRODU;
--  DDL for Package Body SFGREGIMEN
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREGIMEN */ 

  -- Creates a new record in the REGIMEN table
  IF OBJECT_ID('WSXML_SFG.SFGREGIMEN_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIMEN_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGIMEN_AddRecord(@p_NOMREGIMEN             NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_REGIMEN_out         NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REGIMEN
      ( NOMREGIMEN, CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMREGIMEN,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_REGIMEN_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the REGIMEN table.
  IF OBJECT_ID('WSXML_SFG.SFGREGIMEN_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIMEN_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGIMEN_UpdateRecord(@pk_ID_REGIMEN            NUMERIC(22,0),
                         @p_NOMREGIMEN             NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.REGIMEN
       SET NOMREGIMEN             = @p_NOMREGIMEN,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_REGIMEN = @pk_ID_REGIMEN;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the REGIMEN table.

  -- Deletes the set of rows from the REGIMEN table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the REGIMEN table.
  IF OBJECT_ID('WSXML_SFG.SFGREGIMEN_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIMEN_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREGIMEN_GetRecord(@pk_ID_REGIMEN NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    
    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.REGIMEN
     WHERE ID_REGIMEN = @pk_ID_REGIMEN;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_REGIMEN,
             NOMREGIMEN,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.REGIMEN
       WHERE ID_REGIMEN = @pk_ID_REGIMEN;
    
  END;
GO

  -- Returns a query resultset from table REGIMEN
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
  IF OBJECT_ID('WSXML_SFG.SFGREGIMEN_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIMEN_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREGIMEN_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;
    

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT R.ID_REGIMEN,
             R.NOMREGIMEN,
             R.FECHAHORAMODIFICACION,
             R.CODUSUARIOMODIFICACION,
             R.ACTIVE,
             COUNT(RI.ID_RETENCIONTRIBUTARIAREGIMEN) NUMRETENCIONES
        FROM WSXML_SFG.REGIMEN R
        LEFT OUTER JOIN WSXML_SFG.RETENCIONTRIBUTARIAREGIMEN RI
          ON (RI.CODREGIMEN = R.ID_REGIMEN)
       WHERE R.ACTIVE = CASE WHEN @p_active = -1 THEN R.ACTIVE ELSE @p_active END
       GROUP BY R.ID_REGIMEN,
                R.NOMREGIMEN,
                R.FECHAHORAMODIFICACION,
                R.CODUSUARIOMODIFICACION,
                R.ACTIVE;
     

  END;
GO
  -- Returns a query result from table REGIMEN
-- given the search criteria and sorting condition.

-- Returns a query result from table REGIMEN
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file






