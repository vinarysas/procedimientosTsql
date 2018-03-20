USE SFGPRODU;
--  DDL for Package Body SFGMAESTROFACTURACIONCOMPCONSI
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI */ 

  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_AddRecord(@p_CODCICLOFACTURACIONPDV       NUMERIC(22,0),
                      @p_CODTIPOPUNTODEVENTA          NUMERIC(22,0),
                      @p_CODAGRUPACIONPUNTODEVENTA    NUMERIC(22,0),
                      @p_CODPUNTODEVENTA              NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO            NUMERIC(22,0),
                      @p_REFERENCIAGTECH              VARCHAR(4000),
                      @p_REFERENCIAFIDUCIA            VARCHAR(4000),
                      @p_FECHALIMITEPAGOGTECH         DATETIME,
                      @p_FECHALIMITEPAGOFIDUCIA       DATETIME,
                      @p_CODCUENTAPAGOGTECH           NUMERIC(22,0),
                      @p_CODCUENTAPAGOFIDUCIA         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_MAESTROFACTCOMPCONSIG_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG (
                                              CODCICLOFACTURACIONPDV,
                                              CODTIPOPUNTODEVENTA,
                                              CODAGRUPACIONPUNTODEVENTA,
                                              CODPUNTODEVENTA,
                                              CODLINEADENEGOCIO,
                                              REFERENCIAGTECH,
                                              REFERENCIAFIDUCIA,
                                              FECHALIMITEPAGOGTECH,
                                              FECHALIMITEPAGOFIDUCIA,
                                              CODCUENTAPAGOGTECH,
                                              CODCUENTAPAGOFIDUCIA,
                                              CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODCICLOFACTURACIONPDV,
            @p_CODTIPOPUNTODEVENTA,
            @p_CODAGRUPACIONPUNTODEVENTA,
            @p_CODPUNTODEVENTA,
            @p_CODLINEADENEGOCIO,
            @p_REFERENCIAGTECH,
            @p_REFERENCIAFIDUCIA,
            @p_FECHALIMITEPAGOGTECH,
            @p_FECHALIMITEPAGOFIDUCIA,
            @p_CODCUENTAPAGOGTECH,
            @p_CODCUENTAPAGOFIDUCIA,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_MAESTROFACTCOMPCONSIG_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_UpdateRecord(@pk_ID_MAESTROFACTCOMPCONSIG NUMERIC(22,0),
                         @p_CODCICLOFACTURACIONPDV    NUMERIC(22,0),
                         @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
                         @p_REFERENCIAGTECH           VARCHAR(4000),
                         @p_REFERENCIAFIDUCIA         VARCHAR(4000),
                         @p_FECHALIMITEPAGOGTECH      DATETIME,
                         @p_FECHALIMITEPAGOFIDUCIA    DATETIME,
                         @p_CODCUENTAPAGOGTECH        NUMERIC(22,0),
                         @p_CODCUENTAPAGOFIDUCIA      NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                         @p_ACTIVE                    NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
       SET CODCICLOFACTURACIONPDV    = @p_CODCICLOFACTURACIONPDV,
           CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA,
           REFERENCIAGTECH           = @p_REFERENCIAGTECH,
           REFERENCIAFIDUCIA         = @p_REFERENCIAFIDUCIA,
           FECHALIMITEPAGOGTECH      = @p_FECHALIMITEPAGOGTECH,
           FECHALIMITEPAGOFIDUCIA    = @p_FECHALIMITEPAGOFIDUCIA,
           CODCUENTAPAGOGTECH        = @p_CODCUENTAPAGOGTECH,
           CODCUENTAPAGOFIDUCIA      = @p_CODCUENTAPAGOFIDUCIA,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           ACTIVE                    = @p_ACTIVE
     WHERE ID_MAESTROFACTCOMPCONSIG = @pk_ID_MAESTROFACTCOMPCONSIG;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetRecord(@pk_ID_MAESTROFACTCOMPCONSIG NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
     WHERE ID_MAESTROFACTCOMPCONSIG = @pk_ID_MAESTROFACTCOMPCONSIG;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_MAESTROFACTCOMPCONSIG,
             CODCICLOFACTURACIONPDV,
             CODAGRUPACIONPUNTODEVENTA,
             REFERENCIAGTECH,
             REFERENCIAFIDUCIA,
             FECHALIMITEPAGOGTECH,
             FECHALIMITEPAGOFIDUCIA,
             CODCUENTAPAGOGTECH,
             CODCUENTAPAGOFIDUCIA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
       WHERE ID_MAESTROFACTCOMPCONSIG = @pk_ID_MAESTROFACTCOMPCONSIG;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_MAESTROFACTCOMPCONSIG,
             CODCICLOFACTURACIONPDV,
             CODAGRUPACIONPUNTODEVENTA,
             REFERENCIAGTECH,
             REFERENCIAFIDUCIA,
             FECHALIMITEPAGOGTECH,
             FECHALIMITEPAGOFIDUCIA,
             CODCUENTAPAGOGTECH,
             CODCUENTAPAGOFIDUCIA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeReferenceNumber', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeReferenceNumber;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeReferenceNumber(@p_NUMEROREFERENCIA NVARCHAR(2000), @p_CODPUNTODEVENTA_out NUMERIC(22,0) OUT, @p_CODAGRUPACIONPUNTODEVENT_out NUMERIC(22,0) OUT, @p_CODTIPOPUNTODEVENTA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    -- Decodificar de acuerdo a la misma logica aplicada para la generacion
    IF SUBSTRING(@p_NUMEROREFERENCIA, 1, 1) = '9' BEGIN
      SET @p_CODTIPOPUNTODEVENTA_out = 1;
      SELECT @p_CODAGRUPACIONPUNTODEVENT_out = ID_AGRUPACIONPUNTODEVENTA, @p_CODPUNTODEVENTA_out = CODPUNTODEVENTACABEZA FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
      WHERE CAST(CODIGOAGRUPACIONGTECH AS INT) = CAST(SUBSTRING(@p_NUMEROREFERENCIA, 2, 4) AS INT);
    END
    ELSE BEGIN
      SELECT @p_CODPUNTODEVENTA_out = ID_PUNTODEVENTA, @p_CODAGRUPACIONPUNTODEVENT_out = CODAGRUPACIONPUNTODEVENTA, @p_CODTIPOPUNTODEVENTA_out = CODTIPOPUNTODEVENTA
      FROM WSXML_SFG.PUNTODEVENTA PDV
      INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON (CODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA)
      WHERE CAST(NUMEROTERMINAL AS INT) = CAST(SUBSTRING(@p_NUMEROREFERENCIA, 1, 5) AS INT)
      AND PDV.ACTIVE = 1;
    END 
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeBilledReferenceNumber', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeBilledReferenceNumber;
GO


 CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeBilledReferenceNumber(
										@p_NUMEROREFERENCIA             NVARCHAR(2000),
                                        @p_CODLINEADENEGOCIO            NUMERIC(22,0),
                                        @p_CODCICLOFACTURACIONPDV_out   NUMERIC(22,0) OUT,
                                        @p_CODPUNTODEVENTA_out          NUMERIC(22,0) OUT,
                                        @p_CODAGRUPACIONPUNTODEVENT_out NUMERIC(22,0) OUT,
                                        @p_CODTIPOPUNTODEVENTA_out      NUMERIC(22,0) OUT,
                                        @lstBILLINGREFERENCES_out_cur       CURSOR VARYING OUT,
										@countBILLINGREFERENCES_out_cur       NUMERIC(38,0) OUT
) AS
 BEGIN
   SET NOCOUNT ON;

    DECLARE @cCurrentHead   NUMERIC(22,0);
    DECLARE @cCurrentCycle  NUMERIC(22,0);
    DECLARE @cCurrentTicket NUMERIC(22,0);
    DECLARE @errormessage   NVARCHAR(2000);

	DECLARE  @lstBILLINGREFERENCES_out  WSXML_SFG.REFERENCEBILLING

BEGIN TRY   

    -- Decode according to last billing, in order to return optional agent list and head of chain
    -- Use real reference number logic, since payments come from another source, and might be unreal
    IF SUBSTRING(@p_NUMEROREFERENCIA, 1, 1) = '9' BEGIN
      -- For chain, last billing is obtained through current head of chain (POTENTIAL ERROR HERE)
      SELECT @cCurrentHead = CODPUNTODEVENTACABEZA FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
      WHERE CAST(CODIGOAGRUPACIONGTECH AS NUMERIC(38,0)) = CAST(SUBSTRING(@p_NUMEROREFERENCIA, 2, 4) AS NUMERIC(38,0));
    END
    ELSE BEGIN
      SELECT @cCurrentHead = ID_PUNTODEVENTA FROM WSXML_SFG.PUNTODEVENTA
      WHERE CAST(NUMEROTERMINAL  AS NUMERIC(38,0)) = CAST(SUBSTRING(@p_NUMEROREFERENCIA, 1, 5)  AS NUMERIC(38,0)) AND ACTIVE = 1;
    END 
    -- Obtain data from last billing, plus the rules used during the process.
    SELECT @cCurrentCycle = MFC.CODCICLOFACTURACIONPDV, @cCurrentTicket = MFC.ID_MAESTROFACTCOMPCONSIG, @p_CODAGRUPACIONPUNTODEVENT_out = MFC.CODAGRUPACIONPUNTODEVENTA, @p_CODPUNTODEVENTA_out = MFC.CODPUNTODEVENTA, @p_CODTIPOPUNTODEVENTA_out = MFC.CODTIPOPUNTODEVENTA
    FROM WSXML_SFG.FACTURACIONPDV FPV
    INNER JOIN WSXML_SFG.MAESTROFACTURACIONPDV MFP ON (MFP.ID_MAESTROFACTURACIONPDV = FPV.CODMAESTROFACTURACIONPDV)
    INNER JOIN WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG MFC ON (MFC.ID_MAESTROFACTCOMPCONSIG = MFP.CODMAESTROFACTURACIONCOMPCONSI)
    WHERE FPV.CODPUNTODEVENTA = @cCurrentHead
      AND FPV.CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
    GROUP BY MFC.CODCICLOFACTURACIONPDV, MFC.ID_MAESTROFACTCOMPCONSIG, MFC.CODAGRUPACIONPUNTODEVENTA, MFC.CODPUNTODEVENTA, MFC.CODTIPOPUNTODEVENTA;
    SET @p_CODCICLOFACTURACIONPDV_out = @cCurrentCycle;
    -- Finally, list of available billings to distribute from

	INSERT INTO @lstBILLINGREFERENCES_out  -- REFERENCEBILLING
    SELECT CODLINEADENEGOCIO, ID_MAESTROFACTURACIONPDV
	FROM WSXML_SFG.MAESTROFACTURACIONPDV
    WHERE CODCICLOFACTURACIONPDV         = @cCurrentCycle
      AND CODMAESTROFACTURACIONCOMPCONSI = @cCurrentTicket;
	
	SET @countBILLINGREFERENCES_out_cur = @@ROWCOUNT
	
    IF @countBILLINGREFERENCES_out_cur > 0 BEGIN
		SET @lstBILLINGREFERENCES_out_cur = CURSOR FORWARD_ONLY STATIC FOR 
			SELECT CODLINEADENEGOCIO, CODMAESTROFACTURACIONPDV FROM @lstBILLINGREFERENCES_out
		OPEN @lstBILLINGREFERENCES_out_cur;
	END ELSE BEGIN
      RAISERROR('-20071 La facturacion no existe', 16, 1);
    END 
END TRY
BEGIN CATCH
    SET @errormessage = 'Could not decode BILLED reference number ' + ISNULL(@p_NUMEROREFERENCIA, '') + ': ' + isnull(ERROR_MESSAGE ( ) , '');
    EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @errormessage
    SET @errormessage = '-20070 Could not decode BILLED reference number ' + ISNULL(@p_NUMEROREFERENCIA, '') + ': ' + isnull(ERROR_MESSAGE ( ) , '')
	RAISERROR(@errormessage, 16, 1);
END CATCH
END;
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGMAESTROFACTURACIONCOMPCONSI_DecodeBilledReferencesList'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeBilledReferencesList
GO

CREATE     FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_DecodeBilledReferencesList(
						@cCurrentCycle  NUMERIC(22,0),
                        @cCurrentTicket NUMERIC(22,0)
	)RETURNS @lstBILLINGREFERENCES_out TABLE (
		CODLINEADENEGOCIO NUMERIC(38,0),
		CODMAESTROFACTURACIONPDV NUMERIC(38,0)
	)  AS --@lstBILLINGREFERENCES_out
  BEGIN

	INSERT INTO @lstBILLINGREFERENCES_out
		SELECT CODLINEADENEGOCIO, ID_MAESTROFACTURACIONPDV  
		FROM WSXML_SFG.MAESTROFACTURACIONPDV
		WHERE CODCICLOFACTURACIONPDV         = @cCurrentCycle
		  AND CODMAESTROFACTURACIONCOMPCONSI = @cCurrentTicket;
	RETURN
  END;
GO


IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGMAESTROFACTURACIONCOMPCONSI_GetDigitoVerifAlgoritmo3'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetDigitoVerifAlgoritmo3
GO

CREATE FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetDigitoVerifAlgoritmo3(
						@p_CODIGOGTECHREFERENCIA NVARCHAR(2000)  ,
                        @p_PRIMERNUMEROPARAPONDERAR NUMERIC(22,0)  ,
                        @p_SEGUNDONUMEROPARAPONDERAR NUMERIC(22,0) ) RETURNS VARCHAR(4000) AS
 BEGIN

  --
   -- Variables de generacion
   DECLARE @xtmpnumber      NUMERIC(22,0)                                   ;
   DECLARE @xresult         NUMERIC(22,0)                                   ;
   DECLARE @xsum            NUMERIC(22,0)  = 0                             ;
   DECLARE @xverificaDigito NUMERIC(22,0)                                   ;
   DECLARE @xverDigitoStr   NVARCHAR(10)                            ;
   DECLARE @xMultPor        NUMERIC(22,0)                                   ;
   --
    
      --
      -- Generacion de codigo
      SET @xMultPor = @p_PRIMERNUMEROPARAPONDERAR;
      --
	  DECLARE @ix INT = 1

      WHILE @ix < 10 BEGIN
        --
        SET @xtmpnumber = SUBSTRING(@p_CODIGOGTECHREFERENCIA, @ix, 1);
        IF @xtmpnumber IS NOT NULL BEGIN
          --
          SET @xresult = @xtmpnumber * @xMultPor;
          -- Si el resultado es mayor que 9 entonces toca sumar el numero de las unidades y el numero de la decenas
          IF @xresult>9 BEGIN
            --
            SET @xresult= ((@xresult- (@xresult %10))/10) + (@xresult %10);
            --
          END 
          --
          SET @xsum = @xsum + @xresult;
          --
          IF @xMultPor = @p_PRIMERNUMEROPARAPONDERAR BEGIN
            --
            SET @xmultpor = @p_SEGUNDONUMEROPARAPONDERAR;
            --
          END
          ELSE BEGIN
            --
            SET @xmultpor = @p_PRIMERNUMEROPARAPONDERAR;
            --
          END 
          --
        END 
        --
		SET @ix = @ix + 1
      END;


      --
      SET @xverificaDigito = SUBSTRING(CONVERT(VARCHAR(MAX),@xsum), -1, 1);
      --
      SET @xverDigitoStr = CONVERT(VARCHAR(MAX), @xverificaDigito);
      --
      RETURN @xverDigitoStr;
      --
   END;
GO


IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferenciaAlgoritmo3', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferenciaAlgoritmo3;
GO


CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferenciaAlgoritmo3(@p_CODTIPOAGRUPACION             NUMERIC(22,0)   ,
                                           @p_CODAGRUPACIONPUNTODEVENTA     NUMERIC(22,0)   ,
                                           @p_CODPUNTODEVENTA               NUMERIC(22,0)   ,
                                           @p_REFERENCIA_out            VARCHAR(4000) OUT ) AS
   -- Variables a Considerar
   DECLARE @cCODIGOGTECHREFERENCIA  VARCHAR(6);
   -- Variables de generacion
   DECLARE @xnumRef   TABLE (ID INT, VALOR INT);
   DECLARE @xverDigitoStr   VARCHAR(10), @msg VARCHAR(2000);

   BEGIN

	BEGIN TRY
     --
		 IF @p_CODTIPOAGRUPACION = 1 BEGIN
		   -- Si es agrupada, sacar el codigo de la agrupacion pad 4
		   SELECT @cCODIGOGTECHREFERENCIA = '9' + ISNULL(RIGHT(REPLICATE('0', 5) + CODIGOAGRUPACIONGTECH, 5),'')
			 FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
			WHERE ID_AGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
		END
		ELSE BEGIN
		  -- Si es punto de venta independiente, sacar el numero de terminal PAD 6
		  SELECT @cCODIGOGTECHREFERENCIA = RIGHT(REPLICATE('_', 6) + CODIGOGTECHPUNTODEVENTA, 6)
			FROM WSXML_SFG.PUNTODEVENTA
		   WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
		  --
		END 
		-- Generacion de codigo
		--SET @xnumRef = SMALLNUMBERARRAY();
		--xnumRef.Extend(9);
		--Obtenemos primer d?gito de verificaci?n
		SET @xverDigitoStr = WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetDigitoVerifAlgoritmo3(@cCODIGOGTECHREFERENCIA, 2, 1);
		-- Obtenemos Segundo d?gito de verificaci?n
		SET @xverDigitoStr = ISNULL(@xverDigitoStr, '') + ISNULL(WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetDigitoVerifAlgoritmo3(@cCODIGOGTECHREFERENCIA,1,3), '');
		--
		SET @p_REFERENCIA_out = ISNULL(@cCODIGOGTECHREFERENCIA, '') + ISNULL(@xverDigitoStr, '');
	END TRY
	BEGIN CATCH

		SET @msg = 'Cannot generate reference number ('

		IF @p_CODTIPOAGRUPACION = 1 
			SET @msg = @msg + 'Chain ' 
		ELSE 
			SET @msg = @msg + 'Term '

		SET @msg = @msg + ') for billing cycle: ' + isnull(ERROR_MESSAGE(), '')


		EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg;
		SET @p_REFERENCIA_out = '00000000';
	END CATCH
  END
GO


IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferencia', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferencia;
GO


CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferencia(@p_CODTIPOAGRUPACION NUMERIC(22,0), @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0), @p_CODPUNTODEVENTA NUMERIC(22,0), @p_FECHACIERRE DATETIME, @p_REFERENCIA_out VARCHAR(4000) OUT) AS
    -- Variables a Considerar
    DECLARE @cCODIGOGTECHREFERENCIA     NVARCHAR(6);
    -- Variables de generacion

	DECLARE  @xnumRef TABLE (ID INT, VALOR INT);
	DECLARE  @xnumRef2 TABLE (ID INT, VALOR INT);
    DECLARE @xdia            INT,
    @xdigitoStr      VARCHAR(1),
    @xreferenciaStr  VARCHAR(10),
    @xsum            INT,
    @xverificaDigito INT,
    @xverDigitoStr   VARCHAR(10),
    @xTipoAlgoritmo  INT,
    @msg             VARCHAR(2000),
    @xmultpor        INT,
    @xtmpnumber      INT,
    @xresult         INT,
    @xsumresult      INT = 0;

  BEGIN
	BEGIN TRY

		-- Consultamos que algoritmo se debe utlizar
		EXEC WSXML_SFG.SFGPARAMETRO_GetValorByKey 'CodigoAlgoritmoParaReferenciaAUsar', @xTipoAlgoritmo OUT
		--
		IF @xTipoAlgoritmo = 1 BEGIN
			IF @p_CODTIPOAGRUPACION = 1 BEGIN
				-- Si es agrupada, sacar el codigo de la agrupacion pad 4
				SELECT @cCODIGOGTECHREFERENCIA = '9' + RIGHT(REPLICATE('0', 4) + CODIGOAGRUPACIONGTECH, 4)
				FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
				WHERE ID_AGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
			END
			ELSE BEGIN
				-- Si es punto de venta independiente, sacar el numero de terminal PAD 5
				SELECT @cCODIGOGTECHREFERENCIA = RIGHT(REPLICATE('0', 5) + NUMEROTERMINAL, 5)
				FROM WSXML_SFG.PUNTODEVENTA
				WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
			END 
			
			-- Generacion de codigo
			--SET @xnumRef = SMALLNUMBERARRAY();
			--xnumRef.Extend(6);
			SET @xdia = FORMAT(@p_FECHACIERRE, 'dd');
			
			IF LEN(@xdia) = 2 BEGIN
				SET @xdigitoStr = SUBSTRING(CAST(@xdia AS VARCHAR(2)), 2, 1);
			END
			ELSE IF LEN(@xdia) = 1 BEGIN
				SET @xdigitoStr = @xdia;
			END 
			
			SET @xreferenciaStr = ISNULL(@cCODIGOGTECHREFERENCIA, '') + ISNULL(@xdigitoStr, '');

			DECLARE @ix INT = 1;
			WHILE  @ix < 7 
			BEGIN
				
				IF SUBSTRING(@xreferenciaStr, @ix, 1) = 0
					INSERT INTO @xnumRef VALUES (@ix,11)
				ELSE
					INSERT INTO @xnumRef VALUES (@ix,SUBSTRING(@xreferenciaStr, @ix, 1))

				SET @ix = @ix + 1;
			END

		  
			INSERT INTO @xnumRef2 SELECT ID, VALOR FROM @xnumRef

			DELETE FROM  @xnumRef;

			INSERT INTO @xnumRef VALUES (1, (SELECT VALOR FROM @xnumRef2 WHERE ID = 1) * 7);
			INSERT INTO @xnumRef VALUES (2, (SELECT VALOR FROM @xnumRef2 WHERE ID = 2) * 23);
			INSERT INTO @xnumRef VALUES (3, (SELECT VALOR FROM @xnumRef2 WHERE ID = 3) * 59);
			INSERT INTO @xnumRef VALUES (4, (SELECT VALOR FROM @xnumRef2 WHERE ID = 4) * 31);
			INSERT INTO @xnumRef VALUES (5, (SELECT VALOR FROM @xnumRef2 WHERE ID = 5) * 47);
			INSERT INTO @xnumRef VALUES (6, (SELECT VALOR FROM @xnumRef2 WHERE ID = 6) * 3);
			
			SET @xsum = 0;
			SET @ix = 0;
			
			WHILE  @ix < 7 BEGIN
				set @xsum = @xsum + (SELECT VALOR FROM @xnumRef WHERE ID = @ix)
			END;

          
			SET @xverificaDigito = (@xsum % 100);
			SET @xverDigitoStr = RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(MAX), @xverificaDigito), 2);
			SET @p_REFERENCIA_out = ISNULL(@xreferenciaStr, '') + ISNULL(@xverDigitoStr, '');
			
			
		END

		IF @xTipoAlgoritmo = 2 
		BEGIN

			IF @p_CODTIPOAGRUPACION = 1 BEGIN
				  -- Si es agrupada, sacar el codigo de la agrupacion pad 4
				  SELECT @cCODIGOGTECHREFERENCIA = '9' + ISNULL(RIGHT(REPLICATE('0', 4) + CODIGOAGRUPACIONGTECH, 4),'')
				  FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
				  WHERE ID_AGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
			END
			ELSE BEGIN
				  -- Si es punto de venta independiente, sacar el numero de terminal PAD 5
				  SELECT @cCODIGOGTECHREFERENCIA = RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(MAX), CAST(PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA AS NUMERIC(38,0))), 5)
					 FROM WSXML_SFG.PUNTODEVENTA
				  WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
			END 
				/*cCODIGOGTECHREFERENCIA := '00022';*/
				-- Generacion de codigo
			set @xmultpor=2;

			SET @ix = 1;
			
			WHILE  @ix < 6 BEGIN
					  set @xtmpnumber = SUBSTRING(@cCODIGOGTECHREFERENCIA, @ix, 1);
					  set @xresult = @xtmpnumber * @xmultpor;
					  -- Si el resultado es mayor que 9 entonces toca sumar el numero de las unidades y el numero de la decenas
					  IF @xresult > 9 BEGIN
						set @xresult= ((@xresult- (@xresult %10))/10) + (@xresult %10);
					  END 
					  set @xsumresult = @xsumresult + @xresult;
					  IF @xmultpor = 2 BEGIN
						set @xmultpor=1;
					  END
					  ELSE BEGIN
						set @xmultpor=2;
					  END 

					SET @ix= @ix + 1 
			END;

            
			IF (@xsumresult %10) = 0 
				SET @xverDigitoStr= '0';
			ELSE
			   SET @xverDigitoStr= CONVERT(VARCHAR(max), ((@xsumresult-(@xsumresult %10)) + 10 )-@xsumresult);
	
			SET @p_REFERENCIA_out=ISNULL(@cCODIGOGTECHREFERENCIA, '') + ISNULL(@xverDigitoStr, '');

		END
	

		IF @xTipoAlgoritmo = 3 BEGIN
			EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferenciaAlgoritmo3 @p_CODTIPOAGRUPACION, @p_CODAGRUPACIONPUNTODEVENTA, @p_CODPUNTODEVENTA, @p_REFERENCIA_out OUT
		END

	END TRY
	BEGIN CATCH

    --

        set @msg = 'Cannot generate reference number (';

		IF @p_CODTIPOAGRUPACION = 1 
			set @msg =  'Chain ' 
		ELSE 
			set @msg = 'Term '
		
		SET @msg = ') for billing cycle: ' + isnull(ERROR_MESSAGE(),'');

		EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @msg
		SET @p_REFERENCIA_out = '00000000';

	END CATCH

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GenerateBillingTicketData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GenerateBillingTicketData;
GO


CREATE     PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GenerateBillingTicketData(
										@p_CODCICLOFACTURACIONPDV    NUMERIC(22,0),
                                      @p_CODPUNTODEVENTA           NUMERIC(22,0),
                                      @p_CODTIPOPUNTODEVENTA       NUMERIC(22,0),
                                      @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
                                      @p_CODLINEADENEGOCIO         NUMERIC(22,0),
                                      @p_FECHACIERRE               DATETIME,
                                      @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                                      @p_CODMAESTROFACTCOMPCON_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCOUNTEXTCOMPCONSIG NUMERIC(22,0);
    DECLARE @cCOUNTLDNCOMPCONSIG NUMERIC(22,0);
    DECLARE @cEXISTINGCOMPCONSIG NUMERIC(22,0);
    DECLARE @xCODPUNTODEVENTA    NUMERIC(22,0); -- Si es agrupado, los datos van de acuerdo a la cabeza
  -- 22/03/2017 Cambio a d?as calendario
    DECLARE @cDIASCALENDARIOPAGOGTECH   NUMERIC(22,0);
    DECLARE @cDIASCALENDARIOPAGOFIDUCIA NUMERIC(22,0);
    DECLARE @cFECHALIMITEPAGOGTECH   DATETIME;
    DECLARE @cFECHALIMITEPAGOFIDUCIA DATETIME;
    DECLARE @cREFERENCIA             NVARCHAR(10);
    DECLARE @cCODCUENTAPAGOGTECH     NUMERIC(22,0);
    DECLARE @cCODCUENTAPAGOFIDUCIA   NUMERIC(22,0);
   
  SET NOCOUNT ON;
    -- Verificar si ya existe un registro para minar datos.
    IF @p_CODTIPOPUNTODEVENTA = 1 BEGIN
      SELECT @cCOUNTEXTCOMPCONSIG = COUNT(1) FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
      WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
        AND CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
    END
    ELSE BEGIN
      SELECT @cCOUNTEXTCOMPCONSIG = COUNT(1) FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
      WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
        AND CODPUNTODEVENTA = @p_CODPUNTODEVENTA;
    END 
    -- Si ya existen, devolver identificador de registro
    IF @cCOUNTEXTCOMPCONSIG > 0 BEGIN
      IF @p_CODTIPOPUNTODEVENTA = 1 BEGIN
        SELECT @cCOUNTLDNCOMPCONSIG = COUNT(1) FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
        WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
          AND CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA
          AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
      END
      ELSE BEGIN
        SELECT @cCOUNTLDNCOMPCONSIG = COUNT(1) FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
        WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
          AND CODPUNTODEVENTA = @p_CODPUNTODEVENTA
          AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
      END 
      IF @cCOUNTLDNCOMPCONSIG > 0 BEGIN
        -- Ya existe el registro. Devolver
        IF @p_CODTIPOPUNTODEVENTA = 1 BEGIN
          SELECT @cEXISTINGCOMPCONSIG = ID_MAESTROFACTCOMPCONSIG FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
          WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
            AND CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA
            AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
        END
        ELSE BEGIN
          SELECT @cEXISTINGCOMPCONSIG = ID_MAESTROFACTCOMPCONSIG FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
          WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
            AND CODPUNTODEVENTA = @p_CODPUNTODEVENTA
            AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO;
        END 
      END
      ELSE BEGIN
        -- No existe, pero los datos estan para otra linea de negocio
        IF @p_CODTIPOPUNTODEVENTA = 1 BEGIN
          SELECT @cFECHALIMITEPAGOGTECH = MIN(FECHALIMITEPAGOGTECH),
                 @cFECHALIMITEPAGOFIDUCIA = MIN(FECHALIMITEPAGOFIDUCIA),
                 @cREFERENCIA = MIN(REFERENCIAGTECH)
                       FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
          WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
            AND CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
        END
        ELSE BEGIN
          SELECT @cFECHALIMITEPAGOGTECH = MIN(FECHALIMITEPAGOGTECH),
                 @cFECHALIMITEPAGOFIDUCIA = MIN(FECHALIMITEPAGOFIDUCIA),
                 @cREFERENCIA = MIN(REFERENCIAGTECH)
                       FROM WSXML_SFG.MAESTROFACTURACIONCOMPCONSIG
          WHERE CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
            AND CODPUNTODEVENTA = @p_CODPUNTODEVENTA;
        END 
        -- Si es agrupada, los valores van de acuerdo a la configuracion de la cabeza
        IF @p_CODTIPOPUNTODEVENTA = 1 BEGIN
          SELECT @xCODPUNTODEVENTA = CODPUNTODEVENTACABEZA FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA WHERE ID_AGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
        END
        ELSE BEGIN
          SET @xCODPUNTODEVENTA = @p_CODPUNTODEVENTA;
        END 
        -- Cuentas bancarias
        BEGIN

			BEGIN TRY
			EXEC SFGPUNTODEVENTACUENTA_GetActualRecord @xCODPUNTODEVENTA,
                                                @p_CODLINEADENEGOCIO,
                                                @cCODCUENTAPAGOGTECH,
                                                @cCODCUENTAPAGOFIDUCIA
			END TRY
			BEGIN CATCH
				RAISERROR('-20054 No se pudo obtener la informacion de cuentas de pago', 16, 1);
			END CATCH
          
        END;

        -- Insercion de registro
        BEGIN
			BEGIN TRY
				EXEC SFGMAESTROFACTURACIONCOMPCONSI_AddRecord @p_CODCICLOFACTURACIONPDV,
                                                   @p_CODTIPOPUNTODEVENTA,
                                                   @p_CODAGRUPACIONPUNTODEVENTA,
                                                   @xCODPUNTODEVENTA,
                                                   @p_CODLINEADENEGOCIO,
                                                   @cREFERENCIA,
                                                   @cREFERENCIA,
                                                   @cFECHALIMITEPAGOGTECH,
                                                   @cFECHALIMITEPAGOFIDUCIA,
                                                   @cCODCUENTAPAGOGTECH,
                                                   @cCODCUENTAPAGOFIDUCIA,
                                                   @p_CODUSUARIOMODIFICACION,
                                                   @cEXISTINGCOMPCONSIG OUT
			END TRY
			BEGIN CATCH
				RAISERROR('-20054 No se pudo ingresar el registro de comprobante de pago para la facturacion.', 16, 1);
			END CATCH
        END;

      END 
    END
    ELSE BEGIN
      -- Si es agrupada, los valores van de acuerdo a la configuracion de la cabeza
      IF @p_CODTIPOPUNTODEVENTA = 1 BEGIN
        SELECT @xCODPUNTODEVENTA = CODPUNTODEVENTACABEZA FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA WHERE ID_AGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA;
      END
      ELSE BEGIN
        SET @xCODPUNTODEVENTA = @p_CODPUNTODEVENTA;
      END 
      -- Fecha de pago. Numero de dias habiles de pago por defecto = 5
      BEGIN
         /*SELECT DIASHABILESPAGOGTECH, DIASHABILESPAGOFIDUCIA
           INTO cDIASHABILESPAGOGTECH, cDIASHABILESPAGOFIDUCIA FROM PDVCATEGORIAPAGO PCP
         INNER JOIN CATEGORIAPAGO CPG ON (CODCATEGORIAPAGO = ID_CATEGORIAPAGO)
         WHERE PCP.CODPUNTODEVENTA = xCODPUNTODEVENTA
           AND PCP.ACTIVE = 1;
          EXCEPTION WHEN OTHERS THEN*/
         -- EPINEDA 22/03/2017 Nuevo Baloto, limites de pago
         -- Consultamos que algoritmo se debe utlizar
         EXEC WSXML_SFG.SFGPARAMETRO_GetValorByKey 'numerodiasplazoIGT', @cDIASCALENDARIOPAGOGTECH OUT
         --
         EXEC WSXML_SFG.SFGPARAMETRO_GetValorByKey 'numerodiasplazoFiducia', @cDIASCALENDARIOPAGOFIDUCIA OUT;
         --
         -- cDIASHABILESPAGOGTECH := 5;
         -- cDIASHABILESPAGOFIDUCIA := 5;
      END;

      -- Calculo de fecha limite de pago en base a los dias habiles configurados en el calendario
      BEGIN
		BEGIN TRY
			-- EPINEDA 22/03/2017 Ahora se suman dias calendario parametrizados
			--SFGCALENDARIOGENERAL.SumarDiasHabiles(xCODPUNTODEVENTA, p_FECHACIERRE, cDIASCALENDARIOPAGOGTECH, cFECHALIMITEPAGOGTECH);
			SET @cFECHALIMITEPAGOGTECH = @p_FECHACIERRE + @cDIASCALENDARIOPAGOGTECH;
			IF NOT (@cDIASCALENDARIOPAGOGTECH = @cDIASCALENDARIOPAGOFIDUCIA)
			   -- SFGCALENDARIOGENERAL.SumarDiasHabiles(xCODPUNTODEVENTA, p_FECHACIERRE, cDIASHABILESPAGOFIDUCIA, cFECHALIMITEPAGOFIDUCIA);
			  SET @cFECHALIMITEPAGOFIDUCIA = @p_FECHACIERRE + @cDIASCALENDARIOPAGOFIDUCIA;
			   --
			ELSE
			   --
			   SET @cFECHALIMITEPAGOFIDUCIA = @cFECHALIMITEPAGOGTECH;
			   --
		END TRY
		BEGIN CATCH
				RAISERROR('-20054 No se pudo establecer la fecha limite de pago', 16, 1);
		END CATCH
      END 
      -- Referencia y agrupacion
      BEGIN
		BEGIN TRY
			EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferencia @p_CODTIPOPUNTODEVENTA, @p_CODAGRUPACIONPUNTODEVENTA, @xCODPUNTODEVENTA, @p_FECHACIERRE, @cREFERENCIA OUT
		END TRY
		BEGIN CATCH
			RAISERROR('-20054 No se pudo generar el numero de referencia de pago', 16, 1);
		END CATCH
      END;

      -- Cuentas bancarias
      BEGIN
		BEGIN TRY
			EXEC WSXML_SFG.SFGPUNTODEVENTACUENTA_GetActualRecord @xCODPUNTODEVENTA,
                                              @p_CODLINEADENEGOCIO,
                                              @cCODCUENTAPAGOGTECH OUT,
                                              @cCODCUENTAPAGOFIDUCIA OUT;
		END TRY
		BEGIN CATCH
			RAISERROR('-20054 No se pudo obtener la informacion de cuentas de pago', 16, 1);
		END CATCH
      END;

      -- Insercion de registro
      BEGIN
		BEGIN TRY
			EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_AddRecord @p_CODCICLOFACTURACIONPDV,
                                                 @p_CODTIPOPUNTODEVENTA,
                                                 @p_CODAGRUPACIONPUNTODEVENTA,
                                                 @xCODPUNTODEVENTA,
                                                 @p_CODLINEADENEGOCIO,
                                                 @cREFERENCIA,
                                                 @cREFERENCIA,
                                                 @cFECHALIMITEPAGOGTECH,
                                                 @cFECHALIMITEPAGOFIDUCIA,
                                                 @cCODCUENTAPAGOGTECH,
                                                 @cCODCUENTAPAGOFIDUCIA,
                                                 @p_CODUSUARIOMODIFICACION,
                                                 @cEXISTINGCOMPCONSIG OUT
		END TRY
		BEGIN CATCH
			RAISERROR('-20054 No se pudo ingresar el registro de comprobante de pago para la facturacion.', 16, 1);
		END CATCH
        
      END;
    END;

    -- Devolver valores para continuar con funcionamiento proceso
    SET @p_CODMAESTROFACTCOMPCON_out = @cEXISTINGCOMPCONSIG;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_IndependentReferenceNumber', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_IndependentReferenceNumber;
GO


CREATE     FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_IndependentReferenceNumber(@p_NUMEROTERMINAL NVARCHAR(2000), @p_FECHACIERRE DATETIME) RETURNS VARCHAR(4000) AS
 BEGIN
    --
    DECLARE @xINDEPENDENT   NUMERIC(22,0)   = 3;
    DECLARE @xCodPuntoVenta NUMERIC(22,0)       ;
    DECLARE @xREFERENCIA    VARCHAR(25) ;
    --
   
     --
    -- RETURN ReferenceNumber(xINDEPENDENT, NULL, p_NUMEROTERMINAL, p_FECHACIERRE);
     --
    /**/ SELECT @xCodPuntoVenta = id_puntodeventa
       
       FROM WSXML_SFG.puntodeventa
      WHERE numeroterminal = @p_NUMEROTERMINAL
      order by active desc
 
        --AND active = 1
      ;
        
        
     --
     EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferencia @xINDEPENDENT, NULL, @xCodPuntoVenta, @p_FECHACIERRE, @xREFERENCIA OUT
     --
     RETURN @xREFERENCIA;
     --
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GroupedReferenceNumber', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GroupedReferenceNumber;
GO


CREATE PROCEDURE WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GroupedReferenceNumber(
  @p_CODIGOAGRUPACIONGTECH NVARCHAR(2000), 
  @p_FECHACIERRE           DATETIME,
  @xREFERENCIA_OUT         NVARCHAR(4000) OUT
) AS
BEGIN
  
  DECLARE @xGROUPED              NUMERIC(22,0) = 1;
  DECLARE @xAgrupacionPuntoVenta NUMERIC(22,0);
  
  SELECT @xAgrupacionPuntoVenta = ID_AGRUPACIONPUNTODEVENTA
  FROM WSXML_SFG.agrupacionpuntodeventa
  WHERE codigoagrupaciongtech = @p_CODIGOAGRUPACIONGTECH;
  
  EXEC WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_GetNumeroReferencia 
    @xGROUPED, 
    @xAgrupacionPuntoVenta, 
    NULL, 
    @p_FECHACIERRE, 
    @xREFERENCIA_OUT OUT
  
END
GO



IF OBJECT_ID('WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_ReferenceNumber', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_ReferenceNumber;
GO

CREATE FUNCTION WSXML_SFG.SFGMAESTROFACTURACIONCOMPCONSI_ReferenceNumber(
							@p_CODTIPOAGRUPACION     NUMERIC(22,0),
							@p_CODIGOAGRUPACIONGTECH NVARCHAR(2000),
							@p_NUMEROTERMINAL        NVARCHAR(2000),
							@p_FECHACIERRE           DATETIME) RETURNS VARCHAR(4000) AS
 BEGIN
    -- Variables a Considerar
    DECLARE @cCODIGOGTECHREFERENCIA     NVARCHAR(6);
    -- Variables de generacion
    DECLARE @xnumRef TABLE (ID INT, VALOR INT)
	DECLARE @xnumRef2 TABLE (ID INT, VALOR INT)

    DECLARE @xdia INT, @xdigitoStr VARCHAR(1), @xreferenciaStr VARCHAR(10), @xsum INT, @xverificaDigito INT, @xverDigitoStr   VARCHAR(10), @msg VARCHAR(2000);


    IF @p_CODTIPOAGRUPACION = 1 BEGIN
      -- Si es agrupada, sacar el codigo de la agrupacion pad 4
      SELECT @cCODIGOGTECHREFERENCIA = '9'+ISNULL(RIGHT(REPLICATE('0', 4) + @P_CODIGOAGRUPACIONGTECH, 4),'')
    END
    ELSE BEGIN
      -- Si es punto de venta independiente, sacar el numero de terminal PAD 5
      SELECT @cCODIGOGTECHREFERENCIA = RIGHT(REPLICATE('0', 5) + @p_NUMEROTERMINAL, 5)
    END 

    -- Generacion de codigo
    --SET @xnumRef = SMALLNUMBERARRAY();
    --xnumRef.Extend(6);
    set @xdia = FORMAT(@p_FECHACIERRE, 'dd');
    IF LEN(@xdia) = 2 BEGIN
      SET @xdigitoStr = SUBSTRING(CAST(@xdia AS VARCHAR(2)), 2, 1);
    END
    ELSE IF LEN(@xdia) = 1 BEGIN
      SET @xdigitoStr = @xdia;
    END 
    SET @xreferenciaStr = ISNULL(@cCODIGOGTECHREFERENCIA, '') + ISNULL(@xdigitoStr, '');
    
	DECLARE @ix INT = 1;
	WHILE @ix < 7 BEGIN
		
		IF SUBSTRING(@xreferenciaStr, @ix, 1) = 0
			INSERT INTO @xnumRef VALUES(@ix, 11)
		ELSE 
			INSERT INTO @xnumRef VALUES(@ix, SUBSTRING(@xreferenciaStr, @ix, 1))
		SET @ix = @ix + 1;
	END


	INSERT @xnumRef2 
	SELECT ID, VALOR FROM @xnumRef


	DELETE FROM @xnumRef;


	INSERT INTO @xnumRef VALUES (1, (SELECT VALOR FROM @xnumRef2 WHERE ID = 1) * 7 )
	INSERT INTO @xnumRef VALUES (2, (SELECT VALOR FROM @xnumRef2 WHERE ID = 2) * 23)
	INSERT INTO @xnumRef VALUES (3, (SELECT VALOR FROM @xnumRef2 WHERE ID = 3) * 59)
	INSERT INTO @xnumRef VALUES (4, (SELECT VALOR FROM @xnumRef2 WHERE ID = 4) * 31)
	INSERT INTO @xnumRef VALUES (5, (SELECT VALOR FROM @xnumRef2 WHERE ID = 5) * 47)
	INSERT INTO @xnumRef VALUES (6, (SELECT VALOR FROM @xnumRef2 WHERE ID = 6) * 3 )


    SET @xsum = 0;
	SET @ix = 1
	WHILE @ix < 7 BEGIN
		SET @xsum = @xsum + (SELECT VALOR FROM @xnumRef WHERE ID = @ix);
	END


    SET @xverificaDigito = (@xsum % 100);
    SET @xverDigitoStr = RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(MAX), @xverificaDigito), 2)
   
	


	--EXCEPTION WHEN OTHERS THEN
	--set @msg = SQLERRM;
	--SFGTMPTRACE.TraceLog('Cannot emule reference number (' + ISNULL(CASE WHEN p_CODTIPOAGRUPACION = 1 THEN 'Chain ' ELSE 'Term ' END, '') + ISNULL(cCODIGOGTECHREFERENCIA, '') + ') for billing cycle: ' + isnull(msg, ''));
	--RETURN '00000000';

	 RETURN ISNULL(@xreferenciaStr, '') + ISNULL(@xverDigitoStr, '');
  END
GO




