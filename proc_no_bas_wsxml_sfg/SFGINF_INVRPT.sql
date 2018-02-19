USE SFGPRODU;
--  DDL for Package Body SFGINF_INVRPT
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_INVRPT */ 

/* Obtiene valores facturados por punto de venta */
IF OBJECT_ID('WSXML_SFG.SFGINF_INVRPT_GetReportData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_INVRPT_GetReportData;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_INVRPT_GetReportData(
  @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
  @pg_CADENA                NVARCHAR(2000),
  @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
  @pg_PRODUCTO              NVARCHAR(2000)
) AS
BEGIN
SET NOCOUNT ON;
  -- Balanced workload
  SELECT PDV.CODAGRUPACIONPUNTODEVENTA        AS ID_AGRUPACIONPUNTODEVENTA,
         PDV.CODIGOGTECHPUNTODEVENTA          AS PTOVTA,
         PDV.NUMEROTERMINAL                   AS TERM,
         pdvsag.CodigoPuntoVentaExternoLargo  AS CODIGO_EXTERNO,
         round(VPVF.VALORVENTA,22)              AS INGRESOS,
         round(VPVF.VALORANULACION,22)          AS ANULACION,
         round(VPVF.IMPUESTO_IVA,22)            AS IVA,
         round(VPVF.VALORVENTABRUTA,22)         AS INGRESO_BRUTO,
         round(VPVF.VALORPREMIOPAGO,22)         AS PAGOS_REALIZADOS,
         round(VALORCOMISION,22)                AS COMISION_CALCULADA,
         round(VATCOMISION,22)                  AS VAT_COMISION,
         round(VPVF.VALORCOMISIONBRUTA,22)      AS COMISIONES_BRUTAS,
         round(VPVF.RETENCION_RENTA,22)         AS RETERENTA,
         round(VPVF.RETENCION_RETEICA,22)       AS RETEICA,
         round(VPVF.RETENCION_RETEIVA,22)       AS RETEIVA,
         round(VPVF.RETENCION_RETECREE,22)      AS RETECREE,
         round(VPVF.VALORCOMISIONNETA,22)       AS COMISIONES_NETAS,
         round(VPVF.AJUSTES,22)                 AS AJUSTES,
         round(VLDF.SALDOANTERIORENCONTRAGTECH - VLDF.SALDOANTERIORAFAVORGTECH,22)
                                              AS BALANCEPREVIOGTECH,
         round(VLDF.SALDOANTERIORENCONTRAFIDUCIA - VLDF.SALDOANTERIORAFAVORFIDUCIA,22)
                                              AS BALANCEPREVIOFIDUCIA,
         round(VLDF.NUEVOSALDOENCONTRAGTECH - VLDF.NUEVOSALDOAFAVORGTECH,22)
                                              AS TOTALAPAGARGTECH,
         round(VLDF.NUEVOSALDOENCONTRAFIDUCIA - VLDF.NUEVOSALDOAFAVORFIDUCIA,22)
                                              AS TOTALAPAGARFIDUCIA,
         round(VPVF.RETENCIONPREMIOSPAGADOS,22) AS RETEFUENTE
  FROM WSXML_SFG.CICLOFACTURACIONPDV CFP
  INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (1 = 1)
  INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (1 = 1)
  LEFT OUTER JOIN (SELECT ID_CICLOFACTURACIONPDV,
                          ID_PUNTODEVENTA,
                          CODLINEADENEGOCIO,
                          SUM(VALORVENTA)              AS VALORVENTA,
                          SUM(VALORANULACION)          AS VALORANULACION,
                          SUM(IMPUESTO_IVA)            AS IMPUESTO_IVA,
                          SUM(VALORVENTABRUTA)         AS VALORVENTABRUTA,
                          SUM(VALORPREMIOPAGO)         AS VALORPREMIOPAGO,
                          SUM(VALORCOMISION)           AS VALORCOMISION,
                          SUM(VATCOMISION)             AS VATCOMISION,
                          SUM(VALORCOMISIONBRUTA)      AS VALORCOMISIONBRUTA,
                          SUM(RETENCION_RENTA)         AS RETENCION_RENTA,
                          SUM(RETENCION_RETEICA)       AS RETENCION_RETEICA,
                          SUM(RETENCION_RETEIVA)       AS RETENCION_RETEIVA,
                          SUM(RETENCION_RETECREE)      AS RETENCION_RETECREE,
                          SUM(VALORCOMISIONNETA)       AS VALORCOMISIONNETA,
                          0                            AS AJUSTES,
                          SUM(RETENCIONPREMIOSPAGADOS) AS RETENCIONPREMIOSPAGADOS
                   FROM WSXML_SFG.VW_SHOW_PDVFACTURACION
                   WHERE CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
                     AND CODALIADOESTRATEGICO = CASE WHEN @pg_ALIADOESTRATEGICO = '-1' THEN CODALIADOESTRATEGICO ELSE WSXML_SFG.ALIADOESTRATEGICO_F(@pg_ALIADOESTRATEGICO) END
                     AND ID_PRODUCTO = CASE WHEN @pg_PRODUCTO = '-1' THEN ID_PRODUCTO ELSE WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO) END
                   GROUP BY ID_CICLOFACTURACIONPDV,
                            ID_PUNTODEVENTA,
                            CODLINEADENEGOCIO) VPVF ON (VPVF.ID_CICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV
                                                    AND VPVF.ID_PUNTODEVENTA        = PDV.ID_PUNTODEVENTA
                                                    AND VPVF.CODLINEADENEGOCIO      = LDN.ID_LINEADENEGOCIO)
  LEFT OUTER JOIN (SELECT ID_CICLOFACTURACIONPDV,
                          CODPUNTODEVENTA,
                          CODLINEADENEGOCIO,
                          SUM(SALDOANTERIORENCONTRAGTECH)   AS SALDOANTERIORENCONTRAGTECH,
                          SUM(SALDOANTERIORAFAVORGTECH)     AS SALDOANTERIORAFAVORGTECH,
                          SUM(SALDOANTERIORENCONTRAFIDUCIA) AS SALDOANTERIORENCONTRAFIDUCIA,
                          SUM(SALDOANTERIORAFAVORFIDUCIA)   AS SALDOANTERIORAFAVORFIDUCIA,
                          SUM(NUEVOSALDOENCONTRAGTECH)      AS NUEVOSALDOENCONTRAGTECH,
                          SUM(NUEVOSALDOAFAVORGTECH)        AS NUEVOSALDOAFAVORGTECH,
                          SUM(NUEVOSALDOENCONTRAFIDUCIA)    AS NUEVOSALDOENCONTRAFIDUCIA,
                          SUM(NUEVOSALDOAFAVORFIDUCIA)      AS NUEVOSALDOAFAVORFIDUCIA
                   FROM WSXML_SFG.VW_SHOW_LDNFACTURACION
                   -- Filters
                   WHERE CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
                   GROUP BY ID_CICLOFACTURACIONPDV,
                            CODPUNTODEVENTA,
                            CODLINEADENEGOCIO) VLDF ON (VLDF.ID_CICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV
                                                    AND VLDF.CODPUNTODEVENTA        = PDV.ID_PUNTODEVENTA
                                                    AND VLDF.CODLINEADENEGOCIO      = LDN.ID_LINEADENEGOCIO)
  left outer join WSXML_SFG.vw_puntosdeventafromsag pdvsag on pdvsag.codigo = pdv.codigogtechpuntodeventa
  WHERE CFP.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
    AND LDN.ID_LINEADENEGOCIO      = @p_CODLINEADENEGOCIO
    AND PDV.ACTIVE                 = 1
  -- Filters
    AND PDV.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN PDV.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
  ORDER BY PDV.CODIGOGTECHPUNTODEVENTA;
END;
GO

  /* Obtiene valores resumidos de facturacion */
  IF OBJECT_ID('WSXML_SFG.SFGINF_INVRPT_GetFooterData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_INVRPT_GetFooterData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_INVRPT_GetFooterData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @pg_CADENA                NVARCHAR(2000),
                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                         @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ISNULL(ROUND(SUM(VLDF.SALDOANTERIORENCONTRAGTECH - VLDF.SALDOANTERIORAFAVORGTECH),0), 0)     AS BALANCEPREVIOGTECH,
             ISNULL(ROUND(SUM(VLDF.SALDOANTERIORENCONTRAFIDUCIA - VLDF.SALDOANTERIORAFAVORFIDUCIA),0), 0) AS BALANCEPREVIOFDCIA,
             ISNULL(ROUND(SUM(VPVF.VALORVENTA),0), 0)                                     AS INGRESOS,
             ISNULL(ROUND(SUM(VPVF.VALORANULACION),0), 0)                                 AS ANULACIONES,
             ISNULL(ROUND(SUM(VPVF.IMPUESTO_IVA),0), 0)                                   AS IVA,
             ISNULL(ROUND(SUM(VPVF.VALORVENTABRUTA),0), 0)                                AS VENTASBRUTAS,
             ISNULL(ROUND(SUM(VPVF.VALORPREMIOPAGO + VPVF.RETENCIONPREMIOSPAGADOS),0), 0) AS VALIDACIONES,
             ISNULL(ROUND(SUM(VPVF.RETENCIONPREMIOSPAGADOS),0), 0)                        AS RETEFUENTE,
             ISNULL(ROUND(SUM(VPVF.VALORPREMIOPAGO),0), 0)                                AS VALDBRUTAS,
             ROUND(0,0) AS PAGOSPROMO,
             ROUND(0,0) AS COMXRECLAM,
             ROUND(0,0) AS IMPAJUSTES,
             ISNULL(ROUND(SUM(VLDF.NUEVOSALDOENCONTRAGTECH + VLDF.NUEVOSALDOENCONTRAFIDUCIA),0), 0) AS TOTLDEBITO,
             ISNULL(ROUND(SUM(VLDF.NUEVOSALDOAFAVORGTECH + VLDF.NUEVOSALDOAFAVORFIDUCIA),0), 0)     AS TOTCREDITO,
             ISNULL(ROUND(SUM((VLDF.NUEVOSALDOENCONTRAGTECH + VLDF.NUEVOSALDOENCONTRAFIDUCIA) -
                           (VLDF.NUEVOSALDOAFAVORGTECH + VLDF.NUEVOSALDOAFAVORFIDUCIA)),0), 0)   AS BALANCETTL,
             ISNULL(ROUND(SUM(VLDF.NUEVOSALDOENCONTRAGTECH - VLDF.NUEVOSALDOAFAVORGTECH),0), 0)     AS ADEUDADOGTECH,
             ISNULL(ROUND(SUM(VLDF.NUEVOSALDOENCONTRAFIDUCIA - VLDF.NUEVOSALDOAFAVORFIDUCIA),0), 0) AS ADEUDADOFDCIA,

             ISNULL(ROUND(SUM(VPVF.VALORCOMISIONBRUTA),0), 0) AS COMISIONBRUTA,
             ISNULL(ROUND(SUM(VPVF.VALORRETENCION +
                       VPVF.VALORRETENCIONUVT),0), 0)      AS RETENCIONESCM,
             ISNULL(ROUND(SUM(VPVF.VALORCOMISIONNETA),0), 0)  AS COMISIONNETAS,


             CASE WHEN ISNULL(SUM(VPVF.VALORVENTA), 0) = 0
                  THEN '0.00'
                  ELSE FORMAT((SUM(VPVF.VALORPREMIOPAGO + VPVF.RETENCIONPREMIOSPAGADOS) /SUM(VPVF.VALORVENTA)), '#.##')
             END                                                                AS PRCNTVALIDACN,
             CASE WHEN ISNULL(SUM(VPVF.VALORVENTA), 0) = 0
                  THEN '0.00'
                  ELSE FORMAT((SUM(VPVF.VALORANULACION) / SUM(VPVF.VALORVENTA)), '#.##')
             END                                                                AS PRCNTANULASIS,
             ISNULL(WSXML_SFG.CANT_PV_POR_ESTADO(1), 0) AS PUNTOSACTIVOS
      FROM WSXML_SFG.VW_SHOW_PDVFACTURACION VPVF
      INNER JOIN WSXML_SFG.VW_SHOW_LDNFACTURACION VLDF ON (VPVF.ID_CICLOFACTURACIONPDV = VLDF.ID_CICLOFACTURACIONPDV
                                             AND VPVF.ID_PUNTODEVENTA        = VLDF.CODPUNTODEVENTA
                                             AND VPVF.CODLINEADENEGOCIO      = VLDF.CODLINEADENEGOCIO)
      WHERE VPVF.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
        AND VPVF.CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO
        -- Filters
        AND VPVF.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN VPVF.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
        AND VPVF.CODALIADOESTRATEGICO = CASE WHEN @pg_ALIADOESTRATEGICO = '-1' THEN VPVF.CODALIADOESTRATEGICO ELSE WSXML_SFG.ALIADOESTRATEGICO_F(@pg_ALIADOESTRATEGICO) END
        AND VPVF.ID_PRODUCTO = CASE WHEN @pg_PRODUCTO = '-1' THEN VPVF.ID_PRODUCTO ELSE WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO) END;
  END;

GO


