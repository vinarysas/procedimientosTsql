USE SFGPRODU;
--  DDL for Package Body SFGCOMPANIA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCOMPANIA */ 

  
  IF OBJECT_ID('WSXML_SFG.SFGCOMPANIA_FormatIdentification', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGCOMPANIA_FormatIdentification;
GO

CREATE     FUNCTION WSXML_SFG.SFGCOMPANIA_FormatIdentification(@p_IDENTIFICACION NUMERIC(22,0), @p_DIGITOVERIFICACION NUMERIC(22,0)) RETURNS VARCHAR(4000) AS
 BEGIN
    DECLARE @origin VARCHAR(18);
    DECLARE @result VARCHAR(20);
    DECLARE @itertr NUMERIC(22,0) = 0;
   
    SET @origin = @p_IDENTIFICACION;
    
	DECLARE @ix int = 1
	WHILE @ix <= LEN(@origin)
	BEGIN
      IF @itertr = 2 AND @ix < LEN(@origin) BEGIN
        SET @itertr = 0;
        SET @result = '.' + ISNULL(SUBSTRING(@origin, LEN(@origin) - @ix + 1, 1), '') + isnull(@result, '');
      END
      ELSE BEGIN
        SET @itertr = @itertr + 1;
        SET @result = ISNULL(SUBSTRING(@origin, LEN(@origin) - @ix + 1, 1), '') + isnull(@result, '');
      END 
    set @ix= @ix + 1
    END;

    RETURN isnull(@result, '') + '-' + ISNULL(@p_DIGITOVERIFICACION, '');
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGCOMPANIA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCOMPANIA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGCOMPANIA_GetList AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_COMPANIA, CODIGO, NOMCOMPANIA, IDENTIFICACION, DIGITOVERIFICACION, WSXML_SFG.SFGCOMPANIA_FormatIdentification(IDENTIFICACION, DIGITOVERIFICACION) AS NIT
      FROM WSXML_SFG.COMPANIA;
  END;
GO






