USE SFGPRODU;
--------------------------------------------------------
--  DDL for Package Body CON_CONCILIA
--------------------------------------------------------

  /* PACKAGE BODY "SFG_CONCILIACION"."CON_CONCILIA" */ 

 
IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONSTANT;
GO




  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONSTANT(
                                       	@con_True						SMALLINT OUT,
										@con_False						SMALLINT OUT,
										@con_Fecha_Negocio				SMALLINT OUT,
										@con_Identificador_Gtech		SMALLINT OUT,
										@con_Monto_Negocio				SMALLINT OUT,
										@con_Codigo_Respuesta_Aliado	SMALLINT OUT,
										@con_No_Requerido				SMALLINT OUT,
										@con_Codigo_Producto			SMALLINT OUT,
										@con_Vacio						VARCHAR(6) OUT,
										@C_CODDETALLETAREAEJECUTADA		SMALLINT OUT
									   
									   
									   )  AS
 BEGIN
  
	SET @con_True                    = 1;
	SET @con_False                   = 0;
	SET @con_Fecha_Negocio           = 1;
	SET @con_Identificador_Gtech     = 2;
	SET @con_Monto_Negocio           = 3;
	SET @con_Codigo_Respuesta_Aliado = 4;
	SET @con_No_Requerido            = 5;
	SET @con_Codigo_Producto         = 6;
	SET @con_Vacio                   = 'VACIO';
	SET @C_CODDETALLETAREAEJECUTADA  = 0;
  END;
GO




 
  
 IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_RepoblaEXT_108', 'P') is not null
  drop PROCEDURE SFG_CONCILIACION.CON_CONCILIA_RepoblaEXT_108;
GO

create     PROCEDURE SFG_CONCILIACION.CON_CONCILIA_RepoblaEXT_108 as
  begin
  set nocount on;
  
	declare @sql varchar(100) = 'TRUNCATE TABLE SFG_CONCILIACION.VW_EX_REG_107'
	execute(@Sql)

    --EXECUTE sp_executesql @'TRUNCATE TABLE SFG_CONCILIACION.VW_EX_REG_107';
  
    BEGIN
      DECLARE TT CURSOR FOR select aliado,
                        fecha_archivo,
                        fec_posteo,
                        tipo_trx,
                        fec_hora_trx,
                        nro_cuenta,
                        nro_tarjeta,
                        valor,
                        citi_error,
                        conf_trx,
                        descip_term,
                        reversal,
                        valor_reversado,
                        sprn,
                        estado_gtech,
                        motivo_diferencia,
                        campos_fallo
                   from SFG_CONCILIACION.BASE_VW_EX_REG_107 t; 
 
 OPEN TT;

 DECLARE @TT__aliado NUMERIC(38,0),
        @TT__fecha_archivo DATETIME,
        @TT__fec_posteo DATETIME,
        @TT__tipo_trx VARCHAR(4),
        @TT__fec_hora_trx DATETIME,
        @TT__nro_cuenta NUMERIC(38,0),
        @TT__nro_tarjeta NUMERIC(38,0),
        @TT__valor NUMERIC(38,0),
        @TT__citi_error  VARCHAR(4),
        @TT__conf_trx  VARCHAR(2),
        @TT__descip_term  VARCHAR(40),
        @TT__reversal NUMERIC(38,0),
        @TT__valor_reversado NUMERIC(38,0),
        @TT__sprn NUMERIC(38,0),
        @TT__estado_gtech  VARCHAR(5),
        @TT__motivo_diferencia  VARCHAR(100),
        @TT__campos_fallo VARCHAR(500)

 FETCH NEXT FROM TT INTO @TT__aliado,
        @TT__fecha_archivo, @TT__fec_posteo,
        @TT__tipo_trx, @TT__fec_hora_trx,
        @TT__nro_cuenta, @TT__nro_tarjeta,
        @TT__valor, @TT__citi_error,
        @TT__conf_trx, @TT__descip_term,
        @TT__reversal, @TT__valor_reversado,
        @TT__sprn, @TT__estado_gtech,
        @TT__motivo_diferencia, @TT__campos_fallo


 WHILE @@FETCH_STATUS=0
 BEGIN
      
        INSERT INTO SFG_CONCILIACION.VW_EX_REG_107
          (aliado,
           fecha_archivo,
           fec_posteo,
           tipo_trx,
           fec_hora_trx,
           nro_cuenta,
           nro_tarjeta,
           valor,
           citi_error,
           conf_trx,
           descip_term,
           reversal,
           valor_reversado,
           sprn,
           estado_gtech,
           motivo_diferencia,
           campos_fallo)
        VALUES
          (@TT__aliado,
           @TT__fecha_archivo,
           @TT__fec_posteo,
           @TT__tipo_trx,
           @TT__fec_hora_trx,
           @TT__nro_cuenta,
           @TT__nro_tarjeta,
           @TT__valor,
           @TT__citi_error,
           @TT__conf_trx,
           @TT__descip_term,
           @TT__reversal,
           @TT__valor_reversado,
           @TT__sprn,
           @TT__estado_gtech,
           @TT__motivo_diferencia,
           @TT__campos_fallo);
        COMMIT;
		   FETCH NEXT FROM TT INTO @TT__aliado,
			@TT__fecha_archivo, @TT__fec_posteo,
			@TT__tipo_trx, @TT__fec_hora_trx,
			@TT__nro_cuenta, @TT__nro_tarjeta,
			@TT__valor, @TT__citi_error,
			@TT__conf_trx, @TT__descip_term,
			@TT__reversal, @TT__valor_reversado,
			@TT__sprn, @TT__estado_gtech,
			@TT__motivo_diferencia, @TT__campos_fallo
      END;
      CLOSE TT;
      DEALLOCATE TT;
END;
END
GO


  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_FORMATEAR_COLUMNA', 'FN') is not null
  drop FUNCTION SFG_CONCILIACION.CON_CONCILIA_FORMATEAR_COLUMNA;
go

create     FUNCTION SFG_CONCILIACION.CON_CONCILIA_FORMATEAR_COLUMNA(@p_COLUMNA      VARCHAR(4000),
                             @p_USAR_FUNCION VARCHAR(4000),
                             @p_FORMATO      varchar(4000) = '')
    returns varchar(4000) as
 begin
  
    declare @v_SALIDA_FORMAT varchar(200);
  
   
  
    set @v_SALIDA_FORMAT = REPLACE(@p_USAR_FUNCION, '<<columna_ext>>', @p_COLUMNA);
  
    IF @p_USAR_FUNCION like '%<<formato_ext>>%' BEGIN
    
      set @v_SALIDA_FORMAT = REPLACE(@v_SALIDA_FORMAT,'<<formato_ext>>', @p_FORMATO);
    
    END 
  
    set @v_SALIDA_FORMAT = ISNULL(@v_SALIDA_FORMAT, '') + ' as ' + ISNULL(@p_COLUMNA, '');
  
    return @v_SALIDA_FORMAT;
  
  end;
GO

  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CREA_EXTERNAL_ALPHA', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CREA_EXTERNAL_ALPHA;
GO

CREATE     PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CREA_EXTERNAL_ALPHA(@P_FECHACDC DATETIME) AS
 BEGIN
  
    DECLARE @SZSQLINSTRUCTION1 VARCHAR(4000) = '';
    DECLARE @CFILENAME         VARCHAR(50);
  
   
  SET NOCOUNT ON;
  
    SET @CFILENAME = 'RECON_' + ISNULL(WSXML_SFG.SFG_PACKAGE_GETNUMEROCDC(@P_FECHACDC), '') +
                 '.FIL';
  
    SET @SZSQLINSTRUCTION1 = 'ALTER TABLE SFG_CONCILIACION.CON_ENTRADA_ALPHA_EXT LOCATION (   CONCILIA_ALPHA_DIR:''' +
                         ISNULL(@CFILENAME, '') + ''')';
    EXECUTE sp_executesql @SZSQLINSTRUCTION1;
  END;
GO


  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_FORMATEA_NOMBRE_ARC_ALIADO', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_FORMATEA_NOMBRE_ARC_ALIADO;
GO

CREATE     FUNCTION SFG_CONCILIACION.CON_CONCILIA_FORMATEA_NOMBRE_ARC_ALIADO(@P_ARCHIVO_ALIADO VARCHAR(4000),
                                      @P_FECHACDC       DATETIME) RETURNS VARCHAR(4000) AS
 BEGIN
    DECLARE @CFILENAME VARCHAR(4000);
   
  
    if charindex('<<FECHA>>', @P_ARCHIVO_ALIADO) > 0 begin
    
      SET @CFILENAME = REPLACE(@P_ARCHIVO_ALIADO,
                           '<<FECHA>>',
                           CONVERT(VARCHAR(8), @P_FECHACDC, 112));
    
    end
    else if charindex('<<FECHA_DDMMYYYY>>', @P_ARCHIVO_ALIADO) > 0 begin
    
      SET @CFILENAME = REPLACE(@P_ARCHIVO_ALIADO,
                           '<<FECHA_DDMMYYYY>>',
                           FORMAT(@P_FECHACDC, 'ddMMyyyy'));
    
    end
    else if charindex('<<FECHA_YYMMDD>>', @P_ARCHIVO_ALIADO) > 0 begin
    
      SET @CFILENAME = REPLACE(@P_ARCHIVO_ALIADO,
                           '<<FECHA_YYMMDD>>',
                           FORMAT(@P_FECHACDC, 'yyMMdd'));
    
    end
    else if charindex('<<FECHA_YYYYMMDD>>', @P_ARCHIVO_ALIADO) > 0 begin
    
      SET @CFILENAME = REPLACE(@P_ARCHIVO_ALIADO,
                           '<<FECHA_YYYYMMDD>>',
                           CONVERT(VARCHAR(8), @P_FECHACDC, 112));
    end 
  
    RETURN @CFILENAME;
  
  END;
  GO

  

  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CREA_EXTERNAL_ALIADO', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CREA_EXTERNAL_ALIADO;
GO

CREATE     PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CREA_EXTERNAL_ALIADO(@P_NOMBRE_TABLA_EXT   VARCHAR(4000),
                                 @P_ARCHIVO_ALIADO     VARCHAR(4000),
                                 @p_DIRECTORIO_ENTRADA varchar(4000),
                                 @P_FECHACDC           DATETIME) AS
 BEGIN
  
    DECLARE @SZSQLINSTRUCTION1 VARCHAR(4000) = '';
    DECLARE @CFILENAME         VARCHAR(50);
  
   
  SET NOCOUNT ON;
  
    SET @CFILENAME = WSXML_SFG.CON_CONCILIA_FORMATEA_NOMBRE_ARC_ALIADO(@P_ARCHIVO_ALIADO, @P_FECHACDC);
  
    SET @SZSQLINSTRUCTION1 = 'ALTER TABLE SFG_CONCILIACION.' +
                         ISNULL(@P_NOMBRE_TABLA_EXT, '') + ' LOCATION (   ' +
                         ISNULL(@p_DIRECTORIO_ENTRADA, '') + ':''' + ISNULL(@CFILENAME, '') +
                         ''')';
    EXECUTE sp_executesql @SZSQLINSTRUCTION1;
  END;
GO






     IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_REGISTRO_ALIADO_CONCILIABLE', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_REGISTRO_ALIADO_CONCILIABLE;
GO




  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_REGISTRO_ALIADO_CONCILIABLE(@P_TRANS_NMBR NUMERIC(22,0),
                                       @P_TRANS_DATE VARCHAR(4000),
                                       @P_TRANS_CODE VARCHAR(4000)) RETURNS NUMERIC(22,0) AS
 BEGIN
  
    DECLARE @V_CANTIDAD            NUMERIC(22,0);
    DECLARE @V_CANTIDAD_TRANS_CODE NUMERIC(22,0);
    DECLARE @V_SALIDA              NUMERIC(22,0) = 1;
   
  
    SELECT @V_CANTIDAD = COUNT(*)
      FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT,
           SFG_CONCILIACION.CON_PRODUCTO_ALIADO
     WHERE 1=1 --AND ROW_NUMBER() OVER(ORDER BY CODIGO_PRODUCTO_ALIADO ASC) < (SELECT COUNT(*) FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT)
		AND CODIGO_PRODUCTO_ALIADO = EXT_02_TRANS_CODE
		AND CAST(EXT_02_TRANS_NMBR AS NUMERIC(38,0)) = @P_TRANS_NMBR
		AND FORMAT(CONVERT(DATETIME, CONVERT(DATE,EXT_03_TRANS_DATE)) , 'yyyyMMdd') = @P_TRANS_DATE
  
    IF @V_CANTIDAD > 1 BEGIN
      SELECT @V_CANTIDAD_TRANS_CODE = COUNT(*)
        FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT,
             SFG_CONCILIACION.CON_PRODUCTO_ALIADO
       WHERE  1=1 --AND ROW_NUMBER() OVER(ORDER BY CODIGO_PRODUCTO_ALIADO) < (SELECT COUNT(*) FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT)
         AND CODIGO_PRODUCTO_ALIADO = EXT_02_TRANS_CODE
         AND CAST(EXT_02_TRANS_NMBR AS NUMERIC) = @P_TRANS_NMBR
		 AND FORMAT(CONVERT(DATETIME, CONVERT(DATE,EXT_03_TRANS_DATE)) , 'yyyyMMdd') = @P_TRANS_DATE
         AND EXT_02_TRANS_CODE = @P_TRANS_CODE;
    
      /*IF V_CANTIDAD_TRANS_CODE = 1 THEN
      
        IF P_TRANS_CODE IN ('8980', '8981') THEN
          V_SALIDA := 0;
        END IF;
      END IF;*/
    
    END 
    return @V_SALIDA;
  END;
 GO
 
 
  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR', 'FN') is not null
  drop FUNCTION SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR;
go



  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR(@P_ALIADO        NUMERIC(22,0),
                                        @P_ESTADO_GTG    VARCHAR(4000),
                                        @P_TP_TRANS_GTK  VARCHAR,
                                        @P_CONF_MARK_ALI VARCHAR(4000),
                                        @P_COD_ERROR_ALI VARCHAR(4000),
                                        @P_REVERSAL      NUMERIC(22,0))
    RETURNS INTEGER AS
 BEGIN
  
    DECLARE @V_INDICA_SI_CONCILIA NUMERIC(22,0) = 0;
    DECLARE @V_COD_ERR            VARCHAR(50) = @P_COD_ERROR_ALI;
  
   
  
    IF CAST(@V_COD_ERR AS NUMERIC(38,0)) > 0 BEGIN
    
      SET @V_COD_ERR = 'ERR';
    
    END 
    BEGIN
      SELECT @V_INDICA_SI_CONCILIA = CON_EST_TP_VS_CONF_MARK.INDICA_SI_CONCILIA
        FROM sfg_conciliacion.CON_EST_TPTRANS_ALIADO
       INNER JOIN sfg_conciliacion.CON_EST_TP_VS_CONF_MARK
          ON CON_EST_TPTRANS_ALIADO.ID_EST_TPTRANS_ALIADO =
             CON_EST_TP_VS_CONF_MARK.CODEST_TPTRANS_ALIADO
       WHERE (CON_EST_TPTRANS_ALIADO.ESTADO_SERV_COM = @P_ESTADO_GTG)
         AND (CON_EST_TPTRANS_ALIADO.TPTRANS_SERV_COM = @P_TP_TRANS_GTK)
         AND (CON_EST_TP_VS_CONF_MARK.COD_ERR_ALI = @V_COD_ERR)
         AND (CON_EST_TP_VS_CONF_MARK.CONF_MARK_ALI = @P_CONF_MARK_ALI)
         AND (CON_EST_TPTRANS_ALIADO.COD_ALIADOESTRATEGICO = @P_ALIADO)
         AND (CON_EST_TP_VS_CONF_MARK.REVERSAL = @P_REVERSAL);
		IF @@ROWCOUNT = 0
        SET @V_INDICA_SI_CONCILIA = 0;
    END;

	
	  IF @@ROWCOUNT = 0
		RETURN @V_INDICA_SI_CONCILIA;

    RETURN @V_INDICA_SI_CONCILIA;
  
    
  END;
GO







     IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_REGISTRO_ALIADO_CONCILIABLE', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_REGISTRO_ALIADO_CONCILIABLE;
GO




  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_REGISTRO_ALIADO_CONCILIABLE(@P_TRANS_NMBR NUMERIC(22,0),
                                       @P_TRANS_DATE VARCHAR(4000),
                                       @P_TRANS_CODE VARCHAR(4000)) RETURNS NUMERIC(22,0) AS
 BEGIN
  
    DECLARE @V_CANTIDAD            NUMERIC(22,0);
    DECLARE @V_CANTIDAD_TRANS_CODE NUMERIC(22,0);
    DECLARE @V_SALIDA              NUMERIC(22,0) = 1;
   
  
    SELECT @V_CANTIDAD = COUNT(*)
	FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY CODIGO_PRODUCTO_ALIADO ASC) ROWNUM,
			EXT_02_TRANS_NMBR, EXT_03_TRANS_DATE
		FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT,
           SFG_CONCILIACION.CON_PRODUCTO_ALIADO
		WHERE CODIGO_PRODUCTO_ALIADO = EXT_02_TRANS_CODE
	) T
    WHERE T.ROWNUM <
		(SELECT COUNT(*) FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT) 
       AND CAST(EXT_02_TRANS_NMBR AS NUMERIC(38,0)) = @P_TRANS_NMBR
       AND FORMAT(CONVERT(DATETIME, CONVERT(DATE,EXT_03_TRANS_DATE)) , 'yyyyMMdd') = @P_TRANS_DATE;
  
    IF @V_CANTIDAD > 1 BEGIN
      SELECT @V_CANTIDAD_TRANS_CODE = COUNT(*)
	  FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY CODIGO_PRODUCTO_ALIADO ASC) ROWNUM,
			EXT_02_TRANS_CODE, EXT_03_TRANS_DATE, CODIGO_PRODUCTO_ALIADO, EXT_02_TRANS_NMBR
		FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT,
           SFG_CONCILIACION.CON_PRODUCTO_ALIADO
		WHERE CODIGO_PRODUCTO_ALIADO = EXT_02_TRANS_CODE
		) T
		WHERE T.ROWNUM <
				(SELECT COUNT(*) FROM SFG_CONCILIACION.CON_ENTRADA_PROC_EXT)
         AND CODIGO_PRODUCTO_ALIADO = EXT_02_TRANS_CODE
         AND CAST(EXT_02_TRANS_NMBR AS NUMERIC(38,0)) = @P_TRANS_NMBR
		 AND FORMAT(CONVERT(DATETIME, CONVERT(DATE,EXT_03_TRANS_DATE)) , 'yyyyMMdd') = @P_TRANS_DATE
         AND EXT_02_TRANS_CODE = @P_TRANS_CODE;
    
      /*IF V_CANTIDAD_TRANS_CODE = 1 THEN
      
        IF P_TRANS_CODE IN ('8980', '8981') THEN
          V_SALIDA := 0;
        END IF;
      END IF;*/
    
    END 
    return @V_SALIDA;
  END;
GO



     IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON;
GO

  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON(@P_COD_PRODUCTO NUMERIC(22,0)) RETURNS NUMERIC(22,0) as
 begin
  
    declare @V_ID_ALIADO NUMERIC(22,0) = 0;
  
   
  
    SELECT @V_ID_ALIADO = P.CODALIADO
      FROM sfg_conciliacion.con_producto_aliado P
     WHERE P.ID_CON_PRODUCTO_ALIADO = @P_COD_PRODUCTO;
  
   IF @@ROWCOUNT = 0
      RETURN @V_ID_ALIADO;

    RETURN @V_ID_ALIADO;
 
    
  END;
GO



     IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR;
GO

  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR(@P_ALIADO        NUMERIC(22,0),
                                        @P_ESTADO_GTG    VARCHAR(4000),
                                        @P_TP_TRANS_GTK  VARCHAR,
                                        @P_CONF_MARK_ALI VARCHAR(4000),
                                        @P_COD_ERROR_ALI VARCHAR(4000),
                                        @P_REVERSAL      NUMERIC(22,0))
    RETURNS INTEGER AS
 BEGIN
  
    DECLARE @V_INDICA_SI_CONCILIA NUMERIC(22,0) = 0;
    DECLARE @V_COD_ERR            VARCHAR(50) = @P_COD_ERROR_ALI;
  
   
  
    IF CAST(@V_COD_ERR AS NUMERIC(38,0)) > 0 BEGIN
    
      SET @V_COD_ERR = 'ERR';
    
    END 
    BEGIN
		  SELECT @V_INDICA_SI_CONCILIA = CON_EST_TP_VS_CONF_MARK.INDICA_SI_CONCILIA
			FROM sfg_conciliacion.CON_EST_TPTRANS_ALIADO
		   INNER JOIN sfg_conciliacion.CON_EST_TP_VS_CONF_MARK
			  ON CON_EST_TPTRANS_ALIADO.ID_EST_TPTRANS_ALIADO =
				 CON_EST_TP_VS_CONF_MARK.CODEST_TPTRANS_ALIADO
		   WHERE (CON_EST_TPTRANS_ALIADO.ESTADO_SERV_COM = @P_ESTADO_GTG)
			 AND (CON_EST_TPTRANS_ALIADO.TPTRANS_SERV_COM = @P_TP_TRANS_GTK)
			 AND (CON_EST_TP_VS_CONF_MARK.COD_ERR_ALI = @V_COD_ERR)
			 AND (CON_EST_TP_VS_CONF_MARK.CONF_MARK_ALI = @P_CONF_MARK_ALI)
			 AND (CON_EST_TPTRANS_ALIADO.COD_ALIADOESTRATEGICO = @P_ALIADO)
			 AND (CON_EST_TP_VS_CONF_MARK.REVERSAL = @P_REVERSAL);
		IF @@ROWCOUNT = 0
			SET @V_INDICA_SI_CONCILIA = 0;
    END;

	IF @@ROWCOUNT = 0
      RETURN @V_INDICA_SI_CONCILIA;


    RETURN @V_INDICA_SI_CONCILIA;
  
  
    
  END;
GO



     IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_OLD', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_OLD;
GO

  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_OLD AS
 BEGIN
  
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @V_ID_CON_CONTROL_PROC_OUT    NUMERIC(22,0);
    DECLARE @V_CANTIDAD_TRAN_ALIADO       NUMERIC(22,0);
    DECLARE @V_CANTIDAD_TRAN_GTK          NUMERIC(22,0);
    DECLARE @V_ESTADO_TRANSA_ALI          NUMERIC(22,0);
    DECLARE @V_CANTIDAD_BUS_DATE_ALIADO   NUMERIC(22,0);
    DECLARE @V_CAMPOS_NO_COINCIDE         VARCHAR(2000);
    DECLARE @V_CAMPOS_SI_COINCIDE         VARCHAR(2000);
    DECLARE @v_EST_TP_TR_VS_CONF_MAR      NUMERIC(22,0);
    DECLARE @V_ESTADO_CONCILIA            NUMERIC(22,0) = 2; --INICIALIZA LA VARIABLE COMO NO CONCILIADO
    DECLARE @v_mensaje_err                varchar(4000) = '';
  
   
  SET NOCOUNT ON;
    --Paso 1 Crear el registro del proceso de conciliacion
  
  BEGIN TRY

	DECLARE @FECHAHOY DAtetime = getdate();
    EXEC sfg_conciliacion.sfgconciwebcon_control_proc_co_addrecord @FECHAHOY,
                                                              null,
                                                              1,
                                                              'Externa',
                                                              1,
                                                               @v_mensaje_err,
                                                              @V_ID_CON_CONTROL_PROC_OUT out
  
    --paso2 Tomar los registros por conciliar la tabla sfg_conciliacion.entradaconciliagtk y recorrer el aliado CITI
  
    declare cur_gtk cursor for SELECT ID_ENTRADACONCILIAGTK,
                           CODREGISTROFACTREFERENCIA,
                           BUS_DATE,
                           CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                           AMOUNT,
                           CAST(ANSWER_CODE  AS NUMERIC(38,0)) as ANSWER_CODE,
                           ENTRADACONCILIAGTK.ARRN,
                           estado_sc,
                           tipotransaccion_sc,
                           ENTRADACONCILIAGTK.ID_ENTRADACONCILIAGTK AS FILA
                      FROM SFG_CONCILIACION.ENTRADACONCILIAGTK,
                           WSXML_SFG.REGISTROFACTREFERENCIA    RFR,
                           WSXML_SFG.REGISTROFACTURACION       RF,
                           WSXML_SFG.PRODUCTO                  PR
                     WHERE (ESTADO_CONCILIA = 1)
                       AND (CONCILIABLE = 1)
                       AND RFR.ID_REGISTROFACTREFERENCIA =
                           SFG_CONCILIACION.ENTRADACONCILIAGTK.CODREGISTROFACTREFERENCIA
                       AND RFR.CODREGISTROFACTURACION =
                           RF.ID_REGISTROFACTURACION
                       AND RF.CODPRODUCTO = PR.ID_PRODUCTO
                       AND PR.CODALIADOESTRATEGICO = 107;
                    --                   and rcpt_nmr = 8773309
 open cur_gtk;

 DECLARE @cur_gtk__ID_ENTRADACONCILIAGTK NUMERIC(38,0),
                           @cur_gtk__CODREGISTROFACTREFERENCIA NUMERIC(38,0),
                           @cur_gtk__BUS_DATE DATETIME,
                           @cur_gtk__RCPT_NMR  NUMERIC(38,0),
                           @cur_gtk__AMOUNT  NUMERIC(38,0),
                           @cur_gtk__ANSWER_CODE NUMERIC(38,0),
                           @cur_gtk__ARRN VARCHAR(100),
                           @cur_gtk__estado_sc VARCHAR(5),
                           @cur_gtk__tipotransaccion_sc VARCHAR(5),
                           @cur_gtk__FILA  NUMERIC(38,0)
 fetch NEXT FROM  cur_gtk into

	@cur_gtk__ID_ENTRADACONCILIAGTK,
                           @cur_gtk__CODREGISTROFACTREFERENCIA,
                           @cur_gtk__BUS_DATE,
                           @cur_gtk__RCPT_NMR,
                           @cur_gtk__AMOUNT,
                           @cur_gtk__ANSWER_CODE,
                           @cur_gtk__ARRN,
                           @cur_gtk__estado_sc,
                           @cur_gtk__tipotransaccion_sc,
                           @cur_gtk__FILA
 while @@fetch_status=0
 begin
    
      SET @v_CAMPOS_NO_COINCIDE = '';
      SET @v_CAMPOS_SI_COINCIDE = '';
      SET @V_ESTADO_CONCILIA    = 2;
    
      --Paso 3 Valida la existencia del id de transaccion en la tabla de aliado
    
      select @v_CANTIDAD_TRAN_ALIADO = count(*)
        from SFG_CONCILIACION.ENTRADACONCILIAALI a
       where CAST(a.rcpt_nmr AS NUMERIC(38,0)) = @cur_gtk__rcpt_nmr
         and a.estado_concilia = 1;
      -- Si encuentra una transaccion en la tabla de aliado entra.
      if @V_CANTIDAD_TRAN_ALIADO >= 1 begin
      
        select @v_CANTIDAD_TRAN_ALIADO = count(*)
          from SFG_CONCILIACION.ENTRADACONCILIAALI a
         where CAST(a.rcpt_nmr AS NUMERIC(38,0)) = @cur_gtk__rcpt_nmr
           and a.estado_concilia = 1
           and a.bus_date = @cur_gtk__bus_date;
      
        if @V_CANTIDAD_TRAN_ALIADO > 1 begin
        
          update SFG_CONCILIACION.ENTRADACONCILIAGTK
             set conciliado_con      = 0,
                 estado_concilia     = 2,
                 codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
           where ID_ENTRADACONCILIAGTK = @cur_gtk__fila;
        
          DECLARE REPETIDOS_ALI CURSOR FOR SELECT G.ID_ENTRADACONCILIAALI,
                                       G.ID_ENTRADACONCILIAALI AS FILA
                                  FROM SFG_CONCILIACION.ENTRADACONCILIAALI G
                                 WHERE CAST(G.RCPT_NMR AS NUMERIC(38,0)) = @cur_gtk__RCPT_NMR; 
		OPEN REPETIDOS_ALI;

		DECLARE @REPETIDOS_ALI__ID_ENTRADACONCILIAALI NUMERIC(38,0),
                                       @REPETIDOS_ALI__FILA NUMERIC(38,0)
 FETCH REPETIDOS_ALI INTO @REPETIDOS_ALI__ID_ENTRADACONCILIAALI, @REPETIDOS_ALI__FILA;
 WHILE @@FETCH_STATUS=0
 BEGIN
            -- Call the procedure
            EXEC sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord 
																		@REPETIDOS_ALI__ID_ENTRADACONCILIAALI,
                                                                      @cur_gtk__id_entradaconciliagtk,
                                                                      @V_ID_CON_CONTROL_PROC_OUT,
                                                                      3,
                                                                      @V_CAMPOS_SI_COINCIDE,
                                                                      @V_CAMPOS_NO_COINCIDE,
                                                                      null,
                                                                      @V_ID_CON_NO_CONCILIA_ALI_OUT OUT
          
            update SFG_CONCILIACION.ENTRADACONCILIAALI
               set conciliado_con      = 0,
                   estado_concilia     = 2,
                   codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
             where ID_ENTRADACONCILIAALI = @REPETIDOS_ALI__FILA;
          
			FETCH REPETIDOS_ALI INTO @REPETIDOS_ALI__ID_ENTRADACONCILIAALI, @REPETIDOS_ALI__FILA;
          END;
          CLOSE REPETIDOS_ALI;
          DEALLOCATE REPETIDOS_ALI;
        
        end
        else if @V_CANTIDAD_TRAN_ALIADO = 1 begin
        
          declare CUR_ALI1 cursor for select a.id_entradaconciliaali,
                                  a.bus_date,
                                  CAST(a.rcpt_nmr AS NUMERIC(38,0)) as rcpt_nmr,
                                  a.amount,
                                  CAST(a.answer_code AS NUMERIC(38,0)) as answer_code,
                                  a.estado_concilia,
                                  a.CONF_MARK,
                                  a.CODPRODUCTO,
                                  a.id_entradaconciliaali as fila,
                                  A.REVERSAL
                             from SFG_CONCILIACION.ENTRADACONCILIAALI           a,
                                  SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS AA
                            where CAST(a.rcpt_nmr AS NUMERIC(38,0)) = @cur_gtk__rcpt_nmr
                              and a.bus_date = @cur_gtk__bus_date
                              AND AA.ID_CONTROL_ARCHIVOS_ALI =
                                  A.CODCONTROL_ARCHIVOS_ALI
                              AND AA.ID_CONF_ARCHIVOS = 2; open CUR_ALI1;

DECLARE @CUR_ALI1__id_entradaconciliaali NUMERIC(38,0) ,
                                  @CUR_ALI1__bus_date DATETIME,
                                  @CUR_ALI1__rcpt_nmr VARCHAR(100),
                                  @CUR_ALI1__amount  NUMERIC(38,0),
                                  @CUR_ALI1__answer_code VARCHAR(4),
                                  @CUR_ALI1__estado_concilia  NUMERIC(38,0),
                                  @CUR_ALI1__CONF_MARK VARCHAR(5),
                                  @CUR_ALI1__CODPRODUCTO  NUMERIC(38,0),
                                  @CUR_ALI1__fila  NUMERIC(38,0),
                                  @CUR_ALI1__REVERSAL  NUMERIC(38,0)

 fetch CUR_ALI1 into @CUR_ALI1__id_entradaconciliaali ,
                                  @CUR_ALI1__bus_date,
                                  @CUR_ALI1__rcpt_nmr,
                                  @CUR_ALI1__amount,
                                  @CUR_ALI1__answer_code,
                                  @CUR_ALI1__estado_concilia,
                                  @CUR_ALI1__CONF_MARK ,
                                  @CUR_ALI1__CODPRODUCTO ,
                                  @CUR_ALI1__fila  ,
                                  @CUR_ALI1__REVERSAL
 while @@fetch_status=0
 begin
          
            --Si el estado del registro es 1 Pendiente por Conciliar
            if @CUR_ALI1__estado_concilia = 1 begin
            
              --Si la fecha de negocio coincide
              if @CUR_ALI1__BUS_DATE = @cur_gtk__bus_date begin
                SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                        'Si coincide Fecha Negocio : BUSINESS_DATE - ';
              end
              else begin
              
                SET @V_ESTADO_CONCILIA = 3;
                -- 3 Conciliado Parcial
              
                SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                        'No coincide Fecha Negocio : BUSINESS_DATE (GTK:' +
                                        isnull(FORMAT(@cur_gtk__bus_date,'dd/MM/yyyy'), '') +
                                        ' ALIADO:' +
                                        isnull(FORMAT(@CUR_ALI1__BUS_DATE,'dd/MM/yyyy'), '') + ') - ';
              
              end 
            
              --Si el monto coincide
              if @CUR_ALI1__AMOUNT = @cur_gtk__amount begin
                SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                        'Si coincide Monto Transaccion : AMOUNT - ';
              
              end
              else begin
                SET @V_ESTADO_CONCILIA = 3;
                -- 3 Conciliado Parcial
              
                SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                        'No coincide Monto Transaccion : AMOUNT (GTK:' +
                                        isnull(@cur_gtk__amount, '') + ' ALIADO:' +
                                        ISNULL(@CUR_ALI1__AMOUNT, '') + ') - ';
              end 
            
              --Si el codigo de respuesta coincide
              /*if @CUR_ALI1__ANSWER_CODE = @cur_gtk__answer_code then
              
                V_ESTADO_CONCILIA := 5;
              
                v_CAMPOS_SI_COINCIDE := v_CAMPOS_SI_COINCIDE ||
                                        ' Si coincide codigo de respuesta Mensaje : ANSWER_CODE - ';
              
              else
                V_ESTADO_CONCILIA := 3;
                -- 3 Conciliado Parcial
              
                v_CAMPOS_NO_COINCIDE := v_CAMPOS_NO_COINCIDE ||
                                        ' No coincide codigo de respuesta Mensaje : ANSWER_CODE (GTK:' ||
                                        @cur_gtk__answer_code || ' ALIADO:' ||
                                        @CUR_ALI1__ANSWER_CODE || ') - ';
              
              end if;*/
            
              --Si el Estado el Tipo Transaccion y Conf_Mark coinciden
            
              SET @v_EST_TP_TR_VS_CONF_MAR = SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR( 
															SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON(@CUR_ALI1__CODPRODUCTO),
                                                                      @cur_gtk__estado_sc,
                                                                     @cur_gtk__tipotransaccion_sc,
                                                                      @CUR_ALI1__CONF_MARK,
                                                                      @CUR_ALI1__ANSWER_CODE,
                                                                       @CUR_ALI1__REVERSAL);
            
              if @v_EST_TP_TR_VS_CONF_MAR = 1 begin
              
                SET @V_ESTADO_CONCILIA = 5;
              
                SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                        'Si coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK - ';
              
              end
              else begin
                SET @V_ESTADO_CONCILIA = 3;
                -- 3 Conciliado Parcial
              
                SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                        'No coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK (GTK: ' +
                                        isnull(@cur_gtk__estado_sc, '') + ' , ' +
                                        isnull(@cur_gtk__tipotransaccion_sc, '') +
                                        ' ALIADO: ' + ISNULL(@CUR_ALI1__CONF_MARK, '') +
                                        ') - ';
              
              end 
            
              --
            
              if @V_ESTADO_CONCILIA <> 5
              
                begin
                  -- Call the procedure
                  exec sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord 
																			@CUR_ALI1__ID_ENTRADACONCILIAALI,
                                                                            @cur_gtk__id_entradaconciliagtk,
                                                                            @V_ID_CON_CONTROL_PROC_OUT,
                                                                            2,
                                                                            @V_CAMPOS_SI_COINCIDE,
                                                                            @V_CAMPOS_NO_COINCIDE,
                                                                            null,
                                                                            @V_ID_CON_NO_CONCILIA_ALI_OUT OUT
                end;
              
              
            
              update SFG_CONCILIACION.ENTRADACONCILIAALI
                 set estado_concilia     = @V_ESTADO_CONCILIA,
                     conciliado_con      = @cur_gtk__id_entradaconciliagtk,
                     codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
               where ID_ENTRADACONCILIAALI = @CUR_ALI1__FILA;
              commit;

              update SFG_CONCILIACION.ENTRADACONCILIAGTK 
                 set conciliado_con      = @CUR_ALI1__id_entradaconciliaali,
                     estado_concilia     = @V_ESTADO_CONCILIA,
                     codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
               where ID_ENTRADACONCILIAGTK = @cur_gtk__fila;
              commit;
            end 
           fetch CUR_ALI1 into @CUR_ALI1__id_entradaconciliaali ,
                                  @CUR_ALI1__bus_date,
                                  @CUR_ALI1__rcpt_nmr,
                                  @CUR_ALI1__amount,
                                  @CUR_ALI1__answer_code,
                                  @CUR_ALI1__estado_concilia,
                                  @CUR_ALI1__CONF_MARK ,
                                  @CUR_ALI1__CODPRODUCTO ,
                                  @CUR_ALI1__fila  ,
                                  @CUR_ALI1__REVERSAL
          end;
          close CUR_ALI1;
          deallocate CUR_ALI1;
        
          -- Si no existe la transaccion, marca el registro GTK como 2 No Conciliado
        end 
      end
      else if @V_CANTIDAD_TRAN_ALIADO = 0 begin
      
        update SFG_CONCILIACION.ENTRADACONCILIAGTK 
           set conciliado_con      = 0,
               estado_concilia     = 2,
               codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
         where ID_ENTRADACONCILIAGTK = @cur_gtk__fila;
      
        begin
          -- Call the procedure
          exec sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord
		  
																	null,
                                                                    @cur_gtk__id_entradaconciliagtk,
                                                                    @V_ID_CON_CONTROL_PROC_OUT,
                                                                    1,
                                                                    @V_CAMPOS_SI_COINCIDE,
                                                                    @V_CAMPOS_NO_COINCIDE,
                                                                     null,
                                                                     @V_ID_CON_NO_CONCILIA_ALI_OUT out
          commit;
        end;
      
      end 
     fetch NEXT FROM  cur_gtk into

	@cur_gtk__ID_ENTRADACONCILIAGTK,
                           @cur_gtk__CODREGISTROFACTREFERENCIA,
                           @cur_gtk__BUS_DATE,
                           @cur_gtk__RCPT_NMR,
                           @cur_gtk__AMOUNT,
                           @cur_gtk__ANSWER_CODE,
                           @cur_gtk__ARRN,
                           @cur_gtk__estado_sc,
                           @cur_gtk__tipotransaccion_sc,
                           @cur_gtk__FILA
    end;
    close cur_gtk;
    deallocate cur_gtk;
  
    --Conciliacion desde Aliado hacia GTK
  
    declare loop_aliado cursor for select id_entradaconciliaali,
                               codproducto,
                               codcontrol_archivos_ali,
                               conciliado_con,
                               bus_date,
                               cast(RCPT_NMR  AS NUMERIC(38,0)) AS RCPT_NMR,
                               amount,
                               answer_code,
                               estado_concilia,
                               bus_date_modificado,
                               conf_mark,
                               EA.id_entradaconciliaali AS FILA,
                               reversal
                          from SFG_CONCILIACION.ENTRADACONCILIAALI           ea,
                               SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS AA
                         where (ea.ESTADO_CONCILIA = 1)
                           AND (CONCILIABLE = 1)
                           AND AA.ID_CONTROL_ARCHIVOS_ALI =
                               ea.CODCONTROL_ARCHIVOS_ALI
                           AND AA.ID_CONF_ARCHIVOS = 2; open loop_aliado;


DECLARE @loop_aliado__id_entradaconciliaali NUMERIC(38,0) ,
		@loop_aliado__CODPRODUCTO  NUMERIC(38,0),
		@loop_aliado__codcontrol_archivos_ali NUMERIC(38,0),
		@loop_aliado__conciliado_con  NUMERIC(38,0),
        @loop_aliado__bus_date DATETIME,
        @loop_aliado__rcpt_nmr VARCHAR(100),
        @loop_aliado__amount  NUMERIC(38,0),
        @loop_aliado__answer_code VARCHAR(4),
        @loop_aliado__estado_concilia  NUMERIC(38,0),
        @loop_aliado__CONF_MARK VARCHAR(5),
                                  
        @loop_aliado__fila  NUMERIC(38,0),
        @loop_aliado__REVERSAL  NUMERIC(38,0)




 fetch NEXT FROM  loop_aliado into @loop_aliado__id_entradaconciliaali ,
		@loop_aliado__CODPRODUCTO  ,
		@loop_aliado__codcontrol_archivos_ali ,
		@loop_aliado__conciliado_con ,
        @loop_aliado__bus_date,
        @loop_aliado__rcpt_nmr,
        @loop_aliado__amount ,
        @loop_aliado__answer_code,
        @loop_aliado__estado_concilia ,
        @loop_aliado__CONF_MARK,
                                  
        @loop_aliado__fila,
        @loop_aliado__REVERSAL

 while @@fetch_status=0
 begin
    
      SET @v_CAMPOS_NO_COINCIDE = '';
      SET @v_CAMPOS_SI_COINCIDE = '';
      SET @V_ESTADO_CONCILIA    = 2;
    
      --Valida la existencia del id de transaccion en la tabla de GTK
    
      select @V_CANTIDAD_TRAN_GTK = count(*)
        from SFG_CONCILIACION.ENTRADACONCILIAGTK G
       where cast(RCPT_NMR  AS NUMERIC(38,0)) = @loop_aliado__rcpt_nmr
         and G.estado_concilia = 1
         and g.conciliable = 1;
    
      if @V_CANTIDAD_TRAN_GTK >= 1 begin
      
        select @V_CANTIDAD_TRAN_GTK = count(*)
          from SFG_CONCILIACION.ENTRADACONCILIAGTK G
         where CAST(RCPT_NMR AS NUMERIC(38,0)) = @loop_aliado__rcpt_nmr
           and G.estado_concilia = 1
           and g.bus_date = @loop_aliado__bus_date
           and g.conciliable = 1;
      
        if @V_CANTIDAD_TRAN_GTK > 1 begin
        
          update SFG_CONCILIACION.ENTRADACONCILIAALI
             set conciliado_con      = 0,
                 estado_concilia     = 2,
                 codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
           where ID_ENTRADACONCILIAALI = @loop_aliado__FILA;
        
          DECLARE REPETIDOS_GTK CURSOR FOR SELECT G.ID_ENTRADACONCILIAGTK,
                                       G.ID_ENTRADACONCILIAGTK AS FILA
                                  FROM SFG_CONCILIACION.ENTRADACONCILIAGTK G,
                                       WSXML_SFG.REGISTROFACTREFERENCIA    RFR,
                                       WSXML_SFG.REGISTROFACTURACION       RF,
                                       WSXML_SFG.PRODUCTO                  PR
                                 WHERE CAST(G.RCPT_NMR AS NUMERIC(38,0)) =
                                       @loop_aliado__RCPT_NMR
                                   and g.bus_date = @loop_aliado__BUS_DATE
                                   and g.conciliable = 1
                                   AND RFR.ID_REGISTROFACTREFERENCIA =
                                       G.CODREGISTROFACTREFERENCIA
                                   AND RFR.CODREGISTROFACTURACION =
                                       RF.ID_REGISTROFACTURACION
                                   AND RF.CODPRODUCTO = PR.ID_PRODUCTO
                                   AND PR.CODALIADOESTRATEGICO = 107; OPEN REPETIDOS_GTK;
DECLARE @REPETIDOS_GTK__ID_ENTRADACONCILIAGTK NUMERIC(38,0),
                                       @REPETIDOS_GTK__FILA NUMERIC(38,0)
 FETCH NEXT FROM REPETIDOS_GTK INTO @REPETIDOS_GTK__ID_ENTRADACONCILIAGTK, @REPETIDOS_GTK__FILA;
 WHILE @@FETCH_STATUS=0
 BEGIN
            -- Call the procedure
            EXEC sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord 
			
																		 @loop_aliado__ID_ENTRADACONCILIAALI,
                                                                     @REPETIDOS_GTK__ID_ENTRADACONCILIAGTK,
                                                                      @V_ID_CON_CONTROL_PROC_OUT,
                                                                      3,
                                                                      @V_CAMPOS_SI_COINCIDE,
                                                                     @V_CAMPOS_NO_COINCIDE,
                                                                      null,
                                                                       @V_ID_CON_NO_CONCILIA_ALI_OUT OUT
          
            update SFG_CONCILIACION.ENTRADACONCILIAGTK
               set conciliado_con      = 0,
                   estado_concilia     = 2,
                   codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
             where ID_ENTRADACONCILIAGTK = @REPETIDOS_GTK__FILA;
            commit;
           FETCH NEXT FROM REPETIDOS_GTK INTO @REPETIDOS_GTK__ID_ENTRADACONCILIAGTK, @REPETIDOS_GTK__FILA;
          END;
          CLOSE REPETIDOS_GTK;
          DEALLOCATE REPETIDOS_GTK;
        
        end
        else if @V_CANTIDAD_TRAN_GTK = 1 begin
        
          declare CUR_gtk1 cursor for select id_entradaconciliagtk,
                                  codregistrofactreferencia,
                                  conciliado_con,
                                  bus_date,
                                  CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                                  amount,
                                  answer_code,
                                  GT.arrn,
                                  estado_concilia,
                                  conciliable,
                                  fecha_hora_trans,
                                  bus_date_modificado,
                                  codrazon_no_conciliable,
                                  estado_sc,
                                  tipotransaccion_sc,
                                  GT.id_entradaconciliagtk AS FILA
                             from sfg_conciliacion.entradaconciliagtk GT,
                                  WSXML_SFG.REGISTROFACTREFERENCIA    RFR,
                                  WSXML_SFG.REGISTROFACTURACION       RF,
                                  WSXML_SFG.PRODUCTO                  PR
                            where CAST(GT.rcpt_nmr AS NUMERIC(38,0)) =
                                  @loop_aliado__rcpt_nmr
                              and gt.bus_date = @loop_aliado__bus_date
                              and gt.conciliable = 1
                              AND RFR.ID_REGISTROFACTREFERENCIA =
                                  GT.CODREGISTROFACTREFERENCIA
                              AND RFR.CODREGISTROFACTURACION =
                                  RF.ID_REGISTROFACTURACION
                              AND RF.CODPRODUCTO = PR.ID_PRODUCTO
                              AND PR.CODALIADOESTRATEGICO = 107; open CUR_gtk1;

DECLARE @CUR_gtk1__id_entradaconciliagtk NUMERIC(38,0) ,
		@CUR_gtk1__codregistrofactreferencia NUMERIC(38,0),
		@CUR_gtk1__conciliado_con  NUMERIC(38,0),
		@CUR_gtk1__bus_date DATETIME,
		@CUR_gtk1__rcpt_nmr VARCHAR(100),
		@CUR_gtk1__amount  NUMERIC(38,0),
		@CUR_gtk1__answer_code VARCHAR(4),
		@CUR_gtk1__arrn VARCHAR(100),
		@CUR_gtk1__estado_concilia  NUMERIC(38,0),
		@CUR_gtk1__conciliable  NUMERIC(38,0),
		@CUR_gtk1__fecha_hora_trans DATETIME,
		@CUR_gtk1__bus_date_modificado DATETIME,
		@CUR_gtk1__codrazon_no_conciliable  NUMERIC(38,0),
		@CUR_gtk1__estado_sc VARCHAR(5),
		@CUR_gtk1__tipotransaccion_sc VARCHAR(5),
		@CUR_gtk1__fila  NUMERIC(38,0)


 FETCH NEXT FROM  CUR_gtk1 into @CUR_gtk1__id_entradaconciliagtk ,
		@CUR_gtk1__codregistrofactreferencia,
		@CUR_gtk1__conciliado_con ,
		@CUR_gtk1__bus_date,
		@CUR_gtk1__rcpt_nmr,
		@CUR_gtk1__amount ,
		@CUR_gtk1__answer_code,
		@CUR_gtk1__arrn,
		@CUR_gtk1__estado_concilia ,
		@CUR_gtk1__conciliable ,
		@CUR_gtk1__fecha_hora_trans,
		@CUR_gtk1__bus_date_modificado,
		@CUR_gtk1__codrazon_no_conciliable ,
		@CUR_gtk1__estado_sc ,
		@CUR_gtk1__tipotransaccion_sc,
		@CUR_gtk1__fila

 while @@fetch_status=0
 begin
          
            --Si el estado del registro es 1 Pendiente por Conciliar
            if @CUR_gtk1__estado_concilia = 1 begin
            
              --Si la fecha de negocio coincide
              if @loop_aliado__BUS_DATE = @CUR_gtk1__bus_date begin
                SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                        'Si coincide Fecha Negocio : BUSINESS_DATE - ';
              end
              else begin
              
                SET @V_ESTADO_CONCILIA = 3;
                -- 3 Conciliado Parcial
              
                SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                        'No coincide Fecha Negocio : BUSINESS_DATE (GTK:' +
                                        isnull(FORMAT(@loop_aliado__bus_date,'dd/MM/yyyy'), '') +
                                        ' ALIADO:' +
                                        isnull(format(@CUR_gtk1__BUS_DATE,'dd/MM/yyyy'), '') + ') - ';
              
              end 
            
              --Si el monto coincide
              if @loop_aliado__AMOUNT = @CUR_gtk1__amount begin
                SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                        'Si coincide Monto Transaccion : AMOUNT - ';
              
              end
              else begin
                SET @V_ESTADO_CONCILIA = 3;
                -- 3 Conciliado Parcial
              
                SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                        'No coincide Monto Transaccion : AMOUNT (GTK:' +
                                        isnull(@loop_aliado__amount, '') + ' ALIADO:' +
                                        ISNULL(@CUR_gtk1__AMOUNT, '') + ') - ';
              end 
            
              --Si el Estado el Tipo Transaccion y Conf_Mark coinciden
            
              SET @v_EST_TP_TR_VS_CONF_MAR = SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR(
																	SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON(@loop_aliado__CODPRODUCTO),
                                                                     @CUR_gtk1__estado_sc,
                                                                       @CUR_gtk1__tipotransaccion_sc,
                                                                      @loop_aliado__CONF_MARK,
                                                                      @loop_aliado__answer_code,
                                                                       @loop_aliado__REVERSAL
																	   )
            
              if @v_EST_TP_TR_VS_CONF_MAR = 1 begin
              
                SET @V_ESTADO_CONCILIA = 5;
              
                SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                        'Si coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK - ';
              
              end
              else begin
                SET @V_ESTADO_CONCILIA = 3;
                -- 3 Conciliado Parcial
              
                SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                        'No coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK (GTK: ' +
                                        ISNULL(@CUR_gtk1__estado_sc, '') + ' , ' +
                                        ISNULL(@CUR_gtk1__tipotransaccion_sc, '') +
                                        ' ALIADO: ' +
                                        ISNULL(@loop_aliado__CONF_MARK, '') + ') - ';
              
              end 
            
              --
            
              if @V_ESTADO_CONCILIA <> 5
              
                begin
                  -- Call the procedure
                  EXEC sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord 
																			@loop_aliado__ID_ENTRADACONCILIAALI,
                                                                            @CUR_gtk1__id_entradaconciliagtk,
                                                                             @V_ID_CON_CONTROL_PROC_OUT,
                                                                             2,
                                                                            @V_CAMPOS_SI_COINCIDE,
                                                                             @V_CAMPOS_NO_COINCIDE,
                                                                             null,
                                                                             @V_ID_CON_NO_CONCILIA_ALI_OUT OUT
                  commit;
                end;
              
              
            
              update SFG_CONCILIACION.ENTRADACONCILIAGTK
                 set conciliado_con      = @loop_aliado__id_entradaconciliaali,
                     estado_concilia     = @V_ESTADO_CONCILIA,
                     codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
               where id_entradaconciliagtk = @CUR_gtk1__fila;
              commit;
              update SFG_CONCILIACION.ENTRADACONCILIAALI 
                 set estado_concilia     = @V_ESTADO_CONCILIA,
                     conciliado_con      = @CUR_gtk1__id_entradaconciliagtk,
                     codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
               where ID_ENTRADACONCILIAALI = @loop_aliado__FILA;
              commit;
            end 
           FETCH NEXT FROM  CUR_gtk1 into @CUR_gtk1__id_entradaconciliagtk ,
		@CUR_gtk1__codregistrofactreferencia,
		@CUR_gtk1__conciliado_con ,
		@CUR_gtk1__bus_date,
		@CUR_gtk1__rcpt_nmr,
		@CUR_gtk1__amount ,
		@CUR_gtk1__answer_code,
		@CUR_gtk1__arrn,
		@CUR_gtk1__estado_concilia ,
		@CUR_gtk1__conciliable ,
		@CUR_gtk1__fecha_hora_trans,
		@CUR_gtk1__bus_date_modificado,
		@CUR_gtk1__codrazon_no_conciliable ,
		@CUR_gtk1__estado_sc ,
		@CUR_gtk1__tipotransaccion_sc,
		@CUR_gtk1__fila
          end;
          close CUR_gtk1;
          deallocate CUR_gtk1;
          -- Si no existe la transaccion, marca el registro ALIADO como 2 No Conciliado
        end 
      end
      else if @V_CANTIDAD_TRAN_GTK = 0 begin
      
        update SFG_CONCILIACION.ENTRADACONCILIAALI 
           set conciliado_con      = 0,
               estado_concilia     = 2,
               codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
         where ID_ENTRADACONCILIAALI = @loop_aliado__fila;
        commit;
        begin
          -- Call the procedure
          EXEC sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord 
																	@loop_aliado__id_entradaconciliaali,
                                                                     null,
                                                                     @V_ID_CON_CONTROL_PROC_OUT,
                                                                     1,
                                                                   @V_CAMPOS_SI_COINCIDE,
                                                                    @V_CAMPOS_NO_COINCIDE,
                                                                    null,
                                                                     @V_ID_CON_NO_CONCILIA_ALI_OUT OUT
          commit;
        end;
      
      end 
    
    fetch NEXT FROM  loop_aliado into @loop_aliado__id_entradaconciliaali ,
		@loop_aliado__CODPRODUCTO  ,
		@loop_aliado__codcontrol_archivos_ali ,
		@loop_aliado__conciliado_con ,
        @loop_aliado__bus_date,
        @loop_aliado__rcpt_nmr,
        @loop_aliado__amount ,
        @loop_aliado__answer_code,
        @loop_aliado__estado_concilia ,
        @loop_aliado__CONF_MARK,
                                  
        @loop_aliado__fila,
        @loop_aliado__REVERSAL
    end;
    close loop_aliado;
    deallocate loop_aliado;
  
    --Find TX whith previus failure (razon = 1) for GTECH
  
    declare loop_no_con cursor for select id_con_no_concilia_ali,
                               codentradaconciliaali,
                               codentradaconciliagtk,
                               T.codcon_control_proc,
                               codrazon_no_concilia,
                               campos_ok,
                               campos_fallo
                          from sfg_conciliacion.con_no_concilia_ali t,
                               SFG_CONCILIACION.ENTRADACONCILIAGTK,
                               WSXML_SFG.REGISTROFACTREFERENCIA     RFR,
                               WSXML_SFG.REGISTROFACTURACION        RF,
                               WSXML_SFG.PRODUCTO                   PR
                         where t.codrazon_no_concilia = 1
                           and t.codcon_control_proc <>
                               @V_ID_CON_CONTROL_PROC_OUT
                           and isnull(t.codentradaconciliaali, 0) = 0
                           and t.cod_ajuste is null
                           AND SFG_CONCILIACION.ENTRADACONCILIAGTK.ID_ENTRADACONCILIAGTK =
                               T.CODENTRADACONCILIAGTK
                           AND RFR.ID_REGISTROFACTREFERENCIA =
                               SFG_CONCILIACION.ENTRADACONCILIAGTK.CODREGISTROFACTREFERENCIA
                           AND RFR.CODREGISTROFACTURACION =
                               RF.ID_REGISTROFACTURACION
                           AND RF.CODPRODUCTO = PR.ID_PRODUCTO
                           AND PR.CODALIADOESTRATEGICO = 107
                         order by t.codcon_control_proc,
                                  t.id_con_no_concilia_ali; open loop_no_con;

declare @loop_no_con__id_con_no_concilia_ali numeric(38,0),
                               @loop_no_con__codentradaconciliaali numeric(38,0),
                               @loop_no_con__codentradaconciliagtk numeric(38,0),
                               @loop_no_con__codcon_control_proc numeric(38,0),
                               @loop_no_con__codrazon_no_concilia numeric(38,0),
                               @loop_no_con__campos_ok varchar(500),
                               @loop_no_con__campos_fallo varchar(500)

 fetch next from loop_no_con into @loop_no_con__id_con_no_concilia_ali,
                               @loop_no_con__codentradaconciliaali,
                               @loop_no_con__codentradaconciliagtk,
                               @loop_no_con__codcon_control_proc,
                               @loop_no_con__codrazon_no_concilia,
                               @loop_no_con__campos_ok,
                               @loop_no_con__campos_fallo;
 while @@fetch_status=0
 begin
    
      declare loop_no_con_gtk cursor for select id_entradaconciliagtk,
                                     codregistrofactreferencia,
                                     conciliado_con,
                                     bus_date,
                                     CAST(RCPT_NMR  AS NUMERIC(38,0)) AS RCPT_NMR,
                                     amount,
                                     answer_code,
                                     g.arrn,
                                     estado_concilia,
                                     conciliable,
                                     fecha_hora_trans,
                                     bus_date_modificado,
                                     codrazon_no_conciliable,
                                     estado_sc,
                                     tipotransaccion_sc,
                                     codcon_control_proc,
                                     g.id_entradaconciliagtk as fila
                                from sfg_conciliacion.entradaconciliagtk g,
                                     WSXML_SFG.REGISTROFACTREFERENCIA    RFR,
                                     WSXML_SFG.REGISTROFACTURACION       RF,
                                     WSXML_SFG.PRODUCTO                  PR
                               where g.id_entradaconciliagtk =
                                     @loop_no_con__codentradaconciliagtk
                                 and g.conciliado_con = 0
                                 and g.conciliable = 1
                                 and g.estado_concilia in (2, 3)
                                 AND RFR.ID_REGISTROFACTREFERENCIA =
                                     g.CODREGISTROFACTREFERENCIA
                                 AND RFR.CODREGISTROFACTURACION =
                                     RF.ID_REGISTROFACTURACION
                                 AND RF.CODPRODUCTO = PR.ID_PRODUCTO
                                 AND PR.CODALIADOESTRATEGICO = 107; open loop_no_con_gtk;

DECLARE @loop_no_con_gtk__id_entradaconciliagtk NUMERIC(38,0) ,
		@loop_no_con_gtk__codregistrofactreferencia NUMERIC(38,0),
		@loop_no_con_gtk__conciliado_con  NUMERIC(38,0),
		@loop_no_con_gtk__bus_date DATETIME,
		@loop_no_con_gtk__rcpt_nmr VARCHAR(100),
		@loop_no_con_gtk__amount  NUMERIC(38,0),
		@loop_no_con_gtk__answer_code VARCHAR(4),
		@loop_no_con_gtk__arrn VARCHAR(100),
		@loop_no_con_gtk__estado_concilia  NUMERIC(38,0),
		@loop_no_con_gtk__conciliable  NUMERIC(38,0),
		@loop_no_con_gtk__fecha_hora_trans DATETIME,
		@loop_no_con_gtk__bus_date_modificado DATETIME,
		@loop_no_con_gtk__codrazon_no_conciliable  NUMERIC(38,0),
		@loop_no_con_gtk__estado_sc VARCHAR(5),
		@loop_no_con_gtk__tipotransaccion_sc VARCHAR(5),
		@loop_no_con_gtk__codcon_control_proc   NUMERIC(38,0),
		@loop_no_con_gtk__fila  NUMERIC(38,0)


 fetch next from loop_no_con_gtk into @loop_no_con_gtk__id_entradaconciliagtk ,
		@loop_no_con_gtk__codregistrofactreferencia,
		@loop_no_con_gtk__conciliado_con ,
		@loop_no_con_gtk__bus_date,
		@loop_no_con_gtk__rcpt_nmr,
		@loop_no_con_gtk__amount ,
		@loop_no_con_gtk__answer_code,
		@loop_no_con_gtk__arrn,
		@loop_no_con_gtk__estado_concilia ,
		@loop_no_con_gtk__conciliable ,
		@loop_no_con_gtk__fecha_hora_trans,
		@loop_no_con_gtk__bus_date_modificado,
		@loop_no_con_gtk__codrazon_no_conciliable ,
		@loop_no_con_gtk__estado_sc,
		@loop_no_con_gtk__tipotransaccion_sc,
		@loop_no_con_gtk__codcon_control_proc  ,
		@loop_no_con_gtk__fila 
 while @@fetch_status=0
 begin
      
        SET @v_CAMPOS_NO_COINCIDE = '';
        SET @v_CAMPOS_SI_COINCIDE = '';
        SET @V_ESTADO_CONCILIA    = 2;
      
        --Paso 3 Valida la existencia del id de transaccion en la tabla de aliado
      
        select @v_CANTIDAD_TRAN_ALIADO = count(*)
          from SFG_CONCILIACION.ENTRADACONCILIAALI a
         where CAST(RCPT_NMR AS NUMERIC(38,0)) = @loop_no_con_gtk__rcpt_nmr
           and a.estado_concilia in (1, 2, 3)
           and a.bus_date = @loop_no_con_gtk__bus_date;
      
        -- Si encuentra una transaccion en la tabla de aliado entra.
        if @V_CANTIDAD_TRAN_ALIADO = 1 begin
        
          declare CUR_ALI3 cursor for select a.id_entradaconciliaali,
                                  a.bus_date,
                                  CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                                  a.amount,
                                  CAST(a.answer_code AS NUMERIC(38,0)) as answer_code,
                                  a.estado_concilia,
                                  a.CONF_MARK,
                                  a.CODPRODUCTO,
                                  a.id_entradaconciliaali as fila,
                                  REVERSAL
                             from SFG_CONCILIACION.ENTRADACONCILIAALI           a,
                                  SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS AA
                           
                            where CAST(RCPT_NMR AS NUMERIC(38,0)) =
                                  @loop_no_con_gtk__rcpt_nmr
                              and a.bus_date = @loop_no_con_gtk__bus_date
                              and a.conciliable = 1
                              AND AA.ID_CONTROL_ARCHIVOS_ALI =
                                  A.CODCONTROL_ARCHIVOS_ALI
                              AND AA.ID_CONF_ARCHIVOS = 2;
                           
 open CUR_ALI3;

 DECLARE @CUR_ALI3__id_entradaconciliaali NUMERIC(38,0) ,
				@CUR_ALI3__bus_date DATETIME,
				@CUR_ALI3__rcpt_nmr VARCHAR(100),

				@CUR_ALI3__amount  NUMERIC(38,0),
				@CUR_ALI3__answer_code VARCHAR(4),
				@CUR_ALI3__estado_concilia  NUMERIC(38,0),
				@CUR_ALI3__CONF_MARK VARCHAR(5),
				@CUR_ALI3__CODPRODUCTO  NUMERIC(38,0),
                                  
				@CUR_ALI3__fila  NUMERIC(38,0),
				@CUR_ALI3__REVERSAL  NUMERIC(38,0)


 fetch NEXT FROM  CUR_ALI3 into @CUR_ALI3__id_entradaconciliaali  ,
				@CUR_ALI3__bus_date,
				@CUR_ALI3__rcpt_nmr ,
				@CUR_ALI3__amount  ,
				@CUR_ALI3__answer_code,
				@CUR_ALI3__estado_concilia  ,
				@CUR_ALI3__CONF_MARK,
				@CUR_ALI3__CODPRODUCTO  ,               
				@CUR_ALI3__fila  ,
				@CUR_ALI3__REVERSAL  ;
 while @@fetch_status=0
 begin
          
            --Si la fecha de negocio coincide
            if @CUR_ALI3__BUS_DATE = @loop_no_con_gtk__bus_date begin
              SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                      'Si coincide Fecha Negocio : BUSINESS_DATE - ';
            end
            else begin
            
              SET @V_ESTADO_CONCILIA = 3;
              -- 3 Conciliado Parcial
            
              SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                      'No coincide Fecha Negocio : BUSINESS_DATE (GTK:' +
                                      isnull(FORMAT(@loop_no_con_gtk__bus_date,'dd/MM/yyyy'), '') +
                                      ' ALIADO:' +
                                      isnull(FORMAT(@CUR_ALI3__BUS_DATE,'dd/MM/yyyy'), '') + ') - ';
            
            end 
          
            --Si el monto coincide
            if @CUR_ALI3__AMOUNT = @loop_no_con_gtk__amount begin
              SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                      'Si coincide Monto Transaccion : AMOUNT - ';
            
            end
            else begin
              SET @V_ESTADO_CONCILIA = 3;
              -- 3 Conciliado Parcial
            
              SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                      'No coincide Monto Transaccion : AMOUNT (GTK:' +
                                      isnull(@loop_no_con_gtk__amount, '') + ' ALIADO:' +
                                      ISNULL(@CUR_ALI3__AMOUNT, '') + ') - ';
            end 
          
            --Si el Estado el Tipo Transaccion y Conf_Mark coinciden
          
            SET @v_EST_TP_TR_VS_CONF_MAR = SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR(
																	SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON(@CUR_ALI3__CODPRODUCTO),
                                                                    @loop_no_con_gtk__estado_sc,
                                                                    @loop_no_con_gtk__tipotransaccion_sc,
                                                                     @CUR_ALI3__CONF_MARK,
                                                                    @CUR_ALI3__ANSWER_CODE,
                                                                   @CUR_ALI3__REVERSAL)
          
            if @v_EST_TP_TR_VS_CONF_MAR = 1 begin
            
              SET @V_ESTADO_CONCILIA = 5;
            
              SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                      'Si coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK - ';
            
            end
            else begin
              SET @V_ESTADO_CONCILIA = 3;
              -- 3 Conciliado Parcial
            
              SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                      'No coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK (GTK: ' +
                                      isnull(@loop_no_con_gtk__estado_sc, '') + ' , ' +
                                      isnull(@loop_no_con_gtk__tipotransaccion_sc, '') +
                                      ' ALIADO: ' + ISNULL(@CUR_ALI3__CONF_MARK, '') +
                                      ') - ';
            
            end 
          
            --
          
            if @V_ESTADO_CONCILIA <> 5 begin
            
              update sfg_conciliacion.con_no_concilia_ali
                 set campos_ok             = @V_CAMPOS_SI_COINCIDE,
                     campos_fallo          = @V_CAMPOS_NO_COINCIDE,
                     codrazon_no_concilia  = 2,
                     codcon_control_proc   = @V_ID_CON_CONTROL_PROC_OUT,
                     codentradaconciliaali = @CUR_ALI3__ID_ENTRADACONCILIAALI
               where id_con_no_concilia_ali =
                     @loop_no_con__id_con_no_concilia_ali;
              commit;
            end
            else if @V_ESTADO_CONCILIA = 5 begin
            
              delete from sfg_conciliacion.con_no_concilia_ali
               where id_con_no_concilia_ali =
                     @loop_no_con__id_con_no_concilia_ali;
            
              delete from sfg_conciliacion.con_no_concilia_ali
               where codentradaconciliagtk =
                     @loop_no_con_gtk__id_entradaconciliagtk;
            
              delete from sfg_conciliacion.con_no_concilia_ali
               where codentradaconciliaali =
                     @CUR_ALI3__id_entradaconciliaali;
              commit;
            end 
          
            update SFG_CONCILIACION.ENTRADACONCILIAALI
               set estado_concilia     = @V_ESTADO_CONCILIA,
                   conciliado_con      = @loop_no_con_gtk__id_entradaconciliagtk,
                   codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
             where [ID_ENTRADACONCILIAALI] = @CUR_ALI3__FILA;
            commit;
            update SFG_CONCILIACION.ENTRADACONCILIAGTK
               set conciliado_con      = @CUR_ALI3__id_entradaconciliaali,
                   estado_concilia     = @V_ESTADO_CONCILIA,
                   codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
             where [ID_ENTRADACONCILIAGTK] = @loop_no_con_gtk__fila;
            commit;
 fetch NEXT FROM  CUR_ALI3 into @CUR_ALI3__id_entradaconciliaali  ,
				@CUR_ALI3__bus_date,
				@CUR_ALI3__rcpt_nmr ,
				@CUR_ALI3__amount  ,
				@CUR_ALI3__answer_code,
				@CUR_ALI3__estado_concilia  ,
				@CUR_ALI3__CONF_MARK,
				@CUR_ALI3__CODPRODUCTO  ,               
				@CUR_ALI3__fila  ,
				@CUR_ALI3__REVERSAL  ;
          end;
          close CUR_ALI3;
          deallocate CUR_ALI3;
        end 
      
      fetch next from loop_no_con_gtk into @loop_no_con_gtk__id_entradaconciliagtk ,
		@loop_no_con_gtk__codregistrofactreferencia,
		@loop_no_con_gtk__conciliado_con ,
		@loop_no_con_gtk__bus_date,
		@loop_no_con_gtk__rcpt_nmr,
		@loop_no_con_gtk__amount ,
		@loop_no_con_gtk__answer_code,
		@loop_no_con_gtk__arrn,
		@loop_no_con_gtk__estado_concilia ,
		@loop_no_con_gtk__conciliable ,
		@loop_no_con_gtk__fecha_hora_trans,
		@loop_no_con_gtk__bus_date_modificado,
		@loop_no_con_gtk__codrazon_no_conciliable ,
		@loop_no_con_gtk__estado_sc,
		@loop_no_con_gtk__tipotransaccion_sc,
		@loop_no_con_gtk__codcon_control_proc  ,
		@loop_no_con_gtk__fila 
      end;
      close loop_no_con_gtk;
      deallocate loop_no_con_gtk;
    
     fetch next from loop_no_con into @loop_no_con__id_con_no_concilia_ali,
                               @loop_no_con__codentradaconciliaali,
                               @loop_no_con__codentradaconciliagtk,
                               @loop_no_con__codcon_control_proc,
                               @loop_no_con__codrazon_no_concilia,
                               @loop_no_con__campos_ok,
                               @loop_no_con__campos_fallo;
    end;
    close loop_no_con;
    deallocate loop_no_con;
  
    --Find TX whith previus failure (razon = 1) for ALIADO
  
    declare loop_no_con2 cursor for select id_con_no_concilia_ali,
                                codentradaconciliaali,
                                codentradaconciliagtk,
                                t.codcon_control_proc,
                                codrazon_no_concilia,
                                campos_ok,
                                campos_fallo
                           from sfg_conciliacion.con_no_concilia_ali          t,
                                SFG_CONCILIACION.ENTRADACONCILIAALI           A,
                                SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS AA
                          where t.codrazon_no_concilia = 1
                            and t.codcon_control_proc <>
                                @V_ID_CON_CONTROL_PROC_OUT
                            and isnull(t.codentradaconciliagtk, 0) = 0
                            and t.cod_ajuste is null
                            AND T.CODENTRADACONCILIAALI =
                                A.ID_ENTRADACONCILIAALI
                            AND AA.ID_CONTROL_ARCHIVOS_ALI =
                                A.CODCONTROL_ARCHIVOS_ALI
                            AND AA.ID_CONF_ARCHIVOS = 2
                         
                          order by t.codcon_control_proc,
                                   t.id_con_no_concilia_ali; open loop_no_con2;

declare  @loop_no_con2__id_con_no_concilia_ali numeric(38,0),
                                @loop_no_con2__codentradaconciliaali numeric(38,0),
                                @loop_no_con2__codentradaconciliagtk numeric(38,0),
                                @loop_no_con2__codcon_control_proc numeric(38,0),
                                @loop_no_con2__codrazon_no_concilia numeric(38,0),
                                @loop_no_con2__campos_ok varchar(500),
                                @loop_no_con2__campos_fallo varchar(500)

 fetch next from  loop_no_con2 into @loop_no_con2__id_con_no_concilia_ali,
                                @loop_no_con2__codentradaconciliaali ,
                                @loop_no_con2__codentradaconciliagtk ,
                                @loop_no_con2__codcon_control_proc ,
                                @loop_no_con2__codrazon_no_concilia ,
                                @loop_no_con2__campos_ok ,
                                @loop_no_con2__campos_fallo;
 while @@fetch_status=0
 begin
    
      declare loop_no_con_ali cursor for select id_entradaconciliaali,
                                     codproducto,
                                     codcontrol_archivos_ali,
                                     conciliado_con,
                                     bus_date,
                                     CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                                     amount,
                                     answer_code,
                                     estado_concilia,
                                     bus_date_modificado,
                                     conf_mark,
                                     codcon_control_proc,
                                     a.id_entradaconciliaali as fila,
                                     REVERSAL
                                from SFG_CONCILIACION.ENTRADACONCILIAALI           a,
                                     SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS AA
                               where a.id_entradaconciliaali =
                                     @loop_no_con2__codentradaconciliaali
                                 and a.conciliado_con = 0
                                 and a.conciliable = 1
                                 and a.estado_concilia in (2, 3)
                                 AND AA.ID_CONTROL_ARCHIVOS_ALI =
                                     A.CODCONTROL_ARCHIVOS_ALI
                                 AND AA.ID_CONF_ARCHIVOS = 2; open loop_no_con_ali;

DECLARE @loop_no_con_ali__id_entradaconciliaali NUMERIC(38,0) ,
		@loop_no_con_ali__CODPRODUCTO  NUMERIC(38,0),
		@loop_no_con_ali__codcontrol_archivos_ali NUMERIC(38,0),
		@loop_no_con_ali__conciliado_con  NUMERIC(38,0),
        @loop_no_con_ali__bus_date DATETIME,
        @loop_no_con_ali__rcpt_nmr VARCHAR(100),
        @loop_no_con_ali__amount  NUMERIC(38,0),
        @loop_no_con_ali__answer_code VARCHAR(4),
        @loop_no_con_ali__estado_concilia  NUMERIC(38,0),
		@loop_no_con_ali__bus_date_modificado datetime,
        @loop_no_con_ali__CONF_MARK VARCHAR(5),    
		@loop_no_con_ali__codcon_control_proc NUMERIC(38,0),
        @loop_no_con_ali__fila  NUMERIC(38,0),
        @loop_no_con_ali__REVERSAL  NUMERIC(38,0)

 fetch NEXT FROM loop_no_con_ali into @loop_no_con_ali__id_entradaconciliaali  ,
		@loop_no_con_ali__CODPRODUCTO  ,
		@loop_no_con_ali__codcontrol_archivos_ali ,
		@loop_no_con_ali__conciliado_con  ,
        @loop_no_con_ali__bus_date,
        @loop_no_con_ali__rcpt_nmr,
        @loop_no_con_ali__amount  ,
        @loop_no_con_ali__answer_code,
        @loop_no_con_ali__estado_concilia  ,
		@loop_no_con_ali__bus_date_modificado,
        @loop_no_con_ali__CONF_MARK,    
		@loop_no_con_ali__codcon_control_proc ,
        @loop_no_con_ali__fila,
        @loop_no_con_ali__REVERSAL  
 while @@fetch_status=0
 begin
      
        SET @v_CAMPOS_NO_COINCIDE = '';
        SET @v_CAMPOS_SI_COINCIDE = '';
        SET @V_ESTADO_CONCILIA    = 2;
      
        --Paso 3 Valida la existencia del id de transaccion en la tabla de aliado
      
        select @V_CANTIDAD_TRAN_GTK = count(*)
          from SFG_CONCILIACION.Entradaconciliagtk a
         where CAST(RCPT_NMR AS NUMERIC(38,0)) = @loop_no_con_ali__rcpt_nmr
           and a.estado_concilia in (1, 2, 3)
           and a.conciliable = 1
           and a.bus_date = @loop_no_con_ali__bus_date;
      
        -- Si encuentra una transaccion en la tabla de aliado entra.
        if @V_CANTIDAD_TRAN_GTK = 1 begin
        
          declare CUR_gtk4 cursor for select id_entradaconciliagtk,
                                  codregistrofactreferencia,
                                  conciliado_con,
                                  bus_date,
                                  CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                                  amount,
                                  answer_code,
                                  GT.arrn,
                                  estado_concilia,
                                  conciliable,
                                  fecha_hora_trans,
                                  bus_date_modificado,
                                  codrazon_no_conciliable,
                                  estado_sc,
                                  tipotransaccion_sc,
                                  GT.id_entradaconciliagtk AS FILA
                             from sfg_conciliacion.entradaconciliagtk GT,
                                  WSXML_SFG.REGISTROFACTREFERENCIA    RFR,
                                  WSXML_SFG.REGISTROFACTURACION       RF,
                                  WSXML_SFG.PRODUCTO                  PR
                            where CAST(RCPT_NMR AS NUMERIC(38,0)) =
                                  @loop_no_con_ali__rcpt_nmr
                              and gt.conciliable = 1
                              and bus_date = @loop_no_con_ali__bus_date
                              AND RFR.ID_REGISTROFACTREFERENCIA =
                                  gt.CODREGISTROFACTREFERENCIA
                              AND RFR.CODREGISTROFACTURACION =
                                  RF.ID_REGISTROFACTURACION
                              AND RF.CODPRODUCTO = PR.ID_PRODUCTO
                              AND PR.CODALIADOESTRATEGICO = 107; open CUR_gtk4;

DECLARE @CUR_gtk4__id_entradaconciliagtk NUMERIC(38,0) ,
		@CUR_gtk4__codregistrofactreferencia NUMERIC(38,0),
		@CUR_gtk4__conciliado_con  NUMERIC(38,0),
		@CUR_gtk4__bus_date DATETIME,
		@CUR_gtk4__rcpt_nmr VARCHAR(100),
		@CUR_gtk4__amount  NUMERIC(38,0),
		@CUR_gtk4__answer_code VARCHAR(4),
		@CUR_gtk4__arrn VARCHAR(100),
		@CUR_gtk4__estado_concilia  NUMERIC(38,0),
		@CUR_gtk4__conciliable  NUMERIC(38,0),
		@CUR_gtk4__fecha_hora_trans DATETIME,
		@CUR_gtk4__bus_date_modificado DATETIME,
		@CUR_gtk4__codrazon_no_conciliable  NUMERIC(38,0),
		@CUR_gtk4__estado_sc VARCHAR(5),
		@CUR_gtk4__tipotransaccion_sc VARCHAR(5),
		@CUR_gtk4__fila  NUMERIC(38,0)


 fetch NEXT FROM CUR_gtk4 into @CUR_gtk4__id_entradaconciliagtk  ,
		@CUR_gtk4__codregistrofactreferencia ,
		@CUR_gtk4__conciliado_con  ,
		@CUR_gtk4__bus_date ,
		@CUR_gtk4__rcpt_nmr ,
		@CUR_gtk4__amount  ,
		@CUR_gtk4__answer_code,
		@CUR_gtk4__arrn ,
		@CUR_gtk4__estado_concilia  ,
		@CUR_gtk4__conciliable  ,
		@CUR_gtk4__fecha_hora_trans ,
		@CUR_gtk4__bus_date_modificado ,
		@CUR_gtk4__codrazon_no_conciliable  ,
		@CUR_gtk4__estado_sc ,
		@CUR_gtk4__tipotransaccion_sc ,
		@CUR_gtk4__fila  

 while @@fetch_status=0
 begin
          
            --Si la fecha de negocio coincide
            if @loop_no_con_ali__BUS_DATE = @CUR_gtk4__bus_date begin
              SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                      'Si coincide Fecha Negocio : BUSINESS_DATE - ';
            end
            else begin
            
              SET @V_ESTADO_CONCILIA = 3;
              -- 3 Conciliado Parcial
            
              SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                      'No coincide Fecha Negocio : BUSINESS_DATE (GTK:' +
                                      isnull(FORMAT(@loop_no_con_ali__bus_date,'dd/MM/yyyy'), '') +
                                      ' ALIADO:' +
                                      isnull(format(@CUR_gtk4__BUS_DATE,'dd/MM/yyyy'), '') + ') - ';
            
            end 
          
            --Si el monto coincide
            if @loop_no_con_ali__AMOUNT = @CUR_gtk4__amount begin
              SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                      'Si coincide Monto Transaccion : AMOUNT - ';
            
            end
            else begin
              SET @V_ESTADO_CONCILIA = 3;
              -- 3 Conciliado Parcial
            
              SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                      'No coincide Monto Transaccion : AMOUNT (GTK:' +
                                      isnull(@loop_no_con_ali__amount, '') + ' ALIADO:' +
                                      ISNULL(@CUR_gtk4__AMOUNT, '') + ') - ';
            end 
          
            --Si el Estado el Tipo Transaccion y Conf_Mark coinciden
          
            SET @v_EST_TP_TR_VS_CONF_MAR = SFG_CONCILIACION.CON_CONCILIA_VALIDA_EST_TP_TR_VS_CONF_MAR(SFG_CONCILIACION.CON_CONCILIA_OBT_ALIADO_FROM_PRODUCTO_CON(@loop_no_con_ali__CODPRODUCTO),
                                                                    @CUR_gtk4__estado_sc,
                                                                    @CUR_gtk4__tipotransaccion_sc,
                                                                    @loop_no_con_ali__CONF_MARK,
                                                                    @loop_no_con_ali__ANSWER_CODE,
                                                                     @loop_no_con_ali__REVERSAL);
          
            if @v_EST_TP_TR_VS_CONF_MAR = 1 begin
            
              SET @V_ESTADO_CONCILIA = 5;
            
              SET @v_CAMPOS_SI_COINCIDE = ISNULL(@V_CAMPOS_SI_COINCIDE, '') +
                                      'Si coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK - ';
            
            end
            else begin
              SET @V_ESTADO_CONCILIA = 3;
              -- 3 Conciliado Parcial
            
              SET @v_CAMPOS_NO_COINCIDE = ISNULL(@V_CAMPOS_NO_COINCIDE, '') +
                                      'No coincide el Estado y Tipo de Transaccion con la Marca de Confirmacion del Aliado : ESTADO, TIPO_TRANSACCION, CONF_MARK (GTK: ' +
                                      ISNULL(@CUR_gtk4__estado_sc, '') + ' , ' +
                                      ISNULL(@CUR_gtk4__tipotransaccion_sc, '') +
                                      ' ALIADO: ' +
                                      ISNULL(@loop_no_con_ali__CONF_MARK, '') + ') - ';
            
            end 
          
            --
          
            if @V_ESTADO_CONCILIA <> 5 begin
            
              update sfg_conciliacion.con_no_concilia_ali
                 set campos_ok             = @V_CAMPOS_SI_COINCIDE,
                     campos_fallo          = @V_CAMPOS_NO_COINCIDE,
                     codrazon_no_concilia  = 2,
                     codcon_control_proc   = @V_ID_CON_CONTROL_PROC_OUT,
                     codentradaconciliagtk = @CUR_gtk4__Id_Entradaconciliagtk
               where id_con_no_concilia_ali =
                     @loop_no_con2__id_con_no_concilia_ali;
              commit;
            end
            else if @V_ESTADO_CONCILIA = 5 begin
            
              delete from sfg_conciliacion.con_no_concilia_ali
               where id_con_no_concilia_ali =
                     @loop_no_con2__id_con_no_concilia_ali;
            
              delete from sfg_conciliacion.con_no_concilia_ali
               where codentradaconciliagtk =
                     @CUR_gtk4__id_entradaconciliagtk;
            
              delete from sfg_conciliacion.con_no_concilia_ali
               where codentradaconciliaali =
                     @loop_no_con_ali__id_entradaconciliaali;
              commit;
            end 
          
            update SFG_CONCILIACION.ENTRADACONCILIAALI 
               set estado_concilia     = @V_ESTADO_CONCILIA,
                   conciliado_con      = @CUR_gtk4__id_entradaconciliagtk,
                   codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
             where [ID_ENTRADACONCILIAALI] = @loop_no_con_ali__FILA;
          
            update SFG_CONCILIACION.ENTRADACONCILIAGTK 
               set conciliado_con      = @loop_no_con_ali__id_entradaconciliaali,
                   estado_concilia     = @V_ESTADO_CONCILIA,
                   codcon_control_proc = @V_ID_CON_CONTROL_PROC_OUT
             where [ID_ENTRADACONCILIAGTK] = @CUR_gtk4__fila;
            commit;
           fetch NEXT FROM CUR_gtk4 into @CUR_gtk4__id_entradaconciliagtk  ,
		@CUR_gtk4__codregistrofactreferencia ,
		@CUR_gtk4__conciliado_con  ,
		@CUR_gtk4__bus_date ,
		@CUR_gtk4__rcpt_nmr ,
		@CUR_gtk4__amount  ,
		@CUR_gtk4__answer_code,
		@CUR_gtk4__arrn ,
		@CUR_gtk4__estado_concilia  ,
		@CUR_gtk4__conciliable  ,
		@CUR_gtk4__fecha_hora_trans ,
		@CUR_gtk4__bus_date_modificado ,
		@CUR_gtk4__codrazon_no_conciliable  ,
		@CUR_gtk4__estado_sc ,
		@CUR_gtk4__tipotransaccion_sc ,
		@CUR_gtk4__fila  
          end;
          close CUR_gtk4;
          deallocate CUR_gtk4;
        end 
      
       fetch NEXT FROM loop_no_con_ali into @loop_no_con_ali__id_entradaconciliaali  ,
		@loop_no_con_ali__CODPRODUCTO  ,
		@loop_no_con_ali__codcontrol_archivos_ali ,
		@loop_no_con_ali__conciliado_con  ,
        @loop_no_con_ali__bus_date,
        @loop_no_con_ali__rcpt_nmr,
        @loop_no_con_ali__amount  ,
        @loop_no_con_ali__answer_code,
        @loop_no_con_ali__estado_concilia  ,
		@loop_no_con_ali__bus_date_modificado,
        @loop_no_con_ali__CONF_MARK,    
		@loop_no_con_ali__codcon_control_proc ,
        @loop_no_con_ali__fila,
        @loop_no_con_ali__REVERSAL  
      end;
      close loop_no_con_ali;
      deallocate loop_no_con_ali;
    
    fetch next from  loop_no_con2 into @loop_no_con2__id_con_no_concilia_ali,
                                @loop_no_con2__codentradaconciliaali ,
                                @loop_no_con2__codentradaconciliagtk ,
                                @loop_no_con2__codcon_control_proc ,
                                @loop_no_con2__codrazon_no_concilia ,
                                @loop_no_con2__campos_ok ,
                                @loop_no_con2__campos_fallo;
    end;
    close loop_no_con2;
    deallocate loop_no_con2;
  
    declare Borr_dup cursor for select t1.[ID_CON_NO_CONCILIA_ALI] as fila
                       from sfg_conciliacion.con_no_concilia_ali t1,
                            sfg_conciliacion.con_no_concilia_ali t2
                      where t1.codentradaconciliaali =
                            t2.codentradaconciliaali
                        and t1.id_con_no_concilia_ali <>
                            t2.id_con_no_concilia_ali
                        and t1.codrazon_no_concilia = 1
                        and t2.codrazon_no_concilia = 2; open Borr_dup;
DECLARE @Borr_dup__fila NUMERIC(38,0)
 fetch NEXT FROM  Borr_dup into @Borr_dup__fila;
 while @@fetch_status=0
 begin
    
      delete from sfg_conciliacion.con_no_concilia_ali
       where [ID_CON_NO_CONCILIA_ALI] = @Borr_dup__fila
      commit;
     fetch NEXT FROM  Borr_dup into @Borr_dup__fila;
    end;
    close Borr_dup;
    deallocate Borr_dup;
  
    begin
    
      declare cur_nc cursor for select ali.[ID_ENTRADACONCILIAALI] as fila_ali, nc.[ID_CON_NO_CONCILIA_ALI] as fila_nc
                       from sfg_conciliacion.entradaconciliaali  ali,
                            sfg_conciliacion.con_no_concilia_ali nc,
                            sfg_conciliacion.entradaconciliaciti cit
                      where nc.codrazon_no_concilia = 1
                        and nc.codentradaconciliaali =
                            ali.id_entradaconciliaali
                        and ali.answer_code = 0
                        and ali.conf_mark = 'VACIO'
                        and ali.id_entradaconciliaali =
                            cit.codentradaconciliaali
                        and cit.cit_03_revs = 1
                        and cit.cit_03_revs_value > 0; open cur_nc;

DECLARE @cur_nc__fila_ali NUMERIC(38,0), @cur_nc__fila_nc  NUMERIC(38,0)
 fetch NEXT FROM cur_nc into @cur_nc__fila_ali, @cur_nc__fila_nc 
 while @@fetch_status=0
 begin
      
        update sfg_conciliacion.entradaconciliaali
           set conciliable     = 0,
               estado_concilia = 1,
               conciliado_con  = null
         where [ID_ENTRADACONCILIAALI] = @cur_nc__fila_ali;
      
        delete from sfg_conciliacion.con_no_concilia_ali
         where [ID_CON_NO_CONCILIA_ALI] = @cur_nc__fila_nc;
        commit;
       fetch NEXT FROM cur_nc into @cur_nc__fila_ali, @cur_nc__fila_nc 
      end;
      close cur_nc;
      deallocate cur_nc;
    
    end;
  
    /*
    cturriago
    14-Abr-2010
    En atencion a su solicitud,  referente a la posibilidad de disminuir
    el numero de diferencias detectadas por el programa de conciliacion, para
    los casos en los que los registros con estado de transaccion en el archivo de
    GTECH es R (Transaccion Rechazada), o es C (Transaccion Rechazada desde el SAF),
    y en el archivo del aliado no existe la transaccion; les confirmo que se llevara
    a cabo el cambio, el cual consiste en marcarlos como no conciliables.
    */
    begin
    
      declare tm cursor for SELECT CNC.ID_CON_NO_CONCILIA_ALI AS FILA_CNC, GTK.[ID_ENTRADACONCILIAGTK] AS FILA_GTK
                   FROM SFG_CONCILIACION.CON_NO_CONCILIA_ALI CNC
                  INNER JOIN SFG_CONCILIACION.ENTRADACONCILIAGTK GTK
                     ON CNC.CODENTRADACONCILIAGTK =
                        GTK.ID_ENTRADACONCILIAGTK
                  INNER JOIN SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS
                     ON GTK.BUS_DATE =
                        SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS.FECHA_ARCHIVO
                  INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA RFR
                     ON GTK.CODREGISTROFACTREFERENCIA =
                        RFR.ID_REGISTROFACTREFERENCIA
                  INNER JOIN WSXML_SFG.REGISTROFACTURACION RF
                     ON RFR.CODREGISTROFACTURACION =
                        RF.ID_REGISTROFACTURACION
                  INNER JOIN WSXML_SFG.PRODUCTO PR
                     ON RF.CODPRODUCTO = PR.ID_PRODUCTO
                  WHERE (CNC.CODRAZON_NO_CONCILIA = 1)
                    AND (CNC.COD_AJUSTE IS NULL)
                    AND (GTK.ESTADO_SC IN ('R', 'C'))
                    AND (PR.CODALIADOESTRATEGICO = 107); open tm;

DECLARE @tm__FILA_CNC NUMERIC(38,0), @tm__FILA_GTK  NUMERIC(38,0)

 fetch NEXT FROM tm into @tm__FILA_CNC, @tm__FILA_GTK ;
 while @@fetch_status=0
 begin
      
        delete from SFG_CONCILIACION.CON_NO_CONCILIA_ALI
         where [ID_CON_NO_CONCILIA_ALI] = @TM__FILA_CNC;
      
        UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
           SET CONCILIABLE = 0
         WHERE [ID_ENTRADACONCILIAGTK] = @TM__FILA_GTK;
        commit;
       fetch NEXT FROM tm into @tm__FILA_CNC, @tm__FILA_GTK ;
      end;
      close tm;
      deallocate tm;
    
    end;
  
    SET @v_mensaje_err = 'Ejecucion sin novedades';
  
    update sfg_conciliacion.con_control_proc_concil
       set fecha_hora_fin = getdate(),
           mensaje        = @v_mensaje_err,
           codestadotarea = 3
     where id_con_control_proc = @V_ID_CON_CONTROL_PROC_OUT;
  END TRY
  BEGIN CATCH
  
    
      SET @v_mensaje_err = ERROR_MESSAGE ( ) ;
    
      update sfg_conciliacion.con_control_proc_concil
         set fecha_hora_fin = getdate(),
             mensaje        = @v_mensaje_err,
             codestadotarea = 4
       where id_con_control_proc = @V_ID_CON_CONTROL_PROC_OUT;
    END CATCH
  END;
GO



IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_CITIBANK', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_CITIBANK;
GO

  
  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_CITIBANK AS
 BEGIN
  
    DECLARE @V_MENSAJE_ERR                VARCHAR(4000) = '';
    DECLARE @V_ID_CON_CONTROL_CITI_OUT    NUMERIC(22,0);
    DECLARE @V_CAT_PROCESSA               NUMERIC(22,0);
    DECLARE @V_FLAG_PAR                   NUMERIC(22,0);
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @MaxFileLoad                  datetime;
    DECLARE @contador_tarea               NUMERIC(22,0);
    DECLARE @v_incrementador              NUMERIC(22,0) = 1;
    DECLARE @v_vr_for                     NUMERIC(22,0) = 0;
	DECLARE @FECHAHOY DATETIME = GETDATE()
   
  SET NOCOUNT ON;
	
    EXEC SFG_CONCILIACION.SFGCONCIWEBCON_CONTROL_PROC_CO_ADDRECORD
															@FECHAHOY,
                                                               NULL,
                                                              1,
                                                              'Citibank',
                                                              1,
                                                              @V_MENSAJE_ERR,
                                                              @V_ID_CON_CONTROL_CITI_OUT OUT
  
    COMMIT;
  END
  GO


    
IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PROCESSA', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PROCESSA;
GO


  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PROCESSA AS
 BEGIN
  
    DECLARE @V_MENSAJE_ERR                VARCHAR(4000) = '';
    DECLARE @V_ID_CON_CONTROL_PROC_OUT    NUMERIC(22,0);
    DECLARE @V_CAT_PROCESSA               NUMERIC(22,0);
    DECLARE @V_FLAG_PAR                   NUMERIC(22,0);
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @MaxFileLoad                  datetime;
    DECLARE @contador_tarea               NUMERIC(22,0);
    DECLARE @v_incrementador              NUMERIC(22,0) = 1;
    DECLARE @v_vr_for                     NUMERIC(22,0) = 0;
	DECLARE @FECHAHOY DATETIME = GETDATE();
   
  SET NOCOUNT ON;
  
    EXEC SFG_CONCILIACION.SFGCONCIWEBCON_CONTROL_PROC_CO_ADDRECORD 
												@FECHAHOY,
                                                NULL,
                                                1,
                                                       'Processa',
                                                          1,
                                                    @V_MENSAJE_ERR,
                                                      @V_ID_CON_CONTROL_PROC_OUT OUT
  
    COMMIT;
  
  END
  GO


  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_EMCALI', 'P') IS NOT NULL
  DROP PROCEDURE "SFG_CONCILIACION".CON_CONCILIA_CONCILIA_ALIADO_EMCALI;
GO


  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_EMCALI AS
 BEGIN
  
    DECLARE @V_MENSAJE_ERR                VARCHAR(4000) = '';
    DECLARE @V_ID_CON_CONTROL_PROC_OUT    NUMERIC(22,0);
    DECLARE @V_CAT_EMCALI                 NUMERIC(22,0);
    DECLARE @V_FLAG_PAR                   NUMERIC(22,0);
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @MaxFileLoad                  datetime;
    DECLARE @contador_tarea               NUMERIC(22,0);
    DECLARE @v_incrementador              NUMERIC(22,0) = 1;
    DECLARE @FECHAHOY DATETIME = GETDATE()
   
  SET NOCOUNT ON;
  
    EXEC SFG_CONCILIACION.SFGCONCIWEBCON_CONTROL_PROC_CO_ADDRECORD		
									@FECHAHOY,
                                    NULL,
                                    1,
                                    'EMCALI',
                                    1,
                                    @V_MENSAJE_ERR,
                                    @V_ID_CON_CONTROL_PROC_OUT OUT
  
    --SOLO CONCILIA SI EL ULTIMO ARCHIVO ESTA CARGADO
  
    SELECT @MAXFILELOAD = MAX(CA.FECHA_ARCHIVO)
      FROM SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS CA
     WHERE CA.ID_CONF_ARCHIVOS = 4;
  
    if @MaxFileLoad >= convert(datetime, convert(date,getdate() - 1)) begin
    
      --CONCILIA DESDE GTK HACIA EMCALI
    
      DECLARE CUR_GTK CURSOR FOR SELECT /*+RULE */
                       ID_ENTRADACONCILIAGTK,
                       CODREGISTROFACTREFERENCIA,
                       CONVERT(DATETIME, CONVERT(DATE,(FECHA_HORA_TRANS))) as BUS_DATE,
                       CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                       AMOUNT,
                       CAST(ANSWER_CODE AS NUMERIC(38,0)) AS ANSWER_CODE,
                       ENTRADACONCILIAGTK.ARRN,
                       ESTADO_SC,
                       TIPOTRANSACCION_SC,
                       null as TRANS_CODE,
                       [ID_ENTRADACONCILIAGTK] AS FILA_GTK,
                       RFR.SUSCRIPTOR
                        FROM SFG_CONCILIACION.ENTRADACONCILIAGTK,
                             WSXML_SFG.REGISTROFACTREFERENCIA RFR
                       WHERE RFR.ID_REGISTROFACTREFERENCIA =
                             codregistrofactreferencia
                         AND (ESTADO_CONCILIA = 1)
--                         AND (ESTADO_CONCILIA = 2)
--                         AND TRUNC(FECHA_HORA_TRANS)>='15/FEB/2015'
                         AND (CONCILIABLE = 1)
                         AND ENTRADACONCILIAGTK.CODALIADOESTRATEGICO = 1050; OPEN CUR_GTK;

			DECLARE @cur_gtk__ID_ENTRADACONCILIAGTK NUMERIC(38,0),
                           @cur_gtk__CODREGISTROFACTREFERENCIA NUMERIC(38,0),
                           @cur_gtk__BUS_DATE DATETIME,
                           @cur_gtk__RCPT_NMR  NUMERIC(38,0),
                           @cur_gtk__AMOUNT  NUMERIC(38,0),
                           @cur_gtk__ANSWER_CODE NUMERIC(38,0),
                           @cur_gtk__ARRN VARCHAR(100),
                           @cur_gtk__estado_sc VARCHAR(5),
                           @cur_gtk__tipotransaccion_sc VARCHAR(5),
						   @cur_gtk__TRANS_CODE NUMERIC(38,0),
                           @cur_gtk__FILA_GTK  NUMERIC(38,0),
						   @cur_gtk__SUSCRIPTOR VARCHAR(50)

		 FETCH NEXT FROM CUR_GTK INTO  @cur_gtk__ID_ENTRADACONCILIAGTK ,
                           @cur_gtk__CODREGISTROFACTREFERENCIA ,
                           @cur_gtk__BUS_DATE,
                           @cur_gtk__RCPT_NMR  ,
                           @cur_gtk__AMOUNT  ,
                           @cur_gtk__ANSWER_CODE ,
                           @cur_gtk__ARRN,
                           @cur_gtk__estado_sc,
                           @cur_gtk__tipotransaccion_sc,
						   @cur_gtk__TRANS_CODE ,
                           @cur_gtk__FILA_GTK  ,
						   @cur_gtk__SUSCRIPTOR
		 WHILE @@FETCH_STATUS=0
		 BEGIN
      
			SET @V_FLAG_PAR = 0;
      
			DECLARE CUR_ALI CURSOR FOR SELECT ALI.ID_ENTRADACONCILIAALI, ALI.ID_ENTRADACONCILIAALI AS FILA_ALI
                          FROM SFG_CONCILIACION.ENTRADACONCILIAEMCALI EMCALI,
                               SFG_CONCILIACION.ENTRADACONCILIAALI    ALI
                         WHERE ALI.ID_ENTRADACONCILIAALI =
                               EMCALI.CODENTRADACONCILIAALI
                              --AND ALI.CONCILIABLE = 1
                           AND ISNULL(ALI.CONCILIADO_CON, 0) = 0
                           AND ALI.ESTADO_CONCILIA in (1, 2)
                           AND CONVERT(DATETIME, CONVERT(DATE,ALI.bus_date)) = @cur_gtk__BUS_DATE
                           AND CAST(EMCALI.REFERENCIA AS NUMERIC(38,0)) =
                               CAST(@cur_gtk__SUSCRIPTOR  AS NUMERIC(38,0))
                           AND CAST(EMCALI.EXT_02_TRANS_VALUE  AS NUMERIC(38,0)) =
                               CAST(@cur_gtk__AMOUNT  AS NUMERIC(38,0))
                           --AND; 
						   OPEN CUR_ALI;
					DECLARE @CUR_ALI_ID_ENTRADACONCILIAALI NUMERIC(38,0), @CUR_ALI_FILA_ALI NUMERIC(38,0)
					FETCH CUR_ALI INTO @CUR_ALI_ID_ENTRADACONCILIAALI, @CUR_ALI_FILA_ALI
					WHILE @@FETCH_STATUS=0
					BEGIN
        
						SET @V_FLAG_PAR = 1;
        
						UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
							SET CONCILIADO_CON      = @CUR_ALI_ID_ENTRADACONCILIAALI,
								ESTADO_CONCILIA     = 5,
								CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
						WHERE [ID_ENTRADACONCILIAGTK] = @cur_gtk__FILA_GTK;
        
						UPDATE SFG_CONCILIACION.ENTRADACONCILIAALI
							SET CONCILIADO_CON      = @cur_gtk__ID_ENTRADACONCILIAGTK,
								ESTADO_CONCILIA     = 5,
								CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
						WHERE [ID_ENTRADACONCILIAALI] = @CUR_ALI_FILA_ALI;
						commit;
						FETCH CUR_ALI INTO @CUR_ALI_ID_ENTRADACONCILIAALI, @CUR_ALI_FILA_ALI
					END;
					CLOSE CUR_ALI;
					DEALLOCATE CUR_ALI;
      
					IF @V_FLAG_PAR = 0 BEGIN
        
					  UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
						 SET CONCILIADO_CON      = 0,
							 ESTADO_CONCILIA     = 2,
							 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
					   WHERE [ID_ENTRADACONCILIAGTK] = @cur_gtk__FILA_GTK;
        
					  EXEC SFG_CONCILIACION.SFGCONCIWEBCON_NO_CONCILIA_ALI_ADDRECORD
																					NULL,
																				@cur_gtk__ID_ENTRADACONCILIAGTK,
																				@V_ID_CON_CONTROL_PROC_OUT,
																				1,
																				NULL,
																				NULL,
																				NULL,
																				@V_ID_CON_NO_CONCILIA_ALI_OUT OUT
        
					END 
      

				 FETCH NEXT FROM CUR_GTK INTO  @cur_gtk__ID_ENTRADACONCILIAGTK ,
								   @cur_gtk__CODREGISTROFACTREFERENCIA ,
								   @cur_gtk__BUS_DATE,
								   @cur_gtk__RCPT_NMR  ,
								   @cur_gtk__AMOUNT  ,
								   @cur_gtk__ANSWER_CODE ,
								   @cur_gtk__ARRN,
								   @cur_gtk__estado_sc,
								   @cur_gtk__tipotransaccion_sc,
								   @cur_gtk__TRANS_CODE ,
								   @cur_gtk__FILA_GTK  ,
								   @cur_gtk__SUSCRIPTOR
		  END;
		  CLOSE CUR_GTK;
		  DEALLOCATE CUR_GTK;
		END
	END
GO
IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_VIRGIN', 'P') IS NOT NULL
  DROP PROCEDURE "SFG_CONCILIACION".CON_CONCILIA_CONCILIA_ALIADO_VIRGIN;
GO


  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_VIRGIN AS
 BEGIN
  
    DECLARE @V_MENSAJE_ERR                VARCHAR(4000) = '';
    DECLARE @V_ID_CON_CONTROL_PROC_OUT    NUMERIC(22,0);
    DECLARE @V_CAT_EMCALI                 NUMERIC(22,0);
    DECLARE @V_FLAG_PAR                   NUMERIC(22,0);
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @MaxFileLoad                  datetime;
    DECLARE @contador_tarea               NUMERIC(22,0);
    DECLARE @v_incrementador              NUMERIC(22,0) = 1;
	DECLARE @FECHAHOY DATETIME = GETDATE()
   
  SET NOCOUNT ON;
  
    EXEC SFG_CONCILIACION.SFGCONCIWEBCON_CONTROL_PROC_CO_ADDRECORD	
																@FECHAHOY,
                                                              NULL,
                                                              1,
                                                              'VIRGIN',
                                                              1,
                                                              @V_MENSAJE_ERR,
                                                              @V_ID_CON_CONTROL_PROC_OUT OUT
  
    --SOLO CONCILIA SI EL ULTIMO ARCHIVO ESTA CARGADO
  
    SELECT @MAXFILELOAD = MAX(CA.FECHA_ARCHIVO)
      FROM SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS CA
     WHERE CA.ID_CONF_ARCHIVOS = 5;
  
    if @MaxFileLoad >= convert(datetime, convert(date,getdate() - 1)) begin
    
      --CONCILIA DESDE GTK HACIA VIRGIN
    
      DECLARE CUR_GTK CURSOR FOR SELECT 
                       ID_ENTRADACONCILIAGTK,
                       CODREGISTROFACTREFERENCIA,
                       CONVERT(DATETIME, CONVERT(DATE,FECHA_HORA_TRANS)) as BUS_DATE,
                       CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                       AMOUNT,
                       CAST(ANSWER_CODE AS NUMERIC(38,0)) AS ANSWER_CODE,
                       ENTRADACONCILIAGTK.ARRN,
                       ESTADO_SC,
                       TIPOTRANSACCION_SC,
                       NULL AS TRANS_CODE,
                       ENTRADACONCILIAGTK.ID_ENTRADACONCILIAGTK AS FILA_GTK
					   
                        FROM SFG_CONCILIACION.ENTRADACONCILIAGTK
                       WHERE ESTADO_CONCILIA = 1
                         AND CONCILIABLE = 1
                         AND CODALIADOESTRATEGICO = 915--ISNULL(915, UID ); 
						 OPEN CUR_GTK;

				DECLARE @cur_gtk__ID_ENTRADACONCILIAGTK NUMERIC(38,0),
                           @cur_gtk__CODREGISTROFACTREFERENCIA NUMERIC(38,0),
                           @cur_gtk__BUS_DATE DATETIME,
                           @cur_gtk__RCPT_NMR  NUMERIC(38,0),
                           @cur_gtk__AMOUNT  NUMERIC(38,0),
                           @cur_gtk__ANSWER_CODE NUMERIC(38,0),
                           @cur_gtk__ARRN VARCHAR(100),
                           @cur_gtk__estado_sc VARCHAR(5),
                           @cur_gtk__tipotransaccion_sc VARCHAR(5),
						   @cur_gtk__TRANS_CODE NUMERIC(38,0),
                           @cur_gtk__FILA_GTK  NUMERIC(38,0)


		 FETCH NEXT FROM CUR_GTK INTO  @cur_gtk__ID_ENTRADACONCILIAGTK ,
                           @cur_gtk__CODREGISTROFACTREFERENCIA ,
                           @cur_gtk__BUS_DATE,
                           @cur_gtk__RCPT_NMR  ,
                           @cur_gtk__AMOUNT  ,
                           @cur_gtk__ANSWER_CODE ,
                           @cur_gtk__ARRN,
                           @cur_gtk__estado_sc,
                           @cur_gtk__tipotransaccion_sc,
						   @cur_gtk__TRANS_CODE ,
                           @cur_gtk__FILA_GTK  




		 WHILE @@FETCH_STATUS=0
		 BEGIN
      
					SET @V_FLAG_PAR = 0;
      
					DECLARE CUR_ALI CURSOR FOR SELECT /*+ FIRST_ROWS(1) */
									 ALI.ID_ENTRADACONCILIAALI, ALI.ID_ENTRADACONCILIAALI AS FILA_ALI
									  FROM SFG_CONCILIACION.ENTRADACONCILIAVIRGIN VIRGIN,
										   SFG_CONCILIACION.ENTRADACONCILIAALI    ALI
									 WHERE ALI.ID_ENTRADACONCILIAALI =
										   VIRGIN.CODENTRADACONCILIAALI
										  --AND ALI.CONCILIABLE = 1
									   AND ISNULL(ALI.CONCILIADO_CON, 0) = 0
									   AND ALI.ESTADO_CONCILIA IN (1, 2)
									   AND CONVERT(DATETIME, CONVERT(DATE,ALI.bus_date)) = @cur_gtk__BUS_DATE
									   AND CAST(VIRGIN.EXT_ID_TRANSACTION AS NUMERIC(38,0)) =
										   CAST(@cur_gtk__RCPT_NMR AS NUMERIC(38,0))
									   AND CAST(VIRGIN.EXT_MONTO  AS NUMERIC(38,0)) =
										   CAST(@cur_gtk__AMOUNT  AS NUMERIC(38,0)); 
								OPEN CUR_ALI;
								DECLARE   @CUR_ALI_ID_ENTRADACONCILIAALI NUMERIC(38,0), @CUR_ALI_FILA_ALI  NUMERIC(38,0)
						 FETCH NEXT FROM CUR_ALI INTO @CUR_ALI_ID_ENTRADACONCILIAALI, @CUR_ALI_FILA_ALI ;
						 WHILE @@FETCH_STATUS=0
						 BEGIN
        
						  SET @V_FLAG_PAR = 1;
        
						  UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
							 SET CONCILIADO_CON      = @CUR_ALI_ID_ENTRADACONCILIAALI,
								 ESTADO_CONCILIA     = 5,
								 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
						   WHERE [ID_ENTRADACONCILIAGTK] = @cur_gtk__FILA_GTK;
        
						  UPDATE SFG_CONCILIACION.ENTRADACONCILIAALI
							 SET CONCILIADO_CON      = @cur_gtk__ID_ENTRADACONCILIAGTK,
								 ESTADO_CONCILIA     = 5,
								 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
						   WHERE [ID_ENTRADACONCILIAALI] = @CUR_ALI_FILA_ALI;
						  commit;
						 FETCH NEXT FROM CUR_ALI INTO @CUR_ALI_ID_ENTRADACONCILIAALI, @CUR_ALI_FILA_ALI ;
						END;
						CLOSE CUR_ALI;
						DEALLOCATE CUR_ALI;
      
					IF @V_FLAG_PAR = 0 BEGIN
        
					  UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
						 SET CONCILIADO_CON      = 0,
							 ESTADO_CONCILIA     = 2,
							 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
					   WHERE [ID_ENTRADACONCILIAGTK] = @cur_gtk__FILA_GTK;
        
					  EXEC SFG_CONCILIACION.SFGCONCIWEBCON_NO_CONCILIA_ALI_ADDRECORD
																NULL,
																@cur_gtk__ID_ENTRADACONCILIAGTK,
																@V_ID_CON_CONTROL_PROC_OUT,
																1,
																NULL,
																NULL,
																NULL,
																@V_ID_CON_NO_CONCILIA_ALI_OUT OUT
        
						END 
      
		   FETCH NEXT FROM CUR_GTK INTO  @cur_gtk__ID_ENTRADACONCILIAGTK ,
                           @cur_gtk__CODREGISTROFACTREFERENCIA ,
                           @cur_gtk__BUS_DATE,
                           @cur_gtk__RCPT_NMR  ,
                           @cur_gtk__AMOUNT  ,
                           @cur_gtk__ANSWER_CODE ,
                           @cur_gtk__ARRN,
                           @cur_gtk__estado_sc,
                           @cur_gtk__tipotransaccion_sc,
						   @cur_gtk__TRANS_CODE ,
                           @cur_gtk__FILA_GTK 
		  END;
		  CLOSE CUR_GTK;
		  DEALLOCATE CUR_GTK;
    
     
    END 
  
  END

GO

  
IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PAGONLINE', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PAGONLINE;
GO


  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PAGONLINE AS
 BEGIN
  
    DECLARE @V_MENSAJE_ERR                VARCHAR(4000) = '';
    DECLARE @V_ID_CON_CONTROL_PROC_OUT    NUMERIC(22,0);
    DECLARE @V_CAT_PONLINE                NUMERIC(22,0);
    DECLARE @V_FLAG_PAR                   NUMERIC(22,0);
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @MaxFileLoad                  datetime;
    DECLARE @contador_tarea               NUMERIC(22,0);
    DECLARE @v_incrementador              NUMERIC(22,0) = 1;
	DECLARE @FECHAHOY DATETIME = GETDATE()
   
  SET NOCOUNT ON;
  
    EXEC SFG_CONCILIACION.SFGCONCIWEBCON_CONTROL_PROC_CO_ADDRECORD	
	
																@FECHAHOY,
                                                              NULL,
                                                              1,
                                                              'Pagos On Line',
                                                              1,
                                                              @V_MENSAJE_ERR,
                                                              @V_ID_CON_CONTROL_PROC_OUT OUT
  
    --SOLO CONCILIA SI EL ULTIMO ARCHIVO ESTA CARGADO
  
    SELECT @MAXFILELOAD = MAX(CA.FECHA_ARCHIVO)
      FROM SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS CA
     WHERE CA.ID_CONF_ARCHIVOS = 6;
  
    if @MaxFileLoad >= convert(datetime, convert(date,getdate() - 1)) begin
    
      --CONCILIA DESDE GTK HACIA PAGOS ON LINE
    
      DECLARE CUR_GTK CURSOR FOR SELECT /*+RULE */
                       ID_ENTRADACONCILIAGTK,
                       CODREGISTROFACTREFERENCIA,
                       CONVERT(DATETIME,CONVERT(DATE,FECHA_HORA_TRANS)) as BUS_DATE,
                       CONVERT(DATETIME, CONVERT(DATE,RCPT_NMR)) AS RCPT_NMR,
                       AMOUNT,
                       CAST(ANSWER_CODE AS NUMERIC(38,0)) AS ANSWER_CODE,
                       ENTRADACONCILIAGTK.ARRN,
                       ESTADO_SC,
                       TIPOTRANSACCION_SC,
                       null as TRANS_CODE,
                       ENTRADACONCILIAGTK.[ID_ENTRADACONCILIAGTK] AS FILA_GTK
                        FROM SFG_CONCILIACION.ENTRADACONCILIAGTK
                       WHERE (ESTADO_CONCILIA = 1)
                         AND (CONCILIABLE = 1)
                         AND ENTRADACONCILIAGTK.CODALIADOESTRATEGICO = 247; OPEN CUR_GTK;


		DECLARE @cur_gtk__ID_ENTRADACONCILIAGTK NUMERIC(38,0),
                           @cur_gtk__CODREGISTROFACTREFERENCIA NUMERIC(38,0),
                           @cur_gtk__BUS_DATE DATETIME,
                           @cur_gtk__RCPT_NMR  NUMERIC(38,0),
                           @cur_gtk__AMOUNT  NUMERIC(38,0),
                           @cur_gtk__ANSWER_CODE NUMERIC(38,0),
                           @cur_gtk__ARRN VARCHAR(100),
                           @cur_gtk__estado_sc VARCHAR(5),
                           @cur_gtk__tipotransaccion_sc VARCHAR(5),
						   @cur_gtk__TRANS_CODE NUMERIC(38,0),
                           @cur_gtk__FILA_GTK  NUMERIC(38,0)
 
		fetch NEXT FROM  cur_gtk into
								@cur_gtk__ID_ENTRADACONCILIAGTK,
							   @cur_gtk__CODREGISTROFACTREFERENCIA,
							   @cur_gtk__BUS_DATE,
							   @cur_gtk__RCPT_NMR,
							   @cur_gtk__AMOUNT,
							   @cur_gtk__ANSWER_CODE,
							   @cur_gtk__ARRN,
							   @cur_gtk__estado_sc,
							   @cur_gtk__tipotransaccion_sc,
							    @cur_gtk__TRANS_CODE,
							   @cur_gtk__FILA_GTK

		 WHILE @@FETCH_STATUS=0
		 BEGIN
      
				SET @V_FLAG_PAR = 0;
      
				DECLARE CUR_ALI CURSOR FOR SELECT /*+ RULE */
								 --ALI.*, 
								 ALI.ID_ENTRADACONCILIAALI,
								 ALI.ID_ENTRADACONCILIAALI AS FILA_ALI
								  FROM SFG_CONCILIACION.ENTRADACONCILIAPAGONLINE PONLINE,
									   SFG_CONCILIACION.ENTRADACONCILIAALI       ALI
								 WHERE ALI.ID_ENTRADACONCILIAALI =
									   PONLINE.CODENTRADACONCILIAALI
								   AND ALI.CONCILIABLE = 1
								   AND ISNULL(ALI.CONCILIADO_CON, 0) = 0
								   AND ALI.ESTADO_CONCILIA in (1, 2)
								   AND ALI.bus_date = @cur_gtk__BUS_DATE
								   AND CAST(PONLINE.EXT_02_RECEIPT  AS NUMERIC(38,0)) =
									   @cur_gtk__RCPT_NMR
								   AND CAST(PONLINE.EXT_02_VALOR AS NUMERIC(38,0)) =
									   CAST(@cur_gtk__AMOUNT  AS NUMERIC(38,0)); OPEN CUR_ALI;
		DECLARE @CUR_ALI__ID_ENTRADACONCILIAALI NUMERIC(38,0), @CUR_ALI__FILA_ALI NUMERIC(38,0)

		 FETCH CUR_ALI INTO @CUR_ALI__ID_ENTRADACONCILIAALI, @CUR_ALI__FILA_ALI;
		 WHILE @@FETCH_STATUS=0
		 BEGIN
        
				  SET @V_FLAG_PAR = 1;
        
				  UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
					 SET CONCILIADO_CON      = @CUR_ALI__ID_ENTRADACONCILIAALI,
						 ESTADO_CONCILIA     = 5,
						 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
				   WHERE [ID_ENTRADACONCILIAGTK] = @cur_gtk__FILA_GTK;
        
				  UPDATE SFG_CONCILIACION.ENTRADACONCILIAALI
					 SET CONCILIADO_CON      = @cur_gtk__ID_ENTRADACONCILIAGTK,
						 ESTADO_CONCILIA     = 5,
						 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
				   WHERE [ID_ENTRADACONCILIAALI] = @CUR_ALI__FILA_ALI;
				  commit;
			FETCH CUR_ALI INTO @CUR_ALI__ID_ENTRADACONCILIAALI, @CUR_ALI__FILA_ALI;
			END;
			CLOSE CUR_ALI;
			DEALLOCATE CUR_ALI;
      
				IF @V_FLAG_PAR = 0 BEGIN
        
				  UPDATE SFG_CONCILIACION.ENTRADACONCILIAGTK
					 SET CONCILIADO_CON      = 0,
						 ESTADO_CONCILIA     = 2,
						 CODCON_CONTROL_PROC = @V_ID_CON_CONTROL_PROC_OUT
				   WHERE [ID_ENTRADACONCILIAGTK] = @cur_gtk__FILA_GTK;
        
				  EXEC SFG_CONCILIACION.SFGCONCIWEBCON_NO_CONCILIA_ALI_ADDRECORD
															NULL,
															@cur_gtk__ID_ENTRADACONCILIAGTK,
															@V_ID_CON_CONTROL_PROC_OUT,
															1,
															NULL,
															NULL,
															NULL,
															@V_ID_CON_NO_CONCILIA_ALI_OUT OUT
        
				END 
      
		fetch NEXT FROM  cur_gtk into
								@cur_gtk__ID_ENTRADACONCILIAGTK,
							   @cur_gtk__CODREGISTROFACTREFERENCIA,
							   @cur_gtk__BUS_DATE,
							   @cur_gtk__RCPT_NMR,
							   @cur_gtk__AMOUNT,
							   @cur_gtk__ANSWER_CODE,
							   @cur_gtk__ARRN,
							   @cur_gtk__estado_sc,
							   @cur_gtk__tipotransaccion_sc,
							    @cur_gtk__TRANS_CODE,
							   @cur_gtk__FILA_GTK
		END;
		CLOSE CUR_GTK;
		DEALLOCATE CUR_GTK;
    
     
    
    END 
  
  END
GO


IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO;
GO



  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO AS
 BEGIN
  
    DECLARE @V_ID_CON_NO_CONCILIA_ALI_OUT NUMERIC(22,0);
    DECLARE @V_ID_CON_CONTROL_PROC_OUT    NUMERIC(22,0);
    DECLARE @V_CANTIDAD_TRAN_ALIADO       NUMERIC(22,0);
    DECLARE @V_CANTIDAD_TRAN_GTK          NUMERIC(22,0);
    DECLARE @V_ESTADO_TRANSA_ALI          NUMERIC(22,0);
    DECLARE @V_CANTIDAD_BUS_DATE_ALIADO   NUMERIC(22,0);
    DECLARE @V_CAMPOS_NO_COINCIDE         VARCHAR(2000);
    DECLARE @V_CAMPOS_SI_COINCIDE         VARCHAR(2000);
    DECLARE @v_EST_TP_TR_VS_CONF_MAR      NUMERIC(22,0);
    DECLARE @V_ESTADO_CONCILIA            NUMERIC(22,0) = 2; --INICIALIZA LA VARIABLE COMO NO CONCILIADO
    DECLARE @v_mensaje_err                varchar(4000) = '';
    DECLARE @v_listaactualizaciongtk      SFG_CONCILIACION.CONCILIAREGISTRO; /* Lista para actualizacion de registros */
    DECLARE @v_listaactualizacionali      SFG_CONCILIACION.CONCILIAREGISTRO; /* Lista para actualizacion de registros */
    DECLARE @FECHAHOY DATETIME = GETDATE()
  SET NOCOUNT ON;
    --SET @v_listaactualizaciongtk = CONCILIAREGISTROLIST();
   -- SET @v_listaactualizacionali = CONCILIAREGISTROLIST();
  
    --Paso 1 Crear el registro del proceso de conciliacion
  
    EXEC sfg_conciliacion.sfgconciwebcon_control_proc_co_addrecord
															@FECHAHOY,
                                                              null,
                                                              1,
                                                              'Externa',
                                                              1,
                                                              @v_mensaje_err,
                                                              @V_ID_CON_CONTROL_PROC_OUT OUT
  
    --paso2 Tomar los registros por conciliar la tabla sfg_conciliacion.entradaconciliagtk y recorrer el aliado CITI
  
    declare cur_gtk cursor for SELECT ID_ENTRADACONCILIAGTK,
                           CODREGISTROFACTREFERENCIA,
                           BUS_DATE,
                           CAST(RCPT_NMR AS NUMERIC(38,0)) AS RCPT_NMR,
                           AMOUNT,
                           CAST(ANSWER_CODE AS NUMERIC) as ANSWER_CODE,
                           ARRN,
                           estado_sc,
                           tipotransaccion_sc,
                           ROW_NUMBER() OVER(ORDER BY ID_ENTRADACONCILIAGTK ASC)  AS FILA
                      FROM SFG_CONCILIACION.ENTRADACONCILIAGTK
                     WHERE (ESTADO_CONCILIA = 1)
                       AND (CONCILIABLE = 1);
                    --                   and rcpt_nmr = 8773309
	 open cur_gtk;

	 DECLARE @cur_gtk__ID_ENTRADACONCILIAGTK NUMERIC(38,0),
                           @cur_gtk__CODREGISTROFACTREFERENCIA NUMERIC(38,0),
                           @cur_gtk__BUS_DATE DATETIME,
                           @cur_gtk__RCPT_NMR  NUMERIC(38,0),
                           @cur_gtk__AMOUNT  NUMERIC(38,0),
                           @cur_gtk__ANSWER_CODE NUMERIC(38,0),
                           @cur_gtk__ARRN VARCHAR(100),
                           @cur_gtk__estado_sc VARCHAR(5),
                           @cur_gtk__tipotransaccion_sc VARCHAR(5),
                           @cur_gtk__FILA  NUMERIC(38,0)
 
		fetch NEXT FROM  cur_gtk into
								@cur_gtk__ID_ENTRADACONCILIAGTK,
							   @cur_gtk__CODREGISTROFACTREFERENCIA,
							   @cur_gtk__BUS_DATE,
							   @cur_gtk__RCPT_NMR,
							   @cur_gtk__AMOUNT,
							   @cur_gtk__ANSWER_CODE,
							   @cur_gtk__ARRN,
							   @cur_gtk__estado_sc,
							   @cur_gtk__tipotransaccion_sc,
							   @cur_gtk__FILA

		 while @@fetch_status=0
				 begin
    
				  SET @v_CAMPOS_NO_COINCIDE = '';
				  SET @v_CAMPOS_SI_COINCIDE = '';
				  SET @V_ESTADO_CONCILIA    = 2;
    
				  --Paso 3 Valida la existencia del id de transaccion en la tabla de aliado
    
				  select @v_CANTIDAD_TRAN_ALIADO = count(*)
					from SFG_CONCILIACION.ENTRADACONCILIAALI a
				   where CAST(a.rcpt_nmr AS NUMERIC(38,0)) = @cur_gtk__rcpt_nmr
					 and a.estado_concilia = 1;
				  -- Si encuentra una transaccion en la tabla de aliado entra.
				  if @V_CANTIDAD_TRAN_ALIADO >= 1 begin
      
					select @v_CANTIDAD_TRAN_ALIADO = count(*)
					  from SFG_CONCILIACION.ENTRADACONCILIAALI a
					 where CAST(a.rcpt_nmr AS NUMERIC(38,0)) = @cur_gtk__rcpt_nmr
					   and a.estado_concilia = 1
					   and a.bus_date = @cur_gtk__bus_date;
      
					if @V_CANTIDAD_TRAN_ALIADO > 1 begin
        
          
					  INSERT INTO @v_listaactualizaciongtk VALUES (@cur_gtk__ID_ENTRADACONCILIAGTK, 0,2, @V_ID_CON_CONTROL_PROC_OUT);
					  /*update SFG_CONCILIACION.ENTRADACONCILIAGTK g
						set g.conciliado_con      = 0,
							g.estado_concilia     = 2,
							g.codcon_control_proc = v_ID_CON_CONTROL_PROC_out
					  where g.rowid = @cur_gtk__fila;*/
        
					  DECLARE REPETIDOS_ALI CURSOR FOR SELECT G.ID_ENTRADACONCILIAALI,
												   ROW_NUMBER() OVER(ORDER BY ID_ENTRADACONCILIAALI ASC) AS FILA
											  FROM SFG_CONCILIACION.ENTRADACONCILIAALI G
											 WHERE CAST(G.RCPT_NMR AS NUMERIC(38,0)) =
												   @cur_gtk__RCPT_NMR; OPEN REPETIDOS_ALI;

							DECLARE @REPETIDOS_ALI__ID_ENTRADACONCILIAALI NUMERIC(38,0), @REPETIDOS_ALI__FILA NUMERIC(38,0)

						 FETCH REPETIDOS_ALI INTO  @REPETIDOS_ALI__ID_ENTRADACONCILIAALI, @REPETIDOS_ALI__FILA
						 WHILE @@FETCH_STATUS=0
						 BEGIN
									-- Call the procedure
									EXEC sfg_conciliacion.sfgconciwebcon_no_concilia_ali_addrecord
																				@REPETIDOS_ALI__ID_ENTRADACONCILIAALI,
																				@cur_gtk__id_entradaconciliagtk,
																				@V_ID_CON_CONTROL_PROC_OUT,
																				3,
																				@V_CAMPOS_SI_COINCIDE,
																				@V_CAMPOS_NO_COINCIDE,
																				null,
																				@V_ID_CON_NO_CONCILIA_ALI_OUT OUT
          
           
								INSERT INTO @v_listaactualizacionali VALUES (@REPETIDOS_ALI__ID_ENTRADACONCILIAALI, 0, 2, @V_ID_CON_CONTROL_PROC_OUT);
								/*update SFG_CONCILIACION.ENTRADACONCILIAALI g
								  set g.conciliado_con      = 0,
									  g.estado_concilia     = 2,
									  g.codcon_control_proc = v_ID_CON_CONTROL_PROC_out
								where g.rowid = @REPETIDOS_ALI__FILA;*/
          
						  FETCH REPETIDOS_ALI INTO  @REPETIDOS_ALI__ID_ENTRADACONCILIAALI, @REPETIDOS_ALI__FILA
						  END;
						  CLOSE REPETIDOS_ALI;
						  DEALLOCATE REPETIDOS_ALI;
        
					end
        
				 end

				 fetch NEXT FROM  cur_gtk into
										@cur_gtk__ID_ENTRADACONCILIAGTK,
									   @cur_gtk__CODREGISTROFACTREFERENCIA,
									   @cur_gtk__BUS_DATE,
									   @cur_gtk__RCPT_NMR,
									   @cur_gtk__AMOUNT,
									   @cur_gtk__ANSWER_CODE,
									   @cur_gtk__ARRN,
									   @cur_gtk__estado_sc,
									   @cur_gtk__tipotransaccion_sc,
									   @cur_gtk__FILA
				end;
				close cur_gtk;
				deallocate cur_gtk;
  
		--Conciliacion desde Aliado hacia GTK
  
    
    end;
  

GO


IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PATCH_DUP_VALS', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PATCH_DUP_VALS;
GO

CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PATCH_DUP_VALS AS
  
    /*Registros de ALIADO que esten en la tabla CON_NO_CONCILIA_ALI y que coincida el SPRN_Y_BUS_DATE con GTK*/
  begin
  set nocount on;
  

    
      declare tm cursor for SELECT cnc.[ID_CON_NO_CONCILIA_ALI]    AS fila_cnc,
                        ali.[ID_ENTRADACONCILIAALI]    AS fila_ali,
                        gtk.[ID_ENTRADACONCILIAGTK]    AS fila_gtk,
                        gtk.RCPT_NMR
                   FROM SFG_CONCILIACION.ENTRADACONCILIAALI ali
                  INNER JOIN SFG_CONCILIACION.ENTRADACONCILIAGTK gtk
                     ON ali.SPRN_Y_BUS_DATE = gtk.SPRN_Y_BUS_DATE
                  INNER JOIN SFG_CONCILIACION.CON_NO_CONCILIA_ALI cnc
                     ON ali.ID_ENTRADACONCILIAALI =
                        cnc.CODENTRADACONCILIAALI
                  WHERE /*(cnc.CODRAZON_NO_CONCILIA = 1)
   																																																																																																																																																																																																																																																																																																																																																							AND*/
							(cnc.COD_AJUSTE IS NULL)
						and ali.conciliable = 1
						and gtk.conciliable = 1
						and cnc.id_con_no_concilia_ali not in
							(select a.COD_NO_CONCILIA
								from sfg_conciliacion.con_ajuste a); open tm;

		DECLARE @tm__fila_cnc numeric(38,0),
                        @tm__fila_ali numeric(38,0),
                        @tm__fila_gtk numeric(38,0),
                        @tm__RCPT_NMR VARCHAR(100)

		
		 fetch NEXT FROM tm into @tm__fila_cnc,
								@tm__fila_ali,
								@tm__fila_gtk,
								@tm__RCPT_NMR;
		 while @@fetch_status=0
		 begin
				begin
					BEGIN TRY
						  update sfg_conciliacion.entradaconciliagtk
							 set estado_concilia       = 1,
								 conciliado_con        = null,
								 codcon_control_proc   = null,
								 CODRAZON_NO_CONCILIABLE = null
						   where [ID_ENTRADACONCILIAGTK] = @tm__fila_gtk;
        
						  update sfg_conciliacion.entradaconciliaali
							 set estado_concilia     = 1,
								 conciliado_con      = null,
								 codcon_control_proc = null
						   where [ID_ENTRADACONCILIAALI] = @tm__fila_ali;
        
						  delete from SFG_CONCILIACION.CON_NO_CONCILIA_ALI
						   where [ID_CON_NO_CONCILIA_ALI] = @tm__fila_cnc;
						  commit;
					END TRY
					BEGIN CATCH
						SELECT NULL
					END CATCH
            
				end;
			  fetch NEXT FROM tm into @tm__fila_cnc,
								@tm__fila_ali,
								@tm__fila_gtk,
								@tm__RCPT_NMR;
		end;
		close tm;
		deallocate tm;
    
    end;
  
  

GO


  


     IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_ASIGNA_BUS_DATE_DE_CALENDAR', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_ASIGNA_BUS_DATE_DE_CALENDAR;
GO


  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_ASIGNA_BUS_DATE_DE_CALENDAR(@P_FECHA_HORA_TRANS DATETIME) RETURNS DATETIME AS
 BEGIN
  
    DECLARE @V_FECHA_NEGOCIO    DATETIME;
    DECLARE @V_CUT_OFF          DATETIME;
    DECLARE @FECHA_HORA_TRANS   datetime;
    DECLARE @ES_DIA_CONCILIABLE NUMERIC(22,0);
	DECLARE @RESULT DATETIME;
  
	DECLARE 	
                @con_True						SMALLINT,
				@con_False						SMALLINT,
				@con_Fecha_Negocio				SMALLINT,
				@con_Identificador_Gtech		SMALLINT,
				@con_Monto_Negocio				SMALLINT,
				@con_Codigo_Respuesta_Aliado	SMALLINT,
				@con_No_Requerido				SMALLINT,
				@con_Codigo_Producto			SMALLINT,
				@con_Vacio						VARCHAR(6),
				@C_CODDETALLETAREAEJECUTADA		SMALLINT

	EXEC SFG_CONCILIACION.CON_CONCILIA_CONSTANT
                @con_True						OUT,
				@con_False						OUT,
				@con_Fecha_Negocio				OUT,
				@con_Identificador_Gtech		OUT,
				@con_Monto_Negocio				OUT,
				@con_Codigo_Respuesta_Aliado	OUT,
				@con_No_Requerido				OUT,
				@con_Codigo_Producto			OUT,
				@con_Vacio						OUT,
				@C_CODDETALLETAREAEJECUTADA		OUT
  
    SET @V_CUT_OFF = CONVERT(DATETIME, CONVERT(DATE,@P_FECHA_HORA_TRANS)) + 0.8125;
  
    if @P_FECHA_HORA_TRANS > @V_CUT_OFF begin
      SET @FECHA_HORA_TRANS = convert(datetime, convert(date,@P_FECHA_HORA_TRANS)) + 1;
    end
    else begin
      SET @FECHA_HORA_TRANS = convert(datetime, convert(date,@P_FECHA_HORA_TRANS));
    end 
  
    SELECT @ES_DIA_CONCILIABLE = CG.EJECUTA_CONCILIAICION
      FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CG
     WHERE CG.FECHA_CALENDARIO = @FECHA_HORA_TRANS;
  
    IF @ES_DIA_CONCILIABLE = @con_False BEGIN
    
      SET @RESULT =  SFG_CONCILIACION.CON_CONCILIA_ASIGNA_BUS_DATE_DE_CALENDAR(@FECHA_HORA_TRANS + 1);
    
    END
    ELSE IF @ES_DIA_CONCILIABLE = @con_True BEGIN
    
      SET @RESULT =  @FECHA_HORA_TRANS;
    
    END 
  
	  IF @@ROWCOUNT = 0
      RETURN NULL;

	RETURN @RESULT;
    
  END;

  GO


IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_FECHA_ARCHIVO_SC', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_FECHA_ARCHIVO_SC;
GO



  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_FECHA_ARCHIVO_SC(@P_ID_REGISTROFACTURACION NUMERIC(22,0)) RETURNS DATETIME AS
 BEGIN
    DECLARE @V_FECHA_ARCHIVO DATETIME;
   
    SELECT @V_FECHA_ARCHIVO = AC.FECHAARCHIVO
      FROM WSXML_SFG.REGISTROFACTURACION   RF,
           WSXML_SFG.ENTRADAARCHIVOCONTROL AC
     WHERE RF.CODENTRADAARCHIVOCONTROL = AC.ID_ENTRADAARCHIVOCONTROL
       AND RF.ID_REGISTROFACTURACION = @P_ID_REGISTROFACTURACION;
    RETURN @V_FECHA_ARCHIVO;

  END;
GO


IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_VALIDA_PRODUCTO_CONCILIABLE', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_VALIDA_PRODUCTO_CONCILIABLE;
GO


CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_VALIDA_PRODUCTO_CONCILIABLE(@P_CODREGISTROFACTURACION NUMERIC(22,0))
    RETURNS NUMERIC(22,0) AS
 BEGIN
  
    DECLARE @V_CANT_MAPEO      NUMERIC(22,0) = 0;
    DECLARE @V_ID_PRODUCTO_SFG NUMERIC(22,0);
   
    SELECT @V_ID_PRODUCTO_SFG = RF.CODPRODUCTO
      FROM WSXML_SFG.REGISTROFACTURACION RF
     WHERE RF.ID_REGISTROFACTURACION = @P_CODREGISTROFACTURACION;
    SELECT @V_CANT_MAPEO = COUNT(*)
      FROM WSXML_SFG.PRODUCTO P, SFG_CONCILIACION.CON_CONF_ARCHIVOS C
     WHERE P.ID_PRODUCTO = @V_ID_PRODUCTO_SFG
       AND P.CODALIADOESTRATEGICO = C.ID_ALIADOESTRATEGICO
       AND C.ACTIVO = 1;
  
    IF @V_CANT_MAPEO = 0 BEGIN
      RETURN @V_CANT_MAPEO;
    END
    ELSE BEGIN
    
      RETURN 1;
    
    END 
    RETURN NULL;
  END;

GO

IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_VALIDA_ESTADO_TIPOTRANSACCION', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_VALIDA_ESTADO_TIPOTRANSACCION;
GO

  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_VALIDA_ESTADO_TIPOTRANSACCION(@P_ESTADO                  VARCHAR(4000),
                                          @P_TIPOTRANS               VARCHAR(4000),
                                          @P_CODREGISTROFACTURACION  NUMERIC(22,0),
                                          @P_ISOERR                  VARCHAR(4000),
                                          @P_OBJETIVO_CONCILIACION   NUMERIC(22,0) OUT,
                                          @P_CODRAZON_NO_CONCILIABLE NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @V_CODALIADOESTRATEGICO NUMERIC(22,0);
   
  SET NOCOUNT ON;

  	DECLARE 	
                @con_True						SMALLINT,
				@con_False						SMALLINT,
				@con_Fecha_Negocio				SMALLINT,
				@con_Identificador_Gtech		SMALLINT,
				@con_Monto_Negocio				SMALLINT,
				@con_Codigo_Respuesta_Aliado	SMALLINT,
				@con_No_Requerido				SMALLINT,
				@con_Codigo_Producto			SMALLINT,
				@con_Vacio						VARCHAR(6),
				@C_CODDETALLETAREAEJECUTADA		SMALLINT

	EXEC SFG_CONCILIACION.CON_CONCILIA_CONSTANT
                @con_True						OUT,
				@con_False						OUT,
				@con_Fecha_Negocio				OUT,
				@con_Identificador_Gtech		OUT,
				@con_Monto_Negocio				OUT,
				@con_Codigo_Respuesta_Aliado	OUT,
				@con_No_Requerido				OUT,
				@con_Codigo_Producto			OUT,
				@con_Vacio						OUT,
				@C_CODDETALLETAREAEJECUTADA		OUT


    SELECT @V_CODALIADOESTRATEGICO = P.CODALIADOESTRATEGICO
      FROM WSXML_SFG.REGISTROFACTURACION RF, WSXML_SFG.PRODUCTO P
     WHERE RF.CODPRODUCTO = P.ID_PRODUCTO
       AND RF.ID_REGISTROFACTURACION = @P_CODREGISTROFACTURACION;
    SELECT @P_OBJETIVO_CONCILIACION = ET.OBJETIVO_CONCILIACION, @P_CODRAZON_NO_CONCILIABLE = ET.CODRAZON_NO_CONCILIABLE
      FROM SFG_CONCILIACION.CON_EST_TPTRANS_ALIADO ET
     WHERE ET.ESTADO_SERV_COM = @P_ESTADO
       AND ET.TPTRANS_SERV_COM = ISNULL(@P_TIPOTRANS, @con_Vacio)
       AND ET.COD_ALIADOESTRATEGICO = @V_CODALIADOESTRATEGICO;
  
    IF @P_OBJETIVO_CONCILIACION = 1 AND @V_CODALIADOESTRATEGICO = 708 BEGIN
      IF @P_ISOERR IN ('94', '95') BEGIN
        SET @P_OBJETIVO_CONCILIACION   = 0;
        SET @P_CODRAZON_NO_CONCILIABLE = 6;
        SET @P_OBJETIVO_CONCILIACION   = 0;
      END 
    
    END 
  END;
GO


IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_CARGA_ARCHIVO_AUTOMATICO', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CARGA_ARCHIVO_AUTOMATICO;
GO


  CREATE PROCEDURE SFG_CONCILIACION.CON_CONCILIA_CARGA_ARCHIVO_AUTOMATICO AS
 BEGIN
  
    DECLARE @ES_DIA_CONCILIABLE    NUMERIC(22,0);
    DECLARE @ES_DIA_DE_ARCHIVO     NUMERIC(22,0);
    DECLARE @ULT_FECHA_CARGADA_ORI DATETIME;
    DECLARE @ULT_FECHA_CARGADA     DATETIME;
  
   
  SET NOCOUNT ON;
  
    SELECT @ES_DIA_CONCILIABLE = CG.EJECUTA_CONCILIAICION
      FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CG
     WHERE CG.FECHA_CALENDARIO = CONVERT(DATETIME, CONVERT(DATE,GETDATE()));
  
    IF @ES_DIA_CONCILIABLE = 1 BEGIN
    
      SELECT @ULT_FECHA_CARGADA_ORI = MAX(FECHA_ARCHIVO)
        FROM SFG_CONCILIACION.CON_CONTROL_ARCHIVOS_ALIADOS AA;
    
      SET @ULT_FECHA_CARGADA = @ULT_FECHA_CARGADA_ORI;
    
      INILOOP:
    
      SET @ULT_FECHA_CARGADA = CONVERT(DATETIME, CONVERT(DATE,@ULT_FECHA_CARGADA)) + 1;
    
      IF CONVERT(DATETIME, CONVERT(DATE,GETDATE())) > @ULT_FECHA_CARGADA BEGIN
      
        SELECT @ES_DIA_DE_ARCHIVO = CG.EJECUTA_CONCILIAICION
          FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL CG
         WHERE CG.FECHA_CALENDARIO = @ULT_FECHA_CARGADA;
      
        IF @ES_DIA_DE_ARCHIVO = 0 BEGIN
          GOTO INILOOP;
        END
        ELSE IF @ES_DIA_DE_ARCHIVO = 1
          BEGIN
			BEGIN TRY
					-- CALL THE PROCEDURE
					--SFG_CONCILIACION.CON_CONCILIA.LOAD_DATA_ALIADO(P_FECHA_PROCESAR => ULT_FECHA_CARGADA);
          
					-- CALL THE PROCEDURE
					EXEC SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO;
          
					EXEC SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO_PATCH_DUP_VALS;
          
					EXEC SFG_CONCILIACION.CON_CONCILIA_CONCILIA_ALIADO;
          
					COMMIT;
			END TRY
			BEGIN CATCH
					  ROLLBACK;
			END CATCH
          END;
        
        
      END 
    END 
 END  
 GO


 IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_EvaluaRespuestaLoad', 'FN') IS NOT NULL
  DROP FUNCTION SFG_CONCILIACION.CON_CONCILIA_EvaluaRespuestaLoad;
GO




  CREATE FUNCTION SFG_CONCILIACION.CON_CONCILIA_EvaluaRespuestaLoad(@p_RETVALUE_CITI   NUMERIC(22,0),
                               @p_RETVALUE_PROC   NUMERIC(22,0),
                               @p_RETVALUE_EMCALI NUMERIC(22,0),
                               @p_RETVALUE_PAGOS  NUMERIC(22,0),
                               @p_RETVALUE_VIRGIN NUMERIC(22,0)) returns NUMERIC(22,0) as
  
  BEGIN
    /*
    1 REGISTRADA
    2 INICIADA
    3 FINALIZADA OK
    4 FINALIZADA FALLO
    5 ABORTADA
    6 NO INICIADA
    7 FINALIZADA ADVERTENCIA
    */
  
    IF @p_RETVALUE_CITI > @p_RETVALUE_PROC AND
       @p_RETVALUE_CITI > @p_RETVALUE_EMCALI AND
       @p_RETVALUE_CITI > @p_RETVALUE_PAGOS AND
       @p_RETVALUE_CITI > @p_RETVALUE_VIRGIN BEGIN
    
      RETURN @p_RETVALUE_CITI;
    
    END
    ELSE IF @p_RETVALUE_PROC > @p_RETVALUE_CITI AND
          @p_RETVALUE_PROC > @p_RETVALUE_EMCALI AND
          @p_RETVALUE_PROC > @p_RETVALUE_PAGOS AND
          @p_RETVALUE_PROC > @p_RETVALUE_VIRGIN BEGIN
    
      RETURN @p_RETVALUE_PROC;
    
    END
    ELSE IF @p_RETVALUE_EMCALI > @p_RETVALUE_CITI AND
          @p_RETVALUE_EMCALI > @p_RETVALUE_PROC AND
          @p_RETVALUE_EMCALI > @p_RETVALUE_PAGOS AND
          @p_RETVALUE_EMCALI > @p_RETVALUE_VIRGIN BEGIN
    
      RETURN @p_RETVALUE_EMCALI;
    
    END
    ELSE IF @p_RETVALUE_VIRGIN > @p_RETVALUE_CITI AND
          @p_RETVALUE_VIRGIN > @p_RETVALUE_PROC AND
          @p_RETVALUE_VIRGIN > @p_RETVALUE_PAGOS AND
          @p_RETVALUE_VIRGIN > @p_RETVALUE_EMCALI BEGIN
    
      RETURN @p_RETVALUE_VIRGIN;
    
    END
    ELSE BEGIN
    
      RETURN @p_RETVALUE_PAGOS;
    
    END 
    RETURN NULL;
  
END
go




