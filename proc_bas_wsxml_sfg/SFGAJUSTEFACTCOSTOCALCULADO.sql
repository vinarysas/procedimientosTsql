USE SFGPRODU;
--  DDL for Package Body SFGAJUSTEFACTCOSTOCALCULADO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO */ 

  IF OBJECT_ID('WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO_AddRecord(@p_CODAJUSTEFACTURACION         NUMERIC(22,0),
                      @p_CODCOSTOCALCULADO            NUMERIC(22,0),
                      @p_VALORCOSTO                   FLOAT,
                      @p_ID_AJUSTEFACTCOSTOCALCUL_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.AJUSTEFACTCOSTOCALCULADO (CODAJUSTEFACTURACION,CODCOSTOCALCULADO,VALORCOSTO)
    VALUES (@p_CODAJUSTEFACTURACION,@p_CODCOSTOCALCULADO,@p_VALORCOSTO);
    SET @p_ID_AJUSTEFACTCOSTOCALCUL_out = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO_AddReplaceRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO_AddReplaceRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAJUSTEFACTCOSTOCALCULADO_AddReplaceRecord(@p_CODAJUSTEFACTURACION         NUMERIC(22,0),
                             @p_CODCOSTOCALCULADO            NUMERIC(22,0),
                             @p_VALORCOSTO                   FLOAT,
                             @p_ID_AJUSTEFACTCOSTOCALCUL_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
		SELECT @p_ID_AJUSTEFACTCOSTOCALCUL_out = (
			SELECT ID_AJUSTEFACTCOSTOCALCULADO FROM WSXML_SFG.AJUSTEFACTCOSTOCALCULADO
			WHERE CODAJUSTEFACTURACION = @p_CODAJUSTEFACTURACION
			AND CODCOSTOCALCULADO    = @p_CODCOSTOCALCULADO
		  )
		IF(@p_ID_AJUSTEFACTCOSTOCALCUL_out > 0)
		BEGIN
			UPDATE WSXML_SFG.AJUSTEFACTCOSTOCALCULADO SET VALORCOSTO = @p_VALORCOSTO
			WHERE ID_AJUSTEFACTCOSTOCALCULADO = @p_ID_AJUSTEFACTCOSTOCALCUL_out;
		END
		ELSE BEGIN
			INSERT INTO WSXML_SFG.AJUSTEFACTCOSTOCALCULADO (CODAJUSTEFACTURACION,CODCOSTOCALCULADO,VALORCOSTO)
			VALUES (@p_CODAJUSTEFACTURACION,@p_CODCOSTOCALCULADO,@p_VALORCOSTO);
			SET @p_ID_AJUSTEFACTCOSTOCALCUL_out = SCOPE_IDENTITY();
		END

  END;
GO






