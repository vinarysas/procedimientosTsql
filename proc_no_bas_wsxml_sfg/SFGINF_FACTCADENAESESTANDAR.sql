USE SFGPRODU;
--  DDL for Package Body SFGINF_FACTCADENAESESTANDAR
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_FACTCADENAESESTANDAR */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEAGRUPADOLINEANEGOCIO', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEAGRUPADOLINEANEGOCIO;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEAGRUPADOLINEANEGOCIO(@P_CADENA                 NUMERIC(22,0),
                                        @P_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @P_NIT                    NVARCHAR(2000)) AS
 BEGIN
    DECLARE @V_CODCICLOFACTURACIONPDV NUMERIC(22,0);
  
   
  SET NOCOUNT ON;
  
    IF @P_CODCICLOFACTURACIONPDV = -1
        SET @V_CODCICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
      ELSE
        SET @V_CODCICLOFACTURACIONPDV = @P_CODCICLOFACTURACIONPDV;
    
  
    
      SELECT LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO AS "Linea de Negocio",
             ISNULL(VENTAS, 0) AS Ventas,
             ISNULL(ANULACIONES, 0) AS Anulaciones,
             ISNULL(IVA, 0) AS Iva,
             ISNULL(DESCUENTOS, 0) AS Descuentos,
             ISNULL("VENTAS BRUTAS", 0) AS "Ventas Brutas",
             ISNULL("PAGO PREMIOS", 0) AS "Pagos Premios",
             ISNULL("INGRESO BRUTO", 0) AS "Ingreso bruto",
             ISNULL("IVA INGRESO", 0) AS "Iva ingreso",
             ISNULL(RETEFUENTE, 0) AS Retefuente,
             ISNULL(RETEICA, 0) AS ReteICA,
             ISNULL(RETEIVA, 0) AS ReteIVA,
             ISNULL(RETECREE, 0) AS ReteCREE,
             ISNULL(INGRESONETO, 0) AS "Ingreso Neto",
             ISNULL("TOTAL A GTECH", 0) AS "Total Gtech",
             ISNULL("TOTAL A ETESA", 0) AS "Total Fiducia"
        FROM WSXML_SFG.LINEADENEGOCIO
        LEFT OUTER JOIN (SELECT LN.ID_LINEADENEGOCIO AS CODLINEADENEGOCIO,
                                SUM(ISNULL(VPD.VALORVENTA, 0)) AS VENTAS,
                                SUM(ISNULL(VPD.VALORANULACION, 0)) AS ANULACIONES,
                                SUM(ISNULL(VPD.IMPUESTO_IVA, 0)) AS IVA,
                                SUM(ISNULL(VPD.DESCUENTOS, 0)) AS DESCUENTOS,
                                SUM(ISNULL(VPD.VALORVENTABRUTA, 0)) AS "VENTAS BRUTAS",
                                SUM(ISNULL(VPD.VALORPREMIOPAGO, 0)) AS "PAGO PREMIOS",
                                SUM(ISNULL(VPD.VALORCOMISION, 0)) AS "INGRESO BRUTO",
                                SUM(ISNULL(VPD.VATCOMISION, 0)) AS "IVA INGRESO",
                                SUM(ISNULL(VPD.RETENCION_RENTA, 0)) AS RETEFUENTE,
                                SUM(ISNULL(VPD.RETENCION_RETEICA, 0)) AS RETEICA,
                                SUM(ISNULL(VPD.RETENCION_RETEIVA, 0)) AS RETEIVA,
                                SUM(ISNULL(VPD.RETENCION_RETECREE, 0)) AS RETECREE,
                                SUM(ISNULL(VPD.VALORCOMISIONNETA, 0)) AS INGRESONETO,
                                CASE
                                  WHEN LN.ID_LINEADENEGOCIO = 4 /*Retiros*/
                                   THEN
                                   SUM(ISNULL(VPD.FACTURADOENCONTRAGTECH +
                                           (VPD.FACTURADOAFAVORGTECH * -1),
                                           0)) - SUM(ISNULL(VPD.VALORVENTA, 0))
                                  ELSE
                                   SUM(ISNULL(VPD.FACTURADOENCONTRAGTECH +
                                           (VPD.FACTURADOAFAVORGTECH * -1),
                                           0))
                                END AS "TOTAL A GTECH",
                                SUM(ISNULL(VPD.FACTURADOENCONTRAFIDUCIA +
                                        (FACTURADOAFAVORFIDUCIA * -1),
                                        0)) AS "TOTAL A ETESA"
                         
                           FROM WSXML_SFG.VW_SHOW_PDVFACTURACION VPD
                          INNER JOIN WSXML_SFG.LINEADENEGOCIO LN
                             ON LN.ID_LINEADENEGOCIO = VPD.CODLINEADENEGOCIO
                          INNER JOIN WSXML_SFG.RAZONSOCIAL RZS
                             ON VPD.CODRAZONSOCIAL = RZS.ID_RAZONSOCIAL
                          WHERE VPD.CODAGRUPACIONPUNTODEVENTA = @P_CADENA
                            AND VPD.ID_CICLOFACTURACIONPDV =
                                @V_CODCICLOFACTURACIONPDV
                            AND ISNULL(RZS.IDENTIFICACION, '') + '-' +
                                ISNULL(RZS.DIGITOVERIFICACION, '') = @P_NIT
                            AND NOT (VPD.CODRANGOCOMISION IN
                                 (SELECT RANGOCOMISION.ID_RANGOCOMISION
                                        FROM WSXML_SFG.RANGOCOMISIONDETALLE
                                       INNER JOIN RANGOCOMISION
                                          ON RANGOCOMISIONDETALLE.CODRANGOCOMISION =
                                             RANGOCOMISION.ID_RANGOCOMISION
                                       WHERE VALORTRANSACCIONAL = CASE
                                               WHEN CODTIPOCOMISION IN (2) THEN
                                                0
                                               ELSE
                                                VALORTRANSACCIONAL
                                             END
                                         AND VALORPORCENTUAL = CASE
                                               WHEN CODTIPOCOMISION IN (1) THEN
                                                0
                                               ELSE
                                                VALORPORCENTUAL
                                             END
                                         AND RANGOCOMISION.CODTIPOCOMISION IN
                                             (1, 2)
                                       GROUP BY RANGOCOMISION.ID_RANGOCOMISION) AND
                                 VPD.VALORVENTABRUTA = 0)
                          GROUP BY LN.ID_LINEADENEGOCIO) DET
          ON DET.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
       ORDER BY LINEADENEGOCIO.ID_LINEADENEGOCIO;
  
  END; 
  GO


    IF OBJECT_ID('WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONCADENA', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONCADENA;
GO


  CREATE PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONCADENA(@P_NIT                    NVARCHAR(2000),
                                    @P_CODCICLOFACTURACIONPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @V_LINEASNEGOCIO          WSXML_SFG.IDSTRINGVALUE;
    DECLARE @V_LSTRAZONSOCIAL         WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @V_CONSULTA               VARCHAR(MAX);
    DECLARE @V_RAZONESSOCIALES        VARCHAR(1000);
    DECLARE @V_CODCICLOFACTURACIONPDV NUMERIC(22,0);
    DECLARE @V_REGISTROS              NUMERIC(22,0);
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
  
    IF @P_CODCICLOFACTURACIONPDV = -1 
        SET @V_CODCICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
      ELSE
        SET @V_CODCICLOFACTURACIONPDV = @P_CODCICLOFACTURACIONPDV;
    
  
    SELECT @V_REGISTROS = COUNT(*)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' +
           ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT;
  
    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Raz�n Social', 16, 1);
    END
    ELSE BEGIN
    
      ---- Razones sociales para este nit
     INSERT INTO @V_LSTRAZONSOCIAL
	  SELECT ID_RAZONSOCIAL
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' +
             ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT;
    
      DECLARE ix CURSOR FOR SELECT IDVALUE FROM @V_LSTRAZONSOCIAL
	  
	  OPEN ix;

	  DECLARE @ix__IDVALUE NUMERIC(38,0)
		FETCH ix INTO @ix__IDVALUE;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
        IF @V_REGISTROS = 1 BEGIN
          SET @V_RAZONESSOCIALES = ISNULL(@V_RAZONESSOCIALES, '') + ISNULL(@ix__IDVALUE, '');
        END
        ELSE BEGIN
          SET @V_RAZONESSOCIALES = ISNULL(@V_RAZONESSOCIALES, '') + ISNULL(@ix__IDVALUE, '') + ', ';
        END 
        SET @V_REGISTROS = @V_REGISTROS - 1;
      FETCH ix INTO @ix__IDVALUE;
      END;
      CLOSE ix;
      DEALLOCATE ix;
    
      ---- Selecciona cada linea de negocio en un arreglo
      INSERT INTO @V_LINEASNEGOCIO
	  SELECT ID_LINEADENEGOCIO,NOMCORTOLINEADENEGOCIO
        FROM WSXML_SFG.LINEADENEGOCIO
       ORDER BY ID_LINEADENEGOCIO;
    
      ---- Recorre el arreblo para realizar la consulta din�micamente
      IF @@ROWCOUNT > 0 BEGIN
        DECLARE iax CURSOR FOR SELECT ID, VALUE FROM @V_LINEASNEGOCIO
		OPEN iax;

		DECLARE @iax__ID NUMERIC(38,0), @iax__VALUE VARCHAR(2000)
		FETCH iax INTO @iax__ID, @iax__VALUE
 WHILE @@FETCH_STATUS=0
 BEGIN
          SET @V_CONSULTA = ISNULL(@V_CONSULTA, '') +
                        ', CAST(SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.NUMINGRESOS,0) ELSE 0 END) AS NUMERIC(38,0)) AS Tx_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.INGRESOS,0) ELSE 0 END),2) AS Valor_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.DESCUENTOS,0) ELSE 0 END),2) AS Descuentos_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.INGRESOSBRUTOS,0) ELSE 0 END),2) AS "Valor Sin IVA_' + ISNULL(@iax__ID, '') + '"' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.COMISION,0) ELSE 0 END),2) AS Ingresos PDV_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.IVAPRODUCTO,0) ELSE 0 END),2) AS "IVA Ingreso_' + ISNULL(@iax__ID, '') + '"' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.RETEFUENTE,0) ELSE 0 END),2) AS ReteFuente_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.RETEICA,0) ELSE 0 END),2) AS ReteICA_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.RETEIVA,0) ELSE 0 END),2) AS ReteIVA_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.RETECREE,0) ELSE 0 END),2) AS ReteCREE_' + ISNULL(@iax__ID, '') + '' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.COMISIONNETA,0) ELSE 0 END),2) AS "Ingresos Netos_' + ISNULL(@iax__ID, '') + '"' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        '  THEN ISNULL(VPD.PREMIOSPAGADOS,0) ELSE 0 END),2) AS "Premios Pagos_' + ISNULL(@iax__ID, '') + '"' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.VALORAPAGARGTECH,0) ELSE 0 END),0) AS "Total Pagar Gtech_' + ISNULL(@iax__ID, '') + '"' +
                        ', (SUM(CASE WHEN VPD.CODLINEADENEGOCIO= ' + ISNULL(@iax__ID, '') +
                        ' THEN ISNULL(VPD.VALORAPAGARFIDUCIA,0) ELSE 0 END),0) AS "Total Pagar Fiducia_' + ISNULL(@iax__ID, '') + '"';
        FETCH iax INTO @iax__ID, @iax__VALUE
        END;
        CLOSE iax;
        DEALLOCATE iax;
      END 
      --- Consulta
      SET @sql =  '   SELECT   CAST(AG.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0)) AS Cadena ' + 
                     '  ,AG.NOMAGRUPACIONPUNTODEVENTA  AS Nombre Cadena ' + 
                     '  ,PV.CODIGOGTECHPUNTODEVENTA  AS PDV ' + 
                     '  ,PV.NOMPUNTODEVENTA  AS Nombre PDV ' + 
                     '  ,ENT.FECHAARCHIVO AS Fecha ' + 
                     '  ' + ISNULL(@V_CONSULTA, '') + 
                     '  FROM         WSXML_SFG.AGRUPACIONPUNTODEVENTA     AG ' + 
                     '  INNER JOIN  WSXML_SFG.PUNTODEVENTA         PV     ON    PV.CODAGRUPACIONPUNTODEVENTA = AG.ID_AGRUPACIONPUNTODEVENTA ' + 
                     '  INNER JOIN  WSXML_SFG.VW_PREFACTURACION_DIARIA    VPD   ON    VPD.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA ' + 
                     '  INNER JOIN  ENTRADAARCHIVOCONTROL     ENT    ON    VPD.ID_ENTRADAARCHIVOCONTROL = ENT.ID_ENTRADAARCHIVOCONTROL ' 
                     + '  WHERE       VPD.CODRAZONSOCIAL   IN (   ' 
                     + ISNULL(@V_RAZONESSOCIALES, '') + 
                     ') ' + 
                     '  AND         VPD.CODCICLOFACTURACIONPDV = ' + ISNULL(@V_CODCICLOFACTURACIONPDV, '') + 
                     '  AND NOT(    ' + 
                     '                 VPD.CODRANGOCOMISION IN ( ' + 
                     '                                     SELECT RANGOCOMISION.ID_RANGOCOMISION ' + 
                     '                                    FROM WSXML_SFG.RANGOCOMISIONDETALLE  ' + 
                     '                                    INNER JOIN WSXML_SFG.RANGOCOMISION ON RANGOCOMISIONDETALLE.CODRANGOCOMISION= RANGOCOMISION.ID_RANGOCOMISION ' + 
                     '                                    WHERE VALORTRANSACCIONAL = CASE WHEN CODTIPOCOMISION IN(2) THEN 0 ELSE VALORTRANSACCIONAL END AND ' + 
                     '                                    VALORPORCENTUAL = CASE WHEN CODTIPOCOMISION IN (1) THEN 0 ELSE VALORPORCENTUAL END   ' + 
                     '                                    AND RANGOCOMISION.CODTIPOCOMISION IN (1,2) ' + 
                     '                                    GROUP BY RANGOCOMISION.ID_RANGOCOMISION  ' + 
                     '                                    ) AND   ' + 
                     '                                    VPD.INGRESOSBRUTOSVENTAS =0  ' + 
                     '             ) ' + 
                     '  GROUP BY      CAST(AG.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0)) ' + 
                     '  ,PV.CODIGOGTECHPUNTODEVENTA ' + 
                     '  ,ENT.FECHAARCHIVO ' + '  ,AG.NOMAGRUPACIONPUNTODEVENTA  ' + 
                     '  ,PV.NOMPUNTODEVENTA  ' + 
                     '   ORDER BY     CAST(AG.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0)),  PV.CODIGOGTECHPUNTODEVENTA, ENT.FECHAARCHIVO';
      EXECUTE sp_executesql @sql;
    
    END 
  
  END; 
GO



    IF OBJECT_ID('WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODUCTO', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODUCTO;
GO


  CREATE PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODUCTO(@P_NIT                    NVARCHAR(2000),
                                      @P_CODCICLOFACTURACIONPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @V_CODCICLOFACTURACIONPDV NUMERIC(22,0);
    DECLARE @V_REGISTROS              NUMERIC(22,0);
   
  SET NOCOUNT ON;
  
    IF  @P_CODCICLOFACTURACIONPDV = -1 
        SET @V_CODCICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
      ELSE
        SET @V_CODCICLOFACTURACIONPDV = @P_CODCICLOFACTURACIONPDV;
    
  
    SELECT @V_REGISTROS = COUNT(*)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE /*RAZONSOCIAL.IDENTIFICACION || '-' ||*/
           ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' + ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '')= @P_NIT;
         --RAZONSOCIAL.IDENTIFICACION = P_NIT;
  
    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Razon Social', 16, 1);
    END
    ELSE BEGIN
        SELECT AG.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AG.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PV.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PV.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENT.FECHAARCHIVO, 'dd/MMM/yyyy') AS Fecha
               --,ENT.FECHAARCHIVO                 AS Fecha
               ,
               LN.NOMCORTOLINEADENEGOCIO AS Linea,
               TP.NOMTIPOPRODUCTO AS "Tipo Producto",
               PR.NOMPRODUCTO AS Producto,
               CO.NOMRANGOCOMISION AS Comision,
               SUM(ISNULL(VPD.NUMINGRESOS, 0)) AS Tx,
               SUM(ISNULL(VPD.INGRESOS, 0)) AS Ingresos,
               SUM(ISNULL(VPD.ANULACIONES, 0)) AS Anulaciones,
               SUM(ISNULL(VPD.NUMANULACIONES, 0)) AS TxAnulaciones,
               SUM(ISNULL(VPD.IVAPRODUCTO, 0)) AS "IVA Producto",
               sum(isnull(VPD.DESCUENTOS, 0)) as Descuentos,
               SUM(ISNULL(VPD.INGRESOSBRUTOS, 0)) AS "Ingresos Brutos",
               SUM(ISNULL(VPD.COMISION, 0)) AS "Ingreso PDV",
               SUM(ISNULL(VPD.IVACOMISION, 0)) AS "IVA Ingreso",
               SUM(ISNULL(VPD.RETEFUENTE, 0)) AS ReteFuente,
               SUM(ISNULL(VPD.RETEICA, 0)) AS ReteIca,
               SUM(ISNULL(VPD.RETEUVT, 0)) AS ReteUVT,
               SUM(ISNULL(VPD.RETECREE, 0)) AS ReteCREE,
               SUM(ISNULL(VPD.COMISIONNETA, 0)) AS "Ingreso Neto",
               SUM(ISNULL(VPD.PREMIOSPAGADOS, 0)) AS "Pago Premios",
               SUM(ISNULL(VPD.VALORAPAGARGTECH, 0) +
                   ISNULL(VPD.VALORAPAGARFIDUCIA, 0)) AS "Total a Pagar"
        --                ,SUM(ISNULL(VPD.INGRESOS,0)) - SUM(ISNULL(VPD.INGRESOSBRUTOS,0)) - SUM(ISNULL(VPD.PREMIOSPAGADOS,0))  AS Total a Pagar
          FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA AG
         INNER JOIN WSXML_SFG.PUNTODEVENTA PV
            ON PV.CODAGRUPACIONPUNTODEVENTA = AG.ID_AGRUPACIONPUNTODEVENTA
         INNER JOIN WSXML_SFG.VW_PREFACTURACION_DIARIA VPD
            ON VPD.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ENT
            ON VPD.ID_ENTRADAARCHIVOCONTROL = ENT.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.LINEADENEGOCIO LN
            ON VPD.CODLINEADENEGOCIO = LN.ID_LINEADENEGOCIO
         INNER JOIN WSXML_SFG.TIPOPRODUCTO TP
            ON VPD.CODTIPOPRODUCTO = TP.ID_TIPOPRODUCTO
         INNER JOIN WSXML_SFG.PRODUCTO PR
            ON VPD.CODPRODUCTO = PR.ID_PRODUCTO
         INNER JOIN WSXML_SFG.RANGOCOMISION CO
            ON VPD.CODRANGOCOMISION = CO.ID_RANGOCOMISION
         WHERE ISNULL(VPD.IDENTIFICACION, '') + '-' + ISNULL(VPD.DIGITOVERIFICACION, '') = @P_NIT
           AND VPD.CODCICLOFACTURACIONPDV = @V_CODCICLOFACTURACIONPDV
           AND NOT (VPD.CODRANGOCOMISION IN
                (SELECT RANGOCOMISION.ID_RANGOCOMISION
                       FROM WSXML_SFG.RANGOCOMISIONDETALLE
                      INNER JOIN RANGOCOMISION
                         ON RANGOCOMISIONDETALLE.CODRANGOCOMISION =
                            RANGOCOMISION.ID_RANGOCOMISION
                      WHERE VALORTRANSACCIONAL = CASE
                              WHEN CODTIPOCOMISION IN (2) THEN
                               0
                              ELSE
                               VALORTRANSACCIONAL
                            END
                        AND VALORPORCENTUAL = CASE
                              WHEN CODTIPOCOMISION IN (1) THEN
                               0
                              ELSE
                               VALORPORCENTUAL
                            END
                        AND RANGOCOMISION.CODTIPOCOMISION IN (1, 2)
                      GROUP BY RANGOCOMISION.ID_RANGOCOMISION) AND VPD.INGRESOSBRUTOSVENTAS = 0)
         GROUP BY AG.CODIGOAGRUPACIONGTECH,
                  AG.NOMAGRUPACIONPUNTODEVENTA,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  PV.NOMPUNTODEVENTA,
                  ENT.FECHAARCHIVO,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO,
                  CO.NOMRANGOCOMISION
         ORDER BY AG.CODIGOAGRUPACIONGTECH,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO;
    
    END 
  
  END
GO



    IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTEFACTURACIONPRODMENSUAL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTEFACTURACIONPRODMENSUAL;
GO

  CREATE PROCEDURE WSXML_SFG.SFGINF_REPORTEFACTURACIONPRODMENSUAL(@p_CODIGOGTECHCADENA      INT,
                                          @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                         @p_ID_LINEADENEGOCIO      NUMERIC(22,0)) AS
 BEGIN
    DECLARE @v_FECHACICLO             DATETIME;
    DECLARE @v_FECHAINICIO            DATETIME;
    DECLARE @v_FECHAFIN               DATETIME;
    DECLARE @V_CODCICLOFACTURACIONPDV NUMERIC(22,0);
    DECLARE @V_REGISTROS              NUMERIC(22,0);
   
  SET NOCOUNT ON;
    IF @p_CODCICLOFACTURACIONPDV = -1 
        SET @V_CODCICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
      ELSE
        SET @V_CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;

  
    SELECT @v_FECHACICLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @V_CODCICLOFACTURACIONPDV;
  
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @v_FECHACICLO, @v_FECHAINICIO OUT, @v_FECHAFIN OUT
  
   
        SELECT AG.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AG.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PV.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PV.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENT.FECHAARCHIVO, 'dd/MMM/yyyy') AS Fecha
               --,ENT.FECHAARCHIVO                 AS Fecha
               ,
               LN.NOMCORTOLINEADENEGOCIO AS Linea,
               TP.NOMTIPOPRODUCTO AS "Tipo Producto",
               PR.NOMPRODUCTO AS Producto,
               CO.NOMRANGOCOMISION AS Comision,
               SUM(ISNULL(VPD.NUMINGRESOS, 0)) AS Tx,
               SUM(ISNULL(VPD.INGRESOS, 0)) AS Ingresos,
               SUM(ISNULL(VPD.ANULACIONES, 0)) AS Anulaciones,
               SUM(ISNULL(VPD.NUMANULACIONES, 0)) AS TxAnulaciones,
               SUM(ISNULL(VPD.IVAPRODUCTO, 0)) AS "IVA Producto",
               SUM(ISNULL(VPD.INGRESOSBRUTOS, 0)) AS "Ingresos Brutos",
               SUM(ISNULL(VPD.COMISION, 0)) AS "Ingreso PDV",
               SUM(ISNULL(VPD.IVACOMISION, 0)) AS "IVA Ingreso",
               SUM(ISNULL(VPD.RETEFUENTE, 0)) AS ReteFuente,
               SUM(ISNULL(VPD.RETEICA, 0)) AS ReteIca,
               SUM(ISNULL(VPD.RETEUVT, 0)) AS ReteUVT,
               --SUM(ISNULL(VPD.RETECREE, 0)) AS ReteCREE,
               SUM(ISNULL(VPD.COMISIONNETA, 0)) AS "Ingreso Neto",
               SUM(ISNULL(VPD.PREMIOSPAGADOS, 0)) AS "Pago Premios"--,
              -- SUM(ISNULL(VPD.VALORAPAGARGTECH, 0) +
              --     ISNULL(VPD.VALORAPAGARFIDUCIA, 0)) AS Total a Pagar
        --                ,SUM(ISNULL(VPD.INGRESOS,0)) - SUM(ISNULL(VPD.INGRESOSBRUTOS,0)) - SUM(ISNULL(VPD.PREMIOSPAGADOS,0))  AS Total a Pagar
          FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA AG
         INNER JOIN WSXML_SFG.PUNTODEVENTA PV
            ON PV.CODAGRUPACIONPUNTODEVENTA = AG.ID_AGRUPACIONPUNTODEVENTA
         INNER JOIN WSXML_SFG.VW_PREFACTURACION_DIARIA VPD
            ON VPD.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ENT
            ON VPD.ID_ENTRADAARCHIVOCONTROL = ENT.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.LINEADENEGOCIO LN
            ON VPD.CODLINEADENEGOCIO = LN.ID_LINEADENEGOCIO
         INNER JOIN WSXML_SFG.TIPOPRODUCTO TP
            ON VPD.CODTIPOPRODUCTO = TP.ID_TIPOPRODUCTO
         INNER JOIN WSXML_SFG.PRODUCTO PR
            ON VPD.CODPRODUCTO = PR.ID_PRODUCTO
         INNER JOIN WSXML_SFG.RANGOCOMISION CO
            ON VPD.CODRANGOCOMISION = CO.ID_RANGOCOMISION
         WHERE AG.CODIGOAGRUPACIONGTECH = @p_CODIGOGTECHCADENA
           AND VPD.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND @v_FECHAFIN
           AND VPD.CODLINEADENEGOCIO = @p_ID_LINEADENEGOCIO
           AND NOT (VPD.CODRANGOCOMISION IN
                (SELECT RANGOCOMISION.ID_RANGOCOMISION
                       FROM WSXML_SFG.RANGOCOMISIONDETALLE
                      INNER JOIN RANGOCOMISION
                         ON RANGOCOMISIONDETALLE.CODRANGOCOMISION =
                            RANGOCOMISION.ID_RANGOCOMISION
                      WHERE VALORTRANSACCIONAL = CASE
                              WHEN CODTIPOCOMISION IN (2) THEN
                               0
                              ELSE
                               VALORTRANSACCIONAL
                            END
                        AND VALORPORCENTUAL = CASE
                              WHEN CODTIPOCOMISION IN (1) THEN
                               0
                              ELSE
                               VALORPORCENTUAL
                            END
                        AND RANGOCOMISION.CODTIPOCOMISION IN (1, 2)
                      GROUP BY RANGOCOMISION.ID_RANGOCOMISION) AND VPD.INGRESOSBRUTOSVENTAS = 0)
         GROUP BY AG.CODIGOAGRUPACIONGTECH,
                  AG.NOMAGRUPACIONPUNTODEVENTA,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  PV.NOMPUNTODEVENTA,
                  ENT.FECHAARCHIVO,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO,
                  CO.NOMRANGOCOMISION
         ORDER BY AG.CODIGOAGRUPACIONGTECH,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO;

  END;
  GO


    IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTEFACTURACIONPRODDIARIO', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTEFACTURACIONPRODDIARIO;
GO

  CREATE PROCEDURE WSXML_SFG.SFGINF_REPORTEFACTURACIONPRODDIARIO(@P_NIT                    NVARCHAR(2000),
                                      @P_FECHA DATETIME
                                      ) AS
 BEGIN 
    DECLARE @V_REGISTROS              NUMERIC(22,0);
   
  SET NOCOUNT ON;
  
 
    SELECT @V_REGISTROS = COUNT(*)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' +
           ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT;
  
    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Razon Social', 16, 1);
    END
    ELSE BEGIN
        SELECT AG.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AG.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PV.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PV.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENT.FECHAARCHIVO, 'dd/MMM/yyyy') AS Fecha
               --,ENT.FECHAARCHIVO                 AS Fecha
               ,
               LN.NOMCORTOLINEADENEGOCIO AS Linea,
               TP.NOMTIPOPRODUCTO AS "Tipo Producto",
               PR.NOMPRODUCTO AS Producto,
               CO.NOMRANGOCOMISION AS Comision,
               SUM(ISNULL(VPD.NUMINGRESOS, 0)) AS Tx,
               SUM(ISNULL(VPD.INGRESOS, 0)) AS Ingresos,
               SUM(ISNULL(VPD.ANULACIONES, 0)) AS Anulaciones,
               SUM(ISNULL(VPD.NUMANULACIONES, 0)) AS TxAnulaciones,
               SUM(ISNULL(VPD.IVAPRODUCTO, 0)) AS "IVA Producto",
               SUM(ISNULL(VPD.INGRESOSBRUTOS, 0)) AS "Ingresos Brutos",
               SUM(ISNULL(VPD.COMISION, 0)) AS "Ingreso PDV",
               SUM(ISNULL(VPD.IVACOMISION, 0)) AS "IVA Ingreso",
               SUM(ISNULL(VPD.RETEFUENTE, 0)) AS ReteFuente,
               SUM(ISNULL(VPD.RETEICA, 0)) AS ReteIca,
               SUM(ISNULL(VPD.RETEUVT, 0)) AS ReteUVT,
               SUM(ISNULL(VPD.RETECREE, 0)) AS ReteCREE,
               SUM(ISNULL(VPD.COMISIONNETA, 0)) AS "Ingreso Neto",
               SUM(ISNULL(VPD.PREMIOSPAGADOS, 0)) AS "Pago Premios",
               SUM(ISNULL(VPD.VALORAPAGARGTECH, 0) +
                   ISNULL(VPD.VALORAPAGARFIDUCIA, 0)) AS "Total a Pagar"
        --                ,SUM(ISNULL(VPD.INGRESOS,0)) - SUM(ISNULL(VPD.INGRESOSBRUTOS,0)) - SUM(ISNULL(VPD.PREMIOSPAGADOS,0))  AS Total a Pagar
          FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA AG
         INNER JOIN WSXML_SFG.PUNTODEVENTA PV
            ON PV.CODAGRUPACIONPUNTODEVENTA = AG.ID_AGRUPACIONPUNTODEVENTA
         INNER JOIN WSXML_SFG.VW_PREFACTURACION_DIARIA VPD
            ON VPD.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ENT
            ON VPD.ID_ENTRADAARCHIVOCONTROL = ENT.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.LINEADENEGOCIO LN
            ON VPD.CODLINEADENEGOCIO = LN.ID_LINEADENEGOCIO
         INNER JOIN WSXML_SFG.TIPOPRODUCTO TP
            ON VPD.CODTIPOPRODUCTO = TP.ID_TIPOPRODUCTO
         INNER JOIN WSXML_SFG.PRODUCTO PR
            ON VPD.CODPRODUCTO = PR.ID_PRODUCTO
         INNER JOIN WSXML_SFG.RANGOCOMISION CO
            ON VPD.CODRANGOCOMISION = CO.ID_RANGOCOMISION
         WHERE ISNULL(VPD.IDENTIFICACION, '') + '-' + ISNULL(VPD.DIGITOVERIFICACION, '') = @P_NIT
           AND ENT.FECHAARCHIVO = @P_FECHA
           AND NOT (VPD.CODRANGOCOMISION IN
                (SELECT RANGOCOMISION.ID_RANGOCOMISION
                       FROM WSXML_SFG.RANGOCOMISIONDETALLE
                      INNER JOIN WSXML_SFG.RANGOCOMISION
                         ON RANGOCOMISIONDETALLE.CODRANGOCOMISION =
                            RANGOCOMISION.ID_RANGOCOMISION
                      WHERE VALORTRANSACCIONAL = CASE
                              WHEN CODTIPOCOMISION IN (2) THEN
                               0
                              ELSE
                               VALORTRANSACCIONAL
                            END
                        AND VALORPORCENTUAL = CASE
                              WHEN CODTIPOCOMISION IN (1) THEN
                               0
                              ELSE
                               VALORPORCENTUAL
                            END
                        AND RANGOCOMISION.CODTIPOCOMISION IN (1, 2)
                      GROUP BY RANGOCOMISION.ID_RANGOCOMISION) AND VPD.INGRESOSBRUTOSVENTAS = 0)
         GROUP BY AG.CODIGOAGRUPACIONGTECH,
                  AG.NOMAGRUPACIONPUNTODEVENTA,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  PV.NOMPUNTODEVENTA,
                  ENT.FECHAARCHIVO,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO,
                  CO.NOMRANGOCOMISION
         ORDER BY AG.CODIGOAGRUPACIONGTECH,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO;
    
    END 
  
  END
GO


    IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTEFACTURACIONDOSPAGOSNIT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTEFACTURACIONDOSPAGOSNIT;
GO



  CREATE PROCEDURE WSXML_SFG.SFGINF_REPORTEFACTURACIONDOSPAGOSNIT(@P_NIT         NVARCHAR(2000),
                                         @P_FECHAINICIO DATETIME,
                                        @P_FECHAFIN    DATETIME
                                        ) AS
 BEGIN 
    DECLARE @V_REGISTROS NUMERIC(22,0);
  
   
  SET NOCOUNT ON;
      SELECT @V_REGISTROS = COUNT(*)
      FROM WSXML_SFG.RAZONSOCIAL
      WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' +
            ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT;
    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Razon Social', 16, 1);
    END
    ELSE BEGIN
        SELECT AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PUNTODEVENTA.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENTRADAARCHIVOCONTROL.FECHAARCHIVO, 'dd/MMM/yyyy') AS Fecha,
               LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO AS Linea,
               TIPOPRODUCTO.NOMTIPOPRODUCTO AS "Tipo Producto",
               PRODUCTO.NOMPRODUCTO AS Producto,
               RANGOCOMISION.NOMRANGOCOMISION AS Comision,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.NUMTRANSACCIONES ELSE 0 END , 0)) AS Tx,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END , 0)) AS Ingresos,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA ELSE 0 END , 0)) AS "Ingresos Brutos",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISION ELSE 0 END , 0)) AS "Ingreso PDV",
               
               CASE WHEN REGISTROFACTURACION.CODTIPOCONTRATOPDV IN (1,2) THEN 
                  WSXM_SFG.SFGVATCOMISIONREGIMEN_GetVatValue(REGISTROFACTURACION.CODPUNTODEVENTA , REGISTROFACTURACION.CODPRODUCTO)
               ELSE 
                  WSXML_SFG.SFGTRIBUTARIOALIADOESTRATEGICO_GetVatValue( REGISTROFACTURACION.CODPRODUCTO,
                                                                          REGISTROFACTURACION.CODREGIMEN,
                                                                          REGISTROFACTURACION.CODCIUDAD) END                AS "% Iva Ingreso",
               
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.IVACOMISION ELSE 0 END , 0)) AS "IVA Ingreso",
               
               WSXML_SFG.SFGRETENCIONTRIBUTARIA_GetRetencionValue(registrofacturacion.codtipocontratopdv,
                                                         registrofacturacion.codproducto,
                                                         producto.codaliadoestrategico,
                                                         registrofacturacion.codciudad,
                                                         registrofacturacion.codregimen,
                                                         servicio.codcompania,
                                                         razonsocial.codtipopersonatributaria,
                                                         1/*Retencion en la fuente*/ ) as "% Retefuente",
               
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_FUENTE ELSE 0 END , 0)) AS ReteFuente,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_ICA ELSE 0 END , 0)) AS ReteIca,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONUVT.VALORRETENCIONUVT ELSE 0 END , 0)) AS ReteUVT,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_IVA ELSE 0 END , 0)) AS ReteIVA,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_CREE ELSE 0 END , 0)) AS ReteCREE,
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA ELSE 0 END , 0)) AS "Ingreso Neto",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END , 0)) AS "Pago Premios",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END,0)-
                   ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA ELSE 0 END,0)-
                   ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END,0))  AS "Valor Total a Pagar",
               SUM(CASE WHEN LINEADENEGOCIO.LINEAEGRESO=1 THEN (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION*-1 ELSE 0 END) ELSE 0 END ) +
               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN -- Total Facturacion
                         ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                               WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                                               ELSE 0 END) END
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                          WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                     ELSE 0 END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END))
                               - -- Menos Facturacion Fiducia
                               ((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                    WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                               ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END)), 6)
                    ELSE ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                              ELSE 0 END END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                         WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                    ELSE 0 END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
               END    )                                                                                                                                                      AS "Valor a Pagar Gtech",

               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                              ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END
                                -
                                CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
                    ELSE 0 END )                                                                                                                                           AS "Valor a Pagar Fiducia",
               (SUM(CASE WHEN LINEADENEGOCIO.LINEAEGRESO=1 THEN (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION*-1 ELSE 0 END) ELSE 0 END ) +
               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN -- Total Facturacion
                         ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                               WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                                               ELSE 0 END) END
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                          WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                     ELSE 0 END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END))
                               - -- Menos Facturacion Fiducia
                               ((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                    WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                               ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END)), 6)
                    ELSE ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                              ELSE 0 END END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                         WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                    ELSE 0 END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
               END    ))                                                                                                                                        +

               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                              ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END
                                -
                                CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
                    ELSE 0 END )  as "Total a pagar Gtech Liq Pago", 
              LINEADENEGOCIO.NOMLINEADENEGOCIO AS "Lineas Total a Pagar",
              CASE WHEN ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @P_FECHAINICIO AND dbo.NEXT_DAY(@P_FECHAINICIO, 'TUESDAY') THEN 1 ELSE 2 END  AS "Dias de Pago"
        FROM WSXML_SFG.REGISTROFACTURACION 
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN WSXML_SFG.PUNTODEVENTA ON REGISTROFACTURACION.CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
        INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN WSXML_SFG.TIPOPRODUCTO ON PRODUCTO.CODTIPOPRODUCTO= TIPOPRODUCTO.ID_TIPOPRODUCTO
        INNER JOIN WSXML_SFG.LINEADENEGOCIO ON TIPOPRODUCTO.CODLINEADENEGOCIO= LINEADENEGOCIO.ID_LINEADENEGOCIO
        INNER JOIN WSXML_SFG.RANGOCOMISION ON REGISTROFACTURACION.CODRANGOCOMISION = RANGOCOMISION.ID_RANGOCOMISION
        INNER JOIN WSXML_SFG.RAZONSOCIAL ON REGISTROFACTURACION.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        INNER JOIN WSXML_SFG.SERVICIO ON LINEADENEGOCIO.CODSERVICIO = SERVICIO.ID_SERVICIO
        LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                SUM(CASE WHEN CODIMPUESTO = 1 THEN VALORIMPUESTO ELSE 0 END) AS VALORIMPUESTO_IVA
                         FROM WSXML_SFG.IMPUESTOREGFACTURACION
                         GROUP BY CODREGISTROFACTURACION) IMPUESTOS ON (IMPUESTOS.CODREGISTROFACTURACION   = REGISTROFACTURACION.ID_REGISTROFACTURACION)
        LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_FUENTE,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 2 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_ICA,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 3 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_IVA,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 4 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_CREE
                         FROM WSXML_SFG.RETENCIONREGFACTURACION
                         GROUP BY CODREGISTROFACTURACION 
						 ) RETENCIONES 
							ON (RETENCIONES.CODREGISTROFACTURACION   = REGISTROFACTURACION.ID_REGISTROFACTURACION)
        LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                SUM(VALORRETENCION) VALORRETENCIONUVT
                         FROM WSXML_SFG.RETUVTREGFACTURACION
                         GROUP BY  CODREGISTROFACTURACION) RETENCIONUVT ON (RETENCIONUVT.CODREGISTROFACTURACION   = REGISTROFACTURACION.ID_REGISTROFACTURACION)
        WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' + ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT
                   AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @P_FECHAINICIO AND @P_FECHAFIN 
                   AND REGISTROFACTURACION.VALORTRANSACCION<>0
                   AND REGISTROFACTURACION.CODTIPOREGISTRO <>2
        GROUP BY        CASE WHEN ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @P_FECHAINICIO AND dbo.NEXT_DAY(@P_FECHAINICIO, 'TUESDAY') THEN 1 ELSE 2 END,
             AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,
               AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA,
               PUNTODEVENTA.NOMPUNTODEVENTA,
               FORMAT(ENTRADAARCHIVOCONTROL.FECHAARCHIVO, 'dd/MMM/yyyy'),
               LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO,
               TIPOPRODUCTO.NOMTIPOPRODUCTO,
               PRODUCTO.NOMPRODUCTO,
               RANGOCOMISION.NOMRANGOCOMISION,
               LINEADENEGOCIO.NOMLINEADENEGOCIO,
               SFGRETENCIONTRIBUTARIA.GetRetencionValue(registrofacturacion.codtipocontratopdv,
                                                         registrofacturacion.codproducto,
                                                         producto.codaliadoestrategico,
                                                         registrofacturacion.codciudad,
                                                         registrofacturacion.codregimen,
                                                         servicio.codcompania,
                                                         razonsocial.codtipopersonatributaria,
                                                         1/*Retencion en la fuente*/ ),
               CASE WHEN REGISTROFACTURACION.CODTIPOCONTRATOPDV IN (1,2) THEN 
                  SFGVATCOMISIONREGIMEN.GetVatValue(REGISTROFACTURACION.CODPUNTODEVENTA , REGISTROFACTURACION.CODPRODUCTO)
               ELSE 
                  SFGTRIBUTARIOALIADOESTRATEGICO.GetVatValue( REGISTROFACTURACION.CODPRODUCTO,
                                                                          REGISTROFACTURACION.CODREGIMEN,
                                                                          REGISTROFACTURACION.CODCIUDAD) 
		END ;
    
    END 
  
END

GO



  IF OBJECT_ID('WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODMENSUAL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODMENSUAL;
GO


  CREATE PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODMENSUAL(@p_CODIGOGTECHCADENA      INT,
                                          @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                          @p_ID_LINEADENEGOCIO      NUMERIC(22,0)) AS
 BEGIN
    DECLARE @v_FECHACICLO             DATETIME;
    DECLARE @v_FECHAINICIO            DATETIME;
    DECLARE @v_FECHAFIN               DATETIME;
    DECLARE @V_CODCICLOFACTURACIONPDV NUMERIC(22,0);
    DECLARE @V_REGISTROS              NUMERIC(22,0);
   
  SET NOCOUNT ON;
    IF @p_CODCICLOFACTURACIONPDV = -1 
        SET @V_CODCICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
      ELSE
        SET @V_CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    
  
    SELECT @v_FECHACICLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @V_CODCICLOFACTURACIONPDV;
  
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @v_FECHACICLO, @v_FECHAINICIO OUT, @v_FECHAFIN OUT
  
   
        SELECT AG.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AG.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PV.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PV.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENT.FECHAARCHIVO, 'dd/MMM/yyyy') AS "Fecha"
               --,ENT.FECHAARCHIVO                 AS "Fecha"
               ,
               LN.NOMCORTOLINEADENEGOCIO AS "Linea",
               TP.NOMTIPOPRODUCTO AS "Tipo Producto",
               PR.NOMPRODUCTO AS "Producto",
               CO.NOMRANGOCOMISION AS "Comision",
               SUM(ISNULL(VPD.NUMINGRESOS, 0)) AS "Tx",
               SUM(ISNULL(VPD.INGRESOS, 0)) AS "Ingresos",
               SUM(ISNULL(VPD.ANULACIONES, 0)) AS "Anulaciones",
               SUM(ISNULL(VPD.NUMANULACIONES, 0)) AS "TxAnulaciones",
               SUM(ISNULL(VPD.IVAPRODUCTO, 0)) AS "IVA Producto",
               SUM(ISNULL(VPD.INGRESOSBRUTOS, 0)) AS "Ingresos Brutos",
               SUM(ISNULL(VPD.COMISION, 0)) AS "Ingreso PDV",
               SUM(ISNULL(VPD.IVACOMISION, 0)) AS "IVA Ingreso",
               SUM(ISNULL(VPD.RETEFUENTE, 0)) AS "ReteFuente",
               SUM(ISNULL(VPD.RETEICA, 0)) AS "ReteIca",
               SUM(ISNULL(VPD.RETEUVT, 0)) AS "ReteUVT",
               --SUM(NVL(VPD.RETECREE, 0)) AS "ReteCREE",
               SUM(ISNULL(VPD.COMISIONNETA, 0)) AS "Ingreso Neto",
               SUM(ISNULL(VPD.PREMIOSPAGADOS, 0)) AS "Pago Premios"--,
              -- SUM(NVL(VPD.VALORAPAGARGTECH, 0) +
              --     NVL(VPD.VALORAPAGARFIDUCIA, 0)) AS "Total a Pagar"
        --                ,SUM(NVL(VPD.INGRESOS,0)) - SUM(NVL(VPD.INGRESOSBRUTOS,0)) - SUM(NVL(VPD.PREMIOSPAGADOS,0))  AS "Total a Pagar"
          FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA AG
         INNER JOIN WSXML_SFG.PUNTODEVENTA PV
            ON PV.CODAGRUPACIONPUNTODEVENTA = AG.ID_AGRUPACIONPUNTODEVENTA
         INNER JOIN WSXML_SFG.VW_PREFACTURACION_DIARIA VPD
            ON VPD.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ENT
            ON VPD.ID_ENTRADAARCHIVOCONTROL = ENT.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.LINEADENEGOCIO LN
            ON VPD.CODLINEADENEGOCIO = LN.ID_LINEADENEGOCIO
         INNER JOIN WSXML_SFG.TIPOPRODUCTO TP
            ON VPD.CODTIPOPRODUCTO = TP.ID_TIPOPRODUCTO
         INNER JOIN WSXML_SFG.PRODUCTO PR
            ON VPD.CODPRODUCTO = PR.ID_PRODUCTO
         INNER JOIN WSXML_SFG.RANGOCOMISION CO
            ON VPD.CODRANGOCOMISION = CO.ID_RANGOCOMISION
         WHERE AG.CODIGOAGRUPACIONGTECH = @p_CODIGOGTECHCADENA
           AND VPD.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND @v_FECHAFIN
           AND VPD.CODLINEADENEGOCIO = @p_ID_LINEADENEGOCIO
           AND NOT (VPD.CODRANGOCOMISION IN
                (SELECT RANGOCOMISION.ID_RANGOCOMISION
                       FROM WSXML_SFG.RANGOCOMISIONDETALLE
                      INNER JOIN RANGOCOMISION
                         ON RANGOCOMISIONDETALLE.CODRANGOCOMISION =
                            RANGOCOMISION.ID_RANGOCOMISION
                      WHERE VALORTRANSACCIONAL = CASE
                              WHEN CODTIPOCOMISION IN (2) THEN
                               0
                              ELSE
                               VALORTRANSACCIONAL
                            END
                        AND VALORPORCENTUAL = CASE
                              WHEN CODTIPOCOMISION IN (1) THEN
                               0
                              ELSE
                               VALORPORCENTUAL
                            END
                        AND RANGOCOMISION.CODTIPOCOMISION IN (1, 2)
                      GROUP BY RANGOCOMISION.ID_RANGOCOMISION) AND
                VPD.INGRESOSBRUTOSVENTAS = 0)
         GROUP BY AG.CODIGOAGRUPACIONGTECH,
                  AG.NOMAGRUPACIONPUNTODEVENTA,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  PV.NOMPUNTODEVENTA,
                  ENT.FECHAARCHIVO,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO,
                  CO.NOMRANGOCOMISION
         ORDER BY AG.CODIGOAGRUPACIONGTECH,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO;

  END;
  GO
  
  
    IF OBJECT_ID('WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODDIARIO', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODDIARIO;
GO


  CREATE PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONPRODDIARIO(@P_NIT                    NVARCHAR(2000),
                                       @P_FECHA DATETIME) AS
 BEGIN 
    DECLARE @V_REGISTROS              NUMERIC(22,0);
   
  SET NOCOUNT ON;
  
 
    SELECT @V_REGISTROS = COUNT(*)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' +
           ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT;
  
    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Razon Social', 16, 1);
    END
    ELSE BEGIN
        SELECT AG.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AG.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PV.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PV.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENT.FECHAARCHIVO, 'dd/MMM/yyyy') AS "Fecha"
               --,ENT.FECHAARCHIVO                 AS "Fecha"
               ,
               LN.NOMCORTOLINEADENEGOCIO AS "Linea",
               TP.NOMTIPOPRODUCTO AS "Tipo Producto",
               PR.NOMPRODUCTO AS "Producto",
               CO.NOMRANGOCOMISION AS "Comision",
               SUM(ISNULL(VPD.NUMINGRESOS, 0)) AS "Tx",
               SUM(ISNULL(VPD.INGRESOS, 0)) AS "Ingresos",
               SUM(ISNULL(VPD.ANULACIONES, 0)) AS "Anulaciones",
               SUM(ISNULL(VPD.NUMANULACIONES, 0)) AS "TxAnulaciones",
               SUM(ISNULL(VPD.IVAPRODUCTO, 0)) AS "IVA Producto",
               SUM(ISNULL(VPD.INGRESOSBRUTOS, 0)) AS "Ingresos Brutos",
               SUM(ISNULL(VPD.COMISION, 0)) AS "Ingreso PDV",
               SUM(ISNULL(VPD.IVACOMISION, 0)) AS "IVA Ingreso",
               SUM(ISNULL(VPD.RETEFUENTE, 0)) AS "ReteFuente",
               SUM(ISNULL(VPD.RETEICA, 0)) AS "ReteIca",
               SUM(ISNULL(VPD.RETEUVT, 0)) AS "ReteUVT",
               SUM(ISNULL(VPD.RETECREE, 0)) AS "ReteCREE",
               SUM(ISNULL(VPD.COMISIONNETA, 0)) AS "Ingreso Neto",
               SUM(ISNULL(VPD.PREMIOSPAGADOS, 0)) AS "Pago Premios",
               SUM(ISNULL(VPD.VALORAPAGARGTECH, 0) +
                   ISNULL(VPD.VALORAPAGARFIDUCIA, 0)) AS "Total a Pagar"
        --                ,SUM(NVL(VPD.INGRESOS,0)) - SUM(NVL(VPD.INGRESOSBRUTOS,0)) - SUM(NVL(VPD.PREMIOSPAGADOS,0))  AS "Total a Pagar"
          FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA AG
         INNER JOIN WSXML_SFG.PUNTODEVENTA PV
            ON PV.CODAGRUPACIONPUNTODEVENTA = AG.ID_AGRUPACIONPUNTODEVENTA
         INNER JOIN WSXML_SFG.VW_PREFACTURACION_DIARIA VPD
            ON VPD.CODPUNTODEVENTA = PV.ID_PUNTODEVENTA
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ENT
            ON VPD.ID_ENTRADAARCHIVOCONTROL = ENT.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.LINEADENEGOCIO LN
            ON VPD.CODLINEADENEGOCIO = LN.ID_LINEADENEGOCIO
         INNER JOIN WSXML_SFG.TIPOPRODUCTO TP
            ON VPD.CODTIPOPRODUCTO = TP.ID_TIPOPRODUCTO
         INNER JOIN WSXML_SFG.PRODUCTO PR
            ON VPD.CODPRODUCTO = PR.ID_PRODUCTO
         INNER JOIN WSXML_SFG.RANGOCOMISION CO
            ON VPD.CODRANGOCOMISION = CO.ID_RANGOCOMISION
         WHERE ISNULL(VPD.IDENTIFICACION, '') + '-' + ISNULL(VPD.DIGITOVERIFICACION, '') = @P_NIT
           AND ENT.FECHAARCHIVO = @P_FECHA
           AND NOT (VPD.CODRANGOCOMISION IN
                (SELECT RANGOCOMISION.ID_RANGOCOMISION
                       FROM WSXML_SFG.RANGOCOMISIONDETALLE
                      INNER JOIN WSXML_SFG.RANGOCOMISION
                         ON RANGOCOMISIONDETALLE.CODRANGOCOMISION =
                            RANGOCOMISION.ID_RANGOCOMISION
                      WHERE VALORTRANSACCIONAL = CASE
                              WHEN CODTIPOCOMISION IN (2) THEN
                               0
                              ELSE
                               VALORTRANSACCIONAL
                            END
                        AND VALORPORCENTUAL = CASE
                              WHEN CODTIPOCOMISION IN (1) THEN
                               0
                              ELSE
                               VALORPORCENTUAL
                            END
                        AND RANGOCOMISION.CODTIPOCOMISION IN (1, 2)
                      GROUP BY RANGOCOMISION.ID_RANGOCOMISION) AND
                VPD.INGRESOSBRUTOSVENTAS = 0)
         GROUP BY AG.CODIGOAGRUPACIONGTECH,
                  AG.NOMAGRUPACIONPUNTODEVENTA,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  PV.NOMPUNTODEVENTA,
                  ENT.FECHAARCHIVO,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO,
                  CO.NOMRANGOCOMISION
         ORDER BY AG.CODIGOAGRUPACIONGTECH,
                  PV.CODIGOGTECHPUNTODEVENTA,
                  LN.NOMCORTOLINEADENEGOCIO,
                  TP.NOMTIPOPRODUCTO,
                  PR.NOMPRODUCTO;
    
    END 
  
  END
GO



     IF OBJECT_ID('WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONDOSPAGOSNIT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONDOSPAGOSNIT;
GO


  CREATE PROCEDURE WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONDOSPAGOSNIT(@P_NIT         NVARCHAR(2000),
                                         @P_FECHAINICIO DATETIME,
                                         @P_FECHAFIN    DATETIME) AS
 BEGIN 
    DECLARE @V_REGISTROS NUMERIC(22,0);
  
   
  SET NOCOUNT ON;
      SELECT @V_REGISTROS = COUNT(*)
      FROM WSXML_SFG.RAZONSOCIAL
      WHERE ISNULL(CONVERT(VARCHAR,RAZONSOCIAL.IDENTIFICACION), '') + '-' +
            ISNULL(CONVERT(VARCHAR,RAZONSOCIAL.DIGITOVERIFICACION), '') = @P_NIT;
    IF @V_REGISTROS = 0 BEGIN
      RAISERROR('-20054 El Nit ingresado no corresponde a una Razon Social', 16, 1);
    END
    ELSE BEGIN
        SELECT AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH AS "Codigo Cadena",
               AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA AS "Nombre Cadena",
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               PUNTODEVENTA.NOMPUNTODEVENTA AS "Nombre Punto de Venta",
               FORMAT(ENTRADAARCHIVOCONTROL.FECHAARCHIVO, 'dd/MMM/yyyy') AS "Fecha",
               LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO AS "Linea",
               TIPOPRODUCTO.NOMTIPOPRODUCTO AS "Tipo Producto",
               PRODUCTO.NOMPRODUCTO AS "Producto",
               RANGOCOMISION.NOMRANGOCOMISION AS "Comision",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.NUMTRANSACCIONES ELSE 0 END , 0)) AS "Tx",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END , 0)) AS "Ingresos",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA ELSE 0 END , 0)) AS "Ingresos Brutos",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISION ELSE 0 END , 0)) AS "Ingreso PDV",
               
               CASE WHEN REGISTROFACTURACION.CODTIPOCONTRATOPDV IN (1,2) THEN 
                 WSXML_SFG.SFGVATCOMISIONREGIMEN_GetVatValue(REGISTROFACTURACION.CODPUNTODEVENTA , REGISTROFACTURACION.CODPRODUCTO)
               ELSE 
                  WSXML_SFG.SFGTRIBUTARIOALIADOESTRATEGICO_GetVatValue( REGISTROFACTURACION.CODPRODUCTO,
                                                                          REGISTROFACTURACION.CODREGIMEN,
                                                                          REGISTROFACTURACION.CODCIUDAD) END                AS "% Iva Ingreso",
               
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.IVACOMISION ELSE 0 END , 0)) AS "IVA Ingreso",
               
               WSXML_SFG.SFGRETENCIONTRIBUTARIA_GetRetencionValue(registrofacturacion.codtipocontratopdv,
                                                         registrofacturacion.codproducto,
                                                         producto.codaliadoestrategico,
                                                         registrofacturacion.codciudad,
                                                         registrofacturacion.codregimen,
                                                         servicio.codcompania,
                                                         razonsocial.codtipopersonatributaria,
                                                         1/*Retencion en la fuente*/ ) as "% Retefuente",
               
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_FUENTE ELSE 0 END , 0)) AS "ReteFuente",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_ICA ELSE 0 END , 0)) AS "ReteIca",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONUVT.VALORRETENCIONUVT ELSE 0 END , 0)) AS "ReteUVT",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_IVA ELSE 0 END , 0)) AS "ReteIVA",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN RETENCIONES.VALORRETENCION_CREE ELSE 0 END , 0)) AS "ReteCREE",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA ELSE 0 END , 0)) AS "Ingreso Neto",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END , 0)) AS "Pago Premios",
               SUM(ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END,0)-
                   ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA ELSE 0 END,0)-
                   ISNULL(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END,0))  AS "Valor Total a Pagar",
               SUM(CASE WHEN LINEADENEGOCIO.LINEAEGRESO=1 THEN (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION*-1 ELSE 0 END) ELSE 0 END ) +
               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN -- Total Facturacion
                         ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                               WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                                               ELSE 0 END) END
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                          WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                     ELSE 0 END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END))
                               - -- Menos Facturacion Fiducia
                               ((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                    WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                               ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END)), 6)
                    ELSE ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                              ELSE 0 END END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                         WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                    ELSE 0 END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
               END    )                                                                                                                                                      AS "Valor a Pagar Gtech",

               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                              ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END
                                -
                                CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
                    ELSE 0 END )                                                                                                                                           AS "Valor a Pagar Fiducia",
               (SUM(CASE WHEN LINEADENEGOCIO.LINEAEGRESO=1 THEN (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION*-1 ELSE 0 END) ELSE 0 END ) +
               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN -- Total Facturacion
                         ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                               WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                                               ELSE 0 END) END
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                          WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                     ELSE 0 END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END))
                               - -- Menos Facturacion Fiducia
                               ((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                    WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                               ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END)
                                -
                                (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END)), 6)
                    ELSE ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION * (-1)
                                                                              ELSE 0 END END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORCOMISIONNETA
                                         WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORCOMISIONNETA * (-1)
                                    ELSE 0 END)
                                -
                               (CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
               END    ))                                                                                                                                        +

               SUM(CASE WHEN PRODUCTO.PORCENTAJEFIDUCIA > 0
                    THEN ROUND((CASE WHEN LINEADENEGOCIO.LINEAEGRESO = 1 THEN 0 ELSE CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA
                                                                                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA * (-1)
                                                                              ELSE 0 END * (PRODUCTO.PORCENTAJEFIDUCIA / 100) END
                                -
                                CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END), 6)
                    ELSE 0 END )  as "Total a pagar Gtech Liq Pago", 
              LINEADENEGOCIO.NOMLINEADENEGOCIO AS "Lineas Total a Pagar",
              CASE WHEN ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @P_FECHAINICIO AND dbo.NEXT_DAY(@P_FECHAINICIO, 'TUESDAY') THEN 1 ELSE 2 END  AS "Dias de Pago"
        FROM WSXML_SFG.REGISTROFACTURACION 
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN WSXML_SFG.PUNTODEVENTA ON REGISTROFACTURACION.CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
        INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN WSXML_SFG.TIPOPRODUCTO ON PRODUCTO.CODTIPOPRODUCTO= TIPOPRODUCTO.ID_TIPOPRODUCTO
        INNER JOIN WSXML_SFG.LINEADENEGOCIO ON TIPOPRODUCTO.CODLINEADENEGOCIO= LINEADENEGOCIO.ID_LINEADENEGOCIO
        INNER JOIN WSXML_SFG.RANGOCOMISION ON REGISTROFACTURACION.CODRANGOCOMISION = RANGOCOMISION.ID_RANGOCOMISION
        INNER JOIN WSXML_SFG.RAZONSOCIAL ON REGISTROFACTURACION.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        INNER JOIN WSXML_SFG.SERVICIO ON LINEADENEGOCIO.CODSERVICIO = SERVICIO.ID_SERVICIO
        LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                SUM(CASE WHEN CODIMPUESTO = 1 THEN VALORIMPUESTO ELSE 0 END) AS VALORIMPUESTO_IVA
                         FROM WSXML_SFG.IMPUESTOREGFACTURACION
                         GROUP BY CODREGISTROFACTURACION) IMPUESTOS ON (IMPUESTOS.CODREGISTROFACTURACION   = REGISTROFACTURACION.ID_REGISTROFACTURACION)
        LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 1 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_FUENTE,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 2 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_ICA,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 3 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_IVA,
                                SUM(CASE WHEN CODRETENCIONTRIBUTARIA = 4 THEN VALORRETENCION ELSE 0 END) AS VALORRETENCION_CREE
                         FROM RETENCIONREGFACTURACION
                         GROUP BY CODREGISTROFACTURACION ) RETENCIONES ON (RETENCIONES.CODREGISTROFACTURACION   = REGISTROFACTURACION.ID_REGISTROFACTURACION)
        LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                SUM(VALORRETENCION) VALORRETENCIONUVT
                         FROM WSXML_SFG.RETUVTREGFACTURACION
                         GROUP BY  CODREGISTROFACTURACION) RETENCIONUVT ON (RETENCIONUVT.CODREGISTROFACTURACION   = REGISTROFACTURACION.ID_REGISTROFACTURACION)
        WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' + ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT
                   AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @P_FECHAINICIO AND @P_FECHAFIN 
                   AND REGISTROFACTURACION.VALORTRANSACCION<>0
                   AND REGISTROFACTURACION.CODTIPOREGISTRO <>2
        GROUP BY        CASE WHEN ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @P_FECHAINICIO AND dbo.NEXT_DAY(@P_FECHAINICIO, 'TUESDAY') THEN 1 ELSE 2 END,
             AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,
               AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA,
               PUNTODEVENTA.NOMPUNTODEVENTA,
               format(ENTRADAARCHIVOCONTROL.FECHAARCHIVO, 'dd/MMM/yyyy'),
               LINEADENEGOCIO.NOMCORTOLINEADENEGOCIO,
               TIPOPRODUCTO.NOMTIPOPRODUCTO,
               PRODUCTO.NOMPRODUCTO,
               RANGOCOMISION.NOMRANGOCOMISION,
               LINEADENEGOCIO.NOMLINEADENEGOCIO,
               WSXML_SFG.SFGRETENCIONTRIBUTARIA_GetRetencionValue(registrofacturacion.codtipocontratopdv,
                                                         registrofacturacion.codproducto,
                                                         producto.codaliadoestrategico,
                                                         registrofacturacion.codciudad,
                                                         registrofacturacion.codregimen,
                                                         servicio.codcompania,
                                                         razonsocial.codtipopersonatributaria,
                                                         1/*Retencion en la fuente*/ ),
               CASE WHEN REGISTROFACTURACION.CODTIPOCONTRATOPDV IN (1,2) THEN 
                  WSXML_SFG.SFGVATCOMISIONREGIMEN_GetVatValue(REGISTROFACTURACION.CODPUNTODEVENTA , REGISTROFACTURACION.CODPRODUCTO)
               ELSE 
                  WSXML_SFG.SFGTRIBUTARIOALIADOESTRATEGICO_GetVatValue( REGISTROFACTURACION.CODPRODUCTO,
                                                                          REGISTROFACTURACION.CODREGIMEN,
                                                                          REGISTROFACTURACION.CODCIUDAD) END ;
    
    END 
  
  END

 GO

DECLARE @P_NIT         NVARCHAR(2000) = '123456'
DECLARE @P_FECHAINICIO DATETIME = '2008-01-12 00:00:00'
DECLARE @P_FECHAFIN    DATETIME = '2008-12-12 00:00:00'
EXEC WSXML_SFG.SFGINF_FACTCADENAESESTANDAR_REPORTEFACTURACIONDOSPAGOSNIT
	@P_NIT         ,
    @P_FECHAINICIO ,
    @P_FECHAFIN    