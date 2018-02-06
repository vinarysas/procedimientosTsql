USE SFGPRODU;
--  DDL for Package Body SFGDETALLESALDOSUSPENSIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_AddRecord
                     (@p_CODSUSPENSIONPDV       NUMERIC(22,0),
                      @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_DETALLESALDOSUS_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.DETALLESALDOSUSPENSIONPDV (
                                             CODSUSPENSIONPDV,
                                             CODDETALLESALDOPDV,
                                             CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODSUSPENSIONPDV,
            @p_CODDETALLESALDOPDV,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DETALLESALDOSUS_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_UpdateRecord
                        (@pk_ID_DETALLESALDOSUSPN  NUMERIC(22,0),
                         @p_CODSUSPENSIONPDV       NUMERIC(22,0),
                         @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.DETALLESALDOSUSPENSIONPDV
       SET CODSUSPENSIONPDV          = @p_CODSUSPENSIONPDV,
           CODDETALLESALDOPDV        = @p_CODDETALLESALDOPDV,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION     = GETDATE(),
           ACTIVE                    = @p_ACTIVE
     WHERE ID_DETALLESALDOSUSPENSIONPDV = @pk_ID_DETALLESALDOSUSPN;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_GetRecord', 'P') IS NOT NULL
    DROP PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_GetRecord;
  GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_GetRecord
                    (@pk_ID_DETALLESALDOSUSPN NUMERIC(22,0)
					  ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.DETALLESALDOSUSPENSIONPDV
    WHERE ID_DETALLESALDOSUSPENSIONPDV = @pk_ID_DETALLESALDOSUSPN;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_DETALLESALDOSUSPENSIONPDV,
             CODSUSPENSIONPDV,
             CODDETALLESALDOPDV,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLESALDOSUSPENSIONPDV
       WHERE ID_DETALLESALDOSUSPENSIONPDV = @pk_ID_DETALLESALDOSUSPN;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLESALDOSUSPENSIONPDV_GetList
                     (@p_active NUMERIC(22,0)
					   ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT ID_DETALLESALDOSUSPENSIONPDV,
             CODSUSPENSIONPDV,
             CODDETALLESALDOPDV,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLESALDOSUSPENSIONPDV
        WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	    
  END;
GO






