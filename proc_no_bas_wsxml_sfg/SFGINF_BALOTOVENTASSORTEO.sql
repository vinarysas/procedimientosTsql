USE SFGPRODU;
--  DDL for Package Body SFGINF_BALOTOVENTASSORTEO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_BALOTOVENTASSORTEO */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetSemanalHeaders', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetSemanalHeaders;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetSemanalHeaders(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @xFECHASORTEOM DATETIME;
    DECLARE @xFECHASORTEOS DATETIME;
    DECLARE @xNUMBRSORTEOM NUMERIC(22,0);
    DECLARE @xNUMBRSORTEOS NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @xFECHASORTEOS = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    SET @xFECHASORTEOM = CONVERT(DATETIME, CONVERT(DATE,@xFECHASORTEOS - 3));
    SET @xNUMBRSORTEOM = WSXML_SFG.SFG_PACKAGE_GetLastSorteoNumber(@xFECHASORTEOM + 1);
    SET @xNUMBRSORTEOS = WSXML_SFG.SFG_PACKAGE_GetLastSorteoNumber(@xFECHASORTEOS + 1);
      SELECT 1 AS ORDEN,
             @xNUMBRSORTEOM                                        AS NOMBRE,
             'SFGINF_BALOTOVENTASSORTEO.GetVentasSorteoMiercoles' AS PROCEDURENAME,
             @p_CODCICLOFACTURACIONPDV                             AS ID_CICLOFACTURACIONPDV
      UNION
      SELECT 2 AS ORDEN,
             @xNUMBRSORTEOS                                        AS NOMBRE,
             'SFGINF_BALOTOVENTASSORTEO.GetVentasSorteoSabado'    AS PROCEDURENAME,
             @p_CODCICLOFACTURACIONPDV                             AS ID_CICLOFACTURACIONPDV
      ORDER BY ORDEN DESC;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteoMiercoles', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteoMiercoles;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteoMiercoles(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                     @pg_CADENA                NVARCHAR(2000),
                                     @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                    @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @xFECHASORTEOM DATETIME;
    DECLARE @xFECHASORTEOS DATETIME;
    DECLARE @xNUMBRSORTEOM NUMERIC(22,0);
    DECLARE @currentSORTEODATE DATETIME;
    DECLARE @prviousSORTEODATE DATETIME;
   
  SET NOCOUNT ON;
    SELECT @xFECHASORTEOS = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    SET @xFECHASORTEOM = CONVERT(DATETIME, CONVERT(DATE,@xFECHASORTEOS - 3));
    SET @xNUMBRSORTEOM = WSXML_SFG.SFG_PACKAGE_GetLastSorteoNumber(@xFECHASORTEOM + 1);
    SET @currentSORTEODATE = @xFECHASORTEOM;
    SET @prviousSORTEODATE = WSXML_SFG.SFG_PACKAGE_GetDateFromSorteo(@xNUMBRSORTEOM - 1);
      SELECT @xNUMBRSORTEOM                                                                                         AS SORTEO,
             CDA.CIUDADDANE                                                                                         AS CIUDADDANE,
             CDA.NOMCIUDAD                                                                                          AS NOMCIUDAD,
             CTR.FECHAARCHIVO                                                                                       AS FECHAARCHIVO,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                      AS NUMINGRESOSVALIDOS,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                      AS INGRESOSVALIDOS
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.CIUDAD              CDA ON (CDA.ID_CIUDAD                = REG.CODCIUDAD)
      LEFT OUTER JOIN (SELECT CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO,
                              SUM(CANTIDADAJUSTE)              AS CANTIDADAJUSTE,
                              SUM(VALORAJUSTE)                 AS VALORAJUSTE
                       FROM WSXML_SFG.AJUSTEFACTURACION
                       WHERE CODTIPOAJUSTEFACTURACION = 1
                       GROUP BY CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO) AFC ON (AFC.CODENTRADAARCHIVODESTINO  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                                                      AND AFC.CODREGISTROFACTDESTINO    = REG.ID_REGISTROFACTURACION)
      WHERE CTR.FECHAARCHIVO BETWEEN @prviousSORTEODATE + 1 AND @currentSORTEODATE
        AND CTR.TIPOARCHIVO = 2
        AND REG.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10002)
      GROUP BY CTR.FECHAARCHIVO, CDA.ID_CIUDAD, CDA.NOMCIUDAD, CDA.CIUDADDANE
      ORDER BY CDA.CIUDADDANE, CTR.FECHAARCHIVO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteoSabado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteoSabado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteoSabado(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                  @pg_CADENA                NVARCHAR(2000),
                                  @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                 @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @xFECHASORTEOS DATETIME;
    DECLARE @xNUMBRSORTEOS NUMERIC(22,0);
    DECLARE @currentSORTEODATE DATETIME;
    DECLARE @prviousSORTEODATE DATETIME;
   
  SET NOCOUNT ON;
    SELECT @xFECHASORTEOS = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    SET @xNUMBRSORTEOS = WSXML_SFG.SFG_PACKAGE_GetLastSorteoNumber(@xFECHASORTEOS + 1);
    SET @currentSORTEODATE = @xFECHASORTEOS;
    SET @prviousSORTEODATE = WSXML_SFG.SFG_PACKAGE_GetDateFromSorteo(@xNUMBRSORTEOS - 1);
      SELECT @xNUMBRSORTEOS                                                                                         AS SORTEO,
             CDA.CIUDADDANE                                                                                         AS CIUDADDANE,
             CDA.NOMCIUDAD                                                                                          AS NOMCIUDAD,
             CTR.FECHAARCHIVO                                                                                       AS FECHAARCHIVO,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                      AS NUMINGRESOSVALIDOS,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                      AS INGRESOSVALIDOS
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.CIUDAD              CDA ON (CDA.ID_CIUDAD                = REG.CODCIUDAD)
      LEFT OUTER JOIN (SELECT CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO,
                              SUM(CANTIDADAJUSTE)              AS CANTIDADAJUSTE,
                              SUM(VALORAJUSTE)                 AS VALORAJUSTE
                       FROM WSXML_SFG.AJUSTEFACTURACION
                       WHERE CODTIPOAJUSTEFACTURACION = 1
                       GROUP BY CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO) AFC ON (AFC.CODENTRADAARCHIVODESTINO  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                                                      AND AFC.CODREGISTROFACTDESTINO    = REG.ID_REGISTROFACTURACION)
      WHERE CTR.FECHAARCHIVO BETWEEN @prviousSORTEODATE + 1 AND @currentSORTEODATE
        AND CTR.TIPOARCHIVO = 2
        AND REG.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10002)
      GROUP BY CTR.FECHAARCHIVO, CDA.ID_CIUDAD, CDA.NOMCIUDAD, CDA.CIUDADDANE
      ORDER BY CDA.CIUDADDANE, CTR.FECHAARCHIVO;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasSorteo(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                            @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                            @pg_CADENA                NVARCHAR(2000),
                            @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                           @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @currentSORTEO NUMERIC(22,0);
    DECLARE @currentSORTEODATE DATETIME;
    DECLARE @prviousSORTEODATE DATETIME;
   
  SET NOCOUNT ON;
    -- Ignore all parameters, use date from SYSDATE
    SELECT @currentSORTEO = WSXML_SFG.SFG_PACKAGE_GetLastSorteoNumber(GETDATE());
    SET @currentSORTEODATE = WSXML_SFG.SFG_PACKAGE_GetDateFromSorteo(@currentSORTEO);
    SET @prviousSORTEODATE = WSXML_SFG.SFG_PACKAGE_GetDateFromSorteo(@currentSORTEO - 1);
    print 'Invoked Ventas Sorteo ' + ISNULL(FORMAT(@currentSORTEODATE, 'dd/MM/yyyy'), '') + ' and ' + ISNULL(FORMAT(@prviousSORTEODATE, 'dd/MM/yyyy'), '');
      SELECT @currentSORTEO                                                                                          AS SORTEO,
             CDA.CIUDADDANE                                                                                         AS CIUDADDANE,
             CDA.NOMCIUDAD                                                                                          AS NOMCIUDAD,
             CTR.FECHAARCHIVO                                                                                       AS FECHAARCHIVO,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                                              AS NUMINGRESOSVALIDOS,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                                              AS INGRESOSVALIDOS
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.CIUDAD              CDA ON (CDA.ID_CIUDAD                = REG.CODCIUDAD)
      LEFT OUTER JOIN (SELECT CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO,
                              SUM(CANTIDADAJUSTE)              AS CANTIDADAJUSTE,
                              SUM(VALORAJUSTE)                 AS VALORAJUSTE
                       FROM WSXML_SFG.AJUSTEFACTURACION
                       WHERE CODTIPOAJUSTEFACTURACION = 1
                       GROUP BY CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO) AFC ON (AFC.CODENTRADAARCHIVODESTINO  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                                                      AND AFC.CODREGISTROFACTDESTINO    = REG.ID_REGISTROFACTURACION)
      WHERE CTR.FECHAARCHIVO BETWEEN @prviousSORTEODATE + 1 AND @currentSORTEODATE
        AND CTR.TIPOARCHIVO = 2
        AND REG.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10002)
      GROUP BY CTR.FECHAARCHIVO, CDA.ID_CIUDAD, CDA.NOMCIUDAD, CDA.CIUDADDANE
      ORDER BY CDA.CIUDADDANE, CTR.FECHAARCHIVO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasMensualesPorPunto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasMensualesPorPunto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_BALOTOVENTASSORTEO_GetVentasMensualesPorPunto(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                       @pg_CADENA                NVARCHAR(2000),
                                       @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                      @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @sFECHACCLO DATETIME;
    DECLARE @sFECHAFRST DATETIME;
    DECLARE @sFECHALAST DATETIME;
   
  SET NOCOUNT ON;
    SELECT @sFECHACCLO = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @sFECHACCLO, @sFECHAFRST OUT, @sFECHALAST OUT
      SELECT PDV.CODIGOGTECHPUNTODEVENTA                                                    AS CODIGOGTECHPUNTODEVENTA,
             PDV.NUMEROTERMINAL                                                             AS NUMEROTERMINAL,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.NUMTRANSACCIONES - ISNULL(AFC.CANTIDADAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                      AS NUMINGRESOSVALIDOS,
             ROUND(SUM(CASE WHEN REG.CODTIPOREGISTRO IN (1, 3)
                            THEN REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)
                            WHEN REG.CODTIPOREGISTRO = 2
                            THEN (REG.VALORTRANSACCION - ISNULL(AFC.VALORAJUSTE, 0)) * (-1)
                       ELSE 0 END), 6)                                                      AS INGRESOSVALIDOS
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN  WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN  WSXML_SFG.PUNTODEVENTA        PDV ON (PDV.ID_PUNTODEVENTA          = REG.CODPUNTODEVENTA)
      LEFT OUTER JOIN (SELECT CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO,
                              SUM(CANTIDADAJUSTE)              AS CANTIDADAJUSTE,
                              SUM(VALORAJUSTE)                 AS VALORAJUSTE
                       FROM WSXML_SFG.AJUSTEFACTURACION
                       WHERE CODTIPOAJUSTEFACTURACION = 1
                       GROUP BY CODENTRADAARCHIVODESTINO, CODREGISTROFACTDESTINO) AFC ON (AFC.CODENTRADAARCHIVODESTINO  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                                                      AND AFC.CODREGISTROFACTDESTINO    = REG.ID_REGISTROFACTURACION)
      WHERE CTR.FECHAARCHIVO BETWEEN @sFECHAFRST AND @sFECHALAST
        AND CTR.TIPOARCHIVO = 2
        AND REG.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10002)
      GROUP BY PDV.CODIGOGTECHPUNTODEVENTA, PDV.NUMEROTERMINAL ORDER BY CAST(PDV.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0));
  END;
GO

