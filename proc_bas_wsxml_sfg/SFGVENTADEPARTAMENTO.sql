USE SFGPRODU;
--  DDL for Package Body SFGVENTADEPARTAMENTO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGVENTADEPARTAMENTO */ 

  IF OBJECT_ID('WSXML_SFG.SFGVENTADEPARTAMENTO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGVENTADEPARTAMENTO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGVENTADEPARTAMENTO_AddRecord(@p_NOMVENTADEPARTAMENTO     NVARCHAR(2000),
                      @p_CODTIPOOPERACIONVENTA    NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                      @p_ID_VENTADEPARTAMENTO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.VENTADEPARTAMENTO (
                                   NOMVENTADEPARTAMENTO,
                                   CODTIPOOPERACIONVENTA,
                                   CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMVENTADEPARTAMENTO,
            @p_CODTIPOOPERACIONVENTA,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_VENTADEPARTAMENTO_out = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGVENTADEPARTAMENTO_GetByName', 'FN') IS NOT NULL
  DROP FUNCTION WSXML_SFG.SFGVENTADEPARTAMENTO_GetByName;
GO

CREATE     FUNCTION WSXML_SFG.SFGVENTADEPARTAMENTO_GetByName(@p_NOMVENTADEPARTAMENTO NVARCHAR(2000)) 
 RETURNS NUMERIC(22,0) AS
 BEGIN
    DECLARE @resultcode NUMERIC(22,0);
   
    SELECT @resultcode = ID_VENTADEPARTAMENTO FROM WSXML_SFG.VENTADEPARTAMENTO 
	WHERE LOWER(RTRIM(LTRIM(NOMVENTADEPARTAMENTO))) = LOWER(RTRIM(LTRIM(@p_NOMVENTADEPARTAMENTO)));
    RETURN @resultcode;
  END;
GO





