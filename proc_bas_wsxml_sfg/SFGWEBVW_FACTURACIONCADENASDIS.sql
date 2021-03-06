USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_FACTURACIONCADENASDIS
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS */ 

-- Returns a query resultset from table VW_FACTURACIONCADENASDISC
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_FACTURACIONCADENASDISC VW_FACTURACIONCADENASDISC_';
    SET @l_alias_str = 'VW_FACTURACIONCADENASDISC_';

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
        'VW_FACTURACIONCADENASDISC_.ID_ENTRADAARCHIVOCONTROL,
            VW_FACTURACIONCADENASDISC_.CODCICLOFACTURACIONPDV,
            VW_FACTURACIONCADENASDISC_.TIPOARCHIVO,
            VW_FACTURACIONCADENASDISC_.FECHAARCHIVO,
            VW_FACTURACIONCADENASDISC_.ID_PUNTODEVENTA,
            VW_FACTURACIONCADENASDISC_.CODIGOGTECHPUNTODEVENTA,
            VW_FACTURACIONCADENASDISC_.NUMEROTERMINAL,
            VW_FACTURACIONCADENASDISC_.NOMPUNTODEVENTA,
            VW_FACTURACIONCADENASDISC_.ID_RAZONSOCIAL,
            VW_FACTURACIONCADENASDISC_.NOMRAZONSOCIAL,
            VW_FACTURACIONCADENASDISC_.IDENTIFICACION,
            VW_FACTURACIONCADENASDISC_.DIGITOVERIFICACION,
            VW_FACTURACIONCADENASDISC_.ID_AGRUPACIONPUNTODEVENTA,
            VW_FACTURACIONCADENASDISC_.CODIGOAGRUPACIONGTECH,
            VW_FACTURACIONCADENASDISC_.NOMAGRUPACIONPUNTODEVENTA,
            VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES01,
            VW_FACTURACIONCADENASDISC_.VALORTRANSACCION01,
            VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA01,
            VW_FACTURACIONCADENASDISC_.VALORCOMISION01,
            VW_FACTURACIONCADENASDISC_.VALORIVACOMISION01,
            VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE01,
            VW_FACTURACIONCADENASDISC_.VALORRETEICA01,
            VW_FACTURACIONCADENASDISC_.VALORRETEIVA01,
            VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA01,
            VW_FACTURACIONCADENASDISC_.VALORPREMIOPAGO01,
            VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES02,
            VW_FACTURACIONCADENASDISC_.VALORTRANSACCION02,
            VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA02,
            VW_FACTURACIONCADENASDISC_.VALORCOMISION02,
            VW_FACTURACIONCADENASDISC_.VALORIVACOMISION02,
            VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE02,
            VW_FACTURACIONCADENASDISC_.VALORRETEICA02,
            VW_FACTURACIONCADENASDISC_.VALORRETEIVA02,
            VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA02,
            VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES03,
            VW_FACTURACIONCADENASDISC_.VALORTRANSACCION03,
            VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA03,
            VW_FACTURACIONCADENASDISC_.VALORCOMISION03,
            VW_FACTURACIONCADENASDISC_.VALORIVACOMISION03,
            VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE03,
            VW_FACTURACIONCADENASDISC_.VALORRETEICA03,
            VW_FACTURACIONCADENASDISC_.VALORRETEIVA03,
            VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA03,
            VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES04,
            VW_FACTURACIONCADENASDISC_.VALORTRANSACCION04,
            VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA04,
            VW_FACTURACIONCADENASDISC_.VALORCOMISION04,
            VW_FACTURACIONCADENASDISC_.VALORIVACOMISION04,
            VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE04,
            VW_FACTURACIONCADENASDISC_.VALORRETEICA04,
            VW_FACTURACIONCADENASDISC_.VALORRETEIVA04,
            VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA04';

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

-- Returns a query result from table VW_FACTURACIONCADENASDISC
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_FACTURACIONCADENASDISC VW_FACTURACIONCADENASDISC_';
    SET @l_alias_str = 'VW_FACTURACIONCADENASDISC_';

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

-- Returns a query result from table VW_FACTURACIONCADENASDISC
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_FACTURACIONCADENASDISC VW_FACTURACIONCADENASDISC_';
    SET @l_alias_str = 'VW_FACTURACIONCADENASDISC_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_FACTURACIONCADENASDIS_Export(
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
                'ID_PUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMEROTERMINAL' + isnull(@p_separator_str, '') +
                'NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ID_RAZONSOCIAL' + isnull(@p_separator_str, '') +
                'NOMRAZONSOCIAL' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'ID_AGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOAGRUPACIONGTECH' + isnull(@p_separator_str, '') +
                'NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMTRANSACCIONES01' + isnull(@p_separator_str, '') +
                'VALORTRANSACCION01' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA01' + isnull(@p_separator_str, '') +
                'VALORCOMISION01' + isnull(@p_separator_str, '') +
                'VALORIVACOMISION01' + isnull(@p_separator_str, '') +
                'VALORRETEFUENTE01' + isnull(@p_separator_str, '') +
                'VALORRETEICA01' + isnull(@p_separator_str, '') +
                'VALORRETEIVA01' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA01' + isnull(@p_separator_str, '') +
                'VALORPREMIOPAGO01' + isnull(@p_separator_str, '') +
                'NUMTRANSACCIONES02' + isnull(@p_separator_str, '') +
                'VALORTRANSACCION02' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA02' + isnull(@p_separator_str, '') +
                'VALORCOMISION02' + isnull(@p_separator_str, '') +
                'VALORIVACOMISION02' + isnull(@p_separator_str, '') +
                'VALORRETEFUENTE02' + isnull(@p_separator_str, '') +
                'VALORRETEICA02' + isnull(@p_separator_str, '') +
                'VALORRETEIVA02' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA02' + isnull(@p_separator_str, '') +
                'NUMTRANSACCIONES03' + isnull(@p_separator_str, '') +
                'VALORTRANSACCION03' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA03' + isnull(@p_separator_str, '') +
                'VALORCOMISION03' + isnull(@p_separator_str, '') +
                'VALORIVACOMISION03' + isnull(@p_separator_str, '') +
                'VALORRETEFUENTE03' + isnull(@p_separator_str, '') +
                'VALORRETEICA03' + isnull(@p_separator_str, '') +
                'VALORRETEIVA03' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA03' + isnull(@p_separator_str, '') +
                'NUMTRANSACCIONES04' + isnull(@p_separator_str, '') +
                'VALORTRANSACCION04' + isnull(@p_separator_str, '') +
                'VALORVENTABRUTA04' + isnull(@p_separator_str, '') +
                'VALORCOMISION04' + isnull(@p_separator_str, '') +
                'VALORIVACOMISION04' + isnull(@p_separator_str, '') +
                'VALORRETEFUENTE04' + isnull(@p_separator_str, '') +
                'VALORRETEICA04' + isnull(@p_separator_str, '') +
                'VALORRETEIVA04' + isnull(@p_separator_str, '') +
                'VALORCOMISIONNETA04' + ' ''';
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
                ' isnull(CAST(VW_FACTURACIONCADENASDISC_.ID_ENTRADAARCHIVOCONTROL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_FACTURACIONCADENASDISC_.CODCICLOFACTURACIONPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.TIPOARCHIVO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMSERVICIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(dbo.ConvertFecha(VW_FACTURACIONCADENASDISC_.FECHAARCHIVO), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_FACTURACIONCADENASDISC_.ID_PUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_FACTURACIONCADENASDISC_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_FACTURACIONCADENASDISC_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_FACTURACIONCADENASDISC_.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_FACTURACIONCADENASDISC_.ID_RAZONSOCIAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_FACTURACIONCADENASDISC_.NOMRAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_FACTURACIONCADENASDISC_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_FACTURACIONCADENASDISC_.ID_AGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_FACTURACIONCADENASDISC_.CODIGOAGRUPACIONGTECH) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_FACTURACIONCADENASDISC_.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORTRANSACCION01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISION01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORIVACOMISION01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEICA01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEIVA01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORPREMIOPAGO01, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORTRANSACCION02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISION02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORIVACOMISION02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEICA02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEIVA02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA02, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORTRANSACCION03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISION03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORIVACOMISION03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEICA03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEIVA03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA03, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.NUMTRANSACCIONES04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORTRANSACCION04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORVENTABRUTA04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISION04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORIVACOMISION04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEFUENTE04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEICA04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORRETEIVA04, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_FACTURACIONCADENASDISC_.VALORCOMISIONNETA04, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_FACTURACIONCADENASDISC VW_FACTURACIONCADENASDISC_ LEFT OUTER JOIN WSXML_SFG.SERVICIO t0 ON (VW_FACTURACIONCADENASDISC_.TIPOARCHIVO =  t0.ID_SERVICIO)';

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






