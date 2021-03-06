USE SFGPRODU;
--  DDL for Package Body SFGPRODCONTRATOESTANDARHISTORI
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPRODCONTRATOESTANDARHISTORI */ 

  IF OBJECT_ID('WSXML_SFG.SFGPRODCONTRATOESTANDARHISTORI_SetComisionEstandar', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPRODCONTRATOESTANDARHISTORI_SetComisionEstandar;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPRODCONTRATOESTANDARHISTORI_SetComisionEstandar(@p_CODPRODUCTO NUMERIC(22,0), @p_FECHAINICIOVALIDEZ DATETIME, @p_CODRANGOCOMISIONESTANDAR NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @cCODPRODUCTOCONTRATO        NUMERIC(22,0);
    DECLARE @counthistorical             NUMERIC(22,0) = 0;
    DECLARE @cCODPRODCONTRATOESTANDARHST NUMERIC(22,0);
   
  SET NOCOUNT ON;
    SELECT @cCODPRODUCTOCONTRATO = ID_PRODUCTOCONTRATO FROM WSXML_SFG.PRODUCTOCONTRATO WHERE CODPRODUCTO = @p_CODPRODUCTO;
	
	IF @@ROWCOUNT = 0 BEGIN
		RETURN CAST('-20089: No existe contrato para el producto' AS INT);
		-- RAISERROR('-20089 No existe contrato para el producto', 16, 1);
	END
	
    SELECT @counthistorical = COUNT(1) FROM WSXML_SFG.PRODCONTRATOESTANDARHISTORICO WHERE CODPRODUCTOCONTRATO = @cCODPRODUCTOCONTRATO;
	
    IF @counthistorical = 0 BEGIN
      UPDATE WSXML_SFG.PRODUCTOCONTRATO SET CODRANGOCOMISIONESTANDAR = @p_CODRANGOCOMISIONESTANDAR WHERE ID_PRODUCTOCONTRATO = @cCODPRODUCTOCONTRATO;
    END 
	
    BEGIN
		SELECT @cCODPRODCONTRATOESTANDARHST = ID_PRODCONTRATOESTANDARHISTORI FROM WSXML_SFG.PRODCONTRATOESTANDARHISTORICO
		WHERE CODPRODUCTOCONTRATO = @cCODPRODUCTOCONTRATO AND FECHAINICIOVALIDEZ = CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINICIOVALIDEZ));
      
		IF @@ROWCOUNT = 0 BEGIN
			INSERT INTO WSXML_SFG.PRODCONTRATOESTANDARHISTORICO ( CODPRODUCTOCONTRATO, FECHAINICIOVALIDEZ, CODRANGOCOMISIONESTANDAR, CODUSUARIOMODIFICACION) VALUES ( @cCODPRODUCTOCONTRATO, CONVERT(DATETIME, CONVERT(DATE,@p_FECHAINICIOVALIDEZ)), @p_CODRANGOCOMISIONESTANDAR, @p_CODUSUARIOMODIFICACION);
			SET @cCODPRODCONTRATOESTANDARHST = SCOPE_IDENTITY();
		END ELSE BEGIN
			UPDATE WSXML_SFG.PRODCONTRATOESTANDARHISTORICO SET CODRANGOCOMISIONESTANDAR = @p_CODRANGOCOMISIONESTANDAR 
			WHERE ID_PRODCONTRATOESTANDARHISTORI = @cCODPRODCONTRATOESTANDARHST;
		END
		
    END
	
  END
GO
  