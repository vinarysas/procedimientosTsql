USE SFGPRODU;
--  DDL for Package Body SFGTIPOPUNTODEVENTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOPUNTODEVENTA */ 


IF OBJECT_ID('WSXML_SFG.SFGTIPOPUNTODEVENTA_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_CONSTANT(
                      @AGRUPADO     INT  OUT,
                      @ABIERTO INT  OUT,
					  @INDEPENDIENTE INT  OUT
					  ) AS
  BEGIN
	
	    SET @AGRUPADO = 1;
	SET @ABIERTO  = 2;
  SET @INDEPENDIENTE = 3;

  END;
GO


	
	
  -- Creates a new record in the TIPOPUNTODEVENTA table
  IF OBJECT_ID('WSXML_SFG.SFGTIPOPUNTODEVENTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_AddRecord(@p_NOMTIPOPUNTODEVENTA         NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                      @p_ID_TIPOPUNTODEVENTA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPOPUNTODEVENTA
      (
       NOMTIPOPUNTODEVENTA,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_NOMTIPOPUNTODEVENTA,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPOPUNTODEVENTA_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the TIPOPUNTODEVENTA table.
  IF OBJECT_ID('WSXML_SFG.SFGTIPOPUNTODEVENTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_UpdateRecord(@pk_ID_TIPOPUNTODEVENTA       NUMERIC(22,0),
                         @p_NOMTIPOPUNTODEVENTA        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                         @p_ACTIVE                     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.TIPOPUNTODEVENTA
       SET NOMTIPOPUNTODEVENTA       = @p_NOMTIPOPUNTODEVENTA,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           ACTIVE                    = @p_ACTIVE
     WHERE ID_TIPOPUNTODEVENTA = @pk_ID_TIPOPUNTODEVENTA;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Returns a specific record from the TIPOPUNTODEVENTA table.
  IF OBJECT_ID('WSXML_SFG.SFGTIPOPUNTODEVENTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_GetRecord(@pk_ID_TIPOPUNTODEVENTA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.TIPOPUNTODEVENTA
     WHERE ID_TIPOPUNTODEVENTA = @pk_ID_TIPOPUNTODEVENTA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT ID_TIPOPUNTODEVENTA,
             NOMTIPOPUNTODEVENTA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOPUNTODEVENTA
       WHERE ID_TIPOPUNTODEVENTA = @pk_ID_TIPOPUNTODEVENTA;
  END;
GO

  -- Returns a query resultset from table TIPOPUNTODEVENTA
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
  IF OBJECT_ID('WSXML_SFG.SFGTIPOPUNTODEVENTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOPUNTODEVENTA_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
      SELECT ID_TIPOPUNTODEVENTA,
             NOMTIPOPUNTODEVENTA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOPUNTODEVENTA
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;

  END;
GO






