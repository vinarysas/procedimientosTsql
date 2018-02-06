USE SFGPRODU;
--  DDL for Package Body SFGDETALLETAREAEJECUTADA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLETAREAEJECUTADA */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_AddRecord(@p_CODDETALLETAREA              NUMERIC(22,0),
                      @p_PROCESOID                    NUMERIC(22,0),
                      @p_FECHAEJECUCION               DATETIME,
                      @p_CONSECUTIVO                  NUMERIC(22,0),
                      @p_CODTAREAEJECUTADA            NUMERIC(22,0),
                      @p_PARAMETROUTILIZADO           NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_DETALLETAREAEJECUTADA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DETALLETAREAEJECUTADA (
                                       CODDETALLETAREA,
                                       PROCESOID,
                                       FECHAEJECUCION,
                                       CODINFOEJECUCION,
                                       CODTAREAEJECUTADA,
                                       PARAMETROUTILIZADO,
                                       CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODDETALLETAREA,
            @p_PROCESOID,
            @p_FECHAEJECUCION,
            @p_CONSECUTIVO,
            @p_CODTAREAEJECUTADA,
            @p_PARAMETROUTILIZADO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DETALLETAREAEJECUTADA_out = SCOPE_IDENTITY();

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateRecord(@pk_ID_DETALLETAREAEJECUTADA NUMERIC(22,0),
                         @p_CODTAREAEJECUTADA         NUMERIC(22,0),
                         @p_CONSECUTIVO               NUMERIC(22,0),
                         @p_FECHAEJECUCION            DATETIME,
                         @p_FECHAHORAMODIFICACION     DATETIME,
                         @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                         @p_ACTIVE                    NUMERIC(22,0),
                         @p_CODDETALLETAREA           NUMERIC(22,0),
                         @p_PROCESOID                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLETAREAEJECUTADA
       SET CODTAREAEJECUTADA      = @p_CODTAREAEJECUTADA,
           CODINFOEJECUCION       = @p_CONSECUTIVO,
           FECHAEJECUCION         = @p_FECHAEJECUCION,
           FECHAHORAMODIFICACION  = @p_FECHAHORAMODIFICACION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE,
           CODDETALLETAREA        = @p_CODDETALLETAREA,
           PROCESOID              = @p_PROCESOID
     WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;

    IF @@ROWCOUNT = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @@ROWCOUNT > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetRecord(@pk_ID_DETALLETAREAEJECUTADA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @L_COUNT INTEGER;
   
  SET NOCOUNT ON;
    SELECT @L_COUNT = COUNT(*) FROM WSXML_SFG.DETALLETAREAEJECUTADA WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;
    IF @L_COUNT = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @L_COUNT > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 
		
		  SELECT DTE.ID_DETALLETAREAEJECUTADA,
				 DTE.CODTAREAEJECUTADA,
				 DTE.CODINFOEJECUCION,
				 DTE.FECHAEJECUCION,
				 DTE.FECHAHORAMODIFICACION,
				 DTE.CODUSUARIOMODIFICACION,
				 DTE.ACTIVE,
				 DTE.CODDETALLETAREA,
				 DT.NOMDETALLETAREA,
				 DTE.PROCESOID
			FROM WSXML_SFG.DETALLETAREAEJECUTADA DTE
			LEFT OUTER JOIN WSXML_SFG.DETALLETAREA DT ON (DT.ID_DETALLETAREA =
												 DTE.CODDETALLETAREA)
		   WHERE DTE.ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_DETALLETAREAEJECUTADA,
             CODTAREAEJECUTADA,
             CODINFOEJECUCION,
             FECHAEJECUCION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             CODDETALLETAREA,
             PROCESOID
        FROM WSXML_SFG.DETALLETAREAEJECUTADA
       WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetListByHeader;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetListByHeader(@p_active            NUMERIC(22,0),
                           @p_CODTAREAEJECUTADA NUMERIC(22,0)
                                             ) AS
  BEGIN
  SET NOCOUNT ON;

    -- GET THE ROWS FROM THE QUERY.  CHECKSUM VALUE WILL BE
    -- RETURNED ALONG THE ROW DATA TO SUPPORT CONCURRENCY.
	
      SELECT DTE.ID_DETALLETAREAEJECUTADA,
             DTE.CODTAREAEJECUTADA,
             DTE.CODINFOEJECUCION,
             DTE.FECHAEJECUCION,
             DTE.FECHAHORAMODIFICACION,
             DTE.CODUSUARIOMODIFICACION,
             DTE.ACTIVE,
             DTE.CODDETALLETAREA,
             DT.NOMDETALLETAREA,
             DTE.PROCESOID
        FROM WSXML_SFG.DETALLETAREAEJECUTADA DTE
        LEFT OUTER JOIN DETALLETAREA DT ON (DT.ID_DETALLETAREA =
                                             DTE.CODDETALLETAREA)
       WHERE CODTAREAEJECUTADA = @p_CODTAREAEJECUTADA
         AND DTE.ACTIVE = CASE WHEN @p_active = -1 THEN DTE.ACTIVE ELSE @p_active END;
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords(@pk_ID_DETALLETAREAEJECUTADA NUMERIC(22,0), @p_TOTALREGISTROS NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
  
	BEGIN TRY
		IF @p_TOTALREGISTROS > 0 BEGIN
		  UPDATE WSXML_SFG.DETALLETAREAEJECUTADA
			 SET TOTALREGISTROS        = @p_TOTALREGISTROS,
				 FECHAHORAMODIFICACION = GETDATE()
		   WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;
		END 
	END TRY
	BEGIN CATCH
		SELECT NULL;
	END CATCH
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords(@pk_ID_DETALLETAREAEJECUTADA NUMERIC(22,0), @p_COUNTREGISTROS NUMERIC(22,0)) AS
 BEGIN
    DECLARE @cTOTALRECORDS NUMERIC(22,0);
   
  SET NOCOUNT ON;
  
	BEGIN TRY
		UPDATE WSXML_SFG.DETALLETAREAEJECUTADA
		   SET COUNTREGISTROS = round(@p_COUNTREGISTROS,2)
		 WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;

		SELECT @cTOTALRECORDS = TOTALREGISTROS FROM WSXML_SFG.DETALLETAREAEJECUTADA WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;
		IF @p_COUNTREGISTROS > @cTOTALRECORDS BEGIN
		  UPDATE WSXML_SFG.DETALLETAREAEJECUTADA SET TOTALREGISTROS = round(@p_COUNTREGISTROS,2)
		  WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;
		END 
	END TRY
	BEGIN CATCH
		SELECT NULL;
	END CATCH
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetProgressPercentage', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetProgressPercentage;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_GetProgressPercentage(@pk_ID_DETALLETAREAEJECUTADA NUMERIC(22,0), @p_PERCENTAGE_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_PERCENTAGE_out = (COUNTREGISTROS * 100) / TOTALREGISTROS FROM WSXML_SFG.DETALLETAREAEJECUTADA
     WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;

    IF @p_PERCENTAGE_out > 100 BEGIN
      SET @p_PERCENTAGE_out = 100;
    END 
	
	IF @@ROWCOUNT = 0
		SET @p_PERCENTAGE_out = 0;
    
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREAEJECUTADA_FinalizeExecution(@pk_ID_DETALLETAREAEJECUTADA NUMERIC(22,0), @p_DESCRIPCIONFINAL NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
	BEGIN TRY
		UPDATE WSXML_SFG.DETALLETAREAEJECUTADA
		   SET DESCRIPCIONFINAL = @p_DESCRIPCIONFINAL
		 WHERE ID_DETALLETAREAEJECUTADA = @pk_ID_DETALLETAREAEJECUTADA;
	END TRY
	BEGIN CATCH
		SELECT NULL;
	END CATCH
END;
