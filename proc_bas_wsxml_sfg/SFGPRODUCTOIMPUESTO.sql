USE SFGPRODU;
--  DDL for Package Body SFGPRODUCTOIMPUESTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPRODUCTOIMPUESTO */ 

  -- Creates a new record in the PRODUCTOIMPUESTO table
  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOIMPUESTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_AddRecord(@p_CODPRODUCTO             NUMERIC(22,0),
                      @p_CODIMPUESTO             NUMERIC(22,0),
                      @p_VALOR                   FLOAT,
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ID_PRODUCTOIMPUESTO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PRODUCTOIMPUESTO
      (
       CODPRODUCTO,
       CODIMPUESTO,
       VALORPORCENTUAL,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODPRODUCTO,
       @p_CODIMPUESTO,
       @p_VALOR,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PRODUCTOIMPUESTO_out = SCOPE_IDENTITY();

  END;
GO

  -- Updates a record in the PRODUCTOIMPUESTO table.
  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOIMPUESTO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_UpdateRecord(@pk_ID_PRODUCTOIMPUESTO   NUMERIC(22,0),
                         @p_CODPRODUCTO            NUMERIC(22,0),
                         @p_CODIMPUESTO            NUMERIC(22,0),
                         @p_VALOR                  FLOAT,
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PRODUCTOIMPUESTO
       SET CODPRODUCTO            = @p_CODPRODUCTO,
           CODIMPUESTO            = @p_CODIMPUESTO,
           VALORPORCENTUAL                  = @p_VALOR,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_PRODUCTOIMPUESTO = @pk_ID_PRODUCTOIMPUESTO;

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

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOIMPUESTO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_DeactivateRecord(@pk_ID_PRODUCTOIMPUESTO NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.PRODUCTOIMPUESTO
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_PRODUCTOIMPUESTO = @pk_ID_PRODUCTOIMPUESTO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;

    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Deletes a record from the PRODUCTOIMPUESTO table.

  -- Deletes the set of rows from the PRODUCTOIMPUESTO table
  -- that match the specified search criteria.
  -- Returns the number of rows deleted as an output parameter.

  -- Returns a specific record from the PRODUCTOIMPUESTO table.
  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOIMPUESTO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_GetRecord(@pk_ID_PRODUCTOIMPUESTO NUMERIC(22,0)
                                          ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.PRODUCTOIMPUESTO
     WHERE ID_PRODUCTOIMPUESTO = @pk_ID_PRODUCTOIMPUESTO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
      SELECT ID_PRODUCTOIMPUESTO,
             CODPRODUCTO,
             CODIMPUESTO,
             VALORPORCENTUAL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PRODUCTOIMPUESTO
       WHERE ID_PRODUCTOIMPUESTO = @pk_ID_PRODUCTOIMPUESTO;
 	   
  END;
GO

  -- Returns a query resultset from table PRODUCTOIMPUESTO
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
  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOIMPUESTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 	
      SELECT PI.ID_PRODUCTOIMPUESTO,
             PI.CODPRODUCTO,
             P.NOMPRODUCTO,
             T.NOMTIPOPRODUCTO,
             PI.CODIMPUESTO,
             PI.VALORPORCENTUAL,
             PI.FECHAHORAMODIFICACION,
             PI.CODUSUARIOMODIFICACION,
             PI.ACTIVE
        FROM WSXML_SFG.PRODUCTOIMPUESTO PI
       LEFT OUTER JOIN WSXML_SFG.PRODUCTO P
         ON (P.ID_PRODUCTO = PI.CODPRODUCTO)
       LEFT OUTER JOIN TIPOPRODUCTO T
         ON (T.ID_TIPOPRODUCTO = P.CODTIPOPRODUCTO)
       WHERE PI.ACTIVE = CASE WHEN @p_active = -1 THEN PI.ACTIVE ELSE @p_active END;
	 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOIMPUESTO_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_GetListByHeader;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOIMPUESTO_GetListByHeader(@p_ACTIVE NUMERIC(22,0), @p_CODIMPUESTO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	   
      SELECT PI.ID_PRODUCTOIMPUESTO,
             PI.CODPRODUCTO,
             P.NOMPRODUCTO,
             P.CODTIPOPRODUCTO,
             T.NOMTIPOPRODUCTO,
             PI.CODIMPUESTO,
             PI.VALORPORCENTUAL,
             PI.FECHAHORAMODIFICACION,
             PI.CODUSUARIOMODIFICACION,
             PI.ACTIVE
        FROM WSXML_SFG.PRODUCTOIMPUESTO PI
       LEFT OUTER JOIN WSXML_SFG.PRODUCTO P
         ON (P.ID_PRODUCTO = PI.CODPRODUCTO)
       LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO T
         ON (T.ID_TIPOPRODUCTO = P.CODTIPOPRODUCTO)
       WHERE CODIMPUESTO = @p_CODIMPUESTO
         AND PI.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN PI.ACTIVE ELSE @p_ACTIVE END;
	 	
  END;
GO
  -- Returns a query result from table PRODUCTOIMPUESTO
-- given the search criteria and sorting condition.

-- Returns a query result from table PRODUCTOIMPUESTO
-- given the search criteria and sorting condition.

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file






