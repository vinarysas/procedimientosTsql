USE SFGPRODU;
--  DDL for Package Body SFGINF_VENTASDIARIASCADENA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_VENTASDIARIASCADENA */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXTipoProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXTipoProducto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXTipoProducto(@p_FECHAGENERACION DATETIME,
                                 @p_CODTIPOPRODUCTO NUMERIC(22,0),
                                @p_CADENA          NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PDV.CODIGOGTECHPUNTODEVENTA AS CODIGOGTECHPUNTODEVENTA,
             PDV.NOMPUNTODEVENTA AS NOMPUNTODEVENTA,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    NUMTRANSACCIONES
                   WHEN CODTIPOREGISTRO = 2 THEN
                    NUMTRANSACCIONES * (-1)
                   ELSE
                    0
                 END) AS TRANSACCIONES,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    VALORTRANSACCION
                   WHEN CODTIPOREGISTRO = 2 THEN
                    VALORTRANSACCION * (-1)
                   ELSE
                    0
                 END) AS VENTAS,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    VALORCOMISION
                   WHEN CODTIPOREGISTRO = 2 THEN
                    VALORCOMISION * (-1)
                   ELSE
                    0
                 END) AS COMISION,
             SUM((CASE
                   WHEN LDN.LINEAEGRESO = 1 THEN
                    0
                   ELSE
                    (CASE
                      WHEN CODTIPOREGISTRO = 1 THEN
                       VALORTRANSACCION
                      WHEN CODTIPOREGISTRO = 2 THEN
                       VALORTRANSACCION * (-1)
                      ELSE
                       0
                    END)
                 END) - (CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    VALORCOMISION
                   WHEN CODTIPOREGISTRO = 2 THEN
                    VALORCOMISION * (-1)
                   ELSE
                    0
                 END) - (CASE
                   WHEN CODTIPOREGISTRO = 4 THEN
                    VALORTRANSACCION
                   ELSE
                    0
                 END)) AS TOTALAPAGAR
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
       INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
          ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
       INNER JOIN WSXML_SFG.PUNTODEVENTA PDV
          ON (REG.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA)
       INNER JOIN WSXML_SFG.PRODUCTO PRD
          ON (REG.CODPRODUCTO = PRD.ID_PRODUCTO)
       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
       INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN
          ON (TPR.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
       WHERE CTR.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAGENERACION))
         AND CTR.REVERSADO = 0
         AND PRD.CODTIPOPRODUCTO = @p_CODTIPOPRODUCTO
         AND REG.CODAGRUPACIONPUNTODEVENTA = WSXML_SFG.AGRUPACION_F(@p_CADENA)
       GROUP BY PDV.CODIGOGTECHPUNTODEVENTA, PDV.NOMPUNTODEVENTA;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetAgrupacionXNit', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetAgrupacionXNit;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetAgrupacionXNit(@p_NIT NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;


      SELECT AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        FROM WSXML_SFG.RAZONSOCIAL, WSXML_SFG.PUNTODEVENTA, WSXML_SFG.AGRUPACIONPUNTODEVENTA
       WHERE RAZONSOCIAL.ID_RAZONSOCIAL = PUNTODEVENTA.CODRAZONSOCIAL
         AND PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA =
             AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
         AND (RAZONSOCIAL.IDENTIFICACION = @p_NIT)
         AND (PUNTODEVENTA.ACTIVE = 1)
         AND (AGRUPACIONPUNTODEVENTA.ACTIVE = 1)
       GROUP BY AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA;

  END
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXLineaDeNegocio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXLineaDeNegocio;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXLineaDeNegocio(@p_FECHAGENERACION   DATETIME,
                                   @p_CODLINEADENEGOCIO NUMERIC(22,0),
                                  @p_CADENA            NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PDV.CODIGOGTECHPUNTODEVENTA AS CODIGOGTECHPUNTODEVENTA,
             PDV.NOMPUNTODEVENTA AS NOMPUNTODEVENTA,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    NUMTRANSACCIONES
                   WHEN CODTIPOREGISTRO = 2 THEN
                    NUMTRANSACCIONES * (-1)
                   ELSE
                    0
                 END) AS TRANSACCIONES,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    VALORTRANSACCION
                   ELSE
                    0
                 END) AS INGRESOS,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 2 THEN
                    VALORTRANSACCION * (-1)
                   ELSE
                    0
                 END) AS ANULACIONES,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    VALORCOMISION
                   WHEN CODTIPOREGISTRO = 2 THEN
                    VALORCOMISION * (-1)
                   ELSE
                    0
                 END) AS COMISION,
             SUM(CASE
                   WHEN CODTIPOREGISTRO = 4 THEN
                    VALORTRANSACCION
                   ELSE
                    0
                 END) AS PREMIOSPAGADOS,

             SUM((CASE
                   WHEN LDN.LINEAEGRESO = 1 THEN
                    0
                   ELSE
                    (CASE
                      WHEN CODTIPOREGISTRO = 1 THEN
                       VALORTRANSACCION
                      WHEN CODTIPOREGISTRO = 2 THEN
                       VALORTRANSACCION * (-1)
                      ELSE
                       0
                    END)
                 END) - (CASE
                   WHEN CODTIPOREGISTRO = 4 THEN
                    VALORTRANSACCION
                   ELSE
                    0
                 END)) AS TOTALVENTAS,
             SUM((CASE
                   WHEN LDN.LINEAEGRESO = 1 THEN
                    0
                   ELSE
                    (CASE
                      WHEN CODTIPOREGISTRO = 1 THEN
                       VALORTRANSACCION
                      WHEN CODTIPOREGISTRO = 2 THEN
                       VALORTRANSACCION * (-1)
                      ELSE
                       0
                    END)
                 END) - (CASE
                   WHEN CODTIPOREGISTRO = 1 THEN
                    VALORCOMISION
                   WHEN CODTIPOREGISTRO = 2 THEN
                    VALORCOMISION * (-1)
                   ELSE
                    0
                 END) - (CASE
                   WHEN CODTIPOREGISTRO = 4 THEN
                    VALORTRANSACCION
                   ELSE
                    0
                 END)) AS TOTALAPAGAR
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
       INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
          ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
       INNER JOIN WSXML_SFG.PUNTODEVENTA PDV
          ON (REG.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA)
       INNER JOIN WSXML_SFG.PRODUCTO PRD
          ON (REG.CODPRODUCTO = PRD.ID_PRODUCTO)
       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
       INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN
          ON (TPR.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
       WHERE CTR.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAGENERACION))
         AND CTR.REVERSADO = 0
         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
         AND REG.CODAGRUPACIONPUNTODEVENTA = WSXML_SFG.AGRUPACION_F(@p_CADENA)
       GROUP BY PDV.CODIGOGTECHPUNTODEVENTA, PDV.NOMPUNTODEVENTA;
  END;
GO

   IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCADENA_DesdeDiaHabil', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_DesdeDiaHabil;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_DesdeDiaHabil(@P_FECHA                    DATETIME,
                          @P_DIAS                     NUMERIC(22,0),
                          @P_DIAS_PAR                 NUMERIC(22,0),
                          @P_ACUMULA_NO_HABIL_DIA_ANT NUMERIC(22,0),
                          @P_FECHA_OUT                DATETIME out) as
 begin
    /*
    P_ACUMULA_NO_HABIL_DIA_ANT
    1 = El fin de semana o el festivo que sea objetivo de compensar,
    se pagara acumulandose al ultimo dia habil, inmediatamente anterior
    al fin de semana o al festivo.
    0 = El fin de semana o el festivo que
    sea objetivo de compensar, se pagara acumulandose al siguiente dia habil,
    inmediatamente posterior al fin de semana o al festivo.
    */

    declare @V_DIAS           INTEGER;
    declare @V_DIAS_LOOP      INTEGER;
    declare @ES_HABIL         INTEGER;
    declare @V_FECHA_CRITERIO DATETIME = CONVERT(DATETIME, CONVERT(DATE,@P_FECHA - @P_DIAS_PAR));
    declare @V_FECHA          DATETIME;
    declare @V_FECHA_LOOP     DATETIME;

   
  SET NOCOUNT ON;

    SELECT @ES_HABIL = COUNT(*)
      FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CALG
     WHERE CALG.ID_CALENDARIO_GRAL NOT IN
           (SELECT CALF.CODCALENDARIO_GRAL
              FROM SFG_CONCILIACION.CON_CALENDARIO_FEST_GRAL CALF)
       AND DATEPART(weekday, CALG.FECHA_CALENDARIO) NOT IN (1, 7)
       AND CALG.FECHA_CALENDARIO = CONVERT(DATETIME, CONVERT(DATE,@P_FECHA));

    IF @ES_HABIL > 0 BEGIN

      SELECT @V_DIAS = COUNT(*)
        FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CALG
       WHERE CALG.ID_CALENDARIO_GRAL NOT IN
             (SELECT CALF.CODCALENDARIO_GRAL
                FROM SFG_CONCILIACION.CON_CALENDARIO_FEST_GRAL CALF)
         AND DATEPART(weekday, CALG.FECHA_CALENDARIO) NOT IN (1, 7)
         AND CALG.FECHA_CALENDARIO > CONVERT(DATETIME,CONVERT(DATE,@V_FECHA_CRITERIO))
         AND CALG.FECHA_CALENDARIO <= CONVERT(DATETIME, CONVERT(DATE,@P_FECHA));
      IF @V_DIAS = @P_DIAS
        BEGIN
          SELECT @V_FECHA = CALG.FECHA_CALENDARIO
            FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CALG
           WHERE CALG.ID_CALENDARIO_GRAL NOT IN
                 (SELECT CALF.CODCALENDARIO_GRAL
                    FROM SFG_CONCILIACION.CON_CALENDARIO_FEST_GRAL CALF)
             AND DATEPART(weekday, CALG.FECHA_CALENDARIO) NOT IN (1, 7)
             AND CONVERT(VARCHAR,CALG.FECHA_CALENDARIO,103) = CONVERT(VARCHAR,@V_FECHA_CRITERIO,103);

          IF @P_ACUMULA_NO_HABIL_DIA_ANT = 1 BEGIN
            set @V_FECHA_LOOP = @V_FECHA;
            WHILE 1=1 BEGIN
              set @V_FECHA_LOOP = @V_FECHA_LOOP + 1;
			  
              SELECT @V_DIAS_LOOP = COUNT(*)
                FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CALG
               WHERE (CALG.ID_CALENDARIO_GRAL IN
                     (SELECT CALF.CODCALENDARIO_GRAL
                         FROM SFG_CONCILIACION.CON_CALENDARIO_FEST_GRAL CALF) OR
                     DATEPART(weekday, CALG.FECHA_CALENDARIO) IN (1, 7)) 
                 AND CALG.FECHA_CALENDARIO = @V_FECHA_LOOP;
				IF @V_DIAS_LOOP = 0
					BREAK; 
              
            END;
            set @V_FECHA = @V_FECHA_LOOP - 1;
          END 
          set @P_FECHA_OUT = @V_FECHA;
		  
		  IF @@ROWCOUNT = 0 BEGIN
			SET @P_DIAS_PAR = @P_DIAS_PAR + 1
				EXEC WSXML_SFG.SFGINF_VENTASDIARIASCADENA_DesdeDiaHabil @P_FECHA,
																   @P_DIAS,
																   @P_DIAS_PAR,
																   @P_ACUMULA_NO_HABIL_DIA_ANT,
																   @V_FECHA OUT

				IF @P_ACUMULA_NO_HABIL_DIA_ANT = 1 BEGIN
				  set @V_FECHA_LOOP = @V_FECHA;
				  WHILE 1=1 BEGIN
					set @V_FECHA_LOOP = @V_FECHA_LOOP + 1;
					SELECT @V_DIAS_LOOP = COUNT(*)
					  FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CALG
					 WHERE (CALG.ID_CALENDARIO_GRAL IN
						   (SELECT CALF.CODCALENDARIO_GRAL
							   FROM SFG_CONCILIACION.CON_CALENDARIO_FEST_GRAL CALF) OR
						   DATEPART(weekday, CALG.FECHA_CALENDARIO) IN (1, 7))
					   AND CALG.FECHA_CALENDARIO = @V_FECHA_LOOP;

					IF @V_DIAS_LOOP = 0
						BREAK;
				  END;
				  set @V_FECHA = @V_FECHA_LOOP - 1;
				END 

				set @P_FECHA_OUT = @V_FECHA;
			END
        END;
      ELSE IF @V_DIAS < @P_DIAS BEGIN
	  SET @P_DIAS_PAR = @P_DIAS_PAR  + 1
        EXEC WSXML_SFG.SFGINF_VENTASDIARIASCADENA_DesdeDiaHabil 
															@P_FECHA,
															@P_DIAS,
															@P_DIAS_PAR,
															@P_ACUMULA_NO_HABIL_DIA_ANT,
															@V_FECHA OUT

        set @P_FECHA_OUT = @V_FECHA;
      END 
    END
    ELSE BEGIN
      set @P_FECHA_OUT = CONVERT(DATETIME, '01/JAN/1900');
    END 

  END
GO

 IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCADENA_HastaElDia', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_HastaElDia;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_HastaElDia(@P_FECHA DATETIME, @P_FECHA_OUT DATETIME out) AS
 BEGIN

    DECLARE @v_cantidad  NUMERIC(22,0);
    DECLARE @FECHA_MOVIL datetime = @P_FECHA;
    DECLARE @v_dater     datetime = @P_FECHA;

   
  SET NOCOUNT ON;

    select @v_cantidad = count(*)
      from sfg_conciliacion.con_calendario_gral cg
     where DATEPART(weekday, cg.fecha_calendario) not in (1, 7)
       and cg.fecha_calendario = CONVERT(DATETIME,@FECHA_MOVIL + 1,103)
       and cg.id_calendario_gral not in
           (select cf.codcalendario_gral
              from sfg_conciliacion.con_calendario_fest_gral cf);

    if @v_cantidad = 0 begin
		DECLARE @l_fecha DATETIME = CONVERT(DATETIME,@FECHA_MOVIL, 103) +1
		EXEC WSXML_SFG.SFGINF_VENTASDIARIASCADENA_HastaElDia @l_fecha, @v_dater OUT

    end
    else if @v_cantidad = 1 begin

      SET @P_FECHA_OUT = @v_dater;

    end 
    SET @P_FECHA_OUT = @v_dater;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXTipoProductoXNit', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXTipoProductoXNit;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINF_VENTASDIARIASCADENA_GetDataXTipoProductoXNit(@p_FECHAGENERACIONDESDE DATETIME,
                                     @p_FECHAGENERACIONHASTA DATETIME,
                                     @p_CODLINEADENEGOCIO    NUMERIC(22,0),
                                    @p_NIT                  VARCHAR(4000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT AGP.CODIGOAGRUPACIONGTECH AS CODCADENA,
             AGP.NOMAGRUPACIONPUNTODEVENTA AS NOMCADENA,
             PREF.FECHAARCHIVO AS FECHA,
             PDV.CODIGOGTECHPUNTODEVENTA,
             PDV.NOMPUNTODEVENTA,
             SUM(PREF.NUMINGRESOS) AS TRANSACCIONES,
             SUM(PREF.INGRESOS) AS INGRESOS,
             SUM(PREF.ANULACIONES) AS ANULACIONES,
             SUM(PREF.COMISION) AS COMISION,
             SUM(PREF.PREMIOSPAGADOS) AS PREMIOSPAGADOS,
             SUM(PREF.VALORAPAGARGTECH) AS TOTALAPAGAR,
             SUM(INGRESOSBRUTOS) AS INGRESOSBRUTOS
        FROM WSXML_SFG.VW_PREFACTURACION_DIARIA PREF,
             WSXML_SFG.RAZONSOCIAL              RZS,
             WSXML_SFG.AGRUPACIONPUNTODEVENTA   AGP,
             WSXML_SFG.PUNTODEVENTA             PDV
       WHERE PREF.CODRAZONSOCIAL = RZS.ID_RAZONSOCIAL
         AND PREF.CODAGRUPACIONPUNTODEVENTA = AGP.ID_AGRUPACIONPUNTODEVENTA
         AND PREF.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA
         AND (PREF.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO)
         AND (PREF.FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,@p_FECHAGENERACIONDESDE)) AND
             CONVERT(DATETIME, CONVERT(DATE,@p_FECHAGENERACIONHASTA)))
         AND (ISNULL(CONVERT(VARCHAR, RZS.IDENTIFICACION), '') + '-' +
             ISNULL(CONVERT(VARCHAR, RZS.DIGITOVERIFICACION), '') = @p_NIT)
       GROUP BY AGP.CODIGOAGRUPACIONGTECH,
                AGP.NOMAGRUPACIONPUNTODEVENTA,
                PREF.FECHAARCHIVO,
                PDV.CODIGOGTECHPUNTODEVENTA,
                PDV.NOMPUNTODEVENTA
       ORDER BY PREF.FECHAARCHIVO, AGP.CODIGOAGRUPACIONGTECH;

    /*
        SELECT AGP.CODIGOAGRUPACIONGTECH AS CODCADENA,
               AGP.NOMAGRUPACIONPUNTODEVENTA AS NOMCADENA,
               CTR.FECHAARCHIVO AS FECHA,
               PDV.CODIGOGTECHPUNTODEVENTA AS CODIGOGTECHPUNTODEVENTA,
               PDV.NOMPUNTODEVENTA AS NOMPUNTODEVENTA,
               SUM(CASE
                     WHEN CODTIPOREGISTRO = 1 THEN
                      NUMTRANSACCIONES
                     WHEN CODTIPOREGISTRO = 2 THEN
                      NUMTRANSACCIONES * (-1)
                     ELSE
                      0
                   END) AS TRANSACCIONES,
               SUM(CASE
                     WHEN CODTIPOREGISTRO = 1 THEN
                      VALORTRANSACCION
                     ELSE
                      0
                   END) AS INGRESOS,
               SUM(CASE
                     WHEN CODTIPOREGISTRO = 2 THEN
                      VALORTRANSACCION * (-1)
                     ELSE
                      0
                   END) AS ANULACIONES,
               SUM(CASE
                     WHEN CODTIPOREGISTRO = 1 THEN
                      VALORCOMISION
                     WHEN CODTIPOREGISTRO = 2 THEN
                      VALORCOMISION * (-1)
                     ELSE
                      0
                   END) AS COMISION,
               SUM(CASE
                     WHEN CODTIPOREGISTRO = 4 THEN
                      VALORTRANSACCION
                     ELSE
                      0
                   END) AS PREMIOSPAGADOS,

               SUM((CASE
                     WHEN LDN.LINEAEGRESO = 1 THEN
                      0
                     ELSE
                      (CASE
                        WHEN CODTIPOREGISTRO = 1 THEN
                         VALORTRANSACCION
                        WHEN CODTIPOREGISTRO = 2 THEN
                         VALORTRANSACCION * (-1)
                        ELSE
                         0
                      END)
                   END) - (CASE
                     WHEN CODTIPOREGISTRO = 4 THEN
                      VALORTRANSACCION
                     ELSE
                      0
                   END)) AS TOTALVENTAS,
               SUM((CASE
                     WHEN LDN.LINEAEGRESO = 1 THEN
                      0
                     ELSE
                      (CASE
                        WHEN CODTIPOREGISTRO = 1 THEN
                         VALORTRANSACCION
                        WHEN CODTIPOREGISTRO = 2 THEN
                         VALORTRANSACCION * (-1)
                        ELSE
                         0
                      END)
                   END) - (CASE
                     WHEN CODTIPOREGISTRO = 1 THEN
                      VALORCOMISION
                     WHEN CODTIPOREGISTRO = 2 THEN
                      VALORCOMISION * (-1)
                     ELSE
                      0
                   END) - (CASE
                     WHEN CODTIPOREGISTRO = 4 THEN
                      VALORTRANSACCION
                     ELSE
                      0
                   END)) AS TOTALAPAGAR

          FROM ENTRADAARCHIVOCONTROL CTR
         INNER JOIN REGISTROFACTURACION REG
            ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
         INNER JOIN PUNTODEVENTA PDV
            ON (REG.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA)
         INNER JOIN PRODUCTO PRD
            ON (REG.CODPRODUCTO = PRD.ID_PRODUCTO)
         INNER JOIN TIPOPRODUCTO TPR
            ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
         INNER JOIN LINEADENEGOCIO LDN
            ON (TPR.CODLINEADENEGOCIO = LDN.ID_LINEADENEGOCIO)
         INNER JOIN AGRUPACIONPUNTODEVENTA AGP
            ON (AGP.ID_AGRUPACIONPUNTODEVENTA = REG.CODAGRUPACIONPUNTODEVENTA)
         WHERE CTR.FECHAARCHIVO >= TRUNC(p_FECHAGENERACIONDESDE, 'DD')
           AND CTR.FECHAARCHIVO <= TRUNC(p_FECHAGENERACIONHASTA, 'DD')
           AND CTR.REVERSADO = 0
           AND PRD.CODTIPOPRODUCTO = p_CODTIPOPRODUCTO
           AND REG.CODAGRUPACIONPUNTODEVENTA IN
               (SELECT AGRUPACIONPUNTODEVENTA_1.ID_AGRUPACIONPUNTODEVENTA
                  FROM RAZONSOCIAL,
                       PUNTODEVENTA,
                       AGRUPACIONPUNTODEVENTA AGRUPACIONPUNTODEVENTA_1
                 WHERE RAZONSOCIAL.ID_RAZONSOCIAL =
                       PUNTODEVENTA.CODRAZONSOCIAL
                   AND PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA =
                       AGRUPACIONPUNTODEVENTA_1.ID_AGRUPACIONPUNTODEVENTA
                   AND (RAZONSOCIAL.IDENTIFICACION || '-' || RAZONSOCIAL.DIGITOVERIFICACION = p_NIT)
                   AND (PUNTODEVENTA.ACTIVE = 1)
                   AND (AGRUPACIONPUNTODEVENTA_1.ACTIVE = 1)
                 GROUP BY AGRUPACIONPUNTODEVENTA_1.ID_AGRUPACIONPUNTODEVENTA)

         GROUP BY PDV.CODIGOGTECHPUNTODEVENTA,
                  PDV.NOMPUNTODEVENTA,
                  CTR.FECHAARCHIVO,
                  AGP.CODIGOAGRUPACIONGTECH,
                  AGP.NOMAGRUPACIONPUNTODEVENTA
         ORDER BY  CTR.FECHAARCHIVO,AGP.CODIGOAGRUPACIONGTECH;
    */

  END;
GO


