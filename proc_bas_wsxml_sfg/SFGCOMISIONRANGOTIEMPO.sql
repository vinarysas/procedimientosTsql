USE SFGPRODU;
--  DDL for Package Body SFGCOMISIONRANGOTIEMPO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCOMISIONRANGOTIEMPO */ 

   --Add Record in the table COMISIONRANGOTIEMPO table.
 IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_AddRecord;
GO

CREATE   PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_AddRecord(@p_CODRANGOCOMISION    NUMERIC(22,0),
                    @p_EVALUARVENTASPORAGRUPACION        NUMERIC(22,0),
                    @p_CODPERIODICIDAD        NUMERIC(22,0),
                    @p_FECHAINICIO        DATETIME,
                    @p_FECHACALENDARIO        NUMERIC(22,0),
                    @p_CODTIPOEVALUACIONVENTAS        NUMERIC(22,0),
                    @p_FRECUENCIA        NUMERIC(22,0),
                    @p_CODUSUARIOMODIFICACION        NUMERIC(22,0),
                    @p_FECHAMODIFICACION        DATETIME,
                    @p_ACTIVE        NUMERIC(22,0),
                    @p_DESCOMISIONPOSTESTANDAR        NUMERIC(22,0),
                    @p_APLICARCADAGRUPO            NUMERIC(22,0),
                    @p_ID_COMISIONRANGOTIEMPO_out NUMERIC(22,0) OUT
                    ) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.COMISIONRANGOTIEMPO (
                                        CODRANGOCOMISION,
                                        EVALUARVENTASPORAGRUPACION,
                                        CODPERIODICIDAD,
                                        FECHAINICIO,
                                        FECHACALENDARIO,
                                        CODTIPOEVALUACIONVENTAS,
                                        FRECUENCIA,
                                        CODUSUARIOMODIFICACION,
                                        FECHAMODIFICACION,
                                        ACTIVE,
                                        DESCOMISPOSTESTANDAR,
                                        APLICARCADAGRUPO
                                        )
    VALUES (
            @p_CODRANGOCOMISION,
            @p_EVALUARVENTASPORAGRUPACION,
            @p_CODPERIODICIDAD,
            @p_FECHAINICIO,
            @p_FECHACALENDARIO,
            @p_CODTIPOEVALUACIONVENTAS,
            @p_FRECUENCIA,
            @p_CODUSUARIOMODIFICACION,
            @p_FECHAMODIFICACION,
            @p_ACTIVE,
            @p_DESCOMISIONPOSTESTANDAR,
            @p_APLICARCADAGRUPO
            );
    SET @p_ID_COMISIONRANGOTIEMPO_out = SCOPE_IDENTITY();
  END;
GO
  --Update Record in the table COMISIONRANGOTIEMPO table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_UpdateRecord(@pk_ID_COMISIONRANGOTIEMPO    NUMERIC(22,0),
                    @p_CODRANGOCOMISION    NUMERIC(22,0),
                    @p_EVALUARVENTASPORAGRUPACION        NUMERIC(22,0),
                    @p_CODPERIODICIDAD        NUMERIC(22,0),
                    @p_FECHAINICIO        DATETIME,
                    @p_FECHACALENDARIO        NUMERIC(22,0),
                    @p_CODTIPOEVALUACIONVENTAS        NUMERIC(22,0),
                    @p_FRECUENCIA        NUMERIC(22,0),
                    @p_CODUSUARIOMODIFICACION        NUMERIC(22,0),
                    @p_FECHAMODIFICACION        DATETIME,
                    @p_ACTIVE        NUMERIC(22,0),
                    @p_DESCOMISIONPOSTESTANDAR        NUMERIC(22,0),
                    @p_APLICARCADAGRUPO            NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      -- Update the record with the passed parameters
   UPDATE WSXML_SFG.COMISIONRANGOTIEMPO
   SET CODRANGOCOMISION = @p_CODRANGOCOMISION
      ,EVALUARVENTASPORAGRUPACION = @p_EVALUARVENTASPORAGRUPACION
      ,CODPERIODICIDAD = @p_CODPERIODICIDAD
      ,FECHAINICIO = @p_FECHAINICIO
      ,FECHACALENDARIO = @p_FECHACALENDARIO
      ,CODTIPOEVALUACIONVENTAS = @p_CODTIPOEVALUACIONVENTAS
      ,FRECUENCIA = @p_FRECUENCIA
      ,CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION
      ,FECHAMODIFICACION = @p_FECHAMODIFICACION
      ,ACTIVE = @p_ACTIVE
      ,DESCOMISPOSTESTANDAR  = @p_DESCOMISIONPOSTESTANDAR
      ,APLICARCADAGRUPO = @p_APLICARCADAGRUPO
   WHERE ID_COMISIONRANGOTIEMPO = @pk_ID_COMISIONRANGOTIEMPO;

   DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    -- Make sure only one record is affected
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  --Get List of Records Active or Inactive in the table COMISIONRANGOTIEMPO table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetList(@p_active NUMERIC(22,0)) AS
    BEGIN
    SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	 
    SELECT
       ID_COMISIONRANGOTIEMPO
      ,CODRANGOCOMISION
      ,EVALUARVENTASPORAGRUPACION
      ,CODPERIODICIDAD
      ,FECHAINICIO
      ,FECHAINICIO
      ,FECHAINICIO
      ,FECHAINICIO
      ,FECHACALENDARIO
      ,CODTIPOEVALUACIONVENTAS
      ,FRECUENCIA
      ,CODUSUARIOMODIFICACION
      ,FECHAMODIFICACION
      ,FECHAMODIFICACION
      ,FECHAMODIFICACION
      ,FECHAMODIFICACION
      ,ACTIVE
      ,DESCOMISPOSTESTANDAR
      ,APLICARCADAGRUPO
    FROM WSXML_SFG.COMISIONRANGOTIEMPO
    WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	
	
    END;
GO

    --Get Records in the table COMISIONRANGOTIEMPO table by the PRIMARY KEY.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetRecord(@pk_ID_COMISIONRANGOTIEMPO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
     
    SET NOCOUNT ON;
       -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
      FROM WSXML_SFG.COMISIONRANGOTIEMPO
     WHERE ID_COMISIONRANGOTIEMPO = @pk_ID_COMISIONRANGOTIEMPO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
       
		SELECT
		   ID_COMISIONRANGOTIEMPO
		  ,CODRANGOCOMISION
		  ,EVALUARVENTASPORAGRUPACION
		  ,CODPERIODICIDAD
		  ,FECHAINICIO
		  ,FECHAINICIO
		  ,FECHAINICIO
		  ,FECHAINICIO
		  ,FECHACALENDARIO
		  ,CODTIPOEVALUACIONVENTAS
		  ,FRECUENCIA
		  ,CODUSUARIOMODIFICACION
		  ,FECHAMODIFICACION
		  ,FECHAMODIFICACION
		  ,FECHAMODIFICACION
		  ,FECHAMODIFICACION
		  ,ACTIVE
		  ,DESCOMISPOSTESTANDAR
		  ,APLICARCADAGRUPO
		FROM WSXML_SFG.COMISIONRANGOTIEMPO
		WHERE ID_COMISIONRANGOTIEMPO = @pk_ID_COMISIONRANGOTIEMPO; 
	 
  END;
GO

   --Delete Record in the COMISIONRANGOTIEMPODETALLE table.
  IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPO_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_DeleteRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_DeleteRecord(@pk_ID_COMISIONRANGOTIEMPO             NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
  UPDATE WSXML_SFG.COMISIONRANGOTIEMPO SET ACTIVE=0
  WHERE ID_COMISIONRANGOTIEMPO = @pk_ID_COMISIONRANGOTIEMPO;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetByCodRangoComision', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetByCodRangoComision;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCOMISIONRANGOTIEMPO_GetByCodRangoComision(@p_CODRANGOCOMISION NUMERIC(22,0)
                ) AS
  BEGIN
  SET NOCOUNT ON;
   
	  SELECT COMISIONRANGOTIEMPO.ID_COMISIONRANGOTIEMPO,
		COMISIONRANGOTIEMPO.CODRANGOCOMISION,
		COMISIONRANGOTIEMPO.EVALUARVENTASPORAGRUPACION,
		COMISIONRANGOTIEMPO.CODPERIODICIDAD,
		COMISIONRANGOTIEMPO.FECHAINICIO,
		COMISIONRANGOTIEMPO.FECHACALENDARIO,
		COMISIONRANGOTIEMPO.CODTIPOEVALUACIONVENTAS,
		COMISIONRANGOTIEMPO.FRECUENCIA,
		COMISIONRANGOTIEMPO.ACTIVE,
		COMISIONRANGOTIEMPODETALLE.ID_COMISIONRANGOTIEMPODETALLE,
		COMISIONRANGOTIEMPO.DESCOMISPOSTESTANDAR,
		COMISIONRANGOTIEMPODETALLE.RANGOINICIAL,
		COMISIONRANGOTIEMPODETALLE.RANGOFINAL,
		COMISIONRANGOTIEMPODETALLE.TARIFAPORCENTUAL,
		COMISIONRANGOTIEMPODETALLE.TARIFATRANSACIONAL,
		COMISIONRANGOTIEMPODETALLE.FIJO,
		COMISIONRANGOTIEMPODETALLE.ACTIVE AS ACTIVE1,
		APLICARCADAGRUPO AS APLICARCADAGRUPO
	  FROM WSXML_SFG.COMISIONRANGOTIEMPO
	  INNER JOIN COMISIONRANGOTIEMPODETALLE
	  ON COMISIONRANGOTIEMPO.ID_COMISIONRANGOTIEMPO = COMISIONRANGOTIEMPODETALLE.CODCOMISIONRANGOTIEMPO
	  WHERE COMISIONRANGOTIEMPO.CODRANGOCOMISION=@p_CODRANGOCOMISION;
	
END;
GO







