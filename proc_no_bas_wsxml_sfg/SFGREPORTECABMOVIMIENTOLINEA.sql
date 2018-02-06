USE SFGPRODU;
--  DDL for Package Body SFGREPORTECABMOVIMIENTOLINEA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREPORTECABMOVIMIENTOLINEA */ 


 IF OBJECT_ID('WSXML_SFG.SFGREPORTECABMOVIMIENTOLINEA_GeneraArchivo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTECABMOVIMIENTOLINEA_GeneraArchivo;
GO

CREATE   PROCEDURE WSXML_SFG.SFGREPORTECABMOVIMIENTOLINEA_GeneraArchivo (@p_nombrearchivo            nvarchar(2000),
                      @p_fechagenerado             datetime,
                     @p_codusuariomodificacion    NUMERIC(22,0)) AS
 BEGIN

   DECLARE @pk_id_reportecabmovimiento NUMERIC(22,0) =0;

    
   SET NOCOUNT ON;
    insert into WSXML_SFG.reportecabmovimientolineas
      ( nombrearchivo
      , fechagenerado
      , fechahoramodificacion
      , codusuariomodificacion)
    values
      (
 @p_nombrearchivo
      , @p_fechagenerado
      , getdate()
      , @p_codusuariomodificacion);
      SET @pk_id_reportecabmovimiento = SCOPE_IDENTITY();

		EXEC WSXML_SFG.sfgreportemovimientolineas_UpdateRecordGenerado @pk_id_reportecabmovimiento,1

          select
          C.NUMEROCUENTA AS CUENTA
          , b.codsuperfinanc AS OFICINAORIGEN
          , CASE WHEN C.CODTIPOCUENTA =2 THEN '7' ELSE '1' END AS TIPOCUENTA
          ,FORMAT(DP.FECHAPAGO,'ddMMyyyy') AS FECHA
          , isnull(MPNR.DOCUMENTO,0) AS DOCUMENTO
          , CASE WHEN DP.VALORPAGO < 0 THEN '-' ELSE '0' END AS SIGNOVALOR
          , ABS(DP.VALORPAGO) AS VALOR
          , ISNULL(MB.CODIGOFIDUCIA,0) AS NUMEROINTERNO
          , ISNULL(COALESCE(MPR.NUMEROREFERENCIA,MB.NOMMOVIMIENTOBANCO),'Extracto')  AS NOMBREEXTRACTO
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
          LEFT OUTER JOIN MOVIMIENTOBANCO MB ON CP.CODMOVIMIENTOBANCO = MB.ID_MOVIMIENTOBANCO
          --WHERE rml.codreportecabmovimientolineas = pk_id_reportecabmovimiento
          ;



  END;
GO


