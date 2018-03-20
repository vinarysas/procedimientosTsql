USE SFGPRODU;
--  DDL for Package Body SFGINFOPARAMETRO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINFOPARAMETRO */ 

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_AddRecord(@p_CODINFOEJECUCION       NUMERIC(22,0),
                      @p_NOMPARAMETRO           NVARCHAR(2000),
                      @p_TIPOPARAMETRO          NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                      @p_ID_INFOPARAMETRO_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.INFOPARAMETRO (
                               CODINFOEJECUCION,
                               NOMPARAMETRO,
                               TIPOPARAMETRO,
                               CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODINFOEJECUCION,
            @p_NOMPARAMETRO,
            @p_TIPOPARAMETRO,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_INFOPARAMETRO_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_UpdateRecord(@pk_ID_INFOPARAMETRO      NUMERIC(22,0),
                         @p_CODINFOEJECUCION       NUMERIC(22,0),
                         @p_NOMPARAMETRO           NVARCHAR(2000),
                         @p_TIPOPARAMETRO          NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                         @p_ACTIVE                 NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.INFOPARAMETRO
       SET CODINFOEJECUCION       = @p_CODINFOEJECUCION,
           NOMPARAMETRO           = @p_NOMPARAMETRO,
           TIPOPARAMETRO          = @p_TIPOPARAMETRO,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = @p_ACTIVE
     WHERE ID_INFOPARAMETRO = @pk_ID_INFOPARAMETRO;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_DeactivateRecord(@pk_ID_INFOPARAMETRO NUMERIC(22,0), 
                                                                     @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.INFOPARAMETRO
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_INFOPARAMETRO = @pk_ID_INFOPARAMETRO;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_GetRecord(@pk_ID_INFOPARAMETRO NUMERIC(22,0)
                                                              ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.INFOPARAMETRO WHERE ID_INFOPARAMETRO = @pk_ID_INFOPARAMETRO;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_INFOPARAMETRO,
             CODINFOEJECUCION,
             NOMPARAMETRO,
             TIPOPARAMETRO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.INFOPARAMETRO
      WHERE ID_INFOPARAMETRO = @pk_ID_INFOPARAMETRO;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_GetList(@p_ACTIVE NUMERIC(22,0)
                                                            ) AS
  BEGIN

  SET NOCOUNT ON;
   
      SELECT ID_INFOPARAMETRO,
             CODINFOEJECUCION,
             NOMPARAMETRO,
             TIPOPARAMETRO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.INFOPARAMETRO
      WHERE ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
	  
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_GetListByHeader;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_GetListByHeader(@p_ACTIVE NUMERIC(22,0), 
                                                                   @p_CODINFOEJECUCION NUMERIC(22,0)
																	) AS
  BEGIN
  SET NOCOUNT ON;
  
      SELECT ID_INFOPARAMETRO,
             CODINFOEJECUCION,
             NOMPARAMETRO,
             TIPOPARAMETRO,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
      FROM WSXML_SFG.INFOPARAMETRO
      WHERE CODINFOEJECUCION = @p_CODINFOEJECUCION
        AND ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN ACTIVE ELSE @p_ACTIVE END;
		
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGINFOPARAMETRO_SetConjuntoEjecucion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_SetConjuntoEjecucion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINFOPARAMETRO_SetConjuntoEjecucion(@p_CODINFOEJECUCION NUMERIC(22,0), 
                                                                         @p_CODINFOEJECUCIONWARNING NUMERIC(22,0), 
																		 @p_CODINFOEJECUCIONERROR NUMERIC(22,0), 
																		 @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
 BEGIN
    DECLARE @cCODINFOEJECUCIONCONJUNTO NUMERIC(22,0);
   
	SET NOCOUNT ON;
    BEGIN
		SELECT @cCODINFOEJECUCIONCONJUNTO = ID_INFOEJECUCIONCONJUNTO FROM WSXML_SFG.INFOEJECUCIONCONJUNTO
		WHERE CODINFOEJECUCION = @p_CODINFOEJECUCION;
	  
		IF(@@rowcount = 0)
		BEGIN
		   INSERT INTO WSXML_SFG.INFOEJECUCIONCONJUNTO (
											 CODINFOEJECUCION,
											 CODINFOEJECUCIONWARNING,
											 CODINFOEJECUCIONERROR,
											 CODUSUARIOMODIFICACION)
		  VALUES (
				  @p_CODINFOEJECUCION,
				  @p_CODINFOEJECUCIONWARNING,
				  @p_CODINFOEJECUCIONERROR,
				  @p_CODUSUARIOMODIFICACION);
		END ELSE BEGIN
			UPDATE WSXML_SFG.INFOEJECUCIONCONJUNTO SET CODINFOEJECUCIONWARNING = @p_CODINFOEJECUCIONWARNING,
                                       CODINFOEJECUCIONERROR   = @p_CODINFOEJECUCIONERROR,
                                       CODUSUARIOMODIFICACION  = @p_CODUSUARIOMODIFICACION
			WHERE ID_INFOEJECUCIONCONJUNTO = @cCODINFOEJECUCIONCONJUNTO;
		END
    END;

  END;
GO






