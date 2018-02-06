USE SFGPRODU;
--  DDL for Package Body SFGSYNC_SALDOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGSYNC_SALDOS */ 

  IF OBJECT_ID('WSXML_SFG.SFGSYNC_SALDOS_SetSaldoFinal', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSYNC_SALDOS_SetSaldoFinal;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSYNC_SALDOS_SetSaldoFinal(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                          @p_CODPUNTODEVENTA        NUMERIC(22,0),
                          @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                          @p_SALDOGTECH             FLOAT,
                          @p_SALDOFIDUCIA           FLOAT,
                          @p_CODDETALLESALDOPDV_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xCycleCheck          NUMERIC(22,0);
    DECLARE @xCycleExecutionDate  DATETIME;
    DECLARE @xAgentCheck          NUMERIC(22,0);
    DECLARE @xAgentActiveState    NUMERIC(22,0);
    DECLARE @xCURRENTBALANCEGTECH FLOAT;
    DECLARE @xCURRENTBALANCEFDCIA FLOAT;
    DECLARE @xOrigenAjusteSaldos  NUMERIC(22,0) = 18;
    DECLARE @cout                 NUMERIC(22,0);
	DECLARE @xValorAjuste FLOAT
    DECLARE @msg VARCHAR(2000)
  SET NOCOUNT ON;

  BEGIN TRY
    SET @p_CODDETALLESALDOPDV_out = 0;
    BEGIN
      SELECT @p_CODDETALLESALDOPDV_out = DSP.ID_DETALLESALDOPDV, @xCURRENTBALANCEGTECH = (DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH), @xCURRENTBALANCEFDCIA = (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA)
      FROM WSXML_SFG.MAESTROFACTURACIONPDV MFP
      INNER JOIN DETALLESALDOPDV DSP ON (DSP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
      WHERE MFP.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
        AND MFP.CODPUNTODEVENTA        = @p_CODPUNTODEVENTA
        AND MFP.CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO;
		IF @@ROWCOUNT = 0
			  -- Consideracion de verificacion solo si el saldo es distinto de cero
			  IF @p_SALDOGTECH <> 0 OR @p_SALDOFIDUCIA <> 0 BEGIN
				-- El ciclo de facturacion debe existir. If not, RAISE NO_DATA_FOUND
				SELECT @xCycleCheck = ID_CICLOFACTURACIONPDV, @xCycleExecutionDate = FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
				-- El punto de venta debe existir, If not, RAISE NO_DATA_FOUND
				SELECT @xAgentCheck = ID_PUNTODEVENTA, @xAgentActiveState = ACTIVE FROM WSXML_SFG.PUNTODEVENTA WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
				IF @xAgentActiveState = 1 BEGIN
				  -- Create Empty Billing Registry. Case of an agent inserted during a week
					DECLARE @xMAESTROFACTURACIONTIRILLA NUMERIC(22,0);
					DECLARE @xCODTIPOAGRUPACION         NUMERIC(22,0);
					DECLARE @xCODAGRUPACIONPUNTODEVENTA NUMERIC(22,0);
					DECLARE @xRegistryBillingID         NUMERIC(22,0);
				  BEGIN
					EXEC WSXML_SFG.SFGMAESTROFACTURACIONTIRILLA_AddRecord @p_CODCICLOFACTURACIONPDV, @p_CODPUNTODEVENTA, @xMAESTROFACTURACIONTIRILLA OUT
					-- Obtener Tipo Agrupamiento y Agrupacion
					SELECT @xCODTIPOAGRUPACION = CODTIPOPUNTODEVENTA, @xCODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA FROM WSXML_SFG.PUNTODEVENTA
					INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON (CODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA)
					WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
					EXEC WSXML_SFG.SFGMAESTROFACTURACIONPDV_FacturarEmptyPOSLDN  @p_CODCICLOFACTURACIONPDV,
																 @xMAESTROFACTURACIONTIRILLA,
																 @p_CODPUNTODEVENTA,
																 @xCODTIPOAGRUPACION,
																 @xCODAGRUPACIONPUNTODEVENTA,
																 @p_CODLINEADENEGOCIO,
																 @xCycleExecutionDate,
																 1,
																 @xRegistryBillingID OUT
					SELECT @p_CODDETALLESALDOPDV_out = ID_DETALLESALDOPDV FROM WSXML_SFG.DETALLESALDOPDV WHERE CODMAESTROFACTURACIONPDV = @xRegistryBillingID;
				  END;
				END
				ELSE BEGIN
				  -- Agent is not active. Must either exist in InactiveBalances (update value), or be created
					DECLARE @xInactiveBalanceID NUMERIC(22,0);
				  BEGIN
					/*BEGIN
					  SELECT ID_SALDOINACTIVO INTO xInactiveBalanceID FROM SALDOINACTIVO
					  WHERE CODPUNTODEVENTA = p_CODPUNTODEVENTA AND CODLINEADENEGOCIO = p_CODLINEADENEGOCIO;
					EXCEPTION WHEN NO_DATA_FOUND THEN
					  INSERT INTO SALDOINACTIVO (ID_SALDOINACTIVO,
												 CODPUNTODEVENTA,
												 CODLINEADENEGOCIO,
												 FECHAINACTIVO,
												 SALDOAFAVORGTECH,
												 SALDOAFAVORFIDUCIA,
												 SALDOCONTRAGTECH,
												 SALDOCONTRAFIDUCIA)
					  VALUES (SALDOINACTIVO_SEQ.NextVal,
							  p_CODPUNTODEVENTA,
							  p_CODLINEADENEGOCIO,
							  SYSDATE, 0, 0, 0, 0)
					  RETURNING ID_SALDOINACTIVO INTO xInactiveBalanceID;
					END;
					-- Update Inactive Balance values
					UPDATE SALDOINACTIVO SET SALDOAFAVORGTECH   = CASE WHEN p_SALDOGTECH   <= 0 THEN ABS(p_SALDOGTECH)   ELSE 0 END,
											 SALDOAFAVORFIDUCIA = CASE WHEN p_SALDOFIDUCIA <= 0 THEN ABS(p_SALDOFIDUCIA) ELSE 0 END,
											 SALDOCONTRAGTECH   = CASE WHEN p_SALDOGTECH   >  0 THEN ABS(p_SALDOGTECH)   ELSE 0 END,
											 SALDOCONTRAFIDUCIA = CASE WHEN p_SALDOFIDUCIA >  0 THEN ABS(p_SALDOFIDUCIA) ELSE 0 END
					WHERE ID_SALDOINACTIVO = xInactiveBalanceID;*/
					EXEC WSXML_SFG.SFGSALDOINACTIVO_UpdateSaldoInactivo @p_CODPUNTODEVENTA, @p_CODLINEADENEGOCIO, @p_CODCICLOFACTURACIONPDV, @p_SALDOGTECH, @p_SALDOFIDUCIA, @xInactiveBalanceID
					-- No current balance will be updated
					SET @p_CODDETALLESALDOPDV_out = 0;
				  END;
				END 
			  END 
		
		END
    
    -- Actualizar Valores Mediante Ajustes. Solo si se encontro facturacion
    IF @p_CODDETALLESALDOPDV_out > 0 BEGIN

		DECLARE @FECHAHOY datetime = GETDATE();
      IF @p_SALDOGTECH <> isnull(@xCURRENTBALANCEGTECH,0) BEGIN
          SET  @xValorAjuste = 0;
        BEGIN
          SET @xValorAjuste = isnull(@xCURRENTBALANCEGTECH,0) - @p_SALDOGTECH;

		  SET @msg = 'Actualizacion automatica de saldos: ' + FORMAT(GETDATE(), 'dd/MM/yyyy HH:mm:ss')

          EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment @p_CODPUNTODEVENTA,
                                       @p_CODLINEADENEGOCIO,
                                       0,
                                       @xValorAjuste,
                                       @xOrigenAjusteSaldos,
                                       @msg,
                                       @FECHAHOY, 1, @cout OUT
        END;
      END 
      IF @p_SALDOFIDUCIA <> @xCURRENTBALANCEFDCIA BEGIN
          SET @xValorAjuste  = 0;
        BEGIN
          SET @xValorAjuste = @xCURRENTBALANCEFDCIA - @p_SALDOFIDUCIA;
		  SET @msg = 'Actualizacion automatica de saldos: ' + FORMAT(GETDATE(), 'dd/MM/yyyy HH:mm:ss')
          EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment @p_CODPUNTODEVENTA,
                                       @p_CODLINEADENEGOCIO,
                                       1,
                                       @xValorAjuste,
                                       @xOrigenAjusteSaldos,
                                       @msg,
                                       @FECHAHOY, 1, @cout OUT
        END;
      END 
    END 

	IF @@ROWCOUNT = 0 BEGIN
		SET @msg ='-20055 No es posible actualizar los saldos de un ciclo de facturaci?n que no existe. Ciclo ' + ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACTURACIONPDV), '') + ', Punto ' + ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '')  
		RAISERROR(@msg, 16, 1);
	END
  END TRY
  BEGIN CATCH
	SET @msg = 'Error al actualizar los saldos finales para los parametros ciclo= ' + ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACTURACIONPDV), '') + ', Punto =' + ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '') + ', Linea de negocio  =' + ISNULL(CONVERT(VARCHAR,@p_CODLINEADENEGOCIO), '') + ', Saldo Gtech  =' + ISNULL(CONVERT(VARCHAR,@p_SALDOGTECH), '') + ', Saldo fiducia  =' + ISNULL(CONVERT(VARCHAR,@p_SALDOFIDUCIA), '') + ' error: ' + ISNULL(ERROR_MESSAGE ( ), '')
    EXEC WSXML_SFG.sfgtmptrace_TraceLog @msg
	SET @msg = '-20055 Error al actualizar los saldos finales para los parametros ciclo= ' + ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACTURACIONPDV), '') + ', Punto =' + ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '') + ', Linea de negocio  =' + ISNULL(CONVERT(VARCHAR,@p_CODLINEADENEGOCIO), '') + ', Saldo Gtech  =' + ISNULL(CONVERT(VARCHAR,@p_SALDOGTECH), '') + ', Saldo fiducia  =' + ISNULL(CONVERT(VARCHAR,@p_SALDOFIDUCIA), '') + ' error: ' + ISNULL(ERROR_MESSAGE ( ), '') 
    RAISERROR(@msg, 16, 1);
  END CATCH
END

GO


