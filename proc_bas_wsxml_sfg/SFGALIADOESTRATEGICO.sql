USE SFGPRODU;
--  DDL for Package Body SFGALIADOESTRATEGICO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGALIADOESTRATEGICO */ 

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_AddRecord(@p_NOMALIADOESTRATEGICO         VARCHAR(4000),
                      @p_NUMEROIDENTIFICACION         VARCHAR(4000),
                      @p_NOMBRERAZONSOCIAL            VARCHAR(4000),
                      @p_CONTACTOCONTRATACION         VARCHAR(4000),
                      @p_TELEFONOCONTACTO             VARCHAR(4000),
                      @p_DIRECCIONCONTACTO            VARCHAR(4000),
                      @p_CONTRATO                     VARCHAR(4000),
                      @p_CODCIUDAD                    NUMERIC(22,0),
                      @p_CODREGIMEN                   NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_ALIADOESTRATEGICO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.ALIADOESTRATEGICO (
                                   NOMALIADOESTRATEGICO,
                                   NUMEROIDENTIFICACION,
                                   NOMBRERAZONSOCIAL,
                                   CONTACTOCONTRATACION,
                                   TELEFONOCONTACTO,
                                   DIRECCIONCONTACTO,
                                   CODCIUDAD,
                                   CODREGIMEN,
                                   CONTRATO,
                                   CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMALIADOESTRATEGICO,
            @p_NUMEROIDENTIFICACION,
            @p_NOMBRERAZONSOCIAL,
            @p_CONTACTOCONTRATACION,
            @p_TELEFONOCONTACTO,
            @p_DIRECCIONCONTACTO,
            @p_CODCIUDAD,
            @p_CODREGIMEN,
            @p_CONTRATO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_ALIADOESTRATEGICO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_UpdateRecord(@pk_ID_ALIADOESTRATEGICO        NUMERIC(22,0),
                         @p_NOMALIADOESTRATEGICO         VARCHAR(4000),
                         @p_NUMEROIDENTIFICACION         VARCHAR(4000),
                         @p_NOMBRERAZONSOCIAL            VARCHAR(4000),
                         @p_CONTACTOCONTRATACION         VARCHAR(4000),
                         @p_TELEFONOCONTACTO             VARCHAR(4000),
                         @p_DIRECCIONCONTACTO            VARCHAR(4000),
                         @p_CONTRATO                     VARCHAR(4000),
                         @p_CODCIUDAD                    NUMERIC(22,0),
                         @p_CODREGIMEN                   NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                         @p_ACTIVE                       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ALIADOESTRATEGICO
       SET NOMALIADOESTRATEGICO          = @p_NOMALIADOESTRATEGICO,
           NUMEROIDENTIFICACION          = @p_NUMEROIDENTIFICACION,
           NOMBRERAZONSOCIAL             = @p_NOMBRERAZONSOCIAL,
           CONTACTOCONTRATACION          = @p_CONTACTOCONTRATACION,
           TELEFONOCONTACTO              = @p_TELEFONOCONTACTO,
           DIRECCIONCONTACTO             = @p_DIRECCIONCONTACTO,
           CODCIUDAD                     = @p_CODCIUDAD,
           CODREGIMEN                    = @p_CODREGIMEN,
           CONTRATO                      = @p_CONTRATO,
           CODUSUARIOMODIFICACION        = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION         = GETDATE(),
           ACTIVE                        = @p_ACTIVE
     WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetRecord(@pk_ID_ALIADOESTRATEGICO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.ALIADOESTRATEGICO WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
		
      SELECT AE.ID_ALIADOESTRATEGICO,
             AE.NOMALIADOESTRATEGICO,
             AE.NUMEROIDENTIFICACION,
             AE.NOMBRERAZONSOCIAL,
             AE.CONTACTOCONTRATACION,
             AE.TELEFONOCONTACTO,
             AE.DIRECCIONCONTACTO,
             AE.CODCIUDAD,
             CD.NOMCIUDAD,
             CD.CODDEPARTAMENTO,
             DP.NOMDEPARTAMENTO,
             AE.CODREGIMEN,
             RG.NOMREGIMEN,
             AE.CONTRATO,
             AE.ACTIVE,
             AE.FECHAHORAMODIFICACION
       FROM WSXML_SFG.ALIADOESTRATEGICO AE
       LEFT OUTER JOIN WSXML_SFG.CIUDAD CD ON (AE.CODCIUDAD = CD.ID_CIUDAD)
       LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO DP ON (CD.CODDEPARTAMENTO = DP.ID_DEPARTAMENTO)
       LEFT OUTER JOIN WSXML_SFG.REGIMEN RG ON (AE.CODREGIMEN = RG.ID_REGIMEN)
       WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_DeactivateRecord(@pk_ID_ALIADOESTRATEGICO  NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.ALIADOESTRATEGICO
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT AE.ID_ALIADOESTRATEGICO,
             AE.NOMALIADOESTRATEGICO,
             AE.NUMEROIDENTIFICACION,
             AE.CODUSUARIOMODIFICACION,
             AE.NOMBRERAZONSOCIAL,
             AE.CONTACTOCONTRATACION,
             AE.TELEFONOCONTACTO,
             AE.DIRECCIONCONTACTO,
             AE.CODCIUDAD,
             CD.NOMCIUDAD,
             CD.CODDEPARTAMENTO,
             DP.NOMDEPARTAMENTO,
             AE.CODREGIMEN,
             RG.NOMREGIMEN,
             AE.CONTRATO,
             AE.ACTIVE,
             AE.FECHAHORAMODIFICACION
       FROM WSXML_SFG.ALIADOESTRATEGICO AE
       LEFT OUTER JOIN WSXML_SFG.CIUDAD CD ON (AE.CODCIUDAD = CD.ID_CIUDAD)
       LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO DP ON (CD.CODDEPARTAMENTO = DP.ID_DEPARTAMENTO)
       LEFT OUTER JOIN WSXML_SFG.REGIMEN RG ON (AE.CODREGIMEN = RG.ID_REGIMEN)
       WHERE AE.ACTIVE = CASE WHEN @p_active = -1 THEN AE.ACTIVE ELSE @p_active END;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_GetListTipoProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetListTipoProducto;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetListTipoProducto(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_ALIADOESTRATEGICO, NOMALIADOESTRATEGICO, CODTIPOPRODUCTO 
	  FROM WSXML_SFG.ALIADOESTRATEGICO A
		LEFT OUTER JOIN WSXML_SFG.PRODUCTO P ON P.CODALIADOESTRATEGICO = A.ID_ALIADOESTRATEGICO
      WHERE CODTIPOPRODUCTO IS NOT NULL
        AND A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END
        AND P.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN P.ACTIVE ELSE @p_ACTIVE END
      GROUP BY ID_ALIADOESTRATEGICO, NOMALIADOESTRATEGICO, CODTIPOPRODUCTO;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_GetListByNumeroIdentificacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetListByNumeroIdentificacion;
GO
CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_GetListByNumeroIdentificacion(@p_active NUMERIC(22,0), @p_NumeroIdentificacion VARCHAR(4000)) AS
  BEGIN
  SET NOCOUNT ON;
  
      SELECT ID_ALIADOESTRATEGICO,
             NOMALIADOESTRATEGICO,
             NUMEROIDENTIFICACION
        FROM WSXML_SFG.ALIADOESTRATEGICO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END
         AND NUMEROIDENTIFICACION = CASE WHEN @p_NumeroIdentificacion = '-1' THEN NUMEROIDENTIFICACION ELSE @p_NumeroIdentificacion END
       ORDER BY NOMALIADOESTRATEGICO;
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_SetAliadoCiudad', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_SetAliadoCiudad;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_SetAliadoCiudad(@pk_ID_ALIADOESTRATEGICO  NUMERIC(22,0),
                            @p_CODCIUDAD              NUMERIC(22,0),
                            @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @vALIADO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    BEGIN
		SELECT @vALIADO =  ID_ALIADOESTRATEGICO FROM WSXML_SFG.ALIADOESTRATEGICO WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO

		IF @@rowcount = 0 BEGIN
			RAISERROR('-20054 No existe el aliado estrategico', 16, 1);
			RETURN 0
		END
	END
	
    UPDATE WSXML_SFG.ALIADOESTRATEGICO 
	SET CODCIUDAD              = @p_CODCIUDAD,
		 CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
		 FECHAHORAMODIFICACION  = GETDATE()
    WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO
END
GO


  IF OBJECT_ID('WSXML_SFG.SFGALIADOESTRATEGICO_SetAliadoInformacionFacturable', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_SetAliadoInformacionFacturable;
GO

CREATE     PROCEDURE WSXML_SFG.SFGALIADOESTRATEGICO_SetAliadoInformacionFacturable(@pk_ID_ALIADOESTRATEGICO  NUMERIC(22,0),
                                           @p_NOMBRERAZONSOCIAL      NVARCHAR(2000),
                                           @p_NUMEROIDENTIFICACION   NVARCHAR(2000),
                                           @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @vALIADO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    BEGIN
      SELECT @vALIADO = ID_ALIADOESTRATEGICO FROM WSXML_SFG.ALIADOESTRATEGICO WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO;
		--EXCEPTION WHEN NO_DATA_FOUND THEN
		IF @@rowcount = 0 BEGIN
			RAISERROR('-20054 No existe el aliado estrategico', 16, 1);
			RETURN 0;
		END
    END;
    UPDATE WSXML_SFG.ALIADOESTRATEGICO SET 
			NOMBRERAZONSOCIAL      = @p_NOMBRERAZONSOCIAL,
			NUMEROIDENTIFICACION   = @p_NUMEROIDENTIFICACION,
			CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
			FECHAHORAMODIFICACION  = GETDATE()
    WHERE ID_ALIADOESTRATEGICO = @pk_ID_ALIADOESTRATEGICO;
  END;
GO






