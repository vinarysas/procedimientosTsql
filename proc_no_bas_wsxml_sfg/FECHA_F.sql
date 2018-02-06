USE SFGPRODU;
--------------------------------------------------------
--  DDL for Function FECHA_F
--------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.FECHA_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.FECHA_F;
GO

CREATE FUNCTION WSXML_SFG.FECHA_F (@p_FECHA DATETIME) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @result NUMERIC(22,0);
 
  SELECT @result = ID_CALENDARIO_GRAL 
  FROM SFG_CONCILIACION.CON_CALENDARIO_GRAL 
  WHERE FECHA_CALENDARIO = CONVERT(DATETIME, CONVERT(DATE,@p_FECHA));
  
  IF @@ROWCOUNT = 0 BEGIN
	--EXCEPTION WHEN OTHERS THEN  RAISERROR('-20054 No existe la la fecha en el calendario', 16, 1);
	RETURN CAST('-20054: No existe la la fecha en el calendario' as INT)
  END
  
  RETURN @result;

END;

