USE SFGPRODU;
--  DDL for Package Body SFGDETALLECALENDARIO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLECALENDARIO */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALENDARIO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_AddRecord(@p_DESCRIPCION              NVARCHAR(2000),
                      @p_FECHA                    DATETIME,
                      @p_RECURRENCIAANUAL         NUMERIC(22,0),
                      @p_CODCALENDARIO            NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                      @p_ID_DETALLECALENDARIO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DETALLECALENDARIO (
                                     DESCRIPCION,
                                     FECHA,
                                     RECURRENCIAANUAL,
                                     CODCALENDARIO,
                                     CODUSUARIOMODIFICACION)
    VALUES (
            @p_DESCRIPCION,
            @p_FECHA,
            @p_RECURRENCIAANUAL,
            @p_CODCALENDARIO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DETALLECALENDARIO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALENDARIO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_UpdateRecord(@pk_ID_DETALLECALENDARIO    NUMERIC(22,0),
                         @p_DESCRIPCION              NVARCHAR(2000),
                         @p_FECHA                    DATETIME,
                         @p_RECURRENCIAANUAL         NUMERIC(22,0),
                         @p_CODCALENDARIO            NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                         @p_ACTIVE                   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLECALENDARIO
       SET DESCRIPCION            = @p_DESCRIPCION,
           FECHA                  = @p_FECHA,
           RECURRENCIAANUAL       = @p_RECURRENCIAANUAL,
           CODCALENDARIO          = @p_CODCALENDARIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_DETALLECALENDARIO   = @pk_ID_DETALLECALENDARIO;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALENDARIO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_GetRecord(@pk_ID_DETALLECALENDARIO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*) FROM WSXML_SFG.DETALLECALENDARIO
     WHERE ID_DETALLECALENDARIO = @pk_ID_DETALLECALENDARIO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_DETALLECALENDARIO,
             DESCRIPCION,
             FECHA,
             RECURRENCIAANUAL,
             CODCALENDARIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLECALENDARIO
       WHERE ID_DETALLECALENDARIO = @pk_ID_DETALLECALENDARIO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALENDARIO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_DETALLECALENDARIO,
             DESCRIPCION,
             FECHA,
             RECURRENCIAANUAL,
             CODCALENDARIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLECALENDARIO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALENDARIO_GetListRango', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_GetListRango;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALENDARIO_GetListRango(@p_active NUMERIC(22,0), @p_CODCALENDARIO NUMERIC(22,0), @p_FECHAINICIO DATETIME, @p_FECHAFIN DATETIME) AS
 BEGIN
    DECLARE @dFECHAINI DATETIME;
    DECLARE @dFECHAFIN DATETIME;
   
  SET NOCOUNT ON;

    -- Desde las 00:00 hasta las 23:59
    SELECT @dFECHAINI = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINICIO));
    SELECT @dFECHAFIN = (CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFIN)) + 1) - (1/86400);

      SELECT ID_DETALLECALENDARIO,
             DESCRIPCION,
             FECHA,
             RECURRENCIAANUAL,
             CODCALENDARIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLECALENDARIO
       WHERE (FECHA BETWEEN @dFECHAINI AND @dFECHAFIN
          OR (RECURRENCIAANUAL = 1
         
			AND CONVERT(DATETIME, FORMAT(FECHA,'dd-MM-')+datepart(year,@dFECHAINI)) BETWEEN @dFECHAINI AND @dFECHAFIN 
				OR CONVERT(DATETIME, FORMAT(FECHA,'dd-MM-')+datepart(year,@dFECHAFIN)) BETWEEN @dFECHAINI AND @dFECHAFIN 
			))
         AND CODCALENDARIO = @p_CODCALENDARIO
         AND ACTIVE = (CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END)

  END;
GO
