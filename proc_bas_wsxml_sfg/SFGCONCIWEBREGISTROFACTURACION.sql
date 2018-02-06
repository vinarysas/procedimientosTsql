USE SFGPRODU;
--  DDL for Package Body SFGCONCIWEBREGISTROFACTURACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION */ 

-- Creates a new record in the REGISTROFACTURACION table
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_AddRecord(
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_CODPRODUCTO NUMERIC(22,0),
    @p_CODRANGOCOMISION NUMERIC(22,0),
    @p_FECHATRANSACCION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_ACTIVE NUMERIC(22,0),
    @p_VALORTRANSACCION FLOAT,
    @p_VALORCOMISION FLOAT,
    @p_VALORVENTANETA FLOAT,
    @p_CODTIPOREGISTRO NUMERIC(22,0),
    @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
    @p_NUMTRANSACCIONES NUMERIC(22,0),
    @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
    @p_CODREGISTROANULACION NUMERIC(22,0),
    @p_VALORCOMISIONNETA FLOAT,
    @p_FACTURADO NUMERIC(22,0),
    @p_VALORVENTABRUTA FLOAT,
    @p_IVACOMISION FLOAT,
    @p_VALORCOMISIONBRUTA FLOAT,
    @p_COMISIONANTICIPO NUMERIC(22,0),
    @p_RETENCIONPREMIO FLOAT,
    @p_CODCATEGORIAPAGO NUMERIC(22,0),
    @p_CODREGIMEN NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_IDENTIFICACION NUMERIC(22,0),
    @p_DIGITOVERIFICACION NUMERIC(22,0),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_VALORVAT FLOAT,
    @p_CODCOMPANIA NUMERIC(22,0),
    @p_CODTIPOCONTRATOPDV NUMERIC(22,0),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CODRAZONSOCIAL NUMERIC(22,0),
    @p_CODTIPOCONTRATOPRODUCTO NUMERIC(22,0),
    @p_VALORCOMISIONNOREDONDEADO FLOAT,
    @p_VALORVENTABRUTANOREDONDEADO FLOAT,
    @p_ID_REGISTROFACTURACION_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.REGISTROFACTURACION
        (
            CODPUNTODEVENTA,
            CODPRODUCTO,
            CODRANGOCOMISION,
            FECHATRANSACCION,
            CODUSUARIOMODIFICACION,
            VALORTRANSACCION,
            CODTIPOREGISTRO,
            CODDETALLEFACTURACIONPDV,
            CODENTRADAARCHIVOCONTROL,
            CODREGISTROANULACION,
            CODCATEGORIAPAGO,
            CODREGIMEN,
            CODAGRUPACIONPUNTODEVENTA,
            IDENTIFICACION,
            DIGITOVERIFICACION,
            CODCIUDAD,
            CODCOMPANIA,
            CODREDPDV,
            CODRAZONSOCIAL,
            CODTIPOCONTRATOPRODUCTO
        )
    VALUES
        (
            @p_CODPUNTODEVENTA,
            @p_CODPRODUCTO,
            @p_CODRANGOCOMISION,
            @p_FECHATRANSACCION,
            @p_CODUSUARIOMODIFICACION,
            @p_VALORTRANSACCION,
            @p_CODTIPOREGISTRO,
            @p_CODDETALLEFACTURACIONPDV,
            @p_CODENTRADAARCHIVOCONTROL,
            @p_CODREGISTROANULACION,
            @p_CODCATEGORIAPAGO,
            @p_CODREGIMEN,
            @p_CODAGRUPACIONPUNTODEVENTA,
            @p_IDENTIFICACION,
            @p_DIGITOVERIFICACION,
            @p_CODCIUDAD,
            @p_CODCOMPANIA,
            @p_CODREDPDV,
            @p_CODRAZONSOCIAL,
            @p_CODTIPOCONTRATOPRODUCTO
        );
       SET
            @p_ID_REGISTROFACTURACION_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET ACTIVE = @p_ACTIVE WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORCOMISION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORCOMISION = @p_VALORCOMISION WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORVENTANETA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORVENTANETA = @p_VALORVENTANETA WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_NUMTRANSACCIONES IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET NUMTRANSACCIONES = @p_NUMTRANSACCIONES WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORCOMISIONNETA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORCOMISIONNETA = @p_VALORCOMISIONNETA WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_FACTURADO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET FACTURADO = @p_FACTURADO WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORVENTABRUTA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORVENTABRUTA = @p_VALORVENTABRUTA WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_IVACOMISION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET IVACOMISION = @p_IVACOMISION WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORCOMISIONBRUTA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORCOMISIONBRUTA = @p_VALORCOMISIONBRUTA WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_COMISIONANTICIPO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET COMISIONANTICIPO = @p_COMISIONANTICIPO WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_RETENCIONPREMIO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET RETENCIONPREMIO = @p_RETENCIONPREMIO WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORVAT IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORVAT = @p_VALORVAT WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_CODTIPOCONTRATOPDV IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET CODTIPOCONTRATOPDV = @p_CODTIPOCONTRATOPDV WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORCOMISIONNOREDONDEADO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORCOMISIONNOREDONDEADO = @p_VALORCOMISIONNOREDONDEADO WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
    IF @p_VALORVENTABRUTANOREDONDEADO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORVENTABRUTANOREDONDEADO = @p_VALORVENTABRUTANOREDONDEADO WHERE ID_REGISTROFACTURACION = @p_ID_REGISTROFACTURACION_out;
    END 
END;
GO

-- Updates a record in the REGISTROFACTURACION table.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_UpdateRecord(
    @pk_ID_REGISTROFACTURACION NUMERIC(22,0),
    @p_CODPUNTODEVENTA NUMERIC(22,0),
    @p_CODPRODUCTO NUMERIC(22,0),
    @p_CODRANGOCOMISION NUMERIC(22,0),
    @p_FECHATRANSACCION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_ACTIVE NUMERIC(22,0),
    @p_VALORTRANSACCION FLOAT,
    @p_VALORCOMISION FLOAT,
    @p_VALORVENTANETA FLOAT,
    @p_CODTIPOREGISTRO NUMERIC(22,0),
    @p_CODDETALLEFACTURACIONPDV NUMERIC(22,0),
    @p_NUMTRANSACCIONES NUMERIC(22,0),
    @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
    @p_CODREGISTROANULACION NUMERIC(22,0),
    @p_VALORCOMISIONNETA FLOAT,
    @p_FACTURADO NUMERIC(22,0),
    @p_VALORVENTABRUTA FLOAT,
    @p_IVACOMISION FLOAT,
    @p_VALORCOMISIONBRUTA FLOAT,
    @p_COMISIONANTICIPO NUMERIC(22,0),
    @p_RETENCIONPREMIO FLOAT,
    @p_CODCATEGORIAPAGO NUMERIC(22,0),
    @p_CODREGIMEN NUMERIC(22,0),
    @p_CODAGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_IDENTIFICACION NUMERIC(22,0),
    @p_DIGITOVERIFICACION NUMERIC(22,0),
    @p_CODCIUDAD NUMERIC(22,0),
    @p_VALORVAT FLOAT,
    @p_CODCOMPANIA NUMERIC(22,0),
    @p_CODTIPOCONTRATOPDV NUMERIC(22,0),
    @p_CODREDPDV NUMERIC(22,0),
    @p_CODRAZONSOCIAL NUMERIC(22,0),
    @p_CODTIPOCONTRATOPRODUCTO NUMERIC(22,0),
    @p_VALORCOMISIONNOREDONDEADO FLOAT,
    @p_VALORVENTABRUTANOREDONDEADO FLOAT
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.REGISTROFACTURACION
    SET
            CODPUNTODEVENTA = @p_CODPUNTODEVENTA,
            CODPRODUCTO = @p_CODPRODUCTO,
            CODRANGOCOMISION = @p_CODRANGOCOMISION,
            FECHATRANSACCION = @p_FECHATRANSACCION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            ACTIVE = @p_ACTIVE,
            VALORTRANSACCION = @p_VALORTRANSACCION,
            VALORCOMISION = @p_VALORCOMISION,
            VALORVENTANETA = @p_VALORVENTANETA,
            CODTIPOREGISTRO = @p_CODTIPOREGISTRO,
            CODDETALLEFACTURACIONPDV = @p_CODDETALLEFACTURACIONPDV,
            NUMTRANSACCIONES = @p_NUMTRANSACCIONES,
            CODENTRADAARCHIVOCONTROL = @p_CODENTRADAARCHIVOCONTROL,
            CODREGISTROANULACION = @p_CODREGISTROANULACION,
            VALORCOMISIONNETA = @p_VALORCOMISIONNETA,
            FACTURADO = @p_FACTURADO,
            VALORVENTABRUTA = @p_VALORVENTABRUTA,
            IVACOMISION = @p_IVACOMISION,
            VALORCOMISIONBRUTA = @p_VALORCOMISIONBRUTA,
            COMISIONANTICIPO = @p_COMISIONANTICIPO,
            RETENCIONPREMIO = @p_RETENCIONPREMIO,
            CODCATEGORIAPAGO = @p_CODCATEGORIAPAGO,
            CODREGIMEN = @p_CODREGIMEN,
            CODAGRUPACIONPUNTODEVENTA = @p_CODAGRUPACIONPUNTODEVENTA,
            IDENTIFICACION = @p_IDENTIFICACION,
            DIGITOVERIFICACION = @p_DIGITOVERIFICACION,
            CODCIUDAD = @p_CODCIUDAD,
            VALORVAT = @p_VALORVAT,
            CODCOMPANIA = @p_CODCOMPANIA,
            CODTIPOCONTRATOPDV = @p_CODTIPOCONTRATOPDV,
            CODREDPDV = @p_CODREDPDV,
            CODRAZONSOCIAL = @p_CODRAZONSOCIAL,
            CODTIPOCONTRATOPRODUCTO = @p_CODTIPOCONTRATOPRODUCTO,
            VALORCOMISIONNOREDONDEADO = @p_VALORCOMISIONNOREDONDEADO,
            VALORVENTABRUTANOREDONDEADO = @p_VALORVENTABRUTANOREDONDEADO
    WHERE ID_REGISTROFACTURACION = @pk_ID_REGISTROFACTURACION;

    -- Make sure only one record is affected
    IF @@rowcount = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 
    IF @@rowcount > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

END;
GO

-- Deletes a record from the REGISTROFACTURACION table.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DeleteRecord(
    @pk_ID_REGISTROFACTURACION NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION = @pk_ID_REGISTROFACTURACION;
END;
GO

-- Deletes the set of rows from the REGISTROFACTURACION table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DeleteRecords(
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
'DELETE WSXML_SFG.REGISTROFACTURACION' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the REGISTROFACTURACION table.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetRecord(
   @pk_ID_REGISTROFACTURACION NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION = @pk_ID_REGISTROFACTURACION;

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
        ID_REGISTROFACTURACION,
        CODPUNTODEVENTA,
        CODPRODUCTO,
        CODRANGOCOMISION,
        FECHATRANSACCION,
        CODUSUARIOMODIFICACION,
        FECHAHORAMODIFICACION,
        ACTIVE,
        VALORTRANSACCION,
        VALORCOMISION,
        VALORVENTANETA,
        CODTIPOREGISTRO,
        CODDETALLEFACTURACIONPDV,
        NUMTRANSACCIONES,
        CODENTRADAARCHIVOCONTROL,
        CODREGISTROANULACION,
        VALORCOMISIONNETA,
        FACTURADO,
        VALORVENTABRUTA,
        IVACOMISION,
        VALORCOMISIONBRUTA,
        COMISIONANTICIPO,
        RETENCIONPREMIO,
        CODCATEGORIAPAGO,
        CODREGIMEN,
        CODAGRUPACIONPUNTODEVENTA,
        IDENTIFICACION,
        DIGITOVERIFICACION,
        CODCIUDAD,
        VALORVAT,
        CODCOMPANIA,
        CODTIPOCONTRATOPDV,
        CODREDPDV,
        CODRAZONSOCIAL,
        CODTIPOCONTRATOPRODUCTO,
        VALORCOMISIONNOREDONDEADO,
        VALORVENTABRUTANOREDONDEADO
    FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION = @pk_ID_REGISTROFACTURACION;  
END;
GO

-- Returns a query resultset from table REGISTROFACTURACION
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
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetList(
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
    SET @l_from_str = 'WSXML_SFG.REGISTROFACTURACION REGISTROFACTURACION_';
    SET @l_alias_str = 'REGISTROFACTURACION_';

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
        'REGISTROFACTURACION_.ID_REGISTROFACTURACION,
            REGISTROFACTURACION_.CODPUNTODEVENTA,
            REGISTROFACTURACION_.CODPRODUCTO,
            REGISTROFACTURACION_.CODRANGOCOMISION,
            REGISTROFACTURACION_.FECHATRANSACCION,
            REGISTROFACTURACION_.CODUSUARIOMODIFICACION,
            REGISTROFACTURACION_.FECHAHORAMODIFICACION,
            REGISTROFACTURACION_.ACTIVE,
            REGISTROFACTURACION_.VALORTRANSACCION,
            REGISTROFACTURACION_.VALORCOMISION,
            REGISTROFACTURACION_.VALORVENTANETA,
            REGISTROFACTURACION_.CODTIPOREGISTRO,
            REGISTROFACTURACION_.CODDETALLEFACTURACIONPDV,
            REGISTROFACTURACION_.NUMTRANSACCIONES,
            REGISTROFACTURACION_.CODENTRADAARCHIVOCONTROL,
            REGISTROFACTURACION_.CODREGISTROANULACION,
            REGISTROFACTURACION_.VALORCOMISIONNETA,
            REGISTROFACTURACION_.FACTURADO,
            REGISTROFACTURACION_.VALORVENTABRUTA,
            REGISTROFACTURACION_.IVACOMISION,
            REGISTROFACTURACION_.VALORCOMISIONBRUTA,
            REGISTROFACTURACION_.COMISIONANTICIPO,
            REGISTROFACTURACION_.RETENCIONPREMIO,
            REGISTROFACTURACION_.CODCATEGORIAPAGO,
            REGISTROFACTURACION_.CODREGIMEN,
            REGISTROFACTURACION_.CODAGRUPACIONPUNTODEVENTA,
            REGISTROFACTURACION_.IDENTIFICACION,
            REGISTROFACTURACION_.DIGITOVERIFICACION,
            REGISTROFACTURACION_.CODCIUDAD,
            REGISTROFACTURACION_.VALORVAT,
            REGISTROFACTURACION_.CODCOMPANIA,
            REGISTROFACTURACION_.CODTIPOCONTRATOPDV,
            REGISTROFACTURACION_.CODREDPDV,
            REGISTROFACTURACION_.CODRAZONSOCIAL,
            REGISTROFACTURACION_.CODTIPOCONTRATOPRODUCTO,
            REGISTROFACTURACION_.VALORCOMISIONNOREDONDEADO,
            REGISTROFACTURACION_.VALORVENTABRUTANOREDONDEADO';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY REGISTROFACTURACION_.ID_REGISTROFACTURACION ASC ';

        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_cols, '') + ' ' +
 ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
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
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table REGISTROFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.REGISTROFACTURACION REGISTROFACTURACION_';
    SET @l_alias_str = 'REGISTROFACTURACION_';

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
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_select, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
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

-- Returns a query result from table REGISTROFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.REGISTROFACTURACION REGISTROFACTURACION_';
    SET @l_alias_str = 'REGISTROFACTURACION_';

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
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_stat_col, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_select_col, '') + ' ' +
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
        'SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGCONCIWEBREGISTROFACTURACION_Export(
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
                '''XID_REGISTROFACTURACION' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPRODUCTO NOMPRODUCTO' + isnull(@p_separator_str, '') +
                'CODRANGOCOMISION' + isnull(@p_separator_str, '') +
                'CODRANGOCOMISION NOMRANGOCOMISION' + isnull(@p_separator_str, '') +
                'FECHATRANSACCION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'VALORTRANSACCION' + isnull(@p_separator_str, '') +
                'VALORCOMISION' + isnull(@p_separator_str, '') +
                'VALORVENTANETA' + isnull(@p_separator_str, '') +
                'CODTIPOREGISTRO' + isnull(@p_separator_str, '') +
                'CODTIPOREGISTRO NOMTIPOREGISTRO' + isnull(@p_separator_str, '') +
                'CODDETALLEFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'NUMTRANSACCIONES' + isnull(@p_separator_str, '') +
                'CODENTRADAARCHIVOCONTROL' + isnull(@p_separator_str, '') +
                'CODREGISTROANULACION' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA' + isnull(@p_separator_str, '') +
                'FACTURADO' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA' + isnull(@p_separator_str, '') +
                'IVACOMISION' + isnull(@p_separator_str, '') +
                'VALORCOMISIONBRUTA' + isnull(@p_separator_str, '') +
                'COMISIONANTICIPO' + isnull(@p_separator_str, '') +
                'RETENCIONPREMIO' + isnull(@p_separator_str, '') +
                'CODCATEGORIAPAGO' + isnull(@p_separator_str, '') +
                'CODCATEGORIAPAGO NOMCATEGORIAPAGO' + isnull(@p_separator_str, '') +
                'CODREGIMEN' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'CODCIUDAD' + isnull(@p_separator_str, '') +
                'VALORVAT' + isnull(@p_separator_str, '') +
                'CODCOMPANIA' + isnull(@p_separator_str, '') +
                'CODCOMPANIA NOMCOMPANIA' + isnull(@p_separator_str, '') +
                'CODTIPOCONTRATOPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV NOMREDPDV' + isnull(@p_separator_str, '') +
                'CODRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'CODRAZONSOCIAL NOMRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'CODTIPOCONTRATOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOCONTRATOPRODUCTO DESCRIPCION' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNOREDONDEADO' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTANOREDONDEADO' + ' ''';
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
                ' isnull(CAST(REGISTROFACTURACION_.ID_REGISTROFACTURACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t0.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODRANGOCOMISION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMRANGOCOMISION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(REGISTROFACTURACION_.FECHATRANSACCION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(REGISTROFACTURACION_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORTRANSACCION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORVENTANETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODTIPOREGISTRO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMTIPOREGISTRO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODDETALLEFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.NUMTRANSACCIONES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODENTRADAARCHIVOCONTROL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODREGISTROANULACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORCOMISIONNETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.FACTURADO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORVENTABRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.IVACOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORCOMISIONBRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.COMISIONANTICIPO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.RETENCIONPREMIO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODCATEGORIAPAGO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMCATEGORIAPAGO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODREGIMEN AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORVAT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODCOMPANIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMCOMPANIA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODTIPOCONTRATOPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMREDPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODRAZONSOCIAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t7.NOMRAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(REGISTROFACTURACION_.CODTIPOCONTRATOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t8.DESCRIPCION, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORCOMISIONNOREDONDEADO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(REGISTROFACTURACION_.VALORVENTABRUTANOREDONDEADO, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.REGISTROFACTURACION REGISTROFACTURACION_ LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA t0 ON (REGISTROFACTURACION_.CODPUNTODEVENTA =  t0.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.PRODUCTO t1 ON (REGISTROFACTURACION_.CODPRODUCTO =  t1.ID_PRODUCTO) LEFT OUTER JOIN WSXML_SFG.RANGOCOMISION t2 ON (REGISTROFACTURACION_.CODRANGOCOMISION =  t2.ID_RANGOCOMISION) LEFT OUTER JOIN WSXML_SFG.TIPOREGISTRO t3 ON (REGISTROFACTURACION_.CODTIPOREGISTRO =  t3.ID_TIPOREGISTRO) LEFT OUTER JOIN WSXML_SFG.CATEGORIAPAGO t4 ON (REGISTROFACTURACION_.CODCATEGORIAPAGO =  t4.ID_CATEGORIAPAGO) LEFT OUTER JOIN WSXML_SFG.COMPANIA t5 ON (REGISTROFACTURACION_.CODCOMPANIA =  t5.ID_COMPANIA) LEFT OUTER JOIN WSXML_SFG.REDPDV t6 ON (REGISTROFACTURACION_.CODREDPDV =  t6.ID_REDPDV) LEFT OUTER JOIN WSXML_SFG.RAZONSOCIAL t7 ON (REGISTROFACTURACION_.CODRAZONSOCIAL =  t7.ID_RAZONSOCIAL) LEFT OUTER JOIN WSXML_SFG.TIPOCONTRATOPRODUCTO t8 ON (REGISTROFACTURACION_.CODTIPOCONTRATOPRODUCTO =  t8.ID_TIPOCONTRATOPRODUCTO)';

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






