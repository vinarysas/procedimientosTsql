USE SFGPRODU;
--  DDL for Package Body SFGREGISTROREVENUETRANSACCION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREGISTROREVENUETRANSACCION */ 

  IF OBJECT_ID('WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddRecord(@p_CODREGISTROREVENUE           NUMERIC(22,0),
                      @p_CODREGISTROFACTREFERENCIA    NUMERIC(22,0),
                      @p_CODRANGOCOMISION             NUMERIC(22,0),
                      @p_CODRANGOCOMISIONDETALLE      NUMERIC(22,0),
                      @p_REVENUE                      FLOAT,
                      @p_ID_REGISTROREVENUETRANSA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REGISTROREVENUETRANSACCION (
                                            CODREGISTROREVENUE,
                                            CODREGISTROFACTREFERENCIA,
                                            CODRANGOCOMISION,
                                            CODRANGOCOMISIONDETALLE,
                                            REVENUE)
    VALUES (
            @p_CODREGISTROREVENUE,
            @p_CODREGISTROFACTREFERENCIA,
            @p_CODRANGOCOMISION,
            @p_CODRANGOCOMISIONDETALLE,
            @p_REVENUE);
    SET @p_ID_REGISTROREVENUETRANSA_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddReplaceRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddReplaceRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddReplaceRecord(@p_CODREGISTROREVENUE           NUMERIC(22,0),
                             @p_CODREGISTROFACTREFERENCIA    NUMERIC(22,0),
                             @p_CODRANGOCOMISION             NUMERIC(22,0),
                             @p_CODRANGOCOMISIONDETALLE      NUMERIC(22,0),
                             @p_REVENUE                      FLOAT,
                             @p_ID_REGISTROREVENUETRANSA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_REGISTROREVENUETRANSA_out = ID_REGISTROREVENUETRANSACCION
    FROM WSXML_SFG.REGISTROREVENUETRANSACCION
    WHERE CODREGISTROREVENUE = @p_CODREGISTROREVENUE AND CODREGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA;
    UPDATE WSXML_SFG.REGISTROREVENUETRANSACCION SET CODRANGOCOMISION        = @p_CODRANGOCOMISION,
                                          CODRANGOCOMISIONDETALLE = @p_CODRANGOCOMISIONDETALLE,
                                          REVENUE                 = @p_REVENUE
    WHERE ID_REGISTROREVENUETRANSACCION = @p_ID_REGISTROREVENUETRANSA_out;
  if @@ROWCOUNT  = 0 begin
    INSERT INTO WSXML_SFG.REGISTROREVENUETRANSACCION (
                                            CODREGISTROREVENUE,
                                            CODREGISTROFACTREFERENCIA,
                                            CODRANGOCOMISION,
                                            CODRANGOCOMISIONDETALLE,
                                            REVENUE)
    VALUES (
            @p_CODREGISTROREVENUE,
            @p_CODREGISTROFACTREFERENCIA,
            @p_CODRANGOCOMISION,
            @p_CODRANGOCOMISIONDETALLE,
            @p_REVENUE);
    SET @p_ID_REGISTROREVENUETRANSA_out = SCOPE_IDENTITY();
	end
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddReplaceAppendRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddReplaceAppendRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGISTROREVENUETRANSACCION_AddReplaceAppendRecord(@p_CODREGISTROREVENUE           NUMERIC(22,0),
                                   @p_CODREGISTROFACTREFERENCIA    NUMERIC(22,0),
                                   @p_CODRANGOCOMISION             NUMERIC(22,0),
                                   @p_CODRANGOCOMISIONDETALLE      NUMERIC(22,0),
                                   @p_REVENUE                      FLOAT,
                                   @p_ID_REGISTROREVENUETRANSA_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_REGISTROREVENUETRANSA_out = ID_REGISTROREVENUETRANSACCION
    FROM WSXML_SFG.REGISTROREVENUETRANSACCION
    WHERE CODREGISTROREVENUE = @p_CODREGISTROREVENUE AND CODREGISTROFACTREFERENCIA = @p_CODREGISTROFACTREFERENCIA;
    UPDATE WSXML_SFG.REGISTROREVENUETRANSACCION SET CODRANGOCOMISION        = @p_CODRANGOCOMISION,
                                          CODRANGOCOMISIONDETALLE = @p_CODRANGOCOMISIONDETALLE,
                                          REVENUE                 = REVENUE + @p_REVENUE
    WHERE ID_REGISTROREVENUETRANSACCION = @p_ID_REGISTROREVENUETRANSA_out;
  IF @@ROWCOUNT   = 0 BEGIN
    INSERT INTO WSXML_SFG.REGISTROREVENUETRANSACCION (
                                            CODREGISTROREVENUE,
                                            CODREGISTROFACTREFERENCIA,
                                            CODRANGOCOMISION,
                                            CODRANGOCOMISIONDETALLE,
                                            REVENUE)
    VALUES (
            @p_CODREGISTROREVENUE,
            @p_CODREGISTROFACTREFERENCIA,
            @p_CODRANGOCOMISION,
            @p_CODRANGOCOMISIONDETALLE,
            @p_REVENUE);
    SET @p_ID_REGISTROREVENUETRANSA_out = SCOPE_IDENTITY();
END
  END;
GO






