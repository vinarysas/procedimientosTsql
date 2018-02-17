USE SFGPRODU;
--  DDL for Package Body SFGINF_FACTURACIONCADENAS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_FACTURACIONCADENAS */ 
IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetSaldosCadena', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetSaldosCadena;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetSaldosCadena(@N_CodigoAgrupacionPDV NUMERIC(22,0), @N_CicloDeFacturacion NUMERIC(22,0)) AS
 BEGIN
   DECLARE @CicloDeFacturacionAux NUMERIC(22,0);
   DECLARE @CodigoMaxLineaNegocioAux NUMERIC(22,0);
    
   SET NOCOUNT ON;
    IF @N_CicloDeFacturacion = -1 BEGIN

       SELECT @CicloDeFacturacionAux = ID_CICLOFACTURACIONPDV from WSXML_SFG.CICLOFACTURACIONPDV
                                ORDER BY ID_CICLOFACTURACIONPDV DESC;
      END
      ELSE BEGIN
        
      SET @CicloDeFacturacionAux = @N_CicloDeFacturacion;
      END  
      
      Select @CodigoMaxLineaNegocioAux = MAX(ID_LINEADENEGOCIO)+1  FROM WSXML_SFG.LINEADENEGOCIO;

      SELECT * FROM(
                        SELECT 
     MFC.CODCICLOFACTURACIONPDV            AS CODCICLOFACTURACIONPDV,
     MFC.CODAGRUPACIONPUNTODEVENTA         AS CODAGRUPACIONPUNTODEVENTA,
     MFP.CODLINEADENEGOCIO                 AS CODLINEADENEGOCIO,
     LDN.NOMCORTOLINEADENEGOCIO                 AS NOMLINEADENEGOCIO,
     MIN(MFC.CODPUNTODEVENTA)              AS CODPUNTODEVENTACABEZA,
     MIN(MFC.CODTIPOPUNTODEVENTA)          AS CODTIPOPUNTODEVENTA,
     ROUND(SUM(ISNULL(MFP.SALDOANTERIORENCONTRAGTECH - MFP.SALDOANTERIORAFAVORGTECH, 0)), 0)     AS SALDOANTERIORGTECH,
     ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 5 THEN (ISNULL(DFP.TOTALFACTURACIONGTECH, 0) - ISNULL(RET_PRD.VALORRETENCION_PRDx1, 0) - ISNULL(RET_PRD.VALORRETENCION_PRDx2, 0) - ISNULL(RET_PRD.VALORRETENCION_PRDx3, 0)) ELSE (ISNULL(DFP.TOTALFACTURACIONGTECH, 0)) END), 0)     AS FACTURACIONGTECH,
     ROUND(SUM(CASE WHEN MFP.CODLINEADENEGOCIO = 5 THEN (ISNULL((ISNULL(MFP.NUEVOSALDOENCONTRAGTECH,0)   - ISNULL(RET_PRD.VALORRETENCION_PRDx1, 0) - ISNULL(RET_PRD.VALORRETENCION_PRDx2, 0) - ISNULL(RET_PRD.VALORRETENCION_PRDx3,0) ) - MFP.NUEVOSALDOAFAVORGTECH, 0)) ELSE (ISNULL(MFP.NUEVOSALDOENCONTRAGTECH - MFP.NUEVOSALDOAFAVORGTECH, 0)) END), 0) AS NUEVOSALDOGTECH
     FROM WSXML_SFG.MAESTROFACTURACIONPDV MFP
     INNER JOIN MAESTROFACTURACIONCOMPCONSIG MFC ON (MFC.ID_MAESTROFACTCOMPCONSIG = MFP.CODMAESTROFACTURACIONCOMPCONSI)
     LEFT OUTER JOIN (SELECT /*+ index(DETALLEFACTURACIONPDV XMLGENERACION_DFP_IX) */
                                         DFP.CODMAESTROFACTURACIONPDV,
                                         SUM(DFP.CANTIDADVENTA)           AS CANTIDADVENTA,
                                         SUM(DFP.VALORVENTA)              AS VALORVENTA,
                                         SUM(DFP.CANTIDADANULACION)       AS CANTIDADANULACION,
                                         SUM(DFP.VALORANULACION)          AS VALORANULACION,
                                         SUM(DFP.CANTIDADGRATUITO)        AS CANTIDADGRATUITO,
                                         SUM(DFP.VALORGRATUITO)           AS VALORGRATUITO,
                                         SUM(DFP.CANTIDADPREMIOPAGO)      AS CANTIDADPREMIOPAGO,
                                         SUM(DFP.VALORPREMIOPAGO)         AS VALORPREMIOPAGO,
                                         SUM(DFP.RETENCIONPREMIOSPAGADOS) AS RETENCIONPREMIOSPAGADOS,
                                         SUM(DFP.VALORVENTABRUTA)         AS VALORVENTABRUTA,
                                         SUM(DFP.VALORCOMISION)           AS VALORCOMISION,
                                         SUM(DFP.VALORCOMISIONBRUTA)      AS VALORCOMISIONBRUTA,
                                         SUM(DFP.VALORCOMISIONNETA)       AS VALORCOMISIONNETA,
                                         SUM(DFP.IVACOMISION)             AS IVACOMISION,
                                         SUM(DFP.NUEVOSALDOENCONTRAGTECH - DFP.NUEVOSALDOAFAVORGTECH)     AS TOTALFACTURACIONGTECH,
                                         SUM(DFP.NUEVOSALDOENCONTRAFIDUCIA - DFP.NUEVOSALDOAFAVORFIDUCIA) AS TOTALFACTURACIONFIDUCIA
                                  FROM WSXML_SFG.DETALLEFACTURACIONPDV DFP
                                  GROUP BY DFP.CODMAESTROFACTURACIONPDV) DFP ON (DFP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
     LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV,
                        SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx1,
                        SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 2 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx2,
                        SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 3 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx3
                 FROM WSXML_SFG.DETALLEFACTURACIONRETDIFE
                GROUP BY CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV) RET_PRD ON (RET_PRD.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
     INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (MFP.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
     WHERE MFC.CODAGRUPACIONPUNTODEVENTA    = @N_CodigoAgrupacionPDV
     AND      MFC.CODCICLOFACTURACIONPDV =  @CicloDeFacturacionAux
     GROUP BY MFC.CODCICLOFACTURACIONPDV, MFC.CODAGRUPACIONPUNTODEVENTA, MFP.CODLINEADENEGOCIO, LDN.NOMCORTOLINEADENEGOCIO
     UNION ALL 
          SELECT 
     MFC.CODCICLOFACTURACIONPDV            AS CODCICLOFACTURACIONPDV,
     MFC.CODAGRUPACIONPUNTODEVENTA         AS CODAGRUPACIONPUNTODEVENTA,
     @CodigoMaxLineaNegocioAux                 AS CODLINEADENEGOCIO,
     'FIDUCIA'                 AS NOMLINEADENEGOCIO,
     MIN(MFC.CODPUNTODEVENTA)              AS CODPUNTODEVENTACABEZA,
     MIN(MFC.CODTIPOPUNTODEVENTA)          AS CODTIPOPUNTODEVENTA,
     ROUND(SUM(ISNULL(MFP.SALDOANTERIORENCONTRAFIDUCIA - MFP.SALDOANTERIORAFAVORFIDUCIA, 0)), 0) AS SALDOANTERIORFIDUCIA,
     ROUND(SUM(ISNULL(DFP.TOTALFACTURACIONFIDUCIA, 0)), 0)   AS FACTURACIONFIDUCIA,
     ROUND(SUM(ISNULL(MFP.NUEVOSALDOENCONTRAFIDUCIA - MFP.NUEVOSALDOAFAVORFIDUCIA, 0)), 0) AS NUEVOSALDOFIDUCIA
     FROM WSXML_SFG.MAESTROFACTURACIONPDV MFP
     INNER JOIN MAESTROFACTURACIONCOMPCONSIG MFC ON (MFC.ID_MAESTROFACTCOMPCONSIG = MFP.CODMAESTROFACTURACIONCOMPCONSI)
     LEFT OUTER JOIN (SELECT /*+ index(DETALLEFACTURACIONPDV XMLGENERACION_DFP_IX) */
                                         DFP.CODMAESTROFACTURACIONPDV,
                                         SUM(DFP.CANTIDADVENTA)           AS CANTIDADVENTA,
                                         SUM(DFP.VALORVENTA)              AS VALORVENTA,
                                         SUM(DFP.CANTIDADANULACION)       AS CANTIDADANULACION,
                                         SUM(DFP.VALORANULACION)          AS VALORANULACION,
                                         SUM(DFP.CANTIDADGRATUITO)        AS CANTIDADGRATUITO,
                                         SUM(DFP.VALORGRATUITO)           AS VALORGRATUITO,
                                         SUM(DFP.CANTIDADPREMIOPAGO)      AS CANTIDADPREMIOPAGO,
                                         SUM(DFP.VALORPREMIOPAGO)         AS VALORPREMIOPAGO,
                                         SUM(DFP.RETENCIONPREMIOSPAGADOS) AS RETENCIONPREMIOSPAGADOS,
                                         SUM(DFP.VALORVENTABRUTA)         AS VALORVENTABRUTA,
                                         SUM(DFP.VALORCOMISION)           AS VALORCOMISION,
                                         SUM(DFP.VALORCOMISIONBRUTA)      AS VALORCOMISIONBRUTA,
                                         SUM(DFP.VALORCOMISIONNETA)       AS VALORCOMISIONNETA,
                                         SUM(DFP.IVACOMISION)             AS IVACOMISION,
                                         SUM(DFP.NUEVOSALDOENCONTRAGTECH - DFP.NUEVOSALDOAFAVORGTECH)     AS TOTALFACTURACIONGTECH,
                                         SUM(DFP.NUEVOSALDOENCONTRAFIDUCIA - DFP.NUEVOSALDOAFAVORFIDUCIA) AS TOTALFACTURACIONFIDUCIA
                                  FROM WSXML_SFG.DETALLEFACTURACIONPDV DFP
                                  GROUP BY DFP.CODMAESTROFACTURACIONPDV) DFP ON (DFP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
     LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV,
                        SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx1,
                        SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 2 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx2,
                        SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 3 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx3
                 FROM WSXML_SFG.DETALLEFACTURACIONRETDIFE
                GROUP BY CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV) RET_PRD ON (RET_PRD.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
     INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN ON (MFP.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
     WHERE MFC.CODAGRUPACIONPUNTODEVENTA    = @N_CodigoAgrupacionPDV
     AND      MFC.CODCICLOFACTURACIONPDV =  @CicloDeFacturacionAux      
     AND MFP.CODLINEADENEGOCIO = 1
     GROUP BY MFC.CODCICLOFACTURACIONPDV, MFC.CODAGRUPACIONPUNTODEVENTA, MFP.CODLINEADENEGOCIO, LDN.NOMCORTOLINEADENEGOCIO
     ) T ORDER BY CODLINEADENEGOCIO;
   END;
  GO



 IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetBalance', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetBalance;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetBalance(@N_CodigoAgrupacionPDV NUMERIC(22,0),  
                                   @N_CicloDeFacturacion NUMERIC(22,0))  AS
 BEGIN
 SET NOCOUNT ON;
   SELECT MFC.CODCICLOFACTURACIONPDV    AS CODCICLOFACTURACIONPDV,
       MFC.CODAGRUPACIONPUNTODEVENTA AS CODAGRUPACIONPUNTODEVENTA,
       SRV.ID_SERVICIO               AS ID_SERVICIO,
       TPR.ID_TIPOPRODUCTO           AS ID_TIPOPRODUCTO,
       SRV.NOMSERVICIO               AS NOMSERVICIO,
       TPR.NOMTIPOPRODUCTO           AS NOMTIPOPRODUCTO,
       LDN.NOMCORTOLINEADENEGOCIO         AS NOMLINEADENEGOCIO,
       /* Valores */
       ROUND(SUM(DFP.CANTIDADVENTA), 0)            AS QUANTITY,
       ROUND(SUM(DFP.VALORVENTA), 0)               AS AMOUNT,
       ROUND(SUM(DFP.CANTIDADANULACION), 0)        AS ANNULLEDQUANTITY,
       ROUND(SUM(DFP.VALORANULACION), 0)           AS ANNULLEDAMOUNT,
       ROUND(SUM(ISNULL(IMP.VALORIMPUESTOx1, 0)), 0)  AS TAXIVA,
       ROUND(SUM(DFP.VALORVENTABRUTA), 0)          AS GROSSSALES,
       ROUND(SUM(DFP.CANTIDADPREMIOPAGO), 0)       AS AWARDPAIDQUANTITY,
       ROUND(SUM(DFP.VALORPREMIOPAGO), 0)          AS AWARDPAIDAMOUNT,
       ROUND(SUM(DFP.RETENCIONPREMIOSPAGADOS), 0)  AS AWARDPAIDTAXDISCOUNTING,
       ROUND(SUM(DFP.VALORCOMISION), 0)            AS COMMISSION,
       ROUND(SUM(DFP.VALORCOMISIONBRUTA -
                 DFP.VALORCOMISION), 0)            AS VATCMS,
       ROUND(SUM(ISNULL(RET.VALORRETENCIONx1, 0) +
                 ISNULL(UVT.VALORRETUVTx1, 0)), 0)    AS RETRNT,
       ROUND(SUM(ISNULL(RET.VALORRETENCIONx2, 0)), 0) AS RETICA,
       ROUND(SUM(ISNULL(RET.VALORRETENCIONx3, 0)), 0) AS RETIVA,
       ROUND(SUM(ISNULL(RET.VALORRETENCIONx4, 0)), 0) AS RETCREE,
       ROUND(SUM(DFP.VALORCOMISIONNETA), 0)        AS FINALCOMMISSION,
       -- Cummulative
       ROUND(SUM(DFP.CANTIDADVENTA -
                 DFP.CANTIDADANULACION -
                 DFP.CANTIDADPREMIOPAGO), 0)       AS FINALQUANTITY,
       ROUND(SUM(DFP.VALORVENTA -
                 DFP.VALORANULACION -
                 DFP.VALORPREMIOPAGO), 0)          AS FINALAMOUNT,
       ROUND(SUM(ISNULL(RET_PRD.VALORRETENCION_PRDx1, 0)), 0) AS RETRNT_PRD,
       ROUND(SUM(ISNULL(RET_PRD.VALORRETENCION_PRDx2, 0)), 0) AS RETICA_PRD,
       ROUND(SUM(ISNULL(RET_PRD.VALORRETENCION_PRDx3, 0)), 0) AS RETIVA_PRD,
       ROUND(SUM(ISNULL(RET_PRD.VALORRETENCION_PRDx4, 0)), 0) AS RETCREE_PRD
                      FROM WSXML_SFG.CICLOFACTURACIONPDV CFP
                      INNER JOIN WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG MFC ON (MFC.CODCICLOFACTURACIONPDV         = CFP.ID_CICLOFACTURACIONPDV)
                      INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV        MFP ON (MFP.CODMAESTROFACTURACIONCOMPCONSI = MFC.ID_MAESTROFACTCOMPCONSIG)
                      INNER JOIN WSXML_SFG.DETALLEFACTURACIONPDV        DFP ON (DFP.CODMAESTROFACTURACIONPDV       = MFP.ID_MAESTROFACTURACIONPDV)
                      INNER JOIN WSXML_SFG.PRODUCTO                     PRD ON (DFP.CODPRODUCTO                    = PRD.ID_PRODUCTO)
                      INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO           AGP ON (PRD.CODAGRUPACIONPRODUCTO          = AGP.ID_AGRUPACIONPRODUCTO)
                      INNER JOIN WSXML_SFG.TIPOPRODUCTO                 TPR ON (AGP.CODTIPOPRODUCTO                = TPR.ID_TIPOPRODUCTO)
                      INNER JOIN WSXML_SFG.LINEADENEGOCIO               LDN ON (TPR.CODLINEADENEGOCIO              = LDN.ID_LINEADENEGOCIO)
                      INNER JOIN WSXML_SFG.SERVICIO                     SRV ON (LDN.CODSERVICIO                    = SRV.ID_SERVICIO)
                      LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV,
                                              SUM(CASE WHEN CODIMPUESTO = 1 THEN VALORIMPUESTO ELSE 0 END) AS VALORIMPUESTOx1
                                       FROM WSXML_SFG.DETALLEFACTURACIONIMPUESTO
                                       GROUP BY CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV) IMP ON (IMP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV
                                                                                                        AND IMP.CODDETALLEFACTURACIONPDV = DFP.ID_DETALLEFACTURACIONPDV)
                      LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCIONx1,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 2 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCIONx2,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 3 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCIONx3,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 4 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCIONx4
                                       FROM WSXML_SFG.DETALLEFACTURACIONRETENCION
                                       GROUP BY CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV) RET ON (RET.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV
                                                                                                        AND RET.CODDETALLEFACTURACIONPDV = DFP.ID_DETALLEFACTURACIONPDV)
                      LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx1,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 2 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx2,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 3 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx3,
                                              SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 4 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_PRDx4
                                       FROM WSXML_SFG.DETALLEFACTURACIONRETDIFE
                                       GROUP BY CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV) RET_PRD ON (RET_PRD.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV
                                                                                                        AND RET_PRD.CODDETALLEFACTURACIONPDV = DFP.ID_DETALLEFACTURACIONPDV)

                      LEFT OUTER JOIN (SELECT CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV,
                                              SUM(CASE WHEN CODRETENCIONUVT = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETUVTx1
                                       FROM WSXML_SFG.DETALLEFACTURACIONRETUVT
                                       GROUP BY CODMAESTROFACTURACIONPDV, CODDETALLEFACTURACIONPDV) UVT ON (UVT.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV
                                       AND UVT.CODDETALLEFACTURACIONPDV = DFP.ID_DETALLEFACTURACIONPDV)

                                       WHERE MFC.CODAGRUPACIONPUNTODEVENTA    = @N_CodigoAgrupacionPDV 
                                        AND      MFC.CODCICLOFACTURACIONPDV =  @N_CicloDeFacturacion
                      GROUP BY MFC.CODCICLOFACTURACIONPDV, MFC.CODAGRUPACIONPUNTODEVENTA,
                               SRV.ID_SERVICIO, TPR.ID_TIPOPRODUCTO,
                               SRV.NOMSERVICIO, TPR.NOMTIPOPRODUCTO,
                               LDN.NOMCORTOLINEADENEGOCIO,
                               SRV.ORDEN
                      ORDER BY MFC.CODAGRUPACIONPUNTODEVENTA,
                               SRV.ORDEN,
                               TPR.ID_TIPOPRODUCTO,
                               LDN.NOMCORTOLINEADENEGOCIO,
                               SUM(DFP.CANTIDADVENTA) DESC;
               END;  
GO
           
 IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetDetalleFacturaCadena', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetDetalleFacturaCadena;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetDetalleFacturaCadena(@N_CodigoAgrupacionPDV NUMERIC(22,0), 
                                  @N_CicloDeFacturacion NUMERIC(22,0)
                                   )  AS
 BEGIN
 SET NOCOUNT ON;
        SELECT TIPOPRODUCTO.NOMTIPOPRODUCTO,
        LINEADENEGOCIO.ID_LINEADENEGOCIO,
        LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO, 
                  CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN 'AJUSTE ' + ISNULL(AGRUPACIONPRODUCTO.NOMAGRUPACIONPRODUCTO, '') ELSE AGRUPACIONPRODUCTO.NOMAGRUPACIONPRODUCTO END AS DESCRIPCION,
               SUM(      CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2      THEN REGISTROFACTURACION.NUMTRANSACCIONES *-1 
                              WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN REGISTROFACTURACION.NUMTRANSACCIONES ELSE 0 END) AS TRX,      
                                              
               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO,0) *-1 
                              WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO,0) ELSE 0 END),0) AS VALORBRUTO,         


               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(IMPUESTOS.IVA,0) *-1 
                              WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(IMPUESTOS.IVA,0) ELSE 0 END),0) AS IVA, 
        -- TODO DESCUENTOS
               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(REGISTROFACTURACION.Valordescuentos,0) *-1 
                              WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(REGISTROFACTURACION.Valordescuentos,0) ELSE 0 END),0) AS DISCOUNTS,         

             
--        0 as DISCOUNTS,     
               
               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(REGISTROFACTURACION.VALORTRANSACCION,0) *-1 
                              WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(REGISTROFACTURACION.VALORTRANSACCION,0) ELSE 0 END),0) AS VALORNETO,
               
               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN ISNULL(REGISTROFACTURACION.VALORTRANSACCION,0) ELSE 0 END ),0) AS PREMIOSPAGADOS,
               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN ISNULL(REGISTROFACTURACION.RETENCIONPREMIO,0) ELSE 0 END ),0) AS RETENCIONPREMIOS,
               ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN ISNULL(REGISTROFACTURACION.NUMTRANSACCIONES,0) ELSE 0 END ),0) AS TRXPREMIOS
               
               
               
                FROM WSXML_SFG.REGISTROFACTURACION 
                     INNER JOIN ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                     INNER JOIN PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO 
                     INNER JOIN TIPOPRODUCTO ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
                     INNER JOIN AGRUPACIONPRODUCTO ON PRODUCTO.CODAGRUPACIONPRODUCTO = AGRUPACIONPRODUCTO.ID_AGRUPACIONPRODUCTO
                     INNER JOIN LINEADENEGOCIO ON TIPOPRODUCTO.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
                      LEFT OUTER JOIN 
                           (
                           SELECT CODREGISTROFACTURACION,SUM(IMPUESTOREGFACTURACION.VALORIMPUESTO) AS IVA
                           FROM  WSXML_SFG.IMPUESTOREGFACTURACION
                           WHERE IMPUESTOREGFACTURACION.CODIMPUESTO = 1 
                           GROUP BY CODREGISTROFACTURACION
                           ) IMPUESTOS ON IMPUESTOS.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
                     WHERE ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV = @N_CicloDeFacturacion /*Ciclo de facturacion*/
                     AND ENTRADAARCHIVOCONTROL.REVERSADO = 0 
                     AND REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA = @N_CodigoAgrupacionPDV /*Codigo de la cadena*/
                     AND NOT(REGISTROFACTURACION.CODTIPOREGISTRO IN (5,6) )
                     GROUP BY LINEADENEGOCIO.ID_LINEADENEGOCIO,
        LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO, CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN 'AJUSTE ' + ISNULL(AGRUPACIONPRODUCTO.NOMAGRUPACIONPRODUCTO, '') ELSE AGRUPACIONPRODUCTO.NOMAGRUPACIONPRODUCTO END, TIPOPRODUCTO.NOMTIPOPRODUCTO
                     HAVING ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO,0) *-1 
                              WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO,0) ELSE 0 END),0) <> 0
                  ORDER BY LINEADENEGOCIO.ID_LINEADENEGOCIO, TIPOPRODUCTO.NOMTIPOPRODUCTO;
 END;
 GO
 
 
 IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoFacturacionCadena', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoFacturacionCadena;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoFacturacionCadena(
  @N_CodigoAgrupacionPDV NUMERIC(22,0),  
  @N_CicloDeFacturacion NUMERIC(22,0)
)  AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @CODIGOAGRUPACIONGTECH NUMERIC
  DECLARE @FECHAEJECUCION DATE
  DECLARE @xREFERENCIA_OUT NVARCHAR(4000)

  SELECT
    @CODIGOAGRUPACIONGTECH = AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,
    @FECHAEJECUCION = CICLOFACTURACIONPDV.Fechaejecucion
  FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
  INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV ON CICLOFACTURACIONPDV.ID_CICLOFACTURACIONPDV = @N_CicloDeFacturacion         
  WHERE AGRUPACIONPUNTODEVENTA.Id_Agrupacionpuntodeventa = @N_CodigoAgrupacionPDV 

  EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GroupedReferenceNumber
    @CODIGOAGRUPACIONGTECH,
    @FECHAEJECUCION,
    @xREFERENCIA_OUT OUT

  SELECT 
      AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,
      ISNULL(COUNTPDV.NUMEROPDVS, 0) AS NUMEROPDV,
      RAZONSOCIAL.NOMRAZONSOCIAL,
      CONVERT(VARCHAR,RAZONSOCIAL.IDENTIFICACION) + '-' +  CONVERT(VARCHAR,RAZONSOCIAL.DIGITOVERIFICACION) AS NIT,
      RAZONSOCIAL.DIRECCIONCONTACTO,
      RAZONSOCIAL.TELEFONOCONTACTO,
      RAZONSOCIALXCONTRATO.TIPOCONTRATO,
      ISNULL(CIUDAD.NOMCIUDAD, '') + ' / ' + ISNULL(DEPARTAMENTO.NOMDEPARTAMENTO, '') AS CIUDAD,
      @xREFERENCIA_OUT AS ReferenciaIGT,
      @xREFERENCIA_OUT AS ReferenciaFiducia,
      PARAMETROS.AccountNumberFiducia,
      PARAMETROS.AccountNumberIGT,
      PARAMETROS.BarcodeFiducia,
      PARAMETROS.BarcodeIGT,
      --04/10/2017 Eduque: Los dos siguientes campos no tienen relevancia, sin embargo si se utilizan en Tirilla PDF para enviar alguna informaci¿n al reporte, por lo tanto se mantienen. 
      PARAMETROS.BarcodeFiducia AS BARCODELEGIBLEFIDUCIA,
      PARAMETROS.BarcodeIGT AS BARCODELEGIBLEIGT,
      (CONVERT(DATETIME,CICLOFACTURACIONPDV.FECHAEJECUCION) -6) AS FECHADESDE,
      CICLOFACTURACIONPDV.FECHAEJECUCION AS FECHAHASTA,
      COMPANIA.NOMCOMPANIA,
      CONVERT(VARCHAR,COMPANIA.IDENTIFICACION) + '-' + CONVERT(VARCHAR,COMPANIA.DIGITOVERIFICACION)  AS NITCOMPANIA
  FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
  INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV ON CICLOFACTURACIONPDV.ID_CICLOFACTURACIONPDV = @N_CicloDeFacturacion
  LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA ON AGRUPACIONPUNTODEVENTA.CODPUNTODEVENTACABEZA = PUNTODEVENTA.ID_PUNTODEVENTA
  LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL ON PUNTODEVENTA.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
  LEFT OUTER JOIN WSXML_SFG.CIUDAD ON RAZONSOCIAL.CODCIUDAD = CIUDAD.ID_CIUDAD
  LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
  LEFT OUTER JOIN 
             (
             SELECT CODRAZONSOCIAL, MAX(TIPOCONTRATOPDV.NOMTIPOCONTRATOPDV) AS TIPOCONTRATO
             FROM WSXML_SFG.RAZONSOCIALCONTRATO 
             INNER JOIN WSXML_SFG.TIPOCONTRATOPDV ON RAZONSOCIALCONTRATO.CODTIPOCONTRATOPDV = TIPOCONTRATOPDV.ID_TIPOCONTRATOPDV
             GROUP BY CODRAZONSOCIAL            
             ) RAZONSOCIALXCONTRATO ON RAZONSOCIALXCONTRATO.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL 
  LEFT OUTER JOIN 
             (
             SELECT CODAGRUPACIONPUNTODEVENTA,COUNT(1) AS NUMEROPDVS
             FROM WSXML_SFG.PUNTODEVENTA
             WHERE ACTIVE = 1
             GROUP BY CODAGRUPACIONPUNTODEVENTA 
             )COUNTPDV ON COUNTPDV.CODAGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
  FULL JOIN 
             (
              SELECT MAX(CASE WHEN NOMPARAMETRO = 'AccountNumberFiducia' THEN CONVERT(VARCHAR, VALOR) ELSE '' END) AS AccountNumberFiducia ,
                     MAX(CASE WHEN NOMPARAMETRO = 'AccountNumberGTECH' THEN CONVERT(VARCHAR, VALOR) ELSE '' END) AS AccountNumberIGT,
                     MAX(CASE WHEN NOMPARAMETRO = 'ShortBarcodeFiducia' THEN CONVERT(VARCHAR, VALOR) ELSE '' END) AS BarcodeFiducia,
                     MAX(CASE WHEN NOMPARAMETRO = 'ShortBarcodeIGT' THEN CONVERT(VARCHAR, VALOR) ELSE '' END) AS BarcodeIGT,     
                     MAX(CASE WHEN NOMPARAMETRO = 'CodigoCompaniaTirilla' THEN CONVERT(VARCHAR, VALOR) ELSE '' END) AS CodigoCompaniaTirilla
              FROM WSXML_SFG.PARAMETRO 
              )PARAMETROS ON 1=1 
  LEFT OUTER JOIN WSXML_SFG.COMPANIA ON PARAMETROS.CodigoCompaniaTirilla = COMPANIA.CODIGO            
  where AGRUPACIONPUNTODEVENTA.Id_Agrupacionpuntodeventa = @N_CodigoAgrupacionPDV 
 
END
GO 

  
IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoUltimosPeriodos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoUltimosPeriodos;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoUltimosPeriodos(@N_CodigoAgrupacionPDV NUMERIC(22,0),  
                                   @N_CicloDeFacturacion NUMERIC(22,0))  AS
 BEGIN
 SET NOCOUNT ON;
         select * from (
			SELECT 
				LINEADENEGOCIO.ID_LINEADENEGOCIO,
						 CICLO.FECHAEJECUCION,
						 (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN REGISTROFACTURACION.Numtransacciones
						 WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2      THEN REGISTROFACTURACION.Numtransacciones*-1 END) AS Transacciones,
						 (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN(1,3)      THEN REGISTROFACTURACION.Valortransaccion
						  WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2      THEN REGISTROFACTURACION.Valortransaccion*-1 END) AS Ventas 
					, ROW_NUMBER() OVER(ORDER BY LINEADENEGOCIO.ID_LINEADENEGOCIO ASC) AS RowNUmber
				  FROM WSXML_SFG.REGISTROFACTURACION 

				  INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO 
				  INNER JOIN WSXML_SFG.TIPOPRODUCTO ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
				  INNER JOIN WSXML_SFG.LINEADENEGOCIO ON TIPOPRODUCTO.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
				  INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
				  INNER JOIN
						(
						SELECT ID_CICLOFACTURACIONPDV,
							   FECHAEJECUCION  
						FROM ( SELECT T.*, ROW_NUMBER() OVER(ORDER BY id_CICLOFACTURACIONPDV DESC) AS RowNumber FROM WSXML_SFG.CICLOFACTURACIONPDV T  ) CICLOFACTURACION
						WHERE ID_CICLOFACTURACIONPDV<= @N_CicloDeFacturacion
						and ACTIVE= 1 
						--AND  
						--ORDER BY 1 DESC 
						)CICLO ON ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV = CICLO.ID_CICLOFACTURACIONPDV 
				  WHERE REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA = @N_CodigoAgrupacionPDV
				  --ORDER BY 1
		)T pivot (
			 sum(Transacciones) FOR ID_LINEADENEGOCIO IN ([1],[2],[3])
			) PIV;
			
 END
 GO

 
 
 IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoPeriodosSeparados', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoPeriodosSeparados;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoPeriodosSeparados(@N_CodigoAgrupacionPDV NUMERIC(22,0),  
                                   @N_CicloDeFacturacion NUMERIC(22,0))  AS
 BEGIN
 SET NOCOUNT ON;
   SELECT LINEADENEGOCIO.NOMLINEADENEGOCIO,
          LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO,
             CICLO.FECHAEJECUCION,
             SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN REGISTROFACTURACION.Numtransacciones 
                      WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2      THEN REGISTROFACTURACION.Numtransacciones*-1 END) AS Transacciones,
             SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN REGISTROFACTURACION.Valortransaccion 
                      WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2      THEN REGISTROFACTURACION.Valortransaccion*-1 END) AS Ventas 
                    
      FROM WSXML_SFG.REGISTROFACTURACION 
      INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO 
      INNER JOIN WSXML_SFG.TIPOPRODUCTO ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
      INNER JOIN WSXML_SFG.LINEADENEGOCIO ON TIPOPRODUCTO.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
      INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
      INNER JOIN
            (
            SELECT ID_CICLOFACTURACIONPDV,
                   FECHAEJECUCION             
            FROM ( SELECT T.*, ROW_NUMBER() OVER(ORDER BY ID_CICLOFACTURACIONPDV DESC) AS RowNumber FROM WSXML_SFG.CICLOFACTURACIONPDV T ) CICLOFACTURACION
            WHERE ID_CICLOFACTURACIONPDV<= @N_CicloDeFacturacion
            and ACTIVE= 1 
            --AND  
            --ORDER BY 1 DESC 
            )CICLO ON ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV = CICLO.ID_CICLOFACTURACIONPDV 
      WHERE REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA = @N_CodigoAgrupacionPDV
      GROUP BY LINEADENEGOCIO.NOMLINEADENEGOCIO,
               LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO,
             CICLO.FECHAEJECUCION
      ORDER BY 3,1;
   END;
   
GO
   
IF OBJECT_ID('WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoCertificaciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoCertificaciones;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_FACTURACIONCADENAS_GetInfoCertificaciones(
  @N_CodigoAgrupacionPDV NUMERIC(22,0),  
  @N_CicloDeFacturacion NUMERIC(22,0)
)  AS
BEGIN
  SET NOCOUNT ON;
  SELECT 
    COMPANIA.NOMCOMPANIA AS COMPANIA,
    CONCAT(COMPANIA.IDENTIFICACION,'-',COMPANIA.DIGITOVERIFICACION) AS NIT,
    TIPOCONTRATOPRODUCTO.NOMTIPOCONTRATOPRODUCTO AS "CONCEPTO",
    ISNULL(DATAREPORTE.INGRESO,0)                   AS "INGRESOPDV",
    ISNULL(DATAREPORTE.IVA,0)                       AS "IVA",
    ISNULL(DATAREPORTE.RETEFUENTE,0)                AS "RETEFUENTE",
    ISNULL(DATAREPORTE.RETEICA,0)                   AS "RETEICA",
    ISNULL(DATAREPORTE.RETEIVA,0)                   AS "RETEIVA",
    ISNULL(DATAREPORTE.RETECREE,0)                  AS "RETECREE"              
  FROM WSXML_SFG.TIPOCONTRATOPRODUCTO
  FULL JOIN WSXML_SFG.COMPANIA ON 1 = 1 
  LEFT OUTER JOIN 
  (
  SELECT REGISTROREVENUE.Codcompania,
         REGISTROREVENUE.Codtipocontratoproducto,
         SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(REGISTROFACTURACION.VALORCOMISION,0) ELSE ISNULL(REGISTROFACTURACION.VALORCOMISION,0) *-1 END)    AS INGRESO,
         SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(REGISTROFACTURACION.IVACOMISION,0)   ELSE ISNULL(REGISTROFACTURACION.IVACOMISION,0) *-1 END )     AS IVA,
         SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(RETENCIONES.RETEFUENTE,0)            ELSE ISNULL(RETENCIONES.RETEFUENTE,0) *-1 END)               AS RETEFUENTE,
         SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(RETENCIONES.RETEICA,0)               ELSE ISNULL(RETENCIONES.RETEICA,0) *-1 END)                  AS RETEICA,       
         SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(RETENCIONES.RETEIVA,0)               ELSE ISNULL(RETENCIONES.RETEIVA,0) *-1 END)                  AS RETEIVA,
         SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN ISNULL(RETENCIONES.RETECREE,0)              ELSE ISNULL(RETENCIONES.RETECREE,0) *-1 END)                 AS RETECREE              
  FROM  WSXML_SFG.REGISTROREVENUE   
  LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION   ON REGISTROREVENUE.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
  LEFT OUTER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
  LEFT OUTER JOIN 
             (
             SELECT CODREGISTROFACTURACION, 
                    SUM(CASE WHEN RETENCIONREGFACTURACION.CODRETENCIONTRIBUTARIA = 1 THEN RETENCIONREGFACTURACION.VALORRETENCION ELSE 0 END) AS RETEFUENTE,
                    SUM(CASE WHEN RETENCIONREGFACTURACION.CODRETENCIONTRIBUTARIA = 2 THEN RETENCIONREGFACTURACION.VALORRETENCION ELSE 0 END) AS RETEICA,
                    SUM(CASE WHEN RETENCIONREGFACTURACION.CODRETENCIONTRIBUTARIA = 3 THEN RETENCIONREGFACTURACION.VALORRETENCION ELSE 0 END) AS RETEIVA,
                    SUM(CASE WHEN RETENCIONREGFACTURACION.CODRETENCIONTRIBUTARIA = 4 THEN RETENCIONREGFACTURACION.VALORRETENCION ELSE 0 END) AS RETECREE
             FROM WSXML_SFG.RETENCIONREGFACTURACION
             GROUP BY CODREGISTROFACTURACION 
             ) RETENCIONES ON RETENCIONES.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
  WHERE REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3,2)
  AND ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV = @N_CicloDeFacturacion/*cod ciclo facturacion*/
  AND REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA= @N_CodigoAgrupacionPDV /*cod cadena*/
  GROUP BY REGISTROREVENUE.Codcompania,
         REGISTROREVENUE.Codtipocontratoproducto
  )DATAREPORTE ON DATAREPORTE.CODTIPOCONTRATOPRODUCTO = TIPOCONTRATOPRODUCTO.ID_TIPOCONTRATOPRODUCTO
  AND DATAREPORTE.CODCOMPANIA = COMPANIA.ID_COMPANIA 
  WHERE COMPANIA.ID_COMPANIA IN (SELECT CODCOMPANIA FROM WSXML_SFG.SERVICIO)
  ORDER BY 1,2;
END
GO


