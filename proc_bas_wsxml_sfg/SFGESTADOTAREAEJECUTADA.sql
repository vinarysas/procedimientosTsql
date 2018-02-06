USE SFGPRODU;
--  DDL for Package Body SFGESTADOTAREAEJECUTADA
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT(
					@p_REGISTRADA      			TINYINT OUT,
                    @p_INICIADA         		TINYINT OUT,
                    @p_FINALIZADAOK 			TINYINT OUT,
                    @p_FINALIZADAFALLO  		TINYINT OUT,
					@p_ABORTADA  				TINYINT OUT,
					@p_NOINICIADA  				TINYINT OUT,
					@p_FINALIZADAADVERTENCIA  	TINYINT OUT
					
) AS
  BEGIN
  SET NOCOUNT ON;
    SET @p_REGISTRADA = 1;
	SET @p_INICIADA = 2;
	SET @p_FINALIZADAOK = 3;
	SET @p_FINALIZADAFALLO = 4;
	SET @p_ABORTADA = 5;
	SET @p_NOINICIADA = 6;
	SET @p_FINALIZADAADVERTENCIA = 7;

  END;
GO



  
  /* PACKAGE BODY WSXML_SFG.SFGESTADOTAREAEJECUTADA */ 

IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_AddRecord(@p_CODTAREAEJECUTADA      NUMERIC(22,0),
                      @p_CODESTADOTAREA         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_ESTADOTAREAEJE_OUT  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ESTADOTAREAEJECUTADA (
                                      CODTAREAEJECUTADA,
                                      CODESTADOTAREA,
                                      CODUSUARIOMODIFICACION,
                                      FECHAHORAESTADO)
    VALUES (
            @p_CODTAREAEJECUTADA,
            @p_CODESTADOTAREA,
            @p_CODUSUARIOMODIFICACION,
            GETDATE());
    SET @P_ID_ESTADOTAREAEJE_OUT = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_UpdateRecord(@pk_ID_ESTADOTAREAEJECUT  NUMERIC(22,0),
                         @p_CODTAREAEJECUTADA      NUMERIC(22,0),
                         @p_CODESTADOTAREA         NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ESTADOTAREAEJECUTADA
       SET CODTAREAEJECUTADA      = @p_CODTAREAEJECUTADA,
           CODESTADOTAREA         = @p_CODESTADOTAREA,
           FECHAHORAMODIFICACION  = GETDATE(),
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_ESTADOTAREAEJECUTADA = @pk_ID_ESTADOTAREAEJECUT;

    IF @@ROWCOUNT = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @@ROWCOUNT > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_SetEstado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_SetEstado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_SetEstado(@p_CODTAREAEJECUTADA      NUMERIC(22,0),
                      @p_CODESTADOTAREA         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
 BEGIN
	SET NOCOUNT ON;
    DECLARE @cOUTESTADO NUMERIC(22,0);
    DECLARE @cCURESTADO NUMERIC(22,0);
   
   BEGIN TRY
  
    --LOCK TABLE WSXML_SFG.ESTADOTAREAEJECUTADA IN EXCLUSIVE MODE WAIT 2;
    IF @p_CODESTADOTAREA = 5 BEGIN
      SELECT @cCURESTADO = CODESTADOTAREA FROM WSXML_SFG.ESTADOTAREAEJECUTADA WHERE CODTAREAEJECUTADA = @p_CODTAREAEJECUTADA AND ACTIVE = 1;
      IF @cCURESTADO NOT IN (3, 4, 7) BEGIN
        UPDATE WSXML_SFG.ESTADOTAREAEJECUTADA
           SET FECHAHORAMODIFICACION = GETDATE(),
               CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
               ACTIVE = 0
         WHERE CODTAREAEJECUTADA = @p_CODTAREAEJECUTADA;
        EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_AddRecord  @p_CODTAREAEJECUTADA, @p_CODESTADOTAREA, @p_CODUSUARIOMODIFICACION, @cOUTESTADO OUT
        --UPDATE TAREAEJECUTADA SET CODESTADOTAREAACTIVO = p_CODESTADOTAREA WHERE ID_TAREAEJECUTADA = p_CODTAREAEJECUTADA;
      END 
    END
    ELSE BEGIN
      UPDATE WSXML_SFG.ESTADOTAREAEJECUTADA
         SET FECHAHORAMODIFICACION = GETDATE(),
             CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
             ACTIVE = 0
       WHERE CODTAREAEJECUTADA = @p_CODTAREAEJECUTADA;
      exec WSXML_SFG.SFGESTADOTAREAEJECUTADA_AddRecord @p_CODTAREAEJECUTADA, @p_CODESTADOTAREA, @p_CODUSUARIOMODIFICACION, @cOUTESTADO OUT
      --UPDATE TAREAEJECUTADA SET CODESTADOTAREAACTIVO = p_CODESTADOTAREA WHERE ID_TAREAEJECUTADA = p_CODTAREAEJECUTADA;
    END 
    /*MERGE INTO ESTADOTAREAEJECUTADA D
    USING (SELECT p_CODTAREAEJECUTADA AS CODTAREAEJECUTADA,
                  p_CODESTADOTAREA AS CODESTADOTAREA FROM DUAL) S
    ON (D.CODTAREAEJECUTADA = S.CODTAREAEJECUTADA AND D.CODESTADOTAREA = S.CODESTADOTAREA)
      WHEN NOT MATCHED THEN INSERT (ID_ESTADOTAREAEJECUTADA,
                                    CODTAREAEJECUTADA,
                                    CODESTADOTAREA,
                                    CODUSUARIOMODIFICACION,
                                    FECHAHORAESTADO)
                            VALUES (WSXML_SFG.ESTADOTAREAEJECUTA_SEQ.NEXTVAL,
                                    p_CODTAREAEJECUTADA,
                                    p_CODESTADOTAREA,
                                    p_CODUSUARIOMODIFICACION,
                                    SYSDATE);*/
 END TRY
 BEGIN CATCH
  
    SELECT NULL;
	END CATCH
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetRecord(@pk_ID_ESTADOTAREAEJECUT NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ESTADOTAREAEJECUTADA WHERE ID_ESTADOTAREAEJECUTADA = @pk_ID_ESTADOTAREAEJECUT;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 THE RECORD NO LONGER EXISTS.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 DUPLICATE OBJECT INSTANCES.', 16, 1);
    END 

      SELECT DTE.ID_ESTADOTAREAEJECUTADA,
             DTE.CODTAREAEJECUTADA,
             DTE.CODESTADOTAREA,
             DTE.ACTIVE,
             DTE.FECHAHORAMODIFICACION,
             DTE.CODUSUARIOMODIFICACION,
             DTE.FECHAHORAESTADO
        FROM WSXML_SFG.ESTADOTAREAEJECUTADA DTE
       WHERE DTE.ID_ESTADOTAREAEJECUTADA = @pk_ID_ESTADOTAREAEJECUT;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_ESTADOTAREAEJECUTADA,
             CODTAREAEJECUTADA,
             CODESTADOTAREA,
             ACTIVE,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             FECHAHORAESTADO
        FROM WSXML_SFG.ESTADOTAREAEJECUTADA
       WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetListNotFinalize', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetListNotFinalize;
GO
CREATE     PROCEDURE WSXML_SFG.SFGESTADOTAREAEJECUTADA_GetListNotFinalize AS
    /*  Lista de estados no finalizados*/
  BEGIN
  SET NOCOUNT ON;

      SELECT T.ID_ESTADOTAREAEJECUTADA
        FROM WSXML_SFG.ESTADOTAREAEJECUTADA T
       WHERE (T.CODESTADOTAREA = 1 OR T.CODESTADOTAREA = 2)
         AND ACTIVE = 1;

  END;
GO




