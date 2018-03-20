USE SFGPRODU;
--  DDL for Package Body SFGREGFACTURACIONREFERENCIA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREGFACTURACIONREFERENCIA */ 

  IF OBJECT_ID('WSXML_SFG.SFGREGFACTURACIONREFERENCIA_FindReference', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_FindReference;
GO

CREATE PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_FindReference(
  @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
  @p_PUNTOVENTA               NVARCHAR(2000),
  @p_CODIGOPRODUCTO           NVARCHAR(2000),
  @p_NUMEROREFERENCIA         NVARCHAR(2000),
  @p_FECHAHORATRANSACCION     DATETIME,
  @p_VALORTRANSACCION         FLOAT,
  @p_ESTADO                   NVARCHAR(2000),
  @p_MARKHUERFANO_out         NUMERIC(22,0) OUT,
  @p_ID_REGFACTREFERENCIA_out NUMERIC(22,0) OUT
) AS
BEGIN

  SET NOCOUNT ON;
  SET @p_MARKHUERFANO_out = 0;
  DECLARE @cCODREGISTROFACTURACION NUMERIC(22,0);
  DECLARE @cCODPUNTODEVENTA NUMERIC(22,0);
  DECLARE @cCODPRODUCTO     NUMERIC(22,0);
  DECLARE @cCODHUERFANOSC   NUMERIC(22,0);
  DECLARE @rowcount NUMERIC(22,0) = 0;
  BEGIN

    DECLARE 
		@VENTAFACT SMALLINT ,
		@ANULACION SMALLINT ,
		@FREETICKT SMALLINT ,
		@PREMIOPAG SMALLINT ,
		@RGSTOTROS SMALLINT ,
		@VENNOFACT SMALLINT 

    EXEC WSXML_SFG.SFGTIPOREGISTRO_CONSTANT 
      @VENTAFACT OUT,
      @ANULACION OUT,
      @FREETICKT OUT,
      @PREMIOPAG OUT,
      @RGSTOTROS OUT,
      @VENNOFACT OUT

    EXEC WSXML_SFG.PUNTODEVENTA_F @p_PUNTOVENTA,  0 , @cCODPUNTODEVENTA OUT
    SET @cCODPRODUCTO = WSXML_SFG.PRODUCTO_F(@p_CODIGOPRODUCTO);

    BEGIN
      
      SELECT /*+ index REGISTROFACTURACION REGISTROFACT_VISTAPREFACTUR_IX) */
        @cCODREGISTROFACTURACION = ID_REGISTROFACTURACION 
      FROM WSXML_SFG.REGISTROFACTURACION
      WHERE CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL
        AND CODPUNTODEVENTA = @cCODPUNTODEVENTA
        AND CODPRODUCTO     = @cCODPRODUCTO
        AND CODTIPOREGISTRO = @VENTAFACT;
		
	  SET @rowcount = @@ROWCOUNT;
	  
	  IF @rowcount = 0 
      BEGIN
      
        -- Verificar si se encuentra en la lista de huerfanos
        SELECT @cCODHUERFANOSC = ID_HUERFANOSERVICIOSCOMERCIALS 
        FROM WSXML_SFG.HUERFANOSERVICIOSCOMERCIALES
        WHERE CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL
          AND CAST(PUNTO_DE_VENTA AS NUMERIC(38,0)) = CAST(@p_PUNTOVENTA AS NUMERIC(38,0))
          AND CAST(CODIGO_PRODUCTO AS NUMERIC(38,0)) = CAST(@p_CODIGOPRODUCTO AS NUMERIC(38,0))
          AND CAST(ESTADO AS NUMERIC(38,0)) = @VENTAFACT;
          
        SET @p_MARKHUERFANO_out = 1;
        
        INSERT INTO WSXML_SFG.HUERFANOSCREFERENCIA (
          CODHUERFANOSERVICIOSCOMERCIALS,
          NUMEROREFERENCIA,
          FECHAHORATRANSACCION,
          VALORTRANSACCION,
          ESTADO
        ) VALUES (
          @cCODHUERFANOSC,
          @p_NUMEROREFERENCIA,
          @p_FECHAHORATRANSACCION,
          @p_VALORTRANSACCION,
          @p_ESTADO);
      END ELSE BEGIN
        
		  -- Insertar registro en registro prefacturado
		  INSERT INTO WSXML_SFG.REGISTROFACTREFERENCIA (
			CODREGISTROFACTURACION,
			NUMEROREFERENCIA,
			FECHAHORATRANSACCION,
			VALORTRANSACCION,
			ESTADO
		  ) VALUES (
			@cCODREGISTROFACTURACION,
			@p_NUMEROREFERENCIA,
			@p_FECHAHORATRANSACCION,
			@p_VALORTRANSACCION,
			@p_ESTADO
		  );
		  
		  SET @p_ID_REGFACTREFERENCIA_out = SCOPE_IDENTITY();
	  END

      
      
    END
    
    DECLARE @msg varchar(2000)
    
    IF @rowcount = 0 
    BEGIN
      set @msg = '-20010 No se encontro la venta a la que se hace referencia: Archivo ID ' + CAST(@p_CODENTRADAARCHIVOCONTROL AS NVARCHAR(MAX)) + ', POS ' + 
                CAST(@p_PUNTOVENTA AS NVARCHAR(MAX)) + ', Producto ' + CAST(@p_CODIGOPRODUCTO AS NVARCHAR(MAX)) + ', Referencia ' + CAST(@p_NUMEROREFERENCIA AS NVARCHAR(MAX))
      RAISERROR(@msg, 16, 1);
    END

    IF @rowcount > 1 
    BEGIN
      set @msg = '-20011 No se pueden cargar referencias a archivos no agrupados: Archivo ID ' + CAST(@p_CODENTRADAARCHIVOCONTROL AS NVARCHAR(MAX)) + ', POS ' + 
                CAST(@p_PUNTOVENTA AS NVARCHAR(MAX)) + ', Producto ' + CAST(@p_CODIGOPRODUCTO AS NVARCHAR(MAX)) + ', Referencia ' + CAST(@p_NUMEROREFERENCIA AS NVARCHAR(MAX))
      RAISERROR(@msg, 16, 1);
    END

  END

END
GO

  IF OBJECT_ID('WSXML_SFG.SFGREGFACTURACIONREFERENCIA_FindRegistryForReference', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_FindRegistryForReference;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_FindRegistryForReference(@p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                     @p_PUNTOVENTA               NVARCHAR(2000),
                                     @p_CODIGOPRODUCTO           NVARCHAR(2000),
                                     @p_ESTADO                   NUMERIC(22,0),
                                     @p_MARKHUERFANO_out         NUMERIC(22,0) OUT,
                                     @p_REGISTROFACTURACION_out  NUMERIC(22,0) OUT) AS
  BEGIN
	SET NOCOUNT ON;
    
	SET @p_MARKHUERFANO_out = 0;
	DECLARE @cCODPUNTODEVENTA NUMERIC(22,0);
	DECLARE @cCODPRODUCTO     NUMERIC(22,0);
	DECLARE @rowcount NUMERIC(22,0) = 0;
    
	BEGIN
		EXEC WSXML_SFG.PUNTODEVENTA_F @p_PUNTOVENTA, 0 , @cCODPUNTODEVENTA OUT
		SET @cCODPRODUCTO     = WSXML_SFG.PRODUCTO_F(@p_CODIGOPRODUCTO);
      BEGIN
        SELECT /*+ index REGISTROFACTURACION REGISTROFACT_VISTAPREFACTUR_IX) */
               @p_REGISTROFACTURACION_out = ID_REGISTROFACTURACION FROM WSXML_SFG.REGISTROFACTURACION
        WHERE CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL
          AND CODPUNTODEVENTA = @cCODPUNTODEVENTA
          AND CODPRODUCTO     = @cCODPRODUCTO
          AND CODTIPOREGISTRO = @p_ESTADO;
		
		SET @rowcount = @@ROWCOUNT;
		IF @rowcount = 0 begin
        -- Verificar si se encuentra en la lista de huerfanos
			SELECT @p_REGISTROFACTURACION_out = ID_HUERFANOSERVICIOSCOMERCIALS FROM WSXML_SFG.HUERFANOSERVICIOSCOMERCIALES
			WHERE CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL
			  AND CAST(PUNTO_DE_VENTA AS INT) = CAST(@p_PUNTOVENTA AS INT)
			  AND CAST(CODIGO_PRODUCTO AS INT) = CAST(@p_CODIGOPRODUCTO AS INT)
			  AND CAST(ESTADO AS INT) = @p_ESTADO;
			SET @p_MARKHUERFANO_out = 1;
		END
      END;
		DECLARE @msgError varchar(2000);
		IF @rowcount = 0 BEGIN
			set @msgError  = '-20054 No se encontro la venta a la que se hace referencia: Archivo ID ' + ISNULL(CONVERT(VARCHAR,@p_CODENTRADAARCHIVOCONTROL), '') + ', POS ' + ISNULL(@p_PUNTOVENTA, '') + ', Producto ' + ISNULL(@p_CODIGOPRODUCTO, '')
			RAISERROR(@msgError, 16, 1);
		END
		IF @rowcount > 1 BEGIN
			set @msgError  = '-20055 No se pueden cargar referencias a archivos no agrupados: Archivo ID ' + ISNULL(CONVERT(VARCHAR,@p_CODENTRADAARCHIVOCONTROL), '') + ', POS ' + ISNULL(@p_PUNTOVENTA, '') + ', Producto ' + ISNULL(@p_CODIGOPRODUCTO, '')
			RAISERROR(@msgError, 16, 1);
		END
    END;
  END
GO

  IF OBJECT_ID('WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendReference', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendReference;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendReference(@p_CODREGISTROFACTURACION   NUMERIC(22,0),
                            @p_NUMEROREFERENCIA         NVARCHAR(2000),
                            @p_FECHAHORATRANSACCION     DATETIME,
                            @p_VALORTRANSACCION         FLOAT,
                            @p_ESTADO                   NVARCHAR(2000),
                            @p_SUBAGENTE                NVARCHAR(2000),
                            @p_RECIBO                   NVARCHAR(2000),
                            @p_SUSCRIPTOR               NVARCHAR(2000),
                            @p_BINTARJETA               NVARCHAR(2000),
                            @p_TIPOTRANSACCION          NVARCHAR(2000),
                            @p_FEECROSSREFERENCE        NVARCHAR(2000),
                            @p_FECHATRANSBANCO          NVARCHAR(2000),
                            @p_RESPUESTABANCO           NVARCHAR(2000),
                            @p_ARRN                     NVARCHAR(2000),
                            @p_VRCOMISION               FLOAT,
                            @p_IVACOMISION              FLOAT,
                            @p_TRANS_CODE               NVARCHAR(2000),
                            @p_ARRN_GIRO_DEPOSITO       NVARCHAR(2000),
                            @p_FECHAHORAALIADO          DATETIME,                            
                            @p_ID_REGFACTREFERENCIA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    INSERT INTO WSXML_SFG.REGISTROFACTREFERENCIA (
                                        CODREGISTROFACTURACION,
                                        NUMEROREFERENCIA,
                                        FECHAHORATRANSACCION,
                                        VALORTRANSACCION,
                                        ESTADO,
                                        SUBAGENTE,
                                        RECIBO,
                                        SUSCRIPTOR,
                                        BINTARJETA,
                                        TIPOTRANSACCION,
                                        FEECROSSREF,
                                        FECHATRANSBANCO,
                                        RESPUESTABANCO,
                                        ARRN,
                                        VRCOMISION,
                                        IVACOMISION,
                                        TRANS_CODE,
                                        ARRN_GIRO_DEPOSITO,
                                        FECHAHORAALIADO
		)
    VALUES (
            @p_CODREGISTROFACTURACION,
            @p_NUMEROREFERENCIA,
            @p_FECHAHORATRANSACCION,
            @p_VALORTRANSACCION,
            @p_ESTADO,
            @p_SUBAGENTE,
            @p_RECIBO,
            CASE WHEN LEN(@p_TRANS_CODE) > 0 THEN  @p_TRANS_CODE ELSE (CASE WHEN LEN(@p_SUSCRIPTOR) > 50 THEN SUBSTRING(@p_SUSCRIPTOR, 1, 50) ELSE @p_SUSCRIPTOR END) END,
            @p_BINTARJETA,
            @p_TIPOTRANSACCION,
            @p_FEECROSSREFERENCE,
            @p_FECHATRANSBANCO,
            @p_RESPUESTABANCO,
            @p_ARRN,
            @p_VRCOMISION,
            @p_IVACOMISION,
            @p_TRANS_CODE,
            @p_ARRN_GIRO_DEPOSITO,
            @p_FECHAHORAALIADO
);
    SET @p_ID_REGFACTREFERENCIA_out = SCOPE_IDENTITY();

	END TRY
	BEGIN CATCH
		DEclare @msg varchar(2000) = 'Phoenix: ' + ISNULL(@p_NUMEROREFERENCIA, '') + ' - ' + isnull(ERROR_MESSAGE(), '');
		EXEC wsxml_sfg.SFGTMPTRACE_TraceLog msg
		SET @p_ID_REGFACTREFERENCIA_out = 1;
	END CATCH
  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendReferenceWithReference', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendReferenceWithReference;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendReferenceWithReference(@p_CODREGISTROFACTURACION   NUMERIC(22,0),
                                         @p_NUMEROREFERENCIA         NUMERIC(22,0),
                                         @p_FECHAHORATRANSACCION     DATETIME,
                                         @p_VALORTRANSACCION         FLOAT,
                                         @p_ESTADO                   NVARCHAR(2000),
                                         @p_SUBAGENTE                NVARCHAR(2000),
                                         @p_RECIBO                   NVARCHAR(2000),
                                         @p_SUSCRIPTOR               NVARCHAR(2000),
                                         @p_CODREGISTROANULADO       NUMERIC(22,0),
                                         @p_ID_REGFACTREFERENCIA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REGISTROFACTREFERENCIA (
                                        CODREGISTROFACTURACION,
                                        NUMEROREFERENCIA,
                                        FECHAHORATRANSACCION,
                                        VALORTRANSACCION,
                                        ESTADO,
                                        SUBAGENTE,
                                        RECIBO,
                                        SUSCRIPTOR,
                                        CODREGISTROANULADO)
    VALUES (
            @p_CODREGISTROFACTURACION,
            @p_NUMEROREFERENCIA,
            @p_FECHAHORATRANSACCION,
            @p_VALORTRANSACCION,
            @p_ESTADO,
            @p_SUBAGENTE,
            @p_RECIBO,
            @p_SUSCRIPTOR,
            @p_CODREGISTROANULADO);
    SET @p_ID_REGFACTREFERENCIA_out = SCOPE_IDENTITY();
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendOrphanReference', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendOrphanReference;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGFACTURACIONREFERENCIA_AppendOrphanReference(@p_CODHUERFANOSC               NUMERIC(22,0),
                                  @p_NUMEROREFERENCIA            NUMERIC(22,0),
                                  @p_FECHAHORATRANSACCION        DATETIME,
                                  @p_VALORTRANSACCION            FLOAT,
                                  @p_ESTADO                      NVARCHAR(2000),
                                  @p_SUBAGENTE                   NVARCHAR(2000),
                                  @p_RECIBO                      NVARCHAR(2000),
                                  @p_SUSCRIPTOR                  NVARCHAR(2000),
                                  @p_BINTARJETA                  NVARCHAR(2000),
                                  @p_TIPOTRANSACCION             NVARCHAR(2000),
                                  @p_FEECROSSREFERENCE           NVARCHAR(2000),
                                  @p_FECHATRANSBANCO             NVARCHAR(2000),
                                  @p_RESPUESTABANCO              NVARCHAR(2000),
                                  @p_ARRN                        NVARCHAR(2000),
                                  @p_VRCOMISION                  FLOAT,
                                  @p_IVACOMISION                 FLOAT,
                                  @p_TRANS_CODE                  NVARCHAR(2000),
                                  @p_ARRN_GIRO_DEPOSITO          NVARCHAR(2000),
                                  @p_FECHAHORAALIADO          DATETIME,                                  
                                  @p_ID_HUERFANOSCREFERENCIA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.HUERFANOSCREFERENCIA (
                                      CODHUERFANOSERVICIOSCOMERCIALS,
                                      NUMEROREFERENCIA,
                                      FECHAHORATRANSACCION,
                                      VALORTRANSACCION,
                                      ESTADO,
                                      SUBAGENTE,
                                      RECIBO,
                                      SUSCRIPTOR,
                                      BINTARJETA,
                                      TIPOTRANSACCION,
                                      FEECROSSREF,
                                      FECHATRANSBANCO,
                                      RESPUESTABANCO,
                                      ARRN,
                                      VRCOMISION,
                                      IVACOMISION,
                                      TRANS_CODE,
                                      ARRN_GIRO_DEPOSITO,
                                      FECHAHORAALIADO
)
    VALUES (
            @p_CODHUERFANOSC,
            @p_NUMEROREFERENCIA,
            @p_FECHAHORATRANSACCION,
            @p_VALORTRANSACCION,
            @p_ESTADO,
            @p_SUBAGENTE,
            @p_RECIBO,
            @p_SUSCRIPTOR,
            @p_BINTARJETA,
            @p_TIPOTRANSACCION,
            @p_FEECROSSREFERENCE,
            @p_FECHATRANSBANCO,
            @p_RESPUESTABANCO,
            @p_ARRN,
            @p_VRCOMISION,
            @p_IVACOMISION,
            @p_TRANS_CODE,
            @p_ARRN_GIRO_DEPOSITO,
            @p_FECHAHORAALIADO
);
    SET @p_ID_HUERFANOSCREFERENCIA_out = SCOPE_IDENTITY();

END
GO


