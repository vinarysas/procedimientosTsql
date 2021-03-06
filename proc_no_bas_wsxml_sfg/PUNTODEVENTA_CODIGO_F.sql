USE SFGPRODU;
--  DDL for Function PUNTODEVENTA_CODIGO_F
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.PUNTODEVENTA_CODIGO_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.PUNTODEVENTA_CODIGO_F;
GO

  CREATE FUNCTION WSXML_SFG.PUNTODEVENTA_CODIGO_F (@pk_ID_PUNTODEVENTA NUMERIC(22,0)) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @result NUMERIC(22,0);
 
  SELECT @result = dbo.lpad_varchar2(CODIGOGTECHPUNTODEVENTA,6,'0')
  FROM WSXML_SFG.PUNTODEVENTA
  WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
  RETURN(@result);
END
GO

