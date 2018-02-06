USE SFGPRODU;
--  DDL for Package Body SFGINF_FIDUCIA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_FIDUCIA */ 

  /* Total a recaudar por concepto de fiducia */
  IF OBJECT_ID('WSXML_SFG.SFGINF_FIDUCIA_GetReportData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FIDUCIA_GetReportData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_FIDUCIA_GetReportData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @pg_CADENA                NVARCHAR(2000),
                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                         @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Particularidad: Union entre Agrupaciones y Terminales con Saldo > 0
      SELECT FECHACICLO,
             NUMEROTERMINAL,
             ROUND(SALDOFIDUCIA,0) AS SALDOFIDUCIA,
             REFERENCIA,
             SUM(ROUND(SALDOFIDUCIA,0)) OVER (PARTITION BY AGRUPAMIENTO ORDER BY CAST(NUMEROTERMINAL AS NUMERIC(38,0))) AS ACUMULADO
      FROM (SELECT 'I'                                 AS AGRUPAMIENTO,
                   CFP.FECHAEJECUCION                  AS FECHACICLO,
                   VLD.CODTIPOPUNTODEVENTA             AS TIPOAGRUPACION,
                   VLD.NUMEROTERMINAL                  AS NUMEROTERMINAL,
                   SUM (VLD.NUEVOSALDOENCONTRAFIDUCIA -
                       VLD.NUEVOSALDOAFAVORFIDUCIA)    AS SALDOFIDUCIA,
                   WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_IndependentReferenceNumber(VLD.NUMEROTERMINAL, CFP.FECHAEJECUCION)
                                                       AS REFERENCIA
            FROM WSXML_SFG.VW_SHOW_LDNFACTURACION VLD
            INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV = VLD.ID_CICLOFACTURACIONPDV)
            WHERE VLD.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
              AND @p_CODLINEADENEGOCIO        = @p_CODLINEADENEGOCIO
              AND @pg_ALIADOESTRATEGICO       = @pg_ALIADOESTRATEGICO
              AND @pg_PRODUCTO                = @pg_PRODUCTO
              -- Filters
              AND VLD.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN VLD.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
              -- Particularity
            GROUP BY CFP.FECHAEJECUCION, VLD.CODTIPOPUNTODEVENTA, VLD.NUMEROTERMINAL

            UNION

            SELECT 'G'                                            AS AGRUPAMIENTO,
                   CFP.FECHAEJECUCION                             AS FECHACICLO,
                   VLD.CODTIPOPUNTODEVENTA                        AS TIPOAGRUPACION,
				   '9' + RIGHT(REPLICATE('0', 4) + LEFT(VLD.CODIGOAGRUPACIONGTECH, 4), 4) AS NUMEROTERMINAL,
                   SUM (VLD.NUEVOSALDOENCONTRAFIDUCIA -
                       VLD.NUEVOSALDOAFAVORFIDUCIA)               AS SALDOFIDUCIA,
                   WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GroupedReferenceNumber(VLD.CODIGOAGRUPACIONGTECH, CFP.FECHAEJECUCION)
                                                                  AS REFERENCIA
            FROM WSXML_SFG.VW_SHOW_LDNFACTURACION VLD
            INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV = VLD.ID_CICLOFACTURACIONPDV)
            WHERE VLD.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
              AND @p_CODLINEADENEGOCIO        = @p_CODLINEADENEGOCIO
              AND @pg_ALIADOESTRATEGICO       = @pg_ALIADOESTRATEGICO
              AND @pg_PRODUCTO                = @pg_PRODUCTO
              -- Filters
              AND VLD.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN VLD.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
              -- Particularity
              AND VLD.CODTIPOPUNTODEVENTA IN (1, 2)
            GROUP BY CFP.FECHAEJECUCION, VLD.CODTIPOPUNTODEVENTA, VLD.CODIGOAGRUPACIONGTECH) T
      -- Particularity
      WHERE SALDOFIDUCIA > 0
      ORDER BY CAST(NUMEROTERMINAL AS NUMERIC(38,0));
  END;
GO

  /* Total a recaudar por concepto de fiducia */
  IF OBJECT_ID('WSXML_SFG.SFGINF_FIDUCIA_GetReportAllData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FIDUCIA_GetReportAllData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_FIDUCIA_GetReportAllData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @pg_CADENA                NVARCHAR(2000),
                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                         @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Particularidad: Union entre Agrupaciones y Terminales con Saldo > 0
      SELECT FECHACICLO,
             NUMEROTERMINAL,
             ROUND(SALDOFIDUCIA,0) AS SALDOFIDUCIA,
             REFERENCIA,
             SUM(ROUND(SALDOFIDUCIA,0)) OVER (PARTITION BY AGRUPAMIENTO ORDER BY CAST(NUMEROTERMINAL AS NUMERIC(38,0))) AS ACUMULADO
      FROM (SELECT 'I'                                 AS AGRUPAMIENTO,
                   CFP.FECHAEJECUCION                  AS FECHACICLO,
                   VLD.CODTIPOPUNTODEVENTA             AS TIPOAGRUPACION,
                   VLD.NUMEROTERMINAL                  AS NUMEROTERMINAL,
                   SUM (VLD.NUEVOSALDOENCONTRAFIDUCIA -
                       VLD.NUEVOSALDOAFAVORFIDUCIA)    AS SALDOFIDUCIA,
                   WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_IndependentReferenceNumber(VLD.NUMEROTERMINAL, CFP.FECHAEJECUCION)
                                                       AS REFERENCIA
            FROM WSXML_SFG.VW_SHOW_LDNFACTURACION VLD
            INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV = VLD.ID_CICLOFACTURACIONPDV)
            WHERE VLD.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
              AND @p_CODLINEADENEGOCIO        = @p_CODLINEADENEGOCIO
              AND @pg_ALIADOESTRATEGICO       = @pg_ALIADOESTRATEGICO
              AND @pg_PRODUCTO                = @pg_PRODUCTO
              -- Filters
              AND VLD.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN VLD.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
              -- Particularity
              AND VLD.CODIGOAGRUPACIONGTECH<>275
            GROUP BY CFP.FECHAEJECUCION, VLD.CODTIPOPUNTODEVENTA, VLD.NUMEROTERMINAL

            UNION

            SELECT 'G'                                            AS AGRUPAMIENTO,
                   CFP.FECHAEJECUCION                             AS FECHACICLO,
                   VLD.CODTIPOPUNTODEVENTA                        AS TIPOAGRUPACION,
                   '9' + RIGHT(REPLICATE('0', 4) + LEFT(VLD.CODIGOAGRUPACIONGTECH, 4), 4) AS NUMEROTERMINAL,
                   SUM (VLD.NUEVOSALDOENCONTRAFIDUCIA -
                       VLD.NUEVOSALDOAFAVORFIDUCIA)               AS SALDOFIDUCIA,
                   WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GroupedReferenceNumber(VLD.CODIGOAGRUPACIONGTECH, CFP.FECHAEJECUCION)
                                                                  AS REFERENCIA
            FROM WSXML_SFG.VW_SHOW_LDNFACTURACION VLD
            INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV = VLD.ID_CICLOFACTURACIONPDV)
            WHERE VLD.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
              AND @p_CODLINEADENEGOCIO        = @p_CODLINEADENEGOCIO
              AND @pg_ALIADOESTRATEGICO       = @pg_ALIADOESTRATEGICO
              AND @pg_PRODUCTO                = @pg_PRODUCTO
              -- Filters
              AND VLD.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN VLD.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
              -- Particularity
              AND VLD.CODTIPOPUNTODEVENTA IN (1, 2)
              AND VLD.CODIGOAGRUPACIONGTECH<>275
            GROUP BY CFP.FECHAEJECUCION, VLD.CODTIPOPUNTODEVENTA, VLD.CODIGOAGRUPACIONGTECH) T

      -- Particularity
      ORDER BY CAST(NUMEROTERMINAL AS NUMERIC(38,0));
  END;

 GO

