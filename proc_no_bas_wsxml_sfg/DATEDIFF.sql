USE [SFGPRODU]
GO

IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'MONTHS_BETWEEN'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION dbo.MONTHS_BETWEEN
GO


CREATE FUNCTION dbo.MONTHS_BETWEEN (@date1 DATETIME, @date2 DATETIME) 
	RETURNS FLOAT
   AS

   BEGIN
     DECLARE @months FLOAT = DATEDIFF(month, @date2, @date1);
 
     -- Both dates does not point to the same day of month
     IF DAY(@date1) <> DAY(@date2) AND
        -- Both dates does not point to the last day of month
        (MONTH(@date1) = MONTH(@date1 + 1) OR MONTH(@date2) = MONTH(@date2 + 1))
     BEGIN
        -- Correct to include full months only and calculate fraction
        IF DAY(@date1) < DAY(@date2)
          SET @months = @months + CONVERT(FLOAT, 31 - DAY(@date2) + DAY(@date1)) / 31 - 1;
        ELSE    
          SET @months = @months + CONVERT(FLOAT, DAY(@date1) - DAY(@date2)) / 31;
     END
 
     RETURN @months; 
   END;
   GO


IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'DATEDIFF'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION WSXML_SFG.DATEDIFF
GO



  CREATE FUNCTION [WSXML_SFG].[DATEDIFF] ( @return_type varchar(20), @date_1 datetime, @date_2 datetime) RETURNS NUMERIC(22,0) AS
 BEGIN

   DECLARE @Result NUMERIC(22,0);

   
    SET @Result = CASE @return_type
		 WHEN 'mm'   THEN ROUND( DATEDIFF( month, @date_1, @date_2 ),0) 
          WHEN 'mm_exact' THEN dbo.MONTHS_BETWEEN(@date_2,@date_1)  
		  WHEN 'yyyy' THEN  ROUND( DATEDIFF( year, @date_1, @date_2 ),0) 
		  WHEN 'ww'   THEN DATEDIFF( wk, @date_1, @date_2 )
		  WHEN 'dd'   THEN DATEDIFF( dd, @date_1, @date_2 )
          WHEN 'hh'   THEN  DATEDIFF( hh, @date_1, @date_2 )
          WHEN 'mi'   THEN  DATEDIFF( mi, @date_1, @date_2 )
          WHEN 'ss'   THEN  DATEDIFF( ss, @date_1, @date_2 )
        END;
    RETURN round(@Result,2)
  END;
GO
