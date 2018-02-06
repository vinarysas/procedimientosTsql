USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_PORTFOLIOPROFILE
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE */ 

-- Returns a query resultset from table VW_PORTFOLIOPROFILE
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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_GetList(
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
    SET @l_from_str = 'WSXML_SFG.VW_PORTFOLIOPROFILE VW_PORTFOLIOPROFILE_';
    SET @l_alias_str = 'VW_PORTFOLIOPROFILE_';

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
        'VW_PORTFOLIOPROFILE_.ID_PUNTODEVENTA,
            VW_PORTFOLIOPROFILE_.CODIGOGTECHPUNTODEVENTA,
            VW_PORTFOLIOPROFILE_.NOMPUNTODEVENTA,
            VW_PORTFOLIOPROFILE_.NUMEROTERMINAL,
            VW_PORTFOLIOPROFILE_.CODCIUDAD,
            VW_PORTFOLIOPROFILE_.CODDEPARTAMENTO,
            VW_PORTFOLIOPROFILE_.CODTIPONEGOCIO,
            VW_PORTFOLIOPROFILE_.CODRUTAPDV,
            VW_PORTFOLIOPROFILE_.CODREDPDV,
            VW_PORTFOLIOPROFILE_.CODREGIONAL,
            VW_PORTFOLIOPROFILE_.CODESTADOPDV,
            VW_PORTFOLIOPROFILE_.NUMEROCONTRATO,
            VW_PORTFOLIOPROFILE_.NOMBREORAZONSOCIAL,
            VW_PORTFOLIOPROFILE_.IDENTIFICACION,
            VW_PORTFOLIOPROFILE_.DIGITOVERIFICACION,
            VW_PORTFOLIOPROFILE_.CODREGIMEN,
            VW_PORTFOLIOPROFILE_.NOMBREREPRESENTANTELEGAL,
            VW_PORTFOLIOPROFILE_.CODAGRUPACIONPUNTODEVENTA,
            VW_PORTFOLIOPROFILE_.CODIGOAGRUPACIONGTECH,
            VW_PORTFOLIOPROFILE_.CODTIPOPUNTODEVENTA,
            VW_PORTFOLIOPROFILE_.NUMDIASPONDERADOSFAC,
            VW_PORTFOLIOPROFILE_.NUMDIASPLAZO,
            VW_PORTFOLIOPROFILE_.NUMDIASMORA,
            VW_PORTFOLIOPROFILE_.NOMCATEGORIACUPO,
            VW_PORTFOLIOPROFILE_.VALORCUPO,
            VW_PORTFOLIOPROFILE_.NOMCATEGORIAPAGO,
            VW_PORTFOLIOPROFILE_.DIASHABILESPAGOGTECH,
            VW_PORTFOLIOPROFILE_.VARIABLEPORCENTUAL,
            VW_PORTFOLIOPROFILE_.VARIABLETRANSACCIONAL,
            VW_PORTFOLIOPROFILE_.CALIFICACION';

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

-- Returns a query result from table VW_PORTFOLIOPROFILE
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_DrillDown(
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
    SET @l_from_str = 'WSXML_SFG.VW_PORTFOLIOPROFILE VW_PORTFOLIOPROFILE_';
    SET @l_alias_str = 'VW_PORTFOLIOPROFILE_';

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

-- Returns a query result from table VW_PORTFOLIOPROFILE
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_GetStats(
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

    SET @l_from_str = 'WSXML_SFG.VW_PORTFOLIOPROFILE VW_PORTFOLIOPROFILE_';
    SET @l_alias_str = 'VW_PORTFOLIOPROFILE_';

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
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_PORTFOLIOPROFILE_Export(
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
                '''XID_PUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMEROTERMINAL' + isnull(@p_separator_str, '') +
                'CODCIUDAD' + isnull(@p_separator_str, '') +
                'CODCIUDAD NOMCIUDAD' + isnull(@p_separator_str, '') +
                'CODDEPARTAMENTO' + isnull(@p_separator_str, '') +
                'CODDEPARTAMENTO NOMDEPARTAMENTO' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODTIPONEGOCIO NOMTIPONEGOCIO' + isnull(@p_separator_str, '') +
                'CODRUTAPDV' + isnull(@p_separator_str, '') +
                'CODRUTAPDV NOMRUTAPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV' + isnull(@p_separator_str, '') +
                'CODREDPDV NOMREDPDV' + isnull(@p_separator_str, '') +
                'CODREGIONAL' + isnull(@p_separator_str, '') +
                'CODREGIONAL NOMREGIONAL' + isnull(@p_separator_str, '') +
                'CODESTADOPDV' + isnull(@p_separator_str, '') +
                'CODESTADOPDV NOMESTADOPDV' + isnull(@p_separator_str, '') +
                'NUMEROCONTRATO' + isnull(@p_separator_str, '') +
                'NOMBREORAZONSOCIAL' + isnull(@p_separator_str, '') +
                'IDENTIFICACION' + isnull(@p_separator_str, '') +
                'DIGITOVERIFICACION' + isnull(@p_separator_str, '') +
                'CODREGIMEN' + isnull(@p_separator_str, '') +
                'CODREGIMEN NOMREGIMEN' + isnull(@p_separator_str, '') +
                'NOMBREREPRESENTANTELEGAL' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODAGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODIGOAGRUPACIONGTECH' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA NOMTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'NUMDIASPONDERADOSFAC' + isnull(@p_separator_str, '') +
                'NUMDIASPLAZO' + isnull(@p_separator_str, '') +
                'NUMDIASMORA' + isnull(@p_separator_str, '') +
                'NOMCATEGORIACUPO' + isnull(@p_separator_str, '') +
                'VALORCUPO' + isnull(@p_separator_str, '') +
                'NOMCATEGORIAPAGO' + isnull(@p_separator_str, '') +
                'DIASHABILESPAGOGTECH' + isnull(@p_separator_str, '') +
                'VARIABLEPORCENTUAL' + isnull(@p_separator_str, '') +
                'VARIABLETRANSACCIONAL' + isnull(@p_separator_str, '') +
                'CALIFICACION' + ' ''';
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
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.ID_PUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PORTFOLIOPROFILE_.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NUMEROTERMINAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODCIUDAD AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMCIUDAD, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODDEPARTAMENTO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMDEPARTAMENTO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODTIPONEGOCIO AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMTIPONEGOCIO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODRUTAPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t3.NOMRUTAPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODREDPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t4.NOMREDPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODREGIONAL AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t5.NOMREGIONAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODESTADOPDV AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t6.NOMESTADOPDV, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NUMEROCONTRATO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NOMBREORAZONSOCIAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.IDENTIFICACION AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.DIGITOVERIFICACION, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODREGIMEN AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t7.NOMREGIMEN, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NOMBREREPRESENTANTELEGAL, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODAGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t8.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_PORTFOLIOPROFILE_.CODIGOAGRUPACIONGTECH) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_PORTFOLIOPROFILE_.CODTIPOPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t9.NOMTIPOPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.NUMDIASPONDERADOSFAC, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.NUMDIASPLAZO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.NUMDIASMORA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NOMCATEGORIACUPO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.VALORCUPO, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_PORTFOLIOPROFILE_.NOMCATEGORIAPAGO, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.DIASHABILESPAGOGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.VARIABLEPORCENTUAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.VARIABLETRANSACCIONAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_PORTFOLIOPROFILE_.CALIFICACION, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_PORTFOLIOPROFILE VW_PORTFOLIOPROFILE_ LEFT OUTER JOIN WSXML_SFG.CIUDAD t0 ON (VW_PORTFOLIOPROFILE_.CODCIUDAD =  t0.ID_CIUDAD) LEFT OUTER JOIN WSXML_SFG.DEPARTAMENTO t1 ON (VW_PORTFOLIOPROFILE_.CODDEPARTAMENTO =  t1.ID_DEPARTAMENTO) LEFT OUTER JOIN WSXML_SFG.TIPONEGOCIO t2 ON (VW_PORTFOLIOPROFILE_.CODTIPONEGOCIO =  t2.ID_TIPONEGOCIO) LEFT OUTER JOIN WSXML_SFG.RUTAPDV t3 ON (VW_PORTFOLIOPROFILE_.CODRUTAPDV =  t3.ID_RUTAPDV) LEFT OUTER JOIN WSXML_SFG.REDPDV t4 ON (VW_PORTFOLIOPROFILE_.CODREDPDV =  t4.ID_REDPDV) LEFT OUTER JOIN WSXML_SFG.REGIONAL t5 ON (VW_PORTFOLIOPROFILE_.CODREGIONAL =  t5.ID_REGIONAL) LEFT OUTER JOIN WSXML_SFG.ESTADOPDV t6 ON (VW_PORTFOLIOPROFILE_.CODESTADOPDV =  t6.ID_ESTADOPDV) LEFT OUTER JOIN WSXML_SFG.REGIMEN t7 ON (VW_PORTFOLIOPROFILE_.CODREGIMEN =  t7.ID_REGIMEN) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t8 ON (VW_PORTFOLIOPROFILE_.CODAGRUPACIONPUNTODEVENTA =  t8.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.TIPOPUNTODEVENTA t9 ON (VW_PORTFOLIOPROFILE_.CODTIPOPUNTODEVENTA =  t9.ID_TIPOPUNTODEVENTA)';

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






