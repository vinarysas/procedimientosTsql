USE SFGPRODU;
--  DDL for Package Body SFGWEBVWP_VALIDARFACTURACIONPR
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR */ 

-- Returns a query resultset from table VWP_VALIDARFACTURACIONPRODUCTO
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VWP_VALIDARFACTURACIONPRODUCTO VWP_VALIDARFACTURACIONPRODUCTO_';
    SET @l_alias_str = 'VWP_VALIDARFACTURACIONPRODUCTO_';

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
        'VWP_VALIDARFACTURACIONPRODUCTO_.ID_CICLOFACTURACIONPDV,
            VWP_VALIDARFACTURACIONPRODUCTO_.CODLINEADENEGOCIO,
            VWP_VALIDARFACTURACIONPRODUCTO_.CODTIPOPRODUCTO,
            VWP_VALIDARFACTURACIONPRODUCTO_.CODPRODUCTO,
            VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADVENTAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADVENTAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADANULACIONFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADANULACIONPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORANULACIONFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORANULACIONPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.INGRESOSVALIDOSFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.INGRESOSVALIDOSPRE,
            VWP_VALIDARFACTURACIONPRODUCTO_.IMPUESTO_IVAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.IMPUESTO_IVAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTABRUTAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTABRUTAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VATCOMISIONFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VATCOMISIONPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONBRUTAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONBRUTAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RENTAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RENTAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEIVAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEIVAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEICAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEICAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONNETAFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONNETAPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORPREMIOPAGOFACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.VALORPREMIOPAGOPREF,
            VWP_VALIDARFACTURACIONPRODUCTO_.TOTALFACTURACION_FACT,
            VWP_VALIDARFACTURACIONPRODUCTO_.TOTALFACTURACION_PREF';

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

-- Returns a query result from table VWP_VALIDARFACTURACIONPRODUCTO
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VWP_VALIDARFACTURACIONPRODUCTO VWP_VALIDARFACTURACIONPRODUCTO_';
    SET @l_alias_str = 'VWP_VALIDARFACTURACIONPRODUCTO_';

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

-- Returns a query result from table VWP_VALIDARFACTURACIONPRODUCTO
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VWP_VALIDARFACTURACIONPRODUCTO VWP_VALIDARFACTURACIONPRODUCTO_';
    SET @l_alias_str = 'VWP_VALIDARFACTURACIONPRODUCTO_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVWP_VALIDARFACTURACIONPR_Export(
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
                'CODLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODLINEADENEGOCIO NOMLINEADENEGOCIO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODTIPOPRODUCTO NOMTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPRODUCTO' + isnull(@p_separator_str, '') +
                'CODPRODUCTO NOMPRODUCTO' + isnull(@p_separator_str, '') +
                'CANTIDADVENTAFACT' + isnull(@p_separator_str, '') +
                'CANTIDADVENTAPREF' + isnull(@p_separator_str, '') +
                'VALORVENTAFACT' + isnull(@p_separator_str, '') +
                'VALORVENTAPREF' + isnull(@p_separator_str, '') +
                'CANTIDADANULACIONFACT' + isnull(@p_separator_str, '') +
                'CANTIDADANULACIONPREF' + isnull(@p_separator_str, '') +
                'VALORANULACIONFACT' + isnull(@p_separator_str, '') +
                'VALORANULACIONPREF' + isnull(@p_separator_str, '') +
                'INGRESOSVALIDOSFACT' + isnull(@p_separator_str, '') +
                'INGRESOSVALIDOSPRE' + isnull(@p_separator_str, '') +
                'IMPUESTO_IVAFACT' + isnull(@p_separator_str, '') +
                'IMPUESTO_IVAPREF' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTAFACT' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTAPREF' + isnull(@p_separator_str, '') +
                'VALORCOMISIONFACT' + isnull(@p_separator_str, '') +
                'VALORCOMISIONPREF' + isnull(@p_separator_str, '') +
                'VATCOMISIONFACT' + isnull(@p_separator_str, '') +
                'VATCOMISIONPREF' + isnull(@p_separator_str, '') +
                'VALORCOMISIONBRUTAFACT' + isnull(@p_separator_str, '') +
                'VALORCOMISIONBRUTAPREF' + isnull(@p_separator_str, '') +
                'RETENCION_RENTAFACT' + isnull(@p_separator_str, '') +
                'RETENCION_RENTAPREF' + isnull(@p_separator_str, '') +
                'RETENCION_RETEIVAFACT' + isnull(@p_separator_str, '') +
                'RETENCION_RETEIVAPREF' + isnull(@p_separator_str, '') +
                'RETENCION_RETEICAFACT' + isnull(@p_separator_str, '') +
                'RETENCION_RETEICAPREF' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETAFACT' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETAPREF' + isnull(@p_separator_str, '') +
                'VALORPREMIOPAGOFACT' + isnull(@p_separator_str, '') +
                'VALORPREMIOPAGOPREF' + isnull(@p_separator_str, '') +
                'TOTALFACTURACION_FACT' + isnull(@p_separator_str, '') +
                'TOTALFACTURACION_PREF' + ' ''';
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
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.ID_CICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.SECUENCIA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CODLINEADENEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMLINEADENEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CODTIPOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMTIPOPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CODPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADVENTAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADVENTAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADANULACIONFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.CANTIDADANULACIONPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORANULACIONFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORANULACIONPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.INGRESOSVALIDOSFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.INGRESOSVALIDOSPRE AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.IMPUESTO_IVAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.IMPUESTO_IVAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTABRUTAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORVENTABRUTAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VATCOMISIONFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VATCOMISIONPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONBRUTAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONBRUTAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RENTAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RENTAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEIVAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEIVAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEICAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.RETENCION_RETEICAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONNETAFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORCOMISIONNETAPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORPREMIOPAGOFACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.VALORPREMIOPAGOPREF AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.TOTALFACTURACION_FACT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VWP_VALIDARFACTURACIONPRODUCTO_.TOTALFACTURACION_PREF AS VARCHAR(MAX)), '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VWP_VALIDARFACTURACIONPRODUCTO VWP_VALIDARFACTURACIONPRODUCTO_ LEFT OUTER JOIN WSXML_SFG.CICLOFACTURACIONPDV t0 ON (VWP_VALIDARFACTURACIONPRODUCTO_.ID_CICLOFACTURACIONPDV =  t0.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.LINEADENEGOCIO t1 ON (VWP_VALIDARFACTURACIONPRODUCTO_.CODLINEADENEGOCIO =  t1.ID_LINEADENEGOCIO) LEFT OUTER JOIN WSXML_SFG.TIPOPRODUCTO t2 ON (VWP_VALIDARFACTURACIONPRODUCTO_.CODTIPOPRODUCTO =  t2.ID_TIPOPRODUCTO) LEFT OUTER JOIN WSXML_SFG.PRODUCTO t3 ON (VWP_VALIDARFACTURACIONPRODUCTO_.CODPRODUCTO =  t3.ID_PRODUCTO)';

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






