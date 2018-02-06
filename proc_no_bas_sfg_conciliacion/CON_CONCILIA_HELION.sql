USE SFGPRODU;
--------------------------------------------------------
--  DDL for Package Body CON_CONCILIA_HELION
--------------------------------------------------------

  /* PACKAGE BODY SFG_CONCILIACION.CON_CONCILIA_HELION */ 

  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_HELION_VALIDA_APLICACION_RETIRO_H', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_HELION_VALIDA_APLICACION_RETIRO_H;
GO

CREATE     PROCEDURE SFG_CONCILIACION.CON_CONCILIA_HELION_VALIDA_APLICACION_RETIRO_H(@ID_RETIROS_A_VALIDAR VARCHAR(4000),
                                       @p_RETURNVALUE_out    NUMERIC(22,0) OUT) AS
 BEGIN
    --DECLARE @con_no_concilia_ret_cur CURSOR;
    --con_no_concilia_ret_record sfg_conciliacion.con_no_concilia_ret%ROWTYPE;
    DECLARE @szSqlParams                varchar(2000);
    DECLARE @SzInstruction2             varchar(2000);
    DECLARE @Cantidad_Conciden          NUMERIC(22,0);
    DECLARE @ValorHelion                NUMERIC(22,0);
    DECLARE @Mensaje_SFGALERTA8000      varchar(2000);
    DECLARE @Mensaje_SFGALERTA          varchar(2000);
    DECLARE @PDVGTECH                   varchar(255);
  
	BEGIN TRY
  
		--p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAOK;
		--p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAADVERTENCIA;
		--p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAFALLO;
  
		SET @szSqlParams = @ID_RETIROS_A_VALIDAR;

		DECLARE @p_REGISTRADA      			TINYINT,
						@p_INICIADA         		TINYINT,
						@p_FINALIZADAOK 			TINYINT,
						@p_FINALIZADAFALLO  		TINYINT,
						@p_ABORTADA  				TINYINT,
						@p_NOINICIADA  				TINYINT,
						@p_FINALIZADAADVERTENCIA  	TINYINT
		EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT 
						@p_REGISTRADA      	 OUT,
						@p_INICIADA          OUT,
						@p_FINALIZADAOK 	 OUT,
						@p_FINALIZADAFALLO   OUT,
						@p_ABORTADA  		 OUT,
						@p_NOINICIADA  		 OUT,
						@p_FINALIZADAADVERTENCIA   OUT
  
		SET @SzInstruction2 = ' select rt.* from sfg_conciliacion.con_no_concilia_ret rt where rt.id_con_no_concilia_ret in (' +
						  ISNULL(@szSqlParams, '') + ')';
		DECLARE con_no_concilia_ret_cur CURSOR FOR
				select CODPUNTODEVENTA,  FECHA_TX,  ID_CON_NO_CONCILIA_RET, trama_xml, MONTO_ACUMULADO
				from sfg_conciliacion.con_no_concilia_ret rt 
				where rt.id_con_no_concilia_ret in (@szSqlParams)

		OPEN con_no_concilia_ret_cur;

		DECLARE @con_no_concilia_ret_cur__CODPUNTODEVENTA NUMERIC(38,0), @con_no_concilia_ret_cur__FECHA_TX DATETIME, 
				@con_no_concilia_ret_cur__ID_CON_NO_CONCILIA_RET NUMERIC(38,0), @con_no_concilia_ret_cur__trama_xml VARCHAR(4000),
				@con_no_concilia_ret_cur__MONTO_ACUMULADO FLOAT


		FETCH con_no_concilia_ret_cur INTO @con_no_concilia_ret_cur__CODPUNTODEVENTA, @con_no_concilia_ret_cur__FECHA_TX, 
				@con_no_concilia_ret_cur__ID_CON_NO_CONCILIA_RET, @con_no_concilia_ret_cur__trama_xml, @con_no_concilia_ret_cur__MONTO_ACUMULADO

		WHILE @@FETCH_STATUS = 0 
		BEGIN
      
    
    
		  --Obtiene PDV GTECH
		  select @PDVGTECH = p.codigogtechpuntodeventa
			from wsxml_sfg.puntodeventa p
		   where p.id_puntodeventa = @con_no_concilia_ret_cur__CODPUNTODEVENTA;
    
		  -- Compara los valores actuales de Helion contra los detectados en la conciliacion
    
		  SELECT @Cantidad_Conciden = count(*), @ValorHelion = sum(TOTALDEPOSITOS)
			from SFG_CONCILIACION.vw_PagosConciliaSFG 
		   WHERE FECHAARCHIVO = FORMAT(CONVERT(DATETIME, CONVERT(DATE,@con_no_concilia_ret_cur__FECHA_TX)),'dd/MMM/yyyy')
			 and CODPUNTODEVENTA = @con_no_concilia_ret_cur__CODPUNTODEVENTA
			 and TOTALDEPOSITOS = @con_no_concilia_ret_cur__MONTO_ACUMULADO
		

		  if @Cantidad_Conciden = 0 begin
      
			update sfg_conciliacion.con_no_concilia_ret
			   set procesado_helion        = 2,
				  fecha_hora_validaproc_h = getdate(),
				   monto_al_validar_helion = isnull(@ValorHelion, 0)
			 where id_con_no_concilia_ret = @con_no_concilia_ret_cur__ID_CON_NO_CONCILIA_RET
      
			SET @Mensaje_SFGALERTA8000 = 'La comprobacion de aplicacion de retiros en SFG Cartera desde SFG Conciliacion fallo para el PDV ' +
									 ISNULL(@PDVGTECH, '') + isnull(char(13), '') +
									 'La siguiente Trama XML no fue aplicada correctamente en SFG Cartera.' +
									 isnull(char(13), '') +
									 isnull(@con_no_concilia_ret_cur__trama_xml, '');
      
			SET @Mensaje_SFGALERTA = substring(@Mensaje_SFGALERTA8000, 0, 2000);
			begin
			  SET @p_RETURNVALUE_out = @p_FINALIZADAADVERTENCIA
          
			  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_FINALIZADAADVERTENCIA,'CONCILIACIONRETIROS',Mensaje_SFGALERTA, 1
			  commit;
			end;
		  end
		  else if @Cantidad_Conciden > 0 begin
      
			update sfg_conciliacion.con_no_concilia_ret
			   set procesado_helion        = 1,
				   fecha_hora_validaproc_h = getdate(),
				   monto_al_validar_helion = isnull(@ValorHelion, 0)
			 where id_con_no_concilia_ret =
				   @con_no_concilia_ret_cur__ID_CON_NO_CONCILIA_RET
      
		  end 
    
		END;
  
		-- Close cursor:
		CLOSE con_no_concilia_ret_cur;
		DEALLOCATE con_no_concilia_ret_cur;
  
		COMMIT;
		SET @p_RETURNVALUE_out = @p_FINALIZADAOK;


	END TRY
	BEGIN CATCH
    
      SET @Mensaje_SFGALERTA8000 = 'La comprobacion de aplicacion de retiros en SFG Cartera desde SFG Conciliacion fallo. -  ' + isnull(ERROR_MESSAGE ( ), '');
      SET @Mensaje_SFGALERTA = substring(@Mensaje_SFGALERTA8000, 0, 2000);
      SET @p_RETURNVALUE_out = @p_FINALIZADAFALLO;
      
	  begin
			
			DECLARE @p_TIPOINFORMATIVO TINYINT,@p_TIPOERROR TINYINT,  @p_TIPOADVERTENCIA TINYINT, @p_TIPOCUALQUIERA TINYINT,
				@p_PROCESONOTIFICACION TINYINT, @p_ESTADOABIERTA TINYINT, @p_ESTADOCERRADA TINYINT 
			EXEC WSXML_SFG.SFGALERTA_CONSTANT @p_TIPOINFORMATIVO OUT, @p_TIPOERROR OUT, @p_TIPOADVERTENCIA OUT,
				@p_TIPOCUALQUIERA OUT, @p_PROCESONOTIFICACION OUT, @p_ESTADOABIERTA OUT, @p_ESTADOCERRADA OUT
      
        EXEC wsxml_sfg.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'CONCILIACIONRETIROS',@Mensaje_SFGALERTA, 1
        commit;
      end;
    END CATCH
  end 
 GO

  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_HELION_ENVIO_TRAMA_XML_HELION', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_HELION_ENVIO_TRAMA_XML_HELION;
GO

CREATE     PROCEDURE SFG_CONCILIACION.CON_CONCILIA_HELION_ENVIO_TRAMA_XML_HELION(@FECHA_A_PROCESAR  DATETIME, @p_RETURNVALUE_out NUMERIC(22,0) OUT) as
 begin
  
    declare @szSqlXml              varchar(max);
    declare @szSqlXmlHeader        varchar(max);
    declare @szSqlXmlBody          varchar(max);
    declare @szSqlXmlFooter        varchar(max);
    declare @fechaProcedure        varchar(20);
    declare @p_ID_ARCHIVOBANCO     NUMERIC(22,0);
    declare @FILAS_AFECTAR         varchar(8000) = '';
    declare @contador              NUMERIC(22,0) = 0;
    declare @szSqlInstruction      varchar(max);
    declare @Mensaje_SFGALERTA8000 varchar(max);
    declare @Mensaje_SFGALERTA     varchar(max);
  
   
  set nocount on;
  
		DECLARE @p_REGISTRADA   TINYINT,@p_INICIADA     TINYINT,@p_FINALIZADAOK  TINYINT,@p_FINALIZADAFALLO  TINYINT,
							@p_ABORTADA  TINYINT, @p_NOINICIADA  TINYINT, @p_FINALIZADAADVERTENCIA  TINYINT
		EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT @p_REGISTRADA      	 OUT,
							@p_INICIADA          OUT,@p_FINALIZADAOK 	 OUT,
							@p_FINALIZADAFALLO   OUT,@p_ABORTADA  		 OUT,
							@p_NOINICIADA  		 OUT,@p_FINALIZADAADVERTENCIA   OUT

		--p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAOK;
		--p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAADVERTENCIA;
		--p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAFALLO;
	BEGIN TRY
		set @fechaProcedure = (convert(datetime, convert(date,@FECHA_A_PROCESAR)));
  
		set @szSqlXmlHeader = '<PAGOS>';
  
		set @szSqlXml = ISNULL(@szSqlXmlHeader, '') + isnull(char(13), '');
  
		declare tmp cursor for select RT.id_con_no_concilia_ret,
						   
						   pdv.codigogtechpuntodeventa,
						   RT.FECHA_TX,
						   (rt.monto_acumulado - rt.monto_cartera) MontoDiferencia,
						   rt.ID_CON_NO_CONCILIA_RET as fila
					  from sfg_conciliacion.con_no_concilia_ret rt,
						   wsxml_sfg.puntodeventa               pdv
					 where rt.enviado_helion = 0
					   and pdv.id_puntodeventa = rt.codpuntodeventa; open tmp;
	DECLARE @tmp__id_con_no_concilia_ret NUMERIC(38,0), @tmp__codigogtechpuntodeventa NUMERIC(38,0), 
		@tmp__fecha_tx DATETIME, @tmp__MontoDiferencia FLOAT, @tmp__fila  NUMERIC(38,0)
	 fetch NEXT FROM tmp into @tmp__id_con_no_concilia_ret, @tmp__codigogtechpuntodeventa, @tmp__fecha_tx, @tmp__MontoDiferencia, @tmp__fila;
	 while @@fetch_status=0
	 begin
    
		  set @contador = @contador + 1;
    
		  if @contador = 1 begin
			set @FILAS_AFECTAR = ISNULL(@FILAS_AFECTAR, '') + isnull(@tmp__id_con_no_concilia_ret, '');
		  end
		  else if @contador > 1 begin
			set @FILAS_AFECTAR = ISNULL(@FILAS_AFECTAR, '') + ' , ' +
							 isnull(@tmp__id_con_no_concilia_ret, '');
		  end 
    
		  set @szSqlXmlBody = '<PAGO Referencia="' + isnull(@tmp__codigogtechpuntodeventa, '') +
						  '" FechaPago="' +
						  isnull(FORMAT(CONVERT(DATETIME,CONVERT(DATE,@tmp__fecha_tx)), 'dd/Mon/yyyy'), '') +
						  '" ValorPagado="' + ISNULL(@tmp__MontoDiferencia, '') +
						  '" Oficina="" Cuenta="" Convenio="" DescripcionPago="WDCONCI" FormaPago="" />';
    
		  update sfg_conciliacion.con_no_concilia_ret
			 set enviado_helion     = 1,
				 fecha_hora_envio_h = getdate(),
				 trama_xml          = @szSqlXmlBody
		   where ID_CON_NO_CONCILIA_RET = @tmp__fila;
    
		  set @szSqlXml = ISNULL(@szSqlXml, '') + ISNULL(@szSqlXmlBody, '') + isnull(char(13), '');
    
		fetch NEXT FROM tmp into @tmp__id_con_no_concilia_ret, @tmp__codigogtechpuntodeventa, @tmp__fecha_tx, @tmp__MontoDiferencia, @tmp__fila;
		end;
		close tmp;
		deallocate tmp;
  
		set @szSqlXmlFooter = '</PAGOS>';
		set @szSqlXml       = ISNULL(@szSqlXml, '') + ISNULL(@szSqlXmlFooter, '');
  
		if len(@szSqlXmlBody) > 0 begin
		 -- "dbo"."ARCHIVOBANCO_ADDSTR"@HELION 39, @fechaProcedure, 'WDCONCILIACION' + isnull(FORMAT(CONVERT(DATETIME, convert(date,@FECHA_A_PROCESAR))), ''),
		--									 ' ', 1,@szSqlXml, 4, @p_ID_ARCHIVOBANCO
    
		  set @szSqlInstruction = ' update sfg_conciliacion.con_no_concilia_ret set cod_archivobanco_helion = ' +
							  ISNULL(@p_ID_ARCHIVOBANCO, '') +
							  ' where (id_con_no_concilia_ret) in ( ' +
							  ISNULL(@FILAS_AFECTAR, '') + ')';
    
		  execute sp_executesql @szSqlInstruction;
    
		  -- Hace el llamado al procedimiento privado que valida la correcta aplicacion
		  -- de los retiros enviados por XML desde CONCILIACION hacia HELION.
    
		  EXEC SFG_CONCILIACION.CON_CONCILIA_HELION_VALIDA_APLICACION_RETIRO_H @FILAS_AFECTAR, @p_RETURNVALUE_out OUT
    
		end 
		--COMMIT;
		set @p_RETURNVALUE_out = @p_FINALIZADAOK;

	END TRY
	BEGIN CATCH
      rollback;
      --RAISE_APPLICATION_ERROR(-20001, sqlerrm);
      set @Mensaje_SFGALERTA8000 = 'Fallo el envio de tramas XML a SFG Cartera desde SFG Conciliacion. - ' +
                               isnull(ERROR_MESSAGE ( ) , '');
      set @Mensaje_SFGALERTA     = substring(@Mensaje_SFGALERTA8000, 0, 2000);
    
      set @p_RETURNVALUE_out = @p_FINALIZADAFALLO
    
      begin

	  		DECLARE @p_TIPOINFORMATIVO TINYINT,@p_TIPOERROR TINYINT,  @p_TIPOADVERTENCIA TINYINT, @p_TIPOCUALQUIERA TINYINT,
			@p_PROCESONOTIFICACION TINYINT, @p_ESTADOABIERTA TINYINT, @p_ESTADOCERRADA TINYINT 
		EXEC WSXML_SFG.SFGALERTA_CONSTANT @p_TIPOINFORMATIVO OUT, @p_TIPOERROR OUT, @p_TIPOADVERTENCIA OUT,
			@p_TIPOCUALQUIERA OUT, @p_PROCESONOTIFICACION OUT, @p_ESTADOABIERTA OUT, @p_ESTADOCERRADA OUT
      
        EXEC wsxml_sfg.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'CONCILIACIONRETIROS', @Mensaje_SFGALERTA, 1
        commit;
      end;
    END CATCH
  end;
GO

  IF OBJECT_ID('SFG_CONCILIACION.CON_CONCILIA_HELION_CONCILIA_RETIROS', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.CON_CONCILIA_HELION_CONCILIA_RETIROS;
GO

CREATE     PROCEDURE SFG_CONCILIACION.CON_CONCILIA_HELION_CONCILIA_RETIROS(@p_CODDETALLETAREAEJECUTADA NUMERIC(22,0),
                             @FECHA_TX_RETIROS           DATETIME,
                             @p_RETURNVALUE_out          NUMERIC(22,0) OUT) as
 begin
  
    declare @p_ID_CON_CONTROL_PROC_out    NUMERIC(22,0);
    declare @p_ID_CON_NO_CONCILIA_RET_out NUMERIC(22,0);
    declare @Cantidad_Conciden            NUMERIC(22,0);
    declare @Vr_Cartera                   NUMERIC(22,0);
    declare @Vr_SFG                       NUMERIC(22,0);
    declare @p_FECHA_HORA_INICIO          datetime = getdate();
    declare @Mensaje_SFGALERTA8000        varchar(8000);
    declare @Mensaje_SFGALERTA            varchar(2000);
  
    
		DECLARE @p_REGISTRADA   TINYINT,@p_INICIADA     TINYINT,@p_FINALIZADAOK  TINYINT,@p_FINALIZADAFALLO  TINYINT,
							@p_ABORTADA  TINYINT, @p_NOINICIADA  TINYINT, @p_FINALIZADAADVERTENCIA  TINYINT
		EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT @p_REGISTRADA      	 OUT,
							@p_INICIADA          OUT,@p_FINALIZADAOK 	 OUT,
							@p_FINALIZADAFALLO   OUT,@p_ABORTADA  		 OUT,
							@p_NOINICIADA  		 OUT,@p_FINALIZADAADVERTENCIA   OUT

   
  set nocount on;
    /* Valores de Retorno */
    set @p_RETURNVALUE_out = @p_FINALIZADAOK;
    --p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAADVERTENCIA;
    --p_RETURNVALUE_out := WSXML_SFG.SFGESTADOTAREAEJECUTADA.FINALIZADAFALLO;
  
    /* Establecer total de registros a iterar */
    EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_CODDETALLETAREAEJECUTADA, 100
    begin
      /* Actualizar registros actualmente iterados */
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_updateCountRecords @p_CODDETALLETAREAEJECUTADA,30
      commit;
    end;
    --Registra el inicio del proceso
  
    EXEC SFG_CONCILIACION.Sfgconciwebcon_Control_Proc_Co_AddRecord @p_FECHA_HORA_INICIO, null, 2, 'Retiros Cartera',1,'Iniciada', @p_ID_CON_CONTROL_PROC_out OUT
  
    --Inicia busqueda desde SFG hacia HELION
  
    declare sfgRet cursor for SELECT WSXML_SFG.REGISTROFACTURACION.CODPUNTODEVENTA,
                          SUM(SFG_CONCILIACION.ENTRADACONCILIAGTK.AMOUNT) AS AMOUNT,
                          CONVERT(DATETIME,CONVERT(DATE,SFG_CONCILIACION.ENTRADACONCILIAGTK.FECHA_HORA_TRANS)) AS FECHA_HORA_TRANS
                     FROM SFG_CONCILIACION.ENTRADACONCILIAGTK
                    INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA
                       ON SFG_CONCILIACION.ENTRADACONCILIAGTK.CODREGISTROFACTREFERENCIA =
                          WSXML_SFG.REGISTROFACTREFERENCIA.ID_REGISTROFACTREFERENCIA
                    INNER JOIN WSXML_SFG.REGISTROFACTURACION
                       ON WSXML_SFG.REGISTROFACTREFERENCIA.CODREGISTROFACTURACION =
                          WSXML_SFG.REGISTROFACTURACION.ID_REGISTROFACTURACION
                    INNER JOIN SFG_CONCILIACION.CON_MAPEO_PRODUCTO
                       ON WSXML_SFG.REGISTROFACTURACION.CODPRODUCTO =
                          SFG_CONCILIACION.CON_MAPEO_PRODUCTO.CODPRODUCTO_SFG
                    WHERE CONVERT(DATETIME,CONVERT(DATE,SFG_CONCILIACION.ENTRADACONCILIAGTK.FECHA_HORA_TRANS)) = convert(datetime, convert(date,@FECHA_TX_RETIROS))
                      AND SFG_CONCILIACION.CON_MAPEO_PRODUCTO.CODPRODUCTO_ALIADO IN (6, 9)
                      AND (SFG_CONCILIACION.ENTRADACONCILIAGTK.ESTADO_SC = 'A')
                      AND (SFG_CONCILIACION.ENTRADACONCILIAGTK.CONCILIABLE = 1)
                    GROUP BY WSXML_SFG.REGISTROFACTURACION.CODPUNTODEVENTA,
                             CONVERT(DATETIME,CONVERT(DATE,SFG_CONCILIACION.ENTRADACONCILIAGTK.FECHA_HORA_TRANS)); 
					open sfgRet;

					DECLARE @sfgRet__CODPUNTODEVENTA NUMERIC(38,0), @sfgRet__AMOUNT FLOAT, @sfgRet__FECHA_HORA_TRANS DATETIME
	fetch NEXT FROM sfgRet into @sfgRet__CODPUNTODEVENTA, @sfgRet__AMOUNT, @sfgRet__FECHA_HORA_TRANS
	while @@fetch_status=0
	begin
    
      SELECT @Cantidad_Conciden = count(*)
        from SFG_CONCILIACION.vw_PagosConciliaSFG@HELION
       WHERE FECHAARCHIVO = (CONVERT(DATETIME, CONVERT(DATE,@sfgRet__FECHA_HORA_TRANS)))
         and CODPUNTODEVENTA = @sfgRet__CODPUNTODEVENTA
         and TOTALDEPOSITOS = @sfgRet__AMOUNT;
    
      if @Cantidad_Conciden = 0 begin
      
        SELECT @Vr_Cartera = sum(TOTALDEPOSITOS)
          from SFG_CONCILIACION.vw_PagosConciliaSFG@HELION
         WHERE FECHAARCHIVO = (CONVERT(DATETIME, CONVERT(DATE,@sfgRet__FECHA_HORA_TRANS)))
           and CODPUNTODEVENTA = sfgRet.Codpuntodeventa;
		
		SET @Vr_Cartera = isnull(@Vr_Cartera,0)
        EXEC sfg_conciliacion.sfgconciwebcon_no_concilia_ret_AddRecord 
																	@p_ID_CON_CONTROL_PROC_out,
                                                                  @sfgRet__CODPUNTODEVENTA,
                                                                  @sfgRet__AMOUNT,
                                                                  @sfgRet__FECHA_HORA_TRANS,
                                                                  @Vr_Cartera,
                                                                  0,
                                                                  null,
                                                                  0,
                                                                  null,
                                                                  null,
                                                                  @p_ID_CON_NO_CONCILIA_RET_out OUT
      end 
    fetch NEXT FROM sfgRet into @sfgRet__CODPUNTODEVENTA, @sfgRet__AMOUNT, @sfgRet__FECHA_HORA_TRANS
    end;

    close sfgRet;
    deallocate sfgRet;
  
    
	DECLARE @fechahoy datetime =  getdate()
    -- Si no hay fallas, registra la tarea como OK
    EXEC SFG_CONCILIACION.Sfgconciwebcon_Control_Proc_Co_UpdateRecord 
																@p_ID_CON_CONTROL_PROC_out,
                                                                @p_FECHA_HORA_INICIO,
                                                                @fechahoy,
                                                                2,
                                                                'Retiros Cartera',
                                                                3,
                                                                'Ejecucion sin novedades'
  
    commit;
  
    -- Llama al procedimiento privado que envia a Helion la
    -- trama XML con los retiros (pagos) que no coinciden
  
    begin
      /* Actualizar registros actualmente iterados */
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_CODDETALLETAREAEJECUTADA,60
      commit;
    end;
  
		EXEC SFG_CONCILIACION.CON_CONCILIA_HELION_ENVIO_TRAMA_XML_HELION @FECHA_TX_RETIROS,@p_RETURNVALUE_out
  
    begin
      /* Actualizar registros actualmente iterados */
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_CODDETALLETAREAEJECUTADA, 100
    
      /* Mensaje de finalizacion */
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, 'El proceso de conciliacion de retiros ha finalizado con exito'
    
      commit;
    end;
  
    
  end;


GO