USE SFGPRODU;
--  DDL for Package Body SFGINF_REPORTESESPECIALES
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_REPORTESESPECIALES */ 

  /* Reporte con comisiones distintas a la general */
IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_CuadreSemanalDiferencial', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CuadreSemanalDiferencial;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CuadreSemanalDiferencial(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                     @pg_CADENA                NVARCHAR(2000),
                                     @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                    @pg_PRODUCTO              NVARCHAR(2000)
                                     ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT CODIGOAGRUPACIONGTECH AS CHAIN,
             CODIGOGTECHPUNTODEVENTA AS POS,
             NUMEROTERMINAL AS TERM,
             SUM(CASE
                   WHEN ID_PRODUCTO <> 177 THEN
                    VALORVENTA - VALORANULACION
                   ELSE
                    0
                 END) AS VENTAS,
             SUM(CASE
                   WHEN ID_PRODUCTO <> 177 THEN
                    CANTIDADVENTA - CANTIDADANULACION
                   ELSE
                    0
                 END) AS TRANSACCIONES,
             SUM(CASE
                   WHEN ID_PRODUCTO = 177 THEN
                    VALORVENTA - VALORANULACION
                   ELSE
                    0
                 END) AS VENTASEEPP,
             SUM(CASE
                   WHEN ID_PRODUCTO = 177 THEN
                    CANTIDADVENTA - CANTIDADANULACION
                   ELSE
                    0
                 END) AS TRANSACCIONESEEPP,
             SUM(VALORCOMISION) AS COMISIONCALCULADA,
             SUM(VATCOMISION) AS IVACOMISION,
             SUM(RETENCION_RENTA) AS RETERENTA,
             SUM(RETENCION_RETEICA) AS RETEICA,
             SUM(RETENCION_RETEIVA) AS RETEIVA,
             SUM(VALORCOMISIONNETA) AS COMISIONNETA,
             SUM(FACTURADOENCONTRAGTECH - FACTURADOAFAVORGTECH) AS FACTURACION
        FROM WSXML_SFG.VW_SHOW_PDVFACTURACION
       WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
         AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
         AND CODALIADOESTRATEGICO = CASE WHEN
       @pg_ALIADOESTRATEGICO = '-1' THEN CODALIADOESTRATEGICO ELSE WSXML_SFG.ALIADOESTRATEGICO_F(@pg_ALIADOESTRATEGICO) END AND ID_PRODUCTO = CASE WHEN @pg_PRODUCTO = '-1' THEN ID_PRODUCTO ELSE WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO) END AND CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
       GROUP BY CODIGOAGRUPACIONGTECH,
                CODIGOGTECHPUNTODEVENTA,
                NUMEROTERMINAL
       ORDER BY CAST(CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0));
  END;
GO
  /* Reporte valores por cadena */
IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_FacturacionCadenas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_FacturacionCadenas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_FacturacionCadenas(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                               @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                               @pg_CADENA                NVARCHAR(2000),
                               @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                              @pg_PRODUCTO              NVARCHAR(2000)
                               ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PRF.CODIGOAGRUPACIONGTECH AS CHAIN,
             AGR.NOMAGRUPACIONPUNTODEVENTA AS CADENA,
             SUM(CANTIDADVENTA - CANTIDADANULACION) AS TRANSACCIONES,
             SUM(VALORVENTA - VALORANULACION) AS VENTAS,
             SUM(VALORCOMISION) AS COMISIONCALCULADA,
             SUM(VATCOMISION) AS IVACOMISION,
             SUM(RETENCION_RENTA) AS RETERENTA,
             SUM(RETENCION_RETEICA) AS RETEICA,
             SUM(RETENCION_RETEIVA) AS RETEIVA,
             SUM(VALORCOMISIONNETA) AS COMISIONNETA,
             SUM(FACTURADOGTECH) AS FACTURACION
        FROM WSXML_SFG.VW_SHOW_LDNFACTCOMISION PRF
       INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                PRF.CODAGRUPACIONPUNTODEVENTA)
       WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
         AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
         AND CODAGRUPACIONPUNTODEVENTA = CASE WHEN @pg_CADENA = '-1' THEN CODAGRUPACIONPUNTODEVENTA ELSE WSXML_SFG.AGRUPACION_F(@pg_CADENA) END
      /* Specific filters */
      AND CODAGRUPACIONPUNTODEVENTA <> WSXML_SFG.AGRUPACION_F(0)
      /* NULL */
      AND @pg_PRODUCTO = @pg_PRODUCTO AND @pg_ALIADOESTRATEGICO = @pg_ALIADOESTRATEGICO
       GROUP BY PRF.CODIGOAGRUPACIONGTECH, AGR.NOMAGRUPACIONPUNTODEVENTA
       ORDER BY CAST(PRF.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0));
  END;

GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_FacturacionConsolidada', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_FacturacionConsolidada;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_FacturacionConsolidada(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                   @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                   @pg_CADENA                NVARCHAR(2000),
                                   @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                  @pg_PRODUCTO              NVARCHAR(2000)
                                   ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             AGR.NOMAGRUPACIONPUNTODEVENTA AS NOMAGRUPACIONPUNTODEVENTA,
             PDV.CODIGOGTECHPUNTODEVENTA AS CODIGOGTECHPUNTODEVENTA,
             PDV.NUMEROTERMINAL AS NUMEROTERMINAL,
             ISNULL(RSC.IDENTIFICACION, '') + ISNULL(RSC.DIGITOVERIFICACION, '') AS IDENTIFICACION,
             RSC.NOMRAZONSOCIAL AS NOMRAZONSOCIAL,
             TCT.NOMTIPOCONTRATOPDV AS NOMTIPOCONTRATOPDV,
             SUM(ISNULL(PRF.CANTIDADVENTA, 0)) AS CANTIDADVENTA,
             round(SUM(ISNULL(PRF.VALORVENTA, 0)),22) AS VALORVENTA,
             round(SUM(ISNULL(PRF.CANTIDADANULACION, 0)),22) AS CANTIDADANULACION,
             round(SUM(ISNULL(PRF.VALORANULACION, 0)),22) AS VALORANULACION,
             round(SUM(ISNULL(PRF.IMPUESTO_IVA, 0)),22) AS IMPUESTO_IVA,
             round(SUM(ISNULL(PRF.VALORVENTABRUTA, 0)),22) AS VALORVENTABRUTA,
             round(SUM(ISNULL(PRF.VALORCOMISION, 0)),22) AS VALORCOMISION,
             round(SUM(ISNULL(PRF.VATCOMISION, 0)),22) AS VATCOMISION,
             round(SUM(ISNULL(PRF.VALORCOMISIONBRUTA, 0)),22) AS VALORCOMISIONBRUTA,
             round(SUM(ISNULL(PRF.RETENCION_RENTA, 0)),22) AS RETENCION_RENTA,
             round(SUM(ISNULL(PRF.RETENCION_RETEIVA, 0)),22) AS RETENCION_RETEIVA,
             round(SUM(ISNULL(PRF.RETENCION_RETEICA, 0)),22) AS RETENCION_RETEICA,
             round(SUM(ISNULL(PRF.VALORCOMISIONNETA, 0)),22) AS VALORCOMISIONNETA,
             round(SUM(ISNULL(PRF.VALORPREMIOPAGO, 0)),22) AS VALORPREMIOPAGO,
             round(SUM(ISNULL(PRF.FACTURADOENCONTRAGTECH - PRF.FACTURADOAFAVORGTECH,
                     0)),22) AS FACTURACIONGTECH,
             round(SUM(ISNULL(PRF.FACTURADOENCONTRAFIDUCIA -
                     PRF.FACTURADOAFAVORFIDUCIA,
                     0)),22) AS FACTURACIONFIDUCIA
        FROM WSXML_SFG.PUNTODEVENTA PDV
       INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                PDV.CODAGRUPACIONPUNTODEVENTA)
       INNER JOIN WSXML_SFG.RAZONSOCIAL RSC ON (RSC.ID_RAZONSOCIAL =
                                     PDV.CODRAZONSOCIAL)
       INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (LDN.ID_LINEADENEGOCIO =
                                        @p_CODLINEADENEGOCIO)
       INNER JOIN WSXML_SFG.RAZONSOCIALCONTRATO RCT ON (RCT.CODRAZONSOCIAL =
                                             RSC.ID_RAZONSOCIAL AND
                                             RCT.CODSERVICIO =
                                             LDN.CODSERVICIO)
       INNER JOIN WSXML_SFG.TIPOCONTRATOPDV TCT ON (TCT.ID_TIPOCONTRATOPDV =
                                         RCT.CODTIPOCONTRATOPDV)
        LEFT OUTER JOIN WSXML_SFG.VW_SHOW_LDNFACTURACION PRF ON (PRF.ID_CICLOFACTURACIONPDV =
                                                      @p_CODCICLOFACTURACIONPDV AND
                                                      PRF.CODPUNTODEVENTA =
                                                      PDV.ID_PUNTODEVENTA AND
                                                      PRF.CODLINEADENEGOCIO =
                                                      LDN.ID_LINEADENEGOCIO)
       WHERE PDV.ACTIVE = 1
       GROUP BY AGR.CODIGOAGRUPACIONGTECH,
                AGR.NOMAGRUPACIONPUNTODEVENTA,
                PDV.CODIGOGTECHPUNTODEVENTA,
                PDV.NUMEROTERMINAL,
                RSC.IDENTIFICACION,
                RSC.DIGITOVERIFICACION,
                RSC.NOMRAZONSOCIAL,
                TCT.NOMTIPOCONTRATOPDV
       ORDER BY CAST(PDV.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0));
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_FactConsolidadaCadenas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_FactConsolidadaCadenas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_FactConsolidadaCadenas(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                   @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                   @pg_CADENA                NVARCHAR(2000),
                                   @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                  @pg_PRODUCTO              NVARCHAR(2000)
                                   ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             AGR.NOMAGRUPACIONPUNTODEVENTA AS NOMAGRUPACIONPUNTODEVENTA,
             CAB.CODIGOGTECHPUNTODEVENTA AS CODIGOGTECHPUNTODEVENTA,
             CAB.NUMEROTERMINAL AS NUMEROTERMINAL,
             ISNULL(RSC.IDENTIFICACION, '') + ISNULL(RSC.DIGITOVERIFICACION, '') AS IDENTIFICACION,
             RSC.NOMRAZONSOCIAL AS NOMRAZONSOCIAL,
             TCT.NOMTIPOCONTRATOPDV AS NOMTIPOCONTRATOPDV,
             round(SUM(ISNULL(PRF.CANTIDADVENTA, 0)),19) AS CANTIDADVENTA,
             round(SUM(ISNULL(PRF.VALORVENTA, 0)),19) AS VALORVENTA,
             round(SUM(ISNULL(PRF.CANTIDADANULACION, 0)),19) AS CANTIDADANULACION,
             round(SUM(ISNULL(PRF.VALORANULACION, 0)),19) AS VALORANULACION,
             round(SUM(ISNULL(PRF.IMPUESTO_IVA, 0)),19) AS IMPUESTO_IVA,
             round(SUM(ISNULL(PRF.VALORVENTABRUTA, 0)),19) AS VALORVENTABRUTA,
             round(SUM(ISNULL(PRF.VALORCOMISION, 0)),19) AS VALORCOMISION,
             round(SUM(ISNULL(PRF.VATCOMISION, 0)),19) AS VATCOMISION,
             round(SUM(ISNULL(PRF.VALORCOMISIONBRUTA, 0)),19) AS VALORCOMISIONBRUTA,
             round(SUM(ISNULL(PRF.RETENCION_RENTA, 0)),19) AS RETENCION_RENTA,
             round(SUM(ISNULL(PRF.RETENCION_RETEIVA, 0)),19) AS RETENCION_RETEIVA,
             round(SUM(ISNULL(PRF.RETENCION_RETEICA, 0)),19) AS RETENCION_RETEICA,
             round(SUM(ISNULL(PRF.VALORCOMISIONNETA, 0)),19) AS VALORCOMISIONNETA,
             round(SUM(ISNULL(PRF.VALORPREMIOPAGO, 0)),19) AS VALORPREMIOPAGO,
             round(SUM(ISNULL(PRF.FACTURADOENCONTRAGTECH - PRF.FACTURADOAFAVORGTECH,
                     0)),19) AS FACTURACIONGTECH,
             round(SUM(ISNULL(PRF.FACTURADOENCONTRAFIDUCIA -
                     PRF.FACTURADOAFAVORFIDUCIA,
                     0)),19) AS FACTURACIONFIDUCIA
        FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR
       INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                      PDV.CODAGRUPACIONPUNTODEVENTA)
       INNER JOIN WSXML_SFG.PUNTODEVENTA CAB ON (CAB.ID_PUNTODEVENTA =
                                      AGR.CODPUNTODEVENTACABEZA)
       INNER JOIN WSXML_SFG.RAZONSOCIAL RSC ON (RSC.ID_RAZONSOCIAL =
                                     CAB.CODRAZONSOCIAL)
       INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (LDN.ID_LINEADENEGOCIO =
                                        @p_CODLINEADENEGOCIO)
       INNER JOIN WSXML_SFG.RAZONSOCIALCONTRATO RCT ON (RCT.CODRAZONSOCIAL =
                                             RSC.ID_RAZONSOCIAL AND
                                             RCT.CODSERVICIO =
                                             LDN.CODSERVICIO)
       INNER JOIN WSXML_SFG.TIPOCONTRATOPDV TCT ON (TCT.ID_TIPOCONTRATOPDV =
                                         RCT.CODTIPOCONTRATOPDV)
        LEFT OUTER JOIN WSXML_SFG.VW_SHOW_LDNFACTURACION PRF ON (PRF.ID_CICLOFACTURACIONPDV =
                                                      @p_CODCICLOFACTURACIONPDV AND
                                                      PRF.CODPUNTODEVENTA =
                                                      PDV.ID_PUNTODEVENTA AND
                                                      PRF.CODLINEADENEGOCIO =
                                                      LDN.ID_LINEADENEGOCIO)
       WHERE AGR.CODTIPOPUNTODEVENTA <> 3
       GROUP BY AGR.CODIGOAGRUPACIONGTECH,
                AGR.NOMAGRUPACIONPUNTODEVENTA,
                CAB.CODIGOGTECHPUNTODEVENTA,
                CAB.NUMEROTERMINAL,
                RSC.IDENTIFICACION,
                RSC.DIGITOVERIFICACION,
                RSC.NOMRAZONSOCIAL,
                TCT.NOMTIPOCONTRATOPDV
       ORDER BY CAST(AGR.CODIGOAGRUPACIONGTECH  AS NUMERIC(38,0));
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteEspecialCadenas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteEspecialCadenas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteEspecialCadenas(@p_CODLINEADENEGOCIO NUMERIC(22,0),
                                  @pg_CADENA           NVARCHAR(2000)
                                   ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT FCT.CODIGOAGRUPACIONGTECH AS CADENA,
             FCT.CODIGOGTECHPUNTODEVENTA AS POS,
             FCT.NUMEROTERMINAL AS TERMINAL,
             PDV.NOMPUNTODEVENTA AS NOMBREPUNTO,
             SUM(ISNULL(FCT.CANTIDADVENTA,0)) AS CANTIDADVENTAS,
             SUM(ISNULL(FCT.VALORVENTA,0)) AS VENTAS,
             SUM(ISNULL(FCT.CANTIDADANULACION,0)) AS CANTIDADANULACIONES,
             SUM(ISNULL(FCT.VALORANULACION,0)) AS ANULACIONES,
             SUM(ISNULL(FCT.IMPUESTO_IVA,0)) AS IVAPRODUCTO,
             SUM(ISNULL(FCT.VALORVENTABRUTA,0)) AS VENTASBRUTAS,
             SUM(ISNULL(FCT.VALORCOMISION,0)) AS INGRESOPDV,
             SUM(ISNULL(FCT.VATCOMISION,0)) AS IVAINGRESO,
             SUM(ISNULL(FCT.VALORCOMISIONBRUTA,0)) AS INGRESOPDVBRUTO,
             SUM(ISNULL(FCT.RETENCION_RENTA,0)) AS RETERENTA,
             SUM(ISNULL(FCT.RETENCION_RETEICA,0)) AS RETEICA,
             SUM(ISNULL(FCT.RETENCION_RETEIVA,0)) AS RETEIVA,
             SUM(ISNULL(FCT.VALORCOMISIONNETA,0)) AS INGRESOPDVNETO,
             SUM(ISNULL(FCT.VALORPREMIOPAGO,0)) AS PAGOSREALIZADOS,
             SUM(ISNULL(FCT.FACTURADOENCONTRAGTECH,0) - ISNULL(FCT.FACTURADOAFAVORGTECH,0)) AS FACTURACIONGTECH,
             SUM(ISNULL(FCT.FACTURADOENCONTRAFIDUCIA,0) - ISNULL(FCT.FACTURADOAFAVORFIDUCIA,0)) AS FACTURACIONFIDUCIA
        FROM WSXML_SFG.VW_SHOW_LDNFACTURACION FCT
       INNER JOIN PUNTODEVENTA PDV ON (PDV.ID_PUNTODEVENTA =
                                      FCT.CODPUNTODEVENTA)
       WHERE FCT.ID_CICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE())
         AND FCT.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
         AND FCT.CODIGOAGRUPACIONGTECH = @pg_CADENA
       GROUP BY FCT.CODIGOAGRUPACIONGTECH,
                FCT.CODIGOGTECHPUNTODEVENTA,
                FCT.NUMEROTERMINAL,
                PDV.NOMPUNTODEVENTA
       ORDER BY FCT.CODIGOAGRUPACIONGTECH, FCT.CODIGOGTECHPUNTODEVENTA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteDinamicoCadenas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteDinamicoCadenas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteDinamicoCadenas(@p_CODLINEADENEGOCIO NUMERIC(22,0),
                                   @pg_CADENA           NVARCHAR(2000),
                                   @p_STRCODIGOEXCEP    NVARCHAR(2000)) AS
 BEGIN
    DECLARE @xTRNSXCOLUMN VARCHAR(MAX) = '';
    DECLARE @xSALESCOLUMN VARCHAR(MAX) = '';
    DECLARE @xTMPQUERY VARCHAR(MAX);


   
  SET NOCOUNT ON;



      DECLARE productType CURSOR FOR SELECT ID_TIPOPRODUCTO, NOMTIPOPRODUCTO
                          FROM WSXML_SFG.TIPOPRODUCTO
                         WHERE CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND TIPOPRODUCTO.ID_TIPOPRODUCTO = CASE WHEN @p_CODLINEADENEGOCIO=4 THEN 10 ELSE TIPOPRODUCTO.ID_TIPOPRODUCTO END
                         ORDER BY ID_TIPOPRODUCTO; OPEN productType;
		DECLARE @productType__ID_TIPOPRODUCTO NUMERIC(38,0), @productType__NOMTIPOPRODUCTO VARCHAR(256)
 FETCH NEXT FROM productType INTO @productType__ID_TIPOPRODUCTO, @productType__NOMTIPOPRODUCTO
 WHILE @@FETCH_STATUS=0
 BEGIN
      SET @xTRNSXCOLUMN = ISNULL(@xTRNSXCOLUMN, '') +
                      'SUM(CASE WHEN FCT.CODTIPOPRODUCTO = ' +
                      ISNULL(@productType__ID_TIPOPRODUCTO, '') +
                      ' THEN CANTIDADVENTA ELSE 0 END) AS "Cant. ' +
                      ISNULL(SUBSTRING(@productType__NOMTIPOPRODUCTO, 0, 24), '') + '", ';
      SET @xSALESCOLUMN = ISNULL(@xSALESCOLUMN, '') +
                      'SUM(CASE WHEN FCT.CODTIPOPRODUCTO = ' +
                      ISNULL(@productType__ID_TIPOPRODUCTO, '') +
                      ' THEN VALORVENTA ELSE 0 END) AS "Ventas ' +
                      ISNULL(SUBSTRING(@productType__NOMTIPOPRODUCTO, 0, 24), '') + '", ';

    FETCH NEXT FROM productType INTO @productType__ID_TIPOPRODUCTO, @productType__NOMTIPOPRODUCTO
    END;
    CLOSE productType;
    DEALLOCATE productType;

    IF LEN(RTRIM(LTRIM(ISNULL(@p_STRCODIGOEXCEP,''))))=0 OR @p_STRCODIGOEXCEP IS NULL BEGIN
        SET @xTMPQUERY='SELECT FCT.CODIGOAGRUPACIONGTECH   AS CADENA, ' + 'FCT.CODIGOGTECHPUNTODEVENTA AS POS, ' + 'FCT.NUMEROTERMINAL          AS TERMINAL, ' + 'PDV.NOMPUNTODEVENTA         AS NOMBREPUNTO, ' + ISNULL(@xTRNSXCOLUMN, '') + ISNULL(@xSALESCOLUMN, '') + 'SUM(FCT.CANTIDADANULACION)  AS CANTIDADANULACIONES, ' + 'SUM(FCT.VALORANULACION)     AS ANULACIONES, ' + 'SUM(FCT.IMPUESTO_IVA)       AS IVAPRODUCTO, ' + 'SUM(FCT.VALORVENTABRUTA)    AS VENTASBRUTAS, ' + 'SUM(FCT.VALORPREMIOPAGO)    AS PAGOSREALIZADOS, ' + 'SUM(FCT.VALORCOMISION)      AS INGRESOPDV, ' + 'SUM(FCT.VATCOMISION)        AS IVAINGRESO, ' + 'SUM(FCT.VALORCOMISIONBRUTA) AS INGRESOPDVBRUTO, ' + 'SUM(FCT.RETENCION_RENTA)    AS RETERENTA, ' + 'SUM(FCT.RETENCION_RETEICA)  AS RETEICA, ' + 'SUM(FCT.RETENCION_RETEIVA)  AS RETEIVA, ' + 'SUM(FCT.VALORCOMISIONNETA)  AS INGRESOPDVNETO, ' + 'SUM(FCT.FACTURADOENCONTRAGTECH - FCT.FACTURADOAFAVORGTECH)     AS FACTURACIONGTECH, ' + 'SUM(FCT.FACTURADOENCONTRAFIDUCIA - FCT.FACTURADOAFAVORFIDUCIA) AS FACTURACIONFIDUCIA ' + 'FROM VW_SHOW_PDVFACTURACION FCT ' + 'INNER JOIN PUNTODEVENTA PDV ON (PDV.ID_PUNTODEVENTA = FCT.ID_PUNTODEVENTA) ' + 'WHERE FCT.ID_CICLOFACTURACIONPDV = ' + ISNULL(ULTIMO_CICLOFACTURACION(GETDATE()), '') + ' ' + 'AND FCT.CODLINEADENEGOCIO      = ' + ISNULL(@p_CODLINEADENEGOCIO, '') + ' ' + 'AND FCT.CODIGOAGRUPACIONGTECH  = ' + ISNULL(TO_NUMBER(@pg_CADENA), '') + ' ' + 'GROUP BY FCT.CODIGOAGRUPACIONGTECH, ' + 'FCT.CODIGOGTECHPUNTODEVENTA, ' + 'FCT.NUMEROTERMINAL, ' + 'PDV.NOMPUNTODEVENTA ' + 'ORDER BY FCT.CODIGOAGRUPACIONGTECH, FCT.CODIGOGTECHPUNTODEVENTA';
        EXECUTE (@xTMPQUERY);
    END
    ELSE BEGIN
        SET @xTMPQUERY= 'SELECT FCT.CODIGOAGRUPACIONGTECH   AS CADENA, ' + 'FCT.CODIGOGTECHPUNTODEVENTA AS POS, ' + 'FCT.NUMEROTERMINAL          AS TERMINAL, ' + 'PDV.NOMPUNTODEVENTA         AS NOMBREPUNTO, ' + ISNULL(@xTRNSXCOLUMN, '') + ISNULL(@xSALESCOLUMN, '') + 'SUM(FCT.CANTIDADANULACION)  AS CANTIDADANULACIONES, ' + 'SUM(FCT.VALORANULACION)     AS ANULACIONES, ' + 'SUM(FCT.IMPUESTO_IVA)       AS IVAPRODUCTO, ' + 'SUM(FCT.VALORVENTABRUTA)    AS VENTASBRUTAS, ' + 'SUM(FCT.VALORPREMIOPAGO)    AS PAGOSREALIZADOS, ' + 'SUM(FCT.VALORCOMISION)      AS INGRESOPDV, ' + 'SUM(FCT.VATCOMISION)        AS IVAINGRESO, ' + 'SUM(FCT.VALORCOMISIONBRUTA) AS INGRESOPDVBRUTO, ' + 'SUM(FCT.RETENCION_RENTA)    AS RETERENTA, ' + 'SUM(FCT.RETENCION_RETEICA)  AS RETEICA, ' + 'SUM(FCT.RETENCION_RETEIVA)  AS RETEIVA, ' + 'SUM(FCT.VALORCOMISIONNETA)  AS INGRESOPDVNETO, ' + 'SUM(FCT.FACTURADOENCONTRAGTECH - FCT.FACTURADOAFAVORGTECH)     AS FACTURACIONGTECH, ' + 'SUM(FCT.FACTURADOENCONTRAFIDUCIA - FCT.FACTURADOAFAVORFIDUCIA) AS FACTURACIONFIDUCIA ' + 'FROM VW_SHOW_PDVFACTURACION FCT ' + 'INNER JOIN PUNTODEVENTA PDV ON (PDV.ID_PUNTODEVENTA = FCT.ID_PUNTODEVENTA) INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = FCT.ID_PRODUCTO ) ' + 'WHERE FCT.ID_CICLOFACTURACIONPDV = ' + ISNULL(ULTIMO_CICLOFACTURACION(GETDATE()), '') + ' ' + 'AND FCT.CODLINEADENEGOCIO      = ' + ISNULL(@p_CODLINEADENEGOCIO, '') + ' ' + 'AND FCT.CODIGOAGRUPACIONGTECH  = ' + ISNULL(TO_NUMBER(@pg_CADENA), '') + ' ' + ' AND  NOT(PRD.CODIGOGTECHPRODUCTO IN ('  + ISNULL(@p_STRCODIGOEXCEP, '') + '))  GROUP BY FCT.CODIGOAGRUPACIONGTECH, ' + 'FCT.CODIGOGTECHPUNTODEVENTA, ' + 'FCT.NUMEROTERMINAL, ' + 'PDV.NOMPUNTODEVENTA ' + 'ORDER BY FCT.CODIGOAGRUPACIONGTECH, FCT.CODIGOGTECHPUNTODEVENTA';
        EXECUTE (@xTMPQUERY);
    END 

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteDinamicoCadProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteDinamicoCadProducto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteDinamicoCadProducto(@p_CODPRODUCTO NUMERIC(22,0),
                                            @pg_CADENA     NVARCHAR(2000)
                                             ) AS
 BEGIN
      DECLARE @xTRNSXCOLUMN VARCHAR(MAX) = '';
      DECLARE @xSALESCOLUMN VARCHAR(MAX) = '';
     
    SET NOCOUNT ON;
       SELECT  FCT.CODIGOAGRUPACIONGTECH   AS CADENA,
              FCT.CODIGOGTECHPUNTODEVENTA AS CodigoPVTa,
              FCT.NUMEROTERMINAL          AS Terminal,
              PDV.NOMPUNTODEVENTA         AS "Nombre PVTA",
              SUM(FCT.CANTIDADVENTA)      AS "Cantidad Ventas",
              SUM(FCT.VALORVENTA)         AS Ventas,
              SUM(FCT.CANTIDADANULACION)  AS "Cantidad Anulaciones",
              SUM(FCT.VALORANULACION)     AS Anulaciones,
              SUM(FCT.IMPUESTO_IVA)       AS "Iva Producto",
              SUM(FCT.VALORVENTABRUTA)    AS "Ventas Brutas",
              SUM(FCT.VALORCOMISION)      AS "Valor Comision",
              SUM(FCT.VATCOMISION)        AS "Iva Comision",
              SUM(FCT.VALORCOMISIONBRUTA) AS "Ingreso Bruto",
              SUM(FCT.RETENCION_RENTA)    AS "ReteRenta",
              SUM(FCT.RETENCION_RETEICA)  AS ReteICA,
              SUM(FCT.RETENCION_RETEIVA)  AS ReteIVA,
              SUM(FCT.VALORCOMISIONNETA)  AS "Ingreso PDV Neto",
              SUM(FCT.FACTURADOENCONTRAGTECH - FCT.FACTURADOAFAVORGTECH)     AS "Total a pagar"
      FROM WSXML_SFG.VW_SHOW_PDVFACTURACION FCT
      INNER JOIN WSXML_SFG.PUNTODEVENTA PDV ON (PDV.ID_PUNTODEVENTA = FCT.ID_PUNTODEVENTA)
      WHERE FCT.ID_CICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE())
      AND FCT.ID_PRODUCTO=@p_CODPRODUCTO
      AND FCT.CODIGOAGRUPACIONGTECH  =  @pg_CADENA
      GROUP BY FCT.CODIGOAGRUPACIONGTECH,FCT.CODIGOGTECHPUNTODEVENTA,FCT.NUMEROTERMINAL,PDV.NOMPUNTODEVENTA
      ORDER BY FCT.CODIGOAGRUPACIONGTECH, FCT.CODIGOGTECHPUNTODEVENTA;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena(@p_CADENA_BASE NUMERIC(22,0),
                                        @p_CADENA_SIMULADA      NUMERIC(22,0)) AS
 BEGIN

    DECLARE @v_CADENA_BASE     NUMERIC(22,0) = @p_CADENA_BASE;
    DECLARE @v_CADENA_SIMULADA NUMERIC(22,0) = @p_CADENA_SIMULADA;
   
  SET NOCOUNT ON;

     SELECT CTR.FECHAARCHIVO AS FECHA,
            PDV.CODIGOGTECHPUNTODEVENTA AS POS,
            PDV.NOMPUNTODEVENTA AS PUNTODEVENTA,
            TPV.NOMTIPOCONTRATOPDV AS CONTRATOPDV,
            LDN.NOMLINEADENEGOCIO AS LINEADENEGOCIO,
            TPR.NOMTIPOPRODUCTO AS TIPOPRODCTO,
            PRD.CODIGOGTECHPRODUCTO AS CODE,
            PRD.NOMPRODUCTO AS PRODUCTO,
            SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                   REG.NUMTRANSACCIONES
                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                   REG.NUMTRANSACCIONES * (-1)
                  ELSE
                   0
                END) AS TRANSACCIONES,
            SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                   REG.VALORTRANSACCION
                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                   REG.VALORTRANSACCION * (-1)
                  ELSE
                   0
                END) AS VENTAS,
            CONVERT(VARCHAR, ROUND(SUM(CASE
                          WHEN REG.CODTIPOREGISTRO = 1 THEN
                           REG.VALORVENTABRUTANOREDONDEADO
                          WHEN REG.CODTIPOREGISTRO = 2 THEN
                           REG.VALORVENTABRUTANOREDONDEADO * (-1)
                          ELSE
                           0
                        END),4)) AS BASECOMISION,
            SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 4 THEN
                   REG.VALORTRANSACCION
                  ELSE
                   0
                END) AS PREMIOSPAGOS,
            RCM.NOMRANGOCOMISION AS COMISION,
            -- Comision Simulada
            CONVERT(VARCHAR, ROUND(SUM(CASE
                          WHEN REG.CODTIPOREGISTRO = 1 THEN
                           (REG.VALORVENTABRUTANOREDONDEADO *
                           (RCD.VALORPORCENTUAL / 100)) +
                           (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)
                          WHEN REG.CODTIPOREGISTRO = 2 THEN
                           (REG.VALORVENTABRUTANOREDONDEADO *
                           (RCD.VALORPORCENTUAL / 100) * (-1)) +
                           (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))
                          ELSE
                           0
                        END),4)) AS COMISIONSIMULADA,

            -- VAT Comision
            round(SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                   (REG.VALORVAT / 100)
                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100) * (-1)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                   (REG.VALORVAT / 100)
                  ELSE
                   0
                END),0 )AS IVACOMISION,
            -- Retefuente
            round(SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                   ISNULL(RET.RETEFUENTE, 0)
                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100) * (-1)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                   ISNULL(RET.RETEFUENTE, 0)
                  ELSE
                   0
                END),0) AS RETEFUENTE,
            -- ReteICA
            round(SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                   ISNULL(RET.RETEICA, 0)
                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100) * (-1)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                   ISNULL(RET.RETEICA, 0)
                  ELSE
                   0
                END),0) AS RETEICA,
            -- ReteIVA
            round(SUM(CASE
                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                   (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                   ((REG.VALORVENTABRUTANOREDONDEADO *
                   (RCD.VALORPORCENTUAL / 100) * (-1)) +
                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                   (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                  ELSE
                   0
                END),0) AS RETEIVA,
            --
            convert(varchar, ROUND(((SUM(CASE
                            WHEN REG.CODTIPOREGISTRO = 1 THEN
                             (REG.VALORVENTABRUTANOREDONDEADO *
                             (RCD.VALORPORCENTUAL / 100)) +
                             (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)
                            WHEN REG.CODTIPOREGISTRO = 2 THEN
                             (REG.VALORVENTABRUTANOREDONDEADO *
                             (RCD.VALORPORCENTUAL / 100) * (-1)) +
                             (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))
                            ELSE
                             0
                          END) +
                    -- VAT Comision
                    (round(SUM(CASE
                            WHEN REG.CODTIPOREGISTRO = 1 THEN
                             ((REG.VALORVENTABRUTANOREDONDEADO *
                             (RCD.VALORPORCENTUAL / 100)) +
                             (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                             (REG.VALORVAT / 100)
                            WHEN REG.CODTIPOREGISTRO = 2 THEN
                             ((REG.VALORVENTABRUTANOREDONDEADO *
                             (RCD.VALORPORCENTUAL / 100) * (-1)) +
                             (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                             (REG.VALORVAT / 100)
                            ELSE
                             0
                          END),0)))),4)
                    -- Retefuente
                    - (round(SUM(CASE
                              WHEN REG.CODTIPOREGISTRO = 1 THEN
                               ((REG.VALORVENTABRUTANOREDONDEADO *
                               (RCD.VALORPORCENTUAL / 100)) +
                               (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                               ISNULL(RET.RETEFUENTE, 0)
                              WHEN REG.CODTIPOREGISTRO = 2 THEN
                               ((REG.VALORVENTABRUTANOREDONDEADO *
                               (RCD.VALORPORCENTUAL / 100) * (-1)) +
                               (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                               ISNULL(RET.RETEFUENTE, 0)
                              ELSE
                               0
                            END),4) +
                    -- ReteICA
                    round(SUM(CASE
                              WHEN REG.CODTIPOREGISTRO = 1 THEN
                               ((REG.VALORVENTABRUTANOREDONDEADO *
                               (RCD.VALORPORCENTUAL / 100)) +
                               (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                               ISNULL(RET.RETEICA, 0)
                              WHEN REG.CODTIPOREGISTRO = 2 THEN
                               ((REG.VALORVENTABRUTANOREDONDEADO *
                               (RCD.VALORPORCENTUAL / 100) * (-1)) +
                               (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                               ISNULL(RET.RETEICA, 0)
                              ELSE
                               0
                            END),4) +
                    -- ReteIVA
                    round(SUM(CASE
                              WHEN REG.CODTIPOREGISTRO = 1 THEN
                               ((REG.VALORVENTABRUTANOREDONDEADO *
                               (RCD.VALORPORCENTUAL / 100)) +
                               (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                               (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                              WHEN REG.CODTIPOREGISTRO = 2 THEN
                               ((REG.VALORVENTABRUTANOREDONDEADO *
                               (RCD.VALORPORCENTUAL / 100) * (-1)) +
                               (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                               (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                              ELSE
                               0
                            END),4))) as COMIS_NETA,

            rcm2.nomrangocomision as PORCT_COMISION_REAL,

            round(convert(varchar, SUM(CASE
                                WHEN REG.CODTIPOREGISTRO = 1 THEN
                                 reg.VALORCOMISIONNOREDONDEADO
                              --REG.Valorcomision
                                WHEN REG.CODTIPOREGISTRO = 2 THEN
                                 REG.VALORCOMISIONNOREDONDEADO * (-1)
                              --REG.Valorcomision * (-1)
                                ELSE
                                 0
                              END)),0) AS COMISIONAPLICADA,

            -- VAT Comision real
            round(SUM(CASE
                        WHEN REG.CODTIPOREGISTRO = 1 THEN
                         REG.VALORCOMISIONNOREDONDEADO * (REG.VALORVAT / 100)
                        WHEN REG.CODTIPOREGISTRO = 2 THEN
                         (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100)

                        ELSE
                         0
                      END),0) AS IVACOMISION_REAL,
            -- Retefuente real
            round(SUM(CASE
                        WHEN REG.CODTIPOREGISTRO = 1 THEN
                         REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEFUENTE, 0)
                        WHEN REG.CODTIPOREGISTRO = 2 THEN
                         (REG.VALORCOMISIONNOREDONDEADO * (-1)) *
                         ISNULL(RET.RETEFUENTE, 0)
                        ELSE
                         0
                      END),0) AS RETEFUENTE_REAL,
            -- ReteICA REAL
            round(SUM(CASE
                        WHEN REG.CODTIPOREGISTRO = 1 THEN
                         REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEICA, 0)
                        WHEN REG.CODTIPOREGISTRO = 2 THEN
                         (REG.VALORCOMISIONNOREDONDEADO * (-1)) * ISNULL(RET.RETEICA, 0)
                        ELSE
                         0
                      END),0) AS RETEICA_REAL,
            -- ReteIVA REAL
            round(SUM(CASE
                        WHEN REG.CODTIPOREGISTRO = 1 THEN
                         (REG.VALORCOMISIONNOREDONDEADO) * (REG.VALORVAT / 100) *
                         ISNULL(RET.RETEIVA, 0)
                        WHEN REG.CODTIPOREGISTRO = 2 THEN
                         (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100) *
                         ISNULL(RET.RETEIVA, 0)
                        ELSE
                         0
                      END),0) AS RETEIVA_REAL,

            convert(varchar, (round(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORCOMISIONNOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORCOMISIONNOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),0) + -- VAT Comision real
                    round(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORCOMISIONNOREDONDEADO * (REG.VALORVAT / 100)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100)
                                 ELSE
                                  0
                               END),0)) -
                    -- Retefuente real
                    (round(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEFUENTE, 0)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORCOMISIONNOREDONDEADO * (-1)) *
                                  ISNULL(RET.RETEFUENTE, 0)
                                 ELSE
                                  0
                               END),0) +
                    -- ReteICA REAL
                    round(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEICA, 0)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORCOMISIONNOREDONDEADO * (-1)) * ISNULL(RET.RETEICA, 0)
                                 ELSE
                                  0
                               END),0) +
                    -- ReteIVA REAL
                    round(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORCOMISIONNOREDONDEADO) * (REG.VALORVAT / 100) *
                                  ISNULL(RET.RETEIVA, 0)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100) *
                                  ISNULL(RET.RETEIVA, 0)
                                 ELSE
                                  0
                               END),0))) AS VRCOMISIONNETA_REAL,

            -- Comision Simulada
            convert(varchar, CONVERT(VARCHAR, ROUND(SUM(CASE
                                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                                   (REG.VALORVENTABRUTANOREDONDEADO *
                                   (RCD.VALORPORCENTUAL / 100)) +
                                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)
                                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                                   (REG.VALORVENTABRUTANOREDONDEADO *
                                   (RCD.VALORPORCENTUAL / 100) * (-1)) +
                                   (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))
                                  ELSE
                                   0
                                END),4)) -
                    --Comision Aplicada
                    round(SUM(CASE
                                WHEN REG.CODTIPOREGISTRO = 1 THEN
                                 REG.VALORCOMISIONNOREDONDEADO
                                WHEN REG.CODTIPOREGISTRO = 2 THEN
                                 REG.VALORCOMISIONNOREDONDEADO * (-1)
                                ELSE
                                 0
                              END),0)) AS DIF_COMISION,

            -- VAT Comision
            ROUND(SUM(CASE
                   WHEN REG.CODTIPOREGISTRO = 1 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                    (REG.VALORVAT / 100)
                   WHEN REG.CODTIPOREGISTRO = 2 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100) * (-1)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                    (REG.VALORVAT / 100)
                   ELSE
                    0
                 END),4) -

            -- VAT Comision real
             round(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REG.VALORCOMISIONNOREDONDEADO * (REG.VALORVAT / 100)
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100)
                         ELSE
                          0
                       END),0) AS DIF_IVACOMISION,

            -- Retefuente
            ROUND(SUM(CASE
                   WHEN REG.CODTIPOREGISTRO = 1 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                    ISNULL(RET.RETEFUENTE, 0)
                   WHEN REG.CODTIPOREGISTRO = 2 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100) * (-1)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                    ISNULL(RET.RETEFUENTE, 0)
                   ELSE
                    0
                 END),4) -

            -- Retefuente real
             round(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEFUENTE, 0)
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          (REG.VALORCOMISIONNOREDONDEADO * (-1)) *
                          ISNULL(RET.RETEFUENTE, 0)
                         ELSE
                          0
                       END),0) AS DIF_RETEFUENTE,

            -- ReteICA
            ROUND(SUM(CASE
                   WHEN REG.CODTIPOREGISTRO = 1 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                    ISNULL(RET.RETEICA, 0)
                   WHEN REG.CODTIPOREGISTRO = 2 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100) * (-1)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                    ISNULL(RET.RETEICA, 0)
                   ELSE
                    0
                 END),4) -

            -- ReteICA REAL
             round(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEICA, 0)
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          (REG.VALORCOMISIONNOREDONDEADO * (-1)) * ISNULL(RET.RETEICA, 0)
                         ELSE
                          0
                       END),0) AS DIF_RETEICA,

            -- ReteIVA
            ROUND(SUM(CASE
                   WHEN REG.CODTIPOREGISTRO = 1 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                    (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                   WHEN REG.CODTIPOREGISTRO = 2 THEN
                    ((REG.VALORVENTABRUTANOREDONDEADO *
                    (RCD.VALORPORCENTUAL / 100) * (-1)) +
                    (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                    (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                   ELSE
                    0
                 END),4) -
            -- ReteIVA REAL
             round(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          (REG.VALORCOMISIONNOREDONDEADO) * (REG.VALORVAT / 100) *
                          ISNULL(RET.RETEIVA, 0)
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100) *
                          ISNULL(RET.RETEIVA, 0)
                         ELSE
                          0
                       END),0) AS DIF_RETEIVA,

            convert(varchar, (((ROUND(SUM(CASE
                             WHEN REG.CODTIPOREGISTRO = 1 THEN
                              (REG.VALORVENTABRUTANOREDONDEADO *
                              (RCD.VALORPORCENTUAL / 100)) +
                              (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)
                             WHEN REG.CODTIPOREGISTRO = 2 THEN
                              (REG.VALORVENTABRUTANOREDONDEADO *
                              (RCD.VALORPORCENTUAL / 100) * (-1)) +
                              (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))
                             ELSE
                              0
                           END),4) +
                    -- VAT Comision
                    ROUND(SUM(CASE
                             WHEN REG.CODTIPOREGISTRO = 1 THEN
                              ((REG.VALORVENTABRUTANOREDONDEADO *
                              (RCD.VALORPORCENTUAL / 100)) +
                              (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                              (REG.VALORVAT / 100)
                             WHEN REG.CODTIPOREGISTRO = 2 THEN
                              ((REG.VALORVENTABRUTANOREDONDEADO *
                              (RCD.VALORPORCENTUAL / 100) * (-1)) +
                              (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                              (REG.VALORVAT / 100)
                             ELSE
                              0
                           END),0))
                    -- Retefuente
                    - ROUND((SUM(CASE
                               WHEN REG.CODTIPOREGISTRO = 1 THEN
                                ((REG.VALORVENTABRUTANOREDONDEADO *
                                (RCD.VALORPORCENTUAL / 100)) +
                                (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                                ISNULL(RET.RETEFUENTE, 0)
                               WHEN REG.CODTIPOREGISTRO = 2 THEN
                                ((REG.VALORVENTABRUTANOREDONDEADO *
                                (RCD.VALORPORCENTUAL / 100) * (-1)) +
                                (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                                ISNULL(RET.RETEFUENTE, 0)
                               ELSE
                                0
                             END)) +
                    -- ReteICA
                    ROUND(SUM(CASE
                               WHEN REG.CODTIPOREGISTRO = 1 THEN
                                ((REG.VALORVENTABRUTANOREDONDEADO *
                                (RCD.VALORPORCENTUAL / 100)) +
                                (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                                ISNULL(RET.RETEICA, 0)
                               WHEN REG.CODTIPOREGISTRO = 2 THEN
                                ((REG.VALORVENTABRUTANOREDONDEADO *
                                (RCD.VALORPORCENTUAL / 100) * (-1)) +
                                (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                                ISNULL(RET.RETEICA, 0)
                               ELSE
                                0
                             END),0) +
                    -- ReteIVA
                    ROUND(SUM(CASE
                               WHEN REG.CODTIPOREGISTRO = 1 THEN
                                ((REG.VALORVENTABRUTANOREDONDEADO *
                                (RCD.VALORPORCENTUAL / 100)) +
                                (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL)) *
                                (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                               WHEN REG.CODTIPOREGISTRO = 2 THEN
                                ((REG.VALORVENTABRUTANOREDONDEADO *
                                (RCD.VALORPORCENTUAL / 100) * (-1)) +
                                (REG.NUMTRANSACCIONES * RCD.VALORTRANSACCIONAL * (-1))) *
                                (REG.VALORVAT / 100) * ISNULL(RET.RETEIVA, 0)
                               ELSE
                                0
                             END),0),0))) -
                    ((round(SUM(CASE
                                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                                   REG.VALORCOMISIONNOREDONDEADO
                                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                                   REG.VALORCOMISIONNOREDONDEADO * (-1)
                                  ELSE
                                   0
                                END),0) + -- VAT Comision real
                    round(SUM(CASE
                                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                                   REG.VALORCOMISIONNOREDONDEADO * (REG.VALORVAT / 100)
                                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                                   (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100)
                                  ELSE
                                   0
                                END),0)) -
                    -- Retefuente real
                    (round(SUM(CASE
                                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                                   REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEFUENTE, 0)
                                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                                   (REG.VALORCOMISIONNOREDONDEADO * (-1)) *
                                   ISNULL(RET.RETEFUENTE, 0)
                                  ELSE
                                   0
                                END),0) +
                    -- ReteICA REAL
                    round(SUM(CASE
                                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                                   REG.VALORCOMISIONNOREDONDEADO * ISNULL(RET.RETEICA, 0)
                                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                                   (REG.VALORCOMISIONNOREDONDEADO * (-1)) * ISNULL(RET.RETEICA, 0)
                                  ELSE
                                   0
                                END),0) +
                    -- ReteIVA REAL
                    round(SUM(CASE
                                  WHEN REG.CODTIPOREGISTRO = 1 THEN
                                   (REG.VALORCOMISIONNOREDONDEADO) * (REG.VALORVAT / 100) *
                                   ISNULL(RET.RETEIVA, 0)
                                  WHEN REG.CODTIPOREGISTRO = 2 THEN
                                   (REG.VALORCOMISIONNOREDONDEADO * (-1)) * (REG.VALORVAT / 100) *
                                   ISNULL(RET.RETEIVA, 0)
                                  ELSE
                                   0
                                END),0)))) AS DIF_COMISION_NETA

     --
       FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
         ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.PUNTODEVENTA PDV
         ON (PDV.ID_PUNTODEVENTA = REG.CODPUNTODEVENTA)
      INNER JOIN WSXML_SFG.TIPOCONTRATOPDV TPV
         ON (TPV.ID_TIPOCONTRATOPDV = REG.CODTIPOCONTRATOPDV)
      INNER JOIN WSXML_SFG.PRODUCTO PRD
         ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
      INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
         ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
      INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
         ON (TPR.ID_TIPOPRODUCTO = PRD.CODTIPOPRODUCTO)
      INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN
         ON (LDN.ID_LINEADENEGOCIO = TPR.CODLINEADENEGOCIO)
     --
      INNER JOIN WSXML_SFG.RANGOCOMISION RCM2
         ON (RCM2.ID_RANGOCOMISION = reg.codrangocomision)
     --

      INNER JOIN WSXML_SFG.PLANTILLAPRODUCTO EST
         ON (EST.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO AND
            EST.MASTERPLANTILLA = 1)
       LEFT OUTER JOIN WSXML_SFG.PLANTILLAPRODUCTO DFA
         ON (DFA.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO AND
            DFA.CODAGRUPACIONPUNTODEVENTA =
            WSXML_SFG.AGRUPACION_F(@v_CADENA_BASE))
       LEFT OUTER JOIN WSXML_SFG.PLANTILLAPRODUCTODETALLE PLD
         ON (PLD.CODPLANTILLAPRODUCTO =
            COALESCE(DFA.ID_PLANTILLAPRODUCTO, EST.ID_PLANTILLAPRODUCTO) AND
            PLD.CODPRODUCTO = PRD.ID_PRODUCTO)
       LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION RCM
         ON (RCM.ID_RANGOCOMISION = PLD.CODRANGOCOMISION AND
            RCM.CODTIPOCOMISION IN (1, 2, 3))
       LEFT OUTER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RCD
         ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
       LEFT OUTER JOIN WSXML_SFG.CATEGORIAPAGO CPG
         ON (CPG.ID_CATEGORIAPAGO = REG.CODCATEGORIAPAGO)
       LEFT OUTER JOIN (SELECT CODALIADOESTRATEGICO,
                               MAX(CASE
                                     WHEN CODRETENCIONTRIBUTARIA = 1 THEN
                                      VALOR / 100
                                   END) AS RETEFUENTE,
                               MAX(CASE
                                     WHEN CODRETENCIONTRIBUTARIA = 2 THEN
                                      VALOR / 100
                                   END) AS RETEICA,
                               MAX(CASE
                                     WHEN CODRETENCIONTRIBUTARIA = 3 THEN
                                      VALOR / 100
                                   END) AS RETEIVA
                          FROM WSXML_SFG.RETENCIONALIADOESTRATEGICO
                         GROUP BY CODALIADOESTRATEGICO) RET
         ON (RET.CODALIADOESTRATEGICO = AES.ID_ALIADOESTRATEGICO)

      WHERE CODCICLOFACTURACIONPDV =
            WSXML_SFG.ultimo_ciclofacturacion(getdate())
        AND REG.CODAGRUPACIONPUNTODEVENTA =
            WSXML_SFG.AGRUPACION_F(@v_CADENA_SIMULADA)

      GROUP BY CTR.FECHAARCHIVO,
               PDV.CODIGOGTECHPUNTODEVENTA,
               PDV.NOMPUNTODEVENTA,
               LDN.ID_LINEADENEGOCIO,
               LDN.NOMLINEADENEGOCIO,
               TPR.ID_TIPOPRODUCTO,
               TPR.NOMTIPOPRODUCTO,
               PRD.CODIGOGTECHPRODUCTO,
               PRD.NOMPRODUCTO,
               RCM.ID_RANGOCOMISION,
               RCM.NOMRANGOCOMISION,
               CPG.ID_CATEGORIAPAGO,
               CPG.NOMCATEGORIAPAGO,
               CPG.VARIABLEPORCENTUAL,
               CPG.VARIABLETRANSACCIONAL,
               TPV.NOMTIPOCONTRATOPDV,
               rcm2.nomrangocomision
      ORDER BY FECHAARCHIVO,
               CAST(CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0)),
               ID_LINEADENEGOCIO,
               ID_TIPOPRODUCTO,
               CAST(CODIGOGTECHPRODUCTO AS NUMERIC(38,0));
  END; 
  GO


IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena27', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena27;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena27(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                          @pg_CADENA                NVARCHAR(2000),
                                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                         @pg_PRODUCTO              NVARCHAR(2000)
                                          ) AS
 BEGIN

    DECLARE @v_CADENA_BASE     NUMERIC(22,0) = 27;
    DECLARE @v_CADENA_SIMULADA NUMERIC(22,0) = 563;
   
  SET NOCOUNT ON;

    EXEC WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena @v_CADENA_BASE, @v_CADENA_SIMULADA

  END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena37', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena37;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena37(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                          @pg_CADENA                NVARCHAR(2000),
                                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                         @pg_PRODUCTO              NVARCHAR(2000)
                                          ) AS
 BEGIN

    DECLARE @v_CADENA_BASE     NUMERIC(22,0) = 37;
    DECLARE @v_CADENA_SIMULADA NUMERIC(22,0) = 563;
   
  SET NOCOUNT ON;

    EXEC WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena @v_CADENA_BASE, @v_CADENA_SIMULADA

  END
GO



IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena279', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena279;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena279(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                         @pg_CADENA                NVARCHAR(2000),
                                         @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                        @pg_PRODUCTO              NVARCHAR(2000)
                                         ) AS
 BEGIN

  DECLARE @v_CADENA_BASE     NUMERIC(22,0) = 348;
  DECLARE @v_CADENA_SIMULADA NUMERIC(22,0) = 279;
 
SET NOCOUNT ON;

  EXEC WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComparComisionCadena @v_CADENA_BASE, @v_CADENA_SIMULADA

END
GO



IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReportePrueba', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReportePrueba;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReportePrueba(
                         @pg_PRODUCTO              NVARCHAR(2000)
                          ) AS

  BEGIN
  SET NOCOUNT ON;

      SELECT convert(datetime, convert(date,GETDATE())) as DIA;
  END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_BinesCityBankMensual', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_BinesCityBankMensual;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_BinesCityBankMensual (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS
  BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;

    
   SET NOCOUNT ON;
        SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
     EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT


      IF FORMAT(GETDATE(), 'dd-MM-yyyy') ='31-01-2011'
        --- Ejecucion 31 de Enero con informacion 1 a 17 de Enero




          SELECT 'BIN Nomina ' + isnull(bintarjeta, '') AS Bin,
          SUM(rfr.valortransaccion) AS Valor,
          count(rfr.id_registrofactreferencia) Tx
          FROM wsxml_sfg.registrofacturacion    rf,
          wsxml_sfg.registrofactreferencia rfr,
          wsxml_sfg.entradaarchivocontrol  ea
          WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
          AND rf.id_registrofacturacion = rfr.codregistrofacturacion
          AND ea.fechaarchivo BETWEEN CONVERT(DATETIME, '01/01/2011') AND CONVERT(DATETIME, '17/01/2011')
          AND rf.codproducto = 935
          AND rf.codtiporegistro = 1
          AND rfr.tipotransaccion = 'F'
          AND rfr.estado = 'A'
          AND rfr.bintarjeta = '426288'
          GROUP BY bintarjeta
          UNION
          SELECT 'BIN Otros ' + isnull(bintarjeta, '') AS BIN,
          SUM(rfr.valortransaccion) AS Valor,
          count(rfr.id_registrofactreferencia) Tx
          FROM wsxml_sfg.registrofacturacion    rf,
          wsxml_sfg.registrofactreferencia rfr,
          wsxml_sfg.entradaarchivocontrol  ea
          WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
          AND rf.id_registrofacturacion = rfr.codregistrofacturacion
          AND ea.fechaarchivo BETWEEN CONVERT(DATETIME, '01/01/2011') AND CONVERT(DATETIME, '17/01/2011')
          AND rf.codproducto = 935
          AND rf.codtiporegistro = 1
          AND rfr.tipotransaccion = 'F'
          AND rfr.estado = 'A'
          AND rfr.bintarjeta <> '426288'
          GROUP BY bintarjeta;




        ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy') ='01-02-2011' BEGIN
        --- Ejecucion 01 de Febrero con informacion 18 a 31 de Enero
          IF FORMAT(GETDATE(), 'HH24')   > 7 
              ---- Ejecucion 8 am informacion 18 a 31 de Enero

            SELECT 'BIN Nomina ' + isnull(bintarjeta, '') AS Bin,
            SUM(rfr.valortransaccion) AS Valor,
            count(rfr.id_registrofactreferencia) Tx
            FROM wsxml_sfg.registrofacturacion    rf,
            wsxml_sfg.registrofactreferencia rfr,
            wsxml_sfg.entradaarchivocontrol  ea
            WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
            AND rf.id_registrofacturacion = rfr.codregistrofacturacion
            AND ea.fechaarchivo BETWEEN CONVERT(DATETIME, '18/01/2011') AND CONVERT(DATETIME, '31/01/2011')
            AND rf.codproducto = 935
            AND rf.codtiporegistro = 1
            AND rfr.tipotransaccion = 'F'
            AND rfr.estado = 'A'
            AND rfr.bintarjeta = '426288'
            GROUP BY bintarjeta
            UNION
            SELECT 'BIN Otros ' + isnull(bintarjeta, '') AS BIN,
            SUM(rfr.valortransaccion) AS Valor,
            count(rfr.id_registrofactreferencia) Tx
            FROM wsxml_sfg.registrofacturacion    rf,
            wsxml_sfg.registrofactreferencia rfr,
            wsxml_sfg.entradaarchivocontrol  ea
            WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
            AND rf.id_registrofacturacion = rfr.codregistrofacturacion
            AND ea.fechaarchivo BETWEEN CONVERT(DATETIME, '18/01/2011') AND CONVERT(DATETIME, '31/01/2011')
            AND rf.codproducto = 935
            AND rf.codtiporegistro = 1
            AND rfr.tipotransaccion = 'F'
            AND rfr.estado = 'A'
            AND rfr.bintarjeta <> '426288'
            GROUP BY bintarjeta;

          ELSE
              ---- Ejecucion antes de las 8 am ejecucion normal

            SELECT 'BIN Nomina ' + isnull(bintarjeta, '') AS Bin,
            SUM(rfr.valortransaccion) AS Valor,
            count(rfr.id_registrofactreferencia) Tx
            FROM wsxml_sfg.registrofacturacion    rf,
            wsxml_sfg.registrofactreferencia rfr,
            wsxml_sfg.entradaarchivocontrol  ea
            WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
            AND rf.id_registrofacturacion = rfr.codregistrofacturacion
            AND ea.fechaarchivo BETWEEN @sFECHAFRST AND @sFECHALAST
            AND rf.codproducto = 935
            AND rf.codtiporegistro = 1
--            AND rfr.tipotransaccion = 'F'
            AND rfr.estado = 'A'
            AND rfr.bintarjeta = '426288'
            GROUP BY bintarjeta
            UNION
            SELECT 'BIN Otros ' + isnull(bintarjeta, '') AS BIN,
            SUM(rfr.valortransaccion) AS Valor,
            count(rfr.id_registrofactreferencia) Tx
            FROM wsxml_sfg.registrofacturacion    rf,
            wsxml_sfg.registrofactreferencia rfr,
            wsxml_sfg.entradaarchivocontrol  ea
            WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
            AND rf.id_registrofacturacion = rfr.codregistrofacturacion
            AND ea.fechaarchivo BETWEEN @sFECHAFRST AND @sFECHALAST
            AND rf.codproducto = 935
            AND rf.codtiporegistro = 1
--            AND rfr.tipotransaccion = 'F'
            AND rfr.estado = 'A'
            AND rfr.bintarjeta <> '426288'
            GROUP BY bintarjeta;






        END ELSE
        --- Flujo Normal


          SELECT 'BIN Nomina ' + isnull(bintarjeta, '') AS Bin,
          SUM(rfr.valortransaccion) AS Valor,
          count(rfr.id_registrofactreferencia) Tx
          FROM wsxml_sfg.registrofacturacion    rf,
          wsxml_sfg.registrofactreferencia rfr,
          wsxml_sfg.entradaarchivocontrol  ea
          WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
          AND rf.id_registrofacturacion = rfr.codregistrofacturacion
          AND ea.fechaarchivo BETWEEN @sFECHAFRST AND @sFECHALAST
          AND rf.codproducto = 935
          AND rf.codtiporegistro = 1
--          AND rfr.tipotransaccion = 'F'
          AND rfr.estado = 'A'
          AND rfr.bintarjeta = 426288
          GROUP BY bintarjeta
          UNION
          SELECT 'BIN Otros ' + isnull(bintarjeta, '') AS BIN,
          SUM(rfr.valortransaccion) AS Valor,
          count(rfr.id_registrofactreferencia) Tx
          FROM wsxml_sfg.registrofacturacion    rf,
          wsxml_sfg.registrofactreferencia rfr,
          wsxml_sfg.entradaarchivocontrol  ea
          WHERE ea.id_entradaarchivocontrol = rf.codentradaarchivocontrol
          AND rf.id_registrofacturacion = rfr.codregistrofacturacion
          AND ea.fechaarchivo BETWEEN @sFECHAFRST AND @sFECHALAST
          AND rf.codproducto = 935
          AND rf.codtiporegistro = 1
--          AND rfr.tipotransaccion = 'F'
          AND rfr.estado = 'A'
          AND rfr.bintarjeta <> 426288
          GROUP BY bintarjeta;




  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ValorAnulacionesBaloto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ValorAnulacionesBaloto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ValorAnulacionesBaloto(    @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS
  BEGIN
    DECLARE @vMAXCICLO  NUMERIC(22,0);
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;

      SELECT   @vMAXCICLO = MAX(ID_CICLOFACTURACIONPDV)  FROM WSXML_SFG.CICLOFACTURACIONPDV;
      SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = CASE WHEN @p_CODCICLOFACTURACIONPDV = -1 THEN  @vMAXCICLO ELSE @p_CODCICLOFACTURACIONPDV END;
      EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT


    SELECT
          T1.FECHAARCHIVO                 AS  Fecha
        , T2.CODIGOGTECHPRODUCTO             AS  CodigoProducto
        , T2.NOMPRODUCTO                 AS  Producto
        , SUM(ISNULL(T3.NUMTRANSACCIONES,0))             AS  Tx
        , ROUND(SUM
          (
            CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN ISNULL(T3.VALORTRANSACCION,0)
               WHEN  T3.CODTIPOREGISTRO = 2 THEN ISNULL(T3.VALORTRANSACCION,0) * -1
               ELSE  0
            END
          ),2)                     AS  ValorAjuste
        , ROUND(SUM
          (
            CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN ISNULL(T3.VALORVENTABRUTANOREDONDEADO,0)
               WHEN  T3.CODTIPOREGISTRO = 2 THEN ISNULL(T3.VALORVENTABRUTANOREDONDEADO,0) * -1
               ELSE  0
            END
          ),2)                     AS  ValorSinIva

    FROM
         WSXML_SFG.ENTRADAARCHIVOCONTROL             T1
        ,WSXML_SFG.REGISTROFACTURACION               T3
        ,WSXML_SFG.PRODUCTO                         T2
    WHERE       T1.ID_ENTRADAARCHIVOCONTROL  =  T3.CODENTRADAARCHIVOCONTROL
    AND       T3.CODPRODUCTO                 =   T2.ID_PRODUCTO
    AND       T1.FECHAARCHIVO                BETWEEN @sFECHAFRST AND @sFECHALAST
    AND       T3.CODTIPOREGISTRO                 =   2
    AND       T2.CODIGOGTECHPRODUCTO                 =   '10002'
    GROUP BY     T1.FECHAARCHIVO
            , T2.CODIGOGTECHPRODUCTO
            , T2.NOMPRODUCTO
    ORDER BY     1 ASC;
  END; 
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ValorFreeTicketsBaloto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ValorFreeTicketsBaloto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ValorFreeTicketsBaloto(    @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS
  BEGIN
    DECLARE @vMAXCICLO   NUMERIC(22,0);
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;

      SELECT   @vMAXCICLO = MAX(ID_CICLOFACTURACIONPDV)  FROM WSXML_SFG.CICLOFACTURACIONPDV;
      SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = CASE WHEN @p_CODCICLOFACTURACIONPDV = -1 THEN  @vMAXCICLO ELSE @p_CODCICLOFACTURACIONPDV END;
      EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT


    SELECT
          T1.FECHAARCHIVO                 AS  Fecha
        , T2.CODIGOGTECHPRODUCTO             AS  CodigoProducto
        , T2.NOMPRODUCTO                 AS  Producto
        , SUM(ISNULL(T3.NUMTRANSACCIONES,0))             AS  Tx
        , ROUND(SUM
          (
            CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN ISNULL(T3.VALORTRANSACCION,0)
               WHEN  T3.CODTIPOREGISTRO = 2 THEN ISNULL(T3.VALORTRANSACCION,0) * -1
               ELSE  0
            END
          ),2)                     AS  ValorAjuste
        , ROUND(SUM
          (
            CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN ISNULL(T3.VALORVENTABRUTANOREDONDEADO,0)
               WHEN  T3.CODTIPOREGISTRO = 2 THEN ISNULL(T3.VALORVENTABRUTANOREDONDEADO,0) * -1
               ELSE  0
            END
          ),2)                     AS  ValorSinIva

    FROM
         WSXML_SFG.ENTRADAARCHIVOCONTROL             T1
        ,WSXML_SFG.REGISTROFACTURACION             T3
        ,WSXML_SFG.PRODUCTO                   T2
    WHERE       T1.ID_ENTRADAARCHIVOCONTROL  =  T3.CODENTRADAARCHIVOCONTROL
    AND       T3.CODPRODUCTO                 =   T2.ID_PRODUCTO
    AND       T1.FECHAARCHIVO                BETWEEN @sFECHAFRST AND @sFECHALAST
    AND       T3.CODTIPOREGISTRO                 =   3
    AND       T2.CODIGOGTECHPRODUCTO                 =   '10002'
    GROUP BY     T1.FECHAARCHIVO
            , T2.CODIGOGTECHPRODUCTO
            , T2.NOMPRODUCTO
    ORDER BY     1 ASC;
  END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComisionPorContratoPRM', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComisionPorContratoPRM;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComisionPorContratoPRM (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS
  BEGIN
      DECLARE @p_MES   NUMERIC(22,0) = @p_CODCICLOFACTURACIONPDV;
      DECLARE @p_ANIO  NUMERIC(22,0) = @p_CODLINEADENEGOCIO;
   
  SET NOCOUNT ON;

      SELECT       ISNULL(FORMAT(CONVERT(DATETIME, CONVERT(DATE,'01-' + ISNULL(CONVERT(VARCHAR,@p_MES), '') + '-' + ISNULL(CONVERT(VARCHAR,@p_ANIO), ''))), 'Month'), '') + ' - ' +  ISNULL(@p_ANIO, '')   AS  Fecha
                  ,T1.NOMTIPOCONTRATOPDV                 AS  Contrato
                  , T2.CODIGOGTECHPUNTODEVENTA           AS  PuntoVenta
                  , SUM(
                      CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN  T3.VALORCOMISION
                         WHEN  T3.CODTIPOREGISTRO =   2     THEN  T3.VALORCOMISION * (-1)
                         ELSE  0
                      END
                       )                                  AS  ValorComision
                  , SUM(
                       CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN  T3.IVACOMISION
                         WHEN  T3.CODTIPOREGISTRO =   2     THEN  T3.IVACOMISION * (-1)
                         ELSE  0
                      END
                       )                                  AS  IvaComision

      FROM             WSXML_SFG.TIPOCONTRATOPDV                  T1
                  , WSXML_SFG.REGISTROFACTURACION                T3
                  , WSXML_SFG.PUNTODEVENTA                       T2
                  , WSXML_SFG.ENTRADAARCHIVOCONTROL               T4
      WHERE           T1.ID_TIPOCONTRATOPDV            =   T3.CODTIPOCONTRATOPDV
      AND           T2.ID_PUNTODEVENTA                =   T3.CODPUNTODEVENTA
      AND           T4.ID_ENTRADAARCHIVOCONTROL        =    T3.CODENTRADAARCHIVOCONTROL
      AND           T4.FECHAARCHIVO                    >=  CONVERT(DATETIME,  ISNULL(@p_ANIO, '') + '-' + ISNULL(@p_MES, '') + '-01 00:00:00')
      AND           T4.FECHAARCHIVO                    <=   DBO.LAST_DAY( CONVERT(DATETIME,  ISNULL(@p_ANIO, '') + '-' + ISNULL(@p_MES, '') + '-01 23:59:00') )
      AND           T3.CODTIPOREGISTRO                =  1
      GROUP BY       T2.CODIGOGTECHPUNTODEVENTA  , T1.NOMTIPOCONTRATOPDV
      ORDER BY       PuntoVenta ASC        , Contrato ASC;


   END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComisionPorContrato', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComisionPorContrato;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteComisionPorContrato (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS
  BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
    DECLARE @p_MES   NUMERIC(22,0) = @p_CODCICLOFACTURACIONPDV;
    DECLARE @p_ANIO  NUMERIC(22,0) = @p_CODLINEADENEGOCIO;
   
  SET NOCOUNT ON;

    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT


    SELECT       ISNULL(FORMAT(CONVERT(DATETIME, @sFECHACCLO), 'Month'), '') + ' - ' + ISNULL(FORMAT(@sFECHACCLO, 'yyyy'), '')  AS  Fecha
                ,T1.NOMTIPOCONTRATOPDV                 AS  Contrato
                , T2.CODIGOGTECHPUNTODEVENTA           AS  PuntoVenta
                , SUM(
                     CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN  T3.VALORCOMISION
                          WHEN  T3.CODTIPOREGISTRO =   2     THEN  T3.VALORCOMISION * (-1)
                          ELSE  0
                     END
                  )                                   AS  ValorComision
               , SUM(
                    CASE WHEN  T3.CODTIPOREGISTRO IN (1,3) THEN  T3.IVACOMISION
                         WHEN  T3.CODTIPOREGISTRO =   2     THEN  T3.IVACOMISION * (-1)
                         ELSE  0
                    END
                 )                                     AS  IvaComision

    FROM       WSXML_SFG.TIPOCONTRATOPDV                  T1
            , WSXML_SFG.REGISTROFACTURACION              T3
            , WSXML_SFG.PUNTODEVENTA                     T2
            , WSXML_SFG.ENTRADAARCHIVOCONTROL             T4
    WHERE       T1.ID_TIPOCONTRATOPDV          =   T3.CODTIPOCONTRATOPDV
    AND       T2.ID_PUNTODEVENTA              =   T3.CODPUNTODEVENTA
    AND       T4.ID_ENTRADAARCHIVOCONTROL      =  T3.CODENTRADAARCHIVOCONTROL
    AND       T4.FECHAARCHIVO                 BETWEEN @sFECHAFRST AND @sFECHALAST
    AND       T3.CODTIPOREGISTRO              =  1
    GROUP BY     T2.CODIGOGTECHPUNTODEVENTA  , T1.NOMTIPOCONTRATOPDV
    ORDER BY     PuntoVenta ASC        , Contrato ASC;


  END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffContable', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffContable;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffContable            (@P_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                         @P_CODLINEADENEGOCIO      NUMERIC(22,0),
                         @PG_CADENA                NVARCHAR(2000),
                         @PG_ALIADOESTRATEGICO     NVARCHAR(2000),
                        @PG_PRODUCTO              NVARCHAR(2000)
                         )
  AS

GO


IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffPlanos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffPlanos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffPlanos                (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS

GO


IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffDiferencia', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffDiferencia;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffDiferencia           (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
  AS
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffAliados', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffAliados;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_CutoffAliados           (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
    AS
    BEGIN
    SET NOCOUNT ON;

             SELECT   AL.ID_ALIADOESTRATEGICO AS ID
                      ,AL.NOMALIADOESTRATEGICO AS ALIADO
                      ,' ' AS TX
                      ,' ' AS VALOR
                      ,' ' AS REVENUE
                      ,' ' AS TX_
                      ,' ' AS VALOR_
                      ,' ' AS REVENUE_
                      ,' ' AS REVISION
             FROM    WSXML_SFG.ALIADOESTRATEGICO AL
             ORDER  BY AL.NOMALIADOESTRATEGICO;

    END
	
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_RentabilidadCadenaFecha', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_RentabilidadCadenaFecha;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_RentabilidadCadenaFecha(@p_fechainicio NVARCHAR(2000),
                    @p_fechafin NVARCHAR(2000),
                   @p_cadena  NVARCHAR(2000)
                    )
  AS
  BEGIN
      DECLARE @v_consulta VARCHAR(MAX);
      DECLARE @v_cadena VARCHAR(100);
      DECLARE @v_where_cadena VARCHAR(250);
      DECLARE @v_innerjoin_cadena VARCHAR(150);
   
  SET NOCOUNT ON;
         SET @v_cadena = RTRIM(LTRIM(@p_cadena));

         if  @p_cadena ='-1' begin
                SET @v_where_cadena = ' ';
                SET @v_innerjoin_cadena = ' ';
              end ELSE begin
                SET @v_where_cadena =  ' AND     APD.CODIGOAGRUPACIONGTECH IN ('+ isnull(@v_cadena, '') +') ';
                SET @v_innerjoin_cadena = ' INNER JOIN   AGRUPACIONPUNTODEVENTA APD ON (PRF.CODAGRUPACIONPUNTODEVENTA  = APD.ID_AGRUPACIONPUNTODEVENTA) ';
         END;

    SET @v_consulta  =  ' SELECT /*+ push_pred(PRF) */ ' +
    '          LDN.NOMLINEADENEGOCIO                          AS Linea de Negocio, ' +
    '          AES.NOMALIADOESTRATEGICO                       AS Aliado,           ' +
    '          AGP.NOMAGRUPACIONPRODUCTO                      AS Padre,            ' +
    '          PRD.CODIGOGTECHPRODUCTO                        AS Codigo,           ' +
    '          PRD.NOMPRODUCTO                                AS Producto,         ' +
    '          SUM(NumIngresos - NumAnulaciones)              AS Tx,               ' +
    '          SUM(IngresosBrutosNoRedondeo)                  AS Ingresos,         ' +
    '          SUM(RevenueBase)                               AS Revenue Base,     ' +
    '          SUM(RevenueTransaccion)                        AS Rangos,           ' +
    '          SUM(RevenueFijo)                               AS Fijo,             ' +
    '          SUM(RevenueTotal)                              AS Revenue Total,    ' +
    '          SUM(IngresoCorporativo)                        AS Ingreso Corp,     ' +
    '          SUM(IngresoLocal)                              AS Ingreso Local,    ' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2)                        ' +
    '                   THEN Comision ELSE 0 END)             AS Ingreso PDV Admin,' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV = 3                              ' +
    '                   THEN Comision ELSE 0 END)             AS Ingreso PDV Colab,' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2)                        ' +
    '                   THEN IvaComision ELSE 0 END)          AS IVA Ingreso PDV Admin,' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV = 3                              ' +
    '                   THEN IvaComision ELSE 0 END)          AS IVA Ingreso PDV Colab, ' +
    '          SUM(EgresoLocal)                               AS Costo de Venta,   ' +
    '          SUM(CostoICA)                                  AS ICA,              ' +
    '          SUM(CostoEtesa)                                AS Comision ETESA,   ' +
    '          SUM(CostoIC)                                   AS IC,               ' +
    '          SUM(CostoICAIC)                                AS ICA IC,           ' +
    '          SUM(CostoBadDebt)                              AS Bad Debt,         ' +
    '          SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS Mercadeo,         ' +
    '          SUM(CostoIvaNoDescontable)                     AS IVA Descontable,  ' +
    '          SUM(CostoIC108)                                AS IC 108,           ' +
    '          SUM(CostoICAIC108)                             AS ICA IC 108,       ' +
    '          SUM(UtilidadParcial)                           AS Utilidad Parcial  ' +
    ' FROM     VW_REVENUE_DIARIO PRF ' +
    ' INNER JOIN   PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO) ' +
    ' INNER JOIN   ALIADOESTRATEGICO      AES ON (AES.ID_ALIADOESTRATEGICO  = PRD.CODALIADOESTRATEGICO) ' +
    ' INNER JOIN   AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO) ' +
    ' ' + isnull(@v_innerjoin_cadena, '')  +
    ' INNER JOIN  LINEADENEGOCIO          LDN ON (PRF.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO) ' +
    ' WHERE     PRF.FECHAARCHIVO BETWEEN TO_DATE( ''' + isnull(@p_fechainicio, '') +''', ''dd/MM/yyyy'') AND TO_DATE( ''' + isnull(@p_fechafin, '') + ''', ''dd/MM/yyyy'') ' +
    '  ' + isnull(@v_where_cadena, '') +
    ' GROUP BY   LDN.NOMLINEADENEGOCIO, AES.NOMALIADOESTRATEGICO, AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO, PRD.NOMPRODUCTO ' +
    ' ORDER BY   LDN.NOMLINEADENEGOCIO, AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO';

    EXECUTE (@v_consulta);
  END
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_RentabilidadPuntoVentaFecha', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_RentabilidadPuntoVentaFecha;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_RentabilidadPuntoVentaFecha(@p_fechainicio NVARCHAR(2000),
                    @p_fechafin NVARCHAR(2000),
                   @p_cadena  NVARCHAR(2000)
                    )
  AS
  BEGIN
      DECLARE @v_consulta VARCHAR(MAX);
      DECLARE @v_cadena VARCHAR(100);
      DECLARE @v_where_cadena VARCHAR(250);
      DECLARE @v_innerjoin_cadena VARCHAR(150);
   
  SET NOCOUNT ON;
         SET @v_cadena = RTRIM(LTRIM(@p_cadena));

         if @p_cadena = '-1' begin
                SET @v_where_cadena = ' ';
                SET @v_innerjoin_cadena = ' ';
              end ELSE begin
                SET @v_where_cadena =  ' AND     APD.CODIGOAGRUPACIONGTECH IN ('+ isnull(@v_cadena, '') +') ';
                SET @v_innerjoin_cadena = ' INNER JOIN   AGRUPACIONPUNTODEVENTA APD ON (PRF.CODAGRUPACIONPUNTODEVENTA  = APD.ID_AGRUPACIONPUNTODEVENTA) ';
         END 

    SET @v_consulta  =  ' SELECT /*+ push_pred(PRF) */ ' +
    '          PRF.FECHAARCHIVO                                AS Fecha, ' +
    '          PDV.CODIGOGTECHPUNTODEVENTA                    AS Codigo Punto de Venta, ' +
    '          PDV.NOMPUNTODEVENTA                            AS Nombre Punto de Venta, ' +
    '          LDN.NOMLINEADENEGOCIO                          AS Linea de Negocio, ' +
    '          AES.NOMALIADOESTRATEGICO                       AS Aliado,           ' +
    '          AGP.NOMAGRUPACIONPRODUCTO                      AS Padre,            ' +
    '          PRD.CODIGOGTECHPRODUCTO                        AS Codigo Producto,  ' +
    '          PRD.NOMPRODUCTO                                AS Producto,         ' +
    '          SUM(NumIngresos - NumAnulaciones)              AS Tx,               ' +
    '          SUM(IngresosBrutosNoRedondeo)                  AS Ingresos,         ' +
    '          SUM(RevenueBase)                               AS Revenue Base,     ' +
    '          SUM(RevenueTransaccion)                        AS Rangos,           ' +
    '          SUM(RevenueFijo)                               AS Fijo,             ' +
    '          SUM(RevenueTotal)                              AS Revenue Total,    ' +
    '          SUM(IngresoCorporativo)                        AS Ingreso Corp,     ' +
    '          SUM(IngresoLocal)                              AS Ingreso Local,    ' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2)                        ' +
    '                   THEN Comision ELSE 0 END)             AS Ingreso PDV Admin,' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV = 3                              ' +
    '                   THEN Comision ELSE 0 END)             AS Ingreso PDV Colab,' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2)                        ' +
    '                   THEN IvaComision ELSE 0 END)          AS IVA Ingreso PDV Admin,' +
    '          SUM(CASE WHEN PRF.CODTIPOCONTRATOPDV = 3                              ' +
    '                   THEN IvaComision ELSE 0 END)          AS IVA Ingreso PDV Colab, ' +
    '          SUM(EgresoLocal)                               AS Costo de Venta,   ' +
    '          SUM(CostoICA)                                  AS ICA,              ' +
    '          SUM(CostoEtesa)                                AS Comision ETESA,   ' +
    '          SUM(CostoIC)                                   AS IC,               ' +
    '          SUM(CostoICAIC)                                AS ICA IC,           ' +
    '          SUM(CostoBadDebt)                              AS Bad Debt,         ' +
    '          SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS Mercadeo,         ' +
    '          SUM(CostoIvaNoDescontable)                     AS IVA Descontable,  ' +
    '          SUM(CostoIC108)                                AS IC 108,           ' +
    '          SUM(CostoICAIC108)                             AS ICA IC 108,       ' +
    '          SUM(UtilidadParcial)                           AS Utilidad Parcial  ' +
    ' FROM     VW_REVENUE_DIARIO PRF ' +
    ' INNER JOIN   PUNTODEVENTA           PDV ON (PRF.CODPUNTODEVENTA       = PDV.ID_PUNTODEVENTA)' +
    ' INNER JOIN   PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO) ' +
    ' INNER JOIN   ALIADOESTRATEGICO      AES ON (AES.ID_ALIADOESTRATEGICO  = PRD.CODALIADOESTRATEGICO) ' +
    ' INNER JOIN   AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO) ' +
    ' ' + isnull(@v_innerjoin_cadena, '')  +
    ' INNER JOIN  LINEADENEGOCIO          LDN ON (PRF.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO) ' +
    ' WHERE     PRF.FECHAARCHIVO BETWEEN TO_DATE( ''' + isnull(@p_fechainicio, '') +''', ''dd/MM/yyyy'') AND TO_DATE( ''' + isnull(@p_fechafin, '') + ''', ''dd/MM/yyyy'') ' +
    '  ' + isnull(@v_where_cadena, '') +
    ' GROUP BY   PRF.FECHAARCHIVO, PDV.CODIGOGTECHPUNTODEVENTA, PDV.NOMPUNTODEVENTA, LDN.NOMLINEADENEGOCIO, AES.NOMALIADOESTRATEGICO, AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO, PRD.NOMPRODUCTO ' +
    ' ORDER BY   PRF.FECHAARCHIVO, PDV.NOMPUNTODEVENTA, LDN.NOMLINEADENEGOCIO, AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO';

    EXECUTE (@v_consulta);
  END
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_MediosMagneticosFecha', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_MediosMagneticosFecha;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_MediosMagneticosFecha    (     @p_fechainicio NVARCHAR(2000),
                                      @p_fechafin NVARCHAR(2000)
                                        )
 AS
 BEGIN
   DECLARE @v_consulta NVARCHAR(MAX);

  
 SET NOCOUNT ON;



  SET @v_consulta  = 'SELECT  ' +
  'COMPANIA.NOMCOMPANIA      AS Compania' +
  ',RAZONSOCIAL.NOMRAZONSOCIAL     AS "Razon Social"' +
  ',TIPOCONTRATOPDV.NOMTIPOCONTRATOPDV  AS "Tipo de Contrato"       ' +
  ',RAZONSOCIAL.TELEFONOCONTACTO  AS Telefono           ' +
  ',RAZONSOCIAL.DIRECCIONCONTACTO AS Direccion           ' +
  ',RAZONSOCIAL.IDENTIFICACION ' + '-' + 'RAZONSOCIAL.DIGITOVERIFICACION AS Nit             ' +
  ',REGIMEN.NOMREGIMEN  AS Regimen           ' +
  ',CIUDAD.NOMCIUDAD    AS "Ciudad Domicilio Principal"   ' +
  ',CIUDAD.CIUDADDANE   AS "Cod dane Municipio"       ' +
  ',DEPARTAMENTO.DEPARTAMENTODANE  AS "Cod dane Departamento"     ' +
  ',DEPARTAMENTO.NOMDEPARTAMENTO   AS Departamento ' +
  ',SUM(ISNULL(PRE.INGRESOS, 0))   AS Ventas' +
  ',SUM(ISNULL(PRE.IVAPRODUCTO, 0)) AS "IVA producto"' +
  '  ,SUM(ISNULL(PRE.INGRESOSBRUTOS, 0))  AS "Ingresos Brutos"       ' +
  '  ,SUM(ISNULL(PRE.COMISION, 0))   AS Comision           ' +
  '  ,SUM(ISNULL(PRE.IVACOMISION, 0)) AS "IVA Comision"         ' +
  '  ,SUM(ISNULL(PRE.COMISIONBRUTA, 0)) AS "Comision Bruta"         ' +
  '  ,SUM(ISNULL(PRE.RETEFUENTE, 0))  AS ReteFuente           ' +
  '  ,SUM(ISNULL(PRE.RETEIVA, 0))     AS ReteIVA           ' +
  '  ,SUM(ISNULL(PRE.RETEICA, 0))     AS ReteICA           ' +
  '  ,SUM(ISNULL(PRE.COMISIONNETA, 0)) AS "Comision Neta"         ' +
  '  ,SUM(ISNULL(PRE.ANTICIPO, 0))     AS Anticipo           ' +
  'FROM WSXML_SFG.RAZONSOCIAL   ' +
  'INNER JOIN    ' +
  '  (        ' +
  '    SELECT /*+ push_pred(PRF) */                 ' +
  '     CODRAZONSOCIAL                      ' +
  '    ,CODTIPOCONTRATOPDV                    ' +
  '    ,CODCOMPANIA                                            ' +
  '    ,SUM(PRF.NUMINGRESOS)              AS NUMINGRESOS       ' +
  '    ,SUM(PRF.NUMANULACIONES)           AS NUMANULACIONES    ' +
  '    ,SUM(PRF.INGRESOS)                 AS INGRESOS          ' +
  '    ,SUM(PRF.ANULACIONES)              AS ANULACIONES       ' +
  '    ,SUM(PRF.INGRESOSVALIDOS)          AS INGRESOSVALIDOS   ' +
  '    ,SUM(PRF.IVAPRODUCTO)              AS IVAPRODUCTO       ' +
  '    ,SUM(PRF.INGRESOSBRUTOS)           AS INGRESOSBRUTOS    ' +
  '    ,SUM(PRF.COMISION)                 AS COMISION          ' +
  '    ,SUM(PRF.COMISIONANTICIPO)         AS COMISIONANTICIPO  ' +
  '    ,SUM(COMISION + COMISIONANTICIPO)  AS TOTALCOMISION     ' +
  '    ,SUM(PRF.IVACOMISION)              AS IVACOMISION       ' +
  '    ,SUM(PRF.COMISIONBRUTA)            AS COMISIONBRUTA     ' +
  '    ,SUM(PRF.RETEFUENTE)               AS RETEFUENTE        ' +
  '    ,sum(PRF.RETEUVT)                  AS RETEUVT           ' +
  '    ,SUM(PRF.RETEIVA)                  AS RETEIVA           ' +
  '    ,SUM(PRF.RETEICA)                  AS RETEICA           ' +
  '    ,SUM(PRF.COMISIONNETA)             AS COMISIONNETA      ' +
  '    ,SUM(PRF.COMISIONANTICIPO)         AS ANTICIPO          ' +
  '   FROM       WSXML_SFG.VW_PREFACTURACION_DIARIA PRF                ' +
  '   INNER JOIN   WSXML_SFG.LINEADENEGOCIO ON PRF.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO  ' +
  '   WHERE       PRF.FECHAARCHIVO BETWEEN CONVERT(VARCHAR,''' + isnull(@p_fechainicio, '')  +''',103) AND  CONVERT(VARCHAR,''' + isnull(@p_fechafin, '') + ''',103) ' +
  '   GROUP BY     CODRAZONSOCIAL,CODTIPOCONTRATOPDV,CODCOMPANIA  ' +
  '  ) PRE ON RAZONSOCIAL.ID_RAZONSOCIAL = PRE.CODRAZONSOCIAL  ' +
  '  LEFT OUTER JOIN WSXML_SFG.TIPOCONTRATOPDV ON PRE.CODTIPOCONTRATOPDV = TIPOCONTRATOPDV.ID_TIPOCONTRATOPDV ' +
  '  LEFT OUTER JOIN WSXML_SFG.COMPANIA ON PRE.CODCOMPANIA = COMPANIA.ID_COMPANIA ' +
  '  LEFT OUTER JOIN WSXML_SFG.REGIMEN ON RAZONSOCIAL.CODREGIMEN= REGIMEN.ID_REGIMEN  ' +
  '  LEFT OUTER JOIN WSXML_SFG.CIUDAD ON RAZONSOCIAL.CODCIUDAD = CIUDAD.ID_CIUDAD   ' +
  '  LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO ' +
  '  GROUP BY      COMPANIA.NOMCOMPANIA                  ' +
  '        ,RAZONSOCIAL.NOMRAZONSOCIAL            ' +
  '        ,TIPOCONTRATOPDV.NOMTIPOCONTRATOPDV    ' +
  '        ,RAZONSOCIAL.TELEFONOCONTACTO          ' +
  '        ,RAZONSOCIAL.DIRECCIONCONTACTO       ' +
   '	   ,RAZONSOCIAL.IDENTIFICACION ' + '-' + 'RAZONSOCIAL.DIGITOVERIFICACION  ' +
  '        ,REGIMEN.NOMREGIMEN  ' +
  '        ,CIUDAD.NOMCIUDAD    ' +
  '        ,CIUDAD.CIUDADDANE   ' +
  '        ,DEPARTAMENTO.DEPARTAMENTODANE ' +
  '        ,DEPARTAMENTO.NOMDEPARTAMENTO   ';

  EXECUTE sp_executesql @v_consulta;


 END
GO



IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_RecaudoBalotoDian', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_RecaudoBalotoDian;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_RecaudoBalotoDian  (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
    AS
    BEGIN
         DECLARE @vFECHACICLO DATETIME;
         DECLARE @vFIRSTDATE DATETIME;
         DECLARE @vLASTDATE  DATETIME;
         DECLARE @v_FECHA_I_C VARCHAR(30);
         DECLARE @v_FECHA_F_C VARCHAR(30);
         DECLARE @v_consulta VARCHAR(MAX);
     
    SET NOCOUNT ON;


   IF @p_CODCICLOFACTURACIONPDV = -1   BEGIN
                  SELECT @vLASTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(7), GETDATE(),120) + '-01')-1 ;
                  SELECT @vFIRSTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(7), @vLASTDATE,120) + '-01') ;
    END ELSE BEGIN
         SELECT  @vFECHACICLO = FECHAEJECUCION
         FROM    WSXML_SFG.CICLOFACTURACIONPDV
         WHERE   ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;

         EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @vFECHACICLO, @vFIRSTDATE OUT, @vLASTDATE OUT

    END


SET @vFIRSTDATE='20/apr/2017';
SET @vLASTDATE='30/apr/2017';

     SET @v_FECHA_I_C = FORMAT( @vFIRSTDATE,'dd/MM/yyyy');
     SET @v_FECHA_F_C = FORMAT( @vLASTDATE,'dd/MM/yyyy');



           SET @v_consulta  = 'SELECT   2          AS Modalidad                        ' +
           ', '' ''                            AS No. Acto Autorizacion            ' +
           ', '' ''                            AS Fecha acto                       ' +
           ', '' ''                            AS No. Contato de Concesion         ' +
           ', '' ''                            AS Fecha Contrato                   ' +
           ', '' ''                            AS Fecha Final Vigencia             ' +
           ', 6                                AS Elemento o equipo de Juego       ' +
           ', '' ''                            AS CNUMDE                           ' +
           ', '' ''                             AS Serial Equipo/Elemento/Termina   ' +
           ', ''GTECH''                        AS Marca Equipo/Elemento/Terminal   ' +
           ', ''TERMINAL DE JUEGO ISYS''        AS Modelo Equipo/Elemento/Termina   ' +
           ', 1                                AS Forma de tenencia legal          ' +
           ', '' ''                            AS Numero documento de Tenencia     ' +
           ', '' ''                            AS Fecha                            ' +
           ', '' ''                            AS Tipo de documento                ' +
           ', '' ''                             AS Numero de identificacion         ' +
           ', '' ''                              AS DV                               ' +
           ', '' ''                              AS Razon Social                     ' +
           ', PDV.NOMPUNTODEVENTA               AS Nombre del Establecimiento       ' +
           ', PDV.DIRECCION                     AS Direccion del Establecimiento    ' +
           ', PDV.CODIGOGTECHPUNTODEVENTA       AS Codigo Establecimiento           ' +
           ', PDV.NUMEROTERMINAL                AS Codigo Terminal                  ' +
           ', DPT.DEPARTAMENTODANE              AS Departamento                     ' +
           ', SUBSTR(CDA.CIUDADDANE,3,3)        AS Municipio                        ' +
           ', '' ''                             AS Valor del carton                 ' +
       ', '' ''                                 AS No. Espacios puestos sillas      ' +
       ', '' ''                                 AS Nombre de la rifa                ' +
       ', '' ''                                 AS Valor boleta                     ' +
       ', '' ''                                 AS No. Total boletas emitidas       ' +
       ', '' ''                                 AS No. Total boletas vendidas       ' +
       ', '' ''                                 AS Fecha Sorteo                     ' +
       ', '' ''                                 AS Valor total plan premios         ' +
       ', ISNULL(VRA.INGRESOSBRUTOSNANOREDONDEO,0) AS Base de Liquidacion              ' +
       ', '' ''                                 AS Valor IVA                        ' +
       ', 15                                     AS Tarifa                           ' +
       ', '' ''                                 AS Total Derechos exploracion       ' +
       ', '' ''                                 AS Total gastos admon               ' +
       ', '' ''                                 AS No. Formulario Litografico       ' +
    'FROM          PUNTODEVENTA      PDV                                                ' +
    'INNER JOIN        CIUDAD         CDA ON (PDV.CODCIUDAD  = CDA.ID_CIUDAD)          ' +
    'INNER JOIN       DEPARTAMENTO       DPT ON (DPT.ID_DEPARTAMENTO  = CDA.CODDEPARTAMENTO) ' +
    'LEFT OUTER JOIN  (                                                                      ' +
    '          SELECT        /*+ push_pred(VRA) */                                             ' +
    '                  VRA.CODPUNTODEVENTA                  AS CODPUNTODEVENTA,                ' +
    '                  ROUND(SUM(VRA.INGRESOSBRUTOSNANOREDONDEO), 0)     AS INGRESOSBRUTOSNANOREDONDEO  ' +
    '          FROM       VWKDAYLYREVENUEADJUSTMENTS VRA                                                 ' +
    '          INNER JOIN     PRODUCTO     PRD ON (VRA.CODPRODUCTO     = PRD.ID_PRODUCTO)                ' +
    '          INNER JOIN     TIPOPRODUCTO TPR ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)            ' +
    '          WHERE       VRA.FECHAARCHIVO BETWEEN TO_DATE(''' + ISNULL(@v_FECHA_I_C, '')  +''',''dd/MM/yyyy'') AND  TO_DATE(''' + ISNULL(@v_FECHA_F_C, '') + ''',''dd/MM/yyyy'') ' +
    '          AND       TPR.CODLINEADENEGOCIO      = 1     ' +
   -- '          AND       PRD.CODTIPOPRODUCTO        = 1     ' ||
   -- '          AND       VRA.CODPRODUCTO            = 155   ' ||
   -- ' 2012.11.02. Omar Rodriguez. cambio producto ' ||
    '          AND       PRD.CODIGOGTECHPRODUCTO     IN (''10002'', ''19999'')   ' +
    '          GROUP       BY VRA.CODPUNTODEVENTA           ' +
    '         )  VRA                                        ' +
    'ON        (PDV.ID_PUNTODEVENTA =  VRA.CODPUNTODEVENTA) ' +
    '  WHERE     VRA.INGRESOSBRUTOSNANOREDONDEO  <> 0       ' +
    '  ORDER BY PDV.NOMPUNTODEVENTA  ';
    EXECUTE (@v_consulta);



    END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ValidarRecaudoDian', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ValidarRecaudoDian;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ValidarRecaudoDian  (@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                        @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                        @pg_CADENA                NVARCHAR(2000),
                                        @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)
                                        )
    AS
    BEGIN
         DECLARE @vFECHACICLO DATETIME;
         DECLARE @vFIRSTDATE DATETIME;
         DECLARE @vLASTDATE  DATETIME;
         DECLARE @v_FECHA_I_C VARCHAR(30);
         DECLARE @v_FECHA_F_C VARCHAR(30);
         DECLARE @v_consulta NVARCHAR(MAX);
     
    SET NOCOUNT ON;


    IF @p_CODCICLOFACTURACIONPDV = -1   BEGIN
                  SELECT @vLASTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(7), GETDATE(),120) + '-01')-1 ;
                  SELECT @vFIRSTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(7), @vLASTDATE,120) + '-01') ;
    END ELSE BEGIN
         SELECT  @vFECHACICLO = FECHAEJECUCION
         FROM    WSXML_SFG.CICLOFACTURACIONPDV
         WHERE   ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;

         EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @vFECHACICLO, @vFIRSTDATE OUT, @vLASTDATE OUT

    END;
SET @vFIRSTDATE='30/apr/2017';
SET @vLASTDATE='30/apr/2017';

     SET @v_FECHA_I_C = FORMAT( @vFIRSTDATE,'dd/MM/yyyy');
     SET @v_FECHA_F_C = FORMAT( @vLASTDATE,'dd/MM/yyyy');


     SET @v_consulta  = '  SELECT   ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0)                                        AS VENTASTOTALES,     ' +
    '        ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0)                                     AS ANULACIONES,           ' +
    '        ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0)                                         AS VENTASBRUTAS,          ' +
    '        ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                  AS TRANSFERENCIASSALUD,   ' +
    '        ROUND(SUM(PRF.COMISIONNAESTANDAR), 0)                                                 AS DESCUENTOENVENTAS,     ' +
    '        ROUND(SUM(PRF.REVENUENATOTAL - PRF.COMISIONNAESTANDAR - PRF.COSTONAMERCADEOVENTA), 0) AS GASTOSOPERACION,       ' +
    '        ROUND(SUM(PRF.COSTONAMERCADEOVENTA), 0)                                               AS GASTOSMERCADEO,        ' +
    '        ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS                ' +
    '    FROM (SELECT PRF.FECHAARCHIVO                                  AS FECHA,                                            ' +
    '         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0)    AS INGRESOSBRUTNAVENTASNOROUND,                              ' +
    '         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,                           ' +
    '         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0)     AS INGRESOSBRUTOSNANOREDONDEO,                               ' +
    '         SUM(PRF.COMISIONNAESTANDAR)             AS COMISIONNAESTANDAR,                                                 ' +
    '         SUM(PRF.REVENUENATOTAL)                 AS REVENUENATOTAL,                                                     ' +
    '         SUM(PRF.COSTONAMERCADEOVENTA)           AS COSTONAMERCADEOVENTA                                                ' +
    '    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF                                                                                 ' +
    '    INNER JOIN WSXML_SFG.PRODUCTO     PRD ON (PRF.CODPRODUCTO     = PRD.ID_PRODUCTO)                                              ' +
    '    INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)                                          ' +
    '    WHERE PRF.FECHAARCHIVO BETWEEN CONVERT(DATETIME,''' + ISNULL(@v_FECHA_I_C, '')  +''',103) AND  CONVERT(DATETIME,''' + ISNULL(@v_FECHA_F_C, '') + ''',103) ' +
    '    AND TPR.CODLINEADENEGOCIO      = 1                                                                                  ' +
    --'    AND PRD.CODTIPOPRODUCTO        = 1     ' ||
       -- AND PRF.CODPRODUCTO        =155                                                                             ' ||
          -- ' 2012.11.02. Omar Rodriguez. cambio producto ' ||                                                                             ' ||
    '    AND PRD.CODIGOGTECHPRODUCTO      IN (''10002'', ''19999'')                                                                               ' +
    '    GROUP BY PRF.FECHAARCHIVO) PRF ';

      EXECUTE sp_executesql @v_consulta;

    END
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteEcomVentas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteEcomVentas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_ReporteEcomVentas( @P_FECHAINICIO NVARCHAR(2000),
                              @P_FECHAFIN NVARCHAR(2000)
                               )
      AS
      BEGIN
      SET NOCOUNT ON;

       SELECT            CAST( PDV.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0))      AS       CODIGOPUNTOVENTA
                  ,FMAR.CODIGOGTECHFMR              AS       CODIGOFMR
                  ,TPV.CODIGOVENTAS                 AS       CODIGOLINEADENEGOCIOVENTAS
                  ,SUM(RGF.VENTAS)                  AS       VENTAS
                  ,SUM(RGF.TRANSACCIONES)           AS       TRANSACCIONES
          FROM               WSXML_SFG.PUNTODEVENTA PDV
          INNER JOIN         WSXML_SFG.RUTAPDV         RPDV    ON  PDV.CODRUTAPDV = RPDV.ID_RUTAPDV
          INNER JOIN         WSXML_SFG.FMR            FMAR     ON  RPDV.CODFMR = FMAR.ID_FMR
          INNER JOIN
          (
           SELECT      REG.CODPUNTODEVENTA
                ,TP.CODIGOVENTAS
                ,ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN ISNULL(REG.VALORVENTABRUTA,0) ELSE 0 END) -
                 SUM(CASE WHEN REG.CODTIPOREGISTRO = 2 THEN ISNULL(REG.VALORVENTABRUTA,0) ELSE 0 END), 0)  AS VENTAS
                ,ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN ISNULL(REG.NUMTRANSACCIONES,0) ELSE 0 END), 0)  AS TRANSACCIONES
           FROM         WSXML_SFG.REGISTROFACTURACION REG
           INNER JOIN   WSXML_SFG.PRDOCUTOAREAVENTAS  PR    ON    REG.CODPRODUCTO = PR.CODPRODUCTO
           INNER JOIN   WSXML_SFG.TIPOPRODUCTOVENTAS TP     ON    PR.CODTIPOPRODUCTOVENTAS = TP.ID_TIPOPRODUCTOVENTAS
           INNER JOIN   WSXML_SFG.ENTRADAARCHIVOCONTROL E ON E.ID_ENTRADAARCHIVOCONTROL = REG.CODENTRADAARCHIVOCONTROL
           WHERE        PR.CODTIPOPRODUCTOVENTAS IS NOT  NULL
             AND      PR.ACTIVE = 1
           AND          E.FECHAARCHIVO BETWEEN CONVERT(DATETIME, @P_FECHAINICIO) AND CONVERT(DATETIME, @P_FECHAFIN)
           GROUP BY     REG.CODPUNTODEVENTA, TP.CODIGOVENTAS
          )  RGF        ON  RGF.CODPUNTODEVENTA  = PDV.ID_PUNTODEVENTA
          INNER JOIN      WSXML_SFG.TIPOPRODUCTOVENTAS   TPV     ON    RGF.CODIGOVENTAS  = TPV.codigoventas
          WHERE           RGF.VENTAS <>  0
          AND             PDV.CODREDPDV = 82
          GROUP BY         CAST( PDV.CODIGOGTECHPUNTODEVENTA  AS NUMERIC(38,0))
                  , FMAR.CODIGOGTECHFMR
                  , TPV.CODIGOVENTAS
          ORDER BY  CAST(PDV.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0)), FMAR.CODIGOGTECHFMR, TPV.CODIGOVENTAS;

      END
	 
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESESPECIALES_VentasMensualesPorTodosPDV', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_VentasMensualesPorTodosPDV;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_REPORTESESPECIALES_VentasMensualesPorTodosPDV(@p_ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                       @p_FECHA                      DATETIME) AS
 BEGIN
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
  
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @p_FECHA, @sFECHAFRST OUT, @sFECHALAST OUT
  
    
      select servicio.nomservicio as "Tipo Servicio",
             compania.nomcompania as "Compania",
             razonsocial.nomrazonsocial as "Razon Social",
             tipocontratopdv.nomtipocontratopdv as "Tipo de Contrato",
             razonsocial.telefonocontacto as "Telefono",
             razonsocial.direccioncontacto as "Direccion",
             isnull(razonsocial.identificacion, '') + '-' +
             isnull(razonsocial.digitoverificacion, '') as "NIT",
             regimen.nomregimen as "Regimen",
             ciudad.nomciudad as "Ciudad Domicilio Principal",
             ciudad.ciudaddane as "Cod Dane Municipio",
             departamento.departamentodane as "Cod Dane Departamento",
             departamento.nomdepartamento as "Departamento",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        registrofacturacion.valortransaccion
                       else
                        registrofacturacion.valortransaccion * -1
                     end),2),
                 0) as "Ventas",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        impuestos.iva
                       else
                        impuestos.iva * -1
                     end),2),
                 0) as "IVA Producto",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        registrofacturacion.valordescuentos
                       else
                        registrofacturacion.valordescuentos * -1
                     end),2),
                 0) as "Desuentos",    
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        registrofacturacion.valorventabruta
                       else
                        registrofacturacion.valorventabruta * -1
                     end),2),
                 0) as "Ingresos Brutos",
             isnull(ROUND(SUM(CASE
                       WHEN registrofacturacion.CODTIPOREGISTRO IN (1, 3) AND
                            registrofacturacion.COMISIONANTICIPO = 0 THEN
                        registrofacturacion.VALORCOMISION
                       ELSE
                        0
                     END),2),
                 0) - isnull(ROUND(SUM(CASE
                                WHEN registrofacturacion.CODTIPOREGISTRO = 2 AND
                                     registrofacturacion.COMISIONANTICIPO = 0 THEN
                                 registrofacturacion.VALORCOMISION
                                ELSE
                                 0
                              END),2),
                          0) AS "Comision",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        registrofacturacion.ivacomision
                       else
                        registrofacturacion.ivacomision * -1
                     end),2),
                 0) as "IVA Comision",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        registrofacturacion.valorcomisionbruta
                       else
                        registrofacturacion.valorcomisionbruta * -1
                     end),2),
                 0) as "Comision Bruta",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        retenciones.ReteFuente
                       else
                        retenciones.ReteFuente * -1
                     end),2),
                 0) as "ReteFuente",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        retenciones.RETEIVA
                       else
                        retenciones.RETEIVA * -1
                     end),2),
                 0) as "ReteIVA",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        retenciones.RETEICA
                       else
                        retenciones.RETEICA * -1
                     end),2),
                 0) as "ReteICA",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        retuvt.reteuvt
                       else
                        retuvt.reteuvt * -1
                     end),2),
                 0) as "ReteUVT",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        registrofacturacion.Valorcomisionneta
                       else
                        registrofacturacion.Valorcomisionneta * -1
                     end),2),
                 0) as "Comision Neta",
             isnull(ROUND(SUM(CASE
                       WHEN registrofacturacion.CODTIPOREGISTRO IN (1, 3) AND
                            registrofacturacion.COMISIONANTICIPO = 1 THEN
                        registrofacturacion.VALORCOMISION
                       ELSE
                        0
                     END),2),
                 0) - isnull(ROUND(SUM(CASE
                                WHEN registrofacturacion.CODTIPOREGISTRO = 2 AND
                                     registrofacturacion.COMISIONANTICIPO = 1 THEN
                                 registrofacturacion.VALORCOMISION
                                ELSE
                                 0
                              END),2),
                          0) AS "Anticipo",
             isnull(ROUND(sum(case
                       when registrofacturacion.codtiporegistro in (1, 3) then
                        retenciones.RETECREE
                       else
                        retenciones.RETECREE * -1
                     end),2),
                 0) as "ReteCREE"
        from WSXML_SFG.registrofacturacion
       inner join WSXML_SFG.entradaarchivocontrol
          on registrofacturacion.codentradaarchivocontrol =
             entradaarchivocontrol.id_entradaarchivocontrol
       inner join WSXML_SFG.servicio
          on entradaarchivocontrol.tipoarchivo = servicio.id_servicio
       inner join WSXML_SFG.compania
          on servicio.codcompania = compania.id_compania
       inner join WSXML_SFG.razonsocial
          on registrofacturacion.codrazonsocial =
             razonsocial.id_razonsocial
       inner join WSXML_SFG.tipocontratopdv
          on registrofacturacion.codtipocontratopdv =
             tipocontratopdv.id_tipocontratopdv
       inner join WSXML_SFG.regimen
          on razonsocial.codregimen = regimen.id_regimen
       inner join ciudad
          on razonsocial.codciudad = ciudad.id_ciudad
       inner join WSXML_SFG.departamento
          on ciudad.coddepartamento = departamento.id_departamento
        left outer join (select codregistrofacturacion,
                                sum(case
                                      when impuestoregfacturacion.codimpuesto = 1 then
                                       impuestoregfacturacion.valorimpuesto
                                      else
                                       0
                                    end) as IVA
                           from WSXML_SFG.impuestoregfacturacion
                          group by codregistrofacturacion) impuestos
          on impuestos.codregistrofacturacion =
             registrofacturacion.id_registrofacturacion
        left outer join (select codregistrofacturacion,
                                sum(case
                                      when retencionregfacturacion.codretenciontributaria = 1 then
                                       retencionregfacturacion.valorretencion
                                      else
                                       0
                                    end) as ReteFuente,
                                sum(case
                                      when retencionregfacturacion.codretenciontributaria = 2 then
                                       retencionregfacturacion.valorretencion
                                      else
                                       0
                                    end) as ReteICA,
                                sum(case
                                      when retencionregfacturacion.codretenciontributaria = 3 then
                                       retencionregfacturacion.valorretencion
                                      else
                                       0
                                    end) as ReteIVA,
                                sum(case
                                      when retencionregfacturacion.codretenciontributaria = 4 then
                                       retencionregfacturacion.valorretencion
                                      else
                                       0
                                    end) as ReteCREE
                           from retencionregfacturacion
                          group by codregistrofacturacion) retenciones
          on retenciones.codregistrofacturacion =
             registrofacturacion.id_registrofacturacion
        left outer join (select codregistrofacturacion,
                                sum(retuvtregfacturacion.valorretencion) as ReteUVT
                           from retuvtregfacturacion
                          group by codregistrofacturacion) retuvt
          on retuvt.codregistrofacturacion =
             registrofacturacion.id_registrofacturacion
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @sFECHAFRST AND
             @sFECHALAST
         and registrofacturacion.codtiporegistro in (1, 2, 3)
       GROUP BY servicio.nomservicio,
                compania.nomcompania,
                razonsocial.nomrazonsocial,
                tipocontratopdv.nomtipocontratopdv,
                razonsocial.telefonocontacto,
                razonsocial.direccioncontacto,
                isnull(razonsocial.identificacion, '') + '-' +
                isnull(razonsocial.digitoverificacion, ''),
                regimen.nomregimen,
                ciudad.nomciudad,
                ciudad.ciudaddane,
                departamento.departamentodane,
                departamento.nomdepartamento;
  
  END;
GO