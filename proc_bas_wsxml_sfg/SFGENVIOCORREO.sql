USE SFGPRODU;
--  DDL for Package Body SFGENVIOCORREO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGENVIOCORREO */ 

  IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_AddRecord(@p_CODTIPONOTIFICACION    NUMERIC(22,0),
                      @p_CODALERTA              NUMERIC(22,0),
                      @p_DESTINO                NVARCHAR(2000),
                      @p_ASUNTO                 NVARCHAR(2000),
                      @p_MENSAJE                NVARCHAR(2000),
                      @p_URLREDIRECT            NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_ENVIOCORREO_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ENVIOCORREO (
                             CODTIPONOTIFICACION,
                             CODALERTA,
                             DESTINO,
                             ASUNTO,
                             MENSAJE,
                             URLREDIRECT,
                             CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODTIPONOTIFICACION,
            @p_CODALERTA,
            @p_DESTINO,
            @p_ASUNTO,
            @p_MENSAJE,
            @p_URLREDIRECT,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ENVIOCORREO_out = SCOPE_IDENTITY();
  END;
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGENVIOCORREO_AddCorreo'
    AND type IN (N'FN', N'IF', N'TF')
)
  DROP FUNCTION WSXML_SFG.SFGENVIOCORREO_AddCorreo;
GO


IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_AddCorreo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_AddCorreo;
GO

CREATE PROCEDURE WSXML_SFG.SFGENVIOCORREO_AddCorreo(
					@p_CODALERTA               NUMERIC(22,0),
                     @p_DESTINO                NVARCHAR(2000),
                     @p_ASUNTO                 NVARCHAR(2000),
                     @p_MENSAJE                NVARCHAR(2000),
                     @p_URLREDIRECT            NVARCHAR(2000),
                     @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
					 @cCODENVIOCORREO			NUMERIC(22,0) OUT
)AS
 BEGIN
  
    EXEC WSXML_SFG.SFGENVIOCORREO_AddRecord 1, @p_CODALERTA, @p_DESTINO, @p_ASUNTO, @p_MENSAJE, @p_URLREDIRECT, @p_CODUSUARIOMODIFICACION, @cCODENVIOCORREO OUT
    
  END;
GO

IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGENVIOCORREO_AddSMS'
    AND type IN (N'FN', N'IF', N'TF')
)
  DROP FUNCTION WSXML_SFG.SFGENVIOCORREO_AddSMS;
GO

IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_AddSMS', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_AddSMS;
GO


CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_AddSMS(@p_CODALERTA              NUMERIC(22,0),
                  @p_DESTINO                NVARCHAR(2000),
                  @p_ASUNTO                 NVARCHAR(2000),
                  @p_MENSAJE                NVARCHAR(2000),
                  @p_URLREDIRECT            NVARCHAR(2000),
                  @p_CODUSUARIOMODIFICACION NUMERIC(22,0) , @cCODENVIOCORREO NUMERIC(22,0) OUT ) AS
 BEGIN
    EXEC WSXML_SFG.SFGENVIOCORREO_AddRecord 2, @p_CODALERTA, @p_DESTINO, @p_ASUNTO, @p_MENSAJE, @p_URLREDIRECT, @p_CODUSUARIOMODIFICACION, @cCODENVIOCORREO OUT
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_UpdateRecord(@pk_ID_ENVIOCORREO        NUMERIC(22,0),
                         @p_CODALERTA              NUMERIC(22,0),
                         @p_DESTINO                NVARCHAR(2000),
                         @p_ASUNTO                 NVARCHAR(2000),
                         @p_MENSAJE                NVARCHAR(2000),
                         @p_URLREDIRECT            NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ENVIOCORREO
       SET CODALERTA              = @p_CODALERTA,
           DESTINO                = @p_DESTINO,
           ASUNTO                 = @p_ASUNTO,
           MENSAJE                = @p_MENSAJE,
           URLREDIRECT            = @p_URLREDIRECT,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ENVIOCORREO = @pk_ID_ENVIOCORREO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20054 Multiple object instances', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetRecord(@pk_ID_ENVIOCORREO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(1) FROM WSXML_SFG.ENVIOCORREO WHERE ID_ENVIOCORREO = @pk_ID_ENVIOCORREO;
    IF @l_count < 0 BEGIN
      RAISERROR('-20054 The record no longer exists', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20054 Multiple object instances', 16, 1);
    END 
	  
      SELECT ID_ENVIOCORREO,
             CODALERTA,
             DESTINO,
             ASUNTO,
             MENSAJE,
             URLREDIRECT,
             CORREOENVIADO,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ENVIOCORREO
       WHERE ID_ENVIOCORREO = @pk_ID_ENVIOCORREO;
    
  END;
GO

 IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	  
      SELECT ID_ENVIOCORREO,
             CODALERTA,
             DESTINO,
             ASUNTO,
             MENSAJE,
             URLREDIRECT,
             CORREOENVIADO,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ENVIOCORREO
       WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_GetUnsentList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetUnsentList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetUnsentList AS
  BEGIN
  SET NOCOUNT ON;
    -- Open MAX 50 messages
	  
      SELECT ID_ENVIOCORREO,
             CODTIPONOTIFICACION,
             CODALERTA,
             NOMTIPOALERTA,
             NOMPROCESO,
             DESCRIPCIONPROCESO,
             CONTENIDO,
             DESTINO,
             MENSAJEDETALLADO,
             ASUNTO,
             MENSAJE,
             URLREDIRECT,
             CORREOENVIADO,
             FECHAHORAMODIFICACION,
             NUMADJUNTOS
      FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY EC.ID_ENVIOCORREO asc) ISD_ROW_NUMBER,
                   EC.ID_ENVIOCORREO,
                   EC.CODTIPONOTIFICACION,
                   ISNULL(EC.CODALERTA, 0)                 AS CODALERTA,
                   ISNULL(TA.NOMTIPOALERTA, 'Informativo') AS NOMTIPOALERTA,
                   ISNULL(PR.NOMPROCESO, 'N/A')            AS NOMPROCESO,
                   ISNULL(PR.DESCRIPCION, 'N/A')           AS DESCRIPCIONPROCESO,
                   AL.CONTENIDO                         AS CONTENIDO,
                   ISNULL(AL.MENSAJEDETALLADO, 'N/A')      AS MENSAJEDETALLADO,
                   EC.DESTINO,
                   EC.ASUNTO,
                   EC.MENSAJE,
                   EC.URLREDIRECT,
                   EC.CORREOENVIADO,
                   EC.FECHAHORAMODIFICACION,
                   ISNULL(EA.NUMADJUNTOS, 0)               AS NUMADJUNTOS
            FROM WSXML_SFG.ENVIOCORREO EC
            LEFT OUTER JOIN WSXML_SFG.ALERTA AL ON (CODALERTA = ID_ALERTA)
            LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (CODTIPOALERTA = ID_TIPOALERTA)
            LEFT OUTER JOIN WSXML_SFG.PROCESO PR ON (CODPROCESO = ID_PROCESO)
            LEFT OUTER JOIN (
				SELECT CODENVIOCORREO, COUNT(1) AS NUMADJUNTOS
                FROM WSXML_SFG.ENVIOCORREOADJUNTO
                GROUP BY CODENVIOCORREO
			) EA ON (EA.CODENVIOCORREO = EC.ID_ENVIOCORREO)
            WHERE EC.CORREOENVIADO = 0
              AND EC.ACTIVE = 1
		) T -- Serves as control over mail not complete (attachment)
      WHERE T.ISD_ROW_NUMBER <= 50;
	  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_GetUnsentAttachments', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetUnsentAttachments;
GO
CREATE     PROCEDURE WSXML_SFG.SFGENVIOCORREO_GetUnsentAttachments(@pk_ID_ENVIOCORREO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	  
      SELECT ADJUNTO FROM WSXML_SFG.ENVIOCORREOADJUNTO WHERE CODENVIOCORREO = @pk_ID_ENVIOCORREO;
	 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGENVIOCORREO_SetCorreoAsSent', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGENVIOCORREO_SetCorreoAsSent;
GO

CREATE  PROCEDURE WSXML_SFG.SFGENVIOCORREO_SetCorreoAsSent(@pk_ID_ENVIOCORREO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ENVIOCORREO SET CORREOENVIADO = 1, FECHAHORAMODIFICACION = GETDATE()
    WHERE ID_ENVIOCORREO = @pk_ID_ENVIOCORREO;
  END;
GO






