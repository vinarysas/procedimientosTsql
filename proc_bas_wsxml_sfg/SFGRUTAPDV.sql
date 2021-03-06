USE SFGPRODU;
--  DDL for Package Body SFGRUTAPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGRUTAPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGRUTAPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRUTAPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRUTAPDV_AddRecord(@p_NOMRUTAPDV             NVARCHAR(2000),
                      @p_CODFMR                 NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_CODREGIONAL            NUMERIC(22,0),
                      @p_ID_RUTAPDV_out         NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.RUTAPDV (
                         NOMRUTAPDV,
                         CODFMR,
                         CODREGIONAL,
                         CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMRUTAPDV,
            CASE WHEN @p_CODFMR > 0 THEN @p_CODFMR ELSE NULL END,
            CASE WHEN @p_CODREGIONAL > 0 THEN @p_CODREGIONAL ELSE NULL END, 
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_RUTAPDV_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRUTAPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRUTAPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRUTAPDV_UpdateRecord(@pk_ID_RUTAPDV            NUMERIC(22,0),
                         @p_NOMRUTAPDV             NVARCHAR(2000),
                         @p_CODFMR                 NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.RUTAPDV
       SET NOMRUTAPDV             = @p_NOMRUTAPDV,
           CODFMR                 = CASE WHEN @p_CODFMR > 0 THEN @p_CODFMR ELSE 0 END,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_RUTAPDV             = @pk_ID_RUTAPDV;
  END;
GO
  
  IF OBJECT_ID('WSXML_SFG.SFGRUTAPDV_UpdateFMR', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRUTAPDV_UpdateFMR;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRUTAPDV_UpdateFMR(@pk_ID_RUTAPDV NUMERIC(22,0),
                      @p_CODFMR      NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.RUTAPDV
       SET CODFMR     = CASE WHEN @p_CODFMR > 0 THEN @p_CODFMR ELSE 0 END
     WHERE ID_RUTAPDV = @pk_ID_RUTAPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRUTAPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRUTAPDV_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGRUTAPDV_GetRecord(@pk_ID_RUTAPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.RUTAPDV
     WHERE ID_RUTAPDV = @pk_ID_RUTAPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT R.ID_RUTAPDV,
             R.NOMRUTAPDV,
             R.CODFMR,
             F.CODUSUARIO,
             U.NOMUSUARIO,
             R.FECHAHORAMODIFICACION,
             R.CODUSUARIOMODIFICACION,
             R.ACTIVE
      FROM WSXML_SFG.RUTAPDV R
      LEFT OUTER JOIN FMR F
        ON (F.ID_FMR = R.CODFMR)
      LEFT OUTER JOIN USUARIO U
        ON (U.ID_USUARIO = F.CODUSUARIO)
      WHERE ID_RUTAPDV = @pk_ID_RUTAPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRUTAPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRUTAPDV_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGRUTAPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT R.ID_RUTAPDV,
             R.NOMRUTAPDV,
             R.CODFMR,
             F.CODUSUARIO,
             U.NOMUSUARIO,
             R.FECHAHORAMODIFICACION,
             R.CODUSUARIOMODIFICACION,
             R.ACTIVE
      FROM WSXML_SFG.RUTAPDV R
      LEFT OUTER JOIN FMR F
        ON (F.ID_FMR = R.CODFMR)
      LEFT OUTER JOIN USUARIO U
        ON (U.ID_USUARIO = F.CODUSUARIO)
      WHERE R.ACTIVE = CASE WHEN @p_active = -1 THEN R.ACTIVE ELSE @p_active END;

  END;
GO






