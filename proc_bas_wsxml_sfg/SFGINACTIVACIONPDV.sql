USE SFGPRODU;
--  DDL for Package Body SFGINACTIVACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINACTIVACIONPDV */ 

  --------------------------------------------------------------------
  -- Ingresar un registro en la tabla INACTIVACIONPDV ----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_AddRecord(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_INACTIVACIONPDV_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.INACTIVACIONPDV (
                                 CODPUNTODEVENTA,
                                 CODLINEADENEGOCIO,
                                 CODDETALLESALDOPDV,
                                 CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODPUNTODEVENTA,
            @p_CODLINEADENEGOCIO,
            @p_CODDETALLESALDOPDV,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_INACTIVACIONPDV_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_AddRecord(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_FECHAINACTIVACION DATETIME,
                      @p_ID_INACTIVACIONPDV_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.INACTIVACIONPDV (
                                 CODPUNTODEVENTA,
                                 CODLINEADENEGOCIO,
                                 CODDETALLESALDOPDV,
                                 CODUSUARIOMODIFICACION,
                                 FECHAINACTIVACION)
    VALUES (
            @p_CODPUNTODEVENTA,
            @p_CODLINEADENEGOCIO,
            @p_CODDETALLESALDOPDV,
            @p_CODUSUARIOMODIFICACION,
            @p_FECHAINACTIVACION);
    SET @p_ID_INACTIVACIONPDV_out = SCOPE_IDENTITY();
  END;
GO

  --------------------------------------------------------------------
  -- Ingresar un registro en la tabla ACTIVACIONPDV ----------------
  --------------------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_AddRecordActivacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_AddRecordActivacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_AddRecordActivacion(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_FECHAREACTIVACION DATETIME,
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
  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_UpdateRecord(@pk_ID_INACTIVACIONPDV    NUMERIC(22,0),
                         @p_CODPUNTODEVENTA        NUMERIC(22,0),
                         @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                         @p_CODDETALLESALDOPDV     NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.INACTIVACIONPDV
       SET CODPUNTODEVENTA        = @p_CODPUNTODEVENTA,
           CODLINEADENEGOCIO      = @p_CODLINEADENEGOCIO,
           CODDETALLESALDOPDV     = @p_CODDETALLESALDOPDV,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_INACTIVACIONPDV     = @pk_ID_INACTIVACIONPDV;

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
  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_DeactivateRecord(@pk_ID_INACTIVACIONPDV    NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.INACTIVACIONPDV
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_INACTIVACIONPDV     = @pk_ID_INACTIVACIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_OmitInactivation', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_OmitInactivation;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_OmitInactivation(@pk_ID_INACTIVACIONPDV    NUMERIC(22,0),
                             @p_DESCRIPCION            NVARCHAR(2000),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.INACTIVACIONPDVOMISION (
                                        CODINACTIVACIONPDV,
                                        DESCRIPCION,
                                        CODUSUARIOMODIFICACION)
    VALUES (
            @pk_ID_INACTIVACIONPDV,
            @p_DESCRIPCION,
            @p_CODUSUARIOMODIFICACION);
  END;
GO

  --------------------------------------------------------------------
  -- Obtener un registro de la tabla INACTIVACIONPDV -----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GetRecord(@pk_ID_INACTIVACIONPDV NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.INACTIVACIONPDV
     WHERE ID_INACTIVACIONPDV = @pk_ID_INACTIVACIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT I.ID_INACTIVACIONPDV,
             I.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             I.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             I.CODLINEADENEGOCIO,
             L.NOMLINEADENEGOCIO,
             I.CODDETALLESALDOPDV,
             D.SALDOCONTRAGTECH,
             D.SALDOCONTRAFIDUCIA,
             O.DESCRIPCION,
             I.FECHAHORAMODIFICACION,
             I.CODUSUARIOMODIFICACION,
             I.ACTIVE
      FROM WSXML_SFG.INACTIVACIONPDV I
      LEFT OUTER JOIN PUNTODEVENTA P
        ON (I.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN LINEADENEGOCIO L
        ON (I.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN DETALLESALDOPDV D
        ON (I.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV)
      LEFT OUTER JOIN INACTIVACIONPDVOMISION O
        ON (O.CODINACTIVACIONPDV = I.ID_INACTIVACIONPDV)
      WHERE ID_INACTIVACIONPDV = @pk_ID_INACTIVACIONPDV;
  END;
GO

  --------------------------------------------------------------------
  -- Obtener lista de registros --------------------------------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT I.ID_INACTIVACIONPDV,
             I.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             I.CODLINEADENEGOCIO,
             L.NOMLINEADENEGOCIO,
             I.CODDETALLESALDOPDV,
             D.SALDOCONTRAGTECH,
             D.SALDOCONTRAFIDUCIA,
             O.DESCRIPCION,
             I.FECHAHORAMODIFICACION,
             I.CODUSUARIOMODIFICACION,
             I.ACTIVE
      FROM WSXML_SFG.INACTIVACIONPDV I
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (I.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO L
        ON (I.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN WSXML_SFG.DETALLESALDOPDV D
        ON (I.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV)
      LEFT OUTER JOIN WSXML_SFG.INACTIVACIONPDVOMISION O
        ON (O.CODINACTIVACIONPDV = I.ID_INACTIVACIONPDV)
      WHERE I.ACTIVE = CASE WHEN @p_active = -1 THEN I.ACTIVE ELSE @p_active END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_GetListToInactivate', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GetListToInactivate;
GO
CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GetListToInactivate AS
  BEGIN
  SET NOCOUNT ON;
      SELECT I.ID_INACTIVACIONPDV,
             I.CODPUNTODEVENTA,
             P.NOMPUNTODEVENTA,
             I.CODLINEADENEGOCIO,
             L.NOMLINEADENEGOCIO,
             P.CODIGOGTECHPUNTODEVENTA,
             I.CODDETALLESALDOPDV,
             D.SALDOCONTRAGTECH,
             D.SALDOCONTRAFIDUCIA,
             I.FECHAHORAMODIFICACION,
             I.CODUSUARIOMODIFICACION,
             I.ACTIVE
      FROM WSXML_SFG.INACTIVACIONPDV I
      LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA P
        ON (I.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO L
        ON (I.CODLINEADENEGOCIO = L.ID_LINEADENEGOCIO)
      LEFT OUTER JOIN WSXML_SFG.DETALLESALDOPDV D
        ON (I.CODDETALLESALDOPDV = D.ID_DETALLESALDOPDV)
      WHERE I.ACTIVE = 1
        AND I.ID_INACTIVACIONPDV NOT IN (SELECT CODINACTIVACIONPDV FROM WSXML_SFG.INACTIVACIONPDVOMISION);
  END;
GO


------------------------------------------------------------------
  -- Generar la lista de inactivaciones a realizar de acuerdo con ----
  -- los saldos consolidados en SALDOPDV -----------------------------
  --------------------------------------------------------------------
 
  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_GenerarInactivaciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GenerarInactivaciones;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GenerarInactivaciones(@p_DETALLETAREAEJECUTADA NUMERIC(22,0),@p_FECHAEJECUCION DATETIME, @p_RETVALUE_out NUMERIC(22,0) OUT) AS
 BEGIN
	  SET NOCOUNT ON;
	BEGIN TRY
    DECLARE cPUNTOSDEVENTA CURSOR LOCAL FOR
      SELECT S.CODPUNTODEVENTA, S.CODLINEADENEGOCIO,
             S.CODDETALLESALDOPDV,
             ((D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH) +
              (D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA)) AS SALDOACTUAL
      FROM WSXML_SFG.SALDOPDV S
      INNER JOIN WSXML_SFG.DETALLESALDOPDV D ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
      INNER JOIN WSXML_SFG.PUNTODEVENTA P ON (P.ID_PUNTODEVENTA = S.CODPUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
      WHERE ((S.ACTIVE = 1 OR S.ACTIVE IS NULL) AND
            (P.ACTIVE = 1 OR P.ACTIVE IS NULL));

    DECLARE @c_TOTAL NUMERIC(38,0) = 0;
    DECLARE @c_COUNT NUMERIC(38,0) = 0;
    DECLARE @c_WAIT NUMERIC(38,0) = 10;
    DECLARE @c_CODUSUARIOMODIFICACION NUMERIC(38,0) = 1;
    DECLARE @c_NumWarnings numeric(38,0) = 0;
    --c_FECHA date := sysdate;

	DECLARE
		@p_REGISTRADA      			TINYINT,
		@p_INICIADA         		TINYINT,
		@p_FINALIZADAOK 			TINYINT,
		@p_FINALIZADAFALLO  		TINYINT,
		@p_ABORTADA  				TINYINT,
		@p_NOINICIADA  				TINYINT,
		@p_FINALIZADAADVERTENCIA  	TINYINT 

	EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT
					@p_REGISTRADA      			 OUT,
					@p_INICIADA         		 OUT,
					@p_FINALIZADAOK 			 OUT,
					@p_FINALIZADAFALLO  		 OUT,
					@p_ABORTADA  				 OUT,
					@p_NOINICIADA  				 OUT,
					@p_FINALIZADAADVERTENCIA  	 OUT
   

    /* TAREA PROGRESO */
    --Borrado Logico de la tabla
    Update WSXML_SFG.INACTIVACIONPDV set Active=0 where Active<>0;

    SELECT @c_TOTAL = COUNT(1)
    FROM WSXML_SFG.SALDOPDV S
    INNER JOIN WSXML_SFG.DETALLESALDOPDV D ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
    WHERE D.SALDOCONTRAGTECH > 0 OR D.SALDOCONTRAFIDUCIA > 0;

    EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_DETALLETAREAEJECUTADA,@c_TOTAL

    /* END TARE PR */

    DECLARE tPUNTODEVENTA CURSOR FOR 
		SELECT S.CODPUNTODEVENTA, S.CODLINEADENEGOCIO,
				 S.CODDETALLESALDOPDV,
				 ((D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH) +
				  (D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA)) AS SALDOACTUAL
		  FROM WSXML_SFG.SALDOPDV S
		  INNER JOIN WSXML_SFG.DETALLESALDOPDV D ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
		  INNER JOIN WSXML_SFG.PUNTODEVENTA P ON (P.ID_PUNTODEVENTA = S.CODPUNTODEVENTA)
		  LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
		  LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
		  WHERE ((S.ACTIVE = 1 OR S.ACTIVE IS NULL) AND
				(P.ACTIVE = 1 OR P.ACTIVE IS NULL)); 

	OPEN tPUNTODEVENTA;

	DECLARE @tPUNTODEVENTA__CODPUNTODEVENTA NUMERIC(38,0), @tPUNTODEVENTA__CODLINEADENEGOCIO  NUMERIC(38,0),
             @tPUNTODEVENTA__CODDETALLESALDOPDV NUMERIC(38,0),
             @tPUNTODEVENTA__SALDOACTUAL FLOAT


	FETCH tPUNTODEVENTA INTO  @tPUNTODEVENTA__CODPUNTODEVENTA, @tPUNTODEVENTA__CODLINEADENEGOCIO,
             @tPUNTODEVENTA__CODDETALLESALDOPDV,  @tPUNTODEVENTA__SALDOACTUAL

	 WHILE @@FETCH_STATUS=0
	 BEGIN
      -- Generar nueva inactivacion
          --Verifica que no este en la tabla de excepciones
    IF WSXML_SFG.SFGEXCEPCIONPDV_PermitirInactivacion(@tPUNTODEVENTA__CODPUNTODEVENTA) = 1 BEGIN

          DECLARE @rID NUMERIC(22,0);
          DECLARE @Verificacion NUMERIC(22,0);
          DECLARE @aux NUMERIC(22,0);
        BEGIN
        EXEC WSXML_SFG.SFGPDVPOLITICAPAGO_GetPolitica @tPUNTODEVENTA__Codpuntodeventa,@tPUNTODEVENTA__Codlineadenegocio,@p_FECHAEJECUCION,@Verificacion OUT

        --IF (tPUNTODEVENTA.SALDOCONTRAGTECH + tPUNTODEVENTA.SALDOCONTRAFIDUCIA) > tPUNTODEVENTA.VALORCUPO THEN
        IF (@Verificacion = 1)
          BEGIN
			BEGIN TRY

				  IF @tPUNTODEVENTA__Saldoactual < 0 BEGIN
              --aCTIVE = 0
              --IF (TPUNTODEVENTA.ID_INACTIVACIONPDV IS NOT NULL) THEN
              --   DeactivateRecord(tPUNTODEVENTA.Id_Inactivacionpdv,c_CODUSUARIOMODIFICACION);
              --END IF;
              EXEC WSXML_SFG.SFGINACTIVACIONPDV_AddRecord @tPUNTODEVENTA__CODPUNTODEVENTA, @tPUNTODEVENTA__CODLINEADENEGOCIO, @tPUNTODEVENTA__CODDETALLESALDOPDV, @c_CODUSUARIOMODIFICACION,@p_FECHAEJECUCION, @rID OUT

              select @aux = count(*) from WSXML_SFG.reactivacionpdv A
              where  convert(datetime, convert(date,A.Fechareactivacion)) = convert(datetime, convert(date,@p_FECHAEJECUCION))
              and A.Codpuntodeventa = @tPUNTODEVENTA__CODPUNTODEVENTA and A.CODLINEADENEGOCIO = @tPUNTODEVENTA__CODLINEADENEGOCIO ;

              if @aux > 0 begin
                 DELETE INACTIVACIONPDV WHERE  convert(datetime, convert(date,fechainactivacion)) = convert(datetime, convert(date,@p_FECHAEJECUCION))
                 and Codpuntodeventa = @tPUNTODEVENTA__CODPUNTODEVENTA and CODLINEADENEGOCIO = @tPUNTODEVENTA__CODLINEADENEGOCIO ;
              END 

              -- Enviar SMS de suspension
                DECLARE @cFMRCELL VARCHAR(4000) /* Use -meta option USUARIO.CELULAR%TYPE */;
                DECLARE @cFMREMAIL NVARCHAR(2000);
                DECLARE @MENSAJE NVARCHAR(2000);

				BEGIN
					SET @MENSAJE='El SFG esta proximo a inactivar el punto de venta ' + ISNULL(WSXML_SFG.PUNTODEVENTA_CODIGO_F(@tPUNTODEVENTA__CODPUNTODEVENTA), '') + ' para la linea de negocio ' + WSXML_SFG.lineadenegocio_nombre_f(@tPUNTODEVENTA__Codlineadenegocio) + '.' ;

					SELECT @cFMRCELL = CELULAR FROM WSXML_SFG.PUNTODEVENTA
					INNER JOIN RUTAPDV ON (CODRUTAPDV = ID_RUTAPDV)
					INNER JOIN FMR ON (CODFMR = ID_FMR)
					INNER JOIN USUARIO ON (CODUSUARIO = ID_USUARIO)
					WHERE ID_PUNTODEVENTA = @tPUNTODEVENTA__CODPUNTODEVENTA;

					SELECT @cFMREMAIL = FMR.EMAIL FROM WSXML_SFG.PUNTODEVENTA
					INNER JOIN RUTAPDV ON (CODRUTAPDV = ID_RUTAPDV)
					INNER JOIN FMR ON (CODFMR = ID_FMR)
					INNER JOIN USUARIO ON (CODUSUARIO = ID_USUARIO)
					WHERE ID_PUNTODEVENTA = @tPUNTODEVENTA__CODPUNTODEVENTA;

					IF @cFMRCELL IS NOT NULL BEGIN
					  EXEC WSXML_SFG.SFG_PACKAGE_CALL_SMS @cFMRCELL, 'Notificacion de inactivacion', @MENSAJE
					  EXEC WSXML_SFG.SFG_PACKAGE_CALL_SMS @cFMREMAIL, 'Notificacion de inactivacion', @MENSAJE
					END 

				  IF @@ROWCOUNT = 0
					SELECT NULL;
              END;

              END 
			END TRY
			BEGIN CATCH
            -- Siguiente linea
	            SET @c_NumWarnings = @c_NumWarnings + 1;
			END CATCH
          END;

        --ELSE
          --IF (tPUNTODEVENTA.Id_Inactivacionpdv is not null) then
             --SFGREACTIVACIONPDV.AddRecord(tPUNTODEVENTA.CODPUNTODEVENTA,tPUNTODEVENTA.Id_Inactivacionpdv, tPUNTODEVENTA.CODLINEADENEGOCIO, c_CODUSUARIOMODIFICACION,c_FECHA, rID);
          --end if;
        
        END;


        SET @c_COUNT = @c_COUNT + 1;
        IF (@c_COUNT %@c_WAIT) = 0 BEGIN
          EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_DETALLETAREAEJECUTADA, @c_COUNT
        END 
      END 
    FETCH tPUNTODEVENTA INTO  @tPUNTODEVENTA__CODPUNTODEVENTA, @tPUNTODEVENTA__CODLINEADENEGOCIO,
             @tPUNTODEVENTA__CODDETALLESALDOPDV,  @tPUNTODEVENTA__SALDOACTUAL
    END;

    CLOSE tPUNTODEVENTA;
    DEALLOCATE tPUNTODEVENTA;
    SET @p_RETVALUE_out = @p_FINALIZADAOK;

	END TRY
	BEGIN CATCH
    SET @p_RETVALUE_out = @p_FINALIZADAFALLO;
	END CATCH
  END;
GO




  --------------------------------------------------------------------
  -- Generar la lista de Activaciones a realizar de acuerdo con ----
  -- los saldos consolidados en SALDOPDV -----------------------------
  --------------------------------------------------------------------


  IF OBJECT_ID('WSXML_SFG.SFGINACTIVACIONPDV_GenerarActivaciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GenerarActivaciones;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINACTIVACIONPDV_GenerarActivaciones(@p_DETALLETAREAEJECUTADA NUMERIC(22,0),@p_FECHAEJECUCION DATETIME, @p_RETVALUE_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE cPUNTOSDEVENTA CURSOR LOCAL FOR
      SELECT S.CODPUNTODEVENTA, S.CODLINEADENEGOCIO,C.VALORCUPO,
             ((D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH) +
              (D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA)
              --- NVL(VENTASDIARIAS.VENTASDIARIAS, 0)
              ) AS SALDOACTUAL
      FROM WSXML_SFG.SALDOPDV S
      INNER JOIN WSXML_SFG.DETALLESALDOPDV D ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
      INNER JOIN WSXML_SFG.PUNTODEVENTA P ON (P.ID_PUNTODEVENTA = S.CODPUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
      LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
      WHERE ((S.ACTIVE = 1 OR S.ACTIVE IS NULL) AND
            (P.ACTIVE = 1 OR P.ACTIVE IS NULL));

	DECLARE
		@p_REGISTRADA      			TINYINT,
		@p_INICIADA         		TINYINT,
		@p_FINALIZADAOK 			TINYINT,
		@p_FINALIZADAFALLO  		TINYINT,
		@p_ABORTADA  				TINYINT,
		@p_NOINICIADA  				TINYINT,
		@p_FINALIZADAADVERTENCIA  	TINYINT 

	EXEC WSXML_SFG.SFGESTADOTAREAEJECUTADA_CONSTANT
					@p_REGISTRADA      			 OUT,
					@p_INICIADA         		 OUT,
					@p_FINALIZADAOK 			 OUT,
					@p_FINALIZADAFALLO  		 OUT,
					@p_ABORTADA  				 OUT,
					@p_NOINICIADA  				 OUT,
					@p_FINALIZADAADVERTENCIA  	 OUT


    DECLARE @c_TOTAL NUMERIC(38,0) = 0;
    DECLARE @c_COUNT NUMERIC(38,0) = 0;
    DECLARE @c_WAIT NUMERIC(38,0) = 10;
    DECLARE @c_CODUSUARIOMODIFICACION NUMERIC(38,0) = 1;
    DECLARE @c_NumWarnings numeric(38,0) = 0;
	DECLARE @msg VARCHAR(2000)
    --c_FECHA date := sysdate;
   
  SET NOCOUNT ON;
    /* TAREA PROGRESO */
    --Borrado Logico de la tabla
	BEGIN TRY
		Update WSXML_SFG.INACTIVACIONPDV set Active=0 where Active <> 0;


		SELECT @c_TOTAL = COUNT(1)
		FROM WSXML_SFG.SALDOPDV S
		INNER JOIN DETALLESALDOPDV D ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
		WHERE D.SALDOCONTRAGTECH > 0 OR D.SALDOCONTRAFIDUCIA > 0;

		EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_SetTotalRecords @p_DETALLETAREAEJECUTADA,@c_TOTAL

		/* END TARE PR */

		DECLARE tPUNTODEVENTA CURSOR FOR 
				SELECT S.CODPUNTODEVENTA, S.CODLINEADENEGOCIO,C.VALORCUPO,
					 ((D.SALDOAFAVORGTECH - D.SALDOCONTRAGTECH) +
					  (D.SALDOAFAVORFIDUCIA - D.SALDOCONTRAFIDUCIA)
					  --- NVL(VENTASDIARIAS.VENTASDIARIAS, 0)
					  ) AS SALDOACTUAL
			  FROM WSXML_SFG.SALDOPDV S
			  INNER JOIN WSXML_SFG.DETALLESALDOPDV D ON (D.ID_DETALLESALDOPDV = S.CODDETALLESALDOPDV)
			  INNER JOIN WSXML_SFG.PUNTODEVENTA P ON (P.ID_PUNTODEVENTA = S.CODPUNTODEVENTA)
			  LEFT OUTER JOIN WSXML_SFG.PDVCATEGORIACUPO PC ON (PC.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
			  LEFT OUTER JOIN WSXML_SFG.CATEGORIACUPO C ON (C.ID_CATEGORIACUPO = PC.CODCATEGORIACUPO)
			  WHERE ((S.ACTIVE = 1 OR S.ACTIVE IS NULL) AND
					(P.ACTIVE = 1 OR P.ACTIVE IS NULL));

		OPEN tPUNTODEVENTA;

		DECLARE @tPUNTODEVENTA__CODPUNTODEVENTA NUMERIC(38,0), @tPUNTODEVENTA__CODLINEADENEGOCIO  NUMERIC(38,0),
				 @tPUNTODEVENTA__CODDETALLESALDOPDV NUMERIC(38,0),
				 @tPUNTODEVENTA__SALDOACTUAL FLOAT


		FETCH tPUNTODEVENTA INTO  @tPUNTODEVENTA__CODPUNTODEVENTA, @tPUNTODEVENTA__CODLINEADENEGOCIO,
				 @tPUNTODEVENTA__CODDETALLESALDOPDV,  @tPUNTODEVENTA__SALDOACTUAL

		 WHILE @@FETCH_STATUS=0
		 BEGIN
		  -- Generar nueva inactivacion
			DECLARE @rID NUMERIC(22,0);
			DECLARE @Verificacion NUMERIC(22,0);
			DECLARE @aux NUMERIC(22,0);
		  BEGIN
		  EXEC WSXML_SFG.SFGPDVPOLITICAPAGO_GetPolitica @tPUNTODEVENTA__Codpuntodeventa,@tPUNTODEVENTA__Codlineadenegocio,@p_FECHAEJECUCION,@Verificacion OUT

		  --IF (tPUNTODEVENTA.SALDOCONTRAGTECH + tPUNTODEVENTA.SALDOCONTRAFIDUCIA) > tPUNTODEVENTA.VALORCUPO THEN
		  IF (@Verificacion = 1)
			BEGIN
				BEGIN TRY
					IF @tPUNTODEVENTA__Saldoactual > 0 BEGIN
				--aCTIVE = 0
				--IF (TPUNTODEVENTA.ID_INACTIVACIONPDV IS NOT NULL) THEN
				--   DeactivateRecord(tPUNTODEVENTA.Id_Inactivacionpdv,c_CODUSUARIOMODIFICACION);
				--END IF;
				EXEC WSXML_SFG.SFGINACTIVACIONPDV_AddRecordActivacion @tPUNTODEVENTA__CODPUNTODEVENTA, @tPUNTODEVENTA__CODLINEADENEGOCIO, @c_CODUSUARIOMODIFICACION,@p_FECHAEJECUCION, @rID OUT

				--Elimina archivo de la tabla inactivaciones

				select @aux = count(*) from WSXML_SFG.inactivacionpdv A
				where  convert(datetime, convert(date,A.fechainactivacion)) = convert(datetime, convert(date,@p_FECHAEJECUCION))
				and A.Codpuntodeventa = @tPUNTODEVENTA__CODPUNTODEVENTA and A.CODLINEADENEGOCIO = @tPUNTODEVENTA__CODLINEADENEGOCIO ;

				if @aux > 0 begin
				   DELETE INACTIVACIONPDV  WHERE  convert(datetime, convert(date,fechainactivacion)) = convert(datetime, convert(date,@p_FECHAEJECUCION))
				   and Codpuntodeventa = @tPUNTODEVENTA__CODPUNTODEVENTA and CODLINEADENEGOCIO = @tPUNTODEVENTA__CODLINEADENEGOCIO ;
				END 

				-- Enviar SMS de suspension
				  DECLARE @cFMRCELL VARCHAR(4000) /* Use -meta option USUARIO.CELULAR%TYPE */;
				BEGIN
				  SELECT @cFMRCELL = CELULAR FROM WSXML_SFG.PUNTODEVENTA
				  INNER JOIN WSXML_SFG.RUTAPDV ON (CODRUTAPDV = ID_RUTAPDV)
				  INNER JOIN WSXML_SFG.FMR ON (CODFMR = ID_FMR)
				  INNER JOIN WSXML_SFG.USUARIO ON (CODUSUARIO = ID_USUARIO)
				  WHERE ID_PUNTODEVENTA = @tPUNTODEVENTA__CODPUNTODEVENTA;

				  IF @cFMRCELL IS NOT NULL BEGIN
					SET @msg = 'El SFG esta proximo a inactivar el punto de venta ' + WSXML_SFG.PUNTODEVENTA_CODIGO_F(@tPUNTODEVENTA__CODPUNTODEVENTA)
					EXEC WSXML_SFG.SFG_PACKAGE_CALL_SMS @cFMRCELL, 'Notificacion de inactivacion', @msg
				  END 
			  
				  IF @@ROWCOUNT = 0 BEGIN
						SELECT NULL;
				  END
				END;

				END 
				END TRY
				BEGIN CATCH
					-- Siguiente linea
					SET @c_NumWarnings = @c_NumWarnings + 1;
				END CATCH
			END;

		  --ELSE
			--IF (tPUNTODEVENTA.Id_Inactivacionpdv is not null) then
			   --SFGREACTIVACIONPDV.AddRecord(tPUNTODEVENTA.CODPUNTODEVENTA,tPUNTODEVENTA.Id_Inactivacionpdv, tPUNTODEVENTA.CODLINEADENEGOCIO, c_CODUSUARIOMODIFICACION,c_FECHA, rID);
			--end if;
      
		  END;


		  SET @c_COUNT = @c_COUNT + 1;
		  IF (@c_COUNT %@c_WAIT) = 0 BEGIN
			EXEC WSXML_SFG.SFGDETALLETAREAEJECUTADA_UpdateCountRecords @p_DETALLETAREAEJECUTADA, @c_COUNT
		  END 
    
			FETCH tPUNTODEVENTA INTO  @tPUNTODEVENTA__CODPUNTODEVENTA, @tPUNTODEVENTA__CODLINEADENEGOCIO,
				 @tPUNTODEVENTA__CODDETALLESALDOPDV,  @tPUNTODEVENTA__SALDOACTUAL
		END;

		CLOSE tPUNTODEVENTA;
		DEALLOCATE tPUNTODEVENTA;
		SET @p_RETVALUE_out = @p_FINALIZADAOK;
	
	END TRY
    BEGIN CATCH
    SET @p_RETVALUE_out = @p_FINALIZADAFALLO;

	END CATCH
  END;
GO
