USE SFGPRODU;
--  DDL for Package SFGARCHIVOTRANSACCIONALIADO
--------------------------------------------------------



  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_CheckFileExistance', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_CheckFileExistance;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_CheckFileExistance(@p_CODALIADOESTRATEGICO  NUMERIC(22,0),
                               @p_FECHAARCHIVO          DATETIME,
                               @p_CANTIDADTRANSACCIONES NUMERIC(22,0),
                               @p_VALORTRANSACCIONES    FLOAT,
                               @p_NOMBREARCHIVO         NVARCHAR(2000),
                               @p_FILEEXISTS_out        INT OUT) AS
 BEGIN
    DECLARE @filelist     WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @txvalueb     INT = 0;
    DECLARE @prefixeslist WSXML_SFG.NUMBERARRAY;
   
  SET NOCOUNT ON;
	INSERT INTO @prefixeslist
    SELECT ID_CONFIGALIADOARCHIVOPREFIJO
      FROM WSXML_SFG.CONFIGURACIONALIADOARCHIVO
     INNER JOIN WSXML_SFG.CONFIGALIADOARCHIVOPREFIJO
        ON (CODCONFIGURACIONALIADOARCHIVO = ID_CONFIGURACIONALIADOARCHIVO)
     WHERE CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
    -- By default, set in no configured

    SET @txvalueb = 3;
    IF (SELECT COUNT(*) FROM @prefixeslist) > 0 BEGIN
      DECLARE ipfx CURSOR FOR SELECT IDVALUE FROM @prefixeslist--.First .. prefixeslist.Last 
	  OPEN ipfx;

	  DECLARE @ipfx__IDVALUE NUMERIC(38,0)
	 FETCH NEXT FROM ipfx INTO @ipfx__IDVALUE;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
          DECLARE @thisFILEPREFIX NVARCHAR(40);
        BEGIN
          SELECT @thisFILEPREFIX = PREFIJOESPERADO
            FROM WSXML_SFG.CONFIGALIADOARCHIVOPREFIJO
           WHERE ID_CONFIGALIADOARCHIVOPREFIJO = @ipfx__IDVALUE
          IF SUBSTRING(@p_NOMBREARCHIVO, 0, LEN(@thisFILEPREFIX)) =
             @thisFILEPREFIX BEGIN
            SET @txvalueb = 0;
          END 
        END;
      FETCH NEXT FROM ipfx INTO @ipfx__IDVALUE;
      END;
      CLOSE ipfx;
      DEALLOCATE ipfx;
    END 
    -- Only check if previous checks have passed
    IF @txvalueb = 0 BEGIN
	  INSERT INTO @filelist
      SELECT ID_ARCHIVOTRANSACCIONALIADO
        FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
       WHERE CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO
         AND FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO));

      IF @@ROWCOUNT > 0 BEGIN
        DECLARE ifx CURSOR FOR SELECT IDVALUE FROM @filelist--.First .. filelist.Last 
		OPEN ifx;
		DECLARE @ifx__IDVALUE NUMERIC(38,0)
		 FETCH NEXT FROM ifx INTO @ifx__IDVALUE;
		 WHILE @@FETCH_STATUS=0
		 BEGIN
            DECLARE @thisfileQUANTITY NUMERIC(22,0);
            DECLARE @thisfileAMOUNT   FLOAT;
            DECLARE @thisFILENAME     NVARCHAR(200);
          BEGIN
            SELECT @thisfileQUANTITY = CANTIDADTRANSACCIONES, @thisfileAMOUNT = VALORTRANSACCIONES, @thisFILENAME = NOMBREARCHIVO
              FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
             WHERE ID_ARCHIVOTRANSACCIONALIADO = @ifx__IDVALUE
            IF @thisfileQUANTITY = @p_CANTIDADTRANSACCIONES AND
               @thisfileAMOUNT = @p_VALORTRANSACCIONES BEGIN
              SET @txvalueb = 1;
              BREAK;
            END 
            IF @thisFILENAME = @p_NOMBREARCHIVO BEGIN
              SET @txvalueb = 2;
              BREAK;
            END 
          END;
        FETCH NEXT FROM ifx INTO @ifx__IDVALUE;
        END;
        CLOSE ifx;
        DEALLOCATE ifx;
      END 
    END 
    SET @p_FILEEXISTS_out = @txvalueb;
  END;
  GO

IF OBJECT_ID('SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_LoadFileHeader', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_LoadFileHeader;
GO

CREATE     PROCEDURE SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_LoadFileHeader(@p_CODALIADOESTRATEGICO         NUMERIC(22,0),
                           @p_FECHAARCHIVO                 DATETIME,
                           @p_NOMBREARCHIVO                NVARCHAR(2000),
                           @p_CODFORMATOARCHIVOTRANSACCION NUMERIC(22,0),
                           @p_CANTIDADTRANSACCIONES        NUMERIC(22,0),
                           @p_VALORTRANSACCIONES           FLOAT,
                           @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                           @p_ID_ARCHIVOTRANSACCIONALI_out NUMERIC(22,0) OUT) AS
BEGIN						   
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ARCHIVOTRANSACCIONALIADO
      (
       CODALIADOESTRATEGICO,
       FECHAARCHIVO,
       NOMBREARCHIVO,
       CODFORMATOARCHIVOTRANSACCION,
       CANTIDADTRANSACCIONES,
       VALORTRANSACCIONES,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODALIADOESTRATEGICO,
       CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO)),
       @p_NOMBREARCHIVO,
       @p_CODFORMATOARCHIVOTRANSACCION,
       @p_CANTIDADTRANSACCIONES,
       @p_VALORTRANSACCIONES,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ARCHIVOTRANSACCIONALI_out = SCOPE_IDENTITY();
    COMMIT;	
END	
GO

  /* Used for configurations in which only the value matches */

  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadValueComparisonTransaction', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadValueComparisonTransaction;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadValueComparisonTransaction(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                           @p_NUMERORECIBO                NVARCHAR(2000),
                                           @p_NUMEROSUSCRIPTOR            NVARCHAR(2000),
                                           @p_VALORTRANSACCION            FLOAT,
                                           @p_ID_TRANSACCIONALIADO_out    NUMERIC(22,0) OUT,
                                           @p_TRANSACCIONENCONTRADA_out   NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xFECHAARCHIVO              DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL  NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION    NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA           NUMERIC(22,0);
    DECLARE @xCODPRODUCTO               NUMERIC(22,0);
    DECLARE @vINCREMENTOS               NUMERIC(22,0) = 0;
    DECLARE @fechaarchivoMIN            DATETIME;
    DECLARE @fechaarchivoMAX            DATETIME;
   
  SET NOCOUNT ON;
    SET @p_TRANSACCIONENCONTRADA_out = 0;
  
    select @fechaarchivoMAX = CONVERT(DATETIME,al.fechaarchivo) + @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;

    REINTENTO:
    
	begin
    
		SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
        FROM (select rfr.*, ROW_NUMBER() OVER(order by rfr.numeroreferencia ASC) rowid
                from wsxml_sfg.registrofactreferencia rfr
               where rfr.codregistrofacturacion in
                     (select rf.id_registrofacturacion
                        from wsxml_sfg.registrofacturacion rf,
                             wsxml_sfg.producto            p
                       where rf.codtiporegistro = 1
                         and rf.codproducto = p.id_producto
                         and rf.codentradaarchivocontrol in
                             (select ac.id_entradaarchivocontrol
                                from WSXML_SFG.entradaarchivocontrol ac
                               where ac.tipoarchivo = 1
                                 and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
                                     @fechaarchivoMAX)
                         and p.codaliadoestrategico in
                             (select al.codaliadoestrategico
                                from wsxml_sfg.archivotransaccionaliado al
                               where al.id_archivotransaccionaliado =
                                     @p_CODARCHIVOTRANSACCIONALIADO)
						)
               --order by rfr.numeroreferencia
		) RF
       WHERE /*TO_NUMBER(nvl(RF.RECIBO, 0)) = TO_NUMBER(nvl(p_NUMERORECIBO, 0))
                                                                                                                                                                                                                                                                                                                               AND*/
			RF.VALORTRANSACCION = @p_VALORTRANSACCION
			  /*AND TO_NUMBER(nvl(RF.SUSCRIPTOR,0)) = 0*/
			   and isnull(rf.codtransaccionaliado, 0) = 0
			   --and;
		IF @@ROWCOUNT = 0 BEGIN
			IF @vINCREMENTOS <= 7 BEGIN
			  SET @vINCREMENTOS = @vINCREMENTOS + 1;
			  --fechaarchivoMAX := fechaarchivoMAX + 1;
			  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
			  GOTO REINTENTO;
			END

		END ELSE 
			SELECT  NULL;
        
    end;
    -- Insert right away. Cross reference will be updated
    INSERT INTO WSXML_SFG.TRANSACCIONALIADO
      (
       CODARCHIVOTRANSACCIONALIADO,
       NUMERORECIBO,
       NUMEROSUSCRIPTOR,
       VALORTRANSACCION,
       REVENUETRANSACCION,
       CODENTRADAARCHIVOCONTROL,
       CODREGISTROFACTURACION,
       CODREGISTROFACTREFERENCIA,
       CODPUNTODEVENTA,
       CODPRODUCTO)
    VALUES
      (
       @p_CODARCHIVOTRANSACCIONALIADO,
       @p_NUMERORECIBO,
       @p_NUMEROSUSCRIPTOR,
       @p_VALORTRANSACCION,
       0,
       @xCODENTRADAARCHIVOCONTROL,
       @xCODREGISTROFACTURACION,
       @xCODREGISTROFACTREFERENCIA,
       @xCODPUNTODEVENTA,
       @xCODPRODUCTO);
    SET @p_ID_TRANSACCIONALIADO_out = SCOPE_IDENTITY();
  
    BEGIN
		BEGIN TRY

			-- Calculate transaction revenue
		  IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
			EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale
							@p_ID_TRANSACCIONALIADO_out,
                             @xCODREGISTROFACTREFERENCIA,
                             @xFECHAARCHIVO,
                             @xCODENTRADAARCHIVOCONTROL,
                             @xCODREGISTROFACTURACION,
                             @xCODPUNTODEVENTA,
                             @xCODPRODUCTO,
                             @p_VALORTRANSACCION,
                             0
      END 
    
		END TRY
		BEGIN CATCH
			SELECT NULL;
		END CATCH
    END;
 END
 GO
 
  /* Used for configurations in which the receipt number matches exactly - No trim leading */
 IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadExactReceiptTransaction', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadExactReceiptTransaction;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadExactReceiptTransaction(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                        @p_NUMERORECIBO                NVARCHAR(2000),
                                        @p_NUMEROSUSCRIPTOR            NVARCHAR(2000),
                                        @p_VALORTRANSACCION            FLOAT,
                                        @p_ID_TRANSACCIONALIADO_out    NUMERIC(22,0) OUT,
                                        @p_TRANSACCIONENCONTRADA_out   NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xFECHAARCHIVO              DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL  NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION    NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA           NUMERIC(22,0);
    DECLARE @xCODPRODUCTO               NUMERIC(22,0);
    DECLARE @fechaarchivoMIN            DATETIME;
    DECLARE @fechaarchivoMAX            DATETIME;
    DECLARE @vINCREMENTOS               NUMERIC(22,0) = 0;
  
   
  SET NOCOUNT ON;
    SET @p_TRANSACCIONENCONTRADA_out = 0;
  
    select @fechaarchivoMAX = CONVERT(DATETIME,al.fechaarchivo) + @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    REINTENTO:
    BEGIN
    
		  SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
			FROM (select rfr.*, ROW_NUMBER() OVER(order by rfr.numeroreferencia) rowid
					from wsxml_sfg.registrofactreferencia rfr
				   where rfr.codregistrofacturacion in
						 (select rf.id_registrofacturacion
							from wsxml_sfg.registrofacturacion rf,
								 wsxml_sfg.producto            p
						   where rf.codtiporegistro = 1
							 and rf.codproducto = p.id_producto
							 and rf.codentradaarchivocontrol in
								 (select ac.id_entradaarchivocontrol
									from WSXML_SFG.entradaarchivocontrol ac
								   where ac.tipoarchivo = 1
									 and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
										 @fechaarchivoMAX)
							 and p.codaliadoestrategico in
								 (select al.codaliadoestrategico
									from wsxml_sfg.archivotransaccionaliado al
								   where al.id_archivotransaccionaliado =
										 @p_CODARCHIVOTRANSACCIONALIADO))
				   --order by rfr.numeroreferencia
				 ) RF
		   WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
				 CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
			 AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
				/*AND TO_NUMBER(nvl(RF.SUSCRIPTOR,0)) = 0*/
			 and isnull(rf.codtransaccionaliado, 0) = 0
			 --and;
	
		IF @@ROWCOUNT = 0 BEGIN
    
			IF @vINCREMENTOS <= 4 BEGIN
			  SET @vINCREMENTOS = @vINCREMENTOS + 1;
			  --fechaarchivoMAX := fechaarchivoMAX + 1;
			  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
			  GOTO REINTENTO;
			END
		 END ELSE BEGIN
			 SELECT NULL;
			END 
      
    end;
    -- Insert right away. Cross reference will be updated
    INSERT INTO WSXML_SFG.TRANSACCIONALIADO
      (
       CODARCHIVOTRANSACCIONALIADO,
       NUMERORECIBO,
       NUMEROSUSCRIPTOR,
       VALORTRANSACCION,
       REVENUETRANSACCION,
       CODENTRADAARCHIVOCONTROL,
       CODREGISTROFACTURACION,
       CODREGISTROFACTREFERENCIA,
       CODPUNTODEVENTA,
       CODPRODUCTO)
    VALUES
      (
       @p_CODARCHIVOTRANSACCIONALIADO,
       @p_NUMERORECIBO,
       @p_NUMEROSUSCRIPTOR,
       @p_VALORTRANSACCION,
       0,
       @xCODENTRADAARCHIVOCONTROL,
       @xCODREGISTROFACTURACION,
       @xCODREGISTROFACTREFERENCIA,
       @xCODPUNTODEVENTA,
       @xCODPRODUCTO);
    SET @p_ID_TRANSACCIONALIADO_out = SCOPE_IDENTITY();
  
    BEGIN
		BEGIN TRY
		  -- Calculate transaction revenue
		  IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
			EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale 
								@p_ID_TRANSACCIONALIADO_out,
								 @xCODREGISTROFACTREFERENCIA,
								 @xFECHAARCHIVO,
								 @xCODENTRADAARCHIVOCONTROL,
								 @xCODREGISTROFACTURACION,
								 @xCODPUNTODEVENTA,
								 @xCODPRODUCTO,
								 @p_VALORTRANSACCION,
								 0
		  END 
    
		END TRY
		BEGIN CATCH
			SELECT NULL; -- Try with next one
		END CATCH
    END;
  END;
  GO
 
 
  /* Used for configurations in which the recept plain value is sometimes crossed */
  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadCrossReceiptTransaction', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadCrossReceiptTransaction;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadCrossReceiptTransaction(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                        @p_NUMERORECIBO                NVARCHAR(2000),
                                        @p_NUMEROSUSCRIPTOR            NVARCHAR(2000),
                                        @p_VALORTRANSACCION            FLOAT,
                                        @p_ID_TRANSACCIONALIADO_out    NUMERIC(22,0) OUT,
                                        @p_TRANSACCIONENCONTRADA_out   NUMERIC(22,0) OUT) AS
 BEGIN
  
    --ESTE ES SOLO COMPRACION POR SUSCRIPTOR
    DECLARE @xFECHAARCHIVO              DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL  NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION    NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA           NUMERIC(22,0);
    DECLARE @xCODPRODUCTO               NUMERIC(22,0);
    DECLARE @lstcachetransactions       LONGNUMBERARRAY;
    DECLARE @fechaarchivoMIN            DATETIME;
    DECLARE @fechaarchivoMAX            DATETIME;
    DECLARE @vINCREMENTOS               NUMERIC(22,0) = 0;
  
   
  SET NOCOUNT ON;
    SET @p_TRANSACCIONENCONTRADA_out = 0;
  
    select @fechaarchivoMAX = convert(datetime,al.fechaarchivo) + @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    REINTENTO:
  
    BEGIN
    
      SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
        FROM (select rfr.*, ROW_NUMBER() OVER(order by rfr.numeroreferencia) rowid
                from wsxml_sfg.registrofactreferencia rfr
               where rfr.codregistrofacturacion in
                     (select rf.id_registrofacturacion
                        from wsxml_sfg.registrofacturacion rf,
                             wsxml_sfg.producto            p
                       where rf.codtiporegistro = 1
                         and rf.codproducto = p.id_producto
                         and rf.codentradaarchivocontrol in
                             (select ac.id_entradaarchivocontrol
                                from WSXML_SFG.entradaarchivocontrol ac
                               where ac.tipoarchivo = 1
                                 and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
                                     @fechaarchivoMAX)
                         and p.codaliadoestrategico in
                             (select al.codaliadoestrategico
                                from wsxml_sfg.archivotransaccionaliado al
                               where al.id_archivotransaccionaliado =
                                     @p_CODARCHIVOTRANSACCIONALIADO))
               --order by rfr.numeroreferencia
			   ) RF
       WHERE RF.VALORTRANSACCION = @p_VALORTRANSACCION
         AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
             CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
         and isnull(rf.codtransaccionaliado, 0) = 0
         ---and;
		IF @@ROWCOUNT = 0 
        BEGIN
        
          SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
            FROM (select rfr.*, ROW_NUMBER() OVER(order by rfr.numeroreferencia) rowid
                    from wsxml_sfg.registrofactreferencia rfr
                   where rfr.codregistrofacturacion in
                         (select rf.id_registrofacturacion
                            from wsxml_sfg.registrofacturacion rf,
                                 wsxml_sfg.producto            p
                           where rf.codtiporegistro = 1
                             and rf.codproducto = p.id_producto
                             and rf.codentradaarchivocontrol in
                                 (select ac.id_entradaarchivocontrol
                                    from WSXML_SFG.entradaarchivocontrol ac
                                   where ac.tipoarchivo = 1
                                     and ac.fechaarchivo BETWEEN
                                         @fechaarchivoMIN AND @fechaarchivoMAX)
                             and p.codaliadoestrategico in
                                 (select al.codaliadoestrategico
                                    from wsxml_sfg.archivotransaccionaliado al
                                   where al.id_archivotransaccionaliado =
                                         @p_CODARCHIVOTRANSACCIONALIADO))
                   --order by rfr.numeroreferencia
				   ) RF
           WHERE RF.VALORTRANSACCION = @p_VALORTRANSACCION
             AND CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
                 CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
             and isnull(rf.codtransaccionaliado, 0) = 0
             ---and

          IF @@ROWCOUNT = 0 BEGIN
          
            IF @vINCREMENTOS <= 7 BEGIN
              SET @vINCREMENTOS = @vINCREMENTOS + 1;
              --fechaarchivoMAX := fechaarchivoMAX + 1;
              SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
              GOTO REINTENTO;
            END
            ELSE BEGIN
              SELECT NULL;
            END 
          
			end;
      
		end;
    -- Insert right away. Cross reference will be updated
    INSERT INTO WSXML_SFG.TRANSACCIONALIADO
      (
       CODARCHIVOTRANSACCIONALIADO,
       NUMERORECIBO,
       NUMEROSUSCRIPTOR,
       VALORTRANSACCION,
       REVENUETRANSACCION,
       CODENTRADAARCHIVOCONTROL,
       CODREGISTROFACTURACION,
       CODREGISTROFACTREFERENCIA,
       CODPUNTODEVENTA,
       CODPRODUCTO)
    VALUES
      (
       @p_CODARCHIVOTRANSACCIONALIADO,
       @p_NUMERORECIBO,
       @p_NUMEROSUSCRIPTOR,
       @p_VALORTRANSACCION,
       0,
       @xCODENTRADAARCHIVOCONTROL,
       @xCODREGISTROFACTURACION,
       @xCODREGISTROFACTREFERENCIA,
       @xCODPUNTODEVENTA,
       @xCODPRODUCTO);
    SET @p_ID_TRANSACCIONALIADO_out = SCOPE_IDENTITY();
  
		BEGIN
		BEGIN TRY
		  -- Calculate transaction revenue
		  IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
			EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale
								@p_ID_TRANSACCIONALIADO_out,
								 @xCODREGISTROFACTREFERENCIA,
								 @xFECHAARCHIVO,
								 @xCODENTRADAARCHIVOCONTROL,
								 @xCODREGISTROFACTURACION,
								 @xCODPUNTODEVENTA,
								 @xCODPRODUCTO,
								 @p_VALORTRANSACCION,
								 0
		  END 
		END TRY
		BEGIN CATCH
			SELECT NULL;
		END CATCH
    END;
	END
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFileTransaction', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFileTransaction;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFileTransaction(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                @p_NUMERORECIBO                VARCHAR(4000),
                                @p_NUMEROSUSCRIPTOR            VARCHAR(4000),
                                @p_VALORTRANSACCION            FLOAT,
                                @p_CHECKAMOUNT                 INT,
                                @p_TRIMRIGHTRECEIPT            INT,
                                @p_TRIMRIGHTSUSCRIBER          INT,
                                @p_ID_TRANSACCIONALIADO_out    NUMERIC(22,0) OUT,
                                @p_TRANSACCIONENCONTRADA_out   NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xFECHAARCHIVO              DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL  NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION    NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA           NUMERIC(22,0);
    DECLARE @xCODPRODUCTO               NUMERIC(22,0);
    DECLARE @lstcachetransactions       LONGNUMBERARRAY;
    DECLARE @fechaarchivoMIN            DATETIME;
    DECLARE @fechaarchivoMAX            DATETIME;
    DECLARE @vCODALIADO                 NUMERIC(22,0);
    DECLARE @vINCREMENTOS               NUMERIC(22,0) = 0;
    DECLARE @v_TIPO_REGISTRO            NUMERIC(22,0) = 1;
   
  SET NOCOUNT ON;
    SET @p_TRANSACCIONENCONTRADA_out = 0;
  
    select @vCODALIADO = al.codaliadoestrategico
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    select @fechaarchivoMAX = CONVERT(DATETIME,al.fechaarchivo) + @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
      from wsxml_sfg.archivotransaccionaliado al
     where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
  
    if @vCODALIADO = 708 begin
      --PROCESSA NO EVALUA VALOR
      REINTENTO_PROCESSA:
      BEGIN
        SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
          FROM (select rfr.id_registrofactreferencia,
                       codtransaccionaliado,
                       SUSCRIPTOR,
                       RECIBO,
					   ROW_NUMBER() OVER(order by rfr.numeroreferencia ASC) AS ROWID
                  from wsxml_sfg.registrofactreferencia rfr
                 where rfr.codregistrofacturacion in
                       (select rf.id_registrofacturacion
                          from wsxml_sfg.registrofacturacion rf,
                               wsxml_sfg.producto            p
                         where rf.codtiporegistro = 1
                           and rf.codproducto = p.id_producto
                           and rf.codentradaarchivocontrol in
                               (select ac.id_entradaarchivocontrol
                                  from WSXML_SFG.entradaarchivocontrol ac
                                 where ac.tipoarchivo = 1
                                   and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
                                       @fechaarchivoMAX)
                           and p.codaliadoestrategico in (@vCODALIADO))
                 --order by rfr.numeroreferencia
				 ) RF
         WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
               CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
           AND CAST(isnull(RTRIM(LTRIM(substring(RF.SUSCRIPTOR,1,4))), 0) AS NUMERIC(38,0))  =
               CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
           and isnull(rf.codtransaccionaliado, 0) = 0
           --and;
      
		  IF @@ROWCOUNT = 0
          BEGIN
            SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
              FROM (select rfr.id_registrofactreferencia,
                           codtransaccionaliado,
                           SUSCRIPTOR,
                           RECIBO,
						   ROW_NUMBER() OVER( order by rfr.numeroreferencia) AS ROWID
                      from wsxml_sfg.registrofactreferencia rfr
                     where rfr.codregistrofacturacion in
                           (select rf.id_registrofacturacion
                              from wsxml_sfg.registrofacturacion rf,
                                   wsxml_sfg.producto            p
                             where /*rf.codtiporegistro = 1
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   and */
                             rf.codproducto = p.id_producto
                          and rf.codentradaarchivocontrol in
                             (select ac.id_entradaarchivocontrol
                                from WSXML_SFG.entradaarchivocontrol ac
                               where ac.tipoarchivo = 1
                                 and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
                                     @fechaarchivoMAX)
                          and p.codaliadoestrategico in (@vCODALIADO))
                     --order by rfr.numeroreferencia
				) RF
             WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
                   CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
               AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
                   CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
               and isnull(rf.codtransaccionaliado, 0) = 0
               --and;
          
				SET @v_TIPO_REGISTRO = 5;
          
			  IF @@ROWCOUNT = 0 BEGIN
				  IF @vINCREMENTOS <= 7 BEGIN
					SET @vINCREMENTOS = @vINCREMENTOS + 1;
					--fechaarchivoMAX := fechaarchivoMAX + 1;
					SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
					GOTO REINTENTO_PROCESSA;
				  END
				  ELSE BEGIN
					SELECT NULL;
				  END 
				END 
          end;
        
      end;
    end
    else if @vCODALIADO = 508 begin
      --PILA NO EVALUA RECIBO
      REINTENTO_PILA:
      BEGIN
			SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
			  FROM (select rfr.id_registrofactreferencia,
						   codtransaccionaliado,
						   SUSCRIPTOR,
						   RECIBO,
						   VALORTRANSACCION,
						   ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
					  from wsxml_sfg.registrofactreferencia rfr
					 where rfr.codregistrofacturacion in
						   (select rf.id_registrofacturacion
							  from wsxml_sfg.registrofacturacion rf,
								   wsxml_sfg.producto            p
							 where rf.codtiporegistro = 1
							   and rf.codproducto = p.id_producto
							   and rf.codentradaarchivocontrol in
								   (select ac.id_entradaarchivocontrol
									  from WSXML_SFG.entradaarchivocontrol ac
									 where ac.tipoarchivo = 1
									   and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
										   @fechaarchivoMAX)
							   and p.codaliadoestrategico in (@vCODALIADO))
					 --order by rfr.numeroreferencia
					 ) RF
			 WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
				   CAST(isnull(@p_NUMERORECIBO, 0)  AS NUMERIC(38,0))
			   AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
				  /*AND TO_NUMBER(nvl(RF.SUSCRIPTOR, 0)) =
				  TO_NUMBER(nvl(p_NUMEROSUSCRIPTOR, 0))*/
			   and isnull(rf.codtransaccionaliado, 0) = 0
			   --and;
      
		  IF @@ROWCOUNT = 0 BEGIN
			  IF @vINCREMENTOS <= 7 BEGIN
				SET @vINCREMENTOS = @vINCREMENTOS + 1;
				--fechaarchivoMAX := fechaarchivoMAX + 1;
				SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
				GOTO REINTENTO_PILA;
			  END
			  ELSE BEGIN
				SELECT NULL;
			  END 
			END
      end;
    end
    else if @vCODALIADO = 267 begin
      --MOVISTAR EVALUA SUSCRIPTOR CONTRA RECIBO SFG
      REINTENTO_MOVISTAR:
      BEGIN
        SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
          FROM (select rfr.id_registrofactreferencia,
                       codtransaccionaliado,
                       SUSCRIPTOR,
                       RECIBO,
                       VALORTRANSACCION,
						ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
                  from wsxml_sfg.registrofactreferencia rfr
                 where rfr.codregistrofacturacion in
                       (select rf.id_registrofacturacion
                          from wsxml_sfg.registrofacturacion rf,
                               wsxml_sfg.producto            p
                         where rf.codtiporegistro = 1
                           and rf.codproducto = p.id_producto
                           and rf.codentradaarchivocontrol in
                               (select ac.id_entradaarchivocontrol
                                  from WSXML_SFG.entradaarchivocontrol ac
                                 where ac.tipoarchivo = 1
                                   and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
                                       @fechaarchivoMAX)
                           and p.codaliadoestrategico in (@vCODALIADO))
                 --order by rfr.numeroreferencia
				 ) RF
         WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
               CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
           AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
              /*AND TO_NUMBER(nvl(RF.SUSCRIPTOR, 0)) =
              TO_NUMBER(nvl(p_NUMEROSUSCRIPTOR, 0))*/
           and isnull(rf.codtransaccionaliado, 0) = 0
           --and;
      
		  IF @@ROWCOUNT = 0
        
          --MOVISTAR EVALUA SUSCRIPTOR CONTRA SUSCRIPTOR SFG
          BEGIN
            SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
              FROM (select rfr.id_registrofactreferencia,
                           codtransaccionaliado,
                           SUSCRIPTOR,
                           RECIBO,
                           VALORTRANSACCION,
						   ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
                      from wsxml_sfg.registrofactreferencia rfr
                     where rfr.codregistrofacturacion in
                           (select rf.id_registrofacturacion
                              from wsxml_sfg.registrofacturacion rf,
                                   wsxml_sfg.producto            p
                             where rf.codtiporegistro = 1
                               and rf.codproducto = p.id_producto
                               and rf.codentradaarchivocontrol in
                                   (select ac.id_entradaarchivocontrol
                                      from WSXML_SFG.entradaarchivocontrol ac
                                     where ac.tipoarchivo = 1
                                       and ac.fechaarchivo BETWEEN
                                           @fechaarchivoMIN AND @fechaarchivoMAX)
                               and p.codaliadoestrategico in (@vCODALIADO))
                     --order by rfr.numeroreferencia
					 ) RF
             WHERE /*TO_NUMBER(nvl(RF.RECIBO, 0)) =
                                                                                                                                                                                                                                                                                                               TO_NUMBER(nvl(p_NUMERORECIBO, 0))
                                                                                                                                                                                                                                                                                                           AND*/
             RF.VALORTRANSACCION = @p_VALORTRANSACCION
             AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
             CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
             and isnull(rf.codtransaccionaliado, 0) = 0
             --and;
          
			  IF @@ROWCOUNT = 0 BEGIN

					  IF @vINCREMENTOS <= 7 BEGIN
						SET @vINCREMENTOS = @vINCREMENTOS + 1;
						--fechaarchivoMAX := fechaarchivoMAX + 1;
						SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
						GOTO REINTENTO_MOVISTAR;
					  END
					  ELSE BEGIN
						SELECT NULL;
					  END 
				END
          end;
        
      end;
    end
    else if @vCODALIADO not in (708, 508, 267) begin
      REINTENTO:
      begin
			BEGIN TRY
				SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
			  FROM (select rfr.id_registrofactreferencia,
						   codtransaccionaliado,
						   SUSCRIPTOR,
						   RECIBO,
						   VALORTRANSACCION,
						   ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
					  from wsxml_sfg.registrofactreferencia rfr
					 where rfr.codregistrofacturacion in
						   (select rf.id_registrofacturacion
							  from wsxml_sfg.registrofacturacion rf,
								   wsxml_sfg.producto            p
							 where rf.codtiporegistro = 1
							   and rf.codproducto = p.id_producto
							   and rf.codentradaarchivocontrol in
								   (select ac.id_entradaarchivocontrol
									  from WSXML_SFG.entradaarchivocontrol ac
									 where ac.tipoarchivo = 1
									   and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
										   @fechaarchivoMAX)
							   and p.codaliadoestrategico in (@vCODALIADO))
					 --order by rfr.numeroreferencia
					 ) RF
			 WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
				   CAST(isnull(@p_NUMERORECIBO, 0)  AS NUMERIC(38,0))
			   AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
			   AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0)  AS NUMERIC(38,0)) =
				   CAST(isnull(@p_NUMEROSUSCRIPTOR, 0)  AS NUMERIC(38,0))
			   and isnull(rf.codtransaccionaliado, 0) = 0
				--and;
			END TRY
			BEGIN CATCH
			  IF @vINCREMENTOS <= 7 BEGIN
				SET @vINCREMENTOS = @vINCREMENTOS + 1;
				--fechaarchivoMAX := fechaarchivoMAX + 1;
				SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
				GOTO REINTENTO;
			  END
			  ELSE BEGIN
          
				--buscar sin recibo
				begin
					BEGIN TRY
              
					SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
					FROM (select rfr.id_registrofactreferencia,
								 codtransaccionaliado,
								 SUSCRIPTOR,
								 RECIBO,
								 VALORTRANSACCION,
								 ROW_NUMBER() OVER(order by rfr.numeroreferencia asc) AS ROWID
							from wsxml_sfg.registrofactreferencia rfr
						   where rfr.codregistrofacturacion in
								 (select rf.id_registrofacturacion
									from wsxml_sfg.registrofacturacion rf,
										 wsxml_sfg.producto            p
								   where rf.codtiporegistro = 1
									 and rf.codproducto = p.id_producto
									 and rf.codentradaarchivocontrol in
										 (select ac.id_entradaarchivocontrol
											from WSXML_SFG.entradaarchivocontrol ac
										   where ac.tipoarchivo = 1
											 and ac.fechaarchivo BETWEEN
												 @fechaarchivoMIN AND
												 @fechaarchivoMAX)
									 and p.codaliadoestrategico in (@vCODALIADO))
						   --order by rfr.numeroreferencia
						 ) RF
				   WHERE RF.VALORTRANSACCION = @p_VALORTRANSACCION
					 AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
						 CAST(isnull(@p_NUMEROSUSCRIPTOR, 0)  AS NUMERIC(38,0))
					 and isnull(rf.codtransaccionaliado, 0) = 0
					 --and;
					END TRY
					BEGIN CATCH
						IF @vINCREMENTOS <= 7 BEGIN
						  SET @vINCREMENTOS = @vINCREMENTOS + 1;
						  --fechaarchivoMAX := fechaarchivoMAX + 1;
						  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
						  GOTO REINTENTO;
						END
						ELSE BEGIN
					  --buscar sin suscriptor
								SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
						  FROM (select rfr.id_registrofactreferencia,
									   codtransaccionaliado,
									   SUSCRIPTOR,
									   RECIBO,
									   VALORTRANSACCION,
									   ROW_NUMBER() OVER(order by rfr.numeroreferencia ASC) AS ROWID
								  from wsxml_sfg.registrofactreferencia rfr
								 where rfr.codregistrofacturacion in
									   (select rf.id_registrofacturacion
										  from wsxml_sfg.registrofacturacion rf,
											   wsxml_sfg.producto            p
										 where rf.codtiporegistro = 1
										   and rf.codproducto = p.id_producto
										   and rf.codentradaarchivocontrol in
											   (select ac.id_entradaarchivocontrol
												  from WSXML_SFG.entradaarchivocontrol ac
												 where ac.tipoarchivo = 1
												   and ac.fechaarchivo BETWEEN
													   @fechaarchivoMIN AND
													   @fechaarchivoMAX)
										   and p.codaliadoestrategico in
											   (@vCODALIADO))
								 --order by rfr.numeroreferencia
								) RF
						 WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
							   CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
						   AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
						   and isnull(rf.codtransaccionaliado, 0) = 0
						   --and;
							  IF @@ROWCOUNT = 0 BEGIN
								  IF @vINCREMENTOS <= 7 BEGIN
									SET @vINCREMENTOS = @vINCREMENTOS + 1;
									--fechaarchivoMAX := fechaarchivoMAX + 1;
									SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
									GOTO REINTENTO;
								  END
								  ELSE BEGIN
									--buscar sin suscriptor y sin recibo
									begin
									  SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
										FROM (select rfr.id_registrofactreferencia,
													 codtransaccionaliado,
													 SUSCRIPTOR,
													 RECIBO,
													 VALORTRANSACCION,
													 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
												from wsxml_sfg.registrofactreferencia rfr
											   where rfr.codregistrofacturacion in
													 (select rf.id_registrofacturacion
														from wsxml_sfg.registrofacturacion rf,
															 wsxml_sfg.producto            p
													   where rf.codtiporegistro = 1
														 and rf.codproducto =
															 p.id_producto
														 and rf.codentradaarchivocontrol in
															 (select ac.id_entradaarchivocontrol
																from WSXML_SFG.entradaarchivocontrol ac
															   where ac.tipoarchivo = 1
																 and ac.fechaarchivo BETWEEN
																	 @fechaarchivoMIN AND
																	 @fechaarchivoMAX)
														 and p.codaliadoestrategico in
															 (@vCODALIADO))
											   --order by rfr.numeroreferencia
											   ) RF
									   WHERE RF.VALORTRANSACCION = @p_VALORTRANSACCION
										 and isnull(rf.codtransaccionaliado, 0) = 0
										 --and;
										IF @@ROWCOUNT = 0 BEGIN
											IF @vINCREMENTOS <= 7 BEGIN
											  SET @vINCREMENTOS = @vINCREMENTOS + 1;
											  --fechaarchivoMAX := fechaarchivoMAX + 1;
											  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
											  GOTO REINTENTO;
											END
											ELSE BEGIN
											  SELECT NULL;
											END 
										END 
									end;
								  END 
							  END
					 end;
					END CATCH
				END;
			  END 
			END CATCH
      end;
    end  
    if @vCODALIADO = 708 begin
    
    IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
      
        -- Insert right away. Cross reference will be updated
        INSERT INTO WSXML_SFG.TRANSACCIONALIADO
          (
           CODARCHIVOTRANSACCIONALIADO,
           NUMERORECIBO,
           NUMEROSUSCRIPTOR,
           VALORTRANSACCION,
           REVENUETRANSACCION,
           CODENTRADAARCHIVOCONTROL,
           CODREGISTROFACTURACION,
           CODREGISTROFACTREFERENCIA,
           CODPUNTODEVENTA,
           CODPRODUCTO)
        VALUES
          (
           @p_CODARCHIVOTRANSACCIONALIADO,
           @p_NUMERORECIBO,
           @p_NUMEROSUSCRIPTOR,
           @p_VALORTRANSACCION,
           0,
           @xCODENTRADAARCHIVOCONTROL,
           @xCODREGISTROFACTURACION,
           @xCODREGISTROFACTREFERENCIA,
           @xCODPUNTODEVENTA,
           @xCODPRODUCTO);
        SET @p_ID_TRANSACCIONALIADO_out = SCOPE_IDENTITY();
      
      end
      else begin
      
        -- Insert right away. Cross reference will be updated
        INSERT INTO WSXML_SFG.TRANSACCIONALIADO
          (
           CODARCHIVOTRANSACCIONALIADO,
           NUMERORECIBO,
           NUMEROSUSCRIPTOR,
           VALORTRANSACCION,
           REVENUETRANSACCION,
           CODENTRADAARCHIVOCONTROL,
           CODREGISTROFACTURACION,
           CODREGISTROFACTREFERENCIA,
           CODPUNTODEVENTA,
           CODPRODUCTO)
        VALUES
          (
           @p_CODARCHIVOTRANSACCIONALIADO,
           @p_NUMERORECIBO,
           @p_NUMEROSUSCRIPTOR,
           0,
           0,
           @xCODENTRADAARCHIVOCONTROL,
           @xCODREGISTROFACTURACION,
           @xCODREGISTROFACTREFERENCIA,
           @xCODPUNTODEVENTA,
           @xCODPRODUCTO);
        SET @p_ID_TRANSACCIONALIADO_out = SCOPE_IDENTITY();
      end 
    
    end
    else begin
      -- Insert right away. Cross reference will be updated
      INSERT INTO WSXML_SFG.TRANSACCIONALIADO
        (
         CODARCHIVOTRANSACCIONALIADO,
         NUMERORECIBO,
         NUMEROSUSCRIPTOR,
         VALORTRANSACCION,
         REVENUETRANSACCION,
         CODENTRADAARCHIVOCONTROL,
         CODREGISTROFACTURACION,
         CODREGISTROFACTREFERENCIA,
         CODPUNTODEVENTA,
         CODPRODUCTO)
      VALUES
        (
         @p_CODARCHIVOTRANSACCIONALIADO,
         @p_NUMERORECIBO,
         @p_NUMEROSUSCRIPTOR,
         @p_VALORTRANSACCION,
         0,
         @xCODENTRADAARCHIVOCONTROL,
         @xCODREGISTROFACTURACION,
         @xCODREGISTROFACTREFERENCIA,
         @xCODPUNTODEVENTA,
         @xCODPRODUCTO);
      SET @p_ID_TRANSACCIONALIADO_out = SCOPE_IDENTITY();
    end 

    BEGIN
		BEGIN TRY
			  -- Calculate transaction revenue
			  IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
      
				EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale
									@p_ID_TRANSACCIONALIADO_out,
									 @xCODREGISTROFACTREFERENCIA,
									 @xFECHAARCHIVO,
									 @xCODENTRADAARCHIVOCONTROL,
									 @xCODREGISTROFACTURACION,
									 @xCODPUNTODEVENTA,
									 @xCODPRODUCTO,
									 @p_VALORTRANSACCION,
									 0

				if @v_TIPO_REGISTRO = 5 begin
        
				  UPDATE WSXML_SFG.TRANSACCIONALIADO
					 SET VALORTRANSACCION        = 0,
						 CODRANGOCOMISION        = NULL,
						 REVENUETRANSACCION      = 0,
						 REVENUEPORCENTUAL       = 0,
						 REVENUETRANSACCIONAL    = 0,
						 REVENUEFIJO             = 0,
						 CODRANGOCOMISIONDETALLE = NULL
				   WHERE ID_TRANSACCIONALIADO = @p_ID_TRANSACCIONALIADO_out;
        
				end 
			  END 
		END TRY
		BEGIN CATCH
				SELECT NULL;
		END CATCH
    END;
  END;
  GO


  -- MUST BE IN CACHE
  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessened', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessened;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessened(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                  @p_COUNTNOVINCULADOS           NUMERIC(22,0) OUT) AS
 BEGIN
  
    DECLARE @p_NUMERORECIBO              NVARCHAR(255);
    DECLARE @p_NUMEROSUSCRIPTOR          NVARCHAR(255);
    DECLARE @p_VALORTRANSACCION          FLOAT;
    DECLARE @p_CHECKAMOUNT               INT;
    DECLARE @p_TRIMRIGHTRECEIPT          INT;
    DECLARE @p_TRIMRIGHTSUSCRIBER        INT;
    DECLARE @p_ID_TRANSACCIONALIADO_out  NUMERIC(22,0);
    DECLARE @p_TRANSACCIONENCONTRADA_out NUMERIC(22,0);
    DECLARE @xFECHAARCHIVO               DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL   NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION     NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA  NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA            NUMERIC(22,0);
    DECLARE @xCODPRODUCTO                NUMERIC(22,0);
    DECLARE @lstcachetransactions        WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @fechaarchivoMIN             DATETIME;
    DECLARE @fechaarchivoMAX             DATETIME;
    DECLARE @vCODALIADO                  NUMERIC(22,0);
    DECLARE @vINCREMENTOS                NUMERIC(22,0) = 0;
    DECLARE @v_TIPO_REGISTRO             NUMERIC(22,0) = 1;
  
   
  SET NOCOUNT ON;
    /* Trace Invoke
    declare
      allyname aliadoestrategico.nomaliadoestrategico%type;
      filename archivotransaccionaliado.nombrearchivo%type;
    begin
      select nomaliadoestrategico, nombrearchivo into allyname, filename from archivotransaccionaliado, aliadoestrategico
      where codaliadoestrategico = id_aliadoestrategico and id_archivotransaccionaliado = p_codarchivotransaccionaliado;
      sfgtmptrace.tracelog('Invoked Reprocess File Lessened for file ' || filename || ' (' || p_codarchivotransaccionaliado || ') for ally ' || allyname);
      COMMIT;
    exception when others then
      null;
    end;
     End Trace Invoke */
  
    SET @p_COUNTNOVINCULADOS = 0;
    SELECT @p_COUNTNOVINCULADOS = SUM(CASE
                 WHEN CODREGISTROFACTREFERENCIA IS NULL THEN
                  1
                 ELSE
                  0
               END)
      FROM WSXML_SFG.TRANSACCIONALIADO
     WHERE CODARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
  
    DECLARE tx CURSOR FOR SELECT FECHAARCHIVO,
                      CODALIADOESTRATEGICO,
                      ID_TRANSACCIONALIADO,
                      NUMERORECIBO,
                      NUMEROSUSCRIPTOR,
                      VALORTRANSACCION,
                      CHECKAMOUNT,
                      TRIMRIGHTRECEIPT,
                      TRIMRIGHTSUSCRIBER,
                      CONFIGURACION,
                      TRANSACCIONALIADO.COMPENSADO
                 FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
                INNER JOIN WSXML_SFG.TRANSACCIONALIADO
                   ON (CODARCHIVOTRANSACCIONALIADO =
                      ID_ARCHIVOTRANSACCIONALIADO)
                INNER JOIN WSXML_SFG.FORMATOARCHIVOTRANSACCION
                   ON (CODFORMATOARCHIVOTRANSACCION =
                      ID_FORMATOARCHIVOTRANSACCION)
                WHERE ID_ARCHIVOTRANSACCIONALIADO =
                      @p_CODARCHIVOTRANSACCIONALIADO
                  AND CODREGISTROFACTREFERENCIA IS NULL; OPEN tx;
		
		DECLARE @tx__FECHAARCHIVO NUMERIC(38,0),
                      @tx__CODALIADOESTRATEGICO NUMERIC(38,0),
                      @tx__ID_TRANSACCIONALIADO NUMERIC(38,0),
                      @tx__NUMERORECIBO NUMERIC(38,0),
                      @tx__NUMEROSUSCRIPTOR NUMERIC(38,0),
                      @tx__VALORTRANSACCION FLOAT,
                      @tx__CHECKAMOUNT FLOAT,
                      @tx__TRIMRIGHTRECEIPT NUMERIC(38,0),
                      @tx__TRIMRIGHTSUSCRIBER NUMERIC(38,0),
                      @tx__CONFIGURACION VARCHAR(20),
                      @tx__COMPENSADO NUMERIC(38,0)

	 FETCH NEXT FROM tx INTO @tx__FECHAARCHIVO,
                      @tx__CODALIADOESTRATEGICO,
                      @tx__ID_TRANSACCIONALIADO,
                      @tx__NUMERORECIBO,
                      @tx__NUMEROSUSCRIPTOR,
                      @tx__VALORTRANSACCION,
                      @tx__CHECKAMOUNT,
                      @tx__TRIMRIGHTRECEIPT,
                      @tx__TRIMRIGHTSUSCRIBER,
                      @tx__CONFIGURACION,
                      @tx__COMPENSADO;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
    
      SET @v_TIPO_REGISTRO = 1;
    
      SET @p_NUMERORECIBO     = @tx__NUMERORECIBO;
      SET @p_NUMEROSUSCRIPTOR = @tx__NUMEROSUSCRIPTOR;
      SET @p_VALORTRANSACCION = @tx__VALORTRANSACCION;
    
      SET @p_TRANSACCIONENCONTRADA_out = 0;
    
      select @vCODALIADO = al.codaliadoestrategico
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      select @fechaarchivoMAX = CONVERT(DATETIME,al.fechaarchivo) + @vINCREMENTOS
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      if @vCODALIADO = 708 begin
        --PROCESSA NO EVALUA VALOR
        REINTENTO_PROCESSA:
        BEGIN
          SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
            FROM (select rfr.id_registrofactreferencia,
                         codtransaccionaliado,
                         SUSCRIPTOR,
                         RECIBO,
						 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
                    from wsxml_sfg.registrofactreferencia rfr
                   where rfr.codregistrofacturacion in
                         (select rf.id_registrofacturacion
                            from wsxml_sfg.registrofacturacion rf,
                                 wsxml_sfg.producto            p
                           where rf.codtiporegistro = 1
                             and rf.codproducto = p.id_producto
                             and rf.codentradaarchivocontrol in
                                 (select ac.id_entradaarchivocontrol
                                    from WSXML_SFG.entradaarchivocontrol ac
                                   where ac.tipoarchivo = 1
                                     and ac.fechaarchivo BETWEEN
                                         @fechaarchivoMIN AND @fechaarchivoMAX)
                             and p.codaliadoestrategico in
                                 (select al.codaliadoestrategico
                                    from wsxml_sfg.archivotransaccionaliado al
                                   where al.id_archivotransaccionaliado =
                                         @p_CODARCHIVOTRANSACCIONALIADO))
                   --order by rfr.numeroreferencia
				   ) RF
           WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
                 CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
             AND CAST(isnull(RTRIM(LTRIM(substring(RF.SUSCRIPTOR,1,4))), 0) AS NUMERIC(38,0)) =
                 CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
             and isnull(rf.codtransaccionaliado, 0) = 0
             --and;
        
          SET @v_TIPO_REGISTRO = 1;
        
			IF @@ROWCOUNT = 0 
            BEGIN
              SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
                FROM (select rfr.id_registrofactreferencia,
                             codtransaccionaliado,
                             SUSCRIPTOR,
                             RECIBO,
							 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
                        from wsxml_sfg.registrofactreferencia rfr
                       where rfr.codregistrofacturacion in
                             (select rf.id_registrofacturacion
                                from wsxml_sfg.registrofacturacion rf,
                                     wsxml_sfg.producto            p
                               where /*rf.codtiporegistro = 1
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   and*/
                               rf.codproducto = p.id_producto
                            and rf.codentradaarchivocontrol in
                               (select ac.id_entradaarchivocontrol
                                  from WSXML_SFG.entradaarchivocontrol ac
                                 where ac.tipoarchivo = 1
                                   and ac.fechaarchivo BETWEEN @fechaarchivoMIN AND
                                       @fechaarchivoMAX)
                            and p.codaliadoestrategico in
                               (select al.codaliadoestrategico
                                  from wsxml_sfg.archivotransaccionaliado al
                                 where al.id_archivotransaccionaliado =
                                       @p_CODARCHIVOTRANSACCIONALIADO))
                       --order by rfr.numeroreferencia
					   ) RF
               WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
                     CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
                 AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
                     CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
                 and isnull(rf.codtransaccionaliado, 0) = 0
                 --and;
            
              SET @v_TIPO_REGISTRO = 5;
            
			  IF @@ROWCOUNT = 0 BEGIN
					IF @vINCREMENTOS <= 7 BEGIN
					  SET @vINCREMENTOS = @vINCREMENTOS + 1;
					  --fechaarchivoMAX := fechaarchivoMAX + 1;
					  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
					  GOTO REINTENTO_PROCESSA;
					END
					ELSE BEGIN
					  SELECT NULL;
					END 
              END
            end;
          
        end;
      end
      else if @vCODALIADO = 267 begin
        --MOVISTAR EVALUA SUSCRIPTOR CONTRA RECIBO SFG
        REINTENTO_MOVISTAR:
        BEGIN
          SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
            FROM (select rfr.id_registrofactreferencia,
                         codtransaccionaliado,
                         SUSCRIPTOR,
                         RECIBO,
                         VALORTRANSACCION,
						 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
                    from wsxml_sfg.registrofactreferencia rfr
                   where rfr.codregistrofacturacion in
                         (select rf.id_registrofacturacion
                            from wsxml_sfg.registrofacturacion rf,
                                 wsxml_sfg.producto            p
                           where rf.codtiporegistro = 1
                             and rf.codproducto = p.id_producto
                             and rf.codentradaarchivocontrol in
                                 (select ac.id_entradaarchivocontrol
                                    from WSXML_SFG.entradaarchivocontrol ac
                                   where ac.tipoarchivo = 1
                                     and ac.fechaarchivo BETWEEN
                                         @fechaarchivoMIN AND @fechaarchivoMAX)
                             and p.codaliadoestrategico in (@vCODALIADO))
                   --order by rfr.numeroreferencia
				   ) RF
           WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
                 CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
             AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
                /*AND TO_NUMBER(nvl(RF.SUSCRIPTOR, 0)) =
                TO_NUMBER(nvl(p_NUMEROSUSCRIPTOR, 0))*/
             and isnull(rf.codtransaccionaliado, 0) = 0
             --and;
        
			IF @@ROWCOUNT = 0
            --MOVISTAR EVALUA SUSCRIPTOR CONTRA SUSCRIPTOR SFG
				BEGIN
				BEGIN TRY
					  SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
						FROM (select rfr.id_registrofactreferencia,
									 codtransaccionaliado,
									 SUSCRIPTOR,
									 RECIBO,
									 VALORTRANSACCION,
									 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
								from wsxml_sfg.registrofactreferencia rfr
							   where rfr.codregistrofacturacion in
									 (select rf.id_registrofacturacion
										from wsxml_sfg.registrofacturacion rf,
											 wsxml_sfg.producto            p
									   where rf.codtiporegistro = 1
										 and rf.codproducto = p.id_producto
										 and rf.codentradaarchivocontrol in
											 (select ac.id_entradaarchivocontrol
												from WSXML_SFG.entradaarchivocontrol ac
											   where ac.tipoarchivo = 1
												 and ac.fechaarchivo BETWEEN
													 @fechaarchivoMIN AND
													 @fechaarchivoMAX)
										 and p.codaliadoestrategico in (@vCODALIADO))
							   --order by rfr.numeroreferencia
							   ) RF
					   WHERE /*TO_NUMBER(nvl(RF.RECIBO, 0)) =
																																																																																									 TO_NUMBER(nvl(p_NUMERORECIBO, 0))
																																																																																								 AND*/
					   RF.VALORTRANSACCION = @p_VALORTRANSACCION
					   AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
					   CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
					   and isnull(rf.codtransaccionaliado, 0) = 0
					   --and;
				END TRY
				BEGIN CATCH
						IF @vINCREMENTOS <= 7 BEGIN
						  SET @vINCREMENTOS = @vINCREMENTOS + 1;
						  --fechaarchivoMAX := fechaarchivoMAX + 1;
						  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
						  GOTO REINTENTO_MOVISTAR;
						END
						ELSE BEGIN
							SELECT NULL;
						END 
				END CATCH
            end;
          
        end;
      end
      else if @vCODALIADO not in (708, 508, 267) begin
        REINTENTO:
        begin
			BEGIN TRY
        
				SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
            FROM (select rfr.id_registrofactreferencia,
                         codtransaccionaliado,
                         SUSCRIPTOR,
                         RECIBO,
                         VALORTRANSACCION,
						 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
                    from wsxml_sfg.registrofactreferencia rfr
                   where rfr.codregistrofacturacion in
                         (select rf.id_registrofacturacion
                            from wsxml_sfg.registrofacturacion rf,
                                 wsxml_sfg.producto            p
                           where rf.codtiporegistro = 1
                             and rf.codproducto = p.id_producto
                             and rf.codentradaarchivocontrol in
                                 (select ac.id_entradaarchivocontrol
                                    from WSXML_SFG.entradaarchivocontrol ac
                                   where ac.tipoarchivo = 1
                                     and ac.fechaarchivo BETWEEN
                                         @fechaarchivoMIN AND @fechaarchivoMAX)
                             and p.codaliadoestrategico in
                                 (select al.codaliadoestrategico
                                    from wsxml_sfg.archivotransaccionaliado al
                                   where al.id_archivotransaccionaliado =
                                         @p_CODARCHIVOTRANSACCIONALIADO))
                   --order by rfr.numeroreferencia
				   ) RF
           WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
                 CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
             AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
             AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0) AS NUMERIC(38,0)) =
                 CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
             and isnull(rf.codtransaccionaliado, 0) = 0
					--and;
			END TRY
			BEGIN CATCH
				IF @vINCREMENTOS <= 7 BEGIN
				  SET @vINCREMENTOS = @vINCREMENTOS + 1;
				  --fechaarchivoMAX := fechaarchivoMAX + 1;
				  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
				  GOTO REINTENTO;
				END
				ELSE BEGIN
            
				  --buscar sin recibo
				  begin
				  BEGIN TRY
					SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
					  FROM (select rfr.id_registrofactreferencia,
								   codtransaccionaliado,
								   SUSCRIPTOR,
								   RECIBO,
								   VALORTRANSACCION,
								   ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
							  from wsxml_sfg.registrofactreferencia rfr
							 where rfr.codregistrofacturacion in
								   (select rf.id_registrofacturacion
									  from wsxml_sfg.registrofacturacion rf,
										   wsxml_sfg.producto            p
									 where rf.codtiporegistro = 1
									   and rf.codproducto = p.id_producto
									   and rf.codentradaarchivocontrol in
										   (select ac.id_entradaarchivocontrol
											  from WSXML_SFG.entradaarchivocontrol ac
											 where ac.tipoarchivo = 1
											   and ac.fechaarchivo BETWEEN
												   @fechaarchivoMIN AND
												   @fechaarchivoMAX)
									   and p.codaliadoestrategico in
										   (select al.codaliadoestrategico
											  from wsxml_sfg.archivotransaccionaliado al
											 where al.id_archivotransaccionaliado =
												   @p_CODARCHIVOTRANSACCIONALIADO))
							 --order by rfr.numeroreferencia
							 ) RF
					 WHERE RF.VALORTRANSACCION = @p_VALORTRANSACCION
					   AND CAST(isnull(RTRIM(LTRIM(RF.SUSCRIPTOR)), 0)  AS NUMERIC(38,0)) =
						   CAST(isnull(@p_NUMEROSUSCRIPTOR, 0) AS NUMERIC(38,0))
					   and isnull(rf.codtransaccionaliado, 0) = 0
					   --and;
              
				  END TRY
				  BEGIN CATCH
						  IF @vINCREMENTOS <= 7 BEGIN
							SET @vINCREMENTOS = @vINCREMENTOS + 1;
							--fechaarchivoMAX := fechaarchivoMAX + 1;
							SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
							GOTO REINTENTO;
						  END
						  ELSE BEGIN
							--buscar sin suscriptor
							begin
								BEGIN TRY
								SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
								FROM (select rfr.id_registrofactreferencia,
											 codtransaccionaliado,
											 SUSCRIPTOR,
											 RECIBO,
											 VALORTRANSACCION,
											 ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
										from wsxml_sfg.registrofactreferencia rfr
									   where rfr.codregistrofacturacion in
											 (select rf.id_registrofacturacion
												from wsxml_sfg.registrofacturacion rf,
													 wsxml_sfg.producto            p
											   where rf.codtiporegistro = 1
												 and rf.codproducto = p.id_producto
												 and rf.codentradaarchivocontrol in
													 (select ac.id_entradaarchivocontrol
														from WSXML_SFG.entradaarchivocontrol ac
													   where ac.tipoarchivo = 1
														 and ac.fechaarchivo BETWEEN
															 @fechaarchivoMIN AND
															 @fechaarchivoMAX)
												 and p.codaliadoestrategico in
													 (select al.codaliadoestrategico
														from wsxml_sfg.archivotransaccionaliado al
													   where al.id_archivotransaccionaliado =
															 @p_CODARCHIVOTRANSACCIONALIADO))
									   --order by rfr.numeroreferencia
									   ) RF
							   WHERE CAST(isnull(RTRIM(LTRIM(RF.RECIBO)), 0) AS NUMERIC(38,0)) =
									 CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
								 AND RF.VALORTRANSACCION = @p_VALORTRANSACCION
									/*AND TO_NUMBER(nvl(RF.SUSCRIPTOR,0)) = TO_NUMBER(nvl(p_NUMEROSUSCRIPTOR, 0))*/
								 and isnull(rf.codtransaccionaliado, 0) = 0
								 --and;
							  END TRY
							  BEGIN CATCH
									IF @vINCREMENTOS <= 7 BEGIN
									  SET @vINCREMENTOS = @vINCREMENTOS + 1;
									  --fechaarchivoMAX := fechaarchivoMAX + 1;
									  SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
									  GOTO REINTENTO;
									END
									ELSE BEGIN
									  --buscar sin suscriptor y sin recibo
									  begin
										BEGIN TRY
											SELECT @xCODREGISTROFACTREFERENCIA = id_registrofactreferencia
											  FROM (select rfr.id_registrofactreferencia,
														   codtransaccionaliado,
														   SUSCRIPTOR,
														   RECIBO,
														   VALORTRANSACCION,
														   ROW_NUMBER() OVER(order by rfr.numeroreferencia) AS ROWID
													  from wsxml_sfg.registrofactreferencia rfr
													 where rfr.codregistrofacturacion in
														   (select rf.id_registrofacturacion
															  from wsxml_sfg.registrofacturacion rf,
																   wsxml_sfg.producto            p
															 where rf.codtiporegistro = 1
															   and rf.codproducto =
																   p.id_producto
															   and rf.codentradaarchivocontrol in
																   (select ac.id_entradaarchivocontrol
																	  from WSXML_SFG.entradaarchivocontrol ac
																	 where ac.tipoarchivo = 1
																	   and ac.fechaarchivo BETWEEN
																		   @fechaarchivoMIN AND
																		   @fechaarchivoMAX)
															   and p.codaliadoestrategico in
																   (select al.codaliadoestrategico
																	  from wsxml_sfg.archivotransaccionaliado al
																	 where al.id_archivotransaccionaliado =
																		   @p_CODARCHIVOTRANSACCIONALIADO))
													 --order by rfr.numeroreferencia
									 
													 ) RF
											 WHERE /*TO_NUMBER(nvl(RF.RECIBO, 0)) = TO_NUMBER(nvl(p_NUMERORECIBO, 0))
																																																																																																																																																																																																																																																																																																																																																											 AND*/
											 RF.VALORTRANSACCION = @p_VALORTRANSACCION
											/*AND TO_NUMBER(nvl(RF.SUSCRIPTOR,0)) = TO_NUMBER(nvl(p_NUMEROSUSCRIPTOR, 0))*/
											 and isnull(rf.codtransaccionaliado, 0) = 0
											 --and
										END TRY
										BEGIN CATCH
											  IF @vINCREMENTOS <= 7 BEGIN
												SET @vINCREMENTOS = @vINCREMENTOS + 1;
												--fechaarchivoMAX := fechaarchivoMAX + 1;
												SET @fechaarchivoMIN = @fechaarchivoMIN - 1;
												GOTO REINTENTO;
											  END
											  ELSE BEGIN
												SELECT NULL;
											  END 
										END CATCH

									  end;
									END 
								END CATCH
							end;
						  END 
					END CATCH

				  end;
				END 
			END CATCH
		end;
      end 
    
      BEGIN
		BEGIN TRY

			IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
			  EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale @tx__ID_TRANSACCIONALIADO,@xCODREGISTROFACTREFERENCIA
			  SET @p_COUNTNOVINCULADOS = @p_COUNTNOVINCULADOS - 1;
        
			  if @v_TIPO_REGISTRO = 5 begin
				UPDATE WSXML_SFG.TRANSACCIONALIADO
				   SET VALORTRANSACCION = 0
				 WHERE ID_TRANSACCIONALIADO = @tx__ID_TRANSACCIONALIADO;
			  END 
			END 
		 END TRY
		 BEGIN CATCH
			  SELECT NULL;
		 END CATCH

      END;
    
    FETCH NEXT FROM tx INTO @tx__FECHAARCHIVO,
                      @tx__CODALIADOESTRATEGICO,
                      @tx__ID_TRANSACCIONALIADO,
                      @tx__NUMERORECIBO,
                      @tx__NUMEROSUSCRIPTOR,
                      @tx__VALORTRANSACCION,
                      @tx__CHECKAMOUNT,
                      @tx__TRIMRIGHTRECEIPT,
                      @tx__TRIMRIGHTSUSCRIBER,
                      @tx__CONFIGURACION,
                      @tx__COMPENSADO;
    END;
    CLOSE tx;
    DEALLOCATE tx;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale;
GO

CREATE     PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale(@p_CODTRANSACCIONALIADO      NUMERIC(22,0),
                                 @p_CODREGISTROFACTREFERENCIA NUMERIC(22,0),
                                 @p_FECHAARCHIVO              DATETIME = NULL,
                                 @p_CODENTRADAARCHIVOCONTROL  NUMERIC(22,0) = NULL,
                                 @p_CODREGISTROFACTURACION    NUMERIC(22,0) = NULL,
                                 @p_CODPUNTODEVENTA           NUMERIC(22,0) = NULL,
                                 @p_CODPRODUCTO               NUMERIC(22,0) = NULL,
                                 @p_VALORTRANSACCION          FLOAT = 0,
                                 @p_NEWREGISTRY               INT = 0) AS
 BEGIN
  
    DECLARE @xFECHAARCHIVO             DATETIME = @p_FECHAARCHIVO;
    DECLARE @xCODENTRADAARCHIVOCONTROL NUMERIC(22,0) = @p_CODENTRADAARCHIVOCONTROL;
    DECLARE @xCODREGISTROFACTURACION   NUMERIC(22,0) = @p_CODREGISTROFACTURACION;
    DECLARE @xVALORTRANSACCION         FLOAT = @p_VALORTRANSACCION;
    DECLARE @xCODPUNTODEVENTA          NUMERIC(22,0) = @p_CODPUNTODEVENTA;
    DECLARE @xCODPRODUCTO              NUMERIC(22,0) = @p_CODPRODUCTO;
    DECLARE @xTIPOTRANSACCION          CHAR(1);
    DECLARE @xBINTARJETA               NVARCHAR(10);
    DECLARE @xCODRANGOCOMISION         NUMERIC(22,0);
    DECLARE @xCALCULATEDREVENUE        FLOAT = 0;
    DECLARE @xCALCREVENUEPORCENTUAL    FLOAT = 0;
    DECLARE @xCALCREVENUETRANSACCNL    FLOAT = 0;
    DECLARE @xMARKEDTRANSACTION        INT = 0;
    DECLARE @V_VRCOMISION              FLOAT = 0;
    DECLARE @vCODALIADO                NUMERIC(22,0);
   
  SET NOCOUNT ON;
    IF @p_CODREGISTROFACTREFERENCIA IS NULL BEGIN
      RAISERROR('-20053 No se puede vincular la transaccion a un registro nulo', 16, 1);
    END 
    IF @p_NEWREGISTRY = 0 BEGIN
      SELECT @xFECHAARCHIVO = CTR.FECHAARCHIVO,
             @xCODENTRADAARCHIVOCONTROL = REG.CODENTRADAARCHIVOCONTROL,
             @xCODREGISTROFACTURACION = RFR.CODREGISTROFACTURACION,
             @xVALORTRANSACCION = RFR.VALORTRANSACCION,
             @xCODPUNTODEVENTA = REG.CODPUNTODEVENTA,
             @xCODPRODUCTO = REG.CODPRODUCTO,
             @xTIPOTRANSACCION = RFR.TIPOTRANSACCION,
             @xBINTARJETA = RFR.BINTARJETA,
             @xMARKEDTRANSACTION = CASE
               WHEN RFR.CODTRANSACCIONALIADO IS NULL THEN
                0
               ELSE
                1
             END
               FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
       INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
          ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
       INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA RFR
          ON (RFR.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
       WHERE RFR.ID_REGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA;
    END
    ELSE BEGIN
      SELECT @xMARKEDTRANSACTION = CASE
               WHEN RFR.CODTRANSACCIONALIADO IS NULL THEN
                0
               ELSE
                1
             END
        FROM WSXML_SFG.REGISTROFACTREFERENCIA RFR
       WHERE RFR.ID_REGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA;
    END 
    IF @xMARKEDTRANSACTION = 1 BEGIN
      RAISERROR('-20020 El registro ya ha sido vinculado', 16, 1);
    END 
      DECLARE @outCODTIPOCOMISION            NUMERIC(22,0);
      DECLARE @outCODTIPORANGO               NUMERIC(22,0);
      DECLARE @outCODRANGOCOMISIONDIFAGR     NUMERIC(22,0);
      DECLARE @outCODRANGOCOMISIONDIFRED     NUMERIC(22,0);
      DECLARE @outFLAGCOMISIONDIFERENCIALBIN NUMERIC(22,0);
      DECLARE @outLISTCOMISIONDIFERENCIALBIN CURSOR;
      DECLARE @outLISTADVTRANSACCIONES       CURSOR;

	  DECLARE @outCOUNTCOMISIONDIFERENCIALBIN NUMERIC(22,0);
      DECLARE @outCOUNTADVTRANSACCIONES       NUMERIC(22,0);

      DECLARE @outCODRANGOCOMISIONESTANDAR   NUMERIC(22,0);
    BEGIN
      EXEC WSXML_SFG.SFGREGISTROREVENUE_GetSimpleRevenueValues  
												@xFECHAARCHIVO,
                                                @xCODENTRADAARCHIVOCONTROL,
                                                @xCODREGISTROFACTURACION,
                                                @xCODRANGOCOMISION OUT,
                                                @outCODTIPOCOMISION OUT,
                                                @outCODTIPORANGO OUT,
                                                @outCODRANGOCOMISIONDIFAGR OUT,
                                                @outCODRANGOCOMISIONDIFRED OUT,
                                                @outFLAGCOMISIONDIFERENCIALBIN OUT,
                                                @outLISTCOMISIONDIFERENCIALBIN OUT,
												@outCOUNTCOMISIONDIFERENCIALBIN OUT,
                                                @outLISTADVTRANSACCIONES OUT,
												@outCOUNTADVTRANSACCIONES OUT,
                                                @outCODRANGOCOMISIONESTANDAR OUT 
      -- Retrieve new rules if differential commission is found
      IF @outCODRANGOCOMISIONDIFAGR <> 0 BEGIN
        SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, @outCODTIPOCOMISION = CODTIPOCOMISION, @outCODTIPORANGO = CODTIPORANGO
          FROM WSXML_SFG.RANGOCOMISION
         WHERE ID_RANGOCOMISION = @outCODRANGOCOMISIONDIFAGR;
      END
      ELSE IF @outCODRANGOCOMISIONDIFRED <> 0 BEGIN
        SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, @outCODTIPOCOMISION = CODTIPOCOMISION, @outCODTIPORANGO = CODTIPORANGO
          FROM WSXML_SFG.RANGOCOMISION
         WHERE ID_RANGOCOMISION = @outCODRANGOCOMISIONDIFRED;
      END
      ELSE IF @outFLAGCOMISIONDIFERENCIALBIN <> 0 BEGIN
        /* Iterate types before obtaining values */
        IF @outCOUNTADVTRANSACCIONES > 0 BEGIN

			
          --DECLARE idv CURSOR FOR outLISTADVTRANSACCIONES.First .. outLISTADVTRANSACCIONES.Last OPEN idv;
			 DECLARE @idv__ID NUMERIC(38,0), @idv__VALUE NVARCHAR(2000)
			 FETCH NEXT FROM @outLISTADVTRANSACCIONES INTO @idv__ID, @idv__VALUE;
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				IF @idv__VALUE = @xTIPOTRANSACCION AND @idv__ID = 0 BEGIN
				  /* Replace signature */
				  IF @outCODTIPOCOMISION IN (1, 3, 4, 6) BEGIN
					EXEC WSXML_SFG.COMISIONSIMPLE_F 1,0,0, @xCODRANGOCOMISION OUT
					--SET @xCODRANGOCOMISION = WSXML_SFG.COMISIONSIMPLE_F(1, 0, 0);
				  END
				  ELSE BEGIN
					--SET @xCODRANGOCOMISION =WSXML_SFG.COMISIONSIMPLE_F(2, 0, 0);
					EXEC WSXML_SFG.COMISIONSIMPLE_F 1,0,0, @xCODRANGOCOMISION OUT
				  END 
				  SET @outCODTIPOCOMISION = 0; /* Parameter forces zero value */
				  BREAK
				END
            FETCH NEXT FROM @outLISTADVTRANSACCIONES INTO @idv__ID, @idv__VALUE;
            END
            CLOSE @outLISTADVTRANSACCIONES;
            DEALLOCATE @outLISTADVTRANSACCIONES; 
          
        END ELSE BEGIN
          /* Replace signature */
          IF @outCODTIPOCOMISION IN (1, 4) BEGIN
            SET @xCODRANGOCOMISION =WSXML_SFG.COMISIONSIMPLE_F(1, 0, 0);
          END
          ELSE BEGIN
            SET @xCODRANGOCOMISION =WSXML_SFG.COMISIONSIMPLE_F(2, 0, 0);
          END 
          SET @outCODTIPOCOMISION = 0; /* Parameter forces zero value */
        END

        IF @outCODTIPOCOMISION <> 0 AND  @outCOUNTCOMISIONDIFERENCIALBIN > 0 BEGIN
			DECLARE @ibx__ID NUMERIC(38,0), @ibx__STRINGVALUE NVARCHAR(50), @ibx__FLOATVALUE FLOAT
			FETCH NEXT FROM @outLISTCOMISIONDIFERENCIALBIN INTO @ibx__ID, @ibx__STRINGVALUE, @ibx__FLOATVALUE -- IN outLISTCOMISIONDIFERENCIALBIN.First .. outLISTCOMISIONDIFERENCIALBIN.Last WHILE 1=1 BEGIN
			WHILE @@FETCH_STATUS=0
			BEGIN 
				IF @ibx__STRINGVALUE = @xBINTARJETA BEGIN
					SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, 
						@outCODTIPOCOMISION = CODTIPOCOMISION, 
						@outCODTIPORANGO = CODTIPORANGO
					FROM WSXML_SFG.RANGOCOMISION
					WHERE ID_RANGOCOMISION = CAST(@ibx__FLOATVALUE AS NUMERIC(38,0));
					BREAK
				END
				FETCH NEXT FROM @outLISTCOMISIONDIFERENCIALBIN INTO @ibx__ID, @ibx__STRINGVALUE, @ibx__FLOATVALUE
			END
			CLOSE @outLISTCOMISIONDIFERENCIALBIN
			DEALLOCATE @outLISTCOMISIONDIFERENCIALBIN
        END
      END
      -- Calculate according to retrieved rules
      IF @outCODTIPOCOMISION IN (1, 2, 3) BEGIN

        DECLARE @cvalcalcVALORPORCENTUA FLOAT = 0;
        DECLARE @cvalcalcVALORTRANSCCNL FLOAT = 0;
        BEGIN
          SELECT @cvalcalcVALORPORCENTUA = VALORPORCENTUAL, @cvalcalcVALORTRANSCCNL = VALORTRANSACCIONAL
            FROM WSXML_SFG.RANGOCOMISIONDETALLE
           WHERE CODRANGOCOMISION = @xCODRANGOCOMISION;
          IF @outCODTIPOCOMISION = 1 BEGIN
            -- Porcentual
          
            SET @xCALCREVENUEPORCENTUAL = (@cvalcalcVALORPORCENTUA *@xVALORTRANSACCION) / 100;
            SET @xCALCULATEDREVENUE     = (@cvalcalcVALORPORCENTUA *@xVALORTRANSACCION) / 100;
          
            --Giros Colpatria
            IF @xCODPRODUCTO IN (1255 --GIRO DEPOSITO COLPA
                               ,
                                1256 --GIRO RETIRO COLPA
                                ) BEGIN
            
              SELECT @V_VRCOMISION = SUM(RFR.VRCOMISION)
                FROM WSXML_SFG.REGISTROFACTREFERENCIA RFR
               WHERE RFR.ID_REGISTROFACTREFERENCIA =
                     @p_CODREGISTROFACTREFERENCIA;
            
              SET @xCALCREVENUEPORCENTUAL = (@cvalcalcVALORPORCENTUA *
                                        @V_VRCOMISION) / 100;
              SET @xCALCULATEDREVENUE     = (@cvalcalcVALORPORCENTUA *
                                        @V_VRCOMISION) / 100;
            
            END 
          
            --Giros MATRIX
            IF @xCODPRODUCTO IN (1872, 1871, 1870, 1869) BEGIN
            
              SELECT @V_VRCOMISION = SUM(CAST(RFR.SUSCRIPTOR AS NUMERIC(38,0)))
                FROM WSXML_SFG.REGISTROFACTREFERENCIA RFR
               WHERE RFR.ID_REGISTROFACTREFERENCIA =
                     @p_CODREGISTROFACTREFERENCIA;
            
              SET @xCALCREVENUEPORCENTUAL = (@cvalcalcVALORPORCENTUA *
                                        @V_VRCOMISION) / 100;
              SET @xCALCULATEDREVENUE     = (@cvalcalcVALORPORCENTUA *
                                        @V_VRCOMISION) / 100;
            
            END 
          
          END
          ELSE IF @outCODTIPOCOMISION = 2 BEGIN
            -- Transaccional
            SET @xCALCREVENUETRANSACCNL = @cvalcalcVALORTRANSCCNL * (1);
            SET @xCALCULATEDREVENUE     = @cvalcalcVALORTRANSCCNL * (1);
          END
          ELSE IF @outCODTIPOCOMISION = 3 BEGIN
            -- Mixto
            SET @xCALCREVENUEPORCENTUAL = (@cvalcalcVALORPORCENTUA *
                                      @xVALORTRANSACCION) / 100;
            SET @xCALCREVENUETRANSACCNL = @cvalcalcVALORTRANSCCNL * (1);
            SET @xCALCULATEDREVENUE     = ((@cvalcalcVALORPORCENTUA *
                                      @xVALORTRANSACCION) / 100) +
                                      (@cvalcalcVALORTRANSCCNL * (1));
          END 
        END;
      END
      ELSE IF @outCODTIPOCOMISION IN (4, 5, 6) BEGIN
        BEGIN
          BEGIN
            DECLARE tCommission CURSOR FOR SELECT ID_RANGOCOMISIONDETALLE,
                                       RANGOINICIAL,
                                       RANGOFINAL,
                                       VALORPORCENTUAL,
                                       VALORTRANSACCIONAL
                                  FROM WSXML_SFG.RANGOCOMISIONDETALLE
                                 WHERE CODRANGOCOMISION = @xCODRANGOCOMISION
                                 ORDER BY RANGOINICIAL; OPEN tCommission;
				DECLARE @tCommission__ID_RANGOCOMISIONDETALLE NUMERIC(38,0),
                                       @tCommission__RANGOINICIAL FLOAT,
                                       @tCommission__RANGOFINAL FLOAT,
                                       @tCommission__VALORPORCENTUAL FLOAT,
                                       @tCommission__VALORTRANSACCIONAL FLOAT

			 FETCH NEXT FROM tCommission INTO @tCommission__ID_RANGOCOMISIONDETALLE,
                                       @tCommission__RANGOINICIAL,
                                       @tCommission__RANGOFINAL,
                                       @tCommission__VALORPORCENTUAL,
                                       @tCommission__VALORTRANSACCIONAL
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				IF @xVALORTRANSACCION >= @tCommission__RANGOINICIAL AND
                 (@xVALORTRANSACCION <= @tCommission__RANGOFINAL OR
                 @tCommission__RANGOFINAL IS NULL) BEGIN
                IF @outCODTIPOCOMISION = 4 BEGIN
                  -- Rangos Porcentual
                
                  SET @xCALCREVENUEPORCENTUAL = (@tCommission__VALORPORCENTUAL *
                                            @xVALORTRANSACCION) / 100;
                  SET @xCALCULATEDREVENUE     = (@tCommission__VALORPORCENTUAL *
                                            @xVALORTRANSACCION) / 100;
                
                  IF @xCODPRODUCTO IN (1255 --GIRO DEPOSITO COLPA
                                     ,
                                      1256 --GIRO RETIRO COLPA
                                      ) BEGIN
                  
                    SELECT @V_VRCOMISION = SUM(RFR.VRCOMISION)
                      FROM WSXML_SFG.REGISTROFACTREFERENCIA RFR
                     WHERE RFR.ID_REGISTROFACTREFERENCIA =
                           @p_CODREGISTROFACTREFERENCIA;
                  
                    SET @xCALCREVENUEPORCENTUAL = (@tCommission__VALORPORCENTUAL *
                                              @V_VRCOMISION) / 100;
                    SET @xCALCULATEDREVENUE     = (@tCommission__VALORPORCENTUAL *
                                              @V_VRCOMISION) / 100;
                  
                  END 
                
                  --Giros MATRIX
                  IF @xCODPRODUCTO IN (1872, 1871, 1870, 1869) BEGIN
                  
                    SELECT @V_VRCOMISION = SUM(CAST(RFR.SUSCRIPTOR AS NUMERIC(38,0)))
                      FROM WSXML_SFG.REGISTROFACTREFERENCIA RFR
                     WHERE RFR.ID_REGISTROFACTREFERENCIA =
                           @p_CODREGISTROFACTREFERENCIA;
                  
                    SET @xCALCREVENUEPORCENTUAL = (@tCommission__VALORPORCENTUAL *
                                              @V_VRCOMISION) / 100;
                    SET @xCALCULATEDREVENUE     = (@tCommission__VALORPORCENTUAL *
                                              @V_VRCOMISION) / 100;
                  
                  END 
                
                END
                ELSE IF @outCODTIPOCOMISION = 5 BEGIN
                  -- Rangos Transaccional
                  SET @xCALCREVENUETRANSACCNL = @tCommission__VALORTRANSACCIONAL * (1);
                  SET @xCALCULATEDREVENUE     = @tCommission__VALORTRANSACCIONAL * (1);
                END
                ELSE IF @outCODTIPOCOMISION = 6 BEGIN
                  -- Rangos Mixto
                  SET @xCALCREVENUEPORCENTUAL = (@tCommission__VALORPORCENTUAL *
                                            @xVALORTRANSACCION) / 100;
                  SET @xCALCREVENUETRANSACCNL = @tCommission__VALORTRANSACCIONAL * (1);
                  SET @xCALCULATEDREVENUE     = ((@tCommission__VALORPORCENTUAL *
                                            @xVALORTRANSACCION) / 100) +
                                            (@tCommission__VALORTRANSACCIONAL * (1));
                END 
                BREAK;
              END 
				FETCH NEXT FROM tCommission INTO @tCommission__ID_RANGOCOMISIONDETALLE,
                                       @tCommission__RANGOINICIAL,
                                       @tCommission__RANGOFINAL,
                                       @tCommission__VALORPORCENTUAL,
                                       @tCommission__VALORTRANSACCIONAL
			 END;
			 CLOSE tCommission;
             DEALLOCATE tCommission;
          END;
        END;
      END 
    END 
  
    SELECT @vCODALIADO = P.CODALIADOESTRATEGICO
      FROM WSXML_SFG.PRODUCTO P
     WHERE P.ID_PRODUCTO = @xCODPRODUCTO;
  
    --se actualiza el valor de la tx por procesa RECHAZOS 51 y 55
    IF @vCODALIADO = 708 BEGIN
      UPDATE WSXML_SFG.TRANSACCIONALIADO
         SET CODENTRADAARCHIVOCONTROL  = @xCODENTRADAARCHIVOCONTROL,
             CODREGISTROFACTURACION    = @xCODREGISTROFACTURACION,
             CODREGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA,
             CODPUNTODEVENTA           = @xCODPUNTODEVENTA,
             CODPRODUCTO               = @xCODPRODUCTO,
             CODRANGOCOMISION          = @xCODRANGOCOMISION,
             REVENUETRANSACCION        = @xCALCULATEDREVENUE,
             REVENUEPORCENTUAL         = @xCALCREVENUEPORCENTUAL,
             REVENUETRANSACCIONAL      = @xCALCREVENUETRANSACCNL,
             VALORTRANSACCION          = @xVALORTRANSACCION
       WHERE ID_TRANSACCIONALIADO = @p_CODTRANSACCIONALIADO;
    END
    ELSE BEGIN
      UPDATE WSXML_SFG.TRANSACCIONALIADO
         SET CODENTRADAARCHIVOCONTROL  = @xCODENTRADAARCHIVOCONTROL,
             CODREGISTROFACTURACION    = @xCODREGISTROFACTURACION,
             CODREGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA,
             CODPUNTODEVENTA           = @xCODPUNTODEVENTA,
             CODPRODUCTO               = @xCODPRODUCTO,
             CODRANGOCOMISION          = @xCODRANGOCOMISION,
             REVENUETRANSACCION        = @xCALCULATEDREVENUE,
             REVENUEPORCENTUAL         = @xCALCREVENUEPORCENTUAL,
             REVENUETRANSACCIONAL      = @xCALCREVENUETRANSACCNL
      --se actualiza el valor de la tx por procesa RECHAZOS 51 y 55
      --VALORTRANSACCION = xVALORTRANSACCION
       WHERE ID_TRANSACCIONALIADO = @p_CODTRANSACCIONALIADO;
    END 
    UPDATE WSXML_SFG.REGISTROFACTREFERENCIA
       SET CODTRANSACCIONALIADO = @p_CODTRANSACCIONALIADO
     WHERE ID_REGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA;
  
  END;
  GO

IF OBJECT_ID('SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_ReverseFile', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_ReverseFile;
GO

  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReverseFile(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                        @p_RETURNVALUE_out             NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @transactionlist WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @flagcompensado  NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    SELECT @flagcompensado = COMPENSADO
      FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
     WHERE ID_ARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
    /*IF flagcompensado <> 0 THEN
      RAISE_APPLICATION_ERROR(-20020, 'No se puede reversar un archivo que ha sido considerado para la compensaci?n');
    END IF;*/
    -- Delete file and unbind registries
    INSERT INTO @transactionlist
	SELECT ID_TRANSACCIONALIADO     
      FROM WSXML_SFG.TRANSACCIONALIADO
     WHERE CODARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;

    IF @@ROWCOUNT > 0 BEGIN
      DECLARE itx CURSOR FOR SELECT IDVALUE FROM @transactionlist--.First .. transactionlist.Last 
	  OPEN itx;

	  DECLARE @itx__IDVALUE NUMERIC(38,0)
	 FETCH NEXT FROM itx INTO @itx__IDVALUE;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
          DECLARE @xCODREGISTROFACTREFERENCIA NUMERIC(22,0);
        BEGIN
          SELECT @xCODREGISTROFACTREFERENCIA = CODREGISTROFACTREFERENCIA
            FROM WSXML_SFG.TRANSACCIONALIADO
           WHERE ID_TRANSACCIONALIADO = @itx__IDVALUE

          IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
            UPDATE WSXML_SFG.REGISTROFACTREFERENCIA
               SET CODTRANSACCIONALIADO = NULL
             WHERE ID_REGISTROFACTREFERENCIA = @xCODREGISTROFACTREFERENCIA;
          END 

        END;
      FETCH NEXT FROM itx INTO @itx__IDVALUE;
      END;
      CLOSE itx;
      DEALLOCATE itx;
      DELETE FROM WSXML_SFG.TRANSACCIONALIADO
       WHERE CODARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
    END 
    DELETE FROM ARCHIVOTRANSACCIONALIADO
     WHERE ID_ARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
  
    begin
      declare tmp cursor for select rfr.ID_registrofactreferencia as fila
                    from wsxml_sfg.registrofactreferencia rfr,
                         WSXML_SFG.REGISTROFACTURACION              RF
                   where RFR.CODREGISTROFACTURACION =
                         RF.ID_REGISTROFACTURACION
                     AND RF.CODPRODUCTO IN
                         (SELECT P.ID_PRODUCTO
                            FROM WSXML_SFG.PRODUCTO P
                           WHERE P.CODALIADOESTRATEGICO IN
                                 (SELECT CA.CODALIADOESTRATEGICO
                                    FROM WSXML_SFG.CONFIGURACIONALIADOARCHIVO CA))
                     and rf.codentradaarchivocontrol in
                         (select ea.id_entradaarchivocontrol
                            from WSXML_SFG.entradaarchivocontrol ea
                           where ea.tipoarchivo = 1
                             and ea.fechaarchivo between convert(datetime, convert(date,getdate() - 10)) and
                                 convert(datetime, convert(date,getdate())))
                     AND isnull(rfr.codtransaccionaliado, 0) not in
                         (select t.id_transaccionaliado
                            from wsxml_sfg.TRANSACCIONALIADO t)
                     and isnull(rfr.codtransaccionaliado, 0) > 0; open tmp;
		DECLARE @tmp__FILA NUMERIC(38,0)
		 fetch NEXT FROM tmp into @tmp__FILA;
		 while @@fetch_status=0
		 begin
      
        update wsxml_sfg.registrofactreferencia
           set codtransaccionaliado = null
         where ID_registrofactreferencia = @tmp__FILA
      
      fetch NEXT FROM tmp into @tmp__FILA;
      end;
      close tmp;
      deallocate tmp;
    end;
  
    SET @p_RETURNVALUE_out = 3;
  END;
GO


IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGARCHIVOTRANSACCIONALIADO_LoadFilesFromDay'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFilesFromDay
GO



  /* Helper procedure that considers the actual transaction date */
  CREATE FUNCTION WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFilesFromDay(@p_FECHAARCHIVO DATETIME) 
	RETURNS @lstfiles TABLE(ID NUMERIC(38,0), VALUE DATETIME)
  AS
  BEGIN

	INSERT INTO  @lstfiles
    SELECT ID_ENTRADAARCHIVOCONTROL, FECHAARCHIVO
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
     WHERE REVERSADO = 0
       AND FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO));

	   RETURN;
  END;
  GO
  



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGARCHIVOTRANSACCIONALIADO_LoadFilesOpenRange'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFilesOpenRange
GO



  /* Helper procedure that considers an open file range */
CREATE FUNCTION WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFilesOpenRange(@p_FECHAARCHIVO DATETIME) 
	RETURNS @lstfiles TABLE (ID NUMERIC(38,0), VALE DATETIME)
AS
 BEGIN
    --SET NOCOUNT ON;

    DECLARE @maxrange INT = 3;
	DECLARE @msg VARCHAR(2000);
  

    DECLARE @lstservices WSXML_SFG.NUMBERARRAY;
    
	BEGIN

		INSERT INTO @lstservices
		SELECT ID_SERVICIO
        FROM WSXML_SFG.SERVICIO
		ORDER BY ID_SERVICIO;
		
	  DECLARE @i INT  = 0
	  WHILE @i < @maxrange 
	  BEGIN

		DECLARE isx CURSOR FOR SELECT IDVALUE FROM @lstservices--.First .. lstservices.Last 
		OPEN isx;
		
		DECLARE @isx__IDVALUE NUMERIC(38,0);

		FETCH NEXT FROM isx INTO @isx__IDVALUE;
		WHILE @@FETCH_STATUS=0
		BEGIN
        
			DECLARE @ctrlid NUMERIC(22,0);
				SELECT @ctrlid = ID_ENTRADAARCHIVOCONTROL
				  FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
				 WHERE REVERSADO = 0
				   AND TIPOARCHIVO = @isx__IDVALUE
				   AND FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,CONVERT(DATETIME,@p_FECHAARCHIVO) - @i));

				IF @@ROWCOUNT = 0 BEGIN

          
					DECLARE @servicename VARCHAR(4000) /* Use -meta option SERVICIO.NOMSERVICIO%TYPE */;
					
					BEGIN
						SELECT @servicename = NOMSERVICIO
						  FROM WSXML_SFG.SERVICIO
						 WHERE ID_SERVICIO = @isx__IDVALUE

						 SET @msg = '-20054 No existe el archivo de transacciones para la fecha ' +
												ISNULL(FORMAT(CONVERT(DATETIME,@p_FECHAARCHIVO) - @i, 'dd/MM/yyyy'), '') +
												' para el servicio ' + isnull(@servicename, '')
						--RAISERROR(@msg, 16, 1);
						--RETURN CAST(@msg AS INT);
					END;
				END;
				FETCH NEXT FROM isx INTO @isx__IDVALUE;
			END;
			CLOSE isx;
			DEALLOCATE isx;
		
		
		SET @i = @i + 1
	  END

    END;


	INSERT INTO @lstfiles
    SELECT ID_ENTRADAARCHIVOCONTROL, FECHAARCHIVO
	FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
     WHERE REVERSADO = 0
       AND FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO - @maxrange)) AND
           CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO));
	
	RETURN;

  END;
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGARCHIVOTRANSACCIONALIADO_LoadFilesGreatRange'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFilesGreatRange
GO

  /* Helper procedure that considers a greater file range */
  CREATE FUNCTION WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_LoadFilesGreatRange(@p_FECHAARCHIVO DATETIME)
        RETURNS @lstfiles  TABLE(ID NUMERIC(38,0), VALUE DATETIME) AS
  BEGIN
  --SET NOCOUNT ON;

	INSERT INTO @lstfiles
    SELECT ID_ENTRADAARCHIVOCONTROL, FECHAARCHIVO
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
     WHERE REVERSADO = 0
       AND FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,CONVERT(DATETIME,@p_FECHAARCHIVO) - 30)) AND
           CONVERT(DATETIME, CONVERT(DATE,@p_FECHAARCHIVO));
	RETURN 
  END;
  GO

IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_UpdateControlTransactionCount', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_UpdateControlTransactionCount;
GO

  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_UpdateControlTransactionCount(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                          @p_NEWTRANSACTIONCOUNT         NUMERIC(22,0),
                                          @p_NEWTRANSACTIONVALUE         FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ARCHIVOTRANSACCIONALIADO
       SET CANTIDADTRANSACCIONES = @p_NEWTRANSACTIONCOUNT,
           VALORTRANSACCIONES    = @p_NEWTRANSACTIONVALUE
     WHERE ID_ARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_CheckLoadingFileProgress', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_CheckLoadingFileProgress;
GO


  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_CheckLoadingFileProgress(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                                     @p_NOMBREARCHIVO        NVARCHAR(2000),
                                     @p_ESTADO_out           NUMERIC(22,0) OUT,
                                     @p_PROGRESO_out         FLOAT OUT) AS
 BEGIN
    DECLARE @FileID       NUMERIC(22,0);
    DECLARE @FileComplete NUMERIC(22,0);
    DECLARE @FileUnlinked NUMERIC(22,0);
    DECLARE @FileProgress NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SET @p_ESTADO_out   = 0;
    SET @p_PROGRESO_out = 0;
    -- Assume File ID
    BEGIN
      SELECT @FileID = ID_ARCHIVOTRANSACCIONALIADO
        FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
       WHERE CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO
         AND NOMBREARCHIVO = @p_NOMBREARCHIVO;
		
		IF @@ROWCOUNT > 1 BEGIN
			SELECT @FileID = ID_ARCHIVOTRANSACCIONALIADO
			FROM (
				SELECT ID_ARCHIVOTRANSACCIONALIADO, ROW_NUMBER() OVER(ORDER BY FECHAHORAINGRESO DESC) AS "Row Number"
                  FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
                 WHERE CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO
                   AND NOMBREARCHIVO = @p_NOMBREARCHIVO
                 ) s
         --WHERE;
		END

		IF @@ROWCOUNT = 0 BEGIN
			 SET @p_ESTADO_out   = 2;
			SET @p_PROGRESO_out = 0;
		END
       
    END;

    IF @p_ESTADO_out <> 2 BEGIN
      -- Select into CASE values
      SELECT @FileComplete = CASE WHEN CANTIDADTRANSACCIONES = ISNULL(CANTIDAD, 0) THEN 1 ELSE 0 END,-- AS TERMINADO,
             @FileUnlinked = ISNULL(SINVINCULO, 0),-- AS SINVINCULO,
             @FileProgress = ISNULL(ROUND((CANTIDAD * 100) / CANTIDADTRANSACCIONES, 2), 0)-- AS PROGRESO
        FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
        LEFT OUTER JOIN (
			SELECT CODARCHIVOTRANSACCIONALIADO,
				COUNT(1) AS CANTIDAD,
				SUM(VALORTRANSACCION) AS VALOR,
				SUM(CASE WHEN CODREGISTROFACTREFERENCIA IS NULL THEN 1 ELSE 0 END) AS SINVINCULO
			FROM WSXML_SFG.TRANSACCIONALIADO
			GROUP BY CODARCHIVOTRANSACCIONALIADO
		) TRX
          ON (TRX.CODARCHIVOTRANSACCIONALIADO = ID_ARCHIVOTRANSACCIONALIADO)
       WHERE ID_ARCHIVOTRANSACCIONALIADO = @FileID;
      IF @FileComplete = 1 BEGIN
        IF @FileUnlinked > 0 BEGIN
          SET @p_ESTADO_out = 7;
        END
        ELSE BEGIN
          SET @p_ESTADO_out = 3;
        END 
        SET @p_PROGRESO_out = 100;
      END
      ELSE BEGIN
        SET @p_ESTADO_out   = 2;
        SET @p_PROGRESO_out = @FileProgress;
      END 
    END 
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_GetLoadedFilesInfo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_GetLoadedFilesInfo;
GO

  -- For differential loading and weekly balance of transactions
  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_GetLoadedFilesInfo(@p_FECHACOMPARACION DATETIME) AS
 BEGIN
    DECLARE @xLimitFechaDesde DATETIME;
    DECLARE @xLimitFechaHasta DATETIME;
   
  SET NOCOUNT ON;
    SET @xLimitFechaHasta = CONVERT(DATETIME, CONVERT(DATE,@p_FECHACOMPARACION));
    SET @xLimitFechaDesde = CONVERT(DATETIME, CONVERT(DATE,@p_FECHACOMPARACION - 300));
    -- Differential time cap: Three Hundred days
      SELECT ID_ARCHIVOTRANSACCIONALIADO,
             NOMBREARCHIVO,
             FECHAARCHIVO,
             CODALIADOESTRATEGICO,
             CODFORMATOARCHIVOTRANSACCION,
             CANTIDADTRANSACCIONES,
             VALORTRANSACCIONES,
             FECHAHORAINGRESO,
             CODUSUARIOMODIFICACION
        FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
       WHERE FECHAARCHIVO BETWEEN @xLimitFechaDesde AND @xLimitFechaHasta
       ORDER BY FECHAARCHIVO, CODALIADOESTRATEGICO;
  END;
  GO


  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_RecalculateRevenueFromContable', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_RecalculateRevenueFromContable;
GO


  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_RecalculateRevenueFromContable(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                                           @p_FECHADESDE           DATETIME,
                                           @p_FECHAHASTA           DATETIME) AS
 BEGIN
    DECLARE @lstfiles     WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @countrecords NUMERIC(22,0) = 0;
    DECLARE @waitnrecords NUMERIC(22,0) = 50;
   
  SET NOCOUNT ON;
    -- Recaculate transactions from files currently on server
    INSERT INTO @lstfiles
	SELECT ID_ARCHIVOTRANSACCIONALIADO
      FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
     WHERE CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO
       AND FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,@p_FECHADESDE)) AND
           CONVERT(DATETIME, CONVERT(DATE,@p_FECHAHASTA));
    -- Only linked transactions
    IF @@ROWCOUNT > 0 BEGIN
      DECLARE ifx CURSOR FOR SELECT IDVALUE FROM @lstfiles
	  OPEN ifx;
	  DECLARE @ifx__IDVALUE NUMERIC(38,0)
		 FETCH NEXT FROM ifx INTO @ifx__IDVALUE;
		 WHILE @@FETCH_STATUS=0
		 BEGIN
         DECLARE @lsttransactions WSXML_SFG.LONGNUMBERARRAY;
		
		BEGIN
			INSERT INTO @lsttransactions
			SELECT ID_TRANSACCIONALIADO
            FROM WSXML_SFG.TRANSACCIONALIADO
           WHERE CODARCHIVOTRANSACCIONALIADO = @ifx__IDVALUE
             AND CODREGISTROFACTREFERENCIA IS NOT NULL;
          IF @@ROWCOUNT > 0 BEGIN
            DECLARE itx CURSOR FOR SELECT IDVALUE FROM @lsttransactions
			OPEN itx;
			DECLARE @itx__IDVALUE NUMERIC(38,0)
			 FETCH NEXT FROM itx INTO @itx__IDVALUE;
			 WHILE @@FETCH_STATUS=0
			 BEGIN
                DECLARE @txaVALORTRANSACCION          FLOAT;
                DECLARE @txaCODREGISTROFACTREFERENCIA NUMERIC(22,0);
                DECLARE @cntblCODRANGOCOMISION        NUMERIC(22,0);
                DECLARE @cntblCODTIPOCOMISION         NUMERIC(22,0);
                DECLARE @cntblCODRANGOCOMISIONDETALLE NUMERIC(22,0);
                DECLARE @cntblVALORPORCENTUAL         FLOAT;
                DECLARE @cntblVALORTRANSACCIONAL      FLOAT;
                DECLARE @nvoREVENUETOTAL              FLOAT = 0;
                DECLARE @nvoREVENUEPORCENTUAL         FLOAT = 0;
                DECLARE @nvoREVENUETRANSACCIONAL      FLOAT = 0;
                DECLARE @nvoREVENUEFIJO               FLOAT = 0;
              BEGIN
                SELECT /*+ rule() */
                 @cntblCODRANGOCOMISION = REV.CODRANGOCOMISION,
                 @txaVALORTRANSACCION = TXA.VALORTRANSACCION,
                 @txaCODREGISTROFACTREFERENCIA = TXA.CODREGISTROFACTREFERENCIA
                                   FROM WSXML_SFG.REGISTROFACTURACION REG,
                       WSXML_SFG.REGISTROREVENUE     REV,
                       WSXML_SFG.TRANSACCIONALIADO   TXA
                 WHERE REG.CODENTRADAARCHIVOCONTROL =
                       REV.CODENTRADAARCHIVOCONTROL
                   AND REG.ID_REGISTROFACTURACION =
                       REV.CODREGISTROFACTURACION
                   AND REG.ID_REGISTROFACTURACION =
                       TXA.CODREGISTROFACTURACION
                   AND TXA.ID_TRANSACCIONALIADO = @itx__IDVALUE
                IF @txaCODREGISTROFACTREFERENCIA IS NOT NULL
                  /* Try to find transaction revenue */
                  BEGIN
					BEGIN TRY
						SELECT @cntblCODRANGOCOMISION = CODRANGOCOMISION
						  FROM WSXML_SFG.REGISTROREVENUETRANSACCION
						 WHERE CODREGISTROFACTREFERENCIA =
							   @txaCODREGISTROFACTREFERENCIA;
					END TRY
					BEGIN CATCH
						  SELECT NULL;
					END CATCH
                  END;
                
                SELECT @cntblCODTIPOCOMISION = CODTIPOCOMISION
                  FROM WSXML_SFG.RANGOCOMISION
                 WHERE ID_RANGOCOMISION = @cntblCODRANGOCOMISION;
                IF @cntblCODTIPOCOMISION IN (1, 2, 3) BEGIN
                  SELECT @cntblCODRANGOCOMISIONDETALLE = ID_RANGOCOMISIONDETALLE,
                         @cntblVALORPORCENTUAL = VALORPORCENTUAL,
                         @cntblVALORTRANSACCIONAL = VALORTRANSACCIONAL
                                       FROM WSXML_SFG.RANGOCOMISIONDETALLE
                   WHERE CODRANGOCOMISION = @cntblCODRANGOCOMISION;
                END
                ELSE IF @cntblCODTIPOCOMISION IN (4, 5, 6) BEGIN
                  -- Obtain value from referenced transaction
                  IF @txaCODREGISTROFACTREFERENCIA IS NULL BEGIN
                    RAISERROR('-20021 Access violation. Se intenta obtener el revenue transaccional a partir de una comision en rangos cuando el contable no posee los valores', 16, 1);
                  END 
                  SELECT @cntblCODRANGOCOMISIONDETALLE = RRT.CODRANGOCOMISIONDETALLE
                    FROM WSXML_SFG.REGISTROFACTURACION        REG,
                         WSXML_SFG.REGISTROREVENUE            REV,
                         WSXML_SFG.TRANSACCIONALIADO          TXA,
                         WSXML_SFG.REGISTROREVENUETRANSACCION RRT
                   WHERE REG.CODENTRADAARCHIVOCONTROL =
                         REV.CODENTRADAARCHIVOCONTROL
                     AND REG.ID_REGISTROFACTURACION =
                         REV.CODREGISTROFACTURACION
                     AND REG.ID_REGISTROFACTURACION =
                         TXA.CODREGISTROFACTURACION
                     AND TXA.ID_TRANSACCIONALIADO = @itx__IDVALUE
                     AND RRT.CODREGISTROREVENUE = REV.ID_REGISTROREVENUE
                     AND RRT.CODREGISTROFACTREFERENCIA =
                         @txaCODREGISTROFACTREFERENCIA;
                  SELECT @cntblVALORPORCENTUAL = VALORPORCENTUAL, @cntblVALORTRANSACCIONAL = VALORTRANSACCIONAL
                    FROM WSXML_SFG.RANGOCOMISIONDETALLE
                   WHERE ID_RANGOCOMISIONDETALLE =
                         @cntblCODRANGOCOMISIONDETALLE;
                END 
                SET @nvoREVENUEPORCENTUAL    = (@cntblVALORPORCENTUAL *
                                           @txaVALORTRANSACCION) / 100;
                SET @nvoREVENUETRANSACCIONAL = @cntblVALORTRANSACCIONAL;
                SET @nvoREVENUEFIJO          = 0;
                SET @nvoREVENUETOTAL         = @nvoREVENUEPORCENTUAL +
                                           @nvoREVENUETRANSACCIONAL +
                                           @nvoREVENUEFIJO;
                UPDATE WSXML_SFG.TRANSACCIONALIADO
                   SET CODRANGOCOMISION        = @cntblCODRANGOCOMISION,
                       CODRANGOCOMISIONDETALLE = @cntblCODRANGOCOMISIONDETALLE,
                       REVENUETRANSACCION      = @nvoREVENUETOTAL,
                       REVENUEPORCENTUAL       = @nvoREVENUEPORCENTUAL,
                       REVENUETRANSACCIONAL    = @nvoREVENUETRANSACCIONAL,
                       REVENUEFIJO             = @nvoREVENUEFIJO
                 WHERE ID_TRANSACCIONALIADO = @itx__IDVALUE
                SET @countrecords = @countrecords + 1;
                IF (@countrecords % @waitnrecords) = 0 BEGIN
                  COMMIT;
                END 
				  IF @@ROWCOUNT = 0
                  RAISERROR('-20020 No se puede recalcular el revenue a partir del revenue contable porque una o mas transacciones se encuentra vinculado a un dia sin calcular. Favor verificar si se ha calculado el revenue contable a todos los archivos', 16, 1);
              END;
            FETCH NEXT FROM itx INTO @itx__IDVALUE;
            END;
            CLOSE itx;
            DEALLOCATE itx;
          END 
        END;
        COMMIT; -- For each file
      FETCH NEXT FROM ifx INTO @ifx__IDVALUE;
      END;
      CLOSE ifx;
      DEALLOCATE ifx;
      ---Aplicar los ajustes de revenue que hayan por rangos de tiempo
      EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_AplicarAjusteRevenue @p_CODALIADOESTRATEGICO,@p_FECHADESDE,@p_FECHAHASTA
      commit;
    END 
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReversarArchivoAliado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReversarArchivoAliado;
GO

  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReversarArchivoAliado(@p_NOMBREARCHIVO NVARCHAR(2000),
                                  @p_FECHADESDE    DATETIME,
                                  @p_FECHAHASTA    DATETIME) AS
 BEGIN
    DECLARE @v_CDARCHTRANALI NUMERIC(22,0);
    DECLARE @v_CODALIADO     NUMERIC(22,0);
   
  SET NOCOUNT ON;
  
    SET @v_CDARCHTRANALI = NULL;
  
    SELECT @v_CDARCHTRANALI = AR.ID_ARCHIVOTRANSACCIONALIADO, @v_CODALIADO = ar.codaliadoestrategico
      FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO AR
     WHERE AR.NOMBREARCHIVO = @p_NOMBREARCHIVO;
  
    IF @v_CDARCHTRANALI IS NOT NULL BEGIN
	  /*
      UPDATE (SELECT RF.CODTRANSACCIONALIADO, RF.ID_REGISTROFACTREFERENCIA
                FROM WSXML_SFG.REGISTROFACTREFERENCIA RF,
                     WSXML_SFG.REGISTROFACTURACION    R,
                     WSXML_SFG.ENTRADAARCHIVOCONTROL  E
               WHERE RF.CODREGISTROFACTURACION = R.ID_REGISTROFACTURACION
                 AND E.ID_ENTRADAARCHIVOCONTROL = R.CODENTRADAARCHIVOCONTROL
                 AND E.TIPOARCHIVO = 1
                 AND E.FECHAARCHIVO BETWEEN @p_FECHADESDE AND @p_FECHAHASTA
                 AND RTRIM(LTRIM(RF.RECIBO)) IN
                     (SELECT RTRIM(LTRIM(T.NUMERORECIBO))
                        FROM WSXML_SFG.TRANSACCIONALIADO T
                       WHERE T.CODARCHIVOTRANSACCIONALIADO = @v_CDARCHTRANALI)) RFR
         SET @RFR.CODTRANSACCIONALIADO = NULL;
      COMMIT;
	  */
    
      DELETE FROM WSXML_SFG.TRANSACCIONALIADO
       WHERE CODARCHIVOTRANSACCIONALIADO = @v_CDARCHTRANALI;
      COMMIT;
      DELETE FROM WSXML_SFG.ARCHIVOTRANSALIADOCACHE
       WHERE CODARCHIVOTRANSACCIONALIADO = @v_CDARCHTRANALI;
      COMMIT;
      DELETE FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
       WHERE ID_ARCHIVOTRANSACCIONALIADO = @v_CDARCHTRANALI;
      COMMIT;
    
      declare tyu cursor for select --rf.*, 
					rf.ID_registrofactreferencia as fila
                    from wsxml_sfg.registrofacturacion    r,
                         wsxml_sfg.registrofactreferencia rf,
                         wsxml_sfg.entradaarchivocontrol  e,
                         wsxml_sfg.aliadoestrategico      a,
                         wsxml_sfg.producto               p
                   where rf.codregistrofacturacion =
                         r.id_registrofacturacion
                     and e.id_entradaarchivocontrol =
                         r.codentradaarchivocontrol
                     and e.tipoarchivo = 1
                     and r.codproducto = p.id_producto
                     and p.codaliadoestrategico = a.id_aliadoestrategico
                     and a.id_aliadoestrategico = @v_CODALIADO
                     and e.fechaarchivo between @p_FECHADESDE and
                         @p_FECHAHASTA
                     and rf.codtransaccionaliado not in
                         (select g.id_transaccionaliado
                            from wsxml_sfg.transaccionaliado g); open tyu;
			DECLARE @tyu__FILA NUMERIC(38,0)
		 fetch NEXT FROM tyu into @tyu__FILA;
		 while @@fetch_status=0
		 begin
      
			update wsxml_sfg.registrofactreferencia
			   set codtransaccionaliado = null
			 where ID_registrofactreferencia = @tyu__FILA
      
			fetch NEXT FROM tyu into @tyu__FILA;
		  end;
		  close tyu;
		  deallocate tyu;
    
    END 
  
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessenedCity', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessenedCity;
GO


  CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessenedCity(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                      @p_COUNTNOVINCULADOS           NUMERIC(22,0) OUT) AS
 BEGIN
  
    DECLARE @p_NUMERORECIBO              NVARCHAR(255);
    DECLARE @p_NUMEROSUSCRIPTOR          NVARCHAR(255);
    DECLARE @p_VALORTRANSACCION          FLOAT;
    DECLARE @p_CHECKAMOUNT               INT;
    DECLARE @p_TRIMRIGHTRECEIPT          INT;
    DECLARE @p_TRIMRIGHTSUSCRIBER        INT;
    DECLARE @p_ID_TRANSACCIONALIADO_out  NUMERIC(22,0);
    DECLARE @p_TRANSACCIONENCONTRADA_out NUMERIC(22,0);
    DECLARE @xFECHAARCHIVO               DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL   NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION     NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA  NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA            NUMERIC(22,0);
    DECLARE @xCODPRODUCTO                NUMERIC(22,0);
    DECLARE @lstcachetransactions        WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @fechaarchivoMIN             DATETIME;
    DECLARE @fechaarchivoMAX             DATETIME;
    DECLARE @vCODALIADO                  NUMERIC(22,0);
    DECLARE @vINCREMENTOS                NUMERIC(22,0) = 0;
    DECLARE @v_TIPO_REGISTRO             NUMERIC(22,0) = 1;
  
   
  SET NOCOUNT ON;
    /* Trace Invoke
    declare
      allyname aliadoestrategico.nomaliadoestrategico%type;
      filename archivotransaccionaliado.nombrearchivo%type;
    begin
      select nomaliadoestrategico, nombrearchivo into allyname, filename from archivotransaccionaliado, aliadoestrategico
      where codaliadoestrategico = id_aliadoestrategico and id_archivotransaccionaliado = p_codarchivotransaccionaliado;
      sfgtmptrace.tracelog('Invoked Reprocess File Lessened for file ' || filename || ' (' || p_codarchivotransaccionaliado || ') for ally ' || allyname);
      COMMIT;
    exception when others then
      null;
    end;
     End Trace Invoke */
  
    SET @p_COUNTNOVINCULADOS = 0;
    SELECT @p_COUNTNOVINCULADOS = SUM(CASE
                 WHEN CODREGISTROFACTREFERENCIA IS NULL THEN
                  1
                 ELSE
                  0
               END)
      FROM WSXML_SFG.TRANSACCIONALIADO
     WHERE CODARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
  
    DECLARE tx CURSOR FOR SELECT FECHAARCHIVO,
                      CODALIADOESTRATEGICO,
                      ID_TRANSACCIONALIADO,
                      NUMERORECIBO,
                      NUMEROSUSCRIPTOR,
                      VALORTRANSACCION,
                      CHECKAMOUNT,
                      TRIMRIGHTRECEIPT,
                      TRIMRIGHTSUSCRIBER,
                      CONFIGURACION,
                      TRANSACCIONALIADO.COMPENSADO
                 FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
                INNER JOIN WSXML_SFG.TRANSACCIONALIADO
                   ON (CODARCHIVOTRANSACCIONALIADO =
                      ID_ARCHIVOTRANSACCIONALIADO)
                INNER JOIN WSXML_SFG.FORMATOARCHIVOTRANSACCION
                   ON (CODFORMATOARCHIVOTRANSACCION =
                      ID_FORMATOARCHIVOTRANSACCION)
                WHERE ID_ARCHIVOTRANSACCIONALIADO =
                      @p_CODARCHIVOTRANSACCIONALIADO
                  AND CODREGISTROFACTREFERENCIA IS NULL
                order by id_TRANSACCIONALIADO desc; OPEN tx;

	 DECLARE @tx__FECHAARCHIVO NUMERIC(38,0),
                      @tx__CODALIADOESTRATEGICO NUMERIC(38,0),
                      @tx__ID_TRANSACCIONALIADO NUMERIC(38,0),
                      @tx__NUMERORECIBO NUMERIC(38,0),
                      @tx__NUMEROSUSCRIPTOR NUMERIC(38,0),
                      @tx__VALORTRANSACCION FLOAT,
                      @tx__CHECKAMOUNT FLOAT,
                      @tx__TRIMRIGHTRECEIPT NUMERIC(38,0),
                      @tx__TRIMRIGHTSUSCRIBER NUMERIC(38,0),
                      @tx__CONFIGURACION VARCHAR(20),
                      @tx__COMPENSADO NUMERIC(38,0)

	 FETCH NEXT FROM tx INTO @tx__FECHAARCHIVO,
                      @tx__CODALIADOESTRATEGICO,
                      @tx__ID_TRANSACCIONALIADO,
                      @tx__NUMERORECIBO,
                      @tx__NUMEROSUSCRIPTOR,
                      @tx__VALORTRANSACCION,
                      @tx__CHECKAMOUNT,
                      @tx__TRIMRIGHTRECEIPT,
                      @tx__TRIMRIGHTSUSCRIBER,
                      @tx__CONFIGURACION,
                      @tx__COMPENSADO;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
    
      SET @v_TIPO_REGISTRO = 1;
    
      SET @p_NUMERORECIBO     = @TX__NUMERORECIBO;
      SET @p_NUMEROSUSCRIPTOR = @TX__NUMEROSUSCRIPTOR;
      SET @p_VALORTRANSACCION = @TX__VALORTRANSACCION;
    
      SET @p_TRANSACCIONENCONTRADA_out = 0;
    
      select @vCODALIADO = al.codaliadoestrategico
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      select @fechaarchivoMAX = CONVERT(DATETIME,al.fechaarchivo) + @vINCREMENTOS
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      begin
		BEGIN TRY
      
			select @xCODREGISTROFACTREFERENCIA = rfr.id_registrofactreferencia
			  from wsxml_sfg.registrofactreferencia rfr
			 where rfr.codregistrofacturacion in
				   (select rf.id_registrofacturacion
					  from wsxml_sfg.registrofacturacion rf,
						   wsxml_sfg.producto            p
					 where rf.codtiporegistro = 1
					   and rf.codproducto = p.id_producto
					   and rf.codentradaarchivocontrol in
						   (select ac.id_entradaarchivocontrol
							  from WSXML_SFG.entradaarchivocontrol ac
							 where ac.tipoarchivo = 1
							   and ac.fechaarchivo BETWEEN CONVERT(DATETIME,@TX__FECHAARCHIVO) - 7 AND
								   CONVERT(DATETIME,@TX__FECHAARCHIVO))
					   and p.codaliadoestrategico = 107)
				  /* order by rfr.numeroreferencia
				  ) RF*/
			   and CAST(isnull(RTRIM(LTRIM(RFR.RECIBO)), 0) AS NUMERIC(38,0)) =
				   CAST(isnull(@p_NUMERORECIBO, 0)  AS NUMERIC(38,0))
			   AND RFR.VALORTRANSACCION = @p_VALORTRANSACCION
			   and isnull(rfr.codtransaccionaliado, 0) = 0
			   --and;
		END TRY
		BEGIN CATCH
			  SELECT null;
        END CATCH
      end;
    
      BEGIN
		BEGIN TRY
			IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
          EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale @TX__ID_TRANSACCIONALIADO,@xCODREGISTROFACTREFERENCIA
          SET @p_COUNTNOVINCULADOS = @p_COUNTNOVINCULADOS - 1;
          commit;
          if @v_TIPO_REGISTRO = 5 begin
            UPDATE WSXML_SFG.TRANSACCIONALIADO
               SET VALORTRANSACCION = 0
             WHERE ID_TRANSACCIONALIADO = @TX__ID_TRANSACCIONALIADO;
          END 
        END 
		END TRY
		BEGIN CATCH
			SELECT NULL;
		END CATCH          
      END;
    
    FETCH NEXT FROM tx INTO @tx__FECHAARCHIVO,
                      @tx__CODALIADOESTRATEGICO,
                      @tx__ID_TRANSACCIONALIADO,
                      @tx__NUMERORECIBO,
                      @tx__NUMEROSUSCRIPTOR,
                      @tx__VALORTRANSACCION,
                      @tx__CHECKAMOUNT,
                      @tx__TRIMRIGHTRECEIPT,
                      @tx__TRIMRIGHTSUSCRIBER,
                      @tx__CONFIGURACION,
                      @tx__COMPENSADO;
    END;
    CLOSE tx;
    DEALLOCATE tx;
  END; 
GO


  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessenedCity2', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessenedCity2;
GO


 CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_ReprocessFileLessenedCity2(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                                       @p_COUNTNOVINCULADOS           NUMERIC(22,0) OUT) AS
 BEGIN
  
    DECLARE @p_NUMERORECIBO              NVARCHAR(255);
    DECLARE @p_NUMEROSUSCRIPTOR          NVARCHAR(255);
    DECLARE @p_VALORTRANSACCION          FLOAT;
    DECLARE @p_CHECKAMOUNT               INT;
    DECLARE @p_TRIMRIGHTRECEIPT          INT;
    DECLARE @p_TRIMRIGHTSUSCRIBER        INT;
    DECLARE @p_ID_TRANSACCIONALIADO_out  NUMERIC(22,0);
    DECLARE @p_TRANSACCIONENCONTRADA_out NUMERIC(22,0);
    DECLARE @xFECHAARCHIVO               DATETIME;
    DECLARE @xCODENTRADAARCHIVOCONTROL   NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTURACION     NUMERIC(22,0);
    DECLARE @xCODREGISTROFACTREFERENCIA  NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA            NUMERIC(22,0);
    DECLARE @xCODPRODUCTO                NUMERIC(22,0);
    DECLARE @lstcachetransactions        WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @fechaarchivoMIN             DATETIME;
    DECLARE @fechaarchivoMAX             DATETIME;
    DECLARE @vCODALIADO                  NUMERIC(22,0);
    DECLARE @vINCREMENTOS                NUMERIC(22,0) = 0;
    DECLARE @v_TIPO_REGISTRO             NUMERIC(22,0) = 1;
  
   
  SET NOCOUNT ON;
    /* Trace Invoke
    declare
      allyname aliadoestrategico.nomaliadoestrategico%type;
      filename archivotransaccionaliado.nombrearchivo%type;
    begin
      select nomaliadoestrategico, nombrearchivo into allyname, filename from archivotransaccionaliado, aliadoestrategico
      where codaliadoestrategico = id_aliadoestrategico and id_archivotransaccionaliado = p_codarchivotransaccionaliado;
      sfgtmptrace.tracelog('Invoked Reprocess File Lessened for file ' || filename || ' (' || p_codarchivotransaccionaliado || ') for ally ' || allyname);
      COMMIT;
    exception when others then
      null;
    end;
     End Trace Invoke */
  
    SET @p_COUNTNOVINCULADOS = 0;
    SELECT @p_COUNTNOVINCULADOS = SUM(CASE
                 WHEN CODREGISTROFACTREFERENCIA IS NULL THEN
                  1
                 ELSE
                  0
               END)
      FROM WSXML_SFG.TRANSACCIONALIADO
     WHERE CODARCHIVOTRANSACCIONALIADO = @p_CODARCHIVOTRANSACCIONALIADO;
  
    DECLARE tx CURSOR FOR SELECT FECHAARCHIVO,
                      CODALIADOESTRATEGICO,
                      ID_TRANSACCIONALIADO,
                      NUMERORECIBO,
                      NUMEROSUSCRIPTOR,
                      VALORTRANSACCION,
                      CHECKAMOUNT,
                      TRIMRIGHTRECEIPT,
                      TRIMRIGHTSUSCRIBER,
                      CONFIGURACION,
                      TRANSACCIONALIADO.COMPENSADO
                 FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
                INNER JOIN WSXML_SFG.TRANSACCIONALIADO
                   ON (CODARCHIVOTRANSACCIONALIADO =
                      ID_ARCHIVOTRANSACCIONALIADO)
                INNER JOIN WSXML_SFG.FORMATOARCHIVOTRANSACCION
                   ON (CODFORMATOARCHIVOTRANSACCION =
                      ID_FORMATOARCHIVOTRANSACCION)
                WHERE ID_ARCHIVOTRANSACCIONALIADO =
                      @p_CODARCHIVOTRANSACCIONALIADO
                  AND CODREGISTROFACTREFERENCIA IS NULL
                order by id_TRANSACCIONALIADO asc; OPEN tx;

	 DECLARE @tx__FECHAARCHIVO NUMERIC(38,0),
                      @tx__CODALIADOESTRATEGICO NUMERIC(38,0),
                      @tx__ID_TRANSACCIONALIADO NUMERIC(38,0),
                      @tx__NUMERORECIBO NUMERIC(38,0),
                      @tx__NUMEROSUSCRIPTOR NUMERIC(38,0),
                      @tx__VALORTRANSACCION FLOAT,
                      @tx__CHECKAMOUNT FLOAT,
                      @tx__TRIMRIGHTRECEIPT NUMERIC(38,0),
                      @tx__TRIMRIGHTSUSCRIBER NUMERIC(38,0),
                      @tx__CONFIGURACION VARCHAR(20),
                      @tx__COMPENSADO NUMERIC(38,0)

	 FETCH NEXT FROM tx INTO @tx__FECHAARCHIVO,
                      @tx__CODALIADOESTRATEGICO,
                      @tx__ID_TRANSACCIONALIADO,
                      @tx__NUMERORECIBO,
                      @tx__NUMEROSUSCRIPTOR,
                      @tx__VALORTRANSACCION,
                      @tx__CHECKAMOUNT,
                      @tx__TRIMRIGHTRECEIPT,
                      @tx__TRIMRIGHTSUSCRIBER,
                      @tx__CONFIGURACION,
                      @tx__COMPENSADO;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
    
      SET @v_TIPO_REGISTRO = 1;
    
      SET @p_NUMERORECIBO     = @TX__NUMERORECIBO;
      SET @p_NUMEROSUSCRIPTOR = @TX__NUMEROSUSCRIPTOR;
      SET @p_VALORTRANSACCION = @TX__VALORTRANSACCION;
    
      SET @p_TRANSACCIONENCONTRADA_out = 0;
    
      select @vCODALIADO = al.codaliadoestrategico
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      select @fechaarchivoMAX = CONVERT(DATETIME,al.fechaarchivo) + @vINCREMENTOS
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      select @fechaarchivoMIN = CONVERT(DATETIME,al.fechaarchivo) - @vINCREMENTOS
        from wsxml_sfg.archivotransaccionaliado al
       where al.id_archivotransaccionaliado = @p_CODARCHIVOTRANSACCIONALIADO;
    
      begin
		BEGIN TRY
      
			select @xCODREGISTROFACTREFERENCIA = rfr.id_registrofactreferencia
			  from wsxml_sfg.registrofactreferencia rfr
			 where rfr.codregistrofacturacion in
				   (select rf.id_registrofacturacion
					  from wsxml_sfg.registrofacturacion rf,
						   wsxml_sfg.producto            p
					 where rf.codtiporegistro = 1
					   and rf.codproducto = p.id_producto
					   and rf.codentradaarchivocontrol in
						   (select ac.id_entradaarchivocontrol
							  from WSXML_SFG.entradaarchivocontrol ac
							 where ac.tipoarchivo = 1
							   and ac.fechaarchivo BETWEEN CONVERT(DATETIME,@TX__FECHAARCHIVO) - 7 AND
								   CONVERT(DATETIME,@TX__FECHAARCHIVO))
					   and p.codaliadoestrategico = 107)
				  /* order by rfr.numeroreferencia
				  ) RF*/
			   and CAST(isnull(RTRIM(LTRIM(RFR.RECIBO)), 0) AS NUMERIC(38,0)) =
				   CAST(isnull(@p_NUMERORECIBO, 0) AS NUMERIC(38,0))
			   AND RFR.VALORTRANSACCION = @p_VALORTRANSACCION
			   and isnull(rfr.codtransaccionaliado, 0) = 0
			   --and;
		END TRY
		BEGIN CATCH
			  SELECT null;
		END CATCH
        
      end;
    
      BEGIN
		BEGIN TRY
			IF @xCODREGISTROFACTREFERENCIA IS NOT NULL BEGIN
			  EXEC WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_BindTransactionWSale @TX__ID_TRANSACCIONALIADO,@xCODREGISTROFACTREFERENCIA
			  SET @p_COUNTNOVINCULADOS = @p_COUNTNOVINCULADOS - 1;
			  commit;
			  if @v_TIPO_REGISTRO = 5 begin
				UPDATE WSXML_SFG.TRANSACCIONALIADO
				   SET VALORTRANSACCION = 0
				 WHERE ID_TRANSACCIONALIADO = @TX__ID_TRANSACCIONALIADO;
			  END 
			END 
		END TRY
		BEGIN CATCH
          SELECT NULL;
		  END CATCH
      END;
    
    FETCH NEXT FROM tx INTO @tx__FECHAARCHIVO,
                      @tx__CODALIADOESTRATEGICO,
                      @tx__ID_TRANSACCIONALIADO,
                      @tx__NUMERORECIBO,
                      @tx__NUMEROSUSCRIPTOR,
                      @tx__VALORTRANSACCION,
                      @tx__CHECKAMOUNT,
                      @tx__TRIMRIGHTRECEIPT,
                      @tx__TRIMRIGHTSUSCRIBER,
                      @tx__CONFIGURACION,
                      @tx__COMPENSADO;
    END;
    CLOSE tx;
    DEALLOCATE tx;
  END
  GO


  IF OBJECT_ID('WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_AplicarAjusteRevenue', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_AplicarAjusteRevenue;
GO


 CREATE PROCEDURE WSXML_SFG.SFGARCHIVOTRANSACCIONALIADO_AplicarAjusteRevenue(@P_CODALIADOESTRATEGICO NUMERIC(22,0),
                                 @P_FECHADESDE           DATETIME,
                                 @P_FECHAHASTA           DATETIME) AS
 BEGIN
    DECLARE @v_NARCHIVOCTA NUMERIC(22,0);
   
	SET NOCOUNT ON;
    /*    SELECT A.FECHAARCHIVO, A.CODALIADOESTRATEGICO
     INTO v_FECHAARCHIVO, v_CODALIADO
     FROM ARCHIVOTRANSACCIONALIADO A
    WHERE ID_ARCHIVOTRANSACCIONALIADO = P_CODARCHIVOTRANSACCIONALIADO;*/
  
    DECLARE AjustesRev CURSOR FOR SELECT REGISTROFACTURACION.CODPRODUCTO,
                              ENTRADAARCHIVOCONTROL.FECHAARCHIVO,
                              SUM(REGISTROREVENUEINCENTIVO.REVENUE) AS VALOR
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
                        INNER JOIN WSXML_SFG.PRODUCTO
                           ON REGISTROFACTURACION.CODPRODUCTO =
                              PRODUCTO.ID_PRODUCTO
                        WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN
                              @P_FECHADESDE AND @P_FECHAHASTA
                          AND PRODUCTO.CODALIADOESTRATEGICO =
                              @P_CODALIADOESTRATEGICO
                          AND REGISTROREVENUEINCENTIVO.CODINCENTIVOCOMISIONGLOBAL IS NULL
                        GROUP BY REGISTROFACTURACION.CODPRODUCTO,
                                 ENTRADAARCHIVOCONTROL.FECHAARCHIVO; OPEN AjustesRev;

	DECLARE @AjustesRev__CODPRODUCTO NUMERIC(38,0), @AjustesRev__FECHAARCHIVO DATETIME, @AjustesRev__VALOR FLOAT
	 FETCH NEXT FROM AjustesRev INTO @AjustesRev__CODPRODUCTO, @AjustesRev__FECHAARCHIVO, @AjustesRev__VALOR
	 WHILE @@FETCH_STATUS=0
	 BEGIN
    
			DECLARE @v_ID_TRANSACCIONALIADO NUMERIC(22,0);
		  BEGIN
      
		SELECT @v_ID_TRANSACCIONALIADO = MIN(ID_TRANSACCIONALIADO)
		FROM (
			SELECT ID_TRANSACCIONALIADO, ROW_NUMBER() OVER(ORDER BY REGISTROFACTREFERENCIA.FECHAHORATRANSACCION) AS ROWID
			  FROM WSXML_SFG.TRANSACCIONALIADO
				 INNER JOIN WSXML_SFG.ARCHIVOTRANSACCIONALIADO
					ON TRANSACCIONALIADO.CODARCHIVOTRANSACCIONALIADO =
					   ARCHIVOTRANSACCIONALIADO.ID_ARCHIVOTRANSACCIONALIADO
				 INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA
					ON TRANSACCIONALIADO.CODREGISTROFACTREFERENCIA =
					   REGISTROFACTREFERENCIA.ID_REGISTROFACTREFERENCIA
				 WHERE ARCHIVOTRANSACCIONALIADO.CODALIADOESTRATEGICO =
					   @P_CODALIADOESTRATEGICO
				   AND ARCHIVOTRANSACCIONALIADO.FECHAARCHIVO =
					   @AjustesRev__Fechaarchivo
				   AND TRANSACCIONALIADO.CODPRODUCTO = @AjustesRev__CODPRODUCTO
				   --AND
			) T
			UPDATE WSXML_SFG.TRANSACCIONALIADO
			   SET REVENUETRANSACCIONAL = ROUND(REVENUETRANSACCIONAL + @AjustesRev__VALOR,2),
				   REVENUETRANSACCION   = ROUND(REVENUETRANSACCION + @AjustesRev__VALOR,2)
			 WHERE ID_TRANSACCIONALIADO = @v_ID_TRANSACCIONALIADO;
      
		  END;
    
		FETCH NEXT FROM AjustesRev INTO @AjustesRev__CODPRODUCTO, @AjustesRev__FECHAARCHIVO, @AjustesRev__VALOR
		END;
		CLOSE AjustesRev;
		DEALLOCATE AjustesRev;
  
 END;

GO



IF OBJECT_ID('SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_LoadCitiFile', 'P') IS NOT NULL
  DROP PROCEDURE SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_LoadCitiFile;
GO

CREATE     PROCEDURE SFG_CONCILIACION.SFGARCHIVOTRANSACCIONALIADO_LoadCitiFile(@p_CODARCHIVOTRANSACCIONALIADO NUMERIC(22,0),
                         @p_FECHAFILE                   DATETIME) AS ;

GO
