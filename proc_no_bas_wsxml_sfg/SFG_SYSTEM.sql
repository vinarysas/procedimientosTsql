USE SFGPRODU;
--  DDL for Package Body SFG_SYSTEM
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFG_SYSTEM */ 

  /* Todos los procedimientos de mantenimiento del sistema deben dejar la base de datos en un estado estable
    Ninguno debe tener reproceso, asi la ejecucion termine inesperadamente */

  /* Elimina todas las ejecuciones de tarea de un numero de dias atras */
  IF OBJECT_ID('WSXML_SFG.SFG_SYSTEM_PurgeTaskExecutionList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFG_SYSTEM_PurgeTaskExecutionList;
GO

CREATE     PROCEDURE WSXML_SFG.SFG_SYSTEM_PurgeTaskExecutionList AS
 BEGIN
    DECLARE @xcountregistros NUMERIC(22,0) = 0;
    DECLARE @xwaitnregistros NUMERIC(22,0) = 20;
    DECLARE @xdaycount       NUMERIC(22,0) = 100;
   
  SET NOCOUNT ON;
    -- Delete one month old tmptrace
    DELETE FROM TMPTRACE WHERE FECHAHORAMODIFICACION < GETDATE() - 30;
    COMMIT;
    -- Delete old task executions
	DECLARE @lsttaskexecutionlist LONGNUMBERARRAY;
    BEGIN
      
	  INSERT @lsttaskexecutionlist 
	  SELECT ID_TAREAEJECUTADA
	  FROM TAREAEJECUTADA WHERE FECHAEJECUCION < GETDATE() - @xdaycount;
	  
	  DECLARE ix CURSOR FOR SELECT IDVALUE FROM @lsttaskexecutionlist
	  OPEN ix
	  
	  DECLARE @id INT;
	  
	  IF @@ROWCOUNT > 0  BEGIN
	  
		FETCH NEXT FROM ix INTO @id
        
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		
			DELETE FROM ESTADOTAREAEJECUTADA  WHERE CODTAREAEJECUTADA = @id;
			DELETE FROM DETALLETAREAEJECUTADA WHERE CODTAREAEJECUTADA = @id;
			DELETE FROM TAREAEJECUTADA        WHERE ID_TAREAEJECUTADA = @id;
			SET @xcountregistros = @xcountregistros + 1;
			IF (@xcountregistros % @xwaitnregistros) = 0 BEGIN
				COMMIT;
			END 
		
			FETCH NEXT FROM ix INTO @id
		END
		
		 CLOSE ix;
        DEALLOCATE ix;
	  
	  END
	  
    END;
    COMMIT;
    -- Other execution

END 

