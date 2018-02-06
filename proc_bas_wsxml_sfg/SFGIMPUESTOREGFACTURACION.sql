USE SFGPRODU;
--  DDL for Package Body SFGIMPUESTOREGFACTURACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGIMPUESTOREGFACTURACION */ 

  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTOREGFACTURACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_AddRecord(
					@p_CODIMPUESTO                  NUMERIC(22,0),
                    @p_CODPRODUCTOIMPUESTO          NUMERIC(22,0),
                    @p_CODENTRADAARCHIVOCONTROL     NUMERIC(22,0),
                    @p_CODREGISTROFACTURACION       NUMERIC(22,0),
                    @p_CODTIPOREGISTRO              NUMERIC(22,0),
                    @p_VALORIMPUESTO                FLOAT,
                    @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                    @p_ID_IMPUESTOREGFACTURACIN_out NUMERIC(22,0) OUT
) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.IMPUESTOREGFACTURACION (
                                        CODIMPUESTO,
                                        CODPRODUCTOIMPUESTO,
                                        CODENTRADAARCHIVOCONTROL,
                                        CODREGISTROFACTURACION,
                                        CODTIPOREGISTRO,
                                        VALORIMPUESTO,
                                        CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODIMPUESTO,
            @p_CODPRODUCTOIMPUESTO,
            @p_CODENTRADAARCHIVOCONTROL,
            @p_CODREGISTROFACTURACION,
            @p_CODTIPOREGISTRO,
            @p_VALORIMPUESTO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_IMPUESTOREGFACTURACIN_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTOREGFACTURACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_UpdateRecord(@pk_ID_IMPUESTOREGFACTURACION NUMERIC(22,0),
                         @p_CODPRODUCTOIMPUESTO        NUMERIC(22,0),
                         @p_CODREGISTROFACTURACION     NUMERIC(22,0),
                         @p_VALORIMPUESTO              FLOAT,
                         @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                         @p_ACTIVE                     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.IMPUESTOREGFACTURACION
       SET CODPRODUCTOIMPUESTO       = @p_CODPRODUCTOIMPUESTO,
           CODREGISTROFACTURACION    = @p_CODREGISTROFACTURACION,
           VALORIMPUESTO             = @p_VALORIMPUESTO,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION     = GETDATE(),
           ACTIVE                    = @p_ACTIVE
     WHERE ID_IMPUESTOREGFACTURACION = @pk_ID_IMPUESTOREGFACTURACION;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGIMPUESTOREGFACTURACION_UpdateValue', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_UpdateValue;
GO

CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_UpdateValue(@pk_ID_IMPUESTOREGFACTURACION NUMERIC(22,0), @p_VALOR FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.IMPUESTOREGFACTURACION SET VALORIMPUESTO = @p_VALOR WHERE ID_IMPUESTOREGFACTURACION = @pk_ID_IMPUESTOREGFACTURACION;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTOREGFACTURACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_GetRecord(@pk_ID_IMPUESTOREGFACTURACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*) FROM WSXML_SFG.IMPUESTOREGFACTURACION
     WHERE ID_IMPUESTOREGFACTURACION = @pk_ID_IMPUESTOREGFACTURACION;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_IMPUESTOREGFACTURACION,
             CODIMPUESTO,
             CODPRODUCTOIMPUESTO,
             CODREGISTROFACTURACION,
             VALORIMPUESTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.IMPUESTOREGFACTURACION
       WHERE ID_IMPUESTOREGFACTURACION = @pk_ID_IMPUESTOREGFACTURACION;
	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGIMPUESTOREGFACTURACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGIMPUESTOREGFACTURACION_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_IMPUESTOREGFACTURACION,
             CODIMPUESTO,
             CODPRODUCTOIMPUESTO,
             CODREGISTROFACTURACION,
             VALORIMPUESTO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.IMPUESTOREGFACTURACION
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	   
  END;
