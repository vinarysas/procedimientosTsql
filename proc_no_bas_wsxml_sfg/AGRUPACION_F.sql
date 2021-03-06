USE SFGPRODU;
--  DDL for Function AGRUPACION_F
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.AGRUPACION_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.AGRUPACION_F;
GO

CREATE FUNCTION WSXML_SFG.AGRUPACION_F (@p_AGRUPACION NVARCHAR(2000)) RETURNS NUMERIC(22,0) AS
BEGIN
  DECLARE @result NUMERIC(22,0);
 
  SELECT @result = C.ID_AGRUPACIONPUNTODEVENTA FROM WSXML_SFG.AGRUPACIONPUNTODEVENTA C
  WHERE CAST(C.CODIGOAGRUPACIONGTECH AS INT) = CAST(@p_AGRUPACION AS INT);

	IF @@ROWCOUNT = 0 BEGIN
		--EXCEPTION WHEN OTHERS THEN  SFGTMPTRACE.TraceLog('Chain ' + ISNULL(@p_AGRUPACION, '') + ' not found');
		RETURN 0
	END

  RETURN(@result);

  
END
GO

