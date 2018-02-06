USE SFGPRODU;
--  DDL for Package Body SFGCTRLTRANSACCION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCTRLTRANSACCION */ 
  IF OBJECT_ID('WSXML_SFG.SFGCTRLTRANSACCION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_AddRecord(@p_CODARCHIVOPAGO         NUMERIC(22,0),
                      @p_FECHACARGUE            DATETIME,
                      @p_TOTALTRANSACCION       FLOAT,
                      @p_TOTALREGISTROS         NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_CTRLTRANSACCION_out        NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CTRLTRANSACCION (
                                 CODARCHIVOPAGO,
                                 FECHACARGUE,
                                 TOTALTRANSACCION,
                                 TOTALREGISTROS,
                                 CODUSUARIOMODIFICACION)
      VALUES (
              @p_CODARCHIVOPAGO,
              @p_FECHACARGUE,
              @p_TOTALTRANSACCION,
              @p_TOTALREGISTROS,
              @p_CODUSUARIOMODIFICACION);
      SET @p_ID_CTRLTRANSACCION_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGCTRLTRANSACCION_AddRecordFromFile', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_AddRecordFromFile;
GO


  CREATE PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_AddRecordFromFile(@p_CODARCHIVOPAGO          NUMERIC(22,0),
                              @p_FECHACARGUE             DATETIME,
                              @p_TOTALTRANSACCION        FLOAT,
                              @p_TOTALREGISTROS          NUMERIC(22,0),
                              @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                              @p_ID_CTRLTRANSACCION_out         NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.CTRLTRANSACCION (
                                 CODARCHIVOPAGO,
                                 FECHACARGUE,
                                 TOTALTRANSACCION,
                                 TOTALREGISTROS,
                                 CODUSUARIOMODIFICACION)
      VALUES (
              @p_CODARCHIVOPAGO,
              @p_FECHACARGUE,
              @p_TOTALTRANSACCION,
              @p_TOTALREGISTROS,
              @p_CODUSUARIOMODIFICACION);
      SET @p_ID_CTRLTRANSACCION_out = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGCTRLTRANSACCION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_UpdateRecord;
GO

  CREATE PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_UpdateRecord(@pk_ID_CTRLTRANSACCION           NUMERIC(22,0),
                         @p_CODARCHIVOPAGO         NUMERIC(22,0),
                         @p_FECHACARGUE            DATETIME,
                         @p_TOTALTRANSACCION       FLOAT,
                         @p_TOTALREGISTROS         NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.CTRLTRANSACCION
       SET CODARCHIVOPAGO         = @p_CODARCHIVOPAGO,
           FECHACARGUE            = @p_FECHACARGUE,
           TOTALTRANSACCION       = @p_TOTALTRANSACCION,
           TOTALREGISTROS         = @p_TOTALREGISTROS,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_CTRLTRANSACCION = @pk_ID_CTRLTRANSACCION;
  END;
GO 

IF OBJECT_ID('WSXML_SFG.SFGCTRLTRANSACCION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_GetRecord;
GO
  CREATE PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_GetRecord(@pk_ID_CTRLTRANSACCION NUMERIC(22,0)
                                                              )AS
BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.CTRLTRANSACCION WHERE ID_CTRLTRANSACCION = @pk_ID_CTRLTRANSACCION;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT A.ID_CTRLTRANSACCION,
             A.CODARCHIVOPAGO,
             A.FECHACARGUE,
             A.TOTALTRANSACCION,
             A.TOTALREGISTROS,
             A.CODUSUARIOMODIFICACION,
             A.FECHAHORAMODIFICACION,
             A.ACTIVE
      FROM WSXML_SFG.CTRLTRANSACCION A
      WHERE A.ID_CTRLTRANSACCION = @pk_ID_CTRLTRANSACCION;
	  
  END;
GO
 
IF OBJECT_ID('WSXML_SFG.SFGCTRLTRANSACCION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_GetList;
GO


  CREATE PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_GetList(@p_ACTIVE NUMERIC(22,0)
                                                            ) AS
  BEGIN
  SET NOCOUNT ON;
     
      SELECT ID_CTRLTRANSACCION,
             CODARCHIVOPAGO,
             FECHACARGUE,
             TOTALTRANSACCION,
             TOTALREGISTROS,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.CTRLTRANSACCION
      WHERE ACTIVE =  CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
      
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGCTRLTRANSACCION_GetListFechaProceso', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_GetListFechaProceso;
GO

  CREATE PROCEDURE WSXML_SFG.SFGCTRLTRANSACCION_GetListFechaProceso(@p_FECHACARGUE DATETIME
                                                                        ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT ID_CTRLTRANSACCION,
             CODARCHIVOPAGO,
             FECHACARGUE,
             TOTALTRANSACCION,
             TOTALREGISTROS,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.CTRLTRANSACCION
      WHERE FECHACARGUE = @p_FECHACARGUE;
	  
  END;
GO






