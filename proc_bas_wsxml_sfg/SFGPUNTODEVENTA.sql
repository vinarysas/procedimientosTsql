USE SFGPRODU;
--  DDL for Package Body SFGPUNTODEVENTA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGPUNTODEVENTA */ 

  -- Creates a new record in the PUNTODEVENTA table
  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_AddRecord(@p_CODIGOGTECHPUNTODEVENTA   NVARCHAR(2000),
                      @p_NUMEROTERMINAL            NUMERIC(22,0),
                      @p_NOMPUNTODEVENTA           NVARCHAR(2000),
                      @p_CODCIUDAD                 NUMERIC(22,0),
                      @p_TELEFONO                  NVARCHAR(2000),
                      @p_DIRECCION                 NVARCHAR(2000),
                      @p_CODREGIMEN                NUMERIC(22,0),
                      @p_IDENTIFICACION            NUMERIC(22,0),
                      @p_DIGITOVERIFICACION        NUMERIC(22,0),
                      @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
                      @p_CODRAZONSOCIAL            NUMERIC(22,0),
                      @p_CODDUENOTERMINAL          NUMERIC(22,0),
                      @p_CODDUENOPUNTODEVENTA      NUMERIC(22,0),
                      @p_CODIGOPDVEXTERNO          NVARCHAR(2000),
                      @p_ACTIVE                    NUMERIC(22,0),
                      @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                      @p_ID_PUNTODEVENTA_out       NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;
    INSERT INTO WSXML_SFG.PUNTODEVENTA
      (
       CODIGOGTECHPUNTODEVENTA,
       NUMEROTERMINAL,
       NOMPUNTODEVENTA,
       CODCIUDAD,
       TELEFONO,
       DIRECCION,
       CODREGIMEN,
       IDENTIFICACION,
       DIGITOVERIFICACION,
       CODAGRUPACIONPUNTODEVENTA,
       CODRAZONSOCIAL,
       CODDUENOTERMINAL,
       CODDUENOPUNTODEVENTA,
       CODEXTERNOPUNTODEVENTA,
       ACTIVE,
       CODUSUARIOMODIFICACION)
    VALUES
      (
       @p_CODIGOGTECHPUNTODEVENTA,
       @p_NUMEROTERMINAL,
       @p_NOMPUNTODEVENTA,
       @p_CODCIUDAD,
       @p_TELEFONO,
       @p_DIRECCION,
       @p_CODREGIMEN,
       @p_IDENTIFICACION,
       @p_DIGITOVERIFICACION,
       @p_CODAGRUPACIONPUNTODEVENTA,
       @p_CODRAZONSOCIAL,
       @p_CODDUENOTERMINAL,
       @p_CODDUENOPUNTODEVENTA,
       @p_CODIGOPDVEXTERNO,
       @p_ACTIVE,
       @p_CODUSUARIOMODIFICACION);
    SET @p_ID_PUNTODEVENTA_out = SCOPE_IDENTITY();
  END;
GO

  -- Updates a record in the PUNTODEVENTA table.
  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_UpdateRecord(@pk_ID_PUNTODEVENTA          NUMERIC(22,0),
                         @p_CODIGOGTECHPUNTODEVENTA   NVARCHAR(2000),
                         @p_NUMEROTERMINAL            NUMERIC(22,0),
                         @p_NOMPUNTODEVENTA           NVARCHAR(2000),
                         @p_CODCIUDAD                 NUMERIC(22,0),
                         @p_TELEFONO                  NVARCHAR(2000),
                         @p_DIRECCION                 NVARCHAR(2000),
                         @p_CODREGIMEN                NUMERIC(22,0),
                         @p_IDENTIFICACION            NUMERIC(22,0),
                         @p_DIGITOVERIFICACION        NUMERIC(22,0),
                         @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
                         @p_CODRAZONSOCIAL            NUMERIC(22,0),
                         @p_CODDUENOTERMINAL          NUMERIC(22,0),
                         @p_CODDUENOPUNTODEVENTA      NUMERIC(22,0),
                         @p_CODIGOPDVEXTERNO          NVARCHAR(2000),
                         @p_CODUSUARIOMODIFICACION    NUMERIC(22,0),
                         @p_ACTIVE                    NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PUNTODEVENTA
       SET CODIGOGTECHPUNTODEVENTA   = @p_CODIGOGTECHPUNTODEVENTA,
           NUMEROTERMINAL            = @p_NUMEROTERMINAL,
           NOMPUNTODEVENTA           = @p_NOMPUNTODEVENTA,
           CODCIUDAD                 = @p_CODCIUDAD,
           TELEFONO                  = @p_TELEFONO,
           DIRECCION                 = @p_DIRECCION,
           CODREGIMEN                = @p_CODREGIMEN,
           IDENTIFICACION            = @p_IDENTIFICACION,
           DIGITOVERIFICACION        = @p_DIGITOVERIFICACION,
           CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA,
           CODRAZONSOCIAL            = @p_CODRAZONSOCIAL,
           CODDUENOTERMINAL          = @p_CODDUENOTERMINAL,
           CODDUENOPUNTODEVENTA      = @p_CODDUENOPUNTODEVENTA,
           CODEXTERNOPUNTODEVENTA    = @p_CODIGOPDVEXTERNO,
           CODUSUARIOMODIFICACION    = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION     = GETDATE(),
           ACTIVE                    = @p_ACTIVE
     WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_UpdateDatosTecnicos(@pk_ID_PUNTODEVENTA       NUMERIC(22,0),
                                @p_CODTIPONEGOCIO         NUMERIC(22,0),
                                @p_CODTIPOESTACION        NUMERIC(22,0),
                                @p_CODTIPOTERMINAL        NUMERIC(22,0),
                                @p_CODPUERTOTERMINAL      NUMERIC(22,0),
                                @p_NUMEROLINEA            NVARCHAR(2000),
                                @p_NUMERODROP             NVARCHAR(2000),
                                @p_NOMBRENODO             NVARCHAR(2000),
                                @p_ADDRESSNODO            NVARCHAR(2000),
                                @p_PUERTOESTACION         NVARCHAR(2000),
                                @p_CODRUTAPDV             NUMERIC(22,0),
                                @p_CODREGIONAL            NUMERIC(22,0),
                                @p_CODREDPDV              NUMERIC(22,0),
                                @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PUNTODEVENTA
       SET CODTIPONEGOCIO         = @p_CODTIPONEGOCIO,
           CODTIPOESTACION        = @p_CODTIPOESTACION,
           CODTIPOTERMINAL        = @p_CODTIPOTERMINAL,
           CODPUERTOTERMINAL      = @p_CODPUERTOTERMINAL,
           NUMEROLINEA            = @p_NUMEROLINEA,
           NUMERODROP             = @p_NUMERODROP,
           NOMBRENODO             = @p_NOMBRENODO,
           ADDRESSNODO            = @p_ADDRESSNODO,
           PUERTOESTACION         = @p_PUERTOESTACION,
           CODRUTAPDV             = @p_CODRUTAPDV,
           CODREGIONAL            = @p_CODREGIONAL,
           CODREDPDV              = @p_CODREDPDV,
           CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION
     WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_DeactivateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_DeactivateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_DeactivateRecord(@pk_ID_PUNTODEVENTA       NUMERIC(22,0),
                             @p_CODUSUARIOMODIFICACION NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    UPDATE WSXML_SFG.PUNTODEVENTA
       SET CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
           FECHAHORAMODIFICACION  = GETDATE(),
           ACTIVE                 = 0
     WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;

    -- Make sure only one record is affected
    IF @@rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetRecord;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetRecord(@pk_ID_PUNTODEVENTA NUMERIC(22,0)) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;
    SELECT @l_count = COUNT(*)
      FROM WSXML_SFG.PUNTODEVENTA
     WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

      SELECT PDV.ID_PUNTODEVENTA,
             PDV.CODRAZONSOCIAL,
             NULL AS NUMEROCONTRATO,
             PDV.CODAGRUPACIONPUNTODEVENTA,
             A.NOMAGRUPACIONPUNTODEVENTA,
             PDV.CODIGOGTECHPUNTODEVENTA,
             PDV.NUMEROTERMINAL,
             PDV.NOMPUNTODEVENTA,
             PDV.CODCIUDAD,
             CD.NOMCIUDAD,
             CD.CODDEPARTAMENTO,
             DP.NOMDEPARTAMENTO,
             PDV.TELEFONO,
             PDV.DIRECCION,
             PDV.FECHAHORAMODIFICACION,
             PDV.CODUSUARIOMODIFICACION,
             PDV.ACTIVE,
             PDV.CUPOINICIAL,
             PDV.NUMEROLINEA,
             PDV.NUMERODROP,
             PDV.CODPUERTOTERMINAL,
             PT.NOMPUERTOTERMINAL,
             PDV.NOMBRENODO,
             PDV.ADDRESSNODO,
             PDV.PUERTOESTACION,
             PDV.CODRUTAPDV,
             RP.NOMRUTAPDV,
             PDV.CODREDPDV,
             RD.NOMREDPDV,
             PDV.CODREGIONAL,
             RG.NOMREGIONAL
        FROM WSXML_SFG.PUNTODEVENTA PDV
        LEFT OUTER JOIN RAZONSOCIAL C
          ON (PDV.CODRAZONSOCIAL = C.ID_RAZONSOCIAL)
        LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA A
          ON (PDV.CODAGRUPACIONPUNTODEVENTA = A.ID_AGRUPACIONPUNTODEVENTA)
        LEFT OUTER JOIN CIUDAD CD
          ON (PDV.CODCIUDAD = CD.ID_CIUDAD)
        LEFT OUTER JOIN DEPARTAMENTO DP
          ON (CD.CODDEPARTAMENTO = DP.ID_DEPARTAMENTO)
        LEFT OUTER JOIN PUERTOTERMINAL PT
          ON (PDV.CODPUERTOTERMINAL = PT.ID_PUERTOTERMINAL)
        LEFT OUTER JOIN RUTAPDV RP
          ON (PDV.CODRUTAPDV = RP.ID_RUTAPDV)
        LEFT OUTER JOIN REDPDV RD
          ON (PDV.CODREDPDV = RD.ID_REDPDV)
        LEFT OUTER JOIN REGIONAL RG
          ON (PDV.CODREGIONAL = RG.ID_REGIONAL)
       WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetRecordByCodigoPDV', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetRecordByCodigoPDV;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetRecordByCodigoPDV(@p_CODIGOGTECHPUNTODEVENTA NVARCHAR(2000)
                                                        ) AS
 BEGIN
    DECLARE @l_count INTEGER;
   
  SET NOCOUNT ON;

    SELECT @l_count = count(*)
      FROM WSXML_SFG.PUNTODEVENTA
     WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA;

    IF @l_count = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @l_count > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 

	
      SELECT ID_PUNTODEVENTA,
             CODRAZONSOCIAL,
             CODIGOGTECHPUNTODEVENTA,
             NUMEROTERMINAL,
             NOMPUNTODEVENTA,
             CODCIUDAD,
             TELEFONO,
             DIRECCION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE
        FROM WSXML_SFG.PUNTODEVENTA
       WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA;
	;
  END;
GO

  -- Returns a query resultset from table PUNTODEVENTA
  -- given the search criteria and sorting condition.
  -- It will return a subset of the data based
  -- on the current page number and batch size.  Table joins can
  -- be performed if the join clause is specified.
  --
  -- If the resultset is not empty, it will return:
  --    1) The total number of rows which match the condition;
  --    2) The resultset in the current page
  -- If nothing matches the search condition, it will return:
  --    1) count is 0 ;
  --    2) empty resultset.
IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetList;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetList(@p_active NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
		
            SELECT PDV.ID_PUNTODEVENTA,
             PDV.CODRAZONSOCIAL,
             NULL AS NUMEROCONTRATO,
             PDV.CODIGOGTECHPUNTODEVENTA,
             PDV.NUMEROTERMINAL,
             PDV.NOMPUNTODEVENTA,
             PDV.CODCIUDAD,
             CD.NOMCIUDAD,
             DEPTO.NOMDEPARTAMENTO,
             CD.CIUDADDANE,
             PDV.TELEFONO,
             PDV.DIRECCION,
             TN.NOMTIPONEGOCIO,
             PDV.FECHAHORAMODIFICACION,
             PDV.CODUSUARIOMODIFICACION,
             PDV.ACTIVE,
             PDV.SLIPXML,
             CAST(VWPDV.CODIGOPUNTOVENTAEXTERNO AS INT) AS CODEXTERNOPUNTODEVENTA,
             C.IDENTIFICACION,
             DEPTO.DEPARTAMENTODANE,
             RG.NOMREGIONAL,
             COALESCE(VWPDV.FechaInstalacion, VWPDV.FechaCreacionSistema) as FECHAACTIVACION
        FROM WSXML_SFG.PUNTODEVENTA PDV
        LEFT OUTER JOIN RAZONSOCIAL C        ON (PDV.CODRAZONSOCIAL = C.ID_RAZONSOCIAL)
        LEFT OUTER JOIN CIUDAD CD            ON (PDV.CODCIUDAD = CD.ID_CIUDAD)
        LEFT OUTER JOIN DEPARTAMENTO DEPTO   ON (CD.CODDEPARTAMENTO = DEPTO.ID_DEPARTAMENTO)
        LEFT OUTER JOIN TIPONEGOCIO TN       ON (PDV.CODTIPONEGOCIO = TN.ID_TIPONEGOCIO)
        LEFT OUTER JOIN REGIONAL RG       ON (PDV.CODREGIONAL = RG.ID_REGIONAL)
        INNER JOIN VW_PUNTOSDEVENTAFROMSAG VWPDV ON VWPDV.Codigo = PDV.codigogtechpuntodeventa
       WHERE PDV.ACTIVE = CASE WHEN @p_active = -1 THEN PDV.ACTIVE ELSE @p_active END;
	;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetListPager', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListPager;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListPager(@p_active  NUMERIC(22,0),
                         @start_row NUMERIC(22,0),
                        @end_row   NUMERIC(22,0)
                                ) AS

  BEGIN
  SET NOCOUNT ON;

    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_PUNTODEVENTA,
             CODRAZONSOCIAL,
             NUMEROCONTRATO,
             CODIGOGTECHPUNTODEVENTA,
             NUMEROTERMINAL,
             NOMPUNTODEVENTA,
             CODCIUDAD,
             NOMCIUDAD,
             TELEFONO,
             DIRECCION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             SLIPXML,
             total_rows,
             row_counter
        FROM (SELECT ID_PUNTODEVENTA,
                     CODRAZONSOCIAL,
                     NUMEROCONTRATO,
                     CODIGOGTECHPUNTODEVENTA,
                     NUMEROTERMINAL,
                     NOMPUNTODEVENTA,
                     CODCIUDAD,
                     NOMCIUDAD,
                     TELEFONO,
                     DIRECCION,
                     FECHAHORAMODIFICACION,
                     CODUSUARIOMODIFICACION,
                     ACTIVE,
                     SLIPXML,
                     total_rows,
                      ROW_NUMBER() OVER(order by s.ID_PUNTODEVENTA asc) row_counter
                FROM (SELECT PDV.ID_PUNTODEVENTA,
                             PDV.CODRAZONSOCIAL,
                             NULL AS NUMEROCONTRATO,
                             PDV.CODIGOGTECHPUNTODEVENTA,
                             PDV.NUMEROTERMINAL,
                             PDV.NOMPUNTODEVENTA,
                             PDV.CODCIUDAD,
                             CD.NOMCIUDAD,
                             PDV.TELEFONO,
                             PDV.DIRECCION,
                             PDV.FECHAHORAMODIFICACION,
                             PDV.CODUSUARIOMODIFICACION,
                             PDV.ACTIVE,
                             PDV.SLIPXML,
                             count(*) OVER() total_rows
                        FROM WSXML_SFG.PUNTODEVENTA PDV
                        LEFT OUTER JOIN RAZONSOCIAL C
                          ON (PDV.CODRAZONSOCIAL = C.ID_RAZONSOCIAL)
                        LEFT OUTER JOIN CIUDAD CD
                          ON (PDV.CODCIUDAD = CD.ID_CIUDAD)
                       where PDV.ACTIVE = CASE
                               WHEN @p_active = -1 THEN
                                PDV.ACTIVE
                               ELSE
                                @p_active
                             END) s) s
       WHERE row_counter between @start_row and @end_row;
		;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetListByAll', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListByAll;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListByAll(@p_active               NUMERIC(22,0),
                         @p_codContrato          NUMERIC(22,0),
                         @p_codGtechPuntodeVenta NVARCHAR(2000),
                         @p_NumeroTerminal       NVARCHAR(2000),
                        @p_CodCiudad            NUMERIC(22,0)
                                             ) AS

  BEGIN
  SET NOCOUNT ON;

  	
      SELECT PDV.ID_PUNTODEVENTA,
             PDV.CODRAZONSOCIAL,
             NULL AS NUMEROCONTRATO,
             C.NOMRAZONSOCIAL,
             PDV.CODIGOGTECHPUNTODEVENTA,
             PDV.NUMEROTERMINAL,
             PDV.NOMPUNTODEVENTA,
             PDV.CODCIUDAD,
             CD.NOMCIUDAD,
             PDV.TELEFONO,
             PDV.DIRECCION,
             PDV.FECHAHORAMODIFICACION,
             PDV.CODUSUARIOMODIFICACION,
             PDV.ACTIVE
        FROM WSXML_SFG.PUNTODEVENTA PDV
			LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL C ON (PDV.CODRAZONSOCIAL = C.ID_RAZONSOCIAL)
			LEFT OUTER JOIN WSXML_SFG.CIUDAD CD ON (PDV.CODCIUDAD = CD.ID_CIUDAD)
       WHERE PDV.ACTIVE = CASE WHEN @p_active = -1 THEN PDV.ACTIVE ELSE @p_active END
			AND PDV.CODRAZONSOCIAL = CASE WHEN @p_codContrato = -1 THEN PDV.CODRAZONSOCIAL ELSE @p_codContrato END
			AND PDV.CODIGOGTECHPUNTODEVENTA = CASE WHEN @p_codGtechPuntodeVenta = '-1' THEN PDV.CODIGOGTECHPUNTODEVENTA ELSE @p_codGtechPuntodeVenta END
			AND PDV.NUMEROTERMINAL = CASE WHEN @p_NumeroTerminal = -1 THEN PDV.NUMEROTERMINAL ELSE @p_NumeroTerminal END
			AND PDV.CODCIUDAD = CASE WHEN @p_CodCiudad = -1 THEN PDV.CODCIUDAD ELSE @p_CodCiudad END
       ORDER BY NOMPUNTODEVENTA;
	;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetListByGroup', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListByGroup;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListByGroup(@p_ACTIVE          NUMERIC(22,0),
                           @p_CODDEPARTAMENTO NUMERIC(22,0),
                           @p_CODCIUDAD       NUMERIC(22,0),
                           @p_CODAGRUPACION   NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;

      SELECT PUNTODEVENTA.ID_PUNTODEVENTA,
             PUNTODEVENTA.CODRAZONSOCIAL,
             PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA,
             PUNTODEVENTA.NUMEROTERMINAL,
             PUNTODEVENTA.NOMPUNTODEVENTA,
             PUNTODEVENTA.CODCIUDAD,
             PUNTODEVENTA.TELEFONO,
             PUNTODEVENTA.DIRECCION,
             PUNTODEVENTA.FECHAHORAMODIFICACION,
             PUNTODEVENTA.CODUSUARIOMODIFICACION,
             PUNTODEVENTA.ACTIVE,
             CIUDAD.NOMCIUDAD,
             DEPARTAMENTO.NOMDEPARTAMENTO,
             NULL AS NUMEROCONTRATO,
             AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,
             RAZONSOCIAL.Identificacion,
             PUNTODEVENTA.CODREGIONAL
        FROM WSXML_SFG.PUNTODEVENTA
        LEFT OUTER JOIN CIUDAD
          ON (CIUDAD.ID_CIUDAD = PUNTODEVENTA.CODCIUDAD)
        LEFT OUTER JOIN DEPARTAMENTO
          ON (DEPARTAMENTO.ID_DEPARTAMENTO = CIUDAD.CODDEPARTAMENTO)
        LEFT OUTER JOIN RAZONSOCIAL
          ON (RAZONSOCIAL.ID_RAZONSOCIAL = PUNTODEVENTA.CODRAZONSOCIAL)
        LEFT OUTER JOIN AGRUPACIONPUNTODEVENTA
          ON (AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA =
             PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA)
       WHERE PUNTODEVENTA.ACTIVE = CASE
               WHEN @p_ACTIVE = -1 THEN
                PUNTODEVENTA.ACTIVE
               ELSE
                @p_ACTIVE
             END
         AND CIUDAD.CODDEPARTAMENTO = CASE
               WHEN @p_CODDEPARTAMENTO = -1 THEN
                CIUDAD.CODDEPARTAMENTO
               ELSE
                @p_CODDEPARTAMENTO
             END
         AND PUNTODEVENTA.CODCIUDAD = CASE
               WHEN @p_CODCIUDAD = -1 THEN
                PUNTODEVENTA.CODCIUDAD
               ELSE
                @p_CODCIUDAD
             END
         AND PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA = CASE WHEN @p_CODAGRUPACION = -1 THEN PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA ELSE @p_CODAGRUPACION END
       ORDER BY NOMPUNTODEVENTA;

  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetListByGroupPager', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListByGroupPager;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetListByGroupPager(@p_ACTIVE          NUMERIC(22,0),
                                @p_CODDEPARTAMENTO NUMERIC(22,0),
                                @p_CODCIUDAD       NUMERIC(22,0),
                                @p_CODAGRUPACION   NUMERIC(22,0),
                                @start_row         NUMERIC(22,0),
                               @end_row           NUMERIC(22,0)
                                               ) AS
  BEGIN
  SET NOCOUNT ON;
  	   
      SELECT ID_PUNTODEVENTA,
             CODRAZONSOCIAL,
             CODIGOGTECHPUNTODEVENTA,
             NUMEROTERMINAL,
             NOMPUNTODEVENTA,
             CODCIUDAD,
             TELEFONO,
             DIRECCION,
             FECHAHORAMODIFICACION,
             CODUSUARIOMODIFICACION,
             ACTIVE,
             NOMCIUDAD,
             NOMDEPARTAMENTO,
             NUMEROCONTRATO,
             NOMAGRUPACIONPUNTODEVENTA,
             total_rows,
             row_counter
        FROM (SELECT ID_PUNTODEVENTA,
                     CODRAZONSOCIAL,
                     CODIGOGTECHPUNTODEVENTA,
                     NUMEROTERMINAL,
                     NOMPUNTODEVENTA,
                     CODCIUDAD,
                     TELEFONO,
                     DIRECCION,
                     FECHAHORAMODIFICACION,
                     CODUSUARIOMODIFICACION,
                     ACTIVE,
                     NOMCIUDAD,
                     NOMDEPARTAMENTO,
                     NUMEROCONTRATO,
                     NOMAGRUPACIONPUNTODEVENTA,
                     total_rows,
                     ROW_NUMBER() OVER(order by s.NOMPUNTODEVENTA asc) row_counter
                FROM (SELECT PUNTODEVENTA.ID_PUNTODEVENTA,
                             PUNTODEVENTA.CODRAZONSOCIAL,
                             PUNTODEVENTA.CODIGOGTECHPUNTODEVENTA,
                             PUNTODEVENTA.NUMEROTERMINAL,
                             PUNTODEVENTA.NOMPUNTODEVENTA,
                             PUNTODEVENTA.CODCIUDAD,
                             PUNTODEVENTA.TELEFONO,
                             PUNTODEVENTA.DIRECCION,
                             PUNTODEVENTA.FECHAHORAMODIFICACION,
                             PUNTODEVENTA.CODUSUARIOMODIFICACION,
                             PUNTODEVENTA.ACTIVE,
                             CIUDAD.NOMCIUDAD,
                             DEPARTAMENTO.NOMDEPARTAMENTO,
                             NULL AS NUMEROCONTRATO,
                             AGRUPACIONPUNTODEVENTA.NOMAGRUPACIONPUNTODEVENTA,
                             count(*) OVER() total_rows
                        FROM WSXML_SFG.PUNTODEVENTA
							LEFT OUTER JOIN WSXML_SFG.CIUDAD ON (CIUDAD.ID_CIUDAD = PUNTODEVENTA.CODCIUDAD)
							LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO ON (DEPARTAMENTO.ID_DEPARTAMENTO = CIUDAD.CODDEPARTAMENTO)
							LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL ON (RAZONSOCIAL.ID_RAZONSOCIAL = PUNTODEVENTA.CODRAZONSOCIAL)
							LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON (AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA = PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA)
                       WHERE PUNTODEVENTA.ACTIVE = CASE
                               WHEN @p_ACTIVE = -1 THEN
                                PUNTODEVENTA.ACTIVE
                               ELSE
                                @p_ACTIVE
                             END
                         AND CIUDAD.CODDEPARTAMENTO = CASE
                               WHEN @p_CODDEPARTAMENTO = -1 THEN
                                CIUDAD.CODDEPARTAMENTO
                               ELSE
                                @p_CODDEPARTAMENTO
                             END
                         AND PUNTODEVENTA.CODCIUDAD = CASE
                               WHEN @p_CODCIUDAD = -1 THEN
                                PUNTODEVENTA.CODCIUDAD
                               ELSE
                                @p_CODCIUDAD
                             END
                         AND PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA = CASE
                               WHEN @p_CODAGRUPACION = -1 THEN
                                PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA
                               ELSE
                                @p_CODAGRUPACION
                             END
                       ) s) s
       WHERE row_counter between @start_row and @end_row;
	;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_UpdateSLIPXml', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_UpdateSLIPXml;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_UpdateSLIPXml(@pk_ID_PUNTODEVENTA NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.PUNTODEVENTA
       SET SLIPXML = SLIPXML + 1
     WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;

  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetSLIPXml', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetSLIPXml;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetSLIPXml(@pk_ID_PUNTODEVENTA NUMERIC(22,0)) AS

  BEGIN
  SET NOCOUNT ON;
    -- Get the rows from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
	
      SELECT ID_PUNTODEVENTA, PDV.SLIPXML
        FROM WSXML_SFG.PUNTODEVENTA PDV
       WHERE PDV.ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;
	;
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_Busqueda', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_Busqueda;
GO
CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_Busqueda(@p_dato VARCHAR) AS
  BEGIN
  SET NOCOUNT ON;
	
      select id_puntodeventa, nompuntodeventa, codigogtechpuntodeventa
        from WSXML_SFG.puntodeventa
       where codigogtechpuntodeventa like '%' + isnull(@p_dato, '') + '%'
          or nompuntodeventa like '%' + isnull(@p_dato, '') + '%';
	;
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_CalcularDigitoVerificacion', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_CalcularDigitoVerificacion;
GO

CREATE     PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_CalcularDigitoVerificacion(@pk_ID_PUNTODEVENTA NUMERIC(22,0)) AS
 BEGIN
 
	SET NOCOUNT ON;
	
    DECLARE @thisIDENTIFICACION NUMERIC(22,0);
    DECLARE @strIDENTIFICACION  NVARCHAR(15);
    --DECLARE @primeNUMBERS       NUMBERARRAY;
    DECLARE @smcheck            NUMERIC(22,0) = 0;
    DECLARE @residuo            NUMERIC(22,0) = 0;
    DECLARE @digitov            NUMERIC(22,0);
    DECLARE @tmpdigt            NUMERIC(22,0);
   
	DECLARE @primeNUMBERS TABLE(ID INT, VALOR INT)
	
	INSERT INTO @primeNUMBERS VALUES (1,3), (2,7), (3,13), (4,17), (5,19), (6,23), (7,29), (8,37), (9,41), (10,43), (11,47), (12,53), (13,59), (14,67), (15,71)
	
    SELECT @thisIDENTIFICACION = IDENTIFICACION
      FROM WSXML_SFG.PUNTODEVENTA
     WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;

    SET @strIDENTIFICACION = CONVERT(VARCHAR(MAX), @thisIDENTIFICACION);
	
	DECLARE @ix INT = 1;
	WHILE (@ix < LEN(@strIDENTIFICACION))
	BEGIN
		SET @tmpdigt  = CAST(SUBSTRING (@strIDENTIFICACION,LEN(@strIDENTIFICACION) - @ix +1, 1) AS INT)
		SET @smcheck = @smcheck + (@tmpdigt*(SELECT VALOR FROM @primeNUMBERS WHERE ID = @ix ))
		SET @ix = @ix + 1;
	END
	
	SET @residuo = @smcheck % 11;
	IF(@residuo in (0,1))
		SET @digitov = @residuo
	ELSE	
		SET @digitov = (11 - @residuo)
	
	UPDATE WSXML_SFG.PUNTODEVENTA
	   SET DIGITOVERIFICACION = @digitov
	 WHERE ID_PUNTODEVENTA = @pk_ID_PUNTODEVENTA;	
END
GO
IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_ObtainBillingRules', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_ObtainBillingRules;
GO

  /* Obtenci?n de reglas de prefacturaci?n, de acuerdo a los contratos firmados */
  CREATE PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_ObtainBillingRules(@p_CODPUNTODEVENTA           NUMERIC(22,0),
                               @p_CODPRODUCTO               NUMERIC(22,0),
                               @p_CODREGIMEN                NUMERIC(22,0) OUT,
                               @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0) OUT,
                               @p_CODREDPDV                 NUMERIC(22,0) OUT,
                               @p_IDENTIFICACION            NUMERIC(22,0) OUT,
                               @p_DIGITOVERIFICACION        NUMERIC(22,0) OUT,
                               @p_CODCIUDAD                 NUMERIC(22,0) OUT,
                               @p_CODCOMPANIA               NUMERIC(22,0) OUT,
                               @p_CODALIADOESTRATEGICO      NUMERIC(22,0) OUT,
                               @p_CODTIPOCONTRATOPDV        NUMERIC(22,0) OUT,
                               @p_CODRAZONSOCIAL            NUMERIC(22,0) OUT,
                               @p_CODTIPOCONTRATOPRODUCTO   NUMERIC(22,0) OUT,
                               @p_CODDUENOTERMINAL          NUMERIC(22,0) OUT,
                               @p_FACTURABE                 NUMERIC(22,0) OUT) AS
 BEGIN
	SET NOCOUNT ON;
    -- Minimizer keys for cases with no contract
    DECLARE @cCODSERVICIO NUMERIC(22,0);
    DECLARE @cCODIGOPROD VARCHAR(4000)  /* Use -meta option PRODUCTO.CODIGOGTECHPRODUCTO%TYPE */;
   
    SELECT @p_CODREGIMEN = PDV.CODREGIMEN,
           @p_CODAGRUPACIONPUNTODEVENTA = PDV.CODAGRUPACIONPUNTODEVENTA,
           @p_CODREDPDV = PDV.CODREDPDV,
           @p_IDENTIFICACION = PDV.IDENTIFICACION,
           @p_DIGITOVERIFICACION = PDV.DIGITOVERIFICACION,
           @p_CODCIUDAD = PDV.CODCIUDAD,
           @p_CODCOMPANIA = RCT.CODCOMPANIA,
           @p_CODALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO,
           @p_CODTIPOCONTRATOPDV = RCT.CODTIPOCONTRATOPDV,
           @cCODSERVICIO = LDN.CODSERVICIO,
           @p_CODRAZONSOCIAL = PDV.CODRAZONSOCIAL,
           @p_CODTIPOCONTRATOPRODUCTO = PCT.CODTIPOCONTRATOPRODUCTO,
           @cCODIGOPROD = PRD.CODIGOGTECHPRODUCTO,
           @p_CODDUENOTERMINAL = PDV.CODDUENOTERMINAL,
           @p_FACTURABE = CASE WHEN PRNOFACT.ID_PRODUCTOREDPDVNOFACTURABLE IS NOT NULL THEN 0 ELSE 1 END 
           FROM WSXML_SFG.PUNTODEVENTA PDV
			 INNER JOIN WSXML_SFG.PRODUCTO PRD
				ON (PRD.ID_PRODUCTO = @p_CODPRODUCTO)
			 INNER JOIN WSXML_SFG.REDPDV RED 
				ON (PDV.CODREDPDV = RED.ID_REDPDV)         
			 INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR
				ON (TPR.ID_TIPOPRODUCTO = PRD.CODTIPOPRODUCTO)
			 INNER JOIN WSXML_SFG.LINEADENEGOCIO LDN
				ON (LDN.ID_LINEADENEGOCIO = TPR.CODLINEADENEGOCIO)
			  LEFT OUTER JOIN WSXML_SFG.RAZONSOCIALCONTRATO RCT
				ON (RCT.CODRAZONSOCIAL = PDV.CODRAZONSOCIAL AND
					RCT.CODSERVICIO = LDN.CODSERVICIO AND 
					RCT.CODCANALNEGOCIO = RED.CODCANALNEGOCIO)
			  LEFT OUTER JOIN WSXML_SFG.PRODUCTOCONTRATO PCT
				ON (PCT.CODPRODUCTO = PRD.ID_PRODUCTO)
			 LEFT OUTER JOIN WSXML_SFG.PRODUCTOREDPDVNOFACTURABLE PRNOFACT ON 
				  ( PRNOFACT.CODPRODUCTO = PRD.ID_PRODUCTO  AND 
					PRNOFACT.CODREDPDV  = RED.ID_REDPDV AND 
					PRNOFACT.ACTIVE = 1
					) 
     WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
    IF @p_CODTIPOCONTRATOPRODUCTO IS NULL BEGIN
		DECLARE @errmsg VARCHAR(2000) = '-20054 No existe contrato asociado para el producto ' + ISNULL(@cCODIGOPROD, '')
		RAISERROR(@errmsg, 16, 1);
    END 
    -- Trampa de puntos de venta (razones sociales) sin contrato asociado para el producto
    --IF @p_CODTIPOCONTRATOPDV IS NULL BEGIN
    --  RAISE NO_DATA_FOUND;
    --END 
	
	IF @@ROWCOUNT = 0 BEGIN
/*      DECLARE
        cDEFAULTCOMPANY NUMBER := COMPANIA_F(105);
        cDEFAULTCONTRCT NUMBER := SFGTIPOCONTRATOPDV.ADMINISTRACION;
        cNOMSERVICIO    SERVICIO.NOMSERVICIO%TYPE;
        cout            NUMBER;
      BEGIN
        -- Obtener nombre del servicio para generar alerta
        SELECT NOMSERVICIO
          INTO cNOMSERVICIO
          FROM SERVICIO
         WHERE ID_SERVICIO = cCODSERVICIO;
        --SFGALERTA.GenerarAlerta(SFGALERTA.TIPOADVERTENCIA, 'LOAD_SALES_FILE', 'El punto de venta ' || PUNTODEVENTA_CODIGO_F(p_CODPUNTODEVENTA) || ' no tiene contrato (' || cNOMSERVICIO || ') que permita el producto ' || PRODUCTO_CODIGO_F(p_CODPRODUCTO) || ' - ' || PRODUCTO_NOMBRE_F(p_CODPRODUCTO) || '. Se han tomado reglas por defecto.', 1);
        SFGRAZONSOCIAL.SetContrato(p_CODRAZONSOCIAL,
                                   cCODSERVICIO,
                                   cDEFAULTCOMPANY,
                                   cDEFAULTCONTRCT,
                                   p_CODRAZONSOCIAL,
                                   1,\*convensional*\
                                   1,
                                   cout);
        SELECT PDV.CODREGIMEN,
               PDV.CODAGRUPACIONPUNTODEVENTA,
               PDV.CODREDPDV,
               PDV.IDENTIFICACION,
               PDV.DIGITOVERIFICACION,
               PDV.CODCIUDAD,
               cDEFAULTCOMPANY,
               PRD.CODALIADOESTRATEGICO,
               cDEFAULTCONTRCT
          INTO p_CODREGIMEN,
               p_CODAGRUPACIONPUNTODEVENTA,
               p_CODREDPDV,
               p_IDENTIFICACION,
               p_DIGITOVERIFICACION,
               p_CODCIUDAD,
               p_CODCOMPANIA,
               p_CODALIADOESTRATEGICO,
               p_CODTIPOCONTRATOPDV
          FROM PUNTODEVENTA PDV
         INNER JOIN PRODUCTO PRD
            ON (PRD.ID_PRODUCTO = p_CODPRODUCTO)
         WHERE ID_PUNTODEVENTA = p_CODPUNTODEVENTA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN*/
          RAISERROR('-20000 El punto de venta no existe', 16, 1);
	END
END
GO

IF OBJECT_ID('WSXML_SFG.SFGPUNTODEVENTA_GetTipoPersonaTributaria', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetTipoPersonaTributaria;
GO

CREATE PROCEDURE WSXML_SFG.SFGPUNTODEVENTA_GetTipoPersonaTributaria( 
	@p_CODPUNTODEVENTA          NUMERIC(22,0),
   @P_CODTIPOPERSONATRIBUTARIA NUMERIC(22,0) OUT
) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT @P_CODTIPOPERSONATRIBUTARIA = RS.CODTIPOPERSONATRIBUTARIA
      FROM WSXML_SFG.PUNTODEVENTA PV
     INNER JOIN WSXML_SFG.RAZONSOCIAL RS
        ON PV.CODRAZONSOCIAL = RS.ID_RAZONSOCIAL
     WHERE PV.ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
  END;
GO




