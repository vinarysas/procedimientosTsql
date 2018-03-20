USE SFGPRODU;
--  DDL for Package Body SFGFMR
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGFMR */ 

IF OBJECT_ID('WSXML_SFG.SFGFMR_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGFMR_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGFMR_AddRecord(@p_CODUSUARIO             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_FMR_out             NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.FMR
      ( CODUSUARIO, CODUSUARIOMODIFICACION)
    VALUES
      ( @p_CODUSUARIO, @p_CODUSUARIOMODIFICACION);
    SET @p_ID_FMR_out = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGFMR_AddFMRRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGFMR_AddFMRRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGFMR_AddFMRRecord(@p_CODIGOGTECHFMR         NVARCHAR(2000),
                         @p_NOMFMR                 NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ID_FMR_out             NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.FMR
      ( CODIGOGTECHFMR, NOMFMR, CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODIGOGTECHFMR,
       @p_NOMFMR,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_FMR_out = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGFMR_CheckUpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGFMR_CheckUpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGFMR_CheckUpdateRecord(@p_CODIGOGTECHFMR NVARCHAR(2000),
                              @p_NOMFMR         NVARCHAR(2000),
                              @p_EMAILFMR       NVARCHAR(2000)) AS
 BEGIN
    DECLARE @thisFMRID    NUMERIC(22,0);
    DECLARE @thisFMRName VARCHAR(4000)  /* Use -meta option FMR.NOMFMR%TYPE */;
    DECLARE @thisFMRemail NVARCHAR(100);
   
  SET NOCOUNT ON;
    SELECT @thisFMRID = ID_FMR, @thisFMRName = NOMFMR, @thisFMRemail = ISNULL(EMAIL, '')
      FROM WSXML_SFG.FMR
     WHERE CODIGOGTECHFMR = RTRIM(LTRIM(@p_CODIGOGTECHFMR));
    IF @thisFMRName <> @p_NOMFMR BEGIN
      UPDATE WSXML_SFG.FMR SET NOMFMR = @p_NOMFMR WHERE ID_FMR = @thisFMRID;
    END 
    IF @thisFMRemail <> @p_EMAILFMR BEGIN
      UPDATE WSXML_SFG.FMR SET EMAIL = @thisFMRemail WHERE ID_FMR = @thisFMRID;
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGFMR_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGFMR_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGFMR_UpdateRecord(@pk_ID_FMR                NUMERIC(22,0),
                         @p_CODUSUARIO             NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.FMR
       SET CODUSUARIO             = @p_CODUSUARIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_FMR = @pk_ID_FMR;
	
	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGFMR_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGFMR_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGFMR_GetRecord(@pk_ID_FMR NUMERIC(22,0)
                                                    ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.FMR WHERE ID_FMR = @pk_ID_FMR;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
     
      SELECT F.ID_FMR,
             F.CODUSUARIO,
             U.NOMUSUARIO,
             F.FECHAHORAMODIFICACION,
             F.CODUSUARIOMODIFICACION,
             F.ACTIVE
        FROM WSXML_SFG.FMR F
        LEFT OUTER JOIN WSXML_SFG.USUARIO U
          ON (U.ID_USUARIO = F.CODUSUARIO)
       WHERE ID_FMR = @pk_ID_FMR;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGFMR_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGFMR_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGFMR_GetList(@p_active NUMERIC(22,0)
                                                  ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT F.ID_FMR,
             F.CODUSUARIO,
             U.NOMUSUARIO,
             F.FECHAHORAMODIFICACION,
             F.CODUSUARIOMODIFICACION,
             F.ACTIVE
        FROM WSXML_SFG.FMR F
        LEFT OUTER JOIN WSXML_SFG.USUARIO U
          ON (U.ID_USUARIO = F.CODUSUARIO)
       WHERE F.ACTIVE = CASE
               WHEN @p_active = -1 THEN
                F.ACTIVE
               ELSE
                @p_active
             END;
			 
  END;
GO






