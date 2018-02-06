USE SFGPRODU;
--  DDL for Package Body SFGCALENDARIOGENERAL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCALENDARIOGENERAL */ 

  ----------------------------------------------------------------------------
  -- Ingresa un registro al calendario general
  ----------------------------------------------------------------------------
IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_AddRecord(@p_DESCRIPCION              NVARCHAR(2000),
                      @p_FECHA                    DATETIME,
                      @p_RECURRENCIAANUAL         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                      @p_ID_CALENDARIOGENERAL_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CALENDARIOGENERAL (
                                     DESCRIPCION,
                                     FECHA,
                                     RECURRENCIAANUAL,
                                     CODUSUARIOMODIFICACION)
    VALUES (
            @p_DESCRIPCION,
            @p_FECHA,
            @p_RECURRENCIAANUAL,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_CALENDARIOGENERAL_out = SCOPE_IDENTITY();
  END;
GO

  ----------------------------------------------------------------------------
  -- Actualiza un registro en el calendario general
  ----------------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_UpdateRecord(@pk_ID_CALENDARIOGENERAL    NUMERIC(22,0),
                         @p_DESCRIPCION              NVARCHAR(2000),
                         @p_FECHA                    DATETIME,
                         @p_RECURRENCIAANUAL         NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                         @p_ACTIVE                   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.CALENDARIOGENERAL
       SET DESCRIPCION            = @p_DESCRIPCION,
           FECHA                  = @p_FECHA,
           RECURRENCIAANUAL       = @p_RECURRENCIAANUAL,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_CALENDARIOGENERAL   = @pk_ID_CALENDARIOGENERAL;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  ----------------------------------------------------------------------------
  -- Obtiene una entrada de festivo
  ----------------------------------------------------------------------------
IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetRecord(@pk_ID_CALENDARIOGENERAL NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*) FROM WSXML_SFG.CALENDARIOGENERAL
     WHERE ID_CALENDARIOGENERAL = @pk_ID_CALENDARIOGENERAL;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	  
      SELECT ID_CALENDARIOGENERAL,
             DESCRIPCION,
             FECHA,
             RECURRENCIAANUAL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CALENDARIOGENERAL
       WHERE ID_CALENDARIOGENERAL = @pk_ID_CALENDARIOGENERAL;
	
  END;
GO

  ----------------------------------------------------------------------------
  -- Cuenta el numero de dias habiles para un punto de venta
  ----------------------------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_GetNumeroDiasHabiles', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetNumeroDiasHabiles;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetNumeroDiasHabiles(@p_CODPUNTODEVENTA    NUMERIC(22,0),
                                 @p_FECHAINICIO        DATETIME,
                                 @p_FECHAFIN           DATETIME,
                                 @p_NUMDIASHABILES_out NUMERIC(22,0) OUT) AS
								 
	DECLARE @l_festivos TABLE (FECHA DATE);									
    --DECLARE @TYPE FESTIVOLIST IS TABLE OF DATE INDEX BY BINARY_INTEGER;
    --FESTIVOS FESTIVOLIST;
    DECLARE cCALENDARIOS CURSOR FOR SELECT CODCALENDARIO 
		FROM WSXML_SFG.PUNTODEVENTACALENDARIO 
		WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND ACTIVE = 1;
	
    DECLARE @dFECHAINI DATE;
    DECLARE @dFECHAFIN DATE;
    DECLARE @tFECHA DATE;
    DECLARE @tCALENDAR INT;
    DECLARE @i INT = 0;
    DECLARE @k INT;
BEGIN
	SET @p_NUMDIASHABILES_out = 0;

	-- Desde las 00:00 hasta las 23:59
	SET @dFECHAINI = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINICIO));
	SET @dFECHAFIN = (CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFIN)) + 1) - (1/86400);
	DECLARE @FEXISTS INTEGER
	-- Calendario General
	DECLARE cGENERAL CURSOR LOCAL FOR
	SELECT FECHA FROM WSXML_SFG.CALENDARIOGENERAL
	WHERE (
		FECHA BETWEEN @dFECHAINI AND @dFECHAFIN
		OR (
			RECURRENCIAANUAL = 1
			--AND (FORMAT(FORMAT(FECHA, 'DD') || '-' || FORMAT(FECHA, 'MM') || '-' || FORMAT(dFECHAINI, 'YYYY'), 'DD-MM-YYYY') BETWEEN @dFECHAINI AND @dFECHAFIN OR FORMAT(FORMAT(FECHA, 'DD') || '-' || FORMAT(FECHA, 'MM') || '-' || FORMAT(dFECHAFIN, 'YYYY'), 'DD-MM-YYYY') BETWEEN @dFECHAINI AND @dFECHAFIN)
			AND (
				CONVERT(datetime,FORMAT(@dFECHAINI, 'yyyy') + '-' + FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'dd')) BETWEEN @dFECHAINI AND @dFECHAFIN 
				OR CONVERT(datetime,FORMAT(@dFECHAFIN, 'yyyy') + '-' + FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'dd')) BETWEEN @dFECHAINI AND @dFECHAFIN 
			)
			
		)
	)
	AND ACTIVE = 1;
	
	BEGIN

		OPEN cGENERAL;
	
		FETCH NEXT FROM cGENERAL INTO @tFECHA
		WHILE (@@FETCH_STATUS = 0)
		
		
		BEGIN
			SET @FEXISTS = 0;


			DECLARE k CURSOR FOR SELECT FECHA FROM @l_festivos
			OPEN k
			DECLARE @l_fecha DATE
			
			FETCH NEXT FROM k INTO @l_fecha

				WHILE (@@FETCH_STATUS = 0)
				BEGIN
				
					IF @l_fecha = @tFECHA  BEGIN
						SET @FEXISTS = 1;
						SET @i = @i + 1;
						RETURN; 
					END
					
					FETCH NEXT FROM k INTO @l_fecha
				END		
			CLOSE k
			DEALLOCATE k
			
			IF @FEXISTS = 0 BEGIN
				INSERT INTO @l_festivos VALUES(@tFECHA);
			END 
		
		FETCH NEXT FROM cGENERAL INTO @l_fecha
		END

		CLOSE cGENERAL;
		DEALLOCATE cGENERAL;
	END;


	-- Calendarios Personalizados
	OPEN cCALENDARIOS;
	
	FETCH NEXT FROM cGENERAL INTO @tFECHA
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			DECLARE cPERSONAL CURSOR LOCAL FOR
				SELECT FECHA FROM WSXML_SFG.DETALLECALENDARIO
				WHERE (FECHA BETWEEN @dFECHAINI AND @dFECHAFIN
					OR (
						RECURRENCIAANUAL = 1
						AND (
							CONVERT(datetime,FORMAT(@dFECHAINI, 'yyyy') + '-' + FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'dd')) BETWEEN @dFECHAINI AND @dFECHAFIN 
							OR CONVERT(datetime,FORMAT(@dFECHAFIN, 'yyyy') + '-' + FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'dd')) BETWEEN @dFECHAINI AND @dFECHAFIN 
						)
					)
				)
				AND ACTIVE = 1
				AND CODCALENDARIO = @tCALENDAR;

			OPEN cPERSONAL;
			
			
			FETCH NEXT FROM cPERSONAL INTO @tFECHA
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @FEXISTS = 0;
			
				FETCH NEXT FROM k INTO @l_fecha

				WHILE (@@FETCH_STATUS = 0)
				BEGIN
				
					IF @l_fecha = @tFECHA  BEGIN
						SET @FEXISTS = 1;
						SET @i = @i + 1;
						RETURN; 
					END
					
					FETCH NEXT FROM k INTO @l_fecha
				END		
				CLOSE k
				DEALLOCATE k
			
				IF @FEXISTS = 0 BEGIN
					INSERT INTO @l_festivos VALUES(@tFECHA);
				END
				
				
			
			FETCH NEXT FROM cPERSONAL INTO @tFECHA
			END
			
	
		FETCH NEXT FROM cGENERAL INTO @tFECHA
		END
		
	CLOSE cCALENDARIOS;
	DEALLOCATE cCALENDARIOS;
		
    -- Contar los dias y restar el numero de festivos distintos
	DECLARE @julian_day_fin INT =  datepart(year, @dFECHAFIN) * 1000 + datepart(dy, @dFECHAFIN);
	DECLARE @julian_day_ini INT =  datepart(year, @dFECHAINI) * 1000 + datepart(dy, @dFECHAINI);
    --SELECT @p_NUMDIASHABILES_out = ABS(TO_NUMBER(TO_CHAR(dFECHAFIN, 'J')) - TO_NUMBER(TO_CHAR(dFECHAINI, 'J'))) - i;
	SET @p_NUMDIASHABILES_out = ABS(@julian_day_fin - @julian_day_ini) - @i;

  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_SumarDiasHabiles', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_SumarDiasHabiles;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_SumarDiasHabiles(@p_CODPUNTODEVENTA NUMERIC(22,0), @p_FECHAINICIO DATETIME, @p_NUMDIASHABILES NUMERIC(22,0), @p_FECHAFIN_out DATETIME OUT) AS
 BEGIN
    DECLARE @i NUMERIC(22,0) = 1;
    DECLARE @dias NUMERIC(22,0);
    DECLARE @tmpdate DATETIME;
    DECLARE @lstCALENDARIOS LONGNUMBERARRAY;
   
  SET NOCOUNT ON;
    SET @dias = ABS(@p_NUMDIASHABILES);
    SET @tmpdate = @p_FECHAINICIO;
    WHILE @i <= @dias BEGIN
        DECLARE @dFECHAINI DATETIME;
        DECLARE @tmpFOUND NUMERIC(22,0) = 0;
      BEGIN
		BEGIN TRY
			SET @dFECHAINI = CONVERT(DATETIME, CONVERT(DATE,@tmpdate));

			-- Calendario general
			SELECT @tmpFOUND = COUNT(1) FROM WSXML_SFG.CALENDARIOGENERAL
			 WHERE (
					CONVERT(DATETIME, CONVERT(DATE,FECHA)) = @dFECHAINI
					OR (RECURRENCIAANUAL = 1 AND CONVERT(DATETIME, FORMAT(@dFECHAINI, 'YYYY') +'-'+ FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'DD')) = @dFECHAINI)
				)
			   AND ACTIVE = 1;


			IF @tmpFOUND = 0 BEGIN
			  -- Calendarios personalizados
				INSERT @lstCALENDARIOS
				SELECT CODCALENDARIO FROM WSXML_SFG.PUNTODEVENTACALENDARIO 
				WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND ACTIVE = 1;


					
				IF @@ROWCOUNT > 0 BEGIN
					DECLARE ix CURSOR FOR SELECT IDVALUE FROM @lstCALENDARIOS
					
					OPEN ix;
					DECLARE @xCODCALENDARIO INT;
				
				
					FETCH NEXT FROM ix INTO @xCODCALENDARIO
					WHILE (@@FETCH_STATUS = 0)
					BEGIN
					
						SELECT @tmpFOUND = COUNT(1) 
						FROM WSXML_SFG.DETALLECALENDARIO
						WHERE CODCALENDARIO = @xCODCALENDARIO
							AND ACTIVE = 1
							AND (
								CONVERT(DATETIME, CONVERT(DATE,FECHA)) = @dFECHAINI
								OR (RECURRENCIAANUAL = 1 AND CONVERT(DATETIME, FORMAT(@dFECHAINI, 'YYYY') +'-'+ FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'DD')) = @dFECHAINI)
							);
						
						IF @tmpFOUND > 0 BEGIN
						  RETURN;
						END 
					
					FETCH NEXT FROM ix INTO @xCODCALENDARIO
					END
					
					CLOSE ix
					DEALLOCATE ix
					

				END


			END 
			-- Si encuentra un festivo agregar 1
			IF @tmpFOUND > 0 BEGIN
			  SET @dias = @dias + 1;
			END
		END TRY
		BEGIN CATCH		
			RETURN ; --No hacer nada, no encontro fecha
		END CATCH
    END
      SET @tmpdate = @tmpdate + 1;
      SET @i = @i + 1;
 END;

    SET @p_FECHAFIN_out = @tmpdate;
END;
GO

  ----------------------------------------------------------------------------
  -- Obtiene la lista de festivos estipulados en el calendario general
  ----------------------------------------------------------------------------
IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	 
      SELECT ID_CALENDARIOGENERAL,
             DESCRIPCION,
             FECHA,
             RECURRENCIAANUAL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CALENDARIOGENERAL
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	
  END;
GO

  ----------------------------------------------------------------------------
  -- Obtiene la lista de festivos en un rango de fechas
  ----------------------------------------------------------------------------
IF OBJECT_ID('WSXML_SFG.SFGCALENDARIOGENERAL_GetListRango', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetListRango;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCALENDARIOGENERAL_GetListRango(@p_active NUMERIC(22,0), @p_FECHAINICIO DATETIME, @p_FECHAFIN DATETIME) AS
 BEGIN
    DECLARE @dFECHAINI DATETIME;
    DECLARE @dFECHAFIN DATETIME;
   
  SET NOCOUNT ON;

    -- Desde las 00:00 hasta las 23:59
    SELECT @dFECHAINI = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINICIO));
    SELECT @dFECHAFIN = (CONVERT(DATETIME, CONVERT(DATE,@p_FECHAFIN)) + 1) - (1/86400);
	 
      SELECT ID_CALENDARIOGENERAL,
             DESCRIPCION,
             FECHA,
             RECURRENCIAANUAL,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.CALENDARIOGENERAL
       WHERE (FECHA BETWEEN @dFECHAINI AND @dFECHAFIN
          OR (
				RECURRENCIAANUAL = 1
				AND (				
					CONVERT(datetime,FORMAT(@dFECHAINI, 'yyyy') + '-' + FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'dd')) BETWEEN @dFECHAINI AND @dFECHAFIN 
					OR CONVERT(datetime,FORMAT(@dFECHAFIN, 'yyyy') + '-' + FORMAT(FECHA, 'MM') + '-' + FORMAT(FECHA, 'dd')) BETWEEN @dFECHAINI AND @dFECHAFIN 
				)
			)
		)
        AND ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	

  END;
GO






