USE SFGPRODU;
--  DDL for Package Body SFGDEPARTAMENTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDEPARTAMENTO */ 

  -- Creates a new record in the DEPARTAMENTO table
  IF OBJECT_ID('WSXML_SFG.SFGDEPARTAMENTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_AddRecord(@p_NOMDEPARTAMENTO        NVARCHAR(2000),
                      @p_DEPARTAMENTODANE       NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_DEPARTAMENTO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DEPARTAMENTO
      (
       NOMDEPARTAMENTO,
       DEPARTAMENTODANE,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMDEPARTAMENTO,
       @p_DEPARTAMENTODANE,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DEPARTAMENTO_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the DEPARTAMENTO table.
  IF OBJECT_ID('WSXML_SFG.SFGDEPARTAMENTO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_UpdateRecord(@pk_ID_DEPARTAMENTO       NUMERIC(22,0),
                         @p_NOMDEPARTAMENTO        NVARCHAR(2000),
                         @p_DEPARTAMENTODANE       NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.DEPARTAMENTO
       SET NOMDEPARTAMENTO        = @p_NOMDEPARTAMENTO,
           DEPARTAMENTODANE       = @p_DEPARTAMENTODANE,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_DEPARTAMENTO = @pk_ID_DEPARTAMENTO;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the DEPARTAMENTO table.

  -- Deletes the set of rows from the DEPARTAMENTO table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the DEPARTAMENTO table.
  IF OBJECT_ID('WSXML_SFG.SFGDEPARTAMENTO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetRecord(@pk_ID_DEPARTAMENTO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.DEPARTAMENTO
     WHERE ID_DEPARTAMENTO = @pk_ID_DEPARTAMENTO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_DEPARTAMENTO,
             NOMDEPARTAMENTO,
             DEPARTAMENTODANE,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DEPARTAMENTO
       WHERE ID_DEPARTAMENTO = @pk_ID_DEPARTAMENTO;
	
  END;
GO

  -- Returns a query resultset from table DEPARTAMENTO
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
  IF OBJECT_ID('WSXML_SFG.SFGDEPARTAMENTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_DEPARTAMENTO,
             NOMDEPARTAMENTO,
             DEPARTAMENTODANE,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DEPARTAMENTO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	
  END;
GO
  -- Returns a query result from table DEPARTAMENTO
-- given the search criteria and sorting condition.

-- Returns a query result from table DEPARTAMENTO
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file


  IF OBJECT_ID('WSXML_SFG.SFGDEPARTAMENTO_GetListByCodDepartamentoDane', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetListByCodDepartamentoDane;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetListByCodDepartamentoDane(@p_active          NUMERIC(22,0),
                                    @p_codDepartamentoDane NVARCHAR(2000)
                                                    ) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_DEPARTAMENTO,
             NOMDEPARTAMENTO,
             DEPARTAMENTODANE
        FROM WSXML_SFG.DEPARTAMENTO
       WHERE
       ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END
       AND
       DEPARTAMENTODANE = CASE WHEN @p_codDepartamentoDane = '-1' THEN DEPARTAMENTODANE ELSE @p_codDepartamentoDane END
       ORDER BY NOMDEPARTAMENTO;
	
  END;
GO

  -- Obtiene la lista de departamentos que comienzan por una letra. Objetivos de paginacion
  IF OBJECT_ID('WSXML_SFG.SFGDEPARTAMENTO_GetListByInitialCharacter', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetListByInitialCharacter;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDEPARTAMENTO_GetListByInitialCharacter(@p_ACTIVE         NUMERIC(22,0),
                                     @p_INITCHAR       NVARCHAR(2000)
                                                    ) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_DEPARTAMENTO,
             NOMDEPARTAMENTO,
             DEPARTAMENTODANE,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.DEPARTAMENTO
      WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END
        AND NOMDEPARTAMENTO LIKE @p_INITCHAR + '%'
      ORDER BY NOMDEPARTAMENTO;
	
  END;
GO






