USE [SFGPRODU]
GO 


IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'ConvertFecha'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION dbo.ConvertFecha
GO

CREATE FUNCTION [dbo].[ConvertFecha](@Pfecha varchar(50))  
RETURNS varchar(50)
AS   
-- Returns the stock level for the product.  
BEGIN  
    DECLARE @ret varchar(50); 
 DECLARE @dia varchar(10); 
 DECLARE @mes varchar(10); 
 DECLARE @año varchar(10); 
 DECLARE @Hora varchar(10); 
 DECLARE @minuto varchar(10); 
--fecha= 2009-12-20 00:06:27.0000000
--final 11/13/2017 20:25 
 set @año=SUBSTRING(@Pfecha,1,4);
 set @mes=SUBSTRING(@Pfecha,6,2);
 set @dia=SUBSTRING(@Pfecha,9,2);
 set @Hora=SUBSTRING(@Pfecha,12,2);
 set @minuto=SUBSTRING(@Pfecha,15,2);
 set @ret=@mes+'/'+@dia+'/'+@año+' '+@Hora+':'+@minuto;
    
    RETURN @ret;  
END;
GO




IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'LAST_DAY'
    AND type IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION dbo.LAST_DAY
GO

CREATE FUNCTION [dbo].[LAST_DAY]
(
    @inDate DATETIME
)
RETURNS DATETIME
AS
BEGIN
    RETURN DATEADD(MONTH, DATEDIFF(MONTH, 0, @inDate) + 1, 0) - 1
END
GO


IF OBJECT_ID('dbo.InitCap') IS NOT NULL
	DROP FUNCTION dbo.InitCap;
  GO
 
 -- Implementing Oracle INITCAP function
 CREATE FUNCTION dbo.InitCap (@inStr VARCHAR(8000))
  RETURNS VARCHAR(8000)
  AS
  BEGIN
    DECLARE @outStr VARCHAR(8000) = LOWER(@inStr),
		 @char CHAR(1),	
		 @alphanum BIT = 0,
		 @len INT = LEN(@inStr),
                 @pos INT = 1;		  
 
    -- Iterate through all characters in the input string
    WHILE @pos <= @len BEGIN
 
      -- Get the next character
      SET @char = SUBSTRING(@inStr, @pos, 1);
 
      -- If the position is first, or the previous characater is not alphanumeric
      -- convert the current character to upper case
      IF @pos = 1 OR @alphanum = 0
        SET @outStr = STUFF(@outStr, @pos, 1, UPPER(@char));
 
      SET @pos = @pos + 1;
 
      -- Define if the current character is non-alphanumeric
      IF ASCII(@char) <= 47 OR (ASCII(@char) BETWEEN 58 AND 64) OR
	  (ASCII(@char) BETWEEN 91 AND 96) OR (ASCII(@char) BETWEEN 123 AND 126)
	  SET @alphanum = 0;
      ELSE
	  SET @alphanum = 1;
 
    END
 
   RETURN @outStr;		   
  END
  GO
  
  
IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'SEPARAR_COLUMNAS_F'
    AND type IN (N'FN', N'IF', N'TF')
)
	DROP FUNCTION dbo.SEPARAR_COLUMNAS_F;
  GO
  
 CREATE FUNCTION dbo.SEPARAR_COLUMNAS_F( @TEXT      varchar(8000),@COLUMN    tinyint,@SEPARATOR char(1))RETURNS varchar(8000)
AS
  BEGIN
       DECLARE @POS_START  int = 1
       DECLARE @POS_END    int = CHARINDEX(@SEPARATOR, @TEXT, @POS_START)

       WHILE (@COLUMN >1 AND @POS_END> 0)
         BEGIN
             SET @POS_START = @POS_END + 1
             SET @POS_END = CHARINDEX(@SEPARATOR, @TEXT, @POS_START)
             SET @COLUMN = @COLUMN - 1
         END 

       IF @COLUMN > 1  SET @POS_START = LEN(@TEXT) + 1
       IF @POS_END = 0 SET @POS_END = LEN(@TEXT) + 1 

       RETURN SUBSTRING (@TEXT, @POS_START, @POS_END - @POS_START)
  END
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'fnIsValidEmail'
    AND type IN (N'FN', N'IF', N'TF')
)
	DROP FUNCTION dbo.fnIsValidEmail;
GO

CREATE FUNCTION dbo.fnIsValidEmail
(
    @email varchar(255)
)
RETURNS bit
AS
BEGIN

    DECLARE @IsValidEmail bit = 0

    IF (@email not like '%[^a-z,0-9,@,.,!,#,$,%%,&,'',*,+,--,/,=,?,^,_,`,{,|,},~]%' --First Carat ^ means Not these characters in the LIKE clause. The list is the valid email characters.
        AND @email like '%_@_%_.[a-z,0-9][a-z]%'
        AND @email NOT like '%@%@%'  
        AND @email NOT like '%..%'
        AND @email NOT like '.%'
        AND @email NOT like '%.'
        AND CHARINDEX('@', @email) <= 65
        )
    BEGIN
        SET @IsValidEmail = 1
    END

    RETURN @IsValidEmail

END
GO

IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'NEXT_DAY'
    AND type IN (N'FN', N'IF', N'TF')
)
	DROP FUNCTION dbo.NEXT_DAY;
GO

CREATE function dbo.NEXT_DAY (@d datetime, @DayOfTheWeekEnglishCollate VARCHAR(100))
RETURNS datetime AS
BEGIN 
	declare @dp int = CASE
		WHEN @DayOfTheWeekEnglishCollate = 'Saturday'  THEN 0
		WHEN @DayOfTheWeekEnglishCollate = 'Sunday'    THEN 1
		WHEN @DayOfTheWeekEnglishCollate = 'Monday'    THEN 2
		WHEN @DayOfTheWeekEnglishCollate = 'Tuesday'   THEN 3
		WHEN @DayOfTheWeekEnglishCollate = 'Wednesday' THEN 4
		WHEN @DayOfTheWeekEnglishCollate = 'Thursday'  THEN 5
		WHEN @DayOfTheWeekEnglishCollate = 'Friday'    THEN 6
	END
	
	RETURN DATEADD(
		DAY, 
		CASE 
			WHEN (@dp -   ((DATEDIFF(DAY,0,@D) + 2) %7)) < 0 THEN 7 + (@dp -   ((DATEDIFF(DAY,0,@D) + 2) %7)) 
			ELSE (@dp -   ((DATEDIFF(DAY,0,@D) + 2) %7))
		END, 
		@d)

END
GO


 IF OBJECT_ID('dbo.to_char_date', 'FN') IS NOT NULL
    DROP FUNCTION dbo.to_char_date;
GO


  CREATE FUNCTION dbo.to_char_date ( @date datetime, @format varchar(20)) RETURNS VARCHAR(2000) AS
 BEGIN

   DECLARE @Result VARCHAR(2000);
   DECLARE @nombreMes VARCHAR(100)
   
    

	IF UPPER(@format) = 'DD/MON/YYYY'  BEGIN
		SET @nombreMes = WSXML_SFG.DATMONTHNAME( datepart(month, @date) )
		SET @Result = convert(varchar,format(@date,'dd')) +'/'+ substring(@nombreMes,1,3) +'/'+ convert(varchar,format(@date,'yyyy'))
	END
	
	IF UPPER(@format) = 'MM/DD/YYYY' BEGIN
		SET @Result = FORMAT(@date, 'MM/dd/yyyy')
	END

    RETURN @Result
  END;
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'lpad_varchar2'
    AND type IN (N'FN', N'IF', N'TF')
)
	DROP FUNCTION dbo.lpad_varchar2;
  GO
  


create FUNCTION dbo.lpad_varchar2(
    @string as varchar(max), 
    @length as int, 
    @pad as varchar(max) = ' '
	)
returns varchar(max)

begin
	
	IF LEN(@string) > @length BEGIN		
		RETURN @string
	END

		RETURN RIGHT(REPLICATE(@pad, @length) + LEFT(@string, @length), @length);

end
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'lpad_numeric2'
    AND type IN (N'FN', N'IF', N'TF')
)
	DROP FUNCTION dbo.lpad_numeric2;
  GO
  


create FUNCTION dbo.lpad_numeric2(
    @numeric as NUMERIC(38,0), 
    @length as int, 
    @pad as varchar(max) = ' '
	)
returns varchar(max)

begin
	DECLARE @string VARCHAR(2000)
	SET @string = CONVERT(VARCHAR,@numeric)  

	IF LEN(@string) > @length BEGIN		
		RETURN @string
	END

		RETURN RIGHT(REPLICATE(@pad, @length) + LEFT(@string, @length), @length);

end
GO



IF EXISTS (
    SELECT * FROM sys.objects WHERE OBJECT_NAME(object_id) = N'rpad_varchar2'
    AND type IN (N'FN', N'IF', N'TF')
)
	DROP FUNCTION dbo.rpad_varchar2;
GO
  

create FUNCTION dbo.rpad_varchar2(
    @string as varchar(max), 
    @length as int, 
    @pad as varchar(max) = ' '
	)
returns varchar(max)

begin
	
	IF LEN(@string) > @length BEGIN		
		RETURN @string
	END

		RETURN LEFT(LEFT(@string, @length) + REPLICATE(@pad, @length), @length);

end
GO
