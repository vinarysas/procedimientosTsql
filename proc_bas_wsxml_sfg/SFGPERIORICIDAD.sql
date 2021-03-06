USE SFGPRODU;
--  DDL for Package Body SFGPERIORICIDAD
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPERIORICIDAD */ 

  -- CREATES A NEW RECORD IN THE PERIORICIDAD TABLE
  IF OBJECT_ID('WSXML_SFG.SFGPERIORICIDAD_ADDRECORD', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPERIORICIDAD_ADDRECORD;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPERIORICIDAD_ADDRECORD(@P_NOMPERIODICIDAD        VARCHAR(4000),
                      @P_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @P_FUNCION                VARCHAR(4000),
                      @P_ID_PERIORICIDAD_OUT    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PERIORICIDAD
      (
       NOMPERIODICIDAD,
       CODUSUARIOMODIFICACION,
       FUNCION)
    VALUES
      (
       @P_NOMPERIODICIDAD,
       @P_CODUSUARIOMODIFICACION,
       @P_FUNCION);
    SET @P_ID_PERIORICIDAD_OUT = SCOPE_IDENTITY();

  END;
GO

  -- UPDATES A RECORD IN THE PERIORICIDAD TABLE.
  IF OBJECT_ID('WSXML_SFG.SFGPERIORICIDAD_UPDATERECORD', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPERIORICIDAD_UPDATERECORD;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPERIORICIDAD_UPDATERECORD(@PK_ID_PERIORICIDAD       NUMERIC(22,0),
                         @P_NOMPERIODICIDAD        VARCHAR(4000),
                         @P_FUNCION                VARCHAR(4000),
                         @P_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @P_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- UPDATE THE RECORD WITH THE PASSED PARAMETERS
    UPDATE WSXML_SFG.PERIORICIDAD
       SET NOMPERIODICIDAD        = @P_NOMPERIODICIDAD,
           CODUSUARIOMODIFICACION = @P_CODUSUARIOMODIFICACION,
           FUNCION                = @P_FUNCION,
           ACTIVE                 = @P_ACTIVE
     WHERE ID_PERIORICIDAD = @PK_ID_PERIORICIDAD;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;

    -- MAKE SURE ONLY ONE RECORD IS AFFECTED
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 

  END;
GO

  -- DELETES A RECORD FROM THE PERIORICIDAD TABLE.

  -- DELETES THE SET OF ROWS FROM THE PERIORICIDAD TABLE
  -- THAT MATCH THE SPECIFIED SEARCH CRITERIA.
  -- RETURNS THE NUMBER OF ROWS DELETED AS AN OUTPUT PARAMETER.

  -- RETURNS A SPECIFIC RECORD FROM THE PERIORICIDAD TABLE.
  IF OBJECT_ID('WSXML_SFG.SFGPERIORICIDAD_GETRECORD', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPERIORICIDAD_GETRECORD;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPERIORICIDAD_GETRECORD(@PK_ID_PERIORICIDAD NUMERIC(22,0)
                                                             ) AS
 BEGIN
    DECLARE @L_COUNT INTEGER;
   
  SET NOCOUNT ON;

    -- GET THE ROWCOUNT FIRST AND MAKE SURE
    -- ONLY ONE ROW IS RETURNED
    SELECT @L_COUNT = COUNT(*)
      FROM WSXML_SFG.PERIORICIDAD
     WHERE ID_PERIORICIDAD = @PK_ID_PERIORICIDAD;

    IF @L_COUNT = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 

    IF @L_COUNT > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 

    -- GET THE ROW FROM THE QUERY.  CHECKSUM VALUE WILL BE
    -- RETURNED ALONG THE ROW DATA TO SUPPORT CONCURRENCY.
      
	  SELECT ID_PERIORICIDAD,
             NOMPERIODICIDAD,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             FECHAHORAMODIFICACION,
             FUNCION
        FROM WSXML_SFG.PERIORICIDAD
       WHERE ID_PERIORICIDAD = @PK_ID_PERIORICIDAD;
	   
  END;
GO

  -- RETURNS A QUERY RESULTSET FROM TABLE PERIORICIDAD
  -- GIVEN THE SEARCH CRITERIA AND SORTING CONDITION.
  -- IT WILL RETURN A SUBSET OF THE DATA BASED
  -- ON THE CURRENT PAGE NUMBER AND BATCH SIZE.  TABLE JOINS CAN
  -- BE PERFORMED IF THE JOIN CLAUSE IS SPECIFIED.
  --
  -- IF THE RESULTSET IS NOT EMPTY, IT WILL RETURN:
  --    1) THE TOTAL NUMBER OF ROWS WHICH MATCH THE CONDITION;
  --    2) THE RESULTSET IN THE CURRENT PAGE
  -- IF NOTHING MATCHES THE SEARCH CONDITION, IT WILL RETURN:
  --    1) COUNT IS 0 ;
  --    2) EMPTY RESULTSET.
  IF OBJECT_ID('WSXML_SFG.SFGPERIORICIDAD_GETLIST', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPERIORICIDAD_GETLIST;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPERIORICIDAD_GETLIST(@P_ACTIVE NUMERIC(22,0)
                                                           ) AS
  BEGIN
  SET NOCOUNT ON;

    -- GET THE ROWS FROM THE QUERY.  CHECKSUM VALUE WILL BE
    -- RETURNED ALONG THE ROW DATA TO SUPPORT CONCURRENCY.
	
      SELECT ID_PERIORICIDAD,
             NOMPERIODICIDAD,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             FECHAHORAMODIFICACION,
             FUNCION
       FROM WSXML_SFG.PERIORICIDAD
       WHERE ACTIVE = CASE WHEN @P_ACTIVE = -1 THEN ACTIVE ELSE @P_ACTIVE END;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPERIORICIDAD_GETLISTBYNAMES', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPERIORICIDAD_GETLISTBYNAMES;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPERIORICIDAD_GETLISTBYNAMES(@P_ACTIVE NUMERIC(22,0)
                                                                  ) AS
  BEGIN
  SET NOCOUNT ON;

    -- GET THE ROWS FROM THE QUERY.  CHECKSUM VALUE WILL BE
    -- RETURNED ALONG THE ROW DATA TO SUPPORT CONCURRENCY.
	
      SELECT * FROM WSXML_SFG.PERIORICIDAD WHERE NOMPERIODICIDAD IN ('DIARIA','MENSUAL','SEMANAL') AND
      ACTIVE = CASE WHEN @P_ACTIVE = -1 THEN ACTIVE ELSE @P_ACTIVE

        END;
		
  END;
GO
  -- RETURNS A QUERY RESULT FROM TABLE PERIORICIDAD
-- GIVEN THE SEARCH CRITERIA AND SORTING CONDITION.

-- RETURNS A QUERY RESULT FROM TABLE PERIORICIDAD
-- GIVEN THE SEARCH CRITERIA AND SORTING CONDITION.

-- RETURNS THE QUERY RESULT SET IN A CSV FORMAT
-- SO THAT THE DATA CAN BE EXPORTED TO A CSV FILE






