USE SFGPRODU;
--  DDL for Package Body SFGCONTROL_L1LIAB01
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCONTROL_L1LIAB01 */ 

  --Add Record in the table CONTROL_L1LIAB01
IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1LIAB01_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1LIAB01_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1LIAB01_AddRecord(@p_FECHAHORAGENERACION     DATETIME,
                      @p_SEMANA                  NUMERIC(22,0),
                      @p_CDC                     NUMERIC(22,0),
                      @p_TOT_GRAL_TOT_GANADO     NUMERIC(22,0),
                      @p_TOT_GRAL_PAG_ANT        NUMERIC(22,0),
                      @p_TOT_GRAL_PAG_HOY        NUMERIC(22,0),
                      @p_TOT_GRAL_PURG_EXPIR     NUMERIC(22,0),
                      @p_TOT_GRAL_PEND           NUMERIC(22,0),
                      @p_TOT_GRAL_RETEFUENTE     NUMERIC(22,0),
                      @p_TOT_GRAL_IMP_IND_X_PREM NUMERIC(22,0),
                      @p_FECHAHORAMODIFICACION   DATETIME,
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ACTIVE                  NUMERIC(22,0),
                      @p_FECHAHORAGENERACIONARCHIVO     DATETIME,
                      @p_ID_CONTROL_L1LIAB01_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CONTROL_L1LIAB01 (
                                  FECHAHORAGENERACION,
                                  SEMANA,
                                  CDC,
                                  TOT_GRAL_TOT_GANADO,
                                  TOT_GRAL_PAG_ANT,
                                  TOT_GRAL_PAG_HOY,
                                  TOT_GRAL_PURG_EXPIR,
                                  TOT_GRAL_PEND,
                                  TOT_GRAL_RETEFUENTE,
                                  TOT_GRAL_IMP_IND_X_PREM,
                                  FECHAHORAMODIFICACION,
                                  CODUSUARIOMODIFICACION,
                                  ACTIVE,
                                  FECHAHORAGENERACIONARCHIVO)
    VALUES (
            @p_FECHAHORAGENERACION,
            @p_SEMANA,
            @p_CDC,
            @p_TOT_GRAL_TOT_GANADO,
            @p_TOT_GRAL_PAG_ANT,
            @p_TOT_GRAL_PAG_HOY,
            @p_TOT_GRAL_PURG_EXPIR,
            @p_TOT_GRAL_PEND,
            @p_TOT_GRAL_RETEFUENTE,
            @p_TOT_GRAL_IMP_IND_X_PREM,
            @p_FECHAHORAMODIFICACION,
            @p_CODUSUARIOMODIFICACION,
            @p_ACTIVE,
            @p_FECHAHORAGENERACIONARCHIVO);
    SET @p_ID_CONTROL_L1LIAB01_out = SCOPE_IDENTITY();
  END;
GO

  --Find Record on the table CONTROL_L1LIAB01
IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1LIAB01_FindRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1LIAB01_FindRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1LIAB01_FindRecord(@p_CDC                     NUMERIC(22,0),
                      @p_ID_CONTROL_L1LIAB01_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_CONTROL_L1LIAB01_out = ID_CONTROL_L1LIAB01
    FROM WSXML_SFG.CONTROL_L1LIAB01 WHERE CDC = @p_CDC;
  
  /*
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SET @p_ID_CONTROL_L1LIAB01_out = 0;
	  */

	  IF(@@rowcount = 0)
	  BEGIN
	   SET @p_ID_CONTROL_L1LIAB01_out = 0
      END
  END;
GO

  --Delete Record on the table CONTROL_L1LIAB01
IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1LIAB01_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1LIAB01_DeleteRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1LIAB01_DeleteRecord(@p_CDC                     NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    DELETE FROM WSXML_SFG.CONTROL_L1LIAB01 WHERE CDC = @p_CDC;
  END;
GO






