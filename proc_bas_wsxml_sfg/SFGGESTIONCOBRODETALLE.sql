USE SFGPRODU;
--  DDL for Package Body SFGGESTIONCOBRODETALLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGGESTIONCOBRODETALLE */ 

IF OBJECT_ID('WSXML_SFG.SFGGESTIONCOBRODETALLE_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_AddRecord(@p_CODGESTIONCOBRO             NUMERIC(22,0),
                      @p_FECHAGESTION                DATETIME,
                      @p_DIASMORA                    NUMERIC(22,0),
                      @p_SALDOMORAGTECH              NUMERIC(22,0),
                      @p_SALDOMORAFIDUCIA            NUMERIC(22,0),
                      @p_FECHAPROXPAGO               DATETIME,
                      @p_OBSERVACIONES               VARCHAR,
                      @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                      @p_ACTIVE                      NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO           NUMERIC(22,0),
                      @p_VALORACUERDOPAGO            NUMERIC(22,0),
                      @p_CALIFICACION                NUMERIC(22,0),
                      @p_ID_GESTIONCOBRODETALLE_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
     INSERT INTO WSXML_SFG.GESTIONCOBRODETALLE
        (
          CODGESTIONCOBRO,
          FECHAGESTION,
          DIASMORA,
          SALDOMORAGTECH,
          SALDOMORAFIDUCIA,
          FECHAPROXPAGO,
          OBSERVACIONES,
          CODUSUARIOMODIFICACION,
          CODLINEADENEGOCIO,
          VALORACUERDOPAGO,
          CALIFICACION,
          ACTIVE)
      VALUES
        (
          @p_CODGESTIONCOBRO,
          @p_FECHAGESTION,
          @p_DIASMORA,
          @p_SALDOMORAGTECH,
          @p_SALDOMORAFIDUCIA,
          @p_FECHAPROXPAGO,
          @p_OBSERVACIONES,
          @p_CODUSUARIOMODIFICACION,
          @p_CODLINEADENEGOCIO,
          @p_VALORACUERDOPAGO,
          @p_CALIFICACION,
          @p_ACTIVE);
      SET @p_ID_GESTIONCOBRODETALLE_out = SCOPE_IDENTITY();

--    NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGGESTIONCOBRODETALLE_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_UpdateRecord;
GO 

  CREATE PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_UpdateRecord(@pk_ID_GESTIONCOBRODETALLE     NUMERIC(22,0),
                      @p_CODGESTIONCOBRO             NUMERIC(22,0),
                      @p_FECHAGESTION                DATETIME,
                      @p_DIASMORA                    NUMERIC(22,0),
                      @p_SALDOMORAGTECH              NUMERIC(22,0),
                      @p_SALDOMORAFIDUCIA            NUMERIC(22,0),
                      @p_FECHAPROXPAGO               DATETIME,
                      @p_OBSERVACIONES               VARCHAR,
                      @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                      @p_CODLINEADENEGOCIO           NUMERIC(22,0),
                      @p_VALORACUERDOPAGO            NUMERIC(22,0),
                      @p_CALIFICACION                NUMERIC(22,0),
                      @p_ACTIVE                      NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
    UPDATE WSXML_SFG.GESTIONCOBRODETALLE
       SET CODGESTIONCOBRO        = @p_CODGESTIONCOBRO,
           FECHAGESTION           = @p_FECHAGESTION,
           DIASMORA               = @p_DIASMORA,
           SALDOMORAGTECH         = @p_SALDOMORAGTECH,
           SALDOMORAFIDUCIA       = @p_SALDOMORAFIDUCIA,
           FECHAPROXPAGO          = @p_FECHAPROXPAGO,
           OBSERVACIONES          = @p_OBSERVACIONES,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            CODLINEADENEGOCIO     = @p_CODLINEADENEGOCIO,
            VALORACUERDOPAGO      = @p_VALORACUERDOPAGO,
            CALIFICACION          = @p_CALIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_GESTIONCOBRODETALLE = @pk_ID_GESTIONCOBRODETALLE;
    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
   -- NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGGESTIONCOBRODETALLE_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_GetRecord(@pk_ID_GESTIONCOBRODETALLE NUMERIC(22,0)
                                                             ) AS
 BEGIN
  DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    /* TODO implementation required */
    SELECT @l_count = count(*)
      FROM WSXML_SFG.GESTIONCOBRODETALLE
     WHERE ID_GESTIONCOBRODETALLE = @pk_ID_GESTIONCOBRODETALLE;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT A.ID_GESTIONCOBRODETALLE,
            A.CODGESTIONCOBRO,
            A.FECHAGESTION,
            A.DIASMORA,
            A.SALDOMORAGTECH,
            A.SALDOMORAFIDUCIA,
            A.FECHAPROXPAGO,
            A.OBSERVACIONES,
            A.CODUSUARIOMODIFICACION,
            A.ACTIVE
      FROM WSXML_SFG.GESTIONCOBRODETALLE A
      WHERE A.ID_GESTIONCOBRODETALLE = @pk_ID_GESTIONCOBRODETALLE;
	  
--    NULL;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGGESTIONCOBRODETALLE_GetListGestionCobro', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_GetListGestionCobro;
GO

  CREATE PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_GetListGestionCobro
        (@pk_ID_CODGESTIONCOBRO NUMERIC(22,0)) AS
 BEGIN
  DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    /* TODO implementation required */
    SELECT @l_count = count(*)
      FROM WSXML_SFG.GESTIONCOBRODETALLE
     WHERE CODGESTIONCOBRO = @pk_ID_CODGESTIONCOBRO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT A.ID_GESTIONCOBRODETALLE,
            A.CODGESTIONCOBRO,
            A.FECHAGESTION,
            A.DIASMORA,
            A.SALDOMORAGTECH,
            A.SALDOMORAFIDUCIA,
            A.FECHAPROXPAGO,
            A.OBSERVACIONES,
            A.CODUSUARIOMODIFICACION,
            A.ACTIVE,
            A.CODLINEADENEGOCIO,
            A.VALORACUERDOPAGO,
            A.CALIFICACION
      FROM WSXML_SFG.GESTIONCOBRODETALLE A
      WHERE A.CODGESTIONCOBRO = @pk_ID_CODGESTIONCOBRO;
	  
   -- NULL;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGGESTIONCOBRODETALLE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_GetList;
GO

  CREATE PROCEDURE WSXML_SFG.SFGGESTIONCOBRODETALLE_GetList(@p_ACTIVE NUMERIC(22,0)
                                                            ) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
	
      SELECT  A.ID_GESTIONCOBRODETALLE,
            A.CODGESTIONCOBRO,
            A.FECHAGESTION,
            A.DIASMORA,
            A.SALDOMORAGTECH,
            A.SALDOMORAFIDUCIA,
            A.FECHAPROXPAGO,
            A.OBSERVACIONES,
            A.CODUSUARIOMODIFICACION,
            A.ACTIVE,
            A.CODLINEADENEGOCIO,
            A.VALORACUERDOPAGO,
            A.CALIFICACION
      FROM WSXML_SFG.GESTIONCOBRODETALLE A
      WHERE A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END;
	  
--    NULL;
  END;
GO






