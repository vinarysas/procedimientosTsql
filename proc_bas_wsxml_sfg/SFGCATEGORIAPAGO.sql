USE SFGPRODU;
--  DDL for Package Body SFGCATEGORIAPAGO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCATEGORIAPAGO */ 

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_AddRecord(@p_NOMCATEGORIAPAGO        NVARCHAR(2000),
                      @p_DIASHABILESPAGOGTECH    NUMERIC(22,0),
                      @p_DIASHABILESPAGOFIDUCIA  NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ID_CATEGORIAPAGO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    INSERT INTO WSXML_SFG.CATEGORIAPAGO (
                               NOMCATEGORIAPAGO,
                               DIASHABILESPAGOGTECH,
                               DIASHABILESPAGOFIDUCIA,
                               CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMCATEGORIAPAGO,
            @p_DIASHABILESPAGOGTECH,
            @p_DIASHABILESPAGOFIDUCIA,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_CATEGORIAPAGO_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_UpdateRecord(@pk_ID_CATEGORIAPAGO      NUMERIC(22,0),
                         @p_NOMCATEGORIAPAGO       NVARCHAR(2000),
                         @p_DIASHABILESPAGOGTECH   NUMERIC(22,0),
                         @p_DIASHABILESPAGOFIDUCIA NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.CATEGORIAPAGO
       SET NOMCATEGORIAPAGO          = @p_NOMCATEGORIAPAGO,
           DIASHABILESPAGOGTECH      = @p_DIASHABILESPAGOGTECH,
           DIASHABILESPAGOFIDUCIA    = @p_DIASHABILESPAGOFIDUCIA,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION     = GETDATE(),
           ACTIVE                    = @p_ACTIVE
     WHERE ID_CATEGORIAPAGO = @pk_ID_CATEGORIAPAGO;

	 DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetRecordValues', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetRecordValues;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetRecordValues(@p_CODPUNTODEVENTA            NUMERIC(22,0),
                            @p_CODLINEADENEGOCIO          NUMERIC(22,0),
                            @p_DIASHABILESPAGOGTECH_out   NUMERIC(22,0) OUT,
                            @p_DIASHABILESPAGOFIDUCIA_out NUMERIC(22,0) OUT,
                            @p_VARIABLEPORCENTUAL_out     NUMERIC(22,0) OUT,
                            @p_VARIABLETRANSACCIONAL_out  NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @rowcount NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @rowcount = COUNT(1) FROM WSXML_SFG.PDVCATEGORIAPAGO WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND ACTIVE = 1;
    IF @rowcount = 1 BEGIN
      SELECT @p_DIASHABILESPAGOGTECH_out = DIASHABILESPAGOGTECH,
             @p_DIASHABILESPAGOFIDUCIA_out = DIASHABILESPAGOFIDUCIA,
             @p_VARIABLEPORCENTUAL_out = VARIABLEPORCENTUAL,
             @p_VARIABLETRANSACCIONAL_out = VARIABLETRANSACCIONAL
               FROM WSXML_SFG.PDVCATEGORIAPAGO
       INNER JOIN CATEGORIAPAGO ON (CODCATEGORIAPAGO = ID_CATEGORIAPAGO)
       WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA
         AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
         AND PDVCATEGORIAPAGO.ACTIVE = 1;
    END
    ELSE BEGIN
      SELECT @p_DIASHABILESPAGOGTECH_out = 5, @p_DIASHABILESPAGOFIDUCIA_out = 5, @p_VARIABLEPORCENTUAL_out = 0, @p_VARIABLETRANSACCIONAL_out = 0
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetPaymentRecordValues', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetPaymentRecordValues;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetPaymentRecordValues(@p_CODPUNTODEVENTA            NUMERIC(22,0),
                                   @p_CODLINEADENEGOCIO          NUMERIC(22,0),
                                   @p_DIASHABILESPAGOGTECH_out   NUMERIC(22,0) OUT,
                                   @p_DIASHABILESPAGOFIDUCIA_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @rowcount NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @rowcount = COUNT(1) FROM WSXML_SFG.PDVCATEGORIAPAGO WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND ACTIVE = 1;
    IF @rowcount = 1 BEGIN
		SELECT @p_DIASHABILESPAGOGTECH_out = DIASHABILESPAGOGTECH,
             @p_DIASHABILESPAGOFIDUCIA_out = DIASHABILESPAGOFIDUCIA
		FROM WSXML_SFG.PDVCATEGORIAPAGO
			INNER JOIN  WSXML_SFG.CATEGORIAPAGO ON (CODCATEGORIAPAGO = ID_CATEGORIAPAGO)
		WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA
			AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
			AND PDVCATEGORIAPAGO.ACTIVE = 1;
    END
    ELSE BEGIN
      SELECT @p_DIASHABILESPAGOGTECH_out = 5, @p_DIASHABILESPAGOFIDUCIA_out = 5
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetComissionString', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGCATEGORIAPAGO_GetComissionString;
GO

CREATE     FUNCTION WSXML_SFG.SFGCATEGORIAPAGO_GetComissionString(@p_CODRANGOCOMISION NUMERIC(22,0), @p_CODCATEGORIAPAGO NUMERIC(22,0)) RETURNS VARCHAR(4000) AS
 BEGIN
    DECLARE @cVALORPORCENTUAL       FLOAT  = 0;
    DECLARE @cVALORTRANSACCIONAL    FLOAT  = 0;
    DECLARE @cCODTIPOCOMISION       NUMERIC(22,0) = 0;
    DECLARE @cVARIABLEPORCENTUAL    NUMERIC(22,0) = 0;
    DECLARE @cVARIABLETRANSACCIONAL NUMERIC(22,0) = 0;
    DECLARE @cCOMISSIONSTRING       VARCHAR(2000);
   
    SELECT @cCODTIPOCOMISION = CODTIPOCOMISION, @cVALORPORCENTUAL = VALORPORCENTUAL, @cVALORTRANSACCIONAL = VALORTRANSACCIONAL
    FROM WSXML_SFG.RANGOCOMISION
    INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
    WHERE ID_RANGOCOMISION = @p_CODRANGOCOMISION;
	
	DECLARE @ROWCOUNT NUMERIC(22,0) = @@ROWCOUNT
	
	IF @ROWCOUNT = 0 BEGIN
		 RETURN 'N/A';
	END
	
	IF @ROWCOUNT > 1 BEGIN
		  RETURN 'C. Rangos';
	END	
	

    IF @p_CODCATEGORIAPAGO > 0
    BEGIN
        SELECT @cVARIABLEPORCENTUAL = VARIABLEPORCENTUAL, @cVARIABLETRANSACCIONAL = VARIABLETRANSACCIONAL
        FROM WSXML_SFG.CATEGORIAPAGO WHERE ID_CATEGORIAPAGO = @p_CODCATEGORIAPAGO;
		
		IF @@ROWCOUNT = 0 BEGIN
			SET @cVARIABLEPORCENTUAL = 0;
			SET @cVARIABLETRANSACCIONAL = 0;
		END			
    END;

    IF @cCODTIPOCOMISION = 1 BEGIN -- El tipo de comision es porcentual
      SET @cCOMISSIONSTRING = ISNULL(REPLACE(CONVERT(VARCHAR, @cVALORPORCENTUAL + @cVARIABLEPORCENTUAL), 'x,', 'x.'), '') + '%';
    END
    ELSE BEGIN
      SET @cCOMISSIONSTRING = '$ ' + ISNULL(REPLACE(CONVERT(VARCHAR, @cVALORTRANSACCIONAL + @cVARIABLETRANSACCIONAL), 'x,', 'x.'), '');
    END 
	
	RETURN @cCOMISSIONSTRING;
   
END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValues', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValues;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValues(@p_CODPUNTODEVENTA            NUMERIC(22,0),
                                     @p_CODLINEADENEGOCIO          NUMERIC(22,0),
                                     @p_VARIABLEPORCENTUAL_out     NUMERIC(22,0) OUT,
                                     @p_VARIABLETRANSACCIONAL_out  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

  BEGIN TRY

    SELECT @p_VARIABLEPORCENTUAL_out = VARIABLEPORCENTUAL,
           @p_VARIABLETRANSACCIONAL_out = VARIABLETRANSACCIONAL
           FROM WSXML_SFG.PDVCATEGORIAPAGO
     INNER JOIN CATEGORIAPAGO ON (CODCATEGORIAPAGO = ID_CATEGORIAPAGO)
     WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA
       AND CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
       AND PDVCATEGORIAPAGO.ACTIVE = 1;
	END TRY
	BEGIN CATCH
    SELECT @p_VARIABLEPORCENTUAL_out = 0, @p_VARIABLETRANSACCIONAL_out = 0;
	END CATCH
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValuesByProd', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValuesByProd;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValuesByProd(@p_CODPUNTODEVENTA            NUMERIC(22,0),
                                           @p_CODPRODUCTO                NUMERIC(22,0),
                                           @p_CODCATEGORIAPAGO_out       NUMERIC(22,0) OUT,
                                           @p_VARIABLEPORCENTUAL_out     NUMERIC(22,0) OUT,
                                           @p_VARIABLETRANSACCIONAL_out  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
	BEGIN TRY
    SELECT @p_CODCATEGORIAPAGO_out = ID_CATEGORIAPAGO,
           @p_VARIABLEPORCENTUAL_out = VARIABLEPORCENTUAL,
           @p_VARIABLETRANSACCIONAL_out = VARIABLETRANSACCIONAL
           FROM WSXML_SFG.PDVCATEGORIAPAGO PCP
     INNER JOIN WSXML_SFG.CATEGORIAPAGO CP ON (PCP.CODCATEGORIAPAGO = CP.ID_CATEGORIAPAGO)
     INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR ON (TPR.CODLINEADENEGOCIO = PCP.CODLINEADENEGOCIO)
     INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.CODTIPOPRODUCTO = TPR.ID_TIPOPRODUCTO AND PRD.COMISIONVARIABLE = 1)
     WHERE PCP.CODPUNTODEVENTA = @p_CODPUNTODEVENTA
       AND PRD.ID_PRODUCTO = @p_CODPRODUCTO
       AND PCP.ACTIVE = 1;
	END TRY
	BEGIN CATCH
		SELECT @p_CODCATEGORIAPAGO_out = 0, @p_VARIABLEPORCENTUAL_out = 0, @p_VARIABLETRANSACCIONAL_out = 0;
	END CATCH
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValuesFromID', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValuesFromID;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetComissionRecordValuesFromID(@p_CODCATEGORIAPAGO           NUMERIC(22,0),
                                           @p_VARIABLEPORCENTUAL_out     NUMERIC(22,0) OUT,
                                           @p_VARIABLETRANSACCIONAL_out  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    SELECT @p_VARIABLEPORCENTUAL_out = VARIABLEPORCENTUAL,
           @p_VARIABLETRANSACCIONAL_out = VARIABLETRANSACCIONAL
           FROM WSXML_SFG.CATEGORIAPAGO
     WHERE ID_CATEGORIAPAGO = @p_CODCATEGORIAPAGO;
	END TRY

	BEGIN CATCH
		SELECT @p_VARIABLEPORCENTUAL_out = 0, @p_VARIABLETRANSACCIONAL_out = 0;
	END CATCH
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_DeactivateRecord(@pk_ID_CATEGORIAPAGO NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.CATEGORIAPAGO
       SET CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION     = GETDATE(),
           ACTIVE                    = 0
     WHERE ID_CATEGORIAPAGO = @pk_ID_CATEGORIAPAGO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetRecord(@pk_ID_CATEGORIAPAGO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.CATEGORIAPAGO
    WHERE ID_CATEGORIAPAGO = @pk_ID_CATEGORIAPAGO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_CATEGORIAPAGO,
             NOMCATEGORIAPAGO,
             DIASHABILESPAGOGTECH,
             DIASHABILESPAGOFIDUCIA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CATEGORIAPAGO
       WHERE ID_CATEGORIAPAGO = @pk_ID_CATEGORIAPAGO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCATEGORIAPAGO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCATEGORIAPAGO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT ID_CATEGORIAPAGO,
             NOMCATEGORIAPAGO,
             DIASHABILESPAGOGTECH,
             DIASHABILESPAGOFIDUCIA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CATEGORIAPAGO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO






