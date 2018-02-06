USE SFGPRODU;
--  DDL for Package Body SFGSALDOPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGSALDOPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_AddRecord(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_SALDOPDV_out        NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.SALDOPDV(
                           CODPUNTODEVENTA,
                           CODDETALLESALDOPDV,
                           CODLINEADENEGOCIO,
                           CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODPUNTODEVENTA,
            @p_CODDETALLESALDOPDV,
            @p_CODLINEADENEGOCIO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_SALDOPDV_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_UpdateRecord(@pk_ID_SALDOPDV           NUMERIC(22,0),
                         @p_CODPUNTODEVENTA        NUMERIC(22,0),
                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                         @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.SALDOPDV
       SET CODPUNTODEVENTA        = @p_CODPUNTODEVENTA,
           CODDETALLESALDOPDV     = @p_CODDETALLESALDOPDV,
           CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_SALDOPDV = @pk_ID_SALDOPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Reversa el estado de los saldos a una facturacion anterior
  IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_ReverseToPrevious', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_ReverseToPrevious;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_ReverseToPrevious(@p_CODPUNTODEVENTA          NUMERIC(22,0),
                              @p_CODLINEADENEGOCIO        NUMERIC(22,0),
                              @p_CODMAESTROFACTURACIONPDV NUMERIC(22,0)) AS
 BEGIN
   DECLARE @lastMAESTROFACTURACIONPDV NUMERIC(22,0);
   DECLARE @codDETALLESALDOPDV NUMERIC(22,0);
   DECLARE @codNULLDETALLESALDOPDV NUMERIC(38,0)
  SET NOCOUNT ON;
    -- Buscar mediante ultima facturacion del punto de venta
    EXEC WSXML_SFG.SFGFACTURACIONPDV_GetCodFacturacionActualPDV @p_CODPUNTODEVENTA,
                                                 @p_CODLINEADENEGOCIO,
                                                 @lastMAESTROFACTURACIONPDV OUT
    IF @lastMAESTROFACTURACIONPDV > 0 AND @lastMAESTROFACTURACIONPDV <> @p_CODMAESTROFACTURACIONPDV BEGIN
        
      BEGIN
        SELECT @codDETALLESALDOPDV = ID_DETALLESALDOPDV FROM WSXML_SFG.DETALLESALDOPDV
        WHERE CODMAESTROFACTURACIONPDV = @lastMAESTROFACTURACIONPDV;
        -- Actualizar padre
        UPDATE WSXML_SFG.SALDOPDV SET CODDETALLESALDOPDV = @codDETALLESALDOPDV
        WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
      END;

    END
    ELSE BEGIN
      IF @@ROWCOUNT = 0 BEGIN
		-- Verificar si existe un saldo con facturacion en null, y si no, insertar
		
			BEGIN
			  SELECT @codNULLDETALLESALDOPDV = ID_DETALLESALDOPDV FROM WSXML_SFG.DETALLESALDOPDV
			  WHERE CODMAESTROFACTURACIONPDV IS NULL;
			  UPDATE WSXML_SFG.SALDOPDV SET CODDETALLESALDOPDV = @codNULLDETALLESALDOPDV
			  WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
				IF @@ROWCOUNT  = 0
					EXEC WSXML_SFG.SFGDETALLESALDOPDV_SetSaldoActualPDV @p_CODPUNTODEVENTA,
												   @p_CODLINEADENEGOCIO,
												   0, 0, 0, 0, NULL, 1, @codNULLDETALLESALDOPDV OUT
			END;
		END
    END 
	IF @@ROWCOUNT = 0 BEGIN
    -- Verificar si existe un saldo con facturacion en null, y si no, insertar
		  
		BEGIN
		  SELECT @codNULLDETALLESALDOPDV = ID_DETALLESALDOPDV FROM WSXML_SFG.DETALLESALDOPDV
		  WHERE CODMAESTROFACTURACIONPDV IS NULL;
		  UPDATE WSXML_SFG.SALDOPDV SET CODDETALLESALDOPDV = @codNULLDETALLESALDOPDV
		  WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
			IF @@ROWCOUNT  = 0
				EXEC WSXML_SFG.SFGDETALLESALDOPDV_SetSaldoActualPDV @p_CODPUNTODEVENTA,
											   @p_CODLINEADENEGOCIO,
											   0, 0, 0, 0, NULL, 1, @codNULLDETALLESALDOPDV OUT
		END;
	END
  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetRecord(@pk_ID_SALDOPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.SALDOPDV
     WHERE ID_SALDOPDV = @pk_ID_SALDOPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_SALDOPDV,
             CODPUNTODEVENTA,
             CODDETALLESALDOPDV,
             CODLINEADENEGOCIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.SALDOPDV
       WHERE ID_SALDOPDV = @pk_ID_SALDOPDV;

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_VincularDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_VincularDetalle;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_VincularDetalle(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                            @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                            @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                            @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                            @p_ID_SALDOPDV_out        NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SET @p_ID_SALDOPDV_out = 0;
    BEGIN
		BEGIN TRY
		  SELECT @p_ID_SALDOPDV_out = ID_SALDOPDV
			FROM WSXML_SFG.SALDOPDV
		   WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA
			 AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;

		  IF @p_ID_SALDOPDV_out > 0 BEGIN
			UPDATE WSXML_SFG.SALDOPDV
			SET CODDETALLESALDOPDV     = @p_CODDETALLESALDOPDV,
				CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
				FECHAHORAMODIFICACION  = GETDATE()
			WHERE ID_SALDOPDV = @p_ID_SALDOPDV_out;
		  END 
		END TRY
		BEGIN CATCH

		  INSERT INTO WSXML_SFG.SALDOPDV (
								CODPUNTODEVENTA,
								CODLINEADENEGOCIO,
								CODDETALLESALDOPDV,
								CODUSUARIOMODIFICACION)
		  VALUES (
				  @p_CODPUNTODEVENTA,
				  @p_CODLINEADENEGOCIO,
				  @p_CODDETALLESALDOPDV,
				  @p_CODUSUARIOMODIFICACION);
		  SET @p_ID_SALDOPDV_out = SCOPE_IDENTITY();
	  END CATCH
    END;

  END;
GO


 IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT ID_SALDOPDV,
             CODPUNTODEVENTA,
             CODDETALLESALDOPDV,
             CODLINEADENEGOCIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.SALDOPDV
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END

  END;
GO


 IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetMora', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetMora;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetMora(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT S.ID_SALDOPDV,
             S.CODPUNTODEVENTA,
             S.CODDETALLESALDOPDV,
             S.CODLINEADENEGOCIO,
             S.FECHAHORAMODIFICACION,
             S.CODUSUARIOMODIFICACION,
             S.ACTIVE
        FROM WSXML_SFG.SALDOPDV S
       LEFT OUTER JOIN WSXML_SFG.DETALLESALDOPDV D
         ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
       WHERE (NUMDIASMORAGTECH > 0 OR NUMDIASMORAFIDUCIA > 0)
         AND S.ACTIVE = CASE WHEN @p_active = -1 THEN S.ACTIVE ELSE @p_active END;
  END;
GO


 IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetFacturacionVsPagos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetFacturacionVsPagos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetFacturacionVsPagos AS
  BEGIN
  SET NOCOUNT ON;
      SELECT CFP.ID_CICLOFACTURACIONPDV, MFP.CODPUNTODEVENTA,
             MIN(MCC.FECHALIMITEPAGOFIDUCIA) MCFECHALIMITEPAGOFIDUCIA, MIN(MCC.FECHALIMITEPAGOGTECH) MCFECHALIMITEPAGOGTECH,
             SUM(MFP.NUEVOSALDOENCONTRAFIDUCIA) MFVALORADEUDADOFIDUCIA, SUM(MFP.NUEVOSALDOENCONTRAGTECH) MFVALORADEUDADOGTECH,
             SUM(MFP.SALDOANTERIORENCONTRAFIDUCIA) MFSALDOPENDIENTEFIDUCIA, SUM(MFP.SALDOANTERIORENCONTRAGTECH) MFSALDOPENDIENTEGTECH,
             SUM(MFP.NUEVOSALDOAFAVORFIDUCIA) MFVALORSALDOAFAVORFIDUCIA, SUM(MFP.NUEVOSALDOAFAVORGTECH) MFVALORSALDOAFAVORGTECH
      FROM WSXML_SFG.CICLOFACTURACIONPDV CFP
      LEFT OUTER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP
        ON (MFP.CODCICLOFACTURACIONPDV = CFP.ID_CICLOFACTURACIONPDV)
      LEFT OUTER JOIN WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG MCC
        ON (MCC.ID_MAESTROFACTCOMPCONSIG = MFP.CODMAESTROFACTURACIONCOMPCONSI)
      LEFT OUTER JOIN WSXML_SFG.PAGOFACTURACIONPDV PFP
        ON (PFP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
      GROUP BY CFP.ID_CICLOFACTURACIONPDV, MFP.CODPUNTODEVENTA
      HAVING CFP.ID_CICLOFACTURACIONPDV = (SELECT MAX(ID_CICLOFACTURACIONPDV) FROM WSXML_SFG.CICLOFACTURACIONPDV);
  END;
GO

  -- Obtiene el saldo actual para una combinacion Cartera
 IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetSaldoActual', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoActual;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoActual(@p_CODPUNTODEVENTA   NUMERIC(22,0),
                           @p_CODLINEADENEGOCIO NUMERIC(22,0),
                           @p_FIDUCIA           NUMERIC(22,0),
                           @p_SALDOACTUAL_out   FLOAT OUT) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_FIDUCIA = 0 BEGIN
      SELECT @p_SALDOACTUAL_out = (SALDOAFAVORGTECH - SALDOCONTRAGTECH)
      FROM WSXML_SFG.SALDOPDV SPV
      INNER JOIN WSXML_SFG.DETALLESALDOPDV DSP ON (DSP.ID_DETALLESALDOPDV = SPV.CODDETALLESALDOPDV)
      WHERE SPV.CODPUNTODEVENTA   = @p_CODPUNTODEVENTA
        AND SPV.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
    END
    ELSE BEGIN
      SELECT @p_SALDOACTUAL_out = (SALDOAFAVORFIDUCIA - SALDOCONTRAFIDUCIA)
      FROM WSXML_SFG.SALDOPDV SPV
      INNER JOIN WSXML_SFG.DETALLESALDOPDV DSP ON (DSP.ID_DETALLESALDOPDV = SPV.CODDETALLESALDOPDV)
      WHERE SPV.CODPUNTODEVENTA   = @p_CODPUNTODEVENTA
        AND SPV.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
    END 
  END;
GO



 IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetSaldoPuntoVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoPuntoVenta;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoPuntoVenta(@p_codpuntoventa NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.SALDOPDV
     WHERE codpuntodeventa = @p_codpuntoventa;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_SALDOPDV,
             CODPUNTODEVENTA,
             CODDETALLESALDOPDV,
             CODLINEADENEGOCIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.SALDOPDV
       WHERE CODPUNTODEVENTA = @p_codpuntoventa;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetSaldoGroupByPuntoVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoGroupByPuntoVenta;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoGroupByPuntoVenta(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT
    A.ID_SALDOPDV,
    A.CODPUNTODEVENTA,
    A.CODDETALLESALDOPDV,
    MAX(D.NUMDIASMORAGTECH) MORAFIDU,
    MAX(D.NUMDIASMORAFIDUCIA) MORAGTECH,
    SUM(D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH + D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA) CARTERA
    FROM WSXML_SFG.SALDOPDV  A left join WSXML_SFG.DETALLESALDOPDV D
    ON A.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV
    WHERE A.ACTIVE = CASE WHEN @p_active = -1 THEN A.ACTIVE ELSE @p_active END
    GROUP BY A.ID_SALDOPDV, A.CODPUNTODEVENTA, A.CODDETALLESALDOPDV;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_GetSaldoGroupByLineaNegocio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoGroupByLineaNegocio;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSALDOPDV_GetSaldoGroupByLineaNegocio(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;


    SELECT
    A.CODPUNTODEVENTA,
    A.CODLINEADENEGOCIO,
    D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH   SUMSLDGTECH,
    D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA   SUMSLDFIDUCIA,
    (D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH + D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA) CARTERA,
    L.NOMLINEADENEGOCIO
    FROM WSXML_SFG.SALDOPDV  A left join WSXML_SFG.DETALLESALDOPDV D
    ON A.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV
    inner join WSXML_SFG.lineadenegocio l
    on a.codlineadenegocio = l.id_lineadenegocio
    WHERE A.ACTIVE = CASE WHEN @p_active = -1 THEN A.ACTIVE ELSE @p_active END
    order by codpuntodeventa;
  END;
GO


IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGSALDOPDV_GetCarteraSaldosActuales'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGSALDOPDV_GetCarteraSaldosActuales
GO

  -- Obtiene el saldo actual para todas las combinaciones cartera y un tipo de distribucion
  CREATE FUNCTION WSXML_SFG.SFGSALDOPDV_GetCarteraSaldosActuales(@p_CODPUNTODEVENTA NUMERIC(22,0), @p_CODTIPOVINCULACIONPAGO NUMERIC(22,0)) 
  
  RETURNS @availableBALANCE TABLE (CODLINEADENEGOCIO NUMERIC(38,0), FIDUCIA NUMERIC(38,0) , SALDOACTUAL FLOAT) AS
 BEGIN
    DECLARE @globalIDENTIFICACION           NVARCHAR(20);
    DECLARE @globalDIGITOVERIFICACION       NUMERIC(22,0);
    DECLARE @globalCODAGRUPACIONPUNTODEVENT NUMERIC(22,0);
  RETURN
  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGSALDOPDV_DistributeChainBalances', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSALDOPDV_DistributeChainBalances;
GO

/** Distributes balance across grouped chains only for active agents.
      This is meant to be used right before billing cycle */

  CREATE PROCEDURE WSXML_SFG.SFGSALDOPDV_DistributeChainBalances(@p_CODLINEADENEGOCIO NUMERIC(22,0), @p_FIDUCIA NUMERIC(22,0)) AS
 BEGIN
	SET NOCOUNT ON;
    DECLARE @lstGROUPEDBILLINGS      WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @cCODCICLOFACTURACIONPDV NUMERIC(22,0) = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
	DECLARE @msg VARCHAR(2000)
	declare @FECHAHOY DATETIME = GETDATE();

	DECLARE @thisFACTURACION       NUMERIC(22,0)
    DECLARE @thisCODPUNTODEVENTA   NUMERIC(22,0)
    DECLARE @thisCODLINEADENEGOCIO NUMERIC(22,0)

	DECLARE @ixpositive__CODPUNTODEVENTA NUMERIC(38,0), @ixpositive__SALDOACTUAL FLOAT, @ixpositive__CODMAESTROFACTURACIONPDV NUMERIC(38,0)

    DECLARE  @AGRUPADO     INT  ,
                      @ABIERTO INT  ,
					  @INDEPENDIENTE INT  
	EXEC WSXML_SFG.SFGTIPOPUNTODEVENTA_CONSTANT
                      @AGRUPADO       OUT,
                      @ABIERTO   OUT,
					  @INDEPENDIENTE   OUT

	DECLARE @Cheques      			TINYINT,
                    @TransportadoraValores         			TINYINT ,
                    @PagosAliadosEstrategicos 					TINYINT ,
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
                    @DistribucionSaldosAgrupa         			TINYINT 	
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

    -- Obtain all grouped billings to which to apply the difference
    INSERT INTO @lstGROUPEDBILLINGS
	SELECT ID_MAESTROFACTCOMPCONSIG 
	FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
    WHERE CODCICLOFACTURACIONPDV = @cCODCICLOFACTURACIONPDV
      AND CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO
      AND CODTIPOPUNTODEVENTA    = @AGRUPADO;
    DECLARE ix CURSOR FOR SELECT IDVALUE FROM @lstGROUPEDBILLINGS--.First..lstGROUPEDBILLINGS.Last LOOP
	OPEN ix
	
	DECLARE @ix__IDVALUE NUMERIC(38,0)
	
	FETCH NEXT FROM ix INTO @ix__IDVALUE;
	
	WHILE @@FETCH_STATUS=0 BEGIN
      -- Obtener saldo positivo, y saldar saldos negativos
        DECLARE @cFACTURACIONCADENA  NUMERIC(22,0) = @ix__IDVALUE;
        DECLARE @xCODIGOCADENA       NVARCHAR(255);
        DECLARE @xCODPUNTOCABEZA     NUMERIC(22,0);
        DECLARE @lstFACTURACIONES    WSXML_SFG.LONGNUMBERARRAY;
        DECLARE @lstBALANCESALDOS    WSXML_SFG.SALDOPDVREFERENCIA;
        DECLARE @vSALDOPOSITIVOGTECH FLOAT = 0;
        DECLARE @vSALDOPOSITIVOFDCIA FLOAT = 0;
        DECLARE @idoutAJUSTE         NUMERIC(22,0) = 0;
      BEGIN
        SELECT @xCODIGOCADENA = AGR.CODIGOAGRUPACIONGTECH, @xCODPUNTOCABEZA = MFC.CODPUNTODEVENTA 
		FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG MFC
        INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA AGR ON (MFC.CODAGRUPACIONPUNTODEVENTA = AGR.ID_AGRUPACIONPUNTODEVENTA)
        WHERE MFC.ID_MAESTROFACTCOMPCONSIG = @cFACTURACIONCADENA;
        -- Obtener facturaciones / saldos para la cadena ordenado por mayor deuda. Ordenamiento depende de FIDUCIA
        IF @p_FIDUCIA = 0 BEGIN

          INSERT INTO @lstFACTURACIONES
		  SELECT ID_MAESTROFACTURACIONPDV 
		  FROM WSXML_SFG.MAESTROFACTURACIONPDV MFP
          INNER JOIN WSXML_SFG.DETALLESALDOPDV DSP ON (DSP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
          WHERE CODCICLOFACTURACIONPDV         = @cCODCICLOFACTURACIONPDV
            AND CODMAESTROFACTURACIONCOMPCONSI = @cFACTURACIONCADENA
          ORDER BY (DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH);
        END
        ELSE IF @p_FIDUCIA = 1 BEGIN
		  
		  INSERT INTO @lstFACTURACIONES
          SELECT ID_MAESTROFACTURACIONPDV  
		  FROM WSXML_SFG.MAESTROFACTURACIONPDV MFP
          INNER JOIN WSXML_SFG.DETALLESALDOPDV DSP ON (DSP.CODMAESTROFACTURACIONPDV = MFP.ID_MAESTROFACTURACIONPDV)
          WHERE CODCICLOFACTURACIONPDV         = @cCODCICLOFACTURACIONPDV
            AND CODMAESTROFACTURACIONCOMPCONSI = @cFACTURACIONCADENA
          ORDER BY (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA);

        END 
        -- Distribuir de acuerdo a FIDUCIA
        IF @p_FIDUCIA = 0 BEGIN
          -- Obtener saldos positivos para distribucion
          INSERT INTO @lstBALANCESALDOS 
		  SELECT MFP.CODPUNTODEVENTA AS CODPUNTODEVENTA, (DSP.SALDOAFAVORGTECH - DSP.SALDOCONTRAGTECH) AS SALDOACTUAL, 
			MFP.ID_MAESTROFACTURACIONPDV AS CODMAESTROFACTURACIONPDV
		  FROM WSXML_SFG.DETALLESALDOPDV DSP
			INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP ON (MFP.ID_MAESTROFACTURACIONPDV = DSP.CODMAESTROFACTURACIONPDV)
          WHERE MFP.CODCICLOFACTURACIONPDV         = @cCODCICLOFACTURACIONPDV
            AND MFP.CODMAESTROFACTURACIONCOMPCONSI = @cFACTURACIONCADENA
            AND (DSP.SALDOAFAVORGTECH - DSP.SALDOCONTRAGTECH) > 0;
			-- Si existieron saldos positivos
			IF @@ROWCOUNT > 0 BEGIN
            -- Obtener sumatoria para distribucion
            DECLARE ixpositive CURSOR FOR SELECT CODPUNTODEVENTA, SALDOACTUAL, CODMAESTROFACTURACIONPDV  FROM @lstBALANCESALDOS--.First..lstBALANCESALDOS.Last LOOP
			OPEN ixpositive

			--DECLARE @ixpositive__CODPUNTODEVENTA NUMERIC(38,0), @ixpositive__SALDOACTUAL FLOAT, @ixpositive__CODMAESTROFACTURACIONPDV NUMERIC(38,0)
			FETCH NEXT FROM ixpositive  INTO @ixpositive__CODPUNTODEVENTA, @ixpositive__SALDOACTUAL, @ixpositive__CODMAESTROFACTURACIONPDV
			
			WHILE @@FETCH_STATUS=0 BEGIN

              IF @ixpositive__SALDOACTUAL > 0 BEGIN
                
				SET @vSALDOPOSITIVOGTECH = @vSALDOPOSITIVOGTECH + @ixpositive__SALDOACTUAL;
                -- Ajuste negativo
				SET @ixpositive__SALDOACTUAL = (@ixpositive__SALDOACTUAL * (-1))
				SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
                EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment   
											 @ixpositive__CODPUNTODEVENTA,
                                             @p_CODLINEADENEGOCIO,
                                             @p_FIDUCIA,
                                             @ixpositive__SALDOACTUAL,
                                             @DistribucionSaldosAgrupa,
                                             @msg,
                                             @FECHAHOY, 
											 1, 
											 @idoutAJUSTE OUT

			END

				FETCH NEXT FROM ixpositive  INTO @ixpositive__CODPUNTODEVENTA, @ixpositive__SALDOACTUAL, @ixpositive__CODMAESTROFACTURACIONPDV
              END
              CLOSE ixpositive;
              DEALLOCATE ixpositive; 
          END 
            -- Solamente si saldo positivo > 0: Solamente lo ajustado negativamente
            IF @vSALDOPOSITIVOGTECH > 0 BEGIN
              DECLARE ip CURSOR FOR SELECT IDVALUE FROM @lstFACTURACIONES--.First..lstFACTURACIONES.Last LOOP
			  DECLARE @ip__IDVALUE NUMERIC(38,0)
			  FETCH NEXT FROM ip INTO @ip__IDVALUE;
	
			  WHILE @@FETCH_STATUS=0 BEGIN
                  SET @thisFACTURACION  = @ip__IDVALUE
                  SET @thisCODPUNTODEVENTA   = 0;
                  SET @thisCODLINEADENEGOCIO = 0;
                  DECLARE @thisSALDOGTECH        FLOAT  = 0;
                
					BEGIN
						IF @vSALDOPOSITIVOGTECH > 0 BEGIN -- Check if positive balance still exists
                    -- Comparar contra facturacion del punto de venta
                    SELECT @thisCODPUNTODEVENTA = CODPUNTODEVENTA, 
						@thisCODLINEADENEGOCIO = CODLINEADENEGOCIO, 
						@thisSALDOGTECH = (DSP.SALDOCONTRAGTECH - DSP.SALDOAFAVORGTECH)
                    FROM WSXML_SFG.DETALLESALDOPDV DSP WHERE CODMAESTROFACTURACIONPDV = @thisFACTURACION;
                    IF @thisSALDOGTECH > 0 BEGIN
                      IF @vSALDOPOSITIVOGTECH >= @thisSALDOGTECH BEGIN
							SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
							EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment 
													@thisCODPUNTODEVENTA,
                                                     @thisCODLINEADENEGOCIO,
                                                     @p_FIDUCIA,
                                                     @thisSALDOGTECH,
                                                     @DistribucionSaldosAgrupa,
                                                     @msg,
                                                     @FECHAHOY, 1, @idoutAJUSTE OUT
							SET @vSALDOPOSITIVOGTECH = @vSALDOPOSITIVOGTECH - @thisSALDOGTECH;
                      END
                      ELSE BEGIN
						SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
                        EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment 
													@thisCODPUNTODEVENTA,
                                                     @thisCODLINEADENEGOCIO,
                                                     @p_FIDUCIA,
                                                     @vSALDOPOSITIVOGTECH,
                                                     @DistribucionSaldosAgrupa,
                                                     @msg,
                                                     @FECHAHOY, 1, @idoutAJUSTE OUT
                        SET @vSALDOPOSITIVOGTECH = 0;
                      END 
                    END 
                  END 
					END;

				FETCH NEXT FROM ip INTO @ip__IDVALUE;
              END;

              CLOSE ip;
              DEALLOCATE ip;
              IF @vSALDOPOSITIVOGTECH > 0 BEGIN -- If there is money left
				SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
                EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment 
											 @xCODPUNTOCABEZA,
                                             @p_CODLINEADENEGOCIO,
                                             @p_FIDUCIA,
                                             @vSALDOPOSITIVOGTECH,
                                             @DistribucionSaldosAgrupa,
                                             @msg,
                                             @FECHAHOY, 1, @idoutAJUSTE OUT
                SET @vSALDOPOSITIVOGTECH = 0;
              END 
            END 
        END
        ELSE IF @p_FIDUCIA = 1 BEGIN
          -- Obtener saldos positivos para distribucion
          INSERT INTO @lstBALANCESALDOS 
		  SELECT MFP.CODPUNTODEVENTA, (DSP.SALDOAFAVORFIDUCIA - DSP.SALDOCONTRAFIDUCIA), MFP.ID_MAESTROFACTURACIONPDV
		  FROM WSXML_SFG.DETALLESALDOPDV DSP
          INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP ON (MFP.ID_MAESTROFACTURACIONPDV = DSP.CODMAESTROFACTURACIONPDV)
          WHERE MFP.CODCICLOFACTURACIONPDV         = @cCODCICLOFACTURACIONPDV
            AND MFP.CODMAESTROFACTURACIONCOMPCONSI = @cFACTURACIONCADENA
            AND (DSP.SALDOAFAVORFIDUCIA - DSP.SALDOCONTRAFIDUCIA) > 0;
          -- Si existieron saldos positivos
           IF @@ROWCOUNT > 0 BEGIN
				-- Obtener sumatoria para distribucion
			
				--DECLARE ixpositive CURSOR FOR lstBALANCESALDOS.First..lstBALANCESALDOS.Last LOOP
				DECLARE ixpositive CURSOR FOR SELECT CODPUNTODEVENTA, SALDOACTUAL, CODMAESTROFACTURACIONPDV  FROM @lstBALANCESALDOS--.First..lstBALANCESALDOS.Last LOOP
			
				OPEN ixpositive

				--DECLARE @ixpositive__CODPUNTODEVENTA NUMERIC(38,0), @ixpositive__SALDOACTUAL FLOAT, @ixpositive__CODMAESTROFACTURACIONPDV NUMERIC(38,0)
				WHILE @@FETCH_STATUS=0 BEGIN
					IF @ixpositive__SALDOACTUAL > 0 BEGIN
						SET @vSALDOPOSITIVOFDCIA = @vSALDOPOSITIVOFDCIA + @ixpositive__SALDOACTUAL;
						-- Ajuste negativo
						SET @ixpositive__SALDOACTUAL = (@ixpositive__SALDOACTUAL * (-1))
						SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
						EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment 
													 @ixpositive__CODPUNTODEVENTA,
													 @p_CODLINEADENEGOCIO,
													 @p_FIDUCIA,
													 @ixpositive__SALDOACTUAL,
													 @DistribucionSaldosAgrupa,
													 @msg,
													 @FECHAHOY, 1, @idoutAJUSTE OUT
					 END
					FETCH NEXT FROM ixpositive  INTO @ixpositive__CODPUNTODEVENTA, @ixpositive__SALDOACTUAL, @ixpositive__CODMAESTROFACTURACIONPDV
				END
				CLOSE ixpositive;
				DEALLOCATE ixpositive
           END 
            -- Solamente si saldo positivo > 0: Solamente lo ajustado negativamente
           IF @vSALDOPOSITIVOFDCIA > 0 BEGIN
              DECLARE ip2 CURSOR FOR SELECT IDVALUE FROM @lstFACTURACIONES--.First..lstFACTURACIONES.Last LOOP
			  DECLARE @ip2__IDVALUE NUMERIC(38,0)
			  FETCH NEXT FROM ip2 INTO @ip2__IDVALUE
			  WHILE @@FETCH_STATUS=0 BEGIN
                  SET @thisFACTURACION   = @ip2__IDVALUE;
                  SET @thisCODPUNTODEVENTA   = 0;
                  SET @thisCODLINEADENEGOCIO  = 0;
                  DECLARE @thisSALDOFIDUCIA      FLOAT  = 0;
                BEGIN
                  IF @vSALDOPOSITIVOFDCIA > 0 BEGIN -- Check if positive balance still exists
                    -- Comparar contra facturacion del punto de venta
                    SELECT @thisCODPUNTODEVENTA = CODPUNTODEVENTA, 
						@thisCODLINEADENEGOCIO = CODLINEADENEGOCIO, 
						@thisSALDOFIDUCIA = (DSP.SALDOCONTRAFIDUCIA - DSP.SALDOAFAVORFIDUCIA)
                    FROM WSXML_SFG.DETALLESALDOPDV DSP WHERE CODMAESTROFACTURACIONPDV = @thisFACTURACION;
                    IF @thisSALDOFIDUCIA > 0 BEGIN
                      IF @vSALDOPOSITIVOFDCIA >= @thisSALDOFIDUCIA BEGIN
							SET @msg = 'Distribucion Interna SFG (' + FORMAT(@FECHAHOY, 'MMM dd/yyyy HH:MI:SS') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
							EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment	
													@thisCODPUNTODEVENTA,
                                                     @thisCODLINEADENEGOCIO,
                                                     @p_FIDUCIA,
                                                     @thisSALDOFIDUCIA,
                                                     @DistribucionSaldosAgrupa,
                                                     @msg,
                                                     @FECHAHOY, 1, @idoutAJUSTE OUT

							SET @vSALDOPOSITIVOFDCIA = @vSALDOPOSITIVOFDCIA - @thisSALDOFIDUCIA;
                      END
                      ELSE BEGIN
						SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
                        EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment		
													@thisCODPUNTODEVENTA,
                                                     @thisCODLINEADENEGOCIO,
                                                     @p_FIDUCIA,
                                                     @vSALDOPOSITIVOFDCIA,
                                                     @DistribucionSaldosAgrupa,
                                                     @msg,
                                                     @FECHAHOY, 1, @idoutAJUSTE OUT
                        SET @vSALDOPOSITIVOFDCIA = 0;
                      END 
                    END 
                  END 
                END;

				FETCH NEXT FROM ip2 INTO @ip2__IDVALUE
              END;

              CLOSE ip;
              DEALLOCATE ip;
              IF @vSALDOPOSITIVOFDCIA > 0 BEGIN -- If there is money left
					SET @msg = 'Distribucion Interna SFG (' + FORMAT(GETDATE(), 'MMM dd/yyyy HH:mm:ss') + ') para la facturacion agrupada de la cadena ' + ISNULL(@xCODIGOCADENA, '')
					EXEC WSXML_SFG.SFGDETALLEPAGO_AddAdjustment	
											 @xCODPUNTOCABEZA,
                                             @p_CODLINEADENEGOCIO,
                                             @p_FIDUCIA,
                                             @vSALDOPOSITIVOFDCIA,
                                             @DistribucionSaldosAgrupa,
                                             @msg,
                                             @FECHAHOY, 1, @idoutAJUSTE OUT
                SET @vSALDOPOSITIVOFDCIA = 0;
              END 
            END 
         END
       END

     END


END
GO
