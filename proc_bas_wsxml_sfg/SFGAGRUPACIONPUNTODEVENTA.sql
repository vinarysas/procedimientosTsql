USE SFGPRODU;
--  DDL for Package Body SFGAGRUPACIONPUNTODEVENTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA */ 

  IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AddRecord(@p_NOMAGRUPACIONPUNTODEVENTA    NVARCHAR(2000),
                      @p_CODIGOAGRUPACIONGTECH        VARCHAR(4000),
                      @p_CODTIPOPUNTODEVENTA          NUMERIC(22,0),
                      @p_CODREDPDV                    NUMERIC(22,0),                      
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_AGRUPACIONPUNTODEVENT_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.AGRUPACIONPUNTODEVENTA (
                                        NOMAGRUPACIONPUNTODEVENTA,
                                        CODIGOAGRUPACIONGTECH,
                                        CODTIPOPUNTODEVENTA,
                                        CODREDPDV,
                                        CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMAGRUPACIONPUNTODEVENTA,
            @p_CODIGOAGRUPACIONGTECH,
            @p_CODTIPOPUNTODEVENTA,
            @p_CODREDPDV,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_AGRUPACIONPUNTODEVENT_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateRecord;
GO

CREATE  PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateRecord(@pk_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0),
                         @p_NOMAGRUPACIONPUNTODEVENTA  NVARCHAR(2000),
                         @p_CODIGOAGRUPACIONGTECH      VARCHAR(4000),
                         @p_CODTIPOPUNTODEVENTA        NUMERIC(22,0),
                         @p_CODREDPDV                    NUMERIC(22,0),                         
                         @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                         @p_ACTIVE                     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.AGRUPACIONPUNTODEVENTA
       SET NOMAGRUPACIONPUNTODEVENTA = @p_NOMAGRUPACIONPUNTODEVENTA,
           CODIGOAGRUPACIONGTECH     = @p_CODIGOAGRUPACIONGTECH,
           CODTIPOPUNTODEVENTA       = @p_CODTIPOPUNTODEVENTA,
           CODREDPDV                 = @p_CODREDPDV,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           ACTIVE                    = @p_ACTIVE
     WHERE ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecord(@pk_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA WHERE ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

     SELECT ID_AGRUPACIONPUNTODEVENTA,
             NOMAGRUPACIONPUNTODEVENTA,
             CODIGOAGRUPACIONGTECH,
             CODTIPOPUNTODEVENTA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
       WHERE ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecordWithData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecordWithData;
GO
CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecordWithData(@pk_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA WHERE ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

	 
	SELECT AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA,
		AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,
		AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,
		AGRUPACIONPUNTODEVENTA.CODTIPOPUNTODEVENTA,
		TIPOPUNTODEVENTA.NOMTIPOPUNTODEVENTA,
		AGRUPACIONPUNTODEVENTA.FECHAHORAMODIFICACION,
		AGRUPACIONPUNTODEVENTA.CODUSUARIOMODIFICACION,
		USUARIO.NOMUSUARIO,
		AGRUPACIONPUNTODEVENTA.ACTIVE
    FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
        LEFT OUTER JOIN TIPOPUNTODEVENTA
          ON (TIPOPUNTODEVENTA.ID_TIPOPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.CODTIPOPUNTODEVENTA)
        LEFT OUTER JOIN USUARIO
          ON (USUARIO.ID_USUARIO = AGRUPACIONPUNTODEVENTA.CODUSUARIOMODIFICACION)
	WHERE ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecordByCodigoAgrupacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecordByCodigoAgrupacion;
GO
CREATE PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetRecordByCodigoAgrupacion(@p_CODIGOAGRUPACIONGTECH VARCHAR(4000)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA WHERE CODIGOAGRUPACIONGTECH = @p_CODIGOAGRUPACIONGTECH;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    
	SELECT ID_AGRUPACIONPUNTODEVENTA,
             NOMAGRUPACIONPUNTODEVENTA,
             CODIGOAGRUPACIONGTECH,
             CODTIPOPUNTODEVENTA,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
    FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
    WHERE CODIGOAGRUPACIONGTECH = @p_CODIGOAGRUPACIONGTECH;
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetList(@p_active NUMERIC(22,0)) AS
BEGIN
	SET NOCOUNT ON;
	
    SELECT ID_AGRUPACIONPUNTODEVENTA,
		NOMAGRUPACIONPUNTODEVENTA,
		CODIGOAGRUPACIONGTECH,
		CODTIPOPUNTODEVENTA,
		FECHAHORAMODIFICACION,
		CODUSUARIOMODIFICACION,
		ACTIVE
    FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
    WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END
        AND ID_AGRUPACIONPUNTODEVENTA <> WSXML_SFG.AGRUPACION_F(0)
    ORDER BY CAST(CODIGOAGRUPACIONGTECH AS INT);
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetListWithData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetListWithData;
GO
CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_GetListWithData(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    
	SELECT AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA,
		 AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,
		 AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH,
		 AGRUPACIONPUNTODEVENTA.CODTIPOPUNTODEVENTA,
		 TIPOPUNTODEVENTA.NOMTIPOPUNTODEVENTA,
		 AGRUPACIONPUNTODEVENTA.FECHAHORAMODIFICACION,
		 AGRUPACIONPUNTODEVENTA.CODUSUARIOMODIFICACION,
		 USUARIO.NOMUSUARIO,
		 AGRUPACIONPUNTODEVENTA.ACTIVE
	FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
        LEFT OUTER JOIN TIPOPUNTODEVENTA
          ON (TIPOPUNTODEVENTA.ID_TIPOPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.CODTIPOPUNTODEVENTA)
        LEFT OUTER JOIN USUARIO
          ON (USUARIO.ID_USUARIO = AGRUPACIONPUNTODEVENTA.CODUSUARIOMODIFICACION)
       WHERE AGRUPACIONPUNTODEVENTA.ACTIVE = CASE WHEN @p_active = -1 THEN AGRUPACIONPUNTODEVENTA.ACTIVE ELSE @p_active END
    ORDER BY CAST(CODIGOAGRUPACIONGTECH AS INT);
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_Busqueda', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_Busqueda;
GO
CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_Busqueda(@p_dato NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_AGRUPACIONPUNTODEVENTA, NOMAGRUPACIONPUNTODEVENTA, CODIGOAGRUPACIONGTECH
        FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA
       WHERE ID_AGRUPACIONPUNTODEVENTA LIKE '%' + isnull(@p_dato, '') + '%'
          OR NOMAGRUPACIONPUNTODEVENTA LIKE '%' + isnull(@p_dato, '') + '%'
          OR CODIGOAGRUPACIONGTECH LIKE '%' + isnull(@p_dato, '') + '%';
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateCabeza', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateCabeza;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_UpdateCabeza(@pk_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0), @p_CODPUNTODEVENTA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.AGRUPACIONPUNTODEVENTA
       SET CODPUNTODEVENTACABEZA = @p_CODPUNTODEVENTA,
           FECHAHORAMODIFICACION = GETDATE()
     WHERE ID_AGRUPACIONPUNTODEVENTA = @pk_ID_AGRUPACIONPUNTODEVENTA;
  END;
GO
  IF OBJECT_ID('WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AgrupacionesPorNit', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AgrupacionesPorNit;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAGRUPACIONPUNTODEVENTA_AgrupacionesPorNit( @P_NIT NVARCHAR(2000)

                               )
  AS
  BEGIN
      DECLARE @V_REGISTROS  NUMERIC(22,0);
   
  SET NOCOUNT ON;

       SET @V_REGISTROS = 0;

        SELECT @V_REGISTROS = COUNT(*)
        FROM WSXML_SFG.RAZONSOCIAL
        WHERE ISNULL(RAZONSOCIAL.IDENTIFICACION, '') + '-' + ISNULL(RAZONSOCIAL.DIGITOVERIFICACION, '') = @P_NIT;

        IF @V_REGISTROS = 0 BEGIN
				DECLARE @msg VARCHAR(200) = '-20054 El Nit ' + ISNULL(@P_NIT, '') + ' no corresponde a una Raz?n Social';
              RAISERROR(@msg, 16, 1);
        END
        ELSE BEGIN
              
			SELECT
				AGP.ID_AGRUPACIONPUNTODEVENTA AS IDCADENA
				,AGP.CODIGOAGRUPACIONGTECH    AS CODIGOGTECHCADENA
				,AGP.NOMAGRUPACIONPUNTODEVENTA AS NOMBRECADENA
            FROM  WSXML_SFG.AGRUPACIONPUNTODEVENTA AGP
            INNER JOIN    PUNTODEVENTA PV ON PV.CODAGRUPACIONPUNTODEVENTA = AGP.ID_AGRUPACIONPUNTODEVENTA
            INNER JOIN    RAZONSOCIAL RZ ON PV.CODRAZONSOCIAL = RZ.ID_RAZONSOCIAL
            WHERE ISNULL(RZ.IDENTIFICACION, '') + '-' + ISNULL(RZ.DIGITOVERIFICACION, '') = @P_NIT
            --AND AGP.CODTIPOPUNTODEVENTA<>3
            GROUP BY AGP.ID_AGRUPACIONPUNTODEVENTA
                    ,AGP.CODIGOAGRUPACIONGTECH
                    ,AGP.NOMAGRUPACIONPUNTODEVENTA
            ORDER BY AGP.CODIGOAGRUPACIONGTECH  ;
			 
        END 

  END;
GO





