USE SFGPRODU;
--  DDL for Package Body SFGINF_ESPECIALMENSUAL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_ESPECIALMENSUAL */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_DetalleTransacciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_DetalleTransacciones;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_DetalleTransacciones(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                 @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                 @pg_CADENA                NVARCHAR(2000),
                                 @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                @pg_PRODUCTO              NVARCHAR(2000)
                                 ) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    --SFG_PACKAGE.GetMonthRange(@sFECHACCLO, @sFECHAFRST, @sFECHALAST);
      SELECT RFR.FECHAHORATRANSACCION    AS FECHAHORATRANSACCION,
             RFR.VALORTRANSACCION        AS VALORTRANSACCION,
             PDV.CODIGOGTECHPUNTODEVENTA AS CODIGOGTECHPUNTODEVENTA,
             RFR.SUSCRIPTOR              AS SUSCRIPTOR,
             RFR.ESTADO                  AS ESTADO
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
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
       WHERE CTR.REVERSADO = 0
         AND CTR.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
         AND SRV.AGRUPAMIENTO = 0
         --AND PRD.CODAGRUPACIONPRODUCTO = TO_NUMBER(@pg_PRODUCTO)
         AND REG.CODTIPOREGISTRO = 1
         AND RFR.ANULADO = 0
       ORDER BY CTR.FECHAARCHIVO, RFR.FECHAHORATRANSACCION;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_VENTASDIARIASDENOMINACION', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_VENTASDIARIASDENOMINACION;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_VENTASDIARIASDENOMINACION(
  @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
  @pg_CADENA                NVARCHAR(MAX),
  @pg_ALIADOESTRATEGICO     NVARCHAR(MAX),
  @pg_PRODUCTO              NVARCHAR(MAX)
) AS
BEGIN
  
  DECLARE @sFECHACCLO        DATE
  DECLARE @sFECHAFRST        DATE
  DECLARE @sFECHALAST        DATE
  DECLARE @ProductList       WSXML_SFG.IDSTRINGVALUE
  DECLARE @ProductString     NVARCHAR(MAX)
  DECLARE @ProductParentName NVARCHAR(MAX)
  DECLARE @ID                NUMERIC
  DECLARE @VALUE             NVARCHAR(MAX)
  DECLARE @SQL               NVARCHAR(MAX)

  SELECT @sFECHACCLO = FECHAEJECUCION
  FROM WSXML_SFG.CICLOFACTURACIONPDV
  WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
  
  EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange
    @sFECHACCLO, 
    @sFECHAFRST OUT, 
    @sFECHALAST OUT
  
  -- Get Products
  INSERT INTO @ProductList
  SELECT ID_PRODUCTO, NOMPRODUCTO
  FROM WSXML_SFG.PRODUCTO
  WHERE CODAGRUPACIONPRODUCTO = CAST(@pg_PRODUCTO AS NUMERIC)
  ORDER BY ID_PRODUCTO

  SELECT @ProductParentName = NOMAGRUPACIONPRODUCTO
  FROM WSXML_SFG.AGRUPACIONPRODUCTO
  WHERE ID_AGRUPACIONPRODUCTO = CAST(@pg_PRODUCTO AS NUMERIC)

  IF (SELECT COUNT(*) FROM @ProductList) > 0 
  BEGIN
    DECLARE ipx CURSOR FOR
      SELECT ID, VALUE
      FROM @ProductList
    OPEN ipx
    FETCH NEXT FROM ipx INTO @ID, @VALUE
    BEGIN
      SET @ProductString = CONCAT(
        @ProductString,
        ', SUM(CASE WHEN VNT.CODPRODUCTO = ',
        @ID,
        ' THEN VNT.NUMTRANSACCIONES ELSE 0 END) AS ''',
        CASE WHEN LEN(@VALUE) > 30 THEN SUBSTRING(@VALUE, 0, 30) ELSE @VALUE END,
        ''' '
      )
    END
    CLOSE ipx
    DEALLOCATE ipx
  END
  
  SET @SQL = CONCAT(
    'SELECT ''', 
    CASE WHEN LEN(@ProductParentName) > 30 THEN SUBSTRING(@ProductParentName,0,30) ELSE @ProductParentName END, 
    ''' AS NOMAGRUPACIONPRODUCTO, VNT.FECHAARCHIVO ',
    @ProductString,
    'FROM (SELECT CTR.FECHAARCHIVO AS FECHAARCHIVO, ',
    'PRD.ID_PRODUCTO AS CODPRODUCTO, ',
    'SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN REG.NUMTRANSACCIONES WHEN REG.CODTIPOREGISTRO = 2 THEN REG.NUMTRANSACCIONES * (-1) ELSE 0 END) AS NUMTRANSACCIONES ',
    'FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR ',
    'INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.CODAGRUPACIONPRODUCTO = ',
    CAST(@pg_PRODUCTO AS NUMERIC),
    ') ',
    'LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL AND REG.CODPRODUCTO = PRD.ID_PRODUCTO) ',
    'WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN ''',
    @sFECHAFRST,
    ''' ',
    'AND ''',
    @sFECHALAST, 
    ''' ',
    'GROUP BY CTR.FECHAARCHIVO, PRD.ID_PRODUCTO) VNT ', 
    'GROUP BY VNT.FECHAARCHIVO ORDER BY VNT.FECHAARCHIVO'
  )
  
  EXECUTE sp_executesql @SQL
  
END
GO

 IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensual', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensual;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensual(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                       @DIA                      DATETIME) AS
 BEGIN
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @DIA, @sFECHAFRST OUT, @sFECHALAST OUT
      SELECT ALIADOESTRATEGICO.NOMALIADOESTRATEGICO AS "Aliado Estrategico",
             producto.nomproducto AS "Producto",
             FORMAT(abs(PUNTODEVENTA.NUMEROTERMINAL), '00000') AS "Terminal",
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
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN
             convert(datetime, convert(date,@sFECHAFRST)) AND convert(datetime, convert(date,@sFECHALAST))
         AND REGISTROFACTURACION.CODTIPOREGISTRO = 1
         AND REGISTROFACTURACION.CODPRODUCTO IN
             (SELECT ID_PRODUCTO
                FROM WSXML_SFG.PRODUCTO P
               WHERE P.CODALIADOESTRATEGICO IN (918, 949));
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensualNoMasivo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensualNoMasivo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensualNoMasivo(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME) AS
 BEGIN
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @DIA, @sFECHAFRST OUT, @sFECHALAST OUT
      select P.CODIGOGTECHPUNTODEVENTA,
             rfR.fechahoratransaccion  AS FECHA,
             rfR.recibo                as SPRN,
             rfR.suscriptor            AS NURA,
             rfR.valortransaccion      AS MONTO,
             rfR.estado,
             rfR.ARRN
        from WSXML_SFG.registrofactreferencia rfR,
             WSXML_SFG.PUNTODEVENTA P,
             (select r.id_registrofacturacion, R.CODPUNTODEVENTA
                from WSXML_SFG.registrofacturacion r
               where r.codtiporegistro = 1
                 and r.codproducto = 1953
                 and r.codentradaarchivocontrol in
                     (select e.id_entradaarchivocontrol
                        from WSXML_SFG.entradaarchivocontrol e
                       where e.tipoarchivo = 1
                         and e.fechaarchivo between @sFECHAFRST and @sFECHALAST)) RF
       where rfR.codregistrofacturacion = RF.id_registrofacturacion
         AND P.ID_PUNTODEVENTA = RF.CODPUNTODEVENTA;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_RECAUDOFRACCIONADO', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_RECAUDOFRACCIONADO;
GO

CREATE PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_RECAUDOFRACCIONADO(
  @ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
  @DIA DATETIME,
  @P_ID_PRODUCTO NUMERIC(22,0)
) AS
BEGIN
  DECLARE @sFECHAFRST DATE
  DECLARE @sFECHALAST DATE

  EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange
    @DIA,
    @sFECHAFRST OUT,
    @sFECHALAST OUT
      
  select 
    e.fechaarchivo,
    rfr.suscriptor,
    p.codigogtechpuntodeventa,
    p.nompuntodeventa,
    tn.nomtiponegocio,
    tp.nomtipopuntodeventa,
    rg.nomregional,
    c.nomciudad,
    d.nomdepartamento,
    a.nomagrupacionpuntodeventa,
    rfr.valortransaccion,
    repeticiones as cantidad_tx
  from 
    wsxml_sfg.registrofactreferencia rfr,
    wsxml_sfg.registrofacturacion rf,
    wsxml_sfg.entradaarchivocontrol e,
    wsxml_sfg.puntodeventa p,
    wsxml_sfg.agrupacionpuntodeventa a,
    wsxml_sfg.ciudad c,
    wsxml_sfg.departamento d,
    wsxml_sfg.tiponegocio tn,
    wsxml_sfg.tipopuntodeventa tp,
    wsxml_sfg.regional rg,
    (
      select 
        fechaarchivo,
        suscriptor,
        id_puntodeventa,
        count(*) as repeticiones
      from (
        select 
          e.fechaarchivo,
          rfr.suscriptor,
          p.id_puntodeventa
        from 
          wsxml_sfg.registrofactreferencia rfr,
          wsxml_sfg.registrofacturacion    rf,
          wsxml_sfg.entradaarchivocontrol  e,
          wsxml_sfg.puntodeventa           p
        where rfr.codregistrofacturacion = rf.id_registrofacturacion
          and rf.codentradaarchivocontrol = e.id_entradaarchivocontrol
          and p.id_puntodeventa = rf.codpuntodeventa
          and e.tipoarchivo = 1
          and rf.codtiporegistro = 1
          and e.fechaarchivo >= @sFECHAFRST 
		  and e.fechaarchivo <= @sFECHALAST
          and rf.codproducto in (@P_ID_PRODUCTO)
      ) tmp
      group by 
        fechaarchivo, 
        suscriptor, 
        id_puntodeventa
      having count(*) > 1
    ) vw
  where rfr.codregistrofacturacion = rf.id_registrofacturacion
    and a.id_agrupacionpuntodeventa = p.codagrupacionpuntodeventa
    and c.id_ciudad = p.codciudad
    and tn.id_tiponegocio = p.codtiponegocio
    and c.coddepartamento = d.id_departamento
    and tp.id_tipopuntodeventa = a.codtipopuntodeventa
    and rg.id_regional = p.codregional
    and rf.codentradaarchivocontrol = e.id_entradaarchivocontrol
    and p.id_puntodeventa = rf.codpuntodeventa
    and vw.fechaarchivo = e.fechaarchivo
    and vw.suscriptor = rfr.suscriptor
    and vw.id_puntodeventa = rf.codpuntodeventa
    and e.tipoarchivo = 1
    and rf.codtiporegistro = 1
    and e.fechaarchivo >= @sFECHAFRST 
	and e.fechaarchivo <= @sFECHALAST
    and rf.codproducto in (@P_ID_PRODUCTO)
  order by 
    repeticiones, 
    suscriptor

END
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_FacturacionProcesa', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_FacturacionProcesa;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_FacturacionProcesa(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME) AS
 BEGIN
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @DIA, @sFECHAFRST OUT, @sFECHALAST OUT
      select nomaliadoestrategico      as Aliado,
             nomagrupacionproducto     as Padre,
             nomtipoproducto           as Linea,
             codigogtechproducto       as codigoproducto,
             nomproducto               as producto,
             P.CODIGOGTECHPUNTODEVENTA as codigopdv,
             p.nompuntodeventa         as nombrepdv,
             rfR.fechahoratransaccion  AS FECHAhoratx,
             rfR.recibo                as SPRNigt,
             rfR.suscriptor            AS processingcodeiso8583,
             rfR.valortransaccion      AS MONTO_RETIRADO,
             rfR.estado                as estadoigt,
             rfR.ARRN                  as arrnigt,
             RFR.BINTARJETA            AS BINCARD,
             rfr.respuestabanco        as ANSWERCODEiso8583
        from WSXML_SFG.registrofactreferencia rfR,
             WSXML_SFG.PUNTODEVENTA P,
             (select r.id_registrofacturacion,
                     R.CODPUNTODEVENTA,
                     pr.nomproducto,
                     pr.codigogtechproducto,
                     a.nomaliadoestrategico,
                     ap.nomagrupacionproducto,
                     tp.nomtipoproducto
                from WSXML_SFG.registrofacturacion r,
                     WSXML_SFG.producto            pr,
                     WSXML_SFG.aliadoestrategico   a,
                     WSXML_SFG.agrupacionproducto  ap,
                     WSXML_SFG.tipoproducto        tp
               where pr.codaliadoestrategico = a.id_aliadoestrategico
                 and a.id_aliadoestrategico = 708
                 and pr.codigogtechproducto not in ('999711', '999611')
                 and ap.id_agrupacionproducto = pr.codagrupacionproducto
                 and tp.id_tipoproducto = pr.codtipoproducto
                 and pr.id_producto = r.codproducto
                 and r.codentradaarchivocontrol in
                     (select e.id_entradaarchivocontrol
                        from WSXML_SFG.entradaarchivocontrol e
                       where e.tipoarchivo = 1
                         and e.fechaarchivo between @sFECHAFRST and @sFECHALAST)) RF
       where rfR.codregistrofacturacion = RF.id_registrofacturacion
         AND P.ID_PUNTODEVENTA = RF.CODPUNTODEVENTA
         and rfR.estado = 'A'
       order by rfr.id_registrofactreferencia;
  END;

GO

  
  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_ConsolmensualTxLogueoTerminal', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ConsolmensualTxLogueoTerminal;
go

create       PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ConsolmensualTxLogueoTerminal(@ID_DETALLETAREAEJEUTADA NUMERIC(22,0), 
                                      @DIA DATETIME,
                                      @pCODPRODUCTO NUMERIC(22,0))
  as
  begin 
    declare @sFECHAFRST DATETIME;
    declare @sFECHALAST DATETIME;
    declare @sWEEKDAY INT;
   
  set nocount on;
   EXEC  WSXML_SFG.SFG_PACKAGE_GetMonthRange @DIA, @sFECHAFRST OUT, @sFECHALAST OUT
	select fechaarchivo  as "Fecha Archivo", codigogtechpuntodeventa as "Numero PDV",
        nompuntodeventa as "Nombre PDV", suscriptor as "Numero Cedula", horas as "Horas", minutos as "Minutos", 
        totalminutos as "Total minutos", sum(numerotransacciones) as "Numero Transacciones", 
        sum(montoventa) as "Monto Venta" , nomregional as "Regional", ciudad as "Ciudad"
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
            left outer join (select case when codtiporegistro in (1,3) then sum(regf.numtransacciones) else 0 end as totaltx, 
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

END
GO


