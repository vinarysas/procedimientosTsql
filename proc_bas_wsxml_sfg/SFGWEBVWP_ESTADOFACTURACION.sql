USE SFGPRODU;
--  DDL for Package Body SFGWEBVWP_ESTADOFACTURACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION */ 

-- Returns a query resultset from table VWP_ESTADOFACTURACION
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VWP_ESTADOFACTURACION VWP_ESTADOFACTURACION_';
    SET @l_alias_str = 'VWP_ESTADOFACTURACION_';

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
        'VWP_ESTADOFACTURACION_.ID_CICLOFACTURACIONPDV,
            VWP_ESTADOFACTURACION_.ID_LINEADENEGOCIO,
            VWP_ESTADOFACTURACION_.CANTIDADPDVACTIVOS,
            VWP_ESTADOFACTURACION_.TOTALINDEPENDIENTES,
            VWP_ESTADOFACTURACION_.TOTALAGRUPADOS,
            VWP_ESTADOFACTURACION_.TIRILLASFACTURACION,
            VWP_ESTADOFACTURACION_.TIRILLASGENERADAS,
            VWP_ESTADOFACTURACION_.TIRILLASTRANSFERIDAS,
            VWP_ESTADOFACTURACION_.TIRILLASAGRUPADAS,
            VWP_ESTADOFACTURACION_.TIRILLASINDEPENDIENTES,
            VWP_ESTADOFACTURACION_.VALORVENTA,
            VWP_ESTADOFACTURACION_.VALORANULACION,
            VWP_ESTADOFACTURACION_.VALORVENTABRUTA,
            VWP_ESTADOFACTURACION_.VALORVENTANETA,
            VWP_ESTADOFACTURACION_.VALORPREMIOPAGO,
            VWP_ESTADOFACTURACION_.RETENCIONPREMIOSPAGADOS,
            VWP_ESTADOFACTURACION_.VALORCOMISION,
            VWP_ESTADOFACTURACION_.VATCOMISION,
            VWP_ESTADOFACTURACION_.VALORCOMISIONBRUTA,
            VWP_ESTADOFACTURACION_.VALORCOMISIONNETA,
            VWP_ESTADOFACTURACION_.IMPUESTO_IVA,
            VWP_ESTADOFACTURACION_.RETENCION_RENTA,
            VWP_ESTADOFACTURACION_.RETENCION_RETEICA,
            VWP_ESTADOFACTURACION_.RETENCION_RETEIVA';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = ' ';
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
                'FROM ( SELECT /*+ push_pred(VWP_ESTADOFACTURACION_) */ ' +
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

-- Returns a query result from table VWP_ESTADOFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VWP_ESTADOFACTURACION VWP_ESTADOFACTURACION_';
    SET @l_alias_str = 'VWP_ESTADOFACTURACION_';

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
                'FROM ( SELECT /*+ push_pred(VWP_ESTADOFACTURACION_) */ ' +
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

-- Returns a query result from table VWP_ESTADOFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VWP_ESTADOFACTURACION VWP_ESTADOFACTURACION_';
    SET @l_alias_str = 'VWP_ESTADOFACTURACION_';

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
                'FROM ( SELECT /*+ push_pred(VWP_ESTADOFACTURACION_) */ ' +
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_ESTADOFACTURACION_Export(
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
                '''XID_CICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'XID_CICLOFACTURACIONPDV SECUENCIA' + isnull(@p_separator_str, '') +
                'ID_LINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'ID_LINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CANTIDADPDVACTIVOS' + isnull(@p_separator_str, '') +
                'TOTALINDEPENDIENTES' + isnull(@p_separator_str, '') +
                'TOTALAGRUPADOS' + isnull(@p_separator_str, '') +
                'TIRILLASFACTURACION' + isnull(@p_separator_str, '') +
                'TIRILLASGENERADAS' + isnull(@p_separator_str, '') +
                'TIRILLASTRANSFERIDAS' + isnull(@p_separator_str, '') +
                'TIRILLASAGRUPADAS' + isnull(@p_separator_str, '') +
                'TIRILLASINDEPENDIENTES' + isnull(@p_separator_str, '') +
                'VALORVENTA' + isnull(@p_separator_str, '') +
                'VALORANULACION' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA' + isnull(@p_separator_str, '') +
                'VALORVENTANETA' + isnull(@p_separator_str, '') +
                'VALORPREMIOPAGO' + isnull(@p_separator_str, '') +
                'RETENCIONPREMIOSPAGADOS' + isnull(@p_separator_str, '') +
                'VALORCOMISION' + isnull(@p_separator_str, '') +
                'VATCOMISION' + isnull(@p_separator_str, '') +
                'VALORCOMISIONBRUTA' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA' + isnull(@p_separator_str, '') +
                'IMPUESTO_IVA' + isnull(@p_separator_str, '') +
                'RETENCION_RENTA' + isnull(@p_separator_str, '') +
                'RETENCION_RETEICA' + isnull(@p_separator_str, '') +
                'RETENCION_RETEIVA' + ' ''';
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
                ' isnull(CAST(VWP_ESTADOFACTURACION_.ID_CICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.SECUENCIA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_ESTADOFACTURACION_.ID_LINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_ESTADOFACTURACION_.CANTIDADPDVACTIVOS AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.TOTALINDEPENDIENTES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.TOTALAGRUPADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.TIRILLASFACTURACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.TIRILLASGENERADAS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_ESTADOFACTURACION_.TIRILLASTRANSFERIDAS AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.TIRILLASAGRUPADAS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.TIRILLASINDEPENDIENTES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORVENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORANULACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORVENTABRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORVENTANETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORPREMIOPAGO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.RETENCIONPREMIOSPAGADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VATCOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORCOMISIONBRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.VALORCOMISIONNETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.IMPUESTO_IVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.RETENCION_RENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.RETENCION_RETEICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VWP_ESTADOFACTURACION_.RETENCION_RETEIVA, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VWP_ESTADOFACTURACION VWP_ESTADOFACTURACION_ LEFT OUTER JOIN WSXML_SFG.CICLOFACTURACIONPDV t0 ON (VWP_ESTADOFACTURACION_.ID_CICLOFACTURACIONPDV =  t0.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t1 ON (VWP_ESTADOFACTURACION_.ID_LINEADENEGOCIO =  t1.ID_LINEADENEGOCIO)';

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






