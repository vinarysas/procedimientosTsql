USE SFGPRODU;
--  DDL for Package Body SFGENTRADAJUEGOS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGENTRADAJUEGOS */ 

  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_AddRecord(@p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
                      @p_FECHA                DATETIME,
                      @p_AGENTE               NVARCHAR(2000),
                      @p_COLOCADOR            NVARCHAR(2000),
                      @p_PRODUCTO             NVARCHAR(2000),
                      @p_TPTRANSACCION        NVARCHAR(2000),
                      @p_NTRANSACCIONES       NUMERIC(22,0),
                      @p_VTRANSACCIONES       NUMERIC(22,0),
                      @p_RETEFUENTE           NUMERIC(22,0),
                      @p_PREMIONETO           NUMERIC(22,0),
                      @p_CODDUENOPUNTODEVENTA        NVARCHAR(2000),
                      @p_ID_ENTRADAJUEGOS_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    
    IF @p_CODDUENOPUNTODEVENTA = 0 begin
     INSERT INTO WSXML_SFG.ENTRADAJUEGOS (
                               CODENTRADAARCHIVOCONTROL,
                               FECHA,
                               AGENTE,
                               COLOCADOR,
                               PRODUCTO,
                               TPTRANSACCION,
                               NTRANSACCIONES,
                               VTRANSACCIONES,
                               RETEFUENTE,
                               PREMIONETO, 
                               CODDUENOPUNTODEVENTA)
    VALUES (
            @p_CODENTRADAARCHIVOCONTROL,
            @p_FECHA,
            @p_AGENTE,
            @p_COLOCADOR,
            @p_PRODUCTO,
            @p_TPTRANSACCION,
            @p_NTRANSACCIONES,
            @p_VTRANSACCIONES,
            @p_RETEFUENTE,
            @p_PREMIONETO, 
            0);
    SET @p_ID_ENTRADAJUEGOS_out = SCOPE_IDENTITY();
    END
    ELSE BEGIN 
      INSERT INTO WSXML_SFG.ENTRADAJUEGOS (
                               CODENTRADAARCHIVOCONTROL,
                               FECHA,
                               AGENTE,
                               COLOCADOR,
                               PRODUCTO,
                               TPTRANSACCION,
                               NTRANSACCIONES,
                               VTRANSACCIONES,
                               RETEFUENTE,
                               PREMIONETO, 
                               CODDUENOPUNTODEVENTA)
    VALUES (
            @p_CODENTRADAARCHIVOCONTROL,
            @p_FECHA,
            @p_AGENTE,
            @p_COLOCADOR,
            @p_PRODUCTO,
            @p_TPTRANSACCION,
            @p_NTRANSACCIONES,
            @p_VTRANSACCIONES,
            @p_RETEFUENTE,
            @p_PREMIONETO, 
            CAST(@p_CODDUENOPUNTODEVENTA AS NUMERIC(38,0)));
    SET @p_ID_ENTRADAJUEGOS_out = SCOPE_IDENTITY();
        END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_UpdateRecord(@pk_ID_ENTRADAJUEGOS NUMERIC(22,0),
                         @p_FECHA             DATETIME,
                         @p_AGENTE            NVARCHAR(2000),
                         @p_COLOCADOR         NVARCHAR(2000),
                         @p_PRODUCTO          NVARCHAR(2000),
                         @p_TPTRANSACCION     NVARCHAR(2000),
                         @p_NTRANSACCIONES    NUMERIC(22,0),
                         @p_VTRANSACCIONES    NUMERIC(22,0),
                         @p_RETEFUENTE        NUMERIC(22,0),
                         @p_PREMIONETO        NUMERIC(22,0),
                         @p_CODDUENOPUNTODEVENTA     NUMERIC(22,0),
                         @p_ACTIVE            NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ENTRADAJUEGOS
       SET FECHA          = @p_FECHA,
           AGENTE         = @p_AGENTE,
           COLOCADOR      = @p_COLOCADOR,
           PRODUCTO       = @p_PRODUCTO,
           TPTRANSACCION  = @p_TPTRANSACCION,
           NTRANSACCIONES = @p_NTRANSACCIONES,
           VTRANSACCIONES = @p_VTRANSACCIONES,
           RETEFUENTE     = @p_RETEFUENTE,
           PREMIONETO     = @p_PREMIONETO,
           CODDUENOPUNTODEVENTA = @p_CODDUENOPUNTODEVENTA,
           ACTIVE         = @p_ACTIVE
     WHERE ID_ENTRADAJUEGOS = @pk_ID_ENTRADAJUEGOS;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  -- Obtiene un registro
  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_GetRecord(@pk_ID_ENTRADAJUEGOS NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ENTRADAJUEGOS
     WHERE ID_ENTRADAJUEGOS = @pk_ID_ENTRADAJUEGOS;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_ENTRADAJUEGOS,
             FECHA,
             AGENTE,
             COLOCADOR,
             PRODUCTO,
             TPTRANSACCION,
             NTRANSACCIONES,
             VTRANSACCIONES,
             RETEFUENTE,
             PREMIONETO,
             CODDUENOPUNTODEVENTA,
             ACTIVE
        FROM WSXML_SFG.ENTRADAJUEGOS
       WHERE ID_ENTRADAJUEGOS = @pk_ID_ENTRADAJUEGOS;
  END;
GO

  -- Obtiene una lista de elementos
  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_ENTRADAJUEGOS,
             FECHA,
             AGENTE,
             COLOCADOR,
             PRODUCTO,
             TPTRANSACCION,
             NTRANSACCIONES,
             VTRANSACCIONES,
             RETEFUENTE,
             PREMIONETO,
             CODDUENOPUNTODEVENTA,
             ACTIVE
        FROM WSXML_SFG.ENTRADAJUEGOS
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_UpdateRecordsTask', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_UpdateRecordsTask;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_UpdateRecordsTask(@p_CODDETALLETAREAEJECUTADA NUMERIC(22,0), @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0), @p_ROWCOUNT_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cNUMROWS NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cNUMROWS = COUNT(1) FROM WSXML_SFG.ENTRADAJUEGOS
    WHERE CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL;

    UPDATE WSXML_SFG.DETALLETAREAEJECUTADA SET COUNTREGISTROS = @cNUMROWS
    WHERE ID_DETALLETAREAEJECUTADA = @p_CODDETALLETAREAEJECUTADA;

    SET @p_ROWCOUNT_out = @@ROWCOUNT;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_ReverseFileLoad', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_ReverseFileLoad;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_ReverseFileLoad(@p_FECHAREPROCESAMIENTO DATETIME, @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0), @p_RETVALUE_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @msg NVARCHAR(2000);
    DECLARE @codENTRADAARCHIVOCONTROL NUMERIC(22,0);
   
  SET NOCOUNT ON;
  BEGIN TRY
    BEGIN
      SELECT @codENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
      WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAREPROCESAMIENTO)) AND TIPOARCHIVO = 2 AND REVERSADO = 0;
      EXEC WSXML_SFG.SFGREGISTROFACTURACION_ReversarCargue3 @codENTRADAARCHIVOCONTROL, @p_CODDETALLETAREAEJECUTADA, @p_RETVALUE_out OUT
		IF @@ROWCOUNT = 0
			 RAISERROR('-20054 No existe ningun archivo para reversar', 16, 1);
    END;
  END TRY
  BEGIN CATCH
	
	DECLARE @p_TIPOINFORMATIVO TINYINT,
		@p_TIPOERROR TINYINT,
		@p_TIPOADVERTENCIA TINYINT,
		@p_TIPOCUALQUIERA TINYINT,
		@p_PROCESONOTIFICACION TINYINT,
		@p_ESTADOABIERTA TINYINT,
		@p_ESTADOCERRADA TINYINT
	EXEC WSXML_SFG.SFGALERTA_CONSTANT
		@p_TIPOINFORMATIVO OUT,
		@p_TIPOERROR OUT,
		@p_TIPOADVERTENCIA OUT,
		@p_TIPOCUALQUIERA OUT,
		@p_PROCESONOTIFICACION OUT,
		@p_ESTADOABIERTA  OUT,
		@p_ESTADOCERRADA OUT
	
	DECLARE 					@p_REGISTRADA      			TINYINT,
                    @p_INICIADA         		TINYINT,
                    @p_FINALIZADAOK 			TINYINT ,
                    @p_FINALIZADAFALLO  		TINYINT ,
					@p_ABORTADA  				TINYINT ,
					@p_NOINICIADA  				TINYINT ,
					@p_FINALIZADAADVERTENCIA  	TINYINT 
	EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT
					@p_REGISTRADA      			OUT,
                    @p_INICIADA         		OUT,
                    @p_FINALIZADAOK 			OUT,
                    @p_FINALIZADAFALLO  		OUT,
					@p_ABORTADA  				OUT,
					@p_NOINICIADA  				OUT,
					@p_FINALIZADAADVERTENCIA  	OUT
    SET @msg = ERROR_MESSAGE ( ) ;
    EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'DESCARGUEJUEGOS', @msg, 1
    EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
    SET @p_RETVALUE_out = @p_FINALIZADAFALLO;
  END CATCH
  END;
GO



  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphans', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphans;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphans(@p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0), @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0), @p_RETVALUE_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCOUNTWARNINGS NUMERIC(22,0) = 0;
    DECLARE @cTOTALREGISTROS NUMERIC(22,0) = 0;
    DECLARE @cCOUNTREGISTROS NUMERIC(22,0) = 0;
    DECLARE @cMODLREGISTROS NUMERIC(22,0) = 0;
    DECLARE @cWAITREGISTROS NUMERIC(22,0) = 5;
    DECLARE @msg NVARCHAR(2000);
   
  SET NOCOUNT ON;
    -- Establecer totalrecords de la tarea
    SELECT @cTOTALREGISTROS = COUNT(1) FROM WSXML_SFG.HUERFANOJUEGOS
    WHERE CODENTRADAARCHIVOCONTROL = CASE WHEN @p_CODENTRADAARCHIVOCONTROL = -1 THEN CODENTRADAARCHIVOCONTROL ELSE @p_CODENTRADAARCHIVOCONTROL END;
END
GO



  IF OBJECT_ID('WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphansByDate', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphansByDate;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphansByDate(@p_FECHAREPROCESAMIENTO DATETIME, @p_CODDETALLETAREAEJECUTADA NUMERIC(22,0), @p_RETVALUE_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0);
    DECLARE @msg NVARCHAR(2000);
   
  SET NOCOUNT ON;

  BEGIN TRY
  		DECLARE @p_TIPOINFORMATIVO TINYINT,
			@p_TIPOERROR TINYINT,
			@p_TIPOADVERTENCIA TINYINT,
			@p_TIPOCUALQUIERA TINYINT,
			@p_PROCESONOTIFICACION TINYINT,
			@p_ESTADOABIERTA TINYINT,
			@p_ESTADOCERRADA TINYINT
		EXEC WSXML_SFG.SFGALERTA_CONSTANT
			@p_TIPOINFORMATIVO OUT,
			@p_TIPOERROR OUT,
			@p_TIPOADVERTENCIA OUT,
			@p_TIPOCUALQUIERA OUT,
			@p_PROCESONOTIFICACION OUT,
			@p_ESTADOABIERTA  OUT,
			@p_ESTADOCERRADA OUT

		DECLARE @p_SERVICIOSCOMERCIALES TINYINT,@p_JUEGOS TINYINT
		EXEC WSXML_SFG.SFGENTRADAARCHIVOCONTROL_CONSTANT @p_SERVICIOSCOMERCIALES OUT, @p_JUEGOS OUT

		SELECT @p_CODENTRADAARCHIVOCONTROL = ID_ENTRADAARCHIVOCONTROL
		FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
		WHERE TIPOARCHIVO = @p_JUEGOS
		  AND REVERSADO = 0
		  AND CONVERT(DATETIME, CONVERT(DATE,FECHAARCHIVO)) = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAREPROCESAMIENTO));

		IF @@ROWCOUNT = 0 BEGIN
			SET @msg = 'No se puede reprocesar el archivo. Su registro ya no existe';
			EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'REPROCESOJUEGOS', @msg, 1
			EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
		END
		IF @@ROWCOUNT > 1  BEGIN
			SET @msg = 'Hay un problema grave de consistencia de datos en el sistema. Hay mas de un archivo de juegos cargado para el dia ' + ISNULL(@p_FECHAREPROCESAMIENTO, '');
			EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'REPROCESOJUEGOS', @msg, 1
			EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
		END
		
		EXEC  WSXML_SFG.SFGENTRADAJUEGOS_ReprocessOrphans @p_CODENTRADAARCHIVOCONTROL, @p_CODDETALLETAREAEJECUTADA, @p_RETVALUE_out OUT

	END TRY
	BEGIN CATCH
		  SET @msg = ERROR_MESSAGE ( ) ;
		  EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOERROR, 'REPROCESOJUEGOS', @msg, 1
		  EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution @p_CODDETALLETAREAEJECUTADA, @msg
	END CATCH
  END;
GO