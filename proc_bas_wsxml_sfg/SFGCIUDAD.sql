USE SFGPRODU;
--  DDL for Package Body SFGCIUDAD
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCIUDAD */ 

  -- Creates a new record in the CIUDAD table
  IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_AddRecord(@p_NOMCIUDAD              NVARCHAR(2000),
                      @p_CIUDADDANE             NVARCHAR(2000),
                      @p_CODDEPARTAMENTO        NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_CIUDAD_out          NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CIUDAD
      (
       NOMCIUDAD,
       CIUDADDANE,
       CODDEPARTAMENTO,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMCIUDAD,
       @p_CIUDADDANE,
       @p_CODDEPARTAMENTO,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_CIUDAD_out = SCOPE_IDENTITY();

    -- Call UPDATE for fields that have database defaults

  END;
GO

  -- Updates a record in the CIUDAD table.
  IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_UpdateRecord(@pk_ID_CIUDAD             NUMERIC(22,0),
                         @p_NOMCIUDAD              NVARCHAR(2000),
                         @p_CIUDADDANE             NVARCHAR(2000),
                         @p_CODDEPARTAMENTO        NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.CIUDAD
       SET NOMCIUDAD              = @p_NOMCIUDAD,
           CIUDADDANE             = @p_CIUDADDANE,
           CODDEPARTAMENTO        = @p_CODDEPARTAMENTO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_CIUDAD = @pk_ID_CIUDAD;

	 DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the CIUDAD table.

  -- Deletes the set of rows from the CIUDAD table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the CIUDAD table.
IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_GetRecord(@pk_ID_CIUDAD NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.CIUDAD
     WHERE ID_CIUDAD = @pk_ID_CIUDAD;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_CIUDAD,
             NOMCIUDAD,
             CIUDADDANE,
             CODDEPARTAMENTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CIUDAD
       WHERE ID_CIUDAD = @pk_ID_CIUDAD;
	
  END;
GO

  -- Returns a query resultset from table CIUDAD
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
  IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_CIUDAD,
             NOMCIUDAD,
             CIUDADDANE,
             CODDEPARTAMENTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CIUDAD
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	
END;
GO

  -- Returns a query result from table CIUDAD
  -- given the search criteria and sorting condition.

  -- Returns a query result from table CIUDAD
  -- given the search criteria and sorting condition.

  -- Returns the query result set in a CSV format
  -- so that the data can be exported to a CSV file

  IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_GetListByCodDepartamento', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_GetListByCodDepartamento;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_GetListByCodDepartamento(@p_active          NUMERIC(22,0),
                                    @p_codDepartamento NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_CIUDAD,
             NOMCIUDAD,
             CIUDADDANE,
             CODDEPARTAMENTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CIUDAD
       WHERE
       ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END
       AND
       CODDEPARTAMENTO = CASE WHEN @p_codDepartamento = -1  THEN CODDEPARTAMENTO ELSE  @p_codDepartamento END
       ORDER BY NOMCIUDAD;
	
  END;
GO

  -- Obtiene una lista de las ciudades de un departamento de acuerdo a su letra inicial
  IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_GetListByCodDepInitialChar', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_GetListByCodDepInitialChar;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_GetListByCodDepInitialChar(@p_ACTIVE          NUMERIC(22,0),
                                       @p_CODDEPARTAMENTO NUMERIC(22,0),
                                      @p_INITCHAR        NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_CIUDAD,
             NOMCIUDAD,
             CIUDADDANE,
             CODDEPARTAMENTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CIUDAD
       WHERE CODDEPARTAMENTO = CASE WHEN @p_CODDEPARTAMENTO = -1  THEN CODDEPARTAMENTO ELSE  @p_CODDEPARTAMENTO END
         AND ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END
         AND NOMCIUDAD LIKE @p_INITCHAR + '%'
       ORDER BY NOMCIUDAD;
	 
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGCIUDAD_GetRecordByDane', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCIUDAD_GetRecordByDane;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCIUDAD_GetRecordByDane(@p_CIUDADDANE VARCHAR)
  AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_CIUDAD,
             NOMCIUDAD,
             CIUDADDANE,
             CODDEPARTAMENTO
        FROM WSXML_SFG.CIUDAD
       WHERE CIUDADDANE = @p_CIUDADDANE
       ORDER BY NOMCIUDAD;
	
  END;
GO





