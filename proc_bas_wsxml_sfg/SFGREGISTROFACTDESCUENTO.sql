USE SFGPRODU;
--  DDL for Package Body SFGREGISTROFACTDESCUENTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREGISTROFACTDESCUENTO */ 
IF OBJECT_ID('WSXML_SFG.SFGREGISTROFACTDESCUENTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROFACTDESCUENTO_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGREGISTROFACTDESCUENTO_AddRecord(  @p_CODPRODUCTODESCUENTO         NUMERIC(22,0),
                      @p_CODENTRADAARCHIVOCONTROL     NUMERIC(22,0),
                      @p_CODREGISTROFACTURACION       NUMERIC(22,0),
                      @p_CODTIPOREGISTRO              NUMERIC(22,0),
                      @p_VALORDESCUENTO               FLOAT,
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_REGISTROFACTDESCUENTO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REGISTROFACTDESCUENTO  (
                                        CODREGISTROFACTURACION,
                                        CODTIPOREGISTRO,
                                        CODENTRADAARCHIVOCONTROL,
                                        CODPRODUCTODESCUENTO,
                                        CODUSUARIOMODIFICACION,
                                        FECHAHORAMODIFICACION,
                                        VALOR
                                        )
    VALUES (
            @p_CODREGISTROFACTURACION,
            @p_CODTIPOREGISTRO,
            @p_CODENTRADAARCHIVOCONTROL,
            @p_CODPRODUCTODESCUENTO,
            @p_CODUSUARIOMODIFICACION,
            GETDATE(),
            @p_VALORDESCUENTO);
    SET @p_ID_REGISTROFACTDESCUENTO_out = SCOPE_IDENTITY();

  END;
GO





