USE SFGPRODU;
--  DDL for Package Body SFGDETALLETAREA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLETAREA */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREA_AddRecord(@p_CODTAREA               NUMERIC(22,0),
                      @p_NOMDETALLETAREA        NVARCHAR(2000),
                      @p_ENSAMBLADO             VARCHAR(4000),
                      @p_PARAMETRO              NVARCHAR(2000),
                      @p_TIENEPREDECESOR        NUMERIC(22,0),
                      @p_METODO                 NVARCHAR(2000),
                      @p_CLASE                  NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @P_ORDEN                  NUMERIC(22,0),
                      @p_ID_DETALLETAREA_out    NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCODINFOEJECUCION NUMERIC(22,0);
	DECLARE @v_validateemail  NUMERIC(22,0);
	DECLARE @p_EMAIL_INVALIDO varchar(255);
   
	SET NOCOUNT ON;

	/*sfgwebdetalletarea.validateemail(p_parametros => p_PARAMETRO, p_RESULTADO => v_validateemail, p_EMAIL_INVALIDO => p_EMAIL_INVALIDO);

    if v_validateemail = 0 then

      SFGTMPTRACE.TraceLog('Create Task','Email Task  - ' || p_EMAIL_INVALIDO || ' format error');

      RAISE_APPLICATION_ERROR(-20099,
                              'Formato de Correo Invalido. ' ||
                              p_EMAIL_INVALIDO);
    end if;*/
	
    BEGIN
		SELECT @cCODINFOEJECUCION = ID_INFOEJECUCION FROM WSXML_SFG.INFOEJECUCION
		WHERE ENSAMBLADO = @p_ENSAMBLADO AND CLASE = @p_CLASE AND METODO = @p_METODO AND ACTIVE = 1;
		
		IF @@ROWCOUNT = 0 -- EXCEPTION WHEN NO_DATA_FOUND THEN
			EXEC WSXML_SFG.SFGINFOEJECUCION_AddRecord ' ', @p_ENSAMBLADO, @p_CLASE, @p_METODO, @p_CODUSUARIOMODIFICACION, @cCODINFOEJECUCION OUT
    END;

    INSERT INTO WSXML_SFG.DETALLETAREA (
                              CODTAREA,
                              NOMDETALLETAREA,
                              PARAMETRO,
                              TIENEPREDECESOR,
                              CODINFOEJECUCION,
                              CODUSUARIOMODIFICACION,
                              ORDEN)
    VALUES (
            @p_CODTAREA,
            @p_NOMDETALLETAREA,
            @p_PARAMETRO,
            @p_TIENEPREDECESOR,
            @cCODINFOEJECUCION,
            @p_CODUSUARIOMODIFICACION,
            @P_ORDEN);
    SET @p_ID_DETALLETAREA_OUT = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREA_UpdateRecord(@pk_ID_DETALLETAREA       NUMERIC(22,0),
                         @p_CODTAREA               NUMERIC(22,0),
                         @p_NOMDETALLETAREA        NVARCHAR(2000),
                         @p_ENSAMBLADO             VARCHAR(4000),
                         @p_PARAMETRO              NVARCHAR(2000),
                         @p_TIENEPREDECESOR        NUMERIC(22,0),
                         @p_METODO                 NVARCHAR(2000),
                         @p_CLASE                  NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0),
                         @p_ORDEN                  NUMERIC(22,0)) AS
 BEGIN
    DECLARE @cCODINFOEJECUCION NUMERIC(22,0);
    DECLARE @v_validateemail  NUMERIC(22,0);
	DECLARE @p_EMAIL_INVALIDO varchar(255);
   
	SET NOCOUNT ON;

  /*sfgwebdetalletarea.validateemail(p_parametros => p_PARAMETRO, p_RESULTADO => v_validateemail, p_EMAIL_INVALIDO => p_EMAIL_INVALIDO);

    if v_validateemail = 0 then

      SFGTMPTRACE.TraceLog('Create Task','Email Task  - ' || p_EMAIL_INVALIDO || ' format error');

      RAISE_APPLICATION_ERROR(-20099,
                              'Formato de Correo Invalido. ' ||
                              p_EMAIL_INVALIDO);
    end if;*/

	BEGIN
		SELECT @cCODINFOEJECUCION = ID_INFOEJECUCION FROM WSXML_SFG.INFOEJECUCION
		WHERE ENSAMBLADO = @p_ENSAMBLADO AND CLASE = @p_CLASE AND METODO = @p_METODO AND ACTIVE = 1;
  
		IF @@ROWCOUNT = 0 BEGIN
			EXEC SFGINFOEJECUCION_AddRecord ' ', @p_ENSAMBLADO, @p_CLASE, @p_METODO, @p_CODUSUARIOMODIFICACION, @cCODINFOEJECUCION OUT;
		END
		  
	END;

    UPDATE WSXML_SFG.DETALLETAREA
       SET CODTAREA               = @p_CODTAREA,
           NOMDETALLETAREA        = @p_NOMDETALLETAREA,
           PARAMETRO              = @p_PARAMETRO,
           TIENEPREDECESOR        = @p_TIENEPREDECESOR,
           CODINFOEJECUCION       = @cCODINFOEJECUCION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE,
           ORDEN                  = @p_ORDEN
     WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;

    IF @@ROWCOUNT = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@ROWCOUNT > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREA_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREA_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREA_DeactivateRecord(@pk_ID_DETALLETAREA       NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLETAREA
       SET ACTIVE                 = 0,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE()
     WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREA_GetRecord(@pk_ID_DETALLETAREA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.DETALLETAREA WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

		
      SELECT DT.ID_DETALLETAREA,
             DT.CODTAREA,
             DT.NOMDETALLETAREA,
             DT.PARAMETRO,
             DT.TIENEPREDECESOR,
             DT.ORDEN,
             DT.FECHAHORAMODIFICACION,
             DT.CODUSUARIOMODIFICACION,
             DT.ACTIVE,
             DT.ORDEN,
             DT.CODINFOEJECUCION,
             IE.ENSAMBLADO,
             IE.CLASE,
             IE.METODO,
             DT.CODINFOEJECUCIONERROR,
             ER.ENSAMBLADO ENSAMBLADOERROR,
             ER.CLASE CLASEERROR,
             ER.METODO METODOERROR,
             DT.CODINFOEJECUCIONWARNING,
             WR.ENSAMBLADO ENSAMBLADOWARNING,
             WR.CLASE CLASEWARNING,
             WR.METODO METODOWARNING
      FROM WSXML_SFG.DETALLETAREA DT
      INNER JOIN WSXML_SFG.INFOEJECUCION IE ON (DT.CODINFOEJECUCION = IE.ID_INFOEJECUCION)
      LEFT OUTER JOIN WSXML_SFG.INFOEJECUCION ER ON (DT.CODINFOEJECUCIONERROR = ER.ID_INFOEJECUCION)
      LEFT OUTER JOIN WSXML_SFG.INFOEJECUCION WR ON (DT.CODINFOEJECUCIONWARNING = WR.ID_INFOEJECUCION)
      WHERE ID_DETALLETAREA = @pk_ID_DETALLETAREA;
		  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREA_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	  
      SELECT DT.ID_DETALLETAREA,
             DT.CODTAREA,
             DT.NOMDETALLETAREA,
             DT.PARAMETRO,
             DT.TIENEPREDECESOR,
             DT.ORDEN,
             DT.FECHAHORAMODIFICACION,
             DT.CODUSUARIOMODIFICACION,
             DT.ACTIVE,
             DT.ORDEN,
             IE.ENSAMBLADO,
             IE.CLASE,
             IE.METODO
      FROM WSXML_SFG.DETALLETAREA DT
      INNER JOIN WSXML_SFG.INFOEJECUCION IE ON (DT.CODINFOEJECUCION = IE.ID_INFOEJECUCION)
      WHERE DT.ACTIVE = CASE WHEN @p_active = -1 THEN DT.ACTIVE ELSE @p_active END;
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGDETALLETAREA_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLETAREA_GetListByHeader;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLETAREA_GetListByHeader(@p_active   NUMERIC(22,0),
                           @p_CODTAREA NUMERIC(22,0)
                                    ) AS
  BEGIN
  SET NOCOUNT ON;
	  
      SELECT DT.ID_DETALLETAREA,
             DT.CODTAREA,
             DT.NOMDETALLETAREA,
             DT.PARAMETRO,
             DT.TIENEPREDECESOR,
             DT.ORDEN,
             DT.FECHAHORAMODIFICACION,
             DT.CODUSUARIOMODIFICACION,
             DT.ACTIVE,
             DT.ORDEN,
             IE.ENSAMBLADO,
             IE.CLASE,
             IE.METODO
      FROM WSXML_SFG.DETALLETAREA DT
      INNER JOIN WSXML_SFG.INFOEJECUCION IE ON (DT.CODINFOEJECUCION = IE.ID_INFOEJECUCION)
      WHERE DT.CODTAREA = @p_CODTAREA
        AND DT.ACTIVE = CASE WHEN @p_active = -1 THEN DT.ACTIVE ELSE @p_active END
      ORDER BY DT.ORDEN;
	
  END;
GO






