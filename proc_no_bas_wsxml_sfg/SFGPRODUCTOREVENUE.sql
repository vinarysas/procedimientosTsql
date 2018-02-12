USE SFGPRODU;
--  DDL for Package Body SFGPRODUCTOREVENUE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPRODUCTOREVENUE */ 

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_FindProductEntry', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_FindProductEntry;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_FindProductEntry(@p_FECHA                  DATETIME,
                             @p_CODPRODUCTO            NUMERIC(22,0),
                             @p_CODPRODUCTOREVENUE_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    SELECT @p_CODPRODUCTOREVENUE_out = ID_PRODUCTOREVENUE FROM WSXML_SFG.PRODUCTOREVENUE
    WHERE FECHA = CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)) AND CODPRODUCTO = @p_CODPRODUCTO;
  
	IF @@ROWCOUNT = 0 BEGIN
    
		INSERT INTO WSXML_SFG.PRODUCTOREVENUE (
									 FECHA,
									 CODPRODUCTO)
		VALUES (
				CONVERT(DATETIME, CONVERT(DATE,@p_FECHA)),
				@p_CODPRODUCTO);
		SET @p_CODPRODUCTOREVENUE_out = SCOPE_IDENTITY();
	END

	IF @@ROWCOUNT > 1 BEGIN
		--WHEN TOO_MANY_ROWS THEN
		DECLARE @msg VARCHAR(2000) = '-20054 Error de consistencia. Hay multiples entradas para el mismo producto para la fecha ' + ISNULL(FORMAT(@p_FECHA, 'dd/MMM/yy'),'')
		RAISERROR(@msg, 16, 1);
	END
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_ClearProductEntry', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_ClearProductEntry;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_ClearProductEntry(@pk_ID_PRODUCTOREVENUE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PRODUCTOREVENUE SET REVENUE            = 0,
                               INGRESOCORPORATIVO = 0,
                               EGRESOCORPORATIVO  = 0,
                               INGRESOLOCAL       = 0,
                               EGRESOLOCAL        = 0
    WHERE ID_PRODUCTOREVENUE = @pk_ID_PRODUCTOREVENUE;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductEntry', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductEntry;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductEntry(@pk_ID_PRODUCTOREVENUE NUMERIC(22,0),
                               @p_REVENUE             FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PRODUCTOREVENUE SET REVENUE = REVENUE + @p_REVENUE
    WHERE ID_PRODUCTOREVENUE = @pk_ID_PRODUCTOREVENUE;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductPyG', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductPyG;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductPyG(@pk_ID_PRODUCTOREVENUE NUMERIC(22,0),
                             @p_INGRESOCORPORATIVO  FLOAT,
                             @p_EGRESOCORPORATIVO   FLOAT,
                             @p_INGRESOLOCAL        FLOAT,
                             @p_EGRESOLOCAL         FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PRODUCTOREVENUE SET INGRESOCORPORATIVO = INGRESOCORPORATIVO + @p_INGRESOCORPORATIVO,
                               EGRESOCORPORATIVO  = EGRESOCORPORATIVO  + @p_EGRESOCORPORATIVO,
                               INGRESOLOCAL       = INGRESOLOCAL       + @p_INGRESOLOCAL,
                               EGRESOLOCAL        = EGRESOLOCAL        + @p_EGRESOLOCAL
    WHERE ID_PRODUCTOREVENUE = @pk_ID_PRODUCTOREVENUE;
  END;
  GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalance', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalance;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalance(@p_CODPRODUCTO NUMERIC(22,0),
                              @p_FECHAINICIO DATETIME,
                              @p_FECHAFIN    DATETIME,
                              @p_page_number INTEGER,
                              @p_batch_size  INTEGER,
                             @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1) FROM WSXML_SFG.TIPOREGISTRO;
    END 
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    /* Obtener reglas de chequeo desde registro */
      SELECT TPR.NOMTIPOREGISTRO                                    AS NOMTIPOREGISTRO,
             ROUND(SUM(ISNULL(REG.NUMTRANSACCIONES, 0)), 6)            AS NUMTRANSACCIONES,
             ROUND(SUM(ISNULL(REG.VALORTRANSACCION, 0)), 6)            AS VALORTRANSACCION,
             ROUND(SUM(ISNULL(REG.VALORVENTABRUTANOREDONDEADO, 0)), 6) AS VALORVENTABRUTANOREDONDEADO, /* Ingresos con base en el importe son redondeo */
             ROUND(SUM(ISNULL(REG.VALORCOMISION, 0)), 6)               AS VALORCOMISIONPDV,            /* Metodo GetCalculatedValues obtiene este campo */
             ROUND(SUM(ISNULL(REV.REVENUETOTAL, 0)), 6)                AS REVENUETOTAL,
             ROUND(SUM(ISNULL(REV.VALORCOMISIONESTANDAR, 0)), 6)       AS VALORCOMISIONESTANDAR,
             ROUND(SUM(ISNULL(REV.INGRESOCORPORATIVO, 0)), 6)          AS INGRESOCORPORATIVO,          /* Solo los valores que son considerados actualmente */
             ROUND(SUM(ISNULL(REV.INGRESOLOCAL, 0)), 6)                AS INGRESOLOCAL,
             ROUND(SUM(ISNULL(REV.EGRESOLOCAL, 0)), 6)                 AS EGRESOLOCAL,
             ROUND(SUM(ISNULL(REV.UTILIDADPARCIAL, 0)), 6)             AS UTILIDADPARCIAL
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO             TPR ON (TPR.ID_TIPOREGISTRO          IN (1, 2, 3, 4))
      INNER JOIN WSXML_SFG.PRODUCTO                 PRD ON (PRD.ID_PRODUCTO              = @p_CODPRODUCTO)
      LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL
                                              AND REG.CODTIPOREGISTRO          = TPR.ID_TIPOREGISTRO
                                              AND REG.CODPRODUCTO              = PRD.ID_PRODUCTO)
      LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE     REV ON (REV.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL
                                              AND REV.CODREGISTROFACTURACION   = REG.ID_REGISTROFACTURACION)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND TIPOARCHIVO = @serviceID
      GROUP BY PRD.ID_PRODUCTO, ID_TIPOREGISTRO, TPR.NOMTIPOREGISTRO ORDER BY TPR.ID_TIPOREGISTRO;
  END;
GO

 IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceDetail', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceDetail;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceDetail(@p_CODPRODUCTO NUMERIC(22,0),
                                    @p_FECHAINICIO DATETIME,
                                    @p_FECHAFIN    DATETIME,
                                    @p_page_number INTEGER,
                                    @p_batch_size  INTEGER,
                                   @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @serviceID       NUMERIC(22,0);
    DECLARE @ServiceCostList WSXML_SFG.IDSTRINGVALUE;
    DECLARE @CostSubQuery    VARCHAR(MAX) = '';
    DECLARE @CostQueryHeader VARCHAR(MAX) = '';
    DECLARE @ContractList    WSXML_SFG.IDSTRINGVALUE;
    DECLARE @ContractQHeader VARCHAR(MAX) = '';
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1) FROM WSXML_SFG.TIPOREGISTRO;
    END 
     /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;

	INSERT INTO @ServiceCostList
    SELECT C.ID_COSTOCALCULADO, CASE WHEN LEN(C.NOMCOSTOCALCULADO) > 28 THEN SUBSTRING(C.NOMCOSTOCALCULADO, 1, 28) ELSE C.NOMCOSTOCALCULADO END
    FROM (
		SELECT ID_COSTOCALCULADO, RTRIM(LTRIM(SUBSTRING(NOMCOSTOCALCULADO, 1, CHARINDEX('(', NOMCOSTOCALCULADO) - 1))) NOMCOSTOCALCULADO, ORDEN, CODSERVICIO 
		FROM WSXML_SFG.COSTOCALCULADO
	) C WHERE C.CODSERVICIO = @serviceID ORDER BY C.ORDEN;
    
	INSERT INTO @ContractList 
	SELECT T.ID_TIPOCONTRATOPDV, CASE WHEN LEN(T.NOMTIPOCONTRATOPDV) > 28 THEN SUBSTRING(T.NOMTIPOCONTRATOPDV, 1, 28) ELSE T.NOMTIPOCONTRATOPDV END 
	FROM WSXML_SFG.TIPOCONTRATOPDV T ORDER BY T.ID_TIPOCONTRATOPDV;

    IF (SELECT COUNT(*) FROM @ServiceCostList) > 0 AND (SELECT COUNT(*) FROM @ContractList) > 0 BEGIN
      DECLARE icx CURSOR FOR SELECT ID, VALUE FROM @ServiceCostList--.First..ServiceCostList.Last LOOP

	  OPEN icx

	  DECLARE @icx__ID NUMERIC(38,0), @icx__VALUE NVARCHAR(2000)
	  FETCH NEXT FROM icx INTO @icx__ID,@icx__VALUE
	  WHILE (@@FETCH_STATUS = 0)
      BEGIN
			SET @CostSubQuery    = ISNULL(@CostSubQuery, '')    + ', SUM(CASE WHEN CODCOSTOCALCULADO = ' + CONVERT(VARCHAR,@icx__ID) + ' THEN VALORCOSTO END) AS COST' + ISNULL(dbo.lpad_numeric2(@icx__ID, 3,'0'),'');
			SET @CostQueryHeader = ISNULL(@CostQueryHeader, '') + ', ROUND(SUM(ISNULL(RCT.COST' + ISNULL(dbo.lpad_numeric2(@icx__ID, 3,'0'), '') + ', 0)), 6) AS "xb' + ISNULL(@icx__VALUE, '') + '"';
			FETCH NEXT FROM icx INTO @icx__ID,@icx__VALUE
	  END;
      CLOSE icx;
      DEALLOCATE icx;

	  

      DECLARE itx CURSOR FOR SELECT ID, VALUE FROM @ContractList--.First..ContractList.Last LOOP
	  OPEN itx
	  DECLARE @itx__ID NUMERIC(38,0), @itx__VALUE NVARCHAR(2000)
	  FETCH NEXT FROM itx INTO @itx__ID,@itx__VALUE

	  WHILE (@@FETCH_STATUS = 0) BEGIN
			SET @ContractQHeader = ISNULL(@ContractQHeader, '') + ', ROUND(SUM(CASE WHEN REG.CODTIPOCONTRATOPDV = ' + ISNULL(CONVERT(VARCHAR,@itx__ID), '') + ' THEN REG.VALORCOMISION ELSE 0 END), 6) AS "xb' + ISNULL(dbo.InitCap(@itx__VALUE),'') + '"';
			FETCH NEXT FROM itx INTO @itx__ID,@itx__VALUE
      END
      CLOSE itx;
      DEALLOCATE itx;

	  --SELECT @CostSubQuery, @CostQueryHeader, @ContractQHeader
    END
    ELSE BEGIN
      RAISERROR('-20083 No existe la lista de costos calculados para el servicio o no existen tipos de contrato configurados en el sistema.', 16, 1);
	  RETURN 0
    END 
    /* Obtener reglas de chequeo desde registro */
    SET @sql = 
      ' SELECT TPR.NOMTIPOREGISTRO                               AS "Tipo Registro" '     +
             ', ROUND(SUM(REG.NUMTRANSACCIONES), 6)              AS Tx '                +
             ', ROUND(SUM(REG.VALORTRANSACCION), 6)              AS Valor '             +
             ', ROUND(SUM(REG.VALORVENTABRUTANOREDONDEADO), 6)   AS "Valor Sin IVA" '     +
             ', ROUND(SUM(REG.VALORCOMISION), 6)                 AS "Comision POS" '      + ISNULL(@ContractQHeader, '') +
             ', ROUND(SUM(ISNULL(REV.REVENUETOTAL, 0)), 6)          AS "Revenue Bruto" '     +
             ', ROUND(SUM(ISNULL(REV.VALORCOMISIONESTANDAR, 0)), 6) AS "Comision Estandar" ' +
             ', ROUND(SUM(ISNULL(REV.INGRESOCORPORATIVO, 0)), 6)    AS "Ingreso Corp." '     +
             ', ROUND(SUM(ISNULL(REV.INGRESOLOCAL, 0)), 6)          AS "Ingreso Local" '     +
             ', ROUND(SUM(ISNULL(REV.EGRESOLOCAL, 0)), 6)           AS "Costo de Venta" '    + ISNULL(@CostQueryHeader, '') +
             ', ROUND(SUM(ISNULL(CASE WHEN AJS.AJUSTES_CASTIGO <>0 THEN  ROUND(REG.VALORTRANSACCION, 6)  ELSE 0 END , 0)), 6)          AS "Castigo Ajuste" '  +
             ', ROUND(SUM(ISNULL(CASE WHEN AJS.AJUSTES_NO_CASTIGO <>0 THEN  REV.REVENUETOTAL ELSE 0 END , 0)), 6)                AS "No Castigo Ajuste" '  +
             ', ROUND(SUM(ISNULL(REV.UTILIDADPARCIAL, 0)), 6)       AS "Utilidad Parcial" '  +
      ' FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR ' +
      ' INNER JOIN WSXML_SFG.TIPOREGISTRO             TPR ON (TPR.ID_TIPOREGISTRO          IN (1, 2, 3, 4)) '               +
      ' INNER JOIN WSXML_SFG.PRODUCTO                 PRD ON (PRD.ID_PRODUCTO              = ' + ISNULL(CONVERT(VARCHAR,@p_CODPRODUCTO), '') + ') '     +
      ' LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL ' +
      '                                         AND REG.CODTIPOREGISTRO          = TPR.ID_TIPOREGISTRO '          +
      '                                         AND REG.CODPRODUCTO              = PRD.ID_PRODUCTO) '             +
      ' LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE     REV ON (REV.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL ' +
      '                                         AND REV.CODREGISTROFACTURACION   = REG.ID_REGISTROFACTURACION) '  +
      '  LEFT OUTER JOIN (                                                                                        '  +
      '                    SELECT CODREGISTROFACTDESTINO AS  CODREGISTROFACTURACION,                              '  +
      '                           SUM(CASE WHEN AJUSTECASTIGADO = 1 THEN VALORAJUSTE ELSE 0 END)  AS AJUSTES_CASTIGO, '  +
      '                           SUM(CASE WHEN AJUSTECASTIGADO = 2 THEN VALORAJUSTE ELSE 0 END)  AS AJUSTES_NO_CASTIGO '  +
      '                    FROM WSXML_SFG.AJUSTEFACTURACION                                                                 '  +
      '                    GROUP BY CODREGISTROFACTDESTINO                                                        '  +
      '                    ) AJS ON AJS.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION                       '  +
      ' LEFT OUTER JOIN (SELECT CODREGISTROREVENUE' + ISNULL(@CostSubQuery, '') +
      '                  FROM WSXML_SFG.REGISTROREVCOSTOCALCULADO GROUP BY CODREGISTROREVENUE) RCT ON (RCT.CODREGISTROREVENUE = REV.ID_REGISTROREVENUE)' +
      ' WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,''' + ISNULL(FORMAT(@p_FECHAINICIO, 'dd/MM/yyyy'), '') + ''')) AND CONVERT(DATETIME, CONVERT(DATE,''' + ISNULL(FORMAT(@p_FECHAFIN, 'dd/MM/yyyy'), '') + ''')) AND TIPOARCHIVO = ' + ISNULL(CONVERT(VARCHAR,@serviceID), '') +
      ' GROUP BY PRD.ID_PRODUCTO, ID_TIPOREGISTRO, TPR.NOMTIPOREGISTRO ORDER BY TPR.ID_TIPOREGISTRO';
    EXECUTE sp_executesql @sql;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceDaily', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceDaily;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceDaily(@p_CODPRODUCTO NUMERIC(22,0),
                                   @p_FECHAINICIO DATETIME,
                                   @p_FECHAFIN    DATETIME,
                                   @p_page_number INTEGER,
                                   @p_batch_size  INTEGER,
                                  @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1) FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE TIPOARCHIVO = @serviceID AND FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND REVERSADO = 0;
    END 
    /* Obtener reglas de chequeo desde registro */
      SELECT 'xc' + ISNULL(WSXML_SFG.SFGPRODUCTOREVENUE_GeneralDateFormat(CTR.FECHAARCHIVO), '')            AS Fecha,
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                            AS Tipo,
             ROUND(SUM(ISNULL(REG.NUMTRANSACCIONES, 0)), 6)            AS Tx,
             ROUND(SUM(ISNULL(REG.VALORVENTABRUTANOREDONDEADO, 0)), 6) AS "Valor Sin IVA",
             'xc' + ISNULL(CONVERT(VARCHAR, RCM.NOMRANGOCOMISION), '')                  AS "Tarifa Aplicada",
             ROUND(SUM(ISNULL(REV.REVENUETOTAL, 0)), 6)                AS "Revenue Bruto"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO        TPR ON (TPR.ID_TIPOREGISTRO          IN (1, 2))
      INNER JOIN WSXML_SFG.PRODUCTO            PRD ON (PRD.ID_PRODUCTO              = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL
                                         AND REG.CODTIPOREGISTRO          = TPR.ID_TIPOREGISTRO
                                         AND REG.CODPRODUCTO              = PRD.ID_PRODUCTO)
      INNER JOIN WSXML_SFG.REGISTROREVENUE     REV ON (REV.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL
                                         AND REV.CODREGISTROFACTURACION   = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.RANGOCOMISION       RCM ON (RCM.ID_RANGOCOMISION         = REV.CODRANGOCOMISION)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY CTR.FECHAARCHIVO, PRD.ID_PRODUCTO, TPR.ID_TIPOREGISTRO, TPR.NOMTIPOREGISTRO, RCM.ID_RANGOCOMISION, RCM.NOMRANGOCOMISION
      ORDER BY CTR.FECHAARCHIVO, TPR.ID_TIPOREGISTRO, RCM.ID_RANGOCOMISION;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceRanks', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceRanks;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceRanks(@p_CODPRODUCTO NUMERIC(22,0),
                                   @p_FECHAINICIO DATETIME,
                                   @p_FECHAFIN    DATETIME,
                                   @p_page_number INTEGER,
                                   @p_batch_size  INTEGER,
                                  @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
      SELECT ISNULL(CASE WHEN RCT.RANGOINICIAL = 0 THEN '>= ' ELSE '> ' END, '') + ISNULL(RCT.RANGOINICIAL, '')      AS Desde,
             CASE WHEN ISNULL(RCT.RANGOFINAL, 0) = 0 THEN 'N/A' ELSE '<= ' + ISNULL(RCT.RANGOFINAL, '') END AS Hasta,
             RCT.VALORPORCENTUAL                                                              AS "Tarifa %",
             RCT.VALORTRANSACCIONAL                                                           AS "Tarifa X",
             ROUND(SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN 1 WHEN CODTIPOREGISTRO = 2 THEN -1 ELSE 0 END), 6)                           AS Tx,
             ROUND(SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN RTX.REVENUE WHEN CODTIPOREGISTRO = 2 THEN RTX.REVENUE * (-1) ELSE 0 END), 6) AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.REGISTROREVENUETRANSACCION RTX ON (RTX.CODREGISTROREVENUE       = REV.ID_REGISTROREVENUE)
      INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE       RCT ON (RCT.CODRANGOCOMISION         = REV.CODRANGOCOMISION
                                                AND RCT.ID_RANGOCOMISIONDETALLE  = RTX.CODRANGOCOMISIONDETALLE)
      WHERE CTR.REVERSADO = 0 AND CTR.TIPOARCHIVO = @serviceID AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND REV.CODPRODUCTO = @p_CODPRODUCTO
      GROUP BY RTX.CODRANGOCOMISIONDETALLE, RCT.RANGOINICIAL, RCT.RANGOFINAL, RCT.VALORPORCENTUAL, RCT.VALORTRANSACCIONAL
      ORDER BY RCT.RANGOINICIAL;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceChain', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceChain;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceChain(@p_CODPRODUCTO NUMERIC(22,0),
                                   @p_FECHAINICIO DATETIME,
                                   @p_FECHAFIN    DATETIME,
                                   @p_page_number INTEGER,
                                   @p_batch_size  INTEGER,
                                  @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
      SELECT /*CTR.FECHAARCHIVO                         AS Fecha,*/
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                    AS Tipo,
             AGR.NOMAGRUPACIONPUNTODEVENTA                  AS Cadena,
             'xc' + ISNULL(CONVERT(VARCHAR, RCM.NOMRANGOCOMISION), '')          AS "Tarifa Aplicada",
             ROUND(SUM(REG.NUMTRANSACCIONES), 6)            AS Tx,
             ROUND(SUM(REG.VALORVENTABRUTANOREDONDEADO), 6) AS Valor,
             ROUND(SUM(ISNULL(INC.DISTRIBUCIONINGRESO, 0)), 6) AS "Distribucion Fijo",
             ROUND(SUM(REV.REVENUETOTAL), 6)                AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (1 = 1)
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODTIPOREGISTRO           = TPR.ID_TIPOREGISTRO
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA     AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA = REG.CODAGRUPACIONPUNTODEVENTA)
      INNER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = REV.CODRANGOCOMISION)
      LEFT OUTER JOIN (SELECT CODREGISTROREVENUE, SUM(REVENUE) AS DISTRIBUCIONINGRESO FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
                       GROUP BY CODREGISTROREVENUE) INC ON (INC.CODREGISTROREVENUE = ID_REGISTROREVENUE)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY /*CTR.FECHAARCHIVO,*/
               TPR.ID_TIPOREGISTRO,
               TPR.NOMTIPOREGISTRO,
               RCM.ID_RANGOCOMISION,
               RCM.NOMRANGOCOMISION,
               AGR.CODIGOAGRUPACIONGTECH,
               AGR.NOMAGRUPACIONPUNTODEVENTA
      ORDER BY /*CTR.FECHAARCHIVO, */ TPR.ID_TIPOREGISTRO, CAST(AGR.CODIGOAGRUPACIONGTECH AS NUMERIC(38,0));
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceNetwork', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceNetwork;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceNetwork(@p_CODPRODUCTO NUMERIC(22,0),
                                     @p_FECHAINICIO DATETIME,
                                     @p_FECHAFIN    DATETIME,
                                     @p_page_number INTEGER,
                                     @p_batch_size  INTEGER,
                                    @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
      SELECT /*CTR.FECHAARCHIVO                         AS Fecha,*/
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                    AS Tipo,
             RED.NOMREDPDV                                  AS Red,
             'xc' + ISNULL(CONVERT(VARCHAR, RCM.NOMRANGOCOMISION), '')          AS "Tarifa Aplicada",
             ROUND(SUM(REG.NUMTRANSACCIONES), 6)            AS Tx,
             ROUND(SUM(REG.VALORVENTABRUTANOREDONDEADO), 6) AS Valor,
             ROUND(SUM(ISNULL(INC.DISTRIBUCIONINGRESO, 0)), 6) AS "Distribucion Fijo",
             ROUND(SUM(REV.REVENUETOTAL), 6)                AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (1 = 1)
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODTIPOREGISTRO           = TPR.ID_TIPOREGISTRO
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.REDPDV                     RED ON (RED.ID_REDPDV                 = REG.CODREDPDV)
      INNER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = REV.CODRANGOCOMISION)
      LEFT OUTER JOIN (SELECT CODREGISTROREVENUE, SUM(REVENUE) AS DISTRIBUCIONINGRESO FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
                       GROUP BY CODREGISTROREVENUE) INC ON (INC.CODREGISTROREVENUE = ID_REGISTROREVENUE)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY /*CTR.FECHAARCHIVO,*/
               TPR.ID_TIPOREGISTRO,
               TPR.NOMTIPOREGISTRO,
               RCM.ID_RANGOCOMISION,
               RCM.NOMRANGOCOMISION,
               RED.ID_REDPDV,
               RED.NOMREDPDV
      ORDER BY /*CTR.FECHAARCHIVO, */ TPR.ID_TIPOREGISTRO, RED.ID_REDPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstate', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstate;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstate (@p_CODPRODUCTO NUMERIC(22,0),
                                     @p_FECHAINICIO DATETIME,
                                     @p_FECHAFIN    DATETIME,
                                     @p_page_number INTEGER,
                                     @p_batch_size  INTEGER,
                                    @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
      SELECT /*CTR.FECHAARCHIVO                         AS Fecha,*/
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                    AS Tipo,
             DTO.NOMDEPARTAMENTO                            AS Departamento,
             'xc' + ISNULL(CONVERT(VARCHAR, RCM.NOMRANGOCOMISION), '')          AS "Tarifa Aplicada",
             ROUND(SUM(REG.NUMTRANSACCIONES), 6)            AS Tx,
             ROUND(SUM(REG.VALORVENTABRUTANOREDONDEADO), 6) AS Valor,
             ROUND(SUM(ISNULL(INC.DISTRIBUCIONINGRESO, 0)), 6) AS "Distribucion Fijo",
             ROUND(SUM(REV.REVENUETOTAL), 6)                AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (1 = 1)
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODTIPOREGISTRO           = TPR.ID_TIPOREGISTRO
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.PUNTODEVENTA               PDV ON (PDV.ID_PUNTODEVENTA           = REG.CODPUNTODEVENTA)
      INNER JOIN WSXML_SFG.CIUDAD                     CIU ON (CIU.ID_CIUDAD                 = REG.CODCIUDAD)
      INNER JOIN WSXML_SFG.DEPARTAMENTO               DTO ON (DTO.ID_DEPARTAMENTO           = CIU.CODDEPARTAMENTO)
      INNER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = REV.CODRANGOCOMISION)
      LEFT OUTER JOIN (SELECT CODREGISTROREVENUE, SUM(REVENUE) AS DISTRIBUCIONINGRESO FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
                       GROUP BY CODREGISTROREVENUE) INC ON (INC.CODREGISTROREVENUE = ID_REGISTROREVENUE)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY /*CTR.FECHAARCHIVO,*/
               TPR.ID_TIPOREGISTRO,
               TPR.NOMTIPOREGISTRO,
               RCM.ID_RANGOCOMISION,
               RCM.NOMRANGOCOMISION,
               DTO.ID_DEPARTAMENTO,
               DTO.NOMDEPARTAMENTO
      ORDER BY /*CTR.FECHAARCHIVO, */ TPR.ID_TIPOREGISTRO, DTO.ID_DEPARTAMENTO;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstatePremios', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstatePremios;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstatePremios (@p_CODPRODUCTO NUMERIC(22,0),
                                     @p_FECHAINICIO DATETIME,
                                     @p_FECHAFIN    DATETIME,
                                     @p_page_number INTEGER,
                                     @p_batch_size  INTEGER,
                                    @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
      SELECT /*CTR.FECHAARCHIVO                         AS Fecha,*/
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                    AS Tipo,
             DTO.NOMDEPARTAMENTO                            AS Departamento,
             --'xc' || TO_CHAR(RCM.NOMRANGOCOMISION)          AS Tarifa Aplicada,
             ROUND(SUM(REG.NUMTRANSACCIONES), 6)            AS Tx,
             ROUND(SUM(REG.VALORTRANSACCION), 6) AS "Valor Premios",
             ROUND(SUM(REG.RETENCIONPREMIO), 6) AS "Valor Retencion Premios"
             --ROUND(SUM(NVL(INC.DISTRIBUCIONINGRESO, 0)), 6) AS "Distribucion Fijo",
             --ROUND(SUM(REV.REVENUETOTAL), 6)                AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.PUNTODEVENTA               PDV ON (PDV.ID_PUNTODEVENTA           = REG.CODPUNTODEVENTA)
      INNER JOIN WSXML_SFG.CIUDAD                     CIU ON (CIU.ID_CIUDAD                 = PDV.CODCIUDAD)
      INNER JOIN WSXML_SFG.DEPARTAMENTO               DTO ON (DTO.ID_DEPARTAMENTO           = CIU.CODDEPARTAMENTO)
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (TPR.ID_TIPOREGISTRO           = REG.CODTIPOREGISTRO)
--      INNER JOIN REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
--                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
--      INNER JOIN RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = REV.CODRANGOCOMISION)
--      LEFT OUTER JOIN (SELECT CODREGISTROREVENUE, SUM(REVENUE) AS DISTRIBUCIONINGRESO FROM REGISTROREVENUEINCENTIVO
--                       GROUP BY CODREGISTROREVENUE) INC ON (INC.CODREGISTROREVENUE = ID_REGISTROREVENUE)
      WHERE TPR.ID_TIPOREGISTRO = 4 AND CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY /*CTR.FECHAARCHIVO,*/
               TPR.ID_TIPOREGISTRO,
               TPR.NOMTIPOREGISTRO,
--               RCM.ID_RANGOCOMISION,
--               RCM.NOMRANGOCOMISION,
               DTO.ID_DEPARTAMENTO,
               DTO.NOMDEPARTAMENTO
      ORDER BY /*CTR.FECHAARCHIVO, */ TPR.ID_TIPOREGISTRO, DTO.ID_DEPARTAMENTO;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstateCity', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstateCity;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstateCity (@p_CODPRODUCTO NUMERIC(22,0),
                                     @p_FECHAINICIO DATETIME,
                                     @p_FECHAFIN    DATETIME,
                                     @p_page_number INTEGER,
                                     @p_batch_size  INTEGER,
                                    @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
       SELECT /*CTR.FECHAARCHIVO                         AS Fecha,*/
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                    AS Tipo,
             DTO.NOMDEPARTAMENTO                            AS Departamento,
             CIU.NOMCIUDAD                                  AS Ciudad,
             'xc' + ISNULL(CONVERT(VARCHAR, RCM.NOMRANGOCOMISION), '')          AS "Tarifa Aplicada",
             ROUND(SUM(REG.NUMTRANSACCIONES), 6)            AS Tx,
             ROUND(SUM(REG.VALORVENTABRUTANOREDONDEADO), 6) AS Valor,
             ROUND(SUM(ISNULL(INC.DISTRIBUCIONINGRESO, 0)), 6) AS "Distribucion Fijo",
             ROUND(SUM(REV.REVENUETOTAL), 6)                AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (1 = 1)
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODTIPOREGISTRO           = TPR.ID_TIPOREGISTRO
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.PUNTODEVENTA               PDV ON (PDV.ID_PUNTODEVENTA           = REG.CODPUNTODEVENTA)
      INNER JOIN WSXML_SFG.CIUDAD                     CIU ON (CIU.ID_CIUDAD                 = PDV.CODCIUDAD)
      INNER JOIN WSXML_SFG.DEPARTAMENTO               DTO ON (DTO.ID_DEPARTAMENTO           = CIU.CODDEPARTAMENTO)
      INNER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = REV.CODRANGOCOMISION)
      LEFT OUTER JOIN (SELECT CODREGISTROREVENUE, SUM(REVENUE) AS DISTRIBUCIONINGRESO FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
                       GROUP BY CODREGISTROREVENUE) INC ON (INC.CODREGISTROREVENUE = ID_REGISTROREVENUE)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY /*CTR.FECHAARCHIVO,*/
               TPR.ID_TIPOREGISTRO,
               TPR.NOMTIPOREGISTRO,
               RCM.ID_RANGOCOMISION,
               RCM.NOMRANGOCOMISION,
               DTO.ID_DEPARTAMENTO,
               DTO.NOMDEPARTAMENTO,
               CIU.ID_CIUDAD,
               CIU.NOMCIUDAD
      ORDER BY /*CTR.FECHAARCHIVO, */ TPR.ID_TIPOREGISTRO, DTO.ID_DEPARTAMENTO, CIU.ID_CIUDAD;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstateCityPre', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstateCityPre;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceEstateCityPre (@p_CODPRODUCTO NUMERIC(22,0),
                                     @p_FECHAINICIO DATETIME,
                                     @p_FECHAFIN    DATETIME,
                                     @p_page_number INTEGER,
                                     @p_batch_size  INTEGER,
                                    @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
       SELECT /*CTR.FECHAARCHIVO                         AS Fecha,*/
             'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                    AS Tipo,
             DTO.NOMDEPARTAMENTO                            AS Departamento,
             CIU.NOMCIUDAD                                  AS Ciudad,
--             'xc' || TO_CHAR(RCM.NOMRANGOCOMISION)          AS Tarifa Aplicada,
             ROUND(SUM(REG.NUMTRANSACCIONES), 6)            AS Tx,
             ROUND(SUM(REG.VALORTRANSACCION), 6) AS "Valor Premios",
             ROUND(SUM(REG.RETENCIONPREMIO), 6) AS "Valor Retencion Premios"
--             ROUND(SUM(NVL(INC.DISTRIBUCIONINGRESO, 0)), 6) AS Distribucion Fijo,
--             ROUND(SUM(REV.REVENUETOTAL), 6)                AS Valor Revenue
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (TPR.ID_TIPOREGISTRO       = REG.CODTIPOREGISTRO           )
      INNER JOIN WSXML_SFG.PUNTODEVENTA               PDV ON (PDV.ID_PUNTODEVENTA           = REG.CODPUNTODEVENTA)
      INNER JOIN WSXML_SFG.CIUDAD                     CIU ON (CIU.ID_CIUDAD                 = PDV.CODCIUDAD)
      INNER JOIN WSXML_SFG.DEPARTAMENTO               DTO ON (DTO.ID_DEPARTAMENTO           = CIU.CODDEPARTAMENTO)
--      INNER JOIN REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
--                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
--      INNER JOIN RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = REV.CODRANGOCOMISION)
--      LEFT OUTER JOIN (SELECT CODREGISTROREVENUE, SUM(REVENUE) AS DISTRIBUCIONINGRESO FROM REGISTROREVENUEINCENTIVO
--                       GROUP BY CODREGISTROREVENUE) INC ON (INC.CODREGISTROREVENUE = ID_REGISTROREVENUE)
      WHERE TPR.ID_TIPOREGISTRO = 4 AND CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY /*CTR.FECHAARCHIVO,*/
               TPR.ID_TIPOREGISTRO,
               TPR.NOMTIPOREGISTRO,
--               RCM.ID_RANGOCOMISION,
--               RCM.NOMRANGOCOMISION,
               DTO.ID_DEPARTAMENTO,
               DTO.NOMDEPARTAMENTO,
               CIU.ID_CIUDAD,
               CIU.NOMCIUDAD
      ORDER BY /*CTR.FECHAARCHIVO, */ TPR.ID_TIPOREGISTRO, DTO.ID_DEPARTAMENTO, CIU.ID_CIUDAD;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceTransactFee', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceTransactFee;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODUCTOREVENUE_GetProductBalanceTransactFee(@p_CODPRODUCTO NUMERIC(22,0),
                                         @p_FECHAINICIO DATETIME,
                                         @p_FECHAFIN    DATETIME,
                                         @p_page_number INTEGER,
                                         @p_batch_size  INTEGER,
                                        @p_total_size  INTEGER OUT) AS
 BEGIN
   DECLARE @serviceID NUMERIC(22,0);
   
  SET NOCOUNT ON;
    /* Obtener servicio del producto para filtrar el rango de archivos */
    SELECT @serviceID = CODSERVICIO FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODTIPOPRODUCTO = ID_TIPOPRODUCTO AND CODLINEADENEGOCIO = ID_LINEADENEGOCIO AND ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = 1;
    END 
      SELECT 'xc' + ISNULL(TPR.NOMTIPOREGISTRO, '')                        AS Tipo,
             'xc' + ISNULL(CONVERT(VARCHAR, RCM.NOMRANGOCOMISION), '')              AS "Tarifa Aplicada",
             ROUND(COUNT(RRT.ID_REGISTROREVENUETRANSACCION), 6) AS Tx,
             ROUND(SUM(RFR.VALORTRANSACCION), 6)                AS "Valor Transacciones",
             ROUND(SUM(RRT.REVENUE), 6)                         AS "Valor Revenue"
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.TIPOREGISTRO               TPR ON (1 = 1)
      INNER JOIN WSXML_SFG.REGISTROFACTURACION        REG ON (REG.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REG.CODTIPOREGISTRO           = TPR.ID_TIPOREGISTRO
                                                AND REG.CODPRODUCTO               = @p_CODPRODUCTO)
      INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA     RFR ON (RFR.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.REGISTROREVENUE            REV ON (REV.CODENTRADAARCHIVOCONTROL  = CTR.ID_ENTRADAARCHIVOCONTROL
                                                AND REV.CODREGISTROFACTURACION    = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.REGISTROREVENUETRANSACCION RRT ON (RRT.CODREGISTROREVENUE        = REV.ID_REGISTROREVENUE
                                                AND RRT.CODREGISTROFACTREFERENCIA = RFR.ID_REGISTROFACTREFERENCIA)
      INNER JOIN WSXML_SFG.RANGOCOMISION              RCM ON (RCM.ID_RANGOCOMISION          = RRT.CODRANGOCOMISION)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND CTR.TIPOARCHIVO = @serviceID
      GROUP BY TPR.ID_TIPOREGISTRO, TPR.NOMTIPOREGISTRO, RCM.ID_RANGOCOMISION, RCM.NOMRANGOCOMISION
      ORDER BY TPR.ID_TIPOREGISTRO, RCM.ID_RANGOCOMISION;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPRODUCTOREVENUE_GeneralDateFormat', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGPRODUCTOREVENUE_GeneralDateFormat;
GO

CREATE     FUNCTION WSXML_SFG.SFGPRODUCTOREVENUE_GeneralDateFormat(@d DATETIME) RETURNS VARCHAR(4000) AS
 BEGIN
    DECLARE @s VARCHAR(MAX);
    
	DECLARE @MONTH VARCHAR(50) = WSXML_SFG.DATMONTHNAME(@d)
    RETURN FORMAT(@d, 'dd') + ' ' + RTRIM(LTRIM(dbo.INITCAP(@MONTH))) + ' ' + FORMAT(@d, 'yyyy');
    
  END;

GO


