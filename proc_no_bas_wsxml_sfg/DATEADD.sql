USE SFGPRODU;
--  DDL for Function DATEADD
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.DATEADD', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.DATEADD;
GO

  CREATE FUNCTION WSXML_SFG.DATEADD (@date_type varchar(4000), @offset NUMERIC(22,0), @date_in datetime )
RETURNS datetime AS
 BEGIN DECLARE @date_returned datetime;
 
SET @date_returned = CASE @date_type
    WHEN 'mm'   THEN dateadd(month, CAST(@offset AS INT), @date_in)
    WHEN 'yyyy' THEN dateadd(month, CAST(@offset AS INT) * 12, @date_in)
    WHEN 'ww'   THEN @date_in + CAST((@offset*7) AS INT)
    WHEN 'dd'   THEN @date_in + CAST(@offset AS INT)
    WHEN 'hh'   THEN @date_in + (CAST(@offset AS INT) / 24)
    WHEN 'mi'   THEN @date_in + (CAST(@offset AS INT) /24/60)
    WHEN 'ss'   THEN @date_in + (CAST(@offset AS INT) /24/60/60)
    END;
RETURN @date_returned
END;

