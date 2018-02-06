USE SFGPRODU;
--  DDL for Package Body SFGREDPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREDPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGREDPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREDPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREDPDV_AddRecord(@p_NOMREDPDV              NVARCHAR(2000),
                      @p_CODCANALNEGOCIO        NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_REDPDV_out          NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REDPDV (
                          NOMREDPDV,
                          CODCANALNEGOCIO,
                          CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMREDPDV,
            @p_CODCANALNEGOCIO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_REDPDV_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREDPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREDPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREDPDV_UpdateRecord(@pk_ID_REDPDV             NUMERIC(22,0),
                         @p_NOMREDPDV              NVARCHAR(2000),
                         @p_CODCANALNEGOCIO        NUMERIC(22,0),                         
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.REDPDV
       SET NOMREDPDV              = @p_NOMREDPDV,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE,
           CODCANALNEGOCIO        = @p_CODCANALNEGOCIO
     WHERE ID_REDPDV              = @pk_ID_REDPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREDPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREDPDV_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREDPDV_GetRecord(@pk_ID_REDPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.REDPDV
     WHERE ID_REDPDV = @pk_ID_REDPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_REDPDV,
             NOMREDPDV,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.REDPDV
      WHERE ID_REDPDV = @pk_ID_REDPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREDPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREDPDV_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREDPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_REDPDV,
             NOMREDPDV,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.REDPDV
      WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGREDPDV_Busqueda', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREDPDV_Busqueda;
GO
CREATE PROCEDURE WSXML_SFG.SFGREDPDV_Busqueda(@p_dato VARCHAR)
AS
  BEGIN
  SET NOCOUNT ON;
    select id_redpdv,
    nomredpdv
    from WSXML_SFG.redpdv
    where id_redpdv like '%'+ isnull(@p_dato, '')+'%'
    or nomredpdv like '%'+ isnull(@p_dato, '')+'%';
END;
GO






