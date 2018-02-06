USE SFGPRODU;
--  DDL for Package Body SFGINF_BASECERTIFICADOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_BASECERTIFICADOS */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_BASECERTIFICADOS_GetJuegosData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BASECERTIFICADOS_GetJuegosData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BASECERTIFICADOS_GetJuegosData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @pg_CADENA                NVARCHAR(2000),
                          @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                         @pg_PRODUCTO              NVARCHAR(2000)
                          ) AS
 BEGIN
    DECLARE @p_FECHA  DATETIME;
    DECLARE @firstDAY DATETIME;
    DECLARE @lastDAY  DATETIME;
   
  SET NOCOUNT ON;
    SELECT @p_FECHA = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    --SFG_PACKAGE.GetMonthRange(@p_FECHA, @firstDAY, @lastDAY);
     /*  SELECT PRF.CODIGO                  AS Compania,
             PRF.CODTIPOCONTRATOPDV      AS TipoContratoPDV,
             PRF.CODTIPOCONTRATOPRODUCTO AS TipoContratoProducto,
             CDA.CIUDADDANE              AS CiudadAliado,
             PRF.CODIGOAGRUPACIONGTECH   AS Chain,
             PRF.CODREGIMEN              AS Regimen,
             CD.CIUDADDANE               AS Ciudad,
             PRF.CODIGOGTECHPUNTODEVENTA AS POS,
             PRF.NUMEROTERMINAL          AS Term,
             PRF.CODIGOGTECHPRODUCTO     AS Prd,
             LDN.NOMLINEADENEGOCIO       AS LDN,
             PRD.NOMPRODUCTO             AS Product,
             RSC.IDENTIFICACION || '-' || RSC.DIGITOVERIFICACION AS NIT,
             -- Valores
             SUM(NumIngresos)                 AS CantidadIngresos,
             SUM(Ingresos)                    AS Ingresos,
             SUM(NumAnulaciones)              AS CantidadAnulaciones,
             SUM(Anulaciones)                 AS Anulaciones,
             SUM(IngresosValidos)             AS IngresosValidos,
             SUM(IvaProducto)                 AS IvaProducto,
             SUM(IngresosBrutos)              AS IngresosBrutos,
             SUM(Comision)                    AS ComisionCalculada,
             SUM(ComisionAnticipo)            AS AnticipoCalculado,
             SUM(IVAComision)                 AS IVAComision,
             SUM(ComisionBruta)               AS ComisionBruta,
             SUM(ReteUVT + ReteFuente)        AS ReteFuente,
             SUM(ReteIVA)                     AS ReteIVA,
             SUM(ReteICA)                     AS ReteICA,
             SUM(ComisionNeta)                AS ComisionNeta,
             SUM(PremiosPagados)              AS PremiosPagados,
             SUM(IngresosValidos - ComisionNeta - PremiosPagados) AS ValorAPagar
      FROM VW_PREFACTURACION_DIARIA PRF
      INNER JOIN CIUDAD                 CD  ON (CD.ID_CIUDAD             = PRF.CODCIUDAD)
      INNER JOIN PRODUCTO               PRD ON (PRD.ID_PRODUCTO          = PRF.CODPRODUCTO)
      INNER JOIN PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO          = PRD.ID_PRODUCTO)
      INNER JOIN ALIADOESTRATEGICO      AES ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
      INNER JOIN CIUDAD                 CDA ON (CDA.ID_CIUDAD            = AES.CODCIUDAD)
      INNER JOIN LINEADENEGOCIO         LDN ON (LDN.ID_LINEADENEGOCIO    = PRF.CODLINEADENEGOCIO)
      INNER JOIN RANGOCOMISION          RCM ON (PRF.CODRANGOCOMISION     = RCM.ID_RANGOCOMISION)
      INNER JOIN PUNTODEVENTA           PDV ON (PDV.ID_PUNTODEVENTA       = PRF.CODPUNTODEVENTA)
      INNER JOIN RAZONSOCIAL            RSC ON (RSC.ID_RAZONSOCIAL        = PDV.CODRAZONSOCIAL)
      WHERE PRF.FECHAARCHIVO BETWEEN firstDAY AND lastDAY AND PRF.TIPOARCHIVO = 2
        AND PRF.CODTIPOCONTRATOPDV = 3
      GROUP BY PRF.CODIGO, PRF.CODTIPOCONTRATOPDV, PRF.CODTIPOCONTRATOPRODUCTO, CDA.CIUDADDANE,
               PRF.CODIGOAGRUPACIONGTECH, PRF.CODREGIMEN, CD.CIUDADDANE, PRF.CODIGOGTECHPUNTODEVENTA,
               PRF.NUMEROTERMINAL, PRF.CODIGOGTECHPRODUCTO, LDN.NOMLINEADENEGOCIO, PRD.NOMPRODUCTO, RSC.IDENTIFICACION, RSC.DIGITOVERIFICACION
      ORDER BY TO_NUMBER(PRF.CODIGOAGRUPACIONGTECH), TO_NUMBER(PRF.CODIGOGTECHPUNTODEVENTA), TO_NUMBER(PRF.CODIGOGTECHPRODUCTO);*/


select       PRF.CODIGO                       AS Compania,
             PRF.CODTIPOCONTRATOPDV           AS TipoContratoPDV,
             PRF.CODTIPOCONTRATOPRODUCTO      AS TipoContratoProducto,
             CDA.CIUDADDANE                   AS CiudadAliado,
             PRF.CODIGOAGRUPACIONGTECH        AS Chain,
             PRF.CODREGIMEN                   AS Regimen,
             CD.CIUDADDANE                    AS Ciudad,
             PRF.CODIGOGTECHPRODUCTO          AS Prd,
             LDN.NOMLINEADENEGOCIO            AS LDN,
             PRD.NOMPRODUCTO                  AS Product,
             ISNULL(CONVERT(VARCHAR,PRF.IDENTIFICACION), '') + '-' + ISNULL(CONVERT(VARCHAR,PRF.DIGITOVERIFICACION), '')               AS NIT,
             SUM(NumIngresos)                 AS CantidadIngresos,
             SUM(Ingresos)                    AS Ingresos,
             SUM(NumAnulaciones)              AS CantidadAnulaciones,
             SUM(Anulaciones)                 AS Anulaciones,
             SUM(IngresosValidos)             AS IngresosValidos,
             SUM(IvaProducto)                 AS IvaProducto,
             sum(isnull(Descuentos, 0))          as Descuentos,
             SUM(IngresosBrutos)              AS IngresosBrutos,
             SUM(Comision)                    AS ComisionCalculada,
             SUM(ComisionAnticipo)            AS AnticipoCalculado,
             SUM(IVAComision)                 AS IVAComision,
             SUM(ComisionBruta)               AS ComisionBruta,
             SUM(ReteUVT + ReteFuente)        AS ReteFuente,
             SUM(ReteIVA)                     AS ReteIVA,
             SUM(ReteICA)                     AS ReteICA,
             SUM(ReteCREE)                    AS ReteCREE,
             SUM(ComisionNeta)                AS ComisionNeta,
             SUM(PremiosPagados)              AS PremiosPagados,
             SUM(IngresosValidos - ComisionNeta - PremiosPagados) AS ValorAPagar
            from WSXML_SFG.VW_PREFACTURACION_DIARIA PRF
           INNER JOIN WSXML_SFG.CIUDAD                 CD  ON (CD.ID_CIUDAD             = PRF.CODCIUDAD)
           INNER JOIN WSXML_SFG.PRODUCTO               PRD ON (PRD.ID_PRODUCTO          = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO          = PRD.ID_PRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO      AES ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.CIUDAD                 CDA ON (CDA.ID_CIUDAD            = AES.CODCIUDAD)
           INNER JOIN WSXML_SFG.LINEADENEGOCIO         LDN ON (LDN.ID_LINEADENEGOCIO    = PRF.CODLINEADENEGOCIO)
           INNER JOIN WSXML_SFG.RANGOCOMISION          RCM ON (PRF.CODRANGOCOMISION     = RCM.ID_RANGOCOMISION)
      WHERE PRF.FECHAARCHIVO BETWEEN @firstDAY AND @lastDAY AND PRF.TIPOARCHIVO = 2
        AND PRF.CODTIPOCONTRATOPDV = 3
      GROUP BY PRF.CODIGO, PRF.IDENTIFICACION, PRF.DIGITOVERIFICACION, PRF.CODTIPOCONTRATOPDV, PRF.CODTIPOCONTRATOPRODUCTO, CDA.CIUDADDANE,
               PRF.CODIGOAGRUPACIONGTECH, PRF.CODIGOGTECHPRODUCTO, PRF.CODREGIMEN, CD.CIUDADDANE, LDN.NOMLINEADENEGOCIO,
               PRD.NOMPRODUCTO
      ORDER BY CAST(PRF.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0)), CAST(PRF.CODIGOGTECHPRODUCTO AS NUMERIC(38,0));
  END;
  GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_BASECERTIFICADOS_GetSCData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BASECERTIFICADOS_GetSCData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BASECERTIFICADOS_GetSCData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @pg_CADENA                NVARCHAR(2000),
                      @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                     @pg_PRODUCTO              NVARCHAR(2000)
                      ) AS
 BEGIN
    DECLARE @p_FECHA  DATETIME;
    DECLARE @firstDAY DATETIME;
    DECLARE @lastDAY  DATETIME;
   
  SET NOCOUNT ON;
    SELECT @p_FECHA = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    --SFG_PACKAGE.GetMonthRange(@p_FECHA, @firstDAY, @lastDAY);
      SELECT PRF.CODIGO                  AS Compania,
             PRF.CODTIPOCONTRATOPDV      AS TipoContratoPDV,
             PRF.CODTIPOCONTRATOPRODUCTO AS TipoContratoProducto,
             CDA.CIUDADDANE              AS CiudadAliado,
             AGP.NOMAGRUPACIONPRODUCTO   AS Padre,
             PRF.CODIGOAGRUPACIONGTECH   AS Chain,
             PRF.CODREGIMEN              AS Regimen,
             CD.CIUDADDANE               AS Ciudad,
             PRF.CODIGOGTECHPUNTODEVENTA AS POS,
             PRF.NUMEROTERMINAL          AS Term,
             PRF.CODIGOGTECHPRODUCTO     AS Prd,
             LDN.NOMLINEADENEGOCIO       AS LDN,
             PRD.NOMPRODUCTO             AS Product,
             ISNULL(CONVERT(VARCHAR,PRF.IDENTIFICACION), '') + '-' + ISNULL(CONVERT(VARCHAR,PRF.DIGITOVERIFICACION), '') AS NIT,
             SUM(NumIngresos - NumAnulaciones)   AS CantidadIngresos,
             SUM(IngresosValidos)                AS IngresosValidos,
             sum(isnull(Descuentos, 0))             as Descuentos,
             SUM(Comision)                       AS ComisionCalculada,
             SUM(IVAComision)                    AS IVAComision,
             SUM(ComisionBruta)                  AS ComisionBruta,
             SUM(ReteUVT + ReteFuente)           AS ReteFuente,
             SUM(ReteIVA)                        AS ReteIVA,
             SUM(ReteICA)                        AS ReteICA,
             SUM(ReteCREE)                       AS ReteCREE,
             SUM(ComisionNeta)                   AS ComisionNeta,
             SUM(IngresosValidos - ComisionNeta) AS ValorAPagar
      FROM WSXML_SFG.VW_PREFACTURACION_DIARIA PRF
      INNER JOIN WSXML_SFG.CIUDAD                 CD  ON (CD.ID_CIUDAD              = PRF.CODCIUDAD)
      INNER JOIN WSXML_SFG.PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO)
      INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
      INNER JOIN WSXML_SFG.PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO           = PRD.ID_PRODUCTO)
      INNER JOIN WSXML_SFG.ALIADOESTRATEGICO      AES ON (AES.ID_ALIADOESTRATEGICO  = PRD.CODALIADOESTRATEGICO)
      INNER JOIN WSXML_SFG.CIUDAD                 CDA ON (CDA.ID_CIUDAD             = AES.CODCIUDAD)
      INNER JOIN WSXML_SFG.LINEADENEGOCIO         LDN ON (LDN.ID_LINEADENEGOCIO     = PRF.CODLINEADENEGOCIO)
      WHERE PRF.FECHAARCHIVO BETWEEN @firstDAY AND @lastDAY AND PRF.TIPOARCHIVO = 1
        AND PRF.CODTIPOCONTRATOPDV = 3
      GROUP BY PRF.CODIGO, PRF.CODTIPOCONTRATOPDV, PRF.CODTIPOCONTRATOPRODUCTO, CDA.CIUDADDANE,
               AGP.NOMAGRUPACIONPRODUCTO, PRF.CODIGOAGRUPACIONGTECH, PRF.CODREGIMEN, CD.CIUDADDANE, PRF.CODIGOGTECHPUNTODEVENTA,
               PRF.NUMEROTERMINAL, PRF.CODIGOGTECHPRODUCTO, LDN.NOMLINEADENEGOCIO, PRD.NOMPRODUCTO, PRF.IDENTIFICACION, PRF.DIGITOVERIFICACION
      ORDER BY CAST(PRF.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0)), CAST(PRF.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0)), CAST(PRF.CODIGOGTECHPRODUCTO AS NUMERIC(38,0));
  END;
GO
