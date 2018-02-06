USE SFGPRODU;
--  DDL for Package Body SFGPLANTILLAPRODUCTODETALLE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE */ 

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_AddRecord(@p_CODPLANTILLAPRODUCTO            NUMERIC(22,0),
                      @p_CODPRODUCTO                     NUMERIC(22,0),
                      @p_CODRANGOCOMISION                NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION          NUMERIC(22,0),
                      @p_ID_PLANTILLAPRODETALLE_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PLANTILLAPRODUCTODETALLE (
                                          CODPLANTILLAPRODUCTO,
                                          CODPRODUCTO,
                                          CODRANGOCOMISION,
                                          CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODPLANTILLAPRODUCTO,
            @p_CODPRODUCTO,
            @p_CODRANGOCOMISION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PLANTILLAPRODETALLE_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_UpdateRecord(@pk_ID_PLANTILLAPRODETALLE NUMERIC(22,0),
                         @p_CODPLANTILLAPRODUCTO    NUMERIC(22,0),
                         @p_CODPRODUCTO             NUMERIC(22,0),
                         @p_CODRANGOCOMISION        NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                         @p_ACTIVE                  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PLANTILLAPRODUCTODETALLE
       SET CODPLANTILLAPRODUCTO   = @p_CODPLANTILLAPRODUCTO,
           CODPRODUCTO            = @p_CODPRODUCTO,
           CODRANGOCOMISION       = @p_CODRANGOCOMISION,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           ACTIVE                 = @p_ACTIVE
     WHERE ID_PLANTILLAPRODUCTODETALLE = @pk_ID_PLANTILLAPRODETALLE;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetRecord(@pk_ID_PLANTILLAPRODUCTODETALLE NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE WHERE ID_PLANTILLAPRODUCTODETALLE = @pk_ID_PLANTILLAPRODUCTODETALLE;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT ID_PLANTILLAPRODUCTODETALLE,
             CODPLANTILLAPRODUCTO,
             CODPRODUCTO,
             CODRANGOCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE
       WHERE ID_PLANTILLAPRODUCTODETALLE = @pk_ID_PLANTILLAPRODUCTODETALLE;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetRecordWithData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetRecordWithData;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetRecordWithData(@pk_ID_PLANTILLAPRODUCTODETALLE NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE WHERE ID_PLANTILLAPRODUCTODETALLE = @pk_ID_PLANTILLAPRODUCTODETALLE;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT PLANTILLAPRODUCTODETALLE.ID_PLANTILLAPRODUCTODETALLE,
             PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO,
             PLANTILLAPRODUCTO.NOMPLANTILLAPRODUCTO,
             PLANTILLAPRODUCTODETALLE.CODPRODUCTO,
             PRODUCTO.NOMPRODUCTO,
             PLANTILLAPRODUCTODETALLE.CODRANGOCOMISION,
             RANGOCOMISION.NOMRANGOCOMISION,
             PLANTILLAPRODUCTODETALLE.FECHAHORAMODIFICACION,
             PLANTILLAPRODUCTODETALLE.CODUSUARIOMODIFICACION,
             USUARIO.NOMUSUARIO,
             PLANTILLAPRODUCTODETALLE.ACTIVE
        FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE
        LEFT OUTER JOIN WSXML_SFG.PLANTILLAPRODUCTO
          ON (PLANTILLAPRODUCTO.ID_PLANTILLAPRODUCTO = PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.PRODUCTO
          ON (PRODUCTO.ID_PRODUCTO = PLANTILLAPRODUCTODETALLE.CODPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION
          ON (RANGOCOMISION.ID_RANGOCOMISION = PLANTILLAPRODUCTODETALLE.CODRANGOCOMISION)
        LEFT OUTER JOIN WSXML_SFG.USUARIO
          ON (USUARIO.ID_USUARIO = PLANTILLAPRODUCTODETALLE.CODUSUARIOMODIFICACION)
       WHERE PLANTILLAPRODUCTODETALLE.ID_PLANTILLAPRODUCTODETALLE = @pk_ID_PLANTILLAPRODUCTODETALLE;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_PLANTILLAPRODUCTODETALLE,
             CODPLANTILLAPRODUCTO,
             CODPRODUCTO,
             CODRANGOCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListByHeader', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListByHeader;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListByHeader(@p_active               NUMERIC(22,0),
                           @p_CODPLANTILLAPRODUCTO NUMERIC(22,0)
                            ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT ID_PLANTILLAPRODUCTODETALLE,
             CODPLANTILLAPRODUCTO,
             CODPRODUCTO,
             CODRANGOCOMISION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE
       WHERE CODPLANTILLAPRODUCTO = @p_CODPLANTILLAPRODUCTO
         AND ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListWithData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListWithData;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListWithData(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PLANTILLAPRODUCTODETALLE.ID_PLANTILLAPRODUCTODETALLE,
             PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO,
             PLANTILLAPRODUCTO.NOMPLANTILLAPRODUCTO,
             PLANTILLAPRODUCTODETALLE.CODPRODUCTO,
             PRODUCTO.NOMPRODUCTO,
             PLANTILLAPRODUCTODETALLE.CODRANGOCOMISION,
             RANGOCOMISION.NOMRANGOCOMISION,
             PLANTILLAPRODUCTODETALLE.FECHAHORAMODIFICACION,
             PLANTILLAPRODUCTODETALLE.CODUSUARIOMODIFICACION,
             USUARIO.NOMUSUARIO,
             PLANTILLAPRODUCTODETALLE.ACTIVE
        FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE
        LEFT OUTER JOIN WSXML_SFG.PLANTILLAPRODUCTO
          ON (PLANTILLAPRODUCTO.ID_PLANTILLAPRODUCTO = PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.PRODUCTO
          ON (PRODUCTO.ID_PRODUCTO = PLANTILLAPRODUCTODETALLE.CODPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION
          ON (RANGOCOMISION.ID_RANGOCOMISION = PLANTILLAPRODUCTODETALLE.CODRANGOCOMISION)
        LEFT OUTER JOIN WSXML_SFG.USUARIO
          ON (USUARIO.ID_USUARIO = PLANTILLAPRODUCTODETALLE.CODUSUARIOMODIFICACION)
       WHERE PLANTILLAPRODUCTODETALLE.ACTIVE = CASE WHEN @p_active = -1 THEN PLANTILLAPRODUCTODETALLE.ACTIVE ELSE @p_active END;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListByHeaderWithData', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListByHeaderWithData;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPLANTILLAPRODUCTODETALLE_GetListByHeaderWithData(@p_active NUMERIC(22,0),
                                   @p_CODPLANTILLAPRODUCTO NUMERIC(22,0)
                                    ) AS
  BEGIN
  SET NOCOUNT ON;
      SELECT PLANTILLAPRODUCTODETALLE.ID_PLANTILLAPRODUCTODETALLE,
             PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO,
             PLANTILLAPRODUCTO.NOMPLANTILLAPRODUCTO,
             PLANTILLAPRODUCTODETALLE.CODPRODUCTO,
             PRODUCTO.NOMPRODUCTO,
             PRODUCTO.CODALIADOESTRATEGICO,
             ALIADOESTRATEGICO.NOMALIADOESTRATEGICO,
             PRODUCTO.CODTIPOPRODUCTO,
             TIPOPRODUCTO.NOMTIPOPRODUCTO,
             TIPOPRODUCTO.CODLINEADENEGOCIO,
             LINEADENEGOCIO.NOMLINEADENEGOCIO,
             PLANTILLAPRODUCTODETALLE.CODRANGOCOMISION,
             RANGOCOMISION.NOMRANGOCOMISION,
             PLANTILLAPRODUCTODETALLE.FECHAHORAMODIFICACION,
             PLANTILLAPRODUCTODETALLE.CODUSUARIOMODIFICACION,
             USUARIO.NOMUSUARIO,
             PLANTILLAPRODUCTODETALLE.ACTIVE
        FROM WSXML_SFG.PLANTILLAPRODUCTODETALLE
        LEFT OUTER JOIN WSXML_SFG.PLANTILLAPRODUCTO
          ON (PLANTILLAPRODUCTO.ID_PLANTILLAPRODUCTO = PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.PRODUCTO
          ON (PRODUCTO.ID_PRODUCTO = PLANTILLAPRODUCTODETALLE.CODPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.ALIADOESTRATEGICO
          ON (ALIADOESTRATEGICO.ID_ALIADOESTRATEGICO = PRODUCTO.CODALIADOESTRATEGICO)
        LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO
          ON (TIPOPRODUCTO.ID_TIPOPRODUCTO = PRODUCTO.CODTIPOPRODUCTO)
        LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO
          ON (LINEADENEGOCIO.ID_LINEADENEGOCIO = TIPOPRODUCTO.CODLINEADENEGOCIO)
        LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION
          ON (RANGOCOMISION.ID_RANGOCOMISION = PLANTILLAPRODUCTODETALLE.CODRANGOCOMISION)
        LEFT OUTER JOIN WSXML_SFG.USUARIO
          ON (USUARIO.ID_USUARIO = PLANTILLAPRODUCTODETALLE.CODUSUARIOMODIFICACION)
       WHERE PLANTILLAPRODUCTODETALLE.CODPLANTILLAPRODUCTO = @p_CODPLANTILLAPRODUCTO
         AND PLANTILLAPRODUCTODETALLE.ACTIVE = CASE WHEN @p_active = -1 THEN PLANTILLAPRODUCTODETALLE.ACTIVE ELSE @p_active END;
  END;
GO





