USE SFGPRODU;
--  DDL for Package Body SFGTIPORANGO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPORANGO */ 

  IF OBJECT_ID('WSXML_SFG.SFGTIPORANGO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPORANGO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPORANGO_AddRecord(@p_NOMTIPORANGO           NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TIPORANGO_out       NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPORANGO (
                           NOMTIPORANGO,
                           CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMTIPORANGO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPORANGO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPORANGO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPORANGO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPORANGO_UpdateRecord(@pk_ID_TIPORANGO          NUMERIC(22,0),
                         @p_NOMTIPORANGO           NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.TIPORANGO
       SET NOMTIPORANGO           = @p_NOMTIPORANGO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TIPORANGO = @pk_ID_TIPORANGO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPORANGO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPORANGO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPORANGO_GetRecord(@pk_ID_TIPORANGO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*)
      FROM WSXML_SFG.TIPOCOMISION
     WHERE ID_TIPOCOMISION = @pk_ID_TIPORANGO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_TIPORANGO,
             NOMTIPORANGO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPORANGO
       WHERE ID_TIPORANGO = @pk_ID_TIPORANGO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPORANGO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPORANGO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPORANGO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_TIPORANGO,
             NOMTIPORANGO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPORANGO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPORANGO_GetCorrespondingID', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGTIPORANGO_GetCorrespondingID;
GO

CREATE     FUNCTION WSXML_SFG.SFGTIPORANGO_GetCorrespondingID(@p_CODTIPOCOMISION NUMERIC(22,0)) RETURNS NUMERIC(22,0) AS
  BEGIN
    IF @p_CODTIPOCOMISION IN (1, 4) BEGIN
      RETURN 2;
    END
    ELSE IF @p_CODTIPOCOMISION IN (2, 5) BEGIN
      RETURN 1;
    END
    ELSE BEGIN
      RETURN 3;
    END 
    RETURN NULL;
  END;
GO






