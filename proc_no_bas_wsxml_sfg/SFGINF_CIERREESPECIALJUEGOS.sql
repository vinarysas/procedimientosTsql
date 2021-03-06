USE SFGPRODU;
--  DDL for Package Body SFGINF_CIERREESPECIALJUEGOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS_GetReporte83Data', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS_GetReporte83Data;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS_GetReporte83Data(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                             @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                             @pg_CADENA                NVARCHAR(2000),
                             @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                            @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
   EXEC  WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT
      SELECT PRF.CDC, PRF.FECHAARCHIVO,
             SUM(CASE WHEN PRF.CODIGOAGRUPACIONGTECH = 83 THEN PRF.PREMIOSPAGADOS ELSE 0 END) AS PREMIOSCAD83,
             SUM(CASE WHEN PRF.CODIGOAGRUPACIONGTECH = 83 THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPREMIOSCAD83,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV <> WSXML_SFG.RED_F('AEL') THEN PRF.INGRESOSVALIDOS ELSE 0 END) AS VENTASPAGATODOOTRAS,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV <> WSXML_SFG.RED_F('AEL') THEN PRF.IVAPRODUCTO ELSE 0 END) AS IVAPAGATODOOTRAS,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV <> WSXML_SFG.RED_F('AEL') THEN PRF.INGRESOSBRUTOS ELSE 0 END) AS VENTASBRUTASPAGATODOOTRAS,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV <> WSXML_SFG.RED_F('AEL') THEN PRF.PREMIOSPAGADOS ELSE 0 END) AS PREMIOSPAGATODOOTRAS,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV <> WSXML_SFG.RED_F('AEL') THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPREMIOSPAGATODOOTRAS
      FROM WSXML_SFG.VW_PREFACTURACIONREDONDEO PRF
      INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (PDV.ID_PUNTODEVENTA = PRF.CODPUNTODEVENTA)
      WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
        AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
      GROUP BY PRF.CDC, PRF.FECHAARCHIVO
      ORDER BY PRF.FECHAARCHIVO;
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS_GetReportePagatodoData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS_GetReportePagatodoData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CIERREESPECIALJUEGOS_GetReportePagatodoData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                   @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                   @pg_CADENA                NVARCHAR(2000),
                                   @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                  @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT
      SELECT PRF.CDC, PRF.FECHAARCHIVO,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10008 AND PDV.CODREDPDV = WSXML_SFG.RED_F('QAP') THEN PRF.INGRESOSVALIDOS ELSE 0 END)  AS VENTAPAGANTIOQUIAQAP,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10008 AND PDV.CODREDPDV = WSXML_SFG.RED_F('QAP') THEN PRF.IVAPRODUCTO ELSE 0 END)      AS IVAPAGANTIOQUIAQAP,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10008 AND PDV.CODREDPDV = WSXML_SFG.RED_F('QAP') THEN PRF.INGRESOSBRUTOS ELSE 0 END)   AS VENTABRUTAPAGANTIOQUIAQAP,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10008 AND PDV.CODREDPDV = WSXML_SFG.RED_F('QAP') THEN PRF.PREMIOSPAGADOS ELSE 0 END)   AS PREMIOSPAGANTIOQUIAQAP,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10008 AND PDV.CODREDPDV = WSXML_SFG.RED_F('QAP') THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPAGANTIOQUIAQAP,

             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV = WSXML_SFG.RED_F('AEL') THEN PRF.INGRESOSVALIDOS ELSE 0 END)  AS VENTAPAGCUNDINAMAEL,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV = WSXML_SFG.RED_F('AEL') THEN PRF.IVAPRODUCTO ELSE 0 END)      AS IVAPAGCUNDINAMAEL,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV = WSXML_SFG.RED_F('AEL') THEN PRF.INGRESOSBRUTOS ELSE 0 END)   AS VENTABRUTAPAGCUNDINAMAEL,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV = WSXML_SFG.RED_F('AEL') THEN PRF.PREMIOSPAGADOS ELSE 0 END)   AS PREMIOSPAGCUNDINAMAEL,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10003 AND PDV.CODREDPDV = WSXML_SFG.RED_F('AEL') THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPAGCUNDINAMAEL,

             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10001 AND PDV.CODREDPDV = WSXML_SFG.RED_F('SEAPTO') THEN PRF.INGRESOSVALIDOS ELSE 0 END)  AS VENTAPAGGANASEAPTO,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10001 AND PDV.CODREDPDV = WSXML_SFG.RED_F('SEAPTO') THEN PRF.IVAPRODUCTO ELSE 0 END)      AS IVAPAGGANASEAPTO,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10001 AND PDV.CODREDPDV = WSXML_SFG.RED_F('SEAPTO') THEN PRF.INGRESOSBRUTOS ELSE 0 END)   AS VENTABRUTAPAGGANASEAPTO,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10001 AND PDV.CODREDPDV = WSXML_SFG.RED_F('SEAPTO') THEN PRF.PREMIOSPAGADOS ELSE 0 END)   AS PREMIOSPAGGANASEAPTO,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10001 AND PDV.CODREDPDV = WSXML_SFG.RED_F('SEAPTO') THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPAGGANASEAPTO,

             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10013 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APOSTAR') THEN PRF.INGRESOSVALIDOS ELSE 0 END)  AS VENTAPAGRISARALDAPOSTAR,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10013 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APOSTAR') THEN PRF.IVAPRODUCTO ELSE 0 END)      AS IVAPAGRISARALDAPOSTAR,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10013 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APOSTAR') THEN PRF.INGRESOSBRUTOS ELSE 0 END)   AS VENTABRUTAPAGRISARALDAPOSTAR,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10013 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APOSTAR') THEN PRF.PREMIOSPAGADOS ELSE 0 END)   AS PREMIOSPAGRISARALDAPOSTAR,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10013 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APOSTAR') THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPAGRISARALDAPOSTAR,

             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10017 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APUESTAS 8A') THEN PRF.INGRESOSVALIDOS ELSE 0 END)  AS VENTAPAGQUINDIOCHOA,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10017 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APUESTAS 8A') THEN PRF.IVAPRODUCTO ELSE 0 END)      AS IVAPAGQUINDIOCHOA,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10017 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APUESTAS 8A') THEN PRF.INGRESOSBRUTOS ELSE 0 END)   AS VENTABRUTAPAGQUINDIOCHOA,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10017 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APUESTAS 8A') THEN PRF.PREMIOSPAGADOS ELSE 0 END)   AS PREMIOSPAGQUINDIOCHOA,
             SUM(CASE WHEN PRF.CODIGOGTECHPRODUCTO = 10017 AND PDV.CODREDPDV = WSXML_SFG.RED_F('APUESTAS 8A') THEN PRF.RETENCIONPREMIOS ELSE 0 END) AS RETENCIONPAGQUINDIOCHOA

      FROM WSXML_SFG.VW_PREFACTURACIONREDONDEO PRF
      INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (PDV.ID_PUNTODEVENTA = PRF.CODPUNTODEVENTA)
      WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
        AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
      GROUP BY PRF.CDC, PRF.FECHAARCHIVO
      ORDER BY PRF.FECHAARCHIVO;
  END;

GO


