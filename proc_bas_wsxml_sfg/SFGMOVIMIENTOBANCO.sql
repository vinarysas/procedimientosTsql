USE SFGPRODU;
--  DDL for Package Body SFGMOVIMIENTOBANCO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGMOVIMIENTOBANCO */ 


IF OBJECT_ID('WSXML_SFG.SFGMOVIMIENTOBANCO_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_CONSTANT(
                      @SINCLASIFICAR   smallint OUT,
                      @TRANSBANCARIA smallint OUT,
                      @PAGONOREFRNCD smallint OUT) AS
 BEGIN
 
  SET NOCOUNT ON;
  SET @SINCLASIFICAR = 0;
  SET @TRANSBANCARIA = -1;
  SET @PAGONOREFRNCD = 1;
END 
GO	
  
  
  IF OBJECT_ID('WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecord(@p_NOMMOVIMIENTOBANCO     NVARCHAR(2000),
                      @p_CLASIFICACION          NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_MOVIMIENTOBANCO_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @codEXISTING NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @codEXISTING = ID_MOVIMIENTOBANCO FROM WSXML_SFG.MOVIMIENTOBANCO
    WHERE NOMMOVIMIENTOBANCO = @p_NOMMOVIMIENTOBANCO;
	
	IF(@@rowcount = 0)
	BEGIN
	   INSERT INTO WSXML_SFG.MOVIMIENTOBANCO (NOMMOVIMIENTOBANCO,CLASIFICACION,CODUSUARIOMODIFICACION)
		VALUES (@p_NOMMOVIMIENTOBANCO, @p_CLASIFICACION, @p_CODUSUARIOMODIFICACION);
		SET @p_ID_MOVIMIENTOBANCO_out = SCOPE_IDENTITY();
    END ELSE BEGIN
	  
		IF @codEXISTING > 0 BEGIN
		  UPDATE WSXML_SFG.MOVIMIENTOBANCO SET CLASIFICACION          = @p_CLASIFICACION,
									 CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
									 FECHAHORAMODIFICACION  = GETDATE(),
									 ACTIVE = 1
		  WHERE ID_MOVIMIENTOBANCO = @codEXISTING;
		  SET @p_ID_MOVIMIENTOBANCO_out = @codEXISTING;
		END 
	
	END
/*
  EXCEPTION WHEN OTHERS THEN
    INSERT INTO WSXML_SFG.MOVIMIENTOBANCO (
                                 NOMMOVIMIENTOBANCO,
                                 CLASIFICACION,
                                 CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMMOVIMIENTOBANCO,
            @p_CLASIFICACION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_MOVIMIENTOBANCO_out = SCOPE_IDENTITY();
	*/
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecordDefault', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecordDefault;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecordDefault(@p_NOMMOVIMIENTOBANCO     NVARCHAR(2000),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                             @p_ID_MOVIMIENTOBANCO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    EXEC WSXML_SFG.SFGMOVIMIENTOBANCO_AddRecord @p_NOMMOVIMIENTOBANCO, 0, @p_CODUSUARIOMODIFICACION, @p_ID_MOVIMIENTOBANCO_out;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMOVIMIENTOBANCO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_UpdateRecord(@pk_ID_MOVIMIENTOBANCO    NUMERIC(22,0),
                         @p_NOMMOVIMIENTOBANCO     NVARCHAR(2000),
                         @p_CLASIFICACION          NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.MOVIMIENTOBANCO SET NOMMOVIMIENTOBANCO     = @p_NOMMOVIMIENTOBANCO,
                               CLASIFICACION          = @p_CLASIFICACION,
                               CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
                               FECHAHORAMODIFICACION  = GETDATE(),
                               ACTIVE                 = @p_ACTIVE
    WHERE ID_MOVIMIENTOBANCO = @pk_ID_MOVIMIENTOBANCO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMOVIMIENTOBANCO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_GetRecord(@pk_ID_MOVIMIENTOBANCO NUMERIC(22,0)
                                                                ) AS
  BEGIN
  SET NOCOUNT ON;
   
    SELECT ID_MOVIMIENTOBANCO,
           NOMMOVIMIENTOBANCO,
           CLASIFICACION,
           CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION,
           ACTIVE
    FROM WSXML_SFG.MOVIMIENTOBANCO
    WHERE ID_MOVIMIENTOBANCO = @pk_ID_MOVIMIENTOBANCO;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGMOVIMIENTOBANCO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGMOVIMIENTOBANCO_GetList(@p_ACTIVE NUMERIC(22,0)
                                                              ) AS
  BEGIN
  SET NOCOUNT ON;
   
    SELECT ID_MOVIMIENTOBANCO,
           NOMMOVIMIENTOBANCO,
           CLASIFICACION,
           CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION,
           ACTIVE
    FROM WSXML_SFG.MOVIMIENTOBANCO
    WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
	
  END;
GO






