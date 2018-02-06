USE SFGPRODU;
--  DDL for Function IS_NUMBER
--------------------------------------------------------

 IF OBJECT_ID('WSXML_SFG.IS_NUMBER', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.IS_NUMBER;
GO

 CREATE FUNCTION WSXML_SFG.IS_NUMBER (@p_string VARCHAR(4000)) returns integer as
 begin
	declare @Result    integer;
	select @Result = ISNUMERIC(@p_string)
	RETURN @Result
end;

