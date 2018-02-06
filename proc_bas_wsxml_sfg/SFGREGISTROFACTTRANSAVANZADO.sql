USE SFGPRODU;
--  DDL for Package Body SFGREGISTROFACTTRANSAVANZADO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO */ 


IF OBJECT_ID('WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_CONSTANT(
                      @FEEINQUIRY       SMALLINT OUT,
                      @FTRANSACTION     SMALLINT OUT,
                      @BOTH             SMALLINT OUT
) AS
  BEGIN
  SET NOCOUNT ON;
    SET @FEEINQUIRY   = 1;
	SET @FTRANSACTION = 2;
	SET @BOTH         = 3;
  END;
GO
 
  
  
IF OBJECT_ID('WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_AddRecord(@p_CODREGISTROFACTURACION       NUMERIC(22,0),
                      @p_CODTIPOTRANSAVANZADO         NUMERIC(22,0),
                      @p_CANTIDADTRANSACCIONES        NUMERIC(22,0),
                      @p_CODRANGOCOMISION             NUMERIC(22,0),
                      @p_ID_REGISTROFACTTRANSAVAN_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REGISTROFACTTRANSAVANZADO (
                                           CODREGISTROFACTURACION,
                                           CODTIPOTRANSAVANZADO,
                                           CANTIDADTRANSACCIONES,
                                           CODRANGOCOMISION)
    VALUES (
            @p_CODREGISTROFACTURACION,
            @p_CODTIPOTRANSAVANZADO,
            @p_CANTIDADTRANSACCIONES,
            @p_CODRANGOCOMISION);
    SET @p_ID_REGISTROFACTTRANSAVAN_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_UpdateCommissionValues', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_UpdateCommissionValues;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGISTROFACTTRANSAVANZADO_UpdateCommissionValues(@pk_ID_REGISTROFACTTRANSAVANZAD NUMERIC(22,0),
                                   @p_VALORCOMISION                FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.REGISTROFACTTRANSAVANZADO SET VALORCOMISION = @p_VALORCOMISION
    WHERE ID_REGISTROFACTTRANSAVANZADO = @pk_ID_REGISTROFACTTRANSAVANZAD;
  END;
GO





