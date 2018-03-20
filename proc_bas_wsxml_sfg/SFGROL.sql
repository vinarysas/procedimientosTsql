USE SFGPRODU;
--  DDL for Package Body SFGROL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGROL */ 

  IF OBJECT_ID('WSXML_SFG.SFGROL_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGROL_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGROL_AddRecord(@p_NOMROL                 NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_ROL_out             NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ROL ( NOMROL, CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMROL,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ROL_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGROL_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGROL_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGROL_UpdateRecord(@pk_ID_ROL                NUMERIC(22,0),
                         @p_NOMROL                 NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ROL
       SET NOMROL                 = @p_NOMROL,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ROL = @pk_ID_ROL;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;

    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGROL_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGROL_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGROL_GetRecord(@pk_ID_ROL NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ROL WHERE ID_ROL = @pk_ID_ROL;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_ROL,
             NOMROL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ROL
       WHERE ID_ROL = @pk_ID_ROL;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGROL_GetRecordByNomRol', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGROL_GetRecordByNomRol;
GO
CREATE     PROCEDURE WSXML_SFG.SFGROL_GetRecordByNomRol(@P_NOMROL NVARCHAR(2000)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ROL WHERE upper(NOMROL) = upper(@P_NOMROL);
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_ROL,
             NOMROL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ROL
    WHERE  upper(NOMROL) =  upper(@P_NOMROL);
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGROL_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGROL_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGROL_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_ROL,
             NOMROL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.ROL
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;

  END;
GO






