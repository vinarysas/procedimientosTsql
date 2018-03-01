USE SFGPRODU;
--  DDL for Package Body SFGINF_ESPECIALSEMANAL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_ESPECIALSEMANAL */ 

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALSEMANAL_EFECTYSEMANAL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALSEMANAL_EFECTYSEMANAL;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALSEMANAL_EFECTYSEMANAL(
  @ID_DETALLETAREAEJECUTADA NUMERIC(22,0), 
  @DIA DATETIME
) AS
BEGIN

  DECLARE @sFECHAFRST DATETIME;
  DECLARE @sFECHALAST DATETIME;
  DECLARE @sWEEKDAY INT;
     
  SET NOCOUNT ON;
  SET @sWEEKDAY= CAST(DATEPART(WEEKDAY,@DIA) AS SMALLINT);
  SET @sFECHAFRST=(CONVERT(DATETIME, CONVERT(DATE,@DIA))-@sWEEKDAY)+1;
  SET @sFECHALAST = @sFECHAFRST + 6 ;

  SELECT NOMPRODUCTO,
         CODIGOGTECHPUNTODEVENTA,
         CODREGISTROFACTURACION,
         CONVERT(DATE,FECHAHORATRANSACCION) FECHAHORATRANSACCION,
         REGISTROFACTREFERENCIA.VALORTRANSACCION,
         SUSCRIPTOR,
         ARRN_GIRO_DEPOSITO,
         SUBSTRING(ciudaddane, 1, 2) DEPARTAMENTO,
         SUBSTRING(ciudaddane, 3, 3) CIUDAD
    FROM WSXML_SFG.REGISTROFACTREFERENCIA
   INNER JOIN WSXML_SFG.REGISTROFACTURACION
      ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
         REGISTROFACTURACION.ID_REGISTROFACTURACION
   INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
      ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
         ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
   INNER JOIN WSXML_SFG.TIPOREGISTRO
      ON REGISTROFACTURACION.CODTIPOREGISTRO =
         TIPOREGISTRO.ID_TIPOREGISTRO
   INNER JOIN WSXML_SFG.PRODUCTO
      ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
   inner join WSXML_SFG.puntodeventa
      on puntodeventa.id_puntodeventa =
         registrofacturacion.codpuntodeventa
   inner join WSXML_SFG.ciudad
      on ciudad.id_ciudad = puntodeventa.codciudad
   WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO >= @sFECHAFRST 
     AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO <= @sFECHALAST
     AND REGISTROFACTURACION.CODPRODUCTO IN (1875, 1874)
     AND TIPOREGISTRO.ID_TIPOREGISTRO IN (1)

END 
GO

   IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALSEMANAL_ConsolsemanalTxLogueoTerminal', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALSEMANAL_ConsolsemanalTxLogueoTerminal;
go

create       PROCEDURE WSXML_SFG.SFGINF_ESPECIALSEMANAL_ConsolsemanalTxLogueoTerminal(@ID_DETALLETAREAEJEUTADA NUMERIC(22,0), 
                                      @DIA DATETIME,
                                     @pCODPRODUCTO NUMERIC(22,0))
  as
  begin 
    declare @sFECHAFRST DATETIME;
    declare @sFECHALAST DATETIME;
    declare @sWEEKDAY INT;
   
  set nocount on;
    set @sWEEKDAY= CAST(DATEPART(WEEKDAY,@DIA) AS SMALLINT);
    set @sFECHAFRST=(CONVERT(DATETIME, CONVERT(DATE,@DIA))-@sWEEKDAY)+1;
    set @sFECHALAST=@sFECHAFRST + 6 ;
        select fechaarchivo  as "Fecha Archivo", codigogtechpuntodeventa as "Numero PDV",
        nompuntodeventa as "Nombre PDV", suscriptor as "Numero Cedula", horas as Horas, minutos as Minutos, 
        totalminutos as "Total minutos", sum(numerotransacciones) as "Numero Transacciones", 
        sum(montoventa) as "Monto Venta" , nomregional as Regional, ciudad as Ciudad
        from ( 
            SELECT distinct reg.codpuntodeventa,  convert(varchar, e.fechaarchivo) as fechaarchivo, p.codigogtechpuntodeventa ,
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
            left outer join (
				select case when codtiporegistro in (1,3) then sum(regf.numtransacciones) else 0 end as totaltx, 
                 case when codtiporegistro in (1,3) then sum(regf.valortransaccion) else 0 end as totalventas, 
                 regf.codentradaarchivocontrol, regf.codpuntodeventa, rfr.fechahoratransaccion, rfr.suscriptor
                 from WSXML_SFG.registrofacturacion regf 
                 inner join WSXML_SFG.entradaarchivocontrol ent on ent.id_entradaarchivocontrol = regf.codentradaarchivocontrol
                 inner join WSXML_SFG.registrofactreferencia rfr on rfr.codregistrofacturacion = regf.id_registrofacturacion
                 where ent.fechaarchivo BETWEEN @sFECHAFRST AND @sFECHALAST and regf.codproducto <> @pCODPRODUCTO
                 group by regf.codentradaarchivocontrol, regf.codtiporegistro,regf.codciudad, regf.codpuntodeventa, 
                 rfr.fechahoratransaccion, rfr.suscriptor
                ) reg on reg.codpuntodeventa = rf.codpuntodeventa
            where fechaarchivo BETWEEN @sFECHAFRST AND @sFECHALAST and rf.codproducto = @pCODPRODUCTO
            group by e.fechaarchivo, rf.codpuntodeventa,p.codigogtechpuntodeventa,
             r.nomregional, rfr.suscriptor, c.nomciudad, p.nompuntodeventa,  reg.codpuntodeventa, 
             reg.suscriptor
             ) T
         group by codpuntodeventa, fechaarchivo, codigogtechpuntodeventa,
          nompuntodeventa, suscriptor, horas, totalminutos, nomregional, ciudad, minutos
          order by 1;
        end;
     GO   


  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALSEMANAL_GetreferecnciasCadenas', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALSEMANAL_GetreferecnciasCadenas;
go

create     PROCEDURE WSXML_SFG.SFGINF_ESPECIALSEMANAL_GetreferecnciasCadenas(@ID_DETALLETAREAEJEUTADA NUMERIC(22,0), 
                                        @DIA DATETIME) as 
        Begin
        Set nocount on;
               select a.codigoagrupaciongtech as Chain, a.nomagrupacionpuntodeventa as Cadena, 
               p.codigogtechpuntodeventa as POS, p.numeroterminal as Term
               from WSXML_SFG.puntodeventa p 
               inner join WSXML_SFG.agrupacionpuntodeventa a on a.id_agrupacionpuntodeventa = p.codagrupacionpuntodeventa
               where p.active = 1 order by a.codigoagrupaciongtech;
end;


GO


