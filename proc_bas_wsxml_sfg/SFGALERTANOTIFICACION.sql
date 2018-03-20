USE SFGPRODU;
--  DDL for Package Body SFGALERTANOTIFICACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGALERTANOTIFICACION */ 

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_AddRecord(@p_CODPROCESO                NUMERIC(22,0),
                      @p_CODTIPOALERTA             NUMERIC(22,0),
                      @p_CODTIPONOTIFICACION       NUMERIC(22,0),
                      @p_DESTINO                   NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                      @p_ID_ALERTANOTIFICACION_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ALERTANOTIFICACION (
                                    CODPROCESO,
                                    CODTIPOALERTA,
                                    CODTIPONOTIFICACION,
                                    DESTINO,
                                    CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODPROCESO,
            @p_CODTIPOALERTA,
            @p_CODTIPONOTIFICACION,
            @p_DESTINO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ALERTANOTIFICACION_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_UpdateRecord(@pk_ID_ALERTANOTIFICACION NUMERIC(22,0),
                         @p_CODPROCESO             NUMERIC(22,0),
                         @p_CODTIPOALERTA          NUMERIC(22,0),
                         @p_CODTIPONOTIFICACION    NUMERIC(22,0),
                         @p_DESTINO                NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ALERTANOTIFICACION
       SET CODPROCESO             = @p_CODPROCESO,
           CODTIPOALERTA          = @p_CODTIPOALERTA,
           CODTIPONOTIFICACION    = @p_CODTIPONOTIFICACION,
           DESTINO                = @p_DESTINO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ALERTANOTIFICACION = @pk_ID_ALERTANOTIFICACION;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetRecord(@pk_ID_ALERTANOTIFICACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ALERTANOTIFICACION WHERE ID_ALERTANOTIFICACION = @pk_ID_ALERTANOTIFICACION;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
		 
		SELECT AN.ID_ALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AN.CODUSUARIOMODIFICACION,
             AN.FECHAHORAMODIFICACION,
             AN.ACTIVE
		FROM WSXML_SFG.ALERTANOTIFICACION AN
			LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
			LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
			LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
			LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
		WHERE ID_ALERTANOTIFICACION = @pk_ID_ALERTANOTIFICACION;
		
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
		 
		SELECT AN.ID_ALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AN.CODUSUARIOMODIFICACION,
             AN.FECHAHORAMODIFICACION,
             AN.ACTIVE
		FROM WSXML_SFG.ALERTANOTIFICACION AN
			LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
			LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
			LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
			LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
		WHERE AN.ACTIVE = CASE WHEN @p_active = -1 THEN AN.ACTIVE ELSE @p_active END;
	  

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACION_GetListByProceso', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetListByProceso;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetListByProceso(@p_ACTIVE NUMERIC(22,0), @p_CODPROCESO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
		 
      SELECT AN.ID_ALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AN.CODUSUARIOMODIFICACION,
             AN.FECHAHORAMODIFICACION,
             AN.ACTIVE
      FROM WSXML_SFG.ALERTANOTIFICACION AN
      LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
      LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
      LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
      LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
      WHERE AN.CODPROCESO = CASE WHEN @p_CODPROCESO = -1 THEN AN.CODPROCESO ELSE @p_CODPROCESO END
        AND AN.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN AN.ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALERTANOTIFICACION_GetListByProcesoTipoAlerta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetListByProcesoTipoAlerta;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALERTANOTIFICACION_GetListByProcesoTipoAlerta(@p_ACTIVE NUMERIC(22,0), @p_CODPROCESO NUMERIC(22,0), @p_CODTIPOALERTA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT AN.ID_ALERTANOTIFICACION,
             AN.CODPROCESO,
             P.NOMPROCESO,
             U.NOMBRE,
             AN.CODTIPOALERTA,
             TA.NOMTIPOALERTA,
             AN.CODTIPONOTIFICACION,
             TN.NOMTIPONOTIFICACION,
             AN.DESTINO,
             AN.CODUSUARIOMODIFICACION,
             AN.FECHAHORAMODIFICACION,
             AN.ACTIVE
      FROM WSXML_SFG.ALERTANOTIFICACION AN
      LEFT OUTER JOIN WSXML_SFG.PROCESO P ON (AN.CODPROCESO = P.ID_PROCESO)
      LEFT OUTER JOIN WSXML_SFG.USUARIO U ON (P.CODUSUARIORESPONSABLE = U.ID_USUARIO)
      LEFT OUTER JOIN WSXML_SFG.TIPOALERTA TA ON (AN.CODTIPOALERTA = TA.NOMTIPOALERTA)
      LEFT OUTER JOIN WSXML_SFG.TIPONOTIFICACION TN ON (AN.CODTIPONOTIFICACION = TN.ID_TIPONOTIFICACION)
      WHERE AN.CODPROCESO = CASE WHEN @p_CODPROCESO = -1 THEN AN.CODPROCESO ELSE @p_CODPROCESO END
        AND AN.CODTIPOALERTA = CASE WHEN @p_CODTIPOALERTA = -1 THEN AN.CODTIPOALERTA ELSE @p_CODTIPOALERTA END
        AND AN.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN AN.ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO






