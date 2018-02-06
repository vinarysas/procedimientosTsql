USE SFGPRODU;
--  DDL for Package Body SFGINF_FACTXCONTRATOPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_FACTXCONTRATOPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_FACTXCONTRATOPDV_GetWeeklyDiscInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTXCONTRATOPDV_GetWeeklyDiscInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_FACTXCONTRATOPDV_GetWeeklyDiscInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                              @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                              @pg_CADENA                NVARCHAR(2000),
                              @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                             @pg_PRODUCTO              NVARCHAR(2000)
                              ) AS
  
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_FACTXCONTRATOPDV_GetMonthlyDiscInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTXCONTRATOPDV_GetMonthlyDiscInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_FACTXCONTRATOPDV_GetMonthlyDiscInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                               @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                               @pg_CADENA                NVARCHAR(2000),
                               @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                              @pg_PRODUCTO              NVARCHAR(2000)
                               ) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    --SFG_PACKAGE.GetMonthRange(@sFECHACCLO, @sFECHAFRST, @sFECHALAST);
      SELECT LDN.NOMLINEADENEGOCIO                     AS NOMLINEADENEGOCIO,
             TPR.NOMTIPOPRODUCTO                       AS NOMTIPOPRODUCTO,
             AGP.NOMAGRUPACIONPRODUCTO                 AS NOMAGRUPACIONPRODUCTO,
             TCT.NOMTIPOCONTRATOPDV                    AS NOMTIPOCONTRATOPDV,
             SUM(ISNULL(NUMINGRESOS - NUMANULACIONES, 0)) AS CANTIDADINGRESOS,
             SUM(ISNULL(INGRESOS - ANULACIONES, 0))       AS VALORINGRESOS,
             SUM(ISNULL(IVAPRODUCTO, 0))                  AS IVAPRODUCTO,
             SUM(ISNULL(PRF.DESCUENTOS, 0))               AS DESCUENTOS,
             SUM(ISNULL(INGRESOSBRUTOS, 0))               AS INGRESOSBRUTOS,
             SUM(ISNULL(COMISION, 0))                     AS COMISION,
             SUM(ISNULL(COMISIONANTICIPO, 0))             AS COMISIONANTICIPO,
             SUM(ISNULL(TOTALCOMISION, 0))                AS TOTALCOMISION,
             SUM(ISNULL(IVACOMISION, 0))                  AS IVACOMISION,
             SUM(ISNULL(COMISIONBRUTA, 0))                AS COMISIONBRUTA,
             SUM(ISNULL(RETEFUENTE, 0))                   AS RETEFUENTE,
             SUM(ISNULL(RETEIVA, 0))                      AS RETEIVA,
             SUM(ISNULL(RETEICA, 0))                      AS RETEICA,
             SUM(ISNULL(RETECREE, 0))                     AS RETECREE,
             SUM(ISNULL(COMISIONNETA, 0))                 AS COMISIONNETA,
             SUM(ISNULL(PREMIOSPAGADOS, 0))               AS PREMIOSPAGADOS
      FROM WSXML_SFG.LINEADENEGOCIO LDN
      INNER JOIN TIPOPRODUCTO           TPR ON (LDN.ID_LINEADENEGOCIO     = TPR.CODLINEADENEGOCIO)
      INNER JOIN AGRUPACIONPRODUCTO     AGP ON (TPR.ID_TIPOPRODUCTO       = AGP.CODTIPOPRODUCTO)
      INNER JOIN PRODUCTO               PRD ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
      INNER JOIN TIPOCONTRATOPDV        TCT ON (1 = 1)
      LEFT OUTER JOIN (SELECT CODPRODUCTO, CODTIPOCONTRATOPDV,
                              SUM(PRF.NUMINGRESOS)              AS NUMINGRESOS,
                              SUM(PRF.NUMANULACIONES)           AS NUMANULACIONES,
                              SUM(PRF.INGRESOS)                 AS INGRESOS,
                              SUM(PRF.ANULACIONES)              AS ANULACIONES,
                              SUM(PRF.INGRESOSVALIDOS)          AS INGRESOSVALIDOS,
                              SUM(PRF.IVAPRODUCTO)              AS IVAPRODUCTO,
                              SUM(PRF.DESCUENTOS)               AS DESCUENTOS,
                              SUM(PRF.INGRESOSBRUTOS)           AS INGRESOSBRUTOS,
                              SUM(PRF.COMISION)                 AS COMISION,
                              SUM(PRF.COMISIONANTICIPO)         AS COMISIONANTICIPO,
                              SUM(COMISION + COMISIONANTICIPO)  AS TOTALCOMISION,
                              SUM(PRF.IVACOMISION)              AS IVACOMISION,
                              SUM(PRF.COMISIONBRUTA)            AS COMISIONBRUTA,
                              SUM(PRF.RETEFUENTE + PRF.RETEUVT) AS RETEFUENTE,
                              SUM(PRF.RETEIVA)                  AS RETEIVA,
                              SUM(PRF.RETEICA)                  AS RETEICA,
                              SUM(PRF.RETECREE)                 AS RETECREE,
                              SUM(PRF.COMISIONNETA)             AS COMISIONNETA,
                              SUM(PRF.PREMIOSPAGADOS)           AS PREMIOSPAGADOS
                       FROM WSXML_SFG.VW_PREFACTURACION_DIARIA PRF
                       WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
                         AND PRF.CODLINEADENEGOCIO  = @p_CODLINEADENEGOCIO
                         AND @pg_CADENA              = @pg_CADENA
                         AND @pg_ALIADOESTRATEGICO   = @pg_ALIADOESTRATEGICO
                         AND @pg_PRODUCTO            = @pg_PRODUCTO
                       GROUP BY CODPRODUCTO, CODTIPOCONTRATOPDV) PRF ON (PRD.ID_PRODUCTO        = PRF.CODPRODUCTO
                                                                     AND TCT.ID_TIPOCONTRATOPDV = PRF.CODTIPOCONTRATOPDV)
      WHERE LDN.ID_LINEADENEGOCIO = @p_CODLINEADENEGOCIO
      GROUP BY LDN.ID_LINEADENEGOCIO, LDN.NOMLINEADENEGOCIO, TPR.NOMTIPOPRODUCTO, AGP.NOMAGRUPACIONPRODUCTO, TCT.NOMTIPOCONTRATOPDV
      ORDER BY LDN.ID_LINEADENEGOCIO, TPR.NOMTIPOPRODUCTO, AGP.NOMAGRUPACIONPRODUCTO, TCT.NOMTIPOCONTRATOPDV;
  END
GO
