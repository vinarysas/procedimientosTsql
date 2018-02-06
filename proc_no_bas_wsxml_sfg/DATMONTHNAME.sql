USE SFGPRODU;
--  DDL for Function DATMONTHNAME
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.DATMONTHNAME', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.DATMONTHNAME;
GO

  CREATE FUNCTION WSXML_SFG.DATMONTHNAME (@pVALUE DATETIME) RETURNS VARCHAR(4000)  AS
BEGIN
	-- RETURN RTRIM(LTRIM(INITCAP(TO_CHAR(@pVALUE, 'MONTH', 'nls_date_language = spanish'))));
	--SET LANGUAGE Spanish
	--RETURN DATENAME(MONTH, @pVALUE);
	declare @month varchar(10)

	select @month = 
		CASE @pVALUE
			WHEN 1 THEN 'Enero'
			WHEN 2 THEN 'Febrero'
			WHEN 3 THEN 'Marzo'
			WHEN 4 THEN 'Abril'
			WHEN 5 THEN 'Mayo'
			WHEN 6 THEN 'Junio'
			WHEN 7 THEN 'Julio'
			WHEN 8 THEN 'Agosto'
			WHEN 9 THEN 'Septiembre'
			WHEN 10 THEN 'Octubre'
			WHEN 11 THEN 'Noviembre'
			WHEN 12 THEN 'Diciembre'
		END

	RETURN @month
 END
 GO
