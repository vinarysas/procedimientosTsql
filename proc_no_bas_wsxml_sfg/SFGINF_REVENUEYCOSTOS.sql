USE SFGPRODU;
--  DDL for Package Body SFGINF_REVENUEYCOSTOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_REVENUEYCOSTOS */ 


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyBreakInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyBreakInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyBreakInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                @pg_CADENA                NVARCHAR(2000),
                                @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
           
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC           
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHACCLO
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO;

  END;
  GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                           @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                           @pg_CADENA                NVARCHAR(2000),
                           @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                           @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

          --- Flujo Normal

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(ISNULL(IvaProducto, 0)) AS IVAPRODUCTO,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
               
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
           
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(PRF.CASTIGO_AJUSTES) AS CASTIGO_AJUSTES,
           SUM(PRF.NO_CASTIGO_AJUSTES) AS NO_CASTIGO_AJUSTES,
           SUM(PRF.AJUSTES_NO_APLICA) AS AJUSTES_NO_APLICA,
           SUM(UtilidadParcial) AS UTILIDADPARCIAL,
           SUM(PRF.COMISIONPOS) AS COMISIONPOS,
           SUM(PRF.GTECH_OPERACION) AS GTECH_OPERACION,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC           
            FROM WSXML_SFG.VW_REVENUE_DIARIO PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO;

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyCummulativeInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyCummulativeInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyCummulativeInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                      @pg_CADENA                NVARCHAR(2000),
                                      @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                      @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

        --- Flujo Normal

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(ISNULL(IvaProducto, 0)) AS IVAPRODUCTO,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,           
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
           
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
           
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(PRF.CASTIGO_AJUSTES) AS CASTIGO_AJUSTES,
           SUM(PRF.NO_CASTIGO_AJUSTES) AS NO_CASTIGO_AJUSTES,
           SUM(PRF.AJUSTES_NO_APLICA) AS AJUSTES_NO_APLICA,
           SUM(UtilidadParcial) AS UTILIDADPARCIAL,
           SUM(PRF.COMISIONPOS) AS COMISIONPOS,
           SUM(PRF.GTECH_OPERACION) AS GTECH_OPERACION,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND--TRUNC(@sFECHAFRST, 'YYYY') AND
                 @sFECHALAST
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO;



  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyBreakNetworkInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyBreakNetworkInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyBreakNetworkInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                       @pg_CADENA                NVARCHAR(2000),
                                       @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                       @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

        --- Flujo Normal

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           RED.NOMREDPDV AS RED,
           ISNULL(PRF.TIPO_DIFERENCIAL, 0) AS TIPO_DIFERENCIAL,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,           
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
               
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
           
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           INNER JOIN WSXML_SFG.REDPDV RED
              ON (RED.ID_REDPDV = PRF.CODREDPDV)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHACCLO
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO,
                    RED.NOMREDPDV,
                    ISNULL(PRF.TIPO_DIFERENCIAL, 0)
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    RED.NOMREDPDV;


  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyNetworkInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyNetworkInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyNetworkInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                  @pg_CADENA                NVARCHAR(2000),
                                  @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                  @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
     EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

        --- Flujo Normal

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           RED.NOMREDPDV AS RED,
           ISNULL(PRF.TIPO_DIFERENCIAL, 0) AS TIPO_DIFERENCIAL,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(ISNULL(IvaProducto, 0)) AS IVAPRODUCTO,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
           
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
           
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(PRF.CASTIGO_AJUSTES) AS CASTIGO_AJUSTES,
           SUM(PRF.NO_CASTIGO_AJUSTES) AS NO_CASTIGO_AJUSTES,
           SUM(AJUSTES_NO_APLICA) AS AJUSTES_NO_APLICA ,
           SUM(UtilidadParcial) AS UTILIDADPARCIAL,
           SUM(PRF.COMISIONPOS) AS COMISIONPOS,
           SUM(PRF.GTECH_OPERACION) AS GTECH_OPERACION,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC           
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           INNER JOIN WSXML_SFG.REDPDV RED
              ON (RED.ID_REDPDV = PRF.CODREDPDV)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO,
                    RED.NOMREDPDV,
                    ISNULL(PRF.TIPO_DIFERENCIAL, 0)
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    RED.NOMREDPDV;


  END;
  GO



  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyCummulatvNetworkInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyCummulatvNetworkInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyCummulatvNetworkInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                           @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                           @pg_CADENA                NVARCHAR(2000),
                                           @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                           @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT


          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           RED.NOMREDPDV AS RED,
           ISNULL(PRF.TIPO_DIFERENCIAL, 0) AS TIPO_DIFERENCIAL,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(ISNULL(IvaProducto, 0)) AS IVAPRODUCTO,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,           
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
           
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,    
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
           
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(PRF.CASTIGO_AJUSTES) AS CASTIGO_AJUSTES,
           SUM(PRF.NO_CASTIGO_AJUSTES) AS NO_CASTIGO_AJUSTES,
           SUM(AJUSTES_NO_APLICA) AS AJUSTES_NO_APLICA,
           SUM(UtilidadParcial) AS UTILIDADPARCIAL,
           SUM(PRF.COMISIONPOS) AS COMISIONPOS,
           SUM(PRF.GTECH_OPERACION) AS GTECH_OPERACION,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC           
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           INNER JOIN WSXML_SFG.REDPDV RED
              ON (RED.ID_REDPDV = PRF.CODREDPDV)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND--TRUNC(@sFECHAFRST, 'YYYY') AND
                 @sFECHALAST
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO,
                    RED.NOMREDPDV,
                    ISNULL(PRF.TIPO_DIFERENCIAL, 0)
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    RED.NOMREDPDV;

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyChainInclusiveInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyChainInclusiveInfo;
GO


CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyChainInclusiveInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                         @pg_CADENA                NVARCHAR(2000),
                                         @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                         @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,           
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
            
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,    
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
               
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(UtilidadParcial) AS UTILIDADPARCIAL,
           SUM(PRF.COMISIONPOS) AS COMISIONPOS,
           SUM(PRF.GTECH_OPERACION) AS GTECH_OPERACION,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
             AND PRF.CODAGRUPACIONPUNTODEVENTA = WSXML_SFG.AGRUPACION_F(@pg_CADENA)
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO;


  END;
  GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyChainExclusiveInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyChainExclusiveInfo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_REVENUEYCOSTOS_GetMonthlyChainExclusiveInfo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                         @pg_CADENA                NVARCHAR(2000),
                                         @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                         @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT

        --- Flujo Normal

          SELECT
           AES.NOMALIADOESTRATEGICO AS ALIADO,
           AGP.NOMAGRUPACIONPRODUCTO AS PADRE,
           PRD.CODIGOGTECHPRODUCTO AS CODIGOPRODUCTO,
           PRD.NOMPRODUCTO AS SUBPRODUCTO,
           SUM(NumIngresos - NumAnulaciones) AS CANTIDADINGRESOS,
           SUM(isnull(PRF.DESCUENTOS, 0)) AS DESCUENTOS,
           SUM(IngresosBrutos) AS INGRESOS,
           SUM(RevenueBase) AS REVENUBASE,
           SUM(RevenueTransaccion) AS RANGOS,
           SUM(RevenueFijo) AS FIJO,
           SUM(RevenueTotal) AS REVENUETOTAL,
           SUM(IngresoCorporativo) AS INGCORPORATIVO,
           SUM(PRF.DESCUENTOVIAMOVIL) AS DESCUENTOVIAMOVIL,           
           SUM(IngresoLocal) AS INGLOCAL,
           SUM(IVAINGRESO) AS IVAINGRESO,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  Comision
                 ELSE
                  0
               END) AS INGRESOPDVCOLAB,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV IN (1, 2) THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVADMIN,
           SUM(CASE
                 WHEN PRF.CODTIPOCONTRATOPDV = 3 THEN
                  IvaComision
                 ELSE
                  0
               END) AS IVAINGRESOPDVCOLAB,
               
           SUM(PRF.COSTOSINBIOMETRIA) AS COSTOSINBIOMETRIA,    
           SUM(PRF.COSTOCONBIOMETRIA) AS COSTOCONBIOMETRIA,
           SUM(PRF.COSTOSINBIOMETRIACONSULTA) AS COSTOSINBIOMETRIACONSULTA,
           SUM(PRF.COSTODATACREDITO) AS COSTODATACREDITO,
               
           SUM(EgresoLocal) AS COSTOVENTA,
           SUM(CostoICA) AS ICA,
           SUM(CostoEtesa) AS COMISIONETESA,
           SUM(CostoIC) AS IC,
           SUM(CostoICAIC) AS ICAIC,
           SUM(CostoBadDebt) AS BADDEBT,
           SUM(CostoMercadeoVenta + CostoMercadeoRevenue) AS MERCADEO,
           SUM(CostoIvaNoDescontable) AS IVANODESC,
           SUM(CostoIC108) AS IC108,
           SUM(CostoICAIC108) AS ICAIC108,
           SUM(CostoIC213) AS IC213,
           SUM(CostoICAIC213) AS ICAIC213,
           SUM(UtilidadParcial) AS UTILIDADPARCIAL,
           SUM(PRF.COMISIONPOS) AS COMISIONPOS,
           SUM(PRF.GTECH_OPERACION) AS GTECH_OPERACION,
           SUM(CostoMINTIC) AS MINTIC,           
           SUM(CostoCRC) AS CRC           
            FROM (select * from WSXML_SFG.VW_REVENUE_DIARIO) PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES
              ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
             AND PRF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
             AND PRF.CODAGRUPACIONPUNTODEVENTA <> WSXML_SFG.AGRUPACION_F(@pg_CADENA)
           GROUP BY AES.NOMALIADOESTRATEGICO,
                    AGP.NOMAGRUPACIONPRODUCTO,
                    PRD.CODIGOGTECHPRODUCTO,
                    PRD.NOMPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO, PRD.CODIGOGTECHPRODUCTO;

  END;
  GO


