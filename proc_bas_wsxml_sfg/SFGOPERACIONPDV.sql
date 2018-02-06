USE SFGPRODU;
--  DDL for Package Body SFGOPERACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGOPERACIONPDV */ 

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_AddRecord(@p_NOMOPERACIONPDV         NVARCHAR(2000),
                      @p_SPOPERACION             NVARCHAR(2000),
                      @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                      @p_ID_OPERACIONPDV_out     NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.OPERACIONPDV (
                                NOMOPERACIONPDV,
                                SPOPERACION,
                                CODUSUARIOMODIFICACION)
    VALUES (
            @p_NOMOPERACIONPDV,
            @p_SPOPERACION,
            @p_CODUSUARIOMODIFICACION);
    SET @p_ID_OPERACIONPDV_out = SCOPE_IDENTITY();

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_UpdateRecord(@pk_ID_OPERACIONPDV        NUMERIC(22,0),
                         @p_NOMOPERACIONPDV         NVARCHAR(2000),
                         @p_SPOPERACION             NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION  NUMERIC(22,0),
                         @p_ACTIVE                  NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

    UPDATE WSXML_SFG.OPERACIONPDV
       SET NOMOPERACIONPDV         = @p_NOMOPERACIONPDV,
           SPOPERACION             = @p_SPOPERACION,
           CODUSUARIOMODIFICACION  = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION   = GETDATE(),
           ACTIVE                  = @p_ACTIVE
     WHERE ID_OPERACIONPDV         = @pk_ID_OPERACIONPDV;

    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_GetRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_GetRecord(@pk_ID_OPERACIONPDV NUMERIC(22,0)
                                      ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = COUNT(*) FROM WSXML_SFG.OPERACIONPDV
     WHERE ID_OPERACIONPDV = @pk_ID_OPERACIONPDV;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

	
      SELECT ID_OPERACIONPDV,
             NOMOPERACIONPDV,
             SPOPERACION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.OPERACIONPDV
       WHERE ID_OPERACIONPDV = @pk_ID_OPERACIONPDV;
	;	   
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_GetList(@p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
      SELECT ID_OPERACIONPDV,
             NOMOPERACIONPDV,
             SPOPERACION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.OPERACIONPDV
       WHERE ACTIVE = CASE WHEN @p_active = -1 THEN ACTIVE ELSE @p_active END;
	;	
  END;
GO

  -----------------------------------------------------------------------------------
  -- Procedimientos que obtienen datos del punto de venta
  -- Estos estaran registrados como entradas en la tabla OperacionPDV
  -- Es prerequisito que se invoquen usando los parametros:
  -- pk_ID_PUNTODEVENTA: Codigo del punto de venta
  -- p_cur OUT: Cursor de salida
  -- El procedimiento devuelve el valor para el punto de venta. Si pK_ID_PUNTODEVENTA
  -- es -1, el procedimiento devuelve los valores para todos los puntos de venta.
  -- Todos los cursores devueltos traen 2 columnas: ID_PUNTODEVENTA y VALOR
  ------------------------------------------------------------------------------------

IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_NumeroDeSuspensiones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_NumeroDeSuspensiones;
GO
CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_NumeroDeSuspensiones(@pk_ID_PUNTODEVENTA NUMERIC(38,0)) AS
  BEGIN
  SET NOCOUNT ON;
	  
        SELECT id_puntodeventa AS PUNTODEVENTA, 0 VALOR
        FROM WSXML_SFG.PUNTODEVENTA
        WHERE id_puntodeventa = CASE WHEN @pk_ID_PUNTODEVENTA=-1 THEN id_puntodeventa ELSE @pk_ID_PUNTODEVENTA END;
	;	
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_PromedioFacturacionSemanal', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_PromedioFacturacionSemanal;
GO
CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_PromedioFacturacionSemanal(@pk_ID_PUNTODEVENTA NUMERIC(38,0)) AS
  BEGIN
  SET NOCOUNT ON;
	
	 
        SELECT id_puntodeventa AS PUNTODEVENTA, AVG(ISNULL(M.NUEVOSALDOENCONTRAGTECH, 0) + ISNULL(M.NUEVOSALDOENCONTRAFIDUCIA, 0)) VALOR
        FROM WSXML_SFG.PUNTODEVENTA P
        LEFT OUTER JOIN MAESTROFACTURACIONPDV M
          ON (M.CODPUNTODEVENTA = P.ID_PUNTODEVENTA)
        WHERE P.id_puntodeventa = CASE WHEN @pk_ID_PUNTODEVENTA=-1 THEN id_puntodeventa ELSE @pk_ID_PUNTODEVENTA END
        GROUP BY id_puntodeventa;
		;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_CupoActual', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_CupoActual;
GO
CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_CupoActual(@pk_ID_PUNTODEVENTA NUMERIC(38,0)) AS
  BEGIN
  SET NOCOUNT ON;
  	 
        SELECT *
        FROM WSXML_SFG.PUNTODEVENTA P;
        --id_puntodeventa AS PUNTODEVENTA,
        --CASE WHEN C.VALORCUPO IS NULL THEN P.CUPOINICIAL ELSE C.VALORCUPO END VALOR
        --FROM PUNTODEVENTA P;
        --LEFT OUTER JOIN CATEGORIACUPO C
          --ON (C.ID_CATEGORIACUPO = P.CODCATEGORIACUPO)
        --WHERE id_puntodeventa = CASE WHEN pk_ID_PUNTODEVENTA=-1 THEN id_puntodeventa ELSE pk_ID_PUNTODEVENTA END;
		;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_ListPuntosDeVenta', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_ListPuntosDeVenta;
GO
CREATE     PROCEDURE WSXML_SFG.SFGOPERACIONPDV_ListPuntosDeVenta(@p_ID_PUNTODEVENTA NVARCHAR(2000), @p_CADENA NVARCHAR(2000),@p_RUTAPDV NUMERIC(22,0), @p_REGIONAL NUMERIC(22,0), @p_RED NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
  	   
        select
               PV.ID_PUNTODEVENTA as IDPUNTODEVENTA,
               PV.codigogtechpuntodeventa AS PUNTODEVENTA,
               PV.codredpdv,
               PV.codrutapdv,
               PV.codregional,
               APV.codigoagrupaciongtech
          from WSXML_SFG.PUNTODEVENTA PV
               INNER JOIN agrupacionpuntodeventa APV ON PV.codagrupacionpuntodeventa = APV.id_agrupacionpuntodeventa
         WHERE
               codigogtechpuntodeventa = CASE WHEN @p_ID_PUNTODEVENTA='-1' THEN codigogtechpuntodeventa ELSE @p_ID_PUNTODEVENTA END
               and APV.codigoagrupaciongtech = CASE WHEN @p_CADENA='-1' THEN APV.codigoagrupaciongtech ELSE @p_CADENA END
               and PV.codredpdv = CASE WHEN @p_RED=-1 THEN PV.codredpdv ELSE @p_RED END
               and PV.codrutapdv = CASE WHEN @p_RUTAPDV=-1 THEN PV.codrutapdv ELSE @p_RUTAPDV END
               and PV.codregional = CASE WHEN @p_REGIONAL=-1 THEN PV.codregional ELSE @p_REGIONAL END;
	;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_CountInactivaciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_CountInactivaciones;
GO
CREATE PROCEDURE WSXML_SFG.SFGOPERACIONPDV_CountInactivaciones(@p_PUNTODEVENTA NUMERIC(22,0), @p_FECHAFIN DATETIME)
AS
BEGIN
    DECLARE @cInactivacion NUMERIC(22,0);
    DECLARE @cActivacion   NUMERIC(22,0);
    DECLARE @cFechaIni     DATETIME;
   
  SET NOCOUNT ON;
      SET @cFechaIni = @p_FECHAFIN - 7;
      select  @cInactivacion = Count(*)
      from  WSXML_SFG.INACTIVACIONPDV
      WHERE CODPUNTODEVENTA = @p_PUNTODEVENTA
      AND FECHAINACTIVACION BETWEEN @cFechaIni AND @p_FECHAFIN;

  	   	  
        select
               @cInactivacion as Valor,
               PV.Id_PUNTODEVENTA
          from WSXML_SFG.PUNTODEVENTA PV
          WHERE pv.id_puntodeventa= @p_PUNTODEVENTA;
	;		  
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGOPERACIONPDV_CountTransacciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGOPERACIONPDV_CountTransacciones;
GO
CREATE PROCEDURE WSXML_SFG.SFGOPERACIONPDV_CountTransacciones(@p_PUNTODEVENTA NUMERIC(22,0), @p_FECHAFIN DATETIME)
AS
BEGIN
    DECLARE @cFechaIni     DATETIME;
   
  SET NOCOUNT ON;
      SET @cFechaIni = @p_FECHAFIN - 7;
	 
      select fechatransaccion,
		sum(numtransacciones) as cantidad
      from WSXML_SFG.registrofacturacion
      where codpuntodeventa= @p_PUNTODEVENTA
		and fechatransaccion BETWEEN @cFechaIni AND @p_FECHAFIN
      group by fechatransaccion,numtransacciones
      order by fechatransaccion;
	;	  
  END;
GO






