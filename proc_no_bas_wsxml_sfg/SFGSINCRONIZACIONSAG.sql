USE SFGPRODU;
--  DDL for Package Body SFGSINCRONIZACIONSAG
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGSINCRONIZACIONSAG */ 


  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePuntoDeVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePuntoDeVenta;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePuntoDeVenta(@p_CODIGOGTECHPUNTODEVENTA NVARCHAR(2000),
                                     @p_NUMEROTERMINAL          NUMERIC(22,0),
                                     @p_NOMPUNTODEVENTA         NVARCHAR(2000),
                                     @p_CODDANECIUDADPDV        NVARCHAR(2000),
                                     @p_CODDANEDEPTOPDV         NVARCHAR(2000),
                                     @p_TELEFONOPUNTODEVENTA    NVARCHAR(2000),
                                     @p_DIRECCIONPUNTODEVENTA   NVARCHAR(2000),
                                     @p_CODIGOGTECHRAZONSOCIAL  NUMERIC(22,0),
                                     @p_IDENTIFICACION          NUMERIC(22,0),
                                     @p_DIGITOVERIFICACION      NUMERIC(22,0),
                                     @p_RUTA                    NVARCHAR(2000),
                                     @p_CODIGOGTECHCADENA       NVARCHAR(2000),
                                     @p_TIPONEGOCIO             NVARCHAR(2000),
                                     @p_TIPOESTACION            NVARCHAR(2000),
                                     @p_TIPOTERMINAL            NVARCHAR(2000),
                                     @p_PUERTOTERMINAL          NVARCHAR(2000),
                                     @p_NUMEROLINEA             NVARCHAR(2000),
                                     @p_NUMERODROP              NVARCHAR(2000),
                                     @p_NOMBRENODO              NVARCHAR(2000),
                                     @p_ADDRESSNODO             NVARCHAR(2000),
                                     @p_ACTIVE                  NUMERIC(22,0)) AS
 BEGIN
  
    -- Codigos de Foraneas
    DECLARE @vCOUNT   INT;
    DECLARE @MSGERROR VARCHAR(8000);
  
   -- vDANECOMPLETO    NVARCHAR2(5);
    DECLARE @vID_CIUDAD         NUMERIC(22,0);
    DECLARE @vID_DEPARTAMENTO   NUMERIC(22,0);
    DECLARE @vID_RAZONSOCIAL    NUMERIC(22,0);
    DECLARE @vID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0);
    DECLARE @vDIGITOVERIFICACION NUMERIC(22,0);
    DECLARE @vCODRAZONSOCIAL_SFG NUMERIC(22,0);
    DECLARE @vCODREGIMEN         NUMERIC(22,0);
    DECLARE @vID_PUNTODEVENTA    NUMERIC(22,0);
    DECLARE @vID_RUTAPDV         NUMERIC(22,0);
    DECLARE @vID_PUNTODEVENTA_out  NUMERIC(22,0);
    DECLARE @vCODREGIONAL        NUMERIC(22,0);     
    DECLARE @vCODREDPDV          NUMERIC(22,0);
    DECLARE @vCODTIPOPUNTODEVENTA NUMERIC(22,0);
    DECLARE @vID_TIPOESTACION    NUMERIC(22,0);
    DECLARE @vID_TIPONEGOCIO     NUMERIC(22,0);
    DECLARE @vID_TIPOTERMINAL    NUMERIC(22,0);
    DECLARE @vID_PUERTOTERMINAL  NUMERIC(22,0);
    
    
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
    --exINVALIDASSIGN              EXCEPTION;
	DECLARE @msg VARCHAR(2000)
  
   
  SET NOCOUNT ON;
    --Verificando consistencias 
	SET @msg = 'Sincronizando punto de venta : ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '')
    EXEC WSXML_SFG.sfgtmptrace_tracelog @msg;
    
    
--    vDANECOMPLETO := p_CODDANEDEPTOPDV || p_CODDANECIUDADPDV;
    
    
  
    --Obtencion del Id de la ciudad
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDADDANE = @p_CODDANECIUDADPDV;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = 'No se puede crear el punto de venta ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                  ' por que no existe el codigo ciudad dane ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODDANECIUDADPDV), '');
      RAISERROR(-20000, @MSGERROR, 16, 1);
    END 
  
    SELECT @vID_CIUDAD = ID_CIUDAD
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDADDANE = @p_CODDANECIUDADPDV;

  
    
    --Obtencion de la Razon Social
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = 'No se puede crear el punto de venta ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                  ' por que el no existe la razonsocial con el codigo  ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '');
    
      RAISERROR(-20000, @MSGERROR, 16, 1);
    END       

      SELECT @vID_RAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL, @vDIGITOVERIFICACION = RAZONSOCIAL.DIGITOVERIFICACION
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
    
    --Obtencion del Id Regimen
        
    SELECT @vCODREGIMEN = CODREGIMEN 
     FROM WSXML_SFG.RAZONSOCIAL
    WHERE ID_RAZONSOCIAL= @vID_RAZONSOCIAL;
    
    
    IF @vCODREGIMEN IS NULL OR @vCODREGIMEN= '' BEGIN
      SET @vCODREGIMEN =1; 
    END 
    
   --Obtencion del Id de Tipo de estacion
     SELECT @vCOUNT = COUNT(1) 
     FROM WSXML_SFG.TIPOESTACION
    WHERE NOMTIPOESTACION = @p_TIPOESTACION;
    
   IF @vCOUNT = 0 BEGIN
    
      SET @vID_TIPOESTACION=NULL;
   END
   ELSE BEGIN 
      SELECT @vID_TIPOESTACION = ID_TIPOESTACION
       FROM WSXML_SFG.TIPOESTACION 
      WHERE NOMTIPOESTACION = @p_TIPOESTACION;      
    END   
    

   
   --Obtencion del tipo de negocio
  SELECT @vCOUNT = COUNT(1)
   FROM WSXML_SFG.TIPONEGOCIO
  WHERE NOMTIPONEGOCIO= @p_TIPONEGOCIO;
  
  
  IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = 'No se puede crear el punto de venta ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                  ' por que no existe el tipo de negocio con el nombre  ' +
                  ISNULL(CONVERT(VARCHAR, @p_TIPONEGOCIO), '');
    
      RAISERROR(-20000, @MSGERROR, 16, 1);
    END 
    
    
  SELECT @vID_TIPONEGOCIO = ID_TIPONEGOCIO
   FROM WSXML_SFG.TIPONEGOCIO
  WHERE NOMTIPONEGOCIO= @p_TIPONEGOCIO;
  
  --Obtencion del tipo de terminal
  SELECT @vCOUNT = COUNT(1)
   FROM WSXML_SFG.TIPOTERMINAL
  WHERE NOMTIPOTERMINAL= @p_TIPOTERMINAL;
  
  IF @vCOUNT = 0 BEGIN
     -- MSGERROR := 'No se puede crear el punto de venta ' ||
     --             TO_CHAR(p_CODIGOGTECHPUNTODEVENTA) ||
     --             ' por que no existe el tipo de terminal con el nombre  ' ||
     --             TO_CHAR(p_TIPOTERMINAL);
     
    
      --RAISE_APPLICATION_ERROR(-20000, MSGERROR);
      SET @vID_TIPOTERMINAL= 1;
    END
    ELSE BEGIN
        SELECT @vID_TIPOTERMINAL = ID_TIPOTERMINAL
         FROM WSXML_SFG.TIPOTERMINAL
        WHERE NOMTIPOTERMINAL = @p_TIPOTERMINAL;   
       
    END 
  
  

  
  --Obtencion del Id del puerto terminal
  
  SELECT @vCOUNT = COUNT(1)
   FROM WSXML_SFG.PUERTOTERMINAL
  WHERE NOMPUERTOTERMINAL = @p_PUERTOTERMINAL;
  
   IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = 'No se puede crear el punto de venta ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                  ' por que no existe el puerto terminal con el nombre  ' +
                  ISNULL(CONVERT(VARCHAR, @p_PUERTOTERMINAL), '');
    
      RAISERROR(-20000, @MSGERROR, 16, 1);
    END 
  
  SELECT @vID_PUERTOTERMINAL = ID_PUERTOTERMINAL
   FROM WSXML_SFG.PUERTOTERMINAL
  WHERE NOMPUERTOTERMINAL = @p_PUERTOTERMINAL;
  
                                     
                                     
                                     
   --Obtencion del Id de Ruta Pdv
    SELECT @vCOUNT = COUNT(1) 
    FROM WSXML_SFG.RUTAPDV 
    WHERE NOMRUTAPDV = @p_RUTA;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = 'No se puede crear el punto de venta ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                  ' por que no existe una ruta con el nombre  ' +
                  ISNULL(CONVERT(VARCHAR, @p_RUTA), '');
    
      RAISERROR(-20000, @MSGERROR, 16, 1);
    END 
    
    SELECT @vID_RUTAPDV = ID_RUTAPDV, @vCODREGIONAL = CODREGIONAL 
     FROM WSXML_SFG.RUTAPDV 
    WHERE NOMRUTAPDV = @p_RUTA;
         
    
    
    --Obtencion del id de la cadena
    
    SELECT @vCOUNT = COUNT(1)
    FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
    WHERE AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH = @p_CODIGOGTECHCADENA;
    
    IF @vCOUNT =0 BEGIN 
        SET @MSGERROR = 'No se puede crear el punto de venta ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                  ' por que no existe una cadena con el codigo ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHCADENA), '');
    
      RAISERROR(-20000, @MSGERROR, 16, 1);
    END 
    
    SELECT @vID_AGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA, @vCODREDPDV = CODREDPDV , @vCODTIPOPUNTODEVENTA = CODTIPOPUNTODEVENTA
     FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA 
    WHERE AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH = @p_CODIGOGTECHCADENA;
    
    --Verficar que la cadena  pertenezca a una razon social
    
    IF @vCODTIPOPUNTODEVENTA <>3 BEGIN 
          SELECT @vCOUNT = COUNT(DISTINCT CODRAZONSOCIAL) 
          FROM WSXML_SFG.puntodeventa
          WHERE  CODAGRUPACIONPUNTODEVENTA= @vID_AGRUPACIONPUNTODEVENTA ;
          
          IF @vCOUNT >=2 BEGIN
           SET @MSGERROR = 'No se puede crear el punto de venta ' +
                        ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHPUNTODEVENTA), '') +
                        ' por que la cadena enviada tiene mas de una razon social asociada. Codigo de la cadena ' +
                        ISNULL(CONVERT(VARCHAR, @vID_AGRUPACIONPUNTODEVENTA), '');  
        /*   RAISE_APPLICATION_ERROR(-20000, MSGERROR);
          ELSE
            IF vCOUNT=1 THEN
              --COMPARO LA RAZON SOCIAL EXISTENTE CON LA QUE VIENE DE SAG
              
              
              SELECT CODRAZONSOCIAL
               INTO vCODRAZONSOCIAL_SFG
               FROM PUNTODEVENTA
              WHERE  CODAGRUPACIONPUNTODEVENTA= vID_AGRUPACIONPUNTODEVENTA AND rownum<=1;
              
              IF  vCODRAZONSOCIAL_SFG <> vID_RAZONSOCIAL THEN
                   vID_RAZONSOCIAL:=  vCODRAZONSOCIAL_SFG;      
              END IF;
          
            END IF;*/
          END 
       END   
    
    
    --Verificar la existencia del punto de venta
    SELECT @vCOUNT = COUNT(1)
     FROM WSXML_SFG.PUNTODEVENTA
    WHERE CODIGOGTECHPUNTODEVENTA= @p_CODIGOGTECHPUNTODEVENTA;
    
    IF @vCOUNT =0 BEGIN
       -- Creacion de punto de venta 
		EXEC WSXML_SFG.SFGPUNTODEVENTA_AddRecord 
										@p_CODIGOGTECHPUNTODEVENTA, 
                                    @p_NUMEROTERMINAL,
                                    @p_NOMPUNTODEVENTA,
                                    @vID_CIUDAD,
                                    @p_TELEFONOPUNTODEVENTA,
                                    @p_DIRECCIONPUNTODEVENTA,
                                    @vCODREGIMEN,
                                    @p_IDENTIFICACION,
                                    @vDIGITOVERIFICACION,
                                    @vID_AGRUPACIONPUNTODEVENTA,
                                    @vID_RAZONSOCIAL,
                                    1/*dueno terminal*/,
                                    0/*dueno de punto de venta IGT*/,
                                    NULL,--codigo externo de punto de venta 
                                    @p_ACTIVE,
                                    1,
                                    @vID_PUNTODEVENTA_out OUT
    END
    ELSE BEGIN
      --Obtengo el id del punto de venta
       SELECT @vID_PUNTODEVENTA = ID_PUNTODEVENTA
        FROM WSXML_SFG.PUNTODEVENTA
       WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA;
    
      -- Modificacion de punto de venta
       EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord @vID_PUNTODEVENTA,
                                     @p_CODIGOGTECHPUNTODEVENTA,
                                     @p_NUMEROTERMINAL,
                                     @p_NOMPUNTODEVENTA,
                                     @vID_CIUDAD,
                                     @p_TELEFONOPUNTODEVENTA,
                                     @p_DIRECCIONPUNTODEVENTA,
                                     @vCODREGIMEN,
                                     @p_IDENTIFICACION,
                                     @vDIGITOVERIFICACION,
                                     @vID_AGRUPACIONPUNTODEVENTA,
                                     @vID_RAZONSOCIAL,
                                     1/*coddueno terminal */,
                                     0/*dueno de punto de venta IGT*/,
                                     NULL,--codigo externo de punto de venta 
                                     1,
                                     @p_ACTIVE
    END 
    
     IF @vCOUNT =0 BEGIN
      --Obtengo el id del punto de venta
       SELECT @vID_PUNTODEVENTA = ID_PUNTODEVENTA
        FROM WSXML_SFG.PUNTODEVENTA
       WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA;
     END  
    
  
    --Actualizacion de Datos Tecnicos
    EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos 
									@vID_PUNTODEVENTA, 
                                        @vID_TIPONEGOCIO,
                                        @vID_TIPOESTACION,
                                        @vID_TIPOTERMINAL,
                                        @vID_PUERTOTERMINAL,
                                        @p_NUMEROLINEA,
                                        @p_NUMERODROP,
                                        @p_NOMBRENODO,
                                        @p_ADDRESSNODO,
                                        0,
                                        @vID_RUTAPDV,
                                        @vCODREGIONAL,
                                        @vCODREDPDV,
                                        1
                                    
    
    
      
    SET @newcodAgrupacionPuntoDeVenta =@vID_AGRUPACIONPUNTODEVENTA;
    SET @newcodRazonSocial = @vID_RAZONSOCIAL;
    SET @newcodCiudadPDV = @vID_CIUDAD;
    --newcodTipoEstacion           NUMBER;
    --newcodTipoNegocio            NUMBER;
    --newcodTipoTerminal           NUMBER;
    --newcodPuertoTerminal         NUMBER;
    SET @newcodRutaPDV =@vID_RUTAPDV;
    --newcodRedPDV                 NUMBER;
    --newcodRegional               NUMBER;
    
    
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
			 WHERE CODIGOGTECHPUNTODEVENTA= @p_CODIGOGTECHPUNTODEVENTA;
			IF @prevCODCIUDAD <> @newcodCiudadPDV OR
			   @prevCODAGRUPACIONPUNTODEVENTA <> @newcodAgrupacionPuntoDeVenta OR
			   @prevCODREDPDV <> @newcodRedPDV BEGIN
			  SET @flagReglasCambioPlantilla = 1;
			END 
		  
		  IF @@ROWCOUNT = 0 BEGIN
			  SET @tmpERROR = 'ecNONEXISTANTCPDV El punto de venta ' +
									  ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '') +
									  ' no existe: ' + ISNULL(ERROR_MESSAGE ( ) , '');
			  RAISERROR(@tmpERROR, 16, 1);
		  END
      END;
  
  /* TRAMPA DE PLANTILLAS. Aplica cuando es nuevo, o actualizado y ha cambiado alguna de las reglas de plantillas */
    IF (@flagActualizacion = 0 OR (@flagActualizacion = 1 AND @flagReglasCambioPlantilla = 1))
      BEGIN

		BEGIN TRY
			DECLARE tLDN CURSOR FOR SELECT ID_LINEADENEGOCIO
						   FROM WSXML_SFG.LINEADENEGOCIO
						  WHERE ACTIVE = 1; OPEN tLDN;
			DECLARE @tLDN__ID_LINEADENEGOCIO NUMERIC(38,0)
			 FETCH NEXT FROM tLDN INTO @tLDN__ID_LINEADENEGOCIO;
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				DECLARE @cCODLDN       NUMERIC(22,0) = @tLDN__Id_Lineadenegocio;
				DECLARE @cCODPLANTILLA NUMERIC(22,0) = 0;
				DECLARE @cPDVPLANT_out NUMERIC(22,0);
				DECLARE @cCIUDADBUSCA  NUMERIC(22,0) = @newcodCiudadPDV;
				DECLARE @cCADENABUSCA  NUMERIC(22,0) = @newcodAgrupacionPuntoDeVenta;
				DECLARE @cREDPDVBUSCA  NUMERIC(22,0) = @newcodRedPDV;
				BEGIN
				-- Buscar por orden y peso de criterios. Ciudad, Agrupacion, Red
				BEGIN
				  -- Criterio 1. Ciudad, Cadena y Red
				  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
					FROM WSXML_SFG.PLANTILLAPRODUCTO P, WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
				   WHERE C.CODPLANTILLAPRODUCTO = P.ID_PLANTILLAPRODUCTO
					 AND P.CODLINEADENEGOCIO = @cCODLDN
					 AND C.CODCIUDAD = @cCIUDADBUSCA
					 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA
					 AND P.CODREDPDV = @cREDPDVBUSCA;

					 IF @@ROWCOUNT = 0 BEGIN
				
							BEGIN
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
								  --RAISE EXINVALIDASSIGN;
								  SET @vID_RAZONSOCIAL=  @vCODRAZONSOCIAL_SFG; 
								END 
                  
							  END 

							  IF @@ROWCOUNT = 0 BEGIN
									-- Criterio 3. Cadena
									BEGIN
									  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
										FROM WSXML_SFG.PLANTILLAPRODUCTO P
									   WHERE P.CODLINEADENEGOCIO = @cCODLDN
										 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA;
                    
									  IF @cCODPLANTILLA > 0 BEGIN
                      
										SELECT @CANTCIUDAD = COUNT(*)
										  FROM WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
										 WHERE C.CODPLANTILLAPRODUCTO = @cCODPLANTILLA;
                      
										IF @CANTCIUDAD > 0 BEGIN
										  --RAISE EXINVALIDASSIGN;
										  SET @vID_RAZONSOCIAL=  @vCODRAZONSOCIAL_SFG; 
										END 
                      
									  END 
                    
										IF @@ROWCOUNT = 0 BEGIN
										 
											BEGIN
							
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
					--                              RAISE EXINVALIDASSIGN;
													SET @vID_RAZONSOCIAL=  @vCODRAZONSOCIAL_SFG; 
												END 
                          
											  END 

											  IF @@ROWCOUNT = 0 BEGIN
													-- Default. Plantilla Master
													BEGIN
														  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
															FROM WSXML_SFG.PLANTILLAPRODUCTO P
														   WHERE P.CODLINEADENEGOCIO =
																 @tLDN__ID_LINEADENEGOCIO
															 AND P.MASTERPLANTILLA = 1;
															IF @@ROWCOUNT = 0 BEGIN
																SET @msg = '-20054 No existe plantilla master unica configurada para la linea de negocio ' +
																						ISNULL(WSXML_SFG.LINEADENEGOCIO_NOMBRE_F(@tLDN__ID_LINEADENEGOCIO), '') 
																RAISERROR(@msg, 16, 1);
															END
													END;
													-- NO SE VINCULARA LA PLANTILLA MASTER: LA PREFACTURACION LA BUSCA POR DEFECTO
													SET @cCODPLANTILLA = 0;
											  END

										END;
										END
									END;
							  END
							END;
					 END
				END;
				  -- Si se encontro plantilla para asignar
				  IF @cCODPLANTILLA > 0 BEGIN
					-- Si se esta cambiando la plantilla, desactivar primero
					EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_DeactivateRecordByData @vID_PUNTODEVENTA,@cCODLDN, 1
                
					EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_AddRecord @vID_PUNTODEVENTA,
													   @cCODPLANTILLA,
													   NULL,
													   NULL,
													   NULL,
													   1,
													   @cPDVPLANT_out OUT
				  END 
			  END;


			FETCH NEXT FROM tLDN INTO @tLDN__ID_LINEADENEGOCIO;
			END;
			CLOSE tLDN;
			DEALLOCATE tLDN;
		END TRY
		BEGIN CATCH
            SET @msg = ERROR_MESSAGE ( ) ;
            SET @msg = isnull(@msg, '') + '. Trampa de plantilla para PDV: ' + ISNULL(@p_CODIGOGTECHPUNTODEVENTA, '');
            EXEC WSXML_SFG.SFGTMPTRACE_TraceLog_1 @msg, 'CARGUEAGTINFO_TEMPLATE_INS'
		 END CATCH
      END;


END;
    
 GO
 
  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_UpdateAgrupacionPDVCabeza', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_UpdateAgrupacionPDVCabeza;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_UpdateAgrupacionPDVCabeza(@p_CODIGOAGRUPACIONGTECH NUMERIC(22,0),
                                      @p_CODPUNTODEVENTACABEZA NVARCHAR(2000)) AS
 BEGIN
    DECLARE @vCOUNT                        INT;
    DECLARE @vID_AGRUPACIONPUNTODEVENTA    INT;
    DECLARE @vID_AGRUPACIONPUNTODEVENTAPDV INT;
    DECLARE @vID_PUNTODEVENTA              INT;
    DECLARE @MSGERROERROR                  VARCHAR(2000);
   
  SET NOCOUNT ON;
    --Get the id of AGrupacionPuntoDeVenta
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
     WHERE AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH =
           @p_CODIGOAGRUPACIONGTECH;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROERROR = '-20000 No se puede establecer la cabeza de la cadena ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOAGRUPACIONGTECH), '') +
                      ' por que la cadena no existe  ';
      RAISERROR(@MSGERROERROR, 16, 1);
    END
    ELSE BEGIN
      SELECT @vID_AGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
       WHERE CODIGOAGRUPACIONGTECH = @p_CODIGOAGRUPACIONGTECH;
    END 
  
    -- Get the id of PuntoDeVenta
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.PUNTODEVENTA
     WHERE PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA = @p_CODPUNTODEVENTACABEZA;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROERROR = '-20000 No se puede establecer la cabeza de la cadena ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOAGRUPACIONGTECH), '') +
                      ' por que no existe el punto de venta ' +
                      ISNULL(@p_CODPUNTODEVENTACABEZA, '');
      RAISERROR(@MSGERROERROR, 16, 1);
    END
    ELSE BEGIN
      SELECT @vID_PUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
        FROM WSXML_SFG.PUNTODEVENTA
       WHERE PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA = @p_CODPUNTODEVENTACABEZA;
    END 
  
    ---Verify that the pos belongs to the chain
  
    SELECT @vID_AGRUPACIONPUNTODEVENTAPDV = PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA
      FROM WSXML_SFG.PUNTODEVENTA
     WHERE ID_PUNTODEVENTA = @vID_PUNTODEVENTA;
  
    IF @vID_AGRUPACIONPUNTODEVENTAPDV <> @vID_AGRUPACIONPUNTODEVENTA BEGIN
      SET @MSGERROERROR = '-20000 No se puede establecer la cabeza de la cadena ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOAGRUPACIONGTECH), '') +
                      ' por que el punto de venta ' +
                      ISNULL(@p_CODPUNTODEVENTACABEZA, '') + 'no pertenece a la cadena';
      RAISERROR(@MSGERROERROR, 16, 1);
    END 
  
    EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateCabeza @vID_AGRUPACIONPUNTODEVENTA,@vID_PUNTODEVENTA
  
  END;
  GO
  


  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateAgrupacionPDV', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateAgrupacionPDV;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateAgrupacionPDV(@p_NOMBREAGRUPACIONPDV   NVARCHAR(2000),
                                      @p_CODIGOAGRUPACIONGTECH NUMERIC(22,0),
                                      @p_CODTIPOPUNTODEVENTA   NUMERIC(22,0),
                                      @p_ACTIVE                NUMERIC(22,0),
                                      @p_REDPUNTODEVENTA       NVARCHAR(2000)) AS
 BEGIN
  
    DECLARE @vID_TIPOPUNTODEVENTA      INT;
    DECLARE @vID_AGRUPACIOPUNTODEVENTA INT;
    DECLARE @vID_REDPDV                INT;
    DECLARE @vID_USUARIOSISTEMA        INT = 1;
  
    DECLARE @MSGERROERROR VARCHAR(8000);
    DECLARE @vCOUNT       INT;
   
  SET NOCOUNT ON;
  
          --Verificando consistencias 
		  SET @MSGERROERROR = 'Sincronizando punto de venta : ' +isnull(convert(varchar, @p_CODIGOAGRUPACIONGTECH), '')
    EXEC WSXML_SFG.sfgtmptrace_tracelog @MSGERROERROR
  
    --Get the id of tipo punto de venta
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.TIPOPUNTODEVENTA
     WHERE TIPOPUNTODEVENTA.ID_TIPOPUNTODEVENTA = @p_CODTIPOPUNTODEVENTA;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la cadena ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOAGRUPACIONGTECH), '') +
                      ' por que no existe un tipo punto de venta con el codigo  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODTIPOPUNTODEVENTA), '');
      RAISERROR(@MSGERROERROR, 16, 1);
    END
    ELSE BEGIN
      SELECT @vID_TIPOPUNTODEVENTA = ID_TIPOPUNTODEVENTA
        FROM WSXML_SFG.TIPOPUNTODEVENTA
       WHERE TIPOPUNTODEVENTA.ID_TIPOPUNTODEVENTA = @p_CODTIPOPUNTODEVENTA;
    
    END 
  
    --Get the id of redpdv 
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.REDPDV
     WHERE REDPDV.NOMREDPDV = @p_REDPUNTODEVENTA;
  
    IF @vCOUNT = 0 BEGIN
    
      SET @MSGERROERROR = '-20000 No se puede sincronizar la cadena ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOAGRUPACIONGTECH), '') +
                      ' por que no existe una red con el nombre   ' +
                      ISNULL(@p_REDPUNTODEVENTA, '');
      RAISERROR(@MSGERROERROR, 16, 1);
    
    END
    ELSE BEGIN
    
      SELECT @vID_REDPDV = REDPDV.ID_REDPDV
        FROM WSXML_SFG.REDPDV
       WHERE REDPDV.NOMREDPDV = @p_REDPUNTODEVENTA;
    
    END 
  
    --Check if the record on agrupacionpuntodeventa does exist , if it does , then it must to be update , and if it does not , it must to be created   
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
     WHERE AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH =
           @p_CODIGOAGRUPACIONGTECH;
  
    IF @vCOUNT = 0 BEGIN
    
      EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AddRecord @p_NOMBREAGRUPACIONPDV,
                                          @p_CODIGOAGRUPACIONGTECH,
                                          @vID_TIPOPUNTODEVENTA,
                                          @vID_REDPDV,
                                          @vID_USUARIOSISTEMA,
                                          @vID_AGRUPACIOPUNTODEVENTA OUT
    
    END
    ELSE BEGIN
    
      SELECT @vID_AGRUPACIOPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
       WHERE AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH =
             @p_CODIGOAGRUPACIONGTECH;
    
      EXEC WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateRecord @vID_AGRUPACIOPUNTODEVENTA,
                                             @p_NOMBREAGRUPACIONPDV,
                                             @p_CODIGOAGRUPACIONGTECH,
                                             @vID_TIPOPUNTODEVENTA,
                                             @vID_REDPDV,
                                             @vID_USUARIOSISTEMA,
                                             @p_ACTIVE
    
      UPDATE WSXML_SFG.PUNTODEVENTA
         SET CODREDPDV = @vID_REDPDV
       WHERE CODAGRUPACIONPUNTODEVENTA = @vID_AGRUPACIOPUNTODEVENTA;
    
    END 
  
  END;
GO

 

  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRedPDV', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRedPDV;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRedPDV(@p_ACTIVE             NUMERIC(22,0),
                               @p_CODIGOCANALNEGOCIO NVARCHAR(2000),
                               @p_NOMREDPDV          NVARCHAR(2000)) AS
 BEGIN
  
    DECLARE @vCOUNT             INT;
    DECLARE @vID_CANALNEGOCIO   INT;
    DECLARE @vID_REDPDV         INT;
    DECLARE @vID_USUARIOSISTEMA INT = 1;
    DECLARE @MSGERROERROR       VARCHAR(8000);
  
   
  SET NOCOUNT ON;
  
    --Get the id of canal de negocio
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.CANALNEGOCIO
     WHERE CANALNEGOCIO.CODIGO = @p_CODIGOCANALNEGOCIO;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la red ' + ISNULL(@p_NOMREDPDV, '') +
                      ' , por que no existe un canal de negocio con el codigo ' +
                      ISNULL(@p_CODIGOCANALNEGOCIO, '');
      RAISERROR(@MSGERROERROR, 16, 1);
    END
    ELSE BEGIN
      SELECT @vID_CANALNEGOCIO = CANALNEGOCIO.ID_CANALNEGOCIO
        FROM WSXML_SFG.CANALNEGOCIO
       WHERE CANALNEGOCIO.CODIGO = @p_CODIGOCANALNEGOCIO;
    END 
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.REDPDV
     WHERE REDPDV.NOMREDPDV = @p_NOMREDPDV;
  
    IF @vCOUNT = 0 BEGIN
      --The record does not exist and must to be created
      EXEC WSXML_SFG.SFGREDPDV_AddRecord @p_NOMREDPDV,
                          @vID_CANALNEGOCIO,
                          @vID_USUARIOSISTEMA,
                          @vID_REDPDV OUT
    END
    ELSE BEGIN
      SELECT @vID_REDPDV = ID_REDPDV
        FROM WSXML_SFG.REDPDV
       WHERE REDPDV.NOMREDPDV = @p_NOMREDPDV;
    
      EXEC WSXML_SFG.SFGREDPDV_UpdateRecord @vID_REDPDV,
                             @p_NOMREDPDV,
                             @vID_CANALNEGOCIO,
                             @vID_USUARIOSISTEMA,
                             @p_ACTIVE
    END 
  
  END;

GO


  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateJefeDistrito', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateJefeDistrito;
GO

CREATE PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateJefeDistrito(
  @p_CODUSUARIO              NUMERIC(22,0),
  @p_ACTIVE                  NUMERIC(22,0),
  @p_CODIGOGTECHJEFEDISTRITO NUMERIC(22,0),
  @p_NOMJEFEDISTRITO         NVARCHAR(2000),
  @p_EMAIL                   NVARCHAR(2000)) AS
 BEGIN
  
  DECLARE @vID_JEFEDISTRITO   NUMERIC(22,0);
  DECLARE @vCOUNT             INT;
  DECLARE @MSGERROR           VARCHAR(8000);
  DECLARE @vID_USUARIOSISTEMA INT = 1;
  DECLARE @vID_USUARIO        INT;
   
  SET NOCOUNT ON;
  
    
    SELECT @vCOUNT = COUNT(1)
    FROM WSXML_SFG.JEFEDISTRITO
    WHERE JEFEDISTRITO.CODIGOGTECHJEFEDISTRITO = CAST(@p_CODIGOGTECHJEFEDISTRITO AS NVARCHAR(MAX));
    
    IF @vCOUNT = 0 BEGIN
    
      --it does not exist and must to be created 
      EXEC WSXML_SFG.SFGJEFEDISTRITO_AddJefeRecord  
        @p_CODIGOGTECHJEFEDISTRITO,
        @p_NOMJEFEDISTRITO,
        @vID_USUARIOSISTEMA,
        @vID_JEFEDISTRITO OUT
                                    
    END
    
    EXEC WSXML_SFG.SFGJEFEDISTRITO_CheckUpdateRecord 
      @p_CODIGOGTECHJEFEDISTRITO,
      @p_NOMJEFEDISTRITO,
      @p_EMAIL
   
    SELECT @vCOUNT = COUNT(1) 
    FROM WSXML_SFG.USUARIO 
    WHERE USUARIO.EMAIL = @p_EMAIL;
  
    IF @vCOUNT = 1 BEGIN
    
      --if there is an user with the same email, it means that that user is the user of the jefe de distrito 
      SELECT @vID_USUARIO = USUARIO.ID_USUARIO
        FROM WSXML_SFG.USUARIO
       WHERE USUARIO.EMAIL = @p_EMAIL;
    
      UPDATE WSXML_SFG.JEFEDISTRITO
         SET JEFEDISTRITO.CODUSUARIO = @vID_USUARIO
       WHERE JEFEDISTRITO.CODIGOGTECHJEFEDISTRITO =
             @p_CODIGOGTECHJEFEDISTRITO;
    END 
  
  END

GO


 
  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRegional', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRegional;
GO

CREATE PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRegional(@p_NOMREGIONAL     NVARCHAR(2000),
                                 @p_ACTIVE          NUMERIC(22,0),
                                 @p_CODJEFEDISTRITO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @vID_REGIONAL       NUMERIC(22,0);
    DECLARE @vID_JEFEDISTRITRO  NUMERIC(22,0);
    DECLARE @vCOUNT             INT;
    DECLARE @MSGERROR           VARCHAR(8000);
    DECLARE @vID_USUARIOSISTEMA INT = 1;
   
  SET NOCOUNT ON;
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.JEFEDISTRITO
     WHERE JEFEDISTRITO.CODIGOGTECHJEFEDISTRITO = CAST(@p_CODJEFEDISTRITO AS NVARCHAR(MAX));
  
    IF ISNULL(@vCOUNT, 0) = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede sincronizar la razon social ' +
                  ISNULL(@p_NOMREGIONAL, '') +
                  ' , por que no existe un jefe de distritro con el codigo  ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODJEFEDISTRITO), '');
      RAISERROR(@MSGERROR, 16, 1);
    END 
  
    SELECT @vID_JEFEDISTRITRO = JEFEDISTRITO.ID_JEFEDISTRITO
      FROM WSXML_SFG.JEFEDISTRITO
     WHERE JEFEDISTRITO.CODIGOGTECHJEFEDISTRITO = CAST(@p_CODJEFEDISTRITO AS NVARCHAR(MAX));
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.REGIONAL
     WHERE UPPER(REGIONAL.NOMREGIONAL) = UPPER(@p_NOMREGIONAL);
  
    IF @vCOUNT = 0 BEGIN
      -- It does not exists and it must to be created
      EXEC WSXML_SFG.SFGREGIONAL_AddRecord @p_NOMREGIONAL,
                            @vID_JEFEDISTRITRO,
                            @vID_USUARIOSISTEMA,
                            @vID_REGIONAL OUT
    END
    ELSE BEGIN
      SELECT @vID_REGIONAL = REGIONAL.ID_REGIONAL
        FROM WSXML_SFG.REGIONAL
       WHERE UPPER(REGIONAL.NOMREGIONAL) = UPPER(@p_NOMREGIONAL);
    
      EXEC WSXML_SFG.SFGREGIONAL_UpdateRecord @vID_REGIONAL,
                               @p_NOMREGIONAL,
                               @vID_JEFEDISTRITRO,
                               @vID_USUARIOSISTEMA,
                               @p_ACTIVE
    END 
  
  END;

GO

  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRedVentas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRedVentas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRedVentas(@p_ACTIVE         NUMERIC(22,0),
                                  @p_CODIGOGTECHFMR NUMERIC(22,0),
                                  @p_NOMFMR         NVARCHAR(2000),
                                  @p_EMAIL          NVARCHAR(2000)) AS
 GO
 


  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_GETPUNTOSDEVENTA', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_GETPUNTOSDEVENTA;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_GETPUNTOSDEVENTA AS
  
  BEGIN
  SET NOCOUNT ON;
  
      SELECT isnull(PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA, 0) as CODIGOGTECHPUNTODEVENTA,
             PUNTODEVENTA.NUMEROTERMINAL,
             PUNTODEVENTA.NOMPUNTODEVENTA,
             CIUDAD.CIUDADDANE,
             isnull(PUNTODEVENTA.TELEFONO, 0) as TELEFONO,
             isnull(PUNTODEVENTA.DIRECCION, '') as DIRECCION,
             isnull(RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL, 0) as CODIGOGTECHRAZONSOCIAL,
             isnull(RAZONSOCIAL.NOMRAZONSOCIAL, '') as NOMRAZONSOCIAL,
             isnull(RAZONSOCIAL.IDENTIFICACION, 0) as IDENTIFICACION,
             isnull(RZCIUDAD.CIUDADDANE, '') AS CIUDAD_RAZON_SOCIAL,
             isnull(RAZONSOCIAL.CODREGIMEN, 0) AS REGIMEN_RAZONSOCIAL,
             isnull(RAZONSOCIAL.NOMBRECONTACTO, '') AS NOMBRECONTACTO_RAZONSOCIAL,
             isnull(RAZONSOCIAL.EMAILCONTACTO, '') AS EMAILCONTACTO_RAZONSOCIAL,
             isnull(RAZONSOCIAL.TELEFONOCONTACTO, 0) AS TELEFONOCONTACTO_RAZONSOCIAL,
             isnull(RAZONSOCIAL.DIRECCIONCONTACTO, '') AS DIRECCIONCONTACTO_RAZONSOCIAL,
             isnull(RUTAPDV.NOMRUTAPDV, '') as NOMRUTAPDV,
             isnull(FMR.CODIGOGTECHFMR, 0) AS CODIGOFMR,
             isnull(FMR.NOMFMR, '') AS NOMBREFMR,
             isnull(REGIONAL.NOMREGIONAL, '') as NOMREGIONAL,
             isnull(JEFEDISTRITO.CODIGOGTECHJEFEDISTRITO, '') AS JEFEDISTRITO,
             isnull(JEFEDISTRITO.NOMJEFEDISTRITO, '') AS NOMBREJEFEDSITRITO,
             isnull(REDPDV.NOMREDPDV, '') AS NOMBREREDPDV,
             isnull(AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH, 0) AS CODIGOCADENA,
             isnull(AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA, '') AS NOMBRECADENA,
             isnull(AGRUPACIONPUNTODEVENTA.CODTIPOPUNTODEVENTA, 0) AS CODTIPOPUNTODEVENTA,
             CASE
               WHEN PUNTODEVENTA.ID_PUNTODEVENTA =
                    AGRUPACIONPUNTODEVENTA.CODPUNTODEVENTACABEZA THEN
                1
               ELSE
                0
             END AS ES_CABEZA,
             isnull(TIPONEGOCIO.NOMTIPONEGOCIO, '') as NOMTIPONEGOCIO,
             isnull(TIPOESTACION.NOMTIPOESTACION, '') as NOMTIPOESTACION,
             isnull(TIPOTERM.NOMTIPOTERMINAL, '') as NOMTIPOTERMINAL,
             --PUNTODEVENTA.PUERTOESTACION,
             isnull(PUERTOTERMINAL.NOMPUERTOTERMINAL, '') as NOMPUERTOTERMINAL,
             isnull(PUNTODEVENTA.NUMEROLINEA, 0) as NUMEROLINEA,
             isnull(PUNTODEVENTA.NUMERODROP, 0) as NUMERODROP,
             isnull(PUNTODEVENTA.NOMBRENODO, '') as NOMBRENODO,
             isnull(PUNTODEVENTA.ADDRESSNODO, '') AS ADDRESSNODO,
             CASE
               WHEN PUNTODEVENTA.Active = 1 THEN
                'A'
               ELSE
                'I'
             END AS FLAGESTADO
        FROM WSXML_SFG.PUNTODEVENTA
       INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA
          ON PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA =
             AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
        LEFT OUTER JOIN WSXML_SFG.RUTAPDV
          ON PUNTODEVENTA.CODRUTAPDV = RUTAPDV.ID_RUTAPDV
        LEFT OUTER JOIN WSXML_SFG.FMR
          ON RUTAPDV.CODFMR = FMR.ID_FMR
        LEFT OUTER JOIN WSXML_SFG.REGIONAL
          ON PUNTODEVENTA.CODREGIONAL = REGIONAL.ID_REGIONAL
        LEFT OUTER JOIN WSXML_SFG.JEFEDISTRITO
          ON REGIONAL.CODJEFEDISTRITO = JEFEDISTRITO.ID_JEFEDISTRITO
        LEFT OUTER JOIN WSXML_SFG.REDPDV
          ON PUNTODEVENTA.CODREDPDV = REDPDV.ID_REDPDV
        LEFT OUTER JOIN WSXML_SFG.TIPONEGOCIO
          ON PUNTODEVENTA.CODTIPONEGOCIO = TIPONEGOCIO.ID_TIPONEGOCIO
      /* LEFT OUTER JOIN TIPOTERMINAL ON PUNTODEVENTA.CODTIPOTERMINAL = TIPOTERMINAL.ID_TIPOTERMINAL*/
        LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL
          ON PUNTODEVENTA.CODRAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        LEFT OUTER JOIN WSXML_SFG.CIUDAD
          ON PUNTODEVENTA.CODCIUDAD = CIUDAD.ID_CIUDAD
        LEFT OUTER JOIN WSXML_SFG.CIUDAD RZCIUDAD
          ON RAZONSOCIAL.CODCIUDAD = RZCIUDAD.ID_CIUDAD
        LEFT OUTER JOIN WSXML_SFG.TIPOESTACION
          ON PUNTODEVENTA.CODTIPOESTACION = TIPOESTACION.ID_TIPOESTACION
        LEFT OUTER JOIN WSXML_SFG.TIPOTERMINAL TIPOTERM
          ON PUNTODEVENTA.CODTIPOTERMINAL = TIPOTERM.ID_TIPOTERMINAL
        LEFT OUTER JOIN WSXML_SFG.PUERTOTERMINAL
          ON PUNTODEVENTA.CODPUERTOTERMINAL =
             PUERTOTERMINAL.ID_PUERTOTERMINAL;
  
  END;
GO 

  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRutaPDV', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRutaPDV;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRutaPDV(@p_RUTA      NVARCHAR(2000),
                                @p_NOMBREFMR NVARCHAR(2000),
                                @p_CODIGOFMR NVARCHAR(2000),
                                @p_NOMREGIONAL NVARCHAR(2000)) AS
 BEGIN
    DECLARE @vID_REPVENTAS      NUMERIC(22,0);
    DECLARE @vID_RUTA           NUMERIC(22,0);
    DECLARE @vCOUNT             INT;
    DECLARE @MSGERROR           VARCHAR(8000);
    DECLARE @vID_USUARIOSISTEMA INT = 1;
    DECLARE @vID_REGIONAL INT;
   
  SET NOCOUNT ON;
    
  --Get id Rep Ventas
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.FMR
     WHERE FMR.CODIGOGTECHFMR = @p_CODIGOFMR;
  
      
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede actualizar la ruta  ' + ISNULL(@p_RUTA, '') +
                  ' , por que no existe un representante de ventas con el codigo  ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOFMR), '');
      RAISERROR( @MSGERROR, 16, 1);
    END
    ELSE BEGIN
      SELECT @vID_REPVENTAS = FMR.ID_FMR
        FROM WSXML_SFG.FMR
       WHERE FMR.CODIGOGTECHFMR = @p_CODIGOFMR;
    END 
  
    --Get id Regional
  
  SELECT @vCOUNT = COUNT(1)
  FROM WSXML_SFG.REGIONAL 
  WHERE REGIONAL.NOMREGIONAL = upper(@p_NOMREGIONAL); 

   IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede actualizar la ruta  ' + ISNULL(@p_RUTA, '') +
                  ' , por que no existe la regional con el nombre ' +
                  ISNULL(CONVERT(VARCHAR, @p_NOMREGIONAL), '');
      RAISERROR(@MSGERROR, 16, 1);
   END
   ELSE BEGIN
     SELECT @vID_REGIONAL = REGIONAL.ID_REGIONAL
     FROM WSXML_SFG.REGIONAL 
     WHERE REGIONAL.NOMREGIONAL= @p_NOMREGIONAL;  
   
   END 
  
  
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RUTAPDV
     WHERE UPPER(RUTAPDV.NOMRUTAPDV) = @p_RUTA;
  
    IF @vCOUNT = 0 BEGIN
       EXEC WSXML_SFG.SFGRUTAPDV_AddRecord @p_RUTA,
                           @vID_REPVENTAS,
                           @vID_USUARIOSISTEMA,
                           @vID_REGIONAL,
                           @vID_RUTA OUT
 
       
    END
    ELSE BEGIN
      
      SELECT @vID_RUTA = RUTAPDV.ID_RUTAPDV
        FROM WSXML_SFG.RUTAPDV
       WHERE UPPER(RUTAPDV.NOMRUTAPDV) = @p_RUTA;
    
      UPDATE WSXML_SFG.RUTAPDV
         SET RUTAPDV.NOMRUTAPDV = @p_RUTA,
             RUTAPDV.CODFMR     = @vID_REPVENTAS,
             RUTAPDV.CODREGIONAL = @vID_REGIONAL
       WHERE RUTAPDV.ID_RUTAPDV = @vID_RUTA;
    END 
  
  END;

GO

  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocialStreet', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocialStreet;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocialStreet(@p_CODIGOGTECHRAZONSOCIAL NUMERIC(22,0),
                                          @p_NOMBRERAZONSOCIAL      NVARCHAR(2000),
                                          @p_IDENTIFICACION         NUMERIC(22,0),
                                          @p_CODREGIMEN             NUMERIC(22,0),
                                          @p_NOMBRECONTACTO         NVARCHAR(2000),
                                          @p_NOMBRETIPOPERSONA      NVARCHAR(2000)) AS
 BEGIN
    -- Codigos de Foraneas
    DECLARE @vID_RAZONSOCIAL     INT;
    DECLARE @vID_REGIMEN         INT;
    DECLARE @vID_CIUDAD          INT;
    DECLARE @vID_TIPOPERSONA     INT;
    DECLARE @vDIGITOVERIFICACION INT;
    DECLARE @vCOUNT              INT;
    DECLARE @vID_USUARIOSISTEMA  INT = 1;
    DECLARE @vTMP                INT;
    DECLARE @MSGERROERROR        VARCHAR(8000);
  
   
  SET NOCOUNT ON;
  
    --Find TipoPersonaTribuaria
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.TIPOPERSONATRIBUTARIA
     WHERE TIPOPERSONATRIBUTARIA.NOMTIPOPERSONATRIBUTARIA =
           @p_NOMBRETIPOPERSONA;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no existe un tipo de persona con el nombre' +
                      ISNULL(@p_NOMBRETIPOPERSONA, '');
      RAISERROR( @MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_TIPOPERSONA = TIPOPERSONATRIBUTARIA.ID_TIPOPERSONATRIBUTARIA
      FROM WSXML_SFG.TIPOPERSONATRIBUTARIA
     WHERE TIPOPERSONATRIBUTARIA.NOMTIPOPERSONATRIBUTARIA =
           @p_NOMBRETIPOPERSONA;
  
    --find the regimen
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.REGIMEN
     WHERE REGIMEN.ID_REGIMEN = @p_CODREGIMEN;
  
    IF ISNULL(@vCOUNT, 0) = 0 BEGIN
      -- It does not exist. Throw Error
    
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no existe un regimen con id ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODREGIMEN), '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_REGIMEN = REGIMEN.ID_REGIMEN
      FROM WSXML_SFG.REGIMEN
     WHERE REGIMEN.ID_REGIMEN = @p_CODREGIMEN;
  
    --Calculate the verification number
    SET @vDIGITOVERIFICACION = WSXML_SFG.calculardigitoverificacion(@p_IDENTIFICACION);
  
    --check if there is a record with the codigogtechrazonsocial 
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
  
    IF @vCOUNT = 0 BEGIN
      -- El registro no existe y debe ser creado 

      EXEC WSXML_SFG.SFGRAZONSOCIAL_AddRecord @p_CODIGOGTECHRAZONSOCIAL,
                               @p_NOMBRERAZONSOCIAL,
                               @p_IDENTIFICACION,
                               @vDIGITOVERIFICACION,
                               '',
                               '',
                               NULL,
                               NULL,
                               NULL,
                               @vID_REGIMEN,
                               @vID_USUARIOSISTEMA,
                               @vID_RAZONSOCIAL OUT
    END
    ELSE BEGIN
      SELECT @vID_RAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
    
      EXEC WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord @vID_RAZONSOCIAL,
                                  @p_CODIGOGTECHRAZONSOCIAL,
                                  @p_NOMBRERAZONSOCIAL,
                                  @p_IDENTIFICACION,
                                  @vDIGITOVERIFICACION,
                                  @p_NOMBRECONTACTO,
                                  '',
                                  NULL,
                                  NULL,
                                  NULL,
                                  @vID_REGIMEN,
                                  @vID_USUARIOSISTEMA
    
    END 
    
    EXEC WSXML_SFG.sfgrazonsocial_SetContrato  @vID_RAZONSOCIAL,1/*sc*/,3,4/*compra y venta*/,@vID_RAZONSOCIAL,2/*VIA MOVIL*/,@vID_USUARIOSISTEMA,@vTMP OUT
  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePdvStreetSeller', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePdvStreetSeller;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePdvStreetSeller(@p_CODIGOPDVMOVIL         NVARCHAR(2000),
                                        @p_TERMINALMOVIL          NUMERIC(22,0),
                                        @p_CELULARMOVIL           NUMERIC(22,0),
                                        @p_CODIGOGTECHRAZONSOCIAL NUMERIC(22,0),
                                        @p_NOMBREPDVMOVIL         NVARCHAR(2000),
                                        @p_DIRECCIONPDV           NVARCHAR(2000),
                                        @p_CODDANECIUDADPDV       NVARCHAR(2000),
                                        @p_CODDANEDEPTOPDV        NVARCHAR(2000),
                                        @p_TELEFONO                   NVARCHAR(2000),
                                        @p_CELULAR                    NVARCHAR(2000),
                                        @p_CORREOELECTRONICO          NVARCHAR(2000),
                                        @p_RUTA                       NVARCHAR(2000),
                                        @P_CODTIPONEGOCIO             INT,
                                        @p_PORCENTAJECOMISIONVIAMOVIL NUMERIC(22,0),
                                        @p_ACTIVE NUMERIC(22,0)) AS
 BEGIN
  
    DECLARE @vID_PUNTODEVENTA      NUMERIC(22,0);
    DECLARE @vID_RAZONSOCIAL       NUMERIC(22,0);
    DECLARE @vID_CIUDAD            NUMERIC(22,0);
    DECLARE @vID_CANALDISTRIBUCION NUMERIC(22,0);
    DECLARE @vID_RUTAPDV           NUMERIC(22,0);
    DECLARE @vID_REGIMEN           NUMERIC(22,0);
    DECLARE @vID_IDENTIFICACION    NUMERIC(22,0);
    DECLARE @vDIGITOVERIFICACION   INT;
    DECLARE @vID_TIPONEGOCIO       NUMERIC(22,0);
    DECLARE @vID_TIPOTERMINAL      NUMERIC(22,0) = 3;
    DECLARE @vID_REGIONAL          NUMERIC(22,0);
    DECLARE @vCODRANGOCOMISION     NUMERIC(22,0);
    
    DECLARE @vCODRAZONSOCIALPDV    NUMERIC(22,0);
    DECLARE @vIDENTIFICACIONANTERIOR NUMERIC(22,0);
    DECLARE @vIDENTIFICACIONIGT  NUMERIC(22,0);
    
    DECLARE @vID_AGRUPACIONPUNTODEVENTA INT = 2239;
    DECLARE @vID_REDPDV                 INT = 228;
    DECLARE @vDANECOMPLENTO             NVARCHAR(5);             
  
    DECLARE @vID_USUARIOSISTEMA INT = 1;
    DECLARE @vCOUNT             INT;
    DECLARE @MSGERROR           NVARCHAR(2000);
    
    
    DECLARE @flagReglasCambioPlantilla    NUMERIC(22,0) = 0;
    DECLARE @flagActualizacion            NUMERIC(22,0) = 0;
    DECLARE @tmpERROR                     NVARCHAR(2000);
    DECLARE @CANTCIUDAD                   NUMERIC(22,0);

   
  SET NOCOUNT ON;
    --Check RazonSocial
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede crear el punto de venta ' +
                  ISNULL(@p_CODIGOPDVMOVIL, '') +
                  ' , por que no existe una razon social con el codigo  ' +
                  ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '');
      RAISERROR(@MSGERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_RAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL,
           @vID_REGIMEN = RAZONSOCIAL.CODREGIMEN,
           @vID_IDENTIFICACION = RAZONSOCIAL.IDENTIFICACION,
           @vDIGITOVERIFICACION = RAZONSOCIAL.DIGITOVERIFICACION
           FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
  
  
    --Check Ciudad
--    vDANECOMPLENTO:= p_CODDANEDEPTOPDV || p_CODDANECIUDADPDV;
    SET @vDANECOMPLENTO= @p_CODDANECIUDADPDV;    
    
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @vDANECOMPLENTO;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede crear el punto de venta   ' +
                  ISNULL(@p_CODIGOPDVMOVIL, '') +
                  ' , por que no existe una ciudad con el codigo dane  ' +
                  ISNULL(CONVERT(VARCHAR, @vDANECOMPLENTO), '');
      RAISERROR(@MSGERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_CIUDAD = CIUDAD.ID_CIUDAD
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @vDANECOMPLENTO;
  
    --Check Ruta PDV
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RUTAPDV
     WHERE RUTAPDV.NOMRUTAPDV = @p_RUTA;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede crear el punto de venta   ' +
                  ISNULL(@p_CODIGOPDVMOVIL, '') +
                  ' , por que no existe una ruta con el nombre  ' + ISNULL(@p_RUTA, '');
      RAISERROR(@MSGERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_RUTAPDV = RUTAPDV.ID_RUTAPDV, @vID_REGIONAL = RUTAPDV.CODREGIONAL
      FROM WSXML_SFG.RUTAPDV
     WHERE RUTAPDV.NOMRUTAPDV = @p_RUTA;
  
    --Check Tipo Negocio 
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.TIPONEGOCIO
     WHERE TIPONEGOCIO.ID_TIPONEGOCIO = @P_CODTIPONEGOCIO;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede crear el punto de venta   ' +
                  ISNULL(@p_CODIGOPDVMOVIL, '') +
                  ' , por que no existe un tipo de negocio con el codigo ' +
                  ISNULL(CONVERT(VARCHAR, @P_CODTIPONEGOCIO), '');
      RAISERROR(@MSGERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_TIPONEGOCIO = TIPONEGOCIO.ID_TIPONEGOCIO
      FROM WSXML_SFG.TIPONEGOCIO
     WHERE TIPONEGOCIO.ID_TIPONEGOCIO = @P_CODTIPONEGOCIO;
     --- Get vID_REDPDV
     
     
    SELECT @vID_REDPDV = AGRUPACIONPUNTODEVENTA.CODREDPDV
    FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA 
    WHERE ID_AGRUPACIONPUNTODEVENTA =@vID_AGRUPACIONPUNTODEVENTA ;
     
     
  
    --Check punto de venta
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.PUNTODEVENTA
     WHERE PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA = @p_CODIGOPDVMOVIL;
  
    IF @vCOUNT > 0 BEGIN
      --Update 
    
      SELECT @vID_PUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
        FROM WSXML_SFG.PUNTODEVENTA
       WHERE PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA = @p_CODIGOPDVMOVIL;
           
       EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord @vID_PUNTODEVENTA,
                                   @p_CODIGOPDVMOVIL,
                                   @p_TERMINALMOVIL,
                                   @p_NOMBREPDVMOVIL,
                                   @vID_CIUDAD,
                                   @p_TELEFONO,
                                   @p_DIRECCIONPDV,
                                   @vID_REGIMEN,
                                   @vID_IDENTIFICACION,
                                   @vDIGITOVERIFICACION,
                                   @vID_AGRUPACIONPUNTODEVENTA,
                                   @vID_RAZONSOCIAL,
                                   1/*cod dueno terminal*/,
                                   0/*dueno de punto de venta IGT*/,
                                   NULL,--codigo externo de punto de venta 
                                   @vID_USUARIOSISTEMA,
                                   1
    END
    ELSE BEGIN
      --INSERT
     EXEC WSXML_SFG.SFGPUNTODEVENTA_AddRecord @p_CODIGOPDVMOVIL,
                                @p_TERMINALMOVIL,
                                @p_NOMBREPDVMOVIL,
                                @vID_CIUDAD,
                                @p_TELEFONO,
                                @p_DIRECCIONPDV,
                                @vID_REGIMEN,
                                @vID_IDENTIFICACION,
                                @vDIGITOVERIFICACION,
                                @vID_AGRUPACIONPUNTODEVENTA,
                                @vID_RAZONSOCIAL,
                                1/*cod dueno terminal*/,
                                0/*dueno de punto de venta IGT*/,
                                NULL,--codigo externo de punto de venta
                                1,
                                @vID_USUARIOSISTEMA,
                                @vID_PUNTODEVENTA OUT
    END 
  
    EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos @vID_PUNTODEVENTA,
                                        @vID_TIPONEGOCIO,
                                        NULL,
                                        @vID_TIPOTERMINAL,
                                        NULL,
                                        0,
                                        0,
                                        NULL,
                                        NULL,
                                        0,
                                        @vID_RUTAPDV,
                                        @vID_REGIONAL,
                                        @vID_REDPDV,
                                        @vID_USUARIOSISTEMA



/*Inicio de Modificacion 25 oct/2016 Actualizacion razon social cuando es IGT*/
   
    IF @vCOUNT > 0 BEGIN   --Solo cuando es actualizacion de punto de venta.
     
     
     SELECT @vIDENTIFICACIONIGT = COMPANIA.IDENTIFICACION 
     FROM WSXML_SFG.COMPANIA 
     WHERE COMPANIA.ID_COMPANIA = 3;  /*Razon Social IGT Colombia*/
    
      IF @vCODRAZONSOCIALPDV <> @vID_RAZONSOCIAL AND @vIDENTIFICACIONANTERIOR = @vIDENTIFICACIONIGT  BEGIN 
         UPDATE WSXML_SFG.REGISTROFACTURACION SET CODRAZONSOCIAL= @vID_RAZONSOCIAL,
                IDENTIFICACION= @vID_IDENTIFICACION,
                DIGITOVERIFICACION= @vDIGITOVERIFICACION
         WHERE CODPUNTODEVENTA= @vID_PUNTODEVENTA AND
                CODRAZONSOCIAL= @vCODRAZONSOCIALPDV;
      END 
      
    END 
  /*Fin de Modificacion 25 oct/2016 Actualizacion razon social cuando es IGT*/
  
                                              
-- Find the right rangocomision     

    SELECT @vCOUNT = COUNT(1)
    FROM WSXML_SFG.RANGOCOMISIONDETALLE
    WHERE RANGOCOMISIONDETALLE.RANGOINICIAL IS NULL
    AND RANGOCOMISIONDETALLE.RANGOFINAL IS NULL
    AND RANGOCOMISIONDETALLE.VALORTRANSACCIONAL= 0 
    AND RANGOCOMISIONDETALLE.VALORPORCENTUAL = @p_PORCENTAJECOMISIONVIAMOVIL;
    
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede crear el punto de venta   ' +
                  ISNULL(@p_CODIGOPDVMOVIL, '') +
                  ' , por que no existe un rango comision con el valor   ' +
                  ISNULL(CONVERT(VARCHAR, @p_PORCENTAJECOMISIONVIAMOVIL), '') + '%' ;
      RAISERROR(@MSGERROR, 16, 1);
	  RETURN 0
    END 
    
    SELECT @vCODRANGOCOMISION = MAX(RANGOCOMISIONDETALLE.CODRANGOCOMISION)
    FROM WSXML_SFG.RANGOCOMISIONDETALLE
    WHERE RANGOCOMISIONDETALLE.RANGOINICIAL IS NULL
    AND RANGOCOMISIONDETALLE.RANGOFINAL IS NULL
    AND RANGOCOMISIONDETALLE.VALORTRANSACCIONAL= 0 
    AND RANGOCOMISIONDETALLE.VALORPORCENTUAL = @p_PORCENTAJECOMISIONVIAMOVIL;                               
    
    UPDATE WSXML_SFG.PUNTODEVENTA SET PUNTODEVENTA.CODRANGOCOMISIONVIAMOVIL = @vCODRANGOCOMISION,
                            PUNTODEVENTA.NUMEROCELULARVIAMOVIL = @p_CELULARMOVIL
    WHERE PUNTODEVENTA.ID_PUNTODEVENTA = @vID_PUNTODEVENTA;                         
    
    
    --ACTUALIZAR INFORMACION DE PLANTILLAS
    
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
         WHERE CODIGOGTECHPUNTODEVENTA= @p_CODIGOPDVMOVIL;
        IF @prevCODCIUDAD <> @vID_CIUDAD OR
           @prevCODAGRUPACIONPUNTODEVENTA <> @vID_AGRUPACIONPUNTODEVENTA OR
           @prevCODREDPDV <> @vID_REDPDV BEGIN
          SET @flagReglasCambioPlantilla = 1;
        END 
		  IF @@ROWCOUNT = 0 BEGIN
			SET @tmpERROR = 'ecNONEXISTANTCPDV El punto de venta ' +
                                  ISNULL(@p_CODIGOPDVMOVIL, '') +
                                  ' no existe: ' + ISNULL(ERROR_MESSAGE ( ) , '');
			RAISERROR(@tmpERROR, 16, 1);
			RETURN 0
		  END
      END;
  
  /* TRAMPA DE PLANTILLAS. Aplica cuando es nuevo, o actualizado y ha cambiado alguna de las reglas de plantillas */
    IF (@flagActualizacion = 0 OR (@flagActualizacion = 1 AND @flagReglasCambioPlantilla = 1))
      BEGIN
		BEGIN TRY

			DECLARE tLDN CURSOR FOR SELECT ID_LINEADENEGOCIO
						   FROM WSXML_SFG.LINEADENEGOCIO
						  WHERE ACTIVE = 1; OPEN tLDN;
			DECLARE @tLDN__ID_LINEADENEGOCIO NUMERIC(38,0)
			 FETCH NEXT FROM tLDN INTO @tLDN__ID_LINEADENEGOCIO;
			 WHILE @@FETCH_STATUS=0
			 BEGIN
				DECLARE @cCODLDN       NUMERIC(22,0) = @tLDN__Id_Lineadenegocio;
				DECLARE @cCODPLANTILLA NUMERIC(22,0) = 0;
				DECLARE @cPDVPLANT_out NUMERIC(22,0);
				DECLARE @cCIUDADBUSCA  NUMERIC(22,0) = @vID_CIUDAD;
				DECLARE @cCADENABUSCA  NUMERIC(22,0) = @vID_AGRUPACIONPUNTODEVENTA;
				DECLARE @cREDPDVBUSCA  NUMERIC(22,0) = @vID_REDPDV;
			  BEGIN
				-- Buscar por orden y peso de criterios. Ciudad, Agrupacion, Red
				BEGIN
				  -- Criterio 1. Ciudad, Cadena y Red
				  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
					FROM WSXML_SFG.PLANTILLAPRODUCTO P, WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
				   WHERE C.CODPLANTILLAPRODUCTO = P.ID_PLANTILLAPRODUCTO
					 AND P.CODLINEADENEGOCIO = @cCODLDN
					 AND C.CODCIUDAD = @cCIUDADBUSCA
					 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA
					 AND P.CODREDPDV = @cREDPDVBUSCA;
					IF @@ROWCOUNT = 0
					BEGIN
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
                  
					  /*  IF CANTCIUDAD > 0 THEN
						  --RAISE EXINVALIDASSIGN;
						  vID_RAZONSOCIAL:=  vCODRAZONSOCIAL_SFG; 
						END IF;*/
                  
					  END 
                
						IF @@ROWCOUNT = 0
						-- Criterio 3. Cadena
						BEGIN
						  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
							FROM WSXML_SFG.PLANTILLAPRODUCTO P
						   WHERE P.CODLINEADENEGOCIO = @cCODLDN
							 AND P.CODAGRUPACIONPUNTODEVENTA = @cCADENABUSCA;
                    
						  IF @cCODPLANTILLA > 0 BEGIN
                      
							SELECT @CANTCIUDAD = COUNT(*)
							  FROM WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
							 WHERE C.CODPLANTILLAPRODUCTO = @cCODPLANTILLA;
                      
							/*IF CANTCIUDAD > 0 THEN
							  --RAISE EXINVALIDASSIGN;
							  vID_RAZONSOCIAL:=  vCODRAZONSOCIAL_SFG; 
							END IF;*/
                      
						  END 
                    
							IF @@ROWCOUNT = 0
							BEGIN
							  -- Criterio 4. Red
							  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
								FROM WSXML_SFG.PLANTILLAPRODUCTO P
							   WHERE P.CODLINEADENEGOCIO = @cCODLDN
								 AND P.CODREDPDV = @cREDPDVBUSCA;
                        
							  IF @cCODPLANTILLA > 0 BEGIN
                          
								SELECT @CANTCIUDAD = COUNT(*)
								  FROM WSXML_SFG.PLANTILLAPRODUCTOCIUDAD C
								 WHERE C.CODPLANTILLAPRODUCTO = @cCODPLANTILLA;
                          
							   /* IF CANTCIUDAD > 0 THEN
	--                              RAISE EXINVALIDASSIGN;
									vID_RAZONSOCIAL:=  vCODRAZONSOCIAL_SFG; 
								END IF;*/
                          
							  END 
								IF @@ROWCOUNT = 0 BEGIN
								-- Default. Plantilla Master
									BEGIN
									  SELECT @cCODPLANTILLA = ID_PLANTILLAPRODUCTO
										FROM WSXML_SFG.PLANTILLAPRODUCTO P
									   WHERE P.CODLINEADENEGOCIO =
											 @tLDN__ID_LINEADENEGOCIO
										 AND P.MASTERPLANTILLA = 1;
										IF @@ROWCOUNT = 0 BEGIN
											SET @MSGERROR = '-20054 No existe plantilla master unica configurada para la linea de negocio ' +
																ISNULL(WSXML_SFG.LINEADENEGOCIO_NOMBRE_F(@tLDN__ID_LINEADENEGOCIO), '')
											RAISERROR(@MSGERROR, 16, 1);
										END
									END;
									-- NO SE VINCULARA LA PLANTILLA MASTER: LA PREFACTURACION LA BUSCA POR DEFECTO
									SET @cCODPLANTILLA = 0;
								END
							END;


						END;
					END;
				END;
				  -- Si se encontro plantilla para asignar
				  IF @cCODPLANTILLA > 0 BEGIN
					-- Si se esta cambiando la plantilla, desactivar primero
					EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_DeactivateRecordByData @vID_PUNTODEVENTA,@cCODLDN,1
                
					EXEC WSXML_SFG.SFGPUNTODEVENTAPLANTILLA_AddRecord @vID_PUNTODEVENTA,
													   @cCODPLANTILLA,
													   NULL,
													   NULL,
													   NULL,
													   1,
													   @cPDVPLANT_out OUT
				  END 
			  END;
			FETCH NEXT FROM tLDN INTO @tLDN__ID_LINEADENEGOCIO;
			END;
			CLOSE tLDN;
			DEALLOCATE tLDN;
		END TRY
		BEGIN CATCH
			       DECLARE @msg VARCHAR(2000);
          BEGIN
            SET @msg = ERROR_MESSAGE ( ) ;
            SET @msg = isnull(@msg, '') + '. Trampa de plantilla para PDV: ' + ISNULL(@p_CODIGOPDVMOVIL, '');
            EXEC WSXML_SFG.SFGTMPTRACE_TraceLog_1 @msg, 'CARGUEAGTINFO_TEMPLATE_INS'
          END;

		END CATCH

     
     
      END;
    
  
  
  END;

GO
 


  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_SetRazonSocialContrato', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_SetRazonSocialContrato;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_SetRazonSocialContrato(@p_CODPUNTODEVENTA            NUMERIC(22,0),
                                   @p_CODIGOGTECHSERVICIO        NUMERIC(22,0),
                                   @p_CODIGOCOMPANIA             NVARCHAR(2000),
                                   @p_CODTIPOCONTRATOPDV         NUMERIC(22,0),
                                   @p_NUMEROCONTRATO             NVARCHAR(2000),
                                   @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                                   @p_ID_RAZONSOCIALCONTRATO_out NUMERIC(22,0) OUT) AS
 BEGIN
  SET NOCOUNT ON;
    DECLARE @cCODRAZONSOCIAL NUMERIC(22,0);
    DECLARE @cCODSERVICIO    NUMERIC(22,0);
    DECLARE @cCODCOMPANIA    NUMERIC(22,0);
   
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
                               1,/*CONVENSIONAL*/
                               @p_CODUSUARIOMODIFICACION,
                               @p_ID_RAZONSOCIALCONTRATO_out OUT
	END TRY
	BEGIN CATCH
      RAISERROR('ecERRORPDVRETURNV Error al ingresar los contratos para el punto de venta', 16, 1);
	  END CATCH
  END;
GO  
 
  
   IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateValkyrieCanalTx', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateValkyrieCanalTx;
GO

CREATE           PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateValkyrieCanalTx(@p_NOMBRECANAL              NVARCHAR(2000),
                                                 @p_NUMEROESTACION           NUMERIC(22,0),
                                                 @p_FRECUENCIATX             NUMERIC(22,0),
                                                 @p_FRECUENCIARX             NUMERIC(22,0),
                                                 @p_NOMNODOTERMINAL          NVARCHAR(2000),
                                                 @p_NOMTECNOLOGIATERMINAL    NVARCHAR(2000),
                                                 @p_NOMRADIO                 NVARCHAR(2000),
                                                 @p_CODIGOLINEA              NUMERIC(22,0))AS
BEGIN 
                                                 
  DECLARE @vCOUNT                     INT;                                                 
  DECLARE @vCODNODOTERMINAL           NUMERIC(22,0);
  DECLARE @vCODTECNOLOGIATERMINAL     NUMERIC(22,0);
  DECLARE @vCODRADIO                  NUMERIC(22,0);
  DECLARE @vACTIVO                    NUMERIC(22,0);
  DECLARE @vID_CANALTRANSMISION       NUMERIC(22,0);
  DECLARE @MSGERROR                   NVARCHAR(2000);
  
  
   
  SET NOCOUNT ON; 
    
     EXEC WSXML_SFG.sfgtmptrace_tracelog 'Sincronizando canal de transmision...'
     
     --Obtengo el codigo del Nodo Terminal
     SELECT @vCOUNT = COUNT(1)
     FROM  VALKYRIE.NODOTERMINAL 
     WHERE VALKYRIE.NODOTERMINAL.NOMNODOTERMINAL= @p_NOMNODOTERMINAL;
     
     
     IF @vCOUNT = 0 BEGIN
       SELECT  @vCODNODOTERMINAL = VALKYRIE.NODOTERMINAL.ID_NODOTERMINAL
       FROM  VALKYRIE.NODOTERMINAL 
       ORDER BY 1 DESC;
     END
     ELSE BEGIN
       SELECT  @vCODNODOTERMINAL = VALKYRIE.NODOTERMINAL.ID_NODOTERMINAL
       FROM  VALKYRIE.NODOTERMINAL 
       WHERE VALKYRIE.NODOTERMINAL.NOMNODOTERMINAL= @p_NOMNODOTERMINAL;
   END 
    
   --Obtengo el codigo de la tecnologia Terminal
    SELECT @vCOUNT = COUNT(1)
    FROM VALKYRIE.TECNOLOGIATERMINAL
    WHERE VALKYRIE.TECNOLOGIATERMINAL.NOMTECNOLOGIATERMINAL= @p_NOMTECNOLOGIATERMINAL;
    
    IF @vCOUNT= 0 BEGIN
       SELECT @vCODTECNOLOGIATERMINAL = VALKYRIE.TECNOLOGIATERMINAL.ID_TECNOLOGIATERMINAL
       FROM VALKYRIE.TECNOLOGIATERMINAL
       ORDER BY 1 DESC;
    END
    ELSE BEGIN
      SELECT @vCODTECNOLOGIATERMINAL = VALKYRIE.TECNOLOGIATERMINAL.ID_TECNOLOGIATERMINAL
      FROM VALKYRIE.TECNOLOGIATERMINAL
      WHERE VALKYRIE.TECNOLOGIATERMINAL.NOMTECNOLOGIATERMINAL= @p_NOMTECNOLOGIATERMINAL;
    END 
   
   
   --Obtengo el codigo del Radio
     SELECT @vCOUNT = COUNT(1)
     FROM VALKYRIE.RADIO
     WHERE VALKYRIE.RADIO.NOMRADIO = @p_NOMRADIO;
     
     
     IF @vCOUNT=0 BEGIN
       /*SELECT VALKYRIE.RADIO.ID_RADIO
        INTO vCODRADIO
       FROM VALKYRIE.RADIO
       WHERE ROWNUM=1
       ORDER BY 1 DESC;  */
       SET @vCODRADIO=7;
     END
     ELSE BEGIN
       SELECT @vCODRADIO = VALKYRIE.RADIO.ID_RADIO
       FROM VALKYRIE.RADIO
       WHERE VALKYRIE.RADIO.NOMRADIO = @p_NOMRADIO;     
     END 

     
    --Obtener la existencia del canal de comunicaciones
       SELECT @vCOUNT = COUNT(1)
       FROM VALKYRIE.CANALTRANSMISION
       WHERE VALKYRIE.CANALTRANSMISION.CODIGOLINEA=@p_CODIGOLINEA;
       --NOMCANALTRANSMISION= p_NOMBRECANAL;    
       
    --Obtengo el estado del Canal
       IF ISNULL(@p_NOMRADIO,'')='MDS' BEGIN
         SET @vACTIVO=1;
       END
       ELSE BEGIN
         SET @vACTIVO=0;         
       END 
       
       
       IF @vCOUNT=0 BEGIN
         --Obtengo el max de la tabla
       SELECT @vID_CANALTRANSMISION = MAX(VALKYRIE.CANALTRANSMISION.ID_CANALTRANSMISION)
       FROM VALKYRIE.CANALTRANSMISION;
  
         SET @vID_CANALTRANSMISION= @vID_CANALTRANSMISION +1;
       
         --Realizo el insert
         INSERT INTO VALKYRIE.CANALTRANSMISION 
         (
                ID_CANALTRANSMISION,
                NOMCANALTRANSMISION,
                CODIGOLINEA,
                ESTADO,
                FECHAHORAESTADO,
                FRECUENCIATRANSMISION,
                FRECUENCIARECEPCION,
                CODRADIO,
              --CODORIENTACION,
                ESTACION,
              --CODTIPOTRANSMISION,
              --CODOPERADORCOMUNICACION,	
                CODTECNOLOGIATERMINAL,
                CODNODOTERMINAL,
                CODUSUARIOMODIFICACION,
                FECHAHORAMODIFICACION,
                ACTIVE
         )
         VALUES 
         (
              @vID_CANALTRANSMISION,
              @p_NOMBRECANAL,
              @p_CODIGOLINEA,
              1,
              GETDATE(),
              @p_FRECUENCIATX,
              @p_FRECUENCIARX,
              @vCODRADIO,
              @p_NUMEROESTACION,                                        
              CASE WHEN @vACTIVO=1 THEN @vCODTECNOLOGIATERMINAL ELSE 5/*BASURA*/ END,
              @vCODNODOTERMINAL,
              1,
              GETDATE(),       
              @vACTIVO                   
         );
       END
       ELSE BEGIN
     --Obtengo el Id del Canal
     /*  SELECT VALKYRIE.CANALTRANSMISION.ID_CANALTRANSMISION
         INTO  vID_CANALTRANSMISION      
       FROM VALKYRIE.CANALTRANSMISION
       WHERE VALKYRIE.CANALTRANSMISION.NOMCANALTRANSMISION= p_NOMBRECANAL; */
       
         --Realizo el update
            UPDATE VALKYRIE.CANALTRANSMISION SET
            
                NOMCANALTRANSMISION=@p_NOMBRECANAL,
                CODIGOLINEA=@p_CODIGOLINEA,
                ESTADO=1,
                FECHAHORAESTADO=GETDATE(),
                FRECUENCIATRANSMISION=@p_FRECUENCIATX,
                FRECUENCIARECEPCION=@p_FRECUENCIARX,
                CODRADIO=@vCODRADIO,
              --CODORIENTACION,
                ESTACION=@p_NUMEROESTACION,
              --CODTIPOTRANSMISION,
              --CODOPERADORCOMUNICACION,	
                CODTECNOLOGIATERMINAL=CASE WHEN @vACTIVO=1 THEN @vCODTECNOLOGIATERMINAL ELSE 5/*BASURA*/ END,
                CODNODOTERMINAL=@vCODNODOTERMINAL,
                CODUSUARIOMODIFICACION=1,
                FECHAHORAMODIFICACION=GETDATE(),
                ACTIVE=  @vACTIVO
            WHERE  CODIGOLINEA=@p_CODIGOLINEA;
            --ID_CANALTRANSMISION= vID_CANALTRANSMISION;
       
       
       END 
       
       
       
  END;
GO

 
  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePDVRedExterna', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePDVRedExterna;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdatePDVRedExterna(@p_CODDUENOPUNTODEVENTA      NUMERIC(22,0),
                                        @p_CODIGOPUNTODEVENTA        NVARCHAR(2000),
                                        @p_CODIGOPUNTODEVENTARED     NVARCHAR(2000),
                                        @p_NUMEROTERMINAL            NUMERIC(22,0),
                                        @p_NONMBREPDV                NVARCHAR(2000),
                                        @p_DIRECCION                 NVARCHAR(2000),
                                        @p_CODDANECIUDADPDV          NVARCHAR(2000),
                                        @p_CODDANEDEPTOPDV           NVARCHAR(2000),
                                        @p_TELEFONO                  NVARCHAR(2000),
                                        @p_CELULAR                   NVARCHAR(2000),
                                        @p_CORREOELECTRONICO         NVARCHAR(2000),
                                        @p_CODIGOGTECHFMR            NUMERIC(22,0),
                                        @p_NOMREGIONAL               NVARCHAR(2000),
                                        @p_ACTIVE  NUMERIC(22,0))
    AS
    BEGIN     

      DECLARE @vID_USUARIOSISTEMA INT = 1;    
      DECLARE @vCOUNT                NUMERIC(22,0);
      DECLARE @MSGERROR              VARCHAR(8000);
      
      DECLARE @vID_PUNTODEVENTA      NUMERIC(22,0);
      DECLARE @vID_RAZONSOCIAL       NUMERIC(22,0);
      DECLARE @vID_CIUDAD            NUMERIC(22,0);
      DECLARE @vID_CANALDISTRIBUCION NUMERIC(22,0);
      DECLARE @vID_AGRUPACIONPDV     NUMERIC(22,0);
      DECLARE @vID_RUTAPDV           NUMERIC(22,0);
      DECLARE @vID_REGIMEN           NUMERIC(22,0);
      DECLARE @vID_IDENTIFICACION    NUMERIC(22,0);
      DECLARE @vDIGITOVERIFICACION   INT;
      DECLARE @vID_TIPONEGOCIO       NUMERIC(22,0);
      DECLARE @vID_TIPOTERMINAL      NUMERIC(22,0) = 4;--terminal externa
      DECLARE @vID_REGIONAL          NUMERIC(22,0); 
      DECLARE @vID_REDPDV            NUMERIC(22,0);    
      
      DECLARE @vCURRENTCODEXTERNO NVARCHAR(10); 
      DECLARE @vCURRENTCODDUENOPDV NUMERIC(22,0);                   
      
      DECLARE @vDANECOMPLETO         NVARCHAR(5); 
     
    SET NOCOUNT ON; 
      
    --Validar el due?o del punto de venta
    BEGIN
      SELECT    @vID_AGRUPACIONPDV = CODAGRUPACIONPUNTODEVENTA,@vID_RAZONSOCIAL = CODRAZONSOCIAL 
                     FROM WSXML_SFG.DUENOPUNTODEVENTA WHERE ID_DUENOPUNTODEVENTA = @p_CODDUENOPUNTODEVENTA;
		IF @@ROWCOUNT = 0 BEGIN
			SET @MSGERROR='-20000 No se encontro un dueño de puntos de venta con el codigo ' + ISNULL(CONVERT(VARCHAR, @p_CODDUENOPUNTODEVENTA), '');
			RAISERROR(@MSGERROR, 16, 1);
			RETURN 0
		END
    END;  
    
    IF @vID_AGRUPACIONPDV IS NULL BEGIN 
        SET @MSGERROR='-20000 No se encontro una cadena configurada en el dueno de punto de venta codigo :' + ISNULL(CONVERT(VARCHAR, @p_CODDUENOPUNTODEVENTA), '');
        RAISERROR(@MSGERROR, 16, 1);
		RETURN 0
    END 
    
    --- Get vID_REDPDV
    SELECT @vID_REDPDV = AGRUPACIONPUNTODEVENTA.CODREDPDV
    FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA 
    WHERE ID_AGRUPACIONPUNTODEVENTA =@vID_AGRUPACIONPDV ;
    
    IF @vID_RAZONSOCIAL IS NULL BEGIN 
        SET @MSGERROR='-20000 No se encontro una cadena configurada en el dueno de punto de venta codigo :' + ISNULL(CONVERT(VARCHAR, @p_CODDUENOPUNTODEVENTA), '');
        RAISERROR(@MSGERROR, 16, 1);
    END 
    
    
    SELECT @vID_REGIMEN = RAZONSOCIAL.CODREGIMEN,
           @vID_IDENTIFICACION = RAZONSOCIAL.IDENTIFICACION,
           @vDIGITOVERIFICACION = RAZONSOCIAL.DIGITOVERIFICACION
           FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.ID_RAZONSOCIAL = @vID_RAZONSOCIAL;
    
     --Validar Ciudad
    SET @vDANECOMPLETO= ISNULL(@p_CODDANEDEPTOPDV, '') + ISNULL(@p_CODDANECIUDADPDV, '');    
    
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @vDANECOMPLETO;
  
    IF @vCOUNT = 0 BEGIN
      SET @MSGERROR = '-20000 No se puede crear el punto de venta   ' +
                  ISNULL(@p_CODIGOPUNTODEVENTA, '') +
                  ' , por que no existe una ciudad con el codigo dane  ' +
                  ISNULL(CONVERT(VARCHAR, @vDANECOMPLETO), '');
      RAISERROR(@MSGERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_CIUDAD = CIUDAD.ID_CIUDAD
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @vDANECOMPLETO;

  
    --Validar regional 
    IF LEN(RTRIM(LTRIM(@p_NOMREGIONAL)))<>0
      BEGIN 
          SELECT @vID_REGIONAL = ID_REGIONAL
          FROM WSXML_SFG.REGIONAL 
          WHERE NOMREGIONAL = @p_NOMREGIONAL;
          
			IF @@ROWCOUNT = 0 BEGIN
              SET @MSGERROR = '-20000 No se puede crear el punto de venta   ' + ISNULL(@p_CODIGOPUNTODEVENTA, '') + ' por que no existe una regional con el nombre : ' + ISNULL(@p_NOMREGIONAL, '');
              RAISERROR(@MSGERROR, 16, 1);
			  RETURN 0
			END
      END;
    ELSE 
        SET @vID_REGIONAL=NULL;
    
    
    --Validar punto de venta
     BEGIN 
      
      SELECT @vID_PUNTODEVENTA = ID_PUNTODEVENTA, @vCURRENTCODEXTERNO = CODEXTERNOPUNTODEVENTA,@vCURRENTCODDUENOPDV = CODDUENOPUNTODEVENTA
      FROM WSXML_SFG.PUNTODEVENTA
      WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOPUNTODEVENTA;
      
      --El punto de venta existe , entonces validamos que el codigo externo de punto de venta y el dueno de terminal es el mismo .
      IF @vCURRENTCODEXTERNO<>@p_CODIGOPUNTODEVENTARED BEGIN 
          SET @MSGERROR = '-20000 No se puede crear el punto de venta  ' + ISNULL(@p_CODIGOPUNTODEVENTA, '') + ' por que cambiaria el codigo externo del punto.';
          RAISERROR(@MSGERROR, 16, 1);
		  RETURN 0
      END 
      
      IF @vCURRENTCODDUENOPDV<>@p_CODDUENOPUNTODEVENTA BEGIN 
          SET @MSGERROR = '-20000 No se puede crear el punto de venta  ' + ISNULL(@p_CODIGOPUNTODEVENTA, '') + ' por que cambiaria el due?o del punto.';
          RAISERROR(@MSGERROR, 16, 1);
		  RETURN 0
      END 
      
      -- Si llega hasta aqui entonces se actualiza el punto de venta
      EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord @vID_PUNTODEVENTA,
                                   @p_CODIGOPUNTODEVENTA,
                                   @p_NUMEROTERMINAL ,
                                   @p_NONMBREPDV,
                                   @vID_CIUDAD,
                                   @p_TELEFONO,
                                   @p_DIRECCION,
                                   @vID_REGIMEN,
                                   @vID_IDENTIFICACION,
                                   @vDIGITOVERIFICACION,
                                   @vID_AGRUPACIONPDV,
                                   @vID_RAZONSOCIAL,
                                    1/*dueno terminal*/,
                                   @p_CODDUENOPUNTODEVENTA,
                                   @p_CODIGOPUNTODEVENTARED,
                                   @vID_USUARIOSISTEMA,
                                   @p_ACTIVE
    
		IF @@ROWCOUNT = 0

        --El punto de venta es nuevo y debe crearse
         EXEC SFGPUNTODEVENTA_AddRecord @p_CODIGOPUNTODEVENTA,
                                    @p_NUMEROTERMINAL,
                                    @p_NONMBREPDV,
                                    @vID_CIUDAD,
                                    @p_TELEFONO,
                                    @p_DIRECCION,
                                    @vID_REGIMEN,
                                    @vID_IDENTIFICACION,
                                    @vDIGITOVERIFICACION,
                                    @vID_AGRUPACIONPDV,
                                    @vID_RAZONSOCIAL, 
                                     1/*dueno terminal*/,
                                    @p_CODDUENOPUNTODEVENTA,
                                    @p_CODIGOPUNTODEVENTARED,
                                    1,--ACTIVE
                                    @vID_USUARIOSISTEMA,
                                    @vID_PUNTODEVENTA OUT

        
        
    END;

    EXEC WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos @vID_PUNTODEVENTA,
                                        1,--TIPO NEGOCIO ND
                                        NULL,
                                        @vID_TIPOTERMINAL,
                                        NULL,
                                        0,
                                        0,
                                        NULL,
                                        NULL,
                                        0,
                                        NULL,--RUTA
                                        @vID_REGIONAL,
                                        @vID_REDPDV,
                                        @vID_USUARIOSISTEMA                                   
                                    
   


END;

 GO 

  

  IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocialExterno', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocialExterno;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocialExterno(@p_CODIGOGTECHRAZONSOCIAL   NUMERIC(22,0),
                                    @p_NOMBRERAZONSOCIAL        NVARCHAR(2000),
                                    @p_IDENTIFICACION           NUMERIC(22,0),
                                    @p_DIGITOVERIFICACION       NUMERIC(22,0),
                                    @p_CODDANECIUDADRAZONSOCIAL NVARCHAR(2000),
                                    @p_CODREGIMEN               NUMERIC(22,0),
                                    @p_NOMBRECONTACTO           NVARCHAR(2000),
                                    @p_EMAILCONTACTO            NVARCHAR(2000),
                                    @p_TELEFONOCONTACTO         NVARCHAR(2000),
                                    @p_DIRECCIONCONTACTO        NVARCHAR(2000),
                                    @p_TIPOCONTRATOJUEGOS   NVARCHAR(2000),--CONTRATO EN JUEGOS
                                    @p_TIPOCONTRATOSERVICIOS     NVARCHAR(2000)) AS
 BEGIN -- CONTRATO EN SC
    -- Codigos de Foraneas
    DECLARE @vID_RAZONSOCIAL     INT;
    DECLARE @vID_REGIMEN         INT;
    DECLARE @vID_CIUDAD          INT;
    DECLARE @vDIGITOVERIFICACION INT;
    DECLARE @vCOUNT              INT;
    DECLARE @vID_USUARIOSISTEMA  INT = 1;
    
    DECLARE @vCODTIPOCONTRATOSERVICIOS INT;
    DECLARE @vCODCOMPANIASERVICIOS INT;
    DECLARE @vCODTIPOCONTRATOJUEGOS INT;
    DECLARE @vCODCOMPANIAJUEGOS INT;
    
    DECLARE @vTMPID              INT;
    DECLARE @MSGERROERROR        VARCHAR(2000);
    
  
   
  SET NOCOUNT ON;
  
    IF  RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ADMINISTRACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=1;
      SET @vCODCOMPANIAJUEGOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ARRIENDO IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=2;
      SET @vCODCOMPANIAJUEGOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='COLABORACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=3;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='COLABORACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=3;
      SET @vCODCOMPANIAJUEGOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ARRIENDO IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=2;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ADMINISTRACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=1;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no se reconoce el tipo de contrato  ' +
                      ISNULL(@p_TIPOCONTRATOJUEGOS, '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
    
    IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ADMINISTRACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=1;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ARRIENDO IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=2;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='COLABORACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=3;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='COLABORACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=3;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ARRIENDO IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=2;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ADMINISTRACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=1;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no se reconoce el tipo de contrato  ' +
                      ISNULL(@p_TIPOCONTRATOSERVICIOS, '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  
    --Verificando consistencias 
	SET @MSGERROERROR = 'Sincronizando razon social : ' +ISNULL(CONVERT(VARCHAR,@p_CODIGOGTECHRAZONSOCIAL), '')
    EXEC WSXML_SFG.sfgtmptrace_tracelog @MSGERROERROR


    --find the city
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @p_CODDANECIUDADRAZONSOCIAL;

    IF ISNULL(@vCOUNT, 0) = 0 BEGIN
      -- It does not exist. Throw Error
    
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no existe una ciudad con el codigo dane ' +
                      ISNULL(@p_CODDANECIUDADRAZONSOCIAL, '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_CIUDAD = CIUDAD.ID_CIUDAD
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @p_CODDANECIUDADRAZONSOCIAL;
  
    --find the regimen

    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.REGIMEN
     WHERE REGIMEN.ID_REGIMEN = @p_CODREGIMEN;
  
    IF ISNULL(@vCOUNT, 0) = 0 BEGIN
      -- It does not exist. Throw Error
    
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no existe un regimen con id ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODREGIMEN), '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  

    SELECT @vID_REGIMEN = REGIMEN.ID_REGIMEN
      FROM WSXML_SFG.REGIMEN
     WHERE REGIMEN.ID_REGIMEN = @p_CODREGIMEN;
  
    --Calculate the verification number
    SET @vDIGITOVERIFICACION = WSXML_SFG.calculardigitoverificacion(@p_IDENTIFICACION);
  
    --check if there is a record with the codigogtechrazonsocial 
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
  
    IF @vCOUNT = 0 BEGIN
      -- El registro no existe y debe ser creado 
      EXEC WSXML_SFG.SFGRAZONSOCIAL_AddRecord @p_CODIGOGTECHRAZONSOCIAL,
                               @p_NOMBRERAZONSOCIAL,
                               @p_IDENTIFICACION,
                               @vDIGITOVERIFICACION,
                               @p_NOMBRECONTACTO,
                               @p_EMAILCONTACTO,
                               @p_TELEFONOCONTACTO,
                               @p_DIRECCIONCONTACTO,
                               @vID_CIUDAD,
                               @vID_REGIMEN,
                               @vID_USUARIOSISTEMA,
                               @vID_RAZONSOCIAL OUT

    --sc
    EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato @vID_RAZONSOCIAL, 
                               1/*SC*/,
                               @vCODCOMPANIASERVICIOS /*GTECH COLOMBIA*/,
                               @vCODTIPOCONTRATOSERVICIOS ,
                               @vID_RAZONSOCIAL,
                               3,/*Externo*/
                               1,
                               @vTMPID OUT
    --juegos
        EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato @vID_RAZONSOCIAL,
                               2/*JUEGOS*/,
                               @vCODCOMPANIAJUEGOS /*GTECH FOREING*/,
                               @vCODTIPOCONTRATOJUEGOS ,
                               @vID_RAZONSOCIAL,
                               3,/*Externo*/                               
                               1,
                               @vTMPID OUT
                               
    END
    ELSE BEGIN
      SELECT @vID_RAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
    
      EXEC WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord @vID_RAZONSOCIAL,
                                  @p_CODIGOGTECHRAZONSOCIAL,
                                  @p_NOMBRERAZONSOCIAL,
                                  @p_IDENTIFICACION,
                                  @vDIGITOVERIFICACION,
                                  @p_NOMBRECONTACTO,
                                  @p_EMAILCONTACTO,
                                  @p_TELEFONOCONTACTO,
                                  @p_DIRECCIONCONTACTO,
                                  @vID_CIUDAD,
                                  @vID_REGIMEN,
                                  @vID_USUARIOSISTEMA
    --sc
    EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato @vID_RAZONSOCIAL, 
                               1/*SC*/,
                               @vCODCOMPANIASERVICIOS /*GTECH COLOMBIA*/,
                               @vCODTIPOCONTRATOSERVICIOS ,
                               @vID_RAZONSOCIAL,
                               3,/*Externo*/                               
                               1,
                               @vTMPID OUT
    --juegos
       EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato @vID_RAZONSOCIAL,
                               2/*JUEGOS*/,
                               @vCODCOMPANIAJUEGOS /*GTECH FOREING*/,
                               @vCODTIPOCONTRATOJUEGOS ,
                               @vID_RAZONSOCIAL,
                               3,/*Externo*/                               
                               1,
                               @vTMPID OUT
    
    END 
  
  END;

GO




 IF OBJECT_ID('WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocial', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocial;
GO

CREATE     PROCEDURE WSXML_SFG.SFGSINCRONIZACIONSAG_InsertUpdateRazonSocial(@p_CODIGOGTECHRAZONSOCIAL   NUMERIC(22,0),
                                    @p_NOMBRERAZONSOCIAL        NVARCHAR(2000),
                                    @p_IDENTIFICACION           NUMERIC(22,0),
                                    @p_DIGITOVERIFICACION       NUMERIC(22,0),
                                    @p_CODDANECIUDADRAZONSOCIAL NVARCHAR(2000),
                                    @p_CODREGIMEN               NUMERIC(22,0),
                                    @p_NOMBRECONTACTO           NVARCHAR(2000),
                                    @p_EMAILCONTACTO            NVARCHAR(2000),
                                    @p_TELEFONOCONTACTO         NVARCHAR(2000),
                                    @p_DIRECCIONCONTACTO        NVARCHAR(2000),
                                    @p_TIPOCONTRATOJUEGOS   NVARCHAR(2000),--CONTRATO EN JUEGOS
                                    @p_TIPOCONTRATOSERVICIOS     NVARCHAR(2000)) AS
 BEGIN -- CONTRATO EN SC
    -- Codigos de Foraneas
    DECLARE @vID_RAZONSOCIAL     INT;
    DECLARE @vID_REGIMEN         INT;
    DECLARE @vID_CIUDAD          INT;
    DECLARE @vDIGITOVERIFICACION INT;
    DECLARE @vCOUNT              INT;
    DECLARE @vID_USUARIOSISTEMA  INT = 1;
    
    DECLARE @vCODTIPOCONTRATOSERVICIOS INT;
    DECLARE @vCODCOMPANIASERVICIOS INT;
    DECLARE @vCODTIPOCONTRATOJUEGOS INT;
    DECLARE @vCODCOMPANIAJUEGOS INT;
    
    DECLARE @vTMPID              INT;
    DECLARE @MSGERROERROR        VARCHAR(8000);
    
  
   
  SET NOCOUNT ON;
  
    IF  RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ADMINISTRACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=1;
      SET @vCODCOMPANIAJUEGOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ARRIENDO IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=2;
      SET @vCODCOMPANIAJUEGOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='COLABORACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=3;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='COLABORACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=3;
      SET @vCODCOMPANIAJUEGOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ARRIENDO IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=2;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='ADMINISTRACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=1;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='CONCESION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=5;
      SET @vCODCOMPANIAJUEGOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOJUEGOS)) ='CONCESION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOJUEGOS=5;
      SET @vCODCOMPANIAJUEGOS=1;            
    END
    ELSE BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no se reconoce el tipo de contrato  ' +
                      ISNULL(@p_TIPOCONTRATOJUEGOS, '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
    
    IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ADMINISTRACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=1;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ARRIENDO IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=2;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='COLABORACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=3;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='COLABORACION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=3;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ARRIENDO IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=2;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='ADMINISTRACION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=1;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='CONCESION IGT COLOMBIA' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=5;
      SET @vCODCOMPANIASERVICIOS=3;
    END
    ELSE IF RTRIM(LTRIM(@p_TIPOCONTRATOSERVICIOS)) ='CONCESION IGT FOREIGN' BEGIN 
      SET @vCODTIPOCONTRATOSERVICIOS=5;
      SET @vCODCOMPANIASERVICIOS=1;
    END
    ELSE BEGIN
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no se reconoce el tipo de contrato  ' +
                      ISNULL(@p_TIPOCONTRATOSERVICIOS, '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
    

  
  
    --Verificando consistencias 
	SET @MSGERROERROR = 'Sincronizando razon social : ' +
                         ISNULL(CONVERT(VARCHAR,@p_CODIGOGTECHRAZONSOCIAL), '')
    EXEC WSXML_SFG.sfgtmptrace_tracelog @MSGERROERROR

  
    --find the city
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @p_CODDANECIUDADRAZONSOCIAL;
  
    IF ISNULL(@vCOUNT, 0) = 0 BEGIN
      -- It does not exist. Throw Error
    
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no existe una ciudad con el codigo dane ' +
                      ISNULL(@p_CODDANECIUDADRAZONSOCIAL, '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_CIUDAD = CIUDAD.ID_CIUDAD
      FROM WSXML_SFG.CIUDAD
     WHERE CIUDAD.CIUDADDANE = @p_CODDANECIUDADRAZONSOCIAL;
  
    --find the regimen
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.REGIMEN
     WHERE REGIMEN.ID_REGIMEN = @p_CODREGIMEN;
  
    IF ISNULL(@vCOUNT, 0) = 0 BEGIN
      -- It does not exist. Throw Error
    
      SET @MSGERROERROR = '-20000 No se puede sincronizar la razon social  ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODIGOGTECHRAZONSOCIAL), '') +
                      ' por que no existe un regimen con id ' +
                      ISNULL(CONVERT(VARCHAR, @p_CODREGIMEN), '');
      RAISERROR(@MSGERROERROR, 16, 1);
	  RETURN 0
    END 
  
    SELECT @vID_REGIMEN = REGIMEN.ID_REGIMEN
      FROM WSXML_SFG.REGIMEN
     WHERE REGIMEN.ID_REGIMEN = @p_CODREGIMEN;
  
    --Calculate the verification number
    SET @vDIGITOVERIFICACION = WSXML_SFG.calculardigitoverificacion(@p_IDENTIFICACION);
  
    --check if there is a record with the codigogtechrazonsocial 
  
    SELECT @vCOUNT = COUNT(1)
      FROM WSXML_SFG.RAZONSOCIAL
     WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
  
    IF @vCOUNT = 0 BEGIN
      -- El registro no existe y debe ser creado 
      EXEC WSXML_SFG.SFGRAZONSOCIAL_AddRecord 
							   @p_CODIGOGTECHRAZONSOCIAL,
                               @p_NOMBRERAZONSOCIAL,
                               @p_IDENTIFICACION,
                               @vDIGITOVERIFICACION,
                               @p_NOMBRECONTACTO,
                               @p_EMAILCONTACTO,
                               @p_TELEFONOCONTACTO,
                               @p_DIRECCIONCONTACTO,
                               @vID_CIUDAD,
                               @vID_REGIMEN,
                               @vID_USUARIOSISTEMA,
                               @vID_RAZONSOCIAL OUT

    --sc
    EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato
							   @vID_RAZONSOCIAL, 
                               1/*SC*/,
                               @vCODCOMPANIASERVICIOS /*GTECH COLOMBIA*/,
                               @vCODTIPOCONTRATOSERVICIOS ,
                               @vID_RAZONSOCIAL,
                               1,/*CONVENSIONAL*/
                               1,
                               @vTMPID OUT
    --juegos
       EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato	
								@vID_RAZONSOCIAL,
                               2/*JUEGOS*/,
                               @vCODCOMPANIAJUEGOS /*GTECH FOREING*/,
                               @vCODTIPOCONTRATOJUEGOS ,
                               @vID_RAZONSOCIAL,
                               1,/*CONVENSIONAL*/                               
                               1,
                               @vTMPID OUT
                               
    END
    ELSE BEGIN
      SELECT @vID_RAZONSOCIAL = RAZONSOCIAL.ID_RAZONSOCIAL
        FROM WSXML_SFG.RAZONSOCIAL
       WHERE RAZONSOCIAL.CODIGOGTECHRAZONSOCIAL = @p_CODIGOGTECHRAZONSOCIAL;
    
      EXEC WSXML_SFG.SFGRAZONSOCIAL_UpdateRecord 
								  @vID_RAZONSOCIAL,
                                  @p_CODIGOGTECHRAZONSOCIAL,
                                  @p_NOMBRERAZONSOCIAL,
                                  @p_IDENTIFICACION,
                                  @vDIGITOVERIFICACION,
                                  @p_NOMBRECONTACTO,
                                  @p_EMAILCONTACTO,
                                  @p_TELEFONOCONTACTO,
                                  @p_DIRECCIONCONTACTO,
                                  @vID_CIUDAD,
                                  @vID_REGIMEN,
                                  @vID_USUARIOSISTEMA
    --sc
    EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato 
							  @vID_RAZONSOCIAL, 
                               1/*SC*/,
                               @vCODCOMPANIASERVICIOS /*GTECH COLOMBIA*/,
                               @vCODTIPOCONTRATOSERVICIOS ,
                               @vID_RAZONSOCIAL,
                               1,/*CONVENSIONAL*/                               
                               1,
                               @vTMPID OUT
    --juegos
     EXEC WSXML_SFG.SFGRAZONSOCIAL_SetContrato
								@vID_RAZONSOCIAL,
                               2/*JUEGOS*/,
                               @vCODCOMPANIAJUEGOS /*GTECH FOREING*/,
                               @vCODTIPOCONTRATOJUEGOS ,
                               @vID_RAZONSOCIAL,
                               1,/*CONVENSIONAL*/                               
                               1,
                               @vTMPID OUT
    
    END 
  
  END;
  GO


  