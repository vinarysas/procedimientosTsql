USE SFGPRODU;
--  DDL for Package Body SFGRETUVTREGFACTURACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGRETUVTREGFACTURACION */ 

  IF OBJECT_ID('WSXML_SFG.SFGRETUVTREGFACTURACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRETUVTREGFACTURACION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRETUVTREGFACTURACION_AddRecord(@p_CODRETENCIONUVT           NUMERIC(22,0),
                      @p_CODENTRADAARCHIVOCONTROL  NUMERIC(22,0),
                      @p_CODREGISTROFACTURACION    NUMERIC(22,0),
                      @p_CODTIPOREGISTRO           NUMERIC(22,0),
                      @p_VALORRETENCION            FLOAT,
                      @p_RETENCIONXNIT             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                      @p_ID_RETUVTREGFACTURACN_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.RETUVTREGFACTURACION (
                                      CODRETENCIONUVT,
                                      CODENTRADAARCHIVOCONTROL,
                                      CODREGISTROFACTURACION,
                                      CODTIPOREGISTRO,
                                      VALORRETENCION,
                                      RETENCIONXNIT,
                                      CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODRETENCIONUVT,
            @p_CODENTRADAARCHIVOCONTROL,
            @p_CODREGISTROFACTURACION,
            @p_CODTIPOREGISTRO,
            @p_VALORRETENCION,
            @p_RETENCIONXNIT,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_RETUVTREGFACTURACN_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRETUVTREGFACTURACION_UpdateValue', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRETUVTREGFACTURACION_UpdateValue;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRETUVTREGFACTURACION_UpdateValue(@pk_ID_RETUVTREGFACTURACION NUMERIC(22,0), @p_VALOR FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.RETUVTREGFACTURACION SET VALORRETENCION = @p_VALOR WHERE ID_RETUVTREGFACTURACION = @pk_ID_RETUVTREGFACTURACION;
  END;
GO






