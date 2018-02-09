USE SFGPRODU;
--  DDL for Package Body SFGMAESTROFACTURACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGMAESTROFACTURACIONPDV */ 

  -- Creates a new record in the MAESTROFACTURACIONPDV table


IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_DescontarComisionATotal', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_DescontarComisionATotal;
GO


  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_DescontarComisionATotal(@p_CODMAESTROFACTURACIONPDV NUMERIC(22,0),
                                    @p_CURRENTTOTALAPAGAR       FLOAT,
                                    @p_VALORCOMISION            FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    -- Reintegrar en facturacion
    UPDATE WSXML_SFG.MAESTROFACTURACIONPDV
       SET NUEVOSALDOENCONTRAGTECH = CASE
                                       WHEN @p_CURRENTTOTALAPAGAR -
                                            @p_VALORCOMISION >= 0 THEN
                                        @p_CURRENTTOTALAPAGAR -
                                        @p_VALORCOMISION
                                       ELSE
                                        0
                                     END,
           NUEVOSALDOAFAVORGTECH = CASE
                                     WHEN @p_CURRENTTOTALAPAGAR -
                                          @p_VALORCOMISION < 0 THEN
                                      ABS(@p_CURRENTTOTALAPAGAR -
                                          @p_VALORCOMISION)
                                     ELSE
                                      0
                                   END
     WHERE ID_MAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV;
    -- Reintegrar en saldos
    UPDATE WSXML_SFG.DETALLESALDOPDV
       SET SALDOCONTRAGTECH = CASE
                                WHEN @p_CURRENTTOTALAPAGAR - @p_VALORCOMISION >= 0 THEN
                                 @p_CURRENTTOTALAPAGAR - @p_VALORCOMISION
                                ELSE
                                 0
                              END,
           SALDOAFAVORGTECH = CASE
                                WHEN @p_CURRENTTOTALAPAGAR - @p_VALORCOMISION < 0 THEN
                                 ABS(@p_CURRENTTOTALAPAGAR - @p_VALORCOMISION)
                                ELSE
                                 0
                              END
     WHERE CODMAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReintegrarComisionATotal', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReintegrarComisionATotal;
GO

CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReintegrarComisionATotal(@p_CODMAESTROFACTURACIONPDV    NUMERIC(22,0),
                                     @p_CURRENTTOTALAPAGAR          FLOAT,
                                     @p_VALORCOMISION               FLOAT,
                                     @p_CODLINEADENEGOCIODESCONTADA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Reintegrar en facturacion
    UPDATE WSXML_SFG.MAESTROFACTURACIONPDV
       SET NUEVOSALDOENCONTRAGTECH = CASE
                                       WHEN @p_CURRENTTOTALAPAGAR +
                                            @p_VALORCOMISION >= 0 THEN
                                        @p_CURRENTTOTALAPAGAR +
                                        @p_VALORCOMISION
                                       ELSE
                                        0
                                     END,
           NUEVOSALDOAFAVORGTECH = CASE
                                     WHEN @p_CURRENTTOTALAPAGAR +
                                          @p_VALORCOMISION < 0 THEN
                                      ABS(@p_CURRENTTOTALAPAGAR +
                                          @p_VALORCOMISION)
                                     ELSE
                                      0
                                   END,
           -- Si estoy reintegrando una comision es porque la desconte de otro
           CODLINEADENEGOCIODESCUENTO = @p_CODLINEADENEGOCIODESCONTADA
     WHERE ID_MAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV;
    -- Reintegrar en saldos
    UPDATE WSXML_SFG.DETALLESALDOPDV
       SET SALDOCONTRAGTECH = CASE
                                WHEN @p_CURRENTTOTALAPAGAR + @p_VALORCOMISION >= 0 THEN
                                 @p_CURRENTTOTALAPAGAR + @p_VALORCOMISION
                                ELSE
                                 0
                              END,
           SALDOAFAVORGTECH = CASE
                                WHEN @p_CURRENTTOTALAPAGAR + @p_VALORCOMISION < 0 THEN
                                 ABS(@p_CURRENTTOTALAPAGAR + @p_VALORCOMISION)
                                ELSE
                                 0
                              END
     WHERE CODMAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarEmptyPOSLDN', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarEmptyPOSLDN;
GO


  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarEmptyPOSLDN(@cCODCICLOFACTURACION           NUMERIC(22,0),
                                @cCODMAESTROFACTURATIRILLA      NUMERIC(22,0),
                                @xCODPUNTODEVENTA               NUMERIC(22,0),
                                @cCODTIPOAGRUPACION             NUMERIC(22,0),
                                @cCODAGRUPACIONPUNTODEVENTA     NUMERIC(22,0),
                                @xCODLINEADENEGOCIO             NUMERIC(22,0),
                                @cTODAY                         DATETIME,
                                @cCODUSUARIOMODIFICACION        NUMERIC(22,0),
                                @p_CODMAESTROFACTURACIONPDV_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCODCOMPROBANTECONSIGNACION NUMERIC(22,0);
    DECLARE @cCODMAESTROFACTURACIONPDV   NUMERIC(22,0);
    DECLARE @msg                         NVARCHAR(2000);
   
  SET NOCOUNT ON;
    /**** DATOS NECESARIOS PARA REALIZAR LA FACTURACION *******************************/
    EXEC SFGMAESTROFACTURACIONCOMPCONSI_GenerateBillingTicketData @cCODCICLOFACTURACION,
                                                             @xCODPUNTODEVENTA,
                                                             @cCODTIPOAGRUPACION,
                                                             @cCODAGRUPACIONPUNTODEVENTA,
                                                             @xCODLINEADENEGOCIO,
                                                             @cTODAY,
                                                             @cCODUSUARIOMODIFICACION,
                                                             @cCODCOMPROBANTECONSIGNACION OUT

    /**** GENERACION DEL MAESTRO DE FACTURACION ***************************************/
    BEGIN
		BEGIN TRY
			EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_AddRecord @cCODCICLOFACTURACION,
                                         @cCODMAESTROFACTURATIRILLA,
                                         @cCODCOMPROBANTECONSIGNACION,
                                         @xCODLINEADENEGOCIO,
                                         @xCODPUNTODEVENTA,
                                         @cCODUSUARIOMODIFICACION,
                                         @cCODMAESTROFACTURACIONPDV OUT
										 
		END TRY
		BEGIN CATCH		
			SET @msg = '-20054 Error al crear el registro de facturacion de linea de negocio: ' + isnull(ERROR_MESSAGE ( ), '');
			RAISERROR(@msg, 16, 1);
			RETURN 0;
		END CATCH
    END;

    COMMIT;

    IF @cCODMAESTROFACTURACIONPDV > 0 BEGIN
      /**** REGISTROS DE FACTURACION PARA LA PAREJA PUNTODEVENTA LINEADENEGOCIO *********/
        DECLARE @xSUMHEADERVALORAPAGARGTECH   FLOAT = 0;
        DECLARE @xSUMHEADERVALORAPAGARFIDUCIA FLOAT = 0;
        DECLARE @xSUMHEADERTOTALCOMISION      FLOAT = 0;
      BEGIN
        -- Consolidar valores de cabecera
          DECLARE @cMAESTROANTERENCONTRAGTECH   FLOAT = 0;
          DECLARE @cMAESTROANTERENCONTRAFIDUCIA FLOAT = 0;
          DECLARE @cMAESTROANTERAFAVORGTECH     FLOAT = 0;
          DECLARE @cMAESTROANTERAFAVORFIDUCIA   FLOAT = 0;

          DECLARE @thisHEADERBILLINGGTECH   FLOAT = 0;
          DECLARE @thisHEADERBILLINGFIDUCIA FLOAT = 0;

          DECLARE @cMAESTRONUEVOENCONTRAGTECH   FLOAT;
          DECLARE @cMAESTRONUEVOENCONTRAFIDUCIA FLOAT;
          DECLARE @cMAESTRONUEVOAFAVORGTECH     FLOAT;
          DECLARE @cMAESTRONUEVOAFAVORFIDUCIA   FLOAT;

          DECLARE @coutDETALLESALDOPDV NUMERIC(22,0);
        BEGIN
          -- Obtener saldos actuales (previos a cCODMAESTROFACTURACIONPDV para efectos de recalculo)
          EXEC WSXML_SFG.SFGDETALLESALDOPDV_GetPreviousValuesFromBilling
														@cCODMAESTROFACTURACIONPDV,
                                                        @xCODPUNTODEVENTA,
                                                        @xCODLINEADENEGOCIO,
                                                        @cMAESTROANTERENCONTRAGTECH OUT,
                                                        @cMAESTROANTERENCONTRAFIDUCIA OUT,
                                                        @cMAESTROANTERAFAVORGTECH OUT,
                                                        @cMAESTROANTERAFAVORFIDUCIA OUT

          -- Agregar facturacion actual
          SET @thisHEADERBILLINGGTECH   = (@cMAESTROANTERENCONTRAGTECH -
                                      @cMAESTROANTERAFAVORGTECH) +
                                      @xSUMHEADERVALORAPAGARGTECH;
          SET @thisHEADERBILLINGFIDUCIA = (@cMAESTROANTERENCONTRAFIDUCIA -
                                      @cMAESTROANTERAFAVORFIDUCIA) +
                                      @xSUMHEADERVALORAPAGARFIDUCIA;

          IF @thisHEADERBILLINGGTECH > 0 BEGIN
            -- Positive Billing
            SET @cMAESTRONUEVOENCONTRAGTECH = ABS(@thisHEADERBILLINGGTECH);
            SET @cMAESTRONUEVOAFAVORGTECH   = 0;
          END
          ELSE BEGIN
            SET @cMAESTRONUEVOENCONTRAGTECH = 0;
            SET @cMAESTRONUEVOAFAVORGTECH   = ABS(@thisHEADERBILLINGGTECH);
          END 

          IF @thisHEADERBILLINGFIDUCIA > 0 BEGIN
            -- Positive Billing
            SET @cMAESTRONUEVOENCONTRAFIDUCIA = ABS(@thisHEADERBILLINGFIDUCIA);
            SET @cMAESTRONUEVOAFAVORFIDUCIA   = 0;
          END
          ELSE BEGIN
            SET @cMAESTRONUEVOENCONTRAFIDUCIA = 0;
            SET @cMAESTRONUEVOAFAVORFIDUCIA   = ABS(@thisHEADERBILLINGFIDUCIA);
          END 

          EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_ActualizarValoresPago @cCODMAESTROFACTURACIONPDV,
                                                         @cMAESTROANTERENCONTRAGTECH,
                                                         @cMAESTROANTERENCONTRAFIDUCIA,
                                                         @cMAESTROANTERAFAVORGTECH,
                                                         @cMAESTROANTERAFAVORFIDUCIA,
                                                         @cMAESTRONUEVOENCONTRAGTECH,
                                                         @cMAESTRONUEVOENCONTRAFIDUCIA,
                                                         @cMAESTRONUEVOAFAVORGTECH,
                                                         @cMAESTRONUEVOAFAVORFIDUCIA,
                                                         @xSUMHEADERTOTALCOMISION,
                                                         @cCODUSUARIOMODIFICACION

          -- Actualizar datos de saldo
          EXEC WSXML_SFG.SFGDETALLESALDOPDV_SetSaldoActualPDV @xCODPUNTODEVENTA,
                                               @xCODLINEADENEGOCIO,
                                               @cMAESTRONUEVOAFAVORGTECH,
                                               @cMAESTRONUEVOAFAVORFIDUCIA,
                                               @cMAESTRONUEVOENCONTRAGTECH,
                                               @cMAESTRONUEVOENCONTRAFIDUCIA,
                                               @cCODMAESTROFACTURACIONPDV,
                                               @cCODUSUARIOMODIFICACION,
                                               @coutDETALLESALDOPDV OUT
        END;

      END;

      SET @p_CODMAESTROFACTURACIONPDV_out = @cCODMAESTROFACTURACIONPDV;
    END
    ELSE BEGIN
      RAISERROR('-20054 Error al crear el registro de facturacion de linea de negocio.', 16, 1);
    END 
  END;
GO




IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_VerificarFacturacionAhora', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONPDV_VerificarFacturacionAhora;
GO


  CREATE FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONPDV_VerificarFacturacionAhora(@p_CODPERIODICIDAD        NUMERIC(22,0),
                                     @p_FECHA                  DATETIME,
                                     @p_TODAY                  DATETIME,
                                     @p_CODPUNTODEVENTA        NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                     @p_CODUSUARIOMODIFICACION NUMERIC(22,0))
    RETURNS VARCHAR(4000) AS
 BEGIN
    DECLARE @cPERIODOFUNCTION VARCHAR(MAX);
    DECLARE @cFECHAAHORA      DATETIME;
    DECLARE @cFECHAPRIOD      DATETIME;
    DECLARE @TRUE             VARCHAR(10) = 'TRUE';
    DECLARE @FALSE            VARCHAR(10) = 'FALSE';
    DECLARE @msg              VARCHAR(255);

	 DECLARE @cFECHARESLT DATETIME = @cFECHAAHORA;
          DECLARE @tmpFECHARES VARCHAR(255);
          DECLARE @cRETURN     VARCHAR(10) = @FALSE;
   
    IF @p_CODPERIODICIDAD BETWEEN 20 AND 30 BEGIN
      RETURN(@TRUE);
    END
    ELSE BEGIN
      SELECT @cPERIODOFUNCTION = FUNCION
        FROM WSXML_SFG.PERIORICIDAD
       WHERE ID_PERIORICIDAD = @p_CODPERIODICIDAD;
      SET @cFECHAAHORA = CONVERT(DATETIME, CONVERT(DATE,@p_TODAY));
      SET @cFECHAPRIOD = CONVERT(DATETIME, CONVERT(DATE,@p_FECHA));
      IF @cFECHAAHORA > @cFECHAPRIOD BEGIN
        -- Sumar a cFECHAPRIOD 1 periodo hasta llegar

        BEGIN
          WHILE @cFECHARESLT <= @cFECHAAHORA BEGIN
            EXECUTE sp_executesql @cPERIODOFUNCTION, N'@tmpFECHARES output, @cFECHARESLT, @1', @tmpFECHARES OUTPUT, @cFECHARESLT, 1;
            SELECT @cFECHARESLT = CONVERT(DATETIME, CONVERT(DATE,@tmpFECHARES))

            SET @cFECHARESLT = CONVERT(DATETIME, CONVERT(DATE,@cFECHARESLT));
            IF @cFECHARESLT = @cFECHAAHORA BEGIN
              SET @cRETURN = @TRUE;
            END 
          END;

          RETURN @cRETURN;
        END;

      END
      ELSE IF @cFECHAAHORA < @cFECHAPRIOD BEGIN
        -- Sumar a cFECHAAHORA 1 periodo hasta llegar

        BEGIN
          WHILE @cFECHARESLT <= @cFECHAPRIOD BEGIN
            EXECUTE sp_executesql @cPERIODOFUNCTION, N'@tmpFECHARES output, @cFECHARESLT, @1', @tmpFECHARES OUTPUT , @cFECHARESLT, 1;
            SELECT @cFECHARESLT = CONVERT(DATETIME,CONVERT(DATE,@tmpFECHARES))
             ;
            SET @cFECHARESLT = CONVERT(DATETIME, CONVERT(DATE,@cFECHARESLT));
            IF @cFECHARESLT = @cFECHAPRIOD BEGIN
              SET @cRETURN = @TRUE;
            END 
          END;

          RETURN @cRETURN;
        END;

      END
      ELSE IF @cFECHAAHORA = @cFECHAPRIOD BEGIN
        RETURN(@TRUE);
      END 
    END 
    RETURN(@FALSE);
		/*
	  EXCEPTION
		WHEN OTHERS THEN
		  SET @msg = SQLERRM;
		  IF @p_CODPUNTODEVENTA <= 0 AND @p_CODLINEADENEGOCIO <= 0 BEGIN
			SET @msg = 'No se pudo verificar si es una fecha valida para facturacion : ' + isnull(@msg, '');
		  END
		  ELSE BEGIN
			SET @msg = 'No se pudo verificar el periodo de facturacion de ' +
				   ISNULL(LINEADENEGOCIO_NOMBRE_F(@p_CODLINEADENEGOCIO), '') +
				   ' para el punto de venta ' +
				   ISNULL(PUNTODEVENTA_CODIGO_F(@p_CODPUNTODEVENTA), '') + ': ' + isnull(@msg, '');
		  END 
		  SFGALERTA.GenerarAlerta(SFGALERTA.TIPOERROR,
								  'FACTURACION',
								  @msg,
								  @p_CODUSUARIOMODIFICACION);
		  RETURN(@FALSE);
		*/
  END;
GO




IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_UpdateRecord;
GO



CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_UpdateRecord(@pk_ID_MAESTROFACTURACIONPDV    NUMERIC(22,0),
                         @p_CODCICLOFACTURACIONPDV       NUMERIC(22,0),
                         @p_CODMAESTROFACTURACIONCOMPCO2 NUMERIC(22,0),
                         @p_CODLINEADENEGOCIO            NUMERIC(22,0),
                         @p_CODPUNTODEVENTA              NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                         @p_ACTIVE                       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.MAESTROFACTURACIONPDV
       SET CODCICLOFACTURACIONPDV         = @p_CODCICLOFACTURACIONPDV,
           CODMAESTROFACTURACIONCOMPCONSI = @p_CODMAESTROFACTURACIONCOMPCO2,
           CODLINEADENEGOCIO              = @p_CODLINEADENEGOCIO,
           CODPUNTODEVENTA                = @p_CODPUNTODEVENTA,
           CODUSUARIOMODIFICACION         = @p_CODUSUARIOMODIFICACION,
           ACTIVE                         = @p_ACTIVE
     WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO




  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_SetFlagNotificacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_SetFlagNotificacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_SetFlagNotificacion(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                @p_FLAGNOTIFICACION       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	BEGIN TRY
		UPDATE WSXML_SFG.CICLOFACTURACIONPDV
		   SET FLAGNOTIFICACION = @p_FLAGNOTIFICACION
		 WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
	END TRY 
    BEGIN CATCH
      SELECT NULL;
	  END CATCH
  END;
GO




  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReversarCicloFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReversarCicloFacturacion;
GO


  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReversarCicloFacturacion(@p_FECHAFACTURACION         DATETIME,
                                     @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0),
                                     @p_RETVALUE_out             NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @msg                     VARCHAR(2000);
    DECLARE @cCODUSUARIOMODIFICACION NUMERIC(22,0) = 1;
    DECLARE @cCODCICLOFACTURACION    NUMERIC(22,0) = 0;
    DECLARE @cSECUENCIAACTUAL        NUMERIC(22,0) = 0;
    DECLARE @totalrecords            NUMERIC(22,0) = 1;
    DECLARE @countrecords            NUMERIC(22,0) = 0;
    DECLARE @waitnrecords            NUMERIC(22,0) = 50;
    DECLARE @lstMasterIDs            WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @countPAGOSVN            NUMERIC(22,0) = 0;
    DECLARE @szSQLInstruction        varchar(4000);
    DECLARE @RESULTADO1               NUMERIC(22,0);
    DECLARE @RESULTADO2               NUMERIC(22,0);
   
  SET NOCOUNT ON;

  BEGIN TRY
    -- Buscar el ciclo de facturacion ejecutado en la fecha
    SELECT @cCODCICLOFACTURACION = ID_CICLOFACTURACIONPDV, @cSECUENCIAACTUAL = SECUENCIA
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAEJECUCION)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFACTURACION))
       AND ACTIVE = 1;

    IF @cCODCICLOFACTURACION > 0 BEGIN
      -- Verificar que no se haya cargado el primer pago a la facturacion
      SELECT @countPAGOSVN = COUNT(1)
        FROM WSXML_SFG.PAGOFACTURACIONPDV
       WHERE CODMAESTROFACTURACIONPDV IN
             (SELECT ID_MAESTROFACTURACIONPDV
                FROM WSXML_SFG.MAESTROFACTURACIONPDV
               WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION);

      IF @countPAGOSVN > 0 BEGIN
        RAISERROR('-20054 No se puede reversar el ciclo porque ya se han aplicado pagos a este', 16, 1);
      END 

      -- Desactivar registros de facturacion
      SELECT @totalrecords = COUNT(1)
        FROM WSXML_SFG.MAESTROFACTURACIONPDV
       INNER JOIN WSXML_SFG.DETALLEFACTURACIONPDV
          ON (CODMAESTROFACTURACIONPDV = ID_MAESTROFACTURACIONPDV)
       WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION;

      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_CODDETALLETAREAEJECUTADA, @totalrecords

	  INSERT INTO @lstMasterIDs
      SELECT ID_MAESTROFACTURACIONPDV 
        FROM WSXML_SFG.MAESTROFACTURACIONPDV
       WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION;

      -- Iterar a traves de los maestros y devolver la facturacion actual
      IF @@ROWCOUNT > 0 BEGIN
        DECLARE ixMaster CURSOR FOR SELECT IDVALUE FROM @lstMasterIDs
			OPEN ixMaster;
			DECLARE @ixMaster__IDVALUE numeric(38,0)
		 FETCH ixMaster INTO @ixMaster__IDVALUE
		 WHILE @@FETCH_STATUS=0
		 BEGIN
            DECLARE @thisMAESTROFACTURACION NUMERIC(22,0) = @ixMaster__IDVALUE;
          BEGIN
            -- Desactivar maestro
            UPDATE WSXML_SFG.MAESTROFACTURACIONPDV
               SET ACTIVE = 0
             WHERE ID_MAESTROFACTURACIONPDV = @thisMAESTROFACTURACION;
            -- Desactivacion del saldo del maestro asegura que el nuevo ciclo toma el saldo previo activo
            UPDATE WSXML_SFG.DETALLESALDOPDV
               SET ACTIVE = 0
             WHERE CODMAESTROFACTURACIONPDV = @thisMAESTROFACTURACION;

              DECLARE @lstDetailIDs LONGNUMBERARRAY;
            BEGIN
				insert INTO @lstDetailIDs
              SELECT ID_DETALLEFACTURACIONPDV
                FROM WSXML_SFG.DETALLEFACTURACIONPDV
               WHERE CODMAESTROFACTURACIONPDV = @thisMAESTROFACTURACION;

              IF @@ROWCOUNT > 0 BEGIN
                DECLARE ixDetail CURSOR FOR SELECT IDVALUE FROM @lstDetailIDs
				OPEN ixDetail;
				DECLARE @ixDetail_IDVALUE numeric(38,0)
				 FETCH ixDetail INTO @ixDetail_IDVALUE;
				 WHILE @@FETCH_STATUS=0
				 BEGIN
                    DECLARE @thisDETALLEFACTURACION NUMERIC(22,0) = @ixDetail_IDVALUE;
                  BEGIN

                    -- Try 1. Eliminacion logica
                    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
                       SET ACTIVE = 0
                     WHERE ID_DETALLEFACTURACIONPDV =
                           @thisDETALLEFACTURACION;
                    -- Eliminar Tributarios
                    --DELETE FROM DETALLEFACTURACIONIMPUESTO WHERE CODDETALLEFACTURACIONPDV = thisDETALLEFACTURACION;
                    --DELETE FROM DETALLEFACTURACIONRETENCION WHERE CODDETALLEFACTURACIONPDV = thisDETALLEFACTURACION;
                    --DELETE FROM DETALLEFACTURACIONRETUVT WHERE CODDETALLEFACTURACIONPDV = thisDETALLEFACTURACION;

                    -- MIDDLE: Permitir nueva facturacion REGISTROFACTURACION
                    UPDATE WSXML_SFG.REGISTROFACTURACION
                       SET FACTURADO = 0, CODDETALLEFACTURACIONPDV = NULL
                     WHERE CODDETALLEFACTURACIONPDV =
                           @thisDETALLEFACTURACION;

                    -- Try 2. Eliminacion Real. Las llaves estan configuradas en cascade y set null
                    --DELETE FROM DETALLEFACTURACIONPDV WHERE ID_DETALLEFACTURACIONPDV = thisDETALLEFACTURACION;

                    SET @countrecords = @countrecords + 1;
                    IF (@countrecords % @waitnrecords) = 0 BEGIN
						EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_CODDETALLETAREAEJECUTADA,@countrecords
                      COMMIT;
                    END 
                  END;

                 FETCH ixDetail INTO @ixDetail_IDVALUE;
                END;

                CLOSE ixDetail;
                DEALLOCATE ixDetail;
              END 
            END;

          END;

        FETCH ixDetail INTO @ixDetail_IDVALUE;
        END;

        CLOSE ixMaster;
        DEALLOCATE ixMaster;
      END 

      -- Establecer facturacion anterior
        DECLARE @prevCODCICLOFACTURACION NUMERIC(22,0);
      BEGIN
        SELECT @prevCODCICLOFACTURACION = ID_CICLOFACTURACIONPDV
          FROM WSXML_SFG.CICLOFACTURACIONPDV
         WHERE SECUENCIA = @cSECUENCIAACTUAL - 1
           AND ACTIVE = 1;
				EXEC WSXML_SFG.SFGFACTURACIONPDV_ReverseFacturActualPDV @prevCODCICLOFACTURACION,@cCODUSUARIOMODIFICACION
		  IF @@ROWCOUNT = 0
			SELECT NULL;
      END;


      -- El ciclo al final
      UPDATE WSXML_SFG.CICLOFACTURACIONPDV
         SET ACTIVE = 0
       WHERE ID_CICLOFACTURACIONPDV = @cCODCICLOFACTURACION;

      -- Permitir facturar los archivos de nuevo
      UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL
         SET FACTURADO = 0, CODCICLOFACTURACIONPDV = NULL
       WHERE FACTURADO = 1
         AND CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION;

      -- Force clean of records.
        DECLARE @lstfiles NUMBERARRAY;
      BEGIN
		INSERT  INTO @lstfiles
        SELECT ID_ENTRADAARCHIVOCONTROL 
          FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
         WHERE REVERSADO = 0
           AND FACTURADO = 0;


        DECLARE ifx CURSOR FOR SELECT IDVALUE FROM @lstfiles
		OPEN ifx;
		DECLARE @ifx__IDVALUE NUMERIC(38,0)
		 FETCH ifx INTO @ifx__IDVALUE;
		 WHILE @@FETCH_STATUS=0
		 BEGIN
          UPDATE WSXML_SFG.REGISTROFACTURACION
             SET FACTURADO = 0, CODDETALLEFACTURACIONPDV = NULL
           WHERE CODENTRADAARCHIVOCONTROL = @ifx__IDVALUE;
          COMMIT;
        FETCH ifx INTO @ifx__IDVALUE;
        END;

        CLOSE ifx;
        DEALLOCATE ifx;
      END;

	  DECLARE 			@p_REGISTRADA     TINYINT ,
                    @p_INICIADA     TINYINT ,
                    @p_FINALIZADAOK TINYINT ,
                    @p_FINALIZADAFALLO TINYINT ,
					@p_ABORTADA  	TINYINT ,
					@p_NOINICIADA  	TINYINT ,
					@p_FINALIZADAADVERTENCIA  	TINYINT 

	  EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT
					@p_REGISTRADA      		 OUT,
                    @p_INICIADA         	 OUT,
                    @p_FINALIZADAOK 		 OUT,
                    @p_FINALIZADAFALLO  	 OUT,
					@p_ABORTADA  			 OUT,
					@p_NOINICIADA  			 OUT,
					@p_FINALIZADAADVERTENCIA  OUT
	
	DECLARE @p_TIPOINFORMATIVO TINYINT,
	@p_TIPOERROR TINYINT,
	@p_TIPOADVERTENCIA TINYINT,
	@p_TIPOCUALQUIERA TINYINT,
	@p_PROCESONOTIFICACION TINYINT,
	@p_ESTADOABIERTA TINYINT,
	@p_ESTADOCERRADA TINYINT

	EXEC WSXML_SFG.SFGALERTA_CONSTANT
	@p_TIPOINFORMATIVO  OUT,
	@p_TIPOERROR  OUT,
	@p_TIPOADVERTENCIA  OUT,
	@p_TIPOCUALQUIERA  OUT,
	@p_PROCESONOTIFICACION  OUT,
	@p_ESTADOABIERTA  OUT,
	@p_ESTADOCERRADA  OUT
      --Liberar process flag
      EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_FreeProcessFlag @cCODCICLOFACTURACION

      SET @p_RETVALUE_out = @p_FINALIZADAOK
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, 'El ciclo de facturacion ha sido reversado exitosamente'
    END 

    SET @szSQLInstruction = 'UPDATE PLANDEPAGOS SET CodEstadoPago = 5, CODCICLOFACTURACIONPDV = NULL, FECHA_CICLO_FACTURACIONPDV = NULL WHERE CODCICLOFACTURACIONPDV = ' +
                        ISNULL(@cCODCICLOFACTURACION, '');

--    RESULTADO1 := DBMS_HS_PASSTHROUGH.EXECUTE_IMMEDIATE@DIFERIDOS(szSQLInstruction);

    SET @RESULTADO1 = 0;


     IF @RESULTADO1 > 0 BEGIN
	  SET @msg = '-20086 Error al intentar actualizar la tabla [Diferidos].[dbo].[PlanDePagos] de SQLServer durante la reversion del ciclo de facturacion. ' +
                              ISNULL(@RESULTADO1, '')
      RAISERROR(@msg, 16, 1);
    END 


    SET @szSQLInstruction = 'UPDATE PLANDEPAGOS SET SecuenciaAFacturar = 0, CODCICLOFACTURACIONPDV = 0 WHERE SecuenciaAFacturar > ' + ISNULL(@cSECUENCIAACTUAL, '') + ' And NumeroCuota > 1 and CodDiferidoInstalacion in (select ID_DiferidoInstalacion from DiferidoInstalacion, ReglaDiferidoInstalacion  where CodReglaDiferidoInstalacion = ID_ReglaDiferidoInstalacion and CodTipoRegla = 1 ) ';

--    RESULTADO2 := DBMS_HS_PASSTHROUGH.EXECUTE_IMMEDIATE@DIFERIDOS(szSQLInstruction);

    SET @RESULTADO2 = 0;

    IF @RESULTADO2 > 0 BEGIN
		set @msg = '-20087 Error al intentar actualizar la tabla [Diferidos].[dbo].[PlanDePagos] de SQLServer durante la reversion del ciclo de facturacion. ' +
                              ISNULL(@RESULTADO2, '')
      RAISERROR(@msg, 16, 1);
    END 

    COMMIT;

	  IF @@ROWCOUNT = 0 BEGIN
		  SET @p_RETVALUE_out = @p_FINALIZADAFALLO;
		  SET @msg            = 'No existe ciclo de facturacion para la fecha ' +
							ISNULL(FORMAT(@p_FECHAFACTURACION, 'dd/MM/yyyy'), '');
		  exec wsxml_sfg.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
		  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'REVERSARCICLOFACTURACION',
								  @msg,
								  @cCODUSUARIOMODIFICACION
		END
    END TRY
	BEGIN CATCH

      SET @p_RETVALUE_out = @p_FINALIZADAFALLO;
      SET @msg            = ERROR_MESSAGE ( ) ;
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA,
                                                 @msg
      EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'REVERSARCICLOFACTURACION', @msg, @cCODUSUARIOMODIFICACION
	END CATCH
  END;
GO




  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_RecalcularValoresFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_RecalcularValoresFacturacion;
GO

  -- No recalcula valores de tirilla. Solamente ventas, comisiones, impuestos y retenciones
  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_RecalcularValoresFacturacion(@p_FECHAFACTURACION         DATETIME,
                                         @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0),
                                         @p_RETVALUE_out             NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCODCICLOFACTURACION    NUMERIC(22,0);
    DECLARE @cTODAY                  DATETIME = @p_FECHAFACTURACION; -- Emula la fecha de facturacion, y es utilizado para efectos de algoritmo de referencia
    DECLARE @cCODUSUARIOMODIFICACION NUMERIC(22,0) = 1;
    DECLARE @cSECUENCIACICLO         NUMERIC(22,0) = 0;
    DECLARE @xLINEACONFIGURACION     WSXML_SFG.IDVALUE;

    DECLARE @cTOTALWARNINGS      NUMERIC(22,0) = 0;
    DECLARE @cTOTALREGISTROS     NUMERIC(22,0) = 0;
    DECLARE @cCOUNTREGISTROS     NUMERIC(22,0) = 0;
    DECLARE @cWAITREGISTROS      NUMERIC(22,0) = 10;
    DECLARE @cMAXWARNINGS        NUMERIC(22,0) = 50; -- Maximo numero de advertencias que puede generar antes de fallar completamente
    DECLARE @cDESCUENTOSCOMISION WSXML_SFG.PDVDESCUENTOS--WSXML_SFG.REDDESCUENTOS;
    DECLARE @msg                 VARCHAR(2000);
	DECLARE @errormsg                 VARCHAR(2000);
   
  SET NOCOUNT ON;

  	DECLARE 	@REGISTRADA      			TINYINT ,
                    @INICIADA         		TINYINT ,
                    @FINALIZADAOK 			TINYINT ,
                    @FINALIZADAFALLO  		TINYINT ,
					@ABORTADA  				TINYINT ,
					@NOINICIADA  				TINYINT ,
					@FINALIZADAADVERTENCIA  	TINYINT 

	EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT   
					@REGISTRADA      			 OUT,
                    @INICIADA         		 OUT,
                    @FINALIZADAOK 			 OUT,
                    @FINALIZADAFALLO  		 OUT,
					@ABORTADA  				 OUT,
					@NOINICIADA  				 OUT,
					@FINALIZADAADVERTENCIA  	 OUT

	
	DECLARE @TIPOINFORMATIVO TINYINT,
		@TIPOERROR TINYINT,
		@TIPOADVERTENCIA TINYINT,
		@TIPOCUALQUIERA TINYINT,
		@PROCESONOTIFICACION TINYINT,
		@ESTADOABIERTA TINYINT,
		@ESTADOCERRADA TINYINT

	EXEC WSXML_SFG.SFGALERTA_CONSTANT
		@TIPOINFORMATIVO  OUT,
		@TIPOERROR  OUT,
		@TIPOADVERTENCIA  OUT,
		@TIPOCUALQUIERA  OUT,
		@PROCESONOTIFICACION  OUT,
		@ESTADOABIERTA  OUT,
		@ESTADOCERRADA  OUT
	
    SELECT @cCODCICLOFACTURACION = ID_CICLOFACTURACIONPDV, @cSECUENCIACICLO = SECUENCIA
      FROM WSXML_SFG.CICLOFACTURACIONPDV
     WHERE ID_CICLOFACTURACIONPDV = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());


    IF WSXML_SFG.SFGCICLOFACTURACIONPDV_ReadProcessFlag() > 0 BEGIN
      RAISERROR('-20090 No se pueden recalcular dos ciclos de facturacion simultaneamente', 16, 1);
    END 
    IF @cCODCICLOFACTURACION > 0 BEGIN
      EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_MarkProcessFlag @cCODCICLOFACTURACION
      
	  INSERT INTO @xLINEACONFIGURACION
	  SELECT ID_LINEADENEGOCIO, LINEAEGRESO
        FROM (SELECT ID_LINEADENEGOCIO, LINEAEGRESO, ROW_NUMBER() OVER(ORDER BY ID_LINEADENEGOCIO) AS RowNumber
                FROM WSXML_SFG.LINEADENEGOCIO) T

      IF @@ROWCOUNT <= 0 BEGIN
        RAISERROR('-20020 No se pudo obtener la configuracion de ingresos y egresos para las lineas de negocio', 16, 1);
      END 
      -- Configuraciones de descuentos de comision
      BEGIN
		
        INSERT INTO @cDESCUENTOSCOMISION 
		SELECT CODPUNTODEVENTA, CONFIGURACION FROM WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRedDistribucionDescuentos();

		IF @@ROWCOUNT = 0 BEGIN --  EXCEPTION WHEN OTHERS THEN
			SET @msg = 'Descuentos de comision: ' + isnull(ERROR_MESSAGE ( ) , '')
			EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg
		END
      
      END;

      -- Conteo de total registros
      SELECT @cTOTALREGISTROS = COUNT(1)
        FROM WSXML_SFG.MAESTROFACTURACIONPDV
       WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION
         AND ACTIVE = 1;

      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_CODDETALLETAREAEJECUTADA,@cTOTALREGISTROS

      -- Iterar por tirillas y luego por maestros
        DECLARE @lstMAESTROSFACTTIRILLA WSXML_SFG.LONGNUMBERARRAY;
      BEGIN
		BEGIN TRY
			INSERT INTO @lstMAESTROSFACTTIRILLA
			
			SELECT ID_MAESTROFACTURACIONTIRILLA 
			  FROM WSXML_SFG.MAESTROFACTURACIONTIRILLA
			 WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION;

			IF @@ROWCOUNT > 0 BEGIN
			  DECLARE it CURSOR FOR SELECT IDVALUE FROM @lstMAESTROSFACTTIRILLA--.First .. lstMAESTROSFACTTIRILLA.Last 
			  OPEN it;

			  DECLARE @it__IDVALUE NUMERIC(38,0)
			 FETCH NEXT FROM it INTO @it__IDVALUE; 
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				  DECLARE @cListaReferencia       WSXML_SFG.REFERENCEBILLING;
				  DECLARE @lstMAESTROSFACTURACION WSXML_SFG.NUMBERARRAY;
				  DECLARE @xCODPUNTODEVENTA       NUMERIC(22,0);
				BEGIN
				  --SET @cListaReferencia = REFERENCEBILLINGLIST();
				  INSERT INTO @lstMAESTROSFACTURACION
				  SELECT ID_MAESTROFACTURACIONPDV
					FROM WSXML_SFG.MAESTROFACTURACIONPDV
				   WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION
					 AND CODMAESTROFACTURACIONTIRILLA = @it__IDVALUE; 

				  SELECT @xCODPUNTODEVENTA = CODPUNTODEVENTA
					FROM WSXML_SFG.MAESTROFACTURACIONTIRILLA
				   WHERE ID_MAESTROFACTURACIONTIRILLA = @it__IDVALUE;

				  -- Por cada maestro de la tirilla = por cada ldn de pdv
				  IF (SELECT COUNT(*) FROM @lstMAESTROSFACTURACION) > 0 BEGIN
					DECLARE ixMAESTRO CURSOR FOR SELECT IDVALUE FROM @lstMAESTROSFACTURACION--.First .. lstMAESTROSFACTURACION.Last 
					OPEN ixMAESTRO;

					DECLARE @ixMAESTRO__IDVALUE NUMERIC(38,0)
					 FETCH NEXT FROM ixMAESTRO INTO @ixMAESTRO__IDVALUE;
					 WHILE @@FETCH_STATUS=0
					 BEGIN
						DECLARE @cCODMAESTROFACTURACIONPDV  NUMERIC(22,0) = @ixMAESTRO__IDVALUE
						DECLARE @xCODMAESTROFACTURATIRILLA  NUMERIC(22,0);
						DECLARE @xCODLINEADENEGOCIO         NUMERIC(22,0);
						DECLARE @cCODTIPOAGRUPACION         NUMERIC(22,0);
						DECLARE @cCODAGRUPACIONPUNTODEVENTA NUMERIC(22,0);
						DECLARE @lstDETALLESFACT            WSXML_SFG.LONGNUMBERARRAY;
						
					BEGIN
						BEGIN TRY
							-- Valores de maestro
							SELECT @xCODMAESTROFACTURATIRILLA = CODMAESTROFACTURACIONTIRILLA,
								   @xCODPUNTODEVENTA = CODPUNTODEVENTA,
								   @xCODLINEADENEGOCIO = CODLINEADENEGOCIO,
								   @cCODAGRUPACIONPUNTODEVENTA = CODAGRUPACIONPUNTODEVENTA,
								   @cCODTIPOAGRUPACION = CODTIPOPUNTODEVENTA
						    FROM WSXML_SFG.MAESTROFACTURACIONPDV MFP
							 INNER JOIN WSXML_SFG.PUNTODEVENTA PDV
								ON (MFP.CODPUNTODEVENTA = PDV.ID_PUNTODEVENTA)
							 INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR
								ON (PDV.CODAGRUPACIONPUNTODEVENTA = AGR.ID_AGRUPACIONPUNTODEVENTA)
							 WHERE ID_MAESTROFACTURACIONPDV = @cCODMAESTROFACTURACIONPDV;

							-- Detalles para limpieza manual
							INSERT INTO @lstDETALLESFACT
							SELECT ID_DETALLEFACTURACIONPDV
							  FROM WSXML_SFG.DETALLEFACTURACIONPDV
							 WHERE CODMAESTROFACTURACIONPDV = @ixMAESTRO__IDVALUE
							   AND ACTIVE = 1;

						   

							-- Recalcular valores para PDVxLDN
							/* COMMIT SECTION */
							  DECLARE @lstREGISTROSFACTURABLES WSXML_SFG.REGISTROFACTURABLE;
							  DECLARE @lstREGISTROSAGRUPADOS    WSXML_SFG.IDVALUENUMERIC--WSXML_SFG.REGISTROSPRODUCTO--WSXML_SFG.REGISTROSLINEADENEGOCIO;
							  DECLARE @cCOUNTFACTURABLES       NUMERIC(22,0) = 0;
							  DECLARE @cCODMAESTROFACTURACION  NUMERIC(22,0); -- Nuevo identificador de maestro. Sera el mismo existente
							BEGIN
							  -- Obtener los registros
							  BEGIN
								BEGIN TRY
									INSERT INTO @lstREGISTROSFACTURABLES
									SELECT ID_REGISTROFACTURACION,CODPRODUCTO
									  FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
									 INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
										ON (REG.CODENTRADAARCHIVOCONTROL =
										   CTR.ID_ENTRADAARCHIVOCONTROL)
									 INNER JOIN WSXML_SFG.PRODUCTO PRD
										ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
									 INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
										ON (TPR.ID_TIPOPRODUCTO = PRD.CODTIPOPRODUCTO)
									 WHERE CTR.CODCICLOFACTURACIONPDV =
										   @cCODCICLOFACTURACION -- Se asegura que solo se recalcule sobre los archivos. sE PUEDE CAMBIAR POR UNA BUSQUEDA DE LOS REGISTROS INICIALMENTE MARCADOS
									   AND CTR.CODCICLOFACTURACIONPDV =
										   @cCODCICLOFACTURACION
									   AND REG.CODPUNTODEVENTA = @xCODPUNTODEVENTA
									   AND TPR.CODLINEADENEGOCIO = @xCODLINEADENEGOCIO; --AND REG.FACTURADO         = 0;
								END TRY
								BEGIN CATCH
										SET @msg = '-20054 Error al obtener los identificadores de los registros facturados: ' + isnull(ERROR_MESSAGE ( ) , '')
										RAISERROR(@msg, 16, 1);
								END CATCH
							  END;

							  -- No facturar si no hay registros facturables
							  SET @cCOUNTFACTURABLES = (SELECT COUNT(*) FROM @lstREGISTROSFACTURABLES)
							  
							  IF @cCOUNTFACTURABLES > 0 BEGIN
								-- Agrupar la lista obtenida por producto
								--SET @lstREGISTROSAGRUPADOS = REGISTROSLINEADENEGOCIO();
								DECLARE reg CURSOR FOR SELECT ID_REGISTROFACTURACION,CODPRODUCTO FROM @lstREGISTROSFACTURABLES--.First .. lstREGISTROSFACTURABLES.Last 
								OPEN reg;
								
								DECLARE @reg__ID_REGISTROFACTURACION NUMERIC(38,0),@reg__CODPRODUCTO NUMERIC(38,0)
								 
								FETCH NEXT FROM reg INTO @reg__ID_REGISTROFACTURACION,@reg__CODPRODUCTO;
								WHILE @@FETCH_STATUS=0
								BEGIN
									DECLARE @regIDREGISTRO  NUMERIC(38,0) = @reg__ID_REGISTROFACTURACION
									DECLARE @regCODPRODUCTO NUMERIC(38,0) = @reg__CODPRODUCTO
									DECLARE @prdFOUND       NUMERIC(38,0) = 0;
									BEGIN
										-- Buscar
										IF (SELECT COUNT(*) FROM @lstREGISTROSAGRUPADOS) > 0 BEGIN
										 DECLARE grup CURSOR FOR SELECT ID AS CODPRODUCTO, VALUE AS IDREGISTRO FROM @lstREGISTROSAGRUPADOS--.First .. lstREGISTROSAGRUPADOS.Last 
										 OPEN grup;
										 DECLARE @grup__CODPRODUCTO NUMERIC(38,0), @grup__IDREGISTRO NUMERIC(38,0)
										 FETCH NEXT FROM grup INTO @grup__CODPRODUCTO, @grup__IDREGISTRO;
										 WHILE @@FETCH_STATUS=0
										 BEGIN
											IF @grup__CODPRODUCTO = @regCODPRODUCTO BEGIN
											  --lstREGISTROSAGRUPADOS(grup).lstREGISTROS(lstREGISTROSAGRUPADOS(grup).lstREGISTROS.Count) := @regIDREGISTRO;
											  INSERT INTO @lstREGISTROSAGRUPADOS VALUES(@grup__CODPRODUCTO, @regIDREGISTRO);
											  
											  SET @prdFOUND = 1;
											  BREAK;
											END
											
											FETCH NEXT FROM grup INTO @grup__CODPRODUCTO, @grup__IDREGISTRO;
											
										 END
										 CLOSE grup;
										 DEALLOCATE grup;
										  --END WHILE 1=1 BEGIN;
										END
										-- Si no se encontro
										IF @prdFOUND = 0 BEGIN
											DECLARE @lstREGISTROSNEWPRODUCTO WSXML_SFG.LONGNUMBERARRAY;
										
											--lstREGISTROSAGRUPADOS(lstREGISTROSAGRUPADOS.Count) := REGISTROSPRODUCTO(regCODPRODUCTO,lstREGISTROSNEWPRODUCTO);
											INSERT INTO @lstREGISTROSAGRUPADOS VALUES (@regCODPRODUCTO, @regIDREGISTRO);
									  
										END 
									END;

									FETCH NEXT FROM reg INTO @reg__ID_REGISTROFACTURACION,@reg__CODPRODUCTO;
								END;

								CLOSE reg;
								DEALLOCATE reg;

								DECLARE @xLINEAEGRESO NUMERIC(38,0);
								SELECT @xLINEAEGRESO = VALUE FROM @xLINEACONFIGURACION WHERE ID = @xCODLINEADENEGOCIO;
								-- Control de reintentos
								EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarPOSLDN
																		@cCODCICLOFACTURACION,
																		@xCODMAESTROFACTURATIRILLA,
																		@xCODPUNTODEVENTA,
																		@cCODTIPOAGRUPACION,
																		@cCODAGRUPACIONPUNTODEVENTA,
																		@xCODLINEADENEGOCIO,
																		@cTODAY,
																		@lstREGISTROSAGRUPADOS,
																		xLINEAEGRESO,
																		@cCODUSUARIOMODIFICACION,
																		@cCODMAESTROFACTURACION OUT
							  END 
							  ELSE BEGIN
							  
								EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarEmptyPOSLDN 
																			 @cCODCICLOFACTURACION,
																			 @xCODMAESTROFACTURATIRILLA,
																			 @xCODPUNTODEVENTA,
																			 @cCODTIPOAGRUPACION,
																			 @cCODAGRUPACIONPUNTODEVENTA,
																			 @xCODLINEADENEGOCIO,
																			 @cTODAY,
																			 @cCODUSUARIOMODIFICACION,
																			 @cCODMAESTROFACTURACION OUT
							  END 
							  -- Actualizar la tarea
							  SET @cCOUNTREGISTROS = @cCOUNTREGISTROS + 1;
							  IF (@cCOUNTREGISTROS % @cWAITREGISTROS) = 0 OR @cCOUNTREGISTROS = @cTOTALREGISTROS BEGIN
								
								EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_CODDETALLETAREAEJECUTADA, @cCOUNTREGISTROS
							  END 
							  -- Ingresar a la lista referenciada
							  --cListaReferencia.Extend(1);
							  INSERT INTO @cListaReferencia VALUES(@xCODLINEADENEGOCIO, @cCODMAESTROFACTURACION);
							  COMMIT;
							END;
						END TRY
						BEGIN CATCH
						-----
						  -- Hubo un error al intentar procesar una entrada
						  SET @msg = ERROR_MESSAGE ( ) ;
						  SET @errormsg = 'No se pudo recalcular la facturacion de ' +
												  ISNULL(WSXML_SFG.LINEADENEGOCIO_NOMBRE_F(@xCODLINEADENEGOCIO), '') +
												  ' para el punto de venta ' +
												  ISNULL(WSXML_SFG.PUNTODEVENTA_CODIGO_F(@xCODPUNTODEVENTA), '')
						  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta 
												  @TIPOADVERTENCIA,
												  'FACTURACION',
												  @errormsg,
												  @msg,
												  @cCODUSUARIOMODIFICACION
												  
						  SET @cTOTALWARNINGS = @cTOTALWARNINGS + 1;
						  COMMIT;
						  IF @cTOTALWARNINGS >= @cMAXWARNINGS BEGIN
							RAISERROR('-20054 Se ha llegado al maximo numero de advertencias para el ciclo de facturacion', 16, 1);
						  END 
						END CATCH
					END;

						FETCH NEXT FROM ixMAESTRO INTO @ixMAESTRO__IDVALUE;
					END;
					CLOSE ixMAESTRO;
					DEALLOCATE ixMAESTRO;
				  END 
				  -- Al final, consolidar descuentos de comision
					DECLARE @thisconfiguration VARCHAR(MAX)--WSXML_SFG.DESCUENTOSLIST;
				  BEGIN
						BEGIN TRY
							SELECT @thisconfiguration = CONFIGURACION
							  FROM @cDESCUENTOSCOMISION
							 WHERE CODPUNTODEVENTA = @xCODPUNTODEVENTA;
							-- thisconfiguration is never empty, due to condition in SFGPUNTODEVENTADESCOMISION.GetRedDistribucionDescuentos
							DECLARE conf CURSOR FOR SELECT VALUE FROM string_split(@thisconfiguration,'|')--.First .. thisconfiguration.Last 
							OPEN conf;
							
							
							DECLARE @conf__VALUE VARCHAR(MAX)
							DECLARE @conf_CODLINEADENEGOCIO NUMERIC(38,0), @conf_CODLINEADENEGOCIODESCUENTO NUMERIC(38,0)
							FETCH NEXT FROM conf INTO @conf__VALUE;
							 
							 WHILE @@FETCH_STATUS=0
							 BEGIN
							 
								SET @conf_CODLINEADENEGOCIO = dbo.SEPARAR_COLUMNAS_F(@conf__VALUE,1,',')
								SET @conf_CODLINEADENEGOCIODESCUENTO = dbo.SEPARAR_COLUMNAS_F(@conf__VALUE,2,',')
								  -- Actua solo si no es uno de uno
								IF @conf_CODLINEADENEGOCIO <> @conf_CODLINEADENEGOCIODESCUENTO BEGIN
									-- Obtener internamente los valores, dado que el ciclo como tal puede disminuir el valor
									  DECLARE @xmasterLINEA          NUMERIC(22,0);
									  DECLARE @xmasterDESCUENTO      NUMERIC(22,0);
									  DECLARE @xVALORCOMISION        FLOAT;
									  DECLARE @xVALORAPAGARLINEA     FLOAT;
									  DECLARE @xVALORAPAGARDESCUENTO FLOAT;
									BEGIN
									  -- Obtener valores de referencia
									  SELECT @xmasterLINEA = CODMAESTROFACTURACIONPDV
										FROM @cListaReferencia
									   WHERE CODLINEADENEGOCIO = @conf_CODLINEADENEGOCIO
									   
									  SELECT @xmasterDESCUENTO = CODMAESTROFACTURACIONPDV
										FROM @cListaReferencia
									   WHERE CODLINEADENEGOCIO = @conf_CODLINEADENEGOCIODESCUENTO
									   
									  -- Obtener valores de tabla de referencia, solo GTECH
									  SELECT @xVALORCOMISION = TOTALCOMISION,
											 @xVALORAPAGARLINEA = (NUEVOSALDOENCONTRAGTECH -
											 NUEVOSALDOAFAVORGTECH)
										FROM WSXML_SFG.MAESTROFACTURACIONPDV
									   WHERE ID_MAESTROFACTURACIONPDV = @xmasterLINEA;
									   
									  SELECT @xVALORAPAGARDESCUENTO = NUEVOSALDOENCONTRAGTECH -
											 NUEVOSALDOAFAVORGTECH
										FROM WSXML_SFG.MAESTROFACTURACIONPDV
									   WHERE ID_MAESTROFACTURACIONPDV = @xmasterDESCUENTO;
									  -- Descontar sin considerar valores
									  EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReintegrarComisionATotal @xmasterLINEA,
															   @xVALORAPAGARLINEA,
															   @xVALORCOMISION,
															   @conf_CODLINEADENEGOCIODESCUENTO
															   
									  EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_DescontarComisionATotal @xmasterDESCUENTO,
															  @xVALORAPAGARDESCUENTO,
															  @xVALORCOMISION
									END;
								  END
								FETCH NEXT FROM conf INTO @conf__VALUE;
							 END
							 CLOSE conf;
							 DEALLOCATE conf;
							
							 -- No se pudo obtener los datos de configuracion. No mover
							 IF @@ROWCOUNT = 0 
							  SELECT NULL;				
						END TRY
						BEGIN CATCH
							  SET @msg = '-20085 No se pudo descontar las comisiones de acuerdo a la configuracion: ' + isnull(ERROR_MESSAGE ( ) , '');
							  RAISERROR(@msg, 16, 1);
						END CATCH
				  END;

				END;
				FETCH NEXT FROM it INTO @it__IDVALUE;
			 END;
			 CLOSE it;
			 DEALLOCATE it;	 

			END
		  
			EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_FreeProcessFlag @cCODCICLOFACTURACION

			SET @msg = 'Se ha recalculado la facturacion ' +
												   ISNULL(@cSECUENCIACICLO, '') +
												   ' correctamente'
			EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
												   
			SET @p_RETVALUE_out = @FINALIZADAOK;
		
		END TRY
		BEGIN CATCH
		  IF @cCODCICLOFACTURACION > 0 BEGIN
			EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_FreeProcessFlag @cCODCICLOFACTURACION
		  END 
		  SET @msg = ERROR_MESSAGE ( ) ;
		  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta_1 @TIPOERROR,
								  'FACTURACION',
								  'Error inesperado',
								  @msg,
								  @cCODUSUARIOMODIFICACION
		  EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
		  SET @p_RETVALUE_out = @FINALIZADAFALLO;
		END CATCH
	  END
  END 
END
GO



  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetListByReferencia', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetListByReferencia;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetListByReferencia(@p_ACTIVE            NUMERIC(22,0),
                                @p_REFERENCIAGTECH   VARCHAR(4000),
                                @p_REFERENCIAFIDUCIA VARCHAR(4000)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT M.ID_MAESTROFACTURACIONPDV,
             M.CODCICLOFACTURACIONPDV,
             M.CODMAESTROFACTURACIONCOMPCONSI,
             M.CODPUNTODEVENTA,
             M.CODLINEADENEGOCIO,
             M.SALDOANTERIORENCONTRAGTECH,
             M.SALDOANTERIORENCONTRAFIDUCIA,
             M.SALDOANTERIORAFAVORGTECH,
             M.SALDOANTERIORAFAVORFIDUCIA,
             M.NUEVOSALDOENCONTRAGTECH,
             M.NUEVOSALDOENCONTRAFIDUCIA,
             M.NUEVOSALDOAFAVORGTECH,
             M.NUEVOSALDOAFAVORFIDUCIA,
             M.FECHAHORAMODIFICACION,
             M.CODUSUARIOMODIFICACION,
             M.ACTIVE
        FROM WSXML_SFG.MAESTROFACTURACIONPDV M
        LEFT OUTER JOIN CICLOFACTURACIONPDV L
          ON (L.ID_CICLOFACTURACIONPDV = M.CODCICLOFACTURACIONPDV)
        LEFT OUTER JOIN MAESTROFACTURACIONCOMPCONSIG C
          ON (C.ID_MAESTROFACTCOMPCONSIG = M.CODMAESTROFACTURACIONCOMPCONSI)
        LEFT OUTER JOIN PAGOFACTURACIONPDV PF
          ON (PF.CODMAESTROFACTURACIONPDV = M.ID_MAESTROFACTURACIONPDV)
       WHERE PF.ID_PAGOFACTURACIONPDV IS NULL
         AND C.REFERENCIAGTECH = CASE
               WHEN @p_REFERENCIAGTECH = '-1' THEN
                C.REFERENCIAGTECH
               ELSE
                @p_REFERENCIAGTECH
             END
         AND C.REFERENCIAFIDUCIA = CASE
               WHEN @p_REFERENCIAFIDUCIA = '-1' THEN
                C.REFERENCIAFIDUCIA
               ELSE
                @p_REFERENCIAFIDUCIA
             END
         AND M.ACTIVE = CASE
               WHEN @p_ACTIVE = -1 THEN
                M.ACTIVE
               ELSE
                @p_ACTIVE
             END;


  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetListByPuntoVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetListByPuntoVenta;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetListByPuntoVenta(@p_ACTIVE          NUMERIC(22,0),
                                @p_CODPUNTODEVENTA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT M.ID_MAESTROFACTURACIONPDV,
             M.CODCICLOFACTURACIONPDV,
             M.CODMAESTROFACTURACIONCOMPCONSI,
             M.CODPUNTODEVENTA,
             M.CODLINEADENEGOCIO,
             M.SALDOANTERIORENCONTRAGTECH,
             M.SALDOANTERIORENCONTRAFIDUCIA,
             M.SALDOANTERIORAFAVORGTECH,
             M.SALDOANTERIORAFAVORFIDUCIA,
             M.NUEVOSALDOENCONTRAGTECH,
             M.NUEVOSALDOENCONTRAFIDUCIA,
             M.NUEVOSALDOAFAVORGTECH,
             M.NUEVOSALDOAFAVORFIDUCIA,
             M.FECHAHORAMODIFICACION,
             M.CODUSUARIOMODIFICACION,
             M.ACTIVE
        FROM WSXML_SFG.MAESTROFACTURACIONPDV M
        LEFT OUTER JOIN WSXML_SFG.CICLOFACTURACIONPDV L
          ON (L.ID_CICLOFACTURACIONPDV = M.CODCICLOFACTURACIONPDV)
        LEFT OUTER JOIN PAGOFACTURACIONPDV PF
          ON (PF.CODMAESTROFACTURACIONPDV = M.ID_MAESTROFACTURACIONPDV)
       WHERE PF.ID_PAGOFACTURACIONPDV IS NULL
         AND M.CODPUNTODEVENTA = @p_CODPUNTODEVENTA
         AND M.ACTIVE = CASE
               WHEN @p_ACTIVE = -1 THEN
                M.ACTIVE
               ELSE
                @p_ACTIVE
             END;


  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarPOSLDN', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarPOSLDN;
GO


  CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarPOSLDN(@cCODCICLOFACTURACION           NUMERIC(22,0),
                           @cCODMAESTROFACTURATIRILLA      NUMERIC(22,0),
                           @xCODPUNTODEVENTA               NUMERIC(22,0),
                           @cCODTIPOAGRUPACION             NUMERIC(22,0),
                           @cCODAGRUPACIONPUNTODEVENTA     NUMERIC(22,0),
                           @xCODLINEADENEGOCIO             NUMERIC(22,0),
                           @cTODAY                         DATETIME,
                           @lstREGISTROSLINEADENEGOCIO     WSXML_SFG.IDVALUENUMERIC READONLY,--REGISTROSLINEADENEGOCIO,
                           @xLINEAEGRESO                   INT,
                           @cCODUSUARIOMODIFICACION        NUMERIC(22,0),
                           @p_CODMAESTROFACTURACIONPDV_out NUMERIC(22,0) OUT) AS
 BEGIN
	  SET NOCOUNT ON;

    DECLARE @cCODCOMPROBANTECONSIGNACION NUMERIC(22,0);
    DECLARE @cCODMAESTROFACTURACIONPDV   NUMERIC(22,0);
    DECLARE @msg                         NVARCHAR(2000);
   
   	DECLARE @TIPOINFORMATIVO TINYINT,
		@TIPOERROR TINYINT,
		@TIPOADVERTENCIA TINYINT,
		@TIPOCUALQUIERA TINYINT,
		@PROCESONOTIFICACION TINYINT,
		@ESTADOABIERTA TINYINT,
		@ESTADOCERRADA TINYINT

  	EXEC WSXML_SFG.SFGALERTA_CONSTANT
		@TIPOINFORMATIVO OUT,
		@TIPOERROR OUT,
		@TIPOADVERTENCIA OUT,
		@TIPOCUALQUIERA OUT,
		@PROCESONOTIFICACION OUT,
		@ESTADOABIERTA OUT,
		@ESTADOCERRADA OUT

	DECLARE  @VALORUSUARIO 	TINYINT,
		  @VALORFIGURAP  	TINYINT,
		  @VALORTARIFAV 	TINYINT,
		  @VALORCOSTOPV 	TINYINT,
		  @VALORCOSTASO 	TINYINT


    /**** DATOS NECESARIOS PARA REALIZAR LA FACTURACION *******************************/
    -- No se genera tirilla si ya existe el maestro de facturacion
    EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GenerateBillingTicketData @cCODCICLOFACTURACION,
                                                             @xCODPUNTODEVENTA,
                                                             @cCODTIPOAGRUPACION,
                                                             @cCODAGRUPACIONPUNTODEVENTA,
                                                             @xCODLINEADENEGOCIO,
                                                             @cTODAY,
                                                             @cCODUSUARIOMODIFICACION,
                                                             @cCODCOMPROBANTECONSIGNACION OUT

    /**** GENERACION DEL MAESTRO DE FACTURACION ***************************************/
    BEGIN
		BEGIN TRY
		  EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_AddRecord @cCODCICLOFACTURACION,
											 @cCODMAESTROFACTURATIRILLA,
											 @cCODCOMPROBANTECONSIGNACION,
											 @xCODLINEADENEGOCIO,
											 @xCODPUNTODEVENTA,
											 @cCODUSUARIOMODIFICACION,
											 @cCODMAESTROFACTURACIONPDV OUT
		END TRY
		BEGIN CATCH
			SET @msg = '-20054 Error al crear el registro de facturacion de linea de negocio: ' + isnull(ERROR_MESSAGE ( ) , '');
			RAISERROR(@msg, 16, 1);
			RETURN 0
		END CATCH
			
    END;

    COMMIT;

    IF @cCODMAESTROFACTURACIONPDV > 0 BEGIN
      /**** REGISTROS DE FACTURACION PARA LA PAREJA PUNTODEVENTA LINEADENEGOCIO *********/
        DECLARE @xSUMHEADERVALORAPAGARGTECH   FLOAT = 0;
        DECLARE @xSUMHEADERVALORAPAGARFIDUCIA FLOAT = 0;
        DECLARE @xSUMHEADERTOTALCOMISION      FLOAT = 0;

        -- Obtener facturacion desde los registros marcados
        DECLARE factprd CURSOR FOR SELECT DISTINCT ID AS CODPRODUCTO/*, VALUE*/ FROM @lstREGISTROSLINEADENEGOCIO--.First .. lstREGISTROSLINEADENEGOCIO.Last 
		OPEN factprd;

		DECLARE @factprd__CODPRODUCTO NUMERIC(38,0)
		FETCH NEXT FROM factprd INTO @factprd__CODPRODUCTO;
		WHILE @@FETCH_STATUS=0
		BEGIN
            DECLARE @cDETALLEFACTURACIONPDV NUMERIC(22,0);
            DECLARE @cMARKEDWITHDETAILID    NUMERIC(22,0) = 0;
            DECLARE @xCODPRODUCTO           NUMERIC(22,0) = @factprd__CODPRODUCTO
			DECLARE @lstREGISTROSDETALLE WSXML_SFG.LONGNUMBERARRAY
			
			INSERT INTO @lstREGISTROSDETALLE
			SELECT VALUE FROM @lstREGISTROSLINEADENEGOCIO
			WHERE ID = @factprd__CODPRODUCTO
            

              DECLARE @xNUMINGRESOS        NUMERIC(22,0) = 0;
              DECLARE @xINGRESOS           FLOAT = 0;
              DECLARE @xNUMANULACIONES     NUMERIC(22,0) = 0;
              DECLARE @xANULACIONES        FLOAT = 0;
              DECLARE @xVALORVENTABRUTA    FLOAT = 0;
              DECLARE @xVALORVENTABRUTANR  FLOAT = 0;
              DECLARE @xVALORAJUSTEBRUTONR FLOAT = 0;

              DECLARE @xVALORCOMISION FLOAT = 0;
              DECLARE @xIVACOMISION   FLOAT = 0;

              DECLARE @xVALORCOMISIONBRUTA FLOAT = 0;
              DECLARE @xVALORCOMISIONNETA  FLOAT = 0;
              DECLARE @xVALORVENTANETA     FLOAT = 0;
              DECLARE @xVALORDESCUENTOS    FLOAT = 0;

              DECLARE @xNUMGRATUITO             NUMERIC(22,0) = 0;
              DECLARE @xGRATUITO                FLOAT = 0;
              DECLARE @xNUMPREMIOSPAGADOS       NUMERIC(22,0) = 0;
              DECLARE @xPREMIOSPAGADOS          FLOAT = 0;
              DECLARE @xRETENCIONPREMIOSPAGADOS FLOAT = 0;

              -- Translation of rules if according to model
              DECLARE @xCOMISIONANTICIPO   NUMERIC(22,0);
              DECLARE @xCODRANGOCOMISION   NUMERIC(22,0);
              DECLARE @xCODTIPOCONTRATOPDV NUMERIC(22,0);
              DECLARE @xFLAGREGISTROSNULL  NUMERIC(22,0);
            
			  BEGIN
              -- Valores de los registros (pareja codpuntodeventa, codproducto, SUMATORIA DE SIETE DIAS)
				  SELECT @xNUMINGRESOS = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.NUMTRANSACCIONES
							   ELSE
								0
							 END),-- AS NUMINGRESOS,
						 @xINGRESOS = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORTRANSACCION
							   ELSE
								0
							 END),-- AS INGRESOS,
						 @xNUMANULACIONES = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.NUMTRANSACCIONES
							   ELSE
								0
							 END),-- AS NUMANULACIONES,
						 @xANULACIONES = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORTRANSACCION
							   ELSE
								0
							 END),-- AS ANULACIONES,
						 -- Venta Bruta
						 @xVALORVENTABRUTA = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORVENTABRUTA
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORVENTABRUTA * (-1)
							   ELSE
								0
							 END),-- AS VALORVENTABRUTA,
						 @xVALORVENTABRUTANR = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORVENTABRUTANOREDONDEADO
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORVENTABRUTANOREDONDEADO * (-1)
							   ELSE
								0
							 END),-- AS VALORVENTABRUTANR,
						 -- Comision Calculada
						 @xVALORCOMISION = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORCOMISION
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORCOMISION * (-1)
							   ELSE
								0
							 END),-- AS VALORCOMISION,
						 -- IVA de la Comision
						 @xIVACOMISION = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.IVACOMISION
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.IVACOMISION * (-1)
							   ELSE
								0
							 END),-- AS IVACOMISION,
						 -- Comision Bruta
						 @xVALORCOMISIONBRUTA = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORCOMISIONBRUTA
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORCOMISIONBRUTA * (-1)
							   ELSE
								0
							 END),-- AS VALORCOMISIONBRUTA,
						 -- Comision Neta
						 @xVALORCOMISIONNETA = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORCOMISIONNETA
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORCOMISIONNETA * (-1)
							   ELSE
								0
							 END),-- AS VALORCOMISIONNETA,
						 --Descuentos 
						 @xVALORDESCUENTOS = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								ISNULL(REG.VALORDESCUENTOS,0)
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								ISNULL(REG.VALORDESCUENTOS,0) * (-1)
							   ELSE
								0
							 END),-- AS VALORDESCUENTOS,
                         
						 -- Venta Neta
						 @xVALORVENTANETA = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								REG.VALORVENTANETA
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								REG.VALORVENTANETA * (-1)
							   ELSE
								0
							 END),-- AS VALORVENTANETA,
						 -- Gratuito
						 @xNUMGRATUITO = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 3 THEN
								REG.NUMTRANSACCIONES
							   ELSE
								0
							 END),-- AS NUMGRATUITO,
						 @xGRATUITO = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 3 THEN
								REG.VALORTRANSACCION
							   ELSE
								0
							 END),-- AS GRATUITO,
						 -- Premios
						 @xNUMPREMIOSPAGADOS = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 4 THEN
								REG.NUMTRANSACCIONES
							   ELSE
								0
							 END),-- AS NUMPREMIOSPAGADOS,
						 @xPREMIOSPAGADOS = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 4 THEN
								REG.VALORTRANSACCION
							   ELSE
								0
							 END),-- AS PREMIOSPAGADOS,
						 @xRETENCIONPREMIOSPAGADOS = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 4 THEN
								REG.RETENCIONPREMIO
							   ELSE
								0
							 END),-- AS RETENCIONPREMIOSPAGADOS,
						 @xCOMISIONANTICIPO = MIN(COMISIONANTICIPO),
						 @xCODRANGOCOMISION = MIN(CODRANGOCOMISION),
						 @xCODTIPOCONTRATOPDV = MIN(CODTIPOCONTRATOPDV),
						 @xFLAGREGISTROSNULL = SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 5 THEN
								1
							   ELSE
								0
							 END)
								   FROM WSXML_SFG.REGISTROFACTURACION REG
				   WHERE ID_REGISTROFACTURACION IN
						 (SELECT * FROM @lstREGISTROSDETALLE);
				  -- Para el caso de ajustes, obtener venta bruta de ajustes
				  BEGIN
					SELECT /*+ INDEX_DESC(AJS) */
					 @xVALORAJUSTEBRUTONR = ISNULL(SUM(CASE
							   WHEN REG.CODTIPOREGISTRO = 1 THEN
								ISNULL(AJS.VALORAJUSTEBRUTONOREDONDEADO, 0)
							   WHEN REG.CODTIPOREGISTRO = 2 THEN
								ISNULL(AJS.VALORAJUSTEBRUTONOREDONDEADO, 0) * -1
							   ELSE
								0
							 END),
						 0)
					  FROM WSXML_SFG.REGISTROFACTURACION REG,
						   (SELECT CODENTRADAARCHIVODESTINO,
								   CODREGISTROFACTDESTINO,
								   SUM(CANTIDADAJUSTE) AS CANTIDADAJUSTE,
								   SUM(VALORAJUSTE) AS VALORAJUSTE,
								   SUM(VALORVENTABRUTANOREDONDEADO) AS VALORAJUSTEBRUTONOREDONDEADO
							  FROM WSXML_SFG.AJUSTEFACTURACION
							 WHERE CODTIPOAJUSTEFACTURACION = 1
							 GROUP BY CODENTRADAARCHIVODESTINO,
									  CODREGISTROFACTDESTINO) AJS
					 WHERE AJS.CODENTRADAARCHIVODESTINO =
						   REG.CODENTRADAARCHIVOCONTROL
					   AND AJS.CODREGISTROFACTDESTINO =
						   REG.ID_REGISTROFACTURACION
					   AND ID_REGISTROFACTURACION IN
						   (SELECT * FROM @lstREGISTROSDETALLE);
					  IF @@ROWCOUNT = 0
						SET @xVALORAJUSTEBRUTONR = 0;
				  END;


				  -- Ingresos: 0, Anulaciones: 0, Gratuitos: 0, PremioPago: 0
				  /*IF xNUMINGRESOS       <> 0 OR xINGRESOS       <> 0 OR xNUMANULACIONES    <> 0 OR xANULACIONES    <> 0 OR xNUMGRATUITO       <> 0 OR xGRATUITO       <> 0 OR xNUMPREMIOSPAGADOS <> 0 OR xPREMIOSPAGADOS <> 0*/
				  -- No registros null
				  IF @xNUMINGRESOS > 0 AND @xINGRESOS = 0 and @xVALORCOMISION = 0 BEGIN
					SELECT NULL;
				  END
				  ELSE BEGIN
					IF (SELECT COUNT(*) FROM @lstREGISTROSDETALLE) > @xFLAGREGISTROSNULL
					  BEGIN
							EXEC WSXML_SFG.SFGDETALLEFACTURACIONPDV_CrearDetalle @cCODMAESTROFACTURACIONPDV,
																  @xCODPRODUCTO,
																  @xCOMISIONANTICIPO,
																  @xCODRANGOCOMISION,
																  @xCODTIPOCONTRATOPDV,
																  @cCODUSUARIOMODIFICACION,
																  @cDETALLEFACTURACIONPDV OUT
							  SET @msg = '-20054 Error al crear el registro de facturacion del producto: ' + isnull(ERROR_MESSAGE ( ) , '');
							  RAISERROR(@msg, 16, 1);
					  END;


					  IF @cDETALLEFACTURACIONPDV > 0 BEGIN
						-- Obtener Tributario y actualizar todo
						  DECLARE @tmpmsg                      NVARCHAR(2000);
						  DECLARE @xSUMIMPUESTOS               NUMERIC(22,0) = 0;
						  DECLARE @xSUMRETENCION               NUMERIC(22,0) = 0;
						  DECLARE @xSUMRETENCION_DIF           NUMERIC(22,0) = 0;
						  DECLARE @cPRODUCTOVALORAPAGAR        FLOAT = 0;
						  DECLARE @cPRODUCTOVALORAPAGARGTECH   FLOAT = 0;
						  DECLARE @cPRODUCTOVALORAPAGARFIDUCIA FLOAT = 0;
						  DECLARE @cPORCENTAJEGTECH            NUMERIC(22,0) = 100;
						  DECLARE @cPORCENTAJEFIDUCIA          NUMERIC(22,0) = 0;

						  BEGIN
						  /*-- Impuestos (Round level/One tax per product)---------------------------------*/
						  DECLARE tIMPUESTO CURSOR FOR SELECT CODIMPUESTO,
												   CODPRODUCTOIMPUESTO,
												   SUM(CASE WHEN CODTIPOREGISTRO = 1 THEN VALORIMPUESTO
														 WHEN CODTIPOREGISTRO = 2 THEN VALORIMPUESTO * (-1) ELSE 0 END) AS VALORIMPUESTO
											  FROM WSXML_SFG.IMPUESTOREGFACTURACION
											 WHERE CODREGISTROFACTURACION IN
												   (SELECT * FROM @lstREGISTROSDETALLE)
											 GROUP BY CODIMPUESTO,
													  CODPRODUCTOIMPUESTO; OPEN tIMPUESTO;
						 DECLARE @tIMPUESTO__CODIMPUESTO NUMERIC(38,0), @tIMPUESTO__CODPRODUCTOIMPUESTO NUMERIC(38,0), @tIMPUESTO__VALORIMPUESTO FLOAT
						 FETCH NEXT FROM tIMPUESTO INTO @tIMPUESTO__CODIMPUESTO, @tIMPUESTO__CODPRODUCTOIMPUESTO, @tIMPUESTO__VALORIMPUESTO;
						 WHILE @@FETCH_STATUS=0
						 BEGIN
							  DECLARE @cDETALLEFACTURACIONIMPUESTO NUMERIC(22,0);
							BEGIN
								BEGIN TRY
								  EXEC WSXML_SFG.SFGDETALLEFACTURACIONIMPUESTO_CrearImpuesto 
																				@cCODMAESTROFACTURACIONPDV,
																			  @cDETALLEFACTURACIONPDV,
																			  @tIMPUESTO__CODIMPUESTO,
																			  @tIMPUESTO__CODPRODUCTOIMPUESTO,
																			  @tIMPUESTO__VALORIMPUESTO,
																			  @cCODUSUARIOMODIFICACION,
																			  @cDETALLEFACTURACIONIMPUESTO OUT
								  SET @xSUMIMPUESTOS = @xSUMIMPUESTOS + @tIMPUESTO__VALORIMPUESTO;
								END TRY
								BEGIN CATCH
									SET @tmpmsg = ERROR_MESSAGE ( ) ;
									RAISERROR('-20054 No se pudo ingresar el registro de impuesto sobre el producto', 16, 1);
								END CATCH
							END;

						  FETCH NEXT FROM tIMPUESTO INTO @tIMPUESTO__CODIMPUESTO, @tIMPUESTO__CODPRODUCTOIMPUESTO, @tIMPUESTO__VALORIMPUESTO;
						  END;
						 CLOSE tIMPUESTO;
						 DEALLOCATE tIMPUESTO;

						  /*-- Retenciones tributarias (Round level, one tax per product) -----------------*/
						 DECLARE tRETENCION CURSOR FOR SELECT CODRETENCIONTRIBUTARIA,
													SUM(CASE
														  WHEN CODTIPOREGISTRO = 1 THEN
														   VALORRETENCION
														  WHEN CODTIPOREGISTRO = 2 THEN
														   VALORRETENCION * (-1)
														  ELSE
														   0
														END) AS VALORRETENCION
											   FROM WSXML_SFG.RETENCIONREGFACTURACION
											  WHERE CODREGISTROFACTURACION IN
													(SELECT *
													   FROM @lstREGISTROSDETALLE)
												AND ACTIVE = 1
											  GROUP BY CODRETENCIONTRIBUTARIA; OPEN tRETENCION;
						 DECLARE @tRETENCION__CODRETENCIONTRIBUTARIA NUMERIC(38,0), @tRETENCION__VALORRETENCION FLOAT
						 FETCH NEXT FROM tRETENCION INTO @tRETENCION__CODRETENCIONTRIBUTARIA, @tRETENCION__VALORRETENCION ;
						 WHILE @@FETCH_STATUS=0
						 BEGIN
							  DECLARE @cDETALLEFACTURACIONRETENCION NUMERIC(22,0);
							BEGIN
								BEGIN TRY
								  EXEC WSXML_SFG.SFGDETALLEFACTURACIONRETENCION_CrearRetencionTributaria
																						  @cCODMAESTROFACTURACIONPDV,
																						  @cDETALLEFACTURACIONPDV,
																						  @tRETENCION__CODRETENCIONTRIBUTARIA,
																						  @tRETENCION__VALORRETENCION,
																						  @cCODUSUARIOMODIFICACION,
																						  @cDETALLEFACTURACIONRETENCION OUT
								  SET @xSUMRETENCION = @xSUMRETENCION + @tRETENCION__VALORRETENCION;
								END TRY
								BEGIN CATCH
									SET @tmpmsg = ERROR_MESSAGE ( ) ;
									RAISERROR('-20054 No se pudo ingresar el registro de retencion sobre el producto', 16, 1);
								END CATCH
							END;

						  FETCH NEXT FROM tRETENCION INTO @tRETENCION__CODRETENCIONTRIBUTARIA, @tRETENCION__VALORRETENCION ;
						  END;
						 CLOSE tRETENCION;
						 DEALLOCATE tRETENCION;

						 /*-- Retenciones tributarias de productos diferidos (Round level, one tax per product) -----------------*/
						 DECLARE tRETENCION2 CURSOR FOR SELECT CODRETENCIONTRIBUTARIA,
													SUM(CASE
														  WHEN CODTIPOREGISTRO = 1 THEN
														   VALORRETENCION
														  WHEN CODTIPOREGISTRO = 2 THEN
														   VALORRETENCION * (-1)
														  ELSE
														   0
														END) AS VALORRETENCION
											   FROM WSXML_SFG.RETENCIONREGFACTURACIONDIF
											  WHERE CODREGISTROFACTURACION IN
													(SELECT *
													   FROM @lstREGISTROSDETALLE)
												AND ACTIVE = 1
											  GROUP BY CODRETENCIONTRIBUTARIA; OPEN tRETENCION2;
						 DECLARE @tRETENCION2__CODRETENCIONTRIBUTARIA NUMERIC(38,0), @tRETENCION2__VALORRETENCION FLOAT

						 FETCH NEXT FROM tRETENCION2 INTO @tRETENCION2__CODRETENCIONTRIBUTARIA, @tRETENCION2__VALORRETENCION
						 WHILE @@FETCH_STATUS=0
						 BEGIN
							  DECLARE @cDETALLEFACTURACIONRETDIFE NUMERIC(22,0);
							BEGIN
								BEGIN TRY
								  EXEC WSXML_SFG.SFGDETALLEFACTURACIONRETDIFE_CrearRetencionTributaria @cCODMAESTROFACTURACIONPDV,
																						@cDETALLEFACTURACIONPDV,
																						@tRETENCION2__CODRETENCIONTRIBUTARIA,
																						@tRETENCION2__VALORRETENCION,
																						@cCODUSUARIOMODIFICACION,
																						@cDETALLEFACTURACIONRETDIFE OUT
								  SET @xSUMRETENCION_DIF = @xSUMRETENCION_DIF +
													   @tRETENCION2__VALORRETENCION;
								END TRY
								BEGIN CATCH
									SET @tmpmsg = ERROR_MESSAGE ( ) ;
									RAISERROR('-20054 No se pudo ingresar el registro de retencion sobre el producto', 16, 1);
								END CATCH
							END;

						  FETCH NEXT FROM tRETENCION2 INTO @tRETENCION2__CODRETENCIONTRIBUTARIA, @tRETENCION2__VALORRETENCION
						  END;
						 CLOSE tRETENCION2;
						 DEALLOCATE tRETENCION2;

						 /*-- Retenciones UVT (Round level/One Tax per product)---------------------------*/
						 DECLARE tRETUVT CURSOR FOR SELECT CODRETENCIONUVT,
												 SUM(CASE
													   WHEN CODTIPOREGISTRO = 1 THEN
														VALORRETENCION
													   WHEN CODTIPOREGISTRO = 2 THEN
														VALORRETENCION * (-1)
													   ELSE
														0
													 END) AS VALORRETENCION
											FROM WSXML_SFG.RETUVTREGFACTURACION
										   WHERE CODREGISTROFACTURACION IN
												 (SELECT *
													FROM @lstREGISTROSDETALLE)
											 AND ACTIVE = 1
										   GROUP BY CODRETENCIONUVT; OPEN tRETUVT;
						 DECLARE @tRETUVT__CODRETENCIONUVT NUMERIC(38,0), @tRETUVT__VALORRETENCION FLOAT
						 FETCH NEXT FROM tRETUVT INTO @tRETUVT__CODRETENCIONUVT, @tRETUVT__VALORRETENCION;
						 WHILE @@FETCH_STATUS=0
						 BEGIN
							  DECLARE @cDETALLEFACTURACIONRETUVT NUMERIC(22,0);
							BEGIN
								BEGIN TRY
								  EXEC WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_CrearRetencionUVT
																				@cCODMAESTROFACTURACIONPDV,
																				@cDETALLEFACTURACIONPDV,
																				@tRETUVT__CODRETENCIONUVT,
																				@tRETUVT__VALORRETENCION,
																				@cCODUSUARIOMODIFICACION,
																				@cDETALLEFACTURACIONRETUVT OUT
								  SET @xSUMRETENCION = @xSUMRETENCION +
												   @tRETUVT__VALORRETENCION;
								END TRY
								BEGIN CATCH
									SET @tmpmsg = ERROR_MESSAGE ( ) ;
									RAISERROR('-20054 No se pudo ingresar el registro de retencion UVT sobre el producto', 16, 1);
								END CATCH
							END;

						  FETCH NEXT FROM tRETUVT INTO @tRETUVT__CODRETENCIONUVT, @tRETUVT__VALORRETENCION;
						  END;
						 CLOSE tRETUVT;
						 DEALLOCATE tRETUVT;

						  -- Actualizar Valores
						  BEGIN
							BEGIN TRY
								-- Calcular valor a pagar y acumular para cabecera
								SELECT @cPORCENTAJEGTECH = PORCENTAJEGTECH, @cPORCENTAJEFIDUCIA = PORCENTAJEFIDUCIA
								  FROM WSXML_SFG.PRODUCTO
								 WHERE ID_PRODUCTO = @xCODPRODUCTO;
								/* VENTAS BUENAS - COMISION NETA - PREMIOS PAGOS (TOTALES) */
								SET @cPRODUCTOVALORAPAGAR = ((CASE
														  WHEN @xLINEAEGRESO = 1 THEN
														   0
														  ELSE
														   @xINGRESOS - @xANULACIONES
														END) - @xVALORCOMISIONNETA - @xPREMIOSPAGADOS);

								IF NOT
									((@cPORCENTAJEGTECH + @cPORCENTAJEFIDUCIA) = 100) BEGIN
								  SET @cPORCENTAJEGTECH   = 100;
								  SET @cPORCENTAJEFIDUCIA = 0;
								  SET  @msg = 'Se encontro configuracion incorrecta para valores de pertenencia del producto ' +
														  ISNULL(WSXML_SFG.PRODUCTO_NOMBRE_F(@xCODPRODUCTO), '') +
														  '. Se procedio con los valores por defecto (100 - 0)'
								  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @TIPOADVERTENCIA,
														  'FACTURACION',
														  @msg,
														  1
								END

								IF @cPORCENTAJEFIDUCIA > 0 BEGIN
								  --cPRODUCTOVALORAPAGARFIDUCIA := ROUND((xVALORVENTABRUTA * (cPORCENTAJEFIDUCIA / 100)) - xPREMIOSPAGADOS);
								  SET @cPRODUCTOVALORAPAGARFIDUCIA = CEILING(((@xVALORVENTABRUTANR -
																	  @xVALORAJUSTEBRUTONR) *
																	  (@cPORCENTAJEFIDUCIA / 100)) -
																	  @xPREMIOSPAGADOS);
								  SET @cPRODUCTOVALORAPAGARGTECH   = @cPRODUCTOVALORAPAGAR -
																 @cPRODUCTOVALORAPAGARFIDUCIA;
								END ELSE BEGIN
								  SET @cPRODUCTOVALORAPAGARGTECH = @cPRODUCTOVALORAPAGAR;
								END

								SET @xSUMHEADERVALORAPAGARGTECH   = @xSUMHEADERVALORAPAGARGTECH +
																@cPRODUCTOVALORAPAGARGTECH;
								SET @xSUMHEADERVALORAPAGARFIDUCIA = @xSUMHEADERVALORAPAGARFIDUCIA +
																@cPRODUCTOVALORAPAGARFIDUCIA;

								-- Actualizar valores.
								EXEC WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarInformacion @cDETALLEFACTURACIONPDV,
																			   @xNUMINGRESOS,
																			   @xINGRESOS,
																			   @xNUMANULACIONES,
																			   @xANULACIONES,
																			   @xNUMGRATUITO,
																			   @xGRATUITO,
																			   @xNUMPREMIOSPAGADOS,
																			   @xPREMIOSPAGADOS,
																			   @xRETENCIONPREMIOSPAGADOS,
																			   @xVALORVENTABRUTA,
																			   @xVALORVENTANETA,
																			   @xVALORCOMISION,
																			   @xIVACOMISION,
																			   @xVALORCOMISIONBRUTA,
																			   @xVALORCOMISIONNETA,
																			   @xVALORDESCUENTOS,
																			   @cPRODUCTOVALORAPAGARGTECH,
																			   @cPRODUCTOVALORAPAGARFIDUCIA

							  END TRY
							  BEGIN CATCH
								  RAISERROR('-20054 No se pudo actualizar el registro de ventas sobre el producto', 16, 1);
							  END CATCH
						  END 

						  -- Marcar registros con el del detalle de facturacion
						  BEGIN
							BEGIN TRY
								UPDATE WSXML_SFG.REGISTROFACTURACION
								   SET FACTURADO                = 1,
									   CODDETALLEFACTURACIONPDV = @cDETALLEFACTURACIONPDV,
									   CODUSUARIOMODIFICACION   = @cCODUSUARIOMODIFICACION,
									   FECHAHORAMODIFICACION    = GETDATE()
								 WHERE ID_REGISTROFACTURACION IN
									   (SELECT * FROM @lstREGISTROSDETALLE);
								SET @cMARKEDWITHDETAILID = 1;
							END TRY
							BEGIN CATCH
							  RAISERROR('-20054 No se pudo marcar los registros como procesados', 16, 1);
							END  CATCH
						  END

						END

					  END ELSE BEGIN
						SET @msg = ERROR_MESSAGE ( ) ;
						RAISERROR('-20054 Error al crear el registro de facturacion del producto.', 16, 1);
					  END
					END
              END
              -- Mark anyway, even if not linked
              IF @cMARKEDWITHDETAILID = 0
              BEGIN
					BEGIN TRY
					  UPDATE WSXML_SFG.REGISTROFACTURACION
						 SET FACTURADO              = 1,
							 CODUSUARIOMODIFICACION = @cCODUSUARIOMODIFICACION,
							 FECHAHORAMODIFICACION  = GETDATE()
					   WHERE ID_REGISTROFACTURACION IN
							 (SELECT * FROM @lstREGISTROSDETALLE);
					END TRY
					BEGIN CATCH
						RAISERROR('-20054 No se pudo marcar los registros como procesados', 16, 1);
					END CATCH
                END;

			  FETCH NEXT FROM factprd INTO @factprd__CODPRODUCTO;
            END

        CLOSE factprd;
        DEALLOCATE factprd;
        -- Aggregate comission to reduntant column
        SET @xSUMHEADERTOTALCOMISION = @xSUMHEADERTOTALCOMISION + @xVALORCOMISIONNETA;

        -- Consolidar valores de cabecera
          DECLARE @cMAESTROANTERENCONTRAGTECH   FLOAT = 0;
          DECLARE @cMAESTROANTERENCONTRAFIDUCIA FLOAT = 0;
          DECLARE @cMAESTROANTERAFAVORGTECH     FLOAT = 0;
          DECLARE @cMAESTROANTERAFAVORFIDUCIA   FLOAT = 0;

          DECLARE @thisHEADERBILLINGGTECH   FLOAT = 0;
          DECLARE @thisHEADERBILLINGFIDUCIA FLOAT = 0;

          DECLARE @cMAESTRONUEVOENCONTRAGTECH   FLOAT;
          DECLARE @cMAESTRONUEVOENCONTRAFIDUCIA FLOAT;
          DECLARE @cMAESTRONUEVOAFAVORGTECH     FLOAT;
          DECLARE @cMAESTRONUEVOAFAVORFIDUCIA   FLOAT;

          DECLARE @coutDETALLESALDOPDV NUMERIC(22,0);

		  BEGIN
          -- Obtener saldos actuales (previos a cCODMAESTROFACTURACIONPDV para efectos de recalculo)
          EXEC WSXML_SFG.SFGDETALLESALDOPDV_GetPreviousValuesFromBilling @cCODMAESTROFACTURACIONPDV,
                                                          xCODPUNTODEVENTA,
                                                          xCODLINEADENEGOCIO,
                                                          @cMAESTROANTERENCONTRAGTECH OUT,
                                                          @cMAESTROANTERENCONTRAFIDUCIA OUT,
                                                          @cMAESTROANTERAFAVORGTECH OUT,
                                                          @cMAESTROANTERAFAVORFIDUCIA OUT

          -- Agregar facturacion actual
          SET @thisHEADERBILLINGGTECH   = (@cMAESTROANTERENCONTRAGTECH -
                                      @cMAESTROANTERAFAVORGTECH) + @xSUMHEADERVALORAPAGARGTECH;
          SET @thisHEADERBILLINGFIDUCIA = (@cMAESTROANTERENCONTRAFIDUCIA -
                                      @cMAESTROANTERAFAVORFIDUCIA) + @xSUMHEADERVALORAPAGARFIDUCIA;

          IF @thisHEADERBILLINGGTECH > 0 BEGIN
            -- Positive Billing
            SET @cMAESTRONUEVOENCONTRAGTECH = ABS(@thisHEADERBILLINGGTECH);
            SET @cMAESTRONUEVOAFAVORGTECH   = 0;
          END
          ELSE BEGIN
            SET @cMAESTRONUEVOENCONTRAGTECH = 0;
            SET @cMAESTRONUEVOAFAVORGTECH   = ABS(@thisHEADERBILLINGGTECH);
          END 

          IF @thisHEADERBILLINGFIDUCIA > 0 BEGIN
            -- Positive Billing
            SET @cMAESTRONUEVOENCONTRAFIDUCIA = ABS(@thisHEADERBILLINGFIDUCIA);
            SET @cMAESTRONUEVOAFAVORFIDUCIA   = 0;
          END
          ELSE BEGIN
            SET @cMAESTRONUEVOENCONTRAFIDUCIA = 0;
            SET @cMAESTRONUEVOAFAVORFIDUCIA   = ABS(@thisHEADERBILLINGFIDUCIA);
          END 

          EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_ActualizarValoresPago cCODMAESTROFACTURACIONPDV,
                                                         @cMAESTROANTERENCONTRAGTECH,
                                                         @cMAESTROANTERENCONTRAFIDUCIA,
                                                         @cMAESTROANTERAFAVORGTECH,
                                                         @cMAESTROANTERAFAVORFIDUCIA,
                                                         @cMAESTRONUEVOENCONTRAGTECH,
                                                         @cMAESTRONUEVOENCONTRAFIDUCIA,
                                                         @cMAESTRONUEVOAFAVORGTECH,
                                                         @cMAESTRONUEVOAFAVORFIDUCIA,
                                                         xSUMHEADERTOTALCOMISION,
                                                         cCODUSUARIOMODIFICACION

          -- Actualizar datos de saldo
          EXEC WSXML_SFG.SFGDETALLESALDOPDV_SetSaldoActualPDV @xCODPUNTODEVENTA,
                                               xCODLINEADENEGOCIO,
                                               @cMAESTRONUEVOAFAVORGTECH,
                                               @cMAESTRONUEVOAFAVORFIDUCIA,
                                               @cMAESTRONUEVOENCONTRAGTECH,
                                               @cMAESTRONUEVOENCONTRAFIDUCIA,
                                               cCODMAESTROFACTURACIONPDV,
                                               cCODUSUARIOMODIFICACION,
                                               @coutDETALLESALDOPDV OUT
		END;

			SET @p_CODMAESTROFACTURACIONPDV_out = @cCODMAESTROFACTURACIONPDV;
	  END ELSE BEGIN
		RAISERROR('-20054 Error al crear el registro de facturacion de linea de negocio.', 16, 1);
      END

END;

GO

  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT ID_MAESTROFACTURACIONPDV,
             CODCICLOFACTURACIONPDV,
             CODMAESTROFACTURACIONCOMPCONSI,
             CODPUNTODEVENTA,
             CODLINEADENEGOCIO,
             SALDOANTERIORENCONTRAGTECH,
             SALDOANTERIORENCONTRAFIDUCIA,
             SALDOANTERIORAFAVORGTECH,
             SALDOANTERIORAFAVORFIDUCIA,
             NUEVOSALDOENCONTRAGTECH,
             NUEVOSALDOENCONTRAFIDUCIA,
             NUEVOSALDOAFAVORGTECH,
             NUEVOSALDOAFAVORFIDUCIA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.MAESTROFACTURACIONPDV M
       WHERE M.ACTIVE = CASE
               WHEN @p_active = -1 THEN
                M.ACTIVE
               ELSE
                @p_active
             END;
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_CicloFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_CicloFacturacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_CicloFacturacion(@p_FECHAFACTURACION         DATETIME,
                             @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0),
                             @p_RETVALUE_out             NUMERIC(22,0) OUT) AS
 BEGIN
	
	SET NOCOUNT ON;

    DECLARE @cCODCICLOFACTURACION    NUMERIC(22,0);
    DECLARE @cTODAY                  DATETIME = @p_FECHAFACTURACION; -- Emula la fecha de facturacion, y es utilizado para efectos de algoritmo de referencia
    DECLARE @cCODUSUARIOMODIFICACION NUMERIC(22,0) = 1;
    DECLARE @cSECUENCIACICLO         NUMERIC(22,0) = 0;
    DECLARE @xLINEACONFIGURACION     WSXML_SFG.IDVALUE;

    DECLARE @cTOTALWARNINGS            NUMERIC(22,0) = 0;
    DECLARE @cTOTALREGISTROS           NUMERIC(22,0) = 0;
    DECLARE @cCOUNTREGISTROS           NUMERIC(22,0) = 0;
    DECLARE @cWAITREGISTROS            NUMERIC(22,0) = 10;
    DECLARE @cMAXWARNINGS              NUMERIC(22,0) = 50; -- Maximo numero de advertencias que puede generar antes de fallar completamente
    DECLARE @cPUNTOSDEVENTAFACTURACION WSXML_SFG.PDVLDNFACTURACION--WSXML_SFG.PUNTOSVENTALINEASNEGOCIO;
	DECLARE @cPDVLINEASDENEGOCIO	   WSXML_SFG.IDVALUENUMERIC
    DECLARE @cDESCUENTOSCOMISION       WSXML_SFG.PDVDESCUENTOS--WSXML_SFG.REDDESCUENTOS;
    DECLARE @BillingFiles              WSXML_SFG.NUMBERARRAY;
    -- El tipo PUNTOSVENTALINEASNEGOCIO es un arreglo de elementos (PUNTODEVENTA, ARREGLO DE LINEAS DE NEGOCIO)
    DECLARE @msg VARCHAR(2000);
   

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

	
	
	DECLARE @REGISTRADA      			TINYINT,
			@INICIADA         		TINYINT,
			@FINALIZADAOK 			TINYINT,
			@FINALIZADAFALLO  		TINYINT,
			@ABORTADA  				TINYINT,
			@NOINICIADA  				TINYINT,
			@FINALIZADAADVERTENCIA  	TINYINT

	EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT
			@REGISTRADA      	 OUT,
			@INICIADA          OUT,
			@FINALIZADAOK 	 OUT,
			@FINALIZADAFALLO   OUT,
			@ABORTADA  		 OUT,
			@NOINICIADA  		 OUT,
			@FINALIZADAADVERTENCIA  OUT
    -- Verificar flag de proceso para evitar dos ciclos simultaneos

	BEGIN TRY

		IF WSXML_SFG.SFGCICLOFACTURACIONPDV_ReadProcessFlag() > 0 BEGIN
		  RAISERROR('-20090 No se pueden ejecutar dos ciclos de facturacion simultaneamente', 16, 1);
		END 

		-- Inicializar
		--SET @cPUNTOSDEVENTAFACTURACION = PUNTOSVENTALINEASNEGOCIO();

		-- Crear ciclo de facturacion
		SET @cTODAY = CONVERT(DATETIME, CONVERT(DATE,@cTODAY))
		EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_AddRecord @cTODAY,
										 @cCODUSUARIOMODIFICACION,
										 @cCODCICLOFACTURACION OUT

		IF @cCODCICLOFACTURACION > 0 BEGIN

		  SELECT @cSECUENCIACICLO = SECUENCIA
			FROM WSXML_SFG.CICLOFACTURACIONPDV
		   WHERE ID_CICLOFACTURACIONPDV = @cCODCICLOFACTURACION;

		  EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_MarkProcessFlag @cCODCICLOFACTURACION
		  --SELECT SECUENCIA INTO cSECUENCIACICLO FROM CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = cCODCICLOFACTURACION;
		  -- Marcar los archivos que se estan facturando
		  INSERT INTO @BillingFiles
		  SELECT ID_ENTRADAARCHIVOCONTROL 
			FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
		   WHERE REVERSADO = 0
			 AND FACTURADO = 0
			 AND FECHAARCHIVO <= CONVERT(DATETIME, CONVERT(DATE,@cTODAY))
			 AND ARCHIVOFACTURABLE = 1;

		  IF @@ROWCOUNT = 0 BEGIN
			RAISERROR('-20054 No existen archivos para facturar', 16, 1);
		  END 

		  UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL
			 SET FACTURADO = 1, CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACION
		   WHERE ID_ENTRADAARCHIVOCONTROL IN
				 (SELECT IDVALUE FROM @BillingFiles);
		  COMMIT;

		  -- Primero se obtiene los registros de FACTURACIONLINEADENEGOCIO que aplican hoy /* Optimized */
			DECLARE @cVERIFICACION VARCHAR(10);

			DECLARE cFACTURAHOY CURSOR LOCAL FOR
			  SELECT F.ID_FACTURACIONLINEADENEGOCIO,
					 F.CODLINEADENEGOCIO,
					 F.CODPERIODICIDAD,
					 F.FECHA,
					 F.DEFECTO
				FROM WSXML_SFG.FACTURACIONLINEADENEGOCIO F
			   INNER JOIN WSXML_SFG.LINEADENEGOCIO L
				  ON (F.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
			   WHERE L.ACTIVE = 1
				 AND F.ACTIVE = 1;

		  BEGIN
			BEGIN TRY
				OPEN cFACTURAHOY;

				DECLARE @cFACTURAHOY__ID_FACTURACIONLINEADENEGOCIO NUMERIC(38,0),  @cFACTURAHOY__CODLINEADENEGOCIO NUMERIC(38,0), @cFACTURAHOY__CODPERIODICIDAD NUMERIC(38,0),
						 @cFACTURAHOY__FECHA DATETIME, @cFACTURAHOY__DEFECTO NUMERIC(22,0)
				FETCH NEXT FROM cFACTURAHOY INTO @cFACTURAHOY__ID_FACTURACIONLINEADENEGOCIO,  @cFACTURAHOY__CODLINEADENEGOCIO, @cFACTURAHOY__CODPERIODICIDAD,
						 @cFACTURAHOY__FECHA, @cFACTURAHOY__DEFECTO
				WHILE @@FETCH_STATUS=0 
				BEGIN
          

					DECLARE @tmpPUNTOSDEVENTA WSXML_SFG.LONGNUMBERARRAY;
					BEGIN
					SET @cVERIFICACION = WSXML_SFG.SFGMAESTROFACTURACIONPDV_VerificarFacturacionAhora(@cFACTURAHOY__CODPERIODICIDAD,
																						@cFACTURAHOY__FECHA,
																						@cTODAY,
																						0,
																						0,
																						@cCODUSUARIOMODIFICACION);
					IF @cVERIFICACION = 'TRUE' BEGIN

					  IF @cFACTURAHOY__DEFECTO = 0 BEGIN
						-- Obtener todos los puntos de venta vinculados a esta facturacion
						INSERT INTO @tmpPUNTOSDEVENTA
						SELECT CODPUNTODEVENTA
						  FROM WSXML_SFG.PUNTODEVENTAFACTURACION
						 WHERE CODFACTURACIONLINEADENEGOCIO =
							   @cFACTURAHOY__ID_FACTURACIONLINEADENEGOCIO
						   AND ACTIVE = 1;
					  END
					  ELSE IF @cFACTURAHOY__DEFECTO = 1 BEGIN
						INSERT INTO @tmpPUNTOSDEVENTA
						SELECT ID_PUNTODEVENTA
						  FROM WSXML_SFG.PUNTODEVENTA PDV
						  LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTAFACTURACION
							ON (CODPUNTODEVENTA = ID_PUNTODEVENTA)
						 WHERE ID_PUNTODEVENTAFACTURACION IS NULL
						   AND PDV.ACTIVE = 1;
					  END 

					  IF (SELECT COUNT(*) FROM @tmpPUNTOSDEVENTA) > 0 BEGIN
						DECLARE tPDV CURSOR FOR SELECT IDVALUE FROM @tmpPUNTOSDEVENTA--.FIRST .. tmpPUNTOSDEVENTA.LAST 
						OPEN tPDV;

						DECLARE @tPDV__IDVALUE NUMERIC(38,0)
						 FETCH NEXT FROM tPDV INTO @tPDV__IDVALUE;
						 WHILE @@FETCH_STATUS=0
						 BEGIN
						  -- Buscar que no exista
							DECLARE @cEXISTS NUMERIC(22,0) = -1;
                  
							IF (SELECT COUNT(*) FROM @cPUNTOSDEVENTAFACTURACION) > 0 BEGIN
								DECLARE k CURSOR FOR SELECT CODPUNTODEVENTA, LINEASDENEGOCIO FROM @cPUNTOSDEVENTAFACTURACION
								OPEN k;
						
								DECLARE @k__CODPUNTODEVENTA NUMERIC(38,0), @k__LINEASDENEGOCIO VARCHAR(MAX)
								FETCH NEXT FROM K into @k__CODPUNTODEVENTA, @k__LINEASDENEGOCIO;
						
								WHILE @@FETCH_STATUS=0
								BEGIN
								IF @k__CODPUNTODEVENTA = @tPDV__IDVALUE
									SET @cEXISTS = @k__CODPUNTODEVENTA;

								FETCH NEXT FROM  k INTO @k__CODPUNTODEVENTA;
								END
								CLOSE k;
								DEALLOCATE k;
								IF @cEXISTS >= 0
									BREAK;
							  --END WHILE 1=1 BEGIN;
							  END 

							  IF @cEXISTS < 0 BEGIN
								--cPUNTOSDEVENTAFACTURACION.EXTEND;

								INSERT INTO @cPDVLINEASDENEGOCIO VALUES (@k__CODPUNTODEVENTA, @cFACTURAHOY__CODLINEADENEGOCIO)
								--cPUNTOSDEVENTAFACTURACION(cPUNTOSDEVENTAFACTURACION.LAST) := PDVLDNFACTURACION(tmpPUNTOSDEVENTA(tPDV), NUMBERARRAY(tFACTLDN.CODLINEADENEGOCIO));

							  END ELSE BEGIN
								--cPUNTOSDEVENTAFACTURACION(@cEXISTS).LINEASDENEGOCIO.EXTEND;
								UPDATE @cPDVLINEASDENEGOCIO SET VALUE =  @cFACTURAHOY__CODLINEADENEGOCIO WHERE ID = @cEXISTS AND VALUE = @k__LINEASDENEGOCIO
							  END
							  SET @cTOTALREGISTROS = @cTOTALREGISTROS + 1;
						  FETCH NEXT FROM tPDV INTO @tPDV__IDVALUE;
						  END;

						 CLOSE tPDV;
						 DEALLOCATE tPDV;
						--END WHILE 1=1 BEGIN;
					   END
					END
				  END;
					FETCH NEXT FROM cFACTURAHOY INTO @cFACTURAHOY__ID_FACTURACIONLINEADENEGOCIO,  @cFACTURAHOY__CODLINEADENEGOCIO, @cFACTURAHOY__CODPERIODICIDAD,
						 @cFACTURAHOY__FECHA, @cFACTURAHOY__DEFECTO
				 END --WHILE 1=1 BEGIN;
				 CLOSE cFACTURAHOY;
				 DEALLOCATE cFACTURAHOY;
			 END TRY
			 BEGIN CATCH

				RAISERROR('-20054 No se pudo obtener la lista de puntos de venta a facturar', 16, 1);
			 END CATCH
		  END;


		  -- Configuraciones de descuentos de comision
		  BEGIN
			BEGIN TRY
				INSERT INTO @cDESCUENTOSCOMISION 
				SELECT * FROM WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRedDistribucionDescuentos()
			END TRY
			BEGIN CATCH
				  SET @msg = 'Descuentos de comision: ' + isnull(ERROR_MESSAGE ( ) , '');
				  EXEC WSXML_SFG.SFGTMPTRACE_TraceLog  @msg
				  --SET @cDESCUENTOSCOMISION = REDDESCUENTOS();
			END CATCH
		  END;


		  -- Conteo de total registros
		  EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_CODDETALLETAREAEJECUTADA,@cTOTALREGISTROS
		  COMMIT;

		  -- Despues de obtener la lista, iterar
		  IF (SELECT COUNT(*) FROM @cPDVLINEASDENEGOCIO) > 0 BEGIN
			-- Obtener las lineas de negocio como indice y como ID, configuracion de egreso como value
			INSERT INTO @xLINEACONFIGURACION
			SELECT ID_LINEADENEGOCIO, LINEAEGRESO --IDVALUE          
			  FROM (SELECT ID_LINEADENEGOCIO, LINEAEGRESO, ROW_NUMBER() OVER(ORDER BY ID_LINEADENEGOCIO) AS Row
					  FROM WSXML_SFG.LINEADENEGOCIO
					 ) T
			IF @@ROWCOUNT <= 0 BEGIN
			  RAISERROR('-20020 No se pudo obtener la configuracion de ingresos y egresos para las lineas de negocio', 16, 1);
			END 
			DECLARE tPDVLDN CURSOR FOR SELECT DISTINCT ID AS CODPUNTODEVENTA/*, VALUE AS LINEASDENEGOCIO*/ FROM @cPDVLINEASDENEGOCIO--.First .. cPUNTOSDEVENTAFACTURACION.Last 
			OPEN tPDVLDN;

			DECLARE @tPDVLDN__CODPUNTODEVENTA NUMERIC(38,0), @tPDVLDN__LINEASDENEGOCIO NUMERIC(38,0)

			 FETCH NEXT FROM tPDVLDN INTO @tPDVLDN__CODPUNTODEVENTA, @tPDVLDN__LINEASDENEGOCIO;
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				BEGIN TRY
					DECLARE @xCODPUNTODEVENTA           NUMERIC(38,0) = @tPDVLDN__CODPUNTODEVENTA;
					DECLARE @xCODMAESTROFACTURATIRILLA  NUMERIC(22,0);
					DECLARE @cCODTIPOAGRUPACION         NUMERIC(22,0);
					DECLARE @cCODAGRUPACIONPUNTODEVENTA NUMERIC(22,0);
					DECLARE @cListaReferencia           WSXML_SFG.REFERENCEBILLING;
			
					BEGIN
					--SET @cListaReferencia = REFERENCEBILLINGLIST();
					EXEC WSXML_SFG.SFGMAESTROFACTURACIONTIRILLA_AddRecord @cCODCICLOFACTURACION,
														   @xCODPUNTODEVENTA,
														   @xCODMAESTROFACTURATIRILLA OUT
					-- Obtener Tipo Agrupamiento y Agrupacion
					SELECT @cCODTIPOAGRUPACION = CODTIPOPUNTODEVENTA, @cCODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA
					  FROM WSXML_SFG.PUNTODEVENTA
						INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA
						ON (CODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA)
					 WHERE ID_PUNTODEVENTA = @xCODPUNTODEVENTA;

					-- Iterar a traves de las lineas de negocio que facturan este dia para el punto de venta
					DECLARE tLDN CURSOR FOR SELECT VALUE AS LINEASDENEGOCIO FROM @cPDVLINEASDENEGOCIO WHERE ID = @tPDVLDN__CODPUNTODEVENTA
					OPEN tLDN
					DECLARE @tLDN__LINEASDENEGOCIO NUMERIC(38,0)
					FETCH NEXT FROM tLDN INTO @tLDN__LINEASDENEGOCIO
					WHILE (@@FETCH_STATUS = 0)
					BEGIN
					  /* COMMIT SECTION */
						DECLARE @xCODLINEADENEGOCIO     NUMERIC(22,0) = @tLDN__LINEASDENEGOCIO
						DECLARE @cCODMAESTROFACTURACION NUMERIC(38,0) = 0;
						DECLARE @cCODFACTURACIONPDV     NUMERIC(38,0) = 0;
						DECLARE @cCOUNTFACTURABLES      NUMERIC(38,0) = 0;
						-- Obtiene la lista de registros a facturar una sola vez
						DECLARE @lstREGISTROSFACTURABLES WSXML_SFG.REGISTROFACTURABLE;
						DECLARE @lstREGISTROSAGRUPADOS   WSXML_SFG.IDVALUENUMERIC--WSXML_SFG.REGISTROSPRODUCTO--WSXML_SFG.REGISTROSLINEADENEGOCIO;
						BEGIN

							BEGIN TRY

								BEGIN
									BEGIN TRY
									  INSERT INTO @lstREGISTROSFACTURABLES
									  SELECT ID_REGISTROFACTURACION,CODPRODUCTO
									  FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
										INNER JOIN WSXML_SFG.REGISTROFACTURACION REG
										  ON (REG.CODENTRADAARCHIVOCONTROL =
											 CTR.ID_ENTRADAARCHIVOCONTROL)
									   INNER JOIN WSXML_SFG.PRODUCTO PRD
										  ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
									   INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
										  ON (TPR.ID_TIPOPRODUCTO = PRD.CODTIPOPRODUCTO)
									   WHERE CTR.ID_ENTRADAARCHIVOCONTROL IN
											 (SELECT IDVALUE FROM @BillingFiles)
										 AND REG.CODPUNTODEVENTA = @xCODPUNTODEVENTA
										 AND TPR.CODLINEADENEGOCIO = @xCODLINEADENEGOCIO
										 AND REG.FACTURADO = 0;
									END TRY
									BEGIN CATCH
										SET @msg = '-20054 Error al obtener los identificadores de los registros facturados: ' + isnull(ERROR_MESSAGE ( ) , '')
										RAISERROR(@msg, 16, 1);
									END CATCH
								END;

								-- No facturar si no hay registros facturables
								SELECT @cCOUNTFACTURABLES = COUNT(*) FROM @lstREGISTROSFACTURABLES
								IF @cCOUNTFACTURABLES > 0 BEGIN
								  -- Agrupar la lista obtenida por producto
								  --SET @lstREGISTROSAGRUPADOS = REGISTROSLINEADENEGOCIO();
								  DECLARE reg CURSOR FOR SELECT ID_REGISTROFACTURACION,CODPRODUCTO FROM @lstREGISTROSFACTURABLES--.First .. lstREGISTROSFACTURABLES.Last 
								  OPEN reg;
								  DECLARE @reg__ID_REGISTROFACTURACION NUMERIC(38,0),@reg__CODPRODUCTO NUMERIC(38,0)
								FETCH NEXT FROM reg INTO @reg__ID_REGISTROFACTURACION,@reg__CODPRODUCTO;
								WHILE @@FETCH_STATUS=0
								BEGIN
									  DECLARE @regIDREGISTRO  NUMERIC(38,0) = @reg__ID_REGISTROFACTURACION
									  DECLARE @regCODPRODUCTO NUMERIC(38,0) = @reg__CODPRODUCTO
									  DECLARE @prdFOUND       NUMERIC(38,0) = 0;
									BEGIN
									  -- Buscar
									  IF (SELECT COUNT(*) FROM @lstREGISTROSAGRUPADOS) > 0 BEGIN
										DECLARE grup CURSOR FOR SELECT ID AS CODPRODUCTO, VALUE AS IDREGISTRO FROM @lstREGISTROSAGRUPADOS--.First .. lstREGISTROSAGRUPADOS.Last 
										OPEN grup;
										DECLARE @grup__CODPRODUCTO NUMERIC(38,0), @grup__IDREGISTRO NUMERIC(38,0)
										 FETCH NEXT FROM grup INTO @grup__CODPRODUCTO, @grup__IDREGISTRO;
										 WHILE @@FETCH_STATUS=0
										 BEGIN
											  IF @grup__CODPRODUCTO = @regCODPRODUCTO BEGIN
													INSERT INTO @lstREGISTROSAGRUPADOS VALUES(@grup__CODPRODUCTO, @regIDREGISTRO);
													SET @prdFOUND = 1;
												BREAK;
											   END
						  
											FETCH NEXT FROM grup INTO @grup__CODPRODUCTO, @grup__IDREGISTRO;
										  END
										  CLOSE grup;
										  DEALLOCATE grup;

										--END WHILE 1=1 BEGIN;
									  END
									  -- Si no se encontro
									  IF @prdFOUND = 0 BEGIN
										DECLARE @lstREGISTROSNEWPRODUCTO WSXML_SFG.LONGNUMBERARRAY;
										BEGIN
										  --SET @lstREGISTROSNEWPRODUCTO = LONGNUMBERARRAY();
										  --lstREGISTROSNEWPRODUCTO.Extend(1);
										  ----lstREGISTROSNEWPRODUCTO(lstREGISTROSNEWPRODUCTO.Count) := @regIDREGISTRO;

										  --lstREGISTROSAGRUPADOS.Extend(1);
										  INSERT INTO @lstREGISTROSAGRUPADOS VALUES (@regCODPRODUCTO, @regIDREGISTRO);
										END;
									  END
					   
									END;

									FETCH NEXT FROM reg INTO @reg__ID_REGISTROFACTURACION,@reg__CODPRODUCTO;
								  END;

								CLOSE reg;
								DEALLOCATE reg;

								  -- Control de reintentos
								  DECLARE @xLINEAEGRESO NUMERIC(38,0)
								  SELECT @xLINEAEGRESO = VALUE FROM @xLINEACONFIGURACION WHERE ID = @xCODLINEADENEGOCIO

								  EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarPOSLDN 
																		 @cCODCICLOFACTURACION,
																		  @xCODMAESTROFACTURATIRILLA,
																		  @xCODPUNTODEVENTA,
																		  @cCODTIPOAGRUPACION,
																		  @cCODAGRUPACIONPUNTODEVENTA,
																		  @xCODLINEADENEGOCIO,
																		  @cTODAY,
																		  @lstREGISTROSAGRUPADOS,
																		  @xLINEAEGRESO,
																		  @cCODUSUARIOMODIFICACION,
																		  @cCODMAESTROFACTURACION OUT
								END
								ELSE BEGIN
								  EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarEmptyPOSLDN 
																			   @cCODCICLOFACTURACION,
																			   @xCODMAESTROFACTURATIRILLA,
																			   @xCODPUNTODEVENTA,
																			   @cCODTIPOAGRUPACION,
																			   @cCODAGRUPACIONPUNTODEVENTA,
																			   @xCODLINEADENEGOCIO,
																			   @cTODAY,
																			   @cCODUSUARIOMODIFICACION,
																			   @cCODMAESTROFACTURACION OUT
								END 
								-- Actualizar facturacion actual
								EXEC WSXML_SFG.SFGFACTURACIONPDV_SetCodFacturacionActualPDV @xCODPUNTODEVENTA,
																			 @xCODLINEADENEGOCIO,
																			 cCODMAESTROFACTURACION,
																			 @cCODUSUARIOMODIFICACION,
																			 @cCODFACTURACIONPDV OUT
								-- Ingresar a la lista referenciada
								--cListaReferencia.Extend(1);
								INSERT INTO @cListaReferencia VALUES(@xCODLINEADENEGOCIO, @cCODMAESTROFACTURACION);
								COMMIT;

								-- Actualizar la tarea
								SET @cCOUNTREGISTROS = @cCOUNTREGISTROS + 1;
								IF (@cCOUNTREGISTROS % @cWAITREGISTROS) = 0 OR
								   @cCOUNTREGISTROS = @cTOTALREGISTROS BEGIN
									EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_CODDETALLETAREAEJECUTADA, @cCOUNTREGISTROS
								END 
							 END TRY
							 BEGIN CATCH
								  -- Hubo un error al intentar procesar una entrada
								  SET @msg = 'No se pudo realizar la facturacion de ' +
														  ISNULL(WSXML_SFG.LINEADENEGOCIO_NOMBRE_F(@xCODLINEADENEGOCIO), '') +
														  ' para el punto de venta ' +
														  ISNULL(WSXML_SFG.PUNTODEVENTA_CODIGO_F(@xCODPUNTODEVENTA), '');
								  DECLARE @errormsg VARCHAR(2000)= ERROR_MESSAGE ( ) 
								  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta_1 @TIPOADVERTENCIA,
														  'FACTURACION',
														  @msg,
														  @errormsg ,
														  @cCODUSUARIOMODIFICACION
								  SET @cTOTALWARNINGS = @cTOTALWARNINGS + 1;
								  COMMIT;
								  IF @cTOTALWARNINGS >= @cMAXWARNINGS BEGIN
									RAISERROR('-20054 Se ha llegado al maximo numero de advertencias para el ciclo de facturacion', 16, 1);
								  END
							  END CATCH
				   
						  END;
						FETCH NEXT FROM tLDN INTO @tLDN__LINEASDENEGOCIO
					END;

					CLOSE tLDN;
					DEALLOCATE tLDN;
				  END;

					-- Al final, consolidar descuentos de comision
					DECLARE @thisconfiguration VARCHAR(MAX)--WSXML_SFG.DESCUENTOSLIST;
					BEGIN
						BEGIN TRY
							SELECT @thisconfiguration = CONFIGURACION
							FROM @cDESCUENTOSCOMISION
							WHERE CODPUNTODEVENTA = @xCODPUNTODEVENTA;
							-- thisconfiguration is never empty, due to condition in SFGPUNTODEVENTADESCOMISION.GetRedDistribucionDescuentos
							DECLARE conf CURSOR FOR SELECT VALUE FROM string_split(@thisconfiguration,'|')--.First .. thisconfiguration.Last 
							OPEN conf;

							DECLARE @conf__VALUE VARCHAR(MAX)
							DECLARE @conf_CODLINEADENEGOCIO NUMERIC(38,0), @conf_CODLINEADENEGOCIODESCUENTO NUMERIC(38,0)
							FETCH NEXT FROM conf INTO @conf__VALUE;
							WHILE @@FETCH_STATUS=0
							BEGIN

								SET @conf_CODLINEADENEGOCIO = dbo.SEPARAR_COLUMNAS_F(@conf__VALUE,1,',')
								SET @conf_CODLINEADENEGOCIODESCUENTO = dbo.SEPARAR_COLUMNAS_F(@conf__VALUE,2,',')
					
								-- Actua solo si no es uno de uno
								IF @conf_CODLINEADENEGOCIO <> @conf_CODLINEADENEGOCIODESCUENTO BEGIN
							  -- Obtener internamente los valores, dado que el ciclo como tal puede disminuir el valor
								DECLARE @xmasterLINEA          NUMERIC(22,0);
								DECLARE @xmasterDESCUENTO      NUMERIC(22,0);
								DECLARE @xVALORCOMISION        FLOAT;
								DECLARE @xVALORAPAGARLINEA     FLOAT;
								DECLARE @xVALORAPAGARDESCUENTO FLOAT;
							  BEGIN
								-- Obtener valores de referencia
								SELECT @xmasterLINEA = CODMAESTROFACTURACIONPDV
								  FROM @cListaReferencia
								 WHERE CODLINEADENEGOCIO = @conf_CODLINEADENEGOCIO;
								SELECT @xmasterDESCUENTO = CODMAESTROFACTURACIONPDV
								  FROM @cListaReferencia
								 WHERE CODLINEADENEGOCIO = @conf_CODLINEADENEGOCIODESCUENTO
								-- Obtener valores de tabla de referencia, solo GTECH
								SELECT @xVALORCOMISION = TOTALCOMISION,
									   @xVALORAPAGARLINEA = (NUEVOSALDOENCONTRAGTECH - NUEVOSALDOAFAVORGTECH)
								  FROM WSXML_SFG.MAESTROFACTURACIONPDV
								 WHERE ID_MAESTROFACTURACIONPDV = @xmasterLINEA;
								SELECT @xVALORAPAGARDESCUENTO = NUEVOSALDOENCONTRAGTECH - NUEVOSALDOAFAVORGTECH
								  FROM WSXML_SFG.MAESTROFACTURACIONPDV
								 WHERE ID_MAESTROFACTURACIONPDV = @xmasterDESCUENTO;
								-- Descontar sin considerar valores

								EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReintegrarComisionATotal
														@xmasterLINEA,
														 @xVALORAPAGARLINEA,
														 @xVALORCOMISION,
														 @conf_CODLINEADENEGOCIODESCUENTO
								EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_DescontarComisionATotal @xmasterDESCUENTO,
														@xVALORAPAGARDESCUENTO,
														@xVALORCOMISION
							  END;
							END

								FETCH NEXT FROM conf INTO @conf__VALUE;
							END
							CLOSE conf;
							DEALLOCATE conf;

							IF @@ROWCOUNT = 0  -- No se pudo obtener los datos de configuracion. No mover
								SELECT NULL

							--END WHILE 1=1 BEGIN;
						END TRY
						BEGIN CATCH
								SET @msg = '-20085 No se pudo descontar las comisiones de acuerdo a la configuracion: ' + isnull(ERROR_MESSAGE ( ) , '')
								RAISERROR(@msg, 16, 1);
						END CATCH
					END;

				END TRY
				BEGIN CATCH
					  -- Hubo un error al intentar procesar una entrada
					  SET @msg = 'No se pudo realizar la facturacion para el punto de venta ' +
											  ISNULL(WSXML_SFG.PUNTODEVENTA_CODIGO_F(@xCODPUNTODEVENTA), '');
					  SET @errormsg = ERROR_MESSAGE ( ) 
					  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta_1
											 @TIPOADVERTENCIA,
											  'FACTURACION',
											  @msg,
											  @errormsg,
											  @cCODUSUARIOMODIFICACION

					  SET @cTOTALWARNINGS = @cTOTALWARNINGS + 1;
					  COMMIT;
					  IF @cTOTALWARNINGS >= @cMAXWARNINGS BEGIN
						RAISERROR('-20054 Se ha llegado al maximo numero de advertencias para el ciclo de facturacion', 16, 1);
					  END 
				END CATCH
				FETCH NEXT FROM tPDVLDN INTO @tPDVLDN__CODPUNTODEVENTA, @tPDVLDN__LINEASDENEGOCIO;
			  END;
			  CLOSE tPDVLDN;
			  DEALLOCATE tPDVLDN; 

        
		  END ELSE BEGIN
			-- Se ejecuto un ciclo de facturacion que no tiene puntos de venta relevantes. Advertir
			SET @errormsg = 'Se ha ejecutado un ciclo de facturacion, pero no existen puntos de venta configurados para facturar en la fecha ' +
									ISNULL(FORMAT(@p_FECHAFACTURACION, 'dd/MM/yyyy'), '')
			EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @TIPOADVERTENCIA,
									'FACTURACION',
									@errormsg,
									@cCODUSUARIOMODIFICACION
		  END

		  IF @cTOTALWARNINGS > 0 AND @cTOTALWARNINGS >= @cTOTALREGISTROS BEGIN
			SET @p_RETVALUE_out = @FINALIZADAFALLO;
		  END ELSE IF @cTOTALWARNINGS > 0 AND @cTOTALWARNINGS < @cTOTALREGISTROS BEGIN
			SET @p_RETVALUE_out = @FINALIZADAADVERTENCIA;
			  DECLARE @endmsg NVARCHAR(2000);
			BEGIN
			  SELECT @endmsg = ISNULL(ISNULL(@msg, ': ' + isnull(@msg, '')), '.');
			  SET @msg = 'El ciclo de facturacion No. ' +
														 ISNULL(@cSECUENCIACICLO, '') +
														 ' ha finalizado correctamente. Sin embargo, ocurrieron algunos errores controlados' +
														 isnull(@endmsg, '')
			  EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution 
														@p_CODDETALLETAREAEJECUTADA,
														@msg
			END;

		  END ELSE BEGIN
			SET @p_RETVALUE_out = @FINALIZADAOK;
			SET @msg = 'El ciclo de facturacion No. ' +
													   ISNULL(@cSECUENCIACICLO, '') +
													   ' ha finalizado correctamente.'
			EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution 
														@p_CODDETALLETAREAEJECUTADA,
													   @msg
		  END

     
      
		  EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_SetFlagNotificacion @cCODCICLOFACTURACION, 1
		  EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_FreeProcessFlag @cCODCICLOFACTURACION

		  -- Actualizacion Ciclo en la base de datos de Diferidos
		  /*BEGIN
			SFGMAESTROFACTURACIONDIFERIDOS.ActuDiferidosCicloFacturacion(cCODCICLOFACTURACION,
																		 cSECUENCIACICLO,
																		 cTODAY);
		  END;
	GO*/

		END
		ELSE BEGIN
		  RAISERROR('-20054 Ocurrio un error al tratar de ingresar el registro de ciclo de facturacion', 16, 1);
		END 

		--REDONDEO DE CIFRAS PARA REPORTES
		update WSXML_SFG.maestrofacturacionpdv
		   set NUEVOSALDOENCONTRAGTECH      = round(NUEVOSALDOENCONTRAGTECH, 2),
			   NUEVOSALDOENCONTRAFIDUCIA    = round(NUEVOSALDOENCONTRAFIDUCIA, 2),
			   NUEVOSALDOAFAVORGTECH        = round(NUEVOSALDOAFAVORGTECH, 2),
			   NUEVOSALDOAFAVORFIDUCIA      = round(NUEVOSALDOAFAVORFIDUCIA, 2),
			   SALDOANTERIORENCONTRAGTECH   = round(SALDOANTERIORENCONTRAGTECH,
													2),
			   SALDOANTERIORENCONTRAFIDUCIA = round(SALDOANTERIORENCONTRAFIDUCIA,
													2),
			   SALDOANTERIORAFAVORGTECH     = round(SALDOANTERIORAFAVORGTECH, 2),
			   SALDOANTERIORAFAVORFIDUCIA   = round(SALDOANTERIORAFAVORFIDUCIA,
													2),
			   TOTALCOMISION                = round(TOTALCOMISION, 2)
		 where codciclofacturacionpdv = WSXML_SFG.ultimo_ciclofacturacion(getdate());

		--REDONDEO DE CIFRAS PARA REPORTES
		update WSXML_SFG.detallesaldopdv
		   set SALDOAFAVORGTECH   = round(SALDOAFAVORGTECH, 2),
			   SALDOAFAVORFIDUCIA = round(SALDOAFAVORFIDUCIA, 2),
			   SALDOCONTRAGTECH   = round(SALDOCONTRAGTECH, 2),
			   SALDOCONTRAFIDUCIA = round(SALDOCONTRAFIDUCIA, 2)
		 where id_detallesaldopdv in
			   (select id_detallesaldopdv
				  from WSXML_SFG.detallesaldopdv
				 inner join WSXML_SFG.maestrofacturacionpdv
					on detallesaldopdv.codmaestrofacturacionpdv =
					   maestrofacturacionpdv.id_maestrofacturacionpdv
				 where maestrofacturacionpdv.codciclofacturacionpdv =
					   WSXML_SFG.ultimo_ciclofacturacion(getdate()));

		--REDONDEO DE CIFRAS PARA REPORTES
		update WSXML_SFG.detallefacturacionpdv
		   set VALORCOMISION             = round(VALORCOMISION, 2),
			   AJUSTE                    = round(AJUSTE, 2),
			   VALORCOMISIONNETA         = round(VALORCOMISIONNETA, 2),
			   VALORVENTANETA            = round(VALORVENTANETA, 2),
			   NUEVOSALDOENCONTRAGTECH   = round(NUEVOSALDOENCONTRAGTECH, 2),
			   NUEVOSALDOENCONTRAFIDUCIA = round(NUEVOSALDOENCONTRAFIDUCIA, 2),
			   NUEVOSALDOAFAVORGTECH     = round(NUEVOSALDOAFAVORGTECH, 2),
			   NUEVOSALDOAFAVORFIDUCIA   = round(NUEVOSALDOAFAVORFIDUCIA, 2),
			   IVACOMISION               = round(IVACOMISION, 2),
			   VALORVENTABRUTA           = round(VALORVENTABRUTA, 2),
			   VALORCOMISIONBRUTA        = round(VALORCOMISIONBRUTA, 2)
		 where id_detallefacturacionpdv in
			   (select id_detallefacturacionpdv
				  from WSXML_SFG.detallefacturacionpdv
				 inner join WSXML_SFG.maestrofacturacionpdv
					on detallefacturacionpdv.codmaestrofacturacionpdv =
					   maestrofacturacionpdv.id_maestrofacturacionpdv
				 where maestrofacturacionpdv.codciclofacturacionpdv =
					   WSXML_SFG.ultimo_ciclofacturacion(getdate()));
	END TRY
	BEGIN CATCH

      IF @cCODCICLOFACTURACION > 0 BEGIN
        EXEC WSXML_SFG.SFGCICLOFACTURACIONPDV_FreeProcessFlag @cCODCICLOFACTURACION
      END 
      SET @msg = ERROR_MESSAGE ( ) ;
      EXEC WSXML_SFG.SFGALERTA_GenerarAlerta_1 @TIPOERROR,
                              'FACTURACION',
                              'Error inesperado en el ciclo',
                              @msg,
                              @cCODUSUARIOMODIFICACION
      EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
      SET @p_RETVALUE_out = @FINALIZADAFALLO;
	END CATCH
  END;
GO




  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_AddRecord(@p_CODCICLOFACTURACIONPDV       NUMERIC(22,0),
                      @p_CODMAESTROFACTURATIRILLA     NUMERIC(22,0),
                      @p_CODMAESTROFACTURACIONCOMPCO2 NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO            NUMERIC(22,0),
                      @p_CODPUNTODEVENTA              NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_MAESTROFACTURACIONPDV_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @codEXISTINGMASTER NUMERIC(22,0);
   DECLARE @msg VARCHAR(2000)
  SET NOCOUNT ON;
    BEGIN
      SELECT @codEXISTINGMASTER = ID_MAESTROFACTURACIONPDV
        FROM WSXML_SFG.MAESTROFACTURACIONPDV
       WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
         AND CODPUNTODEVENTA = @p_CODPUNTODEVENTA
         AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
      IF @codEXISTINGMASTER > 0 BEGIN
        SET @p_ID_MAESTROFACTURACIONPDV_out = @codEXISTINGMASTER;
		SET @msg = 'Existing master: ' + ISNULL(@codEXISTINGMASTER, '') +
                             '. It will be cleaned. This is an error in billing cycle'
        EXEC WSXML_SFG.SFGTMPTRACE_TRACELOG  @msg
      END 
		IF @@ROWCOUNT = 0 BEGIN
        INSERT INTO WSXML_SFG.MAESTROFACTURACIONPDV
          (
           CODMAESTROFACTURACIONTIRILLA,
           CODCICLOFACTURACIONPDV,
           CODMAESTROFACTURACIONCOMPCONSI,
           CODLINEADENEGOCIO,
           CODLINEADENEGOCIODESCUENTO,
           CODPUNTODEVENTA,
           CODUSUARIOMODIFICACION)
        VALUES
          (
           @p_CODMAESTROFACTURATIRILLA,
           @p_CODCICLOFACTURACIONPDV,
           @p_CODMAESTROFACTURACIONCOMPCO2,
           @p_CODLINEADENEGOCIO,
           @p_CODLINEADENEGOCIO,
           @p_CODPUNTODEVENTA,
           @p_CODUSUARIOMODIFICACION);
        SET @p_ID_MAESTROFACTURACIONPDV_out = SCOPE_IDENTITY();
	END
    END;
  END;
GO




  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_ActualizarValoresPago', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ActualizarValoresPago;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ActualizarValoresPago(@pk_ID_MAESTROFACTURACIONPDV    NUMERIC(22,0),
                                  @p_SALDOANTERIORENCONTRAGTECH   FLOAT,
                                  @p_SALDOANTERIORENCONTRAFIDUCIA FLOAT,
                                  @p_SALDOANTERIORAFAVORGTECH     FLOAT,
                                  @p_SALDOANTERIORAFAVORFIDUCIA   FLOAT,
                                  @p_NUEVOSALDOENCONTRAGTECH      FLOAT,
                                  @p_NUEVOSALDOENCONTRAFIDUCIA    FLOAT,
                                  @p_NUEVOSALDOAFAVORGTECH        FLOAT,
                                  @p_NUEVOSALDOAFAVORFIDUCIA      FLOAT,
                                  @p_TOTALCOMISION                FLOAT,
                                  @p_CODUSUARIOMODIFICACION       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.MAESTROFACTURACIONPDV
       SET SALDOANTERIORENCONTRAGTECH   = @p_SALDOANTERIORENCONTRAGTECH,
           SALDOANTERIORENCONTRAFIDUCIA = @p_SALDOANTERIORENCONTRAFIDUCIA,
           SALDOANTERIORAFAVORGTECH     = @p_SALDOANTERIORAFAVORGTECH,
           SALDOANTERIORAFAVORFIDUCIA   = @p_SALDOANTERIORAFAVORFIDUCIA,
           NUEVOSALDOENCONTRAGTECH      = @p_NUEVOSALDOENCONTRAGTECH,
           NUEVOSALDOENCONTRAFIDUCIA    = @p_NUEVOSALDOENCONTRAFIDUCIA,
           NUEVOSALDOAFAVORGTECH        = @p_NUEVOSALDOAFAVORGTECH,
           NUEVOSALDOAFAVORFIDUCIA      = @p_NUEVOSALDOAFAVORFIDUCIA,
           TOTALCOMISION                = @p_TOTALCOMISION,
           PAGOCOMPLETOGTECH = CASE
                                 WHEN @p_NUEVOSALDOENCONTRAGTECH = 0 THEN
                                  1
                                 ELSE
                                  0
                               END,
           PAGOCOMPLETOFIDUCIA = CASE
                                   WHEN @p_NUEVOSALDOENCONTRAFIDUCIA = 0 THEN
                                    1
                                   ELSE
                                    0
                                 END,
           PAGOCOMPLETO = CASE
                            WHEN @p_NUEVOSALDOENCONTRAGTECH = 0 AND
                                 @p_NUEVOSALDOENCONTRAFIDUCIA = 0 THEN
                             1
                            ELSE
                             0
                          END,
           CODUSUARIOMODIFICACION       = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION        = GETDATE()
     WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;
  END;
GO





IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReadFlagNotificacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReadFlagNotificacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_ReadFlagNotificacion(@p_FLAGNOTIFICACION       NUMERIC(22,0),
                                 @p_CODCICLOFACTURACIONPDV NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
		SELECT @p_CODCICLOFACTURACIONPDV = ID_CICLOFACTURACIONPDV
		FROM WSXML_SFG.CICLOFACTURACIONPDV
		WHERE FLAGNOTIFICACION = @p_FLAGNOTIFICACION
			AND ACTIVE = 1;
	   
		IF @@ROWCOUNT = 0 BEGIN -- EXCEPTION WHEN NO_DATA_FOUND THEN
			 SET @p_CODCICLOFACTURACIONPDV = 0;
		END
		
		IF @@ROWCOUNT > 1 BEGIN -- EXCEPTION WHEN TOO_MANY_ROWS THEN
			SELECT @p_CODCICLOFACTURACIONPDV = MAX(ID_CICLOFACTURACIONPDV)
			FROM WSXML_SFG.CICLOFACTURACIONPDV
			WHERE FLAGNOTIFICACION = @p_FLAGNOTIFICACION
				AND ACTIVE = 1;
		END
		  
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONPDV_GetRecord(@pk_ID_MAESTROFACTURACIONPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*)
      FROM WSXML_SFG.MAESTROFACTURACIONPDV
     WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
		SELECT ID_MAESTROFACTURACIONPDV,
             CODCICLOFACTURACIONPDV,
             CODMAESTROFACTURACIONCOMPCONSI,
             CODPUNTODEVENTA,
             CODLINEADENEGOCIO,
             SALDOANTERIORENCONTRAGTECH,
             SALDOANTERIORENCONTRAFIDUCIA,
             SALDOANTERIORAFAVORGTECH,
             SALDOANTERIORAFAVORFIDUCIA,
             NUEVOSALDOENCONTRAGTECH,
             NUEVOSALDOENCONTRAFIDUCIA,
             NUEVOSALDOAFAVORGTECH,
             NUEVOSALDOAFAVORFIDUCIA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.MAESTROFACTURACIONPDV
       WHERE ID_MAESTROFACTURACIONPDV = @pk_ID_MAESTROFACTURACIONPDV;
	
  END;
GO