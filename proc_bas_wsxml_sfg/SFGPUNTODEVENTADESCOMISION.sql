USE SFGPRODU;
--  DDL for Package Body SFGPUNTODEVENTADESCOMISION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPUNTODEVENTADESCOMISION */ 

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_AddRecord(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                      @p_CODCONFIGDESCOMISION   NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_PDVDESCOMISION_out  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PUNTODEVENTADESCOMISION (
                                         CODPUNTODEVENTA,
                                         CODCONFIGDESCOMISION,
                                         CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODPUNTODEVENTA,
            @p_CODCONFIGDESCOMISION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PDVDESCOMISION_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_UpdateRecord(@pk_ID_PDVDESCOMISION     NUMERIC(22,0),
                         @p_CODPUNTODEVENTA        NUMERIC(22,0),
                         @p_CODCONFIGDESCOMISION   NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PUNTODEVENTADESCOMISION
       SET CODPUNTODEVENTA        = @p_CODPUNTODEVENTA,
           CODCONFIGDESCOMISION   = @p_CODCONFIGDESCOMISION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_PUNTODEVENTADESCOMISION = @pk_ID_PDVDESCOMISION;
	
	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_SetDesComisionContext', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_SetDesComisionContext;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_SetDesComisionContext(@p_CODPUNTODEVENTA        NUMERIC(22,0),
                                  @p_CODCONFIGDESCOMISION   NUMERIC(22,0),
                                  @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                                  @p_ID_PDVDESCOMISION_out  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_PDVDESCOMISION_out = ID_PUNTODEVENTADESCOMISION FROM WSXML_SFG.PUNTODEVENTADESCOMISION
    WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND CODCONFIGDESCOMISION = @p_CODCONFIGDESCOMISION AND ACTIVE = 1;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
	IF @rowcount = 0 BEGIN
		UPDATE WSXML_SFG.PUNTODEVENTADESCOMISION SET ACTIVE = 0
		WHERE CODPUNTODEVENTA = @p_CODPUNTODEVENTA AND ACTIVE = 1;
		EXEC WSXML_SFG.SFGPUNTODEVENTADESCOMISION_AddRecord @p_CODPUNTODEVENTA,
											 @p_CODCONFIGDESCOMISION,
											 @p_CODUSUARIOMODIFICACION,
											 @p_ID_PDVDESCOMISION_out OUT
	END
	IF @rowcount > 1 BEGIN
		DECLARE @msg VARCHAR(2000) =  '-20060 Error de consistencia. El punto de venta ' + ISNULL(WSXML_SFG.PUNTODEVENTA_CODIGO_F(@p_CODPUNTODEVENTA), '') + ' tiene mas de una configuracion de descuentos configurada'
	    RAISERROR(@msg, 16, 1);
	END
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_DeactivateRecord(@pk_ID_PDVDESCOMISION NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PUNTODEVENTADESCOMISION
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_PUNTODEVENTADESCOMISION = @pk_ID_PDVDESCOMISION;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRecord(@pk_ID_PDVDESCOMISION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.PUNTODEVENTADESCOMISION
     WHERE ID_PUNTODEVENTADESCOMISION = @pk_ID_PDVDESCOMISION;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_PUNTODEVENTADESCOMISION,
             CODPUNTODEVENTA,
             CODCONFIGDESCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PUNTODEVENTADESCOMISION
       WHERE ID_PUNTODEVENTADESCOMISION = @pk_ID_PDVDESCOMISION;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_PUNTODEVENTADESCOMISION,
             CODPUNTODEVENTA,
             CODCONFIGDESCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PUNTODEVENTADESCOMISION
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetListPorDefecto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetListPorDefecto;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetListPorDefecto(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT 0 ID_PUNTODEVENTADESCOMISION,
             LDN.ID_LINEADENEGOCIO,
             LDN.NOMLINEADENEGOCIO,
             LDN.ID_LINEADENEGOCIO CODLINEADENEGOCIODESCUENTO
      FROM WSXML_SFG.LINEADENEGOCIO LDN
      WHERE LDN.ACTIVE = 1;
  END;
GO



  /* Obtencion de los registros de DESCOMISIONLINEADENEGOCIO para aplicar a la facturacion activa */

IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SFGPUNTODEVENTADESCOMISION_GetRedDistribucionDescuentos'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRedDistribucionDescuentos
GO

CREATE     FUNCTION WSXML_SFG.SFGPUNTODEVENTADESCOMISION_GetRedDistribucionDescuentos() 
RETURNS @configreddistribucion table (CODPUNTODEVENTA NUMERIC(38,0), CONFIGURACION VARCHAR(MAX)) AS --WSXML_SFG.PDVDESCUENTOS
 BEGIN
    -- Configuraciones disponibles con al menos un descuento
    DECLARE cDESCUENTOS CURSOR LOCAL FOR
      SELECT D.ID_CONFIGDESCOMISION, D.DEFECTO FROM WSXML_SFG.CONFIGDESCOMISION D
      LEFT OUTER JOIN WSXML_SFG.DESCOMISIONLINEADENEGOCIO L ON (L.CODCONFIGDESCOMISION = D.ID_CONFIGDESCOMISION) WHERE D.ACTIVE = 1
      GROUP BY D.ID_CONFIGDESCOMISION, D.DEFECTO HAVING COUNT(L.ID_DESCOMISIONLINEADENEGOCIO) > 0 ORDER BY DEFECTO;


	  DECLARE @configuration varchar(MAX)
   
   DECLARE  @cDESCUENTOS__ID_CONFIGDESCOMISION   NUMERIC(38,0), @cDESCUENTOS__DEFECTO  NUMERIC(38,0)
    OPEN cDESCUENTOS;
    WHILE 1=1 BEGIN
      FETCH cDESCUENTOS INTO @cDESCUENTOS__ID_CONFIGDESCOMISION, @cDESCUENTOS__DEFECTO;
      IF @@FETCH_STATUS <> 0 BREAK ;

      IF @cDESCUENTOS__DEFECTO = 0 BEGIN
          DECLARE @attachedPOS WSXML_SFG.MEDIUMNUMBERARRAY;
         
        BEGIN
          -- Lista de puntos de venta seteados a la configuracion
		  INSERT INTO @attachedPOS 
          SELECT CODPUNTODEVENTA 
		  FROM WSXML_SFG.PUNTODEVENTADESCOMISION
          WHERE CODCONFIGDESCOMISION = @cDESCUENTOS__ID_CONFIGDESCOMISION AND ACTIVE = 1;
          -- Configuracion actual

		  SET @configuration = STUFF((
			SELECT '|'+T.CAMPO
			FROM (
					SELECT CONVERT(VARCHAR,CODLINEADENEGOCIO)+','+CONVERT(VARCHAR,CODLINEADENEGOCIODESCUENTO) AS CAMPO
					FROM WSXML_SFG.DESCOMISIONLINEADENEGOCIO 
					WHERE CODCONFIGDESCOMISION = @cDESCUENTOS__ID_CONFIGDESCOMISION
					
			) T
			FOR XML PATH('')
		),1,1, '')


          
          -- Asumiendo que no hay registros duplicados, insertar a lista
          DECLARE ix CURSOR FOR SELECT IDVALUE FROM @attachedPOS
		  
		  DECLARE @ix__IDVALUE NUMERIC(38,0)

		  FETCH NEXT FROM ix INTO @ix__IDVALUE
        
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
            
	            INSERT INTO @configreddistribucion VALUES (@ix__IDVALUE, @configuration);
				FETCH NEXT FROM ix INTO @ix__IDVALUE
			END;

          CLOSE ix;
          DEALLOCATE ix;
        END;

      END
      ELSE IF @cDESCUENTOS__DEFECTO = 1 BEGIN
          DECLARE @missing WSXML_SFG.MEDIUMNUMBERARRAY;
         
        BEGIN
          -- Configuracion por defecto

		  SET @configuration = STUFF((
			SELECT '|'+T.CAMPO
			FROM (
					SELECT CONVERT(VARCHAR,CODLINEADENEGOCIO)+','+ CONVERT(VARCHAR,CODLINEADENEGOCIODESCUENTO) AS CAMPO
					FROM WSXML_SFG.DESCOMISIONLINEADENEGOCIO WHERE CODCONFIGDESCOMISION = @cDESCUENTOS__ID_CONFIGDESCOMISION
					
			) T
			FOR XML PATH('')
		),1,1, '')


          
          -- Pueden haber registros ya ingresados a la lista. Concatenar red de distribucion faltante
          INSERT INTO @missing 
		  SELECT ID_PUNTODEVENTA 
		  FROM WSXML_SFG.PUNTODEVENTA
          WHERE ID_PUNTODEVENTA NOT IN (SELECT CODPUNTODEVENTA FROM @configreddistribucion);
          DECLARE ix2 CURSOR FOR SELECT IDVALUE FROM @missing
			OPEN ix2
			DECLARE @ix2__IDVALUE NUMERIC(38,0)
			FETCH NEXT FROM ix INTO @ix2__IDVALUE
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				INSERT INTO @configreddistribucion VALUES (@ix2__IDVALUE, @configuration);
				FETCH NEXT FROM ix INTO @ix2__IDVALUE
			END;

          CLOSE ix2;
          DEALLOCATE ix2;
        END;

      END 
    END;

    CLOSE cDESCUENTOS;
    DEALLOCATE cDESCUENTOS;
    RETURN

	--EXCEPTION WHEN OTHERS THEN
    --RAISERROR('-20054 No se pudo obtener las configuraciones de descuento de comision', 16, 1);
 END;
GO