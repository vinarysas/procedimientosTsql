USE SFGPRODU;
--  DDL for Package Body SFGINF_LIQUIDACIONES
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_LIQUIDACIONES */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_LIQUIDACIONES_GetSpecialElementList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_LIQUIDACIONES_GetSpecialElementList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_LIQUIDACIONES_GetSpecialElementList(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                  @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                  @pg_PRODUCTO              NVARCHAR(2000),
                                  @pg_REDPDV                NVARCHAR(2000),
                                 @pg_CADENA                NVARCHAR(2000)
                                  ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_LIQUIDACIONELEMENTO AS ID, DESCRIPCIONELEMENTO AS DESCRIPCION FROM WSXML_SFG.LIQUIDACIONELEMENTO
      WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV AND CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO);
  END;
  GO
  

  IF OBJECT_ID('WSXML_SFG.SFGINF_LIQUIDACIONES_GetNetworkOwnerData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_LIQUIDACIONES_GetNetworkOwnerData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_LIQUIDACIONES_GetNetworkOwnerData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                @pg_PRODUCTO              NVARCHAR(2000),
                                @pg_REDPDV                NVARCHAR(2000),
                                @pg_CADENA                NVARCHAR(2000),
                                @p_cur varchar(8000)  OUTPUT) AS
 BEGIN
    DECLARE @LiquidacionElements WSXML_SFG.IDSTRINGVALUE;
    DECLARE @LiquidacionID       VARCHAR(MAX) = '';
    DECLARE @LiquidacionHeader   VARCHAR(MAX) = '';
    DECLARE @xidRed    NUMERIC(22,0) = WSXML_SFG.RED_F(@pg_REDPDV);
    DECLARE @xidCadena NUMERIC(22,0) = WSXML_SFG.AGRUPACION_F(@pg_CADENA);
    DECLARE @sql NVARCHAR(MAX);
   
  SET NOCOUNT ON;
	INSERT INTO @LiquidacionElements
    SELECT ID_LIQUIDACIONELEMENTO, DESCRIPCIONELEMENTO 
	FROM WSXML_SFG.LIQUIDACIONELEMENTO
    WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV AND CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO);
    IF @@ROWCOUNT > 0 BEGIN
      DECLARE ix CURSOR FOR SELECT ID, VALUE FROM @LiquidacionElements--.First..LiquidacionElements.Last LOOP
	  OPEN ix
	  WHILE @@FETCH_STATUS=0 
	  BEGIN
		  DECLARE @ix__ID NUMERIC(38,0), @ix__VALUE NVARCHAR(2000)
		  FETCH NEXT FROM ix INTO @ix__ID, @ix__VALUE
	  
			SET @LiquidacionID = ISNULL(@LiquidacionID, '') + ISNULL(@ix__ID, '') + ',';
			SET @LiquidacionHeader = ISNULL(@LiquidacionHeader, '') + ', "' + ISNULL(@ix__ID, '') + '" AS "_' + ISNULL(@ix__ID, '') + '"';
			FETCH NEXT FROM ix INTO @ix__ID, @ix__VALUE
      END;
      CLOSE ix;
      DEALLOCATE ix;
      SET @LiquidacionID = SUBSTRING(@LiquidacionID, 1, LEN(@LiquidacionID) - 1);
    END 
    -- Obtain taxes accordingly
    SET @sql = 
      'SELECT ISNULL(CANTIDAD, 0)               AS CANTIDAD, ' +
             'ISNULL(VENTAS, 0)                 AS VENTAS, ' +
             'ISNULL(IVAPRODUCTONOROUND, 0)     AS IVAPRODUCTONOROUND, ' +
             'ISNULL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED, ' +
             'ISNULL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR, ' +
             'ISNULL(VENTASBRUTASNOROUND, 0)    AS VENTASBRUTASNOROUND, ' +
             'ISNULL(COMISION, 0)               AS COMISION, ' +
             'ISNULL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO, ' +
             'ISNULL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED, ' +
             'ISNULL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR, ' +
             'ISNULL(REVENUETOTAL, 0) * (-1)    AS REVENUETOTAL, ' +
             'ISNULL(IVAREVENUE, 0) * (-1)      AS IVAREVENUE, ' +
             'ISNULL(RETEFTEREVENUE, 0)         AS RETEFTEREVENUE, ' +
             'ISNULL(RETEICAREVENUE, 0)         AS RETEICAREVENUE, ' +
             'ISNULL(RETEIVAREVENUE, 0)         AS RETEIVAREVENUE, ' +
             'ISNULL(REVENUETOTAL + IVAREVENUE - (RETEFTEREVENUE + RETEICAREVENUE + RETEIVAREVENUE), 0) * (-1) AS REVENUENETO, ' +
             'ISNULL(PREMIOSPAGADOS, 0) * (-1)  AS PREMIOSPAGADOS, ' +
             'ISNULL(PREMIOSRED, 0) * (-1)      AS PREMIOSRED, ' +
             'ISNULL(PREMIOSCADENA, 0) * (-1)   AS PREMIOSCADENA, ' +
             'ISNULL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO, ' +
             'ISNULL(VENTAS - REVENUETOTAL - IVAREVENUE + RETEFTEREVENUE - COMISIONANTICIPO - PREMIOSRED, 0) + ISNULL(TOTALELEMENTVALUE, 0)                       AS LIQUIDACIONRED, ' +
             'ISNULL(VENTAS - REVENUETOTAL - IVAREVENUE + RETEFTEREVENUE - COMISIONANTICIPO - (PREMIOSPAGADOS - PREMIOSCADENA), 0) + ISNULL(TOTALELEMENTVALUE, 0) AS LIQUIDACIONCADENA ' +
             ISNULL(@LiquidacionHeader, '') +
      'FROM (SELECT ROUND(SUM(PRF.NUMINGRESOS - PRF.NUMANULACIONES), 0)               AS CANTIDAD, ' +
                   'ROUND(SUM(PRF.INGRESOSVALIDOS), 0)                                AS VENTAS, ' +
                   'ROUND(SUM(PRF.INGRESOSVALIDOS - PRF.INGRESOSBRUTOSNOREDONDEO), 0) AS IVAPRODUCTONOROUND, ' +
                   'ROUND(SUM(CASE WHEN PRF.CODREDPDV =  ' + ISNULL(@xidRed, '') + ' THEN PRF.INGRESOSBRUTOSNOREDONDEO ELSE 0 END), 0) AS VENTASBRUTASNOROUNDRED, ' +
                   'ROUND(SUM(CASE WHEN PRF.CODREDPDV <> ' + ISNULL(@xidRed, '') + ' THEN PRF.INGRESOSBRUTOSNOREDONDEO ELSE 0 END), 0) AS VENTASBRUTASNOROUNDOTR, ' +
                   'ROUND(SUM(PRF.INGRESOSBRUTOSNOREDONDEO), 0)                       AS VENTASBRUTASNOROUND, ' +
                   'ROUND(SUM(PRF.COMISION), 0)                                       AS COMISION, ' +
                   'ROUND(SUM(PRF.COMISIONANTICIPO), 0)                               AS COMISIONANTICIPO, ' +
                   'ROUND(SUM(CASE WHEN PRF.CODREDPDV =  ' + ISNULL(@xidRed, '') + ' THEN PRF.REVENUETOTAL ELSE 0 END), 0)             AS REVENUETOTALRED, ' +
                   'ROUND(SUM(CASE WHEN PRF.CODREDPDV <> ' + ISNULL(@xidRed, '') + ' THEN PRF.REVENUETOTAL ELSE 0 END), 0)             AS REVENUETOTALOTR, ' +
                   'ROUND(SUM(PRF.REVENUETOTAL), 0)                                   AS REVENUETOTAL, ' +
                   'ROUND(SUM(PRF.REVENUETOTAL * VAT.VALORVAT), 0)                    AS IVAREVENUE, ' +
                   'ROUND(SUM(PRF.REVENUETOTAL * RET.RETEFUENTE), 0)                  AS RETEFTEREVENUE, ' +
                   'ROUND(SUM(PRF.REVENUETOTAL * RET.RETEICA), 0)                     AS RETEICAREVENUE, ' +
                   'ROUND(SUM(PRF.REVENUETOTAL * RET.RETEIVA), 0)                     AS RETEIVAREVENUE, ' +
                   'ROUND(SUM(PRF.PREMIOSPAGADOS), 0)                                 AS PREMIOSPAGADOS, ' +
                   'ROUND(SUM(CASE WHEN PRF.CODREDPDV = ' + ISNULL(@xidRed, '') + ' THEN PRF.PREMIOSPAGADOS ELSE 0 END), 0)                AS PREMIOSRED, ' +
                   'ROUND(SUM(CASE WHEN PRF.CODAGRUPACIONPUNTODEVENTA = ' + ISNULL(@xidCadena, '') + ' THEN PREMIOSPAGADOS ELSE 0 END), 0) AS PREMIOSCADENA ' +
            'FROM WSXML_SFG.VW_PREFACTURACION_REVENUE PRF ' +
            'INNER JOIN WSXML_SFG.REDPDV RED ON (PRF.CODREDPDV = RED.ID_REDPDV) ' +
            'LEFT OUTER JOIN WSXML_SFG.PRODUCTO               PRD ON (PRD.ID_PRODUCTO            = PRF.CODPRODUCTO) ' +
            'LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO  = PRD.CODAGRUPACIONPRODUCTO) ' +
            'LEFT OUTER JOIN WSXML_SFG.PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO            = PRF.CODPRODUCTO) ' +
            'LEFT OUTER JOIN (SELECT CODCOMPANIA, CODREGIMEN, (ISNULL(MAX(VALORVAT), 0) / 100) AS VALORVAT ' +
                             'FROM WSXML_SFG.VATCOMISIONREGIMEN ' +
                             'GROUP BY CODCOMPANIA, CODREGIMEN) VAT ON (VAT.CODCOMPANIA = PRD.CODCOMPANIA AND VAT.CODREGIMEN = 5) ' +
            'LEFT OUTER JOIN (SELECT CODCOMPANIA, CODREGIMEN, ' +
                                    '(ISNULL(MAX(CASE WHEN ID_RETENCIONTRIBUTARIA = 1 THEN VALOR ELSE 0 END), 0) / 100) AS RETEFUENTE, ' +
                                    '(ISNULL(MAX(CASE WHEN ID_RETENCIONTRIBUTARIA = 2 THEN VALOR ELSE 0 END), 0) / 100) AS RETEICA, ' +
                                    '(ISNULL(MAX(CASE WHEN ID_RETENCIONTRIBUTARIA = 3 THEN VALOR ELSE 0 END), 0) / 100) AS RETEIVA ' +
                             'FROM WSXML_SFG.RETENCIONTRIBUTARIA ' +
                             'INNER JOIN WSXML_SFG.RETENCIONTRIBUTARIAREGIMEN ON (CODRETENCIONTRIBUTARIA = ID_RETENCIONTRIBUTARIA) ' +
                             'GROUP BY CODCOMPANIA, CODREGIMEN) RET ON (RET.CODCOMPANIA = PRD.CODCOMPANIA AND RET.CODREGIMEN = 5) ' +
            'WHERE PRF.CODCICLOFACTURACIONPDV = ' + ISNULL(@p_CODCICLOFACTURACIONPDV, '') + ' ' +
              'AND PRF.CODLINEADENEGOCIO      = ' + ISNULL(@p_CODLINEADENEGOCIO, '') + ' ' +
              'AND PRF.CODTIPOPRODUCTO        = ' + ISNULL(CASE WHEN @p_CODTIPOPRODUCTO = -1 THEN 'PRF.CODTIPOPRODUCTO' ELSE CONVERT(VARCHAR, @p_CODTIPOPRODUCTO) END, '') + ' ' +
              'AND PRF.CODPRODUCTO            = ' + ISNULL(WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO), '') + ') ' +
            'LEFT OUTER JOIN (SELECT CODCICLOFACTURACIONPDV, CODPRODUCTO, SUM(VALOR) AS TOTALELEMENTVALUE FROM LIQUIDACIONELEMENTO ' +
                             'GROUP BY CODCICLOFACTURACIONPDV, CODPRODUCTO) ELM ON (ELM.CODCICLOFACTURACIONPDV = ' + ISNULL(@p_CODCICLOFACTURACIONPDV, '') + ' AND ELM.CODPRODUCTO = ' + ISNULL(WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO), '') + ') ' +
            'LEFT OUTER JOIN ((SELECT ID_LIQUIDACIONELEMENTO, VALOR FROM LIQUIDACIONELEMENTO) T ' +
                             'PIVOT ' +
                             '(SUM(VALOR) FOR ID_LIQUIDACIONELEMENTO IN (' + ISNULL(CASE WHEN LEN(@LiquidacionID) > 0 THEN @LiquidacionID ELSE '-1' END, '') + ')) PIV) ON (1 = 1)';
    EXECUTE sp_executesql @sql;
  END;
  GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_LIQUIDACIONES_GetRegularData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_LIQUIDACIONES_GetRegularData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_LIQUIDACIONES_GetRegularData(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                           @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                           @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                           @pg_PRODUCTO              NVARCHAR(2000),
                           @pg_REDPDV                NVARCHAR(2000),
                           @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ISNULL(CANTIDAD, 0)                               AS CANTIDAD,
             ISNULL(VENTAS, 0)                                 AS VENTAS,
             ISNULL(IVAPRODUCTONOROUND, 0)                     AS IVAPRODUCTONOROUND,
             ISNULL(VENTASBRUTASNOROUND, 0)                    AS VENTASBRUTASNOROUND,
             ISNULL(REVENUETOTAL, 0) * (-1)                    AS REVENUETOTAL,
             ISNULL(COMISIONCORPORATIVA, 0) * (-1)             AS COMISIONCORPORATIVA,
             ISNULL(COMISIONESTANDAR, 0) * (-1)                AS COMISIONESTANDAR,
             ISNULL(PREMIOSPAGADOS, 0) * (-1)                  AS PREMIOSPAGADOS,
             ISNULL(VENTAS - REVENUETOTAL - PREMIOSPAGADOS, 0) AS TOTALAPAGAR
      FROM (SELECT SUM(PRF.NUMINGRESOS - PRF.NUMANULACIONES)                        AS CANTIDAD,
                   SUM(PRF.INGRESOSVALIDOS)                                         AS VENTAS,
                   SUM(PRF.INGRESOSVALIDOS - PRF.INGRESOSBRUTOSNOREDONDEO)          AS IVAPRODUCTONOROUND,
                   SUM(PRF.INGRESOSBRUTOSNOREDONDEO)                                AS VENTASBRUTASNOROUND,
                   SUM(PRF.REVENUETOTAL)                                            AS REVENUETOTAL,
                   SUM(PRF.REVENUETOTAL - PRF.COMISIONESTANDAR)                     AS COMISIONCORPORATIVA,
                   SUM(PRF.COMISIONESTANDAR)                                        AS COMISIONESTANDAR,
                   SUM(PRF.PREMIOSPAGADOS)                                          AS PREMIOSPAGADOS
            FROM WSXML_SFG.VW_PREFACTURACION_REVENUE PRF
/*            INNER JOIN REDPDV RED ON (PRF.CODREDPDV = RED.ID_REDPDV)
            LEFT OUTER JOIN PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO)
            LEFT OUTER JOIN AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
            LEFT OUTER JOIN PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO           = PRF.CODPRODUCTO)
*/            WHERE --PRF.CODCICLOFACTURACIONPDV = p_CODCICLOFACTURACIONPDV
                  PRF.FECHAARCHIVO BETWEEN CONVERT(DATETIME, '30/05/2010', 103) AND CONVERT(DATETIME, '04/06/2010', 103)
              AND PRF.CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO
              AND PRF.CODTIPOPRODUCTO        = CASE WHEN @p_CODTIPOPRODUCTO = -1 THEN PRF.CODTIPOPRODUCTO ELSE @p_CODTIPOPRODUCTO END
              AND PRF.CODPRODUCTO            = CASE WHEN @pg_PRODUCTO = '-1' THEN PRF.CODPRODUCTO ELSE WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO) END) s;
  END;
GO
