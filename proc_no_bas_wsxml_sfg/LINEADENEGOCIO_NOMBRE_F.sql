USE SFGPRODU;
--  DDL for Function LINEADENEGOCIO_NOMBRE_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.LINEADENEGOCIO_NOMBRE_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.LINEADENEGOCIO_NOMBRE_F;
GO

  CREATE FUNCTION WSXML_SFG.LINEADENEGOCIO_NOMBRE_F (@pk_ID_LINEADENEGOCIO NUMERIC(22,0)) RETURNS NVARCHAR(2000) AS
 BEGIN
  DECLARE @result NVARCHAR(255);
 
  SELECT @result = RTRIM(LTRIM(NOMLINEADENEGOCIO)) 
  FROM WSXML_SFG.LINEADENEGOCIO 
  WHERE ID_LINEADENEGOCIO = @pk_ID_LINEADENEGOCIO;
  RETURN @result;
END;

