USE SFGPRODU;
--  DDL for Package Body SFGVENTASCADENAXRANGO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGVENTASCADENAXRANGO */ 

  IF OBJECT_ID('WSXML_SFG.SFGVENTASCADENAXRANGO_VentasCadenaXRango', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGVENTASCADENAXRANGO_VentasCadenaXRango;
GO

CREATE     PROCEDURE WSXML_SFG.SFGVENTASCADENAXRANGO_VentasCadenaXRango(@p_FECHAINICIO           DATETIME,
                               @p_FECHAFIN              DATETIME,
                               @p_CODIGOAGRUPACIONGTECH NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT
             PUNTODEVENTA.ID_PUNTODEVENTA                                                            AS ID_POS,
             LINEADENEGOCIO.ID_LINEADENEGOCIO                                                        AS ID_LineaDeNegocio,
             FORMAT(ENTRADAARCHIVOCONTROL.FECHAARCHIVO,'dd-MM-yyyy')                                AS Fecha,
             SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.NUMTRANSACCIONES ELSE 0 END) AS NumeroTransacciones,
             SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END) AS Ventas,
             SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA  ELSE 0 END) AS VentasSinIva,
             SUM(CASE WHEN CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.NUMTRANSACCIONES ELSE 0 END) AS NumeroAnulaciones,
             SUM(CASE WHEN CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END) AS Anulaciones,
             SUM(CASE WHEN CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.NUMTRANSACCIONES ELSE 0 END) AS NumeroPremiosPagados,
             SUM(CASE WHEN CODTIPOREGISTRO = 4 THEN REGISTROFACTURACION.VALORTRANSACCION ELSE 0 END) AS PremiosPagados
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
      INNER JOIN WSXML_SFG.REGISTROFACTURACION    ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
      INNER JOIN WSXML_SFG.PRODUCTO               ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
      INNER JOIN WSXML_SFG.TIPOPRODUCTO           ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
      INNER JOIN WSXML_SFG.LINEADENEGOCIO         ON TIPOPRODUCTO.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
      INNER JOIN WSXML_SFG.PUNTODEVENTA           ON REGISTROFACTURACION.CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
      INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
      WHERE ENTRADAARCHIVOCONTROL.REVERSADO = 0 AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINICIO)) AND CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFIN))
        AND AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH = @p_CODIGOAGRUPACIONGTECH
      GROUP BY PUNTODEVENTA.ID_PUNTODEVENTA ,
               LINEADENEGOCIO.ID_LINEADENEGOCIO,
               ENTRADAARCHIVOCONTROL.FECHAARCHIVO;

END 
GO


