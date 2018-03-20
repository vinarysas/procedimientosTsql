USE SFGPRODU;
--  DDL for Function TIPOPRODUCTO_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.TIPOPRODUCTO_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.TIPOPRODUCTO_F;
GO

  CREATE FUNCTION WSXML_SFG.TIPOPRODUCTO_F (@p_NOMTIPOPRODUCTO VARCHAR(4000) /* Use -meta option TIPOPRODUCTO.NOMTIPOPRODUCTO%TYPE */) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @returnvalue NUMERIC(22,0);
 
  SELECT @returnvalue = ID_TIPOPRODUCTO FROM WSXML_SFG.TIPOPRODUCTO WHERE NOMTIPOPRODUCTO = @p_NOMTIPOPRODUCTO;
  IF @@ROWCOUNT = 0 BEGIN
	RETURN CAST('-20054 El tipo de producto no existe'AS INT);
	--  RAISERROR('-20054 El tipo de producto no existe', 16, 1);
  END
  RETURN @returnvalue;
END; 

