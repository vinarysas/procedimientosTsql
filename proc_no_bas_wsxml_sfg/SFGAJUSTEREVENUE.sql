USE SFGPRODU;
--  DDL for Package Body SFGAJUSTEREVENUE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGAJUSTEREVENUE */ 


  IF OBJECT_ID('WSXML_SFG.SFGAJUSTEREVENUE_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_CONSTANT(
  @MODIFICACIONTARIFA SMALLINT OUT,
  @MODIFICACIONVALOR SMALLINT OUT,
  @MODIFICACIONPUNTO  SMALLINT OUT ) AS
  BEGIN
  SET NOCOUNT ON;

    -- 1  Modificacion de tarifa retroactiva
  SET @MODIFICACIONTARIFA= 1;
  -- 2  Modificacion de valores
  SET @MODIFICACIONVALOR  = 2;
  -- 3  Modificacion reglas punto de venta
  SET @MODIFICACIONPUNTO  = 3;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentRecord(@p_DESCRIPCIONAJUSTE           NVARCHAR(2000),
                                @p_CODTIPOAJUSTEREVENUE        NUMERIC(22,0),
                                @p_VALORAJUSTE                 FLOAT,
                                @p_CODENTRADAARCHIVOORIGEN     NUMERIC(22,0),
                                @p_CODREGISTROFACTORIGEN       NUMERIC(22,0),
                                @p_CODREGISTROREVNORIGEN       NUMERIC(22,0),
                                @p_CODENTRADAARCHIVODESTINO    NUMERIC(22,0),
                                @p_CODREGISTROFACTDESTINO      NUMERIC(22,0),
                                @p_CODREGISTROREVNDESTINO      NUMERIC(22,0),
                                @p_REVENUEAJUSTE               FLOAT,
                                @p_DIFERENCIALINGRESOCORPORATI FLOAT,
                                @p_DIFERENCIALEGRESOCORPORATIV FLOAT,
                                @p_DIFERENCIALINGRESOLOCAL     FLOAT,
                                @p_DIFERENCIALEGRESOLOCAL      FLOAT,
                                @p_DIFERENCIALVALORCOMISIONEST FLOAT,
                                @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                                @p_CODAJUSTEREVENUE_out        NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.AJUSTEREVENUE (
                               DESCRIPCIONAJUSTE,
                               CODTIPOAJUSTEREVENUE,
                               VALORAJUSTE,
                               CODENTRADAARCHIVOORIGEN,
                               CODREGISTROFACTORIGEN,
                               CODREGISTROREVNORIGEN,
                               CODENTRADAARCHIVODESTINO,
                               CODREGISTROFACTDESTINO,
                               CODREGISTROREVNDESTINO,
                               REVENUEAJUSTE,
                               DIFERENCIALINGRESOCORPORATI,
                               DIFERENCIALEGRESOCORPORATIV,
                               DIFERENCIALINGRESOLOCAL,
                               DIFERENCIALEGRESOLOCAL,
                               DIFERENCIALVALORCOMISIONEST,
                               CODUSUARIOMODIFICACION)
    VALUES (
            @p_DESCRIPCIONAJUSTE,
            @p_CODTIPOAJUSTEREVENUE,
            @p_VALORAJUSTE,
            @p_CODENTRADAARCHIVOORIGEN,
            @p_CODREGISTROFACTORIGEN,
            @p_CODREGISTROREVNORIGEN,
            @p_CODENTRADAARCHIVODESTINO,
            @p_CODREGISTROFACTDESTINO,
            @p_CODREGISTROREVNDESTINO,
            @p_REVENUEAJUSTE,
            @p_DIFERENCIALINGRESOCORPORATI,
            @p_DIFERENCIALEGRESOCORPORATIV,
            @p_DIFERENCIALINGRESOLOCAL,
            @p_DIFERENCIALEGRESOLOCAL,
            @p_DIFERENCIALVALORCOMISIONEST,
            @p_CODUSUARIOMODIFICACION);
    SET @p_CODAJUSTEREVENUE_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentCostRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentCostRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentCostRecord(@p_CODREGISTROREVENUE           NUMERIC(22,0),
                                    @p_CODREGISTROREVCOSTOCALCULADO NUMERIC(22,0),
                                    @p_CODAJUSTEREVENUE             NUMERIC(22,0),
                                    @p_CODCOSTOCALCULADO            NUMERIC(22,0),
                                    @p_VALORCOSTO                   FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.AJUSTEREVCOSTOCALCULADO (
                                         CODREGISTROREVENUE,
                                         CODREGISTROREVCOSTOCALCULADO,
                                         CODAJUSTEREVENUE,
                                         CODCOSTOCALCULADO,
                                         VALORCOSTO)
    VALUES (
            @p_CODREGISTROREVENUE,
            @p_CODREGISTROREVCOSTOCALCULADO,
            @p_CODAJUSTEREVENUE,
            @p_CODCOSTOCALCULADO,
            @p_VALORCOSTO);
  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGAJUSTEREVENUE_CreateAdjustment', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_CreateAdjustment;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAJUSTEREVENUE_CreateAdjustment(@p_FECHAINGRESOAJUSTE     DATETIME,
                             @p_DESCRIPCION            NVARCHAR(2000),
                             @p_CODTIPOAJUSTEREVENUE   NUMERIC(22,0),
                             @p_VALORAJUSTE            FLOAT,
                             @p_FECHAREFERENCIA        DATETIME,   -- Dia origen
                             @p_CODPUNTODEVENTA        NUMERIC(22,0), -- En caso de reglas de punto (3)
                             @p_CODPRODUCTO            NUMERIC(22,0), -- En caso de modificacion de tarifa o valor (1 y 2)
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                             @p_ID_AJUSTEREVENUE_out   NUMERIC(22,0) OUT) AS
 BEGIN
 
	SET NOCOUNT ON;
	
    DECLARE @countservics NUMERIC(22,0);
    DECLARE @countfilescl NUMERIC(22,0);
    -- Cache helpers
    DECLARE @cachetarifa      WSXML_SFG.PRODUCTTARIFA;
    DECLARE @cachetarifadif   WSXML_SFG.PRODUCTTARIFA;
    DECLARE @cacheconfigpyg   WSXML_SFG.CONFIGPYGREGISTRY;
    -- Source files
    DECLARE @lstoriginfiles   WSXML_SFG.NUMBERARRAY;
    DECLARE @cFECHAORIGEN     DATETIME = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAREFERENCIA));
    DECLARE @errormsg         NVARCHAR(2000);
		DECLARE @rowcount NUMERIC(22,0) = 0;

	DECLARE 
	  @MODIFICACIONTARIFA SMALLINT,
	  @MODIFICACIONVALOR SMALLINT,
	  @MODIFICACIONPUNTO  SMALLINT

	EXEC WSXML_SFG.SFGAJUSTEREVENUE_CONSTANT
	  @MODIFICACIONTARIFA OUT,
	  @MODIFICACIONVALOR OUT,
	  @MODIFICACIONPUNTO  OUT
   
   	DECLARE @TIPOINFORMATIVO TINYINT, @TIPOERROR TINYINT,
		@TIPOADVERTENCIA TINYINT, @TIPOCUALQUIERA TINYINT,
		@PROCESONOTIFICACION TINYINT, @ESTADOABIERTA TINYINT,
		@ESTADOCERRADA TINYINT

	EXEC WSXML_SFG.SFGALERTA_CONSTANT
			@TIPOINFORMATIVO OUT,
			@TIPOERROR OUT,
			@TIPOADVERTENCIA OUT,
			@TIPOCUALQUIERA OUT,
			@PROCESONOTIFICACION OUT,
			@ESTADOABIERTA OUT,
			@ESTADOCERRADA OUT
			
	DECLARE @VALORUSUARIO 	TINYINT,
	  @VALORFIGURAP  	TINYINT,
	  @VALORTARIFAV 	TINYINT,
	  @VALORCOSTOPV 	TINYINT,
	  @VALORCOSTASO 	TINYINT

	EXEC WSXML_SFG.SFGCOSTOCALCULADO_CONSTANT
	  @VALORUSUARIO  OUT,
	  @VALORFIGURAP  OUT,
	  @VALORTARIFAV  OUT,
	  @VALORCOSTOPV  OUT,
	  @VALORCOSTASO  OUT
			
	
	DECLARE @VENTAFACT SMALLINT,
                      @ANULACION SMALLINT,
					  @FREETICKT SMALLINT,
					  @PREMIOPAG SMALLINT,
					  @RGSTOTROS SMALLINT,
					  @VENNOFACT SMALLINT

	EXEC WSXML_SFG.SFGTIPOREGISTRO_CONSTANT
                      @VENTAFACT OUT,
                      @ANULACION OUT,
					  @FREETICKT OUT,
					  @PREMIOPAG OUT,
					  @RGSTOTROS OUT,
					  @VENNOFACT OUT

	DECLARE @cpsvcodeTIPOCOMISION   NUMERIC(22,0);
    DECLARE @cpsvcalcVALORPORCENTUA FLOAT = 0;
    DECLARE @cpsvcalcVALORTRANSCCNL FLOAT = 0;

	DECLARE @cvalcalcVALORPORCENTUA FLOAT = 0;
    DECLARE @cvalcalcVALORTRANSCCNL FLOAT = 0;

    -- Verificar que se haya calculado el revenue para la fecha de referencia
    SELECT @countservics = COUNT(1) FROM WSXML_SFG.SERVICIO;
    SELECT @countfilescl = COUNT(1) FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE FECHAARCHIVO = @cFECHAORIGEN AND REVERSADO = 0 AND REVENUECALCULADO = 1;
    IF @countservics <> @countfilescl BEGIN
      RAISERROR('-20054 No se puede ajustar el revenue a partir de la fecha porque no se calculo revenue', 16, 1);
	  RETURN 0;
    END 

    -- Tarifas por contrato
    --SET @cachetarifa = 
	DECLARE @getTarifaCacheList [WSXML_SFG].[PRODUCTTARIFA];
	
	INSERT INTO @getTarifaCacheList
	SELECT PARENT,CODTARIFAVALOR,VALOR 
	FROM WSXML_SFG.SFGPRODUCTOCONTRATO_GetTarifaCacheList_F(@cFECHAORIGEN,-1)

    INSERT INTO @cachetarifadif 
	SELECT * FROM WSXML_SFG.SFGPRODUCTOCONTRATO_GetTarifaDiferencialCacheList(@cFECHAORIGEN);

    -- Configuracion P&G
    INSERT INTO @cacheconfigpyg 
	SELECT * FROM WSXML_SFG.SFGCONFIGURACIONPYG_GetConfiguracionCache();

    IF @p_CODTIPOAJUSTEREVENUE = @MODIFICACIONTARIFA OR @p_CODTIPOAJUSTEREVENUE = @MODIFICACIONVALOR BEGIN
      -- Solo se calculara para el archivo correspondiente a la fecha, producto
      
	  INSERT INTO @lstoriginfiles 
	  SELECT CTR.ID_ENTRADAARCHIVOCONTROL 
	  FROM WSXML_SFG.PRODUCTO PRD
      INNER JOIN WSXML_SFG.TIPOPRODUCTO          TPR ON (TPR.ID_TIPOPRODUCTO   = PRD.CODTIPOPRODUCTO)
      INNER JOIN WSXML_SFG.LINEADENEGOCIO        LDN ON (LDN.ID_LINEADENEGOCIO = TPR.CODLINEADENEGOCIO)
      INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL CTR ON (CTR.TIPOARCHIVO       = LDN.CODSERVICIO)
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO = @cFECHAORIGEN AND PRD.ID_PRODUCTO = @p_CODPRODUCTO;
    END
    ELSE IF @p_CODTIPOAJUSTEREVENUE = @MODIFICACIONPUNTO BEGIN
      -- Se recalculara para todos los registros que pertenezcan al punto de venta para la fecha
      INSERT INTO @lstoriginfiles 
	  SELECT CTR.ID_ENTRADAARCHIVOCONTROL
	  FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO = @cFECHAORIGEN;
    END
    ELSE BEGIN
      RAISERROR('-20090 No se reconoce el tipo de ajuste', 16, 1);
	  RETURN 0;
    END 

    -- Para todos los archivos, calcular
    IF (SELECT COUNT(*) FROM @lstoriginfiles) > 0 BEGIN
      DECLARE ifile CURSOR FOR SELECT IDVALUE FROM @lstoriginfiles--.First..lstoriginfiles.Last LOOP
	  OPEN ifile
	  DECLARE @ifile__IDVALUE NUMERIC(38,0)
	  FETCH NEXT FROM ifile INTO @ifile__IDVALUE
	  
	  WHILE (@@FETCH_STATUS = 0)
	  BEGIN
          DECLARE @costoscalculados         WSXML_SFG.FORMULA;
          DECLARE @lstconsiderablerecords   WSXML_SFG.LONGNUMBERARRAY;
          DECLARE @cCODSERVICIOARCHIVO      NUMERIC(22,0);
          DECLARE @newENTRADAARCHIVOCONTROL NUMERIC(22,0);
        BEGIN
          SELECT @cCODSERVICIOARCHIVO = TIPOARCHIVO FROM WSXML_SFG.ENTRADAARCHIVOCONTROL WHERE ID_ENTRADAARCHIVOCONTROL = @ifile__IDVALUE;
          
		  INSERT INTO @costoscalculados
		  SELECT ID, DESCONTABLE, DEFINITION FROM WSXML_SFG.SFGCOSTOCALCULADO_GetCurrentCostoList(@cCODSERVICIOARCHIVO); -- Costos Calculados

          -- Los registros considerables dependen del tipo de ajuste
          IF @p_CODTIPOAJUSTEREVENUE = @MODIFICACIONTARIFA OR @p_CODTIPOAJUSTEREVENUE = @MODIFICACIONVALOR BEGIN
            INSERT INTO @lstconsiderablerecords 
			SELECT ID_REGISTROFACTURACION 
			FROM WSXML_SFG.REGISTROFACTURACION
            WHERE CODENTRADAARCHIVOCONTROL = @ifile__IDVALUE
              AND CODPRODUCTO              = @p_CODPRODUCTO
              AND CODTIPOREGISTRO          IN (1, 2);
          END
          ELSE IF @p_CODTIPOAJUSTEREVENUE = @MODIFICACIONPUNTO BEGIN
            INSERT INTO @lstconsiderablerecords 
			SELECT ID_REGISTROFACTURACION 
			FROM WSXML_SFG.REGISTROFACTURACION
            WHERE CODENTRADAARCHIVOCONTROL = @ifile__IDVALUE
              AND CODPUNTODEVENTA          = @p_CODPUNTODEVENTA
              AND CODTIPOREGISTRO          IN (1, 2);
          END 
          -- Obtener nuevo identificador de archivo en donde ingresar el ajuste
          BEGIN
            
			SELECT @newENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
            WHERE REVERSADO = 0 AND TIPOARCHIVO = @cCODSERVICIOARCHIVO AND FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINGRESOAJUSTE)) AND REVENUECALCULADO = 1;
          
			IF @@ROWCOUNT = 0 BEGIN
				RAISERROR('-20050 No es posible ingresar un ajuste en la fecha debido a que no se ha corrido el revenue sobre esta', 16, 1);
				RETURN 0
			END
          END;

          -- Para cada uno de los registros, calcular en variables y comparar contra calculados
          IF (SELECT COUNT(*) FROM @lstconsiderablerecords) > 0 BEGIN
            DECLARE irecord CURSOR FOR SELECT IDVALUE FROM @lstconsiderablerecords--.First..lstconsiderablerecords.Last LOOP
			OPEN irecord
			DECLARE @irecord__IDVALUE NUMERIC(38,0)

			FETCH NEXT FROM irecord INTO @irecord__IDVALUE
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
              /* Recalcular revenue bruto */
                DECLARE @originARCHIVOCONTROL        NUMERIC(22,0);
                DECLARE @originREGISTROFACTURACION   NUMERIC(22,0) = @irecord__IDVALUE;
                DECLARE @originREGISTROREVENUE       NUMERIC(22,0);
                DECLARE @originPRODUCTOREVENUE       NUMERIC(22,0);
                DECLARE @destinREGISTROFACTURACION   NUMERIC(22,0);
                DECLARE @destinREGISTROREVENUE       NUMERIC(22,0);
                DECLARE @destinPRODUCTOREVENUE       NUMERIC(22,0);
                DECLARE @xCODTIPOREGISTRO            NUMERIC(22,0);
                DECLARE @xCODPUNTODEVENTA            NUMERIC(22,0);
                DECLARE @xCODTIPOCONTRATOPDV         NUMERIC(22,0);
                DECLARE @xCODPRODUCTO                NUMERIC(22,0);
                DECLARE @xCODTIPOCONTRATOPRODUCTO    NUMERIC(22,0);
                DECLARE @xCODCOMPANIA                NUMERIC(22,0);
                DECLARE @xCODSERVICIO                NUMERIC(22,0);
                -- Valores para calcular y considerar
                DECLARE @xNUMTRANSACCIONES           NUMERIC(22,0);
                DECLARE @xVALORTRANSACCION           FLOAT;
                DECLARE @xTOTALVENTASBRUTAS          FLOAT;
                DECLARE @xVALORINGRESOPDV            FLOAT;
                DECLARE @xVALORIVAINGRESOPDV         FLOAT;
                DECLARE @xCODAGRUPACIONPUNTODEVENTA  NUMERIC(22,0);
                DECLARE @xCODREDPDV                  NUMERIC(22,0);
                DECLARE @xCODCIUDAD                  NUMERIC(22,0);
                -- Valores de Tarifa (Ignorar valor de Anticipo)
                DECLARE @xCODRANGOCOMISION           NUMERIC(22,0);
                DECLARE @xCODTIPOCOMISION            NUMERIC(22,0);
                DECLARE @xCODTIPORANGO               NUMERIC(22,0);
                DECLARE @xCODRANGOCOMISIONDIFAGR     NUMERIC(22,0);
                DECLARE @xCODRANGOCOMISIONDIFRED     NUMERIC(22,0);
                DECLARE @xCODRANGOCOMISIONDIFDTO     NUMERIC(22,0);
                DECLARE @cFLAGCOMISIONDIFERENCIALBIN NUMERIC(22,0);
                DECLARE @cLISTCOMISIONDIFERENCIALBIN WSXML_SFG.IDSTRINGFLOATVALUE;
                DECLARE @cLISTADVTRANSACCIONES       WSXML_SFG.IDSTRINGVALUE;
                DECLARE @xCODRANGOCOMISIONESTANDAR   NUMERIC(22,0);
                -- Calculation value
                DECLARE @xCOMISIONPOSESTANDAR        FLOAT = 0;
                DECLARE @xREVENUE                    FLOAT = 0;
                DECLARE @xINGRESOCORPORATIVO         FLOAT = 0;
                DECLARE @xEGRESOCORPORATIVO          FLOAT = 0;
                DECLARE @xINGRESOLOCAL               FLOAT = 0;
                DECLARE @xEGRESOLOCAL                FLOAT = 0;
                DECLARE @nCOMISIONPOSESTANDAR        FLOAT = 0;
                DECLARE @nREVENUE                    FLOAT = 0;
                DECLARE @nINGRESOCORPORATIVO         FLOAT = 0;
                DECLARE @nEGRESOCORPORATIVO          FLOAT = 0;
                DECLARE @nINGRESOLOCAL               FLOAT = 0;
                DECLARE @nEGRESOLOCAL                FLOAT = 0;
                DECLARE @difCOMISIONPOSESTANDAR      FLOAT = 0;
                DECLARE @difREVENUE                  FLOAT = 0;
                DECLARE @difINGRESOCORPORATIVO       FLOAT = 0;
                DECLARE @difEGRESOCORPORATIVO        FLOAT = 0;
                DECLARE @difINGRESOLOCAL             FLOAT = 0;
                DECLARE @difEGRESOLOCAL              FLOAT = 0;

                -- Output control values
                DECLARE @flagANULACIONDIFERENCIAL   NUMERIC(22,0) = 0;
                BEGIN
					EXEC WSXML_SFG.SFGREGISTROREVENUE_GetRegistryRevenueValues 
						@cFECHAORIGEN, @originREGISTROFACTURACION, 
							@originARCHIVOCONTROL OUT, @xCODTIPOREGISTRO OUT, @xCODPUNTODEVENTA OUT, @xCODTIPOCONTRATOPDV OUT, @xCODPRODUCTO OUT, @xCODTIPOCONTRATOPRODUCTO OUT, @xCODCOMPANIA OUT, @xNUMTRANSACCIONES OUT, @xVALORTRANSACCION OUT, @xTOTALVENTASBRUTAS OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODREDPDV OUT, @xCODCIUDAD OUT, @xCODRANGOCOMISION OUT, @xCODTIPOCOMISION OUT, @xCODTIPORANGO OUT, @xCODRANGOCOMISIONDIFAGR OUT, @xCODRANGOCOMISIONDIFRED OUT, @xCODRANGOCOMISIONDIFDTO OUT, @cFLAGCOMISIONDIFERENCIALBIN OUT, @cLISTCOMISIONDIFERENCIALBIN OUT, @cLISTADVTRANSACCIONES OUT, @xCODRANGOCOMISIONESTANDAR OUT
					IF @xCODTIPOREGISTRO = @ANULACION BEGIN
						DECLARE @xCountReferences NUMERIC(22,0) = 0;
					  BEGIN
						SELECT @xCountReferences = COUNT(ID_REGISTROFACTREFERENCIA) FROM WSXML_SFG.REGISTROFACTREFERENCIA WHERE CODREGISTROFACTURACION = @originREGISTROFACTURACION;
						IF @xCountReferences > 0 BEGIN
						  SET @flagANULACIONDIFERENCIAL = 1;
						END 
					  END;
					END 

					IF @flagANULACIONDIFERENCIAL = 1
					  BEGIN
						-- Obtener (calcular en variables)
						DECLARE treference CURSOR FOR SELECT ID_REGISTROFACTREFERENCIA, CONVERT(DATETIME, CONVERT(DATE,FECHAHORATRANSACCION)) AS FECHA, VALORTRANSACCION, CODREGISTROANULADO FROM WSXML_SFG.REGISTROFACTREFERENCIA
										   WHERE CODREGISTROFACTURACION = @originREGISTROFACTURACION; OPEN treference;
						 DECLARE @treference__ID_REGISTROFACTREFERENCIA NUMERIC(38,0), @treference__FECHA DATETIME, @treference__VALORTRANSACCION FLOAT, @treference__CODREGISTROANULADO NUMERIC(38,0)
						 FETCH NEXT FROM treference INTO @treference__ID_REGISTROFACTREFERENCIA, @treference__FECHA, @treference__VALORTRANSACCION, @treference__CODREGISTROANULADO;
						 WHILE @@FETCH_STATUS=0
						 BEGIN
							DECLARE @orgCODREGISTROFACTURACION   NUMERIC(22,0);
							DECLARE @dmyCODENTRADAARCHIVOCONTROL NUMERIC(22,0);
							DECLARE @dmyCODTIPOREGISTRO          NUMERIC(22,0);
							DECLARE @tmpvCOMISIONPOSESTANDAR     FLOAT = 0;
							DECLARE @tmpvREVENUE                 FLOAT = 0;
							DECLARE @tmpvCODRANGOCOMISIONDETALLE NUMERIC(22,0);
							BEGIN
							BEGIN
								BEGIN TRY
								  IF @treference__CODREGISTROANULADO IS NULL BEGIN
									SET @errormsg = 'No se pudo obtener los valores originales de transaccion para la referencia anulacion de id ' + ISNULL(CONVERT(VARCHAR,@treference__ID_REGISTROFACTREFERENCIA), '')
									EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @errormsg							  
									EXEC WSXML_SFG.SFGREGISTROREVENUE_GetRegistryRevenueValues @treference__FECHA, @originREGISTROFACTURACION, @dmyCODENTRADAARCHIVOCONTROL OUT, @dmyCODTIPOREGISTRO OUT, @xCODPUNTODEVENTA OUT, @xCODTIPOCONTRATOPDV OUT, @xCODPRODUCTO OUT, @xCODTIPOCONTRATOPRODUCTO OUT, @xCODCOMPANIA OUT, @xNUMTRANSACCIONES OUT, @xVALORTRANSACCION OUT, @xTOTALVENTASBRUTAS OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODREDPDV OUT, @xCODCIUDAD OUT, @xCODRANGOCOMISION OUT, @xCODTIPOCOMISION OUT, @xCODTIPORANGO OUT, @xCODRANGOCOMISIONDIFAGR OUT, @xCODRANGOCOMISIONDIFRED OUT, @xCODRANGOCOMISIONDIFDTO OUT, @cFLAGCOMISIONDIFERENCIALBIN OUT, @cLISTCOMISIONDIFERENCIALBIN OUT, @cLISTADVTRANSACCIONES OUT, @xCODRANGOCOMISIONESTANDAR OUT
								  END 
								  SELECT @orgCODREGISTROFACTURACION = ID_REGISTROFACTURACION 
								  FROM WSXML_SFG.REGISTROFACTURACION
								  INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA ON (CODREGISTROFACTURACION = ID_REGISTROFACTURACION)
								  WHERE ID_REGISTROFACTREFERENCIA = @treference__CODREGISTROANULADO;
								  
									EXEC WSXML_SFG.SFGREGISTROREVENUE_GetRegistryRevenueValues 
										@treference__FECHA, @orgCODREGISTROFACTURACION, @dmyCODENTRADAARCHIVOCONTROL OUT, @dmyCODTIPOREGISTRO OUT, @xCODPUNTODEVENTA OUT, @xCODTIPOCONTRATOPDV OUT, @xCODPRODUCTO OUT, @xCODTIPOCONTRATOPRODUCTO OUT, @xCODCOMPANIA OUT, @xNUMTRANSACCIONES OUT, @xVALORTRANSACCION OUT, @xTOTALVENTASBRUTAS OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODREDPDV OUT, @xCODCIUDAD OUT, @xCODRANGOCOMISION OUT, @xCODTIPOCOMISION OUT, @xCODTIPORANGO OUT, @xCODRANGOCOMISIONDIFAGR OUT, @xCODRANGOCOMISIONDIFRED OUT, @xCODRANGOCOMISIONDIFDTO OUT, @cFLAGCOMISIONDIFERENCIALBIN OUT, @cLISTCOMISIONDIFERENCIALBIN OUT, @cLISTADVTRANSACCIONES OUT, @xCODRANGOCOMISIONESTANDAR OUT
								
								END TRY
								BEGIN CATCH
								  SET @errormsg = 'No se pudo obtener los valores originales de transaccion para la referencia anulacion de id ' + ISNULL(CONVERT(VARCHAR,@treference__ID_REGISTROFACTREFERENCIA), '')
								  EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @errormsg							  
								  EXEC WSXML_SFG.SFGREGISTROREVENUE_GetRegistryRevenueValues @treference__FECHA, @originREGISTROFACTURACION, @dmyCODENTRADAARCHIVOCONTROL OUT, @dmyCODTIPOREGISTRO OUT, @xCODPUNTODEVENTA OUT, @xCODTIPOCONTRATOPDV OUT, @xCODPRODUCTO OUT, @xCODTIPOCONTRATOPRODUCTO OUT, @xCODCOMPANIA OUT, @xNUMTRANSACCIONES OUT, @xVALORTRANSACCION OUT, @xTOTALVENTASBRUTAS OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODREDPDV OUT, @xCODCIUDAD OUT, @xCODRANGOCOMISION OUT, @xCODTIPOCOMISION OUT, @xCODTIPORANGO OUT, @xCODRANGOCOMISIONDIFAGR OUT, @xCODRANGOCOMISIONDIFRED OUT, @xCODRANGOCOMISIONDIFDTO OUT, @cFLAGCOMISIONDIFERENCIALBIN OUT, @cLISTCOMISIONDIFERENCIALBIN OUT, @cLISTADVTRANSACCIONES OUT, @xCODRANGOCOMISIONESTANDAR OUT
								END CATCH
							END;
							-- Verificar si se encontro comision (tarifa) diferencial
							BEGIN
								BEGIN TRY
								  IF @xCODRANGOCOMISIONDIFAGR <> 0 BEGIN
									SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, @xCODTIPOCOMISION = CODTIPOCOMISION, @xCODTIPORANGO = CODTIPORANGO
									FROM WSXML_SFG.RANGOCOMISION WHERE ID_RANGOCOMISION = @xCODRANGOCOMISIONDIFAGR;
								  END
								  ELSE IF @xCODRANGOCOMISIONDIFRED <> 0 BEGIN
									SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, @xCODTIPOCOMISION = CODTIPOCOMISION, @xCODTIPORANGO = CODTIPORANGO
									FROM WSXML_SFG.RANGOCOMISION WHERE ID_RANGOCOMISION = @xCODRANGOCOMISIONDIFRED;
								  END 
								END TRY
								BEGIN CATCH
								  SET @errormsg = 'No se pudo obtener valores para tarifa diferencial: Se prosigue con tarifa normal. ' + isnull(ERROR_MESSAGE ( ) , '')
								  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @TIPOADVERTENCIA, 'REVENUE', @errormsg, 1
								  SET @errormsg = '-20060 Maximo numero de advertencias alcanzado: ' + isnull(@errormsg, '')
								  RAISERROR(@errormsg, 16, 1);
								  RETURN 0;
								END CATCH
							END;
							-- Calcular (Emular) Comision POS Estandar
							  --DECLARE @cpsvcodeTIPOCOMISION   NUMERIC(22,0);
							  SET @cpsvcalcVALORPORCENTUA = 0;
							  SET @cpsvcalcVALORTRANSCCNL = 0;
							BEGIN
							  -- Obtain Values. Mathematical operation goes against transaction values
							  SELECT @cpsvcodeTIPOCOMISION = CODTIPOCOMISION, @cpsvcalcVALORPORCENTUA = VALORPORCENTUAL, @cpsvcalcVALORTRANSCCNL = VALORTRANSACCIONAL FROM WSXML_SFG.RANGOCOMISION
							  INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
							  WHERE ID_RANGOCOMISION = @xCODRANGOCOMISIONESTANDAR;
							  
							  SET @rowcount = @@ROWCOUNT
							  IF @rowcount > 1
								SET @tmpvCOMISIONPOSESTANDAR = 0;
								
							  IF @rowcount = 0 BEGIN
								SET @errormsg = '-20080 No existe comision estandar configurada para el producto ' + ISNULL(WSXML_SFG.PRODUCTO_CODIGO_F(@xCODPRODUCTO), '') + '. No se puede continuar'
								RAISERROR(@errormsg, 16, 1);
								RETURN 0
							  END
							  
							  IF @cpsvcodeTIPOCOMISION IN (1, 2, 3) BEGIN
								IF @cpsvcodeTIPOCOMISION = 1 BEGIN    -- Porcentual
								  SET @tmpvCOMISIONPOSESTANDAR = (@cpsvcalcVALORPORCENTUA * @treference__VALORTRANSACCION) / 100;
								END
								ELSE IF @cpsvcodeTIPOCOMISION = 2 BEGIN -- Transaccional
								  SET @tmpvCOMISIONPOSESTANDAR = @cpsvcalcVALORTRANSCCNL * (1);
								END
								ELSE IF @cpsvcodeTIPOCOMISION = 3 BEGIN -- Mixto
								  SET @tmpvCOMISIONPOSESTANDAR = ((@cpsvcalcVALORPORCENTUA * @treference__VALORTRANSACCION) / 100) + (@cpsvcalcVALORTRANSCCNL * (1));
								END 
							  END
							  ELSE BEGIN
								SET @tmpvCOMISIONPOSESTANDAR = 0;
							  END 
							  
							  
							
							  
							END;
							SET @nCOMISIONPOSESTANDAR = @nCOMISIONPOSESTANDAR + @tmpvCOMISIONPOSESTANDAR;
							-- Forcefully calculate reference level. Mathematical operation goes against transaction (reference) values
							IF @xCODTIPOCOMISION IN (1, 2, 3) BEGIN
								SET @cvalcalcVALORPORCENTUA = 0;
								SET @cvalcalcVALORTRANSCCNL = 0;
							  BEGIN
								SELECT @tmpvCODRANGOCOMISIONDETALLE = ID_RANGOCOMISIONDETALLE, @cvalcalcVALORPORCENTUA = VALORPORCENTUAL, @cvalcalcVALORTRANSCCNL = VALORTRANSACCIONAL
								FROM WSXML_SFG.RANGOCOMISIONDETALLE WHERE CODRANGOCOMISION = @xCODRANGOCOMISION;
								IF @xCODTIPOCOMISION = 1 BEGIN    -- Porcentual
								  SET @tmpvREVENUE = (@cvalcalcVALORPORCENTUA * @treference__VALORTRANSACCION) / 100;
								END
								ELSE IF @xCODTIPOCOMISION = 2 BEGIN -- Transaccional
								  SET @tmpvREVENUE = @cvalcalcVALORTRANSCCNL * (1);
								END
								ELSE IF @xCODTIPOCOMISION = 3 BEGIN -- Mixto
								  SET @tmpvREVENUE = ((@cvalcalcVALORPORCENTUA * @treference__VALORTRANSACCION) / 100) + (@cvalcalcVALORTRANSCCNL * (1));
								END 
							  END;
							END
							ELSE IF @xCODTIPOCOMISION IN (4, 5, 6)
							  BEGIN
								BEGIN
								  DECLARE tCommission CURSOR FOR SELECT ID_RANGOCOMISIONDETALLE, RANGOINICIAL, RANGOFINAL, VALORPORCENTUAL, VALORTRANSACCIONAL FROM WSXML_SFG.RANGOCOMISIONDETALLE
													  WHERE CODRANGOCOMISION = @xCODRANGOCOMISION ORDER BY RANGOINICIAL; OPEN tCommission;
								 DECLARE @tCommission__ID_RANGOCOMISIONDETALLE NUMERIC(38,0), @tCommission__RANGOINICIAL FLOAT, @tCommission__RANGOFINAL FLOAT, @tCommission__VALORPORCENTUAL FLOAT, @tCommission__VALORTRANSACCIONAL FLOAT
									
								 FETCH NEXT FROM tCommission INTO @tCommission__ID_RANGOCOMISIONDETALLE, @tCommission__RANGOINICIAL, @tCommission__RANGOFINAL, @tCommission__VALORPORCENTUAL, @tCommission__VALORTRANSACCIONAL;
								 WHILE @@FETCH_STATUS=0
								 BEGIN
									IF @treference__VALORTRANSACCION >= @tCommission__RANGOINICIAL AND (@treference__VALORTRANSACCION <= @tCommission__RANGOFINAL OR @tCommission__RANGOFINAL IS NULL) BEGIN
									  IF @xCODTIPOCOMISION = 4 BEGIN    -- Rangos Porcentual
										SET @tmpvREVENUE = (@tCommission__VALORPORCENTUAL * @treference__VALORTRANSACCION) / 100;
									  END
									  ELSE IF @xCODTIPOCOMISION = 5 BEGIN -- Rangos Transaccional
										SET @tmpvREVENUE = @tCommission__VALORTRANSACCIONAL * (1);
									  END
									  ELSE IF @xCODTIPOCOMISION = 6 BEGIN -- Rangos Mixto
										SET @tmpvREVENUE = ((@tCommission__VALORPORCENTUAL * @treference__VALORTRANSACCION) / 100) + (@tCommission__VALORTRANSACCIONAL * (1));
									  END 
									  SET @tmpvCODRANGOCOMISIONDETALLE = @tCommission__ID_RANGOCOMISIONDETALLE;
									  BREAK;
									END 
									FETCH NEXT FROM tCommission INTO @tCommission__ID_RANGOCOMISIONDETALLE, @tCommission__RANGOINICIAL, @tCommission__RANGOFINAL, @tCommission__VALORPORCENTUAL, @tCommission__VALORTRANSACCIONAL;
								  END;
								  CLOSE tCommission;
								  DEALLOCATE tCommission;
								END;
							  END;
							END 
							SET @nREVENUE = @nREVENUE + @tmpvREVENUE;
						  
						  FETCH NEXT FROM treference INTO @treference__ID_REGISTROFACTREFERENCIA, @treference__FECHA, @treference__VALORTRANSACCION, @treference__CODREGISTROANULADO;
						END;
						 CLOSE treference;
						 DEALLOCATE treference;
					  END;
					ELSE BEGIN
                  -- Verificar si se encontro comision (tarifa) diferencial
                  BEGIN
					BEGIN TRY
						IF @xCODRANGOCOMISIONDIFAGR <> 0 BEGIN
						  SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, @xCODTIPOCOMISION = CODTIPOCOMISION, @xCODTIPORANGO = CODTIPORANGO
						  FROM WSXML_SFG.RANGOCOMISION WHERE ID_RANGOCOMISION = @xCODRANGOCOMISIONDIFAGR;
						END
						ELSE IF @xCODRANGOCOMISIONDIFRED <> 0 BEGIN
						  SELECT @xCODRANGOCOMISION = ID_RANGOCOMISION, @xCODTIPOCOMISION = CODTIPOCOMISION, @xCODTIPORANGO = CODTIPORANGO
						  FROM WSXML_SFG.RANGOCOMISION WHERE ID_RANGOCOMISION = @xCODRANGOCOMISIONDIFRED;
						END 
					END TRY
					BEGIN CATCH
						SET @errormsg = 'No se pudo obtener valores para tarifa diferencial: Se prosigue con tarifa normal. ' + isnull(ERROR_MESSAGE ( ) , '');
						EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @TIPOADVERTENCIA, 'REVENUE', @errormsg, 1
						SET @errormsg = '-20060 Maximo numero de advertencias alcanzado: ' + isnull(ERROR_MESSAGE ( ) , '')
						RAISERROR(@errormsg, 16, 1);
						RETURN 0;
					END CATCH
                  END;
                  -- Calcular (Emular) Comision POS Estandar
                    --DECLARE @cpsvcodeTIPOCOMISION   NUMERIC(22,0);
                    SET @cpsvcalcVALORPORCENTUA = 0;
                    SET @cpsvcalcVALORTRANSCCNL = 0;
                  BEGIN
                    -- Obtain Values
                    SELECT @cpsvcodeTIPOCOMISION = CODTIPOCOMISION, @cpsvcalcVALORPORCENTUA = VALORPORCENTUAL, @cpsvcalcVALORTRANSCCNL = VALORTRANSACCIONAL
                    FROM WSXML_SFG.RANGOCOMISION INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
                    WHERE ID_RANGOCOMISION = @xCODRANGOCOMISIONESTANDAR;
					
					SET @rowcount = @@ROWCOUNT;
					
					IF @rowcount > 1 
						SET @nCOMISIONPOSESTANDAR = 0;
					
					IF @rowcount = 0 BEGIN
						SET @errormsg = '-20080 No existe comision estandar configurada para el producto ' + ISNULL(WSXML_SFG.PRODUCTO_CODIGO_F(@xCODPRODUCTO), '') + '. No se puede continuar'
						RAISERROR(@errormsg, 16, 1);
						RETURN 0;
					END
                    -- Emular
                    IF @cpsvcodeTIPOCOMISION IN (1, 2, 3) BEGIN
                      IF @cpsvcodeTIPOCOMISION = 1 BEGIN    -- Porcentual
                        SET @nCOMISIONPOSESTANDAR = (@cpsvcalcVALORPORCENTUA * @xTOTALVENTASBRUTAS) / 100;
                      END
                      ELSE IF @cpsvcodeTIPOCOMISION = 2 BEGIN -- Transaccional
                        SET @nCOMISIONPOSESTANDAR = @cpsvcalcVALORTRANSCCNL * @xNUMTRANSACCIONES;
                      END
                      ELSE IF @cpsvcodeTIPOCOMISION = 3 BEGIN -- Mixto
                        SET @nCOMISIONPOSESTANDAR = ((@cpsvcalcVALORPORCENTUA * @xTOTALVENTASBRUTAS) / 100) + (@cpsvcalcVALORTRANSCCNL * @xNUMTRANSACCIONES);
                      END 
                    END
                    ELSE BEGIN
                      SET @nCOMISIONPOSESTANDAR = 0;
                    END 
					
					
                  
                    
                  END;
                  -- A partir de este punto se tiene las reglas correctas:
                  IF @xCODTIPOCOMISION IN (1, 2, 3) BEGIN
                      SET @cvalcalcVALORPORCENTUA = 0;
                      SET @cvalcalcVALORTRANSCCNL = 0;
                    BEGIN
                      SELECT @cvalcalcVALORPORCENTUA = VALORPORCENTUAL, @cvalcalcVALORTRANSCCNL = VALORTRANSACCIONAL
                      FROM WSXML_SFG.RANGOCOMISIONDETALLE WHERE CODRANGOCOMISION = @xCODRANGOCOMISION;
                      IF @xCODTIPOCOMISION = 1 BEGIN    -- Porcentual
                        SET @nREVENUE = (@cvalcalcVALORPORCENTUA * @xTOTALVENTASBRUTAS) / 100;
                      END
                      ELSE IF @xCODTIPOCOMISION = 2 BEGIN -- Transaccional
                        SET @nREVENUE = @cvalcalcVALORTRANSCCNL * @xNUMTRANSACCIONES;
                      END
                      ELSE IF @xCODTIPOCOMISION = 3 BEGIN -- Mixto
                        SET @nREVENUE = ((@cvalcalcVALORPORCENTUA * @xTOTALVENTASBRUTAS) / 100) + (@cvalcalcVALORTRANSCCNL * @xNUMTRANSACCIONES);
                      END 
                    END;
                  END
                  ELSE IF @xCODTIPOCOMISION IN (4, 5, 6) BEGIN
                      DECLARE @lstTRANSACCIONES WSXML_SFG.TRANSACCIONVALOR;
                    BEGIN
					  INSERT @lstTRANSACCIONES
                      SELECT ID_REGISTROFACTREFERENCIA, VALORTRANSACCION
                      FROM WSXML_SFG.REGISTROFACTREFERENCIA WHERE CODREGISTROFACTURACION = @originREGISTROFACTURACION AND ANULADO = 0;
                      IF @@ROWCOUNT > 0 BEGIN
                        DECLARE itx CURSOR FOR SELECT ID_REGISTROFACTREFERENCIA, VALORTRANSACCION FROM @lstTRANSACCIONES--.First..lstTRANSACCIONES.Last LOOP
						OPEN itx
						DECLARE @itx__ID_REGISTROFACTREFERENCIA NUMERIC(38,0), @itx__VALORTRANSACCION FLOAT
						FETCH NEXT FROM itx INTO @itx__ID_REGISTROFACTREFERENCIA, @itx__VALORTRANSACCION
						WHILE (@@FETCH_STATUS = 0)
						BEGIN
                            DECLARE @vtxREVENUE FLOAT = 0;
                          BEGIN
                            DECLARE tCommissionDetail CURSOR FOR SELECT ID_RANGOCOMISIONDETALLE, RANGOINICIAL, RANGOFINAL, VALORPORCENTUAL, VALORTRANSACCIONAL FROM WSXML_SFG.RANGOCOMISIONDETALLE
                                                      WHERE CODRANGOCOMISION = @xCODRANGOCOMISION ORDER BY RANGOINICIAL; OPEN tCommissionDetail;
							 
							DECLARE  @tCommissionDetail__ID_RANGOCOMISIONDETALLE NUMERIC(38,0), @tCommissionDetail__RANGOINICIAL FLOAT, @tCommissionDetail__RANGOFINAL FLOAT, @tCommissionDetail__VALORPORCENTUAL FLOAT, @tCommissionDetail__VALORTRANSACCIONAL FLOAT
							FETCH NEXT FROM tCommissionDetail INTO @tCommissionDetail__ID_RANGOCOMISIONDETALLE, @tCommissionDetail__RANGOINICIAL, @tCommissionDetail__RANGOFINAL, @tCommissionDetail__VALORPORCENTUAL, @tCommissionDetail__VALORTRANSACCIONAL;
							WHILE @@FETCH_STATUS=0
							BEGIN
                              IF @itx__VALORTRANSACCION >= @tCommissionDetail__RANGOINICIAL AND (@itx__VALORTRANSACCION <= @tCommissionDetail__RANGOFINAL OR @tCommissionDetail__RANGOFINAL IS NULL) BEGIN
                                IF @xCODTIPOCOMISION = 4 BEGIN    -- Rangos Porcentual
                                  SET @vtxREVENUE = (@tCommissionDetail__VALORPORCENTUAL * @itx__VALORTRANSACCION) / 100;
                                END
                                ELSE IF @xCODTIPOCOMISION = 5 BEGIN -- Rangos Transaccional
                                  SET @vtxREVENUE = @tCommissionDetail__VALORTRANSACCIONAL * (1);
                                END
                                ELSE IF @xCODTIPOCOMISION = 6 BEGIN -- Rangos Mixto
                                  SET @vtxREVENUE = ((@tCommissionDetail__VALORPORCENTUAL * @itx__VALORTRANSACCION / 100) + (@tCommissionDetail__VALORTRANSACCIONAL * (1)));
                                END 
                                BREAK;
							  END
                              FETCH NEXT FROM tCommissionDetail INTO @tCommissionDetail__ID_RANGOCOMISIONDETALLE, @tCommissionDetail__RANGOINICIAL, @tCommissionDetail__RANGOFINAL, @tCommissionDetail__VALORPORCENTUAL, @tCommissionDetail__VALORTRANSACCIONAL;
                            END
                            CLOSE tCommissionDetail;
                            DEALLOCATE tCommissionDetail;
							
                            --END WHILE 1=1 BEGIN;
                            SET @nREVENUE = @nREVENUE + @vtxREVENUE;
                          END;
						  FETCH NEXT FROM itx INTO @itx__ID_REGISTROFACTREFERENCIA, @itx__VALORTRANSACCION
                        --END WHILE 1=1 BEGIN;
						END
						CLOSE itx;
						DEALLOCATE itx;
					
                      END
                    END;
                  
                  END
				END
				END
				--END
                -- Concatenar calculo del fijo a la variable nueva
                DECLARE @vtotalfijo FLOAT = 0;
                BEGIN
                  SELECT @vtotalfijo = ISNULL(SUM(REVENUE), 0) FROM WSXML_SFG.REGISTROREVENUEINCENTIVO WHERE CODREGISTROREVENUE = @originREGISTROREVENUE;
                  IF @vtotalfijo <> 0 BEGIN
                    SET @nREVENUE = @nREVENUE + @vtotalfijo;
                  END 
                END;
                
				-- Obtener valores actuales y restar (FECHA ORIGEN)
                EXEC WSXML_SFG.SFGREGISTROREVENUE_GetCalculatedRevenueValues @originREGISTROFACTURACION, @xNUMTRANSACCIONES OUT, @xVALORTRANSACCION OUT, @xTOTALVENTASBRUTAS OUT, @xVALORINGRESOPDV OUT, @xVALORIVAINGRESOPDV OUT, @xREVENUE OUT, @xCOMISIONPOSESTANDAR OUT, @xCODCOMPANIA OUT, @xCODSERVICIO OUT, @xCODTIPOCONTRATOPDV OUT, @xCODTIPOCONTRATOPRODUCTO OUT, @xCODPUNTODEVENTA OUT, @xCODPRODUCTO OUT, @xCODREDPDV OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODCIUDAD OUT, @originREGISTROREVENUE OUT, @originPRODUCTOREVENUE OUT
                SET @difCOMISIONPOSESTANDAR = @nCOMISIONPOSESTANDAR - @xCOMISIONPOSESTANDAR; -- El diferencial es igual al nuevo valor calculado menos el valor calculado originalmente
                SET @difREVENUE             = (@nREVENUE + @p_VALORAJUSTE) - @xREVENUE;       -- El diferencial es igual al nuevo valor calculado menos el valor calculado originalmente

                -- Solo ingresar ajuste si existe diferencia o si han cambiado las reglas del punto (para recalcular PYG)
                IF @difCOMISIONPOSESTANDAR <> 0 OR @difREVENUE <> 0 OR @p_CODTIPOAJUSTEREVENUE IN (2, 3) BEGIN
                  BEGIN
                  -- Buscar registro mediante llave unica
                  SELECT @destinREGISTROFACTURACION = ID_REGISTROFACTURACION FROM WSXML_SFG.REGISTROFACTURACION
                  WHERE CODENTRADAARCHIVOCONTROL = @newENTRADAARCHIVOCONTROL
                    AND CODPUNTODEVENTA          = @xCODPUNTODEVENTA
                    AND CODPRODUCTO              = @xCODPRODUCTO
                    AND CODTIPOREGISTRO          = @xCODTIPOREGISTRO;
                  IF @@ROWCOUNT = 0 BEGIN -- Crear registro ficticio, junto con el registro de revenue
                      -- Mostly dummy values
                      DECLARE @xCODRANGOCOMISIONFACTURACN NUMERIC(22,0);
                      DECLARE @xCODTIPOCOMISIONFACTURACN  NUMERIC(22,0);
                      DECLARE @xCOMISIONANTICIPOFACTURACN NUMERIC(22,0);
                      DECLARE @xVALCALCPORCENTUAFACTURACN NUMERIC(22,0);
                      DECLARE @xVALCALCTRANSCCNLFACTURACN NUMERIC(22,0);
                      DECLARE @xPLANTILLAFACTURACN        NUMERIC(22,0);
                      DECLARE @xCODREGIMEN                NUMERIC(22,0);
                      DECLARE @xIDENTIFICACION            NUMERIC(22,0);
                      DECLARE @xDIGITOVERIFICACION        NUMERIC(22,0);
                      --DECLARE @xCODCIUDAD                 NUMERIC(22,0);
                      DECLARE @xCODALIADOESTRATEGICO      NUMERIC(22,0);
                      DECLARE @xCODRAZONSOCIAL            NUMERIC(22,0);
                      DECLARE @xFLAGADVANCEDCOMMISSION    NUMERIC(22,0);
                    
					  DECLARE @l_FECHAINGRESOAJUSTE DATETIME= CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINGRESOAJUSTE))
                      EXEC WSXML_SFG.SFGPRODUCTOREVENUE_FindProductEntry @l_FECHAINGRESOAJUSTE, @xCODPRODUCTO, @destinPRODUCTOREVENUE OUT
                      EXEC WSXML_SFG.SFGPUNTODEVENTA_ObtainBillingRules @xCODPUNTODEVENTA, @xCODPRODUCTO, @xCODREGIMEN OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODREDPDV OUT, @xIDENTIFICACION OUT, @xDIGITOVERIFICACION OUT, @xCODCIUDAD OUT, @xCODCOMPANIA OUT, @xCODALIADOESTRATEGICO OUT, @xCODTIPOCONTRATOPDV OUT, @xCODRAZONSOCIAL OUT, @xCODTIPOCONTRATOPRODUCTO OUT
                      -- Advanced commission does not become necessary. Just the general markup
                      EXEC WSXML_SFG.SFGPLANTILLAPRODUCTO_GetPinpointComissionValues @xCODPUNTODEVENTA, @xCODPRODUCTO, @xCODRANGOCOMISIONFACTURACN OUT, @xCODTIPOCOMISIONFACTURACN OUT, @xCOMISIONANTICIPOFACTURACN OUT, @xVALCALCPORCENTUAFACTURACN OUT, @xVALCALCTRANSCCNLFACTURACN OUT, @xPLANTILLAFACTURACN OUT, @xFLAGADVANCEDCOMMISSION OUT
                      EXEC WSXML_SFG.SFGREGISTROFACTURACION_AddRecord @newENTRADAARCHIVOCONTROL, @xCODPUNTODEVENTA, @xCODPRODUCTO, @xCODTIPOREGISTRO, 0, @p_FECHAINGRESOAJUSTE, 0, @xCODRANGOCOMISIONFACTURACN, @xCOMISIONANTICIPOFACTURACN, 0, 0, @xCODCOMPANIA, @xCODREGIMEN, @xCODAGRUPACIONPUNTODEVENTA, @xCODREDPDV, @xIDENTIFICACION, @xDIGITOVERIFICACION, @xCODCIUDAD, @xCODTIPOCONTRATOPDV, @xCODRAZONSOCIAL, @xCODTIPOCONTRATOPRODUCTO, @p_CODUSUARIOMODIFICACION, @destinREGISTROFACTURACION OUT
                      EXEC WSXML_SFG.SFGREGISTROREVENUE_AddEmptyRecord @newENTRADAARCHIVOCONTROL, @destinREGISTROFACTURACION, @xCODTIPOREGISTRO, @l_FECHAINGRESOAJUSTE, @xCODPUNTODEVENTA, @xCODTIPOCONTRATOPDV, @xCODPRODUCTO, @xCODTIPOCONTRATOPRODUCTO, @xCODCOMPANIA, @xCODRANGOCOMISION, @destinPRODUCTOREVENUE, 0, @destinREGISTROREVENUE OUT
                    END;
			      END;
                  -- Obtain Ingresos y Egresos, Corporativo y Local, del registro que se esta modificando
                  EXEC WSXML_SFG.SFGREGISTROREVENUE_GetCalculatedRevenueValues @destinREGISTROFACTURACION, @xNUMTRANSACCIONES OUT, @xVALORTRANSACCION OUT, @xTOTALVENTASBRUTAS OUT, @xVALORINGRESOPDV OUT, @xVALORIVAINGRESOPDV OUT, @xREVENUE OUT, @xCOMISIONPOSESTANDAR OUT, @xCODCOMPANIA OUT, @xCODSERVICIO OUT, @xCODTIPOCONTRATOPDV OUT, @xCODTIPOCONTRATOPRODUCTO OUT, @xCODPUNTODEVENTA OUT, @xCODPRODUCTO OUT, @xCODREDPDV OUT, @xCODAGRUPACIONPUNTODEVENTA OUT, @xCODCIUDAD OUT, @destinREGISTROREVENUE OUT, @destinPRODUCTOREVENUE OUT

                  -- Sumar el revenue actualmente calculado para considerar los valores completos para el P&G
                  SET @nCOMISIONPOSESTANDAR = @difCOMISIONPOSESTANDAR + @xCOMISIONPOSESTANDAR; -- El diferencial + el ya calculado en el registro destino
                  SET @nREVENUE             = @difREVENUE             + @xREVENUE;             -- El diferencial + el ya calculado en el registro destino

                  -- Configuracion P&G para calcular ingresos y egresos
                  DECLARE @xCONFIGURACIONINGRESOCORP  NUMERIC(22,0) = 0;
                  DECLARE @xCONFIGURACIONEGRESOCORP   NUMERIC(22,0) = 0;
                  DECLARE @xCONFIGURACIONINGRESOLOCAL NUMERIC(22,0) = 0;
                  DECLARE @xCONFIGURACIONEGRESOLOCAL  NUMERIC(22,0) = 0;
					
				  BEGIN
                    BEGIN
						BEGIN TRY
						  EXEC WSXML_SFG.SFGCONFIGURACIONPYG_GetConfiguracionRegistro @cacheconfigpyg, @xCODSERVICIO, @xCODTIPOCONTRATOPRODUCTO, @xCODTIPOCONTRATOPDV, @xCONFIGURACIONINGRESOCORP OUT, @xCONFIGURACIONEGRESOCORP OUT, @xCONFIGURACIONINGRESOLOCAL OUT, @xCONFIGURACIONEGRESOLOCAL OUT
						END TRY
						BEGIN CATCH
						  SELECT NULL;
						END CATCH
                    END;
                    
					-- Calcular en nuevas variables. Se calcula con base en el total del nuevo revenue para que se desprenda la diferencia si existe
					-- Falta un parametro descuentos se agrego un cero al final
                    SET @nINGRESOCORPORATIVO = WSXML_SFG.SFGCONFIGURACIONPYG_TranslateFigure(@xCONFIGURACIONINGRESOCORP , @xCODTIPOCONTRATOPDV, @xNUMTRANSACCIONES, @xVALORTRANSACCION, @xVALORINGRESOPDV, @xVALORIVAINGRESOPDV, @nREVENUE, @nCOMISIONPOSESTANDAR, @nINGRESOCORPORATIVO, @nEGRESOCORPORATIVO, @nINGRESOLOCAL, @nEGRESOLOCAL,0,0);
                    SET @nEGRESOCORPORATIVO  = WSXML_SFG.SFGCONFIGURACIONPYG_TranslateFigure(@xCONFIGURACIONEGRESOCORP  , @xCODTIPOCONTRATOPDV, @xNUMTRANSACCIONES, @xVALORTRANSACCION, @xVALORINGRESOPDV, @xVALORIVAINGRESOPDV, @nREVENUE, @nCOMISIONPOSESTANDAR, @nINGRESOCORPORATIVO, @nEGRESOCORPORATIVO, @nINGRESOLOCAL, @nEGRESOLOCAL,0,0);
                    SET @nINGRESOLOCAL       = WSXML_SFG.SFGCONFIGURACIONPYG_TranslateFigure(@xCONFIGURACIONINGRESOLOCAL, @xCODTIPOCONTRATOPDV, @xNUMTRANSACCIONES, @xVALORTRANSACCION, @xVALORINGRESOPDV, @xVALORIVAINGRESOPDV, @nREVENUE, @nCOMISIONPOSESTANDAR, @nINGRESOCORPORATIVO, @nEGRESOCORPORATIVO, @nINGRESOLOCAL, @nEGRESOLOCAL,0,0);
                    SET @nEGRESOLOCAL        = WSXML_SFG.SFGCONFIGURACIONPYG_TranslateFigure(@xCONFIGURACIONEGRESOLOCAL , @xCODTIPOCONTRATOPDV, @xNUMTRANSACCIONES, @xVALORTRANSACCION, @xVALORINGRESOPDV, @xVALORIVAINGRESOPDV, @nREVENUE, @nCOMISIONPOSESTANDAR, @nINGRESOCORPORATIVO, @nEGRESOCORPORATIVO, @nINGRESOLOCAL, @nEGRESOLOCAL,0,0);
                    -- Obtener valores actuales
                    EXEC WSXML_SFG.SFGREGISTROREVENUE_GetCalculatedPyGValues @destinREGISTROREVENUE, @xINGRESOCORPORATIVO OUT, @xEGRESOCORPORATIVO OUT, @xINGRESOLOCAL OUT , @xEGRESOLOCAL OUT
                    SET @difINGRESOCORPORATIVO = @nINGRESOCORPORATIVO - @xINGRESOCORPORATIVO;
                    SET @difEGRESOCORPORATIVO  = @nEGRESOCORPORATIVO  - @xEGRESOCORPORATIVO;
                    SET @difINGRESOLOCAL       = @nINGRESOLOCAL       - @xINGRESOLOCAL;
                    SET @difEGRESOLOCAL        = @nEGRESOLOCAL        - @xEGRESOLOCAL;
                  END;

                  -- Ingresar ajuste y actualizar valores de padre
                  EXEC WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentRecord @p_DESCRIPCION, @p_CODTIPOAJUSTEREVENUE, @p_VALORAJUSTE, @originARCHIVOCONTROL, @originREGISTROFACTURACION, @originREGISTROREVENUE, @newENTRADAARCHIVOCONTROL, @destinREGISTROFACTURACION, @destinREGISTROREVENUE, @difREVENUE, @difINGRESOCORPORATIVO, @difEGRESOCORPORATIVO, @difINGRESOLOCAL, @difEGRESOLOCAL, @difCOMISIONPOSESTANDAR, @p_CODUSUARIOMODIFICACION, @p_ID_AJUSTEREVENUE_out OUT
                  EXEC WSXML_SFG.SFGREGISTROREVENUE_UpdateRevenueFromAdjustment @destinREGISTROREVENUE, @difREVENUE, @difCOMISIONPOSESTANDAR, @difINGRESOCORPORATIVO, @difEGRESOCORPORATIVO, @difINGRESOLOCAL, @difEGRESOLOCAL
                  EXEC WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductEntry @destinPRODUCTOREVENUE, @difREVENUE
                  EXEC WSXML_SFG.SFGPRODUCTOREVENUE_UpdateProductPyG @destinPRODUCTOREVENUE, @difINGRESOCORPORATIVO, @difEGRESOCORPORATIVO, @difINGRESOLOCAL, @difEGRESOLOCAL

                  -- Costos Calculados
                  DECLARE @costCODPRODUCTOCONTRATO       NUMERIC(22,0);
                  DECLARE @costCODPRODUCTOCONTRATOCOMDIF NUMERIC(22,0);
                  DECLARE @currentcalculatedcosts        WSXML_SFG.IDVALUE;
                  BEGIN
                   -- SET @currentcalculatedcosts = IDVALUELIST();
                    -- Obtener identificadores padres y diferenciales para el producto
                    EXEC WSXML_SFG.SFGPRODUCTOCONTRATO_GetTarifasProductoMaster @xCODPRODUCTO, @xCODREDPDV, @xCODAGRUPACIONPUNTODEVENTA, @xCODCIUDAD, @costCODPRODUCTOCONTRATO OUT, @costCODPRODUCTOCONTRATOCOMDIF OUT
                    -- Calcular todos los costos asociados
                    -- OJO: Si hay que totalizar, desactivar algunos de resta
                    DECLARE icst CURSOR FOR SELECT ID, DESCONTABLE, DEFINITION FROM @costoscalculados--.First..costoscalculados.Last LOOP
					OPEN icst
					
					DECLARE @icst__ID NUMERIC(38,0), @icst__DESCONTABLE NUMERIC(38,0), @icst__DEFINITION VARCHAR(MAX)
					FETCH NEXT FROM icst INTO @icst__ID, @icst__DESCONTABLE, @icst__DEFINITION
					
					WHILE (@@FETCH_STATUS = 0)
					BEGIN
                        DECLARE @cout         NUMERIC(22,0);
                        DECLARE @idcosto      NUMERIC(22,0) = @icst__ID
                        DECLARE @oldcostvalue FLOAT = 0;
                        DECLARE @newcostvalue FLOAT = 0;
                        DECLARE @difcostvalue FLOAT = 0;
						DECLARE @definition VARCHAR(MAX) = @icst__DEFINITION
						
						DECLARE @formulacalculations WSXML_SFG.OPERATIONCALC

						INSERT INTO @formulacalculations
						SELECT  CONVERT(NUMERIC,dbo.SEPARAR_COLUMNAS_F(VALUE,1,';')) AS CODTIPOVALOR,
							CONVERT(FLOAT,dbo.SEPARAR_COLUMNAS_F(VALUE,2,';')) AS VALOR,
							CONVERT(VARCHAR,dbo.SEPARAR_COLUMNAS_F(VALUE,3,';')) AS OPERADOR
						FROM STRING_SPLIT(@definition,'|')
					  
						BEGIN
                        DECLARE iclc CURSOR FOR SELECT CODTIPOVALOR, VALOR, OPERADOR  FROM @formulacalculations--.First..formulacalculations.Last LOOP
						
						OPEN iclc
						DECLARE @iclc__CODTIPOVALOR NUMERIC(38,0), @iclc__VALOR FLOAT, @iclc__OPERADOR VARCHAR(1)
						
						FETCH NEXT FROM iclc INTO @iclc__CODTIPOVALOR, @iclc__VALOR, @iclc__OPERADOR;
						WHILE (@@FETCH_STATUS = 0)
						BEGIN
                            DECLARE @operador VARCHAR(1) = @iclc__OPERADOR
                            DECLARE @tipovalr NUMERIC(38,0) = @iclc__CODTIPOVALOR
                            DECLARE @valor    FLOAT  = @iclc__VALOR
                            DECLARE @actualv  FLOAT  = 0;
                          BEGIN
								BEGIN TRY
									-- Actual value depends on type
									IF @tipovalr = @VALORUSUARIO BEGIN
									  SET @actualv = @valor;
									END
									ELSE IF @tipovalr = @VALORFIGURAP BEGIN
										-- Se agrego un cero al final, porque faltaba un parametro
									  SET @actualv = WSXML_SFG.SFGCONFIGURACIONPYG_TranslateFigure(@valor, @xCODTIPOCONTRATOPDV, @xNUMTRANSACCIONES, @xVALORTRANSACCION, @xVALORINGRESOPDV, @xVALORIVAINGRESOPDV, @nREVENUE, @nCOMISIONPOSESTANDAR, @nINGRESOCORPORATIVO, @nEGRESOCORPORATIVO, @nINGRESOLOCAL, @nEGRESOLOCAL,0,0);
									END
									ELSE IF @tipovalr = @VALORTARIFAV BEGIN
										-- se quito el parametro @cachetarifa,  porque el procedimiento lo tiene comentariado
									  SET @actualv = WSXML_SFG.SFGPRODUCTOCONTRATO_TranslateTarifaFromMaster(@cachetarifadif, @costCODPRODUCTOCONTRATO, @costCODPRODUCTOCONTRATOCOMDIF, @valor, @getTarifaCacheList);
									END
									ELSE IF @tipovalr = @VALORCOSTOPV BEGIN
									  IF (SELECT COUNT(*) FROM @currentcalculatedcosts) > 0 BEGIN
										DECLARE ccpv CURSOR FOR SELECT ID, VALUE FROM @currentcalculatedcosts--.First..currentcalculatedcosts.Last LOOP
										OPEN ccpv
										DECLARE @ccpv__ID NUMERIC(38,0), @ccpv__VALUE FLOAT
										FETCH NEXT FROM ccpv INTO @ccpv__ID, @ccpv__VALUE
										WHILE @@FETCH_STATUS=0
										BEGIN
										  IF @ccpv__ID = @valor BEGIN
											SET @actualv = @ccpv__VALUE
											BREAK;
										  END
										  FETCH NEXT FROM ccpv INTO @ccpv__ID, @ccpv__VALUE
										END
										CLOSE ccpv;
										DEALLOCATE ccpv;
									  END
									END
									-- Calculate agains actual value depending on operator
									IF @operador = '+' BEGIN
									  SET @newcostvalue = @newcostvalue + @actualv;
									END
									ELSE IF @operador = '-' BEGIN
									  SET @newcostvalue = @newcostvalue - @actualv;
									END
									ELSE IF @operador = '*' BEGIN
									  SET @newcostvalue = @newcostvalue * @actualv;
									END
									ELSE IF @operador = '/' BEGIN
									  SET @newcostvalue = @newcostvalue / @actualv;
									END
									ELSE BEGIN
									  SET @newcostvalue = @actualv;
									END 
								END TRY
								BEGIN CATCH
									RAISERROR('-20054 No se pueden calcular las formulas de costos a partir de las configuraciones', 16, 1);
									RETURN 0;
								END  CATCH
                          END 
						  FETCH NEXT FROM iclc INTO @iclc__CODTIPOVALOR, @iclc__VALOR, @iclc__OPERADOR;
						END
						CLOSE iclc;
						DEALLOCATE iclc;
                        
                        -- At the end, save value in database and add to array for future consulting
                        --currentcalculatedcosts.Extend(1);
                        INSERT INTO @currentcalculatedcosts VALUES(@idcosto, @newcostvalue);
                        -- Compare against current cost
                        EXEC WSXML_SFG.SFGREGISTROREVCOSTOCALCULADO_GetRecordValue  @destinREGISTROREVENUE, @idcosto, @oldcostvalue OUT
                        SET @difcostvalue = @newcostvalue - @oldcostvalue;
                        IF @difcostvalue <> 0 BEGIN
                          EXEC WSXML_SFG.SFGREGISTROREVCOSTOCALCULADO_AddReplaceRecord @destinREGISTROREVENUE, @idcosto, @newcostvalue, @cout OUT
                          EXEC WSXML_SFG.SFGAJUSTEREVENUE_AddAdjustmentCostRecord @destinREGISTROREVENUE, @cout, @p_ID_AJUSTEREVENUE_out, @idcosto, @difcostvalue OUT
                        END 
                      END;
                    
						FETCH NEXT FROM icst INTO @icst__ID, @icst__DESCONTABLE, @icst__DEFINITION
					END;
					CLOSE icst;
					DEALLOCATE icst;
                
                  END
                END;
              --END --WHILE 1=1 BEGIN;
				
				FETCH NEXT FROM irecord INTO @irecord__IDVALUE
			END
			CLOSE irecord
			DEALLOCATE irecord
			
		  END
        END;
		FETCH NEXT FROM ifile INTO @ifile__IDVALUE
	  END
	  CLOSE ifile
	  DEALLOCATE ifile
    
	END 
    ELSE BEGIN
      SET @p_ID_AJUSTEREVENUE_out = 0;
    END
END;
GO