USE SFGPRODU;
--  DDL for Package Body SFGTRANSACCIONSINIDENTIFICAR
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR */ 

  IF OBJECT_ID('WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_AddRecord(@p_CODARCHIVOPAGO               NUMERIC(22,0),
                      @p_CODMOVIMIENTOBANCO           NUMERIC(22,0),
                      @p_FECHATRANSACCION             DATETIME,
                      @p_VALORTRANSACCION             FLOAT,
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_TRANSACCIONSINIDENTIF_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TRANSACCIONSINIDENTIFICAR (
                                           CODARCHIVOPAGO,
                                           CODMOVIMIENTOBANCO,
                                           FECHATRANSACCION,
                                           VALORTRANSACCION,
                                           CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODARCHIVOPAGO,
            @p_CODMOVIMIENTOBANCO,
            @p_FECHATRANSACCION,
            @p_VALORTRANSACCION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TRANSACCIONSINIDENTIF_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_UpdateRecord(@pk_ID_TRANSACCIONSINIDENTIFICA NUMERIC(22,0),
                         @p_CODARCHIVOPAGO               NUMERIC(22,0),
                         @p_CODMOVIMIENTOBANCO           NUMERIC(22,0),
                         @p_FECHATRANSACCION             DATETIME,
                         @p_VALORTRANSACCION             FLOAT,
                         @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                         @p_ACTIVE                       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.TRANSACCIONSINIDENTIFICAR
       SET CODARCHIVOPAGO         = @p_CODARCHIVOPAGO,
           CODMOVIMIENTOBANCO     = @p_CODMOVIMIENTOBANCO,
           FECHATRANSACCION       = @p_FECHATRANSACCION,
           VALORTRANSACCION       = @p_VALORTRANSACCION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
    WHERE ID_TRANSACCIONSINIDENTIFICAR = @pk_ID_TRANSACCIONSINIDENTIFICA;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_IdentifyRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_IdentifyRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_IdentifyRecord(@pk_ID_TRANSACCIONSINIDENTIFICA NUMERIC(22,0),
                           @p_CLASIFICACION                NUMERIC(22,0),
                           @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                           @p_RETVALUE_out                 NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @thisCODARCHIVOPAGO     NUMERIC(22,0);
    DECLARE @thisCODMOVIMIENTOBANCO NUMERIC(22,0);
    DECLARE @thisNOMMOVIMIENTOBANCO NUMERIC(22,0);
    DECLARE @thisCOUNTTRANSACCION   NUMERIC(22,0) = 1;
    DECLARE @thisFECHATRANSACCION   DATETIME;
    DECLARE @thisVALORTRANSACCION   FLOAT;
   
  SET NOCOUNT ON;


  DECLARE @SINCLASIFICAR smallint,@TRANSBANCARIA smallint, @PAGONOREFRNCD smallint;
  EXEC WSXML_SFG.SFGMOVIMIENTOBANCO_CONSTANT @SINCLASIFICAR OUT, @TRANSBANCARIA OUT, @PAGONOREFRNCD OUT


  DECLARE @p_REGISTRADA TINYINT ,@p_INICIADA  TINYINT , @p_FINALIZADAOK TINYINT , @p_FINALIZADAFALLO TINYINT , @p_ABORTADA  TINYINT ,@p_NOINICIADA  TINYINT ,@p_FINALIZADAADVERTENCIA  	TINYINT 
  EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT @p_REGISTRADA  OUT, @p_INICIADA OUT,@p_FINALIZADAOK OUT, @p_FINALIZADAFALLO  OUT, @p_ABORTADA  OUT, @p_NOINICIADA  OUT, @p_FINALIZADAADVERTENCIA OUT

    IF @p_CLASIFICACION = @TRANSBANCARIA OR @p_CLASIFICACION = @PAGONOREFRNCD BEGIN
      -- Obtener informacion
      SELECT @thisCODARCHIVOPAGO = CODARCHIVOPAGO, @thisCODMOVIMIENTOBANCO = CODMOVIMIENTOBANCO, @thisNOMMOVIMIENTOBANCO = NOMMOVIMIENTOBANCO, @thisFECHATRANSACCION = FECHATRANSACCION, @thisVALORTRANSACCION = VALORTRANSACCION
      FROM WSXML_SFG.TRANSACCIONSINIDENTIFICAR TSI
      INNER JOIN MOVIMIENTOBANCO MVB ON (MVB.ID_MOVIMIENTOBANCO = TSI.CODMOVIMIENTOBANCO)
      WHERE ID_TRANSACCIONSINIDENTIFICAR = @pk_ID_TRANSACCIONSINIDENTIFICA;
      -- De acuerdo a la clasificacion
      IF @p_CLASIFICACION = @TRANSBANCARIA BEGIN
        -- No Cartera
          DECLARE @coutCTRLTRANSACCION    NUMERIC(22,0);
          DECLARE @coutDETALLETRANSACCION NUMERIC(22,0);
        BEGIN
          EXEC WSXML_SFG.SFGCTRLTRANSACCION_AddRecord  @thisCODARCHIVOPAGO,
                                       @thisFECHATRANSACCION,
                                       @thisVALORTRANSACCION,
                                       @thisCOUNTTRANSACCION,
                                       @p_CODUSUARIOMODIFICACION,
                                       @coutCTRLTRANSACCION OUT
          EXEC WSXML_SFG.SFGDETALLETRANSACCION_AddDescriptiveRecord @coutCTRLTRANSACCION,
                                                     @thisCODMOVIMIENTOBANCO,
                                                     1,
                                                     @thisFECHATRANSACCION,
                                                     @thisVALORTRANSACCION,
                                                     @p_CODUSUARIOMODIFICACION,
                                                     @coutDETALLETRANSACCION OUT
        END;

      END
      ELSE IF @p_CLASIFICACION = @PAGONOREFRNCD BEGIN
        -- Cartera No Referenciado
          DECLARE @coutCTRLPAGO       NUMERIC(22,0);
          DECLARE @coutDETALLEPAGO    NUMERIC(22,0);
          DECLARE @coutMEDIOPAGONOREF NUMERIC(22,0);
        BEGIN

		DECLARE @Cheques      			TINYINT ,
                    @TransportadoraValores         			TINYINT,
                    @PagosAliadosEstrategicos 					TINYINT,
					@ReclamacionesBancarias      			TINYINT ,
                    @InformacionSebra         			TINYINT ,
                    @PagosDirectosGTECH 					TINYINT ,
					@TitulosValor      			TINYINT ,
                    @CrucesLiquidacionAliado         			TINYINT ,
                    @DirectoLineaCredito 					TINYINT 	,				
					@RecibidosFiduciaria      			TINYINT ,
                    @ReclasificacionCuenta         			TINYINT ,
                    @ErroresManuales 					TINYINT ,
					@ErroresBancarios      			TINYINT ,
                    @PagosBancos         			TINYINT ,
                    @ETESA 					TINYINT ,
					@IdentificacionTransaccion      			TINYINT ,
                    @DistribucionSaldosAgrupa         			TINYINT;	

		EXEC WSXML_SFG.SFGORIGENPAGO_CONSTANT 
					@Cheques      			 OUT,
                    @TransportadoraValores         			 OUT,
                    @PagosAliadosEstrategicos 					 OUT,
					@ReclamacionesBancarias      			 OUT,
                    @InformacionSebra         			 OUT,
                    @PagosDirectosGTECH 					 OUT,
					@TitulosValor      			 OUT,
                    @CrucesLiquidacionAliado         			 OUT,
                    @DirectoLineaCredito 					 OUT	,				
					@RecibidosFiduciaria      			 OUT,
                    @ReclasificacionCuenta         			 OUT,
                    @ErroresManuales 					 OUT,
					@ErroresBancarios      			 OUT,
                    @PagosBancos         			 OUT,
                    @ETESA 					 OUT,
					@IdentificacionTransaccion      			 OUT,
                    @DistribucionSaldosAgrupa         			 OUT	
          EXEC WSXML_SFG.SFGCTRLPAGO_AddRecordFromMovement  @IdentificacionTransaccion,
                                            @thisCODARCHIVOPAGO,
                                            @thisCODMOVIMIENTOBANCO,
                                            @thisFECHATRANSACCION,
                                            @thisVALORTRANSACCION,
                                            @thisCOUNTTRANSACCION,
                                            @p_CODUSUARIOMODIFICACION,
                                            @coutCTRLPAGO OUT
          -- Registro de pago no referenciado sin vinculos posibles
          EXEC WSXML_SFG.SFGDETALLEPAGO_AddRecord @coutCTRLPAGO,
                                   1,
                                   @thisFECHATRANSACCION,
                                   @thisVALORTRANSACCION,
                                   0,
                                   @p_CODUSUARIOMODIFICACION,
                                   @coutDETALLEPAGO OUT
          EXEC WSXML_SFG.SFGMEDIOPAGONOREF_AddRecordFromMovement @coutDETALLEPAGO,
                                                  @thisNOMMOVIMIENTOBANCO,
                                                  @p_CODUSUARIOMODIFICACION,
                                                  @coutMEDIOPAGONOREF OUT
        END;

      END 
      -- Eliminar el registro para mantener balance de archivo
      DELETE FROM WSXML_SFG.TRANSACCIONSINIDENTIFICAR WHERE ID_TRANSACCIONSINIDENTIFICAR = @pk_ID_TRANSACCIONSINIDENTIFICA;
      SET @p_RETVALUE_out = @p_FINALIZADAOK;
    END
    ELSE BEGIN
      SET @p_RETVALUE_out = @p_FINALIZADAFALLO
    END 
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_GetRecord(@pk_ID_TRANSACCIONSINIDENTIFICA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.TRANSACCIONSINIDENTIFICAR WHERE ID_TRANSACCIONSINIDENTIFICAR = @pk_ID_TRANSACCIONSINIDENTIFICA;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_TRANSACCIONSINIDENTIFICAR,
             CODARCHIVOPAGO,
             CODMOVIMIENTOBANCO
             FECHATRANSACCION,
             VALORTRANSACCION,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.TRANSACCIONSINIDENTIFICAR
      WHERE ID_TRANSACCIONSINIDENTIFICAR = @pk_ID_TRANSACCIONSINIDENTIFICA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTRANSACCIONSINIDENTIFICAR_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_TRANSACCIONSINIDENTIFICAR,
             CODARCHIVOPAGO,
             CODMOVIMIENTOBANCO
             FECHATRANSACCION,
             VALORTRANSACCION,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.TRANSACCIONSINIDENTIFICAR
      WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;

  END;
GO






