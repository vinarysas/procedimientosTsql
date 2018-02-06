USE SFGPRODU;
--  DDL for Package Body SFGMAESTROFACTURACIONDIFERIDOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS */ 

  -- Procedimiento para seleccionar los diferidos para PreFacturacion por ciclos
 IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ObtenerDiferidosCiclo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ObtenerDiferidosCiclo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ObtenerDiferidosCiclo AS
 BEGIN
    DECLARE @p_CODCICLO                 NUMERIC(22,0);
    DECLARE @msg                        VARCHAR(2000);
    DECLARE @V_CODENTRADAARCHIVOCONTROL NUMERIC(22,0);
    DECLARE @V_FECHA_ARCHIVO_VENTAS     datetime;
   
  SET NOCOUNT ON;

    SELECT @p_CODCICLO = MAX(C.SECUENCIA) + 1
      FROM WSXML_SFG.CICLOFACTURACIONPDV C
     WHERE C.ACTIVE = 1
       AND C.FLAGPROCESO = 0;

    if isnull(@p_CODCICLO, 0) > 0 BEGIN

      SELECT @V_CODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL, @V_FECHA_ARCHIVO_VENTAS = FECHAARCHIVO
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
       WHERE ID_ENTRADAARCHIVOCONTROL =
             (SELECT MAX(T.ID_ENTRADAARCHIVOCONTROL)
                FROM WSXML_SFG.ENTRADAARCHIVOCONTROL T
               WHERE T.TIPOARCHIVO = 1
                 AND T.REVERSADO = 0
                 AND T.ACTIVE = 1
                 AND T.FACTURADO = 0
                 AND T.ARCHIVOFACTURABLE = 1
                 AND T.CODCICLOFACTURACIONPDV IS NULL);

      DECLARE CICLO_ACTUAL CURSOR FOR SELECT CODPVTA,
                                  SECUENCIAAFACTURAR,
                                  VALORCUOTA,
                                  ID_PLANDEPAGOS,
                                  ID_PRODUCTO,
                                  ID_REGLADIFERIDOINSTALACION,
                                  CANTIDAD,
                                  NOMBREPRODUCTO
                             FROM WSXML_SFG.VW_DIFERIDOS_CICLOSQL; OPEN CICLO_ACTUAL;

		DECLARE @CICLO_ACTUAL__CODPVTA CHAR(10), @CICLO_ACTUAL__SECUENCIAAFACTURAR NUMERIC(38,0), 
			@CICLO_ACTUAL__VALORCUOTA FLOAT, @CICLO_ACTUAL__ID_PLANDEPAGOS  NUMERIC(38,0),
            @CICLO_ACTUAL__ID_PRODUCTO  NUMERIC(38,0), @CICLO_ACTUAL__ID_REGLADIFERIDOINSTALACION  NUMERIC(38,0), 
			@CICLO_ACTUAL__CANTIDAD  CHAR(10), @CICLO_ACTUAL__NOMBREPRODUCTO NVARCHAR(255)

		FETCH NEXT FROM CICLO_ACTUAL INTO @CICLO_ACTUAL__CODPVTA, @CICLO_ACTUAL__SECUENCIAAFACTURAR, @CICLO_ACTUAL__VALORCUOTA, @CICLO_ACTUAL__ID_PLANDEPAGOS,
                @CICLO_ACTUAL__ID_PRODUCTO, @CICLO_ACTUAL__ID_REGLADIFERIDOINSTALACION, @CICLO_ACTUAL__CANTIDAD, @CICLO_ACTUAL__NOMBREPRODUCTO;
		WHILE @@FETCH_STATUS=0
		BEGIN
        BEGIN
			BEGIN TRY
				  IF CONVERT(NUMERIC,@CICLO_ACTUAL__SECUENCIAAFACTURAR) = @p_CODCICLO BEGIN
					INSERT INTO WSXML_SFG.ENTRADADIFERIDOS
					  (
					   PVTA,
					   CODCICLOFACTURACIONPDV,
					   VALOR,
					   CODPLANDEPAGO,
					   CODIGOGTECHPRODUCTO,
					   FECHA_Y_HORA,
					   COUNTRANSACCIONES,
					   CODENTRADAARCHIVOCONTROL,
					   NOMBREPRODUCTO)
					VALUES
					  (
					   RTRIM(LTRIM(@CICLO_ACTUAL__CODPVTA)),
					   CONVERT(NUMERIC,@p_CODCICLO),
					   CONVERT(NUMERIC,@CICLO_ACTUAL__VALORCUOTA),
					   CONVERT(NUMERIC,@CICLO_ACTUAL__ID_PLANDEPAGOS),
					   @CICLO_ACTUAL__ID_PRODUCTO,
					   GETDATE(),
					   CONVERT(NUMERIC,@CICLO_ACTUAL__CANTIDAD),
					   @V_CODENTRADAARCHIVOCONTROL,
					   @CICLO_ACTUAL__NOMBREPRODUCTO);

					   SET @CICLO_ACTUAL__CANTIDAD = CONVERT(NUMERIC,@CICLO_ACTUAL__CANTIDAD)
					   SET @CICLO_ACTUAL__VALORCUOTA = CONVERT(NUMERIC,@CICLO_ACTUAL__VALORCUOTA)
					   
					   EXEC WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosEntradaArchivCtrl 
												   @V_CODENTRADAARCHIVOCONTROL,
												   @CICLO_ACTUAL__CANTIDAD,
												   @CICLO_ACTUAL__VALORCUOTA

				  END 

			END TRY
			BEGIN CATCH
					SET @msg = ERROR_MESSAGE ( ) ;
					EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg
					SET @msg = '-20088 Error al obtener registros de diferidos para el ciclo: ' + isnull(ERROR_MESSAGE ( ) , '')
					RAISERROR(@msg, 16, 1);
			END CATCH
        END;
      FETCH NEXT FROM CICLO_ACTUAL INTO @CICLO_ACTUAL__CODPVTA, @CICLO_ACTUAL__SECUENCIAAFACTURAR, @CICLO_ACTUAL__VALORCUOTA, @CICLO_ACTUAL__ID_PLANDEPAGOS,
                @CICLO_ACTUAL__ID_PRODUCTO, @CICLO_ACTUAL__ID_REGLADIFERIDOINSTALACION, @CICLO_ACTUAL__CANTIDAD, @CICLO_ACTUAL__NOMBREPRODUCTO;
      END;
      CLOSE CICLO_ACTUAL;
      DEALLOCATE CICLO_ACTUAL;

      EXEC WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_InsercionDifPrefacturacion @p_CODCICLO, 
                                 @V_CODENTRADAARCHIVOCONTROL,
                                 @V_FECHA_ARCHIVO_VENTAS

      COMMIT;
    END 
  END
GO

  -- Procedimiento para marcar en SQL los registros de Diferidos prefacturados
  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_InsercionDifPrefacturacion(@P_CODCICLO                 NUMERIC(22,0),
                                       @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                       @p_FECHA_ARCHIVO_VENTAS     DATETIME) as
 begin

    declare @V_FECHA_ARCHIVO_VENTAS VARCHAR(100) = FORMAT(@p_FECHA_ARCHIVO_VENTAS,'yyyy-MM-dd HH:mm:ss');
    declare @szSQLInstruction       VARCHAR(MAX);
    declare @msg                    VARCHAR(2000);
    declare @RESULT                 DECIMAL(8, 2);

   
  SET NOCOUNT ON;
	BEGIN TRY
		/*szSQLInstruction := 'UPDATE PLANDEPAGOS SET CodEstadoPago = 5, CODENTRADAARCHIVOCONTROL = ' ||
							p_CODENTRADAARCHIVOCONTROL ||
							', FECHA_ARCHIVO_VENTAS = ''' ||
							V_FECHA_ARCHIVO_VENTAS ||
							'''  WHERE SecuenciaAFacturar = ' || P_CODCICLO ||
							' AND CODENTRADAARCHIVOCONTROL IS NULL';*/


		--RESULT := DBMS_HS_PASSTHROUGH.EXECUTE_IMMEDIATE@DIFERIDOS(szSQLInstruction);
    
		set @RESULT = 0;

		IF @RESULT > 0 BEGIN
			SET @msg = '-20086 Error al intentar actualizar la tabla [Diferidos].[dbo].[PlanDePagos] de SQLServer durante la prefacturacion. ' +
								  ISNULL(@RESULT, '')
		  RAISERROR(@msg, 16, 1);
		END 
	END TRY
	BEGIN CATCH
		  SET @msg = ERROR_MESSAGE ( ) ;
		  EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg
		  SET @msg = '-20087 Error al intentar actualizar la tabla [Diferidos].[dbo].[PlanDePagos] de SQLServer durante la prefacturacion. ' + isnull(ERROR_MESSAGE ( ), '') 
		  RAISERROR(@msg, 16, 1);
	END CATCH
  END
GO


IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosEntradaArchivCtrl', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosEntradaArchivCtrl;
GO
  -- Procedimiento para actualizar la canntidad de transacciones y el valor en la EntradaArchivoControl
  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosEntradaArchivCtrl(@pk_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                           @p_NUMTRANSACCIONES          NUMERIC(22,0),
                                           @p_VALORTRANSACCION          FLOAT) AS
 BEGIN
   SET NOCOUNT ON;
   DECLARE @msg VARCHAR(2000);
   
   BEGIN TRY
		-- Servicios comerciales: Anulaciones suman al archivo de Control
		UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL
		   SET NUMEROTRANSACCIONES = NUMEROTRANSACCIONES + @p_NUMTRANSACCIONES,
			   VALORTRANSACCIONES  = VALORTRANSACCIONES + @p_VALORTRANSACCION
		 WHERE ID_ENTRADAARCHIVOCONTROL = @pk_ID_ENTRADAARCHIVOCONTROL;
	END TRY
	BEGIN CATCH
      
		SET @msg = ERROR_MESSAGE ( )
		EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg
		SET @msg = '-20086 Error al intentar actualizar la tabla ENTRADAARCHIVOCONTROL  durante la prefacturacion de Diferidos. ' + isnull(ERROR_MESSAGE ( ) , '');
		RAISERROR(@msg, 16, 1);
	END CATCH

  END
GO

IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ReprocessOrphansDefered', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ReprocessOrphansDefered;
GO

CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ReprocessOrphansDefered(@p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                    @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0),
                                    @p_RETVALUE_out             NUMERIC(22,0) OUT) AS
 BEGIN

    DECLARE @cTOTALREGISTROS NUMERIC(22,0) = 0;
    DECLARE @orphanENTRIES   WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @cCOUNTWARNINGS  NUMERIC(22,0) = 0;
    DECLARE @cMODLREGISTROS  NUMERIC(22,0) = 0;
    DECLARE @cWAITREGISTROS  NUMERIC(22,0) = 5;
    DECLARE @cCOUNTREGISTROS NUMERIC(22,0) = 0;

	DECLARE @REGISTRADA      			TINYINT,
		@INICIADA         		TINYINT,
		@FINALIZADAOK 			TINYINT,
		@FINALIZADAFALLO  		TINYINT,
		@ABORTADA  				TINYINT,
		@NOINICIADA  				TINYINT,
		@FINALIZADAADVERTENCIA  	TINYINT
		 
	EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT
					@REGISTRADA		OUT,
                    @INICIADA			OUT,
                    @FINALIZADAOK		OUT,
                    @FINALIZADAFALLO  OUT,
					@ABORTADA  		OUT,
					@NOINICIADA  		OUT,
					@FINALIZADAADVERTENCIA  OUT   
  SET NOCOUNT ON;
    -- Establecer totalrecords de la tarea
    SELECT @cTOTALREGISTROS = COUNT(1)
      FROM WSXML_SFG.HUERFANOSDIFERIDOS
     WHERE CODENTRADAARCHIVOCONTROL = CASE
             WHEN @p_CODENTRADAARCHIVOCONTROL = -1 THEN
              CODENTRADAARCHIVOCONTROL
             ELSE
              @p_CODENTRADAARCHIVOCONTROL
           END;

    EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_CODDETALLETAREAEJECUTADA,@cTOTALREGISTROS

	INSERT INTO @orphanENTRIES
    SELECT ID_HUERFANODIFERIDOS
    FROM WSXML_SFG.HUERFANOSDIFERIDOS
     WHERE CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL;

    IF @@ROWCOUNT > 0 BEGIN
      DECLARE orphan CURSOR FOR SELECT IDVALUE FROM @orphanENTRIES--.First .. orphanENTRIES.Last 
	  OPEN orphan;

	  DECLARE @orphan__IDVALUE NUMERIC(38,0)

	 FETCH NEXT FROM orphan INTO @orphan__IDVALUE;
	 WHILE @@FETCH_STATUS=0
	 BEGIN
          DECLARE @orphID                       NUMERIC(22,0) = @orphan__IDVALUE
          DECLARE @orphPVTA                     VARCHAR(6);
          DECLARE @orphCODCICLOFACTURACIONPDV   NUMERIC(22,0);
          DECLARE @orphVALOR                    NUMERIC(22,0);
          DECLARE @orphCODPLANDEPAGO            NUMERIC(22,0);
          DECLARE @orphCODIGOGTECHPRODUCTO      VARCHAR(50);
          DECLARE @orphFECHA_Y_HORA             DATETIME;
          DECLARE @orphCOUNTRANSACCIONES        NUMERIC(22,0);
          DECLARE @orphCODENTRADAARCHIVOCONTROL NUMERIC(22,0);
          DECLARE @orphNOMBREPRODUCTO           VARCHAR(255);
        BEGIN

          -- Obtener datos
          SELECT @orphPVTA = convert(varchar, PVTA),
                 @orphCODCICLOFACTURACIONPDV = CODCICLOFACTURACIONPDV,
                 @orphVALOR = VALOR,
                 @orphCODPLANDEPAGO = CODPLANDEPAGO,
                 @orphCODIGOGTECHPRODUCTO = CODIGOGTECHPRODUCTO,
                 @orphFECHA_Y_HORA = FECHA_Y_HORA,
                 @orphCOUNTRANSACCIONES = COUNTRANSACCIONES,
                 @orphCODENTRADAARCHIVOCONTROL = CODENTRADAARCHIVOCONTROL,
                 @orphNOMBREPRODUCTO = NOMBREPRODUCTO
                       FROM WSXML_SFG.HUERFANOSDIFERIDOS
           WHERE ID_HUERFANODIFERIDOS = @orphID;

          -- Insertar registro de nuevo para emular uso de trigger
          INSERT INTO WSXML_SFG.ENTRADADIFERIDOS
            (
             PVTA,
             CODCICLOFACTURACIONPDV,
             VALOR,
             CODPLANDEPAGO,
             CODIGOGTECHPRODUCTO,
             FECHA_Y_HORA,
             COUNTRANSACCIONES,
             CODENTRADAARCHIVOCONTROL,
             NOMBREPRODUCTO)
          VALUES
            (
             @orphPVTA,
             @orphCODCICLOFACTURACIONPDV,
             @orphVALOR,
             @orphCODPLANDEPAGO,
             @orphCODIGOGTECHPRODUCTO,
             @orphFECHA_Y_HORA,
             @orphCOUNTRANSACCIONES,
             @orphCODENTRADAARCHIVOCONTROL,
             @orphNOMBREPRODUCTO);

          -- Eliminar huerfano
          DELETE FROM WSXML_SFG.HUERFANOSDIFERIDOS
           WHERE ID_HUERFANODIFERIDOS = @orphID;
          COMMIT;

          -- Actualizar la tarea
          SET @cMODLREGISTROS = @cMODLREGISTROS + 1;
          IF @cMODLREGISTROS = @cWAITREGISTROS BEGIN
            SET @cCOUNTREGISTROS = @cCOUNTREGISTROS + @cMODLREGISTROS;
            
			EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_CODDETALLETAREAEJECUTADA, @cCOUNTREGISTROS
            SET @cMODLREGISTROS = 0;
            COMMIT;
          END 
        END;
      FETCH NEXT FROM orphan INTO @orphan__IDVALUE;
      END;
      CLOSE orphan;
      DEALLOCATE orphan;
    END 

    -- Contar los que siguen huerfanos
    SELECT @cCOUNTWARNINGS = COUNT(1)
      FROM WSXML_SFG.HUERFANOSDIFERIDOS
     WHERE CODENTRADAARCHIVOCONTROL = CASE WHEN @p_CODENTRADAARCHIVOCONTROL = -1 THEN CODENTRADAARCHIVOCONTROL ELSE @p_CODENTRADAARCHIVOCONTROL END;

    -- Contar el numero de warnings
    IF @cCOUNTWARNINGS > 0 BEGIN
      SET @p_RETVALUE_out = @FINALIZADAADVERTENCIA;
    END
    ELSE BEGIN
      SET @p_RETVALUE_out = @FINALIZADAOK;
    END 

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosCicloFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosCicloFacturacion;
GO


  -- Procedimiento actualizacion Final SQL - Diferidos
  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONDIFERIDOS_ActuDiferidosCicloFacturacion(@P_CODCICLO               NUMERIC(22,0),
                                          @P_SECUENCIACICLO         NUMERIC(22,0),
                                          @p_FECHA_CICLOFACTURACION DATETIME) AS
 BEGIN

	SET NOCOUNT ON;
    DECLARE @V_FECHA_CICLOFACTURACION VARCHAR(100);
    DECLARE @szSQLInstruction         VARCHAR(MAX);
    DECLARE @msg                      VARCHAR(2000);
    DECLARE @RESULT                   DECIMAL(8, 2);

    SET @V_FECHA_CICLOFACTURACION = FORMAT(@p_FECHA_CICLOFACTURACION, 'yyyy-MM-dd HH:mm:ss');
    BEGIN
		BEGIN TRY
			  SET @szSQLInstruction = 'UPDATE PLANDEPAGOS SET CodEstadoPago = 3, CODCICLOFACTURACIONPDV = ' +
								  ISNULL(CONVERT(NUMERIC,@P_CODCICLO), '') +
								  ', FECHA_CICLO_FACTURACIONPDV = ''' +
								  ISNULL(@V_FECHA_CICLOFACTURACION, '') +
								  '''  WHERE CODENTRADAARCHIVOCONTROL IS NOT NULL AND SecuenciaAFacturar = ' +
								  ISNULL(CONVERT(DATETIME,@P_SECUENCIACICLO), '');

		--      RESULT := DBMS_HS_PASSTHROUGH.EXECUTE_IMMEDIATE@DIFERIDOS(szSQLInstruction);

			  SET @RESULT = 0;

			  IF @RESULT > 0 BEGIN
				SET @msg = '-20086 Error al intentar actualizar la tabla [Diferidos].[dbo].[PlanDePagos] de SQLServer durante la Facturacion. ' + ISNULL(@RESULT, '') 
				RAISERROR(@msg, 16, 1);
			  END
		END TRY
		BEGIN CATCH 
				SET @msg = ERROR_MESSAGE ( ) ;
				EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg
				SET @msg = '-20087 Error al intentar actualizar la tabla [Diferidos].[dbo].[PlanDePagos] de SQLServer durante la Facturacion. ' + isnull(ERROR_MESSAGE ( ),'') 
				RAISERROR(@msg, 16, 1);
		END CATCH
    END;

 END;
 GO