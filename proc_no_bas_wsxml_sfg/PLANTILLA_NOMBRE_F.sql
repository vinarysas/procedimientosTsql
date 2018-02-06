USE SFGPRODU;
--  DDL for Function PLANTILLA_NOMBRE_F
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.PLANTILLA_NOMBRE_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.PLANTILLA_NOMBRE_F;
GO

 CREATE FUNCTION WSXML_SFG.PLANTILLA_NOMBRE_F (@pk_ID_PLANTILLA NUMERIC(22,0)) RETURNS NVARCHAR(2000) AS
 BEGIN
  DECLARE @result VARCHAR(4000) /* Use -meta option PLANTILLAPRODUCTO.NOMPLANTILLAPRODUCTO%TYPE */;
 
  SELECT @result = RTRIM(LTRIM(P.NOMPLANTILLAPRODUCTO)) 
  FROM WSXML_SFG.PLANTILLAPRODUCTO P 
  WHERE P.ID_PLANTILLAPRODUCTO = @pk_ID_PLANTILLA;
  RETURN(@result);
END;
