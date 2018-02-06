USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_INFORMEFISCALVENTAS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS */ 

-- Returns a query resultset from table VW_INFORMEFISCALVENTAS
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_INFORMEFISCALVENTAS VW_INFORMEFISCALVENTAS_';
    SET @l_alias_str = 'VW_INFORMEFISCALVENTAS_';

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
        IF rtrim(ltrim(@l_where_str)) <> 'WHERE (1 = 2)' BEGIN
          EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
          @p_total_size output;
        END
        ELSE BEGIN
           SET @p_total_size=1;
        END 
    END 
--        WSXML_SFG.SFGTMPTRACE.TraceLog(l_from_str, 'SFGWebVW_INFORMEFISCALVENTAS l_from_str 71');
--        WSXML_SFG.SFGTMPTRACE.TraceLog(l_join_str, 'SFGWebVW_INFORMEFISCALVENTAS l_join_str 71');
--        WSXML_SFG.SFGTMPTRACE.TraceLog(l_where_str, 'SFGWebVW_INFORMEFISCALVENTAS l_where_str 71');


    -- Set up column name variable(s)
    SET @l_query_cols =
        'VW_INFORMEFISCALVENTAS_.ID_ENTRADAARCHIVOCONTROL,
            VW_INFORMEFISCALVENTAS_.CODCICLOFACTURACIONPDV,
            VW_INFORMEFISCALVENTAS_.TIPOARCHIVO,
            VW_INFORMEFISCALVENTAS_.FECHAARCHIVO,
            VW_INFORMEFISCALVENTAS_.CDC,
            VW_INFORMEFISCALVENTAS_.ID_RAZONSOCIAL,
            VW_INFORMEFISCALVENTAS_.IDENTIFICACION,
            VW_INFORMEFISCALVENTAS_.DIGITOVERIFICACION,
            VW_INFORMEFISCALVENTAS_.NOMRAZONSOCIAL,
            VW_INFORMEFISCALVENTAS_.ID_PUNTODEVENTA,
            VW_INFORMEFISCALVENTAS_.CODIGOGTECHPUNTODEVENTA,
            VW_INFORMEFISCALVENTAS_.NUMEROTERMINAL,
            VW_INFORMEFISCALVENTAS_.NOMPUNTODEVENTA,
            VW_INFORMEFISCALVENTAS_.ID_VENTADEPARTAMENTO,
            VW_INFORMEFISCALVENTAS_.NOMVENTADEPARTAMENTO,
            VW_INFORMEFISCALVENTAS_.NOMTIPOOPERACIONVENTA,
            VW_INFORMEFISCALVENTAS_.TXEFECTIVO,
            VW_INFORMEFISCALVENTAS_.TXCHEQUES,
            VW_INFORMEFISCALVENTAS_.TXTARJETA,
            VW_INFORMEFISCALVENTAS_.TXVALE,
            VW_INFORMEFISCALVENTAS_.TXCREDITO,
            VW_INFORMEFISCALVENTAS_.TXBONOS,
            VW_INFORMEFISCALVENTAS_.TXTOTAL,
            VW_INFORMEFISCALVENTAS_.VBRUTASEFECTIVO,
            VW_INFORMEFISCALVENTAS_.VBRUTASCHEQUES,
            VW_INFORMEFISCALVENTAS_.VBRUTASTARJETA,
            VW_INFORMEFISCALVENTAS_.VBRUTASVALE,
            VW_INFORMEFISCALVENTAS_.VBRUTASCREDITO,
            VW_INFORMEFISCALVENTAS_.VBRUTASBONOS,
            VW_INFORMEFISCALVENTAS_.VBRUTASTOTAL';

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

       IF rtrim(ltrim(@l_where_str)) <> 'WHERE (1 = 2)' BEGIN
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
            SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE ID_ENTRADAARCHIVOCONTROL = 100';
            EXECUTE sp_executesql @sql;
          END 

--        WSXML_SFG.SFGTMPTRACE.TraceLog(l_from_str, 'SFGWebVW_INFORMEFISCALVENTAS l_from_str 158');
--        WSXML_SFG.SFGTMPTRACE.TraceLog(l_join_str, 'SFGWebVW_INFORMEFISCALVENTAS l_join_str 158');
--        WSXML_SFG.SFGTMPTRACE.TraceLog(l_where_str, 'SFGWebVW_INFORMEFISCALVENTAS l_where_str 158');

    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        'SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE ID_ENTRADAARCHIVOCONTROL = 100';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_INFORMEFISCALVENTAS
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_INFORMEFISCALVENTAS VW_INFORMEFISCALVENTAS_';
    SET @l_alias_str = 'VW_INFORMEFISCALVENTAS_';

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

-- Returns a query result from table VW_INFORMEFISCALVENTAS
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_INFORMEFISCALVENTAS VW_INFORMEFISCALVENTAS_';
    SET @l_alias_str = 'VW_INFORMEFISCALVENTAS_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_INFORMEFISCALVENTAS_Export(
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
                '''XID_ENTRADAARCHIVOCONTROL' + isnull(@p_separator_str, '') +
                'CODCICLOFACTURACIONPDV' + isnull(@p_separator_str, '') +
                'TIPOARCHIVO' + isnull(@p_separator_str, '') +
                'TIPOARCHIVO NOMSERVICIO' + isnull(@p_separator_str, '') +
                'FECHAARCHIVO' + isnull(@p_separator_str, '') +
                'CDC' + isnull(@p_separator_str, '') +
                'ID_RAZONSOCIAL' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'NOMRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'ID_PUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMEROTERMINAL' + isnull(@p_separator_str, '') +
                'NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ID_VENTADEPARTAMENTO' + isnull(@p_separator_str, '') +
                'NOMVENTADEPARTAMENTO' + isnull(@p_separator_str, '') +
                'NOMTIPOOPERACIONVENTA' + isnull(@p_separator_str, '') +
                'TXEFECTIVO' + isnull(@p_separator_str, '') +
                'TXCHEQUES' + isnull(@p_separator_str, '') +
                'TXTARJETA' + isnull(@p_separator_str, '') +
                'TXVALE' + isnull(@p_separator_str, '') +
                'TXCREDITO' + isnull(@p_separator_str, '') +
                'TXBONOS' + isnull(@p_separator_str, '') +
                'TXTOTAL' + isnull(@p_separator_str, '') +
                'VBRUTASEFECTIVO' + isnull(@p_separator_str, '') +
                'VBRUTASCHEQUES' + isnull(@p_separator_str, '') +
                'VBRUTASTARJETA' + isnull(@p_separator_str, '') +
                'VBRUTASVALE' + isnull(@p_separator_str, '') +
                'VBRUTASCREDITO' + isnull(@p_separator_str, '') +
                'VBRUTASBONOS' + isnull(@p_separator_str, '') +
                'VBRUTASTOTAL' + ' ''';
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
                ' isnull(CAST(VW_INFORMEFISCALVENTAS_.ID_ENTRADAARCHIVOCONTROL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_INFORMEFISCALVENTAS_.CODCICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TIPOARCHIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMSERVICIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_INFORMEFISCALVENTAS_.FECHAARCHIVO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.CDC, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_INFORMEFISCALVENTAS_.ID_RAZONSOCIAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_INFORMEFISCALVENTAS_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_INFORMEFISCALVENTAS_.NOMRAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_INFORMEFISCALVENTAS_.ID_PUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_INFORMEFISCALVENTAS_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_INFORMEFISCALVENTAS_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_INFORMEFISCALVENTAS_.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_INFORMEFISCALVENTAS_.ID_VENTADEPARTAMENTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_INFORMEFISCALVENTAS_.NOMVENTADEPARTAMENTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_INFORMEFISCALVENTAS_.NOMTIPOOPERACIONVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXEFECTIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXCHEQUES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXTARJETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXVALE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXCREDITO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXBONOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.TXTOTAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASEFECTIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASCHEQUES, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASTARJETA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASVALE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASCREDITO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASBONOS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_INFORMEFISCALVENTAS_.VBRUTASTOTAL, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_INFORMEFISCALVENTAS VW_INFORMEFISCALVENTAS_ LEFT OUTER JOIN WSXML_SFG.SERVICIO t0 ON (VW_INFORMEFISCALVENTAS_.TIPOARCHIVO =  t0.ID_SERVICIO)';

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






