USE SFGPRODU;
--  DDL for Package Body SFGEMPRESAGESTION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGEMPRESAGESTION */ 
IF OBJECT_ID('WSXML_SFG.SFGEMPRESAGESTION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_AddRecord(@p_NIT                     NUMERIC(22,0),
                      @p_DESCRIPCION             VARCHAR,
                      @p_TELEFONO                NUMERIC(22,0),
                      @p_DIRECCION               VARCHAR,
                      @p_REPRESENTANTE           VARCHAR,
                      @p_CODEDADMORA             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ACTIVE                  NUMERIC(22,0),
                      @p_ID_EMPRESAGESTION_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
    INSERT INTO WSXML_SFG.EMPRESAGESTION
        (
          NIT,
          DESCRIPCION,
          TELEFONO,
          DIRECCION,
          REPRESENTANTE,
          CODEDADMORA,
          CODUSUARIOMODIFICACION,
          ACTIVE)
      VALUES
        (
          @p_NIT,
          @p_DESCRIPCION,
          @p_TELEFONO,
          @p_DIRECCION,
          @p_REPRESENTANTE,
          @p_CODEDADMORA,
          @p_CODUSUARIOMODIFICACION,
          @p_ACTIVE);
      SET @p_ID_EMPRESAGESTION_out = SCOPE_IDENTITY();
--    NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGEMPRESAGESTION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_UpdateRecord(@pk_ID_EMPRESAGESTION    NUMERIC(22,0),
                      @p_NIT                     NUMERIC(22,0),
                      @p_DESCRIPCION             VARCHAR,
                      @p_TELEFONO                NUMERIC(22,0),
                      @p_DIRECCION               VARCHAR,
                      @p_REPRESENTANTE           VARCHAR,
                      @p_CODEDADMORA             NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ACTIVE                  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
    UPDATE WSXML_SFG.EMPRESAGESTION
       SET NIT                    = @p_NIT,
           DESCRIPCION            = @p_DESCRIPCION,
           TELEFONO               = @p_TELEFONO,
           DIRECCION              = @p_DIRECCION,
           REPRESENTANTE          = @p_REPRESENTANTE,
           CODEDADMORA            = @p_CODEDADMORA,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_EMPRESAGESTION      = @pk_ID_EMPRESAGESTION;
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

IF OBJECT_ID('WSXML_SFG.SFGEMPRESAGESTION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_GetRecord(@pk_ID_EMPRESAGESTION NUMERIC(22,0)
                                                       )  AS
  BEGIN
  DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    /* TODO implementation required */
    SELECT @l_count = count(*)
      FROM WSXML_SFG.EMPRESAGESTION
     WHERE ID_EMPRESAGESTION = @pk_ID_EMPRESAGESTION;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT A.ID_EMPRESAGESTION,
            A.NIT,
            A.DESCRIPCION,
            A.TELEFONO,
            A.DIRECCION,
            A.REPRESENTANTE,
            A.CODEDADMORA,
            A.ACTIVE
      FROM WSXML_SFG.EMPRESAGESTION A
      WHERE A.ID_EMPRESAGESTION = @pk_ID_EMPRESAGESTION;
	  
   -- NULL;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGEMPRESAGESTION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_GetList;
GO
CREATE PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_GetList(@p_ACTIVE NUMERIC(22,0)
                                                     ) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
      SELECT  A.ID_EMPRESAGESTION,
              A.NIT,
              A.DESCRIPCION,
              A.TELEFONO,
              A.DIRECCION,
              A.REPRESENTANTE,
              A.CODEDADMORA,
              A.ACTIVE
      FROM WSXML_SFG.EMPRESAGESTION A
            WHERE A.ACTIVE = CASE WHEN @p_ACTIVE = -1 THEN A.ACTIVE ELSE @p_ACTIVE END;
   -- NULL;
  END;
GO



IF OBJECT_ID('WSXML_SFG.SFGEMPRESAGESTION_GetEmpresaMora', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_GetEmpresaMora;
GO
  CREATE PROCEDURE WSXML_SFG.SFGEMPRESAGESTION_GetEmpresaMora(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    select eg.id_empresagestion,eg.nit,eg.descripcion,
    e.rango_desde,e.rango_hasta,e.valor_desde,e.valor_hasta
    from WSXML_SFG.empresagestion eg inner  join edadmora e
    on eg.codedadmora = e.id_edadmora;
   -- NULL;
  END;
GO






