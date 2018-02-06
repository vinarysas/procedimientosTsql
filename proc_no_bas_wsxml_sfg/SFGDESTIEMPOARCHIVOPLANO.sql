USE SFGPRODU;
--  DDL for Package Body SFGDESTIEMPOARCHIVOPLANO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO */ 

  IF OBJECT_ID('WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO_GetDestiempoFacturacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO_GetDestiempoFacturacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO_GetDestiempoFacturacion(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                                    @p_FECHAFACTURADO       DATETIME,
                                    @p_FECHACORTECONTABLE   DATETIME,
                                    @p_page_number          INTEGER,
                                    @p_batch_size           INTEGER,
                                   @p_total_size           INTEGER OUT) AS
 BEGIN
    DECLARE @xLastBilledFile       NUMERIC(22,0);
    DECLARE @lstBilledFilesBetween WSXML_SFG.LONGNUMBERARRAY;
    DECLARE @cntBilledFilesBetween NUMERIC(22,0) = 0;
    DECLARE @nmoBilledFilesBetween NVARCHAR(1000);
    DECLARE @lstContableFiles      WSXML_SFG.NUMBERARRAY;
    DECLARE @xContableTransactionCount NUMERIC(22,0);
    DECLARE @xContableTransactionValue FLOAT;
    DECLARE @xContableTransactionRvnue FLOAT;
    DECLARE @xPlainTransactionCount NUMERIC(22,0);
    DECLARE @xPlainTransactionValue FLOAT;
    DECLARE @xPlainTransactionRvnue FLOAT;
   
  SET NOCOUNT ON;
    -- Get last Billed File
    BEGIN
		BEGIN TRY
		  SELECT @xLastBilledFile = ID_ARCHIVOTRANSACCIONALIADO
		  FROM (
				SELECT ID_ARCHIVOTRANSACCIONALIADO, NOMBREARCHIVO,
					ROW_NUMBER() OVER(ORDER BY FECHAARCHIVO DESC, NOMBREARCHIVO DESC) ID_ROW_NUMBER
				FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
				WHERE CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO AND FECHAARCHIVO <= CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFACTURADO))
				--ORDER BY FECHAARCHIVO DESC, NOMBREARCHIVO DESC
		  ) s;
		END TRY
		BEGIN CATCH
		  RAISERROR('-20012 No se pudo encontrar el ultimo archivo facturado de la fecha', 16, 1);
		END CATCH
    END;
    -- Get plain files in between
	INSERT INTO @lstBilledFilesBetween
    SELECT ID_ARCHIVOTRANSACCIONALIADO  FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
     WHERE CODALIADOESTRATEGICO =  @p_CODALIADOESTRATEGICO
       AND FECHAARCHIVO         >  CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFACTURADO))
       AND FECHAARCHIVO         <= CONVERT(DATETIME, CONVERT(DATE,@p_FECHACORTECONTABLE))
    ORDER BY FECHAARCHIVO ASC, NOMBREARCHIVO ASC;

    SET @cntBilledFilesBetween = (SELECT COUNT(*) FROM  @lstBilledFilesBetween)
    -- Concatenate those file names
    IF @cntBilledFilesBetween > 0 AND @cntBilledFilesBetween <= 20 BEGIN

      DECLARE ifx CURSOR FOR 
		SELECT IDVALUE, ROW_NUMBER() OVER(ORDER BY IDVALUE ASC) ID_ROW_NUMBER 
		FROM @lstBilledFilesBetween --.First..lstBilledFilesBetween.Last LOOP

		OPEN ifx;

		DECLARE @ifx_IDVALUE NUMERIC(38,0), @ifx_ID_ROW_NUMBER  numeric(38,0)
		DECLARE @tmpFileName VARCHAR(4000) /* Use -meta option ARCHIVOTRANSACCIONALIADO.NOMBREARCHIVO%TYPE */;
		FETCH NEXT FROM ifx INTO @ifx_IDVALUE, @ifx_ID_ROW_NUMBER

		WHILE (@@FETCH_STATUS = 0) 
        BEGIN

			  SELECT @tmpFileName = NOMBREARCHIVO FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO WHERE ID_ARCHIVOTRANSACCIONALIADO = @ifx_IDVALUE

			  --IF @ifx_IDVALUE = lstBilledFilesBetween.First 
			  IF @ifx_ID_ROW_NUMBER = 1
			  BEGIN
				SET @nmoBilledFilesBetween = '<br />' + ISNULL(@tmpFileName, '');
			  END
			  ELSE BEGIN
				SET @nmoBilledFilesBetween = ISNULL(@nmoBilledFilesBetween, '') + ', <br />' + ISNULL(@tmpFileName, '');
			  END 

        
			  FETCH NEXT FROM ifx INTO @ifx_IDVALUE, @ifx_ID_ROW_NUMBER
		END;
		CLOSE ifx;
		DEALLOCATE ifx;
    END 
    -- Get contable values from last day
    SELECT @xContableTransactionCount = ISNULL(SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN REG.NUMTRANSACCIONES WHEN REG.CODTIPOREGISTRO = 2 THEN REG.NUMTRANSACCIONES * (-1) ELSE 0 END), 0),
           @xContableTransactionValue = ISNULL(SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN REG.VALORTRANSACCION WHEN REG.CODTIPOREGISTRO = 2 THEN REG.VALORTRANSACCION * (-1) ELSE 0 END), 0),
           @xContableTransactionRvnue = ISNULL(SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 THEN REV.REVENUETOTAL     WHEN REG.CODTIPOREGISTRO = 2 THEN REV.REVENUETOTAL * (-1)     ELSE 0 END), 0)
    FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
    INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
    INNER JOIN WSXML_SFG.REGISTROREVENUE     REV ON (REV.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL AND REV.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
    INNER JOIN WSXML_SFG.PRODUCTO            PRD ON (PRD.ID_PRODUCTO              = REG.CODPRODUCTO)
    WHERE CTR.REVERSADO = 0 AND CTR.FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHACORTECONTABLE))
      AND PRD.CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
    -- Get transaction values from last contable day
    SELECT @xPlainTransactionCount = ISNULL(COUNT(1), 0), @xPlainTransactionValue = ISNULL(SUM(VALORTRANSACCION), 0), @xPlainTransactionRvnue = ISNULL(SUM(REVENUETRANSACCION), 0)
    FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO
    INNER JOIN WSXML_SFG.TRANSACCIONALIADO ON (CODARCHIVOTRANSACCIONALIADO = ID_ARCHIVOTRANSACCIONALIADO)
    WHERE FECHAARCHIVO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHACORTECONTABLE)) AND CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
    SET @p_total_size = @cntBilledFilesBetween + 2;
      SELECT 1                                                                                                                    AS ORDEN,
             'Ya facturado'                                                                                                       AS DEFINITION,
             'Ultimo archivo facturado: ' + ISNULL(CONVERT(VARCHAR, ARC.NOMBREARCHIVO), '') + ' (' + ISNULL(FORMAT(ARC.FECHAARCHIVO, 'dd/MM/yyyy'), '') + ')' AS DESCRIPTION,
             COUNT(TXA.ID_TRANSACCIONALIADO)                                                                                      AS NUMTRANSACCIONES,
             SUM(TXA.VALORTRANSACCION)                                                                                            AS VALORTRANSACCION,
             SUM(TXA.REVENUETRANSACCION)                                                                                          AS REVENUETOTAL
      FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO ARC
      INNER JOIN WSXML_SFG.TRANSACCIONALIADO TXA ON (TXA.CODARCHIVOTRANSACCIONALIADO = ARC.ID_ARCHIVOTRANSACCIONALIADO)
      WHERE ARC.ID_ARCHIVOTRANSACCIONALIADO = @xLastBilledFile
      GROUP BY ARC.NOMBREARCHIVO, ARC.FECHAARCHIVO
      UNION
      SELECT 2                                                                                                                    AS ORDEN,
             'Por facturar'                                                                                                       AS DEFINITION,
             'Archivos por facturar: ' + ISNULL(@cntBilledFilesBetween, '') +
             ISNULL(CASE WHEN LEN(@nmoBilledFilesBetween) > 0 THEN CONVERT(VARCHAR, ' - ' + ISNULL(@nmoBilledFilesBetween, '')) ELSE '' END, '')                 AS DESCRIPTION,
             COUNT(TXA.ID_TRANSACCIONALIADO)                                                                                      AS NUMTRANSACCIONES,
             SUM(TXA.VALORTRANSACCION)                                                                                            AS VALORTRANSACCION,
             SUM(TXA.REVENUETRANSACCION)                                                                                          AS REVENUETOTAL
      FROM WSXML_SFG.ARCHIVOTRANSACCIONALIADO ARC
      INNER JOIN WSXML_SFG.TRANSACCIONALIADO TXA ON (TXA.CODARCHIVOTRANSACCIONALIADO = ARC.ID_ARCHIVOTRANSACCIONALIADO)
      WHERE ARC.ID_ARCHIVOTRANSACCIONALIADO IN (SELECT IDVALUE FROM @lstBilledFilesBetween)
      UNION
      SELECT 3                                                                                                                    AS ORDEN,
             'Destiempo Contable'                                                                                                 AS DEFINITION,
             'Transacciones contables del dia no incluidas en archivo'                                                            AS DESCRIPTION,
             @xContableTransactionCount - @xPlainTransactionCount                                                                   AS NUMTRANSACCIONES,
             @xContableTransactionValue - @xPlainTransactionValue                                                                   AS VALORTRANSACCION,
             @xContableTransactionRvnue - @xPlainTransactionRvnue                                                                   AS REVENUETOTAL
      UNION
      SELECT 4                                                                                                                    AS ORDEN,
             'Transacciones faltantes'                                                                                            AS DEFINITION,
             'Transacciones del periodo no incluidas en los archivos planos cargados'                                             AS DESCRIPTION,
             SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 AND RFR.CODTRANSACCIONALIADO IS NULL THEN 1 ELSE 0 END)                           AS NUMTRANSACCIONES,
             SUM(CASE WHEN REG.CODTIPOREGISTRO = 1 AND RFR.CODTRANSACCIONALIADO IS NULL THEN RFR.VALORTRANSACCION ELSE 0 END)        AS VALORTRANSACCION,
             0  AS REVENUETOTAL
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL CTR
      INNER JOIN WSXML_SFG.REGISTROFACTURACION REG ON (REG.CODENTRADAARCHIVOCONTROL = CTR.ID_ENTRADAARCHIVOCONTROL)
      INNER JOIN WSXML_SFG.REGISTROFACTREFERENCIA RFR ON (RFR.CODREGISTROFACTURACION = REG.ID_REGISTROFACTURACION)
      INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.ID_PRODUCTO = REG.CODPRODUCTO)
      WHERE CTR.FECHAARCHIVO BETWEEN CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFACTURADO)) AND CONVERT(DATETIME, CONVERT(DATE,@p_FECHACORTECONTABLE)) AND PRD.CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO_GetDestiempoCompensacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO_GetDestiempoCompensacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESTIEMPOARCHIVOPLANO_GetDestiempoCompensacion(@p_CODALIADOESTRATEGICO NUMERIC(22,0),
                                     @p_FECHAFACTURADO       DATETIME,
                                     @p_FECHACORTECONTABLE   DATETIME,
                                     @p_page_number          INTEGER,
                                     @p_batch_size           INTEGER,
                                    @p_total_size           INTEGER OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT NULL;
  END;

GO


