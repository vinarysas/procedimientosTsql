USE SFGPRODU;
--  DDL for Package Body SFGTIPOTRANSACCION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGTIPOTRANSACCION */ 

IF OBJECT_ID('WSXML_SFG.SFGTIPOTRANSACCION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_AddRecord(@p_DESCRIPCION             NVARCHAR(2000),
                      @p_CODUSUARIO              NUMERIC(22,0),
                      @p_ID_TIPOTRANSACCION_out  NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.TIPOTRANSACCION
               (
                DESCRIPCION,
                CODUSUARIOMODIFICACION)
      VALUES
        (
         @p_DESCRIPCION,
         @p_CODUSUARIO);
      SET @p_ID_TIPOTRANSACCION_out = SCOPE_IDENTITY();
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGTIPOTRANSACCION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_UpdateRecord(@pk_ID_TIPOTRANSACCION   NUMERIC(22,0),
                         @p_DESCRIPCION           NVARCHAR(2000),
                         @p_CODUSUARIO            NUMERIC(22,0),
                         @p_ACTIVE                NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      UPDATE WSXML_SFG.TIPOTRANSACCION
      SET DESCRIPCION            = @p_DESCRIPCION,
          CODUSUARIOMODIFICACION = @p_CODUSUARIO,
          ACTIVE                 = @p_ACTIVE
      WHERE ID_TIPOTRANSACCION   = @pk_ID_TIPOTRANSACCION;
      IF @@rowcount = 0 BEGIN
        RAISERROR('-20054 The record no longer exists.', 16, 1);
      END 
      IF @@rowcount > 1 BEGIN
        RAISERROR('-20053 Duplicate object instances.', 16, 1);
      END 
  --  NULL;
  END;
GO


IF OBJECT_ID('WSXML_SFG.SFGTIPOTRANSACCION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_GetRecord(@pk_ID_TIPOTRANSACCION NUMERIC(22,0)
                                                        ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*)
    FROM WSXML_SFG.TIPOTRANSACCION
    WHERE ID_TIPOTRANSACCION = @pk_ID_TIPOTRANSACCION;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be returned along the row data to support concurrency.
      
	  SELECT A.ID_TIPOTRANSACCION,
             A.DESCRIPCION,
             A.CODUSUARIOMODIFICACION,
             A.FECHAHORAMODIFICACION,
             A.ACTIVE
      FROM WSXML_SFG.TIPOTRANSACCION A
      WHERE A.ID_TIPOTRANSACCION = @pk_ID_TIPOTRANSACCION;
	  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGTIPOTRANSACCION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_GetList;
GO

  CREATE PROCEDURE WSXML_SFG.SFGTIPOTRANSACCION_GetList(@p_ACTIVE NUMERIC(22,0)
                                                        ) AS
  BEGIN
  SET NOCOUNT ON;
  
      SELECT A.ID_TIPOTRANSACCION,
             A.DESCRIPCION,
             A.CODUSUARIOMODIFICACION,
             A.FECHAHORAMODIFICACION,
             A.ACTIVE
      FROM WSXML_SFG.TIPOTRANSACCION A
      WHERE A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END;
	  
  END;
GO






