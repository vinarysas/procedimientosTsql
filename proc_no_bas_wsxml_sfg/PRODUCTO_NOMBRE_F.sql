USE SFGPRODU;
--  DDL for Function PRODUCTO_NOMBRE_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.PRODUCTO_NOMBRE_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.PRODUCTO_NOMBRE_F;
GO

CREATE FUNCTION WSXML_SFG.PRODUCTO_NOMBRE_F (@pk_ID_PRODUCTO NUMERIC(22,0)) 
  RETURNS NVARCHAR(2000) AS
 BEGIN
  DECLARE @result NVARCHAR(255) = '';
 
  SELECT @result = RTRIM(LTRIM(P.NOMPRODUCTO)) FROM WSXML_SFG.PRODUCTO P WHERE P.ID_PRODUCTO = @pk_ID_PRODUCTO;
  	
		IF @@ROWCOUNT = 0 BEGIN
		 --SFGTMPTRACE.TraceLog('No es posible encontrar el producto con identificador ' + ISNULL(@pk_ID_PRODUCTO, ''));
		 RETURN 0
		END
  RETURN @result;
END; 
