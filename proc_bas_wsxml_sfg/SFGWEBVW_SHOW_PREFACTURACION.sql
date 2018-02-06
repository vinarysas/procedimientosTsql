USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_SHOW_PREFACTURACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION */ 

-- Returns a query resultset from table VW_SHOW_PREFACTURACION
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PREFACTURACION VW_SHOW_PREFACTURACION_';
    SET @l_alias_str = 'VW_SHOW_PREFACTURACION_';

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
        'VW_SHOW_PREFACTURACION_.ID_PREFACTURACION_DIARIA,
            VW_SHOW_PREFACTURACION_.ID_ENTRADAARCHIVOCONTROL,
            VW_SHOW_PREFACTURACION_.CODPRODUCTO,
            VW_SHOW_PREFACTURACION_.CODPUNTODEVENTA,
            VW_SHOW_PREFACTURACION_.CODTIPOPRODUCTO,
            VW_SHOW_PREFACTURACION_.CODLINEADENEGOCIO,
            VW_SHOW_PREFACTURACION_.CODIGOGTECHPRODUCTO,
            VW_SHOW_PREFACTURACION_.CODAGRUPACIONPUNTODEVENTA,
            VW_SHOW_PREFACTURACION_.CODIGOGTECHPUNTODEVENTA,
            VW_SHOW_PREFACTURACION_.CODALIADOESTRATEGICO,
            VW_SHOW_PREFACTURACION_.TIPOARCHIVO,
            VW_SHOW_PREFACTURACION_.FECHAARCHIVO,
            VW_SHOW_PREFACTURACION_.CDC,
            VW_SHOW_PREFACTURACION_.MINCODRANGOCOMISION,
            VW_SHOW_PREFACTURACION_.NUMINGRESOS,
            VW_SHOW_PREFACTURACION_.INGRESOS,
            VW_SHOW_PREFACTURACION_.NUMANULACIONES,
            VW_SHOW_PREFACTURACION_.ANULACIONES,
            VW_SHOW_PREFACTURACION_.INGRESOSVALIDOS,
            VW_SHOW_PREFACTURACION_.IVAPRODUCTO,
            VW_SHOW_PREFACTURACION_.INGRESOSBRUTOS,
            VW_SHOW_PREFACTURACION_.COMISION,
            VW_SHOW_PREFACTURACION_.COMISIONANTICIPO,
            VW_SHOW_PREFACTURACION_.IVACOMISION,
            VW_SHOW_PREFACTURACION_.COMISIONBRUTA,
            VW_SHOW_PREFACTURACION_.RETEFUENTE,
            VW_SHOW_PREFACTURACION_.RETEICA,
            VW_SHOW_PREFACTURACION_.RETEIVA,
            VW_SHOW_PREFACTURACION_.RETEUVT,
            VW_SHOW_PREFACTURACION_.COMISIONNETA,
            VW_SHOW_PREFACTURACION_.PREMIOSPAGADOS,
            VW_SHOW_PREFACTURACION_.RETENCIONPREMIOS';

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

-- Returns a query result from table VW_SHOW_PREFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PREFACTURACION VW_SHOW_PREFACTURACION_';
    SET @l_alias_str = 'VW_SHOW_PREFACTURACION_';

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

-- Returns a query result from table VW_SHOW_PREFACTURACION
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PREFACTURACION VW_SHOW_PREFACTURACION_';
    SET @l_alias_str = 'VW_SHOW_PREFACTURACION_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOW_PREFACTURACION_Export(
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
                'CODPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPRODUCTO NOMPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTA CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO NOMTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPRODUCTO' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'CODALIADOESTRATEGICO NOMALIADOESTRATEGICO' + isnull(@p_separator_str, '') +
                'TIPOARCHIVO' + isnull(@p_separator_str, '') +
                'FECHAARCHIVO' + isnull(@p_separator_str, '') +
                'CDC' + isnull(@p_separator_str, '') +
                'MINCODRANGOCOMISION' + isnull(@p_separator_str, '') +
                'NUMINGRESOS' + isnull(@p_separator_str, '') +
                'INGRESOS' + isnull(@p_separator_str, '') +
                'NUMANULACIONES' + isnull(@p_separator_str, '') +
                'ANULACIONES' + isnull(@p_separator_str, '') +
                'INGRESOSVALIDOS' + isnull(@p_separator_str, '') +
                'IVAPRODUCTO' + isnull(@p_separator_str, '') +
                'INGRESOSBRUTOS' + isnull(@p_separator_str, '') +
                'COMISION' + isnull(@p_separator_str, '') +
                'COMISIONANTICIPO' + isnull(@p_separator_str, '') +
                'IVACOMISION' + isnull(@p_separator_str, '') +
                'COMISIONBRUTA' + isnull(@p_separator_str, '') +
                'RETEFUENTE' + isnull(@p_separator_str, '') +
                'RETEICA' + isnull(@p_separator_str, '') +
                'RETEIVA' + isnull(@p_separator_str, '') +
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
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_PREFACTURACION_.ID_PREFACTURACION_DIARIA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.ID_ENTRADAARCHIVOCONTROL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMARCHIVO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.CODPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.CODPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t2.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.CODTIPOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMTIPOPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_PREFACTURACION_.CODIGOGTECHPRODUCTO) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_SHOW_PREFACTURACION_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.CODALIADOESTRATEGICO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMALIADOESTRATEGICO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.TIPOARCHIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_SHOW_PREFACTURACION_.FECHAARCHIVO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.CDC, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.MINCODRANGOCOMISION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.NUMINGRESOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.INGRESOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.NUMANULACIONES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.ANULACIONES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOW_PREFACTURACION_.INGRESOSVALIDOS AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.IVAPRODUCTO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.INGRESOSBRUTOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.COMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.COMISIONANTICIPO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.IVACOMISION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.COMISIONBRUTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.RETEFUENTE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.RETEICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.RETEIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.RETEUVT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.COMISIONNETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.PREMIOSPAGADOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOW_PREFACTURACION_.RETENCIONPREMIOS, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_SHOW_PREFACTURACION VW_SHOW_PREFACTURACION_ LEFT OUTER JOIN WSXML_SFG.VWC_ARCHIVOCONTROL t0 ON (VW_SHOW_PREFACTURACION_.ID_ENTRADAARCHIVOCONTROL =  t0.ID_ENTRADAARCHIVOCONTROL) LEFT OUTER JOIN WSXML_SFG.PRODUCTO t1 ON (VW_SHOW_PREFACTURACION_.CODPRODUCTO =  t1.ID_PRODUCTO) LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA t2 ON (VW_SHOW_PREFACTURACION_.CODPUNTODEVENTA =  t2.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO t3 ON (VW_SHOW_PREFACTURACION_.CODTIPOPRODUCTO =  t3.ID_TIPOPRODUCTO) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t4 ON (VW_SHOW_PREFACTURACION_.CODLINEADENEGOCIO =  t4.ID_LINEADENEGOCIO) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t5 ON (VW_SHOW_PREFACTURACION_.CODAGRUPACIONPUNTODEVENTA =  t5.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.ALIADOESTRATEGICO t6 ON (VW_SHOW_PREFACTURACION_.CODALIADOESTRATEGICO =  t6.ID_ALIADOESTRATEGICO)';

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

