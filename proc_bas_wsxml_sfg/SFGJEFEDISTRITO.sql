USE SFGPRODU;
--  DDL for Package Body SFGJEFEDISTRITO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGJEFEDISTRITO */ 

  IF OBJECT_ID('WSXML_SFG.SFGJEFEDISTRITO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_AddRecord(@p_CODUSUARIO             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_JEFEDISTRITO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.JEFEDISTRITO
      ( CODUSUARIO, CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODUSUARIO,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_JEFEDISTRITO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGJEFEDISTRITO_AddJefeRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_AddJefeRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_AddJefeRecord(@p_CODIGOGTECHJEFEDISTRITO NVARCHAR(2000),
                          @p_NOMJEFEDISTRITO         NVARCHAR(2000),
                          @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                          @p_ID_JEFEDISTRITO_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.JEFEDISTRITO
      (
       CODIGOGTECHJEFEDISTRITO,
       NOMJEFEDISTRITO,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODIGOGTECHJEFEDISTRITO,
       @p_NOMJEFEDISTRITO,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_JEFEDISTRITO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGJEFEDISTRITO_CheckUpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_CheckUpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_CheckUpdateRecord(@p_CODIGOGTECHJEFEDISTRITO NVARCHAR(2000),
                              @p_NOMJEFEDISTRITO         NVARCHAR(2000),
                              @p_EMAIL                   NVARCHAR(2000)) AS
 BEGIN
    DECLARE @thisJefeDistritoID   NUMERIC(22,0);
    DECLARE @thisJefeDistritoName VARCHAR(4000) /* Use -meta option JEFEDISTRITO.NOMJEFEDISTRITO%TYPE */;
    DECLARE @thisJefeDistritoMail NVARCHAR(100);
   
  SET NOCOUNT ON;
    SELECT @thisJefeDistritoID = ID_JEFEDISTRITO, @thisJefeDistritoName = NOMJEFEDISTRITO, @thisJefeDistritoMail = isnull(EMAIL, '')
      FROM WSXML_SFG.JEFEDISTRITO
     WHERE CODIGOGTECHJEFEDISTRITO = RTRIM(LTRIM(@p_CODIGOGTECHJEFEDISTRITO));
    IF @thisJefeDistritoName <> @p_NOMJEFEDISTRITO BEGIN
      UPDATE WSXML_SFG.JEFEDISTRITO
         SET NOMJEFEDISTRITO = @p_NOMJEFEDISTRITO
       WHERE ID_JEFEDISTRITO = @thisJefeDistritoID;
    END 
    IF @thisJefeDistritoMail <> @p_EMAIL BEGIN
      UPDATE WSXML_SFG.JEFEDISTRITO
         SET EMAIL = @p_EMAIL
       WHERE ID_JEFEDISTRITO = @thisJefeDistritoID;
    END 
  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGJEFEDISTRITO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_UpdateRecord(@pk_ID_JEFEDISTRITO       NUMERIC(22,0),
                         @p_CODUSUARIO             NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.JEFEDISTRITO
       SET CODUSUARIO             = @p_CODUSUARIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_JEFEDISTRITO = @pk_ID_JEFEDISTRITO;
	 
	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGJEFEDISTRITO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_GetRecord(@pk_ID_JEFEDISTRITO NUMERIC(22,0)
                                                             ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*)
      FROM WSXML_SFG.JEFEDISTRITO
     WHERE ID_JEFEDISTRITO = @pk_ID_JEFEDISTRITO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
    
      SELECT J.ID_JEFEDISTRITO,
             J.CODUSUARIO,
             U.NOMUSUARIO,
             J.FECHAHORAMODIFICACION,
             J.CODUSUARIOMODIFICACION,
             J.ACTIVE
        FROM WSXML_SFG.JEFEDISTRITO J
        LEFT OUTER JOIN WSXML_SFG.USUARIO U
          ON (U.ID_USUARIO = J.CODUSUARIO)
       WHERE ID_JEFEDISTRITO = @pk_ID_JEFEDISTRITO;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGJEFEDISTRITO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGJEFEDISTRITO_GetList(@p_active NUMERIC(22,0)
                                                           ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT J.ID_JEFEDISTRITO,
             J.CODUSUARIO,
             U.NOMUSUARIO,
             J.FECHAHORAMODIFICACION,
             J.CODUSUARIOMODIFICACION,
             J.ACTIVE
        FROM WSXML_SFG.JEFEDISTRITO J
        LEFT OUTER JOIN WSXML_SFG.USUARIO U
          ON (U.ID_USUARIO = J.CODUSUARIO)
       WHERE J.ACTIVE = CASE
               WHEN @p_active = -1 THEN
                J.ACTIVE
               ELSE
                @p_active
             END;
			 
  END;
GO






