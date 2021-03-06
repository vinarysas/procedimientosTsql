USE SFGPRODU;
--------------------------------------------------------
--  DDL for Function CICLO_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.CICLO_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.CICLO_F;
GO

  CREATE FUNCTION WSXML_SFG.CICLO_F (@p_SECUENCIA NUMERIC(22,0)) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @result NUMERIC(22,0);
 
  SELECT @result = C.ID_CICLOFACTURACIONPDV FROM WSXML_SFG.CICLOFACTURACIONPDV C
  WHERE SECUENCIA = @p_SECUENCIA AND ACTIVE = 1;

   IF @@ROWCOUNT = 0 BEGIN
	--EXCEPTION WHEN OTHERS THEN   SFGTMPTRACE.TraceLog('Cicle ' + ISNULL(@p_SECUENCIA, '') + ' not found');
	RETURN 0
  END

  RETURN @result;

END;


