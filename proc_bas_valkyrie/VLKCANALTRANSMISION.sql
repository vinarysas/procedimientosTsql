 /* PACKAGE BODY VLKCANALTRANSMISION */ 

IF OBJECT_ID('VALKYRIE.VLKCANALTRANSMISION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE VALKYRIE.VLKCANALTRANSMISION_AddRecord;
GO

CREATE     PROCEDURE VALKYRIE.VLKCANALTRANSMISION_AddRecord(@p_NOMCANALTRANSMISION     VARCHAR(4000),
                      @p_CODIGOLINEA             VARCHAR(4000),
                      @p_ESTADO                  INT,
                      @p_FRECUENCIATRANSMISION   VARCHAR(4000),
                      @p_FRECUENCIARECEPCION     VARCHAR(4000),
                      @p_RADIO                   VARCHAR(4000),
                      @p_ORIENTACION             VARCHAR(4000),
                      @p_ESTACION                VARCHAR(4000),
                      @p_TIPOTRANSMISION         VARCHAR(4000),
                      @p_OPERADORCOMUNICACION    VARCHAR(4000),
                      @p_TECNOLOGIATERMINAL      VARCHAR(4000),
                      @p_NODOTERMINAL            VARCHAR(4000),
                      @p_CODUSUARIOMODIFICACION  FLOAT,
                      @p_ID_CANALTRANSMISION_out FLOAT OUT) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_ESTADO NOT IN (0, 1) BEGIN
      RAISERROR('-20015 El estado ' + ISNULL(@p_ESTADO, '') + ' no es valido para insercion', 16, 1);
	  RETURN 0
    END 
    INSERT INTO VALKYRIE.CANALTRANSMISION ( NOMCANALTRANSMISION, CODIGOLINEA, ESTADO, FRECUENCIATRANSMISION, FRECUENCIARECEPCION, CODRADIO, CODORIENTACION, ESTACION, CODTIPOTRANSMISION, CODOPERADORCOMUNICACION, CODTECNOLOGIATERMINAL, CODNODOTERMINAL, CODUSUARIOMODIFICACION)
    VALUES ( ISNULL(RTRIM(LTRIM(@p_NOMCANALTRANSMISION)), ' '), RTRIM(LTRIM(@p_CODIGOLINEA)), @p_ESTADO, @p_FRECUENCIATRANSMISION, @p_FRECUENCIARECEPCION, RADIO_F(@p_RADIO), ORIENTACION_F(@p_ORIENTACION), @p_ESTACION, TIPOTRANSMISION_F(@p_TIPOTRANSMISION), OPERADORCOMUNICACION_F(@p_OPERADORCOMUNICACION), TECNOLOGIATERMINAL_F(@p_TECNOLOGIATERMINAL), NODOTERMINAL_F(@p_NODOTERMINAL), @p_CODUSUARIOMODIFICACION);
    SET @p_ID_CANALTRANSMISION_out = SCOPE_IDENTITY();
  END;
 GO
 
IF OBJECT_ID('VALKYRIE.VLKCANALTRANSMISION_SetEstadoCanal', 'P') IS NOT NULL
  DROP PROCEDURE VALKYRIE.VLKCANALTRANSMISION_SetEstadoCanal;
GO

CREATE     PROCEDURE VALKYRIE.VLKCANALTRANSMISION_SetEstadoCanal(@p_CODIGOLINEA VARCHAR(4000), @p_ESTADO INT, @p_ID_CANALTRANSMISIONESTAD_out FLOAT OUT) AS
 BEGIN
    DECLARE @xCodCanal      FLOAT;
    DECLARE @xCurrentEstado INT;
    DECLARE @xCurrentActive INT;
    DECLARE @xTimeStamp     DATETIME = GETDATE();
    DECLARE @ErrorMessage   NVARCHAR(2000);
   
  SET NOCOUNT ON;
  
  BEGIN TRY
    IF @p_ESTADO NOT IN (0, 1) BEGIN
      RAISERROR('-20015 El estado ' + ISNULL(@p_ESTADO, '') + ' no es valido para insercion', 16, 1);
	  RETURN 0
    END 
    SELECT @xCodCanal = ID_CANALTRANSMISION, @xCurrentEstado = ESTADO, @xCurrentActive = ACTIVE FROM VALKYRIE.CANALTRANSMISION WHERE CODIGOLINEA = RTRIM(LTRIM(@p_CODIGOLINEA));
	
	IF @@ROWCOUNT = 0 BEGIN
		RAISERROR('-20014 El canal especificado ''' + ISNULL(RTRIM(LTRIM(@p_CODIGOLINEA)), '') + ''' no existe en el sistema', 16, 1);
		RETURN 0
	END
	
    INSERT INTO VALKYRIE.CANALTRANSMISIONESTADO ( CODCANALTRANSMISION, ESTADO, FECHAHORAESTADO)
    VALUES ( @xCodCanal, @p_ESTADO, @xTimeStamp); 
	SET @p_ID_CANALTRANSMISIONESTAD_out = SCOPE_IDENTITY();
	
    IF @p_ESTADO <> @xCurrentEstado BEGIN
      UPDATE VALKYRIE.CANALTRANSMISION SET ESTADO = @p_ESTADO, FECHAHORAESTADO = @xTimeStamp WHERE ID_CANALTRANSMISION = @xCodCanal;
    END 
    IF @xCurrentActive = 0 BEGIN
      UPDATE VALKYRIE.CANALTRANSMISION SET ACTIVE = 1 WHERE ID_CANALTRANSMISION = @xCodCanal;
    END 
  END TRY
  BEGIN CATCH
    RAISERROR('-20010 Error en la invocacion del procedimiento SetEstadoCanal con parametros ' + ISNULL(@p_CODIGOLINEA, '') + ', ' + ISNULL(@p_ESTADO, '') + ': ' + ISNULL(@ErrorMessage, ''), 16, 1);
  END CATCH
 END;
 GO
  
  IF OBJECT_ID('VALKYRIE.VLKCANALTRANSMISION_GetCanales', 'P') IS NOT NULL
  DROP PROCEDURE VALKYRIE.VLKCANALTRANSMISION_GetCanales;
GO

CREATE     PROCEDURE VALKYRIE.VLKCANALTRANSMISION_GetCanales AS
 BEGIN
    DECLARE @xTimeStamp   DATETIME = GETDATE();
    DECLARE @ErrorMessage NVARCHAR(2000);
   
  SET NOCOUNT ON;
	BEGIN TRY
      SELECT ID_CANALTRANSMISION, CODIGOLINEA, NOMCANALTRANSMISION, ESTADO, FECHAHORAESTADO, WSXML_SFG.FECHAS_DIFERENCIA(@xTimeStamp, FECHAHORAESTADO) AS DIFERENCIA, CODTECNOLOGIATERMINAL, NOMTECNOLOGIATERMINAL 
	  FROM VALKYRIE.CANALTRANSMISION
      INNER JOIN VALKYRIE.TECNOLOGIATERMINAL ON (CODTECNOLOGIATERMINAL = ID_TECNOLOGIATERMINAL)
      WHERE ACTIVE = 1 AND CONSIDERARCAIDO = 1 ORDER BY CONVERT(NUMERIC,CODIGOLINEA);
	
	END TRY
	BEGIN CATCH
		SET @ErrorMessage = SQLERRM;
		RAISERROR('-20010 Error en la invocacion del procedimiento GetCanales: ' + ISNULL(@ErrorMessage, ''), 16, 1);      
	END CATCH
  END;
GO

IF OBJECT_ID('VALKYRIE.VLKCANALTRANSMISION_InactivaCanal', 'P') IS NOT NULL
  DROP PROCEDURE VALKYRIE.VLKCANALTRANSMISION_InactivaCanal;
GO

CREATE PROCEDURE VALKYRIE.VLKCANALTRANSMISION_InactivaCanal(@p_CODIGOLINEA VARCHAR(4000)) AS
BEGIN
SET NOCOUNT ON;

  UPDATE VALKYRIE.CANALTRANSMISION
     SET CODRADIO                = 6,  -- NA
         CODORIENTACION          = 19, -- NA
         CODTIPOTRANSMISION      = 5,  -- BASURA
         CODOPERADORCOMUNICACION = 6,  -- NA
         CODTECNOLOGIATERMINAL   = 5,  -- BASURA
         CODNODOTERMINAL         = 6   -- ND
   WHERE CODIGOLINEA = @p_CODIGOLINEA;

END;
   
END 
GO

