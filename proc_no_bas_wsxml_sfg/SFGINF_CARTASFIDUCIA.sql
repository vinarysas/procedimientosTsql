USE SFGPRODU;
--  DDL for Package Body SFGINF_CARTASFIDUCIA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_CARTASFIDUCIA */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER;
GO

CREATE     FUNCTION WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER(@p_PARAMETRO NVARCHAR(2000)) RETURNS NUMERIC(22,0) AS
 BEGIN

		DECLARE @result NUMERIC(22,0);
   

		SELECT @result = REPLACE(P.VALOR, '%','') / 100
		  FROM WSXML_SFG.PARAMETRO P
		 WHERE P.NOMPARAMETRO = @p_PARAMETRO;

		RETURN @result;


  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER;
GO

CREATE     FUNCTION WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER(@p_PARAMETRO NVARCHAR(2000)) RETURNS NUMERIC(22,0) AS
 BEGIN
    DECLARE @result NUMERIC(22,0);
   

    SELECT @result = CAST(P.VALOR AS NUMERIC(38,0))
      FROM WSXML_SFG.PARAMETRO P
     WHERE P.NOMPARAMETRO = @p_PARAMETRO;

	 IF @@ROWCOUNT = 0
		RETURN 0

    RETURN @result;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_MAX_FECHA_L1LIAB0', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGINF_CARTASFIDUCIA_MAX_FECHA_L1LIAB0;
GO

CREATE     FUNCTION WSXML_SFG.SFGINF_CARTASFIDUCIA_MAX_FECHA_L1LIAB0() RETURNS DATETIME AS
 BEGIN
    DECLARE @result DATETIME;
   

    select @RESULT = MAX(T.FECHAHORAGENERACION)
      from WSXML_SFG.VW_REPORTE__L1LIAB01_02 t;

    RETURN @result;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetConsecutivoCartas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetConsecutivoCartas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetConsecutivoCartas(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                 @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                 @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                 @pg_PRODUCTO              NVARCHAR(2000),
                                 @pg_REDPDV                NVARCHAR(2000),
                                @pg_CADENA                NVARCHAR(2000)) AS
 BEGIN

    DECLARE @V_CONSECUTIVO  NUMERIC(22,0);
    DECLARE @V_CODIGO_CARTA VARCHAR(50);
    DECLARE @V_ASUNTO       VARCHAR(2000) = @pg_PRODUCTO;
    DECLARE @V_RUTA         VARCHAR(2000) = @pg_REDPDV;

   
  SET NOCOUNT ON;
    declare @msg varchar(2000);
    begin
      set @msg = 'Guillermo CartasFidu' + isnull(convert(varchar, @p_CODCICLOFACTURACIONPDV), '');
      EXEC WSXML_SFG.sfgtmptrace_TraceLog @msg
     end;

    select @V_CONSECUTIVO = isnull(max(c.consecutivo),
               WSXML_SFG.sfginf_cartasfiducia_parametro_number('ConsecutivoInicialAno')) + 1
      from WSXML_SFG.CONTROL_CARTAS_L1SHRCLC c
     where c.anio = FORMAT(getdate(), 'yyyy')
       and c.consecutivo >=
           WSXML_SFG.sfginf_cartasfiducia_parametro_number('ConsecutivoInicialAno')
       and c.consecutivo <
           WSXML_SFG.sfginf_cartasfiducia_parametro_number('ConsecutivoFinalAno');

    if @V_CONSECUTIVO <>
       WSXML_SFG.sfginf_cartasfiducia_parametro_number('ConsecutivoFinalAno') begin


	 set @V_CODIGO_CARTA = 
		'FIN-' + ISNULL( RIGHT(REPLICATE('0', 5) + LEFT(@V_CONSECUTIVO, 5), 5), '') + '-' + FORMAT(getdate(), 'yyyy');

      set @V_RUTA = ISNULL(@V_RUTA, '')+'-'+ISNULL(@V_CODIGO_CARTA, '')+'.pdf';

      INSERT INTO WSXML_SFG.CONTROL_CARTAS_L1SHRCLC
        (CODIGO_CARTA,
         ASUNTO,
         RUTA,
         FECHAHORAMODIFICACION,
         CODUSUARIOMODIFICACION,
         ACTIVE,
         CONSECUTIVO,
         ANIO,
         AREA)
      VALUES
        (@V_CODIGO_CARTA,
         @V_ASUNTO,
         @V_RUTA,
         GETDATE(),
         1,
         1,
         @V_CONSECUTIVO,
         format(getdate(), 'yyyy'),
         'FIN');


        SELECT ID_CONTROL_CARTAS_L1SHRCLC,
               CODIGO_CARTA,
               ASUNTO,
               RUTA,
               FECHAHORAMODIFICACION,
               CODUSUARIOMODIFICACION,
               ACTIVE,
               CONSECUTIVO,
               ANIO,
               AREA
          FROM WSXML_SFG.CONTROL_CARTAS_L1SHRCLC CC
         WHERE CC.ID_CONTROL_CARTAS_L1SHRCLC IN
               (SELECT MAX(CONTROL_CARTAS_L1SHRCLC.ID_CONTROL_CARTAS_L1SHRCLC)
                  FROM WSXML_SFG.CONTROL_CARTAS_L1SHRCLC);
    end 
  END; 
GO


    IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetExpiredWinnersTwoMonths', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetExpiredWinnersTwoMonths;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetExpiredWinnersTwoMonths(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                       @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                       @pg_PRODUCTO              NVARCHAR(2000),
                                       @pg_REDPDV                NVARCHAR(2000),
                                       @pg_CADENA                NVARCHAR(2000)) AS
 BEGIN

    DECLARE @V_SORTEO1_VENCIDO     NUMERIC(22,0) = 0;
    DECLARE @V_SORTEO2_VENCIDO     NUMERIC(22,0) = 0;
    DECLARE @V_FECHA_DESDE_SORTEO1 DATETIME;
    DECLARE @V_FECHA_HASTA_SORTEO1 DATETIME;
    DECLARE @V_FECHA_DESDE_SORTEO2 DATETIME;
    DECLARE @V_FECHA_HASTA_SORTEO2 DATETIME;
    DECLARE @v_PRODUCTO            NUMERIC(22,0);

   
  SET NOCOUNT ON;

    SELECT @V_PRODUCTO = P.ID_PRODUCTO
      FROM WSXML_SFG.PRODUCTO P
     WHERE CONVERT(NUMERIC,P.CODIGOGTECHPRODUCTO) = CONVERT(NUMERIC,@pg_PRODUCTO)
       AND P.ACTIVE = 1;

    SELECT @V_SORTEO1_VENCIDO = MIN(P1.SORTEO)
      FROM (SELECT SR.*,
                   EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                   ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
              FROM (SELECT P.CODPRODUCTO,
                           L1.SORTEO,
                           L1.FECHASORTEO,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                      FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                     WHERE L1.ACTIVE = 1
                       AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC2
             WHERE EAC.ACTIVE = 1
               AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
               AND EAC.TIPOARCHIVO = 2
               AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
               AND EAC2.TIPOARCHIVO = 2
               AND EAC2.ACTIVE = 1
               AND EAC.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV) P1;

    SELECT @V_SORTEO2_VENCIDO = MAX(P2.SORTEO)
      FROM (SELECT SR.*,
                   EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                   ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
              FROM (SELECT P.CODPRODUCTO,
                           L1.SORTEO,
                           L1.FECHASORTEO,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                      FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                     WHERE L1.ACTIVE = 1
                       AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC2
             WHERE EAC.ACTIVE = 1
               AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
               AND EAC.TIPOARCHIVO = 2
               AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
               AND EAC2.TIPOARCHIVO = 2
               AND EAC2.ACTIVE = 1
               AND EAC.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV) P2;

    IF @V_SORTEO1_VENCIDO > 0 AND @V_SORTEO2_VENCIDO > 0 BEGIN

      SELECT @V_FECHA_DESDE_SORTEO1 = MIN(C.FECHAHORAGENERACION), @V_FECHA_HASTA_SORTEO1 = MAX(C.FECHAHORAGENERACION)
        FROM WSXML_SFG.SORTEO_L1LIAB01 SL, WSXML_SFG.CONTROL_L1LIAB01 C
       WHERE C.ID_CONTROL_L1LIAB01 = SL.COD_CONTROL_L1LIAB01
         AND SL.SORTEO = @V_SORTEO1_VENCIDO;

      SELECT @V_FECHA_DESDE_SORTEO2 = MIN(C.FECHAHORAGENERACION), @V_FECHA_HASTA_SORTEO2 = MAX(C.FECHAHORAGENERACION)
        FROM WSXML_SFG.SORTEO_L1LIAB01 SL, WSXML_SFG.CONTROL_L1LIAB01 C
       WHERE C.ID_CONTROL_L1LIAB01 = SL.COD_CONTROL_L1LIAB01
         AND SL.SORTEO = @V_SORTEO2_VENCIDO;


        SELECT VENCIDOS.*,
               CICLOS.FECHASORTEO,
               CICLOS.VENC_DOS_MESES AS FECHA_VENCIMIENTO,
               CONVERT(DATETIME,CICLOS.VENC_DOS_MESES) - CONVERT(DATETIME,CICLOS.FECHASORTEO) as DIAS_VENCIMIENTO,
               CPDV.FECHAEJECUCION AS FECHA_CORTE,
               CPDV.SECUENCIA AS SECUENCIA_CORTE,
               CICLOS.CICLO_DOS_MESES AS CICLO_CORTE
        --               CICLOS.VENC_UN_ANO,
        --               CICLOS.CICLO_UN_ANO,
          FROM (SELECT *
                  FROM (SELECT *
                          FROM (SELECT NOMBRECATEGORIA,
                                       PAGADOS.SORTEO,
                                       NOMPRODUCTO,
                                       ID_PRODUCTO,
                                       GANADOS.TOT_GANADO - PAGADOS.VALOR AS VALOR_VENCIDOS
                                  FROM (select *
                                          from (

                                                SELECT *

                                                  FROM (SELECT isnull(VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                    VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01) ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                isnull(VW_REPORTE__L1LIAB01_01.NOMBRECATEGORIA,
                                                                    VW_REPORTE__L1LIAB01_02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                                                isnull(VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY -
                                                                    VW_REPORTE__L1LIAB01_01.PAG_ANT_MAS_PAGADO_HOY,
                                                                    VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY) AS VALOR,
                                                                VW_REPORTE__L1LIAB01_02.SORTEO,
                                                                VW_REPORTE__L1LIAB01_02.NOMPRODUCTO,
                                                                VW_REPORTE__L1LIAB01_02.ID_PRODUCTO
                                                           FROM (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_02
                                                                  where (CONVERT(DATETIME,VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION) =
                                                                        CONVERT(DATETIME,@V_FECHA_HASTA_SORTEO1))
                                                                    and VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_02,
                                                                (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_01
                                                                  where (CONVERT(DATETIME,VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) =
                                                                        CONVERT(DATETIME,@V_FECHA_DESDE_SORTEO1))
                                                                    and VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_01
                                                          WHERE VW_REPORTE__L1LIAB01_02.SORTEO =
                                                                VW_REPORTE__L1LIAB01_01.SORTEO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_SORTEO_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_SORTEO_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                                                VW_REPORTE__L1LIAB01_01.ID_PRODUCTO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                                                VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CONTROL_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_CONTROL_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION >
                                                                VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) s) s) PAGADOS,
                                       (SELECT L.CODCATEGORIA_ACIERTOS_L1LIAB01,
                                               L.TOT_GANADO,
                                               SORTEO,
                                               CODPRODUCTO
                                          FROM WSXML_SFG.DETALLE_L1LIAB01 L,
                                               (SELECT MAX(P.ID_SORTEO_L1LIAB01_PRODUCTO) AS ID_SORTEO_L1LIAB01_PRODUCTO,
                                                       S.SORTEO,
                                                       P.CODPRODUCTO
                                                  FROM WSXML_SFG.SORTEO_L1LIAB01          S,
                                                       WSXML_SFG.SORTEO_L1LIAB01_PRODUCTO P
                                                 WHERE S.ID_SORTEO_L1LIAB01 =
                                                       P.CODSORTEO_L1LIAB01
                                                 GROUP BY S.SORTEO,
                                                          P.CODPRODUCTO) SR
                                         WHERE L.CODSORTEO_L1LIAB01_PRODUCTO =
                                               SR.ID_SORTEO_L1LIAB01_PRODUCTO) GANADOS
                                 WHERE PAGADOS.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                       GANADOS.CODCATEGORIA_ACIERTOS_L1LIAB01
                                   AND PAGADOS.SORTEO = GANADOS.SORTEO
                                   AND PAGADOS.ID_PRODUCTO =
                                       GANADOS.CODPRODUCTO) T 
											PIVOT(SUM(VALOR_VENCIDOS) 
												FOR NOMBRECATEGORIA IN (['3 Aciertos de 6'],['4 Aciertos de 6'],['5 Aciertos de 6'],['6 Aciertos de 6'])
											) PIV
									) T ) VENCIDOS,
               (SELECT SR.*,
                       EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                       ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
                  FROM (SELECT P.CODPRODUCTO,
                               L1.SORTEO,
                               L1.FECHASORTEO,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                                WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                                WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                          FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                         WHERE L1.ACTIVE = 1
                           AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                       ENTRADAARCHIVOCONTROL EAC,
                       ENTRADAARCHIVOCONTROL EAC2
                 WHERE EAC.ACTIVE = 1
                   AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
                   AND EAC.TIPOARCHIVO = 2
                   AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
                   AND EAC2.TIPOARCHIVO = 2
                   AND EAC2.ACTIVE = 1) CICLOS,
               CICLOFACTURACIONPDV CPDV
         WHERE VENCIDOS.SORTEO = CICLOS.SORTEO
           AND VENCIDOS.ID_PRODUCTO = CICLOS.CODPRODUCTO
           AND CICLOS.CICLO_DOS_MESES = @p_CODCICLOFACTURACIONPDV
           AND VENCIDOS.SORTEO = @V_SORTEO1_VENCIDO
           AND ID_PRODUCTO = @v_PRODUCTO
           AND CPDV.ID_CICLOFACTURACIONPDV = CICLOS.CICLO_DOS_MESES

        UNION

        SELECT VENCIDOS.*,
               CICLOS.FECHASORTEO,
               CICLOS.VENC_DOS_MESES AS FECHA_VENCIMIENTO,
               CONVERT(DATETIME,CICLOS.VENC_DOS_MESES) - CONVERT(DATETIME,CICLOS.FECHASORTEO) as DIAS_VENCIMIENTO,
               CPDV.FECHAEJECUCION AS FECHA_CORTE,
               CPDV.SECUENCIA AS SECUENCIA_CORTE,
               CICLOS.CICLO_DOS_MESES AS CICLO_CORTE
        --               CICLOS.VENC_UN_ANO,
        --               CICLOS.CICLO_UN_ANO,
          FROM (SELECT *
                  FROM (SELECT *
                          FROM (SELECT NOMBRECATEGORIA,
                                       PAGADOS.SORTEO,
                                       NOMPRODUCTO,
                                       ID_PRODUCTO,
                                       GANADOS.TOT_GANADO - PAGADOS.VALOR AS VALOR_VENCIDOS
                                  FROM (select *
                                          from (

                                                SELECT *

                                                  FROM (SELECT isnull(VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                    VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01) ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                isnull(VW_REPORTE__L1LIAB01_01.NOMBRECATEGORIA,
                                                                    VW_REPORTE__L1LIAB01_02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                                                isnull(VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY -
                                                                    VW_REPORTE__L1LIAB01_01.PAG_ANT_MAS_PAGADO_HOY,
                                                                    VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY) AS VALOR,
                                                                VW_REPORTE__L1LIAB01_02.SORTEO,
                                                                VW_REPORTE__L1LIAB01_02.NOMPRODUCTO,
                                                                VW_REPORTE__L1LIAB01_02.ID_PRODUCTO
                                                           FROM (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_02
                                                                  where (CONVERT(DATETIME,VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION) =
                                                                        CONVERT(DATETIME,@V_FECHA_HASTA_SORTEO2))
                                                                    and VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_02,
                                                                (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_01
                                                                  where (CONVERT(DATETIME,VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) =
                                                                        CONVERT(DATETIME,@V_FECHA_DESDE_SORTEO2))
                                                                    and VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_01
                                                          WHERE VW_REPORTE__L1LIAB01_02.SORTEO =
                                                                VW_REPORTE__L1LIAB01_01.SORTEO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_SORTEO_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_SORTEO_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                                                VW_REPORTE__L1LIAB01_01.ID_PRODUCTO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                                                VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CONTROL_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_CONTROL_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION >
                                                                VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) s) s) PAGADOS,
                                       (SELECT L.CODCATEGORIA_ACIERTOS_L1LIAB01,
                                               L.TOT_GANADO,
                                               SORTEO,
                                               CODPRODUCTO
                                          FROM WSXML_SFG.DETALLE_L1LIAB01 L,
                                               (SELECT MAX(P.ID_SORTEO_L1LIAB01_PRODUCTO) AS ID_SORTEO_L1LIAB01_PRODUCTO,
                                                       S.SORTEO,
                                                       P.CODPRODUCTO
                                                  FROM WSXML_SFG.SORTEO_L1LIAB01          S,
                                                       WSXML_SFG.SORTEO_L1LIAB01_PRODUCTO P
                                                 WHERE S.ID_SORTEO_L1LIAB01 =
                                                       P.CODSORTEO_L1LIAB01
                                                 GROUP BY S.SORTEO,
                                                          P.CODPRODUCTO) SR
                                         WHERE L.CODSORTEO_L1LIAB01_PRODUCTO =
                                               SR.ID_SORTEO_L1LIAB01_PRODUCTO) GANADOS
                                 WHERE PAGADOS.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                       GANADOS.CODCATEGORIA_ACIERTOS_L1LIAB01
                                   AND PAGADOS.SORTEO = GANADOS.SORTEO
                                   AND PAGADOS.ID_PRODUCTO =
                                       GANADOS.CODPRODUCTO) T
											PIVOT(SUM(VALOR_VENCIDOS) 
												FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'],['4 Aciertos de 6'],['5 Aciertos de 6'],['6 Aciertos de 6'])
											) AS PIVOTTABLE
					) T1) VENCIDOS,
               (SELECT SR.*,
                       EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                       ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
                  FROM (SELECT P.CODPRODUCTO,
                               L1.SORTEO,
                               L1.FECHASORTEO,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                                WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                                WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                          FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                         WHERE L1.ACTIVE = 1
                           AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                       ENTRADAARCHIVOCONTROL EAC,
                       ENTRADAARCHIVOCONTROL EAC2
                 WHERE EAC.ACTIVE = 1
                   AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
                   AND EAC.TIPOARCHIVO = 2
                   AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
                   AND EAC2.TIPOARCHIVO = 2
                   AND EAC2.ACTIVE = 1) CICLOS,
               CICLOFACTURACIONPDV CPDV
         WHERE VENCIDOS.SORTEO = CICLOS.SORTEO
           AND VENCIDOS.ID_PRODUCTO = CICLOS.CODPRODUCTO
           AND CICLOS.CICLO_DOS_MESES = @p_CODCICLOFACTURACIONPDV
           AND VENCIDOS.SORTEO = @V_SORTEO2_VENCIDO
           AND ID_PRODUCTO = @v_PRODUCTO
           AND CPDV.ID_CICLOFACTURACIONPDV = CICLOS.CICLO_DOS_MESES;

    END 

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetExpiredWinnersOneYear', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetExpiredWinnersOneYear;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetExpiredWinnersOneYear(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                     @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                     @pg_PRODUCTO              NVARCHAR(2000),
                                     @pg_REDPDV                NVARCHAR(2000),
                                     @pg_CADENA                NVARCHAR(2000)) AS
 BEGIN

    DECLARE @V_SORTEO1_VENCIDO     NUMERIC(22,0) = 0;
    DECLARE @V_SORTEO2_VENCIDO     NUMERIC(22,0) = 0;
    DECLARE @V_FECHA_DESDE_SORTEO1 DATETIME;
    DECLARE @V_FECHA_HASTA_SORTEO1 DATETIME;
    DECLARE @V_FECHA_DESDE_SORTEO2 DATETIME;
    DECLARE @V_FECHA_HASTA_SORTEO2 DATETIME;
    DECLARE @v_PRODUCTO            NUMERIC(22,0);

   
  SET NOCOUNT ON;

    SELECT @V_PRODUCTO = P.ID_PRODUCTO
      FROM WSXML_SFG.PRODUCTO P
     WHERE CONVERT(NUMERIC,P.CODIGOGTECHPRODUCTO) = CONVERT(NUMERIC,@pg_PRODUCTO)
       AND P.ACTIVE = 1;

    SELECT @V_SORTEO1_VENCIDO = MIN(P1.SORTEO)
      FROM (SELECT SR.*,
                   EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                   ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
              FROM (SELECT P.CODPRODUCTO,
                           L1.SORTEO,
                           L1.FECHASORTEO,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                      FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                     WHERE L1.ACTIVE = 1
                       AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC2
             WHERE EAC.ACTIVE = 1
               AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
               AND EAC.TIPOARCHIVO = 2
               AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
               AND EAC2.TIPOARCHIVO = 2
               AND EAC2.ACTIVE = 1
               AND EAC2.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV) P1;

    SELECT @V_SORTEO2_VENCIDO = MAX(P2.SORTEO)
      FROM (SELECT SR.*,
                   EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                   ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
              FROM (SELECT P.CODPRODUCTO,
                           L1.SORTEO,
                           L1.FECHASORTEO,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                      FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                     WHERE L1.ACTIVE = 1
                       AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC2
             WHERE EAC.ACTIVE = 1
               AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
               AND EAC.TIPOARCHIVO = 2
               AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
               AND EAC2.TIPOARCHIVO = 2
               AND EAC2.ACTIVE = 1
               AND EAC2.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV) P2;

    IF @V_SORTEO1_VENCIDO > 0 AND @V_SORTEO2_VENCIDO > 0 BEGIN

      SELECT @V_FECHA_DESDE_SORTEO1 = MIN(C.FECHAHORAGENERACION), @V_FECHA_HASTA_SORTEO1 = MAX(C.FECHAHORAGENERACION)
        FROM WSXML_SFG.SORTEO_L1LIAB01 SL, WSXML_SFG.CONTROL_L1LIAB01 C
       WHERE C.ID_CONTROL_L1LIAB01 = SL.COD_CONTROL_L1LIAB01
         AND SL.SORTEO = @V_SORTEO1_VENCIDO;

      SELECT @V_FECHA_DESDE_SORTEO2 = MIN(C.FECHAHORAGENERACION), @V_FECHA_HASTA_SORTEO2 = MAX(C.FECHAHORAGENERACION)
        FROM WSXML_SFG.SORTEO_L1LIAB01 SL, WSXML_SFG.CONTROL_L1LIAB01 C
       WHERE C.ID_CONTROL_L1LIAB01 = SL.COD_CONTROL_L1LIAB01
         AND SL.SORTEO = @V_SORTEO2_VENCIDO;


execute sp_executesql 'truncate table WSXML_SFG.tbl_ExpiredWinnersTwoMonths';

insert into WSXML_SFG.tbl_ExpiredWinnersTwoMonths
        SELECT VENCIDOS.SORTEO,
               VENCIDOS.NOMPRODUCTO,
               VENCIDOS.ID_PRODUCTO,
               ISNULL('3 Aciertos de 6',0) as "3 Aciertos de 6",
               ISNULL('4 Aciertos de 6',0) as "4 Aciertos de 6",
               ISNULL('5 Aciertos de 6',0) as "5 Aciertos de 6",
               ISNULL('6 Aciertos de 6',0) as "6 Aciertos de 6",
               CICLOS.FECHASORTEO,
               CICLOS.VENC_UN_ANO AS FECHA_VENCIMIENTO,
               --CICLOS.VENC_UN_ANO - CICLOS.FECHASORTEO as DIAS_VENCIMIENTO,
			   DATEDIFF ( DAY , CICLOS.FECHASORTEO , CICLOS.VENC_UN_ANO ) as DIAS_VENCIMIENTO,
			   --2 as DIAS_VENCIMIENTO,
               CPDV.FECHAEJECUCION AS FECHA_CORTE,
               CPDV.SECUENCIA AS SECUENCIA_CORTE,
               CICLOS.CICLO_UN_ANO AS CICLO_CORTE
        --               CICLOS.VENC_DOS_MESES,
        --               CICLOS.CICLO_DOS_MESES,
          FROM (SELECT *
                  FROM (SELECT *
                          FROM (SELECT NOMBRECATEGORIA,
                                       PAGADOS.SORTEO,
                                       NOMPRODUCTO,
                                       ID_PRODUCTO,
                                       GANADOS.TOT_GANADO - PAGADOS.VALOR AS VALOR_VENCIDOS
                                  FROM (select *
                                          from (

                                                SELECT *

                                                  FROM (SELECT isnull(VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                    VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01) ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                isnull(VW_REPORTE__L1LIAB01_01.NOMBRECATEGORIA,
                                                                    VW_REPORTE__L1LIAB01_02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                                                isnull(VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY -
                                                                    VW_REPORTE__L1LIAB01_01.PAG_ANT_MAS_PAGADO_HOY,
                                                                    VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY) +
                                                                ISNULL(MONTO_PREMIO_NETO,
                                                                    0) AS VALOR,
                                                                VW_REPORTE__L1LIAB01_02.SORTEO,
                                                                VW_REPORTE__L1LIAB01_02.NOMPRODUCTO,
                                                                VW_REPORTE__L1LIAB01_02.ID_PRODUCTO
                                                           FROM (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_02
                                                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION) =
                                                                        dbo.trunc_date(@V_FECHA_HASTA_SORTEO1))
                                                                    and VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_02,
                                                                (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_01
                                                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) =
                                                                        dbo.trunc_date(@V_FECHA_DESDE_SORTEO1))
                                                                    and VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_01,
                                                                (SELECT F.SORTEO,
                                                                        SUM(F.MONTO_PREMIO_NETO) as MONTO_PREMIO_NETO,
                                                                        F.CODPRODUCTO,
                                                                        F.CODCATEGORIA_ACIERTOS_L1LIAB01
                                                                   FROM WSXML_SFG.DETALLE_PREMIOS_FIDUCIA F
                                                                  GROUP BY F.SORTEO,
                                                                           F.CODPRODUCTO,
                                                                           F.CODCATEGORIA_ACIERTOS_L1LIAB01) FD
                                                          WHERE VW_REPORTE__L1LIAB01_02.SORTEO =
                                                                FD.SORTEO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                                                FD.CODCATEGORIA_ACIERTOS_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                                                FD.CODPRODUCTO
                                                            AND VW_REPORTE__L1LIAB01_02.SORTEO =
                                                                VW_REPORTE__L1LIAB01_01.SORTEO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_SORTEO_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_SORTEO_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                                                VW_REPORTE__L1LIAB01_01.ID_PRODUCTO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                                                VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CONTROL_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_CONTROL_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION >
                                                                VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) s) s) PAGADOS,
                                       (SELECT L.CODCATEGORIA_ACIERTOS_L1LIAB01,
                                               L.TOT_GANADO,
                                               SORTEO,
                                               CODPRODUCTO
                                          FROM WSXML_SFG.DETALLE_L1LIAB01 L,
                                               (SELECT MAX(P.ID_SORTEO_L1LIAB01_PRODUCTO) AS ID_SORTEO_L1LIAB01_PRODUCTO,
                                                       S.SORTEO,
                                                       P.CODPRODUCTO
                                                  FROM WSXML_SFG.SORTEO_L1LIAB01          S,
                                                       WSXML_SFG.SORTEO_L1LIAB01_PRODUCTO P
                                                 WHERE S.ID_SORTEO_L1LIAB01 =
                                                       P.CODSORTEO_L1LIAB01
                                                 GROUP BY S.SORTEO,
                                                          P.CODPRODUCTO) SR
                                         WHERE L.CODSORTEO_L1LIAB01_PRODUCTO =
                                               SR.ID_SORTEO_L1LIAB01_PRODUCTO) GANADOS
                                 WHERE PAGADOS.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                       GANADOS.CODCATEGORIA_ACIERTOS_L1LIAB01
                                   AND PAGADOS.SORTEO = GANADOS.SORTEO
                                   AND PAGADOS.ID_PRODUCTO =
                                       GANADOS.CODPRODUCTO) T PIVOT(SUM(VALOR_VENCIDOS) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'],['4 Aciertos de 6'],['5 Aciertos de 6'],['6 Aciertos de 6'])) PIV) T ) VENCIDOS,
               (SELECT SR.*,
                       EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                       ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
                  FROM (SELECT P.CODPRODUCTO,
                               L1.SORTEO,
                               L1.FECHASORTEO,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                               WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                               WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                          FROM CONTROL_L1SHRCLC L1, PRODUCTO_L1SHRCLC P
                         WHERE L1.ACTIVE = 1
                           AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                       ENTRADAARCHIVOCONTROL EAC,
                       ENTRADAARCHIVOCONTROL EAC2
                 WHERE EAC.ACTIVE = 1
                   AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
                   AND EAC.TIPOARCHIVO = 2
                   AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
                   AND EAC2.TIPOARCHIVO = 2
                   AND EAC2.ACTIVE = 1)  CICLOS,
               CICLOFACTURACIONPDV CPDV
         WHERE VENCIDOS.SORTEO = CICLOS.SORTEO
           AND VENCIDOS.ID_PRODUCTO = CICLOS.CODPRODUCTO
           AND CICLOS.CICLO_UN_ANO = @p_CODCICLOFACTURACIONPDV
           AND VENCIDOS.SORTEO = @V_SORTEO1_VENCIDO
           AND ID_PRODUCTO = @v_PRODUCTO
           AND CPDV.ID_CICLOFACTURACIONPDV = CICLOS.CICLO_UN_ANO;

--        UNION

		insert into WSXML_SFG.tbl_ExpiredWinnersTwoMonths
        
		SELECT --VENCIDOS.*
               VENCIDOS.SORTEO,
               VENCIDOS.NOMPRODUCTO,
               VENCIDOS.ID_PRODUCTO,
               ISNULL('3 Aciertos de 6',0) as "3 Aciertos de 6",
               ISNULL('4 Aciertos de 6',0) as "4 Aciertos de 6",
               ISNULL('5 Aciertos de 6',0) as "5 Aciertos de 6",
               ISNULL('6 Aciertos de 6',0) as "6 Aciertos de 6",
               CICLOS.FECHASORTEO,
               CICLOS.VENC_UN_ANO AS FECHA_VENCIMIENTO,
               --CICLOS.VENC_UN_ANO - CICLOS.FECHASORTEO as DIAS_VENCIMIENTO,
			   DATEDIFF ( DAY , CICLOS.FECHASORTEO , CICLOS.VENC_UN_ANO ) as DIAS_VENCIMIENTO,
               CPDV.FECHAEJECUCION AS FECHA_CORTE,
               CPDV.SECUENCIA AS SECUENCIA_CORTE,
               CICLOS.CICLO_UN_ANO AS CICLO_CORTE
        --               CICLOS.VENC_DOS_MESES,
        --               CICLOS.CICLO_DOS_MESES,
          FROM (SELECT *
                  FROM (SELECT *
                          FROM (SELECT NOMBRECATEGORIA,
                                       PAGADOS.SORTEO,
                                       NOMPRODUCTO,
                                       ID_PRODUCTO,
                                       GANADOS.TOT_GANADO - PAGADOS.VALOR AS VALOR_VENCIDOS
                                  FROM (select *
                                          from (

                                                SELECT *

                                                  FROM (SELECT isnull(VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                    VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01) ID_CATEGORIA_ACIERTOS_L1LIAB01,
                                                                isnull(VW_REPORTE__L1LIAB01_01.NOMBRECATEGORIA,
                                                                    VW_REPORTE__L1LIAB01_02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                                                isnull(VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY -
                                                                    VW_REPORTE__L1LIAB01_01.PAG_ANT_MAS_PAGADO_HOY,
                                                                    VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY) +
                                                                ISNULL(MONTO_PREMIO_NETO,
                                                                    0) AS VALOR,
                                                                VW_REPORTE__L1LIAB01_02.SORTEO,
                                                                VW_REPORTE__L1LIAB01_02.NOMPRODUCTO,
                                                                VW_REPORTE__L1LIAB01_02.ID_PRODUCTO
                                                           FROM (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_02
                                                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION) =
                                                                        dbo.trunc_date(@V_FECHA_HASTA_SORTEO2))
                                                                    and VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_02,
                                                                (select *
                                                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_01
                                                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) =
                                                                        dbo.trunc_date(@V_FECHA_DESDE_SORTEO2))
                                                                    and VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                                                        (3, 4, 5, 6)) VW_REPORTE__L1LIAB01_01,
                                                                (SELECT F.SORTEO,
                                                                        SUM(F.MONTO_PREMIO_NETO) as MONTO_PREMIO_NETO,
                                                                        F.CODPRODUCTO,
                                                                        F.CODCATEGORIA_ACIERTOS_L1LIAB01
                                                                   FROM WSXML_SFG.DETALLE_PREMIOS_FIDUCIA F
                                                                  GROUP BY F.SORTEO,
                                                                           F.CODPRODUCTO,
                                                                           F.CODCATEGORIA_ACIERTOS_L1LIAB01) FD
                                                          WHERE VW_REPORTE__L1LIAB01_02.SORTEO =
                                                                FD.SORTEO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                                                FD.CODCATEGORIA_ACIERTOS_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                                                FD.CODPRODUCTO
                                                            AND VW_REPORTE__L1LIAB01_02.SORTEO =
                                                                VW_REPORTE__L1LIAB01_01.SORTEO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_SORTEO_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_SORTEO_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                                                VW_REPORTE__L1LIAB01_01.ID_PRODUCTO
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                                                VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.ID_CONTROL_L1LIAB01 <>
                                                                VW_REPORTE__L1LIAB01_01.ID_CONTROL_L1LIAB01
                                                            AND VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION >
                                                                VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) s) s) PAGADOS,
                                       (SELECT L.CODCATEGORIA_ACIERTOS_L1LIAB01,
                                               L.TOT_GANADO,
                                               SORTEO,
                                               CODPRODUCTO
                                          FROM WSXML_SFG.DETALLE_L1LIAB01 L,
                                               (SELECT MAX(P.ID_SORTEO_L1LIAB01_PRODUCTO) AS ID_SORTEO_L1LIAB01_PRODUCTO,
                                                       S.SORTEO,
                                                       P.CODPRODUCTO
                                                  FROM WSXML_SFG.SORTEO_L1LIAB01          S,
                                                       WSXML_SFG.SORTEO_L1LIAB01_PRODUCTO P
                                                 WHERE S.ID_SORTEO_L1LIAB01 =
                                                       P.CODSORTEO_L1LIAB01
                                                 GROUP BY S.SORTEO,
                                                          P.CODPRODUCTO) SR
                                         WHERE L.CODSORTEO_L1LIAB01_PRODUCTO =
                                               SR.ID_SORTEO_L1LIAB01_PRODUCTO) GANADOS
                                 WHERE PAGADOS.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                       GANADOS.CODCATEGORIA_ACIERTOS_L1LIAB01
                                   AND PAGADOS.SORTEO = GANADOS.SORTEO
                                   AND PAGADOS.ID_PRODUCTO =
                                       GANADOS.CODPRODUCTO) T PIVOT(SUM(VALOR_VENCIDOS) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'],['4 Aciertos de 6'],['5 Aciertos de 6'],['6 Aciertos de 6'])) PIV ) T ) VENCIDOS,
               (SELECT SR.*,
                       EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                       ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
                  FROM (SELECT P.CODPRODUCTO,
                               L1.SORTEO,
                               L1.FECHASORTEO,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                               WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                               CONVERT(DATETIME,L1.FECHASORTEO) +
                               WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                          FROM CONTROL_L1SHRCLC L1, PRODUCTO_L1SHRCLC P
                         WHERE L1.ACTIVE = 1
                           AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                       ENTRADAARCHIVOCONTROL EAC,
                       ENTRADAARCHIVOCONTROL EAC2
                 WHERE EAC.ACTIVE = 1
                   AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
                   AND EAC.TIPOARCHIVO = 2
                   AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
                   AND EAC2.TIPOARCHIVO = 2
                   AND EAC2.ACTIVE = 1) CICLOS,
               CICLOFACTURACIONPDV CPDV
         WHERE VENCIDOS.SORTEO = CICLOS.SORTEO
           AND VENCIDOS.ID_PRODUCTO = CICLOS.CODPRODUCTO
           AND CICLOS.CICLO_UN_ANO = @p_CODCICLOFACTURACIONPDV
           AND VENCIDOS.SORTEO = @V_SORTEO2_VENCIDO
           AND ID_PRODUCTO = @v_PRODUCTO
           AND CPDV.ID_CICLOFACTURACIONPDV = CICLOS.CICLO_UN_ANO;

	commit;

	select * from WSXML_SFG.tbl_ExpiredWinnersTwoMonths;
 
    END 

  END
  GO



  IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySales', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySales;
GO


  CREATE PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySales(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                           @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                           @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                           @pg_PRODUCTO              NVARCHAR(2000),
                           @pg_REDPDV                NVARCHAR(2000),
                           @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
    --BALOTO
    IF WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO) = 105 BEGIN

		  IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '01-03-2012' BEGIN
				SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
					   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
					   /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                  AS GASTOSOPERACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                  AS GASTOSMERCADEO,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'),
							 0) AS DERECHOSEXPLOTACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'),
							 0) AS GASTOSADMON,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Baloto'),
							 0) AS DESCUENTOENVENTAS,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'),
							 0) AS GASTOSOPERACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'),
							 0) AS GASTOSMERCADEO,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'),
							 0) AS PREMIOS
				  FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
							   ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
							   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
							   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
							   SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
							   SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
							   SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
						  FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
						 INNER JOIN WSXML_SFG.PRODUCTO PRD
							ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
						 INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
							ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
						 WHERE PRF.FECHAARCHIVO BETWEEN
							   CONVERT(DATETIME, '26/02/2012', 103) AND
							   CONVERT(DATETIME, '29/02/2012', 103)
						   AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
						   AND PRD.CODTIPOPRODUCTO = CASE
								 WHEN @p_CODTIPOPRODUCTO = -1 THEN
								  PRD.CODTIPOPRODUCTO
								 ELSE
								  @p_CODTIPOPRODUCTO
							   END
						   AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
						 GROUP BY PRF.FECHAARCHIVO) PRF;
		  END ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '04-03-2012' BEGIN
          
			  IF FORMAT(GETDATE(), 'HH') > 12
				  ---  SE EJECUTA  SOLO AL CORTE DE 18 A 22
					SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
						   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
						   /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                                  AS GASTOSOPERACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                  AS GASTOSMERCADEO,
							ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'),
								 0) AS DERECHOSEXPLOTACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'),
								 0) AS GASTOSADMON,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Baloto'),
								 0) AS DESCUENTOENVENTAS,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'),
								 0) AS GASTOSOPERACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'),
								 0) AS GASTOSMERCADEO,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'),
								 0) AS PREMIOS
					  FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
								   ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
								   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
										 0) AS INGRESOSBRUTNAANULACIONNOROUND,
								   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
								   SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
								   SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
								   SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
							  FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
							 INNER JOIN WSXML_SFG.PRODUCTO PRD
								ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
							 INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
								ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
							 WHERE PRF.FECHAARCHIVO BETWEEN
								   CONVERT(DATETIME, '01/03/2012', 103) AND
								   CONVERT(DATETIME, '03/03/2012', 103)
							   AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
							   AND PRD.CODTIPOPRODUCTO = CASE
									 WHEN @p_CODTIPOPRODUCTO = -1 THEN
									  PRD.CODTIPOPRODUCTO
									 ELSE
									  @p_CODTIPOPRODUCTO
								   END
							   AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
							 GROUP BY PRF.FECHAARCHIVO) PRF;
				ELSE
					SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
						   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
						   /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                                  AS GASTOSOPERACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                  AS GASTOSMERCADEO,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'),
								 0) AS DERECHOSEXPLOTACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'),
								 0) AS GASTOSADMON,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Baloto'),
								 0) AS DESCUENTOENVENTAS,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'),
								 0) AS GASTOSOPERACION,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'),
								 0) AS GASTOSMERCADEO,
						   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
								 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'),
								 0) AS PREMIOS
					  FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
								   ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
								   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
										 0) AS INGRESOSBRUTNAANULACIONNOROUND,
								   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
								   SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
								   SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
								   SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
							  FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
							 INNER JOIN WSXML_SFG.PRODUCTO PRD
								ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
							 INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
								ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
							WHERE PRF.CODCICLOFACTURACIONPDV =
								   @p_CODCICLOFACTURACIONPDV
                                
							   AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
							   AND PRD.CODTIPOPRODUCTO = CASE
									 WHEN @p_CODTIPOPRODUCTO = -1 THEN
									  PRD.CODTIPOPRODUCTO
									 ELSE
									  @p_CODTIPOPRODUCTO
								   END
							   AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
							 GROUP BY PRF.FECHAARCHIVO) PRF;
		  END ELSE
				SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
					   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
					   /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                                  AS GASTOSOPERACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                            AS GASTOSMERCADEO,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'),
							 0) AS DERECHOSEXPLOTACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'),
							 0) AS GASTOSADMON,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Baloto'),
							 0) AS DESCUENTOENVENTAS,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'),
							 0) AS GASTOSOPERACION,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'),
							 0) AS GASTOSMERCADEO,
					   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
							 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'),
							 0) AS PREMIOS
				  FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
							   ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
							   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
							   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
							   SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
							   SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
							   SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
						  FROM  WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS    PRF
						 INNER JOIN WSXML_SFG.PRODUCTO PRD
							ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
						 INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
							ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
						 WHERE PRF.CODCICLOFACTURACIONPDV =
							   @p_CODCICLOFACTURACIONPDV
						   AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
						   AND PRD.CODTIPOPRODUCTO = CASE
								 WHEN @p_CODTIPOPRODUCTO = -1 THEN
								  PRD.CODTIPOPRODUCTO
								 ELSE
								  @p_CODTIPOPRODUCTO
							   END
						   AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
						 GROUP BY PRF.FECHAARCHIVO) PRF;


    End
    Else BEGIN

      IF FORMAT(GETDATE(), 'dd-MM-yyyy') ='01-03-2012'
            SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                   /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                  AS GASTOSOPERACION,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                  AS GASTOSMERCADEO,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Revancha'),
                         0) AS DERECHOSEXPLOTACION,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Revancha'),
                         0) AS GASTOSADMON,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Revancha'),
                         0) AS DESCUENTOENVENTAS,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Revancha'),
                         0) AS GASTOSOPERACION,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Revancha'),
                         0) AS GASTOSMERCADEO,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Revancha'),
                         0) AS PREMIOS
              FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                           ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                           ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                           ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                           SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                           SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                           SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                      FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                     INNER JOIN WSXML_SFG.PRODUCTO PRD
                        ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                     INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                        ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                     WHERE PRF.FECHAARCHIVO BETWEEN
                           CONVERT(DATETIME, '26/02/2012', 103) AND
                           CONVERT(DATETIME, '29/02/2012', 103)
                       AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                       AND PRD.CODTIPOPRODUCTO = CASE
                             WHEN @p_CODTIPOPRODUCTO = -1 THEN
                              PRD.CODTIPOPRODUCTO
                             ELSE
                              @p_CODTIPOPRODUCTO
                           END
                       AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     GROUP BY PRF.FECHAARCHIVO) PRF;

      ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '04-03-2012' BEGIN
          
            IF CONVERT(NUMERIC,FORMAT(GETDATE(), 'HH')) > 12
              ---  SE EJECUTA  SOLO AL CORTE DE 18 A 22
                SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                       ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                       /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                                  AS GASTOSOPERACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                  AS GASTOSMERCADEO,
                        ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Revancha'),
                             0) AS DERECHOSEXPLOTACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Revancha'),
                             0) AS GASTOSADMON,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Revancha'),
                             0) AS DESCUENTOENVENTAS,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Revancha'),
                             0) AS GASTOSOPERACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Revancha'),
                             0) AS GASTOSMERCADEO,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Revancha'),
                             0) AS PREMIOS
                  FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                               ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                               ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                     0) AS INGRESOSBRUTNAANULACIONNOROUND,
                               ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                               SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                               SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                               SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                          FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                         INNER JOIN WSXML_SFG.PRODUCTO PRD
                            ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                         INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                            ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                         WHERE PRF.FECHAARCHIVO BETWEEN
                               CONVERT(DATETIME, '01/03/2012', 103) AND
                               CONVERT(DATETIME, '03/03/2012', 103)
                           AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                           AND PRD.CODTIPOPRODUCTO = CASE
                                 WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                  PRD.CODTIPOPRODUCTO
                                 ELSE
                                  @p_CODTIPOPRODUCTO
                               END
                           AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                         GROUP BY PRF.FECHAARCHIVO) PRF;
            ELSE
                SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                       ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                       /*ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0)                                AS TRANSFERENCIASSALUD,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.32, 0)                                AS DERECHOSEXPLOTACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0032, 0)                                AS GASTOSADMON,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0)                                AS DESCUENTOENVENTAS,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0)                                                  AS GASTOSOPERACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0)                                  AS GASTOSMERCADEO,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0)                                  AS PREMIOS*/
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Revancha'),
                             0) AS DERECHOSEXPLOTACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Revancha'),
                             0) AS GASTOSADMON,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Revancha'),
                             0) AS DESCUENTOENVENTAS,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Revancha'),
                             0) AS GASTOSOPERACION,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Revancha'),
                             0) AS GASTOSMERCADEO,
                       ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                             WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Revancha'),
                             0) AS PREMIOS
                  FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                               ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                               ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                     0) AS INGRESOSBRUTNAANULACIONNOROUND,
                               ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                               SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                               SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                               SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                          FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                         INNER JOIN WSXML_SFG.PRODUCTO PRD
                            ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                         INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                            ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                         WHERE PRF.CODCICLOFACTURACIONPDV =
                               @p_CODCICLOFACTURACIONPDV
                           AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                           AND PRD.CODTIPOPRODUCTO = CASE
                                 WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                  PRD.CODTIPOPRODUCTO
                                 ELSE
                                  @p_CODTIPOPRODUCTO
                               END
                           AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                         GROUP BY PRF.FECHAARCHIVO) PRF;


      END ELSE
            SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) 
            - ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) 
            AS VENTASTOTALES,
                   ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0)
                   - ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0)
                    AS VENTASBRUTAS,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Revancha'),
                         0) AS DERECHOSEXPLOTACION,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Revancha'),
                         0) AS GASTOSADMON,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Revancha'),
                         0) AS DESCUENTOENVENTAS,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Revancha'),
                         0) AS GASTOSOPERACION,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Revancha'),
                         0) AS GASTOSMERCADEO,
                   ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) *
                         WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Revancha'),
                         0) AS PREMIOS
              FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                           ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                           ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                           ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                           SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                           SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                           SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                      FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                     INNER JOIN WSXML_SFG.PRODUCTO PRD
                        ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                     INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                        ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                     WHERE PRF.CODCICLOFACTURACIONPDV =
                           @p_CODCICLOFACTURACIONPDV
                       AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                       AND PRD.CODTIPOPRODUCTO = CASE
                             WHEN @p_CODTIPOPRODUCTO = -1 THEN
                              PRD.CODTIPOPRODUCTO
                             ELSE
                              @p_CODTIPOPRODUCTO
                           END
                       AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO) 
                     GROUP BY PRF.FECHAARCHIVO) PRF;


    END
END
GO

 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetail', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetail;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetail(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                 @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                 @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                 @pg_PRODUCTO              NVARCHAR(2000),
                                 @pg_REDPDV                NVARCHAR(2000),
                                @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;


/*Cambiar para carta de avanzadas*/

        SELECT /*+
                   PUSH_PRED(L1)
                 */
           PRE.CODPRODUCTO,
           PRE.CODCICLOFACTURACIONPDV,
           ROUND(SUM(PRE.INGRESOSBRUTOSNANOREDONDEO) *
                 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'),
                 0) AS DERECHOSEXPLOTACION,
           ROUND(SUM(PRE.INGRESOSBRUTOSNANOREDONDEO) *
                 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'),
                 0) AS GASTOSADMON,
           ROUND(SUM(PRE.INGRESOSBRUTOSNANOREDONDEO) *
                 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'),
                 0) AS GASTOSOPERACION,
           ROUND(SUM(PRE.INGRESOSBRUTOSNANOREDONDEO) *
                 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'),
                 0) AS GASTOSMERCADEO,

          ROUND(SUM(PRE.INGRESOSBRUTOSNANOREDONDEO +
                  (((ADV.VENTAS - ADVACTUAL.VENTAS)) /
                  WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas'))) *
                 (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PAGOPREMIOS_6_Aciertos_Baloto') +
                  WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PAGOPREMIOS_5_Aciertos_Baloto')),
                 0) AS PAGO_PREMIOS_5_6,
            ROUND(ROUND(SUM(PRE.INGRESOSBRUTOSNANOREDONDEO +
                 ((ADV.VENTAS -ADVACTUAL.VENTAS) /
                 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas'))) *
                 WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('RESERVATECNICA_Baloto'),
                 2) + SUM(L1.TOTAL_REDONDEO), 2) - SUM(isnull(detallel1.AJUSTES, 0)) AS RESERVA_TECNICA,
          ROUND(sum((Adiciones.VENTAS* WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))/ WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0)  as ventas
            FROM (SELECT ENTRADAARCHIVOCONTROL.FECHAARCHIVO,
                         ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV,
                         REG.CODPRODUCTO,
                         ROUND(SUM(CASE
                                     WHEN REG.CODTIPOREGISTRO IN (1, 3) THEN
                                      (REG.VALORVENTABRUTANOREDONDEADO -
                                      ISNULL(AFC.VALORVENTABRUTANOREDONDEADO, 0))
                                     WHEN REG.CODTIPOREGISTRO = 2 THEN
                                      (REG.VALORVENTABRUTANOREDONDEADO -
                                      ISNULL(AFC.VALORVENTABRUTANOREDONDEADO, 0)) * (-1)
                                     ELSE
                                      0
                                   END),
                               10) AS INGRESOSBRUTOSNANOREDONDEO
                    FROM WSXML_SFG.REGISTROFACTURACION REG
                   INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                      ON REG.CODENTRADAARCHIVOCONTROL =
                         ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                    LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE RRV
                      ON (RRV.CODENTRADAARCHIVOCONTROL = REG.CODENTRADAARCHIVOCONTROL AND
                         RRV.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
                    LEFT OUTER JOIN (SELECT CODREGISTROFACTDESTINO,
                                           SUM(VALORVENTABRUTANOREDONDEADO) AS VALORVENTABRUTANOREDONDEADO
                                      FROM WSXML_SFG.AJUSTEFACTURACION
                                      INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON AJUSTEFACTURACION.CODENTRADAARCHIVODESTINO = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                                     WHERE CODTIPOAJUSTEFACTURACION = 1
                                     /*AND ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV = p_CODCICLOFACTURACIONPDV*/
                                     AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
                                     GROUP BY  CODREGISTROFACTDESTINO) AFC
                      ON (AFC.CODREGISTROFACTDESTINO = REG.ID_REGISTROFACTURACION)
                   WHERE REG.CODTIPOREGISTRO IN (1, 2, 3)
                   /*  AND ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN '23/MAR/2014' AND
                         '29/MAR/2014'*/
                     AND REG.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY REG.CODPRODUCTO,
                            ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV, 
                            ENTRADAARCHIVOCONTROL.FECHAARCHIVO) PRE
           INNER JOIN WSXML_SFG.REDONDEO_L1SHRCLC L1
              ON L1.ID_CICLOFACTURACIONPDV = PRE.CODCICLOFACTURACIONPDV
             AND L1.CODPRODUCTO = PRE.CODPRODUCTO
           
             
               LEFT OUTER JOIN (SELECT ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV,
                                      ADVV.ID_PRODUCTO,
                                      SUM(ADVV.VENTA) AS VENTAS
                                 FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
                                INNER JOIN ENTRADAARCHIVOCONTROL
                                   ON ADVV.FECHAARCHIVO =
                                      ENTRADAARCHIVOCONTROL.FECHAARCHIVO
                                  AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
                                  AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
                                WHERE ADVV.ACTIVE = 1
                                  and ADVV.fechaarchivo in
                                      (select FECHAARCHIVO
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        /*where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = p_CODCICLOFACTURACIONPDV*/
                                        where ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
                                        )
                                GROUP BY ENTRADAARCHIVOCONTROL.CODCICLOFACTURACIONPDV,
                                         ID_PRODUCTO) ADVACTUAL
                ON PRE.CODCICLOFACTURACIONPDV = ADVACTUAL.CODCICLOFACTURACIONPDV
               AND PRE.CODPRODUCTO = ADVACTUAL.ID_PRODUCTO
              LEFT OUTER JOIN (SELECT ADVV.ID_PRODUCTO,
                                      SUM(ADVV.VENTA) AS VENTAS
                                 FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
                                INNER JOIN ENTRADAARCHIVOCONTROL
                                   ON ADVV.FECHAARCHIVO =
                                      ENTRADAARCHIVOCONTROL.FECHAARCHIVO
                                  AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
                                  AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
                                WHERE ADVV.ACTIVE = 1
                                  and ADVV.fecha in
                                      (select FECHAARCHIVO
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        /*where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = p_CODCICLOFACTURACIONPDV*/
                                        where ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
                                        )
                                GROUP BY ID_PRODUCTO) ADV
                on PRE.CODPRODUCTO =  ADV.ID_PRODUCTO
                   LEFT OUTER JOIN (SELECT ADVV.ID_PRODUCTO,
                                      SUM(ADVV.VENTA) AS VENTAS
                                 FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
                                INNER JOIN ENTRADAARCHIVOCONTROL
                                   ON ADVV.FECHAARCHIVO =
                                      ENTRADAARCHIVOCONTROL.FECHAARCHIVO
                                  AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
                                  AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
                                WHERE ADVV.ACTIVE = 1
                                  and ADVV.fechaarchivo in
                                      (select (FECHAARCHIVO)
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        /*where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = p_CODCICLOFACTURACIONPDV*/
                                        where ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
                                        )
                                         and ADVV.fecha not in
                                      (select (FECHAARCHIVO)
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        /*where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = p_CODCICLOFACTURACIONPDV*/
                                        where ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
                                        )
                                GROUP BY ID_PRODUCTO) Adiciones
                on PRE.CODPRODUCTO =  Adiciones.ID_PRODUCTO
                left outer join ( select producto_l1shrclc.codproducto, sum(detalle_l1shrclc.ajustes) as ajustes
                                from WSXML_SFG.detalle_l1shrclc, WSXML_SFG.producto_l1shrclc 
                                inner join WSXML_SFG.control_l1shrclc on control_l1shrclc.id_control_l1shrclc = producto_l1shrclc.codcontrol_l1shrclc
                                left outer join entradaarchivocontrol on convert(datetime, convert(date,control_l1shrclc.fechahorageneracionarchivo)) = entradaarchivocontrol.fechaarchivo and entradaarchivocontrol.tipoarchivo = 1 
                                where producto_l1shrclc.id_producto_l1shrclc = detalle_l1shrclc.codproducto_l1shrclc
                                /*and entradaarchivocontrol.codciclofacturacionpdv = p_CODCICLOFACTURACIONPDV*/
                                AND entradaarchivocontrol.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
                                group by producto_l1shrclc.codproducto--, producto_l1shrclc.codcontrol_l1shrclc
--                                order by producto_l1shrclc.codcontrol_l1shrclc desc
                        ) detallel1 on  detallel1.codproducto = l1.CODPRODUCTO
                        
           /*WHERE PRE.CODCICLOFACTURACIONPDV = p_CODCICLOFACTURACIONPDV*/
           where PRE.FECHAARCHIVO BETWEEN '16/APR/2017' AND '19/APR/2017'
           GROUP BY PRE.CODPRODUCTO,
                    PRE.CODCICLOFACTURACIONPDV,
                    L1.TOTAL_REDONDEO,
                    ADV.VENTAS;
  END;
  GO

 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetailNow', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetailNow;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetailNow(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                    @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                    @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                    @pg_PRODUCTO              NVARCHAR(2000),
                                    @pg_REDPDV                NVARCHAR(2000),
                                   @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;

	DECLARE @FECHAHOY DATETIME = GETDATE()

    IF FORMAT(@FECHAHOY, 'dd-MM-yyyy') = '01-03-2012' 
	BEGIN
          SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
            FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                         SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                         SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                         SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                   INNER JOIN WSXML_SFG.PRODUCTO PRD
                      ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                      ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                   WHERE PRF.FECHAARCHIVO BETWEEN
                         CONVERT(DATETIME, '26/02/2012') AND
                         CONVERT(DATETIME, '29/02/2012')
                     AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                     AND PRD.CODTIPOPRODUCTO = CASE
                           WHEN @p_CODTIPOPRODUCTO = -1 THEN
                            PRD.CODTIPOPRODUCTO
                           ELSE
                            @p_CODTIPOPRODUCTO
                         END
                     AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY PRF.FECHAARCHIVO) PRF;

	END					
    IF FORMAT(@FECHAHOY, 'dd-MM-yyyy') = '04-03-2012' BEGIN
        
          IF CAST(FORMAT(GETDATE(), 'HH') AS INT) > 12 BEGIN
              SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
                FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                             ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                   0) AS INGRESOSBRUTNAANULACIONNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                             SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                             SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                             SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                       INNER JOIN WSXML_SFG.PRODUCTO PRD
                          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                       WHERE PRF.FECHAARCHIVO BETWEEN
                             CONVERT(DATETIME, '01/03/2012', 103) AND
                             CONVERT(DATETIME, '03/03/2012', 103)
                         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND PRD.CODTIPOPRODUCTO = CASE
                               WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                PRD.CODTIPOPRODUCTO
                               ELSE
                                @p_CODTIPOPRODUCTO
                             END
                         AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                       GROUP BY PRF.FECHAARCHIVO) PRF;

          END ELSE
              SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
                FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                             ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                   0) AS INGRESOSBRUTNAANULACIONNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                             SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                             SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                             SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                       INNER JOIN WSXML_SFG.PRODUCTO PRD
                          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                       WHERE PRF.FECHAARCHIVO BETWEEN
                             CONVERT(DATETIME, '01/07/2010', 103) AND
                             CONVERT(DATETIME, '03/07/2010', 103)
                         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND PRD.CODTIPOPRODUCTO = CASE
                               WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                PRD.CODTIPOPRODUCTO
                               ELSE
                                @p_CODTIPOPRODUCTO
                             END
                         AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                       GROUP BY PRF.FECHAARCHIVO) PRF;

	END	
	ELSE
		SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
            FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                         SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                         SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                         SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                   INNER JOIN WSXML_SFG.PRODUCTO PRD
                      ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                      ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                   WHERE PRF.FECHAARCHIVO BETWEEN
                         CONVERT(DATETIME, CONVERT(DATE,'01/07/2010')) AND
                         CONVERT(DATETIME, CONVERT(DATE,'03/07/2010'))
                     AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                     AND PRD.CODTIPOPRODUCTO = CASE
                           WHEN @p_CODTIPOPRODUCTO = -1 THEN
                            PRD.CODTIPOPRODUCTO
                           ELSE
                            @p_CODTIPOPRODUCTO
                         END
                     AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY PRF.FECHAARCHIVO) PRF;
    

  END
GO


 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommision', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommision;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommision(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                  @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                  @pg_PRODUCTO              NVARCHAR(2000),
                                  @pg_REDPDV                NVARCHAR(2000),
                                 @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;

    IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '01-03-2012' BEGIN
      
          SELECT AGP.NOMAGRUPACIONPRODUCTO AS PRODUCTO,
                 SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                 SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                 SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                 ISNULL(MAX(CASE
                       WHEN RCM.CODTIPOCOMISION = 1 THEN
                        ISNULL(RCD.VALORPORCENTUAL, '') + '%'
                       WHEN RCM.CODTIPOCOMISION = 2 THEN
                        '$' + ISNULL(RCD.VALORTRANSACCIONAL, '')
                       ELSE
                        '?'
                     END), '') + ' * ' + '(1 + ' + ISNULL(MAX(PTG.VALOR), '') + '%)' AS COMISIONGFH,
                 SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                 ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                 SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
              ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.RANGOCOMISION RCM
              ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
              ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTG.CODTARIFAVALOR = 2)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
              ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTE.CODTARIFAVALOR = 3)
           INNER JOIN (SELECT CODRANGOCOMISION,
                              MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                              MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                         FROM WSXML_SFG.RANGOCOMISIONDETALLE
                        GROUP BY CODRANGOCOMISION) RCD
              ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
           WHERE PRF.FECHAARCHIVO BETWEEN
                 CONVERT(DATETIME, CONVERT(DATE,'26/02/2012')) AND
                 CONVERT(DATETIME, CONVERT(DATE,'29/02/2012'))
             AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
             AND PRD.CODTIPOPRODUCTO = CASE
                   WHEN @p_CODTIPOPRODUCTO = -1 THEN
                    PRD.CODTIPOPRODUCTO
                   ELSE
                    @p_CODTIPOPRODUCTO
                 END
             AND PRF.CODPRODUCTO = CASE
                   WHEN @pg_PRODUCTO = '-1' THEN
                    PRF.CODPRODUCTO
                   ELSE
                    WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                 END
           GROUP BY AGP.ID_AGRUPACIONPRODUCTO, AGP.NOMAGRUPACIONPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO;
	END

    IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '04-03-2012' BEGIN
		IF FORMAT(GETDATE(), 'HH') > 12 BEGIN

              SELECT AGP.NOMAGRUPACIONPRODUCTO AS PRODUCTO,
                     SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                     SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                     SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                     ISNULL(MAX(CASE
                           WHEN RCM.CODTIPOCOMISION = 1 THEN
                            ISNULL(RCD.VALORPORCENTUAL, '') + '%'
                           WHEN RCM.CODTIPOCOMISION = 2 THEN
                            '$' + ISNULL(RCD.VALORTRANSACCIONAL, '')
                           ELSE
                            '?'
                         END), '') + ' * ' + '(1 + ' + ISNULL(MAX(PTG.VALOR), '') + '%)' AS COMISIONGFH,
                     SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                     ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                     SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
                  ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
                  ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.RANGOCOMISION RCM
                  ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
                  ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTG.CODTARIFAVALOR = 2)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
                  ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTE.CODTARIFAVALOR = 3)
               INNER JOIN (SELECT CODRANGOCOMISION,
                                  MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                                  MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                            GROUP BY CODRANGOCOMISION) RCD
                  ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
               WHERE PRF.FECHAARCHIVO BETWEEN
                     CONVERT(DATETIME, '01/03/2012') AND
                     CONVERT(DATETIME, '03/03/2012')
                 AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                 AND PRD.CODTIPOPRODUCTO = CASE
                       WHEN @p_CODTIPOPRODUCTO = -1 THEN
                        PRD.CODTIPOPRODUCTO
                       ELSE
                        @p_CODTIPOPRODUCTO
                     END
                 AND PRF.CODPRODUCTO = CASE
                       WHEN @pg_PRODUCTO = '-1' THEN
                        PRF.CODPRODUCTO
                       ELSE
                        WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     END
               GROUP BY AGP.ID_AGRUPACIONPRODUCTO,
                        AGP.NOMAGRUPACIONPRODUCTO
               ORDER BY AGP.NOMAGRUPACIONPRODUCTO;

         END ELSE
              SELECT AGP.NOMAGRUPACIONPRODUCTO AS PRODUCTO,
                     SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                     SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                     SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                     ISNULL(MAX(CASE
                           WHEN RCM.CODTIPOCOMISION = 1 THEN
                            ISNULL(RCD.VALORPORCENTUAL, '') + '%'
                           WHEN RCM.CODTIPOCOMISION = 2 THEN
                            '$' + ISNULL(RCD.VALORTRANSACCIONAL, '')
                           ELSE
                            '?'
                         END), '') + ' * ' + '(1 + ' + ISNULL(MAX(PTG.VALOR), '') + '%)' AS COMISIONGFH,
                     SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                     ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                     SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               INNER JOIN WSXML_SFG.AGRUPACIONPRODUCTO AGP
                  ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
                  ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.RANGOCOMISION RCM
                  ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
                  ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTG.CODTARIFAVALOR = 2)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
                  ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTE.CODTARIFAVALOR = 3)
               INNER JOIN (SELECT CODRANGOCOMISION,
                                  MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                                  MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                            GROUP BY CODRANGOCOMISION) RCD
                  ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
               WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
                 AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                 AND PRD.CODTIPOPRODUCTO = CASE
                       WHEN @p_CODTIPOPRODUCTO = -1 THEN
                        PRD.CODTIPOPRODUCTO
                       ELSE
                        @p_CODTIPOPRODUCTO
                     END
                 AND PRF.CODPRODUCTO = CASE
                       WHEN @pg_PRODUCTO = '-1' THEN
                        PRF.CODPRODUCTO
                       ELSE
                        WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     END
               GROUP BY AGP.ID_AGRUPACIONPRODUCTO,
                        AGP.NOMAGRUPACIONPRODUCTO
               ORDER BY AGP.NOMAGRUPACIONPRODUCTO;

        

     END ELSE
          SELECT AGP.NOMAGRUPACIONPRODUCTO AS PRODUCTO,
                 SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                 SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                 SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                 ISNULL(MAX(CASE
                       WHEN RCM.CODTIPOCOMISION = 1 THEN
                        ISNULL(RCD.VALORPORCENTUAL, '') + '%'
                       WHEN RCM.CODTIPOCOMISION = 2 THEN
                        '$' + ISNULL(RCD.VALORTRANSACCIONAL, '')
                       ELSE
                        '?'
                     END), '') + ' * ' + '(1 + ' + ISNULL(MAX(PTG.VALOR), '') + '%)' AS COMISIONGFH,
                 SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                 ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                 SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           INNER JOIN AGRUPACIONPRODUCTO AGP
              ON (AGP.ID_AGRUPACIONPRODUCTO = PRD.CODAGRUPACIONPRODUCTO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
              ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.RANGOCOMISION RCM
              ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
              ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTG.CODTARIFAVALOR = 2)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
              ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTE.CODTARIFAVALOR = 3)
           INNER JOIN (SELECT CODRANGOCOMISION,
                              MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                              MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                         FROM WSXML_SFG.RANGOCOMISIONDETALLE
                        GROUP BY CODRANGOCOMISION) RCD
              ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
           WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
             AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
             AND PRD.CODTIPOPRODUCTO = CASE
                   WHEN @p_CODTIPOPRODUCTO = -1 THEN
                    PRD.CODTIPOPRODUCTO
                   ELSE
                    @p_CODTIPOPRODUCTO
                 END
             AND PRF.CODPRODUCTO = CASE
                   WHEN @pg_PRODUCTO = '-1' THEN
                    PRF.CODPRODUCTO
                   ELSE
                    WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                 END
           GROUP BY AGP.ID_AGRUPACIONPRODUCTO, AGP.NOMAGRUPACIONPRODUCTO
           ORDER BY AGP.NOMAGRUPACIONPRODUCTO;

    
  END; 
GO


 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommisionPines', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommisionPines;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommisionPines(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                       @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                       @pg_PRODUCTO              NVARCHAR(2000),
                                       @pg_REDPDV                NVARCHAR(2000),
                                      @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;

    IF FORMAT(GETDATE(), 'dd-MM-yyyy')= '01-03-2012' BEGIN
          SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                 SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                 SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                 SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                 CASE
                   WHEN RCM.CODTIPOCOMISION = 1 THEN
                    ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                   WHEN RCM.CODTIPOCOMISION = 2 THEN
                    '$' + ISNULL((RCD.VALORTRANSACCIONAL * (1 + (MAX(PTG.VALOR) / 100))), '')
                   ELSE
                    ''
                 END AS COMISIONGFH,
                 SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                 ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                 SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
              ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
              ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.RANGOCOMISION RCM
              ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
              ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTG.CODTARIFAVALOR = 2)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
              ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTE.CODTARIFAVALOR = 3)
           INNER JOIN (SELECT CODRANGOCOMISION,
                              MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                              MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                         FROM WSXML_SFG.RANGOCOMISIONDETALLE
                        GROUP BY CODRANGOCOMISION) RCD
              ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
           WHERE PRF.FECHAARCHIVO BETWEEN
                 CONVERT(DATETIME, '26/02/2012', 103) AND
                 CONVERT(DATETIME, '29/02/2012', 103)
             AND TPR.CODLINEADENEGOCIO = 2
             AND PRD.CODTIPOPRODUCTO = CASE
                   WHEN @p_CODTIPOPRODUCTO = -1 THEN
                    PRD.CODTIPOPRODUCTO
                   ELSE
                    @p_CODTIPOPRODUCTO
                 END
             AND PRF.CODPRODUCTO = CASE
                   WHEN @pg_PRODUCTO = '-1' THEN
                    PRF.CODPRODUCTO
                   ELSE
                    WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                 END
           GROUP BY AST.ID_ALIADOESTRATEGICO,
                    AST.NOMALIADOESTRATEGICO,
                    RCM.ID_RANGOCOMISION,
                    RCM.CODTIPOCOMISION,
                    RCD.VALORPORCENTUAL,
                    RCD.VALORTRANSACCIONAL
           ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;

     END ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy')= '04-03-2012' BEGIN
        IF FORMAT(GETDATE(), 'HH') > 12 BEGIN
              SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                     SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                     SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                     SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                     CASE
                       WHEN RCM.CODTIPOCOMISION = 1 THEN
                        ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                       WHEN RCM.CODTIPOCOMISION = 2 THEN
                        '$' + ISNULL((RCD.VALORTRANSACCIONAL *
                        (1 + (MAX(PTG.VALOR) / 100))), '')
                       ELSE
                        ''
                     END AS COMISIONGFH,
                     SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                     ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                     SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
                  ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
                  ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.RANGOCOMISION RCM
                  ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
                  ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTG.CODTARIFAVALOR = 2)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
                  ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTE.CODTARIFAVALOR = 3)
               INNER JOIN (SELECT CODRANGOCOMISION,
                                  MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                                  MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                            GROUP BY CODRANGOCOMISION) RCD
                  ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
               WHERE PRF.FECHAARCHIVO BETWEEN
                     CONVERT(DATETIME, '01/03/2012',103) AND
                     CONVERT(DATETIME, '03/03/2012',103)
                 AND TPR.CODLINEADENEGOCIO = 2
                 AND PRD.CODTIPOPRODUCTO = CASE
                       WHEN @p_CODTIPOPRODUCTO = -1 THEN
                        PRD.CODTIPOPRODUCTO
                       ELSE
                        @p_CODTIPOPRODUCTO
                     END
                 AND PRF.CODPRODUCTO = CASE
                       WHEN @pg_PRODUCTO = '-1' THEN
                        PRF.CODPRODUCTO
                       ELSE
                        WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     END
               GROUP BY AST.ID_ALIADOESTRATEGICO,
                        AST.NOMALIADOESTRATEGICO,
                        RCM.ID_RANGOCOMISION,
                        RCM.CODTIPOCOMISION,
                        RCD.VALORPORCENTUAL,
                        RCD.VALORTRANSACCIONAL
               ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;

          END ELSE
              SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                     SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                     SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                     SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                     CASE
                       WHEN RCM.CODTIPOCOMISION = 1 THEN
                        ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                       WHEN RCM.CODTIPOCOMISION = 2 THEN
                        '$' + ISNULL((RCD.VALORTRANSACCIONAL * (1 + (MAX(PTG.VALOR) / 100))), '')
                       ELSE
                        ''
                     END AS COMISIONGFH,
                     SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                     ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                     SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
                  ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
                  ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.RANGOCOMISION RCM
                  ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
                  ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTG.CODTARIFAVALOR = 2)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
                  ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTE.CODTARIFAVALOR = 3)
               INNER JOIN (SELECT CODRANGOCOMISION,
                                  MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                                  MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                            GROUP BY CODRANGOCOMISION) RCD
                  ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
               WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
                 AND TPR.CODLINEADENEGOCIO = 2
                 AND PRD.CODTIPOPRODUCTO = CASE
                       WHEN @p_CODTIPOPRODUCTO = -1 THEN
                        PRD.CODTIPOPRODUCTO
                       ELSE
                        @p_CODTIPOPRODUCTO
                     END
                 AND PRF.CODPRODUCTO = CASE
                       WHEN @pg_PRODUCTO = '-1' THEN
                        PRF.CODPRODUCTO
                       ELSE
                        WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     END
               GROUP BY AST.ID_ALIADOESTRATEGICO,
                        AST.NOMALIADOESTRATEGICO,
                        RCM.ID_RANGOCOMISION,
                        RCM.CODTIPOCOMISION,
                        RCD.VALORPORCENTUAL,
                        RCD.VALORTRANSACCIONAL
               ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;

        

      END ELSE
          SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                 SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                 SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                 SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                 CASE
                   WHEN RCM.CODTIPOCOMISION = 1 THEN
                    ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                   WHEN RCM.CODTIPOCOMISION = 2 THEN
                    '$' +
                    ISNULL((RCD.VALORTRANSACCIONAL * (1 + (MAX(PTG.VALOR) / 100))), '')
                   ELSE
                    ''
                 END AS COMISIONGFH,
                 SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                 ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                 SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
              ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
              ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.RANGOCOMISION RCM
              ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
              ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTG.CODTARIFAVALOR = 2)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
              ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTE.CODTARIFAVALOR = 3)
           INNER JOIN (SELECT CODRANGOCOMISION,
                              MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                              MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                         FROM WSXML_SFG.RANGOCOMISIONDETALLE
                        GROUP BY CODRANGOCOMISION) RCD
              ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
           WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
             AND TPR.CODLINEADENEGOCIO = 2
             AND PRD.CODTIPOPRODUCTO = CASE
                   WHEN @p_CODTIPOPRODUCTO = -1 THEN
                    PRD.CODTIPOPRODUCTO
                   ELSE
                    @p_CODTIPOPRODUCTO
                 END
             AND PRF.CODPRODUCTO = CASE
                   WHEN @pg_PRODUCTO = '-1' THEN
                    PRF.CODPRODUCTO
                   ELSE
                    WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                 END
           GROUP BY AST.ID_ALIADOESTRATEGICO,
                    AST.NOMALIADOESTRATEGICO,
                    RCM.ID_RANGOCOMISION,
                    RCM.CODTIPOCOMISION,
                    RCD.VALORPORCENTUAL,
                    RCD.VALORTRANSACCIONAL
           ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;

   

  END; 
GO

 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommisionFacturas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommisionFacturas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFiduciaryCommisionFacturas(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                          @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                          @pg_PRODUCTO              NVARCHAR(2000),
                                          @pg_REDPDV                NVARCHAR(2000),
                                         @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
    IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '01-03-2012'
          SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                 SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                 SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                 SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                 CASE
                   WHEN RCM.CODTIPOCOMISION = 1 THEN
                    ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                   WHEN RCM.CODTIPOCOMISION = 2 THEN
                    '$' + ISNULL((RCD.VALORTRANSACCIONAL * (1 + (MAX(PTG.VALOR) / 100))), '')
                   ELSE
                    ''
                 END AS COMISIONGFH,
                 SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                 ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                 SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
              ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
              ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.RANGOCOMISION RCM
              ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
              ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTG.CODTARIFAVALOR = 2)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
              ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTE.CODTARIFAVALOR = 3)
           INNER JOIN (SELECT CODRANGOCOMISION,
                              MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                              MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                         FROM WSXML_SFG.RANGOCOMISIONDETALLE
                        GROUP BY CODRANGOCOMISION) RCD
              ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
           WHERE PRF.FECHAARCHIVO BETWEEN
                 CONVERT(DATETIME, '26/02/2012', 103) AND
                 CONVERT(DATETIME, '29/02/2012', 103)
             AND TPR.CODLINEADENEGOCIO IN (3, 4)
             AND PRD.CODTIPOPRODUCTO = CASE
                   WHEN @p_CODTIPOPRODUCTO = -1 THEN
                    PRD.CODTIPOPRODUCTO
                   ELSE
                    @p_CODTIPOPRODUCTO
                 END
             AND PRF.CODPRODUCTO = CASE
                   WHEN @pg_PRODUCTO = '-1' THEN
                    PRF.CODPRODUCTO
                   ELSE
                    WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                 END
           GROUP BY AST.ID_ALIADOESTRATEGICO,
                    AST.NOMALIADOESTRATEGICO,
                    RCM.ID_RANGOCOMISION,
                    RCM.CODTIPOCOMISION,
                    RCD.VALORPORCENTUAL,
                    RCD.VALORTRANSACCIONAL
           ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;

    ELSE IF  FORMAT(GETDATE(), 'dd-MM-yyyy') =  '04-03-2012' BEGIN
        IF FORMAT(GETDATE(), 'HH24') > 12

              SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                     SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                     SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                     SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                     CASE
                       WHEN RCM.CODTIPOCOMISION = 1 THEN
                        ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                       WHEN RCM.CODTIPOCOMISION = 2 THEN
                        '$' + ISNULL((RCD.VALORTRANSACCIONAL *
                        (1 + (MAX(PTG.VALOR) / 100))), '')
                       ELSE
                        ''
                     END AS COMISIONGFH,
                     SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                     ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                     SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
                  ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
                  ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.RANGOCOMISION RCM
                  ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
                  ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTG.CODTARIFAVALOR = 2)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
                  ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTE.CODTARIFAVALOR = 3)
               INNER JOIN (SELECT CODRANGOCOMISION,
                                  MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                                  MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                            GROUP BY CODRANGOCOMISION) RCD
                  ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
               WHERE PRF.FECHAARCHIVO BETWEEN
                     CONVERT(DATETIME, '01/03/2012', 103) AND
                     CONVERT(DATETIME, '03/03/2012', 103)
                 AND TPR.CODLINEADENEGOCIO IN (3, 4)
                 AND PRD.CODTIPOPRODUCTO = CASE
                       WHEN @p_CODTIPOPRODUCTO = -1 THEN
                        PRD.CODTIPOPRODUCTO
                       ELSE
                        @p_CODTIPOPRODUCTO
                     END
                 AND PRF.CODPRODUCTO = CASE
                       WHEN @pg_PRODUCTO = '-1' THEN
                        PRF.CODPRODUCTO
                       ELSE
                        WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     END
               GROUP BY AST.ID_ALIADOESTRATEGICO,
                        AST.NOMALIADOESTRATEGICO,
                        RCM.ID_RANGOCOMISION,
                        RCM.CODTIPOCOMISION,
                        RCD.VALORPORCENTUAL,
                        RCD.VALORTRANSACCIONAL
               ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;

        ELSE
              SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                     SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                     SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                     SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                     CASE
                       WHEN RCM.CODTIPOCOMISION = 1 THEN
                        ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                       WHEN RCM.CODTIPOCOMISION = 2 THEN
                        '$' + ISNULL((RCD.VALORTRANSACCIONAL * (1 + (MAX(PTG.VALOR) / 100))), '')
                       ELSE
                        ''
                     END AS COMISIONGFH,
                     SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                     ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                     SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
                  ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
                  ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
               INNER JOIN WSXML_SFG.RANGOCOMISION RCM
                  ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
                  ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTG.CODTARIFAVALOR = 2)
               INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
                  ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                     PTE.CODTARIFAVALOR = 3)
               INNER JOIN (SELECT CODRANGOCOMISION,
                                  MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                                  MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                            GROUP BY CODRANGOCOMISION) RCD
                  ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
               WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
                 AND TPR.CODLINEADENEGOCIO IN (3, 4)
                 AND PRD.CODTIPOPRODUCTO = CASE
                       WHEN @p_CODTIPOPRODUCTO = -1 THEN
                        PRD.CODTIPOPRODUCTO
                       ELSE
                        @p_CODTIPOPRODUCTO
                     END
                 AND PRF.CODPRODUCTO = CASE
                       WHEN @pg_PRODUCTO = '-1' THEN
                        PRF.CODPRODUCTO
                       ELSE
                        WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                     END
               GROUP BY AST.ID_ALIADOESTRATEGICO,
                        AST.NOMALIADOESTRATEGICO,
                        RCM.ID_RANGOCOMISION,
                        RCM.CODTIPOCOMISION,
                        RCD.VALORPORCENTUAL,
                        RCD.VALORTRANSACCIONAL
               ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;



     END ELSE
          SELECT AST.NOMALIADOESTRATEGICO AS ALIADOESTRATEGICO,
                 SUM(PRF.NUMNAINGRESOS - PRF.NUMNAANULACIONES) AS CANTIDAD,
                 SUM(PRF.NAINGRESOS - PRF.NAANULACIONES) AS VENTAS,
                 SUM(PRF.INGRESOSNABRUTOS) AS VENTASBRUTAS,
                 CASE
                   WHEN RCM.CODTIPOCOMISION = 1 THEN
                    ISNULL((RCD.VALORPORCENTUAL * (1 + (MAX(PTG.VALOR) / 100))), '') + '%'
                   WHEN RCM.CODTIPOCOMISION = 2 THEN
                    '$' +
                    ISNULL((RCD.VALORTRANSACCIONAL * (1 + (MAX(PTG.VALOR) / 100))), '')
                   ELSE
                    ''
                 END AS COMISIONGFH,
                 SUM(PRF.COSTONAIC) AS VALORCOMISIONGFH,
                 ISNULL(MAX(PTE.VALOR), '') + '%' AS COMISIONFIDUCIA,
                 SUM(PRF.COSTONAETESA) AS VALORCOMISIONFIDUCIA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRD.ID_PRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AST
              ON (PRD.CODALIADOESTRATEGICO = AST.ID_ALIADOESTRATEGICO)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
              ON (PCT.CODPRODUCTO = PRF.CODPRODUCTO)
           INNER JOIN WSXML_SFG.RANGOCOMISION RCM
              ON (RCM.ID_RANGOCOMISION = PCT.CODRANGOCOMISIONESTANDAR)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTG
              ON (PTG.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTG.CODTARIFAVALOR = 2)
           INNER JOIN WSXML_SFG.PRODUCTOCONTRATOTARIFA PTE
              ON (PTE.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND
                 PTE.CODTARIFAVALOR = 3)
           INNER JOIN (SELECT CODRANGOCOMISION,
                              MIN(VALORPORCENTUAL) AS VALORPORCENTUAL,
                              MIN(VALORTRANSACCIONAL) AS VALORTRANSACCIONAL
                         FROM WSXML_SFG.RANGOCOMISIONDETALLE
                        GROUP BY CODRANGOCOMISION) RCD
              ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION)
           WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
             AND TPR.CODLINEADENEGOCIO IN (3, 4)
             AND PRD.CODTIPOPRODUCTO = CASE
                   WHEN @p_CODTIPOPRODUCTO = -1 THEN
                    PRD.CODTIPOPRODUCTO
                   ELSE
                    @p_CODTIPOPRODUCTO
                 END
             AND PRF.CODPRODUCTO = CASE
                   WHEN @pg_PRODUCTO = '-1' THEN
                    PRF.CODPRODUCTO
                   ELSE
                    WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                 END
           GROUP BY AST.ID_ALIADOESTRATEGICO,
                    AST.NOMALIADOESTRATEGICO,
                    RCM.ID_RANGOCOMISION,
                    RCM.CODTIPOCOMISION,
                    RCD.VALORPORCENTUAL,
                    RCD.VALORTRANSACCIONAL
           ORDER BY AST.NOMALIADOESTRATEGICO, RCM.ID_RANGOCOMISION;


  END;
GO

   IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetGamesFiduciaryBilling', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetGamesFiduciaryBilling;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetGamesFiduciaryBilling(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                     @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                     @pg_PRODUCTO              NVARCHAR(2000),
                                     @pg_REDPDV                NVARCHAR(2000),
                                    @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
    IF  FORMAT(GETDATE(), 'dd-MM-yyyy') = '01-03-2012'
          SELECT SUM(CASE
                       WHEN PRD.CODTIPOPRODUCTO = 3 THEN
                        PRF.COSTONAETESA
                       ELSE
                        0
                     END) AS LOTERIAS,
                 SUM(CASE
                       WHEN PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                        PRF.COSTONAETESA
                       ELSE
                        0
                     END) AS PAGATODO,
                 SUM(CASE
                       WHEN PRD.CODTIPOPRODUCTO = 3 OR PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                        PRF.COSTONAETESA
                       ELSE
                        0
                     END) AS TOTALFACTURA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN
                 CONVERT(DATETIME, '26/02/2012') AND
                 CONVERT(DATETIME, '29/02/2012')
             AND PRF.TIPOARCHIVO = 2
             AND TPR.CODLINEADENEGOCIO = 1;

    ELSE IF  FORMAT(GETDATE(), 'dd-MM-yyyy') = '04-03-2012' BEGIN
        IF FORMAT(GETDATE(), 'HH') > 12

              SELECT SUM(CASE
                           WHEN PRD.CODTIPOPRODUCTO = 3 THEN
                            PRF.COSTONAETESA
                           ELSE
                            0
                         END) AS LOTERIAS,
                     SUM(CASE
                           WHEN PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                            PRF.COSTONAETESA
                           ELSE
                            0
                         END) AS PAGATODO,
                     SUM(CASE
                           WHEN PRD.CODTIPOPRODUCTO = 3 OR
                                PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                            PRF.COSTONAETESA
                           ELSE
                            0
                         END) AS TOTALFACTURA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               WHERE PRF.FECHAARCHIVO BETWEEN
                     CONVERT(DATETIME, '01/03/2012') AND
                     CONVERT(DATETIME, '03/03/2012')
                 AND PRF.TIPOARCHIVO = 2
                 AND TPR.CODLINEADENEGOCIO = 1;

         ELSE
              SELECT SUM(CASE
                           WHEN PRD.CODTIPOPRODUCTO = 3 THEN
                            PRF.COSTONAETESA
                           ELSE
                            0
                         END) AS LOTERIAS,
                     SUM(CASE
                           WHEN PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                            PRF.COSTONAETESA
                           ELSE
                            0
                         END) AS PAGATODO,
                     SUM(CASE
                           WHEN PRD.CODTIPOPRODUCTO = 3 OR PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                            PRF.COSTONAETESA
                           ELSE
                            0
                         END) AS TOTALFACTURA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
                 AND PRF.TIPOARCHIVO = 2
                 AND TPR.CODLINEADENEGOCIO = 1;



     END ELSE
          SELECT SUM(CASE
                       WHEN PRD.CODTIPOPRODUCTO = 3 THEN
                        PRF.COSTONAETESA
                       ELSE
                        0
                     END) AS LOTERIAS,
                 SUM(CASE
                       WHEN PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                        PRF.COSTONAETESA
                       ELSE
                        0
                     END) AS PAGATODO,
                 SUM(CASE
                       WHEN PRD.CODTIPOPRODUCTO = 3 OR
                            PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(10003) THEN
                        PRF.COSTONAETESA
                       ELSE
                        0
                     END) AS TOTALFACTURA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
             AND PRF.TIPOARCHIVO = 2
             AND TPR.CODLINEADENEGOCIO = 1;



  END; 

GO

IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetBPFiduciaryBilling', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetBPFiduciaryBilling;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetBPFiduciaryBilling(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                  @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                  @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                  @pg_PRODUCTO              NVARCHAR(2000),
                                  @pg_REDPDV                NVARCHAR(2000),
                                 @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;

    IF FORMAT(GETDATE(), 'dd-MM-yyyy')= '01-03-2012'
          SELECT SUM(PRF.COSTONAETESA) AS TOTALFACTURA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           WHERE PRF.FECHAARCHIVO BETWEEN
                 CONVERT(DATETIME, '26/02/2012', 103) AND
                 CONVERT(DATETIME, '29/02/2012', 103)
             AND PRF.TIPOARCHIVO = 1
             AND TPR.CODLINEADENEGOCIO IN (3, 4);

    ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy')= '04-03-2012' BEGIN
        IF FORMAT(GETDATE(), 'HH') > 12
              SELECT SUM(PRF.COSTONAETESA) AS TOTALFACTURA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               WHERE PRF.FECHAARCHIVO BETWEEN
                     CONVERT(DATETIME, '01/03/2012') AND
                     CONVERT(DATETIME, '03/03/2012')
                 AND PRF.TIPOARCHIVO = 1
                 AND TPR.CODLINEADENEGOCIO IN (3, 4);

        ELSE
              SELECT SUM(PRF.COSTONAETESA) AS TOTALFACTURA
                FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
               INNER JOIN WSXML_SFG.PRODUCTO PRD
                  ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
               INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                  ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
               WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
                 AND PRF.TIPOARCHIVO = 1
                 AND TPR.CODLINEADENEGOCIO IN (3, 4);


     END ELSE
          SELECT SUM(PRF.COSTONAETESA) AS TOTALFACTURA
            FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
           INNER JOIN WSXML_SFG.PRODUCTO PRD
              ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
           INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
              ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
           WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
             AND PRF.TIPOARCHIVO = 1
             AND TPR.CODLINEADENEGOCIO IN (3, 4);



  END
  GO


IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetETUFiduciaryBilling', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetETUFiduciaryBilling;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetETUFiduciaryBilling(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                   @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                   @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                   @pg_PRODUCTO              NVARCHAR(2000),
                                   @pg_REDPDV                NVARCHAR(2000),
                                  @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT SUM(PRF.COSTONAETESA) AS TOTALFACTURA
        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
       INNER JOIN WSXML_SFG.PRODUCTO PRD
          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
       WHERE PRF.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
         AND PRF.TIPOARCHIVO = 1
         AND TPR.CODLINEADENEGOCIO = 2;

  END; 
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFondoPremioVentasAvanzadas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFondoPremioVentasAvanzadas;
GO


   CREATE PROCEDURE  WSXML_SFG.SFGINF_CARTASFIDUCIA_GetFondoPremioVentasAvanzadas(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                 @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                 @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                 @pg_PRODUCTO              NVARCHAR(2000),
                                 @pg_REDPDV                NVARCHAR(2000),
                                 @pg_CADENA                NVARCHAR(2000)) AS
 BEGIN


     DECLARE @p_Fecha DATETIME;
     DECLARE @P_FECHA_V DATETIME;
     DECLARE @P_FECHAINICIO DATETIME;
     DECLARE @P_FECHAFIN DATETIME;
     DECLARE @p_ADICIONES NUMERIC(22,0);
     DECLARE @P_RETIROS NUMERIC(22,0);
     DECLARE @P_SALDOINICIAL NUMERIC(22,0);
     DECLARE @P_SALDOFINAL NUMERIC(22,0);
     DECLARE @P_FECHASALDO DATETIME;
       DECLARE @l_count INTEGER;

   
  SET NOCOUNT ON;

        /*Cambiar para carta de avanzadas*/
        select @p_Fecha = fechaejecucion
          from WSXML_SFG.ciclofacturacionpdv
         where id_ciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV;

        SET @P_FECHA_V     = @p_Fecha - 7;
        SET @P_FECHAINICIO = @P_FECHA_V -
                         (DATEPART(WEEKDAY,@P_FECHA_V)) + 1;
        SET @P_FECHAFIN    = @P_FECHAINICIO + 6;

       --Adiciones
        SELECT @p_ADICIONES = ROUND(sum((ADVV.VENTA*WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))
        / WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0)
             FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
            INNER JOIN ENTRADAARCHIVOCONTROL
               ON ADVV.FECHAARCHIVO =
                  ENTRADAARCHIVOCONTROL.FECHAARCHIVO
              AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
              AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
            WHERE ADVV.ACTIVE = 1 and id_producto = @pg_PRODUCTO
              and ADVV.fechaarchivo in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV)
                     and ADVV.fecha not in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV);

                --Retiros
        SELECT @P_RETIROS = ROUND(sum((VENTA*WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))
        /WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0) 
             FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
            INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
               ON ADVV.FECHAARCHIVO =
                  ENTRADAARCHIVOCONTROL.FECHAARCHIVO
              AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
              AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
            WHERE ADVV.ACTIVE = 1 and id_producto = @pg_PRODUCTO
              and ADVV.fecha in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV)
                     and ADVV.fechaarchivo not in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV);



       SELECT @l_count = COUNT(*) from WSXML_SFG.SaldosAvanzadas
         where CODPRODUCTO = @pg_PRODUCTO
         and fecha = @P_FECHAFIN --AND 
		 --order by Id_Saldosavanzadas desc;
       IF @l_count = 0 BEGIN
                  select  @P_SALDOINICIAL = saldofinal, @P_FECHASALDO = fecha
                 from(
                  select saldofinal, fecha
				  from WSXML_SFG.SaldosAvanzadas
				 where CODPRODUCTO = @pg_PRODUCTO
				 --order by Id_Saldosavanzadas desc
				 ) s;
        SET @P_SALDOFINAL = (@P_SALDOINICIAL + @p_ADICIONES) - @P_RETIROS;
        EXEC WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas @P_SALDOINICIAL,
                                                       @p_ADICIONES,
                                                       @P_RETIROS,
                                                       @P_SALDOFINAL,
                                                       @p_Fecha,
                                                       @pg_PRODUCTO
       end
       else begin
               select  @P_SALDOINICIAL = saldofinal, @P_FECHASALDO = fecha
                 from(
                  select saldofinal, fecha
         from WSXML_SFG.SaldosAvanzadas
         where CODPRODUCTO = @pg_PRODUCTO
         and fecha = @P_FECHAFIN --order by Id_Saldosavanzadas desc
		 ) s;
        SET @P_SALDOFINAL = (@P_SALDOINICIAL + @p_ADICIONES) - @P_RETIROS;
        EXEC WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas  @P_SALDOINICIAL,
                                                       @p_ADICIONES,
                                                       @P_RETIROS,
                                                       @P_SALDOFINAL,
                                                       @p_Fecha,
                                                       @pg_PRODUCTO
       end 



          select @P_SALDOINICIAL as SaldoInicial,
                 @P_RETIROS      as Retiros,
                 @p_ADICIONES    as Adiones,
                 @P_SALDOFINAL   as SaldoFinal
           ;
      --'GetWeeklySalesDetail
  END
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_ValidarArchivos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_ValidarArchivos;
GO


create PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_ValidarArchivos(@pCODCICLODEFACTURACION NUMERIC(22,0), @pNOMBREARCHIVO NVARCHAR(2000)) as
 begin
          declare @DIAS DATETIME;
          declare @ARCHIVOS NUMERIC(22,0);
          declare @diasemana NUMERIC(22,0);
          
	declare @msg VARCHAR(2000)
  set nocount on;
         
          
          --Valida la existencia de todos los archivos 
          --Valida archivos l1liab
          IF UPPER(@pNOMBREARCHIVO) like '%LIAB%' 
            BEGIN
          --Recorre cursor fecha archivo
          declare fechas cursor for select CONVERT(DATETIME,CONVERT(DATE,e.fechaarchivo)) as fecha
                          from WSXML_SFG.entradaarchivocontrol e 
                          where e.codciclofacturacionpdv = @pCODCICLODEFACTURACION; 
              open fechas;
			  DECLARE @fechas__fecha datetime
              fetch next from fechas into @fechas__fecha;
              while @@fetch_status=0
              begin
              begin
				
					  select l.cdc
					  from WSXML_SFG.control_l1liab01 l 
					  order by 1;
				 if @@ROWCOUNT = 0 begin
					SET @msg = '-20054 El archivo L1Liab del dia  ' +
											  isnull(@fechas__fecha, '') +
											  ', No se encuentra cargado en la base de datos '
					  RAISERROR(@msg, 16, 1);
				end
              END;
            fetch next from fechas into @fechas__fecha;
            end;
            close fechas;
            deallocate fechas;
            end 
            --Valida archivos ventas avanzadas
           
          
           end
go
           


IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalVentas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalVentas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalVentas(@pCodCicloFacturacionpdv NUMERIC(22,0),
                                  @PCODPRODUCTO NUMERIC(22,0)) as 

    begin
    set nocount on; 
        select r.codproducto,
        case when r.codtiporegistro in (1,3) then round(sum(r.Valortransaccion), 0) -
         round(sum(ISNULL(r.Valordescuentos, 0)), 0)  else 0 end as VENTASTOTALES,
        case when r.codtiporegistro in (1,3) then ROUND(SUM(r.valorventabruta), 0) else 0 end as VENTASBRUTAS,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'), 0) AS DERECHOSEXPLOTACION,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'), 0) AS GASTOSADMON,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Baloto'), 0) AS DESCUENTOENVENTAS,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'), 0) AS GASTOSOPERACION,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'), 0) AS GASTOSMERCADEO,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'), 0) AS PREMIOS
        from WSXML_SFG.registrofacturacion r
        inner join WSXML_SFG.entradaarchivocontrol on id_entradaarchivocontrol = codentradaarchivocontrol
        where codciclofacturacionpdv = @pCodCicloFacturacionpdv 
        and codproducto = @PCODPRODUCTO and codtiporegistro in (1,3)
        group by r.codproducto, r.codtiporegistro;        
    end;
GO
    


IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalTransferencias', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalTransferencias;
GO

     CREATE PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalTransferencias(@pCodCicloFacturacionpdv NUMERIC(22,0),
                                            @PCODPRODUCTO VARCHAR(4000)) as 
    
    begin
    set nocount on; 
    
        select distinct  --case when r.codtiporegistro in (1, 3) then  SUM(r.valorventabruta) else 0 end,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'), 0) AS "DerechosdeExplotacion",
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'), 0) AS "GastosdeAdministracion",
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'), 0) AS "GastosdeOperacion",
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'), 0) AS "GastosdePublicidad",
        round(premiosbalrev.PremiosBaloto, 2) as "PrimerPremioTipoBaloto",
        round(isnull(TOTALPREMIOSPAGOS.premiosMAYORES, 0), 2)  as PremiosMayores, 
       round(isnull(TOTALPREMIOSPAGOS.premiosintermedios, 0), 2)  as PremiosIntermedios, 
        isnull(TOTALPREMIOSPAGOS.PremiosMenores, 0)  as PremiosMenores, 
        round(fondoreserva.fondoreserva, 2)  as FondoreservaBaloto, 
         0 as ReservaPremiosMultiplicador, 
       isnull(ROUND(sum((Avanzadas.VENTAS*WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))
          / WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0), 0) as PagoPremiosAvanzadas
                   
        from WSXML_SFG.registrofacturacion r
        inner join entradaarchivocontrol e on id_entradaarchivocontrol = codentradaarchivocontrol
        inner join (select sum(premios.PremiosBaloto) as PremiosBaloto, premios.codproducto
                    from(select round(dl.pozo_premios, 0) as PremiosBaloto,  p.codproducto                  
                      from WSXML_SFG.control_l1shrclc cl 
                      inner join WSXML_SFG.producto_l1shrclc p on p.codcontrol_l1shrclc = cl.id_control_l1shrclc
                      inner join WSXML_SFG.detalle_l1shrclc dl on dl.codproducto_l1shrclc = P.ID_PRODUCTO_L1SHRCLC
                      inner join WSXML_SFG.entradaarchivocontrol ec on ec.fechaarchivo = cl.fechahorageneracionarchivo
                      where ec.codciclofacturacionpdv = @pCodCicloFacturacionpdv and dl.codcategoriasorteos = 1 and p.codproducto = @PCODPRODUCTO
                     group by dl.pozo_premios, p.codproducto) premios
                     group by premios.codproducto
                    ) premiosbalrev on premiosbalrev.codproducto = r.codproducto
                    
        inner join (select sum(fondo.fondoreserva) as fondoreserva, fondo.codproducto from (
                   select round(p.fondo_de_reserva, 0) as fondoreserva, p.codproducto
                                from WSXML_SFG.control_l1shrclc cl 
                                right outer join WSXML_SFG.producto_l1shrclc p on p.codcontrol_l1shrclc = cl.id_control_l1shrclc
                                right join WSXML_SFG.detalle_l1shrclc dl on dl.codproducto_l1shrclc = P.ID_PRODUCTO_L1SHRCLC
                                right join WSXML_SFG.entradaarchivocontrol ec on ec.fechaarchivo = cl.fechahorageneracionarchivo
                                where ec.codciclofacturacionpdv = @pCodCicloFacturacionpdv and p.codproducto = @PCODPRODUCTO
                    group by  p.codproducto, p.fondo_de_reserva) fondo
                    group by fondo.codproducto --, codcategoriasorteos  , dl.pozo_premios     
                    ) fondoreserva on fondoreserva.codproducto = r.codproducto
                    
         right outer join (
         select codproducto, sum(premiosmayores) as PremiosMayores, sum(pagosintermedios) as PremiosIntermedios, sum(premiosmenores) as PremiosMenores
         from(
			select distinct  premioporcategoria.fechaarchivo, premioporcategoria.codproducto,
                round(premioporcategoria.totalpremios, 0) AS totalpremios , round(premioporcategoria.totalganadores, 0) AS totalganadores, 
                
                case when  (case when round(premioporcategoria.totalganadores, 0) > 0 then 
                round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) > = 
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMaximoPagoPremios') * 
                WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT')) 
                then case when premioporcategoria.totalpremios > 0 then round(sum(premioporcategoria.totalpremios), 0) else 0 end else 0 end as premiosmayores, 
                  
                  case when (case when round(premioporcategoria.totalganadores, 0) > 0 then 
                  round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0) else 0 end) >=
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMinimoPagoPremios') * WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT'))
                and (case when round(premioporcategoria.totalganadores, 0) > 0 then 
                  round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) <
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMaximoPagoPremios') * wsxml_sfg.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT'))
                 
                then case when premioporcategoria.totalganadores > 0 then round(premioporcategoria.totalpremios, 0)  else 0 end else 0 end as pagosintermedios,
                  
                  
                case when (case when round(premioporcategoria.totalganadores, 0) >0 then 
                  round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) <
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMinimoPagoPremios') * WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT')) 
                then case when premioporcategoria.totalganadores > 0 then round(premioporcategoria.totalpremios, 0)  else 0 end else 0 end as premiosmenores
                
                
                  from (
                  select distinct 
                    case when d.codcategoriasorteos is not null then d.pozo_pagos else 0 end as totalpremios, 
                    case when d.codcategoriasorteos is not null then d.ganadoras else 0 end  as totalganadores, 
                    case when d.codcategoriasorteos is not null then d.codcategoriasorteos else 0 end as categoria, 

                    p.codproducto, ec.fechaarchivo
                    from WSXML_SFG.detalle_l1shrclc d
                    inner join WSXML_SFG.producto_l1shrclc p on p.id_producto_l1shrclc  = d.codproducto_l1shrclc
                    inner join WSXML_SFG.control_l1shrclc c on c.id_control_l1shrclc = p.codcontrol_l1shrclc
                    inner join WSXML_SFG.entradaarchivocontrol ec on ec.fechaarchivo = c.fechahorageneracionarchivo
                    where codciclofacturacionpdv = @pCodCicloFacturacionpdv and p.codproducto = @PCODPRODUCTO
                   group by p.codproducto, d.codcategoriasorteos, d.pozo_pagos, d.ganadoras, d.codcategoriasorteos, ec.fechaarchivo
                    --order by 3 desc
					) premioporcategoria
                    group by premioporcategoria.totalganadores, premioporcategoria.totalpremios, 
                    premioporcategoria.fechaarchivo, premioporcategoria.codproducto) TOTALPREMIOSPAGOS 
                    group by codproducto) TOTALPREMIOSPAGOS ON 
                    TOTALPREMIOSPAGOS.codproducto = r.codproducto
        left outer join (SELECT ADVV.ID_PRODUCTO,
                                      SUM(ADVV.VENTA) AS VENTAS
                                 FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
                                INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
                                   ON ADVV.FECHAARCHIVO =
                                      ENTRADAARCHIVOCONTROL.FECHAARCHIVO
                                  AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
                                  AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
                                WHERE ADVV.ACTIVE = 1 and advv.id_producto = @PCODPRODUCTO
                                  and ADVV.fechaarchivo in
                                      (select (FECHAARCHIVO)
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @pCodCicloFacturacionpdv)
                                         and ADVV.fecha not in
                                      (select (FECHAARCHIVO)
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @pCodCicloFacturacionpdv)
                                GROUP BY ID_PRODUCTO) Avanzadas on Avanzadas.id_producto = r.codproducto
        where codciclofacturacionpdv = @pCodCicloFacturacionpdv   and r.codproducto = @PCODPRODUCTO and codtiporegistro in (1,3)
        group by     TOTALPREMIOSPAGOS.premiosmayores, premiosbalrev.PremiosBaloto, fondoreserva.fondoreserva,
        TOTALPREMIOSPAGOS.premiosintermedios, TOTALPREMIOSPAGOS.premiosmenores; 
         
        
    end;
GO


IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetCategoriasSorteos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetCategoriasSorteos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetCategoriasSorteos as 
  begin
  set nocount on;
           select NOMBRECATEGORIA 
           from WSXML_SFG.categoriasorteo 
           order by division ;
    
    end;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetListProductosL1shrclc', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetListProductosL1shrclc;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetListProductosL1shrclc as 
  begin
  set nocount on;
           select distinct p.codproducto, p.nomproducto
           from WSXML_SFG.producto_l1shrclc p  
           order by 1 ;
    
    end;
   GO

IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_PremiosVencidosporperiodos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_PremiosVencidosporperiodos;
GO



    create PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_PremiosVencidosporperiodos(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                  @PCODPRODUCTO NUMERIC(22,0),
                                  @pDiasVencimiento NUMERIC(22,0),
                                  @pcur varchar(8000)  OUTPUT) as
 begin
     declare @v_sql VARCHAR(MAX);
     declare @v_nomcategoria VARCHAR(MAX);
     declare @V_SORTEO1_VENCIDO     NUMERIC(22,0) = 0;
     declare @V_SORTEO2_VENCIDO     NUMERIC(22,0) = 0;
  
 set nocount on;
   --Lista categorias de sorteos 


			SELECT @v_nomcategoria =  STUFF(( 
						SELECT  ','+ '''' + ISNULL(NOMBRECATEGORIA, '') + '''' 
						FROM WSXML_SFG.categoriasorteo a
						WHERE b.ID_CATEGORIASORTEO = a.ID_CATEGORIASORTEO FOR XML PATH('')
						),1 ,1, '')

			FROM WSXML_SFG.categoriasorteo b
			ORDER BY DIVISION, ID_CATEGORIASORTEO


          
    --Consulta sorteos de consultas 
    SELECT @V_SORTEO1_VENCIDO = isnull(MIN(P1.SORTEO), 0)
      FROM (SELECT SR.*,
                   EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                   ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
              FROM (SELECT P.CODPRODUCTO,
                           L1.SORTEO,
                           L1.FECHASORTEO,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                      FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                     WHERE L1.ACTIVE = 1
                       AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC2
             WHERE EAC.ACTIVE = 1
               AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
               AND EAC.TIPOARCHIVO = 2
               AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
               AND EAC2.TIPOARCHIVO= 2
               AND EAC2.ACTIVE = 1
               AND EAC2.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV) P1;

    SELECT @V_SORTEO2_VENCIDO = isnull(MAX(P2.SORTEO), 0)
      FROM (SELECT SR.*,
                   EAC.CODCICLOFACTURACIONPDV AS CICLO_DOS_MESES,
                   ISNULL(EAC2.CODCICLOFACTURACIONPDV, 0) AS CICLO_UN_ANO
              FROM (SELECT P.CODPRODUCTO,
                           L1.SORTEO,
                           L1.FECHASORTEO,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosDosMeses') as VENC_DOS_MESES,
                           CONVERT(DATETIME,L1.FECHASORTEO) +
                           WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('PremiosVencidosUnAno') as VENC_UN_ANO
                      FROM WSXML_SFG.CONTROL_L1SHRCLC L1, WSXML_SFG.PRODUCTO_L1SHRCLC P
                     WHERE L1.ACTIVE = 1
                       AND L1.ID_CONTROL_L1SHRCLC = P.CODCONTROL_L1SHRCLC) SR,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC,
                   WSXML_SFG.ENTRADAARCHIVOCONTROL EAC2
             WHERE EAC.ACTIVE = 1
               AND SR.VENC_DOS_MESES = EAC.FECHAARCHIVO
               AND EAC.TIPOARCHIVO = 2
               AND SR.VENC_UN_ANO = EAC2.FECHAARCHIVO
               AND EAC2.TIPOARCHIVO = 2
               AND EAC2.ACTIVE = 1
               AND EAC2.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV) P2;
    
          
          
      set @v_sql = '
      select * from (
      select * from (
      select ps.sorteo, 
      case when '+ ISNULL(@pDiasVencimiento, '') +'  
        = SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosDosMeses'') -1  then '
      + ISNULL(@pDiasVencimiento, '') + ' when ' + ISNULL(@pDiasVencimiento, '') + ' = SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosUnAno'') -1 then '
      + ISNULL(@pDiasVencimiento, '') + ' end as diasvencimiento,
        c.nombrecategoria as categoria, 
        case when ' + ISNULL(@pDiasVencimiento, '') + '= SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosDosMeses'') -1 then 
        sum(l.premiospendientesmayor60) 
        when ' + ISNULL(@pDiasVencimiento, '') + ' = SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosUnAno'') -1 then sum(l.premioscaducosmayor365) end
        as premiosexpirados
        from WSXML_SFG.l1liabtotalesporproducto l
        inner join WSXML_SFG.producto p on id_producto = codproducto 
        inner join WSXML_SFG.categoriasorteo c on c.id_categoriasorteo = l.codcategoria
        inner join WSXML_SFG.controlpremiosl1liab cl on cl.id_controlpremiosl1liab = l.codcontroll1liab
        inner join WSXML_SFG.entradaarchivocontrol e on e.fechaarchivo  = cl.fechareporte
        inner join WSXML_SFG.l1liabpremiosporsorteo ps on ps.codl1liabtotalespremios = l.id_l1liabtotalesporproducto
        inner join WSXML_SFG.ciclofacturacionpdv cf on cf.id_ciclofacturacionpdv = e.codciclofacturacionpdv
        where e.codciclofacturacionpdv = ' + isnull(@p_CODCICLOFACTURACIONPDV, '') + '
         and p.id_producto = ' + ISNULL(@PCODPRODUCTO, '') + ' and ps.sorteo between ' + ISNULL(@V_SORTEO1_VENCIDO, '') + ' and ' +  ISNULL(@V_SORTEO2_VENCIDO, '') +'
        group by p.id_producto, c.nombrecategoria, ps.sorteo, cf.fechaejecucion
       -- select * from WSXML_SFG.controlpremiosl1liab for update
      )) T pivot(sum(premiosexpirados) for categoria in (' + isnull(@v_nomcategoria, '') + ')) PIV';
      
      
    
            
            execute (@v_sql);
    end;  
GO
 
    
IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetPremioVentasAvanzadas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetPremioVentasAvanzadas;
GO



    CREATE PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetPremioVentasAvanzadas(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                       @PCODPRODUCTO             NVARCHAR(2000)) AS
 BEGIN


     DECLARE @p_Fecha DATETIME;
     DECLARE @P_FECHA_V DATETIME;
     DECLARE @P_FECHAINICIO DATETIME;
     DECLARE @P_FECHAFIN DATETIME;
     DECLARE @p_ADICIONES NUMERIC(22,0);
     DECLARE @P_RETIROS NUMERIC(22,0);
     DECLARE @P_SALDOINICIAL NUMERIC(22,0);
     DECLARE @P_SALDOFINAL NUMERIC(22,0);
     DECLARE @P_FECHASALDO DATETIME;
       DECLARE @l_count INTEGER;

   
  SET NOCOUNT ON;

        /*Cambiar para carta de avanzadas*/
        select @p_Fecha = fechaejecucion
          from WSXML_SFG.ciclofacturacionpdv
         where id_ciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV;

        SET @P_FECHA_V     = @p_Fecha - 7;
        SET @P_FECHAINICIO = @P_FECHA_V -
                         (DATEPART(WEEKDAY, @P_FECHA_V)) + 1;
        SET @P_FECHAFIN    = @P_FECHAINICIO + 6;

       --Adiciones
        SELECT @p_ADICIONES = isnull(ROUND(sum((ADVV.VENTA*WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))/ WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0), 0)
             FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
            INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
               ON ADVV.FECHAARCHIVO =
                  ENTRADAARCHIVOCONTROL.FECHAARCHIVO
              AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
              AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
            WHERE ADVV.ACTIVE = 1 and id_producto = @PCODPRODUCTO
              and ADVV.fechaarchivo in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV)
                     and ADVV.fecha not in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV);

                --Retiros
        SELECT @P_RETIROS = isnull(ROUND(sum((VENTA*WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))/ WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0), 0) 
             FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
            INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL
               ON ADVV.FECHAARCHIVO =
                  ENTRADAARCHIVOCONTROL.FECHAARCHIVO
              AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
              AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
            WHERE ADVV.ACTIVE = 1 and id_producto = @PCODPRODUCTO
              and ADVV.fecha in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV)
                     and ADVV.fechaarchivo not in
                  (select (FECHAARCHIVO)
                     from WSXML_SFG.ENTRADAARCHIVOCONTROL
                    where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @p_CODCICLOFACTURACIONPDV);



       SELECT @l_count = COUNT(*) 
	   from WSXML_SFG.SaldosAvanzadas
         where CODPRODUCTO = @PCODPRODUCTO
         and fecha = @P_FECHAFIN  
		-- order by Id_Saldosavanzadas desc;
       IF @l_count = 0 BEGIN
                  select  @P_SALDOINICIAL = saldofinal, @P_FECHASALDO = fecha
                 from(
                  select saldofinal, fecha
				  from WSXML_SFG.SaldosAvanzadas
				 where CODPRODUCTO = @PCODPRODUCTO
				 --order by Id_Saldosavanzadas desc
				 ) s;
        SET @P_SALDOFINAL = (@P_SALDOINICIAL + @p_ADICIONES) - @P_RETIROS;
        EXEC WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas @P_SALDOINICIAL,
                                                       @p_ADICIONES,
                                                       @P_RETIROS,
                                                       @P_SALDOFINAL,
                                                       @p_Fecha,
                                                       @PCODPRODUCTO OUT
       end
       else begin
               select  @P_SALDOINICIAL = saldofinal, @P_FECHASALDO = fecha
                 from(
                  select saldofinal, fecha
         from WSXML_SFG.SaldosAvanzadas
         where CODPRODUCTO = @PCODPRODUCTO
         and fecha = @P_FECHAFIN --order by Id_Saldosavanzadas desc
		 ) s;
        SET @P_SALDOFINAL = (@P_SALDOINICIAL + @p_ADICIONES) - @P_RETIROS;
        EXEC WSXML_SFG.SFG_ARCHIVO_L1ADVSAL1_AddRecordSaldosAvanzadas @P_SALDOINICIAL,
                                                       @p_ADICIONES,
                                                       @P_RETIROS,
                                                       @P_SALDOFINAL,
                                                       @p_Fecha,
                                                       @PCODPRODUCTO OUT
       end 



          select @P_SALDOINICIAL as SaldoInicial,
                 @P_RETIROS      as Retiros,
                 @p_ADICIONES    as Adiones,
                 @P_SALDOFINAL   as SaldoFinal
           ;
      --'GetWeeklySalesDetail
  END
  GO
  
 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalVentasxproducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalVentasxproducto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalVentasxproducto(@pCodCicloFacturacionpdv NUMERIC(22,0)) as 
    begin
    set nocount on; 
         select pr.nomproducto as PRODUCTO,
            case when r.codtiporegistro in (1,3) then round(sum(r.valortransaccion), 0) else 0 end as "VENTAS TOTALES",
            case when r.codtiporegistro in (1,3) then ROUND(SUM(r.valorventabruta), 0) else 0 end as "VENTAS BRUTAS",
            ROUND(SUM(r.valorventabruta) * 
            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'), 0) AS "DERECHOS EXPLOTACION",
            ROUND(SUM(r.valorventabruta) * 
            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'), 0) AS "GASTOS ADMON",
            ROUND(SUM(r.valorventabruta) * 
            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DESCUENTOENVENTAS_Baloto'), 0) AS "DESCUENTO EN VENTAS",
            ROUND(SUM(r.valorventabruta) * 
            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'), 0) AS "GASTOS OPERACION",
            ROUND(SUM(r.valorventabruta) * 
            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'), 0) AS "GASTOS MERCADEO",
            ROUND(SUM(r.valorventabruta) * 
            WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'), 0) AS PREMIOS
        from WSXML_SFG.registrofacturacion r
        INNER JOIN WSXML_SFG.PRODUCTO pr on pr.id_producto = r.codproducto
        inner join WSXML_SFG.entradaarchivocontrol on id_entradaarchivocontrol = codentradaarchivocontrol
        where codciclofacturacionpdv = @pCodCicloFacturacionpdv 
        and codtiporegistro in (1,3) and pr.id_producto in (select pls.codproducto from WSXML_SFG.producto_l1shrclc pls )
        group by pr.nomproducto, r.codtiporegistro;          
    end;
 GO
   
    
 IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalTransfexprod', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalTransfexprod;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetAnexosemanalTransfexprod(@pCodCicloFacturacionpdv NUMERIC(22,0)) as 
    
    begin
    set nocount on; 
    
           select 
        pr.nomproducto,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('DERECHOSEXPLOTACION_Baloto'), 0) AS DerechosdeExplotacion,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSADMON_Baloto'), 0) AS GastosdeAdministracion,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSOPERACION_Baloto'), 0) AS GastosdeOperacion,
        ROUND(SUM(r.valorventabruta) * 
        WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('GASTOSMERCADEO_Baloto'), 0) AS GastosdePublicidad,
        sum(premiosbalrev.PremiosBaloto) as PrimerPremioTipoBaloto,
        sum(TOTALPREMIOSPAGOS.pagosMAYORES) as PremiosMayores, 
        sum(TOTALPREMIOSPAGOS.pagosintermedios) as PremiosIntermedios, 
        sum(TOTALPREMIOSPAGOS.pagosmenores) as PremiosMenores, 
        sum(fondoreserva.fondoreserva)  as FondoreservaBaloto, 
         0 as ReservaPremiosMultiplicador, 
       isnull(ROUND(sum((Avanzadas.VENTAS*WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_PORCENTAJES_NUMBER('PREMIOS_Baloto'))
          / WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('IvaVentasAvanzadas')),0), 0) as PagoPremiosAvanzadas
          
          
          
        from WSXML_SFG.registrofacturacion r
        inner join WSXML_SFG.entradaarchivocontrol e on id_entradaarchivocontrol = codentradaarchivocontrol
        inner join WSXML_SFG.producto pr on pr.id_producto = r.codproducto
        inner join (select distinct round(dl.pozo_premios, 0)  as PremiosBaloto,  p.codproducto                  
                    from WSXML_SFG.control_l1shrclc cl 
                    inner join WSXML_SFG.producto_l1shrclc p on p.codcontrol_l1shrclc = cl.id_control_l1shrclc
                    inner join WSXML_SFG.detalle_l1shrclc dl on dl.codproducto_l1shrclc = P.ID_PRODUCTO_L1SHRCLC
                    inner join WSXML_SFG.entradaarchivocontrol ec on ec.fechaarchivo = cl.fechahorageneracionarchivo
                    where ec.codciclofacturacionpdv = @pCodCicloFacturacionpdv and dl.codcategoriasorteos = 1
                    ) premiosbalrev on premiosbalrev.codproducto = r.codproducto
                    
        inner join (select distinct round(p.fondo_de_reserva, 0)as fondoreserva, p.codproducto
                                from WSXML_SFG.control_l1shrclc cl 
                                INNER JOIN WSXML_SFG.PRODUCTO_l1shrclc p on p.codcontrol_l1shrclc = cl.id_control_l1shrclc
                                inner join detalle_l1shrclc dl on dl.codproducto_l1shrclc = P.ID_PRODUCTO_L1SHRCLC
                                inner join entradaarchivocontrol ec on ec.fechaarchivo = cl.fechahorageneracionarchivo
                                where ec.codciclofacturacionpdv = @pCodCicloFacturacionpdv 
                  --  group by  p.codproducto, p.fondo_de_reserva, codcategoriasorteos  , dl.pozo_premios     
                    ) fondoreserva on fondoreserva.codproducto = r.codproducto
                    
         left outer join ( select sum(TOTALPREMIOS.PREMIOSMAYORES) as pagosmayores, sum(TOTALPREMIOS.pagosintermedios) as pagosintermedios,
                          sum(TOTALPREMIOS.PREMIOSMENORES) as pagosmenores, TOTALPREMIOS.fechaarchivo 
                from(
                select premioporcategoria.codproducto, premioporcategoria.fechaarchivo,
                
                case when  (case when round(premioporcategoria.totalganadores, 0) = @pCodCicloFacturacionpdv then 
                round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) > = 
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMaximoPagoPremios') * WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT')) 
                then case when premioporcategoria.totalganadores = @pCodCicloFacturacionpdv then round(premioporcategoria.totalpremios, 0) / 
                  round(premioporcategoria.totalganadores, 0) else 0 end else 0 end as premiosmayores, 
                  
                  case when (case when round(premioporcategoria.totalganadores, 0) = @pCodCicloFacturacionpdv then 
                  round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) >=
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMinimoPagoPremios') * WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT'))
                and (case when round(premioporcategoria.totalganadores, 0) = @pCodCicloFacturacionpdv then 
                  round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) <
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMaximoPagoPremios') * WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT'))
                 
                then case when premioporcategoria.totalganadores = @pCodCicloFacturacionpdv then round(premioporcategoria.totalpremios, 0) / 
                round(premioporcategoria.totalganadores, 0) else 0 end else 0 end as pagosintermedios,
                  
                  
                case when (case when round(premioporcategoria.totalganadores, 0) = @pCodCicloFacturacionpdv then 
                  round(premioporcategoria.totalpremios, 0) / round(premioporcategoria.totalganadores, 0)  else 0 end) <
                (WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVTMinimoPagoPremios') * WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER('UVT')) 
                then case when premioporcategoria.totalganadores = @pCodCicloFacturacionpdv then round(premioporcategoria.totalpremios, 0) / 
                round(premioporcategoria.totalganadores, 0) else 0 end else 0 end as premiosmenores
                
                
                  from (
                  select 
                    case when d.codcategoriasorteos is not null then sum(d.pozo_pagos) else 0 end as totalpremios, 
                    case when d.codcategoriasorteos is not null then sum(d.ganadoras) else 0 end  as totalganadores, 
                    case when d.codcategoriasorteos is not null then d.codcategoriasorteos else 0 end as categoria, 
                    p.codproducto, ec.fechaarchivo
                    from WSXML_SFG.detalle_l1shrclc d
                    INNER JOIN WSXML_SFG.PRODUCTO_l1shrclc p on p.id_producto_l1shrclc  = d.codproducto_l1shrclc
                    inner join WSXML_SFG.control_l1shrclc c on c.id_control_l1shrclc = p.codcontrol_l1shrclc
                    inner join WSXML_SFG.entradaarchivocontrol ec on ec.fechaarchivo = c.fechahorageneracionarchivo
                    where codciclofacturacionpdv = @pCodCicloFacturacionpdv
                    group by d.codcategoriasorteos,  p.codproducto, ec.fechaarchivo
                     --order by 1 desc
					 ) premioporcategoria
                     group by premioporcategoria.totalganadores, premioporcategoria.totalpremios, premioporcategoria.codproducto, premioporcategoria.fechaarchivo) TOTALPREMIOS
                     group by TOTALPREMIOS.fechaarchivo) TOTALPREMIOSPAGOS ON TOTALPREMIOSPAGOS.FECHAARCHIVO = E.FECHAARCHIVO
        left outer join (SELECT ADVV.ID_PRODUCTO,
                                      SUM(ADVV.VENTA) AS VENTAS
                                 FROM WSXML_SFG.ARCHIVO_L1ADVSAL1 ADVV
                                INNER JOIN ENTRADAARCHIVOCONTROL
                                   ON ADVV.FECHAARCHIVO =
                                      ENTRADAARCHIVOCONTROL.FECHAARCHIVO
                                  AND ENTRADAARCHIVOCONTROL.ACTIVE = 1
                                  AND ENTRADAARCHIVOCONTROL.TIPOARCHIVO = 2 /*Juegos*/
                                WHERE ADVV.ACTIVE = 1
                                  and ADVV.fechaarchivo in
                                      (select (FECHAARCHIVO)
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @pCodCicloFacturacionpdv)
                                         and ADVV.fecha not in
                                      (select (FECHAARCHIVO)
                                         from WSXML_SFG.ENTRADAARCHIVOCONTROL
                                        where ENTRADAARCHIVOCONTROL.Codciclofacturacionpdv = @pCodCicloFacturacionpdv)
                                GROUP BY ID_PRODUCTO) Avanzadas on Avanzadas.id_producto = r.codproducto
        where codciclofacturacionpdv = @pCodCicloFacturacionpdv  and codtiporegistro in (1,3)
        group by  r.codtiporegistro,pr.nomproducto;        
        
    end;  

GO



IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesNow', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesNow;
GO


CREATE PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesNow(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                              @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                              @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                              @pg_PRODUCTO              NVARCHAR(2000),
                              @pg_REDPDV                NVARCHAR(2000),
                              @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;

    IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '01-03-2012'
          SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                 ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0) AS DESCUENTOENVENTAS,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0) AS PREMIOS
            FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                         SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                         SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                         SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                   INNER JOIN WSXML_SFG.PRODUCTO PRD
                      ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                      ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                   WHERE PRF.FECHAARCHIVO BETWEEN
                         CONVERT(DATETIME, CONVERT(DATE,'26/02/2012')) AND
                         CONVERT(DATETIME, CONVERT(DATE,'29/02/2012'))
                     AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                     AND PRD.CODTIPOPRODUCTO = CASE
                           WHEN @p_CODTIPOPRODUCTO = -1 THEN
                            PRD.CODTIPOPRODUCTO
                           ELSE
                            @p_CODTIPOPRODUCTO
                         END
                     AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY PRF.FECHAARCHIVO) PRF;

      ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy') =  '04-03-2012' BEGIN
       IF (FORMAT(GETDATE(), 'HH')) > 12
              SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                     ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0) AS DESCUENTOENVENTAS,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0) AS PREMIOS
                FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                             ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                   0) AS INGRESOSBRUTNAANULACIONNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                             SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                             SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                             SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                       INNER JOIN WSXML_SFG.PRODUCTO PRD
                          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                       WHERE PRF.FECHAARCHIVO BETWEEN
                             CONVERT(DATETIME, CONVERT(DATE,'01/03/2012')) AND
                             CONVERT(DATETIME,  CONVERT(DATE,'03/03/2012'))
                         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND PRD.CODTIPOPRODUCTO = CASE
                               WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                PRD.CODTIPOPRODUCTO
                               ELSE
                                @p_CODTIPOPRODUCTO
                             END
                         AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                       GROUP BY PRF.FECHAARCHIVO) PRF;
          ELSE
              SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                     ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0) AS DESCUENTOENVENTAS,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0) AS PREMIOS
                FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                             ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                   0) AS INGRESOSBRUTNAANULACIONNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                             SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                             SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                             SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                       INNER JOIN WSXML_SFG.PRODUCTO PRD
                          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                       WHERE PRF.FECHAARCHIVO BETWEEN
                             CONVERT(DATETIME, CONVERT(DATE,'01/07/2010')) AND
                             CONVERT(DATETIME, CONVERT(DATE,'03/07/2010'))
                         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND PRD.CODTIPOPRODUCTO = CASE
                               WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                PRD.CODTIPOPRODUCTO
                               ELSE
                                @p_CODTIPOPRODUCTO
                             END
                         AND PRF.CODPRODUCTO = PWSXML_SFG.RODUCTO_F(@pg_PRODUCTO)
                       GROUP BY PRF.FECHAARCHIVO) PRF;



      END ELSE
          SELECT ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS VENTASTOTALES,
                 ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS ANULACIONES,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS VENTASBRUTAS,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.0768, 0) AS DESCUENTOENVENTAS,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.50, 0) AS PREMIOS
            FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                         SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                         SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                         SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                   INNER JOIN WSXML_SFG.PRODUCTO PRD
                      ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                      ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                   WHERE PRF.FECHAARCHIVO BETWEEN
                         CONVERT(DATETIME, CONVERT(DATE,'01/07/2010')) AND
                         CONVERT(DATETIME, CONVERT(DATE,'03/07/2010'))
                     AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                     AND PRD.CODTIPOPRODUCTO = CASE
                           WHEN @p_CODTIPOPRODUCTO = -1 THEN
                            PRD.CODTIPOPRODUCTO
                           ELSE
                            @p_CODTIPOPRODUCTO
                         END
                     AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY PRF.FECHAARCHIVO) PRF;

   

  END
GO



IF OBJECT_ID('WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetailNow', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetailNow;
GO


 CREATE PROCEDURE WSXML_SFG.SFGINF_CARTASFIDUCIA_GetWeeklySalesDetailNow(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                    @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                    @p_CODTIPOPRODUCTO        NUMERIC(22,0),
                                    @pg_PRODUCTO              NVARCHAR(2000),
                                    @pg_REDPDV                NVARCHAR(2000),
                                    @pg_CADENA                NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;

    IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '01-03-2012' 
          SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
            FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                         SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                         SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                         SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                   INNER JOIN WSXML_SFG.PRODUCTO PRD
                      ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                      ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                   WHERE PRF.FECHAARCHIVO BETWEEN
                         CONVERT(DATETIME, CONVERT(DATE,'26/02/2012')) AND
                         CONVERT(DATETIME, CONVERT(DATE,'29/02/2012'))
                     AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                     AND PRD.CODTIPOPRODUCTO = CASE
                           WHEN @p_CODTIPOPRODUCTO = -1 THEN
                            PRD.CODTIPOPRODUCTO
                           ELSE
                            @p_CODTIPOPRODUCTO
                         END
                     AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY PRF.FECHAARCHIVO) PRF;

      ELSE IF FORMAT(GETDATE(), 'dd-MM-yyyy') = '04-03-2012' BEGIN
			IF (FORMAT(GETDATE(), 'HH24')) > 12
              SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
                FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                             ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                   0) AS INGRESOSBRUTNAANULACIONNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                             SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                             SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                             SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                       INNER JOIN WSXML_SFG.PRODUCTO PRD
                          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                       WHERE PRF.FECHAARCHIVO BETWEEN
                             CONVERT(DATETIME, CONVERT(DATE,'01/03/2012')) AND
                             CONVERT(DATETIME,CONVERT(DATE,'03/03/2012'))
                         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND PRD.CODTIPOPRODUCTO = CASE
                               WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                PRD.CODTIPOPRODUCTO
                               ELSE
                                @p_CODTIPOPRODUCTO
                             END
                         AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                       GROUP BY PRF.FECHAARCHIVO) PRF;

          ELSE
              SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                     ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
                FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                             ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND),
                                   0) AS INGRESOSBRUTNAANULACIONNOROUND,
                             ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                             SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                             SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                             SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                        FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                       INNER JOIN WSXML_SFG.PRODUCTO PRD
                          ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                       INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                          ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                       WHERE PRF.FECHAARCHIVO BETWEEN
                             CONVERT(DATETIME, CONVERT(DATE,'01/07/2010')) AND
                             CONVERT(DATETIME, CONVERT(DATE,'03/07/2010'))
                         AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                         AND PRD.CODTIPOPRODUCTO = CASE
                               WHEN @p_CODTIPOPRODUCTO = -1 THEN
                                PRD.CODTIPOPRODUCTO
                               ELSE
                                @p_CODTIPOPRODUCTO
                             END
                         AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                       GROUP BY PRF.FECHAARCHIVO) PRF;



      END ELSE
          SELECT ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.3232, 0) AS TRANSFERENCIASSALUD,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.08, 0) AS GASTOSOPERACION,
                 ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO) * 0.02, 0) AS GASTOSMERCADEO
            FROM (SELECT PRF.FECHAARCHIVO AS FECHA,
                         ROUND(SUM(PRF.INGRESOSBRUTNAVENTASNOROUND), 0) AS INGRESOSBRUTNAVENTASNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTNAANULACIONNOROUND), 0) AS INGRESOSBRUTNAANULACIONNOROUND,
                         ROUND(SUM(PRF.INGRESOSBRUTOSNANOREDONDEO), 0) AS INGRESOSBRUTOSNANOREDONDEO,
                         SUM(PRF.COMISIONNAESTANDAR) AS COMISIONNAESTANDAR,
                         SUM(PRF.REVENUENATOTAL) AS REVENUENATOTAL,
                         SUM(PRF.COSTONAMERCADEOVENTA) AS COSTONAMERCADEOVENTA
                    FROM WSXML_SFG.VWKDAYLYREVENUEADJUSTMENTS PRF
                   INNER JOIN WSXML_SFG.PRODUCTO PRD
                      ON (PRF.CODPRODUCTO = PRD.ID_PRODUCTO)
                   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
                      ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO)
                   WHERE PRF.FECHAARCHIVO BETWEEN
                         CONVERT(DATETIME, CONVERT(DATE,'01/07/2010')) AND
                         CONVERT(DATETIME, CONVERT(DATE,'03/07/2010'))
                     AND TPR.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
                     AND PRD.CODTIPOPRODUCTO = CASE
                           WHEN @p_CODTIPOPRODUCTO = -1 THEN
                            PRD.CODTIPOPRODUCTO
                           ELSE
                            @p_CODTIPOPRODUCTO
                         END
                     AND PRF.CODPRODUCTO = WSXML_SFG.PRODUCTO_F(@pg_PRODUCTO)
                   GROUP BY PRF.FECHAARCHIVO) PRF;

  END
  GO
  