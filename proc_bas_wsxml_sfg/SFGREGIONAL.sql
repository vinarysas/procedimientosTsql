USE SFGPRODU;
--  DDL for Package Body SFGREGIONAL
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREGIONAL */ 

  IF OBJECT_ID('WSXML_SFG.SFGREGIONAL_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIONAL_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGIONAL_AddRecord(@p_NOMREGIONAL            NVARCHAR(2000),
                      @p_CODJEFEDISTRITO        NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @pk_ID_REGIONAL_out       NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.REGIONAL(
                         NOMREGIONAL,
                         CODJEFEDISTRITO,
                         CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMREGIONAL,
            CASE WHEN @p_CODJEFEDISTRITO > 0 THEN @p_CODJEFEDISTRITO ELSE 1 END,
            @p_CODUSUARIOMODIFICACION);
    SET @pk_ID_REGIONAL_out = SCOPE_IDENTITY();
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGREGIONAL_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIONAL_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREGIONAL_UpdateRecord(@pk_ID_REGIONAL           NUMERIC(22,0),
                         @p_NOMREGIONAL            NVARCHAR(2000),
                         @p_CODJEFEDISTRITO        NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.REGIONAL
       SET NOMREGIONAL            = @p_NOMREGIONAL,
           CODJEFEDISTRITO        = CASE WHEN @p_CODJEFEDISTRITO > 0 THEN @p_CODJEFEDISTRITO ELSE NULL END,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_REGIONAL = @pk_ID_REGIONAL;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGREGIONAL_UpdateJefeDistrito', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIONAL_UpdateJefeDistrito;
GO

CREATE PROCEDURE WSXML_SFG.SFGREGIONAL_UpdateJefeDistrito(@pk_ID_REGIONAL    NUMERIC(22,0),
                               @p_CODJEFEDISTRITO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.REGIONAL
       SET CODJEFEDISTRITO = CASE WHEN @p_CODJEFEDISTRITO > 0 THEN @p_CODJEFEDISTRITO ELSE NULL END
     WHERE ID_REGIONAL     = @pk_ID_REGIONAL;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGREGIONAL_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIONAL_GetRecord;
GO


CREATE PROCEDURE WSXML_SFG.SFGREGIONAL_GetRecord(@pk_ID_REGIONAL NUMERIC(22,0)
                                                 ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.REGIONAL WHERE ID_REGIONAL = @pk_ID_REGIONAL;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_REGIONAL,
             NOMREGIONAL,
             CODJEFEDISTRITO,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.REGIONAL
       WHERE ID_REGIONAL = @pk_ID_REGIONAL;
	   
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGREGIONAL_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREGIONAL_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGREGIONAL_GetList(@p_active NUMERIC(22,0)
                                               ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT ID_REGIONAL,
             NOMREGIONAL,
             CODJEFEDISTRITO,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.REGIONAL
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	   
   -- NULL;
  END;
GO






