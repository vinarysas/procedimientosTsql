USE SFGPRODU;
--  DDL for Package Body SFGPDVCALIFICACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPDVCALIFICACION */ 

 IF OBJECT_ID('WSXML_SFG.SFGPDVCALIFICACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_AddRecord;
GO

CREATE   PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_AddRecord(@p_CODCALIFICACIONCARTERA        NUMERIC(22,0),
                      @p_CODPUNTOVENTA         NUMERIC(38,0),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_CALIFICACION  NUMERIC(22,0),
                      @p_ID_PDVCALIFICACION_out    NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

  UPDATE WSXML_SFG.pdvcalificacion
  SET active = 0
  WHERE codpuntodeventa = @p_CODPUNTOVENTA
  AND active = 1;

  insert into WSXML_SFG.pdvcalificacion
    (
    codpuntodeventa
    , codusuariomodificacion
    , codcalificacioncartera
    , calificacion
    )
  values
    (
 @p_CODPUNTOVENTA
    , @p_CODUSUARIOMODIFICACION
    , @p_CODCALIFICACIONCARTERA
    , @p_CALIFICACION);

    SET @p_ID_PDVCALIFICACION_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPDVCALIFICACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_UpdateRecord(@pk_ID_PDVCALIFICACION    NUMERIC(22,0),
                          @p_CODCALIFICACIONCARTERA        NUMERIC(22,0),
                          @p_CODPUNTOVENTA         NUMERIC(38,0),
                          @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                          @p_CALIFICACION  NUMERIC(22,0),
                          @p_ACTIVE                  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

  update WSXML_SFG.pdvcalificacion
     set codpuntodeventa = @p_CODPUNTOVENTA,
         codusuariomodificacion = @p_CODUSUARIOMODIFICACION,
         fechahoramodificacion = GETDATE(),
         active = @p_ACTIVE,
         codcalificacioncartera = @p_CODCALIFICACIONCARTERA,
         calificacion = @p_CALIFICACION
   where id_pdvcalificacion = @pk_ID_PDVCALIFICACION;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPDVCALIFICACION_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_DeactivateRecord(@pk_ID_PDVCALIFICACION NUMERIC(22,0), @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.pdvcalificacion
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE id_pdvcalificacion = @pk_ID_PDVCALIFICACION;

  END;
GO

   IF OBJECT_ID('WSXML_SFG.SFGPDVCALIFICACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_GetRecord;
GO

CREATE       PROCEDURE WSXML_SFG.SFGPDVCALIFICACION_GetRecord(@p_CODPUNTOVENTA NUMERIC(22,0)
                      ) AS
   BEGIN
   SET NOCOUNT ON;

	  
      SELECT PC.ID_PDVCALIFICACION,
             PC.CALIFICACION
      FROM WSXML_SFG.pdvcalificacion PC
      WHERE PC.CODPUNTODEVENTA = @p_CODPUNTOVENTA
      AND PC.ACTIVE = 1;
	
  END;
GO





