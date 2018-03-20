USE SFGPRODU;
--  DDL for Package Body SFGDETALLECALIFICACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLECALIFICACION */ 

 IF OBJECT_ID('WSXML_SFG.SFGDETALLECALIFICACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_AddRecord;
GO

CREATE   PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_AddRecord(@p_CODCALIFICACIONCARTERA            NUMERIC(22,0),
                      @p_CODOPERACIONPDV             NUMERIC(22,0),
                      @p_DESIGUALDAD                 CHAR,
                      @p_VALOR                       FLOAT,
                      @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                      @p_ID_DETALLECALIFICACION_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    insert into WSXML_SFG.detallecalificacion
      (
     codcalificacioncartera
      , codoperacionpdv
      , desigualdad
      , valor
      , codusuariomodificacion
      )
    values
      (
 @p_CODCALIFICACIONCARTERA
      , @p_CODOPERACIONPDV
      , @p_DESIGUALDAD
      , @p_VALOR
      , @p_CODUSUARIOMODIFICACION
      );

    SET @p_ID_DETALLECALIFICACION_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALIFICACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_UpdateRecord(@pk_ID_DETALLECALIFICACION NUMERIC(22,0),
                          @p_CODCALIFICACIONCARTERA            NUMERIC(22,0),
                          @p_CODOPERACIONPDV             NUMERIC(22,0),
                          @p_DESIGUALDAD                 CHAR,
                          @p_VALOR                       FLOAT,
                          @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                          @p_ACTIVE                   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    update WSXML_SFG.detallecalificacion
       set
           codcalificacioncartera = @p_CODCALIFICACIONCARTERA,
           codoperacionpdv = @p_CODOPERACIONPDV,
           desigualdad = @p_DESIGUALDAD,
           valor = @p_VALOR,
           fechahoramodificacion = GETDATE(),
           codusuariomodificacion = @p_CODUSUARIOMODIFICACION,
           active = @p_ACTIVE
     where id_detallecalificacion = @pk_ID_DETALLECALIFICACION;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALIFICACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_GetRecord(@pk_ID_DETALLECALIFICACION NUMERIC(22,0)
                      ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.detallecalificacion
     WHERE id_detallecalificacion = @pk_ID_DETALLECALIFICACION;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

   

      SELECT D.ID_DETALLECALIFICACION,
             D.CODCALIFICACIONCARTERA,
             D.CODOPERACIONPDV,
             O.NOMOPERACIONPDV,
             D.DESIGUALDAD,
             D.VALOR,
             D.FECHAHORAMODIFICACION,
             D.CODUSUARIOMODIFICACION,
             D.ACTIVE
      FROM WSXML_SFG.DETALLECALIFICACION D
      LEFT OUTER JOIN WSXML_SFG.OPERACIONPDV O
        ON (O.ID_OPERACIONPDV = D.CODOPERACIONPDV)
      WHERE D.ID_DETALLECALIFICACION = @pk_ID_DETALLECALIFICACION;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALIFICACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_GetList(@p_active NUMERIC(22,0)
                                                                  ) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT D.ID_DETALLECALIFICACION,
             D.CODCALIFICACIONCARTERA,
             D.CODOPERACIONPDV,
             O.NOMOPERACIONPDV,
             D.DESIGUALDAD,
             D.VALOR,
             D.FECHAHORAMODIFICACION,
             D.CODUSUARIOMODIFICACION,
             D.ACTIVE
      FROM WSXML_SFG.DETALLECALIFICACION D
      LEFT OUTER JOIN WSXML_SFG.OPERACIONPDV O
        ON (O.ID_OPERACIONPDV = D.CODOPERACIONPDV)
       WHERE D.ACTIVE = CASE WHEN @p_active = -1 THEN D.ACTIVE ELSE @p_active END;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECALIFICACION_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_GetListByHeader;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECALIFICACION_GetListByHeader(@p_active NUMERIC(22,0),
           @p_CODCALIFICACIONCARTERA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
     
      SELECT D.ID_DETALLECALIFICACION,
             D.CODCALIFICACIONCARTERA,
             D.CODOPERACIONPDV,
             O.NOMOPERACIONPDV,
             D.DESIGUALDAD,
             D.VALOR,
             D.FECHAHORAMODIFICACION,
             D.CODUSUARIOMODIFICACION,
             D.ACTIVE
      FROM WSXML_SFG.DETALLECALIFICACION D
      LEFT OUTER JOIN WSXML_SFG.OPERACIONPDV O
        ON (O.ID_OPERACIONPDV = D.CODOPERACIONPDV)
       WHERE D.CODCALIFICACIONCARTERA = @p_CODCALIFICACIONCARTERA
         AND D.ACTIVE = CASE WHEN @p_active = -1 THEN D.ACTIVE ELSE @p_active END;
        
  END;
GO





