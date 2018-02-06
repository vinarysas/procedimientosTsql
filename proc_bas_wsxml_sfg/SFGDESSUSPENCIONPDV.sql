USE SFGPRODU;
--  DDL for Package Body SFGDESSUSPENCIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDESSUSPENCIONPDV */ 

   --------------------------------------------------------------------
  -- Ingresar un registro en la tabla SUSPENSIONPDV ------------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_AddRecord(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_codsuspensionpdv       NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_fechadessuspension datetime,
                      @p_ID_DESSUSPENSIONPDV_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DESSUSPENSIONPDV (
                               CODPUNTODEVENTA,
                               codsuspensionpdv,
                               CODUSUARIOMODIFICACION,
                               fechadessuspension
                               )
    VALUES (
            @p_CODPUNTODEVENTA,
            @p_codsuspensionpdv,
            @p_CODUSUARIOMODIFICACION,
            @p_fechadessuspension);
    SET @p_ID_DESSUSPENSIONPDV_out = SCOPE_IDENTITY();
  END;
GO

  --------------------------------------------------------------------
  -- Actualizar un registro de la tabla SUSPENSIONPDV ----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_UpdateRecord(@pk_ID_DESSUSPENSIONPDV      NUMERIC(22,0),
                         @p_CODPUNTODEVENTA        NUMERIC(22,0),
                         @p_codsuspensionpdv       NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0),
                         @p_fechadessuspension datetime) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DESSUSPENSIONPDV
       SET CODPUNTODEVENTA        = @p_CODPUNTODEVENTA,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           codsuspensionpdv = @p_codsuspensionpdv,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE,
           fechadessuspension = @p_fechadessuspension
     WHERE ID_DESSUSPENSIONPDV = @pk_ID_DESSUSPENSIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  --------------------------------------------------------------------
  -- Desactivar un registro de la tabla SUSPENSIONPDV ----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_DeactivateRecord(@pk_ID_DESSUSPENSIONPDV      NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DESSUSPENSIONPDV
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_DESSUSPENSIONPDV       = @pk_ID_DESSUSPENSIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_OmitSuspension', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_OmitSuspension;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_OmitSuspension(@pk_ID_SUSPENSIONPDV      NUMERIC(22,0),
                           @p_DESCRIPCION            NVARCHAR(2000),
                           @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.SUSPENSIONPDVOMISION (
                                      CODSUSPENSIONPDV,
                                      DESCRIPCION,
                                      CODUSUARIOMODIFICACION)
    VALUES (
            @pk_ID_SUSPENSIONPDV,
            @p_DESCRIPCION,
            @p_CODUSUARIOMODIFICACION);
  END;
GO

  --------------------------------------------------------------------
  -- Obtener un registro de la tabla SUSPENSIONPDV -------------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_GetRecord(@pk_ID_DESSUSPENSIONPDV NUMERIC(22,0)
                                                                ) AS
 BEGIN
    DECLARE @l_count INTEGER;
	
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.DESSUSPENSIONPDV
     WHERE ID_DESSUSPENSIONPDV = @pk_ID_DESSUSPENSIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT DSS.FECHADESSUSPENSION,
             S.ID_SUSPENSIONPDV,
             S.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             O.DESCRIPCION,
             D.NUMDIASMORAGTECH,
             D.NUMDIASMORAFIDUCIA,
             D.SALDOCONTRAGTECH,
             D.SALDOCONTRAFIDUCIA,

             S.FECHAHORAMODIFICACION,
             S.CODUSUARIOMODIFICACION,
             S.ACTIVE
       FROM
      WSXML_SFG.DESSUSPENSIONPDV DSS
      INNER JOIN  WSXML_SFG.SUSPENSIONPDV S ON DSS.CODSUSPENSIONPDV=S.ID_SUSPENSIONPDV
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (S.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.SUSPENSIONPDVOMISION O
        ON (O.CODSUSPENSIONPDV = S.ID_SUSPENSIONPDV)
      LEFT OUTER JOIN WSXML_SFG.DETALLESALDOSUSPENSIONPDV DS
        ON (DS.CODSUSPENSIONPDV = S.ID_SUSPENSIONPDV)
      LEFT OUTER JOIN WSXML_SFG.DETALLESALDOPDV D
        ON (DS.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV)
      WHERE ID_SUSPENSIONPDV = @pk_ID_DESSUSPENSIONPDV;
	  
  END;
GO

  --------------------------------------------------------------------
  -- Obtener lista de registros --------------------------------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_GetList(@p_active NUMERIC(22,0)
                                                               ) AS
  BEGIN
  SET NOCOUNT ON;
   
      SELECT DSS.FECHADESSUSPENSION,
             S.ID_SUSPENSIONPDV,
             S.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             O.DESCRIPCION,
             D.NUMDIASMORAGTECH,
             D.NUMDIASMORAFIDUCIA,
             D.SALDOCONTRAGTECH,
             D.SALDOCONTRAFIDUCIA,
             S.FECHAHORAMODIFICACION,
             S.CODUSUARIOMODIFICACION,
             S.ACTIVE
      FROM
      WSXML_SFG.DESSUSPENSIONPDV DSS
      INNER JOIN  WSXML_SFG.SUSPENSIONPDV S ON DSS.CODSUSPENSIONPDV=S.ID_SUSPENSIONPDV
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (S.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.SUSPENSIONPDVOMISION O
        ON (O.CODSUSPENSIONPDV = S.ID_SUSPENSIONPDV)
      LEFT OUTER JOIN WSXML_SFG.DETALLESALDOSUSPENSIONPDV DS
        ON (DS.CODSUSPENSIONPDV = S.ID_SUSPENSIONPDV)
      LEFT OUTER JOIN WSXML_SFG.DETALLESALDOPDV D
        ON (DS.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV)
      WHERE S.ACTIVE = CASE WHEN @p_active = -1 THEN S.ACTIVE ELSE @p_active END;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDESSUSPENCIONPDV_GetListToDessuspend', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_GetListToDessuspend;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDESSUSPENCIONPDV_GetListToDessuspend AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT DSS.FECHADESSUSPENSION,
             S.ID_SUSPENSIONPDV,
             S.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             P.CODIGOGTECHPUNTODEVENTA,
             D.NUMDIASMORAGTECH,
             D.NUMDIASMORAFIDUCIA,
             D.SALDOCONTRAGTECH,
             D.SALDOCONTRAFIDUCIA,
             S.FECHAHORAMODIFICACION,
             S.CODUSUARIOMODIFICACION,
             S.ACTIVE
      FROM
      WSXML_SFG.DESSUSPENSIONPDV DSS
      INNER JOIN  SUSPENSIONPDV S ON DSS.CODSUSPENSIONPDV=S.ID_SUSPENSIONPDV
      LEFT OUTER JOIN PUNTODEVENTA P
        ON (S.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN DETALLESALDOSUSPENSIONPDV DS
        ON (DS.CODSUSPENSIONPDV = S.ID_SUSPENSIONPDV)
      LEFT OUTER JOIN DETALLESALDOPDV D
        ON (DS.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV)
      WHERE S.ACTIVE = 1
        AND S.ID_SUSPENSIONPDV NOT IN (SELECT CODSUSPENSIONPDV FROM WSXML_SFG.SUSPENSIONPDVOMISION);
		
  END;
GO








