USE SFGPRODU;
--  DDL for Function DATESERIAL
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.DATESERIAL', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.DATESERIAL;
GO

  CREATE FUNCTION WSXML_SFG.DATESERIAL (@DAY NUMERIC(22,0), @MONTH NUMERIC(22,0),@YEAR NUMERIC(22,0)) returns datetime as
 begin
  declare @Result datetime;
  declare @v_str varchar(50);
 
  set @v_str= CONVERT(VARCHAR, @DAY);
  set @v_str= isnull(@v_str, '') + '/';
  set @v_str= isnull(@v_str, '') + ISNULL(CONVERT(VARCHAR, @MONTH), '');
  set @v_str= isnull(@v_str, '') + '/';
  set @v_str= isnull(@v_str, '') + ISNULL(CONVERT(VARCHAR, @YEAR), '');
  set @Result = FORMAT(CONVERT(DATETIME, @v_str),'dd/MM/yyyy');
  return(@Result);
end; 
GO

