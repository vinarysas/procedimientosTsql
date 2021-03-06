USE SFGPRODU;
--  DDL for Function CANT_PV_POR_ESTADO
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.CANT_PV_POR_ESTADO', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.CANT_PV_POR_ESTADO;
GO

  CREATE FUNCTION WSXML_SFG.CANT_PV_POR_ESTADO (@p_CODESTADOPDV NUMERIC(22,0)) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @result NUMERIC(22,0);
 
  SELECT @result = COUNT(1) FROM WSXML_SFG.PUNTODEVENTA WHERE ACTIVE = @p_CODESTADOPDV;
  RETURN @result;
END;

