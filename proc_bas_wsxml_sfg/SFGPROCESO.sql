USE SFGPRODU;
--  DDL for Package Body SFGPROCESO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPROCESO */ 

  -- Creates a new record in the PROCESO table

  IF OBJECT_ID('WSXML_SFG.SFGPROCESO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPROCESO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPROCESO_AddRecord(@p_NOMPROCESO             NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_PROCESO_out         NUMERIC(22,0) OUT)

   AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PROCESO
      ( NOMPROCESO, CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMPROCESO,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PROCESO_out = SCOPE_IDENTITY();

    -- Call UPDATE for fields that have database defaults

  END;
GO

  -- Updates a record in the PROCESO table.

  IF OBJECT_ID('WSXML_SFG.SFGPROCESO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPROCESO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPROCESO_UpdateRecord(@pk_ID_PROCESO            NUMERIC(22,0),
                         @p_NOMPROCESO             NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0))

   AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PROCESO
       SET NOMPROCESO             = @p_NOMPROCESO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_PROCESO = @pk_ID_PROCESO;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the PROCESO table.

  -- Deletes the set of rows from the PROCESO table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the PROCESO table.
  IF OBJECT_ID('WSXML_SFG.SFGPROCESO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPROCESO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPROCESO_GetRecord(@pk_ID_PROCESO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PROCESO
     WHERE ID_PROCESO = @pk_ID_PROCESO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT ID_PROCESO,
             NOMPROCESO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION ACTIVE
        FROM WSXML_SFG.PROCESO
       WHERE ID_PROCESO = @pk_ID_PROCESO;
  END;
GO

  -- Returns a query resultset from table PROCESO
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
  IF OBJECT_ID('WSXML_SFG.SFGPROCESO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPROCESO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPROCESO_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT ID_PROCESO,
             NOMPROCESO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION ACTIVE
        FROM WSXML_SFG.PROCESO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGPROCESO_GetProcessIDByName', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPROCESO_GetProcessIDByName;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPROCESO_GetProcessIDByName(@p_NOMPROCESO NVARCHAR(2000), @p_ID_PROCESO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_PROCESO_out = MIN(ID_PROCESO) FROM WSXML_SFG.PROCESO
    WHERE UPPER(NOMPROCESO) = UPPER(@p_NOMPROCESO);
  
  /*
  EXCEPTION WHEN NO_DATA_FOUND THEN
    INSERT INTO WSXML_SFG.PROCESO (
                         NOMPROCESO,
                         CODUSUARIOMODIFICACION,
                         CODUSUARIORESPONSABLE)
    VALUES (
            @p_NOMPROCESO,
            1, 1);
    SET @p_ID_PROCESO_out = SCOPE_IDENTITY();
	*/
	IF(@@rowcount = 0)
		  BEGIN
		     INSERT INTO WSXML_SFG.PROCESO (
                         NOMPROCESO,
                         CODUSUARIOMODIFICACION,
                         CODUSUARIORESPONSABLE)
                      VALUES (
                               @p_NOMPROCESO,
                               1, 1);
                     SET @p_ID_PROCESO_out = SCOPE_IDENTITY();
          END
  END;
GO






