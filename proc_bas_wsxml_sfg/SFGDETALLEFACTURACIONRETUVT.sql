USE SFGPRODU;
--  DDL for Package Body SFGDETALLEFACTURACIONRETUVT
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLEFACTURACIONRETUVT */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_AddRecord(@p_CODMAESTROFACTURACIONPDV NUMERIC(22,0),
                      @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
                      @p_CODRETENCIONUVT          NUMERIC(22,0),
                      @p_VALORRETENCION           FLOAT,
                      @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                      @p_ID_DETALLEFACTRETUVT_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DETALLEFACTURACIONRETUVT (
                                          CODMAESTROFACTURACIONPDV,
                                          CODDETALLEFACTURACIONPDV,
                                          CODRETENCIONUVT,
                                          VALORRETENCION,
                                          CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODMAESTROFACTURACIONPDV,
            @p_CODDETALLEFACTURACIONPDV,
            @p_CODRETENCIONUVT,
            @p_VALORRETENCION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DETALLEFACTRETUVT_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_CrearRetencionUVT', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_CrearRetencionUVT;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_CrearRetencionUVT(@p_CODMAESTROFACTURACIONPDV NUMERIC(22,0),
                              @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
                              @p_CODRETENCIONUVT          NUMERIC(22,0),
                              @p_VALORRETENCION           FLOAT,
                              @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                              @p_ID_DETALLEFACTRETUVT_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    -- Identificador de retencion ya existente
    SELECT @p_ID_DETALLEFACTRETUVT_out = ID_DETALLEFACTURACIONRETUVT FROM WSXML_SFG.DETALLEFACTURACIONRETUVT
    WHERE CODMAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV
      AND CODDETALLEFACTURACIONPDV = @p_CODDETALLEFACTURACIONPDV
      AND CODRETENCIONUVT = @p_CODRETENCIONUVT
      AND ACTIVE = 1;

	--  EXCEPTION WHEN NO_DATA_FOUND THEN
    -- Nueva retencion
	IF(@@rowcount = 0)
	BEGIN
	    EXEC WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_AddRecord
		                                  @p_CODMAESTROFACTURACIONPDV,
                                          @p_CODDETALLEFACTURACIONPDV,
                                          @p_CODRETENCIONUVT,
                                          @p_VALORRETENCION,
                                          @p_CODUSUARIOMODIFICACION,
                                          @p_ID_DETALLEFACTRETUVT_out OUT;
    END	ELSE BEGIN
		-- Sumar a retencion
		UPDATE WSXML_SFG.DETALLEFACTURACIONRETUVT SET VALORRETENCION = VALORRETENCION + @p_VALORRETENCION
		WHERE ID_DETALLEFACTURACIONRETUVT = @p_ID_DETALLEFACTRETUVT_out;
	END 

  END;
GO

  /*PROCEDURE AnularRetencionUVT(p_CODMAESTROFACTURACIONPDV NUMBER,
                               p_CODDETALLEFACTURACIONPDV NUMBER,
                               p_CODRETENCIONUVT          NUMBER,
                               p_VALORRETENCION           FLOAT,
                               p_CODUSUARIOMODIFICACION   NUMBER,
                               p_ID_DETALLEFACTRETUVT_out OUT NUMBER) IS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(1) INTO l_count FROM DETALLEFACTURACIONRETUVT
    WHERE CODMAESTROFACTURACIONPDV = p_CODMAESTROFACTURACIONPDV
         AND CODDETALLEFACTURACIONPDV = p_CODDETALLEFACTURACIONPDV
         AND CODRETENCIONUVT = p_CODRETENCIONUVT
         AND ACTIVE = 1;
    IF l_count > 0 THEN
      SELECT ID_DETALLEFACTURACIONRETUVT INTO p_ID_DETALLEFACTRETUVT_out
        FROM DETALLEFACTURACIONRETUVT
       WHERE CODMAESTROFACTURACIONPDV = p_CODMAESTROFACTURACIONPDV
         AND CODDETALLEFACTURACIONPDV = p_CODDETALLEFACTURACIONPDV
         AND CODRETENCIONUVT = p_CODRETENCIONUVT
         AND ACTIVE = 1;
       IF p_ID_DETALLEFACTRETUVT_out > 0 THEN
         UPDATE DETALLEFACTURACIONRETUVT
            SET VALORRETENCION = VALORRETENCION - p_VALORRETENCION
          WHERE ID_DETALLEFACTURACIONRETUVT = p_ID_DETALLEFACTRETUVT_out;
       END IF;
    ELSIF l_count = 0 THEN
      SFGTMPTRACE.TraceLog('Cancelling RETUVT with no record');
      AddRecord(p_CODMAESTROFACTURACIONPDV,
                p_CODDETALLEFACTURACIONPDV,
                (0 - p_CODRETENCIONUVT),
                p_VALORRETENCION,
                p_CODUSUARIOMODIFICACION,
                p_ID_DETALLEFACTRETUVT_out);
    END IF;
  END;
GO*/

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_UpdateRecord(@pk_ID_DETALLEFACTRETUVT    NUMERIC(22,0),
                         @p_CODMAESTROFACTURACIONPDV NUMERIC(22,0),
                         @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
                         @p_CODRETENCIONUVT          NUMERIC(22,0),
                         @p_VALORRETENCION           FLOAT,
                         @p_CODUSUARIOMODIFICACION   NUMERIC(22,0),
                         @p_ACTIVE                   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONRETUVT
       SET CODMAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV,
           CODDETALLEFACTURACIONPDV = @p_CODDETALLEFACTURACIONPDV,
           CODRETENCIONUVT          = @p_CODRETENCIONUVT,
           VALORRETENCION           = @p_VALORRETENCION,
           CODUSUARIOMODIFICACION   = @p_CODUSUARIOMODIFICACION,
           ACTIVE                   = @p_ACTIVE
     WHERE ID_DETALLEFACTURACIONRETUVT = @pk_ID_DETALLEFACTRETUVT;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_GetRecord(@pk_ID_DETALLEFACTRETUVT NUMERIC(22,0)
                                                                         ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.DETALLEFACTURACIONRETUVT
     WHERE ID_DETALLEFACTURACIONRETUVT = @pk_ID_DETALLEFACTRETUVT;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_DETALLEFACTURACIONRETUVT,
             CODMAESTROFACTURACIONPDV,
             CODDETALLEFACTURACIONPDV,
             CODRETENCIONUVT,
             VALORRETENCION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLEFACTURACIONRETUVT
       WHERE ID_DETALLEFACTURACIONRETUVT = @pk_ID_DETALLEFACTRETUVT;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONRETUVT_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_DETALLEFACTURACIONRETUVT,
             CODMAESTROFACTURACIONPDV,
             CODDETALLEFACTURACIONPDV,
             CODRETENCIONUVT,
             VALORRETENCION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLEFACTURACIONRETUVT
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO






