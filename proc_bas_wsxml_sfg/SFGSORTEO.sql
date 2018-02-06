USE SFGPRODU;
--  DDL for Package Body SFGSORTEO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGSORTEO */ 

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSORTEO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSORTEO_AddRecord(@p_CODPRODUCTO            NUMERIC(22,0),
                      @p_NUMEROSORTEO           NUMERIC(22,0),
                      @p_FECHASORTEO            DATETIME,
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_CODSORTEOPRODUCTO      NUMERIC(22,0),
                      @p_ID_SORTEO_out          NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xCODCALENDARIO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    BEGIN
      SELECT @xCODCALENDARIO = ID_CALENDARIO_GRAL FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL WHERE CONVERT(DATETIME, CONVERT(DATE,FECHA_CALENDARIO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHASORTEO));
		IF @@ROWCOUNT = 0
			RAISERROR('-20054 Existe una inconsistencia en el calendario: La fecha solicitada no existe', 16, 1);
		IF @@ROWCOUNT > 1
			RAISERROR('-20055 Existe una inconsistencia en el calendario: La fecha del sorteo existe dos veces en este', 16, 1);
    END;

    INSERT INTO WSXML_SFG.SORTEO (
                        CODPRODUCTO,
                        NUMEROSORTEO,
                        COD_CALENDARIO_GRAL,
                        CODUSUARIOMODIFICACION,
                        CODSORTEOPRODUCTO)
    VALUES (
            @p_CODPRODUCTO,
            @p_NUMEROSORTEO,
            @xCODCALENDARIO,
            @p_CODUSUARIOMODIFICACION,
            @p_CODSORTEOPRODUCTO);
    SET @p_ID_SORTEO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetLastSorteoNumber', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGSORTEO_GetLastSorteoNumber;
GO

CREATE     FUNCTION WSXML_SFG.SFGSORTEO_GetLastSorteoNumber(@p_CODPRODUCTO NUMERIC(22,0), @p_FECHA DATETIME) RETURNS NUMERIC(22,0) AS
 BEGIN
    DECLARE @xSorteo NUMERIC(22,0);
    DECLARE @xSorteoNumber NUMERIC(22,0);
   
    SELECT @xSorteo = ID_SORTEO
    FROM (SELECT ID_SORTEO FROM WSXML_SFG.SORTEO
          INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
          WHERE CODPRODUCTO = @p_CODPRODUCTO AND FECHA_CALENDARIO < @p_FECHA
          --ORDER BY FECHA_CALENDARIO DESC
		  ) s
   
    SELECT @xSorteoNumber = NUMEROSORTEO FROM WSXML_SFG.SORTEO WHERE ID_SORTEO = @xSorteo;
	
	IF @@ROWCOUNT = 0
		RETURN 0;
	
    RETURN @xSorteoNumber;
    
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetLastSorteoDate', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGSORTEO_GetLastSorteoDate;
GO

CREATE     FUNCTION WSXML_SFG.SFGSORTEO_GetLastSorteoDate(@p_CODPRODUCTO NUMERIC(22,0), @p_FECHA DATETIME) RETURNS DATETIME AS
 BEGIN
    DECLARE @xSorteo NUMERIC(22,0);
    DECLARE @xSorteoDate DATETIME;
   
    SELECT @xSorteo = ID_SORTEO
    FROM (SELECT ID_SORTEO FROM WSXML_SFG.SORTEO
          INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
          WHERE CODPRODUCTO = @p_CODPRODUCTO AND FECHA_CALENDARIO < @p_FECHA
          --ORDER BY FECHA_CALENDARIO DESC
		  ) s
   ;
    SELECT @xSorteoDate = FECHA_CALENDARIO FROM WSXML_SFG.SORTEO
    INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
    WHERE ID_SORTEO = @xSorteo;
	
	IF @@ROWCOUNT = 0
		RETURN NULL;
		
    RETURN @xSorteoDate;
	

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetNextSorteoNumber', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGSORTEO_GetNextSorteoNumber;
GO

CREATE     FUNCTION WSXML_SFG.SFGSORTEO_GetNextSorteoNumber(@p_CODPRODUCTO NUMERIC(22,0), @p_FECHA DATETIME) RETURNS NUMERIC(22,0) AS
 BEGIN
    DECLARE @xSorteo NUMERIC(22,0);
    DECLARE @xSorteoNumber NUMERIC(22,0);
   
    SELECT @xSorteo = ID_SORTEO
    FROM (SELECT ID_SORTEO FROM WSXML_SFG.SORTEO
          INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
          WHERE CODPRODUCTO = @p_CODPRODUCTO AND FECHA_CALENDARIO > @p_FECHA
          --ORDER BY FECHA_CALENDARIO ASC
		  ) s
   ;
    SELECT @xSorteoNumber = NUMEROSORTEO FROM WSXML_SFG.SORTEO WHERE ID_SORTEO = @xSorteo;
	
		IF @@ROWCOUNT = 0
		RETURN 0;
		
    RETURN @xSorteoNumber;
	

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetNextSorteoDate', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGSORTEO_GetNextSorteoDate;
GO

CREATE     FUNCTION WSXML_SFG.SFGSORTEO_GetNextSorteoDate(@p_CODPRODUCTO NUMERIC(22,0), @p_FECHA DATETIME) RETURNS DATETIME AS
 BEGIN
    DECLARE @xSorteo     NUMERIC(22,0);
    DECLARE @xSorteoDate DATETIME;
   
    SELECT @xSorteo = ID_SORTEO
    FROM (SELECT ID_SORTEO FROM WSXML_SFG.SORTEO
          INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
          WHERE CODPRODUCTO = @p_CODPRODUCTO AND FECHA_CALENDARIO > @p_FECHA
          --ORDER BY FECHA_CALENDARIO ASC
		  ) s
   ;
    SELECT @xSorteoDate = FECHA_CALENDARIO FROM WSXML_SFG.SORTEO
    INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
    WHERE ID_SORTEO = @xSorteo;
	
	IF @@ROWCOUNT = 0
		RETURN NULL;
	
    RETURN @xSorteoDate;
	
	
 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetSorteoDateFromNumber', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGSORTEO_GetSorteoDateFromNumber;
GO

CREATE     FUNCTION WSXML_SFG.SFGSORTEO_GetSorteoDateFromNumber(@p_CODPRODUCTO NUMERIC(22,0), @p_NUMEROSORTEO NUMERIC(22,0)) RETURNS DATETIME AS
 BEGIN
    DECLARE @xSorteo     NUMERIC(22,0);
    DECLARE @xSorteoDate DATETIME;
   
    SELECT @xSorteo = ID_SORTEO FROM WSXML_SFG.SORTEO WHERE CODPRODUCTO = @p_CODPRODUCTO AND NUMEROSORTEO = @p_NUMEROSORTEO;
    SELECT @xSorteoDate = FECHA_CALENDARIO FROM WSXML_SFG.SORTEO
    INNER JOIN SFG_CONCILIACION.CON_CALENDARIO_GRAL ON (ID_CALENDARIO_GRAL = COD_CALENDARIO_GRAL)
    WHERE ID_SORTEO = @xSorteo;
	
	IF @@ROWCOUNT = 0
		RETURN NULL;
		
    RETURN @xSorteoDate;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetInfoLiquidacionLoteria', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSORTEO_GetInfoLiquidacionLoteria;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSORTEO_GetInfoLiquidacionLoteria(@p_CODPRODUCTO NUMERIC(22,0),
                                      @p_FECHAINICIO DATETIME,
                                      @p_FECHAFIN    DATETIME,
                                      @p_page_number INTEGER,
                                      @p_batch_size  INTEGER,
                                     @p_total_size  INTEGER OUT
                                                 ) AS
 BEGIN
  DECLARE @tmptotalventas float;
   
  SET NOCOUNT ON;
    SET @p_total_size = 1;

 
        SELECT @tmptotalventas = SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO IN (1,3) THEN REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO
                   ELSE REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO * -1 END )
       FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND REGISTROFACTURACION.CODPRODUCTO = @p_CODPRODUCTO;


	 
    SELECT ISNULL(CANTIDAD, 0)                               AS CANTIDAD,
             ISNULL(VENTAS, 0)                                 AS VENTAS,
             ISNULL(IVAPRODUCTONOROUND, 0)                     AS IVAPRODUCTONOROUND,
            /* NVL(VENTASBRUTASNOROUND, 0)*/@tmptotalventas                    AS VENTASBRUTASNOROUND,
             ISNULL(REVENUETOTAL, 0) * (-1)                    AS REVENUETOTAL,
             ISNULL(COMISIONCORPORATIVA, 0) * (-1)             AS COMISIONCORPORATIVA,
             ISNULL(COMISIONESTANDAR, 0) * (-1)                AS COMISIONESTANDAR,
             ISNULL(PREMIOSPAGADOS, 0) * (-1)                  AS PREMIOSPAGADOS,
             ISNULL(VENTAS - REVENUETOTAL - PREMIOSPAGADOS, 0) AS TOTALAPAGAR
      FROM (SELECT SUM(PRF.NUMINGRESOS - PRF.NUMANULACIONES)                        AS CANTIDAD,
                   SUM(PRF.INGRESOSVALIDOS)                                         AS VENTAS,
                   SUM(PRF.INGRESOSVALIDOS )-@tmptotalventas          AS IVAPRODUCTONOROUND,
                   SUM(PRF.INGRESOSBRUTOSNOREDONDEO)                                AS VENTASBRUTASNOROUND,
                   SUM(PRF.REVENUETOTAL)                                            AS REVENUETOTAL,
                   SUM(PRF.REVENUETOTAL - PRF.COMISIONESTANDAR)                     AS COMISIONCORPORATIVA,
                   SUM(PRF.COMISIONESTANDAR)                                        AS COMISIONESTANDAR,
                   SUM(PRF.PREMIOSPAGADOS)                                          AS PREMIOSPAGADOS
            FROM WSXML_SFG.VW_PREFACTURACION_REVENUE PRF
           WHERE PRF.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND PRF.CODPRODUCTO = @p_CODPRODUCTO) s;
	;
/*      SELECT NVL(CANTIDAD, 0)                               AS CANTIDAD,
             NVL(VENTAS, 0)                                 AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0)                     AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUND, 0)                    AS VENTASBRUTASNOROUND,
             NVL(REVENUETOTAL, 0) * (-1)                    AS REVENUETOTAL,
             NVL(COMISIONCORPORATIVA, 0) * (-1)             AS COMISIONCORPORATIVA,
             NVL(COMISIONESTANDAR, 0) * (-1)                AS COMISIONESTANDAR,
             NVL(PREMIOSPAGADOS, 0) * (-1)                  AS PREMIOSPAGADOS,
             NVL(VENTAS - REVENUETOTAL - PREMIOSPAGADOS, 0) AS TOTALAPAGAR
      FROM (SELECT SUM(PRF.NUMINGRESOS - PRF.NUMANULACIONES)                        AS CANTIDAD,
                   SUM(PRF.INGRESOSVALIDOS)                                         AS VENTAS,
                   SUM(PRF.INGRESOSVALIDOS - PRF.INGRESOSBRUTOSNOREDONDEO)          AS IVAPRODUCTONOROUND,
                   SUM(PRF.INGRESOSBRUTOSNOREDONDEO)                                AS VENTASBRUTASNOROUND,
                   SUM(PRF.REVENUETOTAL)                                            AS REVENUETOTAL,
                   SUM(PRF.REVENUETOTAL - PRF.COMISIONESTANDAR)                     AS COMISIONCORPORATIVA,
                   SUM(PRF.COMISIONESTANDAR)                                        AS COMISIONESTANDAR,
                   SUM(PRF.PREMIOSPAGADOS)                                          AS PREMIOSPAGADOS
            FROM VW_PREFACTURACION_REVENUE PRF
           \* INNER JOIN REDPDV RED ON (PRF.CODREDPDV = RED.ID_REDPDV)
            LEFT OUTER JOIN PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO)
            LEFT OUTER JOIN AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
            LEFT OUTER JOIN PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO           = PRF.CODPRODUCTO)
        *\    WHERE PRF.FECHAARCHIVO BETWEEN p_FECHAINICIO AND p_FECHAFIN AND PRF.CODPRODUCTO = p_CODPRODUCTO);*/
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_GetDetailedInfoLiqLoteria', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSORTEO_GetDetailedInfoLiqLoteria;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSORTEO_GetDetailedInfoLiqLoteria(@p_CODPRODUCTO NUMERIC(22,0),
                                      @p_FECHAINICIO DATETIME,
                                      @p_FECHAFIN    DATETIME,
                                      @p_page_number INTEGER,
                                      @p_batch_size  INTEGER,
                                     @p_total_size  INTEGER OUT
                                                 ) AS
  BEGIN
  SET NOCOUNT ON;
    set @p_total_size = CONVERT(FLOAT, @p_FECHAFIN) - CONVERT(FLOAT, @p_FECHAINICIO);

	  	
      SELECT FECHAARCHIVO                                   AS FECHA,
             NOMPRODUCTO                                    AS NOMPRODUCTO,
             ISNULL(CANTIDAD, 0)                               AS CANTIDAD,
             ISNULL(VENTAS, 0)                                 AS VENTAS,
             ISNULL(IVAPRODUCTONOROUND, 0)                     AS IVAPRODUCTONOROUND,
             ISNULL(VENTASBRUTASNOROUND, 0)                    AS VENTASBRUTASNOROUND,
             ISNULL(REVENUETOTAL, 0) * (-1)                    AS REVENUETOTAL,
             ISNULL(COMISIONCORPORATIVA, 0) * (-1)             AS COMISIONCORPORATIVA,
             ISNULL(COMISIONESTANDAR, 0) * (-1)                AS COMISIONESTANDAR,
             ISNULL(PREMIOSPAGADOS, 0) * (-1)                  AS PREMIOSPAGADOS,
             ISNULL(VENTAS - REVENUETOTAL - PREMIOSPAGADOS, 0) AS TOTALAPAGAR
      FROM (SELECT PRF.FECHAARCHIVO                                                 AS FECHAARCHIVO,
                   PRD.ID_PRODUCTO                                                  AS ID_PRODUCTO,
                   PRD.NOMPRODUCTO                                                  AS NOMPRODUCTO,
                   SUM(PRF.NUMINGRESOS - PRF.NUMANULACIONES)                        AS CANTIDAD,
                   SUM(PRF.INGRESOSVALIDOS)                                         AS VENTAS,
                   SUM(PRF.INGRESOSVALIDOS - PRF.INGRESOSBRUTOSNOREDONDEO)          AS IVAPRODUCTONOROUND,
                   SUM(PRF.INGRESOSBRUTOSNOREDONDEO)                                AS VENTASBRUTASNOROUND,
                   SUM(PRF.REVENUETOTAL)                                            AS REVENUETOTAL,
                   SUM(PRF.REVENUETOTAL - PRF.COMISIONESTANDAR)                     AS COMISIONCORPORATIVA,
                   SUM(PRF.COMISIONESTANDAR)                                        AS COMISIONESTANDAR,
                   SUM(PRF.PREMIOSPAGADOS)                                          AS PREMIOSPAGADOS
            FROM WSXML_SFG.VW_PREFACTURACION_REVENUE PRF
            INNER JOIN WSXML_SFG.REDPDV RED ON (PRF.CODREDPDV = RED.ID_REDPDV)
            LEFT OUTER JOIN WSXML_SFG.PRODUCTO               PRD ON (PRD.ID_PRODUCTO           = PRF.CODPRODUCTO)
            LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPRODUCTO     AGP ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
            LEFT OUTER JOIN WSXML_SFG.PRODUCTOCONTRATO       PCT ON (PCT.CODPRODUCTO           = PRF.CODPRODUCTO)
            WHERE PRF.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN AND PRF.CODPRODUCTO = @p_CODPRODUCTO
            GROUP BY PRF.FECHAARCHIVO, PRD.ID_PRODUCTO, PRD.NOMPRODUCTO) s ORDER BY FECHAARCHIVO;
	;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_SetSorteoLiquidado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSORTEO_SetSorteoLiquidado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSORTEO_SetSorteoLiquidado(@pk_ID_LIQUIDACIONPRODUCTO      NUMERIC(22,0),
                               @p_NUMEROSORTEO                 NUMERIC(22,0),
                               @p_VALORAPAGAR                  FLOAT,
                               @p_CODUSUARIOGENERACION         NUMERIC(22,0),
                               @p_ID_LIQUIDACIONPRODUCTOHI_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xcodSORTEOPRODUCTO             NUMERIC(22,0);
    DECLARE @xcodSORTEO                     NUMERIC(22,0);
    DECLARE @xcodLIQUIDACIONPRODUCTOHISTORI NUMERIC(22,0);
	DECLARE @msg VARCHAR(2000)
   
  SET NOCOUNT ON;
    -- Get from sorteo
    SELECT @xcodSORTEOPRODUCTO = CODSORTEOPRODUCTO FROM WSXML_SFG.LIQUIDACIONPRODUCTO WHERE ID_LIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO;
    BEGIN
      SELECT @xcodSORTEO = ID_SORTEO FROM WSXML_SFG.SORTEO WHERE CODSORTEOPRODUCTO = @xcodSORTEOPRODUCTO AND NUMEROSORTEO = @p_NUMEROSORTEO;
		IF @@ROWCOUNT = 0
			RAISERROR('-20054 No existe el sorteo para el producto especificado', 16, 1);
    END;

    -- Check historic value for non existance
    BEGIN
      SELECT @xcodLIQUIDACIONPRODUCTOHISTORI = ID_LIQUIDACIONPRODUCTOHISTORIC FROM WSXML_SFG.LIQUIDACIONPRODUCTOHISTORICO
      WHERE CODLIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO AND CODSORTEO = @xcodSORTEO;
	  SET  @msg = '-20055 Ya se establecio el sorteo ' + ISNULL(@p_NUMEROSORTEO, '') + ' como liquidado para el producto'
      RAISERROR(@msg, 16, 1);
		IF @@ROWCOUNT = 0 BEGIN
      INSERT INTO WSXML_SFG.LIQUIDACIONPRODUCTOHISTORICO (
                                                CODLIQUIDACIONPRODUCTO,
                                                CODSORTEO,
                                                TOTALVALORAPAGAR,
                                                CODUSUARIOGENERACION)
      VALUES (
              @pk_ID_LIQUIDACIONPRODUCTO,
              @xcodSORTEO,
              @p_VALORAPAGAR,
              @p_CODUSUARIOGENERACION);
      SET @xcodLIQUIDACIONPRODUCTOHISTORI = SCOPE_IDENTITY();
      UPDATE WSXML_SFG.LIQUIDACIONPRODUCTO SET CODSORTEO = @xcodSORTEO, CODLIQUIDACIONPRODUCTOHISTORIC = @xcodLIQUIDACIONPRODUCTOHISTORI
      WHERE ID_LIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO;
      SET @p_ID_LIQUIDACIONPRODUCTOHI_out = @xcodLIQUIDACIONPRODUCTOHISTORI;
	  END
    END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSORTEO_ReverseSorteoLiquidado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSORTEO_ReverseSorteoLiquidado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSORTEO_ReverseSorteoLiquidado(@pk_ID_LIQUIDACIONPRODUCTO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @xcodLIQUIDACIONPRODUCTOHISTORI NUMERIC(22,0);
    DECLARE @xnewLIQUIDACIONPRODUCTOHISTORI NUMERIC(22,0);
    DECLARE @xnewSORTEO                     NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @xcodLIQUIDACIONPRODUCTOHISTORI = CODLIQUIDACIONPRODUCTOHISTORIC FROM WSXML_SFG.LIQUIDACIONPRODUCTO
    WHERE ID_LIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO;
    /* Select previous values */
    SELECT @xnewSORTEO = CODSORTEO, @xnewLIQUIDACIONPRODUCTOHISTORI = ID_LIQUIDACIONPRODUCTOHISTORIC FROM WSXML_SFG.LIQUIDACIONPRODUCTOHISTORICO
    WHERE CODLIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO
    AND CODSORTEO = (SELECT MAX(CODSORTEO) FROM WSXML_SFG.LIQUIDACIONPRODUCTOHISTORICO
                     WHERE CODLIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO AND ID_LIQUIDACIONPRODUCTOHISTORIC <> @xcodLIQUIDACIONPRODUCTOHISTORI);
    /* Update base */
    UPDATE WSXML_SFG.LIQUIDACIONPRODUCTO SET CODSORTEO = @xnewSORTEO, CODLIQUIDACIONPRODUCTOHISTORIC = @xnewLIQUIDACIONPRODUCTOHISTORI
    WHERE ID_LIQUIDACIONPRODUCTO = @pk_ID_LIQUIDACIONPRODUCTO;
    /* Delete historic */
    DELETE LIQUIDACIONPRODUCTOHISTORICO WHERE ID_LIQUIDACIONPRODUCTOHISTORIC = @xcodLIQUIDACIONPRODUCTOHISTORI;
  /* Do not catch exception */
  END;
GO



