USE SFGPRODU;
--  DDL for Package Body SFGINF_ESPECIALDIARIO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_ESPECIALDIARIO */ 


  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ETBDiario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ETBDiario;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ETBDiario(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                      @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT RFR.FECHAHORATRANSACCION    AS "Fecha Hora Transaccion",
             RFR.VALORTRANSACCION        AS "Monto",
             PDV.CODIGOGTECHPUNTODEVENTA AS "POS",
             RFR.RECIBO              AS "Ref. Cliente",
             RFR.ESTADO                  AS "Estado"
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
       INNER JOIN WSXML_SFG.SERVICIO SRV
          ON (SRV.ID_SERVICIO = CTR.TIPOARCHIVO)
       INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
          ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
       INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA RFR
          ON (RFR.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
       INNER JOIN WSXML_SFG.PRODUCTO PRD
          ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
       INNER JOIN WSXML_SFG.PUNTODEVENTA PDV
          ON (PDV.ID_PUNTODEVENTA = REG.CODPUNTODEVENTA)
       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
       WHERE CTR.FECHAARCHIVO = convert(datetime, convert(date,@DIA))
         AND REG.CODTIPOREGISTRO = 1
         AND PRD.CODALIADOESTRATEGICO = 971
         AND TPR.CODLINEADENEGOCIO = 2
       ORDER BY CTR.FECHAARCHIVO, RFR.FECHAHORATRANSACCION;
  END;
GO

 
  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_EasyTaxyDiario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_EasyTaxyDiario;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_EasyTaxyDiario(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                      @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
       SELECT 'date','partnerID','point_of_saleID','batch','codeID'
       UNION ALL 
       SELECT  FORMAT(CTR.FECHAARCHIVO,'yyyy-MM-dd HH:mm:ss'),
               'GTECH'  AS "PARTNER ID",
               convert(varchar, PDV.CODIGOGTECHPUNTODEVENTA) AS "POINT OF SALE",
               '' AS "BATCH",
               convert(varchar, RFR.SUSCRIPTOR) AS "CODE ID"           
          FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
         INNER JOIN WSXML_SFG.SERVICIO SRV                    ON (SRV.ID_SERVICIO = CTR.TIPOARCHIVO)
         INNER JOIN WSXML_SFG.REGISTROFACTURACION REG         ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
         INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA RFR      ON (RFR.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
         INNER JOIN WSXML_SFG.PRODUCTO PRD                    ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
         INNER JOIN WSXML_SFG.PUNTODEVENTA PDV                ON (PDV.ID_PUNTODEVENTA = REG.CODPUNTODEVENTA)
         INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR                ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
         WHERE CTR.FECHAARCHIVO =  convert(datetime, convert(date,@DIA))
           AND REG.CODTIPOREGISTRO = 1
           AND PRD.CODALIADOESTRATEGICO = 1030
           AND TPR.CODLINEADENEGOCIO = 2;
         
     /* SELECT RFR.FECHAHORATRANSACCION    AS "Fecha Hora Transaccion",
             RFR.VALORTRANSACCION        AS "Monto",
             PDV.CODIGOGTECHPUNTODEVENTA AS "POS",
             RFR.SUSCRIPTOR              AS "Ref. Cliente",
             RFR.ESTADO                  AS "Estado"
        FROM ENTRADAARCHIVOCONTROL CTR
       INNER JOIN SERVICIO SRV
          ON (SRV.ID_SERVICIO = CTR.TIPOARCHIVO)
       INNER JOIN REGISTROFACTURACION REG
          ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
       INNER JOIN REGISTROFACTREFERENCIA RFR
          ON (RFR.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
       INNER JOIN PRODUCTO PRD
          ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
       INNER JOIN PUNTODEVENTA PDV
          ON (PDV.ID_PUNTODEVENTA = REG.CODPUNTODEVENTA)
       INNER JOIN TIPOPRODUCTO TPR
          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
       WHERE CTR.FECHAARCHIVO = trunc(DIA, 'DD')
         AND REG.CODTIPOREGISTRO = 1
         AND PRD.CODALIADOESTRATEGICO = 1030
         AND TPR.CODLINEADENEGOCIO = 2
       ORDER BY CTR.FECHAARCHIVO, RFR.FECHAHORATRANSACCION;*/
  END;
  GO
  

  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ATHDiario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ATHDiario;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ATHDiario(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                      @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ALIADOESTRATEGICO.NOMALIADOESTRATEGICO AS "Aliado Estrategico",
             producto.nomproducto AS "Producto",
             PUNTODEVENTA.NUMEROTERMINAL AS "Terminal",
             ENTRADAARCHIVOCONTROL.FECHAARCHIVO AS "Fecha Archivo",
             REGISTROFACTREFERENCIA.VALORTRANSACCION AS "Valor Transaccion",
             SUBSTRING(CIUDAD.CIUDADDANE, 3, 3) AS "Ciudad Dane",
             SUBSTRING(CIUDAD.CIUDADDANE, 1, 2) AS "Departamento Dane"
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
       INNER JOIN WSXML_SFG.REGISTROFACTURACION
          ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
             REGISTROFACTURACION.ID_REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN WSXML_SFG.PUNTODEVENTA
          ON REGISTROFACTURACION.CODPUNTODEVENTA =
             PUNTODEVENTA.ID_PUNTODEVENTA
       INNER JOIN WSXML_SFG.PRODUCTO
          ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       INNER JOIN WSXML_SFG.ALIADOESTRATEGICO
          ON PRODUCTO.CODALIADOESTRATEGICO =
             ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO
       INNER JOIN WSXML_SFG.CIUDAD
          ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = convert(datetime, convert(date,@DIA))
         AND REGISTROFACTURACION.CODTIPOREGISTRO = 1
         AND REGISTROFACTURACION.CODPRODUCTO IN
             (SELECT ID_PRODUCTO
                FROM WSXML_SFG.PRODUCTO P
               WHERE P.CODALIADOESTRATEGICO IN (918, 949));
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_LeonisaDiario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_LeonisaDiario;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_LeonisaDiario(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                         @DIA                      DATETIME
                          ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT REGISTROFACTREFERENCIA.SUSCRIPTOR AS Cedula,
             PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS CodigoPVTA,
             PUNTODEVENTA.NOMPUNTODEVENTA AS NombrePVTA,
             PUNTODEVENTA.DIRECCION AS Direccion1,
             CIUDAD.NOMCIUDAD AS NomCiudad,
             DEPARTAMENTO.NOMDEPARTAMENTO AS NomDepartamento,
             REGISTROFACTREFERENCIA.VALORTRANSACCION AS Monto,
             REGISTROFACTREFERENCIA.FECHAHORATRANSACCION AS Hora,
             WXML_SFG.DATEDIFF('dd',
                      CONVERT(DATETIME, '30/12/1999', 'DD/MM/YYYY'),
                      ENTRADAARCHIVOCONTROL.FECHAARCHIVO) AS CDC,
             PRODUCTO.CODIGOGTECHPRODUCTO AS IdProducto
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
       INNER JOIN REGISTROFACTURACION
          ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
             REGISTROFACTURACION.ID_REGISTROFACTURACION
       INNER JOIN ENTRADAARCHIVOCONTROL
          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN PUNTODEVENTA
          ON REGISTROFACTURACION.CODPUNTODEVENTA =
             PUNTODEVENTA.ID_PUNTODEVENTA
       INNER JOIN CIUDAD
          ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
       INNER JOIN DEPARTAMENTO
          ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
       INNER JOIN PRODUCTO
          ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = convert(datetime, convert(date,@DIA))
         AND REGISTROFACTURACION.CODPRODUCTO = 185
         AND REGISTROFACTURACION.CODTIPOREGISTRO = 1;
  END;
  GO

 IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ListadoArrnEfecty', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ListadoArrnEfecty;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ListadoArrnEfecty ( @ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                 @DIA                      DATETIME
                                  ) AS 
   BEGIN
   SET NOCOUNT ON;
        SELECT REGISTROFACTREFERENCIA.ARRN
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL 
        INNER JOIN PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        WHERE PRODUCTO.CODALIADOESTRATEGICO= 925
        AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA))
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1;
   END;
  GO
   
 IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTrxXAliadoRecepSusc', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTrxXAliadoRecepSusc;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTrxXAliadoRecepSusc ( @ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                        @DIA                      DATETIME,
                                       @ID_ALIADOESTRATEGICO     NUMERIC(22,0)
                                        ) AS 
   BEGIN
   SET NOCOUNT ON;
        SELECT ENTRADAARCHIVOCONTROL.FECHAARCHIVO,
               PRODUCTO.NOMPRODUCTO,
               REGISTROFACTREFERENCIA.RECIBO,
               REGISTROFACTREFERENCIA.SUSCRIPTOR,
               REGISTROFACTREFERENCIA.VALORTRANSACCION
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        WHERE PRODUCTO.CODALIADOESTRATEGICO = @ID_ALIADOESTRATEGICO AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA))
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1 ;
   END;
GO

   IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetTrxXAliadoRecepSuscCiudad', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetTrxXAliadoRecepSuscCiudad;
GO

CREATE       PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetTrxXAliadoRecepSuscCiudad ( @ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                        @DIA                      DATETIME,
                                       @ID_ALIADOESTRATEGICO     NUMERIC(22,0)
                                        ) AS 
   BEGIN
   SET NOCOUNT ON;
        SELECT ENTRADAARCHIVOCONTROL.FECHAARCHIVO AS Fecha,
               PRODUCTO.NOMPRODUCTO AS Producto,
               REGISTROFACTREFERENCIA.RECIBO AS Recibo,
               REGISTROFACTREFERENCIA.SUSCRIPTOR AS Suscriptor,
               REGISTROFACTREFERENCIA.VALORTRANSACCION as "Valor Transaccion",
               DEPARTAMENTO.NOMDEPARTAMENTO AS Departamento,               
               CIUDAD.NOMCIUDAD AS Ciudad,
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta"
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN PUNTODEVENTA        ON REGISTROFACTURACION.CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
        INNER JOIN ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN CIUDAD ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
        INNER JOIN DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
        WHERE PRODUCTO.CODALIADOESTRATEGICO = @ID_ALIADOESTRATEGICO AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA))
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1 ;
   END;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetTrxXProductoRecepSuscCiudad', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetTrxXProductoRecepSuscCiudad;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetTrxXProductoRecepSuscCiudad ( @ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                       @DIA                      DATETIME,
                                       @p_ID_PRODUCTO     NUMERIC(22,0))
AS
BEGIN
SET NOCOUNT ON;
  
        SELECT  REGISTROFACTREFERENCIA.FECHAHORATRANSACCION  AS "Fecha",
               PRODUCTO.NOMPRODUCTO as "Producto",
               REGISTROFACTREFERENCIA.RECIBO as "Recibo",
               REGISTROFACTREFERENCIA.SUSCRIPTOR as "Suscriptor",
               REGISTROFACTREFERENCIA.VALORTRANSACCION as "Valor Transaccion",
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Codigo PDV",
               CIUDAD.CIUDADDANE AS "Codigo Dane" ,            
               CIUDAD.NOMCIUDAD AS "Ciudad"
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN WSXML_SFG.PUNTODEVENTA ON REGISTROFACTURACION.CODPUNTODEVENTA= PUNTODEVENTA.ID_PUNTODEVENTA
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN WSXML_SFG.CIUDAD ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
        INNER JOIN WSXML_SFG.DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
        WHERE  ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA)) and PRODUCTO.ID_PRODUCTO = @p_ID_PRODUCTO
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1 ;
  END;   
GO
  
IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTransaccionesGiros', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTransaccionesGiros;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTransaccionesGiros(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                          @DIA                      DATETIME) 
AS
BEGIN
SET NOCOUNT ON;
          SELECT ENTRADAARCHIVOCONTROL.FECHAARCHIVO as "Fecha Archivo",
               REGISTROFACTREFERENCIA.FECHAHORATRANSACCION as "Fecha Hora Transaccion",
               REGISTROFACTREFERENCIA.ESTADO as "Estado",
               CASE WHEN PRODUCTO.CODTIPOPRODUCTO = 14 /*Giro retiro*/ THEN REGISTROFACTREFERENCIA.VALORTRANSACCION ELSE  REGISTROFACTREFERENCIA.VALORTRANSACCION - REGISTROFACTREFERENCIA.VRCOMISION END as " Valor",
               REGISTROFACTREFERENCIA.VRCOMISION as "Flete ",
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA as "Punto de venta",
               PRODUCTO.CODIGOGTECHPRODUCTO as "Codigo Producto",
               PRODUCTO.NOMPRODUCTO as "Nom Producto",
               round(REGISTROREVENUE.REVENUETOTAL / REGISTROFACTURACION.NUMTRANSACCIONES,4) as "Revenue",
               --REGEXP_SUBSTR(REGISTROFACTREFERENCIA.ARRN_GIRO_DEPOSITO, '[^,]+', 1, 1)  as "Factura"
			   SUBSTRING(REGISTROFACTREFERENCIA.ARRN_GIRO_DEPOSITO, 1, CHARINDEX(',', REGISTROFACTREFERENCIA.ARRN_GIRO_DEPOSITO ))  as "Factura"
          FROM WSXML_SFG.REGISTROFACTREFERENCIA
          INNER JOIN WSXML_SFG.REGISTROFACTURACION    ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
          INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL  ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
          INNER JOIN WSXML_SFG.PUNTODEVENTA           ON REGISTROFACTURACION.CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
          INNER JOIN WSXML_SFG.PRODUCTO               ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
          INNER JOIN WSXML_SFG.REGISTROREVENUE        ON REGISTROREVENUE.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
          WHERE PRODUCTO.CODTIPOPRODUCTO IN (14,15)
          AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA));
END;   
GO
                         

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_CedulasNuevasGiros', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_CedulasNuevasGiros;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_CedulasNuevasGiros(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                          @DIA                      DATETIME)
AS
BEGIN
SET NOCOUNT ON;
        select @DIA as fecha, tipo, count(distinct( cedula)) as Cantidad
        from
        (        
         select cedula, max(tipo) as tipo
          from 
          (
          select cedulaprincipal  as cedula,
                 usitipoarchivo.nombre as Tipo
          from WSXML_SFG.usiarchivodetalle 
          inner join WSXML_SFG.usiarchivo on usiarchivodetalle.codusiarchivo = usiarchivo.id_usiarchivo
          inner join WSXML_SFG.usitipoarchivo on usiarchivo.codusitipoarchivo = usitipoarchivo.id_usitipoarchivo
          where clasificada =1 and cedulaprincipal is not null and (usitipoarchivo.id_usitipoarchivo = 2/*Datacredito*/ or usiarchivodetalle.codusitipoarchivoclasificacion  in (1,2)/*Transacciones con biometria*/ )
          and usiarchivo.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA))
          union all 
          select cedulasecundaria,
                 usitipoarchivo.nombre as Tipo
          from WSXML_SFG.usiarchivodetalle
          inner join WSXML_SFG.usiarchivo on usiarchivodetalle.codusiarchivo = usiarchivo.id_usiarchivo
          inner join WSXML_SFG.usitipoarchivo on usiarchivo.codusitipoarchivo = usitipoarchivo.id_usitipoarchivo
          where clasificada =1 and cedulasecundaria is not null and (usitipoarchivo.id_usitipoarchivo = 2/*Datacredito*/ or usiarchivodetalle.codusitipoarchivoclasificacion  in (1,2)/*Transacciones con biometria*/ )
          and usiarchivo.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA))
          )data
          where not(cedula in (  select cedula 
                                  from 
                                  (
                                  select cedula from cedulasgirosiniciales  
                                  union all
                                  select cedulaprincipal  as cedula
                                  from WSXML_SFG.usiarchivodetalle 
                                  inner join WSXML_SFG.usiarchivo on usiarchivodetalle.codusiarchivo = usiarchivo.id_usiarchivo
                                  inner join WSXML_SFG.usitipoarchivo on usiarchivo.codusitipoarchivo = usitipoarchivo.id_usitipoarchivo
                                  where clasificada =1 and cedulaprincipal is not null and (usitipoarchivo.id_usitipoarchivo = 2/*Datacredito*/ or usiarchivodetalle.codusitipoarchivoclasificacion  in (1,2)/*Transacciones con biometria*/ )
                                  and usiarchivo.fechaarchivo < CONVERT(DATETIME, CONVERT(DATE,@DIA))
                                  union all 
                                  select cedulasecundaria 
                                  from WSXML_SFG.usiarchivodetalle
                                  inner join WSXML_SFG.usiarchivo on usiarchivodetalle.codusiarchivo = usiarchivo.id_usiarchivo
                                  inner join WSXML_SFG.usitipoarchivo on usiarchivo.codusitipoarchivo = usitipoarchivo.id_usitipoarchivo                                  
                                  where clasificada =1 and cedulasecundaria is not null and (usitipoarchivo.id_usitipoarchivo = 2/*Datacredito*/ or usiarchivodetalle.codusitipoarchivoclasificacion  in (1,2)/*Transacciones con biometria*/ )
                                  and usiarchivo.fechaarchivo < CONVERT(DATETIME, CONVERT(DATE,@DIA))
                                  ) data
                                  group by cedula
                                ))
          group by cedula
          )data
          group by tipo;
END;  

GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesCarvajal', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesCarvajal;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesCarvajal(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                          @DIA                      DATETIME)
AS
BEGIN
SET NOCOUNT ON;
               SELECT USIARCHIVODETALLE.NUMEROTRANSACCIONUSI as "Id Unico Transacion", 
                 USIARCHIVODETALLE.ARRN_SERIAL as "ARRN",
                 USIARCHIVODETALLE.CODIGOGTECHPRODUCTO as "Codigo Producto",
                 USIARCHIVODETALLE.PROCESSINGCODE as "Codigo Transaccion",
                 USIARCHIVO.FECHAARCHIVO as "Fecha tx",
                 FORMAT(USIARCHIVODETALLE.FECHAHORATRANSACCION,'HH:mm:ss') as "Hora Transaccion",
                 USIARCHIVODETALLE.CODIGOGTECHPUNTODEVENTA AS "PDV",
                 USIARCHIVODETALLE.NUMEROTERMINAL as "Terminal",
                 USIARCHIVODETALLE.ANSWERCODE as "Codigo Respuesta",
                 USIARCHIVODETALLE.CEDULAPRINCIPAL as "Cedula Colocador Giro",
                 USIARCHIVODETALLE.CEDULASECUNDARIA as "Cedula Beneficiario",
                 '' AS "Numero autorizacio biometrico",
                 0 as "Numero ARRN Giro Financiero"
          FROM WSXML_SFG.USIARCHIVODETALLE
          INNER JOIN WSXML_SFG.USIARCHIVO ON USIARCHIVODETALLE.CODUSIARCHIVO = USIARCHIVO.ID_USIARCHIVO
          WHERE USIARCHIVO.CODUSITIPOARCHIVO = 1
          AND USIARCHIVO.FECHAARCHIVO =  CONVERT(DATETIME, CONVERT(DATE,@DIA));
END;                              
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesDataCredito', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesDataCredito;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesDataCredito(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                          @DIA                      DATETIME)
AS
BEGIN
SET NOCOUNT ON;
                 SELECT USIARCHIVODETALLE.ARRN_SERIAL as "ARRN",
                   USIARCHIVODETALLE.CODIGOGTECHPRODUCTO as "Codigo Producto",
                   USIARCHIVO.FECHAARCHIVO as "Fecha tx",
                   FORMAT(USIARCHIVODETALLE.FECHAHORATRANSACCION,'HH:mm:ss') as "Hora Transaccion",
                   USIARCHIVODETALLE.CODIGOGTECHPUNTODEVENTA AS "PDV",
                   USIARCHIVODETALLE.NUMEROTERMINAL as "Terminal",
                   USIARCHIVODETALLE.ANSWERCODE as "Codigo Respuesta",
                   USIARCHIVODETALLE.CEDULAPRINCIPAL as "Cedula Consultada"
            FROM WSXML_SFG.USIARCHIVODETALLE
            INNER JOIN WSXML_SFG.USIARCHIVO ON USIARCHIVODETALLE.CODUSIARCHIVO = USIARCHIVO.ID_USIARCHIVO
            WHERE USIARCHIVO.CODUSITIPOARCHIVO = 2
            AND USIARCHIVO.FECHAARCHIVO =  CONVERT(DATETIME, CONVERT(DATE,@DIA));


END;         
GO
      
IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesCLUBSOCIAL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesCLUBSOCIAL;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_TransaccionesCLUBSOCIAL(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                          @DIA                      DATETIME)
AS
BEGIN
SET NOCOUNT ON;
                SELECT entradaarchivocontrol.fechaarchivo AS "Fecha" ,
                       producto.nomproducto as "Producto", 
                       registrofactreferencia.recibo as "Recibo",
                       registrofactreferencia.suscriptor as "Suscriptor",
                       registrofactreferencia.valortransaccion as "Valor Transaccion", 
                       departamento.nomdepartamento as "Departamento",
                       ciudad.nomciudad  as "Ciudad", 
                       puntodeventa.codigogtechpuntodeventa as "Punto de venta"
                FROM WSXML_SFG.REGISTROFACTREFERENCIA 
                INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
                INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                INNER JOIN WSXML_SFG.PUNTODEVENTA ON REGISTROFACTURACION.CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
                INNER JOIN WSXML_SFG.CIUDAD ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
                INNER JOIN WSXML_SFG.DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
                INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO 
                WHERE REGISTROFACTURACION.CODPRODUCTO IN (1216,269,1483)
                AND  ENTRADAARCHIVOCONTROL.FECHAARCHIVO =CONVERT(DATETIME, CONVERT(DATE,@DIA));
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteGelsaBaloto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteGelsaBaloto;
GO

CREATE PROCEDURE  WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteGelsaBaloto (@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME)         
AS
BEGIN
SET NOCOUNT ON;
        SELECT '01' AS DEFAULT0, 
             pdv.codigogtechpuntodeventa, 
             pdv.numeroterminal,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_TX_BALOTO,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_VENTA_BALOTO,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_ANULACIONES_BALOTO,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_ANULACIONES_BALOTO,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_PAGO_PREMIOS_BALOTO,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_PREMIOS_BALOTO,
             '0' AS DEFAULT1,
             '0' AS DEFAULT2,
             '0' AS DEFAULT3,
             '0' AS DEFAULT4,
             '0' AS DEFAULT5       
      FROM WSXML_SFG.PUNTODEVENTA PDV
      left outer join 
      (      
      select registrofacturacion.id_registrofacturacion,
             registrofacturacion.numtransacciones, 
             registrofacturacion.valortransaccion,
             registrofacturacion.codtiporegistro,
             registrofacturacion.codpuntodeventa 
      from WSXML_SFG.registrofacturacion 
      inner join WSXML_SFG.entradaarchivocontrol on registrofacturacion.codentradaarchivocontrol = entradaarchivocontrol.id_entradaarchivocontrol
      where entradaarchivocontrol.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA))  
      AND REGISTROFACTURACION.CODPRODUCTO IN (155,1741)
      )RF on pdv.id_puntodeventa = RF.codpuntodeventa
      WHERE PDV.codagrupacionpuntodeventa in (1187,955) AND PDV.ACTIVE=1 
      GROUP BY  pdv.codigogtechpuntodeventa, pdv.numeroterminal
      ORDER BY 2;
     

END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActCruz', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActCruz;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActCruz (@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME)        
AS
BEGIN
SET NOCOUNT ON;
        SELECT '24' AS DEFAULT0, 
             pdv.codigogtechpuntodeventa, 
             pdv.numeroterminal,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_TX,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_VENTA,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_ANULACIONES,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_ANULACIONES,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_PAGO_PREMIOS,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_PREMIOS,
             '0' AS DEFAULT1,
             '0' AS DEFAULT2,
             '0' AS DEFAULT3,
             '0' AS DEFAULT4       
      FROM WSXML_SFG.PUNTODEVENTA PDV
      left outer join 
      (      
      select registrofacturacion.id_registrofacturacion,
             registrofacturacion.numtransacciones, 
             registrofacturacion.valortransaccion,
             registrofacturacion.codtiporegistro,
             registrofacturacion.codpuntodeventa 
      from WSXML_SFG.registrofacturacion 
      inner join  WSXML_SFG.entradaarchivocontrol on registrofacturacion.codentradaarchivocontrol = entradaarchivocontrol.id_entradaarchivocontrol
      where entradaarchivocontrol.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA))  
      AND REGISTROFACTURACION.CODPRODUCTO IN (2725)
      )RF on pdv.id_puntodeventa = RF.codpuntodeventa
      WHERE PDV.codagrupacionpuntodeventa in (1187,955) AND PDV.ACTIVE=1 
      GROUP BY  pdv.codigogtechpuntodeventa, pdv.numeroterminal
      ORDER BY 2;

     

END;

GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActHuila', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActHuila;
GO

CREATE PROCEDURE  WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActHuila (@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME)         
AS
BEGIN
SET NOCOUNT ON;
        SELECT '21' AS DEFAULT0, 
             pdv.codigogtechpuntodeventa, 
             pdv.numeroterminal,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_TX,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_VENTA,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_ANULACIONES,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_ANULACIONES,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_PAGO_PREMIOS,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_PREMIOS,
             '0' AS DEFAULT1,
             '0' AS DEFAULT2,
             '0' AS DEFAULT3,
             '0' AS DEFAULT4      
      FROM WSXML_SFG.PUNTODEVENTA PDV
      left outer join 
      (      
      select registrofacturacion.id_registrofacturacion,
             registrofacturacion.numtransacciones, 
             registrofacturacion.valortransaccion,
             registrofacturacion.codtiporegistro,
             registrofacturacion.codpuntodeventa 
      from WSXML_SFG.registrofacturacion 
      inner join  WSXML_SFG.entradaarchivocontrol on registrofacturacion.codentradaarchivocontrol = entradaarchivocontrol.id_entradaarchivocontrol
      where entradaarchivocontrol.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA))  
      AND REGISTROFACTURACION.CODPRODUCTO IN (2625)
      )RF on pdv.id_puntodeventa = RF.codpuntodeventa
      WHERE PDV.codagrupacionpuntodeventa in (1187,955) AND PDV.ACTIVE=1 
      GROUP BY  pdv.codigogtechpuntodeventa, pdv.numeroterminal
      ORDER BY 2;

     

END;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActExtra', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActExtra;
GO

CREATE PROCEDURE  WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteAgtActExtra (@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME)         
AS
BEGIN
SET NOCOUNT ON;
        SELECT '25' AS DEFAULT0, 
             pdv.codigogtechpuntodeventa, 
             pdv.numeroterminal,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_TX,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (1) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_VENTA,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_ANULACIONES,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (2) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_ANULACIONES,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.NUMTRANSACCIONES,0) END),0) AS CANT_PAGO_PREMIOS,
             ISNULL(SUM(CASE WHEN  RF.CODTIPOREGISTRO IN (4) THEN ISNULL(RF.VALORTRANSACCION,0) END),0) AS VALOR_MONTO_PREMIOS,
             '0' AS DEFAULT1,
             '0' AS DEFAULT2,
             '0' AS DEFAULT3,
             '0' AS DEFAULT4       
      FROM WSXML_SFG.PUNTODEVENTA PDV
      left outer join 
      (      
      select registrofacturacion.id_registrofacturacion,
             registrofacturacion.numtransacciones, 
             registrofacturacion.valortransaccion,
             registrofacturacion.codtiporegistro,
             registrofacturacion.codpuntodeventa 
      from WSXML_SFG.registrofacturacion 
      inner join  WSXML_SFG.entradaarchivocontrol on registrofacturacion.codentradaarchivocontrol = entradaarchivocontrol.id_entradaarchivocontrol
      where entradaarchivocontrol.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA))  
      AND REGISTROFACTURACION.CODPRODUCTO IN (2626)
      )RF on pdv.id_puntodeventa = RF.codpuntodeventa
      WHERE PDV.codagrupacionpuntodeventa in (1187,955) AND PDV.ACTIVE=1 
      GROUP BY  pdv.codigogtechpuntodeventa, pdv.numeroterminal
      ORDER BY 2;

END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteConciliacionIGTEmCali', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteConciliacionIGTEmCali;
GO

CREATE PROCEDURE  WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteConciliacionIGTEmCali (@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME) 
AS
BEGIN
SET NOCOUNT ON;
     select 
     '01' + '' + ISNULL(dbo.lpad_varchar2(rfr.suscriptor,12,'0'), '') + '' + '000' 
     from WSXML_SFG.registrofactreferencia rfr
     inner join WSXML_SFG.registrofacturacion rf on rfr.codregistrofacturacion = rf.id_registrofacturacion
     inner join WSXML_SFG.entradaarchivocontrol eac on rf.codentradaarchivocontrol = eac.id_entradaarchivocontrol
     inner join WSXML_SFG.producto p on rf.codproducto= p.id_producto 
     inner join WSXML_SFG.aliadoestrategico ae on p.codaliadoestrategico= ae.id_aliadoestrategico
     where eac.fechaarchivo =CONVERT(DATETIME, CONVERT(DATE,@DIA)) 
     and ae.id_aliadoestrategico=1050
     and rfr.estado='A'
     --and
     union 
     select 
     '02' + '' + ISNULL(dbo.lpad_varchar2(rfr.suscriptor,12,'0'), '') + '' + ISNULL(dbo.lpad_varchar2(rfr.recibo,13,'0'), '') + '' + ISNULL(dbo.lpad_varchar2(CONVERT(VARCHAR,rfr.valortransaccion),13,'0'), '') + '' + '000' + '' + ISNULL(dbo.lpad_varchar2(CONVERT(VARCHAR,pdv.codigogtechpuntodeventa),7,'0'), '')
     + '' + ISNULL(FORMAT(rfr.fechahoratransaccion,'MMddyyyy'), '') + '' + ISNULL(FORMAT(rfr.fechahoratransaccion,'HH24mmss'), '') as "Registros"
     from WSXML_SFG.registrofactreferencia rfr
     inner join WSXML_SFG.registrofacturacion rf on rfr.codregistrofacturacion = rf.id_registrofacturacion
     inner join WSXML_SFG.entradaarchivocontrol eac on rf.codentradaarchivocontrol = eac.id_entradaarchivocontrol
     inner join WSXML_SFG.producto p on rf.codproducto= p.id_producto 
     inner join WSXML_SFG.aliadoestrategico ae on p.codaliadoestrategico= ae.id_aliadoestrategico
     inner join WSXML_SFG.puntodeventa pdv  on rf.codpuntodeventa = pdv.id_puntodeventa
     where eac.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA)) 
     and ae.id_aliadoestrategico=1050
     and rfr.estado='A'
     union
     select
     '01' + '' + ISNULL(dbo.lpad_varchar2(rfr.suscriptor,12,'0'), '') + '' + '000' 
     from WSXML_SFG.registrofactreferencia rfr
     inner join WSXML_SFG.registrofacturacion rf on rfr.codregistrofacturacion = rf.id_registrofacturacion
     inner join WSXML_SFG.entradaarchivocontrol eac on rf.codentradaarchivocontrol = eac.id_entradaarchivocontrol
     inner join WSXML_SFG.producto p on rf.codproducto= p.id_producto 
     inner join WSXML_SFG.aliadoestrategico ae on p.codaliadoestrategico= ae.id_aliadoestrategico
     where eac.fechaarchivo =CONVERT(DATETIME, CONVERT(DATE,@DIA)) 
     and ae.id_aliadoestrategico=1050
     and rfr.estado='A'
     --and;

END;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteConciliacionIGTVirgin', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteConciliacionIGTVirgin;
GO

CREATE PROCEDURE  WSXML_SFG.SFGINF_ESPECIALDIARIO_ReporteConciliacionIGTVirgin (@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME)
                          
AS
BEGIN
SET NOCOUNT ON;
     select isnull(FORMAT(rfr.fechahoratransaccion,'yyyy-MM-dd HH:mm:ss'), '') + ',16,GTECH,57' + isnull(rfr.suscriptor, '') + ',' + isnull(rfr.recibo, '') + ',0,'  + isnull(CONVERT(VARCHAR,rfr.valortransaccion), '') + ',' + isnull(rfr.estado, '') + ',' as ITEM
     from WSXML_SFG.registrofactreferencia rfr
     inner join WSXML_SFG.registrofacturacion rf on rfr.codregistrofacturacion = rf.id_registrofacturacion
     inner join WSXML_SFG.entradaarchivocontrol eac on rf.codentradaarchivocontrol = eac.id_entradaarchivocontrol
     inner join WSXML_SFG.producto p on rf.codproducto= p.id_producto 
     inner join WSXML_SFG.aliadoestrategico ae on p.codaliadoestrategico= ae.id_aliadoestrategico
     where eac.fechaarchivo = CONVERT(DATETIME, CONVERT(DATE,@DIA)) 
     and ae.id_aliadoestrategico=915
     and rfr.estado='A';

END;      
GO              

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTxDiarioxproductociudad', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTxDiarioxproductociudad;
go

create PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTxDiarioxproductociudad(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                 @DIA                      DATETIME,
                                 @p_ID_PRODUCTO            NUMERIC(22,0)) as
begin
set nocount on;
   SELECT     CIUDAD.NOMCIUDAD AS "Ciudad",
              departamento.nomdepartamento as "Departamento",
              REGISTROFACTREFERENCIA.FECHAHORATRANSACCION  AS "Fecha y hora de la donacion",
              REGISTROFACTREFERENCIA.SUSCRIPTOR as "Documento de identificacion", 
              convert(varchar, REGISTROFACTREFERENCIA.NUMEROREFERENCIA) as "Codigo de transaccion", 
              REGISTROFACTREFERENCIA.VALORTRANSACCION as "Monto",
              PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta"
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN WSXML_SFG.PUNTODEVENTA ON REGISTROFACTURACION.CODPUNTODEVENTA= PUNTODEVENTA.ID_PUNTODEVENTA
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN WSXML_SFG.CIUDAD ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
        INNER JOIN WSXML_SFG.DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
        WHERE  ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA)) and PRODUCTO.ID_PRODUCTO = @p_ID_PRODUCTO
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1;            
end;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ConsolidadofinalTeleton', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ConsolidadofinalTeleton;
go

create PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ConsolidadofinalTeleton(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                 @DIA                      DATETIME,
                                 @p_ID_PRODUCTO            NUMERIC(22,0)) as
begin
set nocount on;
   SELECT     CIUDAD.NOMCIUDAD AS "Ciudad",
              departamento.nomdepartamento as "Departamento",
              REGISTROFACTREFERENCIA.FECHAHORATRANSACCION  AS "Fecha y hora de la donacion",
              REGISTROFACTREFERENCIA.SUSCRIPTOR as "Documento de identificacion", 
              convert(varchar, REGISTROFACTREFERENCIA.NUMEROREFERENCIA) as "Codigo de transaccion", 
              REGISTROFACTREFERENCIA.VALORTRANSACCION as "Monto",
              PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta"
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN WSXML_SFG.PUNTODEVENTA ON REGISTROFACTURACION.CODPUNTODEVENTA= PUNTODEVENTA.ID_PUNTODEVENTA
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN WSXML_SFG.CIUDAD ON REGISTROFACTURACION.CODCIUDAD = CIUDAD.ID_CIUDAD
        INNER JOIN WSXML_SFG.DEPARTAMENTO ON CIUDAD.CODDEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
        WHERE  ENTRADAARCHIVOCONTROL.FECHAARCHIVO > CONVERT(DATETIME,'01/feb/2017',103) and PRODUCTO.ID_PRODUCTO = @p_ID_PRODUCTO
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1;            
end;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_ConsolidadoTxLogueoTerminales', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ConsolidadoTxLogueoTerminales;
go

create PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_ConsolidadoTxLogueoTerminales(@ID_DETALLETAREAEJEUTADA NUMERIC(22,0), 
                                      @DIA DATETIME)
  as 
  begin
  set nocount on;
       select fechaarchivo  as "Fecha Archivo", codigogtechpuntodeventa as "Numero PDV",
        nompuntodeventa as "Nombre PDV", suscriptor as "Numero Cedula", horas as "Horas", minutos as "Minutos", 
        totalminutos as "Total minutos", sum(numerotransacciones) as "Numero Transacciones", 
        sum(montoventa) as "Monto Venta" , nomregional as "Regional", ciudad as "Ciudad"
        from ( SELECT distinct reg.codpuntodeventa,  convert(varchar, e.fechaarchivo) as fechaarchivo, p.codigogtechpuntodeventa ,
         p.nompuntodeventa,
        rfr.suscriptor, 
        cast(round(WSXML_SFG.datediff('mi',max(rfr.fechahoratransaccion), min(rfr.fechahoratransaccion)) /60 ,0) as integer)*-1 as horas,
        case when 
        round((cast(round(WSXML_SFG.datediff('mi',min(rfr.fechahoratransaccion), max(rfr.fechahoratransaccion)) /60 ,3) as float) -
        cast(round(WSXML_SFG.datediff('mi',min(rfr.fechahoratransaccion), max(rfr.fechahoratransaccion)) /60 ,0) as float)) * 60, 0) < 0 then 
        round((cast(round(WSXML_SFG.datediff('mi',min(rfr.fechahoratransaccion), max(rfr.fechahoratransaccion)) /60 ,3) as float) -
        cast(round(WSXML_SFG.datediff('mi',min(rfr.fechahoratransaccion), max(rfr.fechahoratransaccion)) /60 ,0) as float)) * 60, 0)*-1
        else round((cast(round(WSXML_SFG.datediff('mi',min(rfr.fechahoratransaccion), max(rfr.fechahoratransaccion)) /60 ,3) as float) -
        cast(round(WSXML_SFG.datediff('mi',min(rfr.fechahoratransaccion), max(rfr.fechahoratransaccion)) /60 ,0) as float)) * 60, 0) end as minutos,
        cast(round(WSXML_SFG.datediff('mi',max(rfr.fechahoratransaccion), min(rfr.fechahoratransaccion)) ,0) as integer) * -1 as totalminutos,
        isnull(case when reg.codpuntodeventa = rf.codpuntodeventa --and rfr.suscriptor = reg.suscriptor
          then  sum(reg.totaltx)  end, 0) as numerotransacciones, 
         isnull(case when reg.codpuntodeventa = rf.codpuntodeventa  
            then  isnull(sum(reg.totalventas), 0) end, 0)  as Montoventa,
        r.nomregional , 
        (case when min(CONVERT(VARCHAR(8), rfr.fechahoratransaccion,108)) = min(CONVERT(VARCHAR(8), rfr.fechahoratransaccion,108)) 
        then c.nomciudad end) as ciudad 
        FROM WSXML_SFG.REGISTROFACTREFERENCIA rfr
        inner join WSXML_SFG.registrofacturacion rf on rf.id_registrofacturacion = rfr.codregistrofacturacion
        inner join WSXML_SFG.entradaarchivocontrol e on rf.codentradaarchivocontrol = e.id_entradaarchivocontrol 
        inner join WSXML_SFG.puntodeventa p on p.id_puntodeventa = rf.codpuntodeventa
        inner join WSXML_SFG.regional r on r.id_regional = p.codregional 
        inner join WSXML_SFG.ciudad c on c.id_ciudad = p.codciudad
        left outer join (select case when codtiporegistro in (1,3) then sum(regf.numtransacciones) else 0 end as totaltx, 
             case when codtiporegistro in (1,3) then sum(regf.valortransaccion) else 0 end as totalventas, 
             regf.codentradaarchivocontrol, regf.codpuntodeventa, rfr.fechahoratransaccion, rfr.suscriptor
             from WSXML_SFG.registrofacturacion regf 
             inner join WSXML_SFG.entradaarchivocontrol ent on ent.id_entradaarchivocontrol = regf.codentradaarchivocontrol
             inner join WSXML_SFG.registrofactreferencia rfr on rfr.codregistrofacturacion = regf.id_registrofacturacion
             where ent.fechaarchivo = convert(datetime, convert(date,@DIA)) and regf.codproducto <> 3249
             group by regf.codentradaarchivocontrol, regf.codtiporegistro,regf.codciudad, regf.codpuntodeventa, 
             rfr.fechahoratransaccion, rfr.suscriptor
            ) reg on reg.codpuntodeventa = rf.codpuntodeventa
        where fechaarchivo = convert(datetime, convert(date,@DIA)) and rf.codproducto = 3249
        group by e.fechaarchivo, rf.codpuntodeventa,p.codigogtechpuntodeventa,
         r.nomregional, rfr.suscriptor, c.nomciudad, p.nompuntodeventa,  reg.codpuntodeventa, 
         reg.suscriptor
         ) T
         group by codpuntodeventa, fechaarchivo, codigogtechpuntodeventa,
          nompuntodeventa, suscriptor, horas, totalminutos, nomregional, ciudad, minutos
          order by 2;
end;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTxLogueoTerminales', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTxLogueoTerminales;
go

create PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalleTxLogueoTerminales(@ID_DETALLETAREAEJEUTADA NUMERIC(22,0), 
                                  @DIA DATETIME)

AS
BEGIN
SET NOCOUNT ON;
         SELECT e.fechaarchivo as "Fecha Archivo", p.codigogtechpuntodeventa as "Numero PDV", 
         p.nompuntodeventa as "Nombre PDV",
        CONVERT(VARCHAR(8), rfr.fechahoratransaccion,108) as hora, rfr.suscriptor as "Numero Cedula", 
        r.nomregional as Regional, 
        c.nomciudad as Ciudad 
        FROM WSXML_SFG.REGISTROFACTREFERENCIA rfr
        inner join WSXML_SFG.registrofacturacion rf on rf.id_registrofacturacion = rfr.codregistrofacturacion
        inner join WSXML_SFG.entradaarchivocontrol e on rf.codentradaarchivocontrol = e.id_entradaarchivocontrol 
        inner join WSXML_SFG.puntodeventa p on p.id_puntodeventa = rf.codpuntodeventa
        inner join WSXML_SFG.regional r on r.id_regional = p.codregional 
        inner join WSXML_SFG.ciudad c on c.id_ciudad = p.codciudad
        where fechaarchivo = convert(datetime, convert(date,@DIA)) AND rf.codproducto = 3249
        order by p.codigogtechpuntodeventa, rfr.fechahoratransaccion;
        
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalletxSerialporaliado', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalletxSerialporaliado;
go

create PROCEDURE WSXML_SFG.SFGINF_ESPECIALDIARIO_DetalletxSerialporaliado(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                   @DIA                      DATETIME,
                                   @ID_ALIADOESTRATEGICO     NUMERIC(22,0)) AS 
                                        
          BEGIN
          SET NOCOUNT ON;
        SELECT FORMAT(CONVERT(DATE,registrofactreferencia.fechahoratransaccion), 'dd/MM/yyyy') AS Fecha,
               FORMAT(registrofactreferencia.fechahoratransaccion,'HH:mm') as Hora,
               PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS "Punto de Venta",
               REGISTROFACTREFERENCIA.Suscriptor as "Serial de PIN",
               REGISTROFACTREFERENCIA.VALORTRANSACCION as Valor, 
               CIUDAD.NOMCIUDAD AS Ciudad
        FROM WSXML_SFG.REGISTROFACTREFERENCIA
        INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION 
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
        INNER JOIN WSXML_SFG.PUNTODEVENTA ON PUNTODEVENTA.ID_PUNTODEVENTA = REGISTROFACTURACION.CODPUNTODEVENTA
        INNER JOIN WSXML_SFG.CIUDAD ON CIUDAD.ID_CIUDAD = REGISTROFACTURACION.CODCIUDAD
        WHERE PRODUCTO.CODALIADOESTRATEGICO = @ID_ALIADOESTRATEGICO 
        AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA))
        AND REGISTROFACTURACION.CODTIPOREGISTRO = 1 ;                               
                                                                            
end;
GO
