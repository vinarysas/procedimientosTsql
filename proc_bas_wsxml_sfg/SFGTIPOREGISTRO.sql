USE SFGPRODU;
--  DDL for Package Body SFGTIPOREGISTRO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOREGISTRO */ 


	    IF OBJECT_ID('WSXML_SFG.SFGTIPOREGISTRO_CONSTANT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_CONSTANT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_CONSTANT(
                      @VENTAFACT SMALLINT OUT,
                      @ANULACION SMALLINT OUT,
					  @FREETICKT SMALLINT OUT,
					  @PREMIOPAG SMALLINT OUT,
					  @RGSTOTROS SMALLINT OUT,
					  @VENNOFACT SMALLINT OUT
					  
					  ) AS
  BEGIN
  SET NOCOUNT ON;
	  SET @VENTAFACT = 1;
	  SET @ANULACION = 2;
	  SET @FREETICKT = 3;
	  SET @PREMIOPAG = 4;
	  SET @RGSTOTROS = 5;
	  SET @VENNOFACT = 6;
  END;
GO
  
  
  IF OBJECT_ID('WSXML_SFG.SFGTIPOREGISTRO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_AddRecord(@p_NOMTIPOREGISTRO        NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_TIPOREGISTRO_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPOREGISTRO (
                              NOMTIPOREGISTRO,
                              CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMTIPOREGISTRO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_TIPOREGISTRO_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOREGISTRO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_UpdateRecord(@pk_ID_TIPOREGISTRO       NUMERIC(22,0),
                         @p_NOMTIPOREGISTRO        NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.TIPOREGISTRO
       SET NOMTIPOREGISTRO        = @p_NOMTIPOREGISTRO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_TIPOREGISTRO        = @pk_ID_TIPOREGISTRO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOREGISTRO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_GetRecord(@pk_ID_TIPOREGISTRO NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*) FROM WSXML_SFG.TIPOREGISTRO
     WHERE ID_TIPOREGISTRO = @pk_ID_TIPOREGISTRO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_TIPOREGISTRO,
             NOMTIPOREGISTRO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOREGISTRO
       WHERE ID_TIPOREGISTRO = @pk_ID_TIPOREGISTRO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGTIPOREGISTRO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGTIPOREGISTRO_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_TIPOREGISTRO,
             NOMTIPOREGISTRO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.TIPOREGISTRO
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO






