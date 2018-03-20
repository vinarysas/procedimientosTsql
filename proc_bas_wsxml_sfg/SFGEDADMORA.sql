USE SFGPRODU;
--  DDL for Package Body SFGEDADMORA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGEDADMORA */ 

IF OBJECT_ID('WSXML_SFG.SFGEDADMORA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEDADMORA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGEDADMORA_AddRecord(@p_RANGO_DESDE             NUMERIC(22,0),
                      @p_RANGO_HASTA             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ACTIVE                  NUMERIC(22,0),
                      @p_ID_EDADMORA_out         NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
     INSERT INTO WSXML_SFG.EDADMORA
        (
          RANGO_DESDE,
          RANGO_HASTA,
          CODUSUARIOMODIFICACION,
          ACTIVE)
      VALUES
        (
          @p_RANGO_DESDE,
          @p_RANGO_HASTA,
          @p_CODUSUARIOMODIFICACION,
          @p_ACTIVE);
      SET @p_ID_EDADMORA_out = SCOPE_IDENTITY();
  --  NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGEDADMORA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEDADMORA_UpdateRecord;
GO  
CREATE PROCEDURE WSXML_SFG.SFGEDADMORA_UpdateRecord(@pk_ID_EDADMORA    NUMERIC(22,0),
                          @p_RANGO_DESDE             NUMERIC(22,0),
                          @p_RANGO_HASTA             NUMERIC(22,0),
                          @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                          @p_ACTIVE                  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
    UPDATE WSXML_SFG.EDADMORA
       SET RANGO_DESDE            = @p_RANGO_DESDE,
           RANGO_HASTA            = @p_RANGO_HASTA,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_EDADMORA      = @pk_ID_EDADMORA;
	
	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
   -- NULL;
  END;
GO

 
IF OBJECT_ID('WSXML_SFG.SFGEDADMORA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEDADMORA_GetRecord;
GO
 
 CREATE PROCEDURE WSXML_SFG.SFGEDADMORA_GetRecord(@pk_ID_EDADMORA NUMERIC(22,0)
                                                  ) AS
 BEGIN
  DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    /* TODO implementation required */
    SELECT @l_count = count(*)
      FROM WSXML_SFG.EDADMORA
     WHERE ID_EDADMORA = @pk_ID_EDADMORA;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT A.ID_EDADMORA,
            A.RANGO_DESDE,
            A.RANGO_HASTA,
            A.ACTIVE
      FROM WSXML_SFG.EDADMORA A
      WHERE A.ID_EDADMORA = @pk_ID_EDADMORA;
    --NULL;
	
  END;
GO 

IF OBJECT_ID('WSXML_SFG.SFGEDADMORA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEDADMORA_GetList;
GO


CREATE PROCEDURE WSXML_SFG.SFGEDADMORA_GetList(@p_ACTIVE NUMERIC(22,0)
                                                ) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
      
	  SELECT  A.ID_EDADMORA,
              A.RANGO_DESDE,
              A.RANGO_HASTA,
              A.VALOR_DESDE,
              A.VALOR_HASTA,
              A.ACTIVE
      FROM WSXML_SFG.EDADMORA A
            WHERE A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END;
	

--    NULL;
  END;
GO






