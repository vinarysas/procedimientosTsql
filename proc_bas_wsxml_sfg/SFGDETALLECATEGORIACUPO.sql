USE SFGPRODU;
--  DDL for Package Body SFGDETALLECATEGORIACUPO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLECATEGORIACUPO */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECATEGORIACUPO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_AddRecord(@p_CODCATEGORIACUPO            NUMERIC(22,0),
                      @p_CODOPERACIONPDV             NUMERIC(22,0),
                      @p_DESIGUALDAD                 CHAR,
                      @p_VALOR                       FLOAT,
                      @p_CODUSUARIOMODIFICACION      NUMERIC(22,0),
                      @p_ID_DETALLECATEGORIACUPO_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DETALLECATEGORIACUPO (
                                        CODCATEGORIACUPO,
                                        CODOPERACIONPDV,
                                        DESIGUALDAD,
                                        VALOR,
                                        CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODCATEGORIACUPO,
            @p_CODOPERACIONPDV,
            @p_DESIGUALDAD,
            @p_VALOR,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DETALLECATEGORIACUPO_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECATEGORIACUPO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_UpdateRecord(@pk_ID_DETALLECATEGORIACUPO NUMERIC(22,0),
                         @p_CODCATEGORIACUPO         NUMERIC(22,0),
                         @p_CODOPERACIONPDV          NUMERIC(22,0),
                         @p_DESIGUALDAD              CHAR,
                         @p_VALOR                    FLOAT,
                         @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                         @p_ACTIVE                   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.DETALLECATEGORIACUPO
       SET CODCATEGORIACUPO          = @p_CODCATEGORIACUPO,
           CODOPERACIONPDV           = @p_CODOPERACIONPDV,
           DESIGUALDAD               = @p_DESIGUALDAD,
           VALOR                     = @p_VALOR,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION     = GETDATE(),
           ACTIVE                    = @p_ACTIVE
     WHERE ID_DETALLECATEGORIACUPO   = @pk_ID_DETALLECATEGORIACUPO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECATEGORIACUPO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_GetRecord(@pk_ID_DETALLECATEGORIACUPO NUMERIC(22,0)
                      ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.DETALLECATEGORIACUPO
     WHERE ID_DETALLECATEGORIACUPO = @pk_ID_DETALLECATEGORIACUPO;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
     
      SELECT D.ID_DETALLECATEGORIACUPO,
             D.CODCATEGORIACUPO,
             D.CODOPERACIONPDV,
             O.NOMOPERACIONPDV,
             D.DESIGUALDAD,
             D.VALOR,
             D.FECHAHORAMODIFICACION,
             D.CODUSUARIOMODIFICACION,
             D.ACTIVE
      FROM WSXML_SFG.DETALLECATEGORIACUPO D
      LEFT OUTER JOIN WSXML_SFG.OPERACIONPDV O
        ON (O.ID_OPERACIONPDV = D.CODOPERACIONPDV)
      WHERE D.ID_DETALLECATEGORIACUPO = @pk_ID_DETALLECATEGORIACUPO;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECATEGORIACUPO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_GetList(@p_active NUMERIC(22,0)
                                         ) AS
  BEGIN
  SET NOCOUNT ON;
   
      SELECT D.ID_DETALLECATEGORIACUPO,
             D.CODCATEGORIACUPO,
             D.CODOPERACIONPDV,
             O.NOMOPERACIONPDV,
             D.DESIGUALDAD,
             D.VALOR,
             D.FECHAHORAMODIFICACION,
             D.CODUSUARIOMODIFICACION,
             D.ACTIVE
      FROM WSXML_SFG.DETALLECATEGORIACUPO D
      LEFT OUTER JOIN WSXML_SFG.OPERACIONPDV O
        ON (O.ID_OPERACIONPDV = D.CODOPERACIONPDV)
       WHERE D.ACTIVE = CASE WHEN @p_active = -1 THEN D.ACTIVE ELSE @p_active END;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLECATEGORIACUPO_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_GetListByHeader;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLECATEGORIACUPO_GetListByHeader(@p_active NUMERIC(22,0),
                           @p_CODCATEGORIACUPO NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    
      SELECT D.ID_DETALLECATEGORIACUPO,
             D.CODCATEGORIACUPO,
             D.CODOPERACIONPDV,
             O.NOMOPERACIONPDV,
             D.DESIGUALDAD,
             D.VALOR,
             D.FECHAHORAMODIFICACION,
             D.CODUSUARIOMODIFICACION,
             D.ACTIVE
      FROM WSXML_SFG.DETALLECATEGORIACUPO D
      LEFT OUTER JOIN WSXML_SFG.OPERACIONPDV O
        ON (O.ID_OPERACIONPDV = D.CODOPERACIONPDV)
       WHERE D.CODCATEGORIACUPO = @p_CODCATEGORIACUPO
         AND D.ACTIVE = CASE WHEN @p_active = -1 THEN D.ACTIVE ELSE @p_active END;
       
  END;
GO






