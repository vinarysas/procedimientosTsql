USE SFGPRODU;
--  DDL for Package Body SFGINF_REPORTECADENASXNIT
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_REPORTECADENASXNIT */ 


IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTECADENASXNIT_REPORTEMENSUALCADENASDETALLE', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_REPORTEMENSUALCADENASDETALLE;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_REPORTEMENSUALCADENASDETALLE( @pNIT NUMERIC(22,0),
                              @pFECHAINICIO DATETIME,
                              @PFECHAFIN DATETIME) AS
                              
BEGIN
SET NOCOUNT ON;
    select entradaarchivocontrol.fechaarchivo as Fecha, 
    puntodeventa.codigogtechpuntodeventa as "Punto de Venta", 
    puntodeventa.nompuntodeventa as "Nombre PDV", 
    lineadenegocio.nomcortolineadenegocio as "Linea de Negocio", 
    tipoproducto.nomtipoproducto as "Tipo producto", 
    producto.nomproducto as Producto, 
    isnull(tipoprodagrupado.NOMTIPOPRODUCTOAGRUPADO, '0') AS DETALLE,
    isnull(sum(registro.totaltransacciones), 0) as TotalTransacciones,
    isnull(sum(registro.ingresos), 0) - isnull(sum(registro.totalpremiospagados), 0) as Ingresos,
    isnull(sum(registro.ivaproducto), 0)  as ivaproducto, 
    round(isnull(sum(registro.ingresosbrutos), 0), 2) as ingresosbrutos, 
    isnull(sum(premios.totalpremiospagados), 0) as totalpremiospagados
from WSXML_SFG.entradaarchivocontrol
    inner join WSXML_SFG.registrofacturacion on registrofacturacion.codentradaarchivocontrol = entradaarchivocontrol.id_entradaarchivocontrol
    inner join WSXML_SFG.puntodeventa on registrofacturacion.codpuntodeventa = puntodeventa.id_puntodeventa
    inner join WSXML_SFG.producto on producto.id_producto = registrofacturacion.codproducto
    inner join WSXML_SFG.tipoproducto on producto.codtipoproducto = tipoproducto.id_tipoproducto
    inner join WSXML_SFG.lineadenegocio on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
    inner join WSXML_SFG.razonsocial on razonsocial.id_razonsocial = registrofacturacion.codrazonsocial
                             
   INNER JOIN (
      select distinct TIPOPRODUCTO.id_tipoproducto, UPPER(case when tipoproducto.codlineadenegocio = 1 or tipoproducto.codlineadenegocio = 2 
      or tipoproducto.codlineadenegocio = 4 and tipoproducto.id_tipoproducto <> 14
      then lineadenegocio.nomcortolineadenegocio 
      when tipoproducto.codlineadenegocio = 3 and tipoproducto.id_tipoproducto <> 15  then 'FACTURAS' 
      else tipoproducto.nomtipoproducto end) as NOMTIPOPRODUCTOAGRUPADO
      from WSXML_SFG.lineadenegocio 
      inner join WSXML_SFG.tipoproducto on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
      where lineadenegocio.id_lineadenegocio <> 5) tipoprodagrupado 
      on tipoprodagrupado.id_tipoproducto = TIPOPRODUCTO.id_tipoproducto 
    
    inner join (   select registrofacturacion.id_registrofacturacion, 
                        isnull(case when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio = 4 and sum(registrofacturacion.valortransaccion) > 0 then 
                        sum(registrofacturacion.numtransacciones) 
                        when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio <> 4 then sum(registrofacturacion.numtransacciones) 
                        end - CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN SUM(REGISTROFACTURACION.NUMTRANSACCIONES)
                        ELSE 0 END , 0) as totaltransacciones, 
                        CONVERT(NUMERIC, isnull(case when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio = 4 and sum(registrofacturacion.valortransaccion) > 0 then 
                        sum(registrofacturacion.valortransaccion) 
                        when registrofacturacion.codtiporegistro in (1,3,4) 
                        and tipoproducto.codlineadenegocio <> 4 then sum(registrofacturacion.valortransaccion) 
                        end - CASE WHEN 
                        REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN SUM(REGISTROFACTURACION.NUMTRANSACCIONES) ELSE 0 END , 0)) AS Ingresos,
                        CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1) THEN 
                        ROUND(ISNULL(sum(IMPUESTOS.iva),0), 2) ELSE 0 END - 
                        CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN 
                        ROUND(ISNULL(sum(IMPUESTOS.iva),0), 2) ELSE 0 END as ivaproducto,                             
                        
                        isnull(case when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio = 4 and sum(registrofacturacion.valortransaccion) > 0 then 
                        sum(registrofacturacion.valorventabrutanoredondeado) 
                        when registrofacturacion.codtiporegistro in (1,3,4) 
                        and tipoproducto.codlineadenegocio <> 4 then sum(registrofacturacion.valorventabrutanoredondeado) 
                        end - CASE WHEN 
                        REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN SUM(REGISTROFACTURACION.valorventabrutanoredondeado) ELSE 0 END , 0)
                         as ingresosbrutos,
                         case when registrofacturacion.codtiporegistro = 4 then sum(registrofacturacion.valortransaccion) else 0 end as totalpremiospagados
                     from WSXML_SFG.registrofacturacion
                     LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                       SUM (IMPUESTOREGFACTURACION.VALORIMPUESTO) AS IVA
                                      FROM WSXML_SFG.IMPUESTOREGFACTURACION
                                     WHERE IMPUESTOREGFACTURACION.CODIMPUESTO = 1
                                     GROUP BY CODREGISTROFACTURACION)IMPUESTOS 
                     ON IMPUESTOS.CODREGISTROFACTURACION = registrofacturacion.ID_REGISTROFACTURACION
                     inner join WSXML_SFG.producto on producto.id_producto = registrofacturacion.codproducto
                     inner join WSXML_SFG.tipoproducto on tipoproducto.id_tipoproducto = producto.codtipoproducto
                     inner join WSXML_SFG.entradaarchivocontrol on entradaarchivocontrol.id_entradaarchivocontrol = registrofacturacion.codentradaarchivocontrol
                     inner join WSXML_SFG.razonsocial on razonsocial.id_razonsocial = registrofacturacion.codrazonsocial
                     where entradaarchivocontrol.fechaarchivo between @pFECHAINICIO and @PFECHAFIN
    and razonsocial.identificacion = @pNIT
                     group by registrofacturacion.id_registrofacturacion, registrofacturacion.codtiporegistro, 
                     tipoproducto.codlineadenegocio
    ) registro on registro.id_registrofacturacion = registrofacturacion.id_registrofacturacion
    
    left outer join ( select registrofacturacion.id_registrofacturacion, 
                         case when registrofacturacion.codtiporegistro = 4 then sum(registrofacturacion.valortransaccion) else 0 end as totalpremiospagados
                     from WSXML_SFG.registrofacturacion
                     inner join WSXML_SFG.entradaarchivocontrol on entradaarchivocontrol.id_entradaarchivocontrol = registrofacturacion.codentradaarchivocontrol
                     inner join WSXML_SFG.razonsocial on razonsocial.id_razonsocial = registrofacturacion.codrazonsocial
                     where entradaarchivocontrol.fechaarchivo between @pFECHAINICIO and @PFECHAFIN
    and razonsocial.identificacion = @pNIT
                     group by registrofacturacion.id_registrofacturacion, 
                     registrofacturacion.codtiporegistro) premios on premios.id_registrofacturacion = registrofacturacion.id_registrofacturacion
                                      
    where entradaarchivocontrol.fechaarchivo between @pFECHAINICIO and @PFECHAFIN
    and razonsocial.identificacion = @pNIT and registro.totaltransacciones > 0 or premios.totalpremiospagados > 0

     
    group by entradaarchivocontrol.fechaarchivo, puntodeventa.codigogtechpuntodeventa, puntodeventa.nompuntodeventa, 
    lineadenegocio.nomcortolineadenegocio, tipoproducto.nomtipoproducto, producto.nomproducto, 
     tipoprodagrupado.NOMTIPOPRODUCTOAGRUPADO
    order by entradaarchivocontrol.fechaarchivo, puntodeventa.codigogtechpuntodeventa
    
;
 END;
 GO
 

 IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTECADENASXNIT_REPORTEMENSUALCADENASRESUMEN', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_REPORTEMENSUALCADENASRESUMEN;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_REPORTEMENSUALCADENASRESUMEN( @pNIT NUMERIC(22,0),
                              @pFECHAINICIO DATETIME,
                              @PFECHAFIN DATETIME) AS
 BEGIN
 DECLARE @v_sql NVARCHAR(MAX);
 DECLARE @v_TipoPorductoAgrupado VARCHAR(MAX);                             
 
                              
 
SET NOCOUNT ON;
   --LISTA TIPOS DE PRODUCTO AGRUPADOS

	SELECT @v_TipoPorductoAgrupado  = STUFF(( 
			SELECT  ','+ TIPOPRODUCTOAGRUPADO 
			FROM (
				select distinct UPPER(case when tipoproducto.codlineadenegocio = 1 or tipoproducto.codlineadenegocio = 2 
				or tipoproducto.codlineadenegocio = 4 and tipoproducto.id_tipoproducto <> 14
				then lineadenegocio.nomcortolineadenegocio 
				when tipoproducto.codlineadenegocio = 3 and tipoproducto.id_tipoproducto <> 15  then 'FACTURAS' 
				else tipoproducto.nomtipoproducto end) as TIPOPRODUCTOAGRUPADO
				from WSXML_SFG.lineadenegocio 
				inner join WSXML_SFG.tipoproducto on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
				where lineadenegocio.id_lineadenegocio <> 5
			) a 
			
			WHERE b.TIPOPRODUCTOAGRUPADO = a.TIPOPRODUCTOAGRUPADO FOR XML PATH('')),1 ,1, ''
		)
	

    FROM (
    select distinct UPPER(case when tipoproducto.codlineadenegocio = 1 or tipoproducto.codlineadenegocio = 2 
    or tipoproducto.codlineadenegocio = 4 and tipoproducto.id_tipoproducto <> 14
    then lineadenegocio.nomcortolineadenegocio 
    when tipoproducto.codlineadenegocio = 3 and tipoproducto.id_tipoproducto <> 15  then 'FACTURAS' 
    else tipoproducto.nomtipoproducto end) as TIPOPRODUCTOAGRUPADO
    from WSXML_SFG.lineadenegocio 
    inner join WSXML_SFG.tipoproducto on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
    where lineadenegocio.id_lineadenegocio <> 5) b;
   
    --GROUP BY TIPOPRODUCTOAGRUPADO
   
    SET @v_sql = '

select * from (
select DISTINCT puntodeventa.codigogtechpuntodeventa as PuntodeVenta, 
    puntodeventa.nompuntodeventa as "NombrePDV", 
    isnull(tipoprodagrupado.NOMTIPOPRODUCTOAGRUPADO, ''0'') AS DETALLE,
     isnull(sum(registro.totaltransacciones), 0) as TotalTransacciones,
    isnull(sum(registro.ingresos), 0) as TOTALVENTAS,
    isnull(sum(registro.ivaproducto), 0) as ivaproducto, 
    round(isnull(sum(registro.ingresosbrutos), 0), 2) as ingresosbrutos, 
    isnull(sum(registro.totalpremiospagados), 0) as totalpremiospagados,
	ROW_NUMBER() OVER(order by puntodeventa.codigogtechpuntodeventa) AS ROWNUMBER
    from WSXML_SFG.entradaarchivocontrol
    inner join WSXML_SFG.registrofacturacion on registrofacturacion.codentradaarchivocontrol = entradaarchivocontrol.id_entradaarchivocontrol
    inner join WSXML_SFG.puntodeventa on registrofacturacion.codpuntodeventa = puntodeventa.id_puntodeventa
    inner join WSXML_SFG.producto on producto.id_producto = registrofacturacion.codproducto
    inner join WSXML_SFG.tipoproducto on producto.codtipoproducto = tipoproducto.id_tipoproducto
    inner join WSXML_SFG.lineadenegocio on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
    inner join WSXML_SFG.razonsocial on razonsocial.id_razonsocial = registrofacturacion.codrazonsocial
    LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                       SUM (IMPUESTOREGFACTURACION.VALORIMPUESTO) AS IVA
                                      FROM WSXML_SFG.IMPUESTOREGFACTURACION
                                     WHERE IMPUESTOREGFACTURACION.CODIMPUESTO = 1
                                     GROUP BY CODREGISTROFACTURACION)IMPUESTOS 
                             ON IMPUESTOS.CODREGISTROFACTURACION = registrofacturacion.ID_REGISTROFACTURACION
                             
                             INNER JOIN (
                                select distinct TIPOPRODUCTO.id_tipoproducto, UPPER(case when tipoproducto.codlineadenegocio = 1 or tipoproducto.codlineadenegocio = 2 
                                or tipoproducto.codlineadenegocio = 4 and tipoproducto.id_tipoproducto <> 14
                                then lineadenegocio.nomcortolineadenegocio 
                                when tipoproducto.codlineadenegocio = 3 and tipoproducto.id_tipoproducto <> 15  then ''FACTURAS'' 
                                else tipoproducto.nomtipoproducto end) as NOMTIPOPRODUCTOAGRUPADO
                                from WSXML_SFG.lineadenegocio 
                                inner join WSXML_SFG.tipoproducto on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
                                where lineadenegocio.id_lineadenegocio <> 5) tipoprodagrupado 
                                      on tipoprodagrupado.id_tipoproducto = TIPOPRODUCTO.id_tipoproducto 
    inner join (select registrofacturacion.id_registrofacturacion, 
                        isnull(case when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio = 4 and sum(registrofacturacion.valortransaccion) > 0 then 
                        sum(registrofacturacion.numtransacciones) 
                        when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio <> 4 then sum(registrofacturacion.numtransacciones) 
                        end - CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN SUM(REGISTROFACTURACION.NUMTRANSACCIONES)
                        ELSE 0 END , 0) as totaltransacciones, 
                        CONVERT(NUMERIC, isnull(case when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio = 4 and sum(registrofacturacion.valortransaccion) > 0 then 
                        sum(registrofacturacion.valortransaccion) 
                        when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio <> 4 then sum(registrofacturacion.valortransaccion) 
                        end - CASE WHEN 
                        REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN SUM(REGISTROFACTURACION.NUMTRANSACCIONES) ELSE 0 END , 0)) AS Ingresos,
                        CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN 
                        ROUND(isnull(sum(IMPUESTOS.iva),0), 2) ELSE 0 END - 
                        CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN 
                        ROUND(isnull(sum(IMPUESTOS.iva),0), 2) ELSE 0 END as ivaproducto,                             
                        
                        isnull(case when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio = 4 and sum(registrofacturacion.valortransaccion) > 0 then 
                        sum(registrofacturacion.valorventabrutanoredondeado) 
                        when registrofacturacion.codtiporegistro in (1,3) 
                        and tipoproducto.codlineadenegocio <> 4 then sum(registrofacturacion.valorventabrutanoredondeado) 
                        end - CASE WHEN 
                        REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN SUM(REGISTROFACTURACION.valorventabrutanoredondeado) ELSE 0 END , 0)
                         as ingresosbrutos,
                         case when registrofacturacion.codtiporegistro = 4 then sum(registrofacturacion.valortransaccion) else 0 end as totalpremiospagados
                     from WSXML_SFG.registrofacturacion
                     LEFT OUTER JOIN (SELECT CODREGISTROFACTURACION,
                                       SUM (IMPUESTOREGFACTURACION.VALORIMPUESTO) AS IVA
                                      FROM WSXML_SFG.IMPUESTOREGFACTURACION
                                     WHERE IMPUESTOREGFACTURACION.CODIMPUESTO = 1
                                     GROUP BY CODREGISTROFACTURACION)IMPUESTOS 
                     ON IMPUESTOS.CODREGISTROFACTURACION = registrofacturacion.ID_REGISTROFACTURACION
                     inner join WSXML_SFG.producto on producto.id_producto = registrofacturacion.codproducto
                     inner join WSXML_SFG.tipoproducto on tipoproducto.id_tipoproducto = producto.codtipoproducto
                     inner join WSXML_SFG.entradaarchivocontrol on entradaarchivocontrol.id_entradaarchivocontrol = registrofacturacion.codentradaarchivocontrol
                     inner join WSXML_SFG.razonsocial on razonsocial.id_razonsocial = registrofacturacion.codrazonsocial
                     where entradaarchivocontrol.fechaarchivo  between '''+ ISNULL(CONVERT(VARCHAR,@pFECHAINICIO,21), '') +''' and '''+ISNULL(CONVERT(VARCHAR,@PFECHAFIN,21), '')+''' 
                     and razonsocial.identificacion = '+ISNULL(CONVERT(VARCHAR,@pNIT), '')+'
                     group by registrofacturacion.id_registrofacturacion, registrofacturacion.codtiporegistro, 
                     tipoproducto.codlineadenegocio
    ) registro on registro.id_registrofacturacion = registrofacturacion.id_registrofacturacion
    where entradaarchivocontrol.fechaarchivo  between '''+ ISNULL(CONVERT(VARCHAR,@pFECHAINICIO,21), '') +''' and '''+ISNULL(CONVERT(VARCHAR,@PFECHAFIN,21), '')+''' 
    and razonsocial.identificacion = '+ISNULL(CONVERT(VARCHAR,@pNIT), '')+' and registro.totaltransacciones > 0 or registro.totalpremiospagados > 0
    group by puntodeventa.codigogtechpuntodeventa, puntodeventa.nompuntodeventa,--, registrofacturacion.codtiporegistro,
     tipoprodagrupado.NOMTIPOPRODUCTOAGRUPADO
    --order by puntodeventa.codigogtechpuntodeventa
	) T
    pivot (SUM(TotalTransacciones)
    for DETALLE IN ('+ ISNULL(@v_TipoPorductoAgrupado, '') +')) PIV
    ORDER BY PuntodeVenta
';
    
  
    EXECUTE sp_executesql @v_sql
 END;
 GO
 
 IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTECADENASXNIT_GetTipoProductoAgrupado', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_GetTipoProductoAgrupado;
go

create   PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_GetTipoProductoAgrupado
   as
   begin
   set nocount on;
            select distinct UPPER(case when tipoproducto.codlineadenegocio = 1 or tipoproducto.codlineadenegocio = 2 
        or tipoproducto.codlineadenegocio = 4 and tipoproducto.id_tipoproducto <> 14
        then lineadenegocio.nomcortolineadenegocio 
        when tipoproducto.codlineadenegocio = 3 and tipoproducto.id_tipoproducto <> 15  then 'FACTURAS' 
        else tipoproducto.nomtipoproducto end) as TIPOPRODUCTOAGRUPADO
        from WSXML_SFG.lineadenegocio 
        inner join WSXML_SFG.tipoproducto on lineadenegocio.id_lineadenegocio = tipoproducto.codlineadenegocio
        where lineadenegocio.id_lineadenegocio <> 5
        order by 1;
   end; 
  GO
   
 IF OBJECT_ID('WSXML_SFG.SFGINF_REPORTECADENASXNIT_GetAllLineadeNegocio', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_GetAllLineadeNegocio;
go

create       PROCEDURE WSXML_SFG.SFGINF_REPORTECADENASXNIT_GetAllLineadeNegocio
     as 
     begin
     set nocount on;
             select lineadenegocio.id_lineadenegocio, lineadenegocio.nomlineadenegocio
       from WSXML_SFG.lineadenegocio 
       order by lineadenegocio.nomlineadenegocio;
end;
GO



