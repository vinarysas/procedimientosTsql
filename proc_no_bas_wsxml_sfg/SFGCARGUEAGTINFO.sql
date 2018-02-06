USE SFGPRODU;
--  DDL for Package Body SFGCARGUEAGTINFO
--------------------------------------------------------


  /* PACKAGE BODY WSXML_SFG.SFGCARGUEAGTINFO */ 


  -- Updates a record in the CICLOFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGCARGUEAGTINFO_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_CONSTANT;
GO

CREATE PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_CONSTANT(
      @ecINVALIDMODFUSER INT OUT,
	  @ecINVALIDGROUPTYP INT OUT,
	  @ecINVALIDREGIMENP INT OUT,
	  @ecINVALIDIDENTTYP INT OUT,
	  @ecINVALIDCITYCODE INT OUT,
	  @ecINVALIDLIMITVAL INT OUT,
	  @ecNONEXISTANTCPDV INT OUT,
	  @ecUNBALANCREGIMEN INT OUT,

	  @ecUNABLEPDVASTATE INT OUT,
	  @ecUNABLEPRTTERMIN INT OUT,
	  @ecUNABLEROUTECREA INT OUT,
	  @ecUNABLENETWORKCR INT OUT,
	  @ecUNABLEREGIONALC INT OUT,
	  @ecUNABLESTATIONTY INT OUT,
	  @ecUNABLEBUSINESST INT OUT,
	  @ecUNABLETERMNTYPE INT OUT,
	  @ecUNABLECHAINDATA INT OUT,
	  @ecUNABLECONTRACTD INT OUT
    )
AS
BEGIN
SET NOCOUNT ON;
  SET @ecINVALIDMODFUSER = -20010;
  SET @ecINVALIDGROUPTYP = -20011;
  SET @ecINVALIDREGIMENP = -20012;
  SET @ecINVALIDIDENTTYP = -20013;
  SET @ecINVALIDCITYCODE = -20014;
  SET @ecINVALIDLIMITVAL = -20015;
  SET @ecNONEXISTANTCPDV = -20016;
  SET @ecUNBALANCREGIMEN = -20017;

  SET @ecUNABLEPDVASTATE = -20060;
  SET @ecUNABLEPRTTERMIN = -20061;
  SET @ecUNABLEROUTECREA = -20062;
  SET @ecUNABLENETWORKCR = -20063;
  SET @ecUNABLEREGIONALC = -20064;
  SET @ecUNABLESTATIONTY = -20065;
  SET @ecUNABLEBUSINESST = -20066;
  SET @ecUNABLETERMNTYPE = -20067;
  SET @ecUNABLECHAINDATA = -20068;
  SET @ecUNABLECONTRACTD = -20069;

END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGCARGUEAGTINFO_VerificarConsistencias', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_VerificarConsistencias;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_VerificarConsistencias(@p_CODDANECIUDADPDV          NVARCHAR(2000),
                                   @p_CODIGOGTECHCADENA         NVARCHAR(2000),
                                   @p_NOMBRECADENA              NVARCHAR(2000),
                                   @p_CODTIPOPUNTODEVENTA       NUMERIC(22,0),
                                   @p_CODIGOGTECHRAZONSOCIAL    NUMERIC(22,0),
                                   @p_NOMBRERAZONSOCIAL         NVARCHAR(2000),
                                   @p_IDENTIFICACION            NUMERIC(22,0),
                                   @p_DIGITOVERIFICACION        NUMERIC(22,0),
                                   @p_CODDANECIUDADRAZONSOCIAL  NVARCHAR(2000),
                                   @p_CODREGIMEN                NUMERIC(22,0),
                                   @p_NOMBRECONTACTO            NVARCHAR(2000),
                                   @p_EMAILCONTACTO             NVARCHAR(2000),
                                   @p_TELEFONOCONTACTO          NVARCHAR(2000),
                                   @p_DIRECCIONCONTACTO         NVARCHAR(2000),
                                   @p_RUTA                      NVARCHAR(2000),
                                   @p_CODIGOFMR                 NVARCHAR(2000),
                                   @p_FMR                       NVARCHAR(2000),
                                   @p_REGIONAL                  NVARCHAR(2000),
                                   @p_CODIGOJEFEDISTRITO        NVARCHAR(2000),
                                   @p_JEFEDISTRITO              NVARCHAR(2000),
                                   @p_RED                       NVARCHAR(2000),
                                   @p_TIPONEGOCIO               NVARCHAR(2000),
                                   @p_TIPOESTACION              NVARCHAR(2000),
                                   @p_TIPOTERMINAL              NVARCHAR(2000),
                                   @p_PUERTOTERMINAL            NVARCHAR(2000),
                                   @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                                   @p_codCiudadPDV              NUMERIC(22,0) OUT,
                                   @p_codAgrupacionPuntoDeVenta NUMERIC(22,0) OUT,
                                   @p_codRazonSocial            NUMERIC(22,0) OUT,
                                   @p_codRutaPDV                NUMERIC(22,0) OUT,
                                   @p_codRegional               NUMERIC(22,0) OUT,
                                   @p_codRedPDV                 NUMERIC(22,0) OUT,
                                   @p_codTipoNegocio            NUMERIC(22,0) OUT,
                                   @p_codTipoEstacion           NUMERIC(22,0) OUT,
                                   @p_codTipoTerminal           NUMERIC(22,0) OUT,
                                   @p_codPuertoTerminal         NUMERIC(22,0) OUT,
                                   @p_flagNuevoAgrupacion       NUMERIC(22,0) OUT,
                                   @p_flagRazonSocialModificada NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @tmpERROR NVARCHAR(2000);
    -- Cursor para verificacion de datos Tabla Adjunta Cadena
    DECLARE @curAGRUPACIONPUNTODEVENTA_pc_CODIGOGTECHCADENA NVARCHAR;

    DECLARE curAGRUPACIONPUNTODEVENTA CURSOR LOCAL FOR
      SELECT ID_AGRUPACIONPUNTODEVENTA,
             CODIGOAGRUPACIONGTECH,
             NOMAGRUPACIONPUNTODEVENTA,
             CODTIPOPUNTODEVENTA
        FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
       WHERE CODIGOAGRUPACIONGTECH = @curAGRUPACIONPUNTODEVENTA_pc_CODIGOGTECHCADENA;
    -- Cursor para verificacion de datos Tabla Adjunta Razon Social
    DECLARE @curRAZONSOCIAL_pc_CODIGOGTECHRAZONSOCIAL FLOAT;
    DECLARE curRAZONSOCIAL CURSOR LOCAL FOR
      SELECT ID_RAZONSOCIAL,
             CODIGOGTECHRAZONSOCIAL,
             NOMRAZONSOCIAL,
             IDENTIFICACION,
             DIGITOVERIFICACION,
             NOMBRECONTACTO,
             EMAILCONTACTO,
             TELEFONOCONTACTO,
             DIRECCIONCONTACTO,
             CODCIUDAD,
             CODREGIMEN
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE CODIGOGTECHRAZONSOCIAL = @curRAZONSOCIAL_pc_CODIGOGTECHRAZONSOCIAL;
    -- Cursor para verificacion de datos Tabla Adjunta Razon Social (sin codigo)
    DECLARE @curRAZONSOCIALNOCODIGO_pc_IDENTIFICACION FLOAT;
    DECLARE @curRAZONSOCIALNOCODIGO_pc_DIGITOVERIFICACION FLOAT;

    DECLARE curRAZONSOCIALNOCODIGO CURSOR LOCAL
                                  FOR
      SELECT ID_RAZONSOCIAL,
             CODIGOGTECHRAZONSOCIAL,
             NOMRAZONSOCIAL,
             IDENTIFICACION,
             DIGITOVERIFICACION,
             NOMBRECONTACTO,
             EMAILCONTACTO,
             TELEFONOCONTACTO,
             DIRECCIONCONTACTO,
             CODCIUDAD,
             CODREGIMEN
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE IDENTIFICACION = @curRAZONSOCIALNOCODIGO_pc_IDENTIFICACION
         AND DIGITOVERIFICACION = @curRAZONSOCIALNOCODIGO_pc_DIGITOVERIFICACION
       ORDER BY CAST(CODIGOGTECHRAZONSOCIAL AS NUMERIC(38,0)) DESC;
   
  SET NOCOUNT ON;
    SET @p_flagNuevoAgrupacion       = 0;
    SET @p_flagRazonSocialModificada = 0;
    /* Consistency check must be realized before attempting to insert any record - key */

    -- Verificacion de consistencia p_CODUSUARIOMODIFICACION
      DECLARE @curCodUsuarioModificacion NUMERIC(22,0);
    BEGIN
		BEGIN TRY
		  SELECT @curCodUsuarioModificacion = ID_USUARIO
			FROM WSXML_SFG.USUARIO
		   WHERE ID_USUARIO = @p_CODUSUARIOMODIFICACION;
			IF @@ROWCOUNT = 0
				RAISERROR('ecINVALIDMODFUSER El usuario no existe', 16, 1);
      
	    END TRY
		BEGIN CATCH
		  
			SET @tmpERROR = 'ecINVALIDMODFUSER No se pudo verificar el usuario que accede el metodo: ' +
									ISNULL(ERROR_MESSAGE ( ) , '');
			RAISERROR(@tmpERROR, 16, 1);
		END CATCH
    END;

    -- Obtencion llave p_codCiudadPDV
    BEGIN
		BEGIN TRY
		  SELECT @p_codCiudadPDV = ID_CIUDAD
			FROM WSXML_SFG.CIUDAD
		   WHERE CIUDADDANE = @p_CODDANECIUDADPDV;
		  IF @@ROWCOUNT = 0
			RAISERROR('ecINVALIDCITYCODE El codigo de ciudad no existe', 16, 1);
		END TRY
		BEGIN CATCH
			SET @tmpERROR = 'ecINVALIDCITYCODE No se pudo verificar la ciudad: ' +
									ISNULL(ERROR_MESSAGE ( ) , '');
			RAISERROR(@tmpERROR, 16, 1);
		END CATCH
    END;

    -- Segmento Cadena: Verificacion de llaves interna
		DECLARE @keyTipoPuntoDeVenta NUMERIC(22,0);
		DECLARE @rowcur_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0);
		DECLARE @rowcur_NOMAGRUPACIONPUNTODEVENTA VARCHAR(2000);
		DECLARE @rowcur_CODTIPOPUNTODEVENTA NUMERIC(22,0);
		DECLARE @rowcur_ID_RAZONSOCIAL NUMERIC(22,0);
		DECLARE @rowcur_NOMRAZONSOCIAL VARCHAR(2000);
		DECLARE @rowcur_IDENTIFICACION VARCHAR(2000);
		DECLARE @rowcur_DIGITOVERIFICACION VARCHAR(2000)
		DECLARE @rowcur_NOMBRECONTACTO VARCHAR(2000);
		DECLARE @rowcur_EMAILCONTACTO VARCHAR(2000)
		DECLARE @rowcur_TELEFONOCONTACTO VARCHAR(2000);
		DECLARE @rowcur_DIRECCIONCONTACTO VARCHAR(2000);
		DECLARE @rowcur_CODCIUDAD NUMERIC(22,0);
		DECLARE @rowcur_CODREGIMEN NUMERIC(22,0);
    BEGIN
      -- Verificacion de Consistencia Tipo Agrupamiento
      BEGIN
		BEGIN TRY
			SELECT @keyTipoPuntoDeVenta = ID_TIPOPUNTODEVENTA
			  FROM WSXML_SFG.TIPOPUNTODEVENTA
			 WHERE ID_TIPOPUNTODEVENTA = @p_CODTIPOPUNTODEVENTA;
			  IF @@ROWCOUNT = 0
				  RAISERROR('ecINVALIDGROUPTYP El tipo de agrupamiento no existe', 16, 1);
		 END TRY
		 BEGIN CATCH

				  SET @tmpERROR = 'ecINVALIDGROUPTYP No se pudo verificar el tipo de agrupamiento: ' +
										  ISNULL(ERROR_MESSAGE ( ) , '');
				  RAISERROR(@tmpERROR, 16, 1);
		 END CATCH
      END;
      -- Verificacion y actualizacion Cadena
      BEGIN
		BEGIN TRY
			SET @curAGRUPACIONPUNTODEVENTA_pc_CODIGOGTECHCADENA = @p_CODIGOGTECHCADENA;
        
			OPEN curAGRUPACIONPUNTODEVENTA;
			FETCH curAGRUPACIONPUNTODEVENTA
			  INTO @rowcur_ID_AGRUPACIONPUNTODEVENTA, @rowcur_NOMAGRUPACIONPUNTODEVENTA, @rowcur_CODTIPOPUNTODEVENTA, @rowcur_ID_RAZONSOCIAL, @rowcur_NOMRAZONSOCIAL, @rowcur_IDENTIFICACION, @rowcur_DIGITOVERIFICACION, @rowcur_NOMBRECONTACTO, @rowcur_EMAILCONTACTO, @rowcur_TELEFONOCONTACTO, @rowcur_DIRECCIONCONTACTO, @rowcur_CODCIUDAD, @rowcur_CODREGIMEN;
			IF @@FETCH_STATUS = 0 BEGIN
			  -- No existe. Insertar.
			  EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AddRecord @p_NOMBRECADENA,
												  @p_CODIGOGTECHCADENA,
												  @keyTipoPuntoDeVenta,
												  @p_CODUSUARIOMODIFICACION,
												  @p_codAgrupacionPuntoDeVenta OUT
			  SET @p_flagNuevoAgrupacion = 1;
			END
			ELSE BEGIN
			  -- Ya existe. Obtener llave y actualizar
			  SELECT @p_codAgrupacionPuntoDeVenta = @rowcur_ID_AGRUPACIONPUNTODEVENTA;

			  IF (@rowcur_NOMAGRUPACIONPUNTODEVENTA <> @p_NOMBRECADENA OR
				 @rowcur_CODTIPOPUNTODEVENTA <> @keyTipoPuntoDeVenta) BEGIN
				EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateRecord @p_codAgrupacionPuntoDeVenta,
													   @p_NOMBRECADENA,
													   @p_CODIGOGTECHCADENA,
													   @keyTipoPuntoDeVenta,
													   @p_CODUSUARIOMODIFICACION,
													   1
			  END 
			END 
			CLOSE curAGRUPACIONPUNTODEVENTA;
			DEALLOCATE curAGRUPACIONPUNTODEVENTA;
		END TRY
		BEGIN CATCH
			  SET @tmpERROR = 'ecUNABLECHAINDATA No se pudo actualizar los datos de la cadena: ' +
									  ISNULL(ERROR_MESSAGE ( ), '');
			  RAISERROR(@tmpERROR, 16, 1);
		END CATCH
      END;
    END;

    -- Segmento Razon Social: Verificacion de llaves interna
      DECLARE @keyCiudadRazonSocial NUMERIC(22,0);
      DECLARE @keyRegimen           NUMERIC(22,0);


    BEGIN
      -- Verificacion Regimen
      BEGIN
		BEGIN TRY
			SELECT @keyRegimen = ID_REGIMEN
			  FROM WSXML_SFG.REGIMEN
			 WHERE ID_REGIMEN = @p_CODREGIMEN;

			IF @@ROWCOUNT = 0
			  RAISERROR('ecINVALIDREGIMENP El regimen no existe', 16, 1);
		 END TRY
		 BEGIN CATCH
			  SET @tmpERROR = 'ecINVALIDREGIMENP No se pudo verificar el regimen: ' +
									  ISNULL(ERROR_MESSAGE ( ), '');
			  RAISERROR(@tmpERROR, 16, 1);
		 END CATCH
      END;
      -- Obtener llave de Ciudad Razon Social
      BEGIN
		BEGIN TRY
			SELECT @keyCiudadRazonSocial = ID_CIUDAD
			  FROM WSXML_SFG.CIUDAD
			 WHERE CIUDADDANE = @p_CODDANECIUDADRAZONSOCIAL;
		  
			IF @@ROWCOUNT = 0
			  RAISERROR('ecINVALIDCITYCODE El Codigo de ciudad no existe', 16, 1);
		END TRY
		BEGIN CATCH
			  SET @tmperror = 'ecINVALIDCITYCODE No se pudo verificar la ciudad: ' +
									  ISNULL(ERROR_MESSAGE ( ), '');
			  RAISERROR(@tmperror, 16, 1);
		END CATCH
      END;
      -- Verificacion y actualizacion Razon Social
      IF @p_CODIGOGTECHRAZONSOCIAL <= 0
        BEGIN
          SET @curRAZONSOCIALNOCODIGO_pc_IDENTIFICACION = @p_IDENTIFICACION;
          SET @curRAZONSOCIALNOCODIGO_pc_DIGITOVERIFICACION = @p_DIGITOVERIFICACION;
          
          OPEN curRAZONSOCIALNOCODIGO;
          FETCH curRAZONSOCIALNOCODIGO
            INTO @rowcur_ID_RAZONSOCIAL, @rowcur_NOMRAZONSOCIAL, @rowcur_IDENTIFICACION, @rowcur_DIGITOVERIFICACION, @rowcur_NOMBRECONTACTO, @rowcur_EMAILCONTACTO, @rowcur_TELEFONOCONTACTO, @rowcur_DIRECCIONCONTACTO, @rowcur_CODCIUDAD, @rowcur_CODREGIMEN;
          IF @@FETCH_STATUS = 0 BEGIN
            -- No existe, y no tiene codigo
            EXEC WSXML_SFG.SFGRAZONSOCIAL_AddRecord 0,
                                     @p_NOMBRERAZONSOCIAL,
                                     @p_IDENTIFICACION,
                                     @p_DIGITOVERIFICACION,
                                     @p_NOMBRECONTACTO,
                                     @p_EMAILCONTACTO,
                                     @p_TELEFONOCONTACTO,
                                     @p_DIRECCIONCONTACTO,
                                     @keyCiudadRazonSocial,
                                     @p_CODREGIMEN,
                                     @p_CODUSUARIOMODIFICACION,
                                     @p_codRazonSocial OUT
          END
          ELSE BEGIN
            -- Existe, pero no tiene codigo. Actualizar
            SELECT @p_codRazonSocial = @rowcur_ID_RAZONSOCIAL;
            IF (@rowcur_NOMRAZONSOCIAL <> @p_NOMBRERAZONSOCIAL OR
               @rowcur_IDENTIFICACION <> @p_IDENTIFICACION OR
               @rowcur_DIGITOVERIFICACION <> @p_DIGITOVERIFICACION OR
               @rowcur_NOMBRECONTACTO <> @p_NOMBRECONTACTO OR
               @rowcur_EMAILCONTACTO <> @p_EMAILCONTACTO OR
               @rowcur_TELEFONOCONTACTO <> @p_TELEFONOCONTACTO OR
               @rowcur_DIRECCIONCONTACTO <> @p_DIRECCIONCONTACTO OR
               @rowcur_CODCIUDAD <> @keyCiudadRazonSocial OR
               @rowcur_CODREGIMEN <> @p_CODREGIMEN) BEGIN
               EXEC WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord @p_codRazonSocial,
                                          0,
                                          @p_NOMBRERAZONSOCIAL,
                                          @p_IDENTIFICACION,
                                          @p_DIGITOVERIFICACION,
                                          @p_NOMBRECONTACTO,
                                          @p_EMAILCONTACTO,
                                          @p_TELEFONOCONTACTO,
                                          @p_DIRECCIONCONTACTO,
                                          @keyCiudadRazonSocial,
                                          @p_CODREGIMEN,
                                          @p_CODUSUARIOMODIFICACION
              IF (@rowcur_IDENTIFICACION <> @p_IDENTIFICACION OR
                 @rowcur_DIGITOVERIFICACION <> @p_DIGITOVERIFICACION OR
                 @rowcur_CODREGIMEN <> @p_CODREGIMEN) BEGIN
                SET @p_flagRazonSocialModificada = 1;
              END 
            END 
          END 
          CLOSE curRAZONSOCIALNOCODIGO;
          DEALLOCATE curRAZONSOCIALNOCODIGO;
        END;
      ELSE
        BEGIN
          SET @curRAZONSOCIAL_pc_CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
          
          OPEN curRAZONSOCIAL;
          FETCH curRAZONSOCIAL
            INTO @rowcur_ID_AGRUPACIONPUNTODEVENTA, @rowcur_NOMAGRUPACIONPUNTODEVENTA, @rowcur_CODTIPOPUNTODEVENTA, @rowcur_ID_RAZONSOCIAL, @rowcur_NOMRAZONSOCIAL, @rowcur_IDENTIFICACION, @rowcur_DIGITOVERIFICACION, @rowcur_NOMBRECONTACTO, @rowcur_EMAILCONTACTO, @rowcur_TELEFONOCONTACTO, @rowcur_DIRECCIONCONTACTO, @rowcur_CODCIUDAD, @rowcur_CODREGIMEN;
          IF @@FETCH_STATUS = 0 BEGIN
            EXEC WSXML_SFG.SFGRAZONSOCIAL_AddRecord @p_CODIGOGTECHRAZONSOCIAL,
                                     @p_NOMBRERAZONSOCIAL,
                                     @p_IDENTIFICACION,
                                     @p_DIGITOVERIFICACION,
                                     @p_NOMBRECONTACTO,
                                     @p_EMAILCONTACTO,
                                     @p_TELEFONOCONTACTO,
                                     @p_DIRECCIONCONTACTO,
                                     @keyCiudadRazonSocial,
                                     @p_CODREGIMEN,
                                     @p_CODUSUARIOMODIFICACION,
                                     @p_codRazonSocial OUT
          END
          ELSE BEGIN
            -- Existe; y tiene codigo. Se actualizara toda la informacion
            SELECT @p_codRazonSocial = @rowcur_ID_RAZONSOCIAL;
            IF (@rowcur_NOMRAZONSOCIAL <> @p_NOMBRERAZONSOCIAL OR
               @rowcur_IDENTIFICACION <> @p_IDENTIFICACION OR
               @rowcur_DIGITOVERIFICACION <> @p_DIGITOVERIFICACION OR
               @rowcur_NOMBRECONTACTO <> @p_NOMBRECONTACTO OR
               @rowcur_EMAILCONTACTO <> @p_EMAILCONTACTO OR
               @rowcur_TELEFONOCONTACTO <> @p_TELEFONOCONTACTO OR
               @rowcur_DIRECCIONCONTACTO <> @p_DIRECCIONCONTACTO OR
               @rowcur_CODCIUDAD <> @keyCiudadRazonSocial OR
               @rowcur_CODREGIMEN <> @p_CODREGIMEN) BEGIN
               EXEC WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord @p_codRazonSocial,
                                          @p_CODIGOGTECHRAZONSOCIAL,
                                          @p_NOMBRERAZONSOCIAL,
                                          @p_IDENTIFICACION,
                                          @p_DIGITOVERIFICACION,
                                          @p_NOMBRECONTACTO,
                                          @p_EMAILCONTACTO,
                                          @p_TELEFONOCONTACTO,
                                          @p_DIRECCIONCONTACTO,
                                          @keyCiudadRazonSocial,
                                          @p_CODREGIMEN,
                                          @p_CODUSUARIOMODIFICACION
              IF (@rowcur_IDENTIFICACION <> @p_IDENTIFICACION OR
                 @rowcur_DIGITOVERIFICACION <> @p_DIGITOVERIFICACION OR
                 @rowcur_CODREGIMEN <> @p_CODREGIMEN) BEGIN
                SET @p_flagRazonSocialModificada = 1;
              END 
            END 
          END 
        END;
      
    END;

    -- Segmento RutaPDV / FMR
      DECLARE @p_codFMR NUMERIC(22,0) = 0;
    BEGIN
      SELECT @p_codRutaPDV = ID_RUTAPDV, @p_codFMR = ISNULL(CODFMR, 0)
        FROM WSXML_SFG.RUTAPDV
       WHERE NOMRUTAPDV = RTRIM(LTRIM(@p_RUTA));
      -- Check if the FMR must be updated
        DECLARE @newcodFMR NUMERIC(22,0) = 0;
      BEGIN
        SELECT @newcodFMR = ID_FMR
          FROM WSXML_SFG.FMR
         WHERE CODIGOGTECHFMR = RTRIM(LTRIM(@p_CODIGOFMR));
        IF @newcodFMR <> @p_codFMR BEGIN
          UPDATE WSXML_SFG.RUTAPDV
             SET CODFMR = @newcodFMR
           WHERE ID_RUTAPDV = @p_codRutaPDV;
        END 
		IF @@ROWCOUNT = 0 BEGIN
				SET @p_CODIGOFMR = RTRIM(LTRIM(@p_CODIGOFMR))
			  EXEC WSXML_SFG.SFGFMR_AddFMRRecord @p_CODIGOFMR,
								  @p_FMR,
								  @p_CODUSUARIOMODIFICACION,
								  @newcodFMR OUT
			  UPDATE WSXML_SFG.RUTAPDV
				 SET CODFMR = @newcodFMR
			   WHERE ID_RUTAPDV = @p_codRutaPDV;
		END
      END;

		IF @@ROWCOUNT = 0 
		BEGIN
			BEGIN TRY
			
				BEGIN
				  SELECT @p_codFMR = ID_FMR
					FROM WSXML_SFG.FMR
				   WHERE CODIGOGTECHFMR = RTRIM(LTRIM(@p_CODIGOFMR));
					IF @@ROWCOUNT = 0 BEGIN
						SET @p_CODIGOFMR = RTRIM(LTRIM(@p_CODIGOFMR))
						EXEC WSXML_SFG.SFGFMR_AddFMRRecord @p_CODIGOFMR,
											@p_FMR,
											@p_CODUSUARIOMODIFICACION,
											@p_codFMR OUT
					END
				END;

				SET @p_RUTA = RTRIM(LTRIM(@p_RUTA))
				EXEC WSXML_SFG.SFGRUTAPDV_AddRecord @p_RUTA,
									 @p_codFMR,
									 @p_CODUSUARIOMODIFICACION,
									 @p_codRutaPDV OUT
			END TRY
			BEGIN CATCH

				SET  @tmpERROR = 'ecUNABLEROUTECREA No se pudo verificar la ruta: ' +
										ISNULL(ERROR_MESSAGE ( ), '');
				RAISERROR(@tmpERROR, 16, 1);
			END CATCH
		END
    END;


	SET @p_CODIGOFMR = RTRIM(LTRIM(@p_CODIGOFMR))
    --EXEC WSXML_SFG.SFGFMR_CheckUpdateRecordName @p_CODIGOFMR, @p_FMR

    -- Segmento Regional / Jefe Distrito
      DECLARE @p_codJefeDistrito NUMERIC(22,0) = 0;
    BEGIN
      SELECT @p_codRegional = ID_REGIONAL, @p_codJefeDistrito = ISNULL(CODJEFEDISTRITO, 0)
        FROM WSXML_SFG.REGIONAL
       WHERE NOMREGIONAL = @p_REGIONAL;
      -- Check if the Jefe Distrito must be updated
        DECLARE @newcodJefeDistrito NUMERIC(22,0) = 0;
      BEGIN
        SELECT @newcodJefeDistrito = ID_JEFEDISTRITO
          FROM WSXML_SFG.JEFEDISTRITO
         WHERE CODIGOGTECHJEFEDISTRITO = RTRIM(LTRIM(@p_CODIGOJEFEDISTRITO));
        IF @newcodJefeDistrito <> @p_codJefeDistrito BEGIN
          UPDATE WSXML_SFG.REGIONAL
             SET CODJEFEDISTRITO = @newcodJefeDistrito
           WHERE ID_REGIONAL = @p_codRegional;
        END 
		IF @@ROWCOUNT   = 0 BEGIN
			SET @p_CODIGOJEFEDISTRITO = RTRIM(LTRIM(@p_CODIGOJEFEDISTRITO))
			EXEC WSXML_SFG.SFGJEFEDISTRITO_AddJefeRecord @p_CODIGOJEFEDISTRITO,
										@p_JEFEDISTRITO,
										@p_CODUSUARIOMODIFICACION,
										@newcodJefeDistrito OUT
			UPDATE WSXML_SFG.REGIONAL
				SET CODJEFEDISTRITO = @newcodJefeDistrito
			WHERE ID_REGIONAL = @p_codRegional;
		END
      END;

		BEGIN TRY

			IF @@ROWCOUNT   = 0 
			BEGIN
			BEGIN
				SELECT @p_codJefeDistrito = ID_JEFEDISTRITO
				FROM WSXML_SFG.JEFEDISTRITO
				WHERE CODIGOGTECHJEFEDISTRITO = RTRIM(LTRIM(@p_CODIGOJEFEDISTRITO));
				IF @@ROWCOUNT  = 0 BEGIN
					DECLARE @l_CODIGOGTECH VARCHAR(2000) = RTRIM(LTRIM(@p_CODIGOJEFEDISTRITO))
					EXEC WSXML_SFG.SFGJEFEDISTRITO_AddJefeRecord @l_CODIGOGTECH,
													@p_JEFEDISTRITO,
													@p_CODUSUARIOMODIFICACION,
													@p_codJefeDistrito OUT
				END
			END;

			DEClARE @l_nombreregional varchar(2000) = RTRIM(LTRIM(@p_REGIONAL))
			EXEC WSXML_SFG.SFGREGIONAL_AddRecord   @l_nombreregional,
									@p_codJefeDistrito,
									@p_CODUSUARIOMODIFICACION,
									@p_codRegional OUT
			END
		END TRY
		BEGIN CATCH
		  
			SET @tmpERROR = 'ecUNABLEROUTECREA No se pudo verificar la regional: ' +
									ISNULL(ERROR_MESSAGE ( ) , '') ;
			RAISERROR(@tmpERROR, 16, 1);
			END CATCH
    END;

	 -- El procedimiento no existe
     --EXEC WSXML_SFG.SFGJEFEDISTRITO_CheckUpdateRecordName  RTRIM(LTRIM(@p_CODIGOJEFEDISTRITO)), @p_JEFEDISTRITO

    -- Segmento Red
    BEGIN
		BEGIN TRY
		  SELECT @p_codRedPDV = ID_REDPDV
			FROM WSXML_SFG.REDPDV
		   WHERE NOMREDPDV = @p_RED;
    
			-- Al procedimiento le hace falta un parametro: p_codcanalnegocio
		  --IF @@ROWCOUNT  = 0
		--EXEC WSXML_SFG.SFGREDPDV_AddRecord  @p_RED, @p_CODUSUARIOMODIFICACION, @p_codRedPDV OUT
		 END TRY
		 BEGIN CATCH
			SET @tmpERROR = 'ecUNABLENETWORKCR No se pudo verificar la red: ' + ISNULL(ERROR_MESSAGE ( ) , '');
			RAISERROR(@tmpERROR, 16, 1);
		 END CATCH
    END

    -- Obtencion de llave TipoNegocio
    BEGIN
		BEGIN TRY
		  SELECT @p_codTipoNegocio = ID_TIPONEGOCIO
			FROM WSXML_SFG.TIPONEGOCIO
		   WHERE NOMTIPONEGOCIO = @p_TIPONEGOCIO;
			if @@ROWCOUNT   = 0 BEGIN
				IF @p_TIPONEGOCIO IS NOT NULL BEGIN
				  EXEC WSXML_SFG.SFGTIPONEGOCIO_AddRecord @p_TIPONEGOCIO,
										   @p_CODUSUARIOMODIFICACION,
										   @p_codTipoNegocio OUT
				END 
			end
		END TRY
		BEGIN CATCH

			SET @tmpERROR = 'ecUNABLEBUSINESST No se pudo verificar el tipo de negocio: ' +
									ISNULL(ERROR_MESSAGE() , '');
			RAISERROR(@tmpERROR, 16, 1);
		END CATCH
    END;

    -- Obtencion de llave TipoEstacion
    BEGIN
		BEGIN TRY
		  SELECT @p_codTipoEstacion = ID_TIPOESTACION
			FROM WSXML_SFG.TIPOESTACION
		   WHERE NOMTIPOESTACION = @p_TIPOESTACION;
    
			IF @@ROWCOUNT  = 0 BEGIN
				IF @p_TIPOESTACION IS NOT NULL BEGIN
				  EXEC WSXML_SFG.SFGTIPOESTACION_AddRecord @p_TIPOESTACION,
											@p_CODUSUARIOMODIFICACION,
											@p_codTipoEstacion OUT
				END
			END 
		END TRY
		BEGIN CATCH
			SET @tmpERROR = 'ecUNABLESTATIONTY No se pudo verificar el tipo de estacion: ' +
									ISNULL(ERROR_MESSAGE ( ) , '');
			RAISERROR(@tmpERROR, 16, 1);
		END CATCH
    END;

    -- Obtencion de llave TipoTerminal
    BEGIN
		BEGIN TRY
		  SELECT @p_codTipoTerminal = ID_TIPOTERMINAL
			FROM WSXML_SFG.TIPOTERMINAL
		   WHERE NOMTIPOTERMINAL = @p_TIPOTERMINAL;
    
			IF @@ROWCOUNT   = 0 BEGIN
				IF @p_TIPOTERMINAL IS NOT NULL BEGIN
				  EXEC WSXML_SFG.SFGTIPOTERMINAL_AddRecord @p_TIPOTERMINAL,
											@p_CODUSUARIOMODIFICACION,
											@p_codTipoTerminal OUT
				END 
			END
		END TRY
		BEGIN CATCH
				SET @tmpERROR = 'ecUNABLETERMNTYPE No se pudo verificar el tipo de terminal: ' +
										ISNULL(ERROR_MESSAGE ( ) , '');
				RAISERROR(@tmpERROR, 16, 1);
		END CATCH
    END;

    -- Obtencion de llave PuertoTerminal
    BEGIN
		BEGIN TRY

		  SELECT @p_codPuertoTerminal = ID_PUERTOTERMINAL
			FROM WSXML_SFG.PUERTOTERMINAL
		   WHERE NOMPUERTOTERMINAL = @p_PUERTOTERMINAL;
	
			IF @@ROWCOUNT   = 0 BEGIN
				IF @p_PUERTOTERMINAL IS NOT NULL BEGIN
				  EXEC WSXML_SFG.SFGPUERTOTERMINAL_AddRecord   @p_PUERTOTERMINAL,
											  @p_CODUSUARIOMODIFICACION,
											  @p_codPuertoTerminal OUT
				END 
			END
		END TRY
		BEGIN CATCH
				SET @tmpERROR = 'ecUNABLEPRTTERMIN No se pudo crear la llave de puerto terminal: ' +
									 ISNULL(ERROR_MESSAGE ( ) , '');
				RAISERROR(@tmpERROR, 16, 1);

		END CATCH
			
			
    END;
  END;
  GO





  IF OBJECT_ID('WSXML_SFG.SFGCARGUEAGTINFO_InsertUpdatePuntoDeVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_InsertUpdatePuntoDeVenta;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_InsertUpdatePuntoDeVenta(@p_CODIGOGTECHPUNTODEVENTA  NVARCHAR(2000),
                                     @p_NUMEROTERMINAL           NUMERIC(22,0),
                                     @p_NOMPUNTODEVENTA          NVARCHAR(2000),
                                     @p_CODDANECIUDADPDV         NVARCHAR(2000),
                                     @p_TELEFONOPUNTODEVENTA     NVARCHAR(2000),
                                     @p_DIRECCIONPUNTODEVENTA    NVARCHAR(2000),
                                     @p_CODIGOGTECHRAZONSOCIAL   NUMERIC(22,0),
                                     @p_NOMBRERAZONSOCIAL        NVARCHAR(2000),
                                     @p_IDENTIFICACION           NUMERIC(22,0),
                                     @p_DIGITOVERIFICACION       NUMERIC(22,0),
                                     @p_CODDANECIUDADRAZONSOCIAL NVARCHAR(2000),
                                     @p_CODREGIMEN               NUMERIC(22,0),
                                     @p_NOMBRECONTACTO           NVARCHAR(2000),
                                     @p_EMAILCONTACTO            NVARCHAR(2000),
                                     @p_TELEFONOCONTACTO         NVARCHAR(2000),
                                     @p_DIRECCIONCONTACTO        NVARCHAR(2000),
                                     @p_RUTA                     NVARCHAR(2000),
                                     @p_CODIGOFMR                NVARCHAR(2000),
                                     @p_FMR                      NVARCHAR(2000),
                                     @p_REGIONAL                 NVARCHAR(2000),
                                     @p_CODIGOJEFEDISTRITO       NVARCHAR(2000),
                                     @p_JEFEDISTRITO             NVARCHAR(2000),
                                     @p_RED                      NVARCHAR(2000),
                                     @p_CODIGOGTECHCADENA        NVARCHAR(2000),
                                     @p_NOMBRECADENA             NVARCHAR(2000),
                                     @p_CODTIPOPUNTODEVENTA      NUMERIC(22,0),
                                     @p_ISCABEZA                 NUMERIC(22,0),
                                     @p_TIPONEGOCIO              NVARCHAR(2000),
                                     @p_TIPOESTACION             NVARCHAR(2000),
                                     @p_TIPOTERMINAL             NVARCHAR(2000),
                                     @p_PUERTOTERMINAL           NVARCHAR(2000),
                                     @p_NUMEROLINEA              NVARCHAR(2000),
                                     @p_NUMERODROP               NVARCHAR(2000),
                                     @p_NOMBRENODO               NVARCHAR(2000),
                                     @p_ADDRESSNODO              NVARCHAR(2000),
                                     @p_ACTIVE                   NUMERIC(22,0),
                                     @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                                     @p_ID_PUNTODEVENTA_out      NUMERIC(22,0) OUT) AS
 BEGIN
    SET NOCOUNT ON;
    -- Codigos de Foraneas
    DECLARE @newcodAgrupacionPuntoDeVenta NUMERIC(22,0);
    DECLARE @newcodRazonSocial            NUMERIC(22,0);
    DECLARE @newcodCiudadPDV              NUMERIC(22,0);
    DECLARE @newcodTipoEstacion           NUMERIC(22,0);
    DECLARE @newcodTipoNegocio            NUMERIC(22,0);
    DECLARE @newcodTipoTerminal           NUMERIC(22,0);
    DECLARE @newcodPuertoTerminal         NUMERIC(22,0);
    DECLARE @newcodRutaPDV                NUMERIC(22,0);
    DECLARE @newcodRedPDV                 NUMERIC(22,0);
    DECLARE @newcodRegional               NUMERIC(22,0);
    DECLARE @flagReglasCambioPlantilla    NUMERIC(22,0) = 0;
    DECLARE @flagActualizacion            NUMERIC(22,0) = 0;
    DECLARE @flagNuevoAgrupacion          NUMERIC(22,0) = 0;
    DECLARE @flagRazonSocialModificada    NUMERIC(22,0) = 0;
    DECLARE @tmpERROR                     NVARCHAR(2000);
    DECLARE @CANTCIUDAD                   NUMERIC(22,0);
    --DECLARE @exINVALIDASSIGN EXCEPTION;
    DECLARE @msg VARCHAR(2000)

    -- Verificar consistencias


	begin
	-- Call the procedure
		SET  @msg  =  'Sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '')
		EXEC WSXML_SFG.sfgtmptrace_tracelog @msg
	end;

    BEGIN
		DECLARE @l_COALESCE VARCHAR(2000) =  COALESCE(@p_NOMBRERAZONSOCIAL,@p_NOMPUNTODEVENTA)
      EXEC WSXML_SFG.SFGCARGUEAGTINFO_VerificarConsistencias 
							 @p_CODDANECIUDADPDV,
                             @p_CODIGOGTECHCADENA,
                             @p_NOMBRECADENA,
                             @p_CODTIPOPUNTODEVENTA,
                             @p_CODIGOGTECHRAZONSOCIAL,
                             @l_COALESCE,
                             @p_IDENTIFICACION,
                             @p_DIGITOVERIFICACION,
                             @p_CODDANECIUDADRAZONSOCIAL,
                             @p_CODREGIMEN,
                             @p_NOMBRECONTACTO,
                             @p_EMAILCONTACTO,
                             @p_TELEFONOCONTACTO,
                             @p_DIRECCIONCONTACTO,
                             @p_RUTA,
                             @p_CODIGOFMR,
                             @p_FMR,
                             @p_REGIONAL,
                             @p_CODIGOJEFEDISTRITO,
                             @p_JEFEDISTRITO,
                             @p_RED,
                             @p_TIPONEGOCIO,
                             @p_TIPOESTACION,
                             @p_TIPOTERMINAL,
                             @p_PUERTOTERMINAL,
                             @p_CODUSUARIOMODIFICACION,
                             @newcodCiudadPDV OUT,
                             @newcodAgrupacionPuntoDeVenta OUT,
                             @newcodRazonSocial OUT,
                             @newcodRutaPDV OUT,
                             @newcodRegional OUT,
                             @newcodRedPDV OUT,
                             @newcodTipoNegocio OUT,
                             @newcodTipoEstacion OUT,
                             @newcodTipoTerminal OUT,
                             @newcodPuertoTerminal OUT,
                             @flagNuevoAgrupacion OUT,
                             @flagRazonSocialModificada OUT
    END;

	begin
		-- Call the procedure
		SET @msg = 'Punto de venta verificado : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '')
		EXEC WSXML_SFG.sfgtmptrace_tracelog @msg;
	end;

    IF @p_NUMEROTERMINAL <= 0 AND @p_ACTIVE = 1 BEGIN
      RAISERROR('-20020 No se puede tener un punto de venta activo con terminal negativa', 16, 1);
    END 

    -- Realizar la insercion del punto de venta
      DECLARE @currentACTIVE NUMERIC(22,0);
    BEGIN

		  SELECT @p_ID_PUNTODEVENTA_out = ID_PUNTODEVENTA, @currentACTIVE = ACTIVE
			FROM WSXML_SFG.PUNTODEVENTA
		   WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA;
		  -- Asignar flag de actualizacion: Punto ya existente
		  SET @flagActualizacion = 1;
		  -- Verificar si cambia alguna de las reglas designadas para plantilla
			DECLARE @prevCODCIUDAD                 NUMERIC(22,0);
			DECLARE @prevCODAGRUPACIONPUNTODEVENTA NUMERIC(22,0);
			DECLARE @prevCODREDPDV                 NUMERIC(22,0);
			DECLARE @prevCODRAZONSOCIAL            NUMERIC(22,0);
		  BEGIN
			SELECT @prevCODCIUDAD = CODCIUDAD,
				   @prevCODAGRUPACIONPUNTODEVENTA = CODAGRUPACIONPUNTODEVENTA,
				   @prevCODREDPDV = CODREDPDV,
				   @prevCODRAZONSOCIAL = CODRAZONSOCIAL
					   FROM WSXML_SFG.PUNTODEVENTA
			 WHERE ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA_out;
			IF @prevCODCIUDAD <> @newcodCiudadPDV OR
			   @prevCODAGRUPACIONPUNTODEVENTA <> @newcodAgrupacionPuntoDeVenta OR
			   @prevCODREDPDV <> @newcodRedPDV BEGIN
			  SET @flagReglasCambioPlantilla = 1;
			END 
			IF @@ROWCOUNT = 0 BEGIN
					  SET @tmpERROR = 'ecNONEXISTANTCPDV El punto de venta ' +
											  ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +
											  ' no existe: ' + ISNULL(ERROR_MESSAGE ( ), '');
					  RAISERROR(@tmpERROR, 16, 1);
					END 
		  END;
		  -- Actualizar informacion
		  BEGIN
			BEGIN TRY

				DECLARE @p_TIPOINFORMATIVO TINYINT, @p_TIPOERROR TINYINT, @p_TIPOADVERTENCIA TINYINT,@p_TIPOCUALQUIERA TINYINT,
					@p_PROCESONOTIFICACION TINYINT, @p_ESTADOABIERTA TINYINT, @p_ESTADOCERRADA TINYINT
			
				EXEC WSXML_SFG.SFGALERTA_CONSTANT 
					@p_TIPOINFORMATIVO OUT, @p_TIPOERROR OUT, @p_TIPOADVERTENCIA OUT,
					@p_TIPOCUALQUIERA OUT, @p_PROCESONOTIFICACION OUT, @p_ESTADOABIERTA OUT,
					@p_ESTADOCERRADA OUT
				IF @currentACTIVE = 0 AND @p_ACTIVE = 1 BEGIN
					SET @msg =  'Se esta reactivando el punto de venta ' +  ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') + ' (' + FORMAT(GETDATE(), 'MON dd/yy HH:mm') + ')'
					EXEC WSXML_SFG.SFGALERTA_GenerarAlerta @p_TIPOINFORMATIVO, 'REACTIVAPDV', @msg , 1
				  COMMIT;
				END 
				EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord @p_ID_PUNTODEVENTA_out,
											 @p_CODIGOGTECHPUNTODEVENTA,
											 @p_NUMEROTERMINAL,
											 @p_NOMPUNTODEVENTA,
											 @newcodCiudadPDV,
											 @p_TELEFONOPUNTODEVENTA,
											 @p_DIRECCIONPUNTODEVENTA,
											 @p_CODREGIMEN,
											 @p_IDENTIFICACION,
											 @p_DIGITOVERIFICACION,
											 @newcodAgrupacionPuntoDeVenta,
											 @newcodRazonSocial,
											 @p_CODUSUARIOMODIFICACION,
											 @p_ACTIVE
				-- Si la cadena es nueva, actualizar cabeza de todas maneras
				IF @flagNuevoAgrupacion = 1 BEGIN
				  UPDATE WSXML_SFG.AGRUPACIONPUNTODEVENTA
					 SET CODPUNTODEVENTACABEZA = @p_ID_PUNTODEVENTA_out,
						 FECHAHORAMODIFICACION = GETDATE()
				   WHERE ID_AGRUPACIONPUNTODEVENTA = @newcodAgrupacionPuntoDeVenta;
				END 
			END TRY
			BEGIN CATCH
				begin
					SET @tmpERROR = 'Error sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +', Error:'+ ISNULL(@tmpERROR, '')
					-- Call the procedure
					EXEC WSXML_SFG.sfgtmptrace_tracelog @tmpERROR;
				end;
				SET @tmpERROR = 'ecUNABLEBASICDPDV No se pudo actualizar los datos basicos del punto de venta: ' +
											ISNULL(ERROR_MESSAGE ( ), '');
				RAISERROR(@tmpERROR, 16, 1);
			END CATCH
		  END;
		  -- Actualizacion de datos tecnicos y llaves
		  --Se cambio p_PUERTOTERMINAL de newp_PUERTOTERMINAL
		  BEGIN
				BEGIN TRY
				EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos @p_ID_PUNTODEVENTA_out,
													@newcodTipoNegocio,
													@newcodTipoEstacion,
													@newcodTipoTerminal,
													@newcodPuertoTerminal,
													@p_NUMEROLINEA,
													@p_NUMERODROP,
													@p_NOMBRENODO,
													@p_ADDRESSNODO,
													@newcodPuertoTerminal,
													@newcodRutaPDV,
													@newcodRegional,
													@newcodRedPDV,
													@p_CODUSUARIOMODIFICACION
				END TRY
				BEGIN CATCH
		
					   begin
						-- Call the procedure
							SET @tmpERROR = 'Error sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +', Error:'+ ISNULL(@tmpERROR, '')
						EXEC WSXML_SFG.sfgtmptrace_tracelog @tmpERROR 
					  end;
					SET @tmpERROR = 'ecUNABLETECHNCPDV No se pudo actualizar los datos tecnicos del punto de venta: ' +
										  ISNULL(ERROR_MESSAGE ( ), '')
				  RAISERROR(@tmpERROR, 16, 1);
				END CATCH
		  END;
		  -- Establecimiento de cabecera en la cadena
		  IF @p_ISCABEZA = 1
			BEGIN
				BEGIN TRY
				  EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateCabeza @newcodAgrupacionPuntoDeVenta, @p_ID_PUNTODEVENTA_out
				END TRY
				BEGIN CATCH
					
						begin
							-- Call the procedure
								SET @tmpERROR = 'Error sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +', Error:'+ ISNULL(@tmpERROR, '')
							EXEC WSXML_SFG.sfgtmptrace_tracelog @tmpERROR;
						  end;
						  SET @tmpERROR = 'ecUNABLEHEADCHAIN No se pudo actualizar la informacion de cabeza de la cadena: ' +
												ISNULL(ERROR_MESSAGE ( ), '')
						RAISERROR(@tmpERROR, 16, 1);
				END CATCH
			END;
		  
		IF @@ROWCOUNT = 0 
		BEGIN
			-- Insertar punto de venta
			BEGIN
				BEGIN TRY
				  EXEC WSXML_SFG.SFGPUNTODEVENTA_AddRecord @p_CODIGOGTECHPUNTODEVENTA,
											@p_NUMEROTERMINAL,
											@p_NOMPUNTODEVENTA,
											@newcodCiudadPDV,
											@p_TELEFONOPUNTODEVENTA,
											@p_DIRECCIONPUNTODEVENTA,
											@p_CODREGIMEN,
											@p_IDENTIFICACION,
											@p_DIGITOVERIFICACION,
											@newcodAgrupacionPuntoDeVenta,
											@newcodRazonSocial,
											@p_ACTIVE,
											@p_CODUSUARIOMODIFICACION,
											@p_ID_PUNTODEVENTA_out OUT
				  -- Si la cadena es nueva, actualizar cabeza de todas maneras
				  IF @flagNuevoAgrupacion = 1 BEGIN
					UPDATE WSXML_SFG.AGRUPACIONPUNTODEVENTA
					   SET CODPUNTODEVENTACABEZA = @p_ID_PUNTODEVENTA_out,
						   FECHAHORAMODIFICACION = GETDATE()
					 WHERE ID_AGRUPACIONPUNTODEVENTA = @newcodAgrupacionPuntoDeVenta;
				  END 
				END TRY
				BEGIN CATCH
					SET @tmpERROR = 'Error sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +', Error:'+ ISNULL(ERROR_MESSAGE ( ), '');
					begin
						-- Call the procedure
						EXEC WSXML_SFG.sfgtmptrace_tracelog tmpERROR
					  end;
					  SET @tmpERROR ='ecUNABLEBASICDPDV No se pudo insertar los datos basicos del punto de venta: ' +
											ISNULL(ERROR_MESSAGE ( ), '')
					RAISERROR(@tmpERROR, 16, 1);
				END CATCH
			END;
			-- Actualizacion de datos tecnicos y llaves
			BEGIN
				BEGIN TRY
				  EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos @p_ID_PUNTODEVENTA_out,
													  @newcodTipoNegocio,
													  @newcodTipoEstacion,
													  @newcodTipoTerminal,
													  @newcodPuertoTerminal,
													  @p_NUMEROLINEA,
													  @p_NUMERODROP,
													  @p_NOMBRENODO,
													  @p_ADDRESSNODO,
													  '0',
													  @newcodRutaPDV,
													  @newcodRegional,
													  @newcodRedPDV,
													  @p_CODUSUARIOMODIFICACION
				END TRY
				BEGIN CATCH
					SET @tmpERROR = 'Error sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +', Error:'+ ISNULL(ERROR_MESSAGE ( ), '');
					begin
						-- Call the procedure
						EXEC WSXML_SFG.sfgtmptrace_tracelog @tmpERROR
					  end;
					SET @tmpERROR = 'ecUNABLETECHNCPDV No se pudo actualizar los datos tecnicos del punto de venta: ' +
											ISNULL(ERROR_MESSAGE ( ), '')
					RAISERROR(@tmpERROR, 16, 1);
				END CATCH
			END;
			-- Establecimiento de cabecera en la cadena
			IF @p_ISCABEZA = 1
			  BEGIN
				BEGIN TRY
					EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateCabeza @newcodAgrupacionPuntoDeVenta, @p_ID_PUNTODEVENTA_out
				END TRY
				BEGIN CATCH
					  SET @tmpERROR = 'Error sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +', Error:'+ ISNULL(ERROR_MESSAGE ( ), '');
					  begin
						-- Call the procedure
						EXEC WSXML_SFG.sfgtmptrace_tracelog @tmpERROR
					  end;
					  SET @tmpERROR = 'ecUNABLEHEADCHAIN No se pudo actualizar la informacion de cabeza de la cadena: ' +
											  ISNULL(ERROR_MESSAGE ( ), '')
					  RAISERROR(@tmpERROR, 16, 1);
				END CATCH
			  END;
        END
    END;

    /* TRAMPA DE PLANTILLAS. Aplica cuando es nuevo, o actualizado y ha cambiado alguna de las reglas de plantillas */
    IF (@flagActualizacion = 0 OR
       (@flagActualizacion = 1 AND @flagReglasCambioPlantilla = 1))
      BEGIN
		BEGIN TRY
			DECLARE tLDN CURSOR FOR SELECT ID_LINEADENEGOCIO
						   FROM WSXML_SFG.LINEADENEGOCIO
						  WHERE ACTIVE = 1; OPEN tLDN;
			 DECLARE @TLDN_ID_LINEADENEGOCIO NUMERIC(38,0)
			 FETCH NEXT FROM tLDN INTO @TLDN_ID_LINEADENEGOCIO
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				DECLARE @cCODLDN       NUMERIC(22,0) = @TLDN_ID_LINEADENEGOCIO
				DECLARE @cCODPLANTILLA NUMERIC(22,0) = 0;
				DECLARE @cPDVPLANT_out NUMERIC(22,0);
				DECLARE @cCIUDADBUSCA  NUMERIC(22,0) = @newcodCiudadPDV;
				DECLARE @cCADENABUSCA  NUMERIC(22,0) = @newcodAgrupacionPuntoDeVenta;
				DECLARE @cREDPDVBUSCA  NUMERIC(22,0) = @newcodRedPDV;
			  BEGIN
				-- Buscar por orden y peso de criterios. Ciudad, Agrupacion, Red
				BEGIN
					BEGIN TRY
					  -- Criterio 1. Ciudad, Cadena y Red
					  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
						FROM WSXML_SFG.PLANTILLAPRODUCTO P, WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
					   WHERE C.CODPLANTILLAPRODUCTO = P.ID_PLANTILLAPRODUCTO
						 AND P.CODLINEADENEGOCIO = @cCODLDN
						 AND C.CODCIUDAD = @cCIUDADBUSCA
						 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA
						 AND P.CODREDPDV = @cREDPDVBUSCA;
					END TRY
					BEGIN CATCH
						BEGIN
							BEGIN TRY
						  -- Criterio 2. Cadena y Red
							  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
								FROM WSXML_SFG.PLANTILLAPRODUCTO P
							   WHERE P.CODLINEADENEGOCIO = @cCODLDN
								 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA
								 AND P.CODREDPDV = @cREDPDVBUSCA;

								IF @cCODPLANTILLA > 0 BEGIN

							SELECT @CANTCIUDAD = COUNT(*)
							  FROM WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
							 WHERE C.CODPLANTILLAPRODUCTO = @cCODPLANTILLA;

							IF @CANTCIUDAD > 0 BEGIN
							  RAISERROR('CANTCIUDAD > 0', 16, 1);
							END 

						  END 
							END TRY
							BEGIN CATCH
								-- Criterio 3. Cadena
								BEGIN
								BEGIN TRY
								  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
									FROM WSXML_SFG.PLANTILLAPRODUCTO P
								   WHERE P.CODLINEADENEGOCIO = @cCODLDN
									 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA;

								  IF @cCODPLANTILLA > 0 BEGIN

									SELECT @CANTCIUDAD = COUNT(*)
									  FROM WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
									 WHERE C.CODPLANTILLAPRODUCTO = @cCODPLANTILLA;

									IF @CANTCIUDAD > 0 BEGIN
									  RAISERROR('CANTCIUDAD > 0', 16, 1);
									END 

								  END 
								END TRY
								BEGIN CATCH
									BEGIN
									BEGIN TRY
									  -- Criterio 4. Red
									  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
										FROM WSXML_SFG.PLANTILLAPRODUCTO P
									   WHERE P.CODLINEADENEGOCIO = @cCODLDN
										 AND P.CODREDPDV = @cREDPDVBUSCA;

									  IF @cCODPLANTILLA > 0 BEGIN

										SELECT @CANTCIUDAD = COUNT(*)
										  FROM WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
										 WHERE C.CODPLANTILLAPRODUCTO = @cCODPLANTILLA;

										IF @CANTCIUDAD > 0 BEGIN
										  RAISERROR('CANTCIUDAD > 0', 16, 1);
										END 

									  END 
									END TRY
									BEGIN CATCH
										-- Default. Plantilla Master
										BEGIN
											BEGIN TRY
											  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
												FROM WSXML_SFG.PLANTILLAPRODUCTO P
											   WHERE P.CODLINEADENEGOCIO =
													 @cCODLDN
												 AND P.MASTERPLANTILLA = 1;
											END TRY
											BEGIN CATCH
												SET @msg = '-20054 No existe plantilla master unica configurada para la linea de negocio ' +ISNULL(WSXML_SFG.LINEADENEGOCIO_NOMBRE_F(@cCODLDN), '')
												RAISERROR(@msg, 16, 1);
											END CATCH
										END;
										-- NO SE VINCULARA LA PLANTILLA MASTER: LA PREFACTURACION LA BUSCA POR DEFECTO
										SET @cCODPLANTILLA = 0;
									END CATCH
								END;
							
								END CATCH
							END;
							END CATCH
					   END;
					END CATCH
				END;
				-- Si se encontro plantilla para asignar
				IF @cCODPLANTILLA > 0 BEGIN
				  -- Si se esta cambiando la plantilla, desactivar primero
				  EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_DeactivateRecordByData @p_ID_PUNTODEVENTA_out,
																  @cCODLDN,
																  1
				  EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_AddRecord @p_ID_PUNTODEVENTA_out,
													 @cCODPLANTILLA,
													 NULL,
													 NULL,
													 NULL,
													 @p_CODUSUARIOMODIFICACION,
													 @cPDVPLANT_out OUT
				END 
			  END;
			FETCH NEXT FROM tLDN INTO @TLDN_ID_LINEADENEGOCIO
			END;
			CLOSE tLDN;
			DEALLOCATE tLDN;
		
		END TRY
		BEGIN CATCH
          BEGIN
		  
            SET @msg = ERROR_MESSAGE ( );
            SET @msg = isnull(@msg, '') + '. Trampa de plantilla para PDV: ' +
                   ISNULL(WSXML_SFG.PUNTODEVENTA_CODIGO_F(@p_ID_PUNTODEVENTA_out), '');
            EXEC WSXML_SFG.sfgtmptrace_tracelog_1 @msg, 'CARGUEAGTINFO_TEMPLATE_INS'
          END;
		END CATCH
	  END;
    

    /* MANTENER BALANCE DE RAZON SOCIAL PARA LAS CADENAS */
    IF @newcodAgrupacionPuntoDeVenta <> WSXML_SFG.AGRUPACION_F(0) BEGIN
      UPDATE WSXML_SFG.PUNTODEVENTA
         SET CODRAZONSOCIAL = @newcodRazonSocial
       WHERE CODAGRUPACIONPUNTODEVENTA = @newcodAgrupacionPuntoDeVenta;
    END 

    /* Antiguo Balance NIT / Regimen, Controlado ahora mediante Razon Social */
      DECLARE @maxCODREGIMEN     NUMERIC(22,0);
      DECLARE @minCODREGIMEN     NUMERIC(22,0);
      DECLARE @maxIDENTIFICACION NUMERIC(22,0);
      DECLARE @minIDENTIFICACION NUMERIC(22,0);
    BEGIN
		BEGIN TRY
		  SELECT @maxCODREGIMEN = MAX(CODREGIMEN),
				 @minCODREGIMEN = MIN(CODREGIMEN),
				 @maxIDENTIFICACION = MAX(IDENTIFICACION),
				 @minIDENTIFICACION = MIN(IDENTIFICACION)
				   FROM WSXML_SFG.PUNTODEVENTA
		   WHERE CODRAZONSOCIAL = @newcodRazonSocial;
		  -- previous agents exist
		  IF @maxCODREGIMEN IS NOT NULL AND @minCODREGIMEN IS NOT NULL AND
			 @maxIDENTIFICACION IS NOT NULL AND @minIDENTIFICACION IS NOT NULL BEGIN
			IF @maxCODREGIMEN <> @p_CODREGIMEN OR @minCODREGIMEN <> @p_CODREGIMEN OR
			   @maxIDENTIFICACION <> @p_IDENTIFICACION OR
			   @minIDENTIFICACION <> @p_IDENTIFICACION BEGIN
			  UPDATE WSXML_SFG.PUNTODEVENTA
				 SET CODREGIMEN            = @p_CODREGIMEN,
					 IDENTIFICACION        = @p_IDENTIFICACION,
					 DIGITOVERIFICACION    = @p_DIGITOVERIFICACION,
					 FECHAHORAMODIFICACION = GETDATE()
			   WHERE CODRAZONSOCIAL = @newcodRazonSocial;
			END 
		  END 
		END TRY
		BEGIN CATCH
			
			SELECT NULL; -- El NIT no existe aun
		END CATCH
    END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCARGUEAGTINFO_SetRazonSocialContrato', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_SetRazonSocialContrato;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_SetRazonSocialContrato(@p_CODPUNTODEVENTA            NUMERIC(22,0),
                                   @p_CODIGOGTECHSERVICIO        NUMERIC(22,0),
                                   @p_CODIGOCOMPANIA             NVARCHAR(2000),
                                   @p_CODTIPOCONTRATOPDV         NUMERIC(22,0),
                                   @p_NUMEROCONTRATO             NVARCHAR(2000),
                                   @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                                   @p_ID_RAZONSOCIALCONTRATO_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @cCODRAZONSOCIAL NUMERIC(22,0);
    DECLARE @cCODSERVICIO    NUMERIC(22,0);
    DECLARE @cCODCOMPANIA    NUMERIC(22,0);
   
  SET NOCOUNT ON;
	BEGIN TRY
		SELECT @cCODRAZONSOCIAL = CODRAZONSOCIAL
		  FROM WSXML_SFG.PUNTODEVENTA
		 WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
		SELECT @cCODSERVICIO = ID_SERVICIO
		  FROM WSXML_SFG.SERVICIO
		 WHERE ORDEN = @p_CODIGOGTECHSERVICIO;
		SELECT @cCODCOMPANIA = ID_COMPANIA
		  FROM WSXML_SFG.COMPANIA
		 WHERE CODIGO = @p_CODIGOCOMPANIA;
		 
		EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato @cCODRAZONSOCIAL,
								   @cCODSERVICIO,
								   @cCODCOMPANIA,
								   @p_CODTIPOCONTRATOPDV,
								   @p_NUMEROCONTRATO,
								   @p_CODUSUARIOMODIFICACION,
								   @p_ID_RAZONSOCIALCONTRATO_out OUT
	END TRY
	BEGIN CATCH
      RAISERROR('ecERRORPDVRETURNV Error al ingresar los contratos para el punto de venta', 16, 1);
	END CATCH
  END;
GO

  
  IF OBJECT_ID('WSXML_SFG.SFGCARGUEAGTINFO_GETPUNTOSDEVENTA', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_GETPUNTOSDEVENTA;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCARGUEAGTINFO_GETPUNTOSDEVENTA  AS

    BEGIN
    SET NOCOUNT ON;

   SELECT isnull(PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA,0) as CODIGOGTECHPUNTODEVENTA,
       PUNTODEVENTA.NUMEROTERMINAL,
       PUNTODEVENTA.NOMPUNTODEVENTA,
       CIUDAD.CIUDADDANE,
       isnull(PUNTODEVENTA.TELEFONO,0) as TELEFONO,
       isnull(PUNTODEVENTA.DIRECCION,'') as DIRECCION ,
       isnull(RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL,0) as CODIGOGTECHRAZONSOCIAL,
       isnull(RAZONSOCIAL.NOMRAZONSOCIAL,'') as NOMRAZONSOCIAL,
       isnull(RAZONSOCIAL.IDENTIFICACION,0) as IDENTIFICACION,
       isnull(RZCIUDAD.CIUDADDANE,'') AS CIUDAD_RAZON_SOCIAL,
       isnull(RAZONSOCIAL.CODREGIMEN,0) AS REGIMEN_RAZONSOCIAL,
       isnull(RAZONSOCIAL.NOMBRECONTACTO,'') AS NOMBRECONTACTO_RAZONSOCIAL,
       isnull(RAZONSOCIAL.EMAILCONTACTO,'') AS EMAILCONTACTO_RAZONSOCIAL,
       isnull(RAZONSOCIAL.TELEFONOCONTACTO,0) AS TELEFONOCONTACTO_RAZONSOCIAL,
       isnull(RAZONSOCIAL.DIRECCIONCONTACTO,'') AS DIRECCIONCONTACTO_RAZONSOCIAL,
       isnull(RUTAPDV.NOMRUTAPDV,'') as NOMRUTAPDV,
       isnull(FMR.CODIGOGTECHFMR,0) AS CODIGOFMR,
       isnull(FMR.NOMFMR,'') AS NOMBREFMR,
       isnull(REGIONAL.NOMREGIONAL,'') as NOMREGIONAL,
       isnull(JEFEDISTRITO.CODIGOGTECHJEFEDISTRITO,'') AS JEFEDISTRITO,
       isnull(JEFEDISTRITO.NOMJEFEDISTRITO,'') AS NOMBREJEFEDSITRITO,
       isnull(REDPDV.NOMREDPDV,'') AS NOMBREREDPDV,
       isnull(AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,0) AS CODIGOCADENA,
       isnull(AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,'') AS NOMBRECADENA,
       isnull(AGRUPACIONPUNTODEVENTA.CODTIPOPUNTODEVENTA,0) AS CODTIPOPUNTODEVENTA,
       CASE WHEN PUNTODEVENTA.ID_PUNTODEVENTA = AGRUPACIONPUNTODEVENTA.CODPUNTODEVENTACABEZA THEN 1 ELSE 0 END AS ES_CABEZA,
        isnull(TIPONEGOCIO.NOMTIPONEGOCIO,'') as NOMTIPONEGOCIO,
        isnull(TIPOESTACION.NOMTIPOESTACION,'') as NOMTIPOESTACION,
        isnull(TIPOTERM.NOMTIPOTERMINAL,'') as NOMTIPOTERMINAL,
         --PUNTODEVENTA.PUERTOESTACION,
        isnull(PUERTOTERMINAL.NOMPUERTOTERMINAL,'') as NOMPUERTOTERMINAL,
        isnull(PUNTODEVENTA.NUMEROLINEA,0) as NUMEROLINEA,
        isnull(PUNTODEVENTA.NUMERODROP,0) as NUMERODROP,
        isnull(PUNTODEVENTA.NOMBRENODO,'') as NOMBRENODO,
        isnull(PUNTODEVENTA.ADDRESSNODO,'') AS ADDRESSNODO,
     CASE WHEN PUNTODEVENTA.Active = 1 THEN 'A' ELSE 'I' END AS FLAGESTADO
        FROM WSXML_SFG.PUNTODEVENTA
        INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        LEFT OUTER JOIN WSXML_SFG.RUTAPDV ON PUNTODEVENTA.CODRUTAPDV = RUTAPDV.ID_RUTAPDV
        LEFT OUTER JOIN WSXML_SFG.FMR ON RUTAPDV.CODFMR = FMR.ID_FMR
        LEFT OUTER JOIN WSXML_SFG.REGIONAL ON PUNTODEVENTA.CODREGIONAL = REGIONAL.ID_REGIONAL
        LEFT OUTER JOIN WSXML_SFG.JEFEDISTRITO ON REGIONAL.CODJEFEDISTRITO = JEFEDISTRITO.ID_JEFEDISTRITO
        LEFT OUTER JOIN WSXML_SFG.REDPDV ON PUNTODEVENTA.CODREDPDV = REDPDV.ID_REDPDV
        LEFT OUTER JOIN WSXML_SFG.TIPONEGOCIO ON PUNTODEVENTA.CODTIPONEGOCIO = TIPONEGOCIO.ID_TIPONEGOCIO
       /* LEFT OUTER JOIN TIPOTERMINAL ON PUNTODEVENTA.CODTIPOTERMINAL = TIPOTERMINAL.ID_TIPOTERMINAL*/
        LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL ON PUNTODEVENTA.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        LEFT OUTER JOIN WSXML_SFG.CIUDAD ON PUNTODEVENTA.CODCIUDAD = CIUDAD.ID_CIUDAD
        LEFT OUTER JOIN WSXML_SFG.CIUDAD RZCIUDAD ON RAZONSOCIAL.CODCIUDAD = RZCIUDAD.ID_CIUDAD
        LEFT OUTER JOIN WSXML_SFG.TIPOESTACION ON PUNTODEVENTA.CODTIPOESTACION = TIPOESTACION.ID_TIPOESTACION
        LEFT OUTER JOIN WSXML_SFG.TIPOTERMINAL TIPOTERM ON PUNTODEVENTA.CODTIPOTERMINAL = TIPOTERM.ID_TIPOTERMINAL
        LEFT OUTER JOIN WSXML_SFG.PUERTOTERMINAL ON PUNTODEVENTA.CODPUERTOTERMINAL = PUERTOTERMINAL.ID_PUERTOTERMINAL;

END
GO


