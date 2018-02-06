USE SFGPRODU;
--  DDL for Function PUNTODEVENTABYTERM_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.PUNTODEVENTABYTERM_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.PUNTODEVENTABYTERM_F;
GO

CREATE FUNCTION WSXML_SFG.PUNTODEVENTABYTERM_F (@p_TERMINAL NVARCHAR(2000)) 
	RETURNS NUMERIC(22,0) AS
BEGIN
	DECLARE @result NUMERIC(22,0);

	SELECT @RESULT = P.ID_PUNTODEVENTA FROM WSXML_SFG.PUNTODEVENTA P
	WHERE CAST(P.NUMEROTERMINAL AS INT) = CAST(@p_TERMINAL AS INT)
	AND ACTIVE = 1;
	
	IF @@ROWCOUNT > 1  BEGIN
		
		SELECT @result = P.ID_PUNTODEVENTA FROM WSXML_SFG.PUNTODEVENTA P
		WHERE CAST(P.NUMEROTERMINAL AS INT) = CAST(@p_TERMINAL AS INT)
			AND ACTIVE = 1;
		
		IF @@ROWCOUNT = 0 BEGIN
				--WSXML_SFG.SFGTMPTRACE_TraceLog('Terminal ' + ISNULL(@p_TERMINAL, '') + ' not found', 'LOAD_SALES_FILES');
				RETURN(0);
		END 
				
		RETURN(@result);
	
	END

	RETURN(@result);

END; 
