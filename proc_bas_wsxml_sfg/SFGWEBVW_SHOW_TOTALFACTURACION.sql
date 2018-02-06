USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_SHOW_TOTALFACTURACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION */ 

-- Creates a new record in the VW_SHOW_TOTALFACTURACION table
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_AddRecord(
    @p_ID_TOTALFACTURACION VARCHAR(4000),
    @p_ID_CICLOFACTURACIONPDV NUMERIC(22,0),
    @p_CODALIADOESTRATEGICO NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_CODTIPOPRODUCTO NUMERIC(22,0),
    @p_ID_PRODUCTO NUMERIC(22,0),
    @p_CANTIDADVENTA NUMERIC(22,0),
    @p_VALORVENTA NUMERIC(22,0),
    @p_VALORVENTABRUTA NUMERIC(22,0),
    @p_VALORVENTANETA NUMERIC(22,0),
    @p_CANTIDADPREMIOPAGO NUMERIC(22,0),
    @p_VALORPREMIOPAGO NUMERIC(22,0),
    @p_RETENCIONPREMIOSPAGADOS NUMERIC(22,0),
    @p_CANTIDADANULACION NUMERIC(22,0),
    @p_VALORANULACION NUMERIC(22,0),
    @p_CANTIDADGRATUITO NUMERIC(22,0),
    @p_VALORGRATUITO NUMERIC(22,0),
    @p_VALORCOMISION NUMERIC(22,0),
    @p_VATCOMISION NUMERIC(22,0),
    @p_VALORCOMISIONBRUTA NUMERIC(22,0),
    @p_VALORCOMISIONNETA NUMERIC(22,0),
    @p_VALORIMPUESTO NUMERIC(22,0),
    @p_VALORRETENCION NUMERIC(22,0),
    @p_VALORRETENCIONUVT NUMERIC(22,0),
    @p_IMPUESTO_IVA NUMERIC(22,0),
    @p_RETENCION_RENTA NUMERIC(22,0),
    @p_RETENCION_RETEICA NUMERIC(22,0),
    @p_RETENCION_RETEIVA NUMERIC(22,0),
    @p_SALDOANTERIORENCONTRAGTECH NUMERIC(22,0),
    @p_SALDOANTERIORENCONTRAFIDUCIA NUMERIC(22,0),
    @p_SALDOANTERIORAFAVORGTECH NUMERIC(22,0),
    @p_SALDOANTERIORAFAVORFIDUCIA NUMERIC(22,0),
    @p_NUEVOSALDOENCONTRAGTECH NUMERIC(22,0),
    @p_NUEVOSALDOENCONTRAFIDUCIA NUMERIC(22,0),
    @p_NUEVOSALDOAFAVORGTECH NUMERIC(22,0),
    @p_NUEVOSALDOAFAVORFIDUCIA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.VW_SHOW_TOTALFACTURACION
        (
            ID_TOTALFACTURACION,
            ID_CICLOFACTURACIONPDV,
            CODALIADOESTRATEGICO,
            CODLINEADENEGOCIO,
            CODTIPOPRODUCTO,
            ID_PRODUCTO,
            CANTIDADVENTA,
            VALORVENTA,
            VALORVENTABRUTA,
            VALORVENTANETA,
            CANTIDADPREMIOPAGO,
            VALORPREMIOPAGO,
            RETENCIONPREMIOSPAGADOS,
            CANTIDADANULACION,
            VALORANULACION,
            CANTIDADGRATUITO,
            VALORGRATUITO,
            VALORCOMISION,
            VATCOMISION,
            VALORCOMISIONBRUTA,
            VALORCOMISIONNETA,
            VALORIMPUESTO,
            VALORRETENCION,
            VALORRETENCIONUVT,
            IMPUESTO_IVA,
            RETENCION_RENTA,
            RETENCION_RETEICA,
            RETENCION_RETEIVA,
            SALDOANTERIORENCONTRAGTECH,
            SALDOANTERIORENCONTRAFIDUCIA,
            SALDOANTERIORAFAVORGTECH,
            SALDOANTERIORAFAVORFIDUCIA,
            NUEVOSALDOENCONTRAGTECH,
            NUEVOSALDOENCONTRAFIDUCIA,
            NUEVOSALDOAFAVORGTECH,
            NUEVOSALDOAFAVORFIDUCIA
        )
    VALUES
        (
            @p_ID_TOTALFACTURACION,
            @p_ID_CICLOFACTURACIONPDV,
            @p_CODALIADOESTRATEGICO,
            @p_CODLINEADENEGOCIO,
            @p_CODTIPOPRODUCTO,
            @p_ID_PRODUCTO,
            @p_CANTIDADVENTA,
            @p_VALORVENTA,
            @p_VALORVENTABRUTA,
            @p_VALORVENTANETA,
            @p_CANTIDADPREMIOPAGO,
            @p_VALORPREMIOPAGO,
            @p_RETENCIONPREMIOSPAGADOS,
            @p_CANTIDADANULACION,
            @p_VALORANULACION,
            @p_CANTIDADGRATUITO,
            @p_VALORGRATUITO,
            @p_VALORCOMISION,
            @p_VATCOMISION,
            @p_VALORCOMISIONBRUTA,
            @p_VALORCOMISIONNETA,
            @p_VALORIMPUESTO,
            @p_VALORRETENCION,
            @p_VALORRETENCIONUVT,
            @p_IMPUESTO_IVA,
            @p_RETENCION_RENTA,
            @p_RETENCION_RETEICA,
            @p_RETENCION_RETEIVA,
            @p_SALDOANTERIORENCONTRAGTECH,
            @p_SALDOANTERIORENCONTRAFIDUCIA,
            @p_SALDOANTERIORAFAVORGTECH,
            @p_SALDOANTERIORAFAVORFIDUCIA,
            @p_NUEVOSALDOENCONTRAGTECH,
            @p_NUEVOSALDOENCONTRAFIDUCIA,
            @p_NUEVOSALDOAFAVORGTECH,
            @p_NUEVOSALDOAFAVORFIDUCIA
        );

END;
GO

-- Updates a record in the VW_SHOW_TOTALFACTURACION table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_UpdateRecord(
        @p_ID_TOTALFACTURACION VARCHAR(4000),
@pk_ID_TOTALFACTURACION VARCHAR(4000),
    @p_ID_CICLOFACTURACIONPDV NUMERIC(22,0),
    @p_CODALIADOESTRATEGICO NUMERIC(22,0),
    @p_CODLINEADENEGOCIO NUMERIC(22,0),
    @p_CODTIPOPRODUCTO NUMERIC(22,0),
    @p_ID_PRODUCTO NUMERIC(22,0),
    @p_CANTIDADVENTA NUMERIC(22,0),
    @p_VALORVENTA NUMERIC(22,0),
    @p_VALORVENTABRUTA NUMERIC(22,0),
    @p_VALORVENTANETA NUMERIC(22,0),
    @p_CANTIDADPREMIOPAGO NUMERIC(22,0),
    @p_VALORPREMIOPAGO NUMERIC(22,0),
    @p_RETENCIONPREMIOSPAGADOS NUMERIC(22,0),
    @p_CANTIDADANULACION NUMERIC(22,0),
    @p_VALORANULACION NUMERIC(22,0),
    @p_CANTIDADGRATUITO NUMERIC(22,0),
    @p_VALORGRATUITO NUMERIC(22,0),
    @p_VALORCOMISION NUMERIC(22,0),
    @p_VATCOMISION NUMERIC(22,0),
    @p_VALORCOMISIONBRUTA NUMERIC(22,0),
    @p_VALORCOMISIONNETA NUMERIC(22,0),
    @p_VALORIMPUESTO NUMERIC(22,0),
    @p_VALORRETENCION NUMERIC(22,0),
    @p_VALORRETENCIONUVT NUMERIC(22,0),
    @p_IMPUESTO_IVA NUMERIC(22,0),
    @p_RETENCION_RENTA NUMERIC(22,0),
    @p_RETENCION_RETEICA NUMERIC(22,0),
    @p_RETENCION_RETEIVA NUMERIC(22,0),
    @p_SALDOANTERIORENCONTRAGTECH NUMERIC(22,0),
    @p_SALDOANTERIORENCONTRAFIDUCIA NUMERIC(22,0),
    @p_SALDOANTERIORAFAVORGTECH NUMERIC(22,0),
    @p_SALDOANTERIORAFAVORFIDUCIA NUMERIC(22,0),
    @p_NUEVOSALDOENCONTRAGTECH NUMERIC(22,0),
    @p_NUEVOSALDOENCONTRAFIDUCIA NUMERIC(22,0),
    @p_NUEVOSALDOAFAVORGTECH NUMERIC(22,0),
    @p_NUEVOSALDOAFAVORFIDUCIA NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.VW_SHOW_TOTALFACTURACION
    SET
            ID_TOTALFACTURACION = @p_ID_TOTALFACTURACION,
            ID_CICLOFACTURACIONPDV = @p_ID_CICLOFACTURACIONPDV,
            CODALIADOESTRATEGICO = @p_CODALIADOESTRATEGICO,
            CODLINEADENEGOCIO = @p_CODLINEADENEGOCIO,
            CODTIPOPRODUCTO = @p_CODTIPOPRODUCTO,
            ID_PRODUCTO = @p_ID_PRODUCTO,
            CANTIDADVENTA = @p_CANTIDADVENTA,
            VALORVENTA = @p_VALORVENTA,
            VALORVENTABRUTA = @p_VALORVENTABRUTA,
            VALORVENTANETA = @p_VALORVENTANETA,
            CANTIDADPREMIOPAGO = @p_CANTIDADPREMIOPAGO,
            VALORPREMIOPAGO = @p_VALORPREMIOPAGO,
            RETENCIONPREMIOSPAGADOS = @p_RETENCIONPREMIOSPAGADOS,
            CANTIDADANULACION = @p_CANTIDADANULACION,
            VALORANULACION = @p_VALORANULACION,
            CANTIDADGRATUITO = @p_CANTIDADGRATUITO,
            VALORGRATUITO = @p_VALORGRATUITO,
            VALORCOMISION = @p_VALORCOMISION,
            VATCOMISION = @p_VATCOMISION,
            VALORCOMISIONBRUTA = @p_VALORCOMISIONBRUTA,
            VALORCOMISIONNETA = @p_VALORCOMISIONNETA,
            VALORIMPUESTO = @p_VALORIMPUESTO,
            VALORRETENCION = @p_VALORRETENCION,
            VALORRETENCIONUVT = @p_VALORRETENCIONUVT,
            IMPUESTO_IVA = @p_IMPUESTO_IVA,
            RETENCION_RENTA = @p_RETENCION_RENTA,
            RETENCION_RETEICA = @p_RETENCION_RETEICA,
            RETENCION_RETEIVA = @p_RETENCION_RETEIVA,
            SALDOANTERIORENCONTRAGTECH = @p_SALDOANTERIORENCONTRAGTECH,
            SALDOANTERIORENCONTRAFIDUCIA = @p_SALDOANTERIORENCONTRAFIDUCIA,
            SALDOANTERIORAFAVORGTECH = @p_SALDOANTERIORAFAVORGTECH,
            SALDOANTERIORAFAVORFIDUCIA = @p_SALDOANTERIORAFAVORFIDUCIA,
            NUEVOSALDOENCONTRAGTECH = @p_NUEVOSALDOENCONTRAGTECH,
            NUEVOSALDOENCONTRAFIDUCIA = @p_NUEVOSALDOENCONTRAFIDUCIA,
            NUEVOSALDOAFAVORGTECH = @p_NUEVOSALDOAFAVORGTECH,
            NUEVOSALDOAFAVORFIDUCIA = @p_NUEVOSALDOAFAVORFIDUCIA
    WHERE ID_TOTALFACTURACION = @pk_ID_TOTALFACTURACION;

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

-- Deletes a record from the VW_SHOW_TOTALFACTURACION table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DeleteRecord(
    @pk_ID_TOTALFACTURACION VARCHAR(4000)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_SHOW_TOTALFACTURACION
    WHERE ID_TOTALFACTURACION = @pk_ID_TOTALFACTURACION;
END;
GO

-- Deletes the set of rows from the VW_SHOW_TOTALFACTURACION table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DeleteRecords(
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
'DELETE WSXML_SFG.VW_SHOW_TOTALFACTURACION' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_SHOW_TOTALFACTURACION table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetRecord(
   @pk_ID_TOTALFACTURACION VARCHAR(4000)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_SHOW_TOTALFACTURACION
    WHERE ID_TOTALFACTURACION = @pk_ID_TOTALFACTURACION;

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
        ID_TOTALFACTURACION,
        ID_CICLOFACTURACIONPDV,
        CODALIADOESTRATEGICO,
        CODLINEADENEGOCIO,
        CODTIPOPRODUCTO,
        ID_PRODUCTO,
        CANTIDADVENTA,
        VALORVENTA,
        VALORVENTABRUTA,
        VALORVENTANETA,
        CANTIDADPREMIOPAGO,
        VALORPREMIOPAGO,
        RETENCIONPREMIOSPAGADOS,
        CANTIDADANULACION,
        VALORANULACION,
        CANTIDADGRATUITO,
        VALORGRATUITO,
        VALORCOMISION,
        VATCOMISION,
        VALORCOMISIONBRUTA,
        VALORCOMISIONNETA,
        VALORIMPUESTO,
        VALORRETENCION,
        VALORRETENCIONUVT,
        IMPUESTO_IVA,
        RETENCION_RENTA,
        RETENCION_RETEICA,
        RETENCION_RETEIVA,
        SALDOANTERIORENCONTRAGTECH,
        SALDOANTERIORENCONTRAFIDUCIA,
        SALDOANTERIORAFAVORGTECH,
        SALDOANTERIORAFAVORFIDUCIA,
        NUEVOSALDOENCONTRAGTECH,
        NUEVOSALDOENCONTRAFIDUCIA,
        NUEVOSALDOAFAVORGTECH,
        NUEVOSALDOAFAVORFIDUCIA
    FROM WSXML_SFG.VW_SHOW_TOTALFACTURACION
    WHERE ID_TOTALFACTURACION = @pk_ID_TOTALFACTURACION;  
END;
GO

-- Returns a query resultset from table VW_SHOW_TOTALFACTURACION
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_TOTALFACTURACION VW_SHOW_TOTALFACTURACION_';
    SET @l_alias_str = 'VW_SHOW_TOTALFACTURACION_';

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
        'VW_SHOW_TOTALFACTURACION_.ID_TOTALFACTURACION,
            VW_SHOW_TOTALFACTURACION_.ID_CICLOFACTURACIONPDV,
            VW_SHOW_TOTALFACTURACION_.CODALIADOESTRATEGICO,
            VW_SHOW_TOTALFACTURACION_.CODLINEADENEGOCIO,
            VW_SHOW_TOTALFACTURACION_.CODTIPOPRODUCTO,
            VW_SHOW_TOTALFACTURACION_.ID_PRODUCTO,
            VW_SHOW_TOTALFACTURACION_.CANTIDADVENTA,
            VW_SHOW_TOTALFACTURACION_.VALORVENTA,
            VW_SHOW_TOTALFACTURACION_.VALORVENTABRUTA,
            VW_SHOW_TOTALFACTURACION_.VALORVENTANETA,
            VW_SHOW_TOTALFACTURACION_.CANTIDADPREMIOPAGO,
            VW_SHOW_TOTALFACTURACION_.VALORPREMIOPAGO,
            VW_SHOW_TOTALFACTURACION_.RETENCIONPREMIOSPAGADOS,
            VW_SHOW_TOTALFACTURACION_.CANTIDADANULACION,
            VW_SHOW_TOTALFACTURACION_.VALORANULACION,
            VW_SHOW_TOTALFACTURACION_.CANTIDADGRATUITO,
            VW_SHOW_TOTALFACTURACION_.VALORGRATUITO,
            VW_SHOW_TOTALFACTURACION_.VALORCOMISION,
            VW_SHOW_TOTALFACTURACION_.VATCOMISION,
            VW_SHOW_TOTALFACTURACION_.VALORCOMISIONBRUTA,
            VW_SHOW_TOTALFACTURACION_.VALORCOMISIONNETA,
            VW_SHOW_TOTALFACTURACION_.VALORIMPUESTO,
            VW_SHOW_TOTALFACTURACION_.VALORRETENCION,
            VW_SHOW_TOTALFACTURACION_.VALORRETENCIONUVT,
            VW_SHOW_TOTALFACTURACION_.IMPUESTO_IVA,
            VW_SHOW_TOTALFACTURACION_.RETENCION_RENTA,
            VW_SHOW_TOTALFACTURACION_.RETENCION_RETEICA,
            VW_SHOW_TOTALFACTURACION_.RETENCION_RETEIVA,
            VW_SHOW_TOTALFACTURACION_.SALDOANTERIORENCONTRAGTECH,
            VW_SHOW_TOTALFACTURACION_.SALDOANTERIORENCONTRAFIDUCIA,
            VW_SHOW_TOTALFACTURACION_.SALDOANTERIORAFAVORGTECH,
            VW_SHOW_TOTALFACTURACION_.SALDOANTERIORAFAVORFIDUCIA,
            VW_SHOW_TOTALFACTURACION_.NUEVOSALDOENCONTRAGTECH,
            VW_SHOW_TOTALFACTURACION_.NUEVOSALDOENCONTRAFIDUCIA,
            VW_SHOW_TOTALFACTURACION_.NUEVOSALDOAFAVORGTECH,
            VW_SHOW_TOTALFACTURACION_.NUEVOSALDOAFAVORFIDUCIA';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_SHOW_TOTALFACTURACION_.ID_TOTALFACTURACION ASC ';

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
                'FROM ( SELECT /*+ push_pred(VW_SHOW_TOTALFACTURACION_) */ ' +
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

-- Returns a query result from table VW_SHOW_TOTALFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_TOTALFACTURACION VW_SHOW_TOTALFACTURACION_';
    SET @l_alias_str = 'VW_SHOW_TOTALFACTURACION_';

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
        ' SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT /*+ push_pred(' + isnull(@l_alias_str, '') + ') */ ' +
                isnull(@l_query_select, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT /*+ push_pred(VW_SHOW_TOTALFACTURACION_) */ ' +
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

-- Returns a query result from table VW_SHOW_TOTALFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_SHOW_TOTALFACTURACION VW_SHOW_TOTALFACTURACION_';
    SET @l_alias_str = 'VW_SHOW_TOTALFACTURACION_';

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
                'FROM ( SELECT /*+ push_pred(VW_SHOW_TOTALFACTURACION_) */ ' +
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
            'WHERE 1=2';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_TOTALFACTURACION_Export(
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
                '''XID_TOTALFACTURACION' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV SECUENCIA' + isnull(@p_separator_str, '') +
                'CODALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'CODALIADOESTRATEGICO NOMALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO NOMTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'ID_PRODUCTO' + isnull(@p_separator_str, '') +
                'ID_PRODUCTO NOMPRODUCTO' + isnull(@p_separator_str, '') +
                'CANTIDADVENTA' + isnull(@p_separator_str, '') +
                'VALORVENTA' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA' + isnull(@p_separator_str, '') +
                'VALORVENTANETA' + isnull(@p_separator_str, '') +
                'CANTIDADPREMIOPAGO' + isnull(@p_separator_str, '') +
                'VALORPREMIOPAGO' + isnull(@p_separator_str, '') +
                'RETENCIONPREMIOSPAGADOS' + isnull(@p_separator_str, '') +
                'CANTIDADANULACION' + isnull(@p_separator_str, '') +
                'VALORANULACION' + isnull(@p_separator_str, '') +
                'CANTIDADGRATUITO' + isnull(@p_separator_str, '') +
                'VALORGRATUITO' + isnull(@p_separator_str, '') +
                'VALORCOMISION' + isnull(@p_separator_str, '') +
                'VATCOMISION' + isnull(@p_separator_str, '') +
                'VALORCOMISIONBRUTA' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA' + isnull(@p_separator_str, '') +
                'VALORIMPUESTO' + isnull(@p_separator_str, '') +
                'VALORRETENCION' + isnull(@p_separator_str, '') +
                'VALORRETENCIONUVT' + isnull(@p_separator_str, '') +
                'IMPUESTO_IVA' + isnull(@p_separator_str, '') +
                'RETENCION_RENTA' + isnull(@p_separator_str, '') +
                'RETENCION_RETEICA' + isnull(@p_separator_str, '') +
                'RETENCION_RETEIVA' + isnull(@p_separator_str, '') +
                'SALDOANTERIORENCONTRAGTECH' + isnull(@p_separator_str, '') +
                'SALDOANTERIORENCONTRAFIDUCIA' + isnull(@p_separator_str, '') +
                'SALDOANTERIORAFAVORGTECH' + isnull(@p_separator_str, '') +
                'SALDOANTERIORAFAVORFIDUCIA' + isnull(@p_separator_str, '') +
                'NUEVOSALDOENCONTRAGTECH' + isnull(@p_separator_str, '') +
                'NUEVOSALDOENCONTRAFIDUCIA' + isnull(@p_separator_str, '') +
                'NUEVOSALDOAFAVORGTECH' + isnull(@p_separator_str, '') +
                'NUEVOSALDOAFAVORFIDUCIA' + ' ''';
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
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_TOTALFACTURACION_.ID_TOTALFACTURACION) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.ID_CICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.SECUENCIA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CODALIADOESTRATEGICO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMALIADOESTRATEGICO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CODTIPOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMTIPOPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.ID_PRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CANTIDADVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORVENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORVENTABRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORVENTANETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CANTIDADPREMIOPAGO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORPREMIOPAGO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.RETENCIONPREMIOSPAGADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CANTIDADANULACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORANULACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.CANTIDADGRATUITO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORGRATUITO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VATCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORCOMISIONBRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORCOMISIONNETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORIMPUESTO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORRETENCION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.VALORRETENCIONUVT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.IMPUESTO_IVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.RETENCION_RENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.RETENCION_RETEICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.RETENCION_RETEIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.SALDOANTERIORENCONTRAGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.SALDOANTERIORENCONTRAFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.SALDOANTERIORAFAVORGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.SALDOANTERIORAFAVORFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.NUEVOSALDOENCONTRAGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.NUEVOSALDOENCONTRAFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_TOTALFACTURACION_.NUEVOSALDOAFAVORGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_TOTALFACTURACION_.NUEVOSALDOAFAVORFIDUCIA AS VARCHAR(MAX)), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_TOTALFACTURACION VW_SHOW_TOTALFACTURACION_ LEFT OUTER JOIN WSXML_SFG.CICLOFACTURACIONPDV t0 ON (VW_SHOW_TOTALFACTURACION_.ID_CICLOFACTURACIONPDV =  t0.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.ALIADOESTRATEGICO t1 ON (VW_SHOW_TOTALFACTURACION_.CODALIADOESTRATEGICO =  t1.ID_ALIADOESTRATEGICO) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t2 ON (VW_SHOW_TOTALFACTURACION_.CODLINEADENEGOCIO =  t2.ID_LINEADENEGOCIO) LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO t3 ON (VW_SHOW_TOTALFACTURACION_.CODTIPOPRODUCTO =  t3.ID_TIPOPRODUCTO) LEFT OUTER JOIN WSXML_SFG.PRODUCTO t4 ON (VW_SHOW_TOTALFACTURACION_.ID_PRODUCTO =  t4.ID_PRODUCTO)';

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

