USE SFGPRODU;
--  DDL for Package Body SFGPAGOFACTURACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPAGOFACTURACIONPDV */ 

IF OBJECT_ID('WSXML_SFG.SFGPAGOFACTURACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_AddRecord(@p_CODDETALLEPAGO             NUMERIC(22,0),
                      @p_CODMAESTROFACTURACIONPDV   NUMERIC(22,0),
                      @p_VALORAPLICADO              FLOAT,
                      @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                      @p_ID_PAGOFACTURACIONPDV_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.PAGOFACTURACIONPDV (
                                    CODDETALLEPAGO,
                                    CODMAESTROFACTURACIONPDV,
                                    VALORAPLICADO,
                                    CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODDETALLEPAGO,
            @p_CODMAESTROFACTURACIONPDV,
            @p_VALORAPLICADO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PAGOFACTURACIONPDV_out = SCOPE_IDENTITY();

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPAGOFACTURACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_UpdateRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_UpdateRecord(@pk_ID_PAGOFACTURACIONPDV     NUMERIC(22,0),
                         @p_CODDETALLEPAGO             NUMERIC(22,0),
                         @p_CODMAESTROFACTURACIONPDV   NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                         @p_ACTIVE                     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PAGOFACTURACIONPDV
       SET CODDETALLEPAGO             = @p_CODDETALLEPAGO,
           CODMAESTROFACTURACIONPDV   = @p_CODMAESTROFACTURACIONPDV,
           CODUSUARIOMODIFICACION     = @p_CODUSUARIOMODIFICACION,
           ACTIVE                     = @p_ACTIVE
     WHERE ID_PAGOFACTURACIONPDV = @pk_ID_PAGOFACTURACIONPDV;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPAGOFACTURACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_GetRecord;
GO


  CREATE PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_GetRecord(@pk_ID_PAGOFACTURACIONPDV NUMERIC(22,0)
                                                             ) AS
 BEGIN
    DECLARE @l_count NUMERIC(22,0);
   
  SET NOCOUNT ON;

    -- Get the rowcount first and make sure only one row is returned
    SELECT @l_count = COUNT(*)
    FROM WSXML_SFG.PAGOFACTURACIONPDV
    WHERE ID_PAGOFACTURACIONPDV = @pk_ID_PAGOFACTURACIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be returned along the row data to support concurrency.
      
	  SELECT ID_PAGOFACTURACIONPDV,
             CODDETALLEPAGO,
             CODMAESTROFACTURACIONPDV,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.PAGOFACTURACIONPDV
      WHERE ID_PAGOFACTURACIONPDV = @pk_ID_PAGOFACTURACIONPDV;
	  

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPAGOFACTURACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_GetList;
GO


  CREATE PROCEDURE WSXML_SFG.SFGPAGOFACTURACIONPDV_GetList(@p_active NUMERIC(22,0)
                                                           ) AS
  BEGIN
  SET NOCOUNT ON;

    -- Get the row from the query.  Checksum value will be returned along the row data to support concurrency.
      
	  SELECT ID_PAGOFACTURACIONPDV,
             CODDETALLEPAGO,
             CODMAESTROFACTURACIONPDV,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.PAGOFACTURACIONPDV
      WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	  
  END;
GO






