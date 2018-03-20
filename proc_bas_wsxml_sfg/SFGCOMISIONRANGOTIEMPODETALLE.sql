USE SFGPRODU;
--  DDL for Package Body SFGCOMISIONRANGOTIEMPODETALLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE */ 

--Add Record in the table COMISIONRANGOTIEMPODETALLE table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_AddRecord(@p_CODCOMISIONRANGOTIEMPO    NUMERIC(22,0),
                      @p_RANGOINICIAL        FLOAT,
                      @p_RANGOFINAL        FLOAT,
                      @p_TARIFAPORCENTUAL        FLOAT,
                      @p_TARIFATRANSACIONAL        FLOAT,
                      @p_FIJO        FLOAT,
                      @p_ACTIVE        NUMERIC(22,0),
                      @p_ID_COMSRANGTIEMPDET_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

     INSERT INTO WSXML_SFG.COMISIONRANGOTIEMPODETALLE
           (CODCOMISIONRANGOTIEMPO
           ,RANGOINICIAL
           ,RANGOFINAL
           ,TARIFAPORCENTUAL
           ,TARIFATRANSACIONAL
           ,FIJO
           ,ACTIVE)
     VALUES
           (
           @p_CODCOMISIONRANGOTIEMPO
           ,@p_RANGOINICIAL
           ,@p_RANGOFINAL
           ,ROUND(@p_TARIFAPORCENTUAL,2)
           ,@p_TARIFATRANSACIONAL
           ,@p_FIJO
           ,@p_ACTIVE);
    SET @p_ID_COMSRANGTIEMPDET_out = SCOPE_IDENTITY();
  END;
GO

  --Update Record in the COMISIONRANGOTIEMPODETALLE table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_UpdateRecord(@pk_ID_COMSRANGTIEMPODET             NUMERIC(22,0),
                      @p_CODCOMISIONRANGOTIEMPO    NUMERIC(22,0),
                      @p_RANGOINICIAL        FLOAT,
                      @p_RANGOFINAL        FLOAT,
                      @p_TARIFAPORCENTUAL        FLOAT,
                      @p_TARIFATRANSACIONAL        FLOAT,
                      @p_FIJO        FLOAT,
                      @p_ACTIVE        NUMERIC(22,0)
                      ) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.COMISIONRANGOTIEMPODETALLE
    SET    CODCOMISIONRANGOTIEMPO = @p_CODCOMISIONRANGOTIEMPO
          ,RANGOINICIAL = @p_RANGOINICIAL
          ,RANGOFINAL = @p_RANGOFINAL
          ,TARIFAPORCENTUAL =ROUND(@p_TARIFAPORCENTUAL,2)
          ,TARIFATRANSACIONAL = @p_TARIFATRANSACIONAL
          ,FIJO = @p_FIJO
          ,ACTIVE = @p_ACTIVE
    WHERE ID_COMISIONRANGOTIEMPODETALLE = @pk_ID_COMSRANGTIEMPODET;

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


  --Get Record in the COMISIONRANGOTIEMPODETALLE table by the Primary Key.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetRecord(@pk_ID_COMSRANGTIEMPODET NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
     WHERE ID_COMISIONRANGOTIEMPODETALLE = @pk_ID_COMSRANGTIEMPODET;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	  
      SELECT ID_COMISIONRANGOTIEMPODETALLE,
             CODCOMISIONRANGOTIEMPO,
             RANGOINICIAL,
             RANGOFINAL,
             TARIFAPORCENTUAL,
             TARIFATRANSACIONAL,
             FIJO,
             ACTIVE
       FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
       WHERE ID_COMISIONRANGOTIEMPODETALLE = @pk_ID_COMSRANGTIEMPODET;
	
  END;
GO

  --Get List of Records Active or Inactive in the table COMISIONRANGOTIEMPODETALLE table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetList(@p_active NUMERIC(22,0)) AS
    BEGIN
    SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	  
    SELECT ID_COMISIONRANGOTIEMPODETALLE,
             CODCOMISIONRANGOTIEMPO,
             RANGOINICIAL,
             RANGOFINAL,
             TARIFAPORCENTUAL,
             TARIFATRANSACIONAL,
             FIJO,
             ACTIVE
       FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
    WHERE ACTIVE= @p_active;
	
    END;
GO

   --Delete Record in the COMISIONRANGOTIEMPODETALLE table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_DeleteRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_DeleteRecord(@pk_ID_COMSRANGTIEMPODET             NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
  UPDATE WSXML_SFG.COMISIONRANGOTIEMPODETALLE SET ACTIVE=0
  WHERE ID_COMISIONRANGOTIEMPODETALLE = @pk_ID_COMSRANGTIEMPODET;
  END;
GO
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetComrangotiemdetbycomisionrt', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetComrangotiemdetbycomisionrt;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPODETALLE_GetComrangotiemdetbycomisionrt(@p_CODCOMISIONRANGOTIEMPO NUMERIC(22,0)
                                           )
    as 
    begin
    set nocount on;
		  
           select  c.id_comisionrangotiempodetalle as ID_COMISIONRANGOTIEMPODETALLE,
                   c.rangoinicial as DESDERC,
                   c.rangofinal AS HASTARC,
                   c.tarifaporcentual AS VALORPORCENTUALRC,
                   c.tarifatransacional AS VALORTRANSACCIONALRC,
                   c.fijo AS VALORFIJORC
           from WSXML_SFG.comisionrangotiempodetalle c
           where c.codcomisionrangotiempo = @p_CODCOMISIONRANGOTIEMPO
           and c.active = 1;
		
    END;
GO





