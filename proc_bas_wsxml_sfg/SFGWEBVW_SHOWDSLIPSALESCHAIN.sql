USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_SHOWDSLIPSALESCHAIN
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN */ 

-- Returns a query resultset from table VW_SHOWDSLIPSALESCHAIN
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPSALESCHAIN VW_SHOWDSLIPSALESCHAIN_';
    SET @l_alias_str = 'VW_SHOWDSLIPSALESCHAIN_';

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
        'VW_SHOWDSLIPSALESCHAIN_.CODCICLOFACTURACIONPDV,
            VW_SHOWDSLIPSALESCHAIN_.CODAGRUPACIONPUNTODEVENTA,
            VW_SHOWDSLIPSALESCHAIN_.ID_SERVICIO,
            VW_SHOWDSLIPSALESCHAIN_.ID_TIPOPRODUCTO,
            VW_SHOWDSLIPSALESCHAIN_.ID_AGRUPACIONPRODUCTO,
            VW_SHOWDSLIPSALESCHAIN_.NOMSERVICIO,
            VW_SHOWDSLIPSALESCHAIN_.NOMTIPOPRODUCTO,
            VW_SHOWDSLIPSALESCHAIN_.NOMAGRUPACIONPRODUCTO,
            VW_SHOWDSLIPSALESCHAIN_.QUANTITY,
            VW_SHOWDSLIPSALESCHAIN_.AMOUNT,
            VW_SHOWDSLIPSALESCHAIN_.ANNULLEDQUANTITY,
            VW_SHOWDSLIPSALESCHAIN_.ANNULLEDAMOUNT,
            VW_SHOWDSLIPSALESCHAIN_.TAXIVA,
            VW_SHOWDSLIPSALESCHAIN_.GROSSSALES,
            VW_SHOWDSLIPSALESCHAIN_.AWARDPAIDQUANTITY,
            VW_SHOWDSLIPSALESCHAIN_.AWARDPAIDAMOUNT,
            VW_SHOWDSLIPSALESCHAIN_.AWARDPAIDTAXDISCOUNTING,
            VW_SHOWDSLIPSALESCHAIN_.COMMISSION,
            VW_SHOWDSLIPSALESCHAIN_.VATCMS,
            VW_SHOWDSLIPSALESCHAIN_.RETRNT,
            VW_SHOWDSLIPSALESCHAIN_.RETICA,
            VW_SHOWDSLIPSALESCHAIN_.RETIVA,
            VW_SHOWDSLIPSALESCHAIN_.RETCREE,
            VW_SHOWDSLIPSALESCHAIN_.FINALCOMMISSION,
            VW_SHOWDSLIPSALESCHAIN_.FINALQUANTITY,
            VW_SHOWDSLIPSALESCHAIN_.FINALAMOUNT,
            VW_SHOWDSLIPSALESCHAIN_.RETRNT_PRD,
            VW_SHOWDSLIPSALESCHAIN_.RETICA_PRD,
            VW_SHOWDSLIPSALESCHAIN_.RETIVA_PRD,
            VW_SHOWDSLIPSALESCHAIN_.RETCREE_PRD,
            VW_SHOWDSLIPSALESCHAIN_.DISCOUNTS';


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

-- Returns a query result from table VW_SHOWDSLIPSALESCHAIN
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPSALESCHAIN VW_SHOWDSLIPSALESCHAIN_';
    SET @l_alias_str = 'VW_SHOWDSLIPSALESCHAIN_';

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

-- Returns a query result from table VW_SHOWDSLIPSALESCHAIN
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPSALESCHAIN VW_SHOWDSLIPSALESCHAIN_';
    SET @l_alias_str = 'VW_SHOWDSLIPSALESCHAIN_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_SHOWDSLIPSALESCHAIN_Export(
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
                'CODCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODCICLOFACTURACIONPDV NOMCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ID_SERVICIO' + isnull(@p_separator_str, '') +
                'ID_TIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'ID_AGRUPACIONPRODUCTO' + isnull(@p_separator_str, '') +
                'NOMSERVICIO' + isnull(@p_separator_str, '') +
                'NOMTIPOPRODUCTO' + isnull(@p_separator_str, '') +
                'NOMAGRUPACIONPRODUCTO' + isnull(@p_separator_str, '') +
                'QUANTITY' + isnull(@p_separator_str, '') +
                'AMOUNT' + isnull(@p_separator_str, '') +
                'ANNULLEDQUANTITY' + isnull(@p_separator_str, '') +
                'ANNULLEDAMOUNT' + isnull(@p_separator_str, '') +
                'TAXIVA' + isnull(@p_separator_str, '') +
                'GROSSSALES' + isnull(@p_separator_str, '') +
                'AWARDPAIDQUANTITY' + isnull(@p_separator_str, '') +
                'AWARDPAIDAMOUNT' + isnull(@p_separator_str, '') +
                'AWARDPAIDTAXDISCOUNTING' + isnull(@p_separator_str, '') +
                'COMMISSION' + isnull(@p_separator_str, '') +
                'VATCMS' + isnull(@p_separator_str, '') +
                'RETRNT' + isnull(@p_separator_str, '') +
                'RETICA' + isnull(@p_separator_str, '') +
                'RETIVA' + isnull(@p_separator_str, '') +
                'RETCREE' + isnull(@p_separator_str, '') +
                'FINALCOMMISSION' + isnull(@p_separator_str, '') +
                'FINALQUANTITY' + isnull(@p_separator_str, '') +
                'FINALAMOUNT' + isnull(@p_separator_str, '') +
                'RETRNT_PRD' + isnull(@p_separator_str, '') +
                'RETICA_PRD' + isnull(@p_separator_str, '') +
                'RETIVA_PRD' + isnull(@p_separator_str, '') +
                'RETCREE_PRD' + ' ';
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
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.CODCICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCICLOFACTURACIONPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.ID_SERVICIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.ID_TIPOPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.ID_AGRUPACIONPRODUCTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOWDSLIPSALESCHAIN_.NOMSERVICIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOWDSLIPSALESCHAIN_.NOMTIPOPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_SHOWDSLIPSALESCHAIN_.NOMAGRUPACIONPRODUCTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.QUANTITY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.AMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.ANNULLEDQUANTITY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.ANNULLEDAMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.TAXIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.GROSSSALES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.AWARDPAIDQUANTITY AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.AWARDPAIDAMOUNT AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_SHOWDSLIPSALESCHAIN_.AWARDPAIDTAXDISCOUNTING AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.COMMISSION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.VATCMS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETRNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETCREE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.FINALCOMMISSION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.FINALQUANTITY, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.FINALAMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETRNT_PRD, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETICA_PRD, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETIVA_PRD, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_SHOWDSLIPSALESCHAIN_.RETCREE_PRD, '''') + '' ''';

    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_SHOWDSLIPSALESCHAIN VW_SHOWDSLIPSALESCHAIN_ LEFT OUTER JOIN WSXML_SFG.VWC_CICLOFACTURACION t0 ON (VW_SHOWDSLIPSALESCHAIN_.CODCICLOFACTURACIONPDV =  t0.ID_CICLOFACTURACIONPDV) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t1 ON (VW_SHOWDSLIPSALESCHAIN_.CODAGRUPACIONPUNTODEVENTA =  t1.ID_AGRUPACIONPUNTODEVENTA)';

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






