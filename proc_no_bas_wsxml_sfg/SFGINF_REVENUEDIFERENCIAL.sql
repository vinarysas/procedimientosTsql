USE SFGPRODU;
--  DDL for Package Body SFGINF_REVENUEDIFERENCIAL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_REVENUEDIFERENCIAL */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueYTDKioskos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueYTDKioskos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueYTDKioskos(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
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
      SELECT /*+ push_pred(PRF) */
             AES.NOMALIADOESTRATEGICO                       AS ALIADO,
             AGP.NOMAGRUPACIONPRODUCTO                      AS PADRE,
             PRD.CODIGOGTECHPRODUCTO                        AS CODIGOPRODUCTO,
             PRD.NOMPRODUCTO                                AS SUBPRODUCTO,
             SUM(NumIngresos - NumAnulaciones)              AS CANTIDADINGRESOS,
             SUM(IngresosBrutosNoRedondeo)                  AS INGRESOS,
             SUM(RevenueBase)                               AS REVENUBASE,
             SUM(RevenueTransaccion)                        AS RANGOS,
             SUM(RevenueFijo)                               AS FIJO,
             SUM(RevenueTotal)                              AS REVENUETOTAL,
             SUM(IngresoCorporativo)                        AS INGCORPORATIVO,
             SUM(IngresoLocal)                              AS INGLOCAL,
             SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2)
                      THEN Comision ELSE 0 END)             AS INGRESOPDVADMIN,
             SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV = 3
                      THEN Comision ELSE 0 END)             AS INGRESOPDVCOLAB,
             SUM(EgresoLocal)                               AS COSTOVENTA,
             SUM(CostoICA)                                  AS ICA,
             SUM(CostoEtesa)                                AS COMISIONETESA,
             SUM(CostoIC)                                   AS IC,
             SUM(CostoICAIC)                                AS ICAIC,
             SUM(CostoBadDebt)                              AS BADDEBT,
             SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
             SUM(CostoIvaNoDescontable)                     AS IVANODESC,
             SUM(CostoIC108)                                AS IC108,
             SUM(CostoICAIC108)                             AS ICAIC108,
             SUM(UtilidadParcial)                           AS UTILIDADPARCIAL
      FROM WSXML_SFG.VW_REVENUE_DIARIO PRF
      INNER JOIN PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO)
      INNER JOIN ALIADOESTRATEGICO      AES ON (AES.ID_ALIADOESTRATEGICO  = PRD.CODALIADOESTRATEGICO)
      INNER JOIN AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
      INNER JOIN PUNTODEVENTA           PDV ON (PDV.ID_PUNTODEVENTA       = PRF.CODPUNTODEVENTA)
      WHERE 1=1 --PRF.FECHAARCHIVO BETWEEN TRUNC(@sFECHAFRST, 'YYYY') AND @sFECHALAST
        AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
        AND PDV.CODTIPONEGOCIO    = 7
      GROUP BY AES.NOMALIADOESTRATEGICO, AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO, PRD.NOMPRODUCTO
      ORDER BY AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO;
  END;
  GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueYTDNoKioskos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueYTDNoKioskos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueYTDNoKioskos(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                   @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                   @pg_CADENA                NVARCHAR(2000),
                                   @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                  @pg_PRODUCTO              NVARCHAR(2000)
                                   ) AS
 GO
  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueRedAEL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueRedAEL;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueRedAEL(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                             @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                             @pg_CADENA                NVARCHAR(2000),
                             @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                            @pg_PRODUCTO              NVARCHAR(2000)
                             ) AS
 GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueRedNoAEL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueRedNoAEL;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEDIFERENCIAL_GetRevenueRedNoAEL(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                               @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                               @pg_CADENA                NVARCHAR(2000),
                               @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                              @pg_PRODUCTO              NVARCHAR(2000)
                               ) AS
GO

