USE SFGPRODU;
--  DDL for Package Body SFGIMPUESTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGIMPUESTO */ 

  -- Creates a new record in the IMPUESTO table
  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTO_AddRecord(@p_NOMIMPUESTO            NVARCHAR(2000),
                      @p_CODBASEIMPUESTO        NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_IMPUESTO_out        NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.IMPUESTO (
                          NOMIMPUESTO,
                          CODIMPUESTOBASE,
                          CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMIMPUESTO,
       @p_CODBASEIMPUESTO,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_IMPUESTO_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the IMPUESTO table.
  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTO_UpdateRecord(@pk_ID_IMPUESTO           NUMERIC(22,0),
                         @p_NOMIMPUESTO            NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.IMPUESTO
       SET NOMIMPUESTO            = @p_NOMIMPUESTO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_IMPUESTO = @pk_ID_IMPUESTO;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the IMPUESTO table.

  -- Deletes the set of rows from the IMPUESTO table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the IMPUESTO table.
  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTO_GetRecord(@pk_ID_IMPUESTO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.IMPUESTO
     WHERE ID_IMPUESTO = @pk_ID_IMPUESTO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	  
      SELECT ID_IMPUESTO,
             NOMIMPUESTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.IMPUESTO
       WHERE ID_IMPUESTO = @pk_ID_IMPUESTO;
	
  END;
GO

  -- Returns a query resultset from table IMPUESTO
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
  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTO_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	  
      SELECT I.ID_IMPUESTO,
             I.NOMIMPUESTO,
             I.FECHAHORAMODIFICACION,
             I.CODUSUARIOMODIFICACION,
             I.ACTIVE,
             COUNT(PI.ID_PRODUCTOIMPUESTO) NUMVALORES
       FROM WSXML_SFG.IMPUESTO I
       LEFT OUTER JOIN WSXML_SFG.PRODUCTOIMPUESTO PI
         ON (PI.CODIMPUESTO = I.ID_IMPUESTO)
       WHERE I.ACTIVE = CASE WHEN @p_active = -1 THEN I.ACTIVE ELSE @p_active END
       GROUP BY I.ID_IMPUESTO,
                I.NOMIMPUESTO,
                I.FECHAHORAMODIFICACION,
                I.CODUSUARIOMODIFICACION,
                I.ACTIVE;
		
  END;
GO
  -- Returns a query result from table IMPUESTO
-- given the search criteria and sorting condition.

-- Returns a query result from table IMPUESTO
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file






