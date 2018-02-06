USE SFGPRODU;
--  DDL for Function RED_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.RED_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.RED_F;
GO

CREATE FUNCTION WSXML_SFG.RED_F (@p_NOMREDPDV NVARCHAR(2000)) RETURNS NUMERIC(22,0) AS
	BEGIN
	DECLARE @result NUMERIC(22,0);
 
	SELECT @result = ID_REDPDV FROM WSXML_SFG.REDPDV
	WHERE NOMREDPDV = @p_NOMREDPDV;

	IF @@ROWCOUNT = 0 BEGIN
		DECLARE @traceLog VARCHAR(100)
		--SFGTMPTRACE.TraceLog('Network ' + ISNULL(@p_NOMREDPDV, '') + ' not found');
		SET @traceLog = 'Network ' + ISNULL(@p_NOMREDPDV, '') + ' not found';
		--EXEC WSXML_SFG.SFGTMPTRACE_TraceLog @traceLog;

		RETURN 0
	END

	RETURN @result;
END

