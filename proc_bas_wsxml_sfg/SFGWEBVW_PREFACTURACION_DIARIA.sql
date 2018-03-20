USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_PREFACTURACION_DIARIA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA */ 

-- Creates a new record in the VW_PREFACTURACION_DIARIA table
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_AddRecord(
    @p_ID_PREFACTURACION_DIARIA VARCHAR(4000),
    @p_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0),
    @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
    @p_TIPOARCHIVO NUMERIC(22,0),
    @p_FECHAARCHIVO DATETIME,
    @p_CDC NUMERIC(22,0),
    @p_CODPRODUCTO NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_CODTIPOPRODUCTO NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
    @p_CODREGIMEN NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_IDENTIFICACION NUMERIC(22,0),
    @p_DIGITOVERIFICACION NUMERIC(22,0),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_CODTIPOCONTRATOPDV NUMERIC(22,0),
    @p_CODALIADOESTRATEGICO NUMERIC(22,0),
    @p_CODCOMPANIA NUMERIC(22,0),
    @p_CODIGOGTECHPRODUCTO NVARCHAR(2000),
    @p_CODIGOGTECHPUNTODEVENTA NVARCHAR(2000),
    @p_NUMEROTERMINAL NVARCHAR(2000),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CODRAZONSOCIAL NUMERIC(22,0),
    @p_CODIGOAGRUPACIONGTECH NVARCHAR(2000),
    @p_CODIGO NVARCHAR(2000),
    @p_FECHACONTRATO DATETIME,
    @p_CODRANGOCOMISION NUMERIC(22,0),
    @p_CODCATEGORIAPAGO NUMERIC(22,0),
    @p_NUMINGRESOS NUMERIC(22,0),
    @p_INGRESOS NUMERIC(22,0),
    @p_NUMANULACIONES NUMERIC(22,0),
    @p_ANULACIONES NUMERIC(22,0),
    @p_INGRESOSVALIDOS NUMERIC(22,0),
    @p_IVAPRODUCTO NUMERIC(22,0),
    @p_INGRESOSBRUTOS NUMERIC(22,0),
    @p_COMISIONNOREDONDEO NUMERIC(22,0),
    @p_COMISION NUMERIC(22,0),
    @p_COMISIONANTICIPO NUMERIC(22,0),
    @p_ISCOMISIONANTICIPO NUMERIC(22,0),
    @p_IVACOMISION NUMERIC(22,0),
    @p_COMISIONBRUTA NUMERIC(22,0),
    @p_RETEFUENTE NUMERIC(22,0),
    @p_RETEICA NUMERIC(22,0),
    @p_RETEIVA NUMERIC(22,0),
    @p_RETECREE NUMERIC(22,0),
    @p_RETEUVT NUMERIC(22,0),
    @p_COMISIONNETA NUMERIC(22,0),
    @p_PREMIOSPAGADOS NUMERIC(22,0),
    @p_RETENCIONPREMIOS NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.VW_PREFACTURACION_DIARIA
        (
            ID_PREFACTURACION_DIARIA,
            ID_ENTRADAARCHIVOCONTROL,
            CODCICLOFACTURACIONPDV,
            TIPOARCHIVO,
            FECHAARCHIVO,
            CDC,
            CODPRODUCTO,
            CODPUNTODEVENTA,
            CODTIPOPRODUCTO,
            CODLINEADENEGOCIO,
            CODDETALLEFACTURACIONPDV,
            CODREGIMEN,
            CODAGRUPACIONPUNTODEVENTA,
            IDENTIFICACION,
            DIGITOVERIFICACION,
            CODCIUDAD,
            CODTIPOCONTRATOPDV,
            CODALIADOESTRATEGICO,
            CODCOMPANIA,
            CODIGOGTECHPRODUCTO,
            CODIGOGTECHPUNTODEVENTA,
            NUMEROTERMINAL,
            CODREDPDV,
            CODRAZONSOCIAL,
            CODIGOAGRUPACIONGTECH,
            CODIGO,
            FECHACONTRATO,
            CODRANGOCOMISION,
            CODCATEGORIAPAGO,
            NUMINGRESOS,
            INGRESOS,
            NUMANULACIONES,
            ANULACIONES,
            INGRESOSVALIDOS,
            IVAPRODUCTO,
            INGRESOSBRUTOS,
            COMISIONNOREDONDEO,
            COMISION,
            COMISIONANTICIPO,
            ISCOMISIONANTICIPO,
            IVACOMISION,
            COMISIONBRUTA,
            RETEFUENTE,
            RETEICA,
            RETEIVA,
            RETECREE,
            RETEUVT,
            COMISIONNETA,
            PREMIOSPAGADOS,
            RETENCIONPREMIOS
        )
    VALUES
        (
            @p_ID_PREFACTURACION_DIARIA,
            @p_ID_ENTRADAARCHIVOCONTROL,
            @p_CODCICLOFACTURACIONPDV,
            @p_TIPOARCHIVO,
            @p_FECHAARCHIVO,
            @p_CDC,
            @p_CODPRODUCTO,
            @p_CODPUNTODEVENTA,
            @p_CODTIPOPRODUCTO,
            @p_CODLINEADENEGOCIO,
            @p_CODDETALLEFACTURACIONPDV,
            @p_CODREGIMEN,
            @p_CODAGRUPACIONPUNTODEVENTA,
            @p_IDENTIFICACION,
            @p_DIGITOVERIFICACION,
            @p_CODCIUDAD,
            @p_CODTIPOCONTRATOPDV,
            @p_CODALIADOESTRATEGICO,
            @p_CODCOMPANIA,
            @p_CODIGOGTECHPRODUCTO,
            @p_CODIGOGTECHPUNTODEVENTA,
            @p_NUMEROTERMINAL,
            @p_CODREDPDV,
            @p_CODRAZONSOCIAL,
            @p_CODIGOAGRUPACIONGTECH,
            @p_CODIGO,
            @p_FECHACONTRATO,
            @p_CODRANGOCOMISION,
            @p_CODCATEGORIAPAGO,
            @p_NUMINGRESOS,
            @p_INGRESOS,
            @p_NUMANULACIONES,
            @p_ANULACIONES,
            @p_INGRESOSVALIDOS,
            @p_IVAPRODUCTO,
            @p_INGRESOSBRUTOS,
            @p_COMISIONNOREDONDEO,
            @p_COMISION,
            @p_COMISIONANTICIPO,
            @p_ISCOMISIONANTICIPO,
            @p_IVACOMISION,
            @p_COMISIONBRUTA,
            @p_RETEFUENTE,
            @p_RETEICA,
            @p_RETEIVA,
            @p_RETECREE,
            @p_RETEUVT,
            @p_COMISIONNETA,
            @p_PREMIOSPAGADOS,
            @p_RETENCIONPREMIOS
        );

END;
GO

-- Updates a record in the VW_PREFACTURACION_DIARIA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_UpdateRecord(
        @p_ID_PREFACTURACION_DIARIA VARCHAR(4000),
@pk_ID_PREFACTURACION_DIARIA VARCHAR(4000),
    @p_ID_ENTRADAARCHIVOCONTROL NUMERIC(22,0),
    @p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
    @p_TIPOARCHIVO NUMERIC(22,0),
    @p_FECHAARCHIVO DATETIME,
    @p_CDC NUMERIC(22,0),
    @p_CODPRODUCTO NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_CODTIPOPRODUCTO NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
    @p_CODREGIMEN NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_IDENTIFICACION NUMERIC(22,0),
    @p_DIGITOVERIFICACION NUMERIC(22,0),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_CODTIPOCONTRATOPDV NUMERIC(22,0),
    @p_CODALIADOESTRATEGICO NUMERIC(22,0),
    @p_CODCOMPANIA NUMERIC(22,0),
    @p_CODIGOGTECHPRODUCTO NVARCHAR(2000),
    @p_CODIGOGTECHPUNTODEVENTA NVARCHAR(2000),
    @p_NUMEROTERMINAL NVARCHAR(2000),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CODRAZONSOCIAL NUMERIC(22,0),
    @p_CODIGOAGRUPACIONGTECH NVARCHAR(2000),
    @p_CODIGO NVARCHAR(2000),
    @p_FECHACONTRATO DATETIME,
    @p_CODRANGOCOMISION NUMERIC(22,0),
    @p_CODCATEGORIAPAGO NUMERIC(22,0),
    @p_NUMINGRESOS NUMERIC(22,0),
    @p_INGRESOS NUMERIC(22,0),
    @p_NUMANULACIONES NUMERIC(22,0),
    @p_ANULACIONES NUMERIC(22,0),
    @p_INGRESOSVALIDOS NUMERIC(22,0),
    @p_IVAPRODUCTO NUMERIC(22,0),
    @p_INGRESOSBRUTOS NUMERIC(22,0),
    @p_COMISIONNOREDONDEO NUMERIC(22,0),
    @p_COMISION NUMERIC(22,0),
    @p_COMISIONANTICIPO NUMERIC(22,0),
    @p_ISCOMISIONANTICIPO NUMERIC(22,0),
    @p_IVACOMISION NUMERIC(22,0),
    @p_COMISIONBRUTA NUMERIC(22,0),
    @p_RETEFUENTE NUMERIC(22,0),
    @p_RETEICA NUMERIC(22,0),
    @p_RETEIVA NUMERIC(22,0),
    @p_RETECREE NUMERIC(22,0),
    @p_RETEUVT NUMERIC(22,0),
    @p_COMISIONNETA NUMERIC(22,0),
    @p_PREMIOSPAGADOS NUMERIC(22,0),
    @p_RETENCIONPREMIOS NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.VW_PREFACTURACION_DIARIA
    SET
            ID_PREFACTURACION_DIARIA = @p_ID_PREFACTURACION_DIARIA,
            ID_ENTRADAARCHIVOCONTROL = @p_ID_ENTRADAARCHIVOCONTROL,
            CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV,
            TIPOARCHIVO = @p_TIPOARCHIVO,
            FECHAARCHIVO = @p_FECHAARCHIVO,
            CDC = @p_CDC,
            CODPRODUCTO = @p_CODPRODUCTO,
            CODPUNTODEVENTA = @p_CODPUNTODEVENTA,
            CODTIPOPRODUCTO = @p_CODTIPOPRODUCTO,
            CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO,
            CODDETALLEFACTURACIONPDV = @p_CODDETALLEFACTURACIONPDV,
            CODREGIMEN = @p_CODREGIMEN,
            CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA,
            IDENTIFICACION = @p_IDENTIFICACION,
            DIGITOVERIFICACION = @p_DIGITOVERIFICACION,
            CODCIUDAD = @p_CODCIUDAD,
            CODTIPOCONTRATOPDV = @p_CODTIPOCONTRATOPDV,
            CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO,
            CODCOMPANIA = @p_CODCOMPANIA,
            CODIGOGTECHPRODUCTO = @p_CODIGOGTECHPRODUCTO,
            CODIGOGTECHPUNTODEVENTA = @p_CODIGOGTECHPUNTODEVENTA,
            NUMEROTERMINAL = @p_NUMEROTERMINAL,
            CODREDPDV = @p_CODREDPDV,
            CODRAZONSOCIAL = @p_CODRAZONSOCIAL,
            CODIGOAGRUPACIONGTECH = @p_CODIGOAGRUPACIONGTECH,
            CODIGO = @p_CODIGO,
            FECHACONTRATO = @p_FECHACONTRATO,
            CODRANGOCOMISION = @p_CODRANGOCOMISION,
            CODCATEGORIAPAGO = @p_CODCATEGORIAPAGO,
            NUMINGRESOS = @p_NUMINGRESOS,
            INGRESOS = @p_INGRESOS,
            NUMANULACIONES = @p_NUMANULACIONES,
            ANULACIONES = @p_ANULACIONES,
            INGRESOSVALIDOS = @p_INGRESOSVALIDOS,
            IVAPRODUCTO = @p_IVAPRODUCTO,
            INGRESOSBRUTOS = @p_INGRESOSBRUTOS,
            COMISIONNOREDONDEO = @p_COMISIONNOREDONDEO,
            COMISION = @p_COMISION,
            COMISIONANTICIPO = @p_COMISIONANTICIPO,
            ISCOMISIONANTICIPO = @p_ISCOMISIONANTICIPO,
            IVACOMISION = @p_IVACOMISION,
            COMISIONBRUTA = @p_COMISIONBRUTA,
            RETEFUENTE = @p_RETEFUENTE,
            RETEICA = @p_RETEICA,
            RETEIVA = @p_RETEIVA,
            RETECREE = @p_RETECREE,
            RETEUVT = @p_RETEUVT,
            COMISIONNETA = @p_COMISIONNETA,
            PREMIOSPAGADOS = @p_PREMIOSPAGADOS,
            RETENCIONPREMIOS = @p_RETENCIONPREMIOS
    WHERE ID_PREFACTURACION_DIARIA = @pk_ID_PREFACTURACION_DIARIA;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

END;
GO

-- Deletes a record from the VW_PREFACTURACION_DIARIA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DeleteRecord(
    @pk_ID_PREFACTURACION_DIARIA VARCHAR(4000)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_PREFACTURACION_DIARIA
    WHERE ID_PREFACTURACION_DIARIA = @pk_ID_PREFACTURACION_DIARIA;
END;
GO

-- Deletes the set of rows from the VW_PREFACTURACION_DIARIA table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DeleteRecords(
    @p_where_str NVARCHAR(2000),
    @p_num_deleted NUMERIC(22,0) OUT
    )
AS
BEGIN
    DECLARE @l_where_str NVARCHAR(MAX);
    DECLARE @l_query_str NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Initialize the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL
    BEGIN
        SET @l_where_str = ' WHERE ' + isnull(@p_where_str, '');
    END 

    SET @p_num_deleted = 0;

    -- Set up the query string
    SET @l_query_str =
'DELETE WSXML_SFG.VW_PREFACTURACION_DIARIA' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_PREFACTURACION_DIARIA table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetRecord(
   @pk_ID_PREFACTURACION_DIARIA VARCHAR(4000)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_PREFACTURACION_DIARIA
    WHERE ID_PREFACTURACION_DIARIA = @pk_ID_PREFACTURACION_DIARIA;

    IF @l_count = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
         SELECT
        ID_PREFACTURACION_DIARIA,
        ID_ENTRADAARCHIVOCONTROL,
        CODCICLOFACTURACIONPDV,
        TIPOARCHIVO,
        FECHAARCHIVO,
        CDC,
        CODPRODUCTO,
        CODPUNTODEVENTA,
        CODTIPOPRODUCTO,
        CODLINEADENEGOCIO,
        CODDETALLEFACTURACIONPDV,
        CODREGIMEN,
        CODAGRUPACIONPUNTODEVENTA,
        IDENTIFICACION,
        DIGITOVERIFICACION,
        CODCIUDAD,
        CODTIPOCONTRATOPDV,
        CODALIADOESTRATEGICO,
        CODCOMPANIA,
        CODIGOGTECHPRODUCTO,
        CODIGOGTECHPUNTODEVENTA,
        NUMEROTERMINAL,
        CODREDPDV,
        CODRAZONSOCIAL,
        CODIGOAGRUPACIONGTECH,
        CODIGO,
        FECHACONTRATO,
        CODRANGOCOMISION,
        CODCATEGORIAPAGO,
        NUMINGRESOS,
        INGRESOS,
        NUMANULACIONES,
        ANULACIONES,
        INGRESOSVALIDOS,
        IVAPRODUCTO,
        INGRESOSBRUTOS,
        COMISIONNOREDONDEO,
        COMISION,
        COMISIONANTICIPO,
        ISCOMISIONANTICIPO,
        IVACOMISION,
        COMISIONBRUTA,
        RETEFUENTE,
        RETEICA,
        RETEIVA,
        RETECREE,
        RETEUVT,
        COMISIONNETA,
        PREMIOSPAGADOS,
        RETENCIONPREMIOS
    FROM WSXML_SFG.VW_PREFACTURACION_DIARIA
    WHERE ID_PREFACTURACION_DIARIA = @pk_ID_PREFACTURACION_DIARIA;  
END;
GO

-- Returns a query resultset from table VW_PREFACTURACION_DIARIA
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetList(
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
    @p_batch_size INTEGER,
   @p_total_size INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_query_cols VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_count_query NVARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the from string as the base table.
    SET @l_from_str = 'WSXML_SFG.VW_PREFACTURACION_DIARIA VW_PREFACTURACION_DIARIA_';
    SET @l_alias_str = 'VW_PREFACTURACION_DIARIA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
        IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0
    BEGIN
        SET @l_count_query =
            'SELECT @p_total_size = count(*) ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
            isnull(@l_where_str, '') + ' ';

        -- Run the count query
        EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
        @p_total_size output;
    END 

    -- Set up column name variable(s)
    SET @l_query_cols =
        'VW_PREFACTURACION_DIARIA_.ID_PREFACTURACION_DIARIA,
            VW_PREFACTURACION_DIARIA_.ID_ENTRADAARCHIVOCONTROL,
            VW_PREFACTURACION_DIARIA_.CODCICLOFACTURACIONPDV,
            VW_PREFACTURACION_DIARIA_.TIPOARCHIVO,
            VW_PREFACTURACION_DIARIA_.FECHAARCHIVO,
            VW_PREFACTURACION_DIARIA_.CDC,
            VW_PREFACTURACION_DIARIA_.CODPRODUCTO,
            VW_PREFACTURACION_DIARIA_.CODPUNTODEVENTA,
            VW_PREFACTURACION_DIARIA_.CODTIPOPRODUCTO,
            VW_PREFACTURACION_DIARIA_.CODLINEADENEGOCIO,
            VW_PREFACTURACION_DIARIA_.CODDETALLEFACTURACIONPDV,
            VW_PREFACTURACION_DIARIA_.CODREGIMEN,
            VW_PREFACTURACION_DIARIA_.CODAGRUPACIONPUNTODEVENTA,
            VW_PREFACTURACION_DIARIA_.IDENTIFICACION,
            VW_PREFACTURACION_DIARIA_.DIGITOVERIFICACION,
            VW_PREFACTURACION_DIARIA_.CODCIUDAD,
            VW_PREFACTURACION_DIARIA_.CODTIPOCONTRATOPDV,
            VW_PREFACTURACION_DIARIA_.CODALIADOESTRATEGICO,
            VW_PREFACTURACION_DIARIA_.CODCOMPANIA,
            VW_PREFACTURACION_DIARIA_.CODIGOGTECHPRODUCTO,
            VW_PREFACTURACION_DIARIA_.CODIGOGTECHPUNTODEVENTA,
            VW_PREFACTURACION_DIARIA_.NUMEROTERMINAL,
            VW_PREFACTURACION_DIARIA_.CODREDPDV,
            VW_PREFACTURACION_DIARIA_.CODRAZONSOCIAL,
            VW_PREFACTURACION_DIARIA_.CODIGOAGRUPACIONGTECH,
            VW_PREFACTURACION_DIARIA_.CODIGO,
            VW_PREFACTURACION_DIARIA_.FECHACONTRATO,
            VW_PREFACTURACION_DIARIA_.CODRANGOCOMISION,
            VW_PREFACTURACION_DIARIA_.CODCATEGORIAPAGO,
            VW_PREFACTURACION_DIARIA_.NUMINGRESOS,
            VW_PREFACTURACION_DIARIA_.INGRESOS,
            VW_PREFACTURACION_DIARIA_.NUMANULACIONES,
            VW_PREFACTURACION_DIARIA_.ANULACIONES,
            VW_PREFACTURACION_DIARIA_.INGRESOSVALIDOS,
            VW_PREFACTURACION_DIARIA_.IVAPRODUCTO,
            VW_PREFACTURACION_DIARIA_.INGRESOSBRUTOS,
            VW_PREFACTURACION_DIARIA_.COMISIONNOREDONDEO,
            VW_PREFACTURACION_DIARIA_.COMISION,
            VW_PREFACTURACION_DIARIA_.COMISIONANTICIPO,
            VW_PREFACTURACION_DIARIA_.ISCOMISIONANTICIPO,
            VW_PREFACTURACION_DIARIA_.IVACOMISION,
            VW_PREFACTURACION_DIARIA_.COMISIONBRUTA,
            VW_PREFACTURACION_DIARIA_.RETEFUENTE,
            VW_PREFACTURACION_DIARIA_.RETEICA,
            VW_PREFACTURACION_DIARIA_.RETEIVA,
            VW_PREFACTURACION_DIARIA_.RETECREE,
            VW_PREFACTURACION_DIARIA_.RETEUVT,
            VW_PREFACTURACION_DIARIA_.COMISIONNETA,
            VW_PREFACTURACION_DIARIA_.PREMIOSPAGADOS,
            VW_PREFACTURACION_DIARIA_.RETENCIONPREMIOS';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_PREFACTURACION_DIARIA_.ID_PREFACTURACION_DIARIA ASC ';

        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        'SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ( SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
                isnull(@l_query_cols, '') + ' ' +
 ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT /*+ push_pred(VW_PREFACTURACION_DIARIA_) */ ' +
                    isnull(@l_query_cols, '') + ' ' +
 ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT',@l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_PREFACTURACION_DIARIA
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_DrillDown(
    @p_select_str NVARCHAR(2000),
    @p_is_distinct INTEGER,
    @p_select_str_b NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
    @p_batch_size INTEGER,
   @p_total_size INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_select_b VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_count_query NVARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the from string as the base table.
	SET @l_query_select = @p_select_str;
    SET @l_from_str = 'WSXML_SFG.VW_PREFACTURACION_DIARIA VW_PREFACTURACION_DIARIA_';
    SET @l_alias_str = 'VW_PREFACTURACION_DIARIA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0
    BEGIN
        IF @p_is_distinct = 0
        BEGIN
            SET @l_count_query =
                'SELECT @p_total_size = count(*) FROM ( SELECT ' + isnull(@p_select_str, '') + ' ' +
                'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str + ' ' +
                isnull(@l_where_str, '') + ' ) countAlias', '');
        END
        ELSE BEGIN
            SET @l_count_query =
                'SELECT @p_total_size = COUNT(*) FROM ( SELECT DISTINCT ' + isnull(@p_select_str, '') + ', 1 As count1  ' +
                'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
                isnull(@l_where_str, '') + ' ) pass1 ';
        END 
    END
    ELSE BEGIN
        SET @l_count_query = ' ';
    END 

    -- Run the count query
    EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
    @p_total_size output;

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ' + @l_query_select;
        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        IF @p_is_distinct = 0
        BEGIN
            SET @l_query_select_b = @p_select_str_b;
        END
        ELSE BEGIN
            SET @l_query_select_b = 'DISTINCT ' + isnull(@p_select_str_b, '');
        END 

        -- Run the query
        SET @sql = 
        'SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
                isnull(@l_query_select, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT /*+ push_pred(VW_PREFACTURACION_DIARIA_) */ ' +
                    isnull(@l_query_select_b, '') + ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_PREFACTURACION_DIARIA
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_GetStats(
    @p_select_str NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
   @p_batch_size INTEGER

    )
AS
BEGIN
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_stat_col VARCHAR(MAX);
    DECLARE @l_select_col VARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Extract the col only that we need to run statistics on.
    -- First extract the content in the function call.
    SET @l_stat_col = @p_select_str;
    SET @l_stat_col = SUBSTRING(@l_stat_col,
                CHARINDEX('(', @l_stat_col) + 1,
                CHARINDEX(')', @l_stat_col) - CHARINDEX('(', @l_stat_col) - 1);

    -- Then extract the column from the distinct clause.
    SET @l_stat_col = LTRIM(RTRIM(@l_stat_col));
    IF CHARINDEX('DISTINCT ', UPPER(@l_stat_col)) = 1
    BEGIN
        SET @l_stat_col = SUBSTRING(@l_stat_col, CHARINDEX(' ', @l_stat_col) + 1, LEN(@l_stat_col));
    END 

    -- Get the select column name without alias.
SET @l_query_select = @l_stat_col;
SET @l_select_col = @l_stat_col;
IF CHARINDEX(' ', @l_stat_col) > 0
BEGIN
SET @l_stat_col = SUBSTRING(@l_stat_col, 0, CHARINDEX(' ', @l_stat_col));
SET @l_select_col = @l_stat_col;
END


    -- Set up the from string as the base table.

    SET @l_from_str = 'WSXML_SFG.VW_PREFACTURACION_DIARIA VW_PREFACTURACION_DIARIA_';
    SET @l_alias_str = 'VW_PREFACTURACION_DIARIA_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ' + @l_stat_col;
        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        'SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
                isnull(@l_stat_col, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT /*+ push_pred(VW_PREFACTURACION_DIARIA_) */ ' +
                    isnull(@l_select_col, '') + ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT',@l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PREFACTURACION_DIARIA_Export(
    @p_separator_str NVARCHAR(2000),
    @p_title_str NVARCHAR(2000),
    @p_select_str NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
   @p_num_exported INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_title_str VARCHAR(MAX);
    DECLARE @l_select_str VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_union VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the title string from the column names.  Excel
    -- will complain if the first column value is ID. So wrap
    -- the value with .
    SET @l_title_str = isnull(@p_title_str, '') + isnull(char(13), '');
    IF @p_title_str IS NULL
    BEGIN
        SET @l_title_str =
                '''XID_PREFACTURACION_DIARIA' + isnull(@p_separator_str, '') +
                'XID_ENTRADAARCHIVOCONTROL' + isnull(@p_separator_str, '') +
                'XID_ENTRADAARCHIVOCONTROL NOMARCHIVO' + isnull(@p_separator_str, '') +
                'CODCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODCICLOFACTURACIONPDV NOMCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'TIPOARCHIVO' + isnull(@p_separator_str, '') +
                'TIPOARCHIVO NOMSERVICIO' + isnull(@p_separator_str, '') +
                'FECHAARCHIVO' + isnull(@p_separator_str, '') +
                'CDC' + isnull(@p_separator_str, '') +
                'CODPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPRODUCTO NOMPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO NOMTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMCORTOLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODDETALLEFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODREGIMEN' + isnull(@p_separator_str, '') +
                'CODREGIMEN NOMREGIMEN' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'CODCIUDAD' + isnull(@p_separator_str, '') +
                'CODTIPOCONTRATOPDV' + isnull(@p_separator_str, '') +
                'CODTIPOCONTRATOPDV NOMTIPOCONTRATOPDV' + isnull(@p_separator_str, '') +
                'CODALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'CODCOMPANIA' + isnull(@p_separator_str, '') +
                'CODCOMPANIA CODIGO' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPRODUCTO' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMEROTERMINAL' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'CODRAZONSOCIAL NOMRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'CODIGOAGRUPACIONGTECH' + isnull(@p_separator_str, '') +
                'CODIGO' + isnull(@p_separator_str, '') +
                'FECHACONTRATO' + isnull(@p_separator_str, '') +
                'CODRANGOCOMISION' + isnull(@p_separator_str, '') +
                'CODRANGOCOMISION NOMRANGOCOMISION' + isnull(@p_separator_str, '') +
                'CODCATEGORIAPAGO' + isnull(@p_separator_str, '') +
                'NUMINGRESOS' + isnull(@p_separator_str, '') +
                'INGRESOS' + isnull(@p_separator_str, '') +
                'NUMANULACIONES' + isnull(@p_separator_str, '') +
                'ANULACIONES' + isnull(@p_separator_str, '') +
                'INGRESOSVALIDOS' + isnull(@p_separator_str, '') +
                'IVAPRODUCTO' + isnull(@p_separator_str, '') +
                'INGRESOSBRUTOS' + isnull(@p_separator_str, '') +
                'COMISIONNOREDONDEO' + isnull(@p_separator_str, '') +
                'COMISION' + isnull(@p_separator_str, '') +
                'COMISIONANTICIPO' + isnull(@p_separator_str, '') +
                'ISCOMISIONANTICIPO' + isnull(@p_separator_str, '') +
                'IVACOMISION' + isnull(@p_separator_str, '') +
                'COMISIONBRUTA' + isnull(@p_separator_str, '') +
                'RETEFUENTE' + isnull(@p_separator_str, '') +
                'RETEICA' + isnull(@p_separator_str, '') +
                'RETEIVA' + isnull(@p_separator_str, '') +
                'RETECREE' + isnull(@p_separator_str, '') +
                'RETEUVT' + isnull(@p_separator_str, '') +
                'COMISIONNETA' + isnull(@p_separator_str, '') +
                'PREMIOSPAGADOS' + isnull(@p_separator_str, '') +
                'RETENCIONPREMIOS' + ' ''';
    END 

    IF SUBSTRING(@l_title_str, 1, 2) = 'ID'
    BEGIN
        SET @l_title_str =
            '' +
            ISNULL(SUBSTRING(@l_title_str, 1, CHARINDEX(',', @l_title_str)-1), '') +
            '' +
            ISNULL(SUBSTRING(@l_title_str, CHARINDEX(',', @l_title_str), LEN(@l_title_str)), '');
    END 

    -- Set up the select string
    SET @l_select_str = @p_select_str;
    IF @p_select_str IS NULL
    BEGIN
        SET @l_select_str =
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PREFACTURACION_DIARIA_.ID_PREFACTURACION_DIARIA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.ID_ENTRADAARCHIVOCONTROL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMARCHIVO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODCICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMCICLOFACTURACIONPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.TIPOARCHIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMSERVICIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_PREFACTURACION_DIARIA_.FECHAARCHIVO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.CDC, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t4.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODTIPOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMTIPOPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMCORTOLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODDETALLEFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODREGIMEN AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t7.NOMREGIMEN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODTIPOCONTRATOPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t8.NOMTIPOCONTRATOPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODALIADOESTRATEGICO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODCOMPANIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t9.CODIGO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PREFACTURACION_DIARIA_.CODIGOGTECHPRODUCTO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PREFACTURACION_DIARIA_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PREFACTURACION_DIARIA_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODRAZONSOCIAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t10.NOMRAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PREFACTURACION_DIARIA_.CODIGOAGRUPACIONGTECH) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PREFACTURACION_DIARIA_.CODIGO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_PREFACTURACION_DIARIA_.FECHACONTRATO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODRANGOCOMISION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t11.NOMRANGOCOMISION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.CODCATEGORIAPAGO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.NUMINGRESOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.INGRESOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.NUMANULACIONES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.ANULACIONES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PREFACTURACION_DIARIA_.INGRESOSVALIDOS AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.IVAPRODUCTO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.INGRESOSBRUTOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.COMISIONNOREDONDEO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.COMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.COMISIONANTICIPO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.ISCOMISIONANTICIPO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.IVACOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.COMISIONBRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.RETEFUENTE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.RETEICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.RETEIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.RETECREE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.RETEUVT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.COMISIONNETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.PREMIOSPAGADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PREFACTURACION_DIARIA_.RETENCIONPREMIOS, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_PREFACTURACION_DIARIA VW_PREFACTURACION_DIARIA_ LEFT OUTER JOIN WSXML_SFG.VWC_ARCHIVOCONTROL t0 ON (VW_PREFACTURACION_DIARIA_.ID_ENTRADAARCHIVOCONTROL =  t0.ID_ENTRADAARCHIVOCONTROL) LEFT OUTER JOIN WSXML_SFG.VWC_CICLOFACTURACION t1 ON (VW_PREFACTURACION_DIARIA_.CODCICLOFACTURACIONPDV =  t1.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.SERVICIO t2 ON (VW_PREFACTURACION_DIARIA_.TIPOARCHIVO =  t2.ID_SERVICIO) LEFT OUTER JOIN WSXML_SFG.PRODUCTO t3 ON (VW_PREFACTURACION_DIARIA_.CODPRODUCTO =  t3.ID_PRODUCTO) LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA t4 ON (VW_PREFACTURACION_DIARIA_.CODPUNTODEVENTA =  t4.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO t5 ON (VW_PREFACTURACION_DIARIA_.CODTIPOPRODUCTO =  t5.ID_TIPOPRODUCTO) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t6 ON (VW_PREFACTURACION_DIARIA_.CODLINEADENEGOCIO =  t6.ID_LINEADENEGOCIO) LEFT OUTER JOIN WSXML_SFG.REGIMEN t7 ON (VW_PREFACTURACION_DIARIA_.CODREGIMEN =  t7.ID_REGIMEN) LEFT OUTER JOIN WSXML_SFG.TIPOCONTRATOPDV t8 ON (VW_PREFACTURACION_DIARIA_.CODTIPOCONTRATOPDV =  t8.ID_TIPOCONTRATOPDV) LEFT OUTER JOIN WSXML_SFG.COMPANIA t9 ON (VW_PREFACTURACION_DIARIA_.CODCOMPANIA =  t9.ID_COMPANIA) LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL t10 ON (VW_PREFACTURACION_DIARIA_.CODRAZONSOCIAL =  t10.ID_RAZONSOCIAL) LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION t11 ON (VW_PREFACTURACION_DIARIA_.CODRANGOCOMISION =  t11.ID_RANGOCOMISION)';

    SET @l_join_str = @p_join_str;
    IF @p_join_str IS NULL
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL
    BEGIN
        SET @l_where_str = isnull(@l_where_str, '') + 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Construct the query string.  Append the result set with the title.
    SET @l_query_select =
'SELECT ';
    SET @l_query_union =
' UNION ALL ' +
            'SELECT ';
    SET @l_query_from =
            ' FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
            isnull(@l_where_str, '');

    -- Run the query
    SET @sql = 
    (' '+isnull(@l_query_select, '') + isnull(@l_title_str, '') + isnull(@l_query_union, '') + isnull(@l_select_str, '')+ isnull(@l_query_from, '')+' ');
    EXECUTE sp_executesql @sql;

END;
GO






