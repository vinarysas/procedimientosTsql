USE SFGPRODU;
--  DDL for Package Body SFGDETALLEFACTURACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDETALLEFACTURACIONPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_AddRecord(@p_CODMAESTROFACTURACIONPDV     NUMERIC(22,0),
                      @p_CODPRODUCTO                  NUMERIC(22,0),
                      @p_CANTIDADVENTA                NUMERIC(22,0),
                      @p_VALORVENTA                   FLOAT,
                      @p_CANTIDADANULACION            NUMERIC(22,0),
                      @p_VALORANULACION               FLOAT,
                      @p_CANTIDADPREMIOPAGO           NUMERIC(22,0),
                      @p_VALORPREMIOPAGO              FLOAT,
                      @p_CANTIDADGRATUITO             NUMERIC(22,0),
                      @p_VALORGRATUITO                FLOAT,
                      @p_VALORCOMISION                FLOAT,
                      @p_VALORCOMISIONNETA            FLOAT,
                      @p_VALORVENTANETA               FLOAT,
                      @p_RETENCIONPREMIOSPAGADOS      FLOAT,
                      @p_AJUSTE                       FLOAT,
                      @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                      @p_ID_DETALLEFACTURACIONPDV_out NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.DETALLEFACTURACIONPDV (
                                       CODMAESTROFACTURACIONPDV,
                                       CODPRODUCTO,
                                       CANTIDADVENTA,
                                       VALORVENTA,
                                       CANTIDADANULACION,
                                       VALORANULACION,
                                       CANTIDADPREMIOPAGO,
                                       VALORPREMIOPAGO,
                                       CANTIDADGRATUITO,
                                       VALORGRATUITO,
                                       VALORCOMISION,
                                       VALORCOMISIONNETA,
                                       VALORVENTANETA,
                                       RETENCIONPREMIOSPAGADOS,
                                       AJUSTE,
                                       CODUSUARIOMODIFICACION)
    VALUES (
            @p_CODMAESTROFACTURACIONPDV,
            @p_CODPRODUCTO,
            @p_CANTIDADVENTA,
            @p_VALORVENTA,
            @p_CANTIDADANULACION,
            @p_VALORANULACION,
            @p_CANTIDADPREMIOPAGO,
            @p_VALORPREMIOPAGO,
            @p_CANTIDADGRATUITO,
            @p_VALORGRATUITO,
            @p_VALORCOMISION,
            @p_VALORCOMISIONNETA,
            @p_VALORVENTANETA,
            @p_RETENCIONPREMIOSPAGADOS,
            @p_AJUSTE,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_DETALLEFACTURACIONPDV_out = SCOPE_IDENTITY();
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_UpdateRecord;
GO

CREATE  PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_UpdateRecord
                                                  (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                         @p_CODMAESTROFACTURACIONPDV  NUMERIC(22,0),
                         @p_CODPRODUCTO               NUMERIC(22,0),
                         @p_CANTIDADVENTA             NUMERIC(22,0),
                         @p_VALORVENTA                FLOAT,
                         @p_CANTIDADANULACION         NUMERIC(22,0),
                         @p_VALORANULACION            FLOAT,
                         @p_CANTIDADPREMIOPAGO        NUMERIC(22,0),
                         @p_VALORPREMIOPAGO           FLOAT,
                         @p_CANTIDADGRATUITO          NUMERIC(22,0),
                         @p_VALORGRATUITO             FLOAT,
                         @p_VALORCOMISION             FLOAT,
                         @p_VALORCOMISIONNETA         FLOAT,
                         @p_VALORVENTANETA            FLOAT,
                         @p_RETENCIONPREMIOSPAGADOS   FLOAT,
                         @p_AJUSTE                    FLOAT,
                         @p_VALORDESCUENTOS           FLOAT,
                         @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                         @p_ACTIVE                    NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CODMAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV,
           CODPRODUCTO              = @p_CODPRODUCTO,
           CANTIDADVENTA            = @p_CANTIDADVENTA,
           VALORVENTA               = @p_VALORVENTA,
           CANTIDADANULACION        = @p_CANTIDADANULACION,
           VALORANULACION           = @p_VALORANULACION,
           CANTIDADPREMIOPAGO       = @p_CANTIDADPREMIOPAGO,
           VALORPREMIOPAGO          = @p_VALORPREMIOPAGO,
           CANTIDADGRATUITO         = @p_CANTIDADGRATUITO,
           VALORGRATUITO            = @p_VALORGRATUITO,
           VALORCOMISION            = @p_VALORCOMISION,
           VALORCOMISIONNETA        = @p_VALORCOMISIONNETA,
           VALORVENTANETA           = @p_VALORVENTANETA,
           RETENCIONPREMIOSPAGADOS  = @p_RETENCIONPREMIOSPAGADOS,
           AJUSTE                   = @p_AJUSTE,
           VALORDESCUENTOS          = @p_VALORDESCUENTOS,
           CODUSUARIOMODIFICACION   = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION    = GETDATE(),
           ACTIVE                   = @p_ACTIVE
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_LimpiarDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_LimpiarDetalle;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_LimpiarDetalle
                                             (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Limpiar detalle
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADVENTA                = 0,
           VALORVENTA                   = 0,
           CANTIDADANULACION            = 0,
           VALORANULACION               = 0,
           CANTIDADGRATUITO             = 0,
           VALORGRATUITO                = 0,
           CANTIDADPREMIOPAGO           = 0,
           VALORPREMIOPAGO              = 0,
           VALORVENTABRUTA              = 0,
           VALORCOMISION                = 0,
           IVACOMISION                  = 0,
           VALORCOMISIONBRUTA           = 0,
           VALORCOMISIONNETA            = 0,
           VALORVENTANETA               = 0,
           RETENCIONPREMIOSPAGADOS      = 0,
           AJUSTE                       = 0,
           NUEVOSALDOENCONTRAGTECH      = 0,
           NUEVOSALDOENCONTRAFIDUCIA    = 0,
           NUEVOSALDOAFAVORGTECH        = 0,
           NUEVOSALDOAFAVORFIDUCIA      = 0
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
    -- Limpiar dependientes
    UPDATE WSXML_SFG.DETALLEFACTURACIONIMPUESTO SET VALORIMPUESTO = 0 
	                                           WHERE CODDETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
    UPDATE WSXML_SFG.DETALLEFACTURACIONRETENCION SET VALORRETENCION = 0 
	                                            WHERE CODDETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
    UPDATE WSXML_SFG.DETALLEFACTURACIONRETUVT SET VALORRETENCION = 0 
	                                            WHERE CODDETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
    UPDATE WSXML_SFG.REGISTROFACTURACION SET FACTURADO = 0, CODDETALLEFACTURACIONPDV = NULL 
	                                            WHERE CODDETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_CrearDetalle', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_CrearDetalle;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_CrearDetalle
                                                             (@p_CODMAESTROFACTURACIONPDV     NUMERIC(22,0),
                         @p_CODPRODUCTO                  NUMERIC(22,0),
                         @p_COMISIONANTICIPO             NUMERIC(22,0),
                         @p_CODRANGOCOMISION             NUMERIC(22,0),
                         @p_CODTIPOCONTRATOPDV           NUMERIC(22,0),
                         @p_CODUSUARIOMODIFICACION       NUMERIC(22,0),
                         @p_ID_DETALLEFACTURACIONPDV_out NUMERIC(22,0) OUT) AS
 BEGIN
    DECLARE @codEXISTINGDETAIL NUMERIC(22,0) = 0;
   
  SET NOCOUNT ON;
      DECLARE @p_CODTIPOPRODUCTO NUMERIC(22,0);
    BEGIN
      SELECT @p_CODTIPOPRODUCTO = CODTIPOPRODUCTO FROM WSXML_SFG.PRODUCTO WHERE ID_PRODUCTO = @p_CODPRODUCTO;
      INSERT INTO WSXML_SFG.DETALLEFACTURACIONPDV (
                                         CODMAESTROFACTURACIONPDV,
                                         CODPRODUCTO,
                                         CODTIPOPRODUCTO,
                                         COMISIONANTICIPO,
                                         CODRANGOCOMISION,
                                         CODTIPOCONTRATOPDV,
                                         CODUSUARIOMODIFICACION)
      VALUES (
              @p_CODMAESTROFACTURACIONPDV,
              @p_CODPRODUCTO,
              @p_CODTIPOPRODUCTO,
              @p_COMISIONANTICIPO,
              @p_CODRANGOCOMISION,
              @p_CODTIPOCONTRATOPDV,
              @p_CODUSUARIOMODIFICACION);
      SET @codEXISTINGDETAIL = SCOPE_IDENTITY();
    END;

    SET @p_ID_DETALLEFACTURACIONPDV_out = @codEXISTINGDETAIL;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarInformacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarInformacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarInformacion
                                                             (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                                  @p_CANTIDADVENTA             NUMERIC(22,0),
                                  @p_VALORVENTA                FLOAT,
                                  @p_CANTIDADANULACION         NUMERIC(22,0),
                                  @p_VALORANULACION            FLOAT,
                                  @p_CANTIDADGRATUITO          NUMERIC(22,0),
                                  @p_VALORGRATUITO             FLOAT,
                                  @p_CANTIDADPREMIOPAGO        NUMERIC(22,0),
                                  @p_VALORPREMIOPAGO           FLOAT,
                                  @p_RETENCIONPREMIOSPAGADOS   FLOAT,
                                  @p_VALORVENTABRUTA           FLOAT,
                                  @p_VALORVENTANETA            FLOAT,
                                  @p_VALORCOMISION             FLOAT,
                                  @p_IVACOMISION               FLOAT,
                                  @p_VALORCOMISIONBRUTA        FLOAT,
                                  @p_VALORCOMISIONNETA         FLOAT,
                                  @p_VALORDESCUENTOS           FLOAT,
                                  @p_VALORAPAGARGTECH          FLOAT,
                                  @p_VALORAPAGARFIDUCIA        FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADVENTA           = @p_CANTIDADVENTA,
           VALORVENTA              = @p_VALORVENTA,
           CANTIDADANULACION       = @p_CANTIDADANULACION,
           VALORANULACION          = @p_VALORANULACION,
           CANTIDADGRATUITO        = @p_CANTIDADGRATUITO,
           VALORGRATUITO           = @p_VALORGRATUITO,
           CANTIDADPREMIOPAGO      = @p_CANTIDADPREMIOPAGO,
           VALORPREMIOPAGO         = @p_VALORPREMIOPAGO,
           RETENCIONPREMIOSPAGADOS = @p_RETENCIONPREMIOSPAGADOS,
           VALORVENTABRUTA         = @p_VALORVENTABRUTA,
           VALORVENTANETA          = @p_VALORVENTANETA,
           VALORCOMISION           = @p_VALORCOMISION,
           IVACOMISION             = @p_IVACOMISION,
           VALORCOMISIONBRUTA      = @p_VALORCOMISIONBRUTA,
           VALORCOMISIONNETA       = @p_VALORCOMISIONNETA,
           VALORDESCUENTOS          = @p_VALORDESCUENTOS,           
           NUEVOSALDOENCONTRAGTECH   = CASE WHEN @p_VALORAPAGARGTECH >= 0 
		                                               THEN @p_VALORAPAGARGTECH ELSE 0 END,
           NUEVOSALDOENCONTRAFIDUCIA = CASE WHEN @p_VALORAPAGARFIDUCIA >= 0 
		                                               THEN @p_VALORAPAGARFIDUCIA ELSE 0 END,
           NUEVOSALDOAFAVORGTECH     = CASE WHEN @p_VALORAPAGARGTECH < 0 
		                                               THEN ABS(@p_VALORAPAGARGTECH) ELSE 0 END,
           NUEVOSALDOAFAVORFIDUCIA   = CASE WHEN @p_VALORAPAGARFIDUCIA < 0 
		                                                THEN ABS(@p_VALORAPAGARFIDUCIA) ELSE 0 END
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarVenta;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarVenta
                                                   (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                            @p_CANTIDADVENTA             NUMERIC(22,0),
                            @p_VALORVENTA                FLOAT,
                            @p_VALORVENTABRUTA           FLOAT,
                            @p_VALORVENTANETA            FLOAT,
                            @p_VALORCOMISION             FLOAT,
                            @p_IVACOMISION               FLOAT,
                            @p_VALORCOMISIONBRUTA        FLOAT,
                            @p_VALORCOMISIONNETA         FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADVENTA      = CANTIDADVENTA      + @p_CANTIDADVENTA,
           VALORVENTA         = VALORVENTA         + @p_VALORVENTA,
           VALORVENTABRUTA    = VALORVENTABRUTA    + @p_VALORVENTABRUTA,
           VALORVENTANETA     = VALORVENTANETA     + @p_VALORVENTANETA,
           VALORCOMISION      = VALORCOMISION      + @p_VALORCOMISION,
           IVACOMISION        = IVACOMISION        + @p_IVACOMISION,
           VALORCOMISIONBRUTA = VALORCOMISIONBRUTA + @p_VALORCOMISIONBRUTA,
           VALORCOMISIONNETA  = VALORCOMISIONNETA  + @p_VALORCOMISIONNETA
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarVentaAnulada', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarVentaAnulada;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarVentaAnulada
                                  (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                                   @p_CANTIDADVENTA             NUMERIC(22,0),
                                   @p_VALORVENTA                FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADVENTA     = CANTIDADVENTA     + @p_CANTIDADVENTA,
           CANTIDADANULACION = CANTIDADANULACION + @p_CANTIDADVENTA,
           VALORVENTA        = VALORVENTA        + @p_VALORVENTA,
           VALORANULACION    = VALORANULACION    + @p_VALORVENTA
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarAnulacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarAnulacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarAnulacion(@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                                @p_CANTIDADVENTA             NUMERIC(22,0),
                                @p_VALORVENTA                FLOAT,
                                @p_VALORVENTABRUTA           FLOAT,
                                @p_VALORVENTANETA            FLOAT,
                                @p_VALORCOMISION             FLOAT,
                                @p_IVACOMISION               FLOAT,
                                @p_VALORCOMISIONBRUTA        FLOAT,
                                @p_VALORCOMISIONNETA         FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADVENTA      = CANTIDADVENTA      + @p_CANTIDADVENTA,
           CANTIDADANULACION  = CANTIDADANULACION  + @p_CANTIDADVENTA,
           VALORANULACION     = VALORANULACION     + @p_VALORVENTA,
           VALORVENTABRUTA    = VALORVENTABRUTA    - @p_VALORVENTABRUTA,
           VALORVENTANETA     = VALORVENTANETA     - @p_VALORVENTANETA,
           VALORCOMISION      = VALORCOMISION      - @p_VALORCOMISION,
           IVACOMISION        = IVACOMISION        - @p_IVACOMISION,
           VALORCOMISIONBRUTA = VALORCOMISIONBRUTA - @p_VALORCOMISIONBRUTA,
           VALORCOMISIONNETA  = VALORCOMISIONNETA  - @p_VALORCOMISIONNETA
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarPremioPago', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarPremioPago;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarPremioPago
                                (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                                 @p_CANTIDADPREMIOPAGO        NUMERIC(22,0),
                                 @p_VALORPREMIONETO           FLOAT,
                                 @p_RETENCIONPREMIOSPAGADOS   FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADPREMIOPAGO = CANTIDADPREMIOPAGO + @p_CANTIDADPREMIOPAGO,
           VALORPREMIOPAGO    = VALORPREMIOPAGO    + @p_VALORPREMIONETO,
           RETENCIONPREMIOSPAGADOS = RETENCIONPREMIOSPAGADOS + @p_RETENCIONPREMIOSPAGADOS
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarGratuito', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarGratuito;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarGratuito(@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
                               @p_CANTIDADGRATUITO          FLOAT,
                               @p_VALORGRATUITO             FLOAT) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET CANTIDADGRATUITO = CANTIDADGRATUITO + @p_CANTIDADGRATUITO,
           VALORGRATUITO    = @p_VALORGRATUITO
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarValoresPago', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarValoresPago;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_ActualizarValoresPago(@pk_ID_DETALLEFACTURACIONPDV    NUMERIC(22,0),
                                  @p_NUEVOSALDOENCONTRAGTECH      FLOAT,
                                  @p_NUEVOSALDOENCONTRAFIDUCIA    FLOAT,
                                  @p_NUEVOSALDOAFAVORGTECH        FLOAT,
                                  @p_NUEVOSALDOAFAVORFIDUCIA      FLOAT,
                                  @p_CODUSUARIOMODIFICACION       NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
       SET NUEVOSALDOENCONTRAGTECH      = @p_NUEVOSALDOENCONTRAGTECH,
           NUEVOSALDOENCONTRAFIDUCIA    = @p_NUEVOSALDOENCONTRAFIDUCIA,
           NUEVOSALDOAFAVORGTECH        = @p_NUEVOSALDOAFAVORGTECH,
           NUEVOSALDOAFAVORFIDUCIA      = @p_NUEVOSALDOAFAVORFIDUCIA,
           CODUSUARIOMODIFICACION       = @p_CODUSUARIOMODIFICACION
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_GetRecord
                            (@pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0)
							  ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*) FROM WSXML_SFG.DETALLEFACTURACIONPDV
     WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
	
      SELECT ID_DETALLEFACTURACIONPDV,
             CODMAESTROFACTURACIONPDV,
             CODPRODUCTO,
             CANTIDADVENTA,
             VALORVENTA,
             CANTIDADANULACION,
             VALORANULACION,
             CANTIDADPREMIOPAGO,
             VALORPREMIOPAGO,
             CANTIDADGRATUITO,
             VALORGRATUITO,
             VALORCOMISION,
             VALORCOMISIONNETA,
             VALORVENTANETA,
             RETENCIONPREMIOSPAGADOS,
             AJUSTE,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLEFACTURACIONPDV
       WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDETALLEFACTURACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDETALLEFACTURACIONPDV_GetList(@p_active NUMERIC(22,0)
                                                          ) AS
  BEGIN
  SET NOCOUNT ON;

    
      SELECT ID_DETALLEFACTURACIONPDV,
             CODMAESTROFACTURACIONPDV,
             CODPRODUCTO,
             CANTIDADVENTA,
             VALORVENTA,
             CANTIDADANULACION,
             VALORANULACION,
             CANTIDADPREMIOPAGO,
             VALORPREMIOPAGO,
             CANTIDADGRATUITO,
             VALORGRATUITO,
             VALORCOMISION,
             VALORCOMISIONNETA,
             VALORVENTANETA,
             RETENCIONPREMIOSPAGADOS,
             AJUSTE,
             CODUSUARIOMODIFICACION,
             FECHAHORAMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.DETALLEFACTURACIONPDV
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	   

  END;
GO






