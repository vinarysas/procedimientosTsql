USE SFGPRODU;
--  DDL for Package Body SFGREPORTEMOVIMIENTOLINEAS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS */ 

  IF OBJECT_ID('WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_AddRecord(@p_CODDETALLEPAGO                 NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION         NUMERIC(22,0),
                      @p_REPORTEMOVIMIENTOLINEAS_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.REPORTEMOVIMIENTOLINEAS
      ( CODDETALLEPAGO
      , FECHAHORAMODIFICACION
      , CODUSUARIOMODIFICACION)
    values
      (
 @p_CODDETALLEPAGO
      , getdate()
      , @p_CODUSUARIOMODIFICACION);
      SET @p_REPORTEMOVIMIENTOLINEAS_out = SCOPE_IDENTITY()
    ;

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_GetRecordInsert', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_GetRecordInsert;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_GetRecordInsert(@p_CODDETALLEPAGO           NUMERIC(22,0)
                            ) AS
  BEGIN
  SET NOCOUNT ON;
      select
       DP.ID_DETALLEPAGO
      from
        WSXML_SFG.DETALLEPAGO DP
        INNER JOIN  WSXML_SFG.CTRLPAGO CP ON DP.CODCTRLPAGO= CP.ID_CTRLPAGO
        INNER JOIN WSXML_SFG.ARCHIVOPAGO AP ON CP.CODARCHIVOPAGO=AP.ID_ARCHIVOPAGO
        INNER JOIN WSXML_SFG.CUENTA C ON AP.CODCUENTA=C.ID_CUENTA
        WHERE DP.ID_DETALLEPAGO = @p_CODDETALLEPAGO
        AND C.PERMITIRMOVLINEAS = 1

    ;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_GetList(@p_GENERADO           NUMERIC(22,0)
                            ) AS
  BEGIN
  SET NOCOUNT ON;
      select
          C.NUMEROCUENTA AS CUENTA
          , b.codsuperfinanc AS OFICINAORIGEN
          , CASE WHEN C.CODTIPOCUENTA =2 THEN '7' ELSE '1' END AS TIPOCUENTA
          ,FORMAT(DP.FECHAPAGO,'ddMMyyyy') AS FECHA
          , isnull(MPNR.DOCUMENTO,0) AS DOCUMENTO
          , CASE WHEN DP.VALORPAGO < 0 THEN '-' ELSE '0' END AS SIGNOVALOR
          , ABS(DP.VALORPAGO) AS VALOR
          , ISNULL(MB.CODIGOFIDUCIA,0) AS NUMEROINTERNO
          , COALESCE(MPR.NUMEROREFERENCIA,MB.NOMMOVIMIENTOBANCO)  AS NOMBREEXTRACTO
          ,  isnull(MPNR.CAUSALDEVOLUCION,0) AS CAUSALDEVOLUCION
          , DP.ID_DETALLEPAGO AS NUMERO
          FROM
           WSXML_SFG.DETALLEPAGO DP
          LEFT JOIN  WSXML_SFG.REPORTEMOVIMIENTOLINEAS RML ON DP.ID_DETALLEPAGO = RML.CODDETALLEPAGO
          LEFT JOIN WSXML_SFG.REPORTECABMOVIMIENTOLINEAS CRML ON RML.CODREPORTECABMOVIMIENTOLINEAS = CRML.ID_REPORTECABMOVIMIENTOLINEAS
          LEFT JOIN WSXML_SFG.MEDIOPAGONOREF MPNR ON MPNR.CODDETALLEPAGO = DP.ID_DETALLEPAGO
          LEFT JOIN WSXML_SFG.MEDIOPAGOREF MPR ON MPR.CODDETALLEPAGO = DP.ID_DETALLEPAGO
          INNER JOIN  WSXML_SFG.CTRLPAGO CP ON DP.CODCTRLPAGO= CP.ID_CTRLPAGO
          INNER JOIN WSXML_SFG.ARCHIVOPAGO AP ON CP.CODARCHIVOPAGO=AP.ID_ARCHIVOPAGO
          INNER JOIN WSXML_SFG.CUENTA C ON AP.CODCUENTA=C.ID_CUENTA
          inner join WSXML_SFG.banco  b on c.codigobanco = b.id_banco
          LEFT OUTER JOIN WSXML_SFG.MOVIMIENTOBANCO MB ON CP.CODMOVIMIENTOBANCO = MB.ID_MOVIMIENTOBANCO

    ;

  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_UpdateRecord(@pk_id_reportemovimientolineas       NUMERIC(22,0),
                         @p_coddetallepago                    NUMERIC(22,0),
                         @p_generado                          NUMERIC(22,0),
                         @p_codusuariomodificacion            NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    update WSXML_SFG.reportemovimientolineas
    set
         coddetallepago = @p_coddetallepago,
         generado = @p_generado,
         fechahoramodificacion = getdate(),
         codusuariomodificacion = @p_codusuariomodificacion
    where id_reportemovimientolineas = @pk_id_reportemovimientolineas;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_UpdateRecordGenerado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_UpdateRecordGenerado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTEMOVIMIENTOLINEAS_UpdateRecordGenerado
                         (@p_codreportecabmovlineas      NUMERIC(22,0),

                         @p_generado                     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
  update WSXML_SFG.reportemovimientolineas
    set
         generado = @p_generado
         , codreportecabmovimientolineas = @p_codreportecabmovlineas
    where generado = 0;

  END;
GO

