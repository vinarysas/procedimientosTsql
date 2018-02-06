USE SFGPRODU;
--  DDL for Package Body SFGINF_REPORTESPORDECADA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_REPORTESPORDECADA */ 

    IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTESPORDECADA_ReporteCadenasxNit', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTESPORDECADA_ReporteCadenasxNit;
GO

CREATE         PROCEDURE WSXML_SFG.SFGINF_REPORTESPORDECADA_ReporteCadenasxNit(@pNIT NUMERIC(22,0),
                                @pFECHAINICIO DATETIME,
                                @PFECHAFIN DATETIME) AS
 BEGIN 
    DECLARE @v_sql VARCHAR(MAX);
    DECLARE @v_nompuntodeventa VARCHAR(MAX);
     
    SET NOCOUNT ON;
         --Lista lineas de negocio diferenctes a ADM Operativo separadas por coma en variable
 
			SELECT @v_nompuntodeventa  = STUFF(
				( SELECT  ','+ CONVERT(VARCHAR,ID_LINEADENEGOCIO) FROM WSXML_SFG.lineadenegocio a WHERE b.ID_LINEADENEGOCIO = a.ID_LINEADENEGOCIO FOR XML PATH('')),1 ,1, ''
			)
			FROM WSXML_SFG.lineadenegocio b
			WHERE ID_LINEADENEGOCIO <> 5;   


            SET @v_sql =  'SELECT * FROM(
                      select distinct TIPOPRODUCTO.codlineadenegocio, agrupacionpuntodeventa.codigoagrupaciongtech, 
                      entradaarchivocontrol.fechaarchivo, puntodeventa.codigogtechpuntodeventa, puntodeventa.nompuntodeventa,
                      --Informacion por linea de negocio
                      case when registrofacturacion.codtiporegistro in (1, 3) then ISNULL(sum(registrofacturacion.numtransacciones), 0) else 0 end - 
                      case when registrofacturacion.codtiporegistro = 2 then sum(ISNULL(registrofacturacion.numtransacciones, 0)) else 0 end as Totaltransacciones, 
                      case when registrofacturacion.codtiporegistro in (1, 3) then ISNULL(sum(registrofacturacion.valortransaccion), 0) else 0 end - 
                      case when registrofacturacion.codtiporegistro = 2 then sum(ISNULL(registrofacturacion.valortransaccion, 0)) else 0 end as TotalVentas, 
                      sum(case when registrofacturacion.codtiporegistro in (1, 3) then ISNULL(round(registrofacturacion.valorventabrutanoredondeado, 2), 0) else 0 end - 
                      case when registrofacturacion.codtiporegistro = 2 then ISNULL(registrofacturacion.valortransaccion, 0) else 0 end) as totalventabruta, 
                      sum(case when registrofacturacion.codtiporegistro = 4 then ISNULL(registrofacturacion.valortransaccion, 0) else 0 end) as totalPremiosPagados
                      from WSXML_SFG.registrofacturacion
                      inner join  WSXML_SFG.entradaarchivocontrol on entradaarchivocontrol.id_entradaarchivocontrol = registrofacturacion.codentradaarchivocontrol
                      INNER join WSXML_SFG.puntodeventa on puntodeventa.id_puntodeventa = registrofacturacion.codpuntodeventa
                      INNER join WSXML_SFG.agrupacionpuntodeventa on puntodeventa.codagrupacionpuntodeventa = agrupacionpuntodeventa.id_agrupacionpuntodeventa
                      INNER join WSXML_SFG.producto on producto.id_producto = registrofacturacion.codproducto
                      INNER join WSXML_SFG.tipoproducto on tipoproducto.id_tipoproducto = producto.codtipoproducto
                      INNER join WSXML_SFG.razonsocial on registrofacturacion.codrazonsocial = razonsocial.id_razonsocial
                      where razonsocial.identificacion = '+isnull(@pNIT, '') +' and FECHAARCHIVO between '''+ISNULL(@pFECHAINICIO, '')+''' and '''+ISNULL(@PFECHAFIN, '')+'''
                      group by TIPOPRODUCTO.codlineadenegocio, agrupacionpuntodeventa.codigoagrupaciongtech, 
                      entradaarchivocontrol.fechaarchivo, puntodeventa.codigogtechpuntodeventa, puntodeventa.nompuntodeventa, registrofacturacion.codtiporegistro
                      )
                      pivot(
                      sum(Totaltransacciones) as TotalTransacciones, sum(TotalVentas) AS TotalVentas, 
                      sum(totalventabruta) AS TotalVentasbrutas, sum(totalPremiospagados) as Totalpremiospagados
                      FOR codlineadenegocio in ('+isnull(@v_nompuntodeventa, '')+'))
                      order by fechaarchivo';
                       
                                          
                      execute (@v_sql);
                  END;

GO

