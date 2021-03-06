USE SFGPRODU;
--  DDL for Package Body SFGCONTROL_L1SHRCLC
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCONTROL_L1SHRCLC */ 

  --Add Record in the table CONTROL_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1SHRCLC_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_AddRecord(@p_FECHAHORAGENERACIONARCHIVO DATETIME,
                      @p_SEMANA                     NUMERIC(22,0),
                      @p_CDC                        NUMERIC(22,0),
                      @p_SORTEO                     NUMERIC(22,0),
                      @p_FECHASORTEO                DATETIME,
                      @p_FECHAHORAMODIFICACION      DATETIME,
                      @p_CODUSUARIOMODIFICACION     NUMERIC(22,0),
                      @p_ACTIVE                     NUMERIC(22,0),
                      @p_ID_CONTROL_L1SHRCLC_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CONTROL_L1SHRCLC
      (FECHAHORAGENERACIONARCHIVO,
       SEMANA,
       CDC,
       SORTEO,
       FECHASORTEO,
       FECHAHORAMODIFICACION,
       CODUSUARIOMODIFICACION,
       ACTIVE)
    VALUES
      (@p_FECHAHORAGENERACIONARCHIVO,
       @p_SEMANA,
       @p_CDC,
       @p_SORTEO,
       @p_FECHASORTEO,
       @p_FECHAHORAMODIFICACION,
       @p_CODUSUARIOMODIFICACION,
       @p_ACTIVE);
    SET @p_ID_CONTROL_L1SHRCLC_out = SCOPE_IDENTITY();
  END;
GO

  --Find Record on the table CONTROL_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1SHRCLC_FindRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_FindRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_FindRecord(@p_CDC NUMERIC(22,0), @p_ID_CONTROL_L1SHRCLC_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @p_ID_CONTROL_L1SHRCLC_out = ID_CONTROL_L1SHRCLC
      FROM WSXML_SFG.CONTROL_L1SHRCLC
     WHERE CDC = @p_CDC;
  
	IF @@ROWCOUNT = 0
      SET @p_ID_CONTROL_L1SHRCLC_out = 0;
  END;
GO

  --Delete Record on the table CONTROL_L1LIAB01
  IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1SHRCLC_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_DeleteRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_DeleteRecord(@p_CDC NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    DELETE WSXML_SFG.CONTROL_L1SHRCLC WHERE CDC = @p_CDC;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1SHRCLC_AddControll1shrclc', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_AddControll1shrclc;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_AddControll1shrclc(@pFECHAHORAGENERACIONARCHIVO DATETIME,
                      @pCDC                        NUMERIC(22,0),
                      @pFECHASORTEO                DATETIME,
                      @pSORTEO                     NUMERIC(22,0),
                      @pNOMBREPRODUCTO             VARCHAR(4000),
                      @pCODUSUARIOMODIFICACION     NUMERIC(22,0),
                      @pFECHAHORAMODIFICACION      DATETIME,
                      @pACTIVE                     NUMERIC(22,0),
                      @p_IDCONTROLL1SHRCLC_out NUMERIC(22,0) OUT) AS
 BEGIN
  DECLARE @vCODPRODUCTO NUMERIC(22,0);
   
  SET NOCOUNT ON;
    --Consulta id producto 
    EXEC WSXML_SFG.SFGPREMIOSL1LIAB_GetProductobyNombre @pNOMBREPRODUCTO, @vCODPRODUCTO OUT
    
    INSERT INTO WSXML_SFG.CONTROL_L1SHRCLC
      (FECHAHORAGENERACIONARCHIVO,
       CDC,
       SORTEO,
       FECHASORTEO,
       FECHAHORAMODIFICACION,
       CODUSUARIOMODIFICACION,
       ACTIVE, 
       CODPRODUCTO)
    VALUES
      (@pFECHAHORAGENERACIONARCHIVO,
       @pCDC,
       @pSORTEO,
       @pFECHASORTEO,
       @pFECHAHORAMODIFICACION,
       @pCODUSUARIOMODIFICACION,
       @pACTIVE,
       @vCODPRODUCTO);
    SET @p_IDCONTROLL1SHRCLC_out = SCOPE_IDENTITY();
  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGCONTROL_L1SHRCLC_ReverseSHRCLC', 'P') is not null
  drop PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_ReverseSHRCLC;
go

create     PROCEDURE WSXML_SFG.SFGCONTROL_L1SHRCLC_ReverseSHRCLC(@pCDC NUMERIC(22,0)) as
  begin
  set nocount on; 
    delete from CONTROL_L1SHRCLC where cdc = @pCDC;
  END;
GO





