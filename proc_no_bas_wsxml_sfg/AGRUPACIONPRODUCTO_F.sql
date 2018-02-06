USE SFGPRODU;
--  DDL for Function AGRUPACIONPRODUCTO_F
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.AGRUPACIONPRODUCTO_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.AGRUPACIONPRODUCTO_F;
GO

  CREATE FUNCTION WSXML_SFG.AGRUPACIONPRODUCTO_F (@p_NOMAGRUPACIONPRODUCTO VARCHAR(4000) /* Use -meta option AGRUPACIONPRODUCTO.NOMAGRUPACIONPRODUCTO%TYPE */, @p_CODTIPOPRODUCTO NUMERIC(22,0)) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @returnvalue NUMERIC(22,0);
 
  SELECT @returnvalue = ID_AGRUPACIONPRODUCTO FROM WSXML_SFG.AGRUPACIONPRODUCTO WHERE NOMAGRUPACIONPRODUCTO = @p_NOMAGRUPACIONPRODUCTO;
  
	IF @@ROWCOUNT = 0 BEGIN
		--INSERT INTO WSXML_SFG.AGRUPACIONPRODUCTO ( NOMAGRUPACIONPRODUCTO, CODTIPOPRODUCTO, CODUSUARIOMODIFICACION)
		--VALUES ( @p_NOMAGRUPACIONPRODUCTO, @p_CODTIPOPRODUCTO, 1); SET @returnvalue = SCOPE_IDENTITY();
		--RETURN @returnvalue;
		RETURN 0
	END
  
  RETURN @returnvalue;  
END; 

