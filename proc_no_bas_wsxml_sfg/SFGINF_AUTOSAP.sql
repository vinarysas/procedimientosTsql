USE SFGPRODU;
--  DDL for Package Body SFGINF_AUTOSAP
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_AUTOSAP */ 
  --SFGINF_AUTOSAP.GetCISJuegos
  IF OBJECT_ID('WSXML_SFG.SFGINF_AUTOSAP_GetCISJuegos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_AUTOSAP_GetCISJuegos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_AUTOSAP_GetCISJuegos(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                        @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
          SELECT  CONVERT(VARCHAR(8), CONVERT(DATETIME, CONVERT(DATE,GETDATE())),112) AS Fecha,
           CODIGOPRODUCTOSAP.CENTRODECOSTOS AS CENTRODECOSTO,
            isnull(CODIGOPRODUCTOSAP.ID_CODIGOPRODUCTOSAP,'') AS CODIGOSAP,
             CONVERT(VARCHAR(8), CONVERT(DATETIME, CONVERT(DATE,ENTRADAARCHIVOCONTROL.FECHAARCHIVO)),112) AS FECHAARCHIVO,
             'COP' AS CURRENCY,
             SUM(Case WHEN CODIGOPRODUCTOSAP.ID_CODIGOPRODUCTOSAP IN (8) THEN null else
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   ELSE
                    0
                 END end) AS TRANSACCIONES,
             SUM(Case WHEN CODIGOPRODUCTOSAP.ID_CODIGOPRODUCTOSAP IN (8) THEN
               case
                WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                      REGISTROFACTURACION.NUMTRANSACCIONES
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                      REGISTROFACTURACION.NUMTRANSACCIONES * -1
                     ELSE
                      0
               end
             else
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.VALORTRANSACCION
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.VALORTRANSACCION * -1
                   ELSE
                    0
                 END end ) AS VENTASBRUTAS,

             '' AS "FREE COUNT",
             '' AS "FREE AMOUNT",
             '' AS "DISCOUNT COUNT",
             '' AS "DISCOUNT AMOUNT",
             '' AS "CANCEL COUNT",
             '' AS "CANCEL AMOUNT",
             --Conteo de premios pagados  '' AS VALIDATION COUNT,
             SUM( CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   ELSE
                    null
                 END ) AS "VALIDATION COUNT",
            SUM(CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 4 THEN
                    REGISTROFACTURACION.VALORTRANSACCION
                   ELSE
                    null
                 END) AS "VALIDATION AMOUNT",
              CASE
                     WHEN DATEPART(WEEKDAY,ENTRADAARCHIVOCONTROL.FECHAARCHIVO) IN (1,5) THEN
                      convert(varchar,  max(isnull(sorteos.numero_ganadores, 0)))
                     ELSE
                      ''
                END AS "JACKPOT WINNERS",
            acumuladobaloto.acumuladosinganador AS "ACUMULADO NOWIN",
            acumuladobaloto.acumuladoconganador  AS "ACUMULADO WIN",
             '' AS "INSTANT SALES COUNT",
             '' AS "INSTANT SALES AMOUNT",
             '' AS "INSTANT SETTLES COUNT",
             '' AS "INSTANT SETTLES AMOUNT",
             '' AS "INSTANT ACTIVATION COUNT",
             '' AS "INSTANT ACTIVATION AMOUNT",
             '' AS "INSTANT RETURN COUNT",
             '' AS "INSTANT RETURN AMOUNT",
             '' AS "INSTANT VALIDATION COUNT",
             '' AS "INSTANT VALIDATION AMOUNT",
             '' AS "EXTRA COUNT",
             '' AS "EXTRA AMOUNT"
            FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = 
             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN WSXML_SFG.PRODUCTO
          ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       INNER JOIN WSXML_SFG.TIPOPRODUCTO
          ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
       INNER JOIN WSXML_SFG.LINEADENEGOCIO
          ON TIPOPRODUCTO.CODLINEADENEGOCIO =
             LINEADENEGOCIO.ID_LINEADENEGOCIO
       INNER JOIN WSXML_SFG.CODIGOPRODUCTOSAP
          ON CODIGOPRODUCTOSAP.ID_CODIGOPRODUCTOSAP = CASE
               WHEN PRODUCTO.CODIGOGTECHPRODUCTO IN ('19999') THEN
                1 /*Revancha*/
               WHEN PRODUCTO.CODIGOGTECHPRODUCTO IN ('10002') THEN
                2 /*Baloto*/
               WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO IN (2) THEN
                3 /*chance*/
               WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO IN (3) THEN
                4 /*Loterias*/
               WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO IN (4) THEN
                5 /*Super satros*/
               WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO IN (5) THEN
                6 /*RAces*/
               WHEN LINEADENEGOCIO.ID_LINEADENEGOCIO IN (2) THEN
                7 /*Etu*/
               WHEN TIPOPRODUCTO.Id_Tipoproducto IN (8,9,10,11,12) THEN
                8 /*Bp*/
               ELSE
                1000
             END
        left outer JOIN (

                         select case
                                   when producto.codigogtechproducto = '10002' then
                                    2
                                   when producto.codigogtechproducto = '19999' then
                                    1
                                   else
                                    0
                                 end as productosap,
                                 ctrl.sorteo,
                                 det.ganadoras as numero_ganadores
                           from WSXML_SFG.detalle_l1shrclc det
                          inner join WSXML_SFG.producto_l1shrclc pro
                             on det.codproducto_l1shrclc =
                                pro.id_producto_l1shrclc
                          inner join WSXML_SFG.control_l1shrclc ctrl
                             on pro.codcontrol_l1shrclc =
                                ctrl.id_control_l1shrclc
                          inner join WSXML_SFG.producto
                             on pro.codproducto = producto.id_producto
                          where producto.codigogtechproducto in
                                ('10002', '19999')
                            and det.codcategoria_aciertos_l1liab01 = 6) sorteos
          on sorteos.sorteo =
             round(((WSXML_SFG.datediff('ww', CONVERT(DATETIME, '30/12/1999',103),ENTRADAARCHIVOCONTROL.FECHAARCHIVO) * 2) - 137) + CASE
                     WHEN DATEPART(WEEKDAY,ENTRADAARCHIVOCONTROL.FECHAARCHIVO) IN (4,7) THEN 0 ELSE 1 END,0)
         and sorteos.productosap = CODIGOPRODUCTOSAP.Id_Codigoproductosap
       LEFT JOIN WSXML_SFG.acumuladobaloto
          ON acumuladobaloto.juegoproducto = PRODUCTO.Id_Producto
           and  acumuladobaloto.fechasorteo = ENTRADAARCHIVOCONTROL.FECHAARCHIVO
    WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA)) -- '24/apr/2013' AND '26/apr/2013'--between '21/APR/2013' AND '30/APR/2013'-- '02/JUL/2013'--TRUNC(DIA) --
       GROUP BY CODIGOPRODUCTOSAP.NOMPRODUCTOSAP,
                ENTRADAARCHIVOCONTROL.FECHAARCHIVO,
                CODIGOPRODUCTOSAP.CENTRODECOSTOS,
                CODIGOPRODUCTOSAP.ID_CODIGOPRODUCTOSAP,
                acumuladobaloto.acumuladosinganador,
                acumuladobaloto.acumuladoconganador
       ORDER BY CODIGOPRODUCTOSAP.ID_CODIGOPRODUCTOSAP;
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_AUTOSAP_AutoSapDiaComercial', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_AUTOSAP_AutoSapDiaComercial;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_AUTOSAP_AutoSapDiaComercial(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                @pg_CADENA                NVARCHAR(2000),
                                @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                               @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @vFECHACICLO DATETIME;
    DECLARE @vFIRSTDATE  DATETIME;
    DECLARE @vLASTDATE   DATETIME;

    
   SET NOCOUNT ON;

	IF @p_CODCICLOFACTURACIONPDV = -1 BEGIN
        SELECT @vLASTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(7), GETDATE(), 120) + '-01') - 1;
        SELECT @vFIRSTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(7), @vLASTDATE, 120) + '-01');
      END ELSE BEGIN
        SELECT @vFECHACICLO = FECHAEJECUCION
          FROM WSXML_SFG.CICLOFACTURACIONPDV
         WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV and active = 1;

        EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @vFECHACICLO, @vFIRSTDATE OUT, @vLASTDATE OUT
    END

     /* Fecha,  Tx Baloto,  BALOTO,  Tx Revancha,  Revancha,  Tx Chances,  Chances,
  Tx Superastro, Superastro,   Tx Loterias,  Loterias,
    Tx Etus,  Etus,  Tx Billpayment,  Billpayment*/

      SELECT CONVERT(DATETIME, CONVERT(DATE,ENTRADAARCHIVOCONTROL.FECHAARCHIVO)) AS FECHA,
      /*BALOTO*/
               SUM(CASE WHEN  TIPOPRODUCTO.ID_TIPOPRODUCTO = 1 AND PRODUCTO.CODIGOGTECHPRODUCTO NOT IN ('19999') THEN(
                 CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                        REGISTROFACTURACION.NUMTRANSACCIONES
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                        REGISTROFACTURACION.NUMTRANSACCIONES * -1
                       ELSE
                        0
                     END)  ELSE 0 END) AS TXBALOTO,
              SUM(CASE WHEN  TIPOPRODUCTO.ID_TIPOPRODUCTO = 1 AND PRODUCTO.CODIGOGTECHPRODUCTO NOT IN ('19999') THEN(
                  CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.VALORTRANSACCION
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.VALORTRANSACCION * -1
                   ELSE
                        0
                    END) ELSE 0 END) AS VENTASBALOTO,
         /*RECANCHA*/
               SUM(CASE WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO = 1 AND PRODUCTO.CODIGOGTECHPRODUCTO NOT IN ('10002') THEN (
                 CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                        REGISTROFACTURACION.NUMTRANSACCIONES
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                        REGISTROFACTURACION.NUMTRANSACCIONES * -1
                       ELSE
                        0
                     END)  ELSE 0 END) AS TXREVANCHA,
                SUM(CASE WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO =1 AND PRODUCTO.CODIGOGTECHPRODUCTO NOT IN ('10002') THEN(
                  CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.VALORTRANSACCION
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.VALORTRANSACCION * -1
                   ELSE
                        0
                    END) ELSE 0 END) AS VENTASREVANCHA,
          /*CHANCE*/
           SUM(CASE WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO = 2  THEN(
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   ELSE
                    0
                 END)  ELSE 0 END) AS TXCHANCE,
            SUM(CASE WHEN  TIPOPRODUCTO.ID_TIPOPRODUCTO = 2  THEN(
              CASE
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                REGISTROFACTURACION.VALORTRANSACCION
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                REGISTROFACTURACION.VALORTRANSACCION * -1
               ELSE
                    0
                END) ELSE 0 END) AS VENTASCHANCE,

          /*SUPER ASTRO*/
           SUM(CASE WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO = 4  THEN(
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   ELSE
                    0
                 END)  ELSE 0 END) AS TXSUPERASTRO,
            SUM(CASE WHEN  TIPOPRODUCTO.ID_TIPOPRODUCTO = 3  THEN(
              CASE
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                REGISTROFACTURACION.VALORTRANSACCION
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                REGISTROFACTURACION.VALORTRANSACCION * -1
               ELSE
                    0
                END) ELSE 0 END) AS VENTASSUPERASTRO,

        /*LOTERIAS*/
           SUM(CASE WHEN TIPOPRODUCTO.ID_TIPOPRODUCTO = 3  THEN(
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   ELSE
                    0
                 END)  ELSE 0 END) AS TXLOTERIAS,
            SUM(CASE WHEN  TIPOPRODUCTO.ID_TIPOPRODUCTO = 3  THEN(
              CASE
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                REGISTROFACTURACION.VALORTRANSACCION
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                REGISTROFACTURACION.VALORTRANSACCION * -1
               ELSE
                    0
                END) ELSE 0 END) AS VENTASLOTERIAS,
        /*ETUS*/
           SUM(CASE WHEN LINEADENEGOCIO.ID_LINEADENEGOCIO = 2  THEN(
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   ELSE
                    0
                 END)  ELSE 0 END) AS TXETUS,

            SUM(CASE WHEN  LINEADENEGOCIO.ID_LINEADENEGOCIO = 2   THEN(
              CASE
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                REGISTROFACTURACION.VALORTRANSACCION
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                REGISTROFACTURACION.VALORTRANSACCION * -1
               ELSE
                    0
                END) ELSE 0 END) AS VENTASETUS,
         /*BP*/
           SUM(CASE WHEN TIPOPRODUCTO.Id_Tipoproducto IN (8,9,10,11,12)  THEN(
             CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   ELSE
                    0
                 END)  ELSE 0 END) AS TXBILLPAYMENT,

            SUM(CASE WHEN  TIPOPRODUCTO.Id_Tipoproducto IN (8,9,10,11,12)   THEN(
              CASE
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 3) THEN
                REGISTROFACTURACION.VALORTRANSACCION
               WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (2) THEN
                REGISTROFACTURACION.VALORTRANSACCION * -1
               ELSE
                    0
                END) ELSE 0 END) AS VENTASBILLPAYMENT
       FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN WSXML_SFG.PRODUCTO
          ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       INNER JOIN WSXML_SFG.TIPOPRODUCTO
          ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
       INNER JOIN WSXML_SFG.LINEADENEGOCIO
          ON TIPOPRODUCTO.CODLINEADENEGOCIO =
             LINEADENEGOCIO.ID_LINEADENEGOCIO
       WHERE  ENTRADAARCHIVOCONTROL.FECHAARCHIVO   --='02/JUL/2013'
        BETWEEN 
            CONVERT(DATETIME, CONVERT(DATE,@vFIRSTDATE)) AND
            CONVERT(DATETIME,CONVERT(DATE,@vLASTDATE))
       GROUP BY FECHAARCHIVO
       ORDER BY FECHAARCHIVO ;

  END 
GO


