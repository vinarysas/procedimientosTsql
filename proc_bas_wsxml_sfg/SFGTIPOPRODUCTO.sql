USE SFGPRODU;
--  DDL for Package Body SFGTIPOPRODUCTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOPRODUCTO */ 

  IF OBJECT_ID('WSXML_SFG.SFGTIPOPRODUCTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_AddRecord(@p_NOMTIPOPRODUCTO        VARCHAR(4000),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TIPOPRODUCTO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPOPRODUCTO (
                              NOMTIPOPRODUCTO,
                              CODLINEADENEGOCIO,
                              CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMTIPOPRODUCTO,
            @p_CODLINEADENEGOCIO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPOPRODUCTO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOPRODUCTO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_UpdateRecord(@pk_ID_TIPOPRODUCTO       NUMERIC(22,0),
                         @p_NOMTIPOPRODUCTO        VARCHAR(4000),
                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.TIPOPRODUCTO
       SET NOMTIPOPRODUCTO        = @p_NOMTIPOPRODUCTO,
           CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TIPOPRODUCTO = @pk_ID_TIPOPRODUCTO;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOPRODUCTO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_GetRecord(@pk_ID_TIPOPRODUCTO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = count(*)
      FROM WSXML_SFG.TIPOPRODUCTO
     WHERE ID_TIPOPRODUCTO = @pk_ID_TIPOPRODUCTO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_TIPOPRODUCTO,
             NOMTIPOPRODUCTO,
             CODLINEADENEGOCIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOPRODUCTO
       WHERE ID_TIPOPRODUCTO = @pk_ID_TIPOPRODUCTO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOPRODUCTO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT ID_TIPOPRODUCTO,
             NOMTIPOPRODUCTO,
             CODLINEADENEGOCIO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOPRODUCTO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOPRODUCTO_GetListByCodLineaDeNegocio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_GetListByCodLineaDeNegocio;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOPRODUCTO_GetListByCodLineaDeNegocio(@p_active NUMERIC(22,0), @p_codLineaDeNegocio NUMERIC(22,0))AS
  BEGIN
  SET NOCOUNT ON;
      SELECT T.ID_TIPOPRODUCTO,
             T.NOMTIPOPRODUCTO,
             T.CODLINEADENEGOCIO,
             T.FECHAHORAMODIFICACION,
             T.CODUSUARIOMODIFICACION,
             T.ACTIVE,
             L.NOMLINEADENEGOCIO
        FROM WSXML_SFG.TIPOPRODUCTO T
       LEFT OUTER JOIN LINEADENEGOCIO L ON (CODLINEADENEGOCIO = ID_LINEADENEGOCIO)
       WHERE T.ACTIVE = CASE WHEN @p_active = -1 THEN T.ACTIVE ELSE @p_active END
       AND CODLINEADENEGOCIO = CASE WHEN @p_codLineaDeNegocio = -1  THEN CODLINEADENEGOCIO ELSE  @p_codLineaDeNegocio END
       ORDER BY NOMTIPOPRODUCTO;
  END;
GO







