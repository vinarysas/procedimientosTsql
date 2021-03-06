USE SFGPRODU;
--  DDL for Function ALIADOESTRATEGICO_F
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.ALIADOESTRATEGICO_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.ALIADOESTRATEGICO_F;
GO

CREATE FUNCTION WSXML_SFG.ALIADOESTRATEGICO_F (@p_ALIADO NVARCHAR(2000)) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @result NUMERIC(22,0);
 
  SELECT @result = ID_ALIADOESTRATEGICO FROM WSXML_SFG.ALIADOESTRATEGICO WHERE CAST(ID_ALIADOESTRATEGICO AS INT) = CAST(@p_ALIADO AS INT);

  IF @@ROWCOUNT = 0 BEGIN
		--EXCEPTION WHEN OTHERS THEN  SFGTMPTRACE.TraceLog('Ally ' + ISNULL(@p_ALIADO, '') + ' not found');
		RETURN 0
	END

  RETURN @result;
END

