USE SFGPRODU;
--  DDL for Package Body SFGWEBDETALLEFACTURACIONPDV
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV */ 

-- Creates a new record in the DETALLEFACTURACIONPDV table
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_AddRecord(
    @p_CODMAESTROFACTURACIONPDV NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_CODPRODUCTO NUMERIC(22,0),
    @p_CANTIDADVENTA NUMERIC(22,0),
    @p_VALORVENTA FLOAT,
    @p_CANTIDADANULACION NUMERIC(22,0),
    @p_VALORANULACION FLOAT,
    @p_CANTIDADPREMIOPAGO NUMERIC(22,0),
    @p_VALORPREMIOPAGO FLOAT,
    @p_VALORCOMISION FLOAT,
    @p_RETENCIONPREMIOSPAGADOS FLOAT,
    @p_ACTIVE NUMERIC(22,0),
    @p_AJUSTE FLOAT,
    @p_VALORCOMISIONNETA FLOAT,
    @p_VALORVENTANETA FLOAT,
    @p_CANTIDADGRATUITO NUMERIC(22,0),
    @p_VALORGRATUITO FLOAT,
    @p_NUEVOSALDOENCONTRAGTECH FLOAT,
    @p_NUEVOSALDOENCONTRAFIDUCIA FLOAT,
    @p_NUEVOSALDOAFAVORGTECH FLOAT,
    @p_NUEVOSALDOAFAVORFIDUCIA FLOAT,
    @p_IVACOMISION FLOAT,
    @p_VALORVENTABRUTA FLOAT,
    @p_VALORCOMISIONBRUTA FLOAT,
    @p_CODTIPOPRODUCTO NUMERIC(22,0),
    @p_COMISIONANTICIPO NUMERIC(22,0),
    @p_CODRANGOCOMISION NUMERIC(22,0),
    @p_CODTIPOCONTRATOPDV NUMERIC(22,0),
    @p_ID_DETALLEFACTURACIONPDV_out NUMERIC(22,0) OUT
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.DETALLEFACTURACIONPDV
        (
            CODMAESTROFACTURACIONPDV,
            CODUSUARIOMODIFICACION,
            CODPRODUCTO,
            CODTIPOPRODUCTO,
            COMISIONANTICIPO,
            CODRANGOCOMISION,
            CODTIPOCONTRATOPDV
        )
    VALUES
        (
            @p_CODMAESTROFACTURACIONPDV,
            @p_CODUSUARIOMODIFICACION,
            @p_CODPRODUCTO,
            @p_CODTIPOPRODUCTO,
            @p_COMISIONANTICIPO,
            @p_CODRANGOCOMISION,
            @p_CODTIPOCONTRATOPDV
        );
       SET
            @p_ID_DETALLEFACTURACIONPDV_out = SCOPE_IDENTITY() ;

    -- Call UPDATE for fields that have database defaults
    IF @p_FECHAHORAMODIFICACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_CANTIDADVENTA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET CANTIDADVENTA = @p_CANTIDADVENTA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORVENTA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORVENTA = @p_VALORVENTA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_CANTIDADANULACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET CANTIDADANULACION = @p_CANTIDADANULACION WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORANULACION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORANULACION = @p_VALORANULACION WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_CANTIDADPREMIOPAGO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET CANTIDADPREMIOPAGO = @p_CANTIDADPREMIOPAGO WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORPREMIOPAGO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORPREMIOPAGO = @p_VALORPREMIOPAGO WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORCOMISION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORCOMISION = @p_VALORCOMISION WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_RETENCIONPREMIOSPAGADOS IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET RETENCIONPREMIOSPAGADOS = @p_RETENCIONPREMIOSPAGADOS WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_ACTIVE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET ACTIVE = @p_ACTIVE WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_AJUSTE IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET AJUSTE = @p_AJUSTE WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORCOMISIONNETA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORCOMISIONNETA = @p_VALORCOMISIONNETA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORVENTANETA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORVENTANETA = @p_VALORVENTANETA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_CANTIDADGRATUITO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET CANTIDADGRATUITO = @p_CANTIDADGRATUITO WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORGRATUITO IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORGRATUITO = @p_VALORGRATUITO WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOENCONTRAGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET NUEVOSALDOENCONTRAGTECH = @p_NUEVOSALDOENCONTRAGTECH WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOENCONTRAFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET NUEVOSALDOENCONTRAFIDUCIA = @p_NUEVOSALDOENCONTRAFIDUCIA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOAFAVORGTECH IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET NUEVOSALDOAFAVORGTECH = @p_NUEVOSALDOAFAVORGTECH WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_NUEVOSALDOAFAVORFIDUCIA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET NUEVOSALDOAFAVORFIDUCIA = @p_NUEVOSALDOAFAVORFIDUCIA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_IVACOMISION IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET IVACOMISION = @p_IVACOMISION WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORVENTABRUTA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORVENTABRUTA = @p_VALORVENTABRUTA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
    IF @p_VALORCOMISIONBRUTA IS NOT NULL
    BEGIN
        UPDATE WSXML_SFG.DETALLEFACTURACIONPDV SET VALORCOMISIONBRUTA = @p_VALORCOMISIONBRUTA WHERE ID_DETALLEFACTURACIONPDV = @p_ID_DETALLEFACTURACIONPDV_out;
    END 
END;
GO

-- Updates a record in the DETALLEFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_UpdateRecord(
    @pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0),
    @p_CODMAESTROFACTURACIONPDV NUMERIC(22,0),
    @p_FECHAHORAMODIFICACION DATETIME,
    @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
    @p_CODPRODUCTO NUMERIC(22,0),
    @p_CANTIDADVENTA NUMERIC(22,0),
    @p_VALORVENTA FLOAT,
    @p_CANTIDADANULACION NUMERIC(22,0),
    @p_VALORANULACION FLOAT,
    @p_CANTIDADPREMIOPAGO NUMERIC(22,0),
    @p_VALORPREMIOPAGO FLOAT,
    @p_VALORCOMISION FLOAT,
    @p_RETENCIONPREMIOSPAGADOS FLOAT,
    @p_ACTIVE NUMERIC(22,0),
    @p_AJUSTE FLOAT,
    @p_VALORCOMISIONNETA FLOAT,
    @p_VALORVENTANETA FLOAT,
    @p_CANTIDADGRATUITO NUMERIC(22,0),
    @p_VALORGRATUITO FLOAT,
    @p_NUEVOSALDOENCONTRAGTECH FLOAT,
    @p_NUEVOSALDOENCONTRAFIDUCIA FLOAT,
    @p_NUEVOSALDOAFAVORGTECH FLOAT,
    @p_NUEVOSALDOAFAVORFIDUCIA FLOAT,
    @p_IVACOMISION FLOAT,
    @p_VALORVENTABRUTA FLOAT,
    @p_VALORCOMISIONBRUTA FLOAT,
    @p_CODTIPOPRODUCTO NUMERIC(22,0),
    @p_COMISIONANTICIPO NUMERIC(22,0),
    @p_CODRANGOCOMISION NUMERIC(22,0),
    @p_CODTIPOCONTRATOPDV NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.DETALLEFACTURACIONPDV
    SET
            CODMAESTROFACTURACIONPDV = @p_CODMAESTROFACTURACIONPDV,
            FECHAHORAMODIFICACION = @p_FECHAHORAMODIFICACION,
            CODUSUARIOMODIFICACION = @p_CODUSUARIOMODIFICACION,
            CODPRODUCTO = @p_CODPRODUCTO,
            CANTIDADVENTA = @p_CANTIDADVENTA,
            VALORVENTA = @p_VALORVENTA,
            CANTIDADANULACION = @p_CANTIDADANULACION,
            VALORANULACION = @p_VALORANULACION,
            CANTIDADPREMIOPAGO = @p_CANTIDADPREMIOPAGO,
            VALORPREMIOPAGO = @p_VALORPREMIOPAGO,
            VALORCOMISION = @p_VALORCOMISION,
            RETENCIONPREMIOSPAGADOS = @p_RETENCIONPREMIOSPAGADOS,
            ACTIVE = @p_ACTIVE,
            AJUSTE = @p_AJUSTE,
            VALORCOMISIONNETA = @p_VALORCOMISIONNETA,
            VALORVENTANETA = @p_VALORVENTANETA,
            CANTIDADGRATUITO = @p_CANTIDADGRATUITO,
            VALORGRATUITO = @p_VALORGRATUITO,
            NUEVOSALDOENCONTRAGTECH = @p_NUEVOSALDOENCONTRAGTECH,
            NUEVOSALDOENCONTRAFIDUCIA = @p_NUEVOSALDOENCONTRAFIDUCIA,
            NUEVOSALDOAFAVORGTECH = @p_NUEVOSALDOAFAVORGTECH,
            NUEVOSALDOAFAVORFIDUCIA = @p_NUEVOSALDOAFAVORFIDUCIA,
            IVACOMISION = @p_IVACOMISION,
            VALORVENTABRUTA = @p_VALORVENTABRUTA,
            VALORCOMISIONBRUTA = @p_VALORCOMISIONBRUTA,
            CODTIPOPRODUCTO = @p_CODTIPOPRODUCTO,
            COMISIONANTICIPO = @p_COMISIONANTICIPO,
            CODRANGOCOMISION = @p_CODRANGOCOMISION,
            CODTIPOCONTRATOPDV = @p_CODTIPOCONTRATOPDV
    WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;

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

-- Deletes a record from the DETALLEFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DeleteRecord(
    @pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.DETALLEFACTURACIONPDV
    WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;
END;
GO

-- Deletes the set of rows from the DETALLEFACTURACIONPDV table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DeleteRecords(
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
'DELETE WSXML_SFG.DETALLEFACTURACIONPDV' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the DETALLEFACTURACIONPDV table.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetRecord(
   @pk_ID_DETALLEFACTURACIONPDV NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.DETALLEFACTURACIONPDV
    WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;

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
        ID_DETALLEFACTURACIONPDV,
        CODMAESTROFACTURACIONPDV,
        FECHAHORAMODIFICACION,
        CODUSUARIOMODIFICACION,
        CODPRODUCTO,
        CANTIDADVENTA,
        VALORVENTA,
        CANTIDADANULACION,
        VALORANULACION,
        CANTIDADPREMIOPAGO,
        VALORPREMIOPAGO,
        VALORCOMISION,
        RETENCIONPREMIOSPAGADOS,
        ACTIVE,
        AJUSTE,
        VALORCOMISIONNETA,
        VALORVENTANETA,
        CANTIDADGRATUITO,
        VALORGRATUITO,
        NUEVOSALDOENCONTRAGTECH,
        NUEVOSALDOENCONTRAFIDUCIA,
        NUEVOSALDOAFAVORGTECH,
        NUEVOSALDOAFAVORFIDUCIA,
        IVACOMISION,
        VALORVENTABRUTA,
        VALORCOMISIONBRUTA,
        CODTIPOPRODUCTO,
        COMISIONANTICIPO,
        CODRANGOCOMISION,
        CODTIPOCONTRATOPDV
    FROM WSXML_SFG.DETALLEFACTURACIONPDV
    WHERE ID_DETALLEFACTURACIONPDV = @pk_ID_DETALLEFACTURACIONPDV;  
END;
GO

-- Returns a query resultset from table DETALLEFACTURACIONPDV
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
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetList(
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
    SET @l_from_str = 'WSXML_SFG.DETALLEFACTURACIONPDV DETALLEFACTURACIONPDV_';
    SET @l_alias_str = 'DETALLEFACTURACIONPDV_';

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
        'DETALLEFACTURACIONPDV_.ID_DETALLEFACTURACIONPDV,
            DETALLEFACTURACIONPDV_.CODMAESTROFACTURACIONPDV,
            DETALLEFACTURACIONPDV_.FECHAHORAMODIFICACION,
            DETALLEFACTURACIONPDV_.CODUSUARIOMODIFICACION,
            DETALLEFACTURACIONPDV_.CODPRODUCTO,
            DETALLEFACTURACIONPDV_.CANTIDADVENTA,
            DETALLEFACTURACIONPDV_.VALORVENTA,
            DETALLEFACTURACIONPDV_.CANTIDADANULACION,
            DETALLEFACTURACIONPDV_.VALORANULACION,
            DETALLEFACTURACIONPDV_.CANTIDADPREMIOPAGO,
            DETALLEFACTURACIONPDV_.VALORPREMIOPAGO,
            DETALLEFACTURACIONPDV_.VALORCOMISION,
            DETALLEFACTURACIONPDV_.RETENCIONPREMIOSPAGADOS,
            DETALLEFACTURACIONPDV_.ACTIVE,
            DETALLEFACTURACIONPDV_.AJUSTE,
            DETALLEFACTURACIONPDV_.VALORCOMISIONNETA,
            DETALLEFACTURACIONPDV_.VALORVENTANETA,
            DETALLEFACTURACIONPDV_.CANTIDADGRATUITO,
            DETALLEFACTURACIONPDV_.VALORGRATUITO,
            DETALLEFACTURACIONPDV_.NUEVOSALDOENCONTRAGTECH,
            DETALLEFACTURACIONPDV_.NUEVOSALDOENCONTRAFIDUCIA,
            DETALLEFACTURACIONPDV_.NUEVOSALDOAFAVORGTECH,
            DETALLEFACTURACIONPDV_.NUEVOSALDOAFAVORFIDUCIA,
            DETALLEFACTURACIONPDV_.IVACOMISION,
            DETALLEFACTURACIONPDV_.VALORVENTABRUTA,
            DETALLEFACTURACIONPDV_.VALORCOMISIONBRUTA,
            DETALLEFACTURACIONPDV_.CODTIPOPRODUCTO,
            DETALLEFACTURACIONPDV_.COMISIONANTICIPO,
            DETALLEFACTURACIONPDV_.CODRANGOCOMISION,
            DETALLEFACTURACIONPDV_.CODTIPOCONTRATOPDV';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY DETALLEFACTURACIONPDV_.ID_DETALLEFACTURACIONPDV ASC ';

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

-- Returns a query result from table DETALLEFACTURACIONPDV
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.DETALLEFACTURACIONPDV DETALLEFACTURACIONPDV_';
    SET @l_alias_str = 'DETALLEFACTURACIONPDV_';

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

-- Returns a query result from table DETALLEFACTURACIONPDV
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.DETALLEFACTURACIONPDV DETALLEFACTURACIONPDV_';
    SET @l_alias_str = 'DETALLEFACTURACIONPDV_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBDETALLEFACTURACIONPDV_Export(
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
                '''XID_DETALLEFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODMAESTROFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODMAESTROFACTURACIONPDV CODLINEADENEGOCIODESCUENTO' + isnull(@p_separator_str, '') +
                'FECHAHORAMODIFICACION' + isnull(@p_separator_str, '') +
                'CODUSUARIOMODIFICACION' + isnull(@p_separator_str, '') +
                'CODPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPRODUCTO NOMPRODUCTO' + isnull(@p_separator_str, '') +
                'CANTIDADVENTA' + isnull(@p_separator_str, '') +
                'VALORVENTA' + isnull(@p_separator_str, '') +
                'CANTIDADANULACION' + isnull(@p_separator_str, '') +
                'VALORANULACION' + isnull(@p_separator_str, '') +
                'CANTIDADPREMIOPAGO' + isnull(@p_separator_str, '') +
                'VALORPREMIOPAGO' + isnull(@p_separator_str, '') +
                'VALORCOMISION' + isnull(@p_separator_str, '') +
                'RETENCIONPREMIOSPAGADOS' + isnull(@p_separator_str, '') +
                'ACTIVE' + isnull(@p_separator_str, '') +
                'AJUSTE' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA' + isnull(@p_separator_str, '') +
                'VALORVENTANETA' + isnull(@p_separator_str, '') +
                'CANTIDADGRATUITO' + isnull(@p_separator_str, '') +
                'VALORGRATUITO' + isnull(@p_separator_str, '') +
                'NUEVOSALDOENCONTRAGTECH' + isnull(@p_separator_str, '') +
                'NUEVOSALDOENCONTRAFIDUCIA' + isnull(@p_separator_str, '') +
                'NUEVOSALDOAFAVORGTECH' + isnull(@p_separator_str, '') +
                'NUEVOSALDOAFAVORFIDUCIA' + isnull(@p_separator_str, '') +
                'IVACOMISION' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA' + isnull(@p_separator_str, '') +
                'VALORCOMISIONBRUTA' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO NOMTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'COMISIONANTICIPO' + isnull(@p_separator_str, '') +
                'CODRANGOCOMISION' + isnull(@p_separator_str, '') +
                'CODTIPOCONTRATOPDV' + ' ''';
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
                ' isnull(CAST(DETALLEFACTURACIONPDV_.ID_DETALLEFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CODMAESTROFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t0.CODLINEADENEGOCIODESCUENTO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(DETALLEFACTURACIONPDV_.FECHAHORAMODIFICACION), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CODUSUARIOMODIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CODPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CANTIDADVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORVENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CANTIDADANULACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORANULACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CANTIDADPREMIOPAGO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORPREMIOPAGO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.RETENCIONPREMIOSPAGADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.ACTIVE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.AJUSTE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORCOMISIONNETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORVENTANETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CANTIDADGRATUITO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORGRATUITO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.NUEVOSALDOENCONTRAGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.NUEVOSALDOENCONTRAFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.NUEVOSALDOAFAVORGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.NUEVOSALDOAFAVORFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.IVACOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORVENTABRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.VALORCOMISIONBRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CODTIPOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMTIPOPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(DETALLEFACTURACIONPDV_.COMISIONANTICIPO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CODRANGOCOMISION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(DETALLEFACTURACIONPDV_.CODTIPOCONTRATOPDV AS VARCHAR(MAX)), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.DETALLEFACTURACIONPDV DETALLEFACTURACIONPDV_ LEFT OUTER JOIN WSXML_SFG.MAESTROFACTURACIONPDV t0 ON (DETALLEFACTURACIONPDV_.CODMAESTROFACTURACIONPDV =  t0.ID_MAESTROFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.PRODUCTO t1 ON (DETALLEFACTURACIONPDV_.CODPRODUCTO =  t1.ID_PRODUCTO) LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO t2 ON (DETALLEFACTURACIONPDV_.CODTIPOPRODUCTO =  t2.ID_TIPOPRODUCTO)';

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






