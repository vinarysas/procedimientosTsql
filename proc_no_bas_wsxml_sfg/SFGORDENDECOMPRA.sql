USE SFGPRODU;


--  DDL for Package Body SFGORDENDECOMPRA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGORDENDECOMPRA */ 

  IF OBJECT_ID('WSXML_SFG.SFGORDENDECOMPRA_ObtenerConsecutivo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ObtenerConsecutivo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ObtenerConsecutivo(@p_page_number INTEGER,
                               @p_batch_size  INTEGER,
                              @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @xParameterUID VARCHAR(99) = 'ConsecutivoOrdenDeCompra';
    DECLARE @xCurrentValue VARCHAR(20);
   
  SET NOCOUNT ON;
    SELECT @xCurrentValue = WSXML_SFG.PARAMETRO_F(@xParameterUID);
    IF ISNULL(RTRIM(LTRIM(@xCurrentValue)), '-') = ISNULL('', '-') 
	BEGIN
		EXEC  WSXML_SFG.SFGPARAMETRO_SetOrReplaceParameter @xParameterUID, 'GT-000'
		SELECT @xCurrentValue = WSXML_SFG.PARAMETRO_F(@xParameterUID);
    END 
    /* Parse Any Numeric Section of the identifier */
    IF LEN(RTRIM(LTRIM(@xCurrentValue))) = 0 BEGIN
      RAISERROR('-20020 El formato del consecutivo de ordenes de compra configurado es incorrecto', 16, 1);
    END 
      DECLARE @pos INT = 0;
      DECLARE @cvl CHAR(1);
      DECLARE @val INT;
      DECLARE @fnp INT = 0;
      DECLARE @lnp INT = 0;
      DECLARE @chn NUMERIC(22,0) = 0;
      DECLARE @len INT = 0;
    BEGIN
      WHILE @pos < LEN(@xCurrentValue) BEGIN
        SET @pos = @pos + 1;
        SET @cvl = SUBSTRING(@xCurrentValue, @pos, 1);
        BEGIN
			BEGIN TRY
			  SET @val = CAST(@cvl AS INT);
			  IF @fnp = 0 BEGIN
				SET @fnp = @pos;
			  END 
			  SET @lnp = @pos;
			END TRY
			BEGIN CATCH
				  IF @lnp > 0 BEGIN
					BREAK
				END 
			END CATCH
        END;
      END;
      SET @len = @lnp - @fnp + 1;
      SET @chn = CAST(SUBSTRING(@xCurrentValue, @fnp, @len) AS INT);
      IF LEN(CONVERT(VARCHAR, @chn + 1)) > @len BEGIN
        SET @len = @len + 1;
      END 
      IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
        SET @p_total_size = 1;
      END 
		SELECT ISNULL(SUBSTRING(@xCurrentValue, 1, @fnp - 1), '') + ISNULL(RIGHT(REPLICATE('0', @len) + LEFT(@chn + 1, @len),@len), '') AS RESULTVALUE;
    END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGORDENDECOMPRA_ConfiguracionProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ConfiguracionProducto;
GO

CREATE     PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ConfiguracionProducto(@p_CODPRODUCTO NUMERIC(22,0),
                                  @p_FECHATARIFA DATETIME,
                                  @p_page_number INTEGER,
                                  @p_batch_size  INTEGER,
                                 @p_total_size  INTEGER OUT) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      set @p_total_size = 1;
    END 
      SELECT PRD.NOMPRODUCTO                AS NOMPRODUCTO,
             ISNULL(RCM.CODTIPOCOMISION, 0)    AS CODTIPOCOMISION,
             ISNULL(RCD.VALORPORCENTUAL, 0)    AS VALORPORCENTUAL,
             ISNULL(RCD.VALORTRANSACCIONAL, 0) AS VALORTRANSACCIONAL,
             ISNULL(CPI.CONFIGURACION, 'N')    AS CONFIGURACION,
             ISNULL(CPI.DENOMINACION, 0)       AS DENOMINACION
      FROM WSXML_SFG.PRODUCTO PRD
      INNER JOIN WSXML_SFG.PRODUCTOCONTRATO              PCT ON (PCT.CODPRODUCTO         = PRD.ID_PRODUCTO)
      LEFT OUTER JOIN WSXML_SFG.PRODCONTRATOHISTORICO    PCH ON (PCH.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND PCH.FECHAINICIOVALIDEZ = CONVERT(DATETIME, CONVERT(DATE,@p_FECHATARIFA)))
      LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION            RCM ON (RCM.ID_RANGOCOMISION    = COALESCE(PCH.CODRANGOCOMISION, PCT.CODRANGOCOMISION) AND RCM.CODTIPOCOMISION IN (1, 2, 3))
      LEFT OUTER JOIN WSXML_SFG.RANGOCOMISIONDETALLE     RCD ON (RCD.CODRANGOCOMISION    = RCM.ID_RANGOCOMISION)
      LEFT OUTER JOIN WSXML_SFG.CONFIGPRODUCTOINVENTARIO CPI ON (CPI.CODPRODUCTO         = PRD.ID_PRODUCTO)
      WHERE PRD.ID_PRODUCTO = @p_CODPRODUCTO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGORDENDECOMPRA_CalcularElementoOrdenDeCompra', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_CalcularElementoOrdenDeCompra;
GO

CREATE     PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_CalcularElementoOrdenDeCompra(@p_CODPRODUCTO NUMERIC(22,0),
                                          @p_FECHATARIFA DATETIME,
                                          @p_CANTIDAD    NUMERIC(22,0),
                                          @p_VALOR       FLOAT,
                                          @p_page_number INTEGER,
                                          @p_batch_size  INTEGER,
                                         @p_total_size  INTEGER OUT) AS
 BEGIN
    DECLARE @TipoContratoProducto NUMERIC(22,0);
    DECLARE @RangoComision        NUMERIC(22,0);
    DECLARE @TipoComision         NUMERIC(22,0);
    DECLARE @ValorPorcentual      FLOAT;
    DECLARE @ValorTransaccional   FLOAT;
    DECLARE @Configuracion        CHAR(1);
    DECLARE @Denominacion         FLOAT;
    DECLARE @Revenue              FLOAT = 0;
   
  SET NOCOUNT ON;
    SELECT @TipoContratoProducto = COALESCE(PCH.CODTIPOCONTRATOPRODUCTO, PCT.CODTIPOCONTRATOPRODUCTO),
           @RangoComision = COALESCE(PCH.CODRANGOCOMISION, PCT.CODRANGOCOMISION) ,
           @TipoComision = ISNULL(RCM.CODTIPOCOMISION, 0) ,
           @ValorPorcentual = ISNULL(RCD.VALORPORCENTUAL, 0) ,
           @ValorTransaccional = ISNULL(RCD.VALORTRANSACCIONAL, 0),
           @Configuracion = ISNULL(CPI.CONFIGURACION, 'V'),
           @Denominacion = ISNULL(CPI.DENOMINACION, 0) 
    FROM WSXML_SFG.PRODUCTO PRD
    INNER JOIN WSXML_SFG.PRODUCTOCONTRATO              PCT ON (PCT.CODPRODUCTO         = PRD.ID_PRODUCTO)
    LEFT OUTER JOIN WSXML_SFG.PRODCONTRATOHISTORICO    PCH ON (PCH.CODPRODUCTOCONTRATO = PCT.ID_PRODUCTOCONTRATO AND PCH.FECHAINICIOVALIDEZ = CONVERT(DATETIME, CONVERT(DATE,@p_FECHATARIFA)))
    LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION            RCM ON (RCM.ID_RANGOCOMISION    = COALESCE(PCH.CODRANGOCOMISION, PCT.CODRANGOCOMISION) AND RCM.CODTIPOCOMISION IN (1, 2, 3))
    LEFT OUTER JOIN WSXML_SFG.RANGOCOMISIONDETALLE     RCD ON (RCD.CODRANGOCOMISION    = RCM.ID_RANGOCOMISION)
    LEFT OUTER JOIN WSXML_SFG.CONFIGPRODUCTOINVENTARIO CPI ON (CPI.CODPRODUCTO         = PRD.ID_PRODUCTO)
    WHERE PRD.ID_PRODUCTO = @p_CODPRODUCTO;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = 1;
    END 
    IF @Configuracion = 'D' BEGIN
      IF @TipoComision IN (1, 3) BEGIN
        SET @Revenue = @Revenue + (((@p_CANTIDAD * @Denominacion) * @ValorPorcentual) / 100);
      END
      ELSE IF @TipoComision IN (2, 3) BEGIN
        SET @Revenue = @Revenue + (@p_CANTIDAD * @ValorTransaccional);
      END 
    END
    ELSE IF @Configuracion = 'V' BEGIN
      IF @TipoComision IN (1, 3) BEGIN
        SET @Revenue = @Revenue + ((@p_VALOR * @ValorPorcentual) / 100);
      END
      ELSE IF @TipoComision IN (2, 3) BEGIN
        SET @Revenue = @Revenue + (0 * @ValorTransaccional);
      END 
    END 
      SELECT @p_CODPRODUCTO                                                                 AS CODPRODUCTO,
             @TipoContratoProducto                                                          AS CODTIPOCONTRATOPRODUCTO,
             @RangoComision                                                                 AS CODRANGOCOMISION,
             CASE WHEN @Configuracion = 'D' THEN @p_CANTIDAD
                  WHEN @Configuracion = 'V' THEN 0
             ELSE 0 END                                                                    AS CANTIDAD,
             CASE WHEN @Configuracion = 'D' THEN @p_CANTIDAD * @Denominacion
                  WHEN @Configuracion = 'V' THEN @p_VALOR
             ELSE 0 END                                                                    AS VALOR,
             CASE WHEN @Configuracion = 'D' THEN @Revenue / CASE WHEN ISNULL(@p_CANTIDAD, 0) = 0 THEN 1 ELSE @p_CANTIDAD END
                  WHEN @Configuracion = 'V' THEN @Revenue / CASE WHEN ISNULL(@p_VALOR, 0) = 0 THEN 1 ELSE @p_VALOR END
             ELSE 0 END                                                                    AS VALORUNITARIO,
             CASE WHEN @Configuracion = 'D' THEN (@p_CANTIDAD * @Denominacion) - @Revenue
                  WHEN @Configuracion = 'V' THEN @p_VALOR - @Revenue
             ELSE 0 END                                                                    AS VALORTOTAL
     ;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGORDENDECOMPRA_CalcularImpuestosOrdenDeCompra', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_CalcularImpuestosOrdenDeCompra;
GO

CREATE     PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_CalcularImpuestosOrdenDeCompra(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                                           @p_CODORDENDECOMPRA     NUMERIC(22,0),
                                           @p_page_number          INTEGER,
                                           @p_batch_size           INTEGER,
                                          @p_total_size           INTEGER OUT) AS
 BEGIN
    DECLARE @TotalDescuento FLOAT = 0;
    DECLARE @VATComision    FLOAT = 0;
    DECLARE @ImpuestoList   WSXML_SFG.IDVALUE;
   
  SET NOCOUNT ON;
    SELECT @TotalDescuento = SUM(VALORDESCUENTO) FROM WSXML_SFG.ORDENDECOMPRADETALLE WHERE CODORDENDECOMPRA = @p_CODORDENDECOMPRA;
    --SET @ImpuestoList = IDVALUELIST();
    /* TRIBUTARIOALIADOESTRATEGICO */
    SELECT @VATComision = (@TotalDescuento * ISNULL(TAE.VALORVAT, 0)) / 100 
	FROM WSXML_SFG.ALIADOESTRATEGICO AES
    LEFT OUTER JOIN WSXML_SFG.TRIBUTARIOALIADOESTRATEGICO TAE ON (TAE.CODALIADOESTRATEGICO = AES.ID_ALIADOESTRATEGICO)
    WHERE AES.ID_ALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
    
    INSERT INTO @ImpuestoList VALUES (0, @VATComision);

    /* RETENCIONALIADOESTRATEGICO */
    DECLARE tret CURSOR FOR SELECT RTB.ID_RETENCIONTRIBUTARIA, RTB.CODBASERETENCION, (ISNULL(RAE.VALOR, 0)) AS VALOR
                 FROM WSXML_SFG.ALIADOESTRATEGICO AES
                 INNER JOIN      WSXML_SFG.RETENCIONTRIBUTARIA        RTB ON (1 = 1)
                 LEFT OUTER JOIN WSXML_SFG.RETENCIONALIADOESTRATEGICO RAE ON (RAE.CODALIADOESTRATEGICO = AES.ID_ALIADOESTRATEGICO AND RAE.CODRETENCIONTRIBUTARIA = RTB.ID_RETENCIONTRIBUTARIA)
                 WHERE AES.ID_ALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO; 
	OPEN tret;

	DECLARE @tret__ID_RETENCIONTRIBUTARIA NUMERIC(38,0), @tret__CODBASERETENCION NUMERIC(38,0), @tret__VALOR AS FLOAT
	
	FETCH NEXT FROM tret INTO  @tret__ID_RETENCIONTRIBUTARIA, @tret__CODBASERETENCION, @tret__VALOR


	 WHILE @@FETCH_STATUS=0
	 BEGIN

      DECLARE @ValorRetencion FLOAT = 0;
      BEGIN
        IF @tret__CODBASERETENCION = 1 BEGIN
          SET @ValorRetencion = (@TotalDescuento * @tret__VALOR) / 100;
        END
        ELSE IF @tret__CODBASERETENCION = 2 BEGIN
          SET @ValorRetencion = (@VATComision * @tret__VALOR) / 100;
        END 
        INSERT INTO @ImpuestoList VALUES (@tret__ID_RETENCIONTRIBUTARIA, @ValorRetencion);
      END;

		FETCH NEXT FROM tret INTO  @tret__ID_RETENCIONTRIBUTARIA, @tret__CODBASERETENCION, @tret__VALOR
    END;
    CLOSE tret;
    DEALLOCATE tret;
    /* CONFIGALIADOIMPUESTO */
    DECLARE timp CURSOR FOR SELECT IAE.ID_IMPUESTOALIADOESTRATEGICO, IAE.SUMAORESTA,
                        ISNULL(IAE.CODIMPUESTOALIADOBASE, -1) AS CODIMPUESTOALIADOBASE, ISNULL(CAI.CODRANGOCOMISION, 0) AS CODRANGOCOMISION
                 FROM WSXML_SFG.ALIADOESTRATEGICO AES
                 INNER JOIN      WSXML_SFG.IMPUESTOALIADOESTRATEGICO IAE ON (1 = 1)
                 LEFT OUTER JOIN WSXML_SFG.CONFIGALIADOIMPUESTO      CAI ON (CAI.CODIMPUESTOALIADOESTRATEGICO = IAE.ID_IMPUESTOALIADOESTRATEGICO AND CAI.CODALIADOESTRATEGICO = AES.ID_ALIADOESTRATEGICO)
                 WHERE AES.ID_ALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO ORDER BY IAE.ORDEN; 
	OPEN timp;

	 DECLARE @timp_ID_IMPUESTOALIADOESTRATEGICO NUMERIC(38,0), @timp_SUMAORESTA CHAR(1),
                        @timp_CODIMPUESTOALIADOBASE NUMERIC(38,0), @timp_CODRANGOCOMISION NUMERIC(38,0)

	 FETCH NEXT FROM timp INTO  @timp_ID_IMPUESTOALIADOESTRATEGICO, @timp_SUMAORESTA,
                        @timp_CODIMPUESTOALIADOBASE, @timp_CODRANGOCOMISION

	 WHILE @@FETCH_STATUS=0
	 BEGIN
		  IF @timp_CODRANGOCOMISION <> 0 BEGIN
			  DECLARE @BaseCalculo   FLOAT = 0;
			  DECLARE @ValorImpuesto FLOAT = 0;
			BEGIN
			  /* Busqueda de Base de Calculo */
			  IF @timp_CODIMPUESTOALIADOBASE = -1 BEGIN
				SET @BaseCalculo = @TotalDescuento;
			  END
			  ELSE BEGIN
				IF (SELECT COUNT(*) FROM @ImpuestoList) > 0 
				BEGIN
				  DECLARE ipx CURSOR FOR SELECT ID, VALUE FROM @ImpuestoList
			  
				  DECLARE @ipx_id numeric(38,0), @ipx_value float;
				  FETCH NEXT FROM ipx INTO  @ipx_id, @ipx_value;

				  WHILE (@@FETCH_STATUS = 0)
					BEGIN
						IF @ipx_id = @timp_CODIMPUESTOALIADOBASE 
						BEGIN
						  SET @BaseCalculo = @ipx_value;
						  BREAK
						END
						FETCH NEXT FROM ipx INTO  @ipx_id, @ipx_value;
					END
					CLOSE ipx;
					DEALLOCATE ipx; 
              
				END
			  END
			  /* Calculo. Solo se permiten Comisiones Tipo 1, 2, 3 */
          
			  DECLARE @VPorcentual    FLOAT, @VTransaccional FLOAT;
          
			  BEGIN
				SELECT @VPorcentual = ISNULL(VALORPORCENTUAL, 0), @VTransaccional = ISNULL(VALORTRANSACCIONAL, 0) 
				FROM WSXML_SFG.RANGOCOMISION RCM
					LEFT OUTER JOIN WSXML_SFG.RANGOCOMISIONDETALLE RCD ON (RCD.CODRANGOCOMISION = RCM.ID_RANGOCOMISION AND RCM.CODTIPOCOMISION IN (1, 2, 3))
				WHERE RCM.ID_RANGOCOMISION = @timp_CODRANGOCOMISION;
				SET @ValorImpuesto = ((@BaseCalculo * @VPorcentual) / 100) + @VTransaccional;
			  END;
			  INSERT INTO @ImpuestoList VALUES(@timp_ID_IMPUESTOALIADOESTRATEGICO, @ValorImpuesto);
			END 

		  END

		  FETCH NEXT FROM timp INTO  @timp_ID_IMPUESTOALIADOESTRATEGICO, @timp_SUMAORESTA,
                        @timp_CODIMPUESTOALIADOBASE, @timp_CODRANGOCOMISION
	 END 
    

		IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size 
		BEGIN
			SET @p_total_size = (SELECT COUNT(*) FROM @ImpuestoList)
		END 

		SELECT 0                                     AS ID_TRIBUTARIOALIADOESTRATEGICO,
             'IVA Comision'                        AS NOMTRIBUTARIOALIADOESTRATEGICO,
             CONVERT(VARCHAR, '+')                          AS SUMAORESTA,
             ROUND(@VATComision, 6)                 AS VALORIMPUESTO
	
		UNION

		SELECT ID_RETENCIONTRIBUTARIA                AS ID_TRIBUTARIOALIADOESTRATEGICO,
             CONVERT(VARCHAR, NOMRETENCIONTRIBUTARIA)       AS NOMTRIBUTARIOALIADOESTRATEGICO,
             CONVERT(VARCHAR, '-')                          AS SUMAORESTA,
             ROUND(RAV.VALUE, 6)                   AS VALORIMPUESTO
		FROM WSXML_SFG.RETENCIONTRIBUTARIA RTB, (SELECT ID, VALUE FROM @ImpuestoList) RAV WHERE RAV.ID = RTB.ID_RETENCIONTRIBUTARIA

		UNION

		SELECT ID_IMPUESTOALIADOESTRATEGICO          AS ID_TRIBUTARIOALIADOESTRATEGICO,
             CONVERT(VARCHAR, NOMIMPUESTOALIADOESTRATEGICO) AS NOMTRIBUTARIOALIADOESTRATEGICO,
             CONVERT(VARCHAR, SUMAORESTA)                   AS SUMAORESTA,
             ROUND(CIV.VALUE, 6)                   AS VALORIMPUESTO
		FROM WSXML_SFG.IMPUESTOALIADOESTRATEGICO IAE, (SELECT ID, VALUE FROM @ImpuestoList) CIV
		WHERE CIV.ID = IAE.ID_IMPUESTOALIADOESTRATEGICO

		ORDER BY ID_TRIBUTARIOALIADOESTRATEGICO;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGORDENDECOMPRA_ObtenerLeadTimePromedio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ObtenerLeadTimePromedio;
GO

  CREATE PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ObtenerLeadTimePromedio(@p_CODPRODUCTO  NUMERIC(22,0),
                                    @p_DIASPROMEDIO NUMERIC(22,0),
                                    @p_page_number  INTEGER,
                                    @p_batch_size   INTEGER,
                                   @p_total_size   INTEGER OUT) AS
 BEGIN
    DECLARE @aliadoID   NUMERIC(22,0);
    DECLARE @checkCount NUMERIC(22,0);
    DECLARE @queryStamp DATETIME = GETDATE();
   
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SET @p_total_size = 1;
    END 
    SELECT @aliadoID = CODALIADOESTRATEGICO FROM WSXML_SFG.PRODUCTO WHERE ID_PRODUCTO = @p_CODPRODUCTO;
    SELECT @checkCount = COUNT(1) 
	FROM WSXML_SFG.ORDENDECOMPRA ODC
    INNER JOIN WSXML_SFG.ORDENDECOMPRADETALLE    OCD ON (OCD.CODORDENDECOMPRA           = ODC.ID_ORDENDECOMPRA)
    INNER JOIN WSXML_SFG.CARGAINVENTARIOPRODUCTO CIP ON (CIP.CODORDENDECOMPRADETALLE    = OCD.ID_ORDENDECOMPRADETALLE
                                           AND CIP.ID_CARGAINVENTARIOPRODUCTO = OCD.CODCARGAINVENTARIOPRODUCTO)
    INNER JOIN WSXML_SFG.INVENTARIOPRODUCTO      INV ON (INV.ID_INVENTARIOPRODUCTO      = CIP.CODINVENTARIOPRODUCTO)
    WHERE ODC.CODALIADOESTRATEGICO = @aliadoID
      AND ODC.FECHAEMISION BETWEEN CONVERT(DATETIME, CONVERT(DATE,(@queryStamp - ABS(@p_DIASPROMEDIO)))) AND CONVERT(DATETIME,CONVERT(DATE,(@queryStamp)))
      AND OCD.CODPRODUCTO          = @p_CODPRODUCTO;
    IF @checkCount = 0 BEGIN
        SELECT -1 AS LEADTIMEPROMEDIO;
    END
    ELSE BEGIN
        SELECT SUM( DATEDIFF(DD, ODC.FECHAEMISION,  INV.FECHAINVENTARIO)) / WSXML_SFG.DBLIFZERO(COUNT(1), 1) AS LEADTIMEPROMEDIO 
		FROM WSXML_SFG.ORDENDECOMPRA ODC
        INNER JOIN WSXML_SFG.ORDENDECOMPRADETALLE    OCD ON (OCD.CODORDENDECOMPRA           = ODC.ID_ORDENDECOMPRA)
        INNER JOIN WSXML_SFG.CARGAINVENTARIOPRODUCTO CIP ON (CIP.CODORDENDECOMPRADETALLE    = OCD.ID_ORDENDECOMPRADETALLE
                                               AND CIP.ID_CARGAINVENTARIOPRODUCTO = OCD.CODCARGAINVENTARIOPRODUCTO)
        INNER JOIN WSXML_SFG.INVENTARIOPRODUCTO      INV ON (INV.ID_INVENTARIOPRODUCTO      = CIP.CODINVENTARIOPRODUCTO)
        WHERE ODC.CODALIADOESTRATEGICO = @aliadoID
          AND ODC.FECHAEMISION BETWEEN CONVERT(DATETIME, CONVERT(DATE,(@queryStamp - ABS(@p_DIASPROMEDIO)))) AND CONVERT(DATETIME, CONVERT(DATE,@queryStamp))
          AND OCD.CODPRODUCTO          = @p_CODPRODUCTO;
    END 
  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGORDENDECOMPRA_ExportarData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ExportarData;
GO

  CREATE PROCEDURE WSXML_SFG.SFGORDENDECOMPRA_ExportarData(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                         @p_ESTADOAPROBACION     CHAR,
                         @p_FECHADESDE           DATETIME,
                         @p_FECHAHASTA           DATETIME,
                         @p_page_number          INTEGER,
                         @p_batch_size           INTEGER,
                        @p_total_size           INTEGER OUT) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_page_number = @p_page_number OR @p_batch_size = @p_batch_size BEGIN
      SELECT @p_total_size = COUNT(1) FROM WSXML_SFG.ORDENDECOMPRA ODC, WSXML_SFG.ORDENDECOMPRADETALLE OCD
       WHERE ODC.ID_ORDENDECOMPRA     = OCD.CODORDENDECOMPRA
         AND ODC.CODALIADOESTRATEGICO = CASE WHEN @p_CODALIADOESTRATEGICO = -1 THEN ODC.CODALIADOESTRATEGICO ELSE @p_CODALIADOESTRATEGICO END
         AND ODC.ESTADOAPROBACION     = CASE WHEN @p_ESTADOAPROBACION   = '-1' THEN ODC.ESTADOAPROBACION     ELSE @p_ESTADOAPROBACION END
         AND ODC.FECHAEMISION BETWEEN @p_FECHADESDE AND @p_FECHAHASTA;
    END 
      SELECT ODC.ID_ORDENDECOMPRA,
             AES.NOMALIADOESTRATEGICO,
             ODC.CONSECUTIVO,
             ODC.FECHAEMISION,
             USR.NOMBRE,
             ODC.FECHAHORASOLICITUD,
             CASE WHEN ODC.ESTADOAPROBACION = 'I' THEN 'En Espera' WHEN ODC.ESTADOAPROBACION = 'A' THEN 'Aprobado' WHEN ODC.ESTADOAPROBACION = 'R' THEN 'Rechazado' END AS ESTADOAPROBACION,
             ODC.TOTALORDENDECOMPRA,
             PRD.NOMPRODUCTO,
             OCD.CANTIDAD,
             OCD.VALOR,
             OCD.VALORUNITARIO,
             OCD.VALORDESCUENTO,
             OCD.VALORPEDIDO
        FROM WSXML_SFG.ORDENDECOMPRA ODC, WSXML_SFG.ORDENDECOMPRADETALLE OCD, WSXML_SFG.ALIADOESTRATEGICO AES, WSXML_SFG.USUARIO USR, WSXML_SFG.PRODUCTO PRD
       WHERE ODC.ID_ORDENDECOMPRA     = OCD.CODORDENDECOMPRA
         AND ODC.CODALIADOESTRATEGICO = AES.ID_ALIADOESTRATEGICO
         AND ODC.CODUSUARIOSOLICITUD  = USR.ID_USUARIO
         AND OCD.CODPRODUCTO          = PRD.ID_PRODUCTO
         AND ODC.CODALIADOESTRATEGICO = CASE WHEN @p_CODALIADOESTRATEGICO = -1 THEN ODC.CODALIADOESTRATEGICO ELSE @p_CODALIADOESTRATEGICO END
         AND ODC.ESTADOAPROBACION     = CASE WHEN @p_ESTADOAPROBACION   = '-1' THEN ODC.ESTADOAPROBACION     ELSE @p_ESTADOAPROBACION END
         AND ODC.FECHAEMISION BETWEEN @p_FECHADESDE AND @p_FECHAHASTA
       ORDER BY ODC.ID_ORDENDECOMPRA, OCD.ID_ORDENDECOMPRADETALLE;
  END;

GO


