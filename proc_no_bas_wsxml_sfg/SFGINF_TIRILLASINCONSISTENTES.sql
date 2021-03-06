USE SFGPRODU;
--  DDL for Package Body SFGINF_TIRILLASINCONSISTENTES
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES */ 

  /* Tirillas con detalles de mas de 4 productos */
  IF OBJECT_ID('WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES_GetChainReportData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES_GetChainReportData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES_GetChainReportData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                               @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                               @pg_CADENA                NVARCHAR(2000),
                               @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                              @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT FCT.ID_CICLOFACTURACIONPDV  AS CICLO,
             AGR.CODIGOAGRUPACIONGTECH   AS CHAIN,
             PDV.CODIGOGTECHPUNTODEVENTA AS POS,
             PDV.NUMEROTERMINAL          AS TERMINAL,
             CD.CIUDADDANE               AS CODCIUDAD,
             CD.NOMCIUDAD                AS CIUDAD,
             USR.NOMUSUARIO              AS FMR,
             FCT.INGRESOSVALIDOS         AS INGRESOSVALIDOS,
             FCT.PRODUCTOS               AS PRODUCTOS
      FROM (SELECT FCT.ID_CICLOFACTURACIONPDV,
                   FCT.CODAGRUPACIONPUNTODEVENTA,
                   SUM(FCT.VALORVENTA - FCT.VALORANULACION) AS INGRESOSVALIDOS,
                   COUNT(DISTINCT(FCT.ID_PRODUCTO) )         AS PRODUCTOS
            FROM WSXML_SFG.VW_SHOW_PDVFACTURACION FCT
            WHERE FCT.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
              AND FCT.CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO
              AND FCT.CODIGOAGRUPACIONGTECH  <> 0
              AND @pg_ALIADOESTRATEGICO       = @pg_ALIADOESTRATEGICO
              AND @pg_PRODUCTO                = @pg_PRODUCTO
              -- Filters
              AND FCT.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN FCT.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
            GROUP BY FCT.ID_CICLOFACTURACIONPDV,
                     FCT.CODAGRUPACIONPUNTODEVENTA) FCT
      INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA = FCT.CODAGRUPACIONPUNTODEVENTA)
      INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (AGR.CODPUNTODEVENTACABEZA = PDV.ID_PUNTODEVENTA)
      INNER JOIN WSXML_SFG.CIUDAD CD ON (PDV.CODCIUDAD = CD.ID_CIUDAD)
      INNER JOIN WSXML_SFG.RUTAPDV RPV ON (PDV.CODRUTAPDV = RPV.ID_RUTAPDV)
      INNER JOIN WSXML_SFG.FMR ON (RPV.CODFMR = FMR.ID_FMR)
      INNER JOIN WSXML_SFG.USUARIO USR ON (FMR.CODUSUARIO = USR.ID_USUARIO)
      WHERE PRODUCTOS > 4
      ORDER BY CAST(AGR.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0));
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES_GetPOSReportData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES_GetPOSReportData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_TIRILLASINCONSISTENTES_GetPOSReportData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                             @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                             @pg_CADENA                NVARCHAR(2000),
                             @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                            @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT FCT.ID_CICLOFACTURACIONPDV  AS CICLO,
             PDV.CODIGOGTECHPUNTODEVENTA AS POS,
             PDV.NUMEROTERMINAL          AS TERMINAL,
             CD.CIUDADDANE               AS CODCIUDAD,
             CD.NOMCIUDAD                AS CIUDAD,
             USR.NOMUSUARIO              AS FMR,
             FCT.INGRESOSVALIDOS         AS INGRESOSVALIDOS,
             FCT.PRODUCTOS               AS PRODUCTOS
      FROM (SELECT FCT.ID_CICLOFACTURACIONPDV,
                   FCT.ID_PUNTODEVENTA,
                   SUM(FCT.VALORVENTA - FCT.VALORANULACION) AS INGRESOSVALIDOS,
                   COUNT(DISTINCT(FCT.ID_PRODUCTO))         AS PRODUCTOS
            FROM WSXML_SFG.VW_SHOW_PDVFACTURACION FCT
            WHERE FCT.ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
              AND FCT.CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO
              AND FCT.CODIGOAGRUPACIONGTECH  = 0
              AND @pg_ALIADOESTRATEGICO       = @pg_ALIADOESTRATEGICO
              AND @pg_PRODUCTO                = @pg_PRODUCTO
              -- Filters
              AND FCT.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN FCT.CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
            GROUP BY FCT.ID_CICLOFACTURACIONPDV,
                     FCT.ID_PUNTODEVENTA) FCT
      INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (FCT.ID_PUNTODEVENTA = PDV.ID_PUNTODEVENTA)
      INNER JOIN WSXML_SFG.CIUDAD CD ON (PDV.CODCIUDAD = CD.ID_CIUDAD)
      INNER JOIN WSXML_SFG.RUTAPDV RPV ON (PDV.CODRUTAPDV = RPV.ID_RUTAPDV)
      INNER JOIN WSXML_SFG.FMR ON (RPV.CODFMR = FMR.ID_FMR)
      INNER JOIN WSXML_SFG.USUARIO USR ON (FMR.CODUSUARIO = USR.ID_USUARIO)
      WHERE PRODUCTOS > 4
      ORDER BY CAST(PDV.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0));
  END;


GO


