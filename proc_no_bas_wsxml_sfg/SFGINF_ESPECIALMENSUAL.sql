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

  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_VentasDiariasDenominacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_VentasDiariasDenominacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_VentasDiariasDenominacion(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                      @pg_CADENA                NVARCHAR(2000),
                                      @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                     @pg_PRODUCTO              NVARCHAR(2000)
                                      ) AS
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensual', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensual;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensual(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                      @DIA                      DATETIME
                       ) AS
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensualNoMasivo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensualNoMasivo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_ATHMensualNoMasivo(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                              @DIA                      DATETIME
                               ) AS

GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_ESPECIALMENSUAL_RecaudoFraccionado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_RecaudoFraccionado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_ESPECIALMENSUAL_RecaudoFraccionado(@ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                               @DIA                      DATETIME,
                              @p_ID_PRODUCTO            NUMERIC(22,0)
                               ) AS
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
GO

