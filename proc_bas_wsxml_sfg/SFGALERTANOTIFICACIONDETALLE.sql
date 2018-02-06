USE SFGPRODU;
--  DDL for Package Body SFGALERTANOTIFICACIONDETALLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGALERTANOTIFICACIONDETALLE */ 

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_AddRecord(@p_CODALERTANOTIFICACION        NUMERIC(22,0),
                      @p_CODALERTA                    NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_ALERTANOTIFICACIONDET_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ALERTANOTIFICACIONDETALLE (
                                           CODALERTANOTIFICACION,
                                           CODALERTA,
                                           CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODALERTANOTIFICACION,
            @p_CODALERTA,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ALERTANOTIFICACIONDET_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_UpdateRecord(@pk_ID_ALERTANOTIFICACIONDETALL NUMERIC(22,0),
                         @p_CODALERTANOTIFICACION        NUMERIC(22,0),
                         @p_CODALERTA                    NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                         @p_ACTIVE                       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ALERTANOTIFICACIONDETALLE
       SET CODALERTANOTIFICACION  = @p_CODALERTANOTIFICACION,
           CODALERTA              = @p_CODALERTA,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ALERTANOTIFICACIONDETALLE = @pk_ID_ALERTANOTIFICACIONDETALL;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetRecord(@pk_ID_ALERTANOTIFICACIONDETALL NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ALERTANOTIFICACIONDETALLE WHERE ID_ALERTANOTIFICACIONDETALLE = @pk_ID_ALERTANOTIFICACIONDETALL;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
		 
      SELECT AD.ID_ALERTANOTIFICACIONDETALLE,
             AD.CODALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AD.CODALERTA,
             AD.CODUSUARIOMODIFICACION,
             AD.FECHAHORAMODIFICACION,
             AD.ACTIVE
      FROM WSXML_SFG.ALERTANOTIFICACIONDETALLE AD
      LEFT OUTER JOIN WSXML_SFG.ALERTANOTIFICACION AN ON (AD.CODALERTANOTIFICACION = AN.ID_ALERTANOTIFICACION)
      LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
      LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
      LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
      LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
      WHERE ID_ALERTANOTIFICACIONDETALLE = @pk_ID_ALERTANOTIFICACIONDETALL;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT AD.ID_ALERTANOTIFICACIONDETALLE,
             AD.CODALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AD.CODALERTA,
             AD.CODUSUARIOMODIFICACION,
             AD.FECHAHORAMODIFICACION,
             AD.ACTIVE
      FROM WSXML_SFG.ALERTANOTIFICACIONDETALLE AD
      LEFT OUTER JOIN WSXML_SFG.ALERTANOTIFICACION AN ON (AD.CODALERTANOTIFICACION = AN.ID_ALERTANOTIFICACION)
      LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
      LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
      LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
      LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
      WHERE AD.ACTIVE = CASE WHEN @p_active = -1 THEN AD.ACTIVE ELSE @p_active END;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetListByAlerta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetListByAlerta;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACIONDETALLE_GetListByAlerta(@p_ACTIVE NUMERIC(22,0), @p_CODALERTA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT AD.ID_ALERTANOTIFICACIONDETALLE,
             AD.CODALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AD.CODALERTA,
             AD.CODUSUARIOMODIFICACION,
             AD.FECHAHORAMODIFICACION,
             AD.ACTIVE
      FROM WSXML_SFG.ALERTANOTIFICACIONDETALLE AD
      LEFT OUTER JOIN WSXML_SFG.ALERTANOTIFICACION AN ON (AD.CODALERTANOTIFICACION = AN.ID_ALERTANOTIFICACION)
      LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
      LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
      LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
      LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
      WHERE AD.CODALERTA = CASE WHEN @p_CODALERTA = -1 THEN AD.CODALERTA ELSE @p_CODALERTA END
        AND AD.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN AD.ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO






