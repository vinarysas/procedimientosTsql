USE SFGPRODU;
--  DDL for Package Body SFGREVENUERANGOTIEMPO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREVENUERANGOTIEMPO */ 

IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_CumplePeriodicidad', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_CumplePeriodicidad;
GO

CREATE     FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_CumplePeriodicidad(@p_FECHAEVALUACION DATETIME,
                              @p_CODPERIODICIDAD NUMERIC(22,0),
                              @p_FRECUENCIA      NUMERIC(22,0),
                              @p_FECHAINICIO     DATETIME,
                              @p_CALENDARIO      NUMERIC(22,0)) RETURNS NUMERIC(22,0) /*1 - 0 */
   AS
  BEGIN
  DECLARE @p_NEWFECHAINICIO DATETIME;
    IF @p_CODPERIODICIDAD = 1 BEGIN
      --Diaria
        DECLARE @V_NDAYSDIF NUMERIC(22,0);
      
      BEGIN
        SET @V_NDAYSDIF = WSXML_SFG.DateDiff('dd',
                                         @p_FECHAINICIO,
                                         @p_FECHAEVALUACION);
        SET @V_NDAYSDIF = @V_NDAYSDIF + 1;
        IF (@V_NDAYSDIF % @p_FRECUENCIA) = 0 AND
           @p_FECHAEVALUACION > @p_FECHAINICIO BEGIN
          RETURN 1;
        END
        ELSE BEGIN
          RETURN 0;
        END 
      END;
    END
    ELSE IF @p_CODPERIODICIDAD = 2 BEGIN
      --Semanal
        DECLARE @v_NWEEKSDIF      NUMERIC(22,0);
        --DECLARE @p_NEWFECHAINICIO DATETIME;
      BEGIN
        IF @p_CALENDARIO = 1 BEGIN
          --        p_NEWFECHAINICIO := NEXT_DAY(p_FECHAINICIO, 'SABADO');
          ---          p_NEWFECHAINICIO := NEXT_DAY(p_FECHAINICIO,TO_NUMBER(to_char(TO_DATE('02/02/2013','DD/MM/YYYY'),'D')));
          ---Find next saturday
            DECLARE @TMPFECHA DATETIME;
          BEGIN
            --Si el primer dia es un sabdo no se puede sumar
          
            SET @TMPFECHA = @p_FECHAINICIO; -- + 1;
            WHILE 1 = 1 BEGIN
              IF datepart(day,@TMPFECHA) =
                 datepart(day,CONVERT(DATETIME, '05/01/2013')) BEGIN
                --'7' THEN
                SET @p_NEWFECHAINICIO = @TMPFECHA;
                RETURN 0
              END
              ELSE BEGIN
                SET @TMPFECHA = @TMPFECHA + 1;
              END 
            END;
            SET @p_NEWFECHAINICIO = @p_NEWFECHAINICIO + 1; --Solucion error de calculo en los viernes+
          END;
        END
        ELSE BEGIN
          SET @p_NEWFECHAINICIO = @p_FECHAINICIO;
        END 
        SET @v_NWEEKSDIF = WSXML_SFG.DATEDIFF('ww',@p_NEWFECHAINICIO - 1,@p_FECHAEVALUACION);
        IF (@v_NWEEKSDIF % @p_FRECUENCIA) = 0 AND
           (@p_NEWFECHAINICIO < @p_FECHAEVALUACION) BEGIN
          RETURN 1;
        END
        ELSE BEGIN
          RETURN 0;
        END 
      END;
    END
    ELSE IF @p_CODPERIODICIDAD = 3 BEGIN
      --Mensual
        DECLARE @v_NMONTHSDIF     NUMERIC(22,0);
        --DECLARE @p_NEWFECHAINICIO DATETIME;
        DECLARE @v_FECHAINICIO    DATETIME;
        DECLARE @v_FECHAFIN       DATETIME;
      BEGIN
        IF @p_CALENDARIO = 1 BEGIN
          -- si es calendario .. solo tengo que validar la fecha de evaluacion sea la ultima fecha del mes
          
              EXEC WSXML_SFG.SFG_PACKAGE_GetMonthRange @p_FECHAEVALUACION, @v_FECHAINICIO OUT, @v_FECHAFIN OUT
          
/*          p_NEWFECHAINICIO := WSXML_SFG.DATEADD('dd',
                                                -1,
                                                WSXML_SFG.DATESERIAL(1,
                                                                     EXTRACT(MONTH FROM
                                                                             WSXML_SFG.DATEADD('mm',
                                                                                               1,
                                                                                               p_FECHAINICIO)),
                                                                     EXTRACT(YEAR FROM
                                                                             WSXML_SFG.DATEADD('mm',
                                                                                               1,
                                                                                               p_FECHAINICIO)))); --Obtener el ultimo dia dle mes
*/        
           IF @p_FECHAEVALUACION =@v_FECHAFIN BEGIN 
              RETURN 1;
           END
           ELSE BEGIN      
              RETURN 0;
           END                                                                                      
        END
        ELSE BEGIN
			SET @p_NEWFECHAINICIO = @p_FECHAINICIO;
			SET @v_NMONTHSDIF = WSXML_SFG.DATEDIFF('mm_exact', @p_NEWFECHAINICIO, @p_FECHAEVALUACION);
			
			IF (@v_NMONTHSDIF % @p_FRECUENCIA) = 0 BEGIN
				RETURN 1;
			END
			ELSE BEGIN
				RETURN 0;
			END 
        END 
       
      END;
    END
    ELSE BEGIN
      RETURN CAST('-20053 Existe una tarifa de rango tiempo con una periodicidad invalida' AS INT);
    END 
    RETURN NULL;
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_GetPeriodicidadRango', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_GetPeriodicidadRango;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_GetPeriodicidadRango (@p_FECHAEVALUACION DATETIME,
                                 @p_CODPERIODICIDAD NUMERIC(22,0),
                                 @p_FRECUENCIA      NUMERIC(22,0),
                                 @p_CALENDARIO      NUMERIC(22,0),
                                 @p_FECHAINICIO_out DATETIME OUT,
                                 @p_FECHAFIN_out    DATETIME OUT) AS

  BEGIN
  SET NOCOUNT ON;
       IF @p_CODPERIODICIDAD = 1 BEGIN
          --Diaria
          SET @p_FECHAINICIO_out = @p_FECHAEVALUACION - @p_FRECUENCIA;
          SET @p_FECHAINICIO_out = @p_FECHAINICIO_out + 1;
          SET @p_FECHAFIN_out    = @p_FECHAEVALUACION;
        END
        ELSE IF @p_CODPERIODICIDAD = 2 BEGIN
          --Semanal
          IF @p_CALENDARIO = 1 BEGIN
            --De domingo a sabado
            --p_FECHAINICIO_out := NEXT_DAY(P_FECHAEVALUACION, 'sabado') - 6;
            --p_FECHAFIN_out    := NEXT_DAY(P_FECHAEVALUACION, 'sabado');
            SET @p_FECHAFIN_out    = @p_FECHAEVALUACION;
            SET @p_FECHAINICIO_out = (@p_FECHAEVALUACION -
                             (7 * @p_FRECUENCIA)) + 1;
          END
          ELSE BEGIN
            --del dia -6
            --p_FECHAINICIO_out := P_FECHAEVALUACION - 6;
            --p_FECHAFIN_out    := P_FECHAEVALUACION;
            SET @p_FECHAFIN_out    = @p_FECHAEVALUACION;
            SET @p_FECHAINICIO_out = (@p_FECHAEVALUACION -
                             (7 * @p_FRECUENCIA)) + 1;
          END 
        END
        ELSE IF @p_CODPERIODICIDAD = 3 BEGIN
          --Mensual
          IF @p_CALENDARIO = 1 BEGIN
            --De domingo a sabado
            SET @p_FECHAINICIO_out = WSXML_SFG.DATESERIAL(1,
                                                  MONTH(
                                                          --addmonth('mm',P_FECHAEVALUACION),
                                                          WSXML_SFG.DATEADD('mm',
                                                                  (@p_FRECUENCIA - 1) * -1,
                                                                  @p_FECHAEVALUACION)),
                                                  YEAR(
                                                          -- P_FECHAEVALUACION));
                                                          WSXML_SFG.DATEADD('mm',
                                                                  (@p_FRECUENCIA - 1) * -1,
                                                                  @p_FECHAEVALUACION)));
            SET @p_FECHAFIN_out    = dbo.LAST_DAY(@p_FECHAEVALUACION);
          END
          ELSE BEGIN
            --del dia -6
            SET @p_FECHAINICIO_out = WSXML_SFG.DATEADD('mm', -1, @p_FECHAEVALUACION) + 1;
            SET @p_FECHAFIN_out    = @p_FECHAEVALUACION;
          END 
        END
        ELSE BEGIN
          RAISERROR('-20053 Tipo de periodicidad no valido', 16, 1);
        END 

     
  END;                                 
GO
                                
  IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_CalcularRevenueRangoTiempo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_CalcularRevenueRangoTiempo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_CalcularRevenueRangoTiempo(@p_FechaEvaluacion datetime) AS
  BEGIN
  SET NOCOUNT ON;
  
    DELETE FROM REGISTROREVENUEINCENTIVO
     WHERE REGISTROREVENUEINCENTIVO.ID_REGISTROREVENUEINCENTIVO IN
           (SELECT REGISTROREVENUEINCENTIVO.ID_REGISTROREVENUEINCENTIVO
              FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
             INNER JOIN WSXML_SFG.REGISTROREVENUE
                ON REGISTROREVENUEINCENTIVO.CODREGISTROREVENUE =
                   REGISTROREVENUE.ID_REGISTROREVENUE
             INNER JOIN WSXML_SFG.REGISTROFACTURACION
                ON REGISTROREVENUE.CODREGISTROFACTURACION =
                   REGISTROFACTURACION.ID_REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                   ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @p_FechaEvaluacion
            -- AND REGISTROFACTURACION.CODPRODUCTO = p_CodProducto
            )
       AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL;
  
    DECLARE Comisiones CURSOR FOR SELECT COMISIONRANGOTIEMPO.ID_COMISIONRANGOTIEMPO,
                              COMISIONRANGOTIEMPO.EVALUARVENTASPORAGRUPACION,
                              COMISIONRANGOTIEMPO.CODPERIODICIDAD,
                              COMISIONRANGOTIEMPO.CODTIPOEVALUACIONVENTAS,
                              COMISIONRANGOTIEMPO.FECHAINICIO,
                              COMISIONRANGOTIEMPO.FECHACALENDARIO,
                              COMISIONRANGOTIEMPO.FRECUENCIA,
                              COMISIONRANGOTIEMPO.DESCOMISPOSTESTANDAR,
                              PRODUCTO.ID_PRODUCTO,
                              PRODUCTO.CODAGRUPACIONPRODUCTO
                         FROM WSXML_SFG.COMISIONRANGOTIEMPO
                        INNER JOIN WSXML_SFG.RANGOCOMISION
                           ON COMISIONRANGOTIEMPO.CODRANGOCOMISION =
                              RANGOCOMISION.ID_RANGOCOMISION
                        INNER JOIN WSXML_SFG.PRODUCTOCONTRATO
                           ON PRODUCTOCONTRATO.CODRANGOCOMISION =
                              RANGOCOMISION.ID_RANGOCOMISION
                        INNER JOIN WSXML_SFG.PRODUCTO
                           ON PRODUCTOCONTRATO.CODPRODUCTO =
                              PRODUCTO.ID_PRODUCTO
                        WHERE PRODUCTO.ACTIVE = 1
                             --  AND PRODUCTO.ID_PRODUCTO = p_CodProducto
                          AND WSXML_SFG.SFGREVENUERANGOTIEMPO_CumplePeriodicidad(@p_FechaEvaluacion,
                                                 COMISIONRANGOTIEMPO.CODPERIODICIDAD,
                                                 COMISIONRANGOTIEMPO.FRECUENCIA,
                                                 COMISIONRANGOTIEMPO.FECHAINICIO,
                                                 COMISIONRANGOTIEMPO.FECHACALENDARIO) = 1; 
	OPEN Comisiones;

	DECLARE @Comisiones__ID_COMISIONRANGOTIEMPO NUMERIC(38,0),
            @Comisiones__EVALUARVENTASPORAGRUPACION NUMERIC(22,0),
            @Comisiones__CODPERIODICIDAD NUMERIC(22,0),
            @Comisiones__CODTIPOEVALUACIONVENTAS NUMERIC(38,0),
            @Comisiones__FECHAINICIO DATETIME,
            @Comisiones__FECHACALENDARIO NUMERIC(22,0),
            @Comisiones__FRECUENCIA NUMERIC(22,0),
            @Comisiones__DESCOMISPOSTESTANDAR NUMERIC(22,0),
            @Comisiones__ID_PRODUCTO NUMERIC(38,0),
            @Comisiones__CODAGRUPACIONPRODUCTO NUMERIC(38,0)

	 FETCH NEXT FROM Comisiones INTO  @Comisiones__ID_COMISIONRANGOTIEMPO,
				@Comisiones__EVALUARVENTASPORAGRUPACION, @Comisiones__CODPERIODICIDAD,
				@Comisiones__CODTIPOEVALUACIONVENTAS,@Comisiones__FECHAINICIO,
				@Comisiones__FECHACALENDARIO,@Comisiones__FRECUENCIA,
				@Comisiones__DESCOMISPOSTESTANDAR,@Comisiones__ID_PRODUCTO,
				@Comisiones__CODAGRUPACIONPRODUCTO

	 WHILE @@FETCH_STATUS=0
	 BEGIN
    
        DECLARE @v_CODAGRUPACIONPRODUCTO NUMERIC(22,0);

        DECLARE @v_MONTOVENTASPERIODO FLOAT;
        DECLARE @v_TRXVENTASPERIODO   FLOAT;
        DECLARE @v_REVENUEPERIODO     FLOAT;
      
        DECLARE @v_MONTOVENTASSOLPRODUCTO FLOAT;
        DECLARE @v_TRXVENTASPRODUCTO      FLOAT;
        DECLARE @v_REVENUEPRODUCTO        FLOAT;
      
        DECLARE @v_FECHAINICIO DATETIME;
        DECLARE @v_FECHAFIN    DATETIME;
      
        DECLARE @v_TARIFAFIJA          FLOAT;
        DECLARE @v_TARIFAPORCENTUAL    FLOAT;
        DECLARE @v_TARIFATRANSACCIONAL FLOAT;
        DECLARE @v_VALORREVENUENUEVO   FLOAT;
        DECLARE @v_VALORREVENUEACTUAL  FLOAT;
        DECLARE @v_VALORREVENUEDIF     FLOAT;
        DECLARE @v_VALORCOMPOSDIF      FLOAT;
      BEGIN
        --Recalcular el producto primero para que tome la tarifa estandar bien
        EXEC WSXML_SFG.SFGREGISTROREVENUE_CalcularRevenueProducto @p_FechaEvaluacion, @Comisiones__ID_PRODUCTO, 0
      
        EXEC WSXML_SFG.SFGREVENUERANGOTIEMPO_GetPeriodicidadRango
			@p_FechaEvaluacion, @Comisiones__CODPERIODICIDAD, @Comisiones__FRECUENCIA, @Comisiones__FECHACALENDARIO
			,@v_FECHAINICIO,@v_FECHAFIN
      
  /*      --Primero calcular las fechas de inicio y fin del rango
        IF Comisiones.CODPERIODICIDAD = 1 THEN
          --Diaria
          v_FECHAINICIO := p_FECHAEVALUACION - Comisiones.FRECUENCIA;
          v_FECHAINICIO := v_FECHAINICIO + 1;
          v_FECHAFIN    := p_FECHAEVALUACION;
        ELSIF Comisiones.CODPERIODICIDAD = 2 THEN
          --Semanal
          IF Comisiones.FECHACALENDARIO = 1 THEN
            --De domingo a sabado
            --v_FECHAINICIO := NEXT_DAY(P_FECHAEVALUACION, 'sabado') - 6;
            --v_FECHAFIN    := NEXT_DAY(P_FECHAEVALUACION, 'sabado');
            V_FECHAFIN    := P_FECHAEVALUACION;
            v_FECHAINICIO := (P_FECHAEVALUACION -
                             (7 * Comisiones.FRECUENCIA)) + 1;
          ELSE
            --del dia -6
            --v_FECHAINICIO := P_FECHAEVALUACION - 6;
            --v_FECHAFIN    := P_FECHAEVALUACION;
            V_FECHAFIN    := P_FECHAEVALUACION;
            v_FECHAINICIO := (P_FECHAEVALUACION -
                             (7 * Comisiones.FRECUENCIA)) + 1;
          END IF;
        ELSIF Comisiones.CODPERIODICIDAD = 3 THEN
          --Mensual
          IF Comisiones.FECHACALENDARIO = 1 THEN
            --De domingo a sabado
            v_FECHAINICIO := WSXML_SFG.DATESERIAL(1,
                                                  EXTRACT(MONTH FROM
                                                          --addmonth('mm',P_FECHAEVALUACION),
                                                          dateadd('mm',
                                                                  (Comisiones.FRECUENCIA - 1) * -1,
                                                                  P_FECHAEVALUACION)),
                                                  EXTRACT(YEAR FROM
                                                          -- P_FECHAEVALUACION));
                                                          dateadd('mm',
                                                                  (Comisiones.FRECUENCIA - 1) * -1,
                                                                  P_FECHAEVALUACION)));
            v_FECHAFIN    := LAST_DAY(P_FECHAEVALUACION);
          ELSE
            --del dia -6
            v_FECHAINICIO := WSXML_SFG.DATEADD('mm', -1, p_FECHAEVALUACION) + 1;
            v_FECHAFIN    := P_FECHAEVALUACION;
          END IF;
        ELSE
          RAISE_APPLICATION_ERROR(-20053, 'Tipo de periodicidad no valido');
        END IF;
      */
        --Ontener el codigo de la agrupacion del producto
        SELECT @v_CODAGRUPACIONPRODUCTO = PRODUCTO.CODAGRUPACIONPRODUCTO
          FROM WSXML_SFG.PRODUCTO
         WHERE PRODUCTO.ID_PRODUCTO = @Comisiones__ID_PRODUCTO
      
        SELECT @v_MONTOVENTASPERIODO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO * -1
                   END),
               @v_TRXVENTASPERIODO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.NUMTRANSACCIONES
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   END),
               @v_REVENUEPERIODO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROREVENUE.REVENUETOTAL
                     ELSE
                      REGISTROREVENUE.REVENUETOTAL * -1
                   END)
          FROM WSXML_SFG.REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.REGISTROREVENUE
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.PRODUCTO
            ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = CASE
                 WHEN @Comisiones__EVALUARVENTASPORAGRUPACION = 0 THEN
                  @Comisiones__ID_PRODUCTO
                 ELSE
                  REGISTROFACTURACION.CODPRODUCTO
               END
           AND PRODUCTO.CODAGRUPACIONPRODUCTO = CASE
                 WHEN @Comisiones__EVALUARVENTASPORAGRUPACION = 1 THEN
                  @v_CODAGRUPACIONPRODUCTO
                 ELSE
                  PRODUCTO.CODAGRUPACIONPRODUCTO
               END;
        --Obtener las ventas de solo el producto para calcular el nuevo revenue
        SELECT @v_MONTOVENTASSOLPRODUCTO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO * -1
                   END),
               @v_TRXVENTASPRODUCTO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.NUMTRANSACCIONES
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   END),
               @v_REVENUEPRODUCTO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROREVENUE.REVENUETOTAL
                     ELSE /*Anulaciones*/
                      REGISTROREVENUE.REVENUETOTAL * -1
                   END)
                   FROM WSXML_SFG.REGISTROFACTURACION
         INNER JOIN WSXML_SFG.REGISTROREVENUE
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.PRODUCTO
            ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO;
      
        --Obtener el valor de la tarifa que debio obtener dependiendo de la cantidad de ventas
      
        SET @v_VALORREVENUENUEVO = WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenue(
											   @Comisiones__ID_COMISIONRANGOTIEMPO,
                                               @v_MONTOVENTASPERIODO,
                                               @v_TRXVENTASPERIODO,
                                               @v_MONTOVENTASSOLPRODUCTO,
                                               @v_TRXVENTASPRODUCTO,
                                               @v_REVENUEPERIODO,
                                               @v_REVENUEPRODUCTO,
                                               @Comisiones__ID_PRODUCTO);
      
        /*Obtener el valor del revenue actual  */
      
        SELECT @v_VALORREVENUEACTUAL = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                      (REGISTROREVENUE.revenuetotal - CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR
                        ELSE
                         0
                      END)
                     ELSE
                      (REGISTROREVENUE.revenuetotal - CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR
                        ELSE
                         0
                      END) * -1
                   END)
          FROM WSXML_SFG.REGISTROREVENUE
         INNER JOIN WSXML_SFG.REGISTROFACTURACION
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO;
      
        --Descontar la comision estandar de las redes que tienen comision diferencia
      
        SELECT @v_VALORCOMPOSDIF = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                      (CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR
                        ELSE
                         0
                      END)
                     ELSE
                      (CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR * -1
                        ELSE
                         0
                      END)
                   END)
          FROM WSXML_SFG.REGISTROREVENUE
         INNER JOIN WSXML_SFG.REGISTROFACTURACION
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
           AND REGISTROFACTURACION.CODREDPDV IN
               (SELECT PRODUCTOCONTRATOCOMDIF.CODREDPDV
                  FROM WSXML_SFG.PRODUCTOCONTRATOCOMDIF
                 INNER JOIN PRODUCTOCONTRATO
                    ON PRODUCTOCONTRATOCOMDIF.CODPRODUCTOCONTRATO =
                       PRODUCTOCONTRATO.ID_PRODUCTOCONTRATO
                 WHERE PRODUCTOCONTRATO.CODPRODUCTO = @Comisiones__ID_PRODUCTO);
      
        SET @v_VALORREVENUEACTUAL = @v_VALORREVENUEACTUAL +
                                ISNULL(@v_VALORCOMPOSDIF, 0);
      
        --Calcular diferencia
        SET @v_VALORREVENUEDIF = @v_VALORREVENUENUEVO - @v_VALORREVENUEACTUAL;
      
        --Ahora toca asignar el valor de los incentivos a cada rango de solo el producto ( no importa el parametro
        -- de evaluar ventas por agrupacion producto por que solo sirve para la evalucacion de las ventas )
          DECLARE @v_TOTALTRX          NUMERIC(22,0);
          DECLARE @v_VALORXTRANSACCION FLOAT;
          DECLARE @v_COUNTCADENAS      NUMERIC(22,0);
		
		BEGIN
        
          SELECT @v_COUNTCADENAS = COUNT(1)
            FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
           WHERE CODCOMISIONRANGOTIEMPO = @Comisiones__ID_COMISIONRANGOTIEMPO;
        
          IF @v_COUNTCADENAS = 0 BEGIN
            --Asignar a toda la red
            SELECT @v_TOTALTRX = ISNULL(SUM(CASE
                             WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                              REGISTROFACTURACION.NUMTRANSACCIONES
                             ELSE
                              REGISTROFACTURACION.NUMTRANSACCIONES * -1
                           END),
                       0)
              FROM WSXML_SFG.REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                   ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
               AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
               AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO;
          END
          ELSE BEGIN
            SELECT @v_TOTALTRX = ISNULL(SUM(CASE
                             WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                              REGISTROFACTURACION.NUMTRANSACCIONES
                             ELSE
                              REGISTROFACTURACION.NUMTRANSACCIONES * -1
                           END),
                       0)
              FROM WSXML_SFG.REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                   ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
               AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
               AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
               AND REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN
                   (SELECT COMISIONRANGOTIEMPOXAGRUP.CODAGRUPACIONPUNTOVENTA
                      FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
                     WHERE CODCOMISIONRANGOTIEMPO =
                           @Comisiones__ID_COMISIONRANGOTIEMPO);
          
          END 
        
          IF @v_TOTALTRX = 0 BEGIN
            --No hay registros... crear uno vacio
              DECLARE @v_IDNEWREGISTROFACTURACION NUMERIC(22,0);
              DECLARE @v_CODPUNTODEVENTA          NUMERIC(22,0);
            BEGIN
              IF @v_COUNTCADENAS > 0 BEGIN
                SELECT @v_CODPUNTODEVENTA = MAX(ID_PUNTODEVENTA)
                  FROM WSXML_SFG.PUNTODEVENTA
                 WHERE ACTIVE = 1
                   AND CODAGRUPACIONPUNTODEVENTA IN
                       (SELECT COMISIONRANGOTIEMPOXAGRUP.CODAGRUPACIONPUNTOVENTA
                          FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
                         WHERE CODCOMISIONRANGOTIEMPO =
                               @Comisiones__ID_COMISIONRANGOTIEMPO);
                IF @v_CODPUNTODEVENTA IS NULL BEGIN
                  SELECT @v_CODPUNTODEVENTA = CAST(VALOR AS NUMERIC(22,0))
                    FROM WSXML_SFG.PARAMETRO
                   WHERE NOMPARAMETRO = 'PUNTO DE VENTA DUMMY';
                
                END 
              
              END
              ELSE BEGIN
              
                SELECT @v_CODPUNTODEVENTA = CAST(VALOR AS NUMERIC(22,0))
                  FROM WSXML_SFG.PARAMETRO
                 WHERE NOMPARAMETRO = 'PUNTO DE VENTA DUMMY';
              END 

            
              EXEC WSXML_SFG.SFGREVENUERANGOTIEMPO_CrearRegistroFacturacionVacio 
											@v_CODPUNTODEVENTA,
                                            @Comisiones__ID_PRODUCTO,
                                            @v_FECHAFIN,
                                            1 /*Venta*/,
                                            1 /*usuario Sistema*/,
                                            @v_IDNEWREGISTROFACTURACION OUT
              --Calculamos el revenue de la transaccion para que se creen los registros de registro revenue.
              EXEC WSXML_SFG.SFGREGISTROREVENUE_CalcularRevenueRegistro @v_IDNEWREGISTROFACTURACION, NULL, NULL
            
              SET @v_VALORXTRANSACCION = ISNULL(@v_VALORREVENUEDIF, 0);
            
              --Validar si existen registros de registrorevenueincentivo y borrarlos
            
              DELETE FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
               WHERE CODREGISTROREVENUE IN
                     (SELECT ID_REGISTROREVENUE
                        FROM WSXML_SFG.REGISTROREVENUE
                       INNER JOIN WSXML_SFG.REGISTROFACTURACION
                          ON REGISTROREVENUE.CODREGISTROFACTURACION =
                             REGISTROFACTURACION.ID_REGISTROFACTURACION
                       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN
                             @v_FECHAINICIO AND @v_FECHAFIN
                         AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                         AND REGISTROFACTURACION.CODPRODUCTO =
                             @Comisiones__ID_PRODUCTO)
                 AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL; /*Esto valida que no s una tarifa fija normal si no por rangos de tiempo */
            
              --Solo va a haber un registro revenue
              INSERT INTO WSXML_SFG.REGISTROREVENUEINCENTIVO
                (--ID_REGISTROREVENUEINCENTIVO,
                 CODREGISTROREVENUE,
                 CODINCENTIVOCOMISIONGLOBAL,
                 REVENUE)
              
                SELECT --REGISTROREVENUEINCENTIVO_SEQ.NEXTVAL,
                       REGISTROREVENUE.ID_REGISTROREVENUE,
                       NULL,
                       @v_VALORXTRANSACCION
                  FROM WSXML_SFG.REGISTROREVENUE
                 INNER JOIN WSXML_SFG.REGISTROFACTURACION
                    ON REGISTROREVENUE.CODREGISTROFACTURACION =
                       REGISTROFACTURACION.ID_REGISTROFACTURACION
                 INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                    ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                       ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                 WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
                   AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                   AND REGISTROFACTURACION.CODPRODUCTO =
                       @Comisiones__ID_PRODUCTO
                   AND REGISTROFACTURACION.ID_REGISTROFACTURACION =
                       @v_IDNEWREGISTROFACTURACION;
            
            END;
          END
          ELSE BEGIN
            --sI HAY REGISTROS
            BEGIN
              SET @v_VALORXTRANSACCION = @v_VALORREVENUEDIF / @v_TOTALTRX;
            
              --Validar si existen registros de registrorevenueincentivo y borrarlos
            
              DELETE FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
               WHERE CODREGISTROREVENUE IN
                     (SELECT ID_REGISTROREVENUE
                        FROM WSXML_SFG.REGISTROREVENUE
                       INNER JOIN WSXML_SFG.REGISTROFACTURACION
                          ON REGISTROREVENUE.CODREGISTROFACTURACION =
                             REGISTROFACTURACION.ID_REGISTROFACTURACION
                       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN
                             @v_FECHAINICIO AND @v_FECHAFIN
                         AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                         AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO)
                 AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL; /*Esto valida que no s una tarifa fija normal si no por rangos de tiempo */
            
              IF @v_COUNTCADENAS = 0 BEGIN
                --Asignar a toda la red
                INSERT INTO WSXML_SFG.REGISTROREVENUEINCENTIVO
                  (--ID_REGISTROREVENUEINCENTIVO,
                   CODREGISTROREVENUE,
                   CODINCENTIVOCOMISIONGLOBAL,
                   REVENUE)
                
                  SELECT --REGISTROREVENUEINCENTIVO_SEQ.NEXTVAL,
                         REGISTROREVENUE.ID_REGISTROREVENUE,
                         NULL,
                         REGISTROFACTURACION.NUMTRANSACCIONES *
                         @v_VALORXTRANSACCION
                    FROM WSXML_SFG.REGISTROREVENUE
                   INNER JOIN WSXML_SFG.REGISTROFACTURACION
                      ON REGISTROREVENUE.CODREGISTROFACTURACION =
                         REGISTROFACTURACION.ID_REGISTROFACTURACION
                   INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                      ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                         ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                   WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
                     AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                     AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO;
              
              END
              ELSE BEGIN
                --Asignar solo a las cadenas definidas;
                INSERT INTO WSXML_SFG.REGISTROREVENUEINCENTIVO
                  (--ID_REGISTROREVENUEINCENTIVO,
                   CODREGISTROREVENUE,
                   CODINCENTIVOCOMISIONGLOBAL,
                   REVENUE)
                  SELECT --REGISTROREVENUEINCENTIVO_SEQ.NEXTVAL,
                         REGISTROREVENUE.ID_REGISTROREVENUE,
                         NULL,
                         REGISTROFACTURACION.NUMTRANSACCIONES *
                         @v_VALORXTRANSACCION
                    FROM WSXML_SFG.REGISTROREVENUE
                   INNER JOIN WSXML_SFG.REGISTROFACTURACION
                      ON REGISTROREVENUE.CODREGISTROFACTURACION =
                         REGISTROFACTURACION.ID_REGISTROFACTURACION
                   INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                      ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                         ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                   WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
                     AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                     AND REGISTROFACTURACION.CODPRODUCTO =
                         @Comisiones__ID_PRODUCTO
                     AND REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN
                         (SELECT COMISIONRANGOTIEMPOXAGRUP.CODAGRUPACIONPUNTOVENTA
                            FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
                           WHERE CODCOMISIONRANGOTIEMPO =
                                 @Comisiones__ID_COMISIONRANGOTIEMPO);
              
              END 
            
            END;
          END 
        
        END;
      
      END;
	 FETCH NEXT FROM Comisiones INTO  @Comisiones__ID_COMISIONRANGOTIEMPO,
				@Comisiones__EVALUARVENTASPORAGRUPACION, @Comisiones__CODPERIODICIDAD,
				@Comisiones__CODTIPOEVALUACIONVENTAS,@Comisiones__FECHAINICIO,
				@Comisiones__FECHACALENDARIO,@Comisiones__FRECUENCIA,
				@Comisiones__DESCOMISPOSTESTANDAR,@Comisiones__ID_PRODUCTO,
				@Comisiones__CODAGRUPACIONPRODUCTO
    END;
    CLOSE Comisiones;
    DEALLOCATE Comisiones;
  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_CalRevenueRangoTiempoProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_CalRevenueRangoTiempoProducto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_CalRevenueRangoTiempoProducto(@p_FechaEvaluacion datetime,
                                          @p_CodProducto     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
  
    DELETE FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
     WHERE REGISTROREVENUEINCENTIVO.ID_REGISTROREVENUEINCENTIVO IN
           (SELECT REGISTROREVENUEINCENTIVO.ID_REGISTROREVENUEINCENTIVO
              FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
             INNER JOIN WSXML_SFG.REGISTROREVENUE
                ON REGISTROREVENUEINCENTIVO.CODREGISTROREVENUE =
                   REGISTROREVENUE.ID_REGISTROREVENUE
             INNER JOIN WSXML_SFG.REGISTROFACTURACION
                ON REGISTROREVENUE.CODREGISTROFACTURACION =
                   REGISTROFACTURACION.ID_REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                   ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @p_FechaEvaluacion
               AND REGISTROFACTURACION.CODPRODUCTO = @p_CodProducto
                          AND NOT(REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN 
           (
           select productocontratocomdif.Codagrupacionpuntodeventa 
           from WSXML_SFG.productocontratocomdif
          inner join WSXML_SFG.productocontrato on productocontratocomdif.codproductocontrato = productocontrato.id_productocontrato
          where productocontrato.codproducto = @p_CodProducto
          group by  productocontratocomdif.Codagrupacionpuntodeventa
           ))   
               )
       AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL;
  
    DECLARE Comisiones CURSOR FOR SELECT COMISIONRANGOTIEMPO.ID_COMISIONRANGOTIEMPO,
                              COMISIONRANGOTIEMPO.EVALUARVENTASPORAGRUPACION,
                              COMISIONRANGOTIEMPO.CODPERIODICIDAD,
                              COMISIONRANGOTIEMPO.CODTIPOEVALUACIONVENTAS,
                              COMISIONRANGOTIEMPO.FECHAINICIO,
                              COMISIONRANGOTIEMPO.FECHACALENDARIO,
                              COMISIONRANGOTIEMPO.FRECUENCIA,
                              COMISIONRANGOTIEMPO.DESCOMISPOSTESTANDAR,
                              PRODUCTO.ID_PRODUCTO,
                              PRODUCTO.CODAGRUPACIONPRODUCTO
                         FROM WSXML_SFG.COMISIONRANGOTIEMPO
                        INNER JOIN WSXML_SFG.RANGOCOMISION
                           ON COMISIONRANGOTIEMPO.CODRANGOCOMISION =
                              RANGOCOMISION.ID_RANGOCOMISION
                        INNER JOIN WSXML_SFG.PRODUCTOCONTRATO
                           ON PRODUCTOCONTRATO.CODRANGOCOMISION =
                              RANGOCOMISION.ID_RANGOCOMISION
                        INNER JOIN WSXML_SFG.PRODUCTO
                           ON PRODUCTOCONTRATO.CODPRODUCTO =
                              PRODUCTO.ID_PRODUCTO
                        WHERE PRODUCTO.ACTIVE = 1
                          AND PRODUCTO.ID_PRODUCTO = @p_CodProducto
                          AND WSXML_SFG.SFGREVENUERANGOTIEMPO_CumplePeriodicidad(@p_FechaEvaluacion,
                                                 COMISIONRANGOTIEMPO.CODPERIODICIDAD,
                                                 COMISIONRANGOTIEMPO.FRECUENCIA,
                                                 COMISIONRANGOTIEMPO.FECHAINICIO,
                                                 COMISIONRANGOTIEMPO.FECHACALENDARIO) = 1; 
	OPEN Comisiones;

		DECLARE @Comisiones__ID_COMISIONRANGOTIEMPO NUMERIC(38,0),
            @Comisiones__EVALUARVENTASPORAGRUPACION NUMERIC(22,0),
            @Comisiones__CODPERIODICIDAD NUMERIC(22,0),
            @Comisiones__CODTIPOEVALUACIONVENTAS NUMERIC(38,0),
            @Comisiones__FECHAINICIO DATETIME,
            @Comisiones__FECHACALENDARIO NUMERIC(22,0),
            @Comisiones__FRECUENCIA NUMERIC(22,0),
            @Comisiones__DESCOMISPOSTESTANDAR NUMERIC(22,0),
            @Comisiones__ID_PRODUCTO NUMERIC(38,0),
            @Comisiones__CODAGRUPACIONPRODUCTO NUMERIC(38,0)

	 FETCH NEXT FROM Comisiones INTO  @Comisiones__ID_COMISIONRANGOTIEMPO,
				@Comisiones__EVALUARVENTASPORAGRUPACION, @Comisiones__CODPERIODICIDAD,
				@Comisiones__CODTIPOEVALUACIONVENTAS,@Comisiones__FECHAINICIO,
				@Comisiones__FECHACALENDARIO,@Comisiones__FRECUENCIA,
				@Comisiones__DESCOMISPOSTESTANDAR,@Comisiones__ID_PRODUCTO,
				@Comisiones__CODAGRUPACIONPRODUCTO

	WHILE @@FETCH_STATUS=0
	BEGIN
    
        DECLARE @v_CODAGRUPACIONPRODUCTO NUMERIC(22,0);
      
        DECLARE @v_MONTOVENTASPERIODO FLOAT;
        DECLARE @v_TRXVENTASPERIODO   FLOAT;
        DECLARE @v_REVENUEPERIODO     FLOAT;
      
        DECLARE @v_MONTOVENTASSOLPRODUCTO FLOAT;
        DECLARE @v_TRXVENTASPRODUCTO      FLOAT;
        DECLARE @v_REVENUEPRODUCTO        FLOAT;
      
        DECLARE @v_FECHAINICIO DATETIME;
        DECLARE @v_FECHAFIN    DATETIME;
      
        DECLARE @v_VALORREVENUENUEVO  FLOAT;
        DECLARE @v_VALORREVENUEACTUAL FLOAT;
        DECLARE @v_VALORREVENUEDIF    FLOAT;
        DECLARE @v_VALORCOMPOSDIF     FLOAT;
        DECLARE @v_VALORREVENUECUTOFF FLOAT;
      BEGIN
        --Recalcular el producto primero para que tome la tarifa estandar bien
        EXEC WSXML_SFG.SFGREGISTROREVENUE_CalcularRevenueProducto 
			@p_FechaEvaluacion,@p_CodProducto,0
      
        --Primero calcular las fechas de inicio y fin del rango
        IF @Comisiones__CODPERIODICIDAD = 1 BEGIN
          --Diaria
          SET @v_FECHAINICIO = @p_FechaEvaluacion - @Comisiones__FRECUENCIA;
          SET @v_FECHAINICIO = @v_FECHAINICIO + 1;
          SET @v_FECHAFIN    = @p_FechaEvaluacion;
        END
        ELSE IF @Comisiones__CODPERIODICIDAD = 2 BEGIN
          --Semanal
          IF @Comisiones__FECHACALENDARIO = 1 BEGIN
            --De domingo a sabado
            --v_FECHAINICIO := NEXT_DAY(P_FECHAEVALUACION, 'sabado') - 6;
            --v_FECHAFIN    := NEXT_DAY(P_FECHAEVALUACION, 'sabado');
            SET @V_FECHAFIN    = @p_FechaEvaluacion;
            SET @v_FECHAINICIO = (@p_FechaEvaluacion -
                             (7 * @Comisiones__FRECUENCIA)) + 1;
          END
          ELSE BEGIN
            --del dia -6
            --v_FECHAINICIO := P_FECHAEVALUACION - 6;
            --v_FECHAFIN    := P_FECHAEVALUACION;
            SET @V_FECHAFIN    = @p_FechaEvaluacion;
            SET @v_FECHAINICIO = (@p_FechaEvaluacion -
                             (7 * @Comisiones__FRECUENCIA)) + 1;
          END 
        END
        ELSE IF @Comisiones__CODPERIODICIDAD = 3 BEGIN
          --Mensual
          IF @Comisiones__FECHACALENDARIO = 1 BEGIN
            --De domingo a sabado
            SET @v_FECHAINICIO = WSXML_SFG.DATESERIAL(1,
                                                  MONTH(
                                                          --addmonth('mm',P_FECHAEVALUACION),
                                                          WSXML_SFG.dateadd('mm',
                                                                  (@Comisiones__FRECUENCIA - 1) * -1,
                                                                  @p_FechaEvaluacion)),
                                                  YEAR(
                                                          -- P_FECHAEVALUACION));
                                                          WSXML_SFG.dateadd('mm',
                                                                  (@Comisiones__FRECUENCIA - 1) * -1,
                                                                  @p_FechaEvaluacion)));
            SET @v_FECHAFIN    = dbo.LAST_DAY(@p_FechaEvaluacion);
          END
          ELSE BEGIN
            --del dia -6
            SET @v_FECHAINICIO = WSXML_SFG.DATEADD('mm', -1, @p_FechaEvaluacion) + 1;
            SET @v_FECHAFIN    = @p_FechaEvaluacion;
          END 
        END
        ELSE BEGIN
          RAISERROR('-20053 Tipo de periodicidad no valido', 16, 1);
        END 
      
        --Ontener el codigo de la agrupacion del producto
        SELECT @v_CODAGRUPACIONPRODUCTO = PRODUCTO.CODAGRUPACIONPRODUCTO
          FROM WSXML_SFG.PRODUCTO
         WHERE PRODUCTO.ID_PRODUCTO = @Comisiones__ID_PRODUCTO;
      
        SELECT @v_MONTOVENTASPERIODO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO * -1
                   END),
               @v_TRXVENTASPERIODO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.NUMTRANSACCIONES
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   END),
               @v_REVENUEPERIODO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROREVENUE.REVENUETOTAL
                     ELSE
                      REGISTROREVENUE.REVENUETOTAL * -1
                   END)
          FROM WSXML_SFG.REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.PRODUCTO
            ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
         LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION

         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = CASE
                 WHEN @Comisiones__EVALUARVENTASPORAGRUPACION = 0 THEN
                  @Comisiones__ID_PRODUCTO
                 ELSE
                  REGISTROFACTURACION.CODPRODUCTO
               END
           AND PRODUCTO.CODAGRUPACIONPRODUCTO = CASE
                 WHEN @Comisiones__EVALUARVENTASPORAGRUPACION = 1 THEN
                  @v_CODAGRUPACIONPRODUCTO
                 ELSE
                  PRODUCTO.CODAGRUPACIONPRODUCTO
               END
               --modificacion 1 marzo para no tener en cuenta las cadenas diferenciales
           AND NOT(REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN 
           (
           select productocontratocomdif.Codagrupacionpuntodeventa 
           from WSXML_SFG.productocontratocomdif
          inner join WSXML_SFG.productocontrato on productocontratocomdif.codproductocontrato = productocontrato.id_productocontrato
          where productocontrato.codproducto = @p_CodProducto
          group by  productocontratocomdif.Codagrupacionpuntodeventa
           ))    ;
               
      
        --Sumar y restar cutoff en agrupaciones
       /* DECLARE
          v_CUTOFFANTTRX FLOAT;
          v_CUTOFFDESTRX FLOAT;
          v_CUTOFFANTMON FLOAT;
          v_CUTOFFDESMON FLOAT;
        BEGIN
        
          SELECT SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        1
                       ELSE
                        -1
                     END),
                 SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        REGISTROFACTREFERENCIA.VALORTRANSACCION
                       ELSE
                        REGISTROFACTREFERENCIA.VALORTRANSACCION * -1
                     END) AS VALOR
            INTO v_CUTOFFANTTRX, v_CUTOFFANTMON
            FROM TRANSACCIONALIADO
           INNER JOIN ARCHIVOTRANSACCIONALIADO
              ON TRANSACCIONALIADO.CODARCHIVOTRANSACCIONALIADO =
                 ARCHIVOTRANSACCIONALIADO.ID_ARCHIVOTRANSACCIONALIADO
           INNER JOIN REGISTROFACTREFERENCIA
              ON TRANSACCIONALIADO.CODREGISTROFACTREFERENCIA =
                 REGISTROFACTREFERENCIA.ID_REGISTROFACTREFERENCIA
           INNER JOIN REGISTROFACTURACION
              ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
                 REGISTROFACTURACION.ID_REGISTROFACTURACION
           inner join producto
              on registrofacturacion.codproducto = producto.id_producto
           INNER JOIN ENTRADAARCHIVOCONTROL
              ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                 ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
           WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO =
                 TRUNC(v_FECHAINICIO) - 1
             AND trunc(ENTRADAARCHIVOCONTROL.FECHAARCHIVO) <>
                 trunc(ARCHIVOTRANSACCIONALIADO.FECHAARCHIVO)
             AND REGISTROFACTURACION.CODPRODUCTO = CASE
                   WHEN Comisiones.EVALUARVENTASPORAGRUPACION = 0 THEN
                    Comisiones.ID_PRODUCTO
                   ELSE
                    REGISTROFACTURACION.CODPRODUCTO
                 END
             AND PRODUCTO.CODAGRUPACIONPRODUCTO = CASE
                   WHEN Comisiones.EVALUARVENTASPORAGRUPACION = 1 THEN
                    v_CODAGRUPACIONPRODUCTO
                   ELSE
                    PRODUCTO.CODAGRUPACIONPRODUCTO
                 END
             AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2);
        
          SELECT SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        1
                       ELSE
                        -1
                     END),
                 SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        REGISTROFACTREFERENCIA.VALORTRANSACCION
                       ELSE
                        REGISTROFACTREFERENCIA.VALORTRANSACCION * -1
                     END) AS VALOR
            INTO v_CUTOFFDESTRX, v_CUTOFFDESMON
            FROM TRANSACCIONALIADO
           INNER JOIN ARCHIVOTRANSACCIONALIADO
              ON TRANSACCIONALIADO.CODARCHIVOTRANSACCIONALIADO =
                 ARCHIVOTRANSACCIONALIADO.ID_ARCHIVOTRANSACCIONALIADO
           INNER JOIN REGISTROFACTREFERENCIA
              ON TRANSACCIONALIADO.CODREGISTROFACTREFERENCIA =
                 REGISTROFACTREFERENCIA.ID_REGISTROFACTREFERENCIA
           INNER JOIN REGISTROFACTURACION
              ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
                 REGISTROFACTURACION.ID_REGISTROFACTURACION
           inner join producto
              on registrofacturacion.codproducto = producto.id_producto
           INNER JOIN ENTRADAARCHIVOCONTROL
              ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                 ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
           WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = v_FECHAFIN
             AND trunc(ENTRADAARCHIVOCONTROL.FECHAARCHIVO) <>
                 trunc(ARCHIVOTRANSACCIONALIADO.FECHAARCHIVO)
             AND REGISTROFACTURACION.CODPRODUCTO = CASE
                   WHEN Comisiones.EVALUARVENTASPORAGRUPACION = 0 THEN
                    Comisiones.ID_PRODUCTO
                   ELSE
                    REGISTROFACTURACION.CODPRODUCTO
                 END
             AND PRODUCTO.CODAGRUPACIONPRODUCTO = CASE
                   WHEN Comisiones.EVALUARVENTASPORAGRUPACION = 1 THEN
                    v_CODAGRUPACIONPRODUCTO
                   ELSE
                    PRODUCTO.CODAGRUPACIONPRODUCTO
                 END
             AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2);
\*        
          v_TRXVENTASPERIODO   := (v_TRXVENTASPERIODO +
                                  NVL(v_CUTOFFANTTRX, 0)) -
                                  NVL(v_CUTOFFDESTRX, 0);
          v_MONTOVENTASPERIODO := (v_MONTOVENTASPERIODO +
                                  NVL(v_CUTOFFANTMON, 0)) -
                                  NVL(v_CUTOFFDESMON, 0);*\
        
        END;
      */
        --Obtener las ventas de solo el producto para calcular el nuevo revenue
        SELECT @v_MONTOVENTASSOLPRODUCTO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.VALORVENTABRUTANOREDONDEADO * -1
                   END),
               @v_TRXVENTASPRODUCTO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROFACTURACION.NUMTRANSACCIONES
                     ELSE /*Anulaciones*/
                      REGISTROFACTURACION.NUMTRANSACCIONES * -1
                   END),
               @v_REVENUEPRODUCTO = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 /*Ventas*/
                      THEN
                      REGISTROREVENUE.REVENUETOTAL
                     ELSE
                      REGISTROREVENUE.REVENUETOTAL * -1
                   END)
                   FROM WSXML_SFG.REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         INNER JOIN WSXML_SFG.REGISTROREVENUE
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.PRODUCTO
            ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
           --modificacion 1 marzo para no tener en cuenta las cadenas diferenciales
           AND NOT(REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN 
           (
           select productocontratocomdif.Codagrupacionpuntodeventa 
           from WSXML_SFG.productocontratocomdif
          inner join WSXML_SFG.productocontrato on productocontratocomdif.codproductocontrato = productocontrato.id_productocontrato
          where productocontrato.codproducto = @p_CodProducto
          group by  productocontratocomdif.Codagrupacionpuntodeventa
           ))    ;

           
      
        --Sumar y restar cutoff en solo producto
/*        DECLARE
          v_CUTOFFANTTRX FLOAT;
          v_CUTOFFDESTRX FLOAT;
          v_CUTOFFANTMON FLOAT;
          v_CUTOFFDESMON FLOAT;
        BEGIN
        
          SELECT SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        1
                       ELSE
                        -1
                     END),
                 SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        REGISTROFACTREFERENCIA.VALORTRANSACCION
                       ELSE
                        REGISTROFACTREFERENCIA.VALORTRANSACCION * -1
                     END) AS VALOR
            INTO v_CUTOFFANTTRX, v_CUTOFFANTMON
            FROM TRANSACCIONALIADO
           INNER JOIN ARCHIVOTRANSACCIONALIADO
              ON TRANSACCIONALIADO.CODARCHIVOTRANSACCIONALIADO =
                 ARCHIVOTRANSACCIONALIADO.ID_ARCHIVOTRANSACCIONALIADO
           INNER JOIN REGISTROFACTREFERENCIA
              ON TRANSACCIONALIADO.CODREGISTROFACTREFERENCIA =
                 REGISTROFACTREFERENCIA.ID_REGISTROFACTREFERENCIA
           INNER JOIN REGISTROFACTURACION
              ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
                 REGISTROFACTURACION.ID_REGISTROFACTURACION
           INNER JOIN ENTRADAARCHIVOCONTROL
              ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                 ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
           WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO =
                 TRUNC(v_FECHAINICIO) - 1
             AND trunc(ENTRADAARCHIVOCONTROL.FECHAARCHIVO) <>
                 trunc(ARCHIVOTRANSACCIONALIADO.FECHAARCHIVO)
             AND REGISTROFACTURACION.CODPRODUCTO = Comisiones.ID_PRODUCTO
             AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2);
        
          SELECT SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        1
                       ELSE
                        -1
                     END),
                 SUM(CASE
                       WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                        REGISTROFACTREFERENCIA.VALORTRANSACCION
                       ELSE
                        REGISTROFACTREFERENCIA.VALORTRANSACCION * -1
                     END) AS VALOR,
                 SUM(NVL(TRANSACCIONALIADO.REVENUEPORCENTUAL, 0) +
                     NVL(TRANSACCIONALIADO.REVENUETRANSACCIONAL, 0) +
                     NVL(TRANSACCIONALIADO.REVENUEFIJO, 0))
            INTO v_CUTOFFDESTRX, v_CUTOFFDESMON, v_VALORREVENUECUTOFF
            FROM TRANSACCIONALIADO
           INNER JOIN ARCHIVOTRANSACCIONALIADO
              ON TRANSACCIONALIADO.CODARCHIVOTRANSACCIONALIADO =
                 ARCHIVOTRANSACCIONALIADO.ID_ARCHIVOTRANSACCIONALIADO
           INNER JOIN REGISTROFACTREFERENCIA
              ON TRANSACCIONALIADO.CODREGISTROFACTREFERENCIA =
                 REGISTROFACTREFERENCIA.ID_REGISTROFACTREFERENCIA
           INNER JOIN REGISTROFACTURACION
              ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
                 REGISTROFACTURACION.ID_REGISTROFACTURACION
           INNER JOIN ENTRADAARCHIVOCONTROL
              ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                 ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
           WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = v_FECHAFIN
             AND trunc(ENTRADAARCHIVOCONTROL.FECHAARCHIVO) <>
                 trunc(ARCHIVOTRANSACCIONALIADO.FECHAARCHIVO)
             AND REGISTROFACTURACION.CODPRODUCTO = Comisiones.ID_PRODUCTO
             AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2);
        
\*          v_TRXVENTASPRODUCTO      := (v_TRXVENTASPRODUCTO +
                                      NVL(v_CUTOFFANTTRX, 0)) -
                                      NVL(v_CUTOFFDESTRX, 0);
          v_MONTOVENTASSOLPRODUCTO := (v_MONTOVENTASSOLPRODUCTO +
                                      NVL(v_CUTOFFANTMON, 0)) -
                                      NVL(v_CUTOFFDESMON, 0);*\
        
        END;
      */
        --Obtener el valor de la tarifa que debio obtener dependiendo de la cantidad de ventas
        SET @v_VALORREVENUENUEVO = WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenue(@Comisiones__ID_COMISIONRANGOTIEMPO,
                                               ISNULL(@v_MONTOVENTASPERIODO,0),
                                               ISNULL(@v_TRXVENTASPERIODO,0),
                                               ISNULL(@v_MONTOVENTASSOLPRODUCTO,0),
                                               ISNULL(@v_TRXVENTASPRODUCTO,0),
                                               ISNULL(@v_REVENUEPERIODO,0),
                                               ISNULL(@v_REVENUEPRODUCTO,0),
                                               @Comisiones__ID_PRODUCTO);
      
        --      v_VALORREVENUENUEVO := v_VALORREVENUENUEVO; --+
        --                               NVL(v_VALORREVENUECUTOFF, 0);
      
        /*Obtener el valor del revenue actual  */
      
        SELECT @v_VALORREVENUEACTUAL = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                      (REGISTROREVENUE.revenuetotal - CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR
                        ELSE
                         0
                      END)
                     ELSE
                      (REGISTROREVENUE.revenuetotal - CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR
                        ELSE
                         0
                      END) * -1
                   END)
          FROM WSXML_SFG.REGISTROREVENUE
         INNER JOIN WSXML_SFG.REGISTROFACTURACION
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
                --modificacion 1 marzo para no tener en cuenta las cadenas diferenciales
           AND NOT(REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN 
           (
           select productocontratocomdif.Codagrupacionpuntodeventa 
           from WSXML_SFG.productocontratocomdif
          inner join WSXML_SFG.productocontrato on productocontratocomdif.codproductocontrato = productocontrato.id_productocontrato
          where productocontrato.codproducto = @p_CodProducto
          group by  productocontratocomdif.Codagrupacionpuntodeventa
           ))    ;
     
      
        --Descontar la comision estandar de las redes que tienen comision diferencia
      
        SELECT @v_VALORCOMPOSDIF = SUM(CASE
                     WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                      (CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR
                        ELSE
                         0
                      END)
                     ELSE
                      (CASE
                        WHEN @Comisiones__DESCOMISPOSTESTANDAR = 1 THEN
                         REGISTROREVENUE.VALORCOMISIONESTANDAR * -1
                        ELSE
                         0
                      END)
                   END)
          FROM WSXML_SFG.REGISTROREVENUE
         INNER JOIN WSXML_SFG.REGISTROFACTURACION
            ON REGISTROREVENUE.CODREGISTROFACTURACION =
               REGISTROFACTURACION.ID_REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
            ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
               ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND
               @v_FECHAFIN
           AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
           AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
           AND REGISTROFACTURACION.CODREDPDV IN
               (SELECT PRODUCTOCONTRATOCOMDIF.CODREDPDV
                  FROM WSXML_SFG.PRODUCTOCONTRATOCOMDIF
                 INNER JOIN WSXML_SFG.PRODUCTOCONTRATO
                    ON PRODUCTOCONTRATOCOMDIF.CODPRODUCTOCONTRATO =
                       PRODUCTOCONTRATO.ID_PRODUCTOCONTRATO
                 WHERE PRODUCTOCONTRATO.CODPRODUCTO = @Comisiones__ID_PRODUCTO);
      
        SET @v_VALORREVENUEACTUAL = isnull(@v_VALORREVENUEACTUAL,0) +
                                ISNULL(@v_VALORCOMPOSDIF, 0);
      
        --Calcular diferencia
        SET @v_VALORREVENUEDIF = isnull(@v_VALORREVENUENUEVO,0) - isnull(@v_VALORREVENUEACTUAL,0);
      
        --Ahora toca asignar el valor de los incentivos a cada rango de solo el producto ( no importa el parametro
        -- de evaluar ventas por agrupacion producto por que solo sirve para la evalucacion de las ventas )
          DECLARE @v_TOTALTRX          NUMERIC(22,0);
          DECLARE @v_VALORXTRANSACCION FLOAT;
          DECLARE @v_COUNTCADENAS      NUMERIC(22,0);
        BEGIN
        
          SELECT @v_COUNTCADENAS = COUNT(1)
            FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
           WHERE CODCOMISIONRANGOTIEMPO = @Comisiones__ID_COMISIONRANGOTIEMPO;
        
          IF @v_COUNTCADENAS = 0 BEGIN
            --Asignar a toda la red
            SELECT @v_TOTALTRX = ISNULL(SUM(CASE
                             WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                              REGISTROFACTURACION.NUMTRANSACCIONES
                             ELSE
                              REGISTROFACTURACION.NUMTRANSACCIONES * -1
                           END),
                       0)
              FROM WSXML_SFG.REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                   ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
               AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
               AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
                              --modificacion 1 marzo para no tener en cuenta las cadenas diferenciales
           AND NOT(REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN 
           (
           select productocontratocomdif.Codagrupacionpuntodeventa 
           from WSXML_SFG.productocontratocomdif
          inner join WSXML_SFG.productocontrato on productocontratocomdif.codproductocontrato = productocontrato.id_productocontrato
          where productocontrato.codproducto = @p_CodProducto
          group by  productocontratocomdif.Codagrupacionpuntodeventa
           ))    ;

          END
          ELSE BEGIN
            SELECT @v_TOTALTRX = ISNULL(SUM(CASE
                             WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN
                              REGISTROFACTURACION.NUMTRANSACCIONES
                             ELSE
                              REGISTROFACTURACION.NUMTRANSACCIONES * -1
                           END),
                       0)
              FROM WSXML_SFG.REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                   ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
               AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
               AND REGISTROFACTURACION.CODPRODUCTO = @Comisiones__ID_PRODUCTO
               AND REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN
                   (SELECT COMISIONRANGOTIEMPOXAGRUP.CODAGRUPACIONPUNTOVENTA
                      FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
                     WHERE CODCOMISIONRANGOTIEMPO =
                           @Comisiones__ID_COMISIONRANGOTIEMPO);
          
          END 
        
          IF @v_TOTALTRX = 0 BEGIN
            --No hay registros... crear uno vacio
              DECLARE @v_IDNEWREGISTROFACTURACION NUMERIC(22,0);
              DECLARE @v_CODPUNTODEVENTA          NUMERIC(22,0);
            BEGIN
              IF @v_COUNTCADENAS > 0 BEGIN
                SELECT @v_CODPUNTODEVENTA = MAX(ID_PUNTODEVENTA)
                  FROM WSXML_SFG.PUNTODEVENTA
                 WHERE ACTIVE = 1
                   AND CODAGRUPACIONPUNTODEVENTA IN
                       (SELECT COMISIONRANGOTIEMPOXAGRUP.CODAGRUPACIONPUNTOVENTA
                          FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
                         WHERE CODCOMISIONRANGOTIEMPO =
                               @Comisiones__ID_COMISIONRANGOTIEMPO);
                IF @v_CODPUNTODEVENTA IS NULL BEGIN
                  SELECT @v_CODPUNTODEVENTA = CAST(VALOR AS NUMERIC(22,0))
                    FROM WSXML_SFG.PARAMETRO
                   WHERE NOMPARAMETRO = 'PUNTO DE VENTA DUMMY';
                
                END 
              
              END
              ELSE BEGIN
              
                SELECT @v_CODPUNTODEVENTA = CAST(VALOR AS NUMERIC(22,0))
                  FROM WSXML_SFG.PARAMETRO
                 WHERE NOMPARAMETRO = 'PUNTO DE VENTA DUMMY';
              END 
            
              EXEC WSXML_SFG.SFGREVENUERANGOTIEMPO_CrearRegistroFacturacionVacio 
											@v_CODPUNTODEVENTA,
                                            @Comisiones__ID_PRODUCTO,
                                            @v_FECHAFIN,
                                            1 /*Venta*/,
                                            1 /*usuario Sistema*/,
                                            @v_IDNEWREGISTROFACTURACION OUT
              --Calculamos el revenue de la transaccion para que se creen los registros de registro revenue.
              EXEC WSXML_SFG.SFGREGISTROREVENUE_CalcularRevenueRegistro @v_IDNEWREGISTROFACTURACION, NULL, NULL
            
              SET @v_VALORXTRANSACCION = ISNULL(@v_VALORREVENUEDIF, 0);
            
              --Validar si existen registros de registrorevenueincentivo y borrarlos
            
              DELETE FROM WSXML_SFG.REGISTROREVENUEINCENTIVO
               WHERE CODREGISTROREVENUE IN
                     (SELECT ID_REGISTROREVENUE
                        FROM WSXML_SFG.REGISTROREVENUE
                       INNER JOIN WSXML_SFG.REGISTROFACTURACION
                          ON REGISTROREVENUE.CODREGISTROFACTURACION =
                             REGISTROFACTURACION.ID_REGISTROFACTURACION
                       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN
                             @v_FECHAINICIO AND @v_FECHAFIN
                         AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                         AND REGISTROFACTURACION.CODPRODUCTO =
                             @Comisiones__ID_PRODUCTO)
                 AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL; /*Esto valida que no s una tarifa fija normal si no por rangos de tiempo */
            
              --Solo va a haber un registro revenue
              INSERT INTO WSXML_SFG.REGISTROREVENUEINCENTIVO
                (--ID_REGISTROREVENUEINCENTIVO,
                 CODREGISTROREVENUE,
                 CODINCENTIVOCOMISIONGLOBAL,
                 REVENUE)
              
                SELECT --REGISTROREVENUEINCENTIVO_SEQ.NEXTVAL,
                       REGISTROREVENUE.ID_REGISTROREVENUE,
                       NULL,
                       ISNULL(@v_VALORXTRANSACCION, 0)
                  FROM WSXML_SFG.REGISTROREVENUE
                 INNER JOIN WSXML_SFG.REGISTROFACTURACION
                    ON REGISTROREVENUE.CODREGISTROFACTURACION =
                       REGISTROFACTURACION.ID_REGISTROFACTURACION
                 INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                    ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                       ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                 WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
                   AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                   AND REGISTROFACTURACION.CODPRODUCTO =
                       @Comisiones__ID_PRODUCTO
                   AND REGISTROFACTURACION.ID_REGISTROFACTURACION =
                       @v_IDNEWREGISTROFACTURACION;
            
            END;
          END
          ELSE BEGIN
            --sI HAY REGISTROS
            BEGIN
              SET @v_VALORXTRANSACCION = @v_VALORREVENUEDIF / @v_TOTALTRX;
            
              --Validar si existen registros de registrorevenueincentivo y borrarlos
            
              DELETE FROM REGISTROREVENUEINCENTIVO
               WHERE CODREGISTROREVENUE IN
                     (SELECT ID_REGISTROREVENUE
                        FROM WSXML_SFG.REGISTROREVENUE
                       INNER JOIN WSXML_SFG.REGISTROFACTURACION
                          ON REGISTROREVENUE.CODREGISTROFACTURACION =
                             REGISTROFACTURACION.ID_REGISTROFACTURACION
                       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN
                             @v_FECHAINICIO AND @v_FECHAFIN
                         AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                         AND REGISTROFACTURACION.CODPRODUCTO =
                             @Comisiones__ID_PRODUCTO)
                 AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL; /*Esto valida que no s una tarifa fija normal si no por rangos de tiempo */
            
              IF @v_COUNTCADENAS = 0 BEGIN
                --Asignar a toda la red
                INSERT INTO WSXML_SFG.REGISTROREVENUEINCENTIVO
                  (--ID_REGISTROREVENUEINCENTIVO,
                   CODREGISTROREVENUE,
                   CODINCENTIVOCOMISIONGLOBAL,
                   REVENUE)
                
                  SELECT --REGISTROREVENUEINCENTIVO_SEQ.NEXTVAL,
                         REGISTROREVENUE.ID_REGISTROREVENUE,
                         NULL,
                         REGISTROFACTURACION.NUMTRANSACCIONES *
                         ISNULL(@v_VALORXTRANSACCION, 0)
                    FROM WSXML_SFG.REGISTROREVENUE
                   INNER JOIN WSXML_SFG.REGISTROFACTURACION
                      ON REGISTROREVENUE.CODREGISTROFACTURACION =
                         REGISTROFACTURACION.ID_REGISTROFACTURACION
                   INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                      ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                         ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                   WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
                     AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                     AND REGISTROFACTURACION.CODPRODUCTO =
                         @Comisiones__ID_PRODUCTO
                                        --modificacion 1 marzo para no tener en cuenta las cadenas diferenciales
           AND NOT(REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN 
           (
           select productocontratocomdif.Codagrupacionpuntodeventa 
           from WSXML_SFG.productocontratocomdif
          inner join WSXML_SFG.productocontrato on productocontratocomdif.codproductocontrato = productocontrato.id_productocontrato
          where productocontrato.codproducto = @p_CodProducto
          group by  productocontratocomdif.Codagrupacionpuntodeventa
           ))    ;

              
              END
              ELSE BEGIN
                --Asignar solo a las cadenas definidas;
                INSERT INTO WSXML_SFG.REGISTROREVENUEINCENTIVO
                  (--ID_REGISTROREVENUEINCENTIVO,
                   CODREGISTROREVENUE,
                   CODINCENTIVOCOMISIONGLOBAL,
                   REVENUE)
                  SELECT --REGISTROREVENUEINCENTIVO_SEQ.NEXTVAL,
                         REGISTROREVENUE.ID_REGISTROREVENUE,
                         NULL,
                         REGISTROFACTURACION.NUMTRANSACCIONES *
                         @v_VALORXTRANSACCION
                    FROM WSXML_SFG.REGISTROREVENUE
                   INNER JOIN WSXML_SFG.REGISTROFACTURACION
                      ON REGISTROREVENUE.CODREGISTROFACTURACION =
                         REGISTROFACTURACION.ID_REGISTROFACTURACION
                   INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                      ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
                         ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                   WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @v_FECHAFIN
                     AND REGISTROFACTURACION.CODTIPOREGISTRO IN (1, 2)
                     AND REGISTROFACTURACION.CODPRODUCTO =
                         @Comisiones__ID_PRODUCTO
                     AND REGISTROFACTURACION.CODAGRUPACIONPUNTODEVENTA IN
                         (SELECT COMISIONRANGOTIEMPOXAGRUP.CODAGRUPACIONPUNTOVENTA
                            FROM WSXML_SFG.COMISIONRANGOTIEMPOXAGRUP
                           WHERE CODCOMISIONRANGOTIEMPO =
                                 @Comisiones__ID_COMISIONRANGOTIEMPO);
              
              END 
            
            END;
          END 
        
        END;
      
      END;
    	 FETCH NEXT FROM Comisiones INTO  @Comisiones__ID_COMISIONRANGOTIEMPO,
				@Comisiones__EVALUARVENTASPORAGRUPACION, @Comisiones__CODPERIODICIDAD,
				@Comisiones__CODTIPOEVALUACIONVENTAS,@Comisiones__FECHAINICIO,
				@Comisiones__FECHACALENDARIO,@Comisiones__FRECUENCIA,
				@Comisiones__DESCOMISPOSTESTANDAR,@Comisiones__ID_PRODUCTO,
				@Comisiones__CODAGRUPACIONPRODUCTO
    END;
    CLOSE Comisiones;
    DEALLOCATE Comisiones;
  
  END;
 GO
 
IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_CrearRegistroFacturacionVacio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_CrearRegistroFacturacionVacio;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREVENUERANGOTIEMPO_CrearRegistroFacturacionVacio(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                                          @p_CODPRODUCTO            NUMERIC(22,0),
                                          @p_FECHA                  DATETIME,
                                          @p_CODTIPOREGISTRO        NUMERIC(22,0),
                                          @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                                          @P_ID_REGISTROFACTURACION NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @v_COUNT NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @V_COUNT = COUNT(1)
      FROM WSXML_SFG.REGISTROFACTURACION
     INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
        ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
           ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
     WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @p_FECHA
       AND REGISTROFACTURACION.CODPRODUCTO = @p_CODPRODUCTO
       AND REGISTROFACTURACION.CODTIPOREGISTRO = @p_CODTIPOREGISTRO
       AND REGISTROFACTURACION.CODPUNTODEVENTA = @p_CODPUNTODEVENTA;
  
    IF @v_COUNT = 0 BEGIN
        DECLARE @p_CODRANGOCOMISION NUMERIC(22,0);
        DECLARE @p_ANTICIPO         NUMERIC(22,0);
        -- Reglas de facturacion aplicadas
        DECLARE @p_CODCOMPANIA               NUMERIC(22,0);
        DECLARE @p_CODREGIMEN                NUMERIC(22,0); --
        DECLARE @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0); --
        DECLARE @p_CODREDPDV                 NUMERIC(22,0); --
        DECLARE @p_IDENTIFICACION            NUMERIC(22,0); --
        DECLARE @p_DIGITOVERIFICACION        NUMERIC(22,0); --
        DECLARE @p_CODCIUDAD                 NUMERIC(22,0); --
        DECLARE @p_CODTIPOCONTRATOPDV        NUMERIC(22,0);
        DECLARE @p_CODRAZONSOCIAL            NUMERIC(22,0); --
        DECLARE @p_CODTIPOCONTRATOPRODUCTO   NUMERIC(22,0);
        DECLARE @TMPID                       NUMERIC(22,0);
        DECLARE @P_CODSERVICIO               NUMERIC(22,0);
        DECLARE @p_CODENTRADAARCHIVOCONTROL  NUMERIC(22,0);
        DECLARE @p_CODCANALNEGOCIO           NUMERIC(22,0);
      
      BEGIN
      
        SELECT @p_CODREGIMEN = PUNTODEVENTA.CODREGIMEN,
               @p_CODAGRUPACIONPUNTODEVENTA = PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA,
               @p_CODREDPDV = PUNTODEVENTA.CODREDPDV,
               @p_IDENTIFICACION = PUNTODEVENTA.IDENTIFICACION,
               @p_DIGITOVERIFICACION = PUNTODEVENTA.DIGITOVERIFICACION,
               @p_CODCIUDAD = PUNTODEVENTA.CODCIUDAD,
               @p_CODRAZONSOCIAL = PUNTODEVENTA.CODRAZONSOCIAL,
               @p_CODCANALNEGOCIO = REDPDV.CODCANALNEGOCIO
                   FROM WSXML_SFG.PUNTODEVENTA
          INNER JOIN WSXML_SFG.REDPDV ON PUNTODEVENTA.CODREDPDV = REDPDV.ID_REDPDV
         WHERE PUNTODEVENTA.ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
      
        SELECT @p_CODTIPOCONTRATOPRODUCTO = PRODUCTOCONTRATO.CODTIPOCONTRATOPRODUCTO
          FROM WSXML_SFG.PRODUCTOCONTRATO
         INNER JOIN WSXML_SFG.PRODUCTO
            ON PRODUCTOCONTRATO.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
         WHERE PRODUCTO.ID_PRODUCTO = @p_CODPRODUCTO;
      
        SELECT @p_CODCOMPANIA = RAZONSOCIALCONTRATO.CODCOMPANIA,
               @p_CODTIPOCONTRATOPDV = RAZONSOCIALCONTRATO.CODTIPOCONTRATOPDV,
               @P_CODSERVICIO = LINEADENEGOCIO.CODSERVICIO
          FROM WSXML_SFG.RAZONSOCIALCONTRATO
         INNER JOIN WSXML_SFG.SERVICIO
            ON RAZONSOCIALCONTRATO.CODSERVICIO = SERVICIO.ID_SERVICIO
         INNER JOIN WSXML_SFG.LINEADENEGOCIO
            ON LINEADENEGOCIO.CODSERVICIO = SERVICIO.ID_SERVICIO
         INNER JOIN WSXML_SFG.TIPOPRODUCTO
            ON TIPOPRODUCTO.CODLINEADENEGOCIO =
               LINEADENEGOCIO.ID_LINEADENEGOCIO
         INNER JOIN WSXML_SFG.PRODUCTO
            ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
         WHERE PRODUCTO.ID_PRODUCTO = @p_CODPRODUCTO
           AND RAZONSOCIALCONTRATO.CODRAZONSOCIAL = @p_CODRAZONSOCIAL
           AND RAZONSOCIALCONTRATO.CODCANALNEGOCIO = @p_CODCANALNEGOCIO;

      
        SELECT @p_CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
          FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
         WHERE FECHAARCHIVO = @p_FECHA
           AND TIPOARCHIVO = @P_CODSERVICIO
           AND ACTIVE = 1;
      
			EXEC WSXML_SFG.SFGPLANTILLAPRODUCTO_GetPinpointComissionValues  
														@p_CODPUNTODEVENTA,
                                                        @p_CODPRODUCTO,
                                                        @p_CODRANGOCOMISION OUT,
                                                        @TMPID OUT,
                                                        @TMPID OUT,
                                                        @TMPID OUT,
                                                        @TMPID OUT,
                                                        @TMPID OUT,
                                                        @p_ANTICIPO  OUT
      
			EXEC WSXML_SFG.SFGREGISTROFACTURACION_AddRecord 
										@p_CODENTRADAARCHIVOCONTROL,
                                         @p_CODPUNTODEVENTA,
                                         @p_CODPRODUCTO,
                                         @p_CODTIPOREGISTRO,
                                         0,
                                         @p_FECHA,
                                         0,
                                         @p_CODRANGOCOMISION,
                                         @p_ANTICIPO,
                                         0,
                                         0,
                                         @p_CODCOMPANIA,
                                         @p_CODREGIMEN,
                                         @p_CODAGRUPACIONPUNTODEVENTA,
                                         @p_CODREDPDV,
                                         @p_IDENTIFICACION,
                                         @p_DIGITOVERIFICACION,
                                         @p_CODCIUDAD,
                                         @p_CODTIPOCONTRATOPDV,
                                         @p_CODRAZONSOCIAL,
                                         @p_CODTIPOCONTRATOPRODUCTO,
                                         1,
                                         @p_CODUSUARIOMODIFICACION,
                                         @P_ID_REGISTROFACTURACION OUT
      END;
    END
    ELSE BEGIN
      SELECT @P_ID_REGISTROFACTURACION = MAX(ID_REGISTROFACTURACION)
        FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
          ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =
             ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO = @p_FECHA
         AND REGISTROFACTURACION.CODPRODUCTO = @p_CODPRODUCTO
         AND REGISTROFACTURACION.CODTIPOREGISTRO = @p_CODTIPOREGISTRO
         AND REGISTROFACTURACION.CODPUNTODEVENTA = @p_CODPUNTODEVENTA;
    
    END 
  
  END;
GO
 
IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenueNo', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenueNo;
GO

CREATE     FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenueNo(@p_CODCOMISIONRANGOTIEMPO NUMERIC(22,0),
                             @p_MONTOVENTASPERIODO     FLOAT,
                             @p_TRXVENTASPERIODO       FLOAT,
                             @p_MONTOVENTASSOLPRODUCTO FLOAT,
                             @p_TRXVENTASPRODUCTO      FLOAT) RETURNS FLOAT AS
 BEGIN
  
    DECLARE @v_CODTIPOEVALUACIONVENTAS NUMERIC(22,0);
    DECLARE @v_APLICARCADAGRUPO        NUMERIC(22,0);
  
    DECLARE @v_VALORREVENUENUEVO FLOAT;
  
    DECLARE @v_TARIFAFIJA          FLOAT;
    DECLARE @v_TARIFAPORCENTUAL    FLOAT;
    DECLARE @v_TARIFATRANSACCIONAL FLOAT;
   
  
    SELECT @v_CODTIPOEVALUACIONVENTAS = COMISIONRANGOTIEMPO.CODTIPOEVALUACIONVENTAS,
           @v_APLICARCADAGRUPO = COMISIONRANGOTIEMPO.APLICARCADAGRUPO
      FROM WSXML_SFG.COMISIONRANGOTIEMPO
     WHERE ID_COMISIONRANGOTIEMPO = @p_CODCOMISIONRANGOTIEMPO;
  
	DECLARE @RANGOINICIAL  FLOAT, @RANGOFINAL FLOAT, @TARIFAPORCENTUAL FLOAT, @TARIFATRANSACIONAL FLOAT, @FIJO FLOAT
    
	IF ISNULL(@v_APLICARCADAGRUPO, 0) = 0 BEGIN
      Declare Rangos Cursor for SELECT COMISIONRANGOTIEMPODETALLE.RANGOINICIAL,
                            COMISIONRANGOTIEMPODETALLE.RANGOFINAL,
                            COMISIONRANGOTIEMPODETALLE.TARIFAPORCENTUAL,
                            COMISIONRANGOTIEMPODETALLE.TARIFATRANSACIONAL,
                            COMISIONRANGOTIEMPODETALLE.FIJO
                       FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
                      WHERE CODCOMISIONRANGOTIEMPO =
                            @p_CODCOMISIONRANGOTIEMPO
                      ORDER BY ID_COMISIONRANGOTIEMPODETALLE; OPEN Rangos;

	

		FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
 
		WHILE @@FETCH_STATUS=0
		BEGIN
			BEGIN
				  IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
					-- VENTAS
					IF @RANGOINICIAL = 0 AND @p_MONTOVENTASPERIODO <= 0 BEGIN
					  SET @v_TARIFAFIJA          = @FIJO;
					  SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
					  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					END
					ELSE IF @p_MONTOVENTASPERIODO >= @RANGOINICIAL AND
						  @p_MONTOVENTASPERIODO <= @RANGOFINAL BEGIN
					  SET @v_TARIFAFIJA          = @FIJO;
					  SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
					  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					END
					ELSE IF @RANGOFINAL = 0 AND
						  @p_MONTOVENTASPERIODO >= @RANGOINICIAL BEGIN
					  SET @v_TARIFAFIJA          = @FIJO;
					  SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
					  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					END 
				  END
				  ELSE IF @v_CODTIPOEVALUACIONVENTAS = 2 BEGIN
					-- TRANSACCIONES
					IF @RANGOINICIAL = 0 AND @p_TRXVENTASPERIODO <= 0 BEGIN
					  SET @v_TARIFAFIJA          = @FIJO;
					  SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
					  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					END
					ELSE IF @p_TRXVENTASPERIODO >= @RANGOINICIAL AND
						  @p_TRXVENTASPERIODO <= @RANGOFINAL BEGIN
					  SET @v_TARIFAFIJA          = @FIJO;
					  SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
					  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					END
					ELSE IF @RANGOFINAL = 0 AND
						  @p_TRXVENTASPERIODO >= @RANGOINICIAL BEGIN
					  SET @v_TARIFAFIJA          = @FIJO;
					  SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
					  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					END 
				  END
				  ELSE BEGIN
					RETURN CAST('-20053 Tipo de evaluacion de ventas no valido' AS FLOAT);
				  END 
        
			END;
      FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
      END;
      CLOSE Rangos;
      DEALLOCATE Rangos;
      /*en este punto ya tengo el valor de las tarifas que se deben aplicar.
      Ahora calcular los valores del revenue que se debeira tener*/
    
      SET @v_VALORREVENUENUEVO = ISNULL(@v_TARIFAFIJA, 0);
      SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                             (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
                             @p_TRXVENTASPRODUCTO);
      SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                             ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
                             @p_MONTOVENTASSOLPRODUCTO);
    END
    ELSE BEGIN
      SET @v_VALORREVENUENUEVO = 0;
        DECLARE @v_MONTOYAAPLICADO FLOAT;
        DECLARE @v_VALORATRABAJAR  FLOAT;
      BEGIN
        SET @v_MONTOYAAPLICADO = 0;
        Declare Rangos Cursor for SELECT COMISIONRANGOTIEMPODETALLE.RANGOINICIAL,
                              COMISIONRANGOTIEMPODETALLE.RANGOFINAL,
                              COMISIONRANGOTIEMPODETALLE.TARIFAPORCENTUAL,
                              COMISIONRANGOTIEMPODETALLE.TARIFATRANSACIONAL,
                              COMISIONRANGOTIEMPODETALLE.FIJO
                         FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
                        WHERE CODCOMISIONRANGOTIEMPO =
                              @p_CODCOMISIONRANGOTIEMPO
                        ORDER BY COMISIONRANGOTIEMPODETALLE.RANGOINICIAL; OPEN Rangos;
		 FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
		 WHILE @@FETCH_STATUS=0
		 BEGIN
				  BEGIN
					IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
					  SET @v_TARIFAFIJA          = 0;
					  SET @v_TARIFAPORCENTUAL    = 0;
					  SET @v_TARIFATRANSACCIONAL = 0;
					  -- VENTAS
					  IF @p_MONTOVENTASPERIODO >= @RANGOFINAL and
						 @RANGOFINAL <> 0 BEGIN
						--Toca aplicarlo
					  
						SET @v_VALORATRABAJAR  = @RANGOFINAL - @v_MONTOYAAPLICADO;
						SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
					  
						SET @v_TARIFAFIJA       = @FIJO;
						SET @v_TARIFAPORCENTUAL = @TARIFAPORCENTUAL;
					  
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
											   ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
											   @v_VALORATRABAJAR);
					  
					  END
					  ELSE BEGIN
						-- si el monto es menor que el rango final esta seria la ultima ejecucion
					  
						SET @v_VALORATRABAJAR  = @p_MONTOVENTASSOLPRODUCTO -
											 @v_MONTOYAAPLICADO;
						SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
					  
						SET @v_TARIFAFIJA       = @FIJO;
						SET @v_TARIFAPORCENTUAL = @TARIFAPORCENTUAL;
					  
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
											   ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
											   @v_VALORATRABAJAR);
					  
						RETURN 0
					  END 
					
					END
					ELSE IF @v_CODTIPOEVALUACIONVENTAS = 2 BEGIN
					
					  SET @v_TARIFAFIJA          = 0;
					  SET @v_TARIFAPORCENTUAL    = 0;
					  SET @v_TARIFATRANSACCIONAL = 0;
					  -- VENTAS
					  IF @p_TRXVENTASPERIODO >= @RANGOFINAL and
						 @RANGOFINAL <> 0 BEGIN
						--Toca aplicarlo
					  
						SET @v_VALORATRABAJAR  = @RANGOFINAL - @v_MONTOYAAPLICADO;
						SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
					  
						SET @v_TARIFAFIJA          = @FIJO;
						SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					  
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
											   (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
											   @v_VALORATRABAJAR);
					  
					  END
					  ELSE BEGIN
					  
						SET @v_VALORATRABAJAR  = @p_TRXVENTASPERIODO - @v_MONTOYAAPLICADO;
						SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
					  
						SET @v_TARIFAFIJA          = @FIJO;
						SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
					  
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
						SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
											   (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
											   @v_VALORATRABAJAR);
					  
						RETURN 0;
					  END 
					
					END
					ELSE BEGIN
					  RETURN CAST('-20053 Tipo de evaluacion de ventas no valido' AS FLOAT);
					END 
				  
				  END;
				FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
				END;
				CLOSE Rangos;
				DEALLOCATE Rangos;
      
      END;
    END 
    return @v_VALORREVENUENUEVO;
  END;
 GO

  IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenue', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenue;
GO

CREATE     FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenue(@p_CODCOMISIONRANGOTIEMPO NUMERIC(22,0),
                           @p_MONTOVENTASPERIODO     FLOAT,
                           @p_TRXVENTASPERIODO       FLOAT,
                           @p_MONTOVENTASSOLPRODUCTO FLOAT,
                           @p_TRXVENTASPRODUCTO      FLOAT,
                           @p_VALORREVAGRUPACION     FLOAT,
                           @p_VALORREVPRODUCTO       FLOAT,
                           @p_CODPRODUCTO            FLOAT) RETURNS FLOAT AS
 BEGIN
  
    DECLARE @v_CODTIPOEVALUACIONVENTAS NUMERIC(22,0);
    DECLARE @v_APLICARCADAGRUPO        NUMERIC(22,0);
    DECLARE @v_EVALUARVENTASXGRUPO     NUMERIC(22,0);
  
    DECLARE @v_VALORREVENUENUEVO FLOAT;
  
    DECLARE @v_TARIFAFIJA          FLOAT;
    DECLARE @v_TARIFAPORCENTUAL    FLOAT;
    DECLARE @v_TARIFATRANSACCIONAL FLOAT;
   
  
    SELECT @v_CODTIPOEVALUACIONVENTAS = COMISIONRANGOTIEMPO.CODTIPOEVALUACIONVENTAS,
           @v_APLICARCADAGRUPO = COMISIONRANGOTIEMPO.APLICARCADAGRUPO,
           @v_EVALUARVENTASXGRUPO = COMISIONRANGOTIEMPO.EVALUARVENTASPORAGRUPACION
           FROM WSXML_SFG.COMISIONRANGOTIEMPO
     WHERE ID_COMISIONRANGOTIEMPO = @p_CODCOMISIONRANGOTIEMPO;
  
	DECLARE @RANGOINICIAL  FLOAT, @RANGOFINAL FLOAT, @TARIFAPORCENTUAL FLOAT, @TARIFATRANSACIONAL FLOAT, @FIJO FLOAT
	
    IF ISNULL(@v_APLICARCADAGRUPO, 0) = 0 BEGIN
      Declare Rangos Cursor for SELECT COMISIONRANGOTIEMPODETALLE.RANGOINICIAL,
                            COMISIONRANGOTIEMPODETALLE.RANGOFINAL,
                            COMISIONRANGOTIEMPODETALLE.TARIFAPORCENTUAL,
                            COMISIONRANGOTIEMPODETALLE.TARIFATRANSACIONAL,
                            COMISIONRANGOTIEMPODETALLE.FIJO
                       FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
                      WHERE CODCOMISIONRANGOTIEMPO =
                            @p_CODCOMISIONRANGOTIEMPO
                      ORDER BY ID_COMISIONRANGOTIEMPODETALLE; OPEN Rangos;
 
		
		FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
		
	 WHILE @@FETCH_STATUS=0
	 BEGIN
        BEGIN
          IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
            -- VENTAS
            IF @RANGOINICIAL = 0 AND @p_MONTOVENTASPERIODO <= 0 BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @p_MONTOVENTASPERIODO >= @RANGOINICIAL AND
                  @p_MONTOVENTASPERIODO <= @RANGOFINAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @RANGOFINAL = 0 AND @p_MONTOVENTASPERIODO >= @RANGOINICIAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END 
          END
          ELSE IF @v_CODTIPOEVALUACIONVENTAS = 2 BEGIN
            -- TRANSACCIONES
            IF @RANGOINICIAL = 0 AND @p_TRXVENTASPERIODO <= 0 BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @p_TRXVENTASPERIODO >= @RANGOINICIAL AND @p_TRXVENTASPERIODO <= @RANGOFINAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @RANGOFINAL = 0 AND @p_TRXVENTASPERIODO >= @RANGOINICIAL BEGIN
				SET @v_TARIFAFIJA          = @FIJO;
				SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
				SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END 
          END
          ELSE BEGIN
            RETURN CAST('-20053 Tipo de evaluacion de ventas no valido' AS FLOAT);
          END 
        
        END;
      FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
      END;
      CLOSE Rangos;
      DEALLOCATE Rangos;
      /*en este punto ya tengo el valor de las tarifas que se deben aplicar.
      Ahora calcular los valores del revenue que se debeira tener*/
    
      SET @v_VALORREVENUENUEVO = ISNULL(@v_TARIFAFIJA, 0);
      SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + (ISNULL(@v_TARIFATRANSACCIONAL, 0) * @p_TRXVENTASPRODUCTO);
      SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) * @p_MONTOVENTASSOLPRODUCTO);
    END
    ELSE BEGIN
      SET @v_VALORREVENUENUEVO = 0;
        DECLARE @v_MONTOYAAPLICADO FLOAT;
        DECLARE @v_VALORATRABAJAR  FLOAT;
      BEGIN
        SET @v_MONTOYAAPLICADO = 0;
        Declare Rangos Cursor for SELECT COMISIONRANGOTIEMPODETALLE.RANGOINICIAL,
                              COMISIONRANGOTIEMPODETALLE.RANGOFINAL,
                              COMISIONRANGOTIEMPODETALLE.TARIFAPORCENTUAL,
                              COMISIONRANGOTIEMPODETALLE.TARIFATRANSACIONAL,
                              COMISIONRANGOTIEMPODETALLE.FIJO
                         FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
                        WHERE CODCOMISIONRANGOTIEMPO =
                              @p_CODCOMISIONRANGOTIEMPO
                        ORDER BY COMISIONRANGOTIEMPODETALLE.RANGOINICIAL; OPEN Rangos;
						
	 FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
	 WHILE @@FETCH_STATUS=0
	 BEGIN
		BEGIN
            IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
              --Ventas
              SET @v_TARIFAFIJA          = 0;
              SET @v_TARIFAPORCENTUAL    = 0;
              SET @v_TARIFATRANSACCIONAL = 0;
            
              IF @v_EVALUARVENTASXGRUPO = 1 BEGIN
                -- VENTAS
                IF @p_MONTOVENTASPERIODO >= @RANGOFINAL and
                   @RANGOFINAL <> 0 BEGIN
                  --Toca aplicarlo
                
                  SET @v_VALORATRABAJAR  = @RANGOFINAL -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA       = @FIJO;
                  SET @v_TARIFAPORCENTUAL = @TARIFAPORCENTUAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
                                         @v_VALORATRABAJAR);
                
                END
                ELSE BEGIN
                  -- si el monto es menor que el rango final esta seria la ultima ejecucion
                
                  SET @v_VALORATRABAJAR  = @p_MONTOVENTASPERIODO -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA       = @FIJO;
                  SET @v_TARIFAPORCENTUAL = @TARIFAPORCENTUAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
                                         @v_VALORATRABAJAR);
                
                  RETURN 0
                END 
              
              END
              ELSE BEGIN
              
                -- VENTAS
                IF @p_MONTOVENTASSOLPRODUCTO >= @RANGOFINAL and
                   @RANGOFINAL <> 0 BEGIN
                  --Toca aplicarlo
                
                  SET @v_VALORATRABAJAR  = @RANGOFINAL -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA       = @FIJO;
                  SET @v_TARIFAPORCENTUAL = @TARIFAPORCENTUAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
                                         @v_VALORATRABAJAR);
                
                END
                ELSE BEGIN
                  -- si el monto es menor que el rango final esta seria la ultima ejecucion
                
                  SET @v_VALORATRABAJAR  = @p_MONTOVENTASSOLPRODUCTO -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA       = @FIJO;
                  SET @v_TARIFAPORCENTUAL = @TARIFAPORCENTUAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
                                         @v_VALORATRABAJAR);
                
					RETURN 0
                END 
              
              END 
            
            END
            ELSE IF @v_CODTIPOEVALUACIONVENTAS = 2 BEGIN
              --Transacciones
            
              SET @v_TARIFAFIJA          = 0;
              SET @v_TARIFAPORCENTUAL    = 0;
              SET @v_TARIFATRANSACCIONAL = 0;
            
              IF @v_EVALUARVENTASXGRUPO = 1 BEGIN
                -- VENTAS
                IF @p_TRXVENTASPERIODO >= @RANGOFINAL and @RANGOFINAL <> 0 BEGIN
                  --Toca aplicarlo
                
                  SET @v_VALORATRABAJAR  = @RANGOFINAL - @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA          = @FIJO;
                  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
                                         @v_VALORATRABAJAR);
                
                END
                ELSE BEGIN
                
                  SET @v_VALORATRABAJAR  = @p_TRXVENTASPERIODO -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA          = @FIJO;
                  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
                                         @v_VALORATRABAJAR);
                
                  RETURN 0
                END 
              END
              ELSE BEGIN
                IF @p_TRXVENTASPRODUCTO >= @RANGOFINAL and
                   @RANGOFINAL <> 0 BEGIN
                  --Toca aplicarlo
                
                  SET @v_VALORATRABAJAR  = @RANGOFINAL -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA          = @FIJO;
                  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
                                         @v_VALORATRABAJAR);
                
                END
                ELSE BEGIN
                
                  SET @v_VALORATRABAJAR  = @p_TRXVENTASPERIODO -
                                       @v_MONTOYAAPLICADO;
                  SET @v_MONTOYAAPLICADO = @v_MONTOYAAPLICADO + @v_VALORATRABAJAR;
                
                  SET @v_TARIFAFIJA          = @FIJO;
                  SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
                
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO + @v_TARIFAFIJA;
                  SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                                         (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
                                         @v_VALORATRABAJAR);
                
                  RETURN 0
                END 
              END 
            END
            ELSE BEGIN
              RETURN CAST('-20053 Tipo de evaluacion de ventas no valido' AS FLOAT);
            END 
          
          END;
        FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
        END;
        CLOSE Rangos;
        DEALLOCATE Rangos;
      DECLARE @V_VALORREVENUE FLOAT;
        --v_VALORREVENUENUEVO tiene el revenue que debe dar total de todos los productos 
        --ahora se debe sacar la diferencia del revenue de los productos actual contra el que debe dar 
        --y aplicarle el porcentaje de participacioon de las ventas y ese seria el revenue nuevo
        IF @v_APLICARCADAGRUPO = 1 AND @v_EVALUARVENTASXGRUPO = 1 BEGIN
          IF @p_MONTOVENTASSOLPRODUCTO = 0 AND @p_MONTOVENTASPERIODO = 0 BEGIN
              --DECLARE @V_VALORREVENUE FLOAT;
              DECLARE @p_count int;
            BEGIN
              --temporal se coloca que busque el maximo 
/*              SELECT MAX(PRODUCTO.ID_PRODUCTO),MAX(PRODUCTO.CODAGRUPACIONPRODUCTO)
                     INTO
                     p_CODPRODUCTO,p_CODAGRUPPRODUCTO                  
              FROM COMISIONRANGOTIEMPO
              INNER JOIN  RANGOCOMISION ON COMISIONRANGOTIEMPO.CODRANGOCOMISION = RANGOCOMISION.ID_RANGOCOMISION
              INNER JOIN PRODUCTOCONTRATO ON PRODUCTOCONTRATO.CODRANGOCOMISION  = RANGOCOMISION.ID_RANGOCOMISION
              INNER JOIN PRODUCTO ON PRODUCTOCONTRATO.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
              WHERE COMISIONRANGOTIEMPO.ID_COMISIONRANGOTIEMPO = p_CODCOMISIONRANGOTIEMPO;*/
              
              SELECT @p_count = COUNT(1)
              FROM WSXML_SFG.PRODUCTO 
              WHERE CODAGRUPACIONPRODUCTO IN (SELECT CODAGRUPACIONPRODUCTO FROM WSXML_SFG.PRODUCTO WHERE ID_PRODUCTO = @p_CODPRODUCTO );
            
              IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
                --Ventas
              
                SET @V_VALORREVENUE = @v_VALORREVENUENUEVO *
                                  (1 /
                                  @p_count);
              END
              ELSE BEGIN
                --TRx
                SET @V_VALORREVENUE = @v_VALORREVENUENUEVO *
                                  (1 / @p_count);
              END 
              SET @v_VALORREVENUENUEVO = @V_VALORREVENUE;
            
            END;
          END
          ELSE BEGIN
              --DECLARE @V_VALORREVENUE FLOAT;
            BEGIN
              IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
                --Ventas
              
                SET @V_VALORREVENUE = @v_VALORREVENUENUEVO *
                                  (@p_MONTOVENTASSOLPRODUCTO /
                                  @p_MONTOVENTASPERIODO);
              END
              ELSE BEGIN
                --TRx
                SET @V_VALORREVENUE = @v_VALORREVENUENUEVO * (@p_TRXVENTASPRODUCTO / @p_TRXVENTASPERIODO);
              END 
              SET @v_VALORREVENUENUEVO = @V_VALORREVENUE;
            
            END;
          END 
        END 
      END;
    END 
    return @v_VALORREVENUENUEVO;
END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenueParaCostos', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenueParaCostos;
GO

CREATE     FUNCTION WSXML_SFG.SFGREVENUERANGOTIEMPO_GetValorRevenueParaCostos(@p_CODCOMISIONRANGOTIEMPO NUMERIC(22,0),
                                     @p_MONTOVENTAS            FLOAT,
                                     @p_TRXVENTAS              FLOAT,
                                     @p_MONTOVENTASGRUPO       FLOAT,
                                     @p_TRXVENTASGRUPO         FLOAT) RETURNS FLOAT AS
 BEGIN
  
    DECLARE @v_CODTIPOEVALUACIONVENTAS NUMERIC(22,0);
    DECLARE @v_EVALUARVENTASXGRUPO     NUMERIC(22,0);
  
    DECLARE @v_TARIFAFIJA          FLOAT; 
    DECLARE @v_TARIFAPORCENTUAL    FLOAT;
    DECLARE @v_TARIFATRANSACCIONAL FLOAT;
    
    DECLARE @v_TRXEVALUAR          FLOAT;
    DECLARE @v_MONTOEVALUAR        FLOAT;
    
    DECLARE @v_VALORREVENUENUEVO   FLOAT=0;
   
  
    SELECT @v_CODTIPOEVALUACIONVENTAS = COMISIONRANGOTIEMPO.CODTIPOEVALUACIONVENTAS,
           @v_EVALUARVENTASXGRUPO = COMISIONRANGOTIEMPO.EVALUARVENTASPORAGRUPACION
           FROM WSXML_SFG.COMISIONRANGOTIEMPO
     WHERE ID_COMISIONRANGOTIEMPO = @p_CODCOMISIONRANGOTIEMPO;
     
     IF @v_EVALUARVENTASXGRUPO=1 BEGIN
       SET @v_TRXEVALUAR=@p_TRXVENTASGRUPO;
       SET @v_MONTOEVALUAR=@p_MONTOVENTASGRUPO;
     END
     ELSE BEGIN
       SET @v_TRXEVALUAR=@p_TRXVENTAS;
       SET @v_MONTOEVALUAR=@p_MONTOVENTAS;
     END 
  
      Declare Rangos Cursor for 
		SELECT COMISIONRANGOTIEMPODETALLE.RANGOINICIAL,
			COMISIONRANGOTIEMPODETALLE.RANGOFINAL,
			COMISIONRANGOTIEMPODETALLE.TARIFAPORCENTUAL,
			COMISIONRANGOTIEMPODETALLE.TARIFATRANSACIONAL,
			COMISIONRANGOTIEMPODETALLE.FIJO
		FROM WSXML_SFG.COMISIONRANGOTIEMPODETALLE
		WHERE CODCOMISIONRANGOTIEMPO =
			@p_CODCOMISIONRANGOTIEMPO
		ORDER BY ID_COMISIONRANGOTIEMPODETALLE; OPEN Rangos;
		
	 --FETCH Rangos INTO;
	 DECLARE @RANGOINICIAL  FLOAT, @RANGOFINAL FLOAT, @TARIFAPORCENTUAL FLOAT, @TARIFATRANSACIONAL FLOAT, @FIJO FLOAT
	 FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
	 
	 WHILE @@FETCH_STATUS=0
	 BEGIN
        BEGIN
          IF @v_CODTIPOEVALUACIONVENTAS = 1 BEGIN
            -- VENTAS
            IF @RANGOINICIAL = 0 AND @v_MONTOEVALUAR <= 0 BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @v_MONTOEVALUAR >= @RANGOINICIAL AND
                  @v_MONTOEVALUAR <= @RANGOFINAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @RANGOFINAL = 0 AND
                  @v_MONTOEVALUAR >= @RANGOINICIAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL ;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END 
          END
          ELSE IF @v_CODTIPOEVALUACIONVENTAS = 2 BEGIN
            -- TRANSACCIONES
            IF @RANGOINICIAL = 0 AND @v_TRXEVALUAR <= 0 BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @v_TRXEVALUAR >= @RANGOINICIAL AND
                  @v_TRXEVALUAR <= @RANGOFINAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END
            ELSE IF @RANGOFINAL = 0 AND
                  @v_TRXEVALUAR >= @RANGOINICIAL BEGIN
              SET @v_TARIFAFIJA          = @FIJO;
              SET @v_TARIFAPORCENTUAL    = @TARIFAPORCENTUAL;
              SET @v_TARIFATRANSACCIONAL = @TARIFATRANSACIONAL;
            END 
          END
          ELSE BEGIN
            RETURN CAST('-20053 Tipo de evaluacion de ventas no valido' AS FLOAT);
          END 
        
        END;
      FETCH NEXT FROM Rangos INTO @RANGOINICIAL, @RANGOFINAL, @TARIFAPORCENTUAL, @TARIFATRANSACIONAL, @FIJO
      END;
      CLOSE Rangos;
      DEALLOCATE Rangos;
      /*en este punto ya tengo el valor de las tarifas que se deben aplicar.
      Ahora calcular los valores del revenue que se debeira tener*/
      SET @v_VALORREVENUENUEVO = ISNULL(@v_TARIFAFIJA, 0);
      SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                             (ISNULL(@v_TARIFATRANSACCIONAL, 0) *
                             @p_TRXVENTAS);
      SET @v_VALORREVENUENUEVO = @v_VALORREVENUENUEVO +
                             ((ISNULL(@v_TARIFAPORCENTUAL, 0) / 100) *
                             @p_MONTOVENTAS);

      RETURN @v_VALORREVENUENUEVO;
  END;

GO

