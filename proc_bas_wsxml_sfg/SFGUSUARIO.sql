USE SFGPRODU;
--  DDL for Package Body SFGUSUARIO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGUSUARIO */ 

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_AddRecord', 'P') IS NOT NULL
	DROP PROCEDURE WSXML_SFG.SFGUSUARIO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_AddRecord(@p_NOMUSUARIO             NVARCHAR(2000),
                      @p_NOMBRE                 NVARCHAR(2000),
                      @p_EMAIL                  NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_USUARIO_out         NUMERIC(22,0) OUT) AS
BEGIN
  SET NOCOUNT ON;
    -- Make sure only one username is at all times in the database
    DECLARE @cCODUSUARIO NUMERIC(22,0);

    SELECT @cCODUSUARIO = ID_USUARIO FROM WSXML_SFG.USUARIO WHERE LOWER(RTRIM(LTRIM(NOMUSUARIO))) = LOWER(RTRIM(LTRIM(@p_NOMUSUARIO))) AND ACTIVE = 1;
    
	IF @@ROWCOUNT = 0 BEGIN
		INSERT INTO WSXML_SFG.USUARIO (NOMUSUARIO,NOMBRE,EMAIL,CODUSUARIOMODIFICACION)
		VALUES (LOWER(RTRIM(LTRIM(@p_NOMUSUARIO))),@p_NOMBRE,@p_EMAIL,@p_CODUSUARIOMODIFICACION);
		SET @p_ID_USUARIO_out = SCOPE_IDENTITY();
	END	ELSE BEGIN
		IF @cCODUSUARIO > 0 BEGIN
			SELECT @p_ID_USUARIO_out = @cCODUSUARIO;
		END
	END
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_UpdateRecord(@pk_ID_USUARIO            NUMERIC(22,0),
                         @p_NOMUSUARIO             NVARCHAR(2000),
                         @p_NOMBRE                 NVARCHAR(2000),
                         @p_EMAIL                  NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.USUARIO
       SET NOMUSUARIO             = @p_NOMUSUARIO,
           NOMBRE                 = @p_NOMBRE,
           EMAIL                  = @p_EMAIL,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_USUARIO = @pk_ID_USUARIO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_DeactivateRecord(@pk_ID_USUARIO NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.USUARIO
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_USUARIO = @pk_ID_USUARIO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @ROWCOUNT = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @ROWCOUNT > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_GetRecord(@PK_ID_USUARIO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @L_COUNT INTEGER;
   
  SET NOCOUNT ON;
    SELECT @L_COUNT = COUNT(*) FROM WSXML_SFG.USUARIO WHERE ID_USUARIO = @PK_ID_USUARIO;
    IF @L_COUNT = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @L_COUNT > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 
	
	  
      SELECT ID_USUARIO,
             NOMUSUARIO,
             NOMBRE,
             EMAIL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.USUARIO
       WHERE ID_USUARIO = @PK_ID_USUARIO AND ACTIVE = 1;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_GetUser', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_GetUser;
GO
CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_GetUser(@p_NOMUSUARIO NVARCHAR(2000)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.USUARIO WHERE LOWER(RTRIM(LTRIM(NOMUSUARIO))) = LOWER(RTRIM(LTRIM(@p_NOMUSUARIO)));
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	 
      SELECT ID_USUARIO,
             NOMUSUARIO,
             NOMBRE,
             EMAIL,
             CELULAR,
             SFG_PACKAGE.DateToString(FECHAHORAMODIFICACION) AS FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.USUARIO
       WHERE LOWER(RTRIM(LTRIM(NOMUSUARIO))) = LOWER(RTRIM(LTRIM(@p_NOMUSUARIO)));
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_GetUserFromID', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_GetUserFromID;
GO
CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_GetUserFromID(@pk_ID_USUARIO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.USUARIO WHERE ID_USUARIO = @pk_ID_USUARIO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	 
      SELECT ID_USUARIO,
             NOMUSUARIO,
             NOMBRE,
             EMAIL,
             CELULAR,
             SFG_PACKAGE.DateToString(FECHAHORAMODIFICACION) AS FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.USUARIO
       WHERE ID_USUARIO = @pk_ID_USUARIO;
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_GetCodigoByNomUsuario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_GetCodigoByNomUsuario;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_GetCodigoByNomUsuario(@p_NOMUSUARIO NVARCHAR(2000), @p_CODUSUARIO NUMERIC(22,0) OUT) AS
BEGIN
  SET NOCOUNT ON;
    SELECT @p_CODUSUARIO = ID_USUARIO FROM WSXML_SFG.USUARIO
     WHERE LOWER(RTRIM(LTRIM(NOMUSUARIO))) = LOWER(RTRIM(LTRIM(@p_NOMUSUARIO)));
	
	IF @@ROWCOUNT = 0
      SET @p_CODUSUARIO = 0;
END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_USUARIO,
             NOMUSUARIO,
             NOMBRE,
             EMAIL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.USUARIO
       WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END
         AND ID_USUARIO NOT IN (SELECT CODUSUARIO FROM WSXML_SFG.USUARIOSISTEMA);
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_CreateUsuarioDominio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_CreateUsuarioDominio;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_CreateUsuarioDominio(@p_NOMUSUARIO     NVARCHAR(2000),
                                 @p_NOMBRE         NVARCHAR(2000),
                                 @p_EMAIL          NVARCHAR(2000),
                                 @p_CELULAR        NVARCHAR(2000),
                                 @p_ID_USUARIO_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCOUNT NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    SELECT @cCOUNT = COUNT(1) FROM WSXML_SFG.USUARIO WHERE LOWER(RTRIM(LTRIM(NOMUSUARIO))) = LOWER(RTRIM(LTRIM(@p_NOMUSUARIO)));
    IF @cCOUNT > 0 BEGIN
      RAISERROR('-20003 El usuario esopecificado ya existe en el sistema', 16, 1);
    END
    ELSE BEGIN
      INSERT INTO WSXML_SFG.USUARIO (
                           NOMUSUARIO,
                           NOMBRE,
                           EMAIL,
                           CELULAR,
                           CODUSUARIOMODIFICACION)
      VALUES (
              LOWER(RTRIM(LTRIM(@p_NOMUSUARIO))),
              @p_NOMBRE,
              @p_EMAIL,
              @p_CELULAR,
              1);
      SET @p_ID_USUARIO_out = SCOPE_IDENTITY();
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_CreateUsuarioSistema', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_CreateUsuarioSistema;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_CreateUsuarioSistema(@p_NOMUSUARIO     NVARCHAR(2000),
                                 @p_CONTRASENA     VARCHAR(4000),
                                 @p_NOMBRE         NVARCHAR(2000),
                                 @p_EMAIL          NVARCHAR(2000),
                                 @p_CELULAR        NVARCHAR(2000),
                                 @p_ID_USUARIO_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCOUNT NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
    SELECT @cCOUNT = COUNT(1) FROM WSXML_SFG.USUARIO WHERE LOWER(RTRIM(LTRIM(NOMUSUARIO))) = LOWER(RTRIM(LTRIM(@p_NOMUSUARIO)));
    IF @cCOUNT > 0 BEGIN
      RAISERROR('-20003 El usuario esopecificado ya existe en el sistema', 16, 1);
    END
    ELSE BEGIN
      INSERT INTO WSXML_SFG.USUARIO (
                           NOMUSUARIO,
                           NOMBRE,
                           EMAIL,
                           CELULAR,
                           CODUSUARIOMODIFICACION)
      VALUES (
              LOWER(RTRIM(LTRIM(@p_NOMUSUARIO))),
              @p_NOMBRE,
              @p_EMAIL,
              @p_CELULAR,
              1);
      SET @p_ID_USUARIO_out = SCOPE_IDENTITY();
      --INSERT INTO WSXML_SFG.USUARIOSISTEMA (CODUSUARIO,CONTRASENA)
      --VALUES (@p_ID_USUARIO_out,HEXTORAW(@p_CONTRASENA));
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_GetUsuariosSistemaValidacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_GetUsuariosSistemaValidacion;
GO
CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_GetUsuariosSistemaValidacion AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_USUARIO,
             NOMUSUARIO,
             --RAWTOHEX(CONTRASENA) AS CONTRASENA,
             -- Informacion de expiracion
             CASE WHEN EXPIRA = 1
                  THEN CASE WHEN DATEADD(dd,300,FECHACONTRASENA) <= GETDATE()
                            THEN 1
                            ELSE 0
                       END
                  ELSE 0
             END AS EXPIRADO,
             BLOQUEO
      FROM WSXML_SFG.USUARIO
      INNER JOIN WSXML_SFG.USUARIOSISTEMA ON (CODUSUARIO = ID_USUARIO);
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_UpdateUsuarioSistemaPassword', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_UpdateUsuarioSistemaPassword;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_UpdateUsuarioSistemaPassword(
	@p_NOMUSUARIO  NVARCHAR(2000),
    @p_NEWPASSWORD VARCHAR(4000)
) AS
 BEGIN
    DECLARE @cCODUSUARIOSISTEMA NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cCODUSUARIOSISTEMA = ID_USUARIOSISTEMA FROM WSXML_SFG.USUARIO
    INNER JOIN USUARIOSISTEMA ON (CODUSUARIO = ID_USUARIO)
    WHERE NOMUSUARIO = @p_NOMUSUARIO;

	IF @@ROWCOUNT = 0 BEGIN
		RAISERROR('-20002 El usuario especificado no pertenece a la lista de usuarios del sistema', 16, 1);
		RETURN 0;
	END
    /* Update password to byte array */
    UPDATE WSXML_SFG.USUARIOSISTEMA SET /*CONTRASENA = HEXTORAW(@p_NEWPASSWORD),*/ FECHACONTRASENA = GETDATE() 
	WHERE ID_USUARIOSISTEMA = @cCODUSUARIOSISTEMA;
    
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGUSUARIO_BlockUsuarioSistema', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGUSUARIO_BlockUsuarioSistema;
GO

CREATE     PROCEDURE WSXML_SFG.SFGUSUARIO_BlockUsuarioSistema(@pk_ID_USUARIO NUMERIC(22,0)) AS
 BEGIN
	SET NOCOUNT ON;
	DECLARE @cCODUSUARIOSISTEMA NUMERIC(22,0);
   
	SELECT @cCODUSUARIOSISTEMA = ID_USUARIOSISTEMA 
	FROM WSXML_SFG.USUARIOSISTEMA 
	WHERE CODUSUARIO = @pk_ID_USUARIO;

	IF @@ROWCOUNT = 0 BEGIN
		RAISERROR('-20002 El usuario especificado no pertenece a la lista de usuarios del sistema', 16, 1);
		RETURN 0;
	END
    UPDATE WSXML_SFG.USUARIOSISTEMA SET BLOQUEO = 1 
	WHERE ID_USUARIOSISTEMA = @cCODUSUARIOSISTEMA;
END;
GO






