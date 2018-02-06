USE SFGPRODU;
--  DDL for Package Body SFGRANGOCOMISIONDETALLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGRANGOCOMISIONDETALLE */ 

  -- Creates a new record in the RANGOCOMISIONDETALLE table
  IF OBJECT_ID('WSXML_SFG.SFGRANGOCOMISIONDETALLE_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_AddRecord(@p_CODRANGOCOMISION            NUMERIC(22,0),
                      @p_RANGOINICIAL                FLOAT,
                      @p_RANGOFINAL                  FLOAT,
                      @p_VALORPORCENTUAL             FLOAT,
                      @p_VALORTRANSACCIONAL          FLOAT,
                      @p_FECHAINICIOVALIDEZ          DATETIME,
                      @p_FECHAFINVALIDEZ             DATETIME,
                      @p_INCENTIVO                   FLOAT,
                      @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                      @p_ID_RANGOCOMISIONDETALLE_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.RANGOCOMISIONDETALLE (
                                      CODRANGOCOMISION,
                                      RANGOINICIAL,
                                      RANGOFINAL,
                                      VALORPORCENTUAL,
                                      VALORTRANSACCIONAL,
                                      INCENTIVO,
                                      CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODRANGOCOMISION,
            CASE WHEN isnull(@p_RANGOINICIAL,0) <= 0 THEN 0 ELSE @p_RANGOINICIAL END,
            CASE WHEN @p_RANGOFINAL <= 0 THEN NULL ELSE @p_RANGOFINAL END,
            round(@p_VALORPORCENTUAL, 3),
            @p_VALORTRANSACCIONAL,
            @p_INCENTIVO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_RANGOCOMISIONDETALLE_out = SCOPE_IDENTITY();
  END;
GO

  -- Updates a record in the RANGOCOMISIONDETALLE table.
  IF OBJECT_ID('WSXML_SFG.SFGRANGOCOMISIONDETALLE_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_UpdateRecord(@pk_ID_RANGOCOMISIONDETALLE NUMERIC(22,0),
                         @p_CODRANGOCOMISION         NUMERIC(22,0),
                         @p_RANGOINICIAL             FLOAT,
                         @p_RANGOFINAL               FLOAT,
                         @p_VALORPORCENTUAL          FLOAT,
                         @p_VALORTRANSACCIONAL       FLOAT,
                         @p_FECHAINICIOVALIDEZ       DATETIME,
                         @p_FECHAFINVALIDEZ          DATETIME,
                         @p_INCENTIVO                FLOAT,
                         @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                         @p_ACTIVE                   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.RANGOCOMISIONDETALLE
       SET CODRANGOCOMISION       = @p_CODRANGOCOMISION,
           RANGOINICIAL           = @p_RANGOINICIAL,
           RANGOFINAL             = @p_RANGOFINAL,
           VALORPORCENTUAL        = @p_VALORPORCENTUAL,
           VALORTRANSACCIONAL     = @p_VALORTRANSACCIONAL,
           INCENTIVO              = @p_INCENTIVO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_RANGOCOMISIONDETALLE = @pk_ID_RANGOCOMISIONDETALLE;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetRecord(@pk_ID_RANGOCOMISIONDETALLE NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = count(*) FROM WSXML_SFG.RANGOCOMISIONDETALLE
    WHERE ID_RANGOCOMISIONDETALLE = @pk_ID_RANGOCOMISIONDETALLE;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_RANGOCOMISIONDETALLE,
             CODRANGOCOMISION,
             RANGOINICIAL,
             RANGOFINAL,
             VALORPORCENTUAL,
             VALORTRANSACCIONAL,
             INCENTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.RANGOCOMISIONDETALLE
       WHERE ID_RANGOCOMISIONDETALLE = @pk_ID_RANGOCOMISIONDETALLE;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_RANGOCOMISIONDETALLE,
             CODRANGOCOMISION,
             RANGOINICIAL,
             RANGOFINAL,
             VALORPORCENTUAL,
             VALORTRANSACCIONAL,
             INCENTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.RANGOCOMISIONDETALLE
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetListByHeader;
GO
CREATE     PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetListByHeader(@p_active NUMERIC(22,0), @p_CODRANGOCOMISION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT ID_RANGOCOMISIONDETALLE,
             CODRANGOCOMISION,
             RANGOINICIAL,
             RANGOFINAL,
             VALORPORCENTUAL,
             VALORTRANSACCIONAL,
             INCENTIVO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.RANGOCOMISIONDETALLE
       WHERE CODRANGOCOMISION = @p_CODRANGOCOMISION
         AND ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetByCodRangoComision', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetByCodRangoComision;
GO

CREATE     PROCEDURE WSXML_SFG.SFGRANGOCOMISIONDETALLE_GetByCodRangoComision(@p_CODRANGOCOMISION NUMERIC(22,0)
                ) AS
  BEGIN
  SET NOCOUNT ON;
  
      SELECT ID_RANGOCOMISIONDETALLE,
      CODRANGOCOMISION,
      RANGOINICIAL,
      RANGOFINAL,
      FECHAHORAMODIFICACION,
      CODUSUARIOMODIFICACION,
      ACTIVE,
      INCENTIVO,
      VALORPORCENTUAL,
      VALORTRANSACCIONAL
      FROM WSXML_SFG.RANGOCOMISIONDETALLE WHERE CODRANGOCOMISION = @p_CODRANGOCOMISION;
	
  END;
GO

