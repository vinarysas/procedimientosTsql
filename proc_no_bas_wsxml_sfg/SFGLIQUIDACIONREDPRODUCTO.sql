USE SFGPRODU;
--  DDL for Package Body SFGLIQUIDACIONREDPRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO */ 

  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_ReversarFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_ReversarFacturacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_ReversarFacturacion(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0)) AS
 BEGIN
    DECLARE @xCurrentHisto NUMERIC(22,0);
    DECLARE @xCurrentCiclo NUMERIC(22,0);
    DECLARE @xNewCurrentCy NUMERIC(22,0);
    DECLARE @xNewCurrentHs NUMERIC(22,0);
   
  SET NOCOUNT ON;
		SELECT @xCurrentHisto = ID_LIQUIDACIONREDPRODUCTOHISTO, @xCurrentCiclo = CODCICLOFACTURACIONPDV
		FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO, WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
		WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO
			AND CODLIQUIDACIONREDPRODUCTO = ID_LIQUIDACIONREDPRODUCTO
			AND CODLIQUIDACIONREDPRODUCTOHISTO = ID_LIQUIDACIONREDPRODUCTOHISTO;
	   
    IF @xCurrentCiclo <> @p_CODCICLOFACTURACIONPDV BEGIN
		RAISERROR('-20035 El ciclo ingresado no corresponde con el ciclo actual facturado', 16, 1);
    END
	
    SELECT @xNewCurrentCy = ID_CICLOFACTURACIONPDV
    FROM WSXML_SFG.CICLOFACTURACIONPDV
    WHERE SECUENCIA =
           (
			SELECT SECUENCIA - 1
            FROM WSXML_SFG.CICLOFACTURACIONPDV
            WHERE ID_CICLOFACTURACIONPDV = @xCurrentCiclo
	)
	AND ACTIVE = 1;
	   
    SELECT @xNewCurrentHs = ID_LIQUIDACIONREDPRODUCTOHISTO
    FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
    WHERE CODLIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO
       AND CODCICLOFACTURACIONPDV = @xNewCurrentCy;
    
	IF @@ROWCOUNT = 0 BEGIN
		RAISERROR('-20035 El ciclo ingresado no corresponde con el ciclo actual facturado', 16, 1);
		RETURN 0
	END
		
	-- Update and delete
    
	UPDATE WSXML_SFG.LIQUIDACIONREDPRODUCTO
    SET CODLIQUIDACIONREDPRODUCTOHISTO = @xNewCurrentHs
    WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;
    
	DELETE FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOAJUSTE
    WHERE CODLIQUIDACIONREDPRODUCTOHISTO = @xCurrentHisto;
	
    DELETE FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
    WHERE ID_LIQUIDACIONREDPRODUCTOHISTO = @xCurrentHisto;
	
	
	
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_EstablecerFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_EstablecerFacturacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_EstablecerFacturacion(@pk_ID_LIQUIDACIONREDPRODUCTO   NUMERIC(22,0),
                                  @p_CODCICLOFACTURACIONPDV       NUMERIC(22,0),
                                  @p_adjustmentdescriptions       WSXML_SFG.IDSTRINGVALUE READONLY,
                                  @p_adjustmentvalues             WSXML_SFG.IDVALUE READONLY,
                                  @p_TOTALVALORAPAGAR             FLOAT,
                                  @p_CODUSUARIOGENERACION         NUMERIC(22,0),
                                  @p_ID_LIQUIDACIONREDPRODHST_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xCycleSequence NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @xCycleSequence = SECUENCIA
    FROM WSXML_SFG.CICLOFACTURACIONPDV
    WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    -- Check for previously billed
    DECLARE @xExistingHistoricID NUMERIC(22,0);
	DECLARE @msgraisor VARCHAR(2000) = '-20030 Ya se ha facturado el ciclo ' + ISNULL(@xCycleSequence, '') + ' para este producto'
    BEGIN
		SELECT @xExistingHistoricID = ID_LIQUIDACIONREDPRODUCTOHISTO
        FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
		WHERE CODLIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO
			AND CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
		
		IF @@ROWCOUNT > 0 BEGIN
			RAISERROR(@msgraisor, 16, 1);
			RETURN 0;
		END	
    END;
    -- Check for concurrency (skip holes, check for higher value)
	DECLARE @xCurrentHistoricRec NUMERIC(22,0);
	DECLARE @xCurrentHistoricSeq NUMERIC(22,0);
    BEGIN
		SELECT @xCurrentHistoricRec = CODLIQUIDACIONREDPRODUCTOHISTO
        FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO
		WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;
		
		IF @xCurrentHistoricRec IS NOT NULL BEGIN
			SELECT @xCurrentHistoricSeq = SECUENCIA
			FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC, WSXML_SFG.CICLOFACTURACIONPDV
			WHERE CODCICLOFACTURACIONPDV = ID_CICLOFACTURACIONPDV
				AND ID_LIQUIDACIONREDPRODUCTOHISTO = @xCurrentHistoricRec;
 
			IF @xCurrentHistoricSeq >= @xCycleSequence BEGIN
				RAISERROR('-20031 No se puede facturar una semana anterior al actualmente facturado', 16, 1);
				RETURN 0;
			END 
		END 
    END;
    -- Insert dependent records and update header
    INSERT INTO WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC(
       CODLIQUIDACIONREDPRODUCTO,
       CODCICLOFACTURACIONPDV,
       TOTALVALORAPAGAR,
       CODUSUARIOGENERACION)
    VALUES (
       @pk_ID_LIQUIDACIONREDPRODUCTO,
       @p_CODCICLOFACTURACIONPDV,
       ROUND(@p_TOTALVALORAPAGAR, 2),
       @p_CODUSUARIOGENERACION
	);
	
    SET @p_ID_LIQUIDACIONREDPRODHST_out = SCOPE_IDENTITY();
    
	IF (SELECT COUNT(*) FROM @p_adjustmentdescriptions)>0 BEGIN
		IF (SELECT COUNT(*) FROM @p_adjustmentdescriptions)  = (SELECT COUNT(*) FROM @p_adjustmentvalues)
		BEGIN
			DECLARE iax CURSOR FOR SELECT ID, VALUE FROM @p_adjustmentdescriptions
			
			OPEN iax;
			DECLARE @IDSTRINGVALUE VARCHAR(MAX);
			DECLARE @ID INT
			
			FETCH NEXT FROM iax INTO @IDSTRINGVALUE
        
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				INSERT INTO WSXML_SFG.LIQUIDACIONREDPRODUCTOAJUSTE(
					CODLIQUIDACIONREDPRODUCTO,
					CODLIQUIDACIONREDPRODUCTOHISTO,
					DESCRIPCIONELEMENTO,
					VALOR)
				VALUES(
					 @pk_ID_LIQUIDACIONREDPRODUCTO,
					 @p_ID_LIQUIDACIONREDPRODHST_out,
					 @IDSTRINGVALUE,
					 (SELECT VALUE FROM @p_adjustmentvalues WHERE ID = @ID)
				)
				 
				FETCH NEXT FROM iax INTO @IDSTRINGVALUE
			END;
			CLOSE iax;
			DEALLOCATE iax;
			
		END
		ELSE BEGIN
			RAISERROR('-20032 Las descripciones de los ajustes no corresponden con los valores', 16, 1);
			RETURN 0;
		END 
    END 
    UPDATE WSXML_SFG.LIQUIDACIONREDPRODUCTO
       SET CODLIQUIDACIONREDPRODUCTOHISTO = @p_ID_LIQUIDACIONREDPRODHST_out
    WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_EstablecerFactEncabezado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_EstablecerFactEncabezado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_EstablecerFactEncabezado(@pk_ID_LIQUIDACIONREDPRODUCTO   NUMERIC(22,0),
                                     @p_CODCICLOFACTURACIONPDV       NUMERIC(22,0),
                                     @p_TOTALVALORAPAGAR             FLOAT,
                                     @p_CODUSUARIOGENERACION         NUMERIC(22,0),
                                     @p_ID_LIQUIDACIONREDPRODHST_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xCycleSequence NUMERIC(22,0);
    DECLARE @billingValue   FLOAT = ROUND(@p_TOTALVALORAPAGAR, 2);
    DECLARE @insertedValue  FLOAT = 0;
   
  SET NOCOUNT ON;
    SELECT @xCycleSequence = SECUENCIA
	FROM WSXML_SFG.CICLOFACTURACIONPDV
    WHERE ID_CICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    -- Check for previously billed
    DECLARE @xExistingHistoricID NUMERIC(22,0);
	DECLARE @msgraisor VARCHAR(2000)
    BEGIN
		SELECT @xExistingHistoricID = ID_LIQUIDACIONREDPRODUCTOHISTO
        FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
		WHERE CODLIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO
			AND CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
		
		IF @@ROWCOUNT > 0 BEGIN
			SET @msgraisor = '-20030 Ya se ha facturado el ciclo ' + ISNULL(CONVERT(VARCHAR,@xCycleSequence), '') + ' para este producto'
			RAISERROR(@msgraisor, 16, 1);
		END

    END;
    -- Check for concurrency (skip holes, check for higher value)
    DECLARE @xCurrentHistoricRec NUMERIC(22,0);
    DECLARE @xCurrentHistoricSeq NUMERIC(22,0);
    BEGIN
		SELECT @xCurrentHistoricRec = CODLIQUIDACIONREDPRODUCTOHISTO
        FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO
		WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;
		
		IF @xCurrentHistoricRec IS NOT NULL BEGIN
			SELECT @xCurrentHistoricSeq = SECUENCIA
			FROM WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC, WSXML_SFG.CICLOFACTURACIONPDV
			WHERE CODCICLOFACTURACIONPDV = ID_CICLOFACTURACIONPDV
				AND ID_LIQUIDACIONREDPRODUCTOHISTO = @xCurrentHistoricRec;
			
			IF @xCurrentHistoricSeq >= @xCycleSequence BEGIN
				RAISERROR('-20031 No se puede facturar una semana anterior al actualmente facturado', 16, 1);
			END 
		END 
    END;
    -- Insert dependent records and update header
    INSERT INTO WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
      (
       CODLIQUIDACIONREDPRODUCTO,
       CODCICLOFACTURACIONPDV,
       TOTALVALORAPAGAR,
       CODUSUARIOGENERACION)
    VALUES
      (
       @pk_ID_LIQUIDACIONREDPRODUCTO,
       @p_CODCICLOFACTURACIONPDV,
       @billingValue,
       @p_CODUSUARIOGENERACION);
	   
	   	SET @p_ID_LIQUIDACIONREDPRODHST_out = SCOPE_IDENTITY();
   
    UPDATE WSXML_SFG.LIQUIDACIONREDPRODUCTO
       SET CODLIQUIDACIONREDPRODUCTOHISTO = @p_ID_LIQUIDACIONREDPRODHST_out
     WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;
  END;
 GO

IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_InsertarElementoAjuste', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_InsertarElementoAjuste;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_InsertarElementoAjuste(@pk_ID_LIQUIDACIONREDPRODUCTO   NUMERIC(22,0),
                                   @p_CODLIQUIDACIONREDPRODUCTOHIS NUMERIC(22,0),
                                   @p_DESCRIPCIONELEMENTO          NVARCHAR(2000),
                                   @p_VALOR                        FLOAT) AS
 BEGIN
    DECLARE @adjustmentValue FLOAT = ROUND(@p_VALOR, 2);
    DECLARE @insertedValue   FLOAT = 0;
   
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.LIQUIDACIONREDPRODUCTOAJUSTE
      (
       CODLIQUIDACIONREDPRODUCTO,
       CODLIQUIDACIONREDPRODUCTOHISTO,
       DESCRIPCIONELEMENTO,
       VALOR)
    VALUES
      (
       @pk_ID_LIQUIDACIONREDPRODUCTO,
       @p_CODLIQUIDACIONREDPRODUCTOHIS,
       @p_DESCRIPCIONELEMENTO,
       @adjustmentValue);
    SET @insertedValue = SCOPE_IDENTITY();
    UPDATE WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC
       SET TOTALVALORAPAGAR = TOTALVALORAPAGAR + @insertedValue
     WHERE ID_LIQUIDACIONREDPRODUCTOHISTO = @p_CODLIQUIDACIONREDPRODUCTOHIS;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedTaxes', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedTaxes;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedTaxes(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                       @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                       @p_page_number                INTEGER,
                                       @p_batch_size                 INTEGER,
                                      @p_total_size                 INTEGER OUT
                                                                 ) AS
 BEGIN
    DECLARE @xproduct NUMERIC(22,0);
    DECLARE @xregimen NUMERIC(22,0);
    DECLARE @xcompany NUMERIC(22,0);
    DECLARE @xservice NUMERIC(22,0);
    DECLARE @xrevenue FLOAT;
    DECLARE @xvatmltp FLOAT;
    DECLARE @xtaxlist WSXML_SFG.IDVALUE;
   
  SET NOCOUNT ON;
  
    -- Get parameter from configuration
    SELECT @xproduct = CODPRODUCTO, @xregimen = CODREGIMENPRODUCTO
      FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO
     WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;
	 
    -- Get total of taxes into two lists
    SELECT @xcompany = CODCOMPANIA, @xservice = CODSERVICIO
    FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
    WHERE CODLINEADENEGOCIO = ID_LINEADENEGOCIO
       AND CODTIPOPRODUCTO = ID_TIPOPRODUCTO
       AND ID_PRODUCTO = @xproduct;
	   
    SELECT @xvatmltp = (ISNULL(VALORVAT, 0) / 100)
    FROM WSXML_SFG.VATCOMISIONREGIMEN
    WHERE CODCOMPANIA = @xcompany
		AND CODREGIMEN = @xregimen;

    /*SELECT IDVALUE(ID_RETENCIONTRIBUTARIA, (NVL(VALOR, 0) / 100)) BULK COLLECT
      INTO xtaxlist
      FROM RETENCIONTRIBUTARIA
     INNER JOIN RETENCIONTRIBUTARIAREGIMEN ON (CODRETENCIONTRIBUTARIA =
                                              ID_RETENCIONTRIBUTARIA and CODTIPOGENERADORFACTURA = 1 )
     WHERE CODCOMPANIA = xcompany
       AND CODREGIMEN = xregimen
     ORDER BY ID_RETENCIONTRIBUTARIAREGIMEN;*/

--RETENCIONES A APLICAR AL ALIDO
INSERT INTO @xtaxlist
SELECT RT.ID_RETENCIONTRIBUTARIA, (ISNULL(RA.VALOR, 0) / 100)

  FROM PRODUCTO                   P,
       ALIADOESTRATEGICO          A,
       RETENCIONALIADOESTRATEGICO RA,
       RETENCIONTRIBUTARIA        RT
 WHERE P.CODALIADOESTRATEGICO = A.ID_ALIADOESTRATEGICO
   AND RA.CODALIADOESTRATEGICO = A.ID_ALIADOESTRATEGICO
   AND RT.ID_RETENCIONTRIBUTARIA = RA.CODRETENCIONTRIBUTARIA
   AND P.ID_PRODUCTO = @xproduct
   AND RA.VALOR > 0;

    -- Get base value to calculate
    SELECT @xrevenue = ROUND(SUM(CASE
                       WHEN REG.CODTIPOREGISTRO = 1 THEN
                        REV.REVENUETOTAL
                       WHEN REG.CODTIPOREGISTRO = 2 THEN
                        REV.REVENUETOTAL * (-1)
                       ELSE
                        0
                     END),
                 0)
    FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
		INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =CTR.ID_ENTRADAARCHIVOCONTROL)
		INNER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =CTR.ID_ENTRADAARCHIVOCONTROL AND REV.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
     WHERE CTR.REVERSADO = 0
       AND CTR.TIPOARCHIVO = @xservice
       AND CTR.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
       AND REG.CODPRODUCTO = @xproduct;
	   
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = (SELECT COUNT(*) FROM @xtaxlist) + CASE WHEN @xvatmltp <> 0 THEN 1 ELSE 0 END;
    END 
	
    IF @xvatmltp <> 0 AND (SELECT COUNT(*) FROM @xtaxlist) > 0 BEGIN
		 
		
        SELECT 1 AS ORDEN,
               'IVA de la Comision (' + ISNULL(CONVERT(VARCHAR, @xvatmltp * 100), '') + '%)' AS DESCRIPCION,
               ROUND(@xrevenue * @xvatmltp, 0) * (-1) AS VALOR
        UNION
        SELECT 10 + ID_RETENCIONTRIBUTARIA AS ORDEN,
               ISNULL(CONVERT(VARCHAR, COALESCE(DESCRIPCION, NOMRETENCIONTRIBUTARIA)), '') + ' (' +
               ISNULL(CONVERT(VARCHAR, TAX.VALUE * 100), '') + '%)' AS DESCRIPCION,
               CASE
                 WHEN CODBASERETENCION = 1 THEN
                  ROUND(@xrevenue * TAX.VALUE, 0)
                 WHEN CODBASERETENCION = 2 THEN
                  ROUND((@xrevenue * @xvatmltp) * TAX.VALUE, 0)
                 ELSE
                  0
               END AS VALOR
          FROM (SELECT ID, VALUE FROM @xtaxlist) TAX
			INNER JOIN RETENCIONTRIBUTARIA RET ON (RET.ID_RETENCIONTRIBUTARIA =
                                               TAX.ID)
         ORDER BY ORDEN;
		
    END 
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionBilledAdjust', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionBilledAdjust;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionBilledAdjust(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                           @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                           @p_page_number                INTEGER,
                                           @p_batch_size                 INTEGER,
                                          @p_total_size                 INTEGER OUT
                                                                     ) AS
  BEGIN
  SET NOCOUNT ON;
    -- OPnly invoked when already billed. Does not have to be current
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1)
        FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO LQP
       INNER JOIN WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                        LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                        LQH.CODCICLOFACTURACIONPDV =
                                                        @p_CODCICLOFACTURACIONPDV)
       INNER JOIN WSXML_SFG.LIQUIDACIONREDPRODUCTOAJUSTE AJS ON (AJS.CODLIQUIDACIONREDPRODUCTO =
                                                      LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                      AJS.CODLIQUIDACIONREDPRODUCTOHISTO =
                                                      LQH.ID_LIQUIDACIONREDPRODUCTOHISTO);
    END 
	 
      SELECT AJS.ID_LIQUIDACIONREDPRODUCTOAJUST,
             AJS.DESCRIPCIONELEMENTO,
             AJS.VALOR
        FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO LQP
       INNER JOIN WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                        LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                        LQH.CODCICLOFACTURACIONPDV =
                                                        @p_CODCICLOFACTURACIONPDV)
       INNER JOIN WSXML_SFG.LIQUIDACIONREDPRODUCTOAJUSTE AJS ON (AJS.CODLIQUIDACIONREDPRODUCTO =
                                                      LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                      AJS.CODLIQUIDACIONREDPRODUCTOHISTO =
                                                      LQH.ID_LIQUIDACIONREDPRODUCTOHISTO)
       WHERE LQP.ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO
       ORDER BY AJS.ID_LIQUIDACIONREDPRODUCTOAJUST;
	
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedVIA', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedVIA;
GO

CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedVIA(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                          @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                          @p_page_number                INTEGER,
                                          @p_batch_size                 INTEGER,
                                         @p_total_size                 INTEGER OUT
                                                                    ) AS
 BEGIN

    DECLARE @xproduct      NUMERIC(22,0);
    DECLARE @xnetwork      NUMERIC(22,0);
    DECLARE @xchainid      NUMERIC(22,0);
    DECLARE @xdepartamento NUMERIC(22,0);
    DECLARE @xconfigdiferencial NUMERIC(22,0);
    DECLARE @xproductocontrato NUMERIC(22,0);
    DECLARE @xStringOtros varchar(255);
    DECLARE @xStringTipoDiferencial varchar(255);
    DECLARE @xnetworkVIA NUMERIC(22,0);
    DECLARE @xregimen      NUMERIC(22,0);
    DECLARE @xcompany      NUMERIC(22,0);
    DECLARE @xservice      NUMERIC(22,0);
    DECLARE @xrevenue      FLOAT;
    DECLARE @xnetrevn      FLOAT;
    DECLARE @xvatmltp      FLOAT;
    DECLARE @xtaxlist      WSXML_SFG.IDVALUE;

   
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = 1;
    END 

    -- Get parameter from configuration
    SELECT @xproduct = CODPRODUCTO,
           @xnetwork = CODREDPDVPRODUCTO,
           @xchainid = ISNULL(CODAGRUPACIONPUNTODEVENTAPRODU,0),
           @xregimen = CODREGIMENPRODUCTO,
           @xdepartamento = CODDEPARTAMENTO
      FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO
     WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;

     IF ISNULL(@xnetwork,0) > 0 BEGIN

          SET @xconfigdiferencial = 1;

     END
     ELSE IF ISNULL(@xchainid,0) > 0 BEGIN

          SET @xconfigdiferencial = 2;

     END
     ELSE IF ISNULL(@xdepartamento,0) > 0 BEGIN

          SET @xconfigdiferencial = 3;

     END 

    -- Get total of taxes into two lists

    SELECT @xcompany = CODCOMPANIA, @xservice = CODSERVICIO
      FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
     WHERE CODLINEADENEGOCIO = ID_LINEADENEGOCIO
       AND CODTIPOPRODUCTO = ID_TIPOPRODUCTO
       AND ID_PRODUCTO = @xproduct;

    SELECT @xvatmltp = (ISNULL(VALORVAT, 0) / 100)
      FROM WSXML_SFG.VATCOMISIONREGIMEN
     WHERE CODCOMPANIA = @xcompany
       AND CODREGIMEN = @xregimen;

	INSERT INTO @xtaxlist
    SELECT CODBASERETENCION, (ISNULL(VALOR, 0) / 100)
      
      FROM WSXML_SFG.RETENCIONTRIBUTARIA
     INNER JOIN WSXML_SFG.RETENCIONTRIBUTARIAREGIMEN 
		ON (CODRETENCIONTRIBUTARIA =ID_RETENCIONTRIBUTARIA and codtipogeneradorfactura = 1)
     WHERE CODCOMPANIA = @xcompany
       AND CODREGIMEN = @xregimen
     ORDER BY ID_RETENCIONTRIBUTARIAREGIMEN;

    -- Get base value to calculate

    SELECT @xrevenue = ISNULL(ROUND(SUM(CASE
                           WHEN REG.CODTIPOREGISTRO = 1 THEN
                            REV.REVENUETOTAL
                           WHEN REG.CODTIPOREGISTRO = 2 THEN
                            REV.REVENUETOTAL * (-1)
                           ELSE
                            0
                         END),
                     0),
               0)
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                 CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                 REG.CODPRODUCTO =
                                                 @xproduct)
      LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                             CTR.ID_ENTRADAARCHIVOCONTROL AND
                                             REV.CODREGISTROFACTURACION =
                                             REG.ID_REGISTROFACTURACION)
     WHERE CTR.REVERSADO = 0
       AND CTR.TIPOARCHIVO = @xservice
       AND CTR.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;

    -- Calculate into net value

    SET @xnetrevn = @xrevenue;

    IF @xvatmltp <> 0 BEGIN
      SET @xnetrevn = @xnetrevn + ROUND(@xrevenue * @xvatmltp, 0);
    END 
    IF (SELECT COUNT(*) FROM @xtaxlist) > 0 BEGIN
		DECLARE itx CURSOR FOR SELECT ID, VALUE FROM @xtaxlist
		
		OPEN itx;
		DECLARE @id NUMERIC(38,0), @idvalue VARCHAR(MAX)
		 FETCH NEXT FROM itx INTO @id,@idvalue
		 WHILE @@FETCH_STATUS=0
		 BEGIN
			IF @id = 1
				set @xnetrevn = @xnetrevn - ROUND(@xrevenue * @idvalue, 0);
			ELSE BEGIN
				IF @ID = 2
					SET @xnetrevn = @xnetrevn - ROUND((@xrevenue * @xvatmltp) * @idvalue, 0);
			END
			
			FETCH NEXT FROM itx INTO @id,@idvalue
        END
        CLOSE itx;
        DEALLOCATE itx;
    END

    -- Open cursor with base data AND INFORMATIVE VALUES

    -- xnetwork

    SET @xnetworkVIA =82;

	SET @xconfigdiferencial= 1;

    if @xconfigdiferencial = 1 
	begin

    SET @xStringOtros ='Red Otras Redes';
    SET @xStringTipoDiferencial ='Red';

	 
    Select * from (
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             'CODIGOAGRUPACIONGTECH' AS CODIGOAGRUPACIONGTECH,
--             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             'NOMREDPDV' AS NOMREDPDV,
--             RED.NOMREDPDV AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             CODTIPOCOMISIONDF AS DIFRCODTIPOCOMISION,
             VALORPORCENTUALDF AS DIFRVALORPORCENTUAL,
             VALORTRANSACCIONALDF AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             ISNULL(CANTIDAD, 0) AS CANTIDAD,
             ISNULL(VENTAS, 0) AS VENTAS,
             ISNULL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             ISNULL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             ISNULL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             ISNULL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             ISNULL(COMISION, 0) AS COMISION,
             ISNULL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             ISNULL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             ISNULL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             ISNULL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(@xnetrevn, 0) * (-1) AS REVENUENETO,
             ISNULL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             ISNULL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             ISNULL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             ISNULL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 @xStringOtros AS XSTRINGOTROS,
                 @xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL,
                 ISNULL(NOMBRECORTO,'RED VIA') as NOMBRECORTO,
                 NOMRANGOCOMISIONDF
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1/* AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2/* AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     /*ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0)*/0 AS PREMIOSCADENA,
                           RCD.NOMBRECORTO,
                           RCD.VALORPORCENTUAL AS VALORPORCENTUALDF,
                           RCD.VALORTRANSACCIONAL VALORTRANSACCIONALDF,
                           CODTIPOCOMISION AS CODTIPOCOMISIONDF,
                           RCD.NOMRANGOCOMISION AS NOMRANGOCOMISIONDF

                FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           @xproduct)
                LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               LEFT OUTER JOIN (SELECT CD.CODREGISTROREVENUE,
                                     CD.NOMBRECORTO,
                                     RC.NOMRANGOCOMISION,
                                     RCD.VALORPORCENTUAL,
                                     RCD.VALORTRANSACCIONAL,
                                     RC.CODTIPOCOMISION
                                FROM WSXML_SFG.REGISTROREVENUECOMDIF  CD,
                                     WSXML_SFG.PRODUCTOCONTRATOCOMDIF PC,
                                     WSXML_SFG.RANGOCOMISION          RC,
                                     WSXML_SFG.RANGOCOMISIONDETALLE   RCD
                               WHERE CD.CODPRODUCTOCONTRATOCOMDIF = PC.ID_PRODUCTOCONTRATOCOMDIF
                                 AND PC.CODRANGOCOMISION = RC.ID_RANGOCOMISION
                                 AND RCD.CODRANGOCOMISION = RC.ID_RANGOCOMISION) RCD ON (REV.ID_REGISTROREVENUE = RCD.CODREGISTROREVENUE)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = @xservice
                 AND CTR.CODCICLOFACTURACIONPDV =@p_CODCICLOFACTURACIONPDV
                 GROUP BY RCD.NOMBRECORTO, RCD.VALORPORCENTUAL, RCD.VALORTRANSACCIONAL, CODTIPOCOMISION, NOMRANGOCOMISION) T
       INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.ID_PRODUCTO = @xproduct)
       INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       /*INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO \*AND
                                                PCD.CODREDPDV = xnetwork*\)*/
       INNER JOIN WSXML_SFG.RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       /*INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)*/
       /*INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)*/
       INNER JOIN WSXML_SFG.RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             @p_CODCICLOFACTURACIONPDV)
       /*LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                REG.CODAGRUPACIONPUNTODEVENTA)
       INNER JOIN REDPDV RED ON (RED.ID_REDPDV = REG.CODREDPDV)*/
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO, LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      @pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV)

    ) s where NOMBRECORTO = 'RED VIA';

	;
  -- xchainid
  /*
  elsif xconfigdiferencial = 2 then


  xStringOtros :='Otras Cadenas';
  xStringTipoDiferencial :='Cadena';

  OPEN p_cur FOR
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             AGR.NOMAGRUPACIONPUNTODEVENTA AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             RCD.CODTIPOCOMISION AS DIFRCODTIPOCOMISION,
             RDD.VALORPORCENTUAL AS DIFRVALORPORCENTUAL,
             RDD.VALORTRANSACCIONAL AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             NVL(CANTIDAD, 0) AS CANTIDAD,
             NVL(VENTAS, 0) AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             NVL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             NVL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             NVL(COMISION, 0) AS COMISION,
             NVL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             NVL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             NVL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             NVL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(xnetrevn, 0) * (-1) AS REVENUENETO,
             NVL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             NVL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             NVL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             NVL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 xStringOtros AS XSTRINGOTROS,
                 xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODREDPDV = xnetworkVIA THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSCADENA
                FROM ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = xservice
                 AND CTR.CODCICLOFACTURACIONPDV =p_CODCICLOFACTURACIONPDV)
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO AND
                                                PCD.CODAGRUPACIONPUNTODEVENTA = xchainid)
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             p_CODCICLOFACTURACIONPDV)
\*     LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)*\
       INNER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);

  -- xdepartamento

  elsif xconfigdiferencial = 3 then


    SELECT PCT.ID_PRODUCTOCONTRATO
      INTO xproductocontrato
      FROM PRODUCTOCONTRATO PCT
     WHERE PCT.CODPRODUCTO = xproduct;

    xStringOtros :='Otros Departamentos';
    xStringTipoDiferencial :='Departamento';

  OPEN p_cur FOR
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             DTO.NOMDEPARTAMENTO  AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             RCD.CODTIPOCOMISION AS DIFRCODTIPOCOMISION,
             RDD.VALORPORCENTUAL AS DIFRVALORPORCENTUAL,
             RDD.VALORTRANSACCIONAL AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             NVL(CANTIDAD, 0) AS CANTIDAD,
             NVL(VENTAS, 0) AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             NVL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             NVL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             NVL(COMISION, 0) AS COMISION,
             NVL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             NVL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             NVL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             NVL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(xnetrevn, 0) * (-1) AS REVENUENETO,
             NVL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             NVL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             NVL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             NVL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 xStringOtros AS XSTRINGOTROS,
                 xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODREDPDV = xnetworkVIA THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSCADENA
                FROM ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = xservice
                 AND CTR.CODCICLOFACTURACIONPDV =p_CODCICLOFACTURACIONPDV)
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO AND
                                                PCD.CODDEPARTAMENTO = xdepartamento)
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             p_CODCICLOFACTURACIONPDV)
       LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)
       INNER JOIN DEPARTAMENTO DTO ON (DTO.ID_DEPARTAMENTO = xdepartamento)
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);

  */end 

  END 
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionProducto;
GO

CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionProducto(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                          @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                          @p_page_number                INTEGER,
                                          @p_batch_size                 INTEGER,
                                         @p_total_size                 INTEGER OUT
                                                                    ) AS
 BEGIN

    DECLARE @xproduct      NUMERIC(22,0);
    DECLARE @xnetwork      NUMERIC(22,0);
    DECLARE @xchainid      NUMERIC(22,0);
    DECLARE @xdepartamento NUMERIC(22,0);
    DECLARE @xconfigdiferencial NUMERIC(22,0);
    DECLARE @xproductocontrato NUMERIC(22,0);
    DECLARE @xStringOtros varchar(255);
    DECLARE @xStringTipoDiferencial varchar(255);
    DECLARE @xnetworkVIA NUMERIC(22,0);
    DECLARE @xregimen      NUMERIC(22,0);
    DECLARE @xcompany      NUMERIC(22,0);
    DECLARE @xservice      NUMERIC(22,0);
    DECLARE @xrevenue      FLOAT;
    DECLARE @xnetrevn      FLOAT;
    DECLARE @xvatmltp      FLOAT;
    DECLARE @xtaxlist      WSXML_SFG.IDVALUE;

   
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = 1;
    END 

    -- Get parameter from configuration
    SELECT @xproduct = CODPRODUCTO,
           @xnetwork = CODREDPDVPRODUCTO,
           @xchainid = ISNULL(CODAGRUPACIONPUNTODEVENTAPRODU,0),
           @xregimen = CODREGIMENPRODUCTO,
           @xdepartamento = CODDEPARTAMENTO
      FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO
     WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;

     IF ISNULL(@xnetwork,0) > 0 BEGIN

          SET @xconfigdiferencial = 1;

     END
     ELSE IF ISNULL(@xchainid,0) > 0 BEGIN

          SET @xconfigdiferencial = 2;

     END
     ELSE IF ISNULL(@xdepartamento,0) > 0 BEGIN

          SET @xconfigdiferencial = 3;

     END 

    -- Get total of taxes into two lists

    SELECT @xcompany = CODCOMPANIA, @xservice = CODSERVICIO
      FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
     WHERE CODLINEADENEGOCIO = ID_LINEADENEGOCIO
       AND CODTIPOPRODUCTO = ID_TIPOPRODUCTO
       AND ID_PRODUCTO = @xproduct;

    SELECT @xvatmltp = (ISNULL(VALORVAT, 0) / 100)
      FROM WSXML_SFG.VATCOMISIONREGIMEN
     WHERE CODCOMPANIA = @xcompany
       AND CODREGIMEN = @xregimen;

    /*SELECT IDVALUE(CODBASERETENCION, (NVL(VALOR, 0) / 100)) BULK COLLECT
      INTO xtaxlist
      FROM RETENCIONTRIBUTARIA
     INNER JOIN RETENCIONTRIBUTARIAREGIMEN ON (CODRETENCIONTRIBUTARIA =
                                              ID_RETENCIONTRIBUTARIA and codtipogeneradorfactura = 1)
     WHERE CODCOMPANIA = xcompany
       AND CODREGIMEN = xregimen
     ORDER BY ID_RETENCIONTRIBUTARIAREGIMEN;*/

    --RETENCIONES A APLICAR AL ALIDO
	INSERT INTO @xtaxlist
    SELECT RT.ID_RETENCIONTRIBUTARIA, (ISNULL(RA.VALOR, 0) / 100)
      FROM WSXML_SFG.PRODUCTO                   P,
           WSXML_SFG.ALIADOESTRATEGICO          A,
           WSXML_SFG.RETENCIONALIADOESTRATEGICO RA,
           WSXML_SFG.RETENCIONTRIBUTARIA        RT
     WHERE P.CODALIADOESTRATEGICO = A.ID_ALIADOESTRATEGICO
       AND RA.CODALIADOESTRATEGICO = A.ID_ALIADOESTRATEGICO
       AND RT.ID_RETENCIONTRIBUTARIA = RA.CODRETENCIONTRIBUTARIA
       AND P.ID_PRODUCTO = @xproduct
       AND RA.VALOR > 0;

    -- Get base value to calculate

    SELECT @xrevenue = ISNULL(ROUND(SUM(CASE
                           WHEN REG.CODTIPOREGISTRO = 1 THEN
                            REV.REVENUETOTAL
                           WHEN REG.CODTIPOREGISTRO = 2 THEN
                            REV.REVENUETOTAL * (-1)
                           ELSE
                            0
                         END),
                     0),
               0)
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                 CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                 REG.CODPRODUCTO =
                                                 @xproduct)
      LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                             CTR.ID_ENTRADAARCHIVOCONTROL AND
                                             REV.CODREGISTROFACTURACION =
                                             REG.ID_REGISTROFACTURACION)
     WHERE CTR.REVERSADO = 0
       AND CTR.TIPOARCHIVO = @xservice
       AND CTR.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;

    -- Calculate into net value

    SET @xnetrevn = @xrevenue;

    IF @xvatmltp <> 0 BEGIN
      SET @xnetrevn = @xnetrevn + ROUND(@xrevenue * @xvatmltp, 0);
    END 
	
    IF (SELECT COUNT(*) FROM @xtaxlist) > 0 BEGIN
		DECLARE itx CURSOR FOR SELECT ID, VALUE FROM @xtaxlist
		OPEN itx;
		DECLARE @id NUMERIC(38,0), @idvalue VARCHAR(MAX)
		FETCH NEXT FROM itx INTO @id,@idvalue
		WHILE @@FETCH_STATUS=0
		BEGIN
			IF @id in (1,4)
				set @xnetrevn = @xnetrevn - ROUND(@idvalue, 0);
			ELSE
				IF @id = 2
					SET @xnetrevn = @xnetrevn - ROUND((@xrevenue * @xvatmltp) * @idvalue, 0);
        FETCH NEXT FROM itx INTO @id,@idvalue
        END
        CLOSE itx;
        DEALLOCATE itx;

    END

    -- Open cursor with base data AND INFORMATIVE VALUES

    -- xnetwork

    SET @xnetworkVIA =82;

	SET @xconfigdiferencial= 1;

    if @xconfigdiferencial = 1 
	BEGIN

    SET @xStringOtros = 'Red VIA';
    SET @xStringTipoDiferencial ='Red';
    
	 
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             WSXML.SFG_PACKAGE_StringRangoDeFechas(CFP.FECHAEJECUCION - 6, CFP.FECHAEJECUCION) AS RANGOFECHAS,
             'CODIGOAGRUPACIONGTECH' AS CODIGOAGRUPACIONGTECH,
--             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             'NOMREDPDV' AS NOMREDPDV,
--             RED.NOMREDPDV AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             0 AS DIFRCODTIPOCOMISION,
             0 AS DIFRVALORPORCENTUAL,
             0 AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             ISNULL(CANTIDAD, 0) AS CANTIDAD,
             ISNULL(VENTAS, 0) AS VENTAS,
             ISNULL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             ISNULL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             ISNULL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             ISNULL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             ISNULL(COMISION, 0) AS COMISION,
             ISNULL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             ISNULL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             ISNULL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             ISNULL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(@xnetrevn, 0) * (-1) AS REVENUENETO,
             ISNULL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             ISNULL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             ISNULL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             ISNULL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 @xStringOtros AS XSTRINGOTROS,
                 @xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL,
                 'NOMBRECORTO' AS NOMBRECORTO,
                 'NOMRANGOCOMISIONDF' AS NOMRANGOCOMISIONDF
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1/* AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2/* AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     /*ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0)*/0 AS PREMIOSCADENA

                FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           @xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               /*LEFT OUTER JOIN (SELECT CD.CODREGISTROREVENUE,
                                     CD.NOMBRECORTO,
                                     RC.NOMRANGOCOMISION,
                                     RCD.VALORPORCENTUAL,
                                     RCD.VALORTRANSACCIONAL,
                                     RC.CODTIPOCOMISION
                                FROM REGISTROREVENUECOMDIF  CD,
                                     PRODUCTOCONTRATOCOMDIF PC,
                                     RANGOCOMISION          RC,
                                     RANGOCOMISIONDETALLE   RCD
                               WHERE CD.CODPRODUCTOCONTRATOCOMDIF = PC.ID_PRODUCTOCONTRATOCOMDIF
                                 AND PC.CODRANGOCOMISION = RC.ID_RANGOCOMISION
                                 AND RCD.CODRANGOCOMISION = RC.ID_RANGOCOMISION) RCD ON (REV.ID_REGISTROREVENUE = RCD.CODREGISTROREVENUE)*/
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = @xservice
                 AND CTR.CODCICLOFACTURACIONPDV =@p_CODCICLOFACTURACIONPDV
                 /*GROUP BY RCD.NOMBRECORTO, RCD.VALORPORCENTUAL, RCD.VALORTRANSACCIONAL, CODTIPOCOMISION, NOMRANGOCOMISION*/) T
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = @xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       /*INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO \*AND
                                                PCD.CODREDPDV = xnetwork*\)*/
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       /*INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)*/
       /*INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)*/
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             @p_CODCICLOFACTURACIONPDV)
       /*LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                REG.CODAGRUPACIONPUNTODEVENTA)
       INNER JOIN REDPDV RED ON (RED.ID_REDPDV = REG.CODREDPDV)*/
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      @pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);
		

  -- xchainid
  /*
  elsif xconfigdiferencial = 2 then


  xStringOtros :='Otras Cadenas';
  xStringTipoDiferencial :='Cadena';

  OPEN p_cur FOR
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             AGR.NOMAGRUPACIONPUNTODEVENTA AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             RCD.CODTIPOCOMISION AS DIFRCODTIPOCOMISION,
             RDD.VALORPORCENTUAL AS DIFRVALORPORCENTUAL,
             RDD.VALORTRANSACCIONAL AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             NVL(CANTIDAD, 0) AS CANTIDAD,
             NVL(VENTAS, 0) AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             NVL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             NVL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             NVL(COMISION, 0) AS COMISION,
             NVL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             NVL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             NVL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             NVL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(xnetrevn, 0) * (-1) AS REVENUENETO,
             NVL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             NVL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             NVL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             NVL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 xStringOtros AS XSTRINGOTROS,
                 xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODREDPDV = xnetworkVIA THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSCADENA
                FROM ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = xservice
                 AND CTR.CODCICLOFACTURACIONPDV =p_CODCICLOFACTURACIONPDV)
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO AND
                                                PCD.CODAGRUPACIONPUNTODEVENTA = xchainid)
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             p_CODCICLOFACTURACIONPDV)
\*     LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)*\
       INNER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);

  -- xdepartamento

  elsif xconfigdiferencial = 3 then


    SELECT PCT.ID_PRODUCTOCONTRATO
      INTO xproductocontrato
      FROM PRODUCTOCONTRATO PCT
     WHERE PCT.CODPRODUCTO = xproduct;

    xStringOtros :='Otros Departamentos';
    xStringTipoDiferencial :='Departamento';

  OPEN p_cur FOR
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             DTO.NOMDEPARTAMENTO  AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             RCD.CODTIPOCOMISION AS DIFRCODTIPOCOMISION,
             RDD.VALORPORCENTUAL AS DIFRVALORPORCENTUAL,
             RDD.VALORTRANSACCIONAL AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             NVL(CANTIDAD, 0) AS CANTIDAD,
             NVL(VENTAS, 0) AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             NVL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             NVL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             NVL(COMISION, 0) AS COMISION,
             NVL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             NVL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             NVL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             NVL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(xnetrevn, 0) * (-1) AS REVENUENETO,
             NVL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             NVL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             NVL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             NVL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 xStringOtros AS XSTRINGOTROS,
                 xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODREDPDV = xnetworkVIA THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSCADENA
                FROM ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = xservice
                 AND CTR.CODCICLOFACTURACIONPDV =p_CODCICLOFACTURACIONPDV)
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO AND
                                                PCD.CODDEPARTAMENTO = xdepartamento)
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             p_CODCICLOFACTURACIONPDV)
       LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)
       INNER JOIN DEPARTAMENTO DTO ON (DTO.ID_DEPARTAMENTO = xdepartamento)
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);

  */end 

  END 
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedProducto;
GO


  CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionRedProducto(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                          @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                          @p_page_number                INTEGER,
                                          @p_batch_size                 INTEGER,
                                         @p_total_size                 INTEGER OUT
                                                                    ) AS
 BEGIN

    DECLARE @xproduct      NUMERIC(22,0);
    DECLARE @xnetwork      NUMERIC(22,0);
    DECLARE @xchainid      NUMERIC(22,0);
    DECLARE @xdepartamento NUMERIC(22,0);
    DECLARE @xconfigdiferencial NUMERIC(22,0);
    DECLARE @xproductocontrato NUMERIC(22,0);
    DECLARE @xStringOtros varchar(255);
    DECLARE @xStringTipoDiferencial varchar(255);
    DECLARE @xnetworkVIA NUMERIC(22,0);
    DECLARE @xregimen      NUMERIC(22,0);
    DECLARE @xcompany      NUMERIC(22,0);
    DECLARE @xservice      NUMERIC(22,0);
    DECLARE @xrevenue      FLOAT;
    DECLARE @xnetrevn      FLOAT;
    DECLARE @xvatmltp      FLOAT;
    DECLARE @xtaxlist      WSXML_SFG.IDVALUE;

   
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = 1;
    END 

    -- Get parameter from configuration
    SELECT @xproduct = CODPRODUCTO,
           @xnetwork = CODREDPDVPRODUCTO,
           @xchainid = ISNULL(CODAGRUPACIONPUNTODEVENTAPRODU,0),
           @xregimen = CODREGIMENPRODUCTO,
           @xdepartamento = CODDEPARTAMENTO
      FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO
     WHERE ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;

     IF ISNULL(@xnetwork,0) > 0 BEGIN

          SET @xconfigdiferencial = 1;

     END
     ELSE IF ISNULL(@xchainid,0) > 0 BEGIN

          SET @xconfigdiferencial = 2;

     END
     ELSE IF ISNULL(@xdepartamento,0) > 0 BEGIN

          SET @xconfigdiferencial = 3;

     END 

    -- Get total of taxes into two lists

    SELECT @xcompany = CODCOMPANIA, @xservice = CODSERVICIO
      FROM WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
     WHERE CODLINEADENEGOCIO = ID_LINEADENEGOCIO
       AND CODTIPOPRODUCTO = ID_TIPOPRODUCTO
       AND ID_PRODUCTO = @xproduct;

    SELECT @xvatmltp = (ISNULL(VALORVAT, 0) / 100)
      FROM WSXML_SFG.VATCOMISIONREGIMEN
     WHERE CODCOMPANIA = @xcompany
       AND CODREGIMEN = @xregimen;

	INSERT INTO @xtaxlist
    SELECT CODBASERETENCION, (ISNULL(VALOR, 0) / 100)
      FROM RETENCIONTRIBUTARIA
     INNER JOIN RETENCIONTRIBUTARIAREGIMEN ON (CODRETENCIONTRIBUTARIA =
                                              ID_RETENCIONTRIBUTARIA and codtipogeneradorfactura = 1)
     WHERE CODCOMPANIA = @xcompany
       AND CODREGIMEN = @xregimen
     ORDER BY ID_RETENCIONTRIBUTARIAREGIMEN;

    -- Get base value to calculate

    SELECT @xrevenue = ISNULL(ROUND(SUM(CASE
                           WHEN REG.CODTIPOREGISTRO = 1 THEN
                            REV.REVENUETOTAL
                           WHEN REG.CODTIPOREGISTRO = 2 THEN
                            REV.REVENUETOTAL * (-1)
                           ELSE
                            0
                         END),
                     0),
               0)
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                 CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                 REG.CODPRODUCTO =
                                                 @xproduct)
      LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                             CTR.ID_ENTRADAARCHIVOCONTROL AND
                                             REV.CODREGISTROFACTURACION =
                                             REG.ID_REGISTROFACTURACION)
     WHERE CTR.REVERSADO = 0
       AND CTR.TIPOARCHIVO = @xservice
       AND CTR.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;

    -- Calculate into net value

    SET @xnetrevn = @xrevenue;

    IF @xvatmltp <> 0 BEGIN
      SET @xnetrevn = @xnetrevn + ROUND(@xrevenue * @xvatmltp, 0);
    END 
    IF (select count(*) from @xtaxlist) > 0 BEGIN
	
      DECLARE itx CURSOR FOR SELECT ID, VALUE FROM @xtaxlist
	  OPEN itx;
		DECLARE @id NUMERIC(38,0),@idvalue VARCHAR(MAX)
		 FETCH NEXT FROM itx INTO @id,@idvalue
		 WHILE @@FETCH_STATUS=0
		 BEGIN
				IF @id = 1 
					SET @xnetrevn = @xnetrevn - ROUND(@xrevenue * @idvalue, 0);
			ELSE IF @id = 2
			  SET @xnetrevn = @xnetrevn - ROUND((@xrevenue * @xvatmltp) * @idvalue, 0);
			FETCH NEXT FROM itx INTO @id,@idvalue
			END
			CLOSE itx;
			DEALLOCATE itx;
		 
    END;

    -- Open cursor with base data AND INFORMATIVE VALUES

    -- xnetwork

	set  @xnetworkVIA =82;

	SET @xconfigdiferencial= 1;

    if @xconfigdiferencial = 1 begin

    SET @xStringOtros ='Otras Redes';
    SET @xStringTipoDiferencial ='Red';

	     
    select * from (
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             WSXML_SFG.SFG_PACKAGE_StringRangoDeFechas(CONVERT(DATETIME,CFP.FECHAEJECUCION) - 6, CFP.FECHAEJECUCION) AS RANGOFECHAS,
             'CODIGOAGRUPACIONGTECH' AS CODIGOAGRUPACIONGTECH,
--             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             'NOMREDPDV' AS NOMREDPDV,
--             RED.NOMREDPDV AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             CODTIPOCOMISIONDF AS DIFRCODTIPOCOMISION,
             VALORPORCENTUALDF AS DIFRVALORPORCENTUAL,
             VALORTRANSACCIONALDF AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             ISNULL(CANTIDAD, 0) AS CANTIDAD,
             ISNULL(VENTAS, 0) AS VENTAS,
             ISNULL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             ISNULL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             ISNULL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             ISNULL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             ISNULL(COMISION, 0) AS COMISION,
             ISNULL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             ISNULL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             ISNULL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             ISNULL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(@xnetrevn, 0) * (-1) AS REVENUENETO,
             ISNULL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             ISNULL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             ISNULL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             ISNULL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 @xStringOtros AS XSTRINGOTROS,
                 @xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL,
                 NOMBRECORTO,
                 NOMRANGOCOMISIONDF,
                 PRIORIDAD
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1/* AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2/* AND
                                      REG.CODREDPDV <> xnetwork*/ THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 /*AND
                                      REG.CODREDPDV = xnetwork*/ THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     /*ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0)*/0 AS PREMIOSCADENA,
                           RCD.NOMBRECORTO,
                           RCD.VALORPORCENTUAL AS VALORPORCENTUALDF,
                           RCD.VALORTRANSACCIONAL VALORTRANSACCIONALDF,
                           CODTIPOCOMISION AS CODTIPOCOMISIONDF,
                           RCD.NOMRANGOCOMISION AS NOMRANGOCOMISIONDF,
                           PRIORIDAD

                FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           @xproduct)
                LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               LEFT OUTER JOIN (SELECT CD.CODREGISTROREVENUE,
                                     CD.NOMBRECORTO,
                                     RC.NOMRANGOCOMISION,
                                     RCD.VALORPORCENTUAL,
                                     RCD.VALORTRANSACCIONAL,
                                     RC.CODTIPOCOMISION ,
                                     PC.PRIORIDAD
                                FROM WSXML_SFG.REGISTROREVENUECOMDIF  CD,
                                     WSXML_SFG.PRODUCTOCONTRATOCOMDIF PC,
                                     WSXML_SFG.RANGOCOMISION          RC,
                                     WSXML_SFG.RANGOCOMISIONDETALLE   RCD
                               WHERE CD.CODPRODUCTOCONTRATOCOMDIF = PC.ID_PRODUCTOCONTRATOCOMDIF
                                 AND PC.CODRANGOCOMISION = RC.ID_RANGOCOMISION
                                 AND RCD.CODRANGOCOMISION = RC.ID_RANGOCOMISION) RCD ON (REV.ID_REGISTROREVENUE = RCD.CODREGISTROREVENUE)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = @xservice
                 AND CTR.CODCICLOFACTURACIONPDV =@p_CODCICLOFACTURACIONPDV
                 GROUP BY RCD.NOMBRECORTO, RCD.VALORPORCENTUAL, RCD.VALORTRANSACCIONAL, CODTIPOCOMISION, NOMRANGOCOMISION, PRIORIDAD) t
       INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.ID_PRODUCTO = @xproduct)
       INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       /*INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO \*AND
                                                PCD.CODREDPDV = xnetwork*\)*/
       INNER JOIN WSXML_SFG.RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       /*INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)*/
       /*INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)*/
       INNER JOIN WSXML_SFG.RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN WSXML_SFG.CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             @p_CODCICLOFACTURACIONPDV)
       /*LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                REG.CODAGRUPACIONPUNTODEVENTA)
       INNER JOIN REDPDV RED ON (RED.ID_REDPDV = REG.CODREDPDV)*/
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN WSXML_SFG.LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      @pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV)
                                                                      ) s 
		where nombrecorto is not null ORDER BY PRIORIDAD;


  -- xchainid
  /*
  elsif xconfigdiferencial = 2 then


  xStringOtros :='Otras Cadenas';
  xStringTipoDiferencial :='Cadena';

  OPEN p_cur FOR
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             AGR.NOMAGRUPACIONPUNTODEVENTA AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             RCD.CODTIPOCOMISION AS DIFRCODTIPOCOMISION,
             RDD.VALORPORCENTUAL AS DIFRVALORPORCENTUAL,
             RDD.VALORTRANSACCIONAL AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             NVL(CANTIDAD, 0) AS CANTIDAD,
             NVL(VENTAS, 0) AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             NVL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             NVL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             NVL(COMISION, 0) AS COMISION,
             NVL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             NVL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             NVL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             NVL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(xnetrevn, 0) * (-1) AS REVENUENETO,
             NVL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             NVL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             NVL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             NVL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 xStringOtros AS XSTRINGOTROS,
                 xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA <> xchainid THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODREDPDV = xnetworkVIA THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSCADENA
                FROM ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = xservice
                 AND CTR.CODCICLOFACTURACIONPDV =p_CODCICLOFACTURACIONPDV)
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO AND
                                                PCD.CODAGRUPACIONPUNTODEVENTA = xchainid)
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             p_CODCICLOFACTURACIONPDV)
	   LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)*\
       INNER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);

  -- xdepartamento

  elsif xconfigdiferencial = 3 then


    SELECT PCT.ID_PRODUCTOCONTRATO
      INTO xproductocontrato
      FROM PRODUCTOCONTRATO PCT
     WHERE PCT.CODPRODUCTO = xproduct;

    xStringOtros :='Otros Departamentos';
    xStringTipoDiferencial :='Departamento';

  OPEN p_cur FOR
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             SFG_PACKAGE.StringRangoDeFechas(CFP.FECHAEJECUCION - 6,
                                             CFP.FECHAEJECUCION) AS RANGOFECHAS,
             AGR.CODIGOAGRUPACIONGTECH AS CODIGOAGRUPACIONGTECH,
             DTO.NOMDEPARTAMENTO  AS NOMREDPDV,
             RCC.CODTIPOCOMISION AS GRALCODTIPOCOMISION,
             RDC.VALORPORCENTUAL AS GRALVALORPORCENTUAL,
             RDC.VALORTRANSACCIONAL AS GRALVALORTRANSACCIONAL,
             RCD.CODTIPOCOMISION AS DIFRCODTIPOCOMISION,
             RDD.VALORPORCENTUAL AS DIFRVALORPORCENTUAL,
             RDD.VALORTRANSACCIONAL AS DIFRVALORTRANSACCIONAL,
             RCE.CODTIPOCOMISION AS STNDCODTIPOCOMISION,
             RDE.VALORPORCENTUAL AS STNDVALORPORCENTUAL,
             RDE.VALORTRANSACCIONAL AS STNDVALORTRANSACCIONAL,
             NVL(CANTIDAD, 0) AS CANTIDAD,
             NVL(VENTAS, 0) AS VENTAS,
             NVL(IVAPRODUCTONOROUND, 0) AS IVAPRODUCTONOROUND,
             NVL(VENTASBRUTASNOROUNDRED, 0) AS VENTASBRUTASNOROUNDRED,
             NVL(VENTASBRUTASNOROUNDOTR, 0) AS VENTASBRUTASNOROUNDOTR,
             NVL(VENTASBRUTASNOROUND, 0) AS VENTASBRUTASNOROUND,
             NVL(COMISION, 0) AS COMISION,
             NVL(COMISIONANTICIPO, 0) * (-1) AS COMISIONANTICIPO,
             NVL(REVENUETOTALRED, 0) * (-1) AS REVENUETOTALRED,
             NVL(REVENUETOTALOTR, 0) * (-1) AS REVENUETOTALOTR,
             NVL(REVENUETOTAL, 0) * (-1) AS REVENUETOTAL,
             ROUND(xnetrevn, 0) * (-1) AS REVENUENETO,
             NVL(PREMIOSPAGADOS, 0) * (-1) AS PREMIOSPAGADOS,
             NVL(PREMIOSRED, 0) * (-1) AS PREMIOSRED,
             NVL(PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENA,
             NVL(PREMIOSPAGADOS - PREMIOSCADENA, 0) * (-1) AS PREMIOSCADENANETO,
             -- Case when already billed
             COALESCE(BLD.TOTALVALORAPAGAR,
                      NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             BLD.TOTALVALORAPAGAR AS TOTALFACTURADO,
             NVL(VENTAS - ROUND(xnetrevn, 0) - COMISIONANTICIPO -
                 (PREMIOSPAGADOS - PREMIOSCADENA),
                 0) AS TOTALCALCULADO,
                 xStringOtros AS XSTRINGOTROS,
                 xStringTipoDiferencial AS XSTRINGTIPODIFERENCIAL
        FROM (SELECT ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.NUMTRANSACCIONES
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.NUMTRANSACCIONES * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS CANTIDAD,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORTRANSACCION
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORTRANSACCION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTAS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO)
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  (REG.VALORTRANSACCION -
                                  REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS IVAPRODUCTONOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUND,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 0 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISION,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.COMISIONANTICIPO = 1 THEN
                                  REG.VALORCOMISION * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS COMISIONANTICIPO,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 AND
                                      REG.CODCIUDAD NOT IN (SELECT C.CODCIUDAD FROM PRODUCTOCONTRATOCOMDIFCIUDAD C ,
                                                                                PRODUCTOCONTRATOCOMDIF D
                                                                           WHERE C.ACTIVE = 1
                                                                           AND C.CODPRODUCTOCONTRATOCOMDIF = D.ID_PRODUCTOCONTRATOCOMDIF
                                                                           AND D.CODPRODUCTOCONTRATO = xproductocontrato) THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTALOTR,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1 THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2 THEN
                                  REV.REVENUETOTAL * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS REVENUETOTAL,

                     -- Premios clasificados de acuerdo a configuracion

                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSPAGADOS,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODREDPDV = xnetworkVIA THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 4 AND
                                      REG.CODAGRUPACIONPUNTODEVENTA = xchainid THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSCADENA
                FROM ENTRADAARCHIVOCONTROL CTR
                LEFT OUTER JOIN REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
                                                           CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                           REG.CODPRODUCTO =
                                                           xproduct)
                LEFT OUTER JOIN REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
                                                       CTR.ID_ENTRADAARCHIVOCONTROL AND
                                                       REV.CODREGISTROFACTURACION =
                                                       REG.ID_REGISTROFACTURACION)
               WHERE CTR.REVERSADO = 0
                 AND CTR.TIPOARCHIVO = xservice
                 AND CTR.CODCICLOFACTURACIONPDV =p_CODCICLOFACTURACIONPDV)
       INNER JOIN PRODUCTO PRD ON (PRD.ID_PRODUCTO = xproduct)
       INNER JOIN PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN PRODUCTOCONTRATOCOMDIF PCD ON (PCD.CODPRODUCTOCONTRATO =
                                                PCT.ID_PRODUCTOCONTRATO AND
                                                PCD.CODDEPARTAMENTO = xdepartamento)
       INNER JOIN RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCD ON (RCD.ID_RANGOCOMISION =
                                       PCD.CODRANGOCOMISION)
       INNER JOIN RANGOCOMISIONDETALLE RDD ON (RDD.CODRANGOCOMISION =
                                              RCD.ID_RANGOCOMISION)
       INNER JOIN RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       INNER JOIN CICLOFACTURACIONPDV CFP ON (CFP.ID_CICLOFACTURACIONPDV =
                                             p_CODCICLOFACTURACIONPDV)
       LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA AGR ON (AGR.ID_AGRUPACIONPUNTODEVENTA =
                                                xchainid)
       INNER JOIN DEPARTAMENTO DTO ON (DTO.ID_DEPARTAMENTO = xdepartamento)
        LEFT OUTER JOIN (SELECT LQP.ID_LIQUIDACIONREDPRODUCTO,
                                LQH.CODCICLOFACTURACIONPDV,
                                SUM(LQH.TOTALVALORAPAGAR) AS TOTALVALORAPAGAR
                           FROM LIQUIDACIONREDPRODUCTO LQP
                          INNER JOIN LIQUIDACIONREDPRODUCTOHISTORIC LQH ON (LQH.CODLIQUIDACIONREDPRODUCTO =
                                                                           LQP.ID_LIQUIDACIONREDPRODUCTO AND
                                                                           LQH.ID_LIQUIDACIONREDPRODUCTOHISTO =
                                                                           LQP.CODLIQUIDACIONREDPRODUCTOHISTO)
                          GROUP BY LQP.ID_LIQUIDACIONREDPRODUCTO,
                                   LQH.CODCICLOFACTURACIONPDV) BLD ON (BLD.ID_LIQUIDACIONREDPRODUCTO =
                                                                      pk_ID_LIQUIDACIONREDPRODUCTO AND
                                                                      BLD.CODCICLOFACTURACIONPDV =
                                                                      CFP.ID_CICLOFACTURACIONPDV);

  */
  end 

 END 
GO



IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionDetalle;
GO


  CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_GetInfoLiquidacionDetalle(@pk_ID_LIQUIDACIONREDPRODUCTO NUMERIC(22,0),
                                      @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                      @p_page_number                INTEGER,
                                      @p_batch_size                 INTEGER,
                                     @p_total_size                 INTEGER OUT) AS
 BEGIN
    DECLARE @xservice NUMERIC(22,0);
    DECLARE @xproduct NUMERIC(22,0);
    DECLARE @xnetwork NUMERIC(22,0);
    DECLARE @xchainid NUMERIC(22,0);
   
  SET NOCOUNT ON;
    -- Get parameter from configuration
    SELECT @xservice = CODSERVICIO,
           @xproduct = CODPRODUCTO,
           @xnetwork = CODREDPDVPRODUCTO,
           @xchainid = CODAGRUPACIONPUNTODEVENTAPRODU
      FROM WSXML_SFG.LIQUIDACIONREDPRODUCTO, WSXML_SFG.PRODUCTO, WSXML_SFG.TIPOPRODUCTO, WSXML_SFG.LINEADENEGOCIO
     WHERE CODLINEADENEGOCIO = ID_LINEADENEGOCIO
       AND CODTIPOPRODUCTO = ID_TIPOPRODUCTO
       AND ID_PRODUCTO = CODPRODUCTO
       AND ID_LIQUIDACIONREDPRODUCTO = @pk_ID_LIQUIDACIONREDPRODUCTO;

        SET @xnetwork=82;
    -- Configuracion semanal
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1)
        FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
       WHERE TIPOARCHIVO = @xservice
         AND CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV;
    END 
      		
      SELECT CTR.FECHAARCHIVO AS FECHA,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REG.NUMTRANSACCIONES
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          REG.NUMTRANSACCIONES * (-1)
                         ELSE
                          0
                       END),
                   0) AS CANTIDAD,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REG.VALORTRANSACCION
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          REG.VALORTRANSACCION * (-1)
                         ELSE
                          0
                       END),
                   0) AS VENTAS,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          (REG.VALORTRANSACCION - REG.VALORVENTABRUTANOREDONDEADO)
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          (REG.VALORTRANSACCION - REG.VALORVENTABRUTANOREDONDEADO) * (-1)
                         ELSE
                          0
                       END),
                   0) AS IVAPRODUCTONOROUND,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 AND REG.CODREDPDV = @xnetwork THEN
                          REG.VALORVENTABRUTANOREDONDEADO
                         WHEN REG.CODTIPOREGISTRO = 2 AND REG.CODREDPDV = @xnetwork THEN
                          REG.VALORVENTABRUTANOREDONDEADO * (-1)
                         ELSE
                          0
                       END),
                   0) AS VENTASBRUTASNOROUNDOTR,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 AND REG.CODREDPDV <> @xnetwork THEN
                          REG.VALORVENTABRUTANOREDONDEADO
                         WHEN REG.CODTIPOREGISTRO = 2 AND REG.CODREDPDV <> @xnetwork THEN
                          REG.VALORVENTABRUTANOREDONDEADO * (-1)
                         ELSE
                          0
                       END),
                   0) AS VENTASBRUTASNOROUNDRED,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REG.VALORVENTABRUTANOREDONDEADO
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          REG.VALORVENTABRUTANOREDONDEADO * (-1)
                         ELSE
                          0
                       END),
                   0) AS VENTASBRUTASNOROUND,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 AND REG.COMISIONANTICIPO = 0 THEN
                          REG.VALORCOMISION
                         WHEN REG.CODTIPOREGISTRO = 2 AND REG.COMISIONANTICIPO = 0 THEN
                          REG.VALORCOMISION * (-1)
                         ELSE
                          0
                       END),
                   0) AS COMISION,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 AND REG.COMISIONANTICIPO = 1 THEN
                          REG.VALORCOMISION
                         WHEN REG.CODTIPOREGISTRO = 2 AND REG.COMISIONANTICIPO = 1 THEN
                          REG.VALORCOMISION * (-1)
                         ELSE
                          0
                       END),
                   0) AS COMISIONANTICIPO,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 AND REG.CODREDPDV = @xnetwork THEN
                          REV.REVENUETOTAL
                         WHEN REG.CODTIPOREGISTRO = 2 AND REG.CODREDPDV = @xnetwork THEN
                          REV.REVENUETOTAL * (-1)
                         ELSE
                          0
                       END),
                   0) AS REVENUETOTALOTR,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 AND REG.CODREDPDV <> @xnetwork THEN
                          REV.REVENUETOTAL
                         WHEN REG.CODTIPOREGISTRO = 2 AND REG.CODREDPDV <> @xnetwork THEN
                          REV.REVENUETOTAL * (-1)
                         ELSE
                          0
                       END),
                   0) AS REVENUETOTALRED,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 1 THEN
                          REV.REVENUETOTAL
                         WHEN REG.CODTIPOREGISTRO = 2 THEN
                          REV.REVENUETOTAL * (-1)
                         ELSE
                          0
                       END),
                   0) AS REVENUETOTAL,
             -- Premios clasificados de acuerdo a configuracion
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 4 THEN
                          REG.VALORTRANSACCION
                         ELSE
                          0
                       END),
                   0) AS PREMIOSPAGADOS,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 4 AND REG.CODREDPDV = @xnetwork THEN
                          REG.VALORTRANSACCION
                         ELSE
                          0
                       END),
                   0) AS PREMIOSRED,
             ROUND(SUM(CASE
                         WHEN REG.CODTIPOREGISTRO = 4 AND
                              REG.CODAGRUPACIONPUNTODEVENTA = @xchainid THEN
                          REG.VALORTRANSACCION
                         ELSE
                          0
                       END),
                   0) AS PREMIOSCADENA
	FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
		INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
        LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL AND REV.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
	WHERE CTR.REVERSADO = 0
         AND CTR.TIPOARCHIVO = @xservice
         AND CTR.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
         AND REG.CODPRODUCTO = @xproduct
	GROUP BY CTR.FECHAARCHIVO
	ORDER BY CTR.FECHAARCHIVO;
	   
	
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_RegresarAUltimaLiquidacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_RegresarAUltimaLiquidacion;
GO



CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONREDPRODUCTO_RegresarAUltimaLiquidacion(@p_cod_producto NUMERIC(22,0)) AS
 BEGIN

  DECLARE @v_codliquidacionredproducto    NUMERIC(22,0);
  DECLARE @v_codliquidacionredproductohis NUMERIC(22,0);
  DECLARE @v_ant_liquidacionredproductohi NUMERIC(22,0);

 BEGIN TRY
	set nocount on;

  select @v_codliquidacionredproducto = t.id_liquidacionredproducto, @v_codliquidacionredproductohis = t.codliquidacionredproductohisto
    from wsxml_sfg.liquidacionredproducto t
   where t.codproducto = @p_cod_producto;

  select @v_ant_liquidacionredproductohi = max(h.id_liquidacionredproductohisto)
    from wsxml_sfg.liquidacionredproductohistoric h
   where h.id_liquidacionredproductohisto < @v_codliquidacionredproductohis
     and h.codliquidacionredproducto = @v_codliquidacionredproducto;

  update wsxml_sfg.liquidacionredproducto
     set codliquidacionredproductohisto = @v_ant_liquidacionredproductohi
   where id_liquidacionredproducto = @v_codliquidacionredproducto
     and codproducto = @p_cod_producto;

  delete from wsxml_sfg.liquidacionredproductohistoric
   where id_liquidacionredproductohisto = @v_codliquidacionredproductohis;

    commit;
END TRY
BEGIN CATCH
	declare @msgraisor varchar(2000) ='-20035 Error durante la reversion a la ultima liquidacion. Error : ' +isnull(ERROR_MESSAGE(), '')
    rollback;
    RAISERROR(@msgraisor, 16, 1);

END CATCH

END
GO

