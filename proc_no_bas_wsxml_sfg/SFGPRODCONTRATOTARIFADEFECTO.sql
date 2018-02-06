USE SFGPRODU;
--  DDL for Package Body SFGPRODCONTRATOTARIFADEFECTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPRODCONTRATOTARIFADEFECTO */ 

  IF OBJECT_ID('WSXML_SFG.SFGPRODCONTRATOTARIFADEFECTO_AddOrSetDefaultValue', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODCONTRATOTARIFADEFECTO_AddOrSetDefaultValue;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODCONTRATOTARIFADEFECTO_AddOrSetDefaultValue(@p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                 @p_CODTARIFAVALOR         NUMERIC(22,0),
                                 @p_VALOR                  FLOAT,
                                 @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @cCODPRODCONTRATOTARIFADEFECTO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cCODPRODCONTRATOTARIFADEFECTO = ID_PRODCONTRATOTARIFADEFECTO
      FROM WSXML_SFG.PRODCONTRATOTARIFADEFECTO
     WHERE CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO
       AND CODTARIFAVALOR = @p_CODTARIFAVALOR;
    UPDATE WSXML_SFG.PRODCONTRATOTARIFADEFECTO SET VALOR = @p_VALOR,
                                         FECHAHORAMODIFICACION = GETDATE(),
                                         CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION
    WHERE ID_PRODCONTRATOTARIFADEFECTO = @cCODPRODCONTRATOTARIFADEFECTO;
	
	IF @@ROWCOUNT = 0 BEGIN
  
    INSERT INTO WSXML_SFG.PRODCONTRATOTARIFADEFECTO (
                                           CODLINEADENEGOCIO,
                                           CODTARIFAVALOR,
                                           VALOR,
                                           CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODLINEADENEGOCIO,
            @p_CODTARIFAVALOR,
            @p_VALOR,
            @p_CODUSUARIOMODIFICACION);
  END;

END 
