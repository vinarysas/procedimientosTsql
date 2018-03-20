USE SFGPRODU;
--  DDL for Package Body SFGORIGENPAGO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGORIGENPAGO */ 

  IF OBJECT_ID('WSXML_SFG.SFGORIGENPAGO_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORIGENPAGO_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGORIGENPAGO_CONSTANT(
					@Cheques      			TINYINT OUT,
                    @TransportadoraValores         			TINYINT OUT,
                    @PagosAliadosEstrategicos 					TINYINT OUT,
					@ReclamacionesBancarias      			TINYINT OUT,
                    @InformacionSebra         			TINYINT OUT,
                    @PagosDirectosGTECH 					TINYINT OUT,
					@TitulosValor      			TINYINT OUT,
                    @CrucesLiquidacionAliado         			TINYINT OUT,
                    @DirectoLineaCredito 					TINYINT OUT	,				
					@RecibidosFiduciaria      			TINYINT OUT,
                    @ReclasificacionCuenta         			TINYINT OUT,
                    @ErroresManuales 					TINYINT OUT,
					@ErroresBancarios      			TINYINT OUT,
                    @PagosBancos         			TINYINT OUT,
                    @ETESA 					TINYINT OUT,
					@IdentificacionTransaccion      			TINYINT OUT,
                    @DistribucionSaldosAgrupa         			TINYINT OUT				
) AS
  BEGIN
  SET NOCOUNT ON;
  SET @Cheques                   = 1;
  SET @TransportadoraValores     = 2;
  SET @PagosAliadosEstrategicos  = 3;
  SET @ReclamacionesBancarias    = 4;
  SET @InformacionSebra          = 5;
  SET @PagosDirectosGTECH        = 6;
  SET @TitulosValor              = 7;
  SET @CrucesLiquidacionAliado   = 8;
  SET @DirectoLineaCredito       = 9;
  SET @RecibidosFiduciaria       = 10;
  SET @ReclasificacionCuenta     = 11;
  SET @ErroresManuales           = 12;
  SET @ErroresBancarios          = 13;
  SET @PagosBancos               = 14;
  SET @ETESA                     = 15;
  SET @IdentificacionTransaccion = 16;
  SET @DistribucionSaldosAgrupa  = 17;

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGORIGENPAGO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORIGENPAGO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGORIGENPAGO_AddRecord(@p_DESCRIPCION            NVARCHAR(2000),
                      @p_CODTIPOPAGO            NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_ORIGENPAGO_out      NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ORIGENPAGO (
                              DESCRIPCION,
                              CODTIPOPAGO,
                              CODUSUARIOMODIFICACION)
    VALUES (
              @p_DESCRIPCION,
              @p_CODTIPOPAGO,
              @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ORIGENPAGO_out = SCOPE_IDENTITY();

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGORIGENPAGO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORIGENPAGO_UpdateRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGORIGENPAGO_UpdateRecord(@pk_ID_ORIGENPAGO         NUMERIC(22,0),
                         @p_DESCRIPCION            NVARCHAR(2000),
                         @p_CODTIPOPAGO            NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ORIGENPAGO
       SET DESCRIPCION            = @p_DESCRIPCION,
           CODTIPOPAGO            = @p_CODTIPOPAGO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
    WHERE ID_ORIGENPAGO = @pk_ID_ORIGENPAGO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGORIGENPAGO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORIGENPAGO_GetRecord;
GO


  CREATE PROCEDURE WSXML_SFG.SFGORIGENPAGO_GetRecord(@pk_ID_ORIGENPAGO NUMERIC(22,0)
                                                     )   AS
   BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*)
    FROM WSXML_SFG.ORIGENPAGO
    WHERE ID_ORIGENPAGO = @pk_ID_ORIGENPAGO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be returned along the row data to support concurrency.
      
	  SELECT A.ID_ORIGENPAGO,
             A.DESCRIPCION,
             A.CODTIPOPAGO,
             A.CODUSUARIOMODIFICACION,
             A.FECHAHORAMODIFICACION,
             A.ACTIVE
      FROM WSXML_SFG.ORIGENPAGO A
      WHERE A.ID_ORIGENPAGO = @pk_ID_ORIGENPAGO;
	  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGORIGENPAGO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORIGENPAGO_GetList;
GO


  CREATE PROCEDURE WSXML_SFG.SFGORIGENPAGO_GetList(@p_ACTIVE NUMERIC(22,0)
                                                   ) AS
  BEGIN
  SET NOCOUNT ON;
      
        SELECT A.ID_ORIGENPAGO,
               A.DESCRIPCION,
               A.CODTIPOPAGO,
               A.CODUSUARIOMODIFICACION,
               A.FECHAHORAMODIFICACION,
               A.ACTIVE
        FROM WSXML_SFG.ORIGENPAGO A
        WHERE A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGORIGENPAGO_GetListPorTipo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORIGENPAGO_GetListPorTipo;
GO


  CREATE PROCEDURE WSXML_SFG.SFGORIGENPAGO_GetListPorTipo(@p_ACTIVE NUMERIC(22,0), @p_CODTIPOPAGO NUMERIC(22,0)
                                                          ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT A.ID_ORIGENPAGO,
             A.DESCRIPCION,
             A.CODTIPOPAGO,
             A.CODUSUARIOMODIFICACION,
             A.FECHAHORAMODIFICACION,
             A.ACTIVE
      FROM WSXML_SFG.ORIGENPAGO A
      WHERE A.CODTIPOPAGO = @p_CODTIPOPAGO
        AND A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO






