USE SFGPRODU;
--  DDL for Function ULTIMO_CICLOFACTURACION
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.ULTIMO_CICLOFACTURACION', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.ULTIMO_CICLOFACTURACION;
GO

CREATE FUNCTION WSXML_SFG.ULTIMO_CICLOFACTURACION (@p_FECHA DATETIME) 
  RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @result NUMERIC(22,0);
 
	BEGIN
		SELECT @result = ID_CICLOFACTURACIONPDV
		FROM (
			SELECT ID_CICLOFACTURACIONPDV, FECHAEJECUCION FROM WSXML_SFG.CICLOFACTURACIONPDV
			WHERE CONVERT(DATETIME, CONVERT(DATE,FECHAEJECUCION)) <= CONVERT(DATETIME, CONVERT(DATE,@p_FECHA))
				AND ACTIVE = 1
			--ORDER BY FECHAEJECUCION DESC
		) s
		ORDER BY FECHAEJECUCION DESC
   
		IF @@ROWCOUNT = 0
			SET @result = NULL;
	END

  RETURN @result;
END; 

