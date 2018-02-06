USE SFGPRODU;
--  DDL for Package Body SFGCARTERATASKMANAGER
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCARTERATASKMANAGER */ 

  -- Todas las fechas se manejaran en el formato DD/MM/YYYY (HH:MI)
  IF OBJECT_ID('WSXML_SFG.SFGCARTERATASKMANAGER_CrearSingleTarea', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCARTERATASKMANAGER_CrearSingleTarea;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCARTERATASKMANAGER_CrearSingleTarea(@p_NOMTAREA           NVARCHAR(2000),
                            @p_CODINFOEJECUCION   NUMERIC(22,0),
                            @p_PARAMETRO          NVARCHAR(2000),
							@cCODEJECUCIONSUB NUMERIC(22,0)  = 0) AS
 BEGIN
    DECLARE @cCODPERIODICIDAD   NUMERIC(22,0) = 22; -- UNA VEZ
    DECLARE @cCODTAREA          NUMERIC(22,0);
    DECLARE @cCODDETALLETAREA   NUMERIC(22,0);
    DECLARE @cCODTAREAEJECUTADA NUMERIC(22,0);
    --DECLARE @cCODEJECUCIONSUB   NUMERIC(22,0) = 0;
    DECLARE @cCODESTADOEJECCION NUMERIC(22,0);
   
    -- Registro principal
    INSERT INTO WSXML_SFG.TAREA (
                       NOMTAREA,
                       FECHAEJECUCIONTAREA,
                       CODPERIODICIDAD,
                       CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMTAREA,
            GETDATE(),
            @cCODPERIODICIDAD,
            1);
    SET @cCODTAREA = SCOPE_IDENTITY();
    INSERT INTO WSXML_SFG.DETALLETAREA (
                              CODTAREA,
                              NOMDETALLETAREA,
                              CODINFOEJECUCION,
                              PARAMETRO,
                              CODUSUARIOMODIFICACION,
                              TIENEPREDECESOR,
                              ORDEN)
    VALUES (
            @cCODTAREA,
            @p_NOMTAREA,
            @p_CODINFOEJECUCION,
            @p_PARAMETRO,
            1,
            0,
            1);
    SET @cCODDETALLETAREA = SCOPE_IDENTITY();
    INSERT INTO WSXML_SFG.TAREAEJECUTADA (
                                CODTAREA,
                                ESTADO,
                                FECHAEJECUCION,
                                CODUSUARIOMODIFICACION)
    VALUES (
            @cCODTAREA,
            'REGISTRADA',
            GETDATE(),
            1);
    SET @cCODTAREAEJECUTADA = SCOPE_IDENTITY();
	DECLARE @FECHAHOY DATETIME =  GETDATE()
    EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_AddRecord @cCODDETALLETAREA,
                                       NULL,
                                      @FECHAHOY,
                                       1,
                                       @cCODTAREAEJECUTADA,
                                       @p_PARAMETRO,
                                       1,
                                       @cCODEJECUCIONSUB OUT
    EXEC WSXML_SFG.SFGESTADODETALLETAREAEJECUTADA_AddRecord @cCODEJECUCIONSUB,
                                             1,
                                             1,
                                             @cCODESTADOEJECCION OUT
    --RETURN @cCODEJECUCIONSUB;

END 
GO


