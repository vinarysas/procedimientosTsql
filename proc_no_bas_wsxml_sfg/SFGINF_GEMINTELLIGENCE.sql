USE SFGPRODU;
--  DDL for Package Body SFGINF_GEMINTELLIGENCE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_GEMINTELLIGENCE */ 
  IF OBJECT_ID('WSXML_SFG.SFGINF_GEMINTELLIGENCE_DetalleTransacciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_DetalleTransacciones;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_DetalleTransacciones(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                                @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;


      SELECT PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS RetailerNumber,
             CONVERT(VARCHAR(10), ENTRADAARCHIVOCONTROL.FECHAARCHIVO, 120) AS DateReport,
             PRODUCTO.CODIGOGTECHPRODUCTO AS ProductCode,
             SUM(CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   ELSE
                    0
                 END - CASE
                   WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN
                    REGISTROFACTURACION.NUMTRANSACCIONES
                   ELSE
                    0
                 END) AS SalesCount,
             SUM(CASE
                           WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                            REGISTROFACTURACION.Valortransaccion
                           ELSE
                            0
                         END - CASE
                           WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN
                            REGISTROFACTURACION.Valortransaccion
                           ELSE
                            0
                         END) AS SalesAmount

        FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN WSXML_SFG.PRODUCTO
          ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       INNER JOIN WSXML_SFG.PUNTODEVENTA
          ON REGISTROFACTURACION.CODPUNTODEVENTA =
             PUNTODEVENTA.ID_PUNTODEVENTA
       INNER JOIN WSXML_SFG.REGIONAL ON PUNTODEVENTA.CODREGIONAL = REGIONAL.ID_REGIONAL
       INNER JOIN WSXML_SFG.RAZONSOCIAL ON PUNTODEVENTA.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@DIA))
         AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
         AND NOT(REGIONAL.ID_REGIONAL IN (42 /* GTECH*/ ,49 /*VENTAS ESP*/))
         AND NOT(RAZONSOCIAL.IDENTIFICACION ='830111257') /*AEL*/
       GROUP BY PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA,
                 CONVERT(VARCHAR(10), ENTRADAARCHIVOCONTROL.FECHAARCHIVO, 120),
                PRODUCTO.CODIGOGTECHPRODUCTO;

  END;

  GO
  IF OBJECT_ID('WSXML_SFG.SFGINF_GEMINTELLIGENCE_Productos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_Productos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_Productos(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                     @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PRODUCTO.CODIGOGTECHPRODUCTO AS PRODUCT_CODE,
             PRODUCTO.NOMPRODUCTO AS PRODUCT_NAME,
             CASE
               WHEN LINEADENEGOCIO.ID_LINEADENEGOCIO IN (1, 2, 3, 4) THEN
                CASE
                  WHEN PRODUCTO.CODIGOGTECHPRODUCTO IN
                       (630, 631, 634, 690, 56, 57, 58) THEN
                   5 /*GIROS*/
                  ELSE
                   LINEADENEGOCIO.ID_LINEADENEGOCIO
                END
               WHEN LINEADENEGOCIO.ID_LINEADENEGOCIO IN (5) THEN
                6
             END AS CATEGORY_CODE,
             CASE
               WHEN PRODUCTO.CODIGOGTECHPRODUCTO IN
                    (630, 631, 634, 690, 56, 57, 58) THEN
                15
               ELSE
                TIPOPRODUCTO.ID_TIPOPRODUCTO
             END AS SUBCATEGORY_CODE,
             ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO AS VENDOR_CODE
        FROM WSXML_SFG.PRODUCTO
       INNER JOIN WSXML_SFG.TIPOPRODUCTO
          ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
       INNER JOIN WSXML_SFG.LINEADENEGOCIO
          ON TIPOPRODUCTO.CODLINEADENEGOCIO =
             LINEADENEGOCIO.ID_LINEADENEGOCIO
       INNER JOIN WSXML_SFG.ALIADOESTRATEGICO
          ON PRODUCTO.CODALIADOESTRATEGICO =
             ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO
       WHERE PRODUCTO.ACTIVE = 1;

  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_GEMINTELLIGENCE_AliadosEstrategicos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_AliadosEstrategicos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_AliadosEstrategicos(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO,
             ALIADOESTRATEGICO.NOMALIADOESTRATEGICO
        FROM WSXML_SFG.ALIADOESTRATEGICO;
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_GEMINTELLIGENCE_TiposDeProductos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_TiposDeProductos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_GEMINTELLIGENCE_TiposDeProductos(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                            @DIA                      DATETIME) AS
  BEGIN
  SET NOCOUNT ON;
        SELECT TIPOPRODUCTO.ID_TIPOPRODUCTO AS ProductSubCategoryCode,
              TIPOPRODUCTO.NOMTIPOPRODUCTO AS ProductSubCategoryName,
              convert(varchar,  ISNULL(TIPOPRODUCTO.NOMCORTOTIPOPRODUCTO,
                   TIPOPRODUCTO.NOMTIPOPRODUCTO)) AS ProductSubCategoryDescription,
                   CASE
                 WHEN LINEADENEGOCIO.ID_LINEADENEGOCIO IN (1, 2, 3, 4) THEN
                  LINEADENEGOCIO.ID_LINEADENEGOCIO
                 WHEN LINEADENEGOCIO.ID_LINEADENEGOCIO IN (5) THEN
                  6
               END AS CATEGORY_CODE
          FROM WSXML_SFG.TIPOPRODUCTO
          INNER JOIN WSXML_SFG.LINEADENEGOCIO ON TIPOPRODUCTO.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
          UNION ALL
          SELECT 15,'Giros','Giros',5;
  END;
GO


