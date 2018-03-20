USE SFGPRODU;
--  DDL for Package Body SFGLIQUIDACIONINDEPPRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO */ 

  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_ReversarFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_ReversarFacturacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_ReversarFacturacion(@pk_ID_LIQ_INDEPENDIENTE NUMERIC(22,0),
                                @p_FECHAINICIO DATETIME,
                                @p_FECHAFIN DATETIME) AS
 BEGIN
    DECLARE @xCurrentHisto NUMERIC(22,0);
    DECLARE @xCurrentCiclo DATETIME;
    DECLARE @xFechaFin     DATETIME;
    DECLARE @xNewCurrentCy NUMERIC(22,0);
    DECLARE @xNewCurrentHs NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @xCurrentHisto = LIP.ID_LIQ_IND_GENERADA, @xCurrentCiclo = LID.FECHAINICIO, @xFechaFin = LID.FECHAINICIO
	FROM WSXML_SFG.LIQ_IND_GENERADA LIP, WSXML_SFG.LIQ_IND_GEN_DETALLE LID
	WHERE LIP.CODLIQINDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE
       AND LIP. ID_LIQ_IND_GENERADA = LID.COD_LIQ_IND_GENERADA;

    IF @xCurrentCiclo <> @p_FECHAINICIO AND @xFechaFin <> @p_FECHAFIN  BEGIN
       IF @@ROWCOUNT = 0 BEGIN
			RAISERROR('-20035 El ciclo ingresado no corresponde con el ciclo actual facturado', 16, 1);
			RETURN 0
		END
    END 

    SELECT @xNewCurrentHs = ID_LIQ_IND_GEN_DETALLE
	FROM WSXML_SFG.LIQ_IND_GEN_DETALLE LIGD
	WHERE LIGD.COD_LIQ_IND_GENERADA = @xCurrentHisto
		AND @p_FECHAINICIO = @xCurrentCiclo;

	IF @@ROWCOUNT = 0 BEGIN
		RAISERROR('-20035 El ciclo ingresado no corresponde con el ciclo actual facturado', 16, 1);
		RETURN 0;
	END
    -- Update and delete

	DELETE FROM WSXML_SFG.LIQINDEPGENAJUSTE WHERE COD_LIQ_IND_DETALLE = @xNewCurrentHs;

	DELETE FROM WSXML_SFG.LIQ_IND_GEN_DETALLE WHERE COD_LIQ_IND_GENERADA = @xCurrentHisto;
  
	 
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_EstablecerFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_EstablecerFacturacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_EstablecerFacturacion(@pk_ID_LIQ_INDEPENDIENTE         NUMERIC(22,0),
                                  @p_FECHAINICIO                   DATETIME,
                                  @p_FECHA_FIN                     DATETIME,
                                  @p_COD_LIQ_IND_GENERADA          NUMERIC(22,0),
                                  @p_adjustmentdescriptions        WSXML_SFG.IDSTRINGVALUE READONLY,
                                  @p_adjustmentvalues              WSXML_SFG.IDVALUE READONLY,
                                  @p_TOTALVALORAPAGAR              FLOAT,
                                  @p_CODUSUARIOGENERACION          NUMERIC(22,0),
                                  @p_ID_LIQ_IND_GEN_DETALLE_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @xCODPRODUCTO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    -- Check for previously billed
      DECLARE @xExistingHistoricID NUMERIC(22,0);
      DECLARE @xExistingLiqGeneradaID NUMERIC(22,0);

    BEGIN
		SELECT @xExistingHistoricID = ID_LIQ_IND_GEN_DETALLE
        FROM WSXML_SFG.LIQ_IND_GEN_DETALLE LIGD
		WHERE LIGD.COD_LIQ_IND_GENERADA = (SELECT LIG.ID_LIQ_IND_GENERADA
                                          FROM WSXML_SFG.LIQ_IND_GENERADA LIG
                                          WHERE LIG.CODLIQINDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE)
            AND LIGD.FECHAHORAGENERACION = @p_FECHAINICIO;
			
		IF @@ROWCOUNT > 0 BEGIN
			RAISERROR('-20030 Ya se ha facturado el ciclo para este producto', 16, 1);
			RETURN 0;
		END
		
    END;
    -- Check for concurrency (skip holes, check for higher value)
    DECLARE @xCurrentHistoricRec NUMERIC(22,0);
    DECLARE @xCurrentHistoricSeq DATETIME;
    BEGIN

      SELECT @xCurrentHistoricRec = LIGD.ID_LIQ_IND_GEN_DETALLE
        FROM WSXML_SFG.LIQ_IND_GEN_DETALLE LIGD
        INNER JOIN WSXML_SFG.LIQ_IND_PRODUCTO LIP
        ON LIGD.COD_LIQ_IND_GENERADA = LIP.COD_LIQ_IND_GENERADA
        INNER JOIN WSXML_SFG.LIQ_IND_GENERADA LIG
        ON LIGD.COD_LIQ_IND_GENERADA = LIG.ID_LIQ_IND_GENERADA
       WHERE LIG.CODLIQINDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE;
      IF @xCurrentHistoricRec IS NOT NULL BEGIN
        SELECT @xCurrentHistoricSeq = LID.FECHAHORAGENERACION
          FROM WSXML_SFG.LIQ_IND_GEN_DETALLE LID
         WHERE LID.FECHAHORAGENERACION = @p_FECHAINICIO
           AND ID_LIQ_IND_GEN_DETALLE = @xCurrentHistoricRec;
        IF @xCurrentHistoricSeq >= @p_FECHAINICIO BEGIN
          RAISERROR('-20031 No se puede facturar una semana anterior al actualmente facturado', 16, 1);
		  RETURN 0
        END 
      END 
    END;
    -- Insert dependent records and update header
    INSERT INTO WSXML_SFG.LIQ_IND_GEN_DETALLE
      (
       COD_LIQ_IND_GENERADA,
       TOTALVALORAPAGAR,
       CODUSUARIOGENERACION,
       FECHAHORAGENERACION
       )
    VALUES
      (
       @p_COD_LIQ_IND_GENERADA,
       ROUND(@p_TOTALVALORAPAGAR, 2),
       @p_CODUSUARIOGENERACION,
       GETDATE());
    SET @p_ID_LIQ_IND_GEN_DETALLE_out = SCOPE_IDENTITY();
    IF (SELECT COUNT(*) FROM @p_adjustmentdescriptions) > 0 BEGIN
      IF (SELECT COUNT(*) FROM @p_adjustmentdescriptions) = (SELECT COUNT(*) FROM @p_adjustmentvalues) BEGIN
        
		DECLARE iax CURSOR FOR SELECT ID, VALUE FROM @p_adjustmentdescriptions
		
		OPEN iax;

		DECLARE @iax_ID NUMERIC(38,0), @iax_VALUE varchar(2000)

		 FETCH NEXT FROM iax INTO @iax_ID, @iax_VALUE
		 WHILE @@FETCH_STATUS=0
		 BEGIN
          INSERT INTO WSXML_SFG.LIQINDEPGENAJUSTE
            (
             DESCRIPCION,
             VALOR,
             COD_LIQ_IND_DETALLE)
          VALUES
            (
             @iax_VALUE,
             (SELECT VALUE FROM @p_adjustmentvalues WHERE ID = @iax_ID ),
             @p_ID_LIQ_IND_GEN_DETALLE_out);
        FETCH NEXT FROM iax INTO @iax_ID, @iax_VALUE
        END;
        CLOSE iax;
        DEALLOCATE iax;
      END
      ELSE BEGIN
        RAISERROR('-20032 Las descripciones de los ajustes no corresponden con los valores', 16, 1);
      END 
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_EstablecerFactEncabezado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_EstablecerFactEncabezado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_EstablecerFactEncabezado(@pk_ID_LIQ_INDEPENDIENTE         NUMERIC(22,0),
                                     @p_FECHAINICIO                   DATETIME,
                                     @p_FECHAFIN                      DATETIME,
                                     @p_TOTALVALORAPAGAR              FLOAT,
                                     @p_CODUSUARIOGENERACION          NUMERIC(22,0),
                                     @p_ID_LIQ_IND_GEN_DETALLE_out NUMERIC(22,0) OUT) AS
 BEGIN

    DECLARE @billingValue   FLOAT = ROUND(@p_TOTALVALORAPAGAR, 2);
    DECLARE @insertedValue  FLOAT = 0;
	DECLARE @msg VARCHAR(2000)
   
  SET NOCOUNT ON;

    -- Check for previously billed
      DECLARE @xExistingHistoricID NUMERIC(22,0);
		BEGIN
			SELECT @xExistingHistoricID = ID_LIQ_IND_GEN_DETALLE
			FROM WSXML_SFG.LIQ_IND_GEN_DETALLE LIGD
			WHERE LIGD.COD_LIQ_IND_GENERADA = (SELECT LIG.ID_LIQ_IND_GENERADA
											 FROM WSXML_SFG.LIQ_IND_GENERADA LIG
											 WHERE LIG.CODLIQINDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE)
											 AND LIGD.FECHAINICIO = @p_FECHAINICIO
											 AND LIGD.FECHAFIN = @p_FECHAFIN;
			IF @@ROWCOUNT > 0 BEGIN
				SET @msg = '-20030 Ya se ha facturado el ciclo ' +' para este producto';
				RAISERROR(@msg, 16, 1);
			END
			
		END;
    -- Check for concurrency (skip holes, check for higher value)
      DECLARE @xCurrentHistoricRec NUMERIC(22,0);
      DECLARE @xCurrentHistoricSeq NUMERIC(22,0);
    BEGIN


    -- Insert dependent records and update header
		INSERT INTO WSXML_SFG.LIQ_IND_GEN_DETALLE
		  (
		   COD_LIQ_IND_GENERADA,
		   TOTALVALORAPAGAR,
		   CODUSUARIOGENERACION,
		   FECHAHORAGENERACION)
		VALUES
		  (
		   @pk_ID_LIQ_INDEPENDIENTE,
		   @billingValue,
		   @p_CODUSUARIOGENERACION,
		   GETDATE());
	   
	   SET @p_ID_LIQ_IND_GEN_DETALLE_out = SCOPE_IDENTITY();
	END;
  END;

  GO

  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_InsertarElementoAjuste', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_InsertarElementoAjuste;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_InsertarElementoAjuste(@p_COD_LIQ_IND_GEN_DETALLE      NUMERIC(22,0),
                                   @p_DESCRIPCION                  NVARCHAR(2000),
                                   @p_VALOR                        FLOAT) AS
 BEGIN
    DECLARE @adjustmentValue FLOAT = ROUND(@p_VALOR, 2);
    DECLARE @insertedValue   FLOAT = 0;
   
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.LIQINDEPGENAJUSTE
      (
       COD_LIQ_IND_DETALLE,
       DESCRIPCION,
       VALOR)
    VALUES
      (
       @p_COD_LIQ_IND_GEN_DETALLE,
       @p_DESCRIPCION,
       @adjustmentValue);
    SET @insertedValue = SCOPE_IDENTITY();
    UPDATE WSXML_SFG.LIQ_IND_GEN_DETALLE
       SET TOTALVALORAPAGAR = TOTALVALORAPAGAR + @insertedValue
     WHERE ID_LIQ_IND_GEN_DETALLE = @p_COD_LIQ_IND_GEN_DETALLE;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionIndTaxes', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionIndTaxes;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionIndTaxes(@pk_ID_LIQ_INDEPENDIENTE       NUMERIC(22,0),
                                       @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                       @p_page_number                INTEGER,
                                       @p_batch_size                 INTEGER,
                                      @p_total_size                 INTEGER OUT) AS
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
    SELECT @xproduct = LIP.COD_PRODUCTO
      FROM WSXML_SFG.LIQ_IND_PRODUCTO LIP,
      WSXML_SFG.PRODUCTO PRO
     WHERE ID_LIQ_IND_PRODUCTO = @pk_ID_LIQ_INDEPENDIENTE
     AND LIP.COD_PRODUCTO = PRO.ID_PRODUCTO;

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


--RETENCIONES A APLICAR AL ALIDO
	INSERT INTO @xtaxlist
		SELECT RT.ID_RETENCIONTRIBUTARIA, (ISNULL(RA.VALOR, 0) / 100)

		FROM WSXML_SFG.PRODUCTO                     P,
			   WSXML_SFG.ALIADOESTRATEGICO          A,
			   WSXML_SFG.RETENCIONALIADOESTRATEGICO RA,
			   WSXML_SFG.RETENCIONTRIBUTARIA        RT
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
		 INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL =
											   CTR.ID_ENTRADAARCHIVOCONTROL)
		 INNER JOIN WSXML_SFG.REGISTROREVENUE REV ON (REV.CODENTRADAARCHIVOCONTROL =
										   CTR.ID_ENTRADAARCHIVOCONTROL AND
										   REV.CODREGISTROFACTURACION =
										   REG.ID_REGISTROFACTURACION)
	   WHERE CTR.REVERSADO = 0
		   AND CTR.TIPOARCHIVO = @xservice
		   AND CTR.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
		   AND REG.CODPRODUCTO = @xproduct;

    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = (select count(*) from @xtaxlist) + CASE WHEN @xvatmltp <> 0 THEN 1 ELSE 0 END;
    END 
    IF @xvatmltp <> 0 AND (select count(*) from @xtaxlist) > 0 BEGIN
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
                  ROUND((@xrevenue * @xvatmltp) * VALUE, 0)
                 ELSE
                  0
               END AS VALOR
          FROM (SELECT ID, VALUE FROM @xtaxlist) TAX
         INNER JOIN WSXML_SFG.RETENCIONTRIBUTARIA RET ON (RET.ID_RETENCIONTRIBUTARIA =
                                               TAX.ID)
         ORDER BY ORDEN;
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionBilledAdjust', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionBilledAdjust;
GO

CREATE     PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionBilledAdjust(@pk_ID_LIQ_INDEPENDIENTE       NUMERIC(22,0),
                                           @p_FECHAINICIO                 DATETIME,
                                           @p_FECHAFIN                    DATETIME,
                                           @p_page_number                 INTEGER,
                                           @p_batch_size                  INTEGER,
                                          @p_total_size                  INTEGER OUT) AS
  BEGIN
  SET NOCOUNT ON;
    -- OPnly invoked when already billed. Does not have to be current
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1)
        FROM WSXML_SFG.LIQ_IND_GENERADA LQP
       INNER JOIN WSXML_SFG.LIQ_IND_GEN_DETALLE LQH ON (LQH.COD_LIQ_IND_GENERADA =
                                              LQP.ID_LIQ_IND_GENERADA AND
                                              LQH.FECHAINICIO = @p_FECHAINICIO AND
                                              LQH.FECHAFIN = @p_FECHAFIN)
                                             INNER JOIN  WSXML_SFG.LIQINDEPGENAJUSTE AJS ON
                                             (AJS.COD_LIQ_IND_DETALLE =
                                             LQH.ID_LIQ_IND_GEN_DETALLE);
    END 
      SELECT AJS.ID_LIQINDEPGENAJUSTE,
             AJS.DESCRIPCION,
             AJS.VALOR
        FROM WSXML_SFG.LIQ_IND_GENERADA LQP
       INNER JOIN WSXML_SFG.LIQ_IND_GEN_DETALLE LQH ON (LQH.COD_LIQ_IND_GENERADA =
                                              LQP.ID_LIQ_IND_GENERADA AND
                                              LQH.FECHAINICIO = @p_FECHAINICIO AND
                                              LQH.FECHAFIN = @p_FECHAFIN
                                            )
                                            INNER JOIN  WSXML_SFG.LIQINDEPGENAJUSTE AJS ON
                                            (AJS.COD_LIQ_IND_DETALLE =
                                            LQH.ID_LIQ_IND_GEN_DETALLE)
       WHERE LQP.CODLIQINDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE
       ORDER BY AJS.ID_LIQINDEPGENAJUSTE;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionIndVIA', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionIndVIA;
GO

CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionIndVIA(@pk_ID_LIQ_INDEPENDIENTE NUMERIC(22,0),
                                          @p_CODCICLOFACTURACIONPDV     NUMERIC(22,0),
                                          @p_page_number                INTEGER,
                                          @p_batch_size                 INTEGER,
                                         @p_total_size                 INTEGER OUT) AS
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
    SELECT @xproduct = COD_PRODUCTO
      FROM WSXML_SFG.LIQ_IND_PRODUCTO
     WHERE ID_LIQ_IND_PRODUCTO = @pk_ID_LIQ_INDEPENDIENTE;

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
		INNER JOIN WSXML_SFG.RETENCIONTRIBUTARIAREGIMEN ON (CODRETENCIONTRIBUTARIA =
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
                                                 REG.CODPRODUCTO = @xproduct)
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

		DECLARE @itx__ID NUMERIC(38,0), @itx__VALUE NUMERIC(38,0) 
		
		FETCH NEXT FROM itx INTO @itx__ID, @itx__VALUE;
		WHILE @@FETCH_STATUS=0
		BEGIN
			IF @itx__ID = 1 
				SET @xnetrevn = @xnetrevn - ROUND(@xrevenue * @itx__VALUE, 0);
			ELSE 
				IF @itx__ID = 2
					SET @xnetrevn = @xnetrevn - ROUND((@xrevenue * @xvatmltp) * @itx__VALUE, 0);
        FETCH NEXT FROM itx INTO @itx__ID, @itx__VALUE;
        END
        CLOSE itx;
        DEALLOCATE itx;
      
    END

    -- Open cursor with base data AND INFORMATIVE VALUES

    -- xnetwork

    SET @xnetworkVIA = 82;

	SET @xconfigdiferencial= 1;

    if @xconfigdiferencial = 1 begin

    SET @xStringOtros ='Otras Redes';
    SET @xStringTipoDiferencial ='Red';

    Select * from (
      SELECT PRD.NOMPRODUCTO AS NOMPRODUCTO,
             WSXML_SFG.SFG_PACKAGE_StringRangoDeFechas(lqid.fechainicio, lqid.fechafin) AS RANGOFECHAS,
             'CODIGOAGRUPACIONGTECH' AS CODIGOAGRUPACIONGTECH,
             'NOMREDPDV' AS NOMREDPDV,
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
             COALESCE(LQID.TOTALVALORAPAGAR,
                      ISNULL(VENTAS - ROUND(@xnetrevn, 0) - COMISIONANTICIPO -
                          (PREMIOSPAGADOS - PREMIOSCADENA),
                          0)) AS TOTALAPAGAR,
             LQID.TOTALVALORAPAGAR AS TOTALFACTURADO,
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
                                 WHEN REG.CODTIPOREGISTRO = 1  THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2  THEN
                                  REG.VALORVENTABRUTANOREDONDEADO * (-1)
                                 ELSE
                                  0
                               END),
                           0) AS VENTASBRUTASNOROUNDRED,
                     ROUND(SUM(CASE
                                 WHEN REG.CODTIPOREGISTRO = 1  THEN
                                  REG.VALORVENTABRUTANOREDONDEADO
                                 WHEN REG.CODTIPOREGISTRO = 2  THEN
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
                                 WHEN REG.CODTIPOREGISTRO = 1  THEN
                                  REV.REVENUETOTAL
                                 WHEN REG.CODTIPOREGISTRO = 2  THEN
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
                                 WHEN REG.CODTIPOREGISTRO = 4  THEN
                                  REG.VALORTRANSACCION
                                 ELSE
                                  0
                               END),
                           0) AS PREMIOSRED,
                     0 AS PREMIOSCADENA,
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
                 GROUP BY RCD.NOMBRECORTO, RCD.VALORPORCENTUAL, RCD.VALORTRANSACCIONAL, CODTIPOCOMISION, NOMRANGOCOMISION
		) T
       INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.ID_PRODUCTO = @xproduct)
       INNER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT ON (PCT.CODPRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN WSXML_SFG.LIQ_IND_PRODUCTO LQIP ON (LQIP.COD_PRODUCTO =
                                          PRD.ID_PRODUCTO)
       INNER JOIN WSXML_SFG.LIQ_IND_GENERADA LQG ON (LQG.ID_LIQ_IND_GENERADA =
                                          LQIP.COD_LIQ_IND_GENERADA)
       INNER JOIN WSXML_SFG.LIQ_INDEPENDIENTE LQI ON (LQI.ID_LIQ_INDEPENDIENTE =
                                           LQG.CODLIQINDEPENDIENTE)
       INNER JOIN WSXML_SFG.LIQ_IND_GEN_DETALLE LQID ON (LQID.COD_LIQ_IND_GENERADA =
                                               LQG.ID_LIQ_IND_GENERADA)
       INNER JOIN WSXML_SFG.RANGOCOMISION RCC ON (RCC.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISION)
       INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RDC ON (RDC.CODRANGOCOMISION =
                                              RCC.ID_RANGOCOMISION)

       INNER JOIN WSXML_SFG.RANGOCOMISION RCE ON (RCE.ID_RANGOCOMISION =
                                       PCT.CODRANGOCOMISIONESTANDAR)
       INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RDE ON (RDE.CODRANGOCOMISION =
                                              RCE.ID_RANGOCOMISION)
       ) s;


 end 

  END 
GO


IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionProducto;
GO

CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionProducto(@pk_ID_LIQ_INDEPENDIENTE      NUMERIC(22,0),
                                     @p_FECHAINICIO                DATETIME,
                                     @p_FECHAFIN                   DATETIME,
                                     @p_page_number                INTEGER,
                                     @p_batch_size                 INTEGER,
                                    @p_total_size                 INTEGER OUT) AS
 BEGIN

  --DECLARE
    DECLARE @SIGNO      NVARCHAR(1);
    DECLARE @NOMBRE     NVARCHAR(20);
    DECLARE @VALOR_VENTAS NUMERIC(22,0);
    DECLARE @VALOR_ANULACIONES NUMERIC(22,0);
    DECLARE @VALOR_FLETE NUMERIC(22,0);
    DECLARE @REVENUE_AJUSTES NUMERIC(22,0);
    DECLARE @REVENUE_VENTAS NUMERIC(22,0);

   
  SET NOCOUNT ON;
    SET @p_total_size = 1;
     SELECT   --PRODUCTO.ID_PRODUCTO AS CODPRODUCTO,
                --LQP.COD_LIQ_INDEPENDIENTE AS ID_LIQ_INDEPENDIENTE,
                --ENTRADAARCHIVOCONTROL.FECHAARCHIVO AS FECHAARCHIVO,
                CASE WHEN PRODUCTO.CODTIPOPRODUCTO = 10 THEN '-' ELSE '+' END AS SIGNO,
                    CASE WHEN PRODUCTO.ID_PRODUCTO IN (1872,1873) THEN 'GIRO DEPOSITO'
                     WHEN PRODUCTO.ID_PRODUCTO IN (1874) THEN 'GIRO RETIRO VIA'
                     WHEN PRODUCTO.ID_PRODUCTO IN (1875) THEN 'GIRO RETIRO OTRAS'
                     ELSE PRODUCTO.NOMPRODUCTO
                 END AS NOMBRE,
                ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA ELSE 0 END ),0) AS VALOR_VENTAS,
                ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA ELSE 0 END ),0) AS VALOR_ANULACIONES,
                ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN FLT.FLETE ELSE 0 END ),0) AS VALOR_FLETE,
                ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(REGISTROREVENUE.REVENUEBASE,0) ELSE 0 END ),0) AS REVENUE_AJUSTES,
                ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN ISNULL(REGISTROREVENUE.REVENUEBASE,0) ELSE 0 END ),0) AS REVENUE_VENTAS
       --INTO SIGNO, NOMBRE, VALOR_VENTAS, VALOR_ANULACIONES, VALOR_FLETE, REVENUE_AJUSTES, REVENUE_VENTAS
       FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       INNER JOIN WSXML_SFG.LIQ_IND_PRODUCTO LQP ON LQP.COD_PRODUCTO = REGISTROFACTURACION.CODPRODUCTO
       LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE ON REGISTROREVENUE.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
       LEFT OUTER JOIN
            (
             SELECT REGISTROFACTURACION.ID_REGISTROFACTURACION AS CODREGISTROFACTURACION,
                    SUM(CASE WHEN PRODUCTO.NOMPRODUCTO LIKE '%GIRO%EFECTY%' THEN CAST(REGISTROFACTREFERENCIA.SUSCRIPTOR AS NUMERIC(38,0)) ELSE REGISTROFACTREFERENCIA.VRCOMISION END) AS FLETE
             FROM WSXML_SFG.REGISTROFACTREFERENCIA
             INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
             GROUP BY REGISTROFACTURACION.ID_REGISTROFACTURACION
            )FLT ON FLT.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION


       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @p_FECHAINICIO AND @p_FECHAFIN
       AND REGISTROFACTURACION.CODPRODUCTO IN (SELECT COD_PRODUCTO FROM WSXML_SFG.liq_ind_producto WHERE COD_LIQ_INDEPENDIENTE = @pk_ID_LIQ_INDEPENDIENTE )
       GROUP BY  PRODUCTO.ID_PRODUCTO, LQP.COD_LIQ_INDEPENDIENTE,
       --ENTRADAARCHIVOCONTROL.FECHAARCHIVO,-- REGISTROFACTURACION.FECHATRANSACCION,
       CASE WHEN PRODUCTO.ID_PRODUCTO IN (1872,1873) THEN 'GIRO DEPOSITO'
                     WHEN PRODUCTO.ID_PRODUCTO IN (1874) THEN 'GIRO RETIRO VIA'
                     WHEN PRODUCTO.ID_PRODUCTO IN (1875) THEN 'GIRO RETIRO OTRAS'
                     ELSE PRODUCTO.NOMPRODUCTO
                 END ,
                 CASE WHEN PRODUCTO.CODTIPOPRODUCTO = 10 THEN '-' ELSE '+' END
       ORDER BY 1 ;

END;
GO

IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionDetalle;
GO

  CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_GetInfoLiquidacionDetalle(@pk_ID_LIQ_INDEPENDIENTE      NUMERIC(22,0),
                                     @p_FECHAINICIO                DATETIME,
                                     @p_FECHAFIN                   DATETIME,
                                     @p_page_number                INTEGER,
                                     @p_batch_size                 INTEGER,
                                    @p_total_size                 INTEGER OUT) AS
 BEGIN
    DECLARE @v_CODLIQUIDACION NUMERIC(22,0)= @pk_ID_LIQ_INDEPENDIENTE;
    DECLARE @v_FECHAINICIO DATETIME= @p_FECHAINICIO;
    DECLARE @v_FECHAFIN DATETIME= @p_FECHAFIN;
    DECLARE @FECHAARCHIVO DATETIME;
    DECLARE @SIGNO      NVARCHAR(1);
    DECLARE @NOMBRE     NVARCHAR(20);
    DECLARE @VALOR_VENTAS NUMERIC(22,0);
    DECLARE @VALOR_ANULACIONES NUMERIC(22,0);
    DECLARE @VALOR_FLETE NUMERIC(22,0);
    DECLARE @REVENUE_AJUSTES NUMERIC(22,0);
    DECLARE @REVENUE_VENTAS NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SET @p_total_size = 1;
      SELECT  ENTRADAARCHIVOCONTROL.FECHAARCHIVO,
             CASE WHEN PRODUCTO.CODTIPOPRODUCTO = 10 THEN '-' ELSE '+' END AS SIGNO,
             CASE WHEN PRODUCTO.ID_PRODUCTO IN (1872,1873) THEN 'GIRO DEPOSITO'
             WHEN PRODUCTO.ID_PRODUCTO IN (1874) THEN 'GIRO RETIRO VIA'
             WHEN PRODUCTO.ID_PRODUCTO IN (1875) THEN 'GIRO RETIRO OTRAS'
             ELSE PRODUCTO.NOMPRODUCTO
             END AS NOMBRE,
             ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN REGISTROFACTURACION.VALORVENTABRUTA ELSE 0 END ),0) AS VALOR_VENTAS,
             ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN REGISTROFACTURACION.VALORVENTABRUTA ELSE 0 END ),0) AS VALOR_ANULACIONES,
             ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN FLT.FLETE ELSE 0 END ),0) AS VALOR_FLETE,
             ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 2 THEN ISNULL(REGISTROREVENUE.REVENUEBASE,0) ELSE 0 END ),0) AS REVENUE_AJUSTES,
             ROUND(SUM(CASE WHEN REGISTROFACTURACION.CODTIPOREGISTRO = 1 THEN ISNULL(REGISTROREVENUE.REVENUEBASE,0) ELSE 0 END ),0) AS REVENUE_VENTAS
       --INTO FECHAARCHIVO, SIGNO, NOMBRE, VALOR_VENTAS, VALOR_ANULACIONES, VALOR_FLETE, REVENUE_AJUSTES, REVENUE_VENTAS
       FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
       LEFT OUTER JOIN WSXML_SFG.REGISTROREVENUE ON REGISTROREVENUE.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
       LEFT OUTER JOIN
            (
             SELECT REGISTROFACTURACION.ID_REGISTROFACTURACION AS CODREGISTROFACTURACION,
                    SUM(CASE WHEN PRODUCTO.NOMPRODUCTO LIKE '%GIRO%EFECTY%' THEN CAST(REGISTROFACTREFERENCIA.SUSCRIPTOR AS NUMERIC(38,0)) ELSE REGISTROFACTREFERENCIA.VRCOMISION END) AS FLETE
             FROM WSXML_SFG.REGISTROFACTREFERENCIA
             INNER JOIN WSXML_SFG.REGISTROFACTURACION ON REGISTROFACTREFERENCIA.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION
             INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
             INNER JOIN WSXML_SFG.PRODUCTO ON REGISTROFACTURACION.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
             GROUP BY REGISTROFACTURACION.ID_REGISTROFACTURACION
            )FLT ON FLT.CODREGISTROFACTURACION = REGISTROFACTURACION.ID_REGISTROFACTURACION

       WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO BETWEEN @v_FECHAINICIO AND @v_FECHAFIN
       AND REGISTROFACTURACION.CODPRODUCTO IN (SELECT COD_PRODUCTO FROM WSXML_SFG.liq_ind_producto WHERE COD_LIQ_INDEPENDIENTE = @v_CODLIQUIDACION)
       GROUP BY  ENTRADAARCHIVOCONTROL.FECHAARCHIVO,
                 CASE WHEN PRODUCTO.ID_PRODUCTO IN (1872,1873) THEN 'GIRO DEPOSITO'
                      WHEN PRODUCTO.ID_PRODUCTO IN (1874) THEN 'GIRO RETIRO VIA'
                      WHEN PRODUCTO.ID_PRODUCTO IN (1875) THEN 'GIRO RETIRO OTRAS'
                      ELSE PRODUCTO.NOMPRODUCTO
                 END ,
                 CASE WHEN PRODUCTO.CODTIPOPRODUCTO = 10 THEN '-' ELSE '+' END
       ORDER BY 1;
        END;
GO



IF OBJECT_ID('WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_RegresarAUltimaLiquidacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_RegresarAUltimaLiquidacion;
GO

CREATE PROCEDURE WSXML_SFG.SFGLIQUIDACIONINDEPPRODUCTO_RegresarAUltimaLiquidacion(@p_COD_LIQ_INDEPENDIENTE NUMERIC(22,0)) AS
 BEGIN

  set nocount on;

  DECLARE @v_cod_liq_ind_producto    NUMERIC(22,0);
  DECLARE @v_cod_liq_ind_gen_detalle NUMERIC(22,0);
  DECLARE @v_ant_liq_ind_gen_detalle NUMERIC(22,0);
  DECLARE @v_cod_liq_ind_generada    NUMERIC(22,0);
  DECLARE @v_ant_liq_independiente   NUMERIC(22,0);
  DECLARE @msg VARCHAR(2000)
  BEGIN TRANSACTION;
  
  BEGIN TRY
 


	  select @v_cod_liq_ind_generada = t.id_liq_ind_generada
		from wsxml_sfg.liq_ind_generada t
	   where t.codliqindependiente = @p_COD_LIQ_INDEPENDIENTE;

	  select @v_ant_liq_ind_gen_detalle = max(h.id_liq_ind_gen_detalle)
		from wsxml_sfg.liq_ind_gen_detalle h
	   where h.id_liq_ind_gen_detalle < @v_cod_liq_ind_gen_detalle;

	   delete from wsxml_sfg.liq_ind_generada
	   where codliqindependiente = @v_cod_liq_ind_generada;

	   delete from wsxml_sfg.liq_ind_gen_detalle
	   where id_liq_ind_gen_detalle = @v_cod_liq_ind_gen_detalle;

		COMMIT TRANSACTION;   
	END TRY
	BEGIN CATCH
		rollback TRANSACTION;
		SET @msg = '-20035 Error durante la reversion a la ultima liquidacion. Error : ' + isnull(ERROR_MESSAGE() , '')
	    RAISERROR(@msg, 16, 1);
	END CATCH



END
GO
