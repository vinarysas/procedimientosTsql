USE SFGPRODU;
--  DDL for Package Body SFGCTRLPAGO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCTRLPAGO */ 
  IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_AddRecord(@p_CODORIGENPAGO          NUMERIC(22,0),
                      @p_CODARCHIVOPAGO         NUMERIC(22,0),
                      @p_CODTIPOPAGO             NUMERIC(22,0),
                      @p_CODMOVIMIENTOBANCO     NUMERIC(22,0),
                      @p_FECHACARGUE            DATETIME,
                      @p_TOTALTRANSACCION       FLOAT,
                      @p_TOTALREGISTROS         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_CTRLPAGO_out        NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CTRLPAGO (
                          CODORIGENPAGO,
                          CODARCHIVOPAGO,
                          CODTIPOPAGO,
                          CODMOVIMIENTOBANCO,
                          FECHACARGUE,
                          TOTALTRANSACCION,
                          TOTALREGISTROS,
                          CODUSUARIOMODIFICACION)
      VALUES (
              @p_CODORIGENPAGO,
              @p_CODARCHIVOPAGO,
              @p_CODTIPOPAGO,
              @p_CODMOVIMIENTOBANCO,
              @p_FECHACARGUE,
              @p_TOTALTRANSACCION,
              @p_TOTALREGISTROS,
              @p_CODUSUARIOMODIFICACION);
      SET @p_ID_CTRLPAGO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_AddRecordFromFile', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_AddRecordFromFile;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_AddRecordFromFile(@p_CODORIGENPAGO           NUMERIC(22,0),
                              @p_CODARCHIVOPAGO          NUMERIC(22,0),
                              @p_CODTIPOPAGO             NUMERIC(22,0),
                              @p_FECHACARGUE             DATETIME,
                              @p_TOTALTRANSACCION        FLOAT,
                              @p_TOTALREGISTROS          NUMERIC(22,0),
                              @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                              @p_ID_CTRLPAGO_out         NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CTRLPAGO (
                          CODORIGENPAGO,
                          CODARCHIVOPAGO,
                          CODTIPOPAGO,
                          FECHACARGUE,
                          TOTALTRANSACCION,
                          TOTALREGISTROS,
                          CODUSUARIOMODIFICACION)
      VALUES (
              @p_CODORIGENPAGO,
              @p_CODARCHIVOPAGO,
              @p_CODTIPOPAGO,
              @p_FECHACARGUE,
              @p_TOTALTRANSACCION,
              @p_TOTALREGISTROS,
              @p_CODUSUARIOMODIFICACION);
      SET @p_ID_CTRLPAGO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_AddRecordFromMovement', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_AddRecordFromMovement;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_AddRecordFromMovement(@p_CODORIGENPAGO           NUMERIC(22,0),
                                  @p_CODARCHIVOPAGO          NUMERIC(22,0),
                                  @p_CODMOVIMIENTOBANCO      NUMERIC(22,0),
                                  @p_FECHACARGUE             DATETIME,
                                  @p_TOTALTRANSACCION        FLOAT,
                                  @p_TOTALREGISTROS          NUMERIC(22,0),
                                  @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                                  @p_ID_CTRLPAGO_out         NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

  DECLARE @REFERENCIADO  TINYINT ,@NOREFRNCIADO  TINYINT ,@MVMNTMAJUSTE TINYINT 
  EXEC WSXML_SFG.SFGTIPOPAGO_CONSTANT @REFERENCIADO OUT,@NOREFRNCIADO OUT,@MVMNTMAJUSTE OUT

    INSERT INTO WSXML_SFG.CTRLPAGO (
                          CODORIGENPAGO,
                          CODARCHIVOPAGO,
                          CODMOVIMIENTOBANCO,
                          FECHACARGUE,
                          TOTALTRANSACCION,
                          TOTALREGISTROS,
                          CODTIPOPAGO,
                          CODUSUARIOMODIFICACION)
      VALUES (
              @p_CODORIGENPAGO,
              @p_CODARCHIVOPAGO,
              @p_CODMOVIMIENTOBANCO,
              @p_FECHACARGUE,
              @p_TOTALTRANSACCION,
              @p_TOTALREGISTROS,
              @NOREFRNCIADO,
              @p_CODUSUARIOMODIFICACION);
      SET @p_ID_CTRLPAGO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_UpdateRecord(@pk_ID_CTRLPAGO           NUMERIC(22,0),
                         @p_CODORIGENPAGO          NUMERIC(22,0),
                         @p_CODARCHIVOPAGO         NUMERIC(22,0),
                         @p_CODMOVIMIENTOBANCO      NUMERIC(22,0),
                         @p_FECHACARGUE            DATETIME,
                         @p_TOTALTRANSACCION       FLOAT,
                         @p_TOTALREGISTROS         NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.CTRLPAGO
       SET CODORIGENPAGO          = @p_CODORIGENPAGO,
           CODARCHIVOPAGO         = @p_CODARCHIVOPAGO,
           CODMOVIMIENTOBANCO      = @p_CODMOVIMIENTOBANCO,
           FECHACARGUE            = @p_FECHACARGUE,
           TOTALTRANSACCION       = @p_TOTALTRANSACCION,
           TOTALREGISTROS         = @p_TOTALREGISTROS,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_CTRLPAGO = @pk_ID_CTRLPAGO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetRecord(@pk_ID_CTRLPAGO NUMERIC(22,0))    AS
    BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.CTRLPAGO WHERE ID_CTRLPAGO = @pk_ID_CTRLPAGO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT A.ID_CTRLPAGO,
             A.CODORIGENPAGO,
             A.CODARCHIVOPAGO,
             A.CODMOVIMIENTOBANCO,
             A.FECHACARGUE,
             A.TOTALTRANSACCION,
             A.TOTALREGISTROS,
             A.CODUSUARIOMODIFICACION,
             A.FECHAHORAMODIFICACION,
             A.ACTIVE
      FROM WSXML_SFG.CTRLPAGO A
      WHERE A.ID_CTRLPAGO = @pk_ID_CTRLPAGO;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_CTRLPAGO,
             CODORIGENPAGO,
             CODARCHIVOPAGO,
             CODMOVIMIENTOBANCO,
             FECHACARGUE,
             TOTALTRANSACCION,
             TOTALREGISTROS,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.CTRLPAGO
      WHERE ACTIVE =  CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_GetListFechaProceso', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetListFechaProceso;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetListFechaProceso(@p_FECHACARGUE DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_CTRLPAGO,
             CODORIGENPAGO,
             CODARCHIVOPAGO,
             CODMOVIMIENTOBANCO,
             FECHACARGUE,
             TOTALTRANSACCION,
             TOTALREGISTROS,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.CTRLPAGO
      WHERE FECHACARGUE = @p_FECHACARGUE;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_GetPagosActuales', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetPagosActuales;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetPagosActuales(@p_NOMBREARCHIVO NVARCHAR(2000), @p_FECHAGENERACION DATETIME, @p_CODUSUARIOMODIFICACION NUMERIC(22,0), @p_CODLINEADENEGOCIO NUMERIC(22,0), @p_SECUENCIA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @p_id_pagoreportado NUMERIC(22,0);
   
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PAGOREPORTADO
      (
        nombrearchivO
        , fechageneracion
        , codusuariomodificacion
        , SECUENCIA
        , CODLINEADENEGOCIO
      )
    values
      (
 @p_NOMBREARCHIVO
        , @p_FECHAGENERACION
        , @p_CODUSUARIOMODIFICACION
        , @p_SECUENCIA
        , @p_CODLINEADENEGOCIO
      );
      SET @p_id_pagoreportado = SCOPE_IDENTITY()
      ;

  DECLARE t CURSOR FOR
        SELECT
          DISTINCT(DTP.ID_DETALLEPAGO) AS ID_DETALLEPAGO
        FROM WSXML_SFG.DETALLEPAGO DTP

          INNER JOIN WSXML_SFG.PAGOFACTURACIONPDV PFP ON DTP.ID_DETALLEPAGO = PFP.CODDETALLEPAGO
          INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP ON PFP.CODMAESTROFACTURACIONPDV=MFP.ID_MAESTROFACTURACIONPDV
        WHERE DTP.VALORPAGO > 0
          and MFP.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
          AND DTP.ID_DETALLEPAGO NOT IN
          (
                      SELECT CODDETALLEPAGO FROM
                      WSXML_SFG.DETALLEPAGOREPORTADO
          );
 OPEN t;
 
 DECLARE @l_ID_DETALLEPAGO NUMERIC(38,0)
 FETCH NEXT FROM t INTO @l_ID_DETALLEPAGO
        

 WHILE @@FETCH_STATUS=0
 BEGIN

      insert into WSXML_SFG.detallepagoreportado
        (
        codpagoreportado
        , coddetallepago
        , codusuariomodificacion)
      values
        (
 @p_id_pagoreportado
          , @l_ID_DETALLEPAGO
          , @p_CODUSUARIOMODIFICACION
        );
       FETCH NEXT FROM t INTO @l_ID_DETALLEPAGO
      END;

      CLOSE t;
      DEALLOCATE t;

      SELECT
		  RIGHT(REPLICATE('0', 8) + LEFT(PDV.CODIGOGTECHPUNTODEVENTA, 8), 8) as NUMERO
          , ROUND(SUM (PFP.VALORAPLICADO),0) AS VALORPAGO

        FROM WSXML_SFG.DETALLEPAGOREPORTADO DPR
          INNER JOIN  WSXML_SFG.PAGOFACTURACIONPDV PFP ON DPR.CODDETALLEPAGO = PFP.CODDETALLEPAGO
          INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP ON PFP.CODMAESTROFACTURACIONPDV=MFP.ID_MAESTROFACTURACIONPDV
          INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON MFP.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA
        WHERE
          CODPAGOREPORTADO = @p_id_pagoreportado
        group by PDV.CODIGOGTECHPUNTODEVENTA;

END;
GO

IF OBJECT_ID('WSXML_SFG.SFGCTRLPAGO_GetSecuenciaPagoReportado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetSecuenciaPagoReportado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLPAGO_GetSecuenciaPagoReportado(@p_Secuencia_OUT NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_Secuencia_OUT = ISNULL(MAX(SECUENCIA), 0) FROM WSXML_SFG.PAGOREPORTADO;
	IF @@ROWCOUNT = 0
		SET @p_Secuencia_OUT = 0;
  END;
GO







