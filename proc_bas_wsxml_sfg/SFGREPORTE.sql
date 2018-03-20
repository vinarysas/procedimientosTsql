USE SFGPRODU;
--  DDL for Package Body SFGREPORTE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREPORTE */ 

  IF OBJECT_ID('WSXML_SFG.SFGREPORTE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTE_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREPORTE_GetList AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_REPORTE, NOMREPORTE, CODUSUARIOMODIFICACION, FECHAHORAMODIFICACION
      FROM WSXML_SFG.REPORTE;
  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGREPORTE_QueueCustomReportMail', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTE_QueueCustomReportMail;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTE_QueueCustomReportMail(@p_NOMBRENOTIFICACION NVARCHAR(2000), @p_DESCRIPCIONNOTIFICACION NVARCHAR(2000), @p_DESTINO NVARCHAR(2000), @p_ADJUNTOS NVARCHAR(2000)) AS
 BEGIN
	 SET NOCOUNT ON;
    DECLARE @CRLF     VARCHAR(2) = ISNULL(CHAR(13), '') + ISNULL(CHAR(10), '');
    DECLARE @cCODUSUARIOMODIFICACION NUMERIC(22,0) = 1;
    DECLARE @mailMESSAGE NVARCHAR(2000);
    DECLARE @mailqueueID NUMERIC(22,0);
    DECLARE @errormsg    NVARCHAR(2000);
   

   BEGIN TRY

	DECLARE @p_EMAIL TINYINT,@p_SMS TINYINT
    EXEC WSXML_SFG.SFGTIPONOTIFICACION_CONSTANT @p_EMAIL OUT,@p_SMS OUT
 
		SET @mailMESSAGE = ISNULL(@p_DESCRIPCIONNOTIFICACION, '') + ISNULL(@CRLF, '');
		INSERT INTO WSXML_SFG.ENVIOCORREO(
								CODTIPONOTIFICACION,
								DESTINO,
								ASUNTO,
								MENSAJE,
								CODALERTA,
								CODUSUARIOMODIFICACION)
		VALUES (
				@p_EMAIL,
				@p_DESTINO,
				@p_NOMBRENOTIFICACION,
				@mailMESSAGE,
				NULL,
				@cCODUSUARIOMODIFICACION);
		SET @mailqueueID = SCOPE_IDENTITY();
		-- Adjuntar cada uno de los archivos especificados
		DECLARE tAttachment CURSOR FOR SELECT VALUE AS ATTACHMENT FROM STRING_SPLIT(@p_ADJUNTOS, ';') 
		OPEN tAttachment;

		DECLARE @ATTACHMENT VARCHAR(MAX);

		 FETCH NEXT FROM tAttachment INTO @ATTACHMENT
		 WHILE @@FETCH_STATUS=0
		 BEGIN
			  INSERT INTO WSXML_SFG.ENVIOCORREOADJUNTO ( CODENVIOCORREO, ADJUNTO)
			  VALUES ( @mailqueueID, @ATTACHMENT);
			FETCH NEXT FROM tAttachment INTO @ATTACHMENT
			END;

		CLOSE tAttachment;
		DEALLOCATE tAttachment;
	END TRY
	BEGIN CATCH
  
	  SET @errormsg = '-20093 No es posible encolar el envio de correo: ' + isnull(ERROR_MESSAGE() , '');
		RAISERROR(@errormsg, 16, 1);
	END  CATCH
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREPORTE_SetReportGenerated', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTE_SetReportGenerated;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTE_SetReportGenerated(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                               @p_NOMREPORTE             NVARCHAR(2000),
                               @p_RUTAGENERADO           NVARCHAR(2000),
                               @p_ID_REPORTEGENERADO_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCODREPORTE    NUMERIC(22,0);
    DECLARE @xACTUALCYCLEID NUMERIC(22,0) = @p_CODCICLOFACTURACIONPDV;
   DECLARE @msg VARCHAR(2000)
  SET NOCOUNT ON;
    -- Bootstrap Cycle Sequence
    IF @xACTUALCYCLEID = -1 BEGIN
      SET @xACTUALCYCLEID = WSXML_SFG.ULTIMO_CICLOFACTURACION(GETDATE());
    END 
    BEGIN
		--SFGTMPTRACE.TraceLog('Reporte to set generated: ' || p_NOMREPORTE);
		SELECT @cCODREPORTE = ID_REPORTE FROM WSXML_SFG.REPORTE WHERE NOMREPORTE = @p_NOMREPORTE;
		IF @@ROWCOUNT = 0 BEGIN
			SET @msg = '-20004 El reporte ' + ISNULL(@p_NOMREPORTE, '') + ' al que se esta haciendo referencia no existe'
			RAISERROR(@msg, 16, 1);
		END
    END;
end
GO



IF OBJECT_ID('WSXML_SFG.SFGREPORTE_QueueSingleReportMail', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTE_QueueSingleReportMail;
GO

CREATE PROCEDURE WSXML_SFG.SFGREPORTE_QueueSingleReportMail(
  @p_CODCICLOFACTURACIONPDV NUMERIC(22,0), 
  @p_LLAVECORREO NVARCHAR(2000), 
  @p_COUNTREPORTS_out NUMERIC(22,0) OUT
) AS
 BEGIN
    DECLARE @errorMSG NVARCHAR(1000);
    DECLARE @CRLF     VARCHAR(2) = ISNULL(CHAR(13), '') + ISNULL(CHAR(10), '');
    DECLARE @cCODUSUARIOMODIFICACION NUMERIC(22,0) = 1;
    DECLARE @cCODREPORTECORREO NUMERIC(22,0);
    DECLARE @cNOMREPORTECORREO NVARCHAR(500);
    DECLARE @cDESCRIPCION      NVARCHAR(2000);
   
    SET NOCOUNT ON;
    SET @p_COUNTREPORTS_out = 0;
    SELECT @cCODREPORTECORREO = ID_REPORTECORREO, @cNOMREPORTECORREO = NOMREPORTECORREO, @cDESCRIPCION = DESCRIPCION
    FROM WSXML_SFG.REPORTECORREO WHERE LLAVECORREO = @p_LLAVECORREO;

    DECLARE @lstDESTINTRIES STRINGARRAY;
    DECLARE @lstATTACHMENTS STRINGARRAY;
    DECLARE @mailMESSAGE NVARCHAR(2000);
    DECLARE @mailqueueID NUMERIC(22,0);
    
    -- Verify that every attachment has been generated, and get generation path
    SELECT 
      RCA.CODREPORTECORREO, 
      RPT.NOMREPORTE,
      ISNULL(RGD.GENERADO, 0) AS GENERADO,
      RGD.RUTAGENERADO
    FROM WSXML_SFG.REPORTECORREOADJUNTO RCA
    INNER JOIN WSXML_SFG.REPORTE RPT ON (RPT.ID_REPORTE = RCA.CODREPORTE)
    LEFT OUTER JOIN WSXML_SFG.REPORTEGENERADO RGD ON (RGD.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV AND RGD.CODREPORTE = RCA.CODREPORTE)
    WHERE RCA.CODREPORTECORREO = @cCODREPORTECORREO
      AND RCA.ACTIVE = 1
END
GO



  IF OBJECT_ID('WSXML_SFG.SFGREPORTE_QueueReportMails', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTE_QueueReportMails;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTE_QueueReportMails(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0), @p_COUNTREPORTS_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @CRLF     VARCHAR(2) = ISNULL(CHAR(13), '') + ISNULL(CHAR(10), '');
    DECLARE @cCODUSUARIOMODIFICACION NUMERIC(22,0) = 1;
   
  SET NOCOUNT ON;
    SET @p_COUNTREPORTS_out = 0;
    -- If invoked, send again
    SELECT ID_REPORTECORREO, NOMREPORTECORREO, DESCRIPCION FROM WSXML_SFG.REPORTECORREO WHERE ACTIVE = 1; ;
END