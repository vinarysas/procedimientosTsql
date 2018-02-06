USE SFGPRODU;
--  DDL for Package Body SFGREACTIVACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREACTIVACIONPDV */ 
--------------------------------------------------------------------
  -- Ingresar un registro en la tabla INACTIVACIONPDV ----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGREACTIVACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_AddRecord(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_CODINACTIVACIONPDV     NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_FECHAREACTIVACION      DATETIME,
                      @p_ID_REACTIVACIONPDV_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REACTIVACIONPDV (
                                 CODPUNTODEVENTA,
                                 CODLINEADENEGOCIO,
                                 CODUSUARIOMODIFICACION,
                                 FECHAREACTIVACION)
    VALUES (
            @p_CODPUNTODEVENTA,
            @p_CODLINEADENEGOCIO,
            @p_CODUSUARIOMODIFICACION,
            @p_FECHAREACTIVACION);

    SET @p_ID_REACTIVACIONPDV_out = SCOPE_IDENTITY();
  END;
GO

  --------------------------------------------------------------------
  -- Actualizar un registro de la tabla INACTIVACIONPDV --------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGREACTIVACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_UpdateRecord(@pk_ID_REACTIVACIONPDV    NUMERIC(22,0),
                         @p_CODPUNTODEVENTA        NUMERIC(22,0),
                         @p_CODINACTIVACIONPDV     NUMERIC(22,0),
                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_FECHAREACTIVACION      DATETIME,
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.REACTIVACIONPDV
       SET CODPUNTODEVENTA        = @p_CODPUNTODEVENTA,
           CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE,
           FECHAREACTIVACION      = @p_FECHAREACTIVACION

     WHERE ID_REACTIVACIONPDV     = @pk_ID_REACTIVACIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  --------------------------------------------------------------------
  -- Desactivar un registro de la tabla INACTIVACIONPDV --------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGREACTIVACIONPDV_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_DeactivateRecord(@pk_ID_REACTIVACIONPDV    NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.REACTIVACIONPDV
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_REACTIVACIONPDV     = @pk_ID_REACTIVACIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO


  --------------------------------------------------------------------
  -- Obtener un registro de la tabla INACTIVACIONPDV -----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGREACTIVACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_GetRecord(@pk_ID_REACTIVACIONPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.REACTIVACIONPDV
     WHERE ID_REACTIVACIONPDV = @pk_ID_REACTIVACIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT R.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             R.CODLINEADENEGOCIO,
             L.NOMLINEADENEGOCIO,
             C.VALORCUPO,
             R.FECHAHORAMODIFICACION,
             R.CODUSUARIOMODIFICACION,
             R.ACTIVE
      FROM WSXML_SFG.REACTIVACIONPDV R
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (R.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO L
        ON (R.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
      WHERE ID_REACTIVACIONPDV = @pk_ID_REACTIVACIONPDV;
  END;
GO

  --------------------------------------------------------------------
  -- Obtener lista de registros --------------------------------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGREACTIVACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT R.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             R.CODLINEADENEGOCIO,
             L.NOMLINEADENEGOCIO,
             C.VALORCUPO,
             R.FECHAHORAMODIFICACION,
             R.CODUSUARIOMODIFICACION,
             R.ACTIVE
      FROM WSXML_SFG.REACTIVACIONPDV R
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (R.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO L
        ON (R.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
      WHERE R.ACTIVE = CASE WHEN @p_active = -1 THEN R.ACTIVE ELSE @p_active END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREACTIVACIONPDV_GetListToReactivate', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_GetListToReactivate;
GO
CREATE     PROCEDURE WSXML_SFG.SFGREACTIVACIONPDV_GetListToReactivate AS
  BEGIN
  SET NOCOUNT ON;
      SELECT R.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             R.CODLINEADENEGOCIO,
             L.NOMLINEADENEGOCIO,
             C.VALORCUPO,
             R.FECHAHORAMODIFICACION,
             R.CODUSUARIOMODIFICACION,
             R.ACTIVE
      FROM WSXML_SFG.REACTIVACIONPDV R
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (R.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO L
        ON (R.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
        AND R.ID_REACTIVACIONPDV NOT IN (SELECT CODINACTIVACIONPDV FROM WSXML_SFG.INACTIVACIONPDVOMISION);
  END;
GO







